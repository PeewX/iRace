--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 26.07.2014 - Time: 17:24
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local eventDebug = false
local evt = {enabled = true, prefix = "|Event| #d4ff00", players = {}, teams = {}, current = {}, event = {}, pickedPlayers = {}, availableTeams = {}, points = {10, 6, 3 }}
gevt = {}

function evt.initialise()
    if not evt.enabled then return end
    evt.loadMaps()
    evt.initialiseNextEvent()
    evt.infoTimer = setTimer(evt.info, 600000, -1)
    addEventHandler("onResourceStart", root, evt.checkEventState)
end
addEventHandler("onResourceStart", resroot, evt.initialise)

function evt.loadMaps()
    evt.maps = {["DM"] = {}, ["DD"] = {}, ["SHOOTER"] = {}, ["HUNTER"] = {}}

    for _, resource in ipairs(getResources()) do
        if getResourceInfo(resource, "type") == "map" then
            local mapType = getMapTypeByName(getResourceName(resource)) or getMapTypeByName(getResourceInfo(resource, "name")) --At first check resourcname, if false, check mapname
            if type(mapType) == "string" then
                table.insert(evt.maps[mapType], {map = resource, name = getResourceInfo(resource, "name") or getResourceName(resource), resname = getResourceName(resource)})
            else
                outputChatBox("Invalid Maptype for map '" .. getResourceName(resource) .. "': " .. tostring(mapType))
            end
        end
    end
    return true
end

function evt.getAvailableMapTypes()
    local temp = {}
    for mapType, map in pairs(evt.maps) do
        if #map > 5 then --minimum 5 maps to set maptype enabled
            table.insert(temp, mapType)
        end
    end
    return temp
end

function evt.initialiseEvent()
    --Set next map
    local rndMap = evt.maps[evt.event.type][math.random(1, #evt.maps[evt.event.type])]
    triggerEvent("setNextEventMap", root, rndMap.name)
    --Initialise tables
    evt.pickedPlayers = {}
    evt.availableTeams = {}
    for _, team in ipairs(gtst.getTeams()) do
        if #gtst.getTeamPlayers(team.datas.players) > 0 then
            table.insert(evt.availableTeams, team)
        end
    end
end

function evt.initialiseNextEvent(h)
    local h = tonumber(h) or math.random(48, 144)
    local d = math.random(1, math.random(1, 3)) --idk why^^...

    evt.event.price = math.random(25000, 1000000)
    evt.event.pot = math.random(1,2) -- Players or Team (1 = players, 2 = team)
    evt.event.cm = math.random(2, 5)
    evt.event.start = evt.getRealTime().timestamp+(h*60*60)
    evt.event.stop  = evt.getRealTime().timestamp+((h+d)*60*60)
    evt.event.type  = evt.getAvailableMapTypes()[math.random(1, #evt.getAvailableMapTypes())]
    evt.event.items = {}
end

function evt.checkEventState()
    local rt = evt.getRealTime()
    if not evt.event.started then
        if (rt.timestamp >= evt.event.start) and (rt.timestamp < evt.event.stop) then
            triggerEvent("toggleRaceEventTime", root, true)
            addEventHandler("onServerGotMapType", resroot, evt.initialiseEvent)
            evt.event.started = true

            if evt.event.pot == 1 then
                for _, p in ipairs(evt.players) do table.insert(evt.event.items, {source = p, name = getPlayerName(p), account = getPlayerAccount(p), points = 0}) end
            else
                for _, t in ipairs(gtst.getTeams()) do table.insert(evt.event.items, {source = t.source, name = t.name, points = 0, datas = t.datas}) end
            end

            evt.triggerClientEvent("onRandomEventInitialised", evt.event)
        end
    else
        if (rt.timestamp >= evt.event.stop) then
            triggerEvent("toggleRaceEventTime", root, false)
            removeEventHandler("onServerGotMapType", resroot, evt.initialiseEvent)
            evt.showEventWinner()
            evt.event.started = false
            evt.initialiseNextEvent()
            evt.triggerClientEvent("onRandomEventInitialised", false)
        end
    end
end

function evt.showEventWinner()
    if evt.event.pot == 1 then
        local ePlayer = evt.event.items[1]
        if ePlayer.points < 50 then outputChatBox(evt.prefix .. "No player has more than 50 points.", root, 255, 255, 255, true) return end

        local ac = getPlayerAccount(ePlayer.source)
        local avatar = getAccountData(ac, "avatar")
        local text = ("Player %s won the %s-Event and got %s$"):format(removeColorCodes(getPlayerName(ePlayer.source)), evt.event.type, convertNumber(evt.event.price))

        evt.triggerClientEvent("onClientShowEndScreen", text, avatar)
        addStat(ac, "cash", evt.event.price)
    else
        local eTeam = evt.event.items[1]
        if eTeam.points < 250 then outputChatBox(evt.prefix .. "No team has more than 250 points.", root, 255, 255, 255, true) return end

        local avatar = "files/images/avatars/settings.png"
        local text = ("Team %s won the %s-Event and get %s$"):format(eTeam.datas.name, evt.event.type, convertNumber(evt.event.price))
        evt.triggerClientEvent("onClientShowEndScreen", text, avatar)

        for _, team in ipairs(evt.event.items) do
            if team == eTeam then gtst.addTeamEventStats(true, team.datas, team.points, evt.event.type, evt.event.price) else gtst.addTeamEventStats(false, team.datas, team.points, evt.event.type) end
        end
        gtst.sortTopTeams(true)
    end
end

addEvent("onClientLoggedIn")
addEventHandler("onClientLoggedIn", resroot, function(client)
    for _, pl in ipairs(evt.players) do
        if pl == client then
            return
        end
    end

    table.insert(evt.players, client)

    if evt.event.started then
       if evt.event.pot == 1 then
           local cAcc = getPlayerAccount(client)
           for _, item in ipairs(evt.event.items) do
                if item.account == cAcc then
                    item.source = client
                    triggerClientEvent(client, "onRandomEventInitialised", client, evt.event)
                    return
                end
           end
           table.insert(evt.event.items, {source = client, name = getPlayerName(client), account = cAcc, points = 0})
           triggerClientEvent(client, "onRandomEventInitialised", client, evt.event)
           evt.triggerClientEvent("onEventUpdate", evt.event)
       end
    end
end)

addEventHandler("onPlayerQuit", root,
    function()
        for i, p in ipairs(evt.players) do
            if p == source then
                table.remove(evt.players, i)
            end
        end
    end
)

addEventHandler("onPlayerChangeNick", root, function(_, new)
    if not evt.event.started then return end
    local changed = false
    for _, item in ipairs(evt.event.items) do
        if item.source == source then
            item.name = new
            changed = true
        end
    end
    if changed then evt.triggerClientEvent("onEventUpdate", evt.event) end
end)

function evt.info()
    if evt.event.started then return end
    if math.round((evt.event.start-evt.getRealTime().timestamp)/60/60) < 24 then
        triggerClientEvent("addClientMessage", root, ("%sA random event will start in %s"):format(evt.prefix, secondsToTimeDesc(evt.event.start-evt.getRealTime().timestamp)), 255, 255, 255)
    end
end

function evt.triggerClientEvent(eventname, ...)
    for _, player in ipairs(evt.players) do
        if isElement(player) then
            triggerClientEvent(player, eventname, player, ...)
        end
    end
end

local t = {[0] = 7, [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 5, [6] = 6}
function evt.getRealTime()
    local rt = getRealTime() rt.weekday = t[rt.weekday] return rt
end

function evt.getRaceAlivePlayers()
    local t = {}
    for _, p in ipairs(activePlayers) do
        if isElement(p) then
            if getElementData(p, "state") == "alive" then
                table.insert(t, p)
            end
        end
    end
    return t
end

function evt.getPlayerRank()
    return #evt.getRaceAlivePlayers() + 1
end

function gevt.onPlayerWasted(player)
    if not evt.event.started then return end
    if getElementData(player, "AFK") then return end
    if #evt.players < 3 then return end
    if evt.event.pot == 2 then if #evt.availableTeams < 3 then return end end
    if evt.pickedPlayers[player] then return else evt.pickedPlayers[player] = true end
    if not isMapType(evt.event.type) then return end

    local changed = false
    if evt.event.pot == 1 then
        local rank = evt.getPlayerRank()
        --if rank > 3 then return end

        for _, item in ipairs(evt.event.items) do
            if item.source == player then
                --item.points = item.points + evt.points[rank]

                if eventDebug then
                    outputChatBox("|Debug| Event stats for player: " .. tostring(getPlayerName(item.source)))
                    outputChatBox("|Debug| cnt activePlayers: " .. tostring(#activePlayers))
                    outputChatBox("|Debug| Rank: " .. tostring(evt.getPlayerRank()))
                    outputChatBox("|Debug| Current points: " .. tostring(item.points))
                    outputChatBox("|Debug| Calculated points: " .. tostring((#activePlayers - evt.getPlayerRank())))
                    outputChatBox("|Debug| New points: " .. tostring(item.points + (#activePlayers - evt.getPlayerRank())))
                end
                    item.points = item.points + (#activePlayers - evt.getPlayerRank())
                    changed = true
                --end
            end
        end

        local lastPlayer = evt.getRaceAlivePlayers()
        if #lastPlayer == 1 then
             evt.pickedPlayers[lastPlayer[1]] = true
             for _, item in ipairs(evt.event.items) do
                if item.source == lastPlayer[1] then
                    --item.points = item.points + evt.points[1]
                    item.points = item.points + (#activePlayers - 1)
                    changed = true
                end
            end
        end
    elseif evt.event.pot == 2 then
        local team = gtst.getPlayerTeam(player)
        --if not team then return end
        if team then
            for _, item in ipairs(evt.event.items) do
                if item.datas == team.datas then
                    item.points = item.points + (#activePlayers - evt.getPlayerRank())
                    changed = true
                end
            end
        end

        local lastPlayer = evt.getRaceAlivePlayers()
        if #lastPlayer == 1 then
            evt.pickedPlayers[lastPlayer[1]] = true
            local team =  gtst.getPlayerTeam(lastPlayer[1])
            if not team then return end
            for _, item in ipairs(evt.event.items) do
                if item.datas == team.datas then
                    item.points = item.points + (#activePlayers - 1)
                    changed = true
                end
            end
        end
    end

    table.sort(evt.event.items, function(t1, t2) return t1.points > t2.points end)
    if changed then evt.triggerClientEvent("onEventUpdate", evt.event) end
end

function gevt.getEventType()
	return evt.event.started and evt.event.type or false
end

function gevt.reloadEventMaps()
    if evt.event.started then return false end
    return evt.loadMaps()
end

--dev
addCommandHandler("event", function(pl)
    if evt.event.started then
        outputChatBox(evt.prefix .. "Event is already started!", pl, 255, 255, 255, true)
    else
        outputChatBox(evt.prefix .. "Event starts in " .. secondsToTimeDesc(evt.event.start-evt.getRealTime().timestamp), pl, 255, 255, 255, true)
    end
end)

addCommandHandler("debugevent", function()
    eventDebug = not eventDebug
    outputChatBox("|Debug| EventSystem debugging " .. eventDebug == true and "enabled" or "disabled")
end)

addCommandHandler("cEvent",
    function(pl, _, a, a2, a3)
        if getAdminRank(pl) < 4 then return end
        if a == "set" then
            if a2 == "start" then
                evt.event.start = tonumber(a3)
                outputChatBox(evt.prefix .. "Event starts in " .. secondsToTimeDesc(evt.event.start-evt.getRealTime().timestamp), pl, 255, 255, 255, true)
                outputChatBox("Don't forget to set stop time!", pl, 255, 0, 0)
            elseif a2 == "stop" then
                evt.event.stop = tonumber(a3) or evt.getRealTime().timestamp
                outputChatBox("Event stopped at next map!", pl, 255, 0, 0)
            elseif a2 == "type" then
                evt.event.type = a3
                outputChatBox(evt.prefix .. "Event type is now: " .. evt.event.type, pl, 255, 255, 255, true)
            elseif a2 == "pot" then
                evt.event.pot = tonumber(a3) or 1
                outputChatBox(evt.prefix .. "Event PoT is now: " .. evt.event.pot, pl, 255, 255, 255, true)
            else
                outputChatBox("Invalid syntax @ argument 2. (Valid: start, stop, type, price, pot)", pl, 255, 0, 0)
            end
        elseif a == "get" then
            if a2 == "price" then
                outputChatBox("Price: " .. evt.event.price, pl, 255, 0, 0)
            elseif a2 == "type" then
                outputChatBox("Type: " .. evt.event.type, pl, 255, 0, 0)
            elseif a2 == "pot" then
                outputChatBox("PoT: " .. evt.event.pot, pl, 255, 0, 0)
            end
        else
            outputChatBox("Invalid syntax @ argument 1. (Please use set or get)", pl, 255, 0, 0)
        end
    end
)