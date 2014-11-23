--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 09.08.2014 - Time: 15:24
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local tst = {invites = {}, prefix = "|Team|#00C8FF "}
gtst = {}

function tst.createTeams()
    tst.teams = {}
    local teams = mysqlQuery("SELECT * FROM sys_teams")
    local eTeam
    for _, team in ipairs(teams) do
        if toboolean(team.showTab) then
            eTeam = createTeam(team.name, getColorFromString(team.color))
        end

        team.players = fromJSON(team.players)
        team.wins = fromJSON(team.wins)
        team.blacklist = fromJSON(team.blacklist)
        team.log = fromJSON(team.log)
        team.notes = fromJSON(team.notes)

        table.insert(tst.teams, {source = eTeam, datas = team})
    end
    gtst.sortTopTeams()
end
addEvent("onServerCreateTeams")
addEventHandler("onServerCreateTeams", resroot, tst.createTeams)

function tst.saveTeams()
    for _, team in ipairs(tst.teams) do
        for index, value in pairs(team.datas) do
            if type(value) == "table" then
                mysqlSet("sys_teams", index, toJSON(value), "ID", team.datas.ID)
            else
                mysqlSet("sys_teams", index, value, "ID", team.datas.ID)
            end
        end
    end
end
addEventHandler("onResourceStop", resroot, tst.saveTeams)

setTimer(
    function()
        tst.saveTeams()
        outputDebugString("Teams synchronized with database")
    end
, 3600000, -1)

function tst.onPlayerLogin(client)
    local pTeam = gtst.getPlayerTeam(client)
    if pTeam then
        triggerClientEvent(client, "onClientCreateTeamGUI", client, pTeam.datas, tst.topTeams)
        if not isPlayerInAdminGroup(client) then setPlayerTeam(client, pTeam.source) end
    elseif not isPlayerInAdminGroup(client) then
        setPlayerTeam(client, getTeamFromName("User"))
    end
end
addEvent("onClientLoggedIn")
addEventHandler("onClientLoggedIn", resroot, tst.onPlayerLogin)

function tst.comp(c1, c2)
    return c1.ts > c2.ts
end

function tst.addLogMessage(team, member, action, color, message)
    table.insert(team.datas.log, {member = removeColorCodes(getPlayerName(member)), date = getRealTimeString(), action = action, message = message, color = color, ts = getRealTime().timestamp})
    table.sort(team.datas.log, tst.comp)
    tst.syncTeam(team)
end

function tst.addPlayerToTeam(player, team)
    local pA = getPlayerAccount(player)
    if not isGuestAccount(pA) then
        pA = getAccountName(pA)
        table.insert(team.datas.players, {accountname = pA, lastusername = removeColorCodes(getPlayerName(player)), wins = 0, rank = 1, lastonline = getRealTime().timestamp, joined = getRealTime().timestamp})
    end
end

function tst.removePlayerFromTeam(player, team)
    for i, p in ipairs(team.datas.players) do
        if p.accountname == player then
            if table.remove(team.datas.players, i) then
                tst.syncTeam(team)
                return true
            end
        end
    end
    return false
end

function gtst.getPlayerTeam(tp)
    local pA = getPlayerAccount(tp)
    if not isGuestAccount(pA) then
        pA = getAccountName(pA)
        for _, team in ipairs(tst.teams) do
            for _, player in ipairs(team.datas.players) do
                if player.accountname == pA then
                    return team
                end
            end
        end
    end
    return false
end

function gtst.getTeamPlayers(tpt)
    local players = {}
    for _, p in ipairs(getElementsByType"player") do
        local pA = getPlayerAccount(p)
        if not isGuestAccount(pA) then
            pA = getAccountName(pA)
            for _, tp in ipairs(tpt) do
                if tp.accountname == pA then
                    table.insert(players, p)
                end
            end
        end
    end
    return players
end

function gtst.sortTopTeams(sync)
    local cache = {}
    for _, team in ipairs(tst.teams) do
        local totalWins = 0
        for _, wins in pairs(team.datas.wins) do
            totalWins = totalWins + wins
        end
        table.insert(cache, {team = team.datas.name, totalWins = totalWins, wins = team.datas.wins, points = team.datas.points})
    end
    table.sort(cache, function(c1, c2) return (c1.totalWins > c2.totalWins) end)
    tst.topTeams = cache

    if sync then
       for _, team in ipairs(tst.teams) do
            tst.syncTeam(team, tst.topTeams)
       end
    end
end

function gtst.addTeamEventStats(eWin, theTeam, points, type, cash)
    for _, team in ipairs(tst.teams) do
        if team.datas == theTeam then
            if eWin then
                team.datas.wins[type] = team.datas.wins[type] + 1
                team.datas.cash = team.datas.cash + cash
            end
            if points ~= 0 then
                team.datas.wins["EVENT"] = team.datas.wins["EVENT"] + 1
                team.datas.points = team.datas.points + points
            end
        end
    end
end

function tst.setPlayerStat(player, team, s, sV)
    for _, p in ipairs(team.datas.players) do
        if p.accountname == player then
            for index in pairs(p) do
                if index == s then
                    p[index] = sV
                    tst.syncTeam(team)
                    return true
                end
            end
        end
    end
    return false
end

function tst.getPlayerStat(player, team, s)
    for _, p in ipairs(team.datas.players) do
        if p.accountname == player then
            for index, value in pairs(p) do
                if index == s then
                    return value
                end
            end
        end
    end
    return false
end

function tst.syncTeam(team, topTeams)
    for _, player in ipairs(gtst.getTeamPlayers(team.datas.players)) do
        triggerClientEvent(player, "onServerSyncTeam", player, team.datas, topTeams)
    end
end

function tst.outputTeamPlayers(team, message)
    for _, player in ipairs(gtst.getTeamPlayers(team.datas.players)) do
        outputChatBox(tst.prefix .. message, player, 255, 255, 255, true)
    end
end

function tst.outputTeamPlayer(player, message)
    outputChatBox(tst.prefix .. message, player, 255, 255, 255, true)
end

function tst.upgradePrice(s)
    return 1000000+(1000000/100*(s^2))
end

function tst.isTeamnameAvailable(n)
    for _, team in ipairs(tst.teams) do
        if team.datas.name == n then
            return false
        end
    end
    return true
end

function tst.isAdminInviteAdmin(i, t)
    if isPlayerInAdminGroup(i) and isPlayerInAdminGroup(t) then return true end
end

function tst.isPlayerInvited(p)
    for i, request in ipairs(tst.invites) do
        if request.player == p then
            return request, i
        end
    end
    return false
end

addEvent("onClientRequestInviteUsers", true)
addEventHandler("onClientRequestInviteUsers", resroot, function()
    local cache = {}
    for _, p in ipairs(getElementsByType"player") do
        local pA = getPlayerAccount(p)
        if not isGuestAccount(pA) then
            local pTeam = gtst.getPlayerTeam(p)
            if not pTeam then
                local pInvite = tst.isPlayerInvited(p)
                if not pInvite then
                    if not isPlayerInAdminGroup(p) then
                        table.insert(cache, {source = p, available = true, color = "#FFFFFF", info = "/"})
                    elseif tst.isAdminInviteAdmin(client, p) then
                        table.insert(cache, {source = p , available = true, color = "#FFFFFF", info = "/"})
                    else
                        table.insert(cache, {source = p, available = false, type = 3, info = "Player is in admin team", color = "#FF0000"})
                    end
                else
                    table.insert(cache, {source = p, available = false, type = 2, info = ("Player was already invited to %s"):format(pInvite.team.datas.name), color = "#F5D46F", invTeam = pInvite.team.datas.name})
                end
            else
                table.insert(cache, {source = p, available = false, type = 1, info = ("Is already in team %s"):format(pTeam.datas.name), color = "#B5B5B5"})
            end
        else
            table.insert(cache, {source = p, available = false, type = 0, info = "Not logged in", color = "#B5B5B5"})
        end
    end
    triggerClientEvent(client, "onClientRecieveInviteUsers", client, cache)
end)

addEvent("onClientNotesSave", true)
addEventHandler("onClientNotesSave", resroot, function(notes)
    local pTeam = gtst.getPlayerTeam(client)
    if pTeam then
        if pTeam.datas.notes.editor == client then
            if pTeam.datas.notes.text == notes then return end
            local lt = pTeam.datas.notes.text
            pTeam.datas.notes.text = notes
            tst.addLogMessage(pTeam, client, "notes", "", ("%s:%s"):format(#lt, #notes))
            tst.outputTeamPlayers(pTeam, "Notes changed.")
        end
    end
end)

addEvent("onClientNotesEdit", true)
addEventHandler("onClientNotesEdit", resroot, function(state)
    local pTeam = gtst.getPlayerTeam(client)
    if pTeam then
        if state then
            if not pTeam.datas.notes.editor then
                pTeam.datas.notes.editor = client
                pTeam.datas.notes.state = "edit by " .. removeColorCodes(getPlayerName(client))
                tst.syncTeam(pTeam)
            end
        else
            pTeam.datas.notes.editor = false
            pTeam.datas.notes.state = "-"
            tst.syncTeam(pTeam)
        end
    end
end)

addEvent("onClientResetLog", true)
addEventHandler("onClientResetLog", resroot, function()
    local pTeam = gtst.getPlayerTeam(client)
    if pTeam then
        local pAN = getAccountName(getPlayerAccount(client))
        if tst.getPlayerStat(pAN, pTeam, "rank") ~= 4 then tst.outputTeamPlayer(client, "Sorry, I can't let you do this :(") return end
        pTeam.datas.log = {}
        tst.addLogMessage(pTeam, client, "reset", "", "reset log")
    end
end)

addEvent("onClientUpgradeTeam", true)
addEventHandler("onClientUpgradeTeam", resroot, function()
    local pTeam = gtst.getPlayerTeam(client)
    if pTeam then
        local pAN = getAccountName(getPlayerAccount(client))
        if tst.getPlayerStat(pAN, pTeam, "rank") ~= 4 then tst.outputTeamPlayer(client, "Sorry, I can't let you do this :(") return end
        if pTeam.datas.slots == 15 then tst.outputTeamPlayer(client, "You reached the teamslot limit!") return end

        local uP = tst.upgradePrice(pTeam.datas.slots)
        if pTeam.datas.cash > uP then
            pTeam.datas.cash = pTeam.datas.cash - uP
            pTeam.datas.slots = pTeam.datas.slots + 1
            tst.addLogMessage(pTeam, client, "upgrade", "", "increased slots")
            tst.outputTeamPlayers(pTeam, "Increased team slots!")
        else
            tst.outputTeamPlayer(client, "Your team don't have enough money!")
        end
    end
end)

addEvent("onClientBuyTeamChange", true)
addEventHandler("onClientBuyTeamChange", resroot, function(tn, r,g,b)
    local pTeam = gtst.getPlayerTeam(client)
    if pTeam then
        local pAN = getAccountName(getPlayerAccount(client))
        if tst.getPlayerStat(pAN, pTeam, "rank") ~= 4 then tst.outputTeamPlayer(client, "Sorry, I can't let you do this :(") return end
        if tn == "" or #tn < 4 or #tn > 16 then tst.outputTeamPlayer(client, "Invalid teamname!") return end
        if not tst.isTeamnameAvailable(tn) then tst.outputTeamPlayer(client, "Teamname is already in use!") return end

        local cr, cg, cb = getColorFromString(pTeam.datas.color)
        local chgPrice = (math.abs(#tn-#pTeam.datas.name) + math.abs(cr-r) + math.abs(cg-g) + math.abs(cb-b))*10000

        if chgPrice < pTeam.datas.cash then
            tst.outputTeamPlayers(pTeam, "Teamname or color changed!")
            pTeam.datas.cash = pTeam.datas.cash - chgPrice
            pTeam.datas.name = tn
            pTeam.datas.color = "#" .. rgbToHex(r,g,b)
            setTeamName(pTeam.source, tn)
            setTeamColor(pTeam.source, r,g,b)
            tst.addLogMessage(pTeam, client, "settings", "", "Teamname or color changed")
        else
            tst.outputTeamPlayer(client, "Your team don't have enough money!")
        end
    end
end)

addEvent("onClientInviteMember", true)
addEventHandler("onClientInviteMember", resroot, function(uName)
    local pTeam = gtst.getPlayerTeam(client)
    if pTeam then
        local pAN = getAccountName(getPlayerAccount(client))
        local tPS = getPlayerFromNamePart(uName)
        if not tPS then tst.outputTeamPlayer(client, "Player can't find serverside. Maybe disconnected?") return end
        if gtst.getPlayerTeam(tPS) then tst.outputTeamPlayer(client, "Player is already in a team!") return end
        if client == tPS then tst.outputTeamPlayer(client, "LOL, You want to invite yourself?! Confused o.O") return end

        local cRank = tonumber(tst.getPlayerStat(pAN, pTeam, "rank"))
        if cRank == 3 or cRank == 4 then
            tst.outputTeamPlayers(pTeam, ("Player %s has send an invite request to %s"):format(removeColorCodes(getPlayerName(client)), removeColorCodes(uName)))
            tst.outputTeamPlayer(tPS, "You was invited to the team " .. pTeam.datas.name)
            tst.outputTeamPlayer(tPS, "Type /team to accept or decline the request")
            table.insert(tst.invites, {player = tPS, team = pTeam, by = client})
            tst.addLogMessage(pTeam, client, "invite", "", getPlayerName(tPS))
        end
    end
end)

addEvent("onClientWithdrawInvite", true)
addEventHandler("onClientWithdrawInvite", resroot, function(uName)
    local pTeam = gtst.getPlayerTeam(client)
    if pTeam then
        local pAN = getAccountName(getPlayerAccount(client))
        local tPS = getPlayerFromNamePart(uName)
        if not tPS then tst.outputTeamPlayer(client, "Player can't find serverside. Maybe disconnected?") return end
        local cRank = tonumber(tst.getPlayerStat(pAN, pTeam, "rank"))

        if cRank == 3 or cRank == 4 then
            local fP, fIndex = tst.isPlayerInvited(tPS)
            if fP and fIndex then
                if fP.team.datas.name == pTeam.datas.name then
                    tst.outputTeamPlayers(pTeam, ("Player %s has withdrawn the invite request to %s"):format(removeColorCodes(getPlayerName(client)), removeColorCodes(uName)))
                    tst.outputTeamPlayer(tPS, "Your invitation has been withdrawn by " .. removeColorCodes(getPlayerName(client)))
                    table.remove(tst.invites, fIndex)
                    tst.addLogMessage(pTeam, client, "withdraw", "", getPlayerName(tPS))
                else
                    tst.outputTeamPlayer(client, "This player recieved no request for your team!")
                end
            end
        end
    end
end)

addEvent("onClientLeaveTeam", true)
addEventHandler("onClientLeaveTeam", resroot, function()
    local pTeam = gtst.getPlayerTeam(client)
    if pTeam then
        local pAN = getAccountName(getPlayerAccount(client))
        if tst.removePlayerFromTeam(pAN, pTeam) then
            triggerClientEvent(client, "onClientDestroyTeamGUI", client)
            setPlayerTeam(client, getTeamFromName("User"))
            tst.outputTeamPlayer(client, "You left the team.")
            tst.outputTeamPlayers(pTeam, removeColorCodes(getPlayerName(client)) .. " left the team.")
            tst.addLogMessage(pTeam, client, "leave", "", "")
        end
    end
end)

addEvent("onClientUninviteMember", true)
addEventHandler("onClientUninviteMember", resroot, function(mName)
    local pTeam = gtst.getPlayerTeam(client)
    if pTeam then
        local pAN = getAccountName(getPlayerAccount(client))
        if pAN == mName then tst.outputTeamPlayer(client, "You can't uninvite yourself!") return end

        local cRank = tonumber(tst.getPlayerStat(pAN, pTeam, "rank"))
        local tpRank = tonumber(tst.getPlayerStat(mName, pTeam, "rank"))
        if cRank == 4 then
            local tpSource = getPlayerFromAccountName(mName)
            if tpSource then triggerClientEvent(tpSource, "onClientDestroyTeamGUI", tpSource) tst.outputTeamPlayer(tpSource, "You was uninvited by " .. removeColorCodes(getPlayerName(client))) setPlayerTeam(tpSource, getTeamFromName("User")) end
            if tst.removePlayerFromTeam(mName, pTeam) then
                tst.outputTeamPlayers(pTeam, ("Player '%s' was uninvited by '%s'"):format(mName, removeColorCodes(getPlayerName(client))))
                tst.addLogMessage(pTeam, client, "uninvite", "", getPlayerName(tpSource) or pAN)
            end
        end
    end
end)

addEvent("onClientSetMemberRank", true)
addEventHandler("onClientSetMemberRank", resroot, function(mName, n)
    local pTeam = gtst.getPlayerTeam(client)
    if pTeam then
        local pAN = getAccountName(getPlayerAccount(client))
        if pAN == mName then tst.outputTeamPlayer(client, "You can't change your own rank!") return end

        local cRank = tonumber(tst.getPlayerStat(pAN, pTeam, "rank"))
        local tpRank = tonumber(tst.getPlayerStat(mName, pTeam, "rank"))
        if cRank == 4 then
            if (tpRank + n) == 0 then tst.outputTeamPlayer(client,"Rank 1 is the lowest rank!") return end
            if (tpRank + n) == 5 then tst.outputTeamPlayer(client,"Rank 4 is the highest rank!") return end
            tst.setPlayerStat(mName, pTeam, "rank", (tpRank + n))
        elseif cRank == 3 then
            if tpRank == 4 then tst.outputTeamPlayer(client, "You can't change the rank from your leader!") return end
            if (tpRank + n) == 4 then tst.outputTeamPlayer(client, "Rank 3 is the highest rank which you can assign!") return end
            if (tpRank + n) == 0 then tst.outputTeamPlayer(client, "Rank 1 is the lowest rank which you can assign!") return end
            tst.setPlayerStat(mName, pTeam, "rank", (tpRank + n))
        else
            tst.outputTeamPlayer(client, "You are not allowed to change ranks!")
            return
        end
        tst.outputTeamPlayers(pTeam, ("Player '%s' has given rank %s by '%s'"):format(mName, (tpRank + n), removeColorCodes(getPlayerName(client))))
        tst.addLogMessage(pTeam, client, "rank", "", mName .. ": " .. (tpRank + n))
    end
end)

addEvent("onClientSetTeamcash", true)
addEventHandler("onClientSetTeamcash", resroot, function(m, st)
    local pTeam = gtst.getPlayerTeam(client)
    if pTeam then
        local pA = getPlayerAccount(client)
        local pMoney = tonumber(getAccountData(pA, "cash"))
        m = math.abs(m)
        if st == 1 then
            if pMoney < m then tst.outputTeamPlayer(client, "You don't have enough money!") return end
            if setAccountData(pA, "cash", (pMoney-m)) then
                pTeam.datas.cash = tonumber(pTeam.datas.cash) + m
                tst.addLogMessage(pTeam, client, "cash", "#00ff00", "+" .. tostring(m))
            end
        else
            if tst.getPlayerStat(getAccountName(pA), pTeam, "rank") < 3 then tst.outputTeamPlayer(client, "Sorry, I can't let you do this :(") return end
            if pTeam.datas.cash < m then tst.outputTeamPlayer(client, "Your team don't have enough money!") return end
            if setAccountData(pA, "cash", (pMoney+m)) then
                pTeam.datas.cash = tonumber(pTeam.datas.cash) - m
                tst.addLogMessage(pTeam, client, "cash", "#ff0000", "-" .. tostring(m))
            end
        end
    end
end)

addCommandHandler("team", function(pl, _, tf)
    local fR = false
    for _, request in ipairs(tst.invites) do
        if request.player == pl then
            fR = request
        end
    end

    if not fR then
        tst.outputTeamPlayer(pl, "You don't recieved a invite request")
        return
    end

    if tf == "accept" then
        --outputChatBox(("%s/%s Slots available"):format(tonumber(fR.team.datas.slots)-#fR.team.datas.players, fR.team.datas.slots))
        if tonumber(fR.team.datas.slots) > #fR.team.datas.players then
            tst.outputTeamPlayers(fR.team, removeColorCodes(getPlayerName(pl)) .. " joined the team.")
            tst.addLogMessage(fR.team, pl, "invite", "", "accepted request")
            tst.outputTeamPlayer(pl, "You successfully accepted the request!")
            tst.addPlayerToTeam(pl, fR.team)
            setPlayerTeam(pl, fR.team.source)
            tst.syncTeam(fR.team)

            triggerClientEvent(pl, "onClientCreateTeamGUI", pl, fR.team.datas, tst.topTeams)
        else
            tst.outputTeamPlayer(pl, "You try to accept the request to late. The team is now full.")
        end
        return
    end

    if tf == "decline" then
        tst.outputTeamPlayers(fR.team, removeColorCodes(getPlayerName(pl)) .. " has rejected the invitation.")
        tst.addLogMessage(fR.team, pl, "invite", "", "declined request")
        tst.outputTeamPlayer(pl, "You successfully declined the request!")
        for i, request in ipairs(tst.invites) do
            if request.player == pl then
                table.remove(tst.invites, i)
            end
        end
        return
    end

    if tf == "info" then
        local invitedBy = getPlayerName(fR.by) or "*Unknown*"
        tst.outputTeamPlayer(pl, ("You was invited to the team %s by %s"):format(fR.team.datas.name, removeColorCodes(invitedBy)))
        return
    end

    tst.outputTeamPlayer(pl, "Syntax: /team [accept/decline/info]")
end)

addEventHandler("onPlayerQuit", root, function()
    for i, request in ipairs(tst.invites) do
        if request.player == source then
            table.remove(tst.invites, i)
        end
    end

    local pTeam = gtst.getPlayerTeam(source)
    if pTeam then
        local pA = getAccountName(getPlayerAccount(source))
        tst.setPlayerStat(pA, pTeam, "lastonline", getRealTime().timestamp)
        tst.setPlayerStat(pA, pTeam, "lastusername", removeColorCodes(getPlayerName(source)))

        if pTeam.datas.notes.editor == source then
            pTeam.datas.notes.editor = false
            pTeam.datas.notes.state = "-"
            tst.syncTeam(pTeam)
        end
    end
end)

---
--Global
---
function gtst.getTeams()
    local cache = {}
    for _, team in ipairs(tst.teams) do
        table.insert(cache, {source = team.source, name = team.datas.name, datas = team.datas})
    end
    return cache
end

function gtst.getTeamBoni(an, pl)
	local pTeam = gtst.getPlayerTeam(pl)
	if pTeam then
		local pRank = tonumber(tst.getPlayerStat(an, pTeam, "rank"))
		if pRank == 4 then	return 50 elseif pRank == 3 then return 40 elseif pRank == 2 then return 35 elseif pRank == 1 then return 30 end
    else return 25
    end
end