--[[
--------------------------------------------------------------------
--Create the GuiText
--------------------------------------------------------------------
]]

theTexts = {}
theShadow = {}
nT = 0
fadeOutItemTimer = {}
function displayGUItextToAll(text, r, g, b,image) --function name, along with the arguments
    if not getElementData(g_Me, "isLogedIn") then return end
if isTimer(scrolling) then --if a text is currently scrolling
	killTimer(scrolling) --stop it
	scrolling = nil --make sure the element is really gone
	guiSetSize ( theShadow[nT], guiLabelGetTextExtent ( theTexts[nT] ), dxGetFontHeight(1,"default-bold"), false ) --set the shadow size as big as it should be
	guiSetSize ( theTexts[nT], guiLabelGetTextExtent ( theTexts[nT] ), dxGetFontHeight(1,"default-bold"), false ) --set the text size as big as it should be
end
	if isElement(theTexts[1]) then --if theres a text item
		local i = #theTexts --get the amount of text items
		while i > 0 do --start from the number of text items, count down to 0
			if i <= 0 then --safety check
				break --break the loop in case something's gone wrong.
			end
			local x, y = guiGetPosition(theTexts[i], false) --get the position of the current text item
			local x1, y1 = guiGetPosition(theShadow[i], false) --get the position of the current shadow item
			local fy = dxGetFontHeight(1,"default-bold") --get the font height
			guiSetPosition(theShadow[i], x1, y1 - fy, false) --move the shadow one step up
			guiSetPosition(theTexts[i], x, y - fy, false) --move the text one step up
			guiSetAlpha(theTexts[i], 0) --set the alpha
			guiSetAlpha(theShadow[i], 0) --set the alpha
			i = i - 1 --count down
		end
	end
	if nT < 7 then --if theres less than 5 text items
		nT = nT + 1 --count up
	else --if there are 5 or more items
		destroyElement(theTexts[1]) --destroy the first item
		destroyElement(theShadow[1]) --destroy its shadow
		table.remove(theTexts, 1) --remove it from the table
		table.remove(theShadow, 1)
		table.remove(alphaFade, 1) --remove it from the table
		table.remove(fadeOut, 1)
	end
	theShadow[nT] = guiCreateLabel(1, 0.15, 0, 0, string.gsub(text, '#%x%x%x%x%x%x', ''), true) --create a shadow
	theTexts[nT] = guiCreateLabel(1, 0.15, 0, 0, string.gsub(text, '#%x%x%x%x%x%x', ''), true) --create text
	setElementData(theTexts[nT],"realtext",text)
	fadeOutItemTimer[theTexts[nT]] = setTimer(fadeOutItems,10000,1,theTexts[nT])
	if image then
		setElementData(theTexts[nT],"image",image)
	end
	guiSetAlpha(theShadow[nT], 0)
	guiSetAlpha(theTexts[nT], 0)
	guiSetFont(theShadow[nT], "default-bold-small") --set the font
	guiSetFont(theTexts[nT], "default-bold-small") --set the font
	guiLabelSetColor(theShadow[nT], 1, 1, 1) --set the shadow color (0,0,0 aint working with new theme.)
	guiLabelSetColor(theTexts[nT], r, g, b) --set the color of the text
	local x, y = guiGetPosition(theTexts[nT], false) --get the position
	local x1, y1 = guiGetPosition(theShadow[nT], false)
	local fx = dxGetTextWidth(string.gsub(guiGetText(theTexts[nT]), '#%x%x%x%x%x%x', ''),1,"default-bold") --get the lenght of the text item
	local sX, sY = guiGetScreenSize() --get the screensize
	local size = ( x + fx ) - sX --calculate a new position for the text, so it wont go off screen
	local margin = 0.05 * sX --add a margin
	local move = size + margin --calculate the total move
	guiSetPosition(theTexts[nT], x - move, y, false) --set the final position
	guiSetPosition(theShadow[nT], (x1 + 2) - move, y1 + 2, false)
	guiMoveToBack(theTexts[nT])
	guiMoveToBack(theShadow[nT])
	
	guiSetSize(theTexts[nT], 0, 0, false) --set the size to 0 again (for scrolling)
	guiSetSize(theShadow[nT], 0, 0, false)
	scrollsize = 0
	typeFirstCharacter = true
	scrolling = setTimer(startScroll, 100, 0) --set a timer to start scrolling
end
addEvent("onRollMessageStart", true) --add a event to make it triggable from a server script
addEventHandler("onRollMessageStart", getLocalPlayer(), displayGUItextToAll) --add a handler for the event.

function startScroll () --scroll function
	if typeFirstCharacter == true then
		typeFirstCharacter = false
	end
	local x = dxGetTextWidth(string.gsub(guiGetText(theTexts[nT]), '#%x%x%x%x%x%x', ''),1,"default-bold") --get the lenght of the text
	if scrollsize < x then --if scrollsize is smaller than the text lenght
		scrollsize = scrollsize + 10 --add 10 pixels
	else
		scrollsize = x --if scollsize is bigger than the text lenght, tell it to set scrollsize the same size as the text lenght (we dont want it bigger!)
		killTimer(scrolling) --kill the timer
		scrolling = nil --make sure the element is deleted
	end
	guiSetSize(theShadow[nT], scrollsize, dxGetFontHeight(1,"default-bold"), false) --set the size
	guiSetSize(theTexts[nT], scrollsize, dxGetFontHeight(1,"default-bold"), false)
	local x, y = guiGetPosition(theTexts[nT], false) --get current position
	--guiSetPosition(blinking, x + scrollsize, y, false) --set the blinking marker so it follows the text
end

alphaFade = {}
fadeOut = {}
function fadeOutItems(item)
	alphaFade[item] = 255
	fadeOut[item] = true
end

function remotePlayerQuit(reason)
	displayGUItextToAll(getPlayerName(source).."#FFFFFF, left ["..reason.."]!", 255, 255, 255, "logout")
end
addEventHandler("onClientPlayerQuit", getRootElement(), remotePlayerQuit)
--[[
function remotePlayerQuit(reason)
	displayGUItextToAll("rgrttt#FF9900rrezzz", 255, 255, 255)
end
bindKey("i","down",remotePlayerQuit)
]]
--Draw Part
addEventHandler("onClientRender", getRootElement(), 
function()
local screenWidth, screenHeight = guiGetScreenSize()
for id, value in pairs(theTexts) do
--fade out
if fadeOut[value] then
	local x, y = guiGetPosition(value, true)
	guiSetPosition(value,x,y-0.001,true)
	if alphaFade[value] >= 1 then
		alphaFade[value] = alphaFade[value]-5
	else
	alphaFade[value] = 0
	fadeOut[value] = nil
	end
end
--draw part
local x, y = guiGetPosition(value, false)
local img = getElementData(value,"image")
	guiSetAlpha(value, 0)
	--dxDrawingColorText(string.gsub(guiGetText(value), '#%x%x%x%x%x%x', ''),screenWidth-screenWidth*0.02+1, y+1, screenWidth-screenWidth*0.02+1, y+1, tocolor(0,0,0,alphaFade[value]), alphaFade[value], 1, "default-bold", "right", "bottom", false, false, false )
	--dxDrawingColorText(getElementData(value,"realtext"),screenWidth-screenWidth*0.02, y, screenWidth-screenWidth*0.02, y, tocolor(255,255,255,alphaFade[value]), alphaFade[value], 1, "default-bold", "right", "bottom", false, false, false )
	dxDrawingColorText(string.gsub(guiGetText(value), '#%x%x%x%x%x%x', ''), 30, y+300, screenWidth-screenWidth*0.02+1, y+300, tocolor(0,0,0,alphaFade[value]), alphaFade[value], 1, "default-bold", "left", "bottom", false, false, false )
	dxDrawingColorText(getElementData(value,"realtext"), 30, y+299, screenWidth-screenWidth*0.02, y+299, tocolor(255,255,255,alphaFade[value]), alphaFade[value], 1, "default-bold", "left", "bottom", false, false, false )
	--image draw part
if img then
	if fileExists("tools/images/flags/"..img..".png") then
		local widht = dxGetTextWidth(string.gsub(guiGetText(value), '#%x%x%x%x%x%x', ''),1,"default-bold")
		local height = dxGetFontHeight(1,"default-bold")
		--dxDrawImage((screenWidth-screenWidth*0.02)-widht-20, y-height*0.8, 16,height-6,"tools/images/flags/"..tostring(img)..".png", 0,0,0,tocolor(255,255,255,alphaFade[value]), false)
		dxDrawImage(12, y-height*0.8+299, 12, 12,"tools/images/flags/"..tostring(img)..".png", 0,0,0,tocolor(255,255,255,alphaFade[value]), false)
	end
end
end
end
)