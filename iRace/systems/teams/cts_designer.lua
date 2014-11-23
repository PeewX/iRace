--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 09.08.2014 - Time: 23:00
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local tst = {prefix = "|Team|#00C8FF "}

function tst.initialiseTeamSystem(team, topTeams)
    tst.team = team
    tst.topTeam = topTeams
    tst.createWindow()

    guiSetText(tst.GUI.edits[1], team.notes.text)
    guiSetText(tst.GUI.labels[14], team.notes.state)
    guiSetText(tst.GUI.window, team.name)
    guiSetText(tst.GUI.labels[5], convertNumber(team.cash) .."$")
    guiSetText(tst.GUI.labels[6], team.slots)
    guiSetText(tst.GUI.labels[7], convertNumber(tst.upgradePrice(team.slots)) .. "$")
    guiSetText(tst.GUI.labels[13], getRealTimeString(team.created))

    local r,g,b = getColorFromString(team.color)
    guiScrollBarSetScrollPosition(tst.GUI.scrollbars[1], r/255*100)
    guiScrollBarSetScrollPosition(tst.GUI.scrollbars[2], g/255*100)
    guiScrollBarSetScrollPosition(tst.GUI.scrollbars[3], b/255*100)
    guiSetProperty(tst.GUI.window, "CaptionColour", rgbToHex(r, g, b, 255, true))

    for i, player in ipairs(team.players) do
        local row = guiGridListAddRow(tst.GUI.gridlist.lists[1])
        guiGridListSetItemText(tst.GUI.gridlist.lists[1], row, tst.GUI.gridlist.columns[1], player.accountname, false, false)
        guiGridListSetItemText(tst.GUI.gridlist.lists[1], row, tst.GUI.gridlist.columns[2], player.rank, false, false)
    end

    for i, log in ipairs(team.log) do
        local row = guiGridListAddRow(tst.GUI.gridlist.lists[3])
        for index, text in pairs(log) do
            if index ~= "ts" and index ~= "color" then
                guiGridListSetItemText(tst.GUI.gridlist.lists[3], row, tst.GUI.gridlist.columns[index], text, false, false)
                if log.color and getColorFromString(log.color) then guiGridListSetItemColor(tst.GUI.gridlist.lists[3], row, tst.GUI.gridlist.columns[index], getColorFromString(log.color)) end
            end
        end
    end

    for _, topTeam in ipairs(topTeams) do
       local row = guiGridListAddRow(tst.GUI.gridlist.lists[4])
        for index, value in pairs(topTeam) do
            if index == "wins" then
                for wIndex, wValue in pairs(value) do
                    guiGridListSetItemText(tst.GUI.gridlist.lists[4], row, tst.GUI.gridlist.columns[wIndex], wValue, false, false)
                end
            elseif index ~= "totalWins" then
                guiGridListSetItemText(tst.GUI.gridlist.lists[4], row, tst.GUI.gridlist.columns[index], value, false, false)
            end
        end
    end
    bindKey("o", "down", tst.toggleWindow)
    outputChatBox(tst.prefix .. "Press 'o' to open the teammenu", 255, 255, 255, true)
    addEventHandler("onServerSyncTeam", me, tst.onServerSyncTeam)
    addEventHandler("onClientDestroyTeamGUI", me, tst.destroyClientTeamSystem)
    removeEventHandler("onClientCreateTeamGUI", me, tst.initialiseTeamSystem)
end
addEvent("onClientCreateTeamGUI", true)
addEventHandler("onClientCreateTeamGUI", me, tst.initialiseTeamSystem)

function tst.destroyClientTeamSystem()
    if isElement(tst.GUI.window) then destroyElement(tst.GUI.window) end
    unbindKey("o", "down", tst.toggleWindow)
    removeEventHandler("onServerSyncTeam", me, tst.onServerSyncTeam)
    removeEventHandler("onClientDestroyTeamGUI", me, tst.destroyClientTeamSystem)
    addEventHandler("onClientCreateTeamGUI", me, tst.initialiseTeamSystem)
end
addEvent("onClientDestroyTeamGUI", true)

function tst.onServerSyncTeam(team, topTeams)
    tst.team = team

    guiSetText(tst.GUI.edits[1], team.notes.text)
    guiSetText(tst.GUI.labels[14], team.notes.state)
    guiSetText(tst.GUI.window, team.name)
    guiSetText(tst.GUI.labels[5], convertNumber(team.cash) .. "$")
    guiSetText(tst.GUI.labels[6], team.slots)
    guiSetText(tst.GUI.labels[7], convertNumber(tst.upgradePrice(team.slots)) .. "$")
    guiSetText(tst.GUI.labels[13], getRealTimeString(team.created))

    local r,g,b = getColorFromString(team.color)
    guiScrollBarSetScrollPosition(tst.GUI.scrollbars[1], r/255*100)
    guiScrollBarSetScrollPosition(tst.GUI.scrollbars[2], g/255*100)
    guiScrollBarSetScrollPosition(tst.GUI.scrollbars[3], b/255*100)
    guiSetProperty(tst.GUI.window, "CaptionColour", rgbToHex(r, g, b, 255, true))

    guiGridListClear(tst.GUI.gridlist.lists[1])
    for i, player in ipairs(team.players) do
        local row = guiGridListAddRow(tst.GUI.gridlist.lists[1])
        guiGridListSetItemText(tst.GUI.gridlist.lists[1], row, tst.GUI.gridlist.columns[1], player.accountname, false, false)
        guiGridListSetItemText(tst.GUI.gridlist.lists[1], row, tst.GUI.gridlist.columns[2], player.rank, false, false)
    end

    guiGridListClear(tst.GUI.gridlist.lists[3])
    for i, log in ipairs(team.log) do
        local row = guiGridListAddRow(tst.GUI.gridlist.lists[3])
        for index, text in pairs(log) do
            if index ~= "ts" and index ~= "color" then
                guiGridListSetItemText(tst.GUI.gridlist.lists[3], row, tst.GUI.gridlist.columns[index], text, false, false)
                if log.color and getColorFromString(log.color) then guiGridListSetItemColor(tst.GUI.gridlist.lists[3], row, tst.GUI.gridlist.columns[index], getColorFromString(log.color)) end
            end
        end
    end

    if topTeams then
        guiGridListClear(tst.GUI.gridlist.lists[4])
        for _, topTeam in ipairs(topTeams) do
            local row = guiGridListAddRow(tst.GUI.gridlist.lists[4])
            for index, value in pairs(topTeam) do
                if index == "wins" then
                    for wIndex, wValue in pairs(value) do
                        guiGridListSetItemText(tst.GUI.gridlist.lists[4], row, tst.GUI.gridlist.columns[wIndex], wValue, false, false)
                    end
                elseif index ~= "totalWins" then
                    guiGridListSetItemText(tst.GUI.gridlist.lists[4], row, tst.GUI.gridlist.columns[index], value, false, false)
                end
            end
        end
    end
end
addEvent("onServerSyncTeam", true)

function tst.recieveInviteUsers(inviteTable)
    tst.inviteTable = inviteTable
    guiGridListClear(tst.GUI.gridlist.lists[2])
    for i, player in ipairs(inviteTable) do
        local row = guiGridListAddRow(tst.GUI.gridlist.lists[2])
        guiGridListSetItemText(tst.GUI.gridlist.lists[2], row, tst.GUI.gridlist.columns[3], removeColorCodes(getPlayerName(player.source)), false, false)
        if player.color and getColorFromString(player.color) then guiGridListSetItemColor(tst.GUI.gridlist.lists[2], row, tst.GUI.gridlist.columns[3], getColorFromString(player.color)) end
    end
end
addEvent("onClientRecieveInviteUsers", true)

function tst.toggleWindow()
    local s = guiGetVisible(tst.GUI.window)
    guiSetVisible(tst.GUI.window, not s)
    showCursor(not s, not s)
    if not s then
        addEventHandler("onClientRecieveInviteUsers", me, tst.recieveInviteUsers) addEventHandler("onClientGUITabSwitched", resroot, tst.tabSwitched) addEventHandler("onClientGUIScroll", resroot, tst.teamsettingsChanged) addEventHandler("onClientGUIChanged", resroot, tst.teamsettingsChanged) addEventHandler("onClientGUIClick", resroot, tst.onGUIClick)
    else
        removeEventHandler("onClientGUITabSwitched", resroot, tst.tabSwitched) removeEventHandler("onClientGUIScroll", resroot, tst.teamsettingsChanged) removeEventHandler("onClientGUIChanged", resroot, tst.teamsettingsChanged)  removeEventHandler("onClientGUIClick", resroot, tst.onGUIClick) removeEventHandler("onClientRecieveInviteUsers", me, tst.recieveInviteUsers)
    end
end

function tst.createGUIAttachedToFunction(btn, aF, ...)
    table.insert(tst.GUI.buttons, {source = btn, aFunction = aF, args = ...})
end

function tst.onGUIClick(btn, state)
    if btn ~= "left" or state ~= "up" then return end
    for i, btn in ipairs(tst.GUI.buttons) do
        if btn.source == source then btn.aFunction(btn.args) end
    end
end

function tst.setMemberRank(n)
    local s = guiGridListGetSelectedItem(tst.GUI.gridlist.lists[1])
    if s >= 0 then
        local mName = guiGridListGetItemText(tst.GUI.gridlist.lists[1], s, 1)
        triggerServerEvent("onClientSetMemberRank", resroot, mName, n)
    else
        outputChatBox(tst.prefix .. "Please select a member!", 255, 255, 255, true)
    end
end

function tst.uninvite()
    local s = guiGridListGetSelectedItem(tst.GUI.gridlist.lists[1])
    if s >= 0 then
        local mName = guiGridListGetItemText(tst.GUI.gridlist.lists[1], s, 1)
        triggerServerEvent("onClientUninviteMember", resroot, mName)
    else
        outputChatBox(tst.prefix .. "Please select a member!", 255, 255, 255, true)
    end
end

function tst.leaveTeam()
    triggerServerEvent("onClientLeaveTeam", resroot)
end

function tst.invite()
    local s = guiGridListGetSelectedItem(tst.GUI.gridlist.lists[2])
    if s >= 0 then
        local uName = guiGridListGetItemText(tst.GUI.gridlist.lists[2], s, 1)
        if tst.getInvitePlayer(uName).available then
            triggerServerEvent("onClientInviteMember", resroot, uName)
        else
            outputChatBox(tst.prefix .. "This player is not available!", 255, 255, 255, true)
        end
    else
        outputChatBox(tst.prefix .. "Please select a member!", 255, 255, 255, true)
    end
end

function tst.withdrawInvite()
    local s = guiGridListGetSelectedItem(tst.GUI.gridlist.lists[2])
    if s >= 0 then
        local uName = guiGridListGetItemText(tst.GUI.gridlist.lists[2], s, 1)
        local fP = tst.getInvitePlayer(uName)
        if not fP then return end
        if fP.invTeam == tst.team.name then
            triggerServerEvent("onClientWithdrawInvite", resroot, uName)
        else
            outputChatBox(tst.prefix .. "This player recieved no request for your team!", 255, 255, 255, true)
        end
    else
        outputChatBox(tst.prefix .. "Please select a member!", 255, 255, 255, true)
    end
end

function tst.getInvitePlayer(iName)
    for _, p in ipairs(tst.inviteTable) do
        if removeColorCodes(getPlayerName(p.source)) == iName then
            return p
        end
    end
    return false
end

function tst.updateSelected(sel)
    local s = guiGridListGetSelectedItem(tst.GUI.gridlist.lists[sel])
    if s < 0 then return end
    if sel == 1 then
        local fP = false
        for _, p in ipairs(tst.team.players) do
            if p.accountname == guiGridListGetItemText(tst.GUI.gridlist.lists[1], s, 1) then
                fP = p
            end
        end
        if not fP then return end

        guiSetText(tst.GUI.labels[1], getRealTimeString(fP.joined))
        guiSetText(tst.GUI.labels[2], removeColorCodes(fP.lastusername))
        guiSetText(tst.GUI.labels[3], getRealTimeString(fP.lastonline))
        guiSetText(tst.GUI.labels[4], fP.wins)
    elseif sel == 2 then
        local fP = tst.getInvitePlayer(guiGridListGetItemText(tst.GUI.gridlist.lists[2], s, 1))
        if not fP then return end

        guiSetText(tst.GUI.labels[15], tostring(fP.available))
        guiSetText(tst.GUI.labels[16], tostring(fP.info))
    end
end

function tst.setTeamcash(st)
    if not tonumber(guiGetText(tst.GUI.edits[2])) then return end
    local m = tonumber(guiGetText(tst.GUI.edits[2]))
    if m == 0 then return end
    triggerServerEvent("onClientSetTeamcash", resroot, m, st)
end

function tst.buyChange()
    local r,g,b = math.round(guiScrollBarGetScrollPosition(tst.GUI.scrollbars[1])/100*255), math.round(guiScrollBarGetScrollPosition(tst.GUI.scrollbars[2])/100*255), math.round(guiScrollBarGetScrollPosition(tst.GUI.scrollbars[3])/100*255)
    local tn = guiGetText(tst.GUI.edits[3])
    if tn ~= "" and #tn >= 4 and #tn <= 16 then
        triggerServerEvent("onClientBuyTeamChange", resroot, tn, r, g, b)
    else
        outputChatBox(tst.prefix .. "Invalid teamname!", 255, 255, 255, true)
    end
end

function tst.resetLog()
    triggerServerEvent("onClientResetLog", resroot)
end

function tst.upgradeTeam()
    if tst.team.slots == 15 then outputChatBox(tst.prefix .. "You reached the teamslot limit!", 255, 255, 255, true) return end
    triggerServerEvent("onClientUpgradeTeam", resroot)
end

function tst.teamsettingsChanged()
    if source == tst.GUI.edits[3] or source == tst.GUI.scrollbars[1] or source == tst.GUI.scrollbars[2] or source == tst.GUI.scrollbars[3] then
        local r,g,b = math.round(guiScrollBarGetScrollPosition(tst.GUI.scrollbars[1])/100*255), math.round(guiScrollBarGetScrollPosition(tst.GUI.scrollbars[2])/100*255), math.round(guiScrollBarGetScrollPosition(tst.GUI.scrollbars[3])/100*255)
        guiSetProperty(tst.GUI.window, "CaptionColour", rgbToHex(r, g, b, 255, true))
        guiSetText(tst.GUI.labels[8], r) guiSetText(tst.GUI.labels[9], g) guiSetText(tst.GUI.labels[10], b) guiSetText(tst.GUI.labels[11], ("Hex: %s"):format(rgbToHex(r,g,b)))
        local cr,cg,cb = getColorFromString(tst.team.color)
        local t = #guiGetText(tst.GUI.edits[3])
        local diff = math.abs(cr-r) + math.abs(cg-g) + math.abs(cb-b) + math.abs(t-#tst.team.name)
        guiSetText(tst.GUI.labels[12], convertNumber(diff*10000) .. "$")
    end
end

function tst.upgradePrice(s)
    return 1000000+(1000000/100*(s^2))
end

function tst.notesSave()
    if tst.team.notes.editor == me then
        if tst.team.notes.text == guiGetText(tst.GUI.edits[1]) then return end
        triggerServerEvent("onClientNotesSave", resroot, guiGetText(tst.GUI.edits[1]))
    else
        outputChatBox(tst.prefix .. "Notes are currently editing!", 255, 255, 255, true)
    end
end

function tst.notesChanged()
    if source == tst.GUI.edits[1] then
        if not toboolean(tst.team.notes.editor) then
            triggerServerEvent("onClientNotesEdit", resroot, true)
            removeEventHandler("onClientGUIClick", tst.GUI.edits[1], tst.notesChanged)
        end
    end
end

function tst.tabSwitched()
    if source == tst.GUI.tabpanel.tabs[3] then
        if not toboolean(tst.team.notes.editor) then
            addEventHandler("onClientGUIClick", tst.GUI.edits[1], tst.notesChanged)
        end
    elseif source == tst.GUI.tabpanel.tabs[2] then
        triggerServerEvent("onClientRequestInviteUsers", resroot)
    else
        removeEventHandler("onClientGUIClick", tst.GUI.edits[1], tst.notesChanged)
        if tst.team.notes.editor == me then
            triggerServerEvent("onClientNotesEdit", resroot, false)
        end
    end
end

function tst.createWindow()
    tst.GUI = {tabpanel = {tabs = {}}, gridlist = {lists = {}, columns = {}}, buttons = {}, edits = {}, labels = {}, scrollbars = {}}

    --Window and Tabs
    tst.GUI.window = guiCreateWindow(x/2-650/2, y/2-350/2, 560, 350, "", false)
    guiWindowSetSizable(tst.GUI.window, false)
    guiSetVisible(tst.GUI.window, false)

    tst.GUI.tabpanel.panel = guiCreateTabPanel(0, 24, 560, 350, false, tst.GUI.window)
    tst.GUI.tabpanel.tabs[1] = guiCreateTab("Overview", tst.GUI.tabpanel.panel)
    tst.GUI.tabpanel.tabs[2] = guiCreateTab("Invite", tst.GUI.tabpanel.panel)
    tst.GUI.tabpanel.tabs[3] = guiCreateTab("Notes", tst.GUI.tabpanel.panel)
    tst.GUI.tabpanel.tabs[4] = guiCreateTab("Log", tst.GUI.tabpanel.panel)
    tst.GUI.tabpanel.tabs[5] = guiCreateTab("Settings", tst.GUI.tabpanel.panel)
    tst.GUI.tabpanel.tabs[6] = guiCreateTab("Top Teams", tst.GUI.tabpanel.panel)

    --Tab: Overview
    tst.GUI.gridlist.lists[1] = guiCreateGridList(0, 0, 200, 312, false, tst.GUI.tabpanel.tabs[1])
    tst.GUI.gridlist.columns[1] = guiGridListAddColumn(tst.GUI.gridlist.lists[1], "Member", 0.5)
    tst.GUI.gridlist.columns[2] = guiGridListAddColumn(tst.GUI.gridlist.lists[1], "Rank", 0.5)
    tst.createGUIAttachedToFunction(tst.GUI.gridlist.lists[1], tst.updateSelected, 1)
    guiCreateLabel(210, 50, 150, 30, "Player statistics", false, tst.GUI.tabpanel.tabs[1])
    guiCreateLabel(210, 65, 150, 30, "Joined:", false, tst.GUI.tabpanel.tabs[1])
    guiCreateLabel(210, 80, 150, 30, "Last username:", false, tst.GUI.tabpanel.tabs[1])
    guiCreateLabel(210, 95, 150, 30, "Last seen:", false, tst.GUI.tabpanel.tabs[1])
    guiCreateLabel(210, 110, 150, 30, "Wins:", false, tst.GUI.tabpanel.tabs[1])
    tst.GUI.labels[1] = guiCreateLabel(360, 65, 150, 30, "-", false, tst.GUI.tabpanel.tabs[1])
    tst.GUI.labels[2] = guiCreateLabel(360, 80, 150, 30, "-", false, tst.GUI.tabpanel.tabs[1])
    tst.GUI.labels[3] = guiCreateLabel(360, 95, 150, 30, "-", false, tst.GUI.tabpanel.tabs[1])
    tst.GUI.labels[4] = guiCreateLabel(360, 110, 150, 30, "-", false, tst.GUI.tabpanel.tabs[1])
    tst.createGUIAttachedToFunction(guiCreateButton(210, 10, 150, 30, "Rank up", false, tst.GUI.tabpanel.tabs[1]), tst.setMemberRank, 1)
    tst.createGUIAttachedToFunction(guiCreateButton(380, 10, 150, 30, "Rank down", false, tst.GUI.tabpanel.tabs[1]), tst.setMemberRank, -1)
    tst.createGUIAttachedToFunction(guiCreateButton(210, 250, 150, 30, "Uninvite", false, tst.GUI.tabpanel.tabs[1]), tst.uninvite)
    tst.createGUIAttachedToFunction(guiCreateButton(380, 250, 150, 30, "Leave team", false, tst.GUI.tabpanel.tabs[1]), tst.leaveTeam)
    guiLabelSetColor(guiCreateLabel(210, 35, 320, 15,  "_______________________________________________", false, tst.GUI.tabpanel.tabs[1]), 255, 80, 0)
    guiLabelSetColor(guiCreateLabel(210, 220, 320, 15, "iRace TeamSystem by HorrorClown (PewX)", false, tst.GUI.tabpanel.tabs[1]), 255, 80, 0)
    guiLabelSetColor(guiCreateLabel(210, 230, 320, 15, "_______________________________________________", false, tst.GUI.tabpanel.tabs[1]), 255, 80, 0)

    --Tab: Invite
    guiCreateLabel(210, 10, 150, 30, "Available:", false, tst.GUI.tabpanel.tabs[2])
    guiCreateLabel(210, 25, 150, 30, "Info:", false, tst.GUI.tabpanel.tabs[2])
    tst.GUI.labels[15] = guiCreateLabel(280, 10, 150, 30, "-", false, tst.GUI.tabpanel.tabs[2])
    tst.GUI.labels[16] = guiCreateLabel(280, 25, 300, 30, "-", false, tst.GUI.tabpanel.tabs[2])
    tst.GUI.gridlist.lists[2] = guiCreateGridList(0, 0, 200, 312, false, tst.GUI.tabpanel.tabs[2])
    tst.GUI.gridlist.columns[3] = guiGridListAddColumn(tst.GUI.gridlist.lists[2], "User", 1)
    tst.createGUIAttachedToFunction(tst.GUI.gridlist.lists[2], tst.updateSelected, 2)
    guiLabelSetColor(guiCreateLabel(210, 230, 320, 15, "_______________________________________________", false, tst.GUI.tabpanel.tabs[2]), 255, 80, 0)
    tst.createGUIAttachedToFunction(guiCreateButton(210, 250, 150, 30, "Invite", false, tst.GUI.tabpanel.tabs[2]), tst.invite)
    tst.createGUIAttachedToFunction(guiCreateButton(380, 250, 150, 30, "Withdraw invite", false, tst.GUI.tabpanel.tabs[2]), tst.withdrawInvite)

    --Tab: Notes
    guiCreateLabel(15, 255, 150, 15, "State:", false, tst.GUI.tabpanel.tabs[3])
    tst.GUI.edits[1] = guiCreateMemo(0, 0, 560, 240, "", false, tst.GUI.tabpanel.tabs[3])
    tst.GUI.labels[14] = guiCreateLabel(55, 255, 150, 15, "-", false, tst.GUI.tabpanel.tabs[3])
    tst.createGUIAttachedToFunction(guiCreateButton(380, 250, 150, 30, "Save", false, tst.GUI.tabpanel.tabs[3]), tst.notesSave)

    --Tab: Log
    tst.GUI.gridlist.lists[3] = guiCreateGridList(0, 0, 560, 312, false, tst.GUI.tabpanel.tabs[4])
    tst.GUI.gridlist.columns["member"] = guiGridListAddColumn(tst.GUI.gridlist.lists[3], "Member", 0.2)
    tst.GUI.gridlist.columns["date"] = guiGridListAddColumn(tst.GUI.gridlist.lists[3], "Date", 0.25)
    tst.GUI.gridlist.columns["action"] = guiGridListAddColumn(tst.GUI.gridlist.lists[3], "Action", 0.1)
    tst.GUI.gridlist.columns["message"] = guiGridListAddColumn(tst.GUI.gridlist.lists[3], "Message", 0.45)

    --Tab: Settings
    guiCreateLabel(15, 15, 150, 30, "Teamname:", false, tst.GUI.tabpanel.tabs[5])
    guiCreateLabel(15, 40, 150, 30, "Red:", false, tst.GUI.tabpanel.tabs[5])
    guiCreateLabel(15, 65, 150, 30, "Green:", false, tst.GUI.tabpanel.tabs[5])
    guiCreateLabel(15, 90, 150, 30, "Blue:", false, tst.GUI.tabpanel.tabs[5])
    guiCreateLabel(15, 115, 150, 30, "Change price:", false, tst.GUI.tabpanel.tabs[5])
    tst.GUI.edits[3] = guiCreateEdit(100, 15, 150, 20, tst.team.name, false, tst.GUI.tabpanel.tabs[5])
    guiEditSetMaxLength(tst.GUI.edits[3], 16)
    tst.GUI.scrollbars[1] = guiCreateScrollBar(100, 40, 300, 20, true, false, tst.GUI.tabpanel.tabs[5])
    tst.GUI.scrollbars[2] = guiCreateScrollBar(100, 65, 300, 20, true, false, tst.GUI.tabpanel.tabs[5])
    tst.GUI.scrollbars[3] = guiCreateScrollBar(100, 90, 300, 20, true, false, tst.GUI.tabpanel.tabs[5])
    tst.GUI.labels[8] = guiCreateLabel(405, 40, 150, 30, "0", false, tst.GUI.tabpanel.tabs[5])
    tst.GUI.labels[9] = guiCreateLabel(405, 65, 150, 30, "0", false, tst.GUI.tabpanel.tabs[5])
    tst.GUI.labels[10] = guiCreateLabel(405, 90, 150, 30, "0", false, tst.GUI.tabpanel.tabs[5])
    tst.GUI.labels[11] = guiCreateLabel(405, 15, 150, 30, "Hex: -", false, tst.GUI.tabpanel.tabs[5])
    tst.GUI.labels[12] = guiCreateLabel(100, 115, 150, 30, "-", false, tst.GUI.tabpanel.tabs[5])
    tst.createGUIAttachedToFunction(guiCreateButton(380, 115, 150, 30, "Buy change", false, tst.GUI.tabpanel.tabs[5]), tst.buyChange)
    guiLabelSetColor(guiCreateLabel(15, 140, 515, 15, "___________________________________________________________________________", false, tst.GUI.tabpanel.tabs[5]), 255, 80, 0)

    guiCreateLabel(15, 160, 150, 30, "Team cash:", false, tst.GUI.tabpanel.tabs[5])
    tst.GUI.labels[5] = guiCreateLabel(85, 160, 150, 30, "-", false, tst.GUI.tabpanel.tabs[5])
    tst.GUI.edits[2] = guiCreateEdit(15, 190, 100, 20, "", false, tst.GUI.tabpanel.tabs[5])
    tst.createGUIAttachedToFunction(guiCreateButton(15, 225, 100, 20, "Pay in", false, tst.GUI.tabpanel.tabs[5]), tst.setTeamcash, 1)
    tst.createGUIAttachedToFunction(guiCreateButton(15, 255, 100, 20, "Pay out", false, tst.GUI.tabpanel.tabs[5]), tst.setTeamcash, -1)

    guiCreateLabel(180, 160, 160, 30, "Team slots:", false, tst.GUI.tabpanel.tabs[5])
    guiCreateLabel(180, 190, 150, 30, "Upgrade price:", false, tst.GUI.tabpanel.tabs[5])
    guiCreateLabel(330, 160, 150, 30, "Team created:", false, tst.GUI.tabpanel.tabs[5])
    tst.GUI.labels[6] = guiCreateLabel(250, 160, 100, 30, "-", false, tst.GUI.tabpanel.tabs[5])
    tst.GUI.labels[7] = guiCreateLabel(270, 190, 100, 30, "-", false, tst.GUI.tabpanel.tabs[5])
    tst.GUI.labels[13] = guiCreateLabel(420, 160, 110, 30, "-", false, tst.GUI.tabpanel.tabs[5])
    tst.createGUIAttachedToFunction(guiCreateButton(180, 225, 150, 20, "Upgrade", false, tst.GUI.tabpanel.tabs[5]), tst.upgradeTeam)
    tst.createGUIAttachedToFunction(guiCreateButton(380, 250, 150, 30, "Reset log", false, tst.GUI.tabpanel.tabs[5]), tst.resetLog)

    --Tab: Top Teams
    tst.GUI.gridlist.lists[4] = guiCreateGridList(0, 0, 560, 312, false, tst.GUI.tabpanel.tabs[6])
    tst.GUI.gridlist.columns["team"] = guiGridListAddColumn(tst.GUI.gridlist.lists[4], "Team", 0.2)
    tst.GUI.gridlist.columns["points"] = guiGridListAddColumn(tst.GUI.gridlist.lists[4], "Points", 0.13)
    tst.GUI.gridlist.columns["DM"] = guiGridListAddColumn(tst.GUI.gridlist.lists[4], "DM", 0.13)
    tst.GUI.gridlist.columns["DD"] = guiGridListAddColumn(tst.GUI.gridlist.lists[4], "DD", 0.13)
    tst.GUI.gridlist.columns["HUNTER"] = guiGridListAddColumn(tst.GUI.gridlist.lists[4], "Hunter", 0.13)
    tst.GUI.gridlist.columns["SHOOTER"] = guiGridListAddColumn(tst.GUI.gridlist.lists[4], "Shooter", 0.13)
    tst.GUI.gridlist.columns["EVENT"] = guiGridListAddColumn(tst.GUI.gridlist.lists[4], "Event", 0.13)

    --Other
    guiGridListSetScrollBars(tst.GUI.gridlist.lists[1], false, true)
    guiGridListSetScrollBars(tst.GUI.gridlist.lists[2], false, true)
    guiGridListSetScrollBars(tst.GUI.gridlist.lists[3], false, true)
end