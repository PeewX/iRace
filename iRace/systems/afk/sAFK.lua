--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 08.11.2014 - Time: 21:59
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--

local afk = {players = {}}

addEvent("onRaceStateChanging")
addEventHandler("onRaceStateChanging", root,
    function(ns)
        if ns == "Running" then
            for _, p in ipairs(getElementsByType"player") do
                if getPlayerIdleTime(p) > 3600000 then
                    kickPlayer(p, "iRace AntiAFK", "You were idle for one hour!")
                elseif getElementData(p, "AFK") then
                    setElementHealth(p, 0)
                elseif getElementData(p, "state") == "not ready" then
                    setTimer(function(p)
                        if getElementData(p, "state") == "not ready" then
                            setElementHealth(p, 0)
                        end
                    end, 20000, 1, p)
                elseif getElementData(p, "state") ~= "alive" then
                    setTimer(function(p)
                        if getElementData(p, "state") ~= "alive" then
                            setElementHealth(p, 0)
                            triggerClientEvent(p, "addClientMessage", p, "|AFK| #ff9900You were killed because you are not ready!", 255, 255, 255)
                        end
                    end, 20000, 1, p)
                end
            end
        end
    end
)

addEvent("onPlayerIsBack", true)
addEventHandler("onPlayerIsBack", getRootElement(),
    function()
        if not checkClient(source, client) then return end
        if getElementData(source, "AFK") then
            setElementData(source, "AFK", false)
            triggerClientEvent("addClientMessage", root, ("|AFK| %s #ff9900is back!"):format(getPlayerName(client)), 255, 255, 255)
        end
    end
)

addCommandHandler("afk",
    function(player, _, ...)
        if getElementData(player, "AFK") == false then
            local afkMessage = table.concat({...}, " ")
            if string.len(afkMessage) > 20 then afkMessage = string.sub(afkMessage, 1, 20) end

            setElementData(player, "AFK", true)
            triggerClientEvent(player, "onClientAFKStateChanged", player, "afk")
            if afkMessage ~= "" then afkMessage = string.format("(%s)", afkMessage) end
            if g_ruhe or isPlayerMuted(player) then return end

            triggerClientEvent("addClientMessage", root, ("|AFK| %s #ff9900is now AFK %s"):format(getPlayerName(player), afkMessage), 255, 255, 255)
        else
            setElementData(player, "AFK", false)
            triggerClientEvent(player, "onClientAFKStateChanged", player, "none")

            if g_ruhe or isPlayerMuted(player) then return end
            triggerClientEvent("addClientMessage", root, ("|AFK| %s #ff9900is back!"):format(getPlayerName(player)), 255, 255, 255)
        end
    end
)

addEvent("onPlayerAFKTimelimit", true)
addEventHandler("onPlayerAFKTimelimit", root,
    function()
        if checkClient(source, client) then
            if g_racestate == "Running" then
                setElementHealth(client, 0)
                setElementData(source, "AFK", true)
                triggerClientEvent("addClientMessage", root, ("|AFK| %s #FF9900 is now AFK (Auto)"):format(getPlayerName(client)), 255, 255, 255)
                table.insert(afk.players, client)
            end
        end
    end
)