--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 29.07.2014 - Time: 20:45
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local map = {}

addEvent("onServerSendMapType", true)
addEventHandler("onServerSendMapType", me, function(new)
    map.current = new
end)

function isMapType(typ)
    return map.current == typ
end