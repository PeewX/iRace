--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 01.08.2014 - Time: 18:32
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local aNickChangeTime = {}
local nickChangeDelay = 5000
showNickchange = true

function checkNickOnChange(old, new)
    if aNickChangeTime[source] and aNickChangeTime[source] + nickChangeDelay > getTickCount() then
        cancelEvent()
    elseif showNickchange then
        if not isPlayerMuted(source) and not g_ruhe then
            outputChatBox("|Nickchange| " .. old .. " #ff6600changed his nick to #ffffff" .. new, getRootElement(), 255, 255, 255, true)
        else
            outputChatBox("|Nickchange| #ff6600You changed your nick to #ffffff" .. new, source, 255, 255, 255, true)
        end

        exports.pxlog:add("nickchange", ("%s -> %s"):format(tostring(old), tostring(new)))
    end
end
addEventHandler("onPlayerChangeNick", root, checkNickOnChange)

addEventHandler ( "onPlayerQuit", root, function ()
    aNickChangeTime[source] = nil
end )