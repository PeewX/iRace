--
-- PewX (HorrorClown)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 22.11.2015 - Time: 18:41
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--

addEventHandler("onResourceStart", resourceRoot,
    function()
        exports.pxlog:create("chat_global")
        exports.pxlog:create("chat_admin")
        exports.pxlog:create("chat_team")
        exports.pxlog:create("chat_pm")

        exports.pxlog:create("nickchange")
    end
)