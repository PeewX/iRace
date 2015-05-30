--[[iR|HorrorClown (PewX) - iRace-mta.de--
local today = {time = "", date = ""}
local w = {sX = math.random(0, x), sY = math.random(0, y), w = 0, h = 0, wA = 0, errorMsg = "", sub = {sX = x/2, sY = y/2-(50/1080*y), alpha = 0, tA = 255, selected = 1, sWH = 170/1080*y, items = {"Login", "Register", "Info"}}}
local leftClick = false

local function changeSelected(state, m)
	local nS if m ~= nil then	nS = state else	nS = w.sub.selected + state	if nS > 3 then nS = 1 elseif nS < 1 then nS = 3 end	end
	createGUIEdits(nS)
	
	local t = {}
	local function render()
		local p = (getTickCount()-t.sT)/(t.eT-t.sT)
		w.sub.sX, w.sub.sWH = interpolateBetween(t.sX, t.sWH, 0, t.eX, t.eWH, 0, p, "OutBack")
		w.sub.tA 			= interpolateBetween(t.sTA, 0, 0, t.eTA, 0, 0, p, "OutQuad")
		if p >= 1 then removeEventHandler("onClientRender", root, render) end
		w.sub.selected = nS
	end
	t.sT = getTickCount()
	t.eT = t.sT + 600
	t.sX = w.sub.sX
	t.eX = x/2-(128/1920*x)*(nS-1)
	t.sTA = 100
	t.eTA = 255
	t.sWH = 100/1080*y
	t.eWH = 170/1080*y
	addEventHandler("onClientRender", root, render)
end

local function includeZero(n) if #tostring(n) == 1 then return "0"..n end return n end
local wd = {[1] = "Monday", [2] = "Tuesday", [3] = "Wednesday", [4] = "Thursday", [5] = "Friday", [6] = "Saturday", [0] = "Sunday"}
local function getDayName(n) return wd[n] end
local m = {[1] = "February", [2] = "March", [3] = "April", [4] = "May", [5] = "June", [6] = "July", [7] = "August", [8] = "September", [9] = "October", [10] = "November", [11] = "December", [0] = "January", }
local function getMonthName(n) return m[n] end

local function calcToday()
	local time = getRealTime()
	today.time = includeZero(time.hour) .. ":" .. includeZero(time.minute)
	today.date = getDayName(time.weekday) .. ", " .. time.monthday .. ". " .. getMonthName(time.month) .. " " .. time.year + 1900
end

local function boundedKeys(btn, down)
	if down and (btn == "enter" or btn == "num_enter") then clientExecute(w.sub.selected, getSelectedGuiTexts(w.sub.selected))
	elseif down and btn == "arrow_r" then changeSelected(1)
    elseif down and btn == "arrow_l" then changeSelected(-1)
    end
end

local function renderExecuteIcon()
	if fileExists("files/images/login/execute.png") then
		
		local color = tocolor(200, 200, 200, w.sub.alpha)
        local size = 48/1080*y
		if isHover(x-(40+size)/1920*x, w.sY + (280/1080*y), size, size) then
			color = tocolor(255, 120, 0, w.sub.alpha)
			if leftClick then
				clientExecute(w.sub.selected, getSelectedGuiTexts(w.sub.selected))
			end
		end


		dxDrawImage(x-(40+size)/1920*x, w.sY + (280/1080*y), size, size, "files/images/login/execute.png", 0, 0, 0, color)
	end
end

local function render()
    fadeCamera(true, 0)     --No other way found.. Can't find the right fadeOut in race resource..
	dxDrawRectangle(w.sX, w.sY, w.w, w.h, tocolor(0, 0, 0, 180))
    dxDrawRectangle(w.sX, w.sY+(250/350*w.h), w.w, 1, tocolor(120, 120, 120, w.wA))
	dxDrawRectangle(w.sX, w.sY+(251/350*w.h), w.w, 1, tocolor(20, 20, 20, w.wA))
	
	for i, sub in ipairs(w.sub.items) do
		if fileExists("files/images/login/" .. string.lower(sub) .. ".png") then
			local iconLength = 100/1920*x
            local iW, iH, tA = iconLength, iconLength, 100 --Image Width, Image Height, textAlpha


            if i == w.sub.selected then iW, iH, tA = w.sub.sWH, w.sub.sWH, w.sub.tA	end
			
			dxDrawImage(w.sub.sX+(200/1920*x)*(i-1)-iW/2, w.sub.sY-iH/2, iW, iH, "files/images/login/" .. string.lower(sub) .. ".png", 0, 0, 0, tocolor(255, 255, 255, tA/255*w.sub.alpha))
			if isHover(w.sub.sX+(200/1920*x)*(i-1)-iW/2, w.sub.sY-iH/2, iW, iH) then sub = ">" .. sub .. "<" if leftClick then changeSelected(i, true)  end end
			dxDrawText(sub, w.sub.sX+(200/1920*x)*(i-1)-iW/2, y/2+(30/1080*y), w.sub.sX+(200/1920*x)*(i-1)+iW/2, y, tocolor(255, 255, 255, tA/255*w.sub.alpha), 1, iFont[14], "center")
		end
	end
		
	local x1, y1 = x/4/1920*x, w.sY
	if w.sub.selected == 1 then
		dxDrawText("Username", x1, y1 + (250/1080*y), x, y1 + (350/1080*y), tocolor(255, 255, 255, w.sub.tA/255*w.sub.alpha), 1, iFont[14], "left", "center")
		dxDrawText("Password", x1 + (350/1920*x), y1 + (250/1080*y), x, y1 + (350/1080*y), tocolor(255, 255, 255, w.sub.tA/255*w.sub.alpha), 1, iFont[14], "left", "center")
		renderExecuteIcon()
	elseif w.sub.selected == 2 then
		dxDrawText("Username", x1, y1 + (250/1080*y), x, y1 + (350/1080*y), tocolor(255, 255, 255, w.sub.tA/255*w.sub.alpha), 1, iFont[14], "left", "center")
		dxDrawText("Password", x1 + (350/1920*x), y1 + (250/1080*y), x, y1 + (350/1080*y), tocolor(255, 255, 255, w.sub.tA/255*w.sub.alpha), 1, iFont[14], "left", "center")
		dxDrawText("Password", x1 + (700/1920*x), y1 + (250/1080*y), x, y1 + (350/1080*y), tocolor(255, 255, 255, w.sub.tA/255*w.sub.alpha), 1, iFont[14], "left", "center")
		renderExecuteIcon()
	elseif w.sub.selected == 3 then
		dxDrawText("Forgot your account name or password? No problem. Contact an admin at our teamspeak (ts.iRace-mta.de) or forum (iRace-mta.de)\nYour iRace-Team :)", x1, y1 + (250/1080*y), x, y1 + (350/1080*y), tocolor(255, 255, 255, w.sub.tA/255*w.sub.alpha), 1, iFont[14], "left", "center")
	end

	calcToday()
	dxDrawText(today.time, 0, w.sY+(50/1080*y), w.sX+(x/4), y, tocolor(255, 255, 255, w.wA), 1, iFontB[36], "right")
	dxDrawText(today.date, 0, w.sY+(113/1080*y), w.sX+(x/4), y, tocolor(255, 255, 255, w.wA), 1, iFont[12], "right")
    dxDrawText(w.errorMsg, 0, w.sY+(225/1080*y), w.sX+(x/4), y, tocolor(180, 0, 0, w.wA), 1, iFont[12], "right")

	leftClick = false
end

local function setWindowWidth(n)
	local t = {}
	local function render()
		local p = (getTickCount()-t.sT)/(t.eT-t.sT)
		w.w = interpolateBetween(t.s, 0, 0, t.e, 0, 0, p, "OutQuad")
		if p >= 1 then removeEventHandler("onClientRender", root, render) end
	end
	
	t.sT = getTickCount()
	t.eT = t.sT + 1250
	t.s = w.w
	t.e = n
	addEventHandler("onClientRender", root, render)
end

local function setWindowHeight(n)
	local t = {}
	local function render()
		local p = (getTickCount()-t.sT)/(t.eT-t.sT)
		w.h = interpolateBetween(t.s, 0, 0, t.e, 0, 0, p, "OutQuad")
		if p >= 1 then removeEventHandler("onClientRender", root, render) end
	end
	
	t.sT = getTickCount()
	t.eT = t.sT + 1250
	t.s = w.h
	t.e = n
	addEventHandler("onClientRender", root, render)
end

local function setWindowSX(n)
	local t = {}
	local function render()
		local p = (getTickCount()-t.sT)/(t.eT-t.sT)
		w.sX = interpolateBetween(t.s, 0, 0, t.e, 0, 0, p, "OutQuad")
		if p >= 1 then removeEventHandler("onClientRender", root, render) end
	end
	
	t.sT = getTickCount()
	t.eT = t.sT + 1250
	t.s = w.sX
	t.e = n
	addEventHandler("onClientRender", root, render)
end

local function setWindowSY(n)
	local t = {}
	local function render()
		local p = (getTickCount()-t.sT)/(t.eT-t.sT)
		w.sY = interpolateBetween(t.s, 0, 0, t.e, 0, 0, p, "OutQuad")
		if p >= 1 then removeEventHandler("onClientRender", root, render) end
	end
	
	t.sT = getTickCount()
	t.eT = t.sT + 1250
	t.s = w.sY
	t.e = n
	addEventHandler("onClientRender", root, render)
end

local function setWindowAlpha(n)
	local t = {}
	local function render()
		local p = (getTickCount()-t.sT)/(t.eT-t.sT)
		w.wA = interpolateBetween(t.s, 0, 0, t.e, 0, 0, p, "OutQuad")
		if p >= 1 then removeEventHandler("onClientRender", root, render) end
	end
	
	t.sT = getTickCount()
	t.eT = t.sT + 1250
	t.s = w.wA
	t.e = n
	addEventHandler("onClientRender", root, render)
end

local function setWindowSubAlpha(n)
	local t = {}
	local function render()
		local p = (getTickCount()-t.sT)/(t.eT-t.sT)
		w.sub.alpha = interpolateBetween(t.s, 0, 0, t.e, 0, 0, p, "OutQuad")
		if p >= 1 then removeEventHandler("onClientRender", root, render) end
	end
		
	t.sT = getTickCount()
	t.eT = t.sT + 2500
	t.s = w.sub.alpha
	t.e = n
	addEventHandler("onClientRender", root, render)
end

local edits = {}
function createGUIEdits(s)
    showErrorMessage("")
	for i, edit in ipairs(edits) do
		if isElement(edit) then
			destroyElement(edit)
		end
	end
	edits = {}
	
	local x1, y1 = x/4/1920*x, w.sY + (290/1080*y)
	if s == 1 then
		edits[1] = guiCreateEdit(x1 + dxGetTextWidth("Username", 1, iFont[14]) + 20, y1, 150/1920*x, 21/1080*y, "", false)
		edits[2] = guiCreateEdit(x1 + (370/1920*x) + dxGetTextWidth("Password", 1, iFont[14]), y1, 150/1920*x, 21/1080*y, "", false)
		guiEditSetMasked(edits[2], true)
        --guiBringToFront(edits[1])
	elseif s == 2 then
		edits[1] = guiCreateEdit(x1 + dxGetTextWidth("Username", 1, iFont[14]) + 20, y1, 150/1920*x, 21/1080*y, "", false)
		edits[2] = guiCreateEdit(x1 + (370/1920*x) + dxGetTextWidth("Password", 1, iFont[14]), y1, 150/1920*x, 21/1080*y, "", false)
		edits[3] = guiCreateEdit(x1 + (720/1920*x) + dxGetTextWidth("Password", 1, iFont[14]), y1, 150/1920*x, 21/1080*y, "", false)
		guiEditSetMasked(edits[2], true)
		guiEditSetMasked(edits[3], true)
        --guiBringToFront(edits[1])
	end
	guiSetInputMode("no_binds_when_editing")
end

function getSelectedGuiTexts(s)
	local temp = {}
	if s == 1 then
		temp[1] = guiGetText(edits[1])
		temp[2] = guiGetText(edits[2])
	elseif s == 2 then
		temp[1] = guiGetText(edits[1])
		temp[2] = guiGetText(edits[2])
		temp[3] = guiGetText(edits[3])
	end
	return temp
end

function showErrorMessage(msg)
    if msg ~= nil then
        w.errorMsg = msg
    end
end
addEvent("showErrorMessage", true)
addEventHandler("showErrorMessage", me , showErrorMessage)

--Background animations
local patterns = {}
local function splitAnimation(index, sx, sy, w, h)
	if not patterns[index].special then
		local tiles = math.random(2, 8)
		w, h = w/tiles, h/tiles
		for i = 1, tiles do
			local t = {file = patterns[index].file, sT = getTickCount(), eT = getTickCount() + math.random(1000, 3000), sPX = sx, sPY = sy, ePX = math.random(0, x), ePY = math.random(0, y), w = w, h = h, cr = patterns[index].cr, cg = patterns[index].cg, cb = patterns[index].cb, ca = patterns[index].ca, r = patterns[index].r, rotate = patterns[index].rotate, speed = patterns[index].speed, special = true, donut = patterns[index].donut}
			table.insert(patterns, t)
		end
		table.remove(patterns, index)
	else
		table.remove(patterns, index)
	end
end

local function renderBackground()
	dxDrawText("Particles: " .. #patterns, 0, 0, x, y, tocolor(255, 255, 255, w.wA), 1, iFont[12], "right", "top")
	for i, p in ipairs(patterns) do
		local progress = (getTickCount()-p.sT)/(p.eT-p.sT)
		
		local pX, pY = interpolateBetween(p.sPX, p.sPY, 0, p.ePX, p.ePY, 0, progress, "OutQuad")
		
		if fileExists("files/images/login/" .. p.file .. ".png") then
			dxDrawImage(pX, pY, p.w, p.h, "files/images/login/" .. p.file .. ".png", p.r, 0, 0, tocolor(p.cr, p.cg, p.cb, p.ca))
		end
		
		if p.rotate then p.r = p.r + p.speed end
		if p.setIn then p.ca = p.ca + 5 if p.ca == 180 then p.setIn = false end end
		if p.setOut then p.ca = p.ca - 5 if p.ca == 0 then p.terminated = true p.setOut = false end end
		if progress >= 0.8 and p.special and not p.setOut and not p.terminated then p.setOut = true end
		if progress >= 1 then splitAnimation(i, pX, pY, p.w, p.h) end
    end
end

local function isEaster(year, cMonth, cDay)
    local d = (19*(year%19)+24)%30
    local e = (2*(year%4)+4*(year%7)+6*d+5)%7
    local month, day = 0, 22+d+e


    if day <= 31 then month = 3 else month, day = 4, d+e-9 end
    if cMonth == month and (cDay >= day and cDay <= day + 7) then return true else return false end
end

local function getRandomImage()
    local time = getRealTime()

    if isEaster(time.year+1900, time.month+1, time.monthday) then return "egg" end
    if time.month == 1 and (time.monthday >= 10 and time.monthday <= 20) then return "love" end
    if time.month == 11 and (time.monthday >= 1 and time.monthday <= 26) then return "christmas" end
    if time.month == 9 and (time.monthday >= 24 and time.monthday <= 31) then return "halloween" end

    local p = math.random(1,100)
	if p <= 5 then
		return "donut"
	elseif p > 5 and p <= 60 then
		return "dot"
	elseif p > 60 and p <= 100 then
		return "pixel"
	end
end

local btnStDown = false
local addParticles = setTimer(function()
    if btnStDown then return end
	for _ = 1, math.random(1,15) do
		local t = {setIn = true, sT = getTickCount(), eT = getTickCount() + math.random(2500, 10000), speed = math.random(-3, 3), sPX = math.random(0, x), sPY = math.random(0, y), ePX = math.random(0, x), ePY = math.random(0,y), w = math.random(10, 50), h = math.random(10, 50), cr = math.random(0,255), cg = math.random(0,255), cb = math.random(0,255), ca = 0, rotate = false, r = 0}
		if math.random(1,2) == 1 then t.rotate = true end
		
		local file = getRandomImage()
		if file == "dot" then
			t.h = t.w
		elseif file == "donut" then
            local rs = math.random(28, 128)
			t.rotate = true
			t.cr, t.cg, t.cb, t.w, t.h = 255, 255, 255, rs, rs
        elseif file == "love" then
            local rs = math.random(28, 128)
            t.rotate = true
            t.cr, t.cg, t.cb, t.w, t.h = 255, 255, 255, rs, rs
        elseif file == "christmas" then
            local rs = math.random(28, 128)
            t.rotate = true
            t.cr, t.cg, t.cb, t.w, t.h = 255, 255, 255, rs, rs
        elseif file == "christmas" then
            local rs = math.random(28, 128)
            t.rotate = true
            t.cr, t.cg, t.cb, t.w, t.h = 255, 255, 255, rs, rs
        elseif file == "egg" then
            local rs = math.random(28, 128)
            t.rotate = true
            t.cr, t.cg, t.cb, t.w, t.h = 255, 255, 255, rs, rs
        elseif file == "halloween" then
            local rs = math.random(28, 128)
            t.rotate = true
            t.cr, t.cg, t.cb, t.w, t.h = 255, 255, 255, rs, rs
		end		
		t.file = file
		table.insert(patterns, t)
	end
end, 3000, -1)

local cTimer
function createClickPatterns()
	if not isCursorShowing(me) then if isTimer(cTimer) then killTimer(cTimer) end end
	
	for _ = 1, 5 do
		local ax, ay = getCursorPosition()
		local t = {file = "dot", sT = getTickCount(), eT = getTickCount() + math.random(1500, 2000), sPX = ax*x, sPY = ay*y, ePX = math.random(0, x), ePY = math.random(0,y), w = math.random(2, 6), rotate = false, r = 0, special = true}
		t.h = t.w
		local wColor = math.random(200, 255)
		t.cr, t.cg, t.cb, t.ca = wColor, wColor, wColor, 255
		table.insert(patterns, t)
	end
end

addEventHandler("onClientClick", root, function(btn, st)
	if btn == "left" and st == "down" then
		leftClick = true
		btnStDown = true

        if isTimer(addParticles) then
            createClickPatterns()
		    if not isTimer(cTimer) then cTimer = setTimer(createClickPatterns, 80, -1) end
		end
	else
		btnStDown = false if isTimer(cTimer) then killTimer(cTimer) end
	end
end)
--


addEventHandler("onClientResourceStart", resroot, function()
    showCursor(true)
    showChat(false)
    addEventHandler("onClientPreRender", root, renderBackground)
    addEventHandler("onClientPreRender", root, render)
    local height = 350/1080*y

    setTimer(function() setWindowSY(y/2-height/2) setWindowSX(0) setWindowHeight(50) setWindowWidth(50) end, 1500, 1)
    setTimer(function() setWindowWidth(x) setWindowAlpha(255) setWindowHeight(height) end, 2000, 1)
    setTimer(function() setWindowSubAlpha(255) end, 3500, 1)
    setTimer(function() createGUIEdits(1) addEventHandler("onClientKey", root, boundedKeys) end, 4500, 1)
    showPlayerHudComponent("all", false)
end)

addEvent("onClientSuccess", true)
addEventHandler("onClientSuccess", me, function()
    showCursor(false)
    showChat(true)
    createGUIEdits(0)
    removeEventHandler("onClientPreRender", root, render)
    removeEventHandler("onClientKey", root, boundedKeys)
    if isTimer(addParticles) then killTimer(addParticles) end
    setTimer(function() removeEventHandler("onClientPreRender", root, renderBackground) end, 20000,  1)
end) ]]

-- Init Webstuff and trigger Server

local checkDomainsTimer

function startLoginProcedure()
	showChat(false)
	killTimer(checkDomainsTimer)
	checkDomainsTimer = nil
	WebUIManager:new()
	triggerServerEvent("onClientFinishedLoading", getRootElement())
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		showChat(true)
		showPlayerHudComponent("all", false)
		
		-- Request Domains and stuff!
		requestBrowserDomains({
			"Please.press.remember.decision",
			"rewrite.rocks", 
			"www.pewx.de",
			
			--9gag
			"m.9gag.com",
			"t.9gag.com",
			"assets-comment-lol.9cache.com",
			"assets-9gag-ftw.9cache.com",
			"img-9gag-ftw.9cache.com",
		})
		
		showCursor(true)
		
		checkDomainsTimer = setTimer(
		function()
			if  not(isBrowserDomainBlocked ( "Please.press.remember.decision" )) then	
				startLoginProcedure()
			else
				outputChatBox("Please accept our requested domains! Otherwise you will not be able to play!", 255,0,0)
			end
		end, 500, 0)
		
	end
)

musicMuteTimer = false

addEvent("onServerRequestLoginRegister", true)
addEventHandler("onServerRequestLoginRegister", getRootElement(),
	function(accountName)

		local screenWidth, screenHeight = guiGetScreenSize()
		
		local bgs = {
			"http://rewrite.rocks/ir-gui/backgrounds/girls.html", --Nirvana - Girls
			"http://rewrite.rocks/ir-gui/backgrounds/particles1.html", --Particles animation
			"http://rewrite.rocks/ir-gui/backgrounds/particles2.html", --Particles audio visual 1
			--"http://rewrite.rocks/ir-gui/backgrounds/particles3.html", --Particles audio visual 2
			--"http://rewrite.rocks/ir-gui/backgrounds/equalizer1.html", --Ring equalizer
			"http://rewrite.rocks/ir-gui/backgrounds/equalizer2.html", --particle equalizer
			"http://rewrite.rocks/ir-gui/backgrounds/fastnfurious.html", --fast n furious dubstep montage		
		}

		local url = bgs[math.random(1, #bgs)]

		local bg = WebWindow:new(Vector2(0, 0), Vector2(screenWidth, screenHeight), url, false)
		bg.m_Background = true

		
		local width, height = 430, 500
		
		local window = false
		
		if (accountName) then
			window = WebWindow:new(Vector2(screenWidth/2-width/2, screenHeight/2-height/2), Vector2(width, height), "files/html/login.html", true)
		else
			window = WebWindow:new(Vector2(screenWidth/2-width/2, screenHeight/2-height/2), Vector2(width, height), "files/html/register.html", true)
		end

		
		addEvent("onCEFLoginRegister")
			addEventHandler("onCEFLoginRegister", window:getUnderlyingBrowser(),
				function(username, password, passwordrepeat)
					if (passwordrepeat) then
						clientExecute(2, {username, password, passwordrepeat})
					else
						clientExecute(1, {username, password})
					end
				end
		)
		
		addEvent("onClientSuccess", true)
		addEventHandler("onClientSuccess", me, 
			function()
				resumeAllSounds()
				showCursor(false)
				showChat(true)
				window:destroy()
				bg:destroy()
			end
		)
		
		local function showErrorMessage(msg)
			if msg ~= nil then
				window:getUnderlyingBrowser():executeJavascript("$('.errortext').text('"..msg.."');")
			end
		end
		addEvent("showErrorMessage", true)
		addEventHandler("showErrorMessage", me , showErrorMessage)
		
		showCursor(true)
		
		musicMuteTimer = setTimer(stopAllSounds, 1000, 0)
	end
)

function stopAllSounds() 
	for k,v in ipairs(getElementsByType("sound")) do
		if (getSoundVolume(v) > 0) then
			setElementData(v, "prevvol", getSoundVolume(v))
		end
		setSoundVolume(v,0)
	end
end

function resumeAllSounds() 
	if (musicMuteTimer) and (isTimer(musicMuteTimer)) then
		killTimer(musicMuteTimer)
		musicMuteTimer = false
		for k,v in ipairs(getElementsByType("sound")) do
			if (getElementData(v, "prevvol") and getElementData(v, "prevvol") > 0) then
				setSoundVolume(v,getElementData(v, "prevvol"))
			end
		end
	end
end