--
-- racemidvote_server.lua
--
-- Mid-race random map vote and
-- NextMapVote handled in this file
--

local lastVoteStarterName = ''
local lastVoteStarterCount = 0
local nextmapbought = false
local mapRedo = false
local voteRedo = false
local g_ForcedNextMap


local function sendMapInformations()
	if not isMapmanagerAvailable() then return end

	local nextMapName = getNextMap()
	for _, p in ipairs(getElementsByType"player") do
		triggerClientEvent(p, "onServerSendNextMapName", p, nextMapName)
	end
end

----------------------------------------------------------------------------
-- displayHilariarseMessage
--
-- Comedy gold
----------------------------------------------------------------------------

function getAdminLevel (player)
	if player then
		local pname = getAccountName(getPlayerAccount(player))
		if pname then
			if isObjectInACLGroup("user."..pname, aclGetGroup("Projektleiter")) then
				return 5
			elseif isObjectInACLGroup("user."..pname, aclGetGroup("Admin")) then
				return 4
			elseif isObjectInACLGroup("user."..pname, aclGetGroup("Moderator")) then
				return 3
			elseif isObjectInACLGroup("user."..pname, aclGetGroup("Supporter")) then
				return 2
			elseif isObjectInACLGroup("user."..pname, aclGetGroup("Member")) then
				return 1
			else 
				return 0
			end
		end
	end
	return false
end

----------------------------------------------------------------------------
-- displayKillerPunchLine
--
-- Sewing kits available in the foyer
----------------------------------------------------------------------------
function displayKillerPunchLine( player )
	if lastVoteStarterName ~= '' then
		outputRace( 'Offical news: Everybody hates ' .. lastVoteStarterName )
	end
end


----------------------------------------------------------------------------
-- startMidMapVoteForRandomMap
--
-- Start the vote menu if during a race and more than 30 seconds from the end
-- No messages if this was not started by a player
----------------------------------------------------------------------------



----------------------------------------------------------------------------
-- event midMapVoteResult
--
-- Called from the votemanager when the poll has completed
----------------------------------------------------------------------------
addEvent('midMapVoteResult')
addEventHandler('midMapVoteResult', getRootElement(),
	function( votedYes,map )
		-- Change state back
			gotoState('Running')
			if votedYes then
			local query = votemapnext
			local map, errormsg = findMap( query )
				g_ForcedNextMap = map
				sendMapInformations()
			else
				displayKillerPunchLine()
			end
	end
)



----------------------------------------------------------------------------
-- startRandomMap
--
-- Changes the current map to a random race map
----------------------------------------------------------------------------

function startRandomMap(skipNextMap)
	-- Handle forced nextmap setting
	if not skipNextMap then
        if g_ForcedNextMap then
			if voteRedo then
				local currentMap = exports.mapmanager:getRunningGamemodeMap()
				exports.mapmanager:changeGamemodeMap(currentMap, nil, true)
				return
			end
            if exports.mapmanager:changeGamemodeMap(g_ForcedNextMap, nil, true) then
                g_IgnoreSpawnCountProblems = g_ForcedNextMap	                        -- Todo: Check that.. confused o.O
                g_ForcedNextMap = nil
                return
            else
                outputChatBox("|Race| Error while start next map..", g_Root, 255, 0, 0)
            end
        end
    end

    local map = getRandomMapCompatibleWithGamemode(getThisResource())
	if map then
		g_IgnoreSpawnCountProblems = map	-- Uber hack 4000
		if not exports.mapmanager:changeGamemodeMap(map, nil, true) then
			problemChangingMap()
		end
	else
        outputChatBox("|Race| Error while start random map..", g_Root, 255, 0, 0)
	end
end

addEvent("onVoteRedoSuccess")
addEventHandler("onVoteRedoSuccess", root,
	function()
		voteRedo = true
	end
)
----------------------------------------------------------------------------
-- outputRace
--
-- Race color is defined in the settings
----------------------------------------------------------------------------
function outputRace(message, toElement)
	toElement = toElement or g_Root
	local r, g, b = getColorFromString(string.upper(get("color")))
	if getElementType(toElement) == 'console' then
		outputServerLog(message)
	else
		if toElement == rootElement then
			outputServerLog(message)
		end
		if getElementType(toElement) == 'player' then
			message = '[PM] ' .. message
		end
		outputChatBox(message, toElement, r, g, b)
	end
end


----------------------------------------------------------------------------
-- problemChangingMap
--
-- Sort it
----------------------------------------------------------------------------
function problemChangingMap()
	outputRace( 'Changing to random map in 5 seconds' )
	local currentMap = exports.mapmanager:getRunningGamemodeMap()
	TimerManager.createTimerFor("resource","mapproblem"):setTimer(
        function()
			-- Check that something else hasn't already changed the map
			if currentMap == exports.mapmanager:getRunningGamemodeMap() then
	            startRandomMap()
			end
        end,
        math.random(4500,5500), 1 )
end



--
--
-- NextMapVote

function startNextMapVote()

	exports.votemanager:stopPoll()

	-- Handle forced nextmap setting
    startRandomMap()

	-- Get all maps
	local compatibleMaps = exports.mapmanager:getMapsCompatibleWithGamemode(getThisResource())
	
	-- limit it to eight random maps
	if #compatibleMaps > 8 then
		math.randomseed(getTickCount())
		repeat
			table.remove(compatibleMaps, math.random(1, #compatibleMaps))
		until #compatibleMaps == 8
	elseif #compatibleMaps < 2 then
		return false, errorCode.onlyOneCompatibleMap
	end

	-- mix up the list order
	for i,map in ipairs(compatibleMaps) do
		local swapWith = math.random(1, #compatibleMaps)
		local temp = compatibleMaps[i]
		compatibleMaps[i] = compatibleMaps[swapWith]
		compatibleMaps[swapWith] = temp
	end
	
	local poll = {
		title="Choose the next map:",
		visibleTo=getRootElement(),
		percentage=51,
		timeout=15,
		allowchange=true;
		}
	
	for index, map in ipairs(compatibleMaps) do
		local mapName = getResourceInfo(map, "name") or getResourceName(map)
		table.insert(poll, {mapName, 'nextMapVoteResult', getRootElement(), map})
	end
	
	local currentMap = exports.mapmanager:getRunningGamemodeMap()
	--if currentMap then
		--table.insert(poll, {"^^", 'nextMapVoteResult', getRootElement(), currentMap})
	--end

	-- Allow addons to modify the poll
	g_Poll = poll
	triggerEvent('onPollStarting', g_Root, poll )
	poll = g_Poll
	g_Poll = nil

	local pollDidStart = exports.votemanager:startPoll(poll)

	if pollDidStart then
		gotoState('NextMapVote')
		addEventHandler("onPollEnd", getRootElement(), chooseRandomMap)
	end

	return pollDidStart
end
--
--
--

local g_Poll

----------------------------------------------------------------------------
-- startNextMapVote
--
-- Start a votemap for the next map. Should only be called during the
-- race state 'NextMapSelect'
----------------------------------------------------------------------------
local eventTime = false
function toggleEventTime(state)
	eventTime = state
end
addEvent("toggleRaceEventTime")
addEventHandler("toggleRaceEventTime", getRootElement(), toggleEventTime)

function nextmapsetauto()
	if voteRedo then voteRedo = false return end
	if mapRedo then mapRedo = false return end
    if eventTime then return end

    local map = getRandomMapCompatibleWithGamemode(getThisResource())
    g_ForcedNextMap = map
    nextmapbought = false

	sendMapInformations()
end
addEvent("onMapStarting",true)
addEventHandler ( "onMapStarting", getRootElement(), nextmapsetauto )

-- Used by addons in response to onPollStarting
addEvent('onPollModified')
addEventHandler('onPollModified', getRootElement(),
	function( poll )
		g_Poll = poll
	end
)


function chooseRandomMap (chosen)
	if not chosen then
		cancelEvent()
		math.randomseed(getTickCount())
		exports.votemanager:finishPoll(1)
	end
	removeEventHandler("onPollEnd", getRootElement(), chooseRandomMap)
end



----------------------------------------------------------------------------
-- event nextMapVoteResult
--
-- Called from the votemanager when the poll has completed
----------------------------------------------------------------------------
addEvent('nextMapVoteResult')
addEventHandler('nextMapVoteResult', getRootElement(),
	function( map )
		if stateAllowsNextMapVoteResult() then
			if not exports.mapmanager:changeGamemodeMap ( map, nil, true ) then
				problemChangingMap()
			end
		end
	end
)



----------------------------------------------------------------------------
-- startMidMapVoteForRestartMap
--
-- Start the vote menu to restart the current map if during a race
-- No messages if this was not started by a player
----------------------------------------------------------------------------


----------------------------------------------------------------------------
-- event midMapRestartVoteResult
--
-- Called from the votemanager when the poll has completed
----------------------------------------------------------------------------
addEvent('midMapRestartVoteResult')
addEventHandler('midMapRestartVoteResult', getRootElement(),
	function( votedYes )
		-- Change state back
		if stateAllowsRandomMapVoteResult() then
			gotoState('Running')
			if votedYes then
					local query = votemapnext
					local map, errormsg = findMap( query )
					g_ForcedNextMap = map
					nextmapbought = true

					sendMapInformations()
					outputChatBox("|Vote| "..getMapName( g_ForcedNextMap ).." #00FF00was set as nextmap. ",g_Root,255,255,255,true)
			else
				local query = votemapnext
				local map, errormsg = findMap( query )	
				outputChatBox("[Vote] "..getMapName( map ).." #00FF00was #FF0000not #00FF00set as nextmap. ",g_Root,255,255,255,true)
			end
		end
	end
)

addCommandHandler('redo',
	function(player)
		if hasObjectPermissionTo ( player, "function.redo", false ) then
            --if eventTime then outputChatBox("|Event| You can't change the map while an event is running", player, 255, 0, 0) return end
            local currentMap = exports.mapmanager:getRunningGamemodeMap()
			if currentMap then
                mapRedo = true
				outputChatBox('|Info| #00FF11Current Map restarted by #FFFFFF' .. getPlayerName(player), g_Root, 255, 255, 255,true)
				if not exports.mapmanager:changeGamemodeMap (currentMap, nil, true) then
					problemChangingMap()
				end
			else
				outputRace("You can't restart the map because no map is running", player)
			end
		else
			--outputRace("You are not an Admin", player)
		end
	end
)


addCommandHandler('random',
	function(player)
        --if eventTime then outputChatBox("|Event| You can't change the map while an event is running", player, 255, 0, 0) return end
		if hasObjectPermissionTo ( player, "function.random", false ) then
			if not stateAllowsRandomMapVote() or g_CurrentRaceMode:getTimeRemaining() < 1000 then
				outputRace( "Random command only works during a race and when no polls are running.", player )
			else
                triggerClientEvent("addClientMessage", g_Root, ("|Map| A random map was started by %s"):format(getPlayerName(player)), 255, 255, 255, "map")
				startRandomMap(true)
			end
		end
	end
)



---------------------------------------------------------------------------
--
-- getRandomMapCompatibleWithGamemode 
--
-- This should go in mapmanager, but ACL needs doing
--
---------------------------------------------------------------------------

addEventHandler('onResourceStop', getRootElement(),
	function( res )
		if exports.mapmanager:isMap( res ) then
			setMapLastTimePlayed( res )
        elseif getResourceName(res) == "irace" then
            eventTime = false
            outputChatBox("iRace stopped. EventTime set to false!!")
		end
	end
)

function getRandomMapCompatibleWithGamemode(gamemode) --Function made by PewX
	if not isMapmanagerAvailable() then return end
    local compatibleMaps = exports.mapmanager:getMapsCompatibleWithGamemode(gamemode)
    if #compatibleMaps == 0 then outputChatBox("|Race| Error: No compatible maps!", getRootElement(), 255, 0, 0) return end

    return compatibleMaps[math.random(1, #compatibleMaps)]
end

--[[function getRandomMapCompatibleWithGamemode( gamemode, oldestPercentage, minSpawnCount ) --Function disabled by PewX: Some stuff don't needed for our uses

	-- Get all relevant maps
	local compatibleMaps = exports.mapmanager:getMapsCompatibleWithGamemode( gamemode )

	if #compatibleMaps == 0 then
		outputDebugString( 'getRandomMapCompatibleWithGamemode: No maps.', 1 )
		return false
	end

	-- Sort maps by time since played
	local sortList = {}
	for i,map in ipairs(compatibleMaps) do
		sortList[i] = {}
		sortList[i].map = map
		sortList[i].lastTimePlayed = getMapLastTimePlayed( map )
	end

	table.sort( sortList, function(a, b) return a.lastTimePlayed > b.lastTimePlayed end )

	-- Use the bottom n% of maps as the initial selection pool
	local cutoff = #sortList - math.floor( #sortList * oldestPercentage / 100 )

	outputDebug( 'RANDMAP', 'getRandomMapCompatibleWithGamemode' )
	outputDebug( 'RANDMAP', ''
			.. ' minSpawns:' .. tostring( minSpawnCount )
			.. ' nummaps:' .. tostring( #sortList )
			.. ' cutoff:' .. tostring( cutoff )
			.. ' poolsize:' .. tostring( #sortList - cutoff + 1 )
			)

	math.randomseed( getTickCount() % 50000 )
	local fallbackMap
	while #sortList > 0 do
		-- Get random item from range
		local idx = math.random( cutoff, #sortList )
		local map = sortList[idx].map

		if not minSpawnCount or minSpawnCount <= getMapSpawnPointCount( map ) then
			outputDebug( 'RANDMAP', ''
					.. ' ++ using map:' .. tostring( getResourceName( map ) )
					.. ' spawns:' .. tostring( getMapSpawnPointCount( map ) )
					.. ' age:' .. tostring( getRealTimeSeconds() - getMapLastTimePlayed( map ) )
					)
			return map
		end

		-- Remember best match incase we cant find any with enough spawn points
		if not fallbackMap or getMapSpawnPointCount( fallbackMap ) < getMapSpawnPointCount( map ) then
			fallbackMap = map
		end

		outputDebug( 'RANDMAP', ''
				.. ' skip:' .. tostring( getResourceName( map ) )
				.. ' spawns:' .. tostring( getMapSpawnPointCount( map ) )
				.. ' age:' .. tostring( getRealTimeSeconds() - getMapLastTimePlayed( map ) )
				)

		-- If map not good enough, remove from the list and try another
		table.remove( sortList, idx )
		-- Move cutoff up the list if required
		cutoff = math.min( cutoff, #sortList )
	end

	-- No maps found - use best match
	outputDebug( 'RANDMAP', ''
			.. ' ** fallback map:' .. tostring( getResourceName( fallbackMap ) )
			.. ' spawns:' .. tostring( getMapSpawnPointCount( fallbackMap ) )
			.. ' ageLstPlyd:' .. tostring( getRealTimeSeconds() - getMapLastTimePlayed( fallbackMap ) )
			)
	return fallbackMap
end]]

-- Look for spawnpoints in map file
-- Not very quick as it loads the map file everytime
function countSpawnPointsInMap(res)
	local count = 0
	local meta = xmlLoadFile(':' .. getResourceName(res) .. '/' .. 'meta.xml')
	if meta then
		local mapnode = xmlFindChild(meta, 'map', 0) or xmlFindChild(meta, 'race', 0)
		local filename = mapnode and xmlNodeGetAttribute(mapnode, 'src')
		xmlUnloadFile(meta)
		if filename then
			local map = xmlLoadFile(':' .. getResourceName(res) .. '/' .. filename)
			if map then
				while xmlFindChild(map, 'spawnpoint', count) do
					count = count + 1
				end
				xmlUnloadFile(map)
			end
		end
	end
	return count
end

---------------------------------------------------------------------------
-- g_MapInfoList access
---------------------------------------------------------------------------
local g_MapInfoList

function getMapLastTimePlayed( map )
	local mapInfo = getMapInfo( map )
	return mapInfo.lastTimePlayed or 0
end

function setMapLastTimePlayed( map, time )
	time = time or getRealTimeSeconds()
	local mapInfo = getMapInfo( map )
	mapInfo.lastTimePlayed = time
	mapInfo.playedCount = ( mapInfo.playedCount or 0 ) + 1
	saveMapInfoItem( map, mapInfo )
end

function getMapSpawnPointCount( map )
	local mapInfo = getMapInfo( map )
	if not mapInfo.spawnPointCount then
		mapInfo.spawnPointCount = countSpawnPointsInMap( map )
		saveMapInfoItem( map, mapInfo )
	end
	return mapInfo.spawnPointCount
end

function getMapInfo( map )
	if not g_MapInfoList then
		loadMapInfoAll()
	end
	if not g_MapInfoList[map] then
		g_MapInfoList[map] = {}
	end
	local mapInfo = g_MapInfoList[map]
	if mapInfo.loadTime ~= getResourceLoadTime(map) then
		-- Reset or clear data that may change between loads
		mapInfo.loadTime = getResourceLoadTime( map )
		mapInfo.spawnPointCount = false
	end
	return mapInfo
end


---------------------------------------------------------------------------
-- g_MapInfoList <-> database
---------------------------------------------------------------------------
function sqlString(value)
	value = tostring(value) or ''
	return "'" .. value:gsub( "(['])", "''" ) .. "'"
end

function sqlInt(value)
	return tonumber(value) or 0
end

function getTableName(value)
	return sqlString( 'race_mapmanager_maps' )
end

function ensureTableExists()
	local cmd = ( 'CREATE TABLE IF NOT EXISTS ' .. getTableName() .. ' ('
					 .. 'resName TEXT UNIQUE'
					 .. ', infoName TEXT '
					 .. ', spawnPointCount INTEGER'
					 .. ', playedCount INTEGER'
					 .. ', lastTimePlayedText TEXT'
					 .. ', lastTimePlayed INTEGER'
			.. ')' )
	executeSQLQuery( cmd )
end

-- Load all rows into g_MapInfoList
function loadMapInfoAll()
	ensureTableExists()
	local rows = executeSQLQuery( 'SELECT * FROM ' .. getTableName() )
	g_MapInfoList = {}
	for i,row in ipairs(rows) do
		local map = getResourceFromName( row.resName )
		if map then
			local mapInfo = getMapInfo( map )
			mapInfo.playedCount = row.playedCount
			mapInfo.lastTimePlayed = row.lastTimePlayed
		end
	end
end

-- Save one row
function saveMapInfoItem( map, info )
	executeSQLQuery( 'BEGIN TRANSACTION' )

	ensureTableExists()

	local cmd = ( 'INSERT OR IGNORE INTO ' .. getTableName() .. ' VALUES ('
					.. ''		.. sqlString( getResourceName( map ) )
					.. ','		.. sqlString( "" )
					.. ','		.. sqlInt( 0 )
					.. ','		.. sqlInt( 0 )
					.. ','		.. sqlString( "" )
					.. ','		.. sqlInt( 0 )
			.. ')' )
	executeSQLQuery( cmd )

	cmd = ( 'UPDATE ' .. getTableName() .. ' SET '
					.. 'infoName='				.. sqlString( getResourceInfo( map, "name" ) )
					.. ',spawnPointCount='		.. sqlInt( info.spawnPointCount )
					.. ',playedCount='			.. sqlInt( info.playedCount )
					.. ',lastTimePlayedText='	.. sqlString( info.lastTimePlayed and info.lastTimePlayed > 0 and getRealDateTimeString(getRealTime(info.lastTimePlayed)) or "-" )
					.. ',lastTimePlayed='		.. sqlInt( info.lastTimePlayed )
			.. ' WHERE '
					.. 'resName='				.. sqlString( getResourceName( map ) )
			 )
	executeSQLQuery( cmd )

	executeSQLQuery( 'END TRANSACTION' )
end



---------------------------------------------------------------------------
--
-- More things that should go in mapmanager
--
---------------------------------------------------------------------------

addCommandHandler('checkmap',
	function( player, command, ... )
		local query = #{...}>0 and table.concat({...},' ') or nil
		if query then
			local map, errormsg = findMap( query )
			outputRace( errormsg, player )
		end
	end
)

addCommandHandler('nextmap',
	function( player, _, ... )
        if eventTime then outputChatBox("|Event| You can't change the map while an event is running", player, 255, 0, 0) return end

        if not _TESTING and not hasObjectPermissionTo(player, "function.nextmap", false) then
            return
        end

		local query = #{...}>0 and table.concat({...},' ') or nil


		local map, errormsg = findMap(query)
		if not map then
			outputRace( errormsg, player )
			return
        end

		if g_ForcedNextMap == map then
			outputRace( 'Next map is already set to ' .. getMapName( g_ForcedNextMap ), player )
			return
        end

		g_ForcedNextMap = map
        nextmapbought = true

		sendMapInformations()
        triggerClientEvent("addClientMessage", g_Root, ("|Map| #00FF11Next map set to #ffffff%s #00FF11 by #ffffff%s"):format(getMapName(g_ForcedNextMap), getPlayerName(player)), 255, 255, 255, "map")
	end
)

local cantBuyTimer = {}
function isMapinCantBuylist(map)
	if isTimer(cantBuyTimer[map]) then 
		local remaining, executesRemaining, totalExecutes = getTimerDetails(cantBuyTimer[map])
		local var = math.round(remaining/60000, 0)
		if var == 0 then killTimer(cantBuyTimer[map]) cantBuyTimer[map] = nil return false else return var end
	else
		return false
	end
end

function setMapInCantBuyMap(map)
	cantBuyTimer[map] = setTimer(function(theMap)
		if isTimer(cantBuyTimer[map]) then killTimer(cantBuyTimer[map]) cantBuyTimer[map] = nil end
        triggerClientEvent("addClientMessage", g_Root, ("|Map| %s #FF9900can be bought again!"):format(getMapName(map)), 255, 255, 255, "map")
	end, 3600000, 1, map)
end

addCommandHandler('enablemaps',
	function(player)
		if hasObjectPermissionTo ( player, "function.nextmap", false ) then
			for i, map in pairs(cantBuyTimer) do
				killTimer(map)
			end
			cantBuyTimer = {}
            triggerClientEvent("addClientMessage", g_Root, ("|Map| All maps was enabled by #ffffff%s"):format(getPlayerName(player)), 255, 255, 255, "map")
		end
	end
)

local function nextmapbuyperpanel(...)
        if nextmapbought then
            outputChatBox("|Map| #FF9900Next Map is already bought. ", source, 255, 255, 255, true)
            return
        end

        local query = #{...}>0 and table.concat({...},' ') or nil
		local map, errormsg = findMap( query )

		if not map then
            outputChatBox("|Map| #FF9900Can't find this map. ", source, 255, 255, 255, true)
			return
		end

        local currentMap = exports.mapmanager:getRunningGamemodeMap()

		local timeToRemain = isMapinCantBuylist(map)
		if timeToRemain then 
			outputChatBox(("|Map| %s #FF9900 can be bought again in #FFFFFF%s#FF9900 min."):format(getMapName(map), timeToRemain), source, 255, 255, 255, true)
			return
        end

        triggerEvent("setCashofBuyMap",source)
		g_ForcedNextMap = map
        nextmapbought = true
		sendMapInformations()

        triggerClientEvent("addClientMessage", g_Root, ("|Map| %s #ff9900was bought by #ffffff%s #00FF00(%s $)"):format(getMapName(g_ForcedNextMap), getPlayerName(source), tostring(getElementData(source, "latestMapPrice"))), 255, 255, 255, "map")
		setMapInCantBuyMap(g_ForcedNextMap)
end
addEvent("onNextmapBuy")
addEventHandler( "onNextmapBuy", getRootElement(), nextmapbuyperpanel)

function setNextEMap(...)
	local query = #{...}>0 and table.concat({...},' ') or nil
	local map, errormsg = findMap( query )
	if not map then
		outputChatBox("|Event| Race Error: " .. errormsg, getRootElement(), 150, 0, 0)
		return
	end

    g_ForcedNextMap = map

	sendMapInformations()
end
addEvent("setNextEventMap")
addEventHandler("setNextEventMap", getRootElement(), setNextEMap)

--Find a map which matches, or nil and a text message if there is not one match
function findMap( query )
	local maps = findMaps( query )

	-- Make status string
    --local status = "Found " .. #maps .. " match" .. ( #maps==1 and "" or "es" ) --Disabled by PewX, see next line
	local status = ("Found %s math %s"):format(#maps, (#maps==1 and "" or "es" ))

	for i=1,math.min(5,#maps) do
		--status = status .. ( i==1 and ": " or ", " ) .. "'" .. getMapName( maps[i] ) .. "'" --Disabled by PewX, see next line
        status = ("%s %s '%s'"):format(status, (i==1 and ": " or ", "), getMapName(maps[i]))
	end
	if #maps > 5 then
		--status = status .. " (" .. #maps - 5 .. " more)" --Disabled by PewX, see next line
        status = ("%s (%s more)"):format(status, #maps-5)
	end

	if #maps == 0 then
		--return nil, status .. " for '" .. query .. "'" --Disabled by PewX, see next line
        return nil, ("%s for '%s'"):format(status, query)
	end
	if #maps == 1 then
		return maps[1], status
	end
	if #maps > 1 then
		return nil, status
	end
end

-- Find all maps which match the query string
function findMaps( query )
	local results = {}
	--escape all meta chars
	query = string.gsub(query, "([%*%+%?%.%(%)%[%]%{%}%\%/%|%^%$%-])","%%%1")
	-- Loop through and find matching maps
	for i,resource in ipairs(exports.mapmanager:getMapsCompatibleWithGamemode(getThisResource())) do
		local resName = getResourceName( resource )
		local infoName = getMapName( resource  )

		-- Look for exact match first
		if query == resName or query == infoName then
			return {resource}
		end

		-- Find match for query within infoName
		if string.find( infoName:lower(), query:lower() ) then
			table.insert( results, resource )
		end
	end
	return results
end

function getMapName( map )
	if not map then
		return "-"
	end

	return getResourceInfo( map, "name" ) or getResourceName( map ) or "unknown"
end

function getNextMap()
	if (g_ForcedNextMap) then
		return getMapName(g_ForcedNextMap)
	else
	--Todo: re enabled nextmapsetauto function, idk why this was disabled, so.. let see what happens
		nextmapsetauto()
		return "#Error - Please wait"
	end
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function isMapmanagerAvailable()
	for _, resource in ipairs(getResources()) do
		if getResourceName(resource) == "mapmanager" then
			if getResourceState(resource) ~= "running" then
				return false
			end
		end
	end
	return true
end
--[[
local function sendInfoToClient()
	if not isMapmanagerAvailable() then return end

	local map = getMapName (exports.mapmanager:getRunningGamemodeMap())
	local nextmap =  getNextMap()
	if voteRedo then nextmap = map .. " <Redo>" end
	for _, p in ipairs(getElementsByType("player")) do
		local ping = getPlayerPing(p)
		triggerClientEvent(p, "update_client_infos", p, ping, map, nextmap)
	end
end
setTimer(sendInfoToClient, 3000, 0)]]

