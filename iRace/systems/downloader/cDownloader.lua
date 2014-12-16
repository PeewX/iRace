--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 26.07.2014 - Time: 17:27
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local fileTable = {}
local mods = {}

local function insertingMod(filePath, src)
	local s = string.find(src, "/")+1
	local e = string.find(src, ".", s, true)
	local ID = string.sub(src, s, e-1)
	local typ = string.sub(src, e+1, #src)
	table.insert(mods, {ID = ID, path = filePath, typ = typ})
end

local function loadMods()
	for i, mT in ipairs(mods) do
		if mT.typ == "col" then
			local col = engineLoadCOL(mT.path)
			engineReplaceCOL(col, mT.ID)
		elseif mT.typ == "dff" then	
			local dff = engineLoadDFF(mT.path, 0)
			engineReplaceModel (dff, mT.ID)
			engineSetModelLODDistance(mT.ID, 500)
		elseif mT.typ == "txd" then
			local txd = engineLoadTXD (mT.path)
			engineImportTXD(txd, mT.ID)
		end
	end
end

local sT = 0
local function getFiles()
	local xml = xmlLoadFile("shared/files.xml")
	local fileDirs = xmlNodeGetChildren(xml)
	
	for _, dir in ipairs(fileDirs) do
		local dirName = xmlNodeGetName(dir)
		local files = xmlNodeGetChildren(dir)
		for _, file in ipairs(files) do
			local src = xmlNodeGetAttribute(file, "src")
			local filePath = "files/" .. dirName .. "/" .. src
			if dirName == "skins" or dirName == "mods" then insertingMod(filePath, src) end
			
			if fileExists(filePath) then
				local file = fileOpen(filePath, true)
				table.insert(fileTable, {hash = md5(fileGetSize(file)), path = filePath})
				fileClose(file)
			else
				table.insert(fileTable, {hash = 0, path = filePath})
			end
		end
	end
	
	triggerServerEvent("onClientCheckFiles", me, fileTable)
end
addEventHandler("onClientResourceStart", resroot, getFiles)

local dlIndex, maxFiles, dlItem = 0, 0, ""
addEvent("onClientDownloadFile", true)
addEventHandler("onClientDownloadFile", me, function(file, path, index, mF)
	dlIndex, maxFiles, dlItem = index, mF, path
	local f = fileCreate(path) fileWrite(f, file) fileClose(f)
	
	if index == maxFiles then
		dlItem = "Finished"
		setTimer(downloadFinished, 5000, 1)
		setTimer(loadMods, 10000, 1)
        triggerEvent("onDownloadFinished", resroot)
	end
end)

addEvent("onClientFilesValid", true)
addEventHandler("onClientFilesValid", me, function()
	setTimer(loadMods, 10000, 1)
    triggerEvent("onDownloadFinished", resroot)
end)

function getDownloadState()
	return dlIndex, dlItem, maxFiles
end