--
-- PewX (HorrorClown)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 22.11.2015 - Time: 16:42
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
CLog = inherit(CSingleton)

function CLog:constructor(sObject)
    self.Object = sObject
    self.LogPath = ("logs/%s/%s.txt"):format(sObject, getDate("%s_%02d_%02d"))
    self.DateStamp = getDate("%s%02d%02d")

    if File.exists(self.LogPath) then
        self.File = File(self.LogPath)
        self.File:setPos(self.File:getSize())
    else
        self.File = File.new(self.LogPath)
        self.File:write(("[%s] File created by pxLog (Object: %s)"):format(getTime("%02d:%02d:%02d"), self.Object))
        self.File:flush()
    end
end

function CLog:destructor()
    if self.File then
        self.File:close()
    end
end

function CLog:checkForNewDay()
    if getDate("%s%02d%02d") > self.DateStamp then
        self.File:close()
        self.LogPath = ("logs/%s/%s.txt"):format(self.Object, getDate("%s_%02d_%02d"))
        self.DateStamp = getDate("%s%02d%02d")

        if File.exists(self.LogPath) then
            self.File = File(self.LogPath)
            self.File:setPos(self.File:getSize())
        else
            self.File = File.new(self.LogPath)
            self.File:write(("[%s] File created by pxLog (Object: %s)"):format(getTime("%02d:%02d:%02d"), self.Object))
            self.File:flush()
        end
    end
end

function CLog:add(sText)
    self:checkForNewDay()

    self.File:write("\n", ("[%s] %s"):format(getTime("%02d:%02d:%02d"), sText))
    self.File:flush()
end