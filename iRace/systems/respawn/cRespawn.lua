--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 02.08.2014 - Time: 14:22
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local rsp = {pickupModel = {nitro = 2221, repair = 2222, vehiclechange = 2223}, players = {}, startTick = getTickCount(), pos = {}}
function rsp.recieveMapFromServer(map)
    rsp.destroyOldMap()
    rsp.map = {}
    rsp.map.objects = {}
    for _, object in ipairs(map.objects) do
        local o = createObject(object.model, object.posX, object.posY, object.posZ, object.rotX, object.rotY, object.rotZ)
        if o then setElementDoubleSided(o, toboolean(object.doublesided)) setElementCollisionsEnabled(o, toboolean(object.collisions or true)) setObjectScale(o, tonumber(object.scale) or 1) setElementDimension(o, 1338) setElementStreamable(o, true) table.insert(rsp.map.objects, o) end
    end

    rsp.map.pickups = {objects = {}, colshapes = {}}
    for _, pickup in ipairs(map.racepickups) do
        local p = createObject(rsp.pickupModel[pickup.type], pickup.posX, pickup.posY, pickup.posZ, pickup.rotX, pickup.rotY, pickup.rotZ)
        if p then
            setElementDimension(p, 1338) setElementStreamable(p, true) setElementCollisionsEnabled(p, false)
            local cs = createColSphere(pickup.posX, pickup.posY, pickup.posZ, 3.5)
            rsp.map.pickups.colshapes[cs] = {type = pickup.type, veh = pickup.vehicle }
            table.insert(rsp.map.pickups.objects, p)
        end
    end

    rsp.map.marker = {}
    for _, marker in ipairs(map.markers) do
        local r, g, b, a = getColorFromString(marker.color)
        local m = createMarker(marker.posX, marker.posY, marker.posZ, marker.type, marker.size, r, g, b, a)
        if m then
            setElementDimension(m, 1338)
            setElementRotation(m, marker.rotX, marker.rotY, marker.rotZ)
            table.insert(rsp.map.marker, m)
        end
    end

    rsp.map.load = true
    addEventHandler("onClientRender", root, rsp.updatePickups)
end
addEvent("onServerSendRespawnMap", true)
addEventHandler("onServerSendRespawnMap", me, rsp.recieveMapFromServer)

function rsp.onServerSetRespawnMaps(cSetMaps)
    rsp.cSetMaps = cSetMaps
    triggerEvent("onClientSetRespawnModes", resroot, cSetMaps)
end
addEvent("onServerSetRandomRespawnMaps", true)
addEventHandler("onServerSetRandomRespawnMaps", resroot, rsp.onServerSetRespawnMaps)

function rsp.updatePickups()
    local rot = math.fmod((getTickCount()-rsp.startTick)*360/2000, 360)
    for _, p in ipairs(rsp.map.pickups.objects) do
        setElementRotation(p, 0, 0, rot)
    end
end

function rsp.colShapeHit(elem)
    if elem ~= getPedOccupiedVehicle(me) then return end
    local p = rsp.map.pickups.colshapes[source]
    if p then
        triggerServerEvent("onPlayerRespawnPickupHit", resroot, p)
        rsp.prevVehicleHeight = getElementDistanceFromCentreOfMassToBaseOfModel(elem)
        playSoundFrontEnd(46)
    end
end
addEventHandler("onClientColShapeHit", resroot, rsp.colShapeHit)

function rsp.vehicleChaning()
    local veh = getPedOccupiedVehicle(me)
    local newVehicleHeight = getElementDistanceFromCentreOfMassToBaseOfModel(veh)
    local x, y, z = getElementPosition(veh)

    if rsp.prevVehicleHeight and newVehicleHeight > rsp.prevVehicleHeight then
        z = z - rsp.prevVehicleHeight + newVehicleHeight
    end
    setElementPosition(veh, x, y, z + 1)
end
addEvent("onVehicleChange", true)
addEventHandler("onVehicleChange", me, rsp.vehicleChaning)

function rsp.destroyOldMap()
    removeEventHandler("onClientRender", root, rsp.updatePickups)
    if not rsp.map or not rsp.map.load then return end

    if rsp.map.objects then
        for _, object in ipairs(rsp.map.objects) do
            destroyElement(object)
        end
        outputDebugString("Destroyed " .. #rsp.map.objects .. " objects")
    end

    if rsp.map.pickups.objects then
        for _, pickup in ipairs(rsp.map.pickups.objects) do
            destroyElement(pickup)
        end

        outputDebugString("Destroyed " .. #rsp.map.pickups.objects .. " pickups")
    end

    if rsp.map.markers then
        for _, marker in ipairs(rsp.map.markers) do
            destroyElement(marker)
        end

        outputDebugString("Destroyed " .. #rsp.map.markers .. " markers")
    end

    outputDebugString("Successfully unloaded map")
    rsp.map.load = false
end
addEvent("destroyRespawnMap", true)
addEventHandler("destroyRespawnMap", me, rsp.destroyOldMap)

function isPlayerRespawnMode(player)
    for _, p in ipairs(rsp.players) do
        if p == player then return true end
    end
    return false
end

function rsp.updatePlayers(nT)
    rsp.players = nT
end
addEvent("onClientUpdatePlayers", true)
addEventHandler("onClientUpdatePlayers", resroot, rsp.updatePlayers)

function rsp.setPlayerVisibility(player, state)
    if player ~= me then
        if state then
            setElementDimension(getPedOccupiedVehicle(player), 1338)
            setElementDimension(player, 1338)
        else
            setElementDimension(getPedOccupiedVehicle(player), 1337)
            setElementDimension(player, 1337)
        end
    end
end
addEvent("setPlayerVisibility", true)
addEventHandler("setPlayerVisibility", resroot, rsp.setPlayerVisibility)

---
--MapTypeSettings
---

function rsp.toggleMapSettings(settings)
    if settings == "unbind" then unbindKey("lshift", "down", rsp.jump) unbindKey("lctrl", "down", rsp.shoot) unbindKey("lalt", "down", rsp.boost) return end

    if toboolean(settings.jump) then
        bindKey("lshift", "down", rsp.jump)
    end

    if toboolean(settings.rockets) then
        bindKey("lctrl", "down", rsp.shoot)
    end

    if toboolean(settings.boost) then
        bindKey("lalt", "down", rsp.boost)
    end
end
addEvent("toggleMapSettings", true)
addEventHandler("toggleMapSettings", me, rsp.toggleMapSettings)

rsp.shootEnabled = true
function rsp.shoot()
    if isPedDead(me) then return end
    if isPlayerRespawnMode(me) then
        if rsp.shootEnabled then
            rsp.shootEnabled = false
            local veh = getPedOccupiedVehicle(me)
            local x, y, z = getElementPosition(veh)
            local _, _, zr = getElementRotation(veh)
            local x = x+4*math.cos(math.rad(zr+90))
            local y = y+4*math.sin(math.rad(zr+90))
            createProjectile(veh, 19, x, y, z, 1.0, nil)
            setTimer(function() rsp.shootEnabled = true end, 3000, 1)
        end
    end
end

rsp.jumpEnabled = true
function rsp.jump()
    if isPedDead(me) then return end
    if isPlayerRespawnMode(me) then
        if rsp.jumpEnabled then
            rsp.jumpEnabled = false
            local veh = getPedOccupiedVehicle(me)
            if not isVehicleOnGround(veh) then return end
            local x, y, z = getElementVelocity(veh)
            setElementVelocity(veh, x, y, z+0.35)
            setTimer(function() rsp.jumpEnabled = true end, 3000, 1)
        end
    end
end

rsp.boostEnabled = true
function rsp.boost()
    if isPedDead(me) then return end
    if isPlayerRespawnMode(me) then
        if rsp.boostEnabled then
            rsp.boostEnabled = false
            local veh = getPedOccupiedVehicle(me)
            local x, y, z = getElementVelocity(veh)
            setElementVelocity(veh, x*2, y*2, z*2)
            setTimer(function() rsp.boostEnabled = true end, 3000, 1)
        end
    end
end

---
--Position saving
---

function rsp.savePos()
    if isPlayerRespawnMode(me) then
        local veh = getPedOccupiedVehicle(me)
        rsp.pos = {}
        rsp.pos.model = getElementModel(veh)
        rsp.pos.vPos = {getElementPosition(veh)}
        rsp.pos.vRot = {getElementRotation(veh)}
        rsp.pos.vVel = {getElementVelocity(veh) }
        rsp.pos.vTVel = {getVehicleTurnVelocity(veh)}
        rsp.pos.nitro = getVehicleUpgradeOnSlot(veh, 8)
        if rsp.pos.nitro then
            rsp.pos.nitroActivated = isVehicleNitroActivated(veh)
            --rsp.pos.nitroLevel = getVehicleNitroLevel(veh)
        end
        triggerEvent("addClientMessage", me, "* #ffffffWarp saved.", 0, 255, 0)
    end
end

function rsp.loadPos()
    if isPlayerRespawnMode(me) then
        if not rsp.pos.vPos then return end
        local veh = getPedOccupiedVehicle(me)
        setElementModel(veh, rsp.pos.model)
        fixVehicle(veh)
        setElementPosition(veh, unpack(rsp.pos.vPos))
        setElementRotation(veh, unpack(rsp.pos.vRot))
        setElementVelocity(veh, unpack(rsp.pos.vVel))
        setVehicleTurnVelocity(veh, unpack(rsp.pos.vTVel))
        if rsp.pos.nitro then
            addVehicleUpgrade(veh, 1010)
            setVehicleNitroActivated(veh, rsp.pos.nitroActivated)
           -- setVehicleNitroLevel(veh, rsp.pos.nitroLevel)
        end
        triggerEvent("addClientMessage", me, "* #ffffffWarp loaded.", 0, 255, 0)
    end
end

function rsp.enablePosSaving(state)
    if state then
        if rsp.pos.enabled then return end
        rsp.pos.enabled = true
        addCommandHandler("sw", rsp.savePos)
        addCommandHandler("lw", rsp.loadPos)
        bindKey("j", "down", rsp.savePos)
        bindKey("k", "down", rsp.loadPos)
    else
        if not rsp.pos.enabled then return end
        rsp.pos.enabled = false
        removeCommandHandler("sw", rsp.savePos)
        removeCommandHandler("lw", rsp.loadPos)
        unbindKey("j", "down", rsp.savePos)
        unbindKey("k", "down", rsp.loadPos)
    end
end

addEvent("onServerEnablePositionSaving", true)
addEventHandler("onServerEnablePositionSaving", me, rsp.enablePosSaving)