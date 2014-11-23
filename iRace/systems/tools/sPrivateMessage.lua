--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 31.07.2014 - Time: 17:51
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local pmPrefix = "|PM| #00B400"
function blockPM(c)
    if eventName == "onPlayerPrivateMessage" then
        cancelEvent()
        outputChatBox(pmPrefix .. "Please use /pm", source, 255, 255, 255, true)
    elseif eventName == "onPlayerCommand" and c == "msg" then
        cancelEvent()
        outputChatBox(pmPrefix .. "Please use /pm", source, 255, 255, 255, true)
    end
end
addEventHandler("onPlayerPrivateMessage",   root, blockPM)
addEventHandler("onPlayerCommand",          root, blockPM)

function privateMessage(thePlayer, _, target, ...)
    local text = table.concat({...}, " ")
    local targetPlayer = getPlayerFromNamePart(target)


    if text == "" then outputChatBox(pmPrefix .. "Invaild text.", thePlayer, 255, 255, 255, true) return end
    if not targetPlayer then outputChatBox(pmPrefix .. "Can't find player.", thePlayer, 255, 255, 255, true) return end
    if isPlayerBlocksPlayer(thePlayer, targetPlayer) then outputChatBox(pmPrefix .. "Message could not be sent to this user.", thePlayer, 255, 255, 255, true) return end

    local thePlayerName = removeColorCodes(getPlayerName(thePlayer))
    outputChatBox(pmPrefix .. thePlayerName .. ": " .. removeColorCodes(text), targetPlayer, 255, 255, 255, true)
    outputChatBox(pmPrefix .. thePlayerName .. " -> " .. removeColorCodes(getPlayerName(targetPlayer)) .. ": " .. removeColorCodes(text), thePlayer, 255, 255, 255, true)
    outputDebugString("|PM| " .. thePlayerName .. " -> " .. removeColorCodes(getPlayerName(targetPlayer)) .. ": " .. removeColorCodes(text))
end
addCommandHandler("pm", privateMessage)