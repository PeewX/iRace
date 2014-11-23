function drawNexMapString(player,streak)
local x, y = guiGetScreenSize()
local heighResize1 = dxGetFontHeight(0.8, "default-bold")
local heighResize2 = dxGetFontHeight(1, "default-bold")
winner = dxText:create("#FFFFFFWinner", x/2, y/1.9, false, "bankgothic", 0.8, "center" )
winner2 = dxText:create("#FFFFFF" ..getPlayerNametagText(player), x/2, y/1.9+heighResize1+2, false, "bankgothic", 1, "center" )
if streak > 1 then
	streak1 = dxText:create("#FFFFFFstreak x"..tostring(streak), x/2, y/1.9+heighResize1+heighResize2+5, false, "bankgothic", 1, "center" )
	setTimer(function()streak1:visible(false)end, 5200, 1)
end
setTimer(function()winner:visible(false) winner2:visible(false)  end, 5200, 1)
end
addEvent("onWins", true)
addEventHandler("onWins", getRootElement(), drawNexMapString)
