local screenWidth, screenHeight = guiGetScreenSize()
local width, height = 720*(screenWidth/1920), 900*(screenHeight/1080)
local nineGagOpened = false
local nineGagBrowser

bindKey("F9", "down", 
	function()
		if not getElementData(me, "isLogedIn") then return end
		if (nineGagBrowser) then
			if (nineGagOpened) then
				nineGagBrowser:show(false)
				showCursor(false)
			else
				nineGagBrowser:show(true)
				showCursor(true)
			end
			nineGagOpened = not nineGagOpened
		else
			nineGagBrowser = WebWindow:new(Vector2(screenWidth/2-width/2, screenHeight/2-height/2), Vector2(width, height), "http://m.9gag.com", false)
			showCursor(true)
			nineGagOpened = true
		end
	end
)