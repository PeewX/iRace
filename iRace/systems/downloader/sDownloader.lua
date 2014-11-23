--iR|HorrorClown (PewX) - iRace-mta.de - 05.06.2014--
local fileTable = {}

local function getFiles()
	local xml = xmlLoadFile("shared/files.xml")
	local fileDirs = xmlNodeGetChildren(xml)
	
	for _, dir in ipairs(fileDirs) do
		local dirName = xmlNodeGetName(dir)
		local files = xmlNodeGetChildren(dir)
		for _, file in ipairs(files) do
			local src = xmlNodeGetAttribute(file, "src")
			local filePath = "files/" .. dirName .. "/" .. src
			
			if fileExists(filePath) then
				local file = fileOpen(filePath, true)
				table.insert(fileTable, {file = fileRead(file, fileGetSize(file)), hash = md5(fileGetSize(file)), path = filePath})
				fileClose(file)
			else
				outputChatBox("Server: " .. filePath .. ": #ff0000not found!", root, 255, 255, 255, true)
			end
		end
	end
	
	xmlUnloadFile(xml)
end
addEventHandler("onResourceStart", resroot, getFiles)

addEvent("onClientCheckFiles", true)
addEventHandler("onClientCheckFiles", root, function(fTable)
	local neededFiles = {}
	
	for i, file in ipairs(fTable) do
		for i, sFile in ipairs(fileTable) do
			if sFile.path == file.path then
				if sFile.hash ~= file.hash then
					table.insert(neededFiles, {path = sFile.path, file = sFile.file})
				end
			end
		end
	end
	
	if #neededFiles ~= 0 then
		triggerClientEvent(client, "onClientStartDownload", client)
		
		for i, file in ipairs(neededFiles) do
			triggerLatentClientEvent(client, "onClientDownloadFile", 10000000, false, client, file.file, file.path, i, #neededFiles) --1MB = 1 048 576
		end
	else
		triggerClientEvent(client, "onClientFilesValid", client)
	end
end)