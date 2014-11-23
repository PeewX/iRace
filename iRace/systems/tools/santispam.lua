--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 09.11.2014 - Time: 05:37
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local unlistedCommands = {"Toggle", "showtimes", "say", "Commit", "teamsay", "admin", "deltime"}
local commandUsed = {}
antiSpam = {}

addEventHandler("onPlayerChat", root, function()
    if g_racestate == "LoadingMap" then return end
    local sourceAccount = getPlayerAccount(source)
    if not isGuestAccount(sourceAccount) then
        if isTimer(antiSpam[source]) then
            cancelEvent()
            outputChatBox("|AntiSpam| " .. getPlayerName(source) .. " #ff6600was muted for spam (2 min)!", root, 255, 255, 255, true)
            setPlayerMuted(source, true)
            setTimer(UnmutePlayer, 120000, 1, source)
        else
            antiSpam[source] = setTimer(function(source) antiSpam[source] = nil end, 400, 1, source)
        end
    end
end)

--[[addEventHandler("onPlayerCommand", root, function(command)
    if isCommandUnlisted(command) then return end

    local sourceAccount = getPlayerAccount(source)
    if not isGuestAccount(sourceAccount) then
        if isTimer(commandUsed[source]) then
            cancelEvent()
            outputChatBox("|AntiSpam| #ff6600Command blocked to prevent spam!", source, 255, 255, 255, true)
            do return end
        else
            commandUsed[source] = setTimer(function(source) commandUsed[source] = nil end, 100, 1, source)
        end
    end

    outputServerLog("Command " .. command .. " was used by " .. removeColorCodes(getPlayerName(source)))
end)]]

function UnmutePlayer(player)
    if (isElement(player) and isPlayerMuted (player)) then
        setPlayerMuted (player, false)
        outputChatBox ("|AntiSpam| " .. getPlayerName (player) .. " #ff6600 can now write again!", root, 255, 255, 255,true )
    end
end

function isCommandUnlisted(command)
    for i, v in ipairs(unlistedCommands) do
        if command == v then
            return true
        end
    end
    return false
end