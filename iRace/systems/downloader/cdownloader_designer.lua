--iR|HorrorClown (PewX) - iRace-mta.de - 07.06.2014--
local w, h = 500, 60
local x1, y1 = x/2-w/2, y - 200

local function renderDownloadProgress()
	local index, item, maxFiles = getDownloadState()
	dxDrawWindow(x1, y1, w, h, "Download (" .. math.round(100/maxFiles*index) .. "%)")
	
	dxDrawRectangle(x1 + 5, y1 + 25, (w-10)/maxFiles*index, 30, tocolor(255, 100, 0, 80))
	dxDrawLine(x1 + 5, y1 + 25, x1 + 5 + (w-10)/maxFiles*index, y1 + 25, tocolor(255, 80, 0, 120), 2)
	dxDrawLine(x1 + 5, y1 + 54, x1 + 5 + (w-10)/maxFiles*index, y1 + 54, tocolor(255, 80, 0, 120), 2)
	dxDrawText("[" .. item .. "]", x1, y1 + 20, x1 + w, y1 + h, tocolor(255, 255, 255, 120), 1, iFont[11], "center", "center")
end

addEvent("onClientStartDownload", true)
addEventHandler("onClientStartDownload", me, function(tFiles)
	addEventHandler("onClientRender", root, renderDownloadProgress)
end)

function downloadFinished()
	removeEventHandler("onClientRender", root, renderDownloadProgress)
end