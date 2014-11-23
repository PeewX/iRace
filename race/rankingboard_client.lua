local sx,sy = guiGetScreenSize()

RankingBoard = {}
RankingBoard.__index = RankingBoard

RankingBoard.instances = {}

local screenWidth, screenHeight = guiGetScreenSize()
local topDistance = 0--screenHeight-19*11
local bottomDistance = screenHeight-19*11
local posLeftDistance = screenWidth-120
local nameLeftDistance = 60
local labelHeight = 19
local maxPositions = 11
local rankingBoardEnabled = true

posLabel = {}
playerLabel = {}
alphaElem = {}
colorElem = {}
biggestLabelWidth = 0

function resetRankingboard ()
	for id, elem in pairs(posLabel) do
		setElementData(elem,"PlayerIsOffline",false)
		setElementData(elem,"spectated",false)
	end
	for i, val in ipairs(spectators) do
		table.remove(spectators, i)
	end
	for id, elem in pairs(posLabel) do
			setElementData(elem,"afkresult",false)
	end
posLabel = {}
playerLabel = {}
spectators = {}		
alphaElem = {}
colorElem = {}
biggestLabelWidth = 0
end
addEvent("onClientMapStopping",true)
addEventHandler ( "onClientMapStopping", getRootElement(), resetRankingboard )

function resetSpectators ()
	for i, val in ipairs(spectators) do
		table.remove(spectators, i)
	end
	for id, elem in pairs(posLabel) do
		setElementData(elem,"spectated",false)
	end	
spectators = {}		
end
addEvent("onClientPlayerWasted",true)
addEventHandler ( "onClientPlayerWasted", getLocalPlayer(), resetSpectators )

function RankingBoard.create(id)
	RankingBoard.instances[id] = setmetatable({ id = id, direction = 'up', labels = {}, position = 0 }, RankingBoard)
	posLabel = {}
	playerLabel = {}
end

function RankingBoard.call(id, fn, ...)
	RankingBoard[fn](RankingBoard.instances[id], ...)
end

function RankingBoard:setDirection(direction, plrs)
	self.direction = direction
	if direction == 'up' then
		self.highestPos = plrs--#g_Players
		self.position = self.highestPos + 1
	end
end

function RankingBoard:add(name, time)
	local position
	local y
	local doBoardScroll = false
	if self.direction == 'down' then
		self.position = self.position + 1
		if self.position > maxPositions then
			return
		end
		y = topDistance + (self.position-1)*labelHeight
	elseif self.direction == 'up' then
		self.position = self.position - 1
		local labelPosition = self.position
		if self.highestPos > maxPositions then
			labelPosition = labelPosition - (self.highestPos - maxPositions)
			if labelPosition < 1 then
				labelPosition = 0
				doBoardScroll = true
			end
		elseif labelPosition < 1 then
			return
		end
		y = topDistance + (labelPosition-1)*labelHeight
	end
	posLabel[name], posLabelShadow = createShadowedLabelFromSpare(nameLeftDistance, y, 20, labelHeight, tostring(self.position) .. '.', 'right')
	if time then
		if not self.firsttime then
			self.firsttime = time
			time = ': ' .. msToTimeStr(time)
		else
			time = ': +' .. msToTimeStr(time - self.firsttime)
		end
	else
		time = ''
	end
	time = ""
	playerLabel[name], playerLabelShadow = createShadowedLabelFromSpare(nameLeftDistance, y, 250, labelHeight, "#FFFFFF"..name)
	table.insert(self.labels, posLabel[name])
	table.insert(self.labels, posLabelShadow)
	table.insert(self.labels, playerLabel[name])
	table.insert(self.labels, playerLabelShadow)
	alphaElem[playerLabel[name]] = 0
	alphaElem[posLabel[name]] = 0
	colorElem[playerLabel[name]] = {30,30,30}
    playSoundFrontEnd(7)
		guiSetAlpha(posLabel[name], 0)
		guiSetAlpha(posLabelShadow, 0)
		guiSetAlpha(playerLabel[name], 0)
		guiSetAlpha(playerLabelShadow, 0)		
	if doBoardScroll then			
		local anim = Animation.createNamed('race.boardscroll', self)
		anim:addPhase({ from = 0, to = 1, time = 500, fn = RankingBoard.scroll, firstLabel = posLabel[name] })
		anim:addPhase({ fn = RankingBoard.destroyLastLabel, firstLabel = posLabel[name] })
		anim:play()
	end
	for id, elem in pairs(playerLabel) do
			local widthRezise1 = dxGetTextWidth(string.gsub( guiGetText(elem), '#%x%x%x%x%x%x', '' ),1.1,"default-bold")
			if widthRezise1 > biggestLabelWidth then
				biggestLabelWidth = widthRezise1
				posLeftDistance = screenWidth-biggestLabelWidth
			end
		end
end

function RankingBoard:scroll(param, phase)
	local firstLabelIndex = table.find(self.labels, phase.firstLabel)
	for i=firstLabelIndex,firstLabelIndex+3 do
		guiSetAlpha(self.labels[i], param)
	end
	local x, y
	for i=0,#self.labels/4-1 do
		for j=1,4 do
			x = (j <= 2 and posLeftDistance or nameLeftDistance)
			y = topDistance + ((maxPositions - i - 1) + param)*labelHeight
			if j % 2 == 0 then
				x = x + 1
				y = y + 1
			end
			guiSetPosition(self.labels[i*4+j], sx + x, y, false)
		end
	end
	for i=1,4 do
		guiSetAlpha(self.labels[i], 1 - param)
	end
end

function RankingBoard:destroyLastLabel(phase)
	for i=1,4 do
		destroyElementToSpare(self.labels[1])
		guiSetVisible(self.labels[1],false)
		table.remove(self.labels, 1)
	end
	local firstLabelIndex = table.find(self.labels, phase.firstLabel)
	for i=firstLabelIndex,firstLabelIndex+3 do
		guiSetAlpha(self.labels[i], 1)
	end
end

function RankingBoard:addMultiple(items)
	for i,item in ipairs(items) do
		self:add(item.name, item.time)
	end
end


function testing (c,name)
RankingBoard:add(name)
end
addCommandHandler("addt",testing)

function RankingBoard:clear()
	table.each(self.labels, destroyElementToSpare)
	self.labels = {}
end

function RankingBoard:destroy()
	self:clear()
	RankingBoard.instances[self.id] = nil
end


function isPlayerOnline (name)
	for i,sPlayer in ipairs(getElementsByType"player") do
		if getPlayerName(sPlayer) == name then 
			playerIsOnline = true
		else
			playerIsOnline = false
		end
	end
	return playerIsOnline
end

function RankingBoardAddQuit(playername)
setTimer(
function ()
	for id, elem in pairs(posLabel) do
		if id == playername then  
			setElementData(elem,"PlayerIsOffline",true)
		end	
	end
end,500,1)
end
addEvent("addQuitPlayerToGUI",true)
addEventHandler("addQuitPlayerToGUI",getLocalPlayer(),RankingBoardAddQuit)

function RankingBoardAddJoin(playername)
setTimer(
function ()
	for id, elem in pairs(posLabel) do
		if id == playername then  
			setElementData(elem,"PlayerIsOffline",false)
		end	
	end
end,250,1)
end
addEvent("addJoinPlayerToGUI",true)
addEventHandler("addJoinPlayerToGUI",getLocalPlayer(),RankingBoardAddJoin)

function RankingBoardAddAFK(playername)
setTimer(
function ()
	for id, elem in pairs(posLabel) do
		if id == playername then  
			setElementData(elem,"afkresult",true)
		end	
	end
end,250,1)
end
addEvent("onAFKKillResult",true)
addEventHandler("onAFKKillResult",getRootElement(),RankingBoardAddAFK)

function RankingBoardAddAFK(playername)
setTimer(
function ()
	for id, elem in pairs(posLabel) do
		if id == playername then  
			setElementData(elem,"afkresult",false)
		end
	end
end,250,1)
end
addEvent("onAFKBackResult",true)
addEventHandler("onAFKBackResult",getRootElement(),RankingBoardAddAFK)

spectators = {}
addEvent('addSpectator', true)
addEvent('removeSpectator', true)

addEventHandler('addSpectator', getRootElement(),
	function(spectator)
		table.insert(spectators, spectator)
		for idS, spectatorer in pairs(spectators) do
			for id, elem in pairs(posLabel) do
				if id == getPlayerNametagText(spectatorer) then 
					setElementData(elem,"spectated",true)
				end
			end
		end
	end	
)

addEventHandler('removeSpectator', getRootElement(),
	function(spectator)
		for i, val in ipairs(spectators) do
			if (val == spectator) then
				table.remove(spectators, i)
				for id, elem in pairs(posLabel) do
					if id == getPlayerNametagText(val) then
						setElementData(elem,"spectated",false)
					end
				end
			end
		end
	end
)

--
-- Label cache
--


local spareElems = {}
local donePrecreate = false

local fakeFont = guiCreateFont("font_ffs.ttf", 0)

function RankingBoard.precreateLabels(count)
    donePrecreate = false
    while #spareElems/4 < count do
        local label, shadow = createShadowedLabel(10, 1, 20, 10, 'a' )
		--guiSetAlpha(label,0)
		guiSetAlpha(shadow,0)
		

		
		guiSetVisible(label, false)
		guiSetVisible(shadow, false)
        destroyElementToSpare(label)
        destroyElementToSpare(shadow)
	end
    donePrecreate = true
end

function destroyElementToSpare(elem)
    table.insertUnique( spareElems, elem )
    guiSetVisible(elem, false)
end

dxTextCache = {}
dxTextShadowCache = {}

function dxDrawColoredLabel(str, ax, ay, bx, by, color,tcolor,scale, font)
	local rax = ax
	if not dxTextShadowCache[str] then
		dxTextShadowCache[str] = string.gsub( str, '#%x%x%x%x%x%x', '' )
	end
	theText = dxDrawText(dxTextShadowCache[str], ax+1,ay+1,ax+1,by,tocolor(0,0,0, 0.8 * tcolor[4]),scale,font, "left", "center", false,false,false) 
	if dxTextCache[str] then
		for id, text in ipairs(dxTextCache[str]) do
			local w = text[2] * ( scale / text[4]  )
			theText = dxDrawText(text[1], ax + w, ay, ax + w, by, tocolor(text[3][1],text[3][2],text[3][3],tcolor[4]), scale, font, "left", "center", false,false,false)
		end
	else
		dxTextCache[str] = {}
		local pat = "(.-)#(%x%x%x%x%x%x)"
		local s, e, cap, col = str:find(pat, 1)
		local last = 1
		local r = tcolor[1]
		local g = tcolor[2]
		local b = tcolor[3]
		local textalpha = tcolor[4]
		while s do
			if cap == "" and col then
				r = tonumber("0x"..col:sub(1, 2))
				g = tonumber("0x"..col:sub(3, 4))
				b = tonumber("0x"..col:sub(5, 6))
				color = tocolor(r, g, b, textalpha) 
			end
			if s ~= 1 or cap ~= "" then
				local w = dxGetTextWidth(cap, scale, font)
				theText = dxDrawText(cap, ax, ay, ax + w, by, color, scale, font, "left", "center")
				table.insert(dxTextCache[str], { cap, ax-rax, {r,g,b}, scale } )
				ax = ax + w
				r = tonumber("0x"..col:sub(1, 2))
				g = tonumber("0x"..col:sub(3, 4))
				b = tonumber("0x"..col:sub(5, 6))
				color = tocolor( r, g, b, textalpha)
			end
			last = e + 1
			s, e, cap, col = str:find(pat, last)
		end
		if last <= #str then
			cap = str:sub(last)
			local w = dxGetTextWidth(cap, scale, font)
			theText = dxDrawText(cap, ax, ay, ax + w, by, color, scale, font, "left", "center")
			table.insert(dxTextCache[str], { cap, ax-rax, {r,g,b}, scale } )
		end
	end
	return theText
end

function enableRankingboard ()
rankingBoardEnabled = not rankingBoardEnabled
end
addCommandHandler("F2",enableRankingboard)

local ltfont = "default-bold"
local recentangleHeightRezise = dxGetFontHeight (1, ltfont)
local screenWidth, screenHeight = guiGetScreenSize()
addEventHandler("onClientRender", root, 
	function()
        if not getElementData(g_Me, "isLogedIn") then return end
		if rankingBoardEnabled == false then
			return
		end
		--Move
		for id, elem in pairs(playerLabel) do
				alphaElem[elem] = alphaElem[elem] + 2
			if alphaElem[elem] > 255 then
				alphaElem[elem] = 255
			elseif alphaElem[elem] < 0 then 
				alphaElem[elem] = 0
			end
		end
		for id, elem in pairs(posLabel) do
				alphaElem[elem] = alphaElem[elem] + 2
			if alphaElem[elem] > 255 then
				alphaElem[elem] = 255
			elseif alphaElem[elem] < 0 then 
				alphaElem[elem] = 0
			end
		end
		for id, elem in pairs(playerLabel) do
			if guiGetVisible(elem) and string.len(guiGetText(elem)) > 4 then
				local x,y = guiGetPosition(elem, false )
				local a = guiGetAlpha(elem) * 255
				if not getKeyState("tab") then
					local withRezise = dxGetTextWidth("10.)",1.1,"default-bold")
					dxDrawRectangle ( posLeftDistance-withRezise-withRezise-withRezise/2,y-1,biggestLabelWidth+withRezise*1.4+6+withRezise+withRezise/2,recentangleHeightRezise*1.1+4, tocolor ( 0, 0, 0, alphaElem[elem]/1.5 ) )
					dxDrawColoredLabel(string.gsub(string.gsub(guiGetText(elem)," ", " #ffffff",1),"#000000", " #ffffff",1), posLeftDistance-withRezise+4,y,200,y+20, tocolor(255,255,255,alphaElem[elem]),{255,255,255,alphaElem[elem]}, 1.1, ltfont, "left", "center", false,false,false)							
				end
			end
		end
		for id, elem in pairs(posLabel) do
			if guiGetVisible(elem) and string.len(guiGetText(elem)) <= 4 then
				local x,y = guiGetPosition(elem, false )
				local a = guiGetAlpha(elem) * 255
				if not getKeyState("tab") then
						local withRezise = dxGetTextWidth("10.)",1.1,"default-bold")
						--Colors 
						if getElementData(elem,"PlayerIsOffline") then
							colorElem[elem] = {255,0,0}
						elseif getElementData(elem,"spectated") then
							colorElem[elem] = {255,153,0}
						elseif getElementData(elem,"afkresult") then
							colorElem[elem] = {255,153,0}
						else
							colorElem[elem] = {255,255,255}
						end
						dxDrawText(guiGetText(elem), posLeftDistance+1,y+1,posLeftDistance-withRezise+1,y+21, tocolor(0,0,0,alphaElem[elem]), 1.1, ltfont, "right", "center", false,false,false)
						dxDrawText(guiGetText(elem), posLeftDistance,y,posLeftDistance-withRezise,y+20, tocolor(colorElem[elem][1],colorElem[elem][2],colorElem[elem][3],alphaElem[elem]), 1.1, ltfont, "right", "center", false,false,false)
				end
			end
		end
	end
)



function createShadowedLabelFromSpare(x, y, width, height, text, align)

    if #spareElems < 2 then
        if not donePrecreate then
            outputDebug( 'OPTIMIZATION', 'createShadowedLabel' )
        end
	    return createShadowedLabel(x, y, width, height, text, align)
    else
        local shadow = table.popLast( spareElems )
	    guiSetSize(shadow, width, height, false)
	    guiSetText(shadow, text)
	    --guiLabelSetColor(shadow, 0, 0, 0)
	    guiSetPosition(shadow, sx + x + 1, y + 1, false)
        guiSetVisible(shadow, false)

        local label = table.popLast( spareElems )
	    guiSetSize(label, width, height, false)
	    guiSetText(label, text)
	    --guiLabelSetColor(label, 255, 255, 255)
	    guiSetPosition(label, sx + x, y, false)
        guiSetVisible(label, true)
	    if align then
		    guiLabelSetHorizontalAlign(shadow, align)
		    guiLabelSetHorizontalAlign(label, align)
        else
		    guiLabelSetHorizontalAlign(shadow, 'left')
		    guiLabelSetHorizontalAlign(label, 'left')
	    end
        return label, shadow
    end
end