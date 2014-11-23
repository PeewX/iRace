--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 02.08.2014 - Time: 14:22
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local rsp = {players = {}, vehicles = {} }
grsp = {}

function rsp.loadMaps()
    local sT = getTickCount()
    rsp.maps = {}
    local mapsToLoad = {}

    rsp.xml = xmlLoadFile("systems/respawn/maps/_maps.xml")
    local maps = xmlNodeGetChildren(rsp.xml)
    for _, map in ipairs(maps) do
        table.insert(mapsToLoad, xmlNodeGetAttributes(map))
    end

    for _, map in ipairs(mapsToLoad) do
        local mapFile = xmlLoadFile("systems/respawn/maps/" .. map.filename)
        if mapFile then
            local cache = {info = map, objects = {}, spawnpoints = {}, racepickups = {}, markers = {}, peds = {}, vehicles = {}}
            local mapFileCn = xmlNodeGetChildren(mapFile)
            for _, mapFileC in ipairs(mapFileCn) do
                local type = xmlNodeGetName(mapFileC)
                if type == "object" then
                    table.insert(cache.objects, xmlNodeGetAttributes(mapFileC))
                elseif type == "spawnpoint" then
                    table.insert(cache.spawnpoints, xmlNodeGetAttributes(mapFileC))
                elseif type == "racepickup" then
                    table.insert(cache.racepickups, xmlNodeGetAttributes(mapFileC))
                elseif type == "marker" then
                    table.insert(cache.markers, xmlNodeGetAttributes(mapFileC))
                elseif type == "ped" then
                    table.insert(cache.peds, xmlNodeGetAttributes(mapFileC))
                elseif type == "vehicle" then
                    table.insert(cache.vehicles, xmlNodeGetAttributes(mapFileC))
                else
                    outputChatBox("Invalid child name (" .. type .. ") for map file " .. map.filename)
                end
            end
            table.insert(rsp.maps, cache)
            xmlUnloadFile(mapFile)
        else
            outputChatBox("Error while loading map file: " .. map.filename)
        end
    end

    outputServerLog("Loaded " .. #rsp.maps .. " maps for respawn system in " .. math.round(getTickCount() - sT, 1) .. "ms")
    outputDebugString("Loaded " .. #rsp.maps .. " maps for respawn system in " .. math.round(getTickCount() - sT, 1) .. "ms")
    return true
end
addEventHandler("onResourceStart", resroot, rsp.loadMaps)

function grsp.reloadRespawnMaps()
    return rsp.loadMaps()
end

function rsp.mapIncreasePlayedCount(key)
    rsp.maps[key].info.joinedCount = tonumber(rsp.maps[key].info.joinedCount) + 1
    local mapFile = rsp.maps[key].info.filename

    local maps = xmlNodeGetChildren(rsp.xml)
    for _, map in ipairs(maps) do
        local filename = xmlNodeGetAttribute(map, "filename")
        if filename == mapFile then
            xmlNodeSetAttribute(map, "joinedCount", rsp.maps[key].info.joinedCount)
        end
    end
    xmlSaveFile(rsp.xml)
end

function rsp.getRaceMapSpawnpoints()
    rsp.spawnpoints = {}
    rsp.spawnpoints = exports['race']:getSpawnpoints()
end

function rsp.setRandomRespawnMaps()
    rsp.cSetMaps = {}
    for _ = 1, 3 do
        if #rsp.maps then
            local rndMap = math.random(1, #rsp.maps)
            table.insert(rsp.cSetMaps, {key = rndMap, info = rsp.maps[rndMap].info})
        end
    end
    triggerClientEvent("onServerSetRandomRespawnMaps", resroot, rsp.cSetMaps)
end

function rsp.onServerGotMapType()
    if isMapType("DM") then
        rsp.getRaceMapSpawnpoints()
        rsp.setRandomRespawnMaps()
    end
end
addEventHandler("onServerGotMapType", resroot, rsp.onServerGotMapType)

function rsp.onClientJoinArea(key)
    if key == nil then return end

    if key == 0 then
        outputDebugString(removeColorCodes(getPlayerName(client)) .. " drive again")
        local rndSpawn = math.random(1, #rsp.spawnpoints)
        local x, y, z = unpack(rsp.spawnpoints[rndSpawn].position)
        spawnPlayer(client, x, y, z)
        local veh = createVehicle(481, x, y, z, 0, 0, rsp.spawnpoints[rndSpawn].rotation)
        setElementCollisionsEnabled(veh, false)
        setElementModel(veh, rsp.spawnpoints[rndSpawn].vehicle)
        warpPedIntoVehicle(client, veh)
        setCameraTarget(client, cleint)
        rsp.addPlayer(client, veh)

        triggerClientEvent(client, 'onClientCall_race', client, "Spectate.stop", 'manual')
        triggerEvent('onClientRequestSpectate', client, false)
        triggerClientEvent("setPlayerVisibility", resroot, client, false)
        triggerClientEvent(client, "onServerEnablePositionSaving", client, true)
        return
    end
    outputDebugString(removeColorCodes(getPlayerName(client)) .. " join map: " .. rsp.maps[key].info.name)
    triggerLatentClientEvent(client, "onServerSendRespawnMap", 10000000, false, client, rsp.maps[key])
    triggerClientEvent(client, "onServerEnablePositionSaving", client, false)

    rsp.mapIncreasePlayedCount(key)

    --SetPlayerToRandomSpawnpoint
    local sp = rsp.maps[key].spawnpoints[math.random(1, #rsp.maps[key].spawnpoints)]

    spawnPlayer(client, sp.posX, sp.posY, sp.posZ)
    local veh = createVehicle(481, sp.posX, sp.posY, sp.posZ, sp.rotX, sp.rotY, sp.rotZ, "  PewX  ")
    setElementCollisionsEnabled(veh, true)
    setElementFrozen(veh, true)
    setElementModel(veh, sp.vehicle)
    setElementDimension(veh, 1338)
    warpPedIntoVehicle(client, veh)
    setElementDimension(client, 1338)
    setCameraTarget(client, client)
    rsp.addPlayer(client, veh)

    triggerClientEvent("setPlayerVisibility", resroot, client, false)
    triggerEvent('onClientRequestSpectate', client, false)
    triggerClientEvent(client, 'onClientCall_race', client, "Spectate.stop", 'manual')
    triggerClientEvent(client, "onServerToggleMapInfo", client, rsp.maps[key].info)

    setTimer(function(client, veh, key) triggerClientEvent(client, "toggleMapSettings", client, rsp.maps[key].info) triggerClientEvent("setPlayerVisibility", resroot, client, true) setElementFrozen(veh, false) end, 5000, 1, client, veh, key)
end
addEvent("onClientJoinArea", true)
addEventHandler("onClientJoinArea", resroot, rsp.onClientJoinArea)

function rsp.onPickupHit(p)
    --local veh = getPedOccupiedVehicle(client)
    local veh = rsp.vehicles[client]
    if not veh then return end
    if p.type == "repair" then
        fixVehicle(veh)
    elseif p.type == "nitro" then
        addVehicleUpgrade(veh, 1010)
    elseif p.type == "vehiclechange" then
        if getElementModel(veh) ~= p.veh then
            setElementModel(veh, p.veh)
            triggerClientEvent(client, "onVehicleChange", client)
        end
    end
end
addEvent("onPlayerRespawnPickupHit", true)
addEventHandler("onPlayerRespawnPickupHit", resroot, rsp.onPickupHit)

function rsp.onPlayerWasted()
    if isPlayerRespawnMode(source) then
        if rsp.removePlayer(source) then
            if isElement(rsp.vehicles[source]) then
                destroyElement(rsp.vehicles[source])
            end

            triggerClientEvent(source, "destroyRespawnMap", source)
            triggerClientEvent(source, "onServerEnablePositionSaving", source, false)
            triggerClientEvent(source, "toggleMapSettings", source, "unbind")

            if getElementDimension(source) ~= 0 then
                spawnPlayer(source, 0, 0, 0)
                setElementDimension(source, 0)
                setCameraTarget(source, getRaceAlivePlayers()[math.random(1, #getRaceAlivePlayers())])
            end
        end
    end
end
addEventHandler("onPlayerWasted", root, rsp.onPlayerWasted)

function isPlayerRespawnMode(player)
    for _, p in ipairs(rsp.players) do
        if p == player then return true end
    end
    return false
end

function resetRespawnPlayers()
    rsp.players = {}
end

function rsp.addPlayer(player, veh)
    for _, p in ipairs(rsp.players) do
        if p == player then
            return false
        end
    end
    table.insert(rsp.players, player)
    rsp.vehicles[player] = veh
    triggerClientEvent("onClientUpdatePlayers", resroot, rsp.players)
    return true
end

function rsp.removePlayer(player)
    for i, p in ipairs(rsp.players) do
        if p == player then
            table.remove(rsp.players, i)
            triggerClientEvent("onClientUpdatePlayers", resroot, rsp.players)
            return true
        end
    end
   return false
end

function rsp.raceStateChanged(rs)
    if rs ~= "Running" then
        for _, player in ipairs(getElementsByType("player")) do
            rsp.removePlayer(player)
            triggerClientEvent(player, "toggleMapSettings", player, "unbind")
            triggerClientEvent(player, "showRespawnModes", player, false)
        end
    elseif rs == "LoadingMap" then
        for _, vehicle in ipairs(getElementsByType("vehicle")) do
            if not getVehicleOccupant(vehicle) then
                destroyElement(vehicle)
            end
        end
    end
end
addEvent("onRaceStateChanging")
addEventHandler("onRaceStateChanging", root, rsp.raceStateChanged)