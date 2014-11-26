--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 17.09.2014 - Time: 11:54
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local mt = {musicLists = {}, winSound = true}
local songOn = true

addEventHandler("onClientResourceStart", resroot,
    function()
        triggerServerEvent("onClientRequestMusicList", resroot)
    end
)

addEvent("onServerSendMusicList", true)
addEventHandler("onServerSendMusicList", me ,
    function(list)
        mt.musicLists = list
    end
)

function mt.getRandomMusic()
    local music = mt.musicLists["irace_background"][math.random(1, #mt.musicLists["irace_background"])]
    local text = string.gsub(music, ".mp3", "")
    return music, text
end

addEventHandler("onClientSoundStream", root,
    function(started)
        if started and not getElementData(source, "winsound") then mt.mapStreamFailed = false end
    end
)


addEvent("onClientRaceStateChanging", true)
addEventHandler("onClientRaceStateChanging", root,
    function(ns)
        if ns == "Running" then
            if mt.mapStreamFailed then
                if #mt.musicLists["irace_background"] == 0 then return end
                local rnd, text = mt.getRandomMusic()
                mt.play = playSound("http://pewx.de/res/sounds/irace_background/" .. rnd, true)
                setElementData(mt.play, "mapmusic", true)
                triggerEvent("addClientMessage", root, "|HorrorFM| #24BAE0" .. text, 255, 255, 255)
            end
        elseif ns == "NoMap" then
            mt.mapStreamFailed = true
        end
    end
)

addEvent("onClientMapStopping")
addEventHandler("onClientMapStopping", root,
    function()
        if mt.play then
            setElementData(mt.play, "mapmusic", nil)
            stopSound(mt.play)
            mt.play = nil
        end

        if mt.specialPlay then
            setElementData(mt.specialPlay, "specialMusic", nil)
            stopSound(mt.specialPlay)
            mt.specialPlay = nil
        end
    end
)

addEvent("onPlayerPlaySpecialMusic", true)
addEventHandler("onPlayerPlaySpecialMusic", root,
    function(song)
        if songOn then
            for _, sound in ipairs(getElementsByType("sound")) do
                setSoundPaused(sound, true)
            end
        end
        mt.specialPlay = playSound("http://pewx.de/res/sounds/specialMusic/" .. song)
        setElementData(mt.specialPlay, "specialMusic", true)
    end
)

setRadioChannel(0)
function cancelRadioSwitch()
    cancelEvent()
end
addEventHandler("onClientPlayerRadioSwitch", getRootElement(), cancelRadioSwitch)

function soundToggle()
    if songOn == true then
        songOn = false
        for _, sound in ipairs(getElementsByType("sound")) do
            if getElementData(sound, "mapmusic") then
                setSoundPaused(sound, true)

            end
        end
        outputChatBox("|Music| #ffdd00disabled", 255, 255, 255, true)
    elseif songOn == false then
        songOn = true
        for _, sound in ipairs(getElementsByType("sound")) do
            if getElementData(sound, "mapmusic") then
                local b = setSoundPaused(sound, false)
            end
        end
        outputChatBox("|Music| #ffdd00enabled", 255, 255, 255, true)
    end
end
bindKey("m","down",soundToggle)

addEventHandler("onClientSoundStream", getRootElement(), function(state, length, name)
    if not getElementData(source, "winsound") and not getElementData(source, "specialMusic")  then
        setElementData(source, "mapmusic", true)
        if songOn == false then
            setSoundPaused(source, true)
        end
    elseif getElementData(source, "winsound") or  getElementData(source, "specialMusic") then
        if length == 0 then
            for i,sound in ipairs (getElementsByType("sound")) do
                if getElementData(sound, "mapmusic") then
                    setSoundVolume(sound,1)
                end
            end
        else
            setTimer(function()
                if songOn then
                    for _,sound in ipairs (getElementsByType("sound")) do
                        if getElementData(sound, "mapmusic") then
                            setSoundVolume(sound,1)
                        end
                    end
                end
            end, length*1000, 1)
        end
    end
end)


addEvent("onAdminWin", true)
addEventHandler("onAdminWin", root,
    function(accName)
        if mt.winSound then
            if songOn then
                for _, sound in ipairs (getElementsByType("sound")) do
                    if getElementData(sound, "mapmusic") then
                        setSoundVolume(sound, 0.1)
                    end
                end
            end
            local adminmusic = playSound("http://www.irace-mta.de/servermusic/adminmusic/" .. accName .. ".mp3", false)
            setElementData(adminmusic, "winsound", true)
        end
    end
)

addCommandHandler("winsound",
    function()
        mt.winSound = not mt.winSound
        outputChatBox(("|Winsound| #00aaff%s!"):format(mt.winSound and "enabled" or "disabled"), 255, 255, 255, true)
    end
)