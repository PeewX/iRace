--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 08.11.2014 - Time: 22:03
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--

afk = {tick = 0}

function afk.checkAFKState()
    if not getElementData(me, "isLogedIn") then afk.state = "none" afk.timer = 0 return end
    if getElementData(me, "state") ~= "alive" then afk.state = "none" afk.timer = 0 return end
    if not isPedInVehicle(me) then afk.state = "none" afk.timer = 0 return end
    if not getPedOccupiedVehicle(me) then afk.state = "none" afk.timer = 0 return end
    if isElementFrozen(me) then afk.state = "none" afk.timer = 0 return end


    local veh = getPedOccupiedVehicle(me)
    if getElementAttachedTo(veh) then afk.state = "none" afk.timer = 0 return end
    if isElementFrozen(veh) then afk.state = "none" afk.timer = 0 return end
    if isAircraft(veh) then afk.state = "none" afk.timer = 0 return end

    local s = getVehicleSpeed(veh)
    if s > 5 then
        afk.tick = 0
        afk.state = "none"
        removeEventHandler("onClientRender", root, afk.render)
    elseif s <= 5 then
        afk.tick = afk.tick + 1
        if afk.tick == 10 then
            afk.state = "warning"
            addEventHandler("onClientRender", root, afk.render)
        elseif afk.tick == 30 then
            afk.state = "afk"
            triggerServerEvent("onPlayerAFKTimelimit", me)
        end
    end
end
setTimer(afk.checkAFKState, 1000, -1)

--[[addEvent("onClientRaceStateChanging", true)
addEventHandler("onClientRaceStateChanging", root,
    function(s)
        if s == "Running" then
            if not isTimer(afk.timer)then afk.timer = setTimer(afk.checkAFKState, 1000, -1) end
        else
            afk.tick = 0
            afk.state = "none"
            if isTimer(afk.timer) then killTimer(afk.timer) end
        end
    end
)]]


addEvent("onClientAFKStateChanged", true)
addEventHandler("onClientAFKStateChanged", me,
    function(state)
        afk.state = state
    end
)

local keys = {["w"] = true, ["a"] = true, ["s"] = true, ["d"] = true}
addEventHandler("onClientKey", root,
    function(b)
        if not keys[b] then return end
        if not getElementData(me, "isLogedIn") then return end
        if not isChatBoxInputActive() then
            if getElementData(me, "AFK") then
                afk.state = "none"
                triggerServerEvent("onPlayerIsBack", me)
            end
        end
    end
)