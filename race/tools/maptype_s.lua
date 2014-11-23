g_Maptype = "n/A"

function getCurrentMapType()
	local map = getMapName (exports.mapmanager:getRunningGamemodeMap())
	if string.find(string.upper(map), "[DM]", 1, true) then
		g_Maptype = "DM"
	elseif string.find(string.upper(map), "[DD]", 1, true) then
		g_Maptype = "DD"
	elseif string.find(string.upper(map), "[FUN]", 1, true) then
		g_Maptype = "FUN"
	elseif string.find(string.upper(map), "[RACE]", 1, true) then
		g_Maptype = "RACE"
	elseif string.find(string.upper(map), "[SHOOTER]", 1, true) then
		g_Maptype = "SHOOTER"
	end
end
addEvent("onMapStarting",true)
addEventHandler("onMapStarting", getRootElement(), getCurrentMapType)
