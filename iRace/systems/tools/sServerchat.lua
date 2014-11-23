--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 29.07.2014 - Time: 21:21
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
function setPlayerChatColor(message, messageType)
    if messageType ~= 2 and g_ruhe and not(isPlayerInAdminGroup(source)) then
        outputChatBox("You can't write while quietness mode is activated!", source, 255, 0, 0)
        cancelEvent()
    else
        if getElementData(source, "isLogedIn") then
            if messageType == 0 then
                cancelEvent()

                message = removeColorCodes(message)
                local thePlayerWithoutColorcode = removeColorCodes(getPlayerName(source))
                local thePlayer = string.gsub(getPlayerName(source), "%iR|", "")
                outputDebugString(thePlayerWithoutColorcode.. ': ' .. tostring(message))

                if isPlayerInAdminGroup(source) then
                    local _, adminColor = getPlayerAdminGroupColor(source)
                    outputChatBox(adminColor .. "iR|#ffffff" .. thePlayer .. ": #ffffff" ..tostring(message), root, 255, 255, 255, true)
                else
                    for _, pl in ipairs(getElementsByType"player") do
                        if not isPlayerBlocksPlayer(source, pl) then
                            outputChatBox(thePlayer .. ": #ffffff" .. tostring(message), pl, 255, 255, 255, true)
                        end
                    end
                end
            end
        else
            cancelEvent()
        end
    end
end
addEventHandler( "onPlayerChat", root, setPlayerChatColor )

function setPlayerTeamChatColor(message, messageType)
    if messageType ~= 2 then return end

    message = removeColorCodes(message)
    cancelEvent()

    if isPlayerInAdminGroup(source) then
        if (messageType == 2) then
            local thePlayerWithoutColorcode = removeColorCodes(getPlayerName(source))
            local thePlayer = getPlayerName(source)

            for _,v in ipairs(getElementsByType("player")) do
                if (isGuestAccount(getPlayerAccount(v)) == false) then
                    if isPlayerInAdminGroup(v) then
                        outputChatBox("|Adminchat| "..thePlayer.. ': #ddff22' ..tostring(message),v,255,255,255,true)
                    end
                end
            end
            outputDebugString("|Adminchat| "..thePlayerWithoutColorcode.. ': ' ..tostring(message))
        end
    elseif getPlayerTeam(source) ~= "User" and getPlayerTeam(source) then
        if (messageType == 2) then
            local team = getTeamName(getPlayerTeam(source))
            local thePlayerWithoutColorcode = removeColorCodes(getPlayerName(source))
            local thePlayer = getPlayerName(source)

            if team ~= "User" then
                for _,v in ipairs(getElementsByType("player")) do
                    local playerTeam = getPlayerTeam(v)
                    if playerTeam then
                        if getTeamName(playerTeam) == team then
                            outputChatBox("#808080|#FFD04FTeamchat#808080|#ffffff "..thePlayer.. ': #ddff22' ..tostring(message),v,255,255,255,true)
                        end
                    end
                end
                outputDebugString("[Teamchat:" .. team .. "] "..thePlayerWithoutColorcode.. ': ' ..tostring(message))
            end

        end
    end
end
addEventHandler( "onPlayerChat", root, setPlayerTeamChatColor)

-----------------------------------------
function isPlayerBlocksPlayer(source, target)
    local t = getElementData(source, "blocktable")
    if t then
        for _, player in ipairs(t) do
            if player == target then
                return true
            end
        end
    end
    return false
end

local ignorePrefix = "|Ignore| #C80000"
addCommandHandler("ignore", function(pl, _, c, id)
    if c == "add" then
        local t = getElementData(pl, "blocktable")
        if not t then t = {} end
        local target = getPlayerFromNamePart(id)

        if target == pl then
            outputChatBox(ignorePrefix .. "LOL, you wan't to ignore yourself??", pl, 255, 255, 255, true)
            return
        end

        if target then
            table.insert(t, target)
            setElementData(pl, "blocktable", t)
            outputChatBox(ignorePrefix .. "Successfully added #ffffff" .. removeColorCodes(getPlayerName(target)) .. "#C80000 to your ignore list!", pl, 255, 255, 255, true)
        else
            outputChatBox(ignorePrefix .. "Can't find player!", pl, 255, 255, 255, true)
        end
    elseif c == "rem" then
        local t = getElementData(pl, "blocktable")
        if table.remove(t, tonumber(id)) then
            outputChatBox(ignorePrefix .. "Player successfully removed!", pl, 255, 255, 255, true)
            setElementData(pl, "blocktable", t)
        else
            outputChatBox(ignorePrefix .. "Unknown ID. Unable to remove!", pl, 255, 255, 255, true)
        end
    elseif c == "list" then
        local bT = getElementData(pl, "blocktable")
        if bT and #bT ~= 0 then
            for i, target in ipairs(bT) do
                if target then
                    local pn = removeColorCodes(getPlayerName(target))
                    outputChatBox("[" .. i .. "] #C80000" .. pn, pl, 255, 255, 255, true)
                else
                    table.remove(bT, i)
                end
            end
            setElementData(pl, "blocktable", bT)
        else
            outputChatBox(ignorePrefix .. "Your ignore list is empty", pl , 255, 255, 255, true)
        end
    else
        outputChatBox(ignorePrefix .. "Syntax: /ignore [add/rem/list]", pl, 255, 255, 255, true)
    end
end)


function onChat (message, messageType)
    if messageType == 1 then -- /me
        cancelEvent()
    end
end
addEventHandler ( "onPlayerChat", root, onChat )