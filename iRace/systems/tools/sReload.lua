--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 08.11.2014 - Time: 19:19
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local rld = {}

rld["hashs"] = refreshHashs
rld["musics"] = refreshMusics
rld["maplist"] = initialiseServerMaps
rld["eventmaps"] = gevt.reloadEventMaps
rld["respawnmaps"] = grsp.reloadRespawnMaps

addCommandHandler("reinit", function(player, _, type)
    if getAdminRank(player) >= 4 then
        if not type then
            local at = {}
            for name in pairs(rld) do
                table.insert(at, name)
            end
            outputChatBox("Available reload functions: " .. table.concat(at, ", "), player, 255, 0, 0)
            return
        end

        if not rld[type] then
            outputChatBox("Can't find initialise function in table!", player, 255, 0, 0)
        else
            if rld[type]() then
                outputChatBox("Successfully reloaded", player, 255, 0, 0)
            else
                outputChatBox("Error while reloading", player, 255, 0, 0)
            end
        end
    end
end)