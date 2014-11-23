--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 31.07.2014 - Time: 19:18
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
addEventHandler('onClientResourceStart', root,	function() triggerServerEvent ('addClient', me) end)

addEventHandler("onClientRender", root, function()
    if getElementData(me, "isLogedIn") then
        local specPlayer = getSpectatedPlayer()
            if specPlayer then
                dxDrawText(getPlayerName(specPlayer), 0, y - 120/1080*y, x, y, tocolor(255, 255, 255), 1, iFont[14], "center", "top", false, false, false, true)
            else
        end
    end
end)