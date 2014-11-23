--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 29.07.2014 - Time: 20:45
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local map = {}

--local validTypes = {"DD", "DM", "HUNTER", "SHOOTER"}
local function updateMapType(mapinfo)
    map.resName = mapinfo.resname
    map.name = mapinfo.name
	
	map.current = getMapTypeByName(map.name)
	if not map.current then
		map.current = getMapTypeByName(map.resName)
		if not map.current then
			outputChatBox("WARNING: Map type is undefined. Please add a valid map prefix to resource name!", root, 255, 0, 0)
		end
	end
	
    --[[if tostring(string.find(string.upper(map.resName), "DD", 1, true)) ~= "nil" then
        map.current = "DD"
    elseif tostring(string.find(string.upper(map.resName), "DM", 1, true)) ~= "nil" then
        map.current = "DM"
    elseif tostring(string.find(string.upper(map.resName), "HUNTER", 1, true)) ~= "nil" then
        map.current = "HUNTER"
    elseif tostring(string.find(string.upper(map.resName), "SHOOTER", 1, true)) ~= "nil" then
        map.current = "SHOOTER"
    else
        outputChatBox("WARNING: Map type is undefined. Please add the right map prefix to resource name!", root, 255, 0, 0)
    end]]

    triggerClientEvent("onServerSendMapType", root, map.current)
    triggerEvent("onServerGotMapType", resroot)
end
addEvent("onMapStarting")
addEventHandler("onMapStarting",getRootElement(),updateMapType)

local mapTypes = {"DM", "DD", "SHOOTER", "HUNTER"}
function getMapTypeByName(mapName)
	if not mapName then return false end
	for _, t in ipairs(mapTypes) do
		if string.find(string.upper(mapName:sub(1, string.len(t)+2)), t, 1, true) then
			return t
		end
	end
	return false
end


--[[function getMapTypeByName(mapName)
    if mapName then
        if tostring(string.find(string.upper(mapName), "DD", 1, true)) ~= "nil" then
            return "DD"
        elseif tostring(string.find(string.upper(mapName), "DM", 1, true)) ~= "nil" then
            return "DM"
        elseif tostring(string.find(string.upper(mapName), "HUNTER", 1, true)) ~= "nil" then
            return "HUNTER"
        elseif tostring(string.find(string.upper(mapName), "SHOOTER", 1, true)) ~= "nil" then
            return "SHOOTER"
        else
            return false
        end
    else
        return nil
    end
end]]

function isMapType(typ)
    return map.current == typ
end

function getCurrentMapName()
    return map.name
end

function getCurrentMapType()
    return map.current
end