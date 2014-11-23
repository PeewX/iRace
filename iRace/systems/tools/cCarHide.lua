--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 29.07.2014 - Time: 20:39
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local state = "none" --States: >none< >classic< >extended< >full<
local vD, hideDim = 20, 2000 --visibleDistance, hideDimension
local players = {}

bindKey("F1", "down", function()
    if state == "none" then	state = "classic" initialiseInfobox("Vehicle hide", "Vehicle hide mode: Classic", 152, 137, 219, 1, 5)	elseif state == "classic" then state = "extended" initialiseInfobox("Vehicle hide", "Vehicle hide mode: Extended", 152, 137, 219, 1, 5) elseif state == "extended" then state = "full" initialiseInfobox("Vehicle hide", "Vehicle hide mode: Full", 152, 137, 219, 1, 5) elseif state == "full" then state = "none" initialiseInfobox("Vehicle hide", "Vehicle hide mode: None", 152, 137, 219, 1, 5) end
end)

addEventHandler("onClientPreRender", getRootElement(), function()
    if not isMapType("DM") then return end
    players = {}
    for _, player in ipairs(getElementsByType"player") do
        if player ~= me then
            if getElementData(player, "state") == "alive" then
                if not isPlayerRespawnMode(player) then
                    table.insert(players, player)
                end
            end
        end
    end

    if state == "classic" then
        for _, pl in ipairs(players) do
            if isElementStreamedIn(pl) then
                local pV = getPedOccupiedVehicle(pl)
                if getElementModel(pV) ~= 425 and pl ~= getSpectatedPlayer() then
                    setElementAlpha(pl, 100)
                    setElementAlpha(pV, 100)
                else
                    setElementAlpha(pl, 255)
                    setElementAlpha(pV, 255)
                end
            end
        end
    elseif state == "extended" then
        local x = me
        if getSpectatedPlayer() then x = getSpectatedPlayer() end
        local lpX, lpY, lpZ = getElementPosition(x)
        for _, pl in ipairs(players) do
            if isElementStreamedIn(pl) then
                local pV = getPedOccupiedVehicle(pl)
                if getElementModel(pV) ~= 425 and pl ~= getSpectatedPlayer() then
                    local pX, pY, pZ = getElementPosition(pl)
                    local d = getDistanceBetweenPoints3D(lpX, lpY, lpZ, pX, pY, pZ)
                    if  d < vD then
                        showPlayer(pl, pV)
                        setElementAlpha(pl, 255/vD*d)
                        setElementAlpha(pV, 255/vD*d)
                    elseif d > vD then
                        showPlayer(pl, pV)
                        setElementAlpha(pl, 255)
                        setElementAlpha(pV, 255)
                    end
                else
                    showPlayer(pl, pV)
                    setElementAlpha(pl, 255)
                    setElementAlpha(pV, 255)
                end
            end
        end
    elseif state == "full" then
        for _, pl in ipairs(players) do
            --if isElementStreamedIn(pl) then
            local pV = getPedOccupiedVehicle(pl)
            if getElementModel(pV) ~= 425 and pl ~= getSpectatedPlayer() then
                hidePlayer(pl, pV)
            else
                showPlayer(pl, pV)
            end
            --end
        end
    elseif state == "none" then
        for _, pl in ipairs(players) do
            local pV = getPedOccupiedVehicle(pl)
            showPlayer(pl, pV)
        end
    end
end)

function hidePlayer(pl, pV)
    local dim = getElementDimension(pl)
    if dim ~= hideDim then
        setElementDimension(pl, hideDim)
        setElementDimension(pV, hideDim)
    end
end

function showPlayer(pl, pV)
    local dim = getElementDimension(pl)
    if dim == hideDim then
        setElementDimension(pl, 0)
        setElementDimension(pV, 0)
    end
end

function getSpectatedPlayer()
    local target = getCameraTarget()
    if target then
        if getElementType(target) == "vehicle" then
            local player = getVehicleController(target, 0)
            if player ~= me then
                return player
            end
        end
    end
    return false
end