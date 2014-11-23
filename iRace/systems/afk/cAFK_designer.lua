--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 08.11.2014 - Time: 22:04
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--

function afk.render()
    if not getElementData(me, "isLogedIn") then return end
    --if afk.state == "warning" and getElementData(me, "state") == "alive" and isPedInVehicle(me) then
    if afk.state == "warning" then
        dxDrawRectangle(0, 0.6*y, x, 0.1*y, tocolor(0, 0, 0, 155), true)
        dxDrawText("You'll be flagged as AFK in " .. 30-afk.tick, 0, 0.6*y, x, 0.6*y + 0.1*y, tocolor(255, 0, 0), 1, iFont[16], "center", "center", false, false, true)
    elseif afk.state == "afk" then
        dxDrawRectangle(0, 0.6*y, x, 0.1*y, tocolor(0, 0, 0, 155), true)
        dxDrawText("You are flagged as AFK!", 0, 0.6*y, x, 0.6*y + 0.1*y, tocolor(255, 0, 0), 1, iFont[16], "center", "center", false, false, true)
    end
end