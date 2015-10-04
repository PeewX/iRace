iDEBUG = true

function debugOutput(sText, nType, cr, cg, cb)
	if iDEBUG then
		outputDebugString(("[%s] %s"):format(SERVER and "Server" or "Client", tostring(sText)), nType or 3, cr, cg, cb)
	end
end

function toboolean(x)
	if x == "true" or x == 1 or x == "1" or x == true then
		return true
	elseif x == "false" or x == 0 or x == "0" or x == false then
		return false
	end
	return false
end

function removeColorCodes(text)
    return string.gsub(text or "", "#%x%x%x%x%x%x", "")
end

function table.random (theTable)
    return theTable[math.random (#theTable)]
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function rgbToHex(r, g, b, a, af) --if af true, then alpha is forwarded aarrggbb and not rrggbbaa
    if ((r < 0 or r > 255 or g < 0 or g > 255 or b < 0 or b > 255) or (a and (a < 0 or a > 255))) then return end
    if af then return ("%.2X%.2X%.2X%.2X"):format(a,r,g,b) end
    if a then return ("%.2X%.2X%.2X%.2X"):format(r,g,b,a) else return ("%.2X%.2X%.2X"):format(r,g,b,a) end
end

function roundTime(value)
    if value then
        local time = getRealTime(value)
        local yearday = time.yearday
        local hours = time.hour
        local minutes = time.minute
        return hours-1+(yearday*24)..":"..minutes
    end
    return false
end

local function includeZero(n) if #tostring(n) == 1 then return "0"..n end return n end
local m = {[1] = "02", [2] = "03", [3] = "04", [4] = "05", [5] = "06", [6] = "07", [7] = "08", [8] = "09", [9] = "10", [10] = "11", [11] = "12", [0] = "01", }
local function getMonth(n) return m[n] end

function getRealTimeString(ts)
    local time = getRealTime(ts)
    return ("%s.%s.%s - %s:%s"):format(includeZero(time.monthday), getMonth(time.month), time.year + 1900, includeZero(time.hour), includeZero(time.minute))
end

local month = {"January","February","March","April","May","June","Juli","August","September","October","November","December"}
function timestampToDate(stamp)
	local time = getRealTime(stamp)
	return string.format("%d %s %02d:%02d",time.monthday,month[time.month+1],time.hour,time.minute)
end

function msToTimeString(ms)
	if not ms then return '' end
	return string.format("%01d:%02d:%03d", ms/1000/60, math.fmod(ms/1000, 60), math.fmod(ms, 1000))
end

--[[
function getPlayerFromNamePart(namePart)
    if not namePart then return false end
    namePart = string.lower(namePart)

    local bestaccuracy = 0
    local foundPlayer, b, e
    for _,player in ipairs(getElementsByType("player")) do
        b,e = string.find(string.lower(string.gsub(getPlayerName(player), "#%x%x%x%x%x%x", "")), namePart)
        if b and e then
            if e-b > bestaccuracy then
                bestaccuracy = e-b
                foundPlayer = player
            end
        end
    end

    if (foundPlayer) then
        return foundPlayer
    else
        return false
    end
end
]]

-- Another algorithm to find a player by namepart. Limited to 1 player. Returns flase otherwise.
function getPlayerFromNamePart(name)
	local found = {}
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                table.insert(found, player)
            end
        end
    end
	if (#found == 1) then
		return found[1]
	else
		return false
	end
end

local presets = {{[true] = "#00ff00enabled", [false] = "#ff0000disabled"}}
function returnStringFromBool(b, s1, s2)
    if s1 == "preset" then return presets[s2][toboolean(b)] end
    if toboolean(b) then return s1 else return s2 end
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
	if 	type( sEventName ) == 'string' and 	isElement( pElementAttachedTo ) and type( func ) == 'function' 	then
		local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
		if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
			for _, v in ipairs( aAttachedFunctions ) do
				if v == func then
					return true
				end
			end
		end
	end
 
	return false
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function getVehicleSpeed(theVehicle)
	if isElement(theVehicle) then
		local x, y, z = getElementVelocity(theVehicle)
		return ((x^2 + y^2 + z^2)^(0.5))* 180
	else
		return false
	end
end

function convertNumber(number)
    local formatted, k = number
	while k~=0 do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
		if ( k==0 ) then
            break
		end
    end
    return formatted
end

function secondsToTimeDesc( seconds )
	if seconds then
		local days = 0
		local hours = 0
		local minutes = 0
		local secs = 0
		local theseconds = seconds
		if theseconds >= 60*60*24 then
			days = math.floor(theseconds / (60*60*24))
			theseconds = theseconds - ((60*60*24)*days)
		end
		if theseconds >= 60*60 then
			hours = math.floor(theseconds / (60*60))
			theseconds = theseconds - ((60*60)*hours)
		end
		if theseconds >= 60 then
			minutes = math.floor(theseconds / (60))
			theseconds = theseconds - ((60)*minutes)
		end
		if theseconds >= 1 then
			secs = theseconds
			theseconds = theseconds - theseconds
		end
		local results = {}
		if days > 1 then table.insert(results, days.." days") end
		if days == 1 then table.insert(results, days.." day") end
		if hours > 1 then table.insert(results, hours.." hours") end
		if hours == 1 then table.insert(results, hours.." hour") end
		if minutes > 1 then table.insert(results, minutes.." minutes") end
		if minutes == 1 then table.insert(results, minutes.." minute") end
		if secs > 1 then table.insert(results, secs.." seconds") end
		if secs == 1 then table.insert(results, secs.." second") end
		if seconds == 0 then table.insert(results, "0 seconds") end
		return table.concat(results, ", "):reverse():gsub((", "):reverse(), (" and "):reverse(), 1):reverse()
	end
	return "*INVALID ARGUMENTS IN [secondsToTimeDesc]*"
end

local aircraft = {592, 577, 511, 548, 512,593, 425, 520, 417, 487, 553, 488, 497, 563, 476, 447, 519, 460, 469, 513}
function isAircraft(theVehicle)
    if isElement(theVehicle) then
        local theModel = getElementModel(theVehicle)
        for _, model in ipairs(aircraft) do
            if model == theModel then
                return true
            end
        end
    end
    return false
end