--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 17.09.2014 - Time: 14:49
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local mt = {musicLists = {}}

function mt.initialise()
    mt.getMusicList("irace_background")
    mt.getMusicList("specialMusic")
end
addEventHandler("onResourceStart", resroot, mt.initialise)

addEvent("onClientRequestMusicList", true)
addEventHandler("onClientRequestMusicList", resroot,
    function()
        triggerClientEvent(client, "onServerSendMusicList", client, mt.musicLists)
    end
)

function mt.getMusicList(folder)
    fetchRemote("http://www.pewx.de/res/music.php?folder=" .. folder, mt.receiveMusicList, "", false, folder)
end

function mt.receiveMusicList(list, errno, folder)
    if list == "ERROR" then outputChatBox("Error: " .. errno) return end
    --local cache = fromJSON("[" .. list .. "]")
    local cache = fromJSON(list)
    mt.musicLists[folder] = {}
    if cache then
        for _, song in pairs(cache) do
            if (string.find(song, ".mp3") or string.find(song, ".ogg")) then
                table.insert(mt.musicLists[folder], song)
            end
        end
    end
end

function refreshMusics()
    mt.initialise()
end

function getMusicList(list)
    return mt.musicLists[list]
end