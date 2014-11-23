--iR|HorrorClown (PewX) - iRace-mta.de - 05.06.2014--
root, resroot, me = getRootElement(), getResourceRootElement(), getLocalPlayer()
x, y = guiGetScreenSize()

iFont = {}
iFontB = {}
addEventHandler("onClientResourceStart", resroot, function()
	for i = 8, 36 do
		iFont[i] = dxCreateFont("files/fonts/calibrii.ttf", i/1080*y, false)
		iFontB[i] = dxCreateFont("files/fonts/calibrii.ttf", i/1080*y, true)
	end
end)

function isHover(startX, startY, width, height)
	if isCursorShowing() then
		assert(type(startX) and type(startY) and type(width) and type(height) == "number", "Bad Argument @isHover [Expected number]")
		local pos = {getCursorPosition()}
		return (x*pos[1] >= startX) and (x*pos[1] <= startX + width) and (y*pos[2] >= startY) and (y*pos[2] <= startY + height)
	end
	return false
end

function dxDrawDoubleLine(lx, ly, lwidth)
	ly, lx, lwidth = math.floor(ly), math.floor(lx), math.floor(lwidth)
	dxDrawLine(lx, ly, lx+lwidth, ly, tocolor(20, 20, 20, 255), 1)
	dxDrawLine(lx, ly+1, lx+lwidth, ly+1, tocolor(100, 100, 100, 255), 1)
end

function dxDrawDoubleLineR(lx, ly, lwidth)
	ly, lx, lwidth = math.floor(ly), math.floor(lx), math.floor(lwidth)
	dxDrawLine(lx, ly+1, lx+lwidth, ly+1, tocolor(20, 20, 20, 255), 1)
	dxDrawLine(lx, ly, lx+lwidth, ly, tocolor(100, 100, 100, 255), 1)
end

function dxDrawWindow(sx, sy, width, height, title, close, aFunction)
	dxDrawRectangle(sx, sy, width, height, tocolor(0, 0, 0, 160))
	dxDrawRectangle(sx, sy, width, 20, tocolor(255, 80, 0))
	dxDrawText(title, sx, sy, sx + width, sy + 20, tocolor(255, 255, 255), 1, iFont[11], "center", "center")
	dxDrawDoubleLine(sx, sy + 20, width)
	
	--Close
	if close then if isHover(sx + width - 18, sy + 2, 16, 16) then dxDrawImage(sx + width - 18, sy + 2, 16, 16, "files/images/gui/close.png", 0, 0, 0, tocolor(0, 0, 0)) if click then aFunction() end else dxDrawImage(sx + width - 18, sy + 2, 16, 16, "files/images/gui/close.png", 0, 0, 0, tocolor(50, 50, 50))	end	end
end

function dxDrawImageBOB(x, y, w, h, img, c)
    local duration, degree, tickCount, secs = 3000, 45, getTickCount()
    if (tickCount%duration < duration/2) then if (tickCount%duration < duration/4) then secs = (tickCount%(duration/2)*(degree/(duration/2))) else secs = degree-(tickCount%(duration/2)*(degree/(duration/2))) end else if (tickCount%duration < 3*duration/4) then secs = 360-(tickCount%(duration/2)*(degree/(duration/2))) else secs = (360-degree)+(tickCount%(duration/2)*(degree/(duration/2))) end end
    dxDrawImage(x, y, w, h, img, secs, 0, 0, c)
end

--Syntax: moveCamera(startX, startY, startZ, startLookX, startLookY, startLookZ, endX, endY, endZ, endLookX, endLookY, endLookZ, length [ms])
--To continue a next camera use addMoveCamera(endX, endY, endZ, endLookX, endLookY, endLookZ, length [ms])
local cMove = {}
local function moveCameraRender()
	for i, move in pairs(cMove) do
		if not move.sub then
			local x1, y1, z1 = getElementPosition(move.ob1)
			local x2, y2, z2 = getElementPosition(move.ob2)
			setCameraMatrix(x1, y1, z1, x2, y2, z2)
			if getTickCount() >= move.e then destroyElement(move.ob1) destroyElement(move.ob2) cMove[i] = nil end
		elseif move.sub then
			if getTickCount() >= move.s then
				if not move.move then
					move.move = true
					local ep1, ep2, ep3 = unpack(move.endPos)
					local epl1, epl2, epl3 = unpack(move.endPosl)
					moveObject(move.ob1, move.e - move.s, ep1, ep2, ep3, 0, 0, 0, move.easing)
					moveObject(move.ob2, move.e - move.s, epl1, epl2, epl3, 0, 0, 0, move.easing)
				end
				local x1, y1, z1 = getElementPosition(move.ob1)
				local x2, y2, z2 = getElementPosition(move.ob2)
				setCameraMatrix(x1, y1, z1, x2, y2, z2)
				if getTickCount() >= move.e then destroyElement(move.ob1) destroyElement(move.ob2) cMove[i] = nil end
			end
		end
	end
end
addEventHandler("onClientPreRender", root, moveCameraRender)

function moveCamera(x1, y1, z1, x1look, y1look, z1look, x2, y2, z2, x2look, y2look, z2look, length, easing)
	if #cMove ~= 0 then return false end
	local id = #cMove + 1
	cMove[id] = {}
	cMove[id].ob1 = createObject(1337, x1, y1, z1)
	cMove[id].ob2 = createObject(1337, x1look, y1look, z1look)
	cMove[id].endPos = {x2, y2, z2}
	cMove[id].endPosl = {x2look, y2look, z2look}
	cMove[id].e = getTickCount() + length
	cMove[id].easing = easing or "InOutQuad"
	
	setObjectScale(cMove[id].ob1, 0)
	setObjectScale(cMove[id].ob2, 0)
	
	moveObject(cMove[id].ob1, length, x2, y2, z2, 0, 0, 0, cMove[id].easing)
	moveObject(cMove[id].ob2, length, x2look, y2look, z2look, 0, 0, 0, cMove[id].easing)
	return true
end

function addMoveCamera(x, y, z, xlook, ylook, zlook, length, easing)
	local parent = #cMove
	local id = #cMove + 1
	cMove[id] = {}
	cMove[id].sub = true
	cMove[id].move = false
	cMove[id].ob1 = createObject(1337, unpack(cMove[parent].endPos))
	cMove[id].ob2 = createObject(1337, unpack(cMove[parent].endPosl))
	cMove[id].endPos = {x, y, z}
	cMove[id].endPosl = {xlook, ylook, zlook}
	cMove[id].s = cMove[parent].e
	cMove[id].e = cMove[parent].e + length
	cMove[id].easing = easing or "InOutQuad"

	setObjectScale(cMove[id].ob1, 0)
	setObjectScale(cMove[id].ob2, 0)
	return true
end

function stopMoveCamera()
	cMove = {}
end