--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 01.08.2014 - Time: 18:19
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
g_noPermissions = "#AA0000You don't have enough permissions to do that!"
g_noReason = "#AA0000You must enter a valid reason!"
g_invalidLength = "#AA0000You must enter a valid time length!"
g_cantFindTarget = "#AA0000Can't find the target player"
g_adminTeams = {[1] = {name = "Projektleiter", color = "#FF0000", rank = 5}, [2] = {name = "Admin", color = "#FF3C00", rank = 4}, [3] = {name = "Moderator", color = "#FF8900", rank = 3}, [4] = {name = "Supporter", color = "#AAFF00", rank = 2}, [5] = {name = "Member", color = "#0064FF", rank = 1}}

local function createAdminTeams()
    for _, team in ipairs(g_adminTeams) do
       team.source = createTeam(team.name, getColorFromString(team.color))
    end
    createTeam("User", 255, 255, 255)
    triggerEvent("onServerCreateTeams", resroot)
end
addEventHandler("onResourceStart", resroot, createAdminTeams)

local function setTeamPlayerInTeam(player)
    if isElement(player) then source = player end
    if not isPlayerInAdminGroup(source) then return end

    local rank, team = getAdminRank(source)
    setPlayerTeam(source, team.source)
end
addEvent("onClientLoggedIn")
addEventHandler("onClientLoggedIn", root, setTeamPlayerInTeam)
addEventHandler("onPlayerChangeNick", root, setTeamPlayerInTeam)

function isPlayerInAdminGroup(thePlayer)
    local theAccount = getPlayerAccount(thePlayer)
    if theAccount and not isGuestAccount(theAccount) then
        if theAccount then
            local theAccountName = getAccountName(theAccount)
            for _, team in ipairs(g_adminTeams) do
                if aclGetGroup(team.name) then
                    if isObjectInACLGroup("user." .. theAccountName, aclGetGroup(team.name)) then return true end
                end
            end
        end
    end
    return false
end

function getAdminRank(thePlayer)
    local theAccount = getPlayerAccount(thePlayer)
    if not isGuestAccount(theAccount) then
        if theAccount then
            local theAccountName = getAccountName(theAccount)
            for _, team in ipairs(g_adminTeams) do
                if isObjectInACLGroup("user." .. theAccountName, aclGetGroup(team.name)) then
                    return team.rank, team
                end
            end
        end
    end
    return false
end

function hasUserPermissionTo(theUser, thePermission)
    local theAccount = getPlayerAccount(theUser)
    if not isGuestAccount(theAccount) then
        if isElement(theUser) and thePermission then
            if hasObjectPermissionTo(theUser, "function." .. thePermission, false) then
                return true
            else
                return false
            end
        else
            return false
        end
    end
    return false
end

function isUserInACLGroup(theUser, theGroup)
    local theAccount = getPlayerAccount(theUser)
    if not isGuestAccount(theAccount) then
        if isElement(theUser) and theGroup then
            if aclGetGroup(theGroup) then
                if isObjectInACLGroup("user." .. getAccountName(getPlayerAccount(theUser)), aclGetGroup(theGroup)) then
                    return true
                end
            end
        else
            return false
        end
    end
    return false
end

function getPlayerAdminGroupColor(thePlayer)
    for _, team in ipairs(g_adminTeams) do
        if isUserInACLGroup(thePlayer, team.name) then
            return team.name, team.color
        end
    end
    return false, false
end

local function clearChat(thePlayer)
    local thePlayerName = getPlayerName(thePlayer)
    if hasUserPermissionTo(thePlayer, "clearChat") then
        for i = 0, 300 do
            outputChatBox (" ", getRootElement(), 255, 255, 255, true)
        end
        outputChatBox("#707070|#ffffffClearChat#707070| #AA0000Admin " .. thePlayerName .. " #AA0000has cleared the chat!", getRootElement(), 255, 0, 0, true)
        triggerEvent("outputLog", getRootElement(), "adminlog", "d", "Admin " .. thePlayerName .. " has cleared the chat!")
    else
        outputChatBox(g_noPermissions, thePlayer, 0, 0, 0, true)
    end
end
addCommandHandler("clearChat", clearChat)

local function quietnessMode(thePlayer)
    local thePlayerName = getPlayerName(thePlayer)
    if hasUserPermissionTo(thePlayer, "quietnessMode") then
        if g_ruhe then
            outputChatBox("#707070|#ffffffBeQuiet#707070| #AA0000The quietness-mode was deactivated by " .. thePlayerName, getRootElement(), 255, 255, 255, true)
            g_ruhe = false
            triggerEvent("outputLog", getRootElement(), "adminlog", "d", "The quietness-mode was deactivated by " .. thePlayerName)
        else
            outputChatBox("#707070|#ffffffBeQuiet#707070| #AA0000The quietness-mode was activated by " .. thePlayerName, getRootElement(), 255, 255, 255, true)
            g_ruhe = true
            triggerEvent("outputLog", getRootElement(), "adminlog", "d", "The quietness-mode was activated by " .. thePlayerName)
        end
    else
        outputChatBox(g_noPermissions, thePlayer, 0, 0, 0, true)
    end
end
addCommandHandler("ruhe", quietnessMode)

local function kickfunc(thePlayer, _, targetPlayer, ...)
    if hasUserPermissionTo(thePlayer, "kickPlayer") then
        local thePlayerName = getPlayerName(thePlayer)
        local targetPlayer = getPlayerFromNamePart(targetPlayer)
        local reason = table.concat({...}, " ")

        if not targetPlayer then outputChatBox(g_cantFindTarget, thePlayer, 0, 0, 0, true) do return end end
        if reason == "" then outputChatBox(g_noReason, thePlayer, 0, 0, 0, true) do return end end

        outputChatBox("#707070|#ffffffAdmin#707070| #AA0000The player " .. getPlayerName(targetPlayer) .. " #AA0000was kicked by " .. thePlayerName .. "#AA0000!", getRootElement(), 0, 0, 0, true)
        outputChatBox("#AA0000Reason: #ffc400" .. reason, getRootElement(), 0, 0, 0, true)
        kickPlayer(targetPlayer, thePlayer, "Reason: " .. reason)
        triggerEvent("outputLog", getRootElement(), "adminlog", "d", "The player " .. getPlayerName(targetPlayer) .. " was kicked by " .. thePlayerName .. " | Reason " .. reason)
    else
        outputChatBox(g_noPermissions, thePlayer, 0, 0, 0, true)
    end
end
addCommandHandler("kick", kickfunc)

local function banPlayerP(thePlayer, _, targetPlayer, ...)
    if hasUserPermissionTo(thePlayer, "banPlayerP") then
        local thePlayerName = getPlayerName(thePlayer)
        local targetPlayer = getPlayerFromNamePart(targetPlayer)
        local reason = table.concat({...}, " ")

        if not targetPlayer then outputChatBox(g_cantFindTarget, thePlayer, 0, 0, 0, true) do return end end
        if reason == "" then outputChatBox(g_noReason, thePlayer, 0, 0, 0, true) do return end end

        outputChatBox("#707070|#ffffffAdmin#707070| #AA0000The player " .. getPlayerName(targetPlayer) .. " #AA0000was permanently banned by " .. thePlayerName .. "#AA0000!", getRootElement(), 0, 0, 0, true)
        outputChatBox("#AA0000Reason: #ffc400" .. reason, getRootElement(), 0, 0, 0, true)
        banPlayer(targetPlayer, true, true, true, thePlayer, "Reason: " .. reason, 0)
        triggerEvent("outputLog", getRootElement(), "adminlog", "d", "The player " .. getPlayerName(targetPlayer) .. " was permanently banned by " .. thePlayerName .. " | Reason " .. reason)
    else
        outputChatBox(g_noPermissions, thePlayer, 0, 0, 0, true)
    end
end
addCommandHandler("pban", banPlayerP)

local function banPlayerT(thePlayer, _, targetPlayer, timeLength, timeUnit, ...)
    if hasUserPermissionTo(thePlayer, "banPlayerT") then
        local thePlayerName = getPlayerName(thePlayer)
        local targetPlayer = getPlayerFromNamePart(targetPlayer)
        local calcedTimeLength, timeUnitText = calcBanTime(timeLength, timeUnit)
        local reason = table.concat({...}, " ")

        if not targetPlayer then outputChatBox(g_cantFindTarget, thePlayer, 0, 0, 0, true) do return end end
        if not calcedTimeLength then outputChatBox(g_invalidLength, thePlayer, 0, 0, 0, true) do return end end
        if reason == "" then outputChatBox(g_noReason, thePlayer, 0, 0, 0, true) do return end end

        outputChatBox("#707070|#ff0000Admin#707070| #AA0000The player " .. getPlayerName(targetPlayer) .. " #AA0000was banned by " .. thePlayerName .. "#AA0000 for " .. timeLength .. " " .. timeUnitText .. "!", getRootElement(), 0, 0, 0, true)
        outputChatBox("#AA0000Reason: #ffc400" .. reason, getRootElement(), 0, 0, 0, true)
        banPlayer(targetPlayer, true, true, true, thePlayer, "Reason: " .. reason .. "(" .. timeLength .. " " .. timeUnitText .. ")", tonumber(calcedTimeLength))
        triggerEvent("outputLog", getRootElement(), "adminlog", "d", "The player " .. getPlayerName(targetPlayer) .. " was banned by " .. thePlayerName .. " for " .. timeLength .. " " .. timeUnitText .. " | Reason " .. reason)
    else
        outputChatBox(g_noPermissions, thePlayer, 0, 0, 0, true)
    end
end
addCommandHandler("tban", banPlayerT)

local function banPlayerOP(thePlayer, _, targetPlayer, ...)
    if hasUserPermissionTo(thePlayer, "banPlayerP") then
        local thePlayerName = getPlayerName(thePlayer)
        local theAccount = getAccountFromNamePart(targetPlayer)
        local reason = table.concat({...}, " ")

        if not theAccount then outputChatBox(g_cantFindTarget, thePlayer, 0, 0, 0, true) do return end end
        if reason == "" then outputChatBox(g_noReason, thePlayer, 0, 0, 0, true) do return end end

        outputChatBox("#707070|#ffffffAdmin#707070| #AA0000The account " .. getAccountName(theAccount) .. " #AA0000was permanently banned by " .. thePlayerName .. "#AA0000!", getRootElement(), 0, 0, 0, true)
        outputChatBox("#AA0000Reason: #ffc400" .. reason, getRootElement(), 0, 0, 0, true)

        local ip, serial = getAccountData(theAccount, "ip"), getAccountData(theAccount, "serial")
        addBan(ip, getAccountName(theAccount), serial, thePlayer, "Reason: " .. reason, 0)
        triggerEvent("outputLog", getRootElement(), "adminlog", "d", "The account " .. getAccountName(theAccount) .. " was permanently banned by " .. thePlayerName .. " (offline) | Reason " .. reason)
    else
        outputChatBox(g_noPermissions, thePlayer, 0, 0, 0, true)
    end
end
addCommandHandler("opban", banPlayerOP)

local function banPlayerOT(thePlayer, _, targetPlayer, timeLength, timeUnit, ...)
    if hasUserPermissionTo(thePlayer, "banPlayerT") then
        local thePlayerName = getPlayerName(thePlayer)
        local theAccount = getAccountFromNamePart(targetPlayer)
        local calcedTimeLength, timeUnitText = calcBanTime(timeLength, timeUnit)
        local reason = table.concat({...}, " ")

        if not theAccount then outputChatBox(g_cantFindTarget, thePlayer, 0, 0, 0, true) do return end end
        if not calcedTimeLength then outputChatBox(g_invalidLength, thePlayer, 0, 0, 0, true) do return end end
        if reason == "" then outputChatBox(g_noReason, thePlayer, 0, 0, 0, true) do return end end

        outputChatBox("#707070|#ff0000Admin#707070| #AA0000The account " .. getAccountName(theAccount) .. " #AA0000was banned by " .. thePlayerName .. "#AA0000 for " .. timeLength .. " " .. timeUnitText .. "!", getRootElement(), 0, 0, 0, true)
        outputChatBox("#AA0000Reason: #ffc400" .. reason, getRootElement(), 0, 0, 0, true)

        local ip, serial = getAccountData(theAccount, "ip"), getAccountData(theAccount, "serial")
        addBan(ip, getAccountName(theAccount), serial, thePlayer, "Reason: " .. reason .. "(" .. timeLength .. " " .. timeUnitText .. ")", tonumber(calcedTimeLength))
        triggerEvent("outputLog", getRootElement(), "adminlog", "d", "The account " .. getAccountName(theAccount) .. " was banned by " .. thePlayerName .. " for " .. timeLength .. " " .. timeUnitText .. " (offline) | Reason " .. reason)
    else
        outputChatBox(g_noPermissions, thePlayer, 0, 0, 0, true)
    end
end
addCommandHandler("otban", banPlayerOT)

local function mutePlayer(thePlayer, _, targetPlayer, timeLength, timeUnit, ...)
    if hasUserPermissionTo(thePlayer, "mutePlayer") then
        local thePlayerName = getPlayerName(thePlayer)
        local targetPlayer = getPlayerFromNamePart(targetPlayer)
        local calcedTimeLength, timeUnitText = calcMuteTime(timeLength, timeUnit)
        local reason = table.concat({...}, " ")

        if not targetPlayer then outputChatBox(g_cantFindTarget, thePlayer, 0, 0, 0, true) do return end end

        if not isPlayerMuted(targetPlayer) then
            if not calcedTimeLength then outputChatBox(g_invalidLength, thePlayer, 0, 0, 0, true) do return end end
            if reason == "" then outputChatBox(g_noReason, thePlayer, 0, 0, 0, true) do return end end

            setPlayerMuted(targetPlayer, true)
            outputChatBox("#707070|#ffffffAdmin#707070| #AA0000The player " .. getPlayerName(targetPlayer) .. " #AA0000was muted by " .. thePlayerName .. "#AA0000 for " .. timeLength .. " " .. timeUnitText .. "!", getRootElement(), 0, 0, 0, true)
            outputChatBox("#AA0000Reason: #ffc400" .. reason, getRootElement(), 0, 0, 0, true)

            g_muteTimers[getAccountName(getPlayerAccount(targetPlayer))] = setTimer(function(targetPlayer)
                g_muteTimers[getAccountName(getPlayerAccount(targetPlayer))] = false
                setPlayerMuted(targetPlayer, false)
                outputChatBox("#707070|#ffffffAdmin#707070| #AA0000The player " .. getPlayerName(targetPlayer) .. " #AA0000can now write again.", getRootElement(), 0, 0, 0, true)
            end, calcedTimeLength, 1, targetPlayer)--setTimer(setPlayerMuted, calcedTimeLength, 1, targetPlayer, false)
            --setTimer(outputChatBox, calcedTimeLength, 1, "#707070|#ffffffAdmin#707070| #AA0000The player " .. getPlayerName(targetPlayer) .. " can now write again.", getRootElement(), 0, 0, 0, true)
            triggerEvent("outputLog", getRootElement(), "adminlog", "d", "The player " .. getPlayerName(targetPlayer) .. " was muted by " .. thePlayerName .. " for " .. timeLength .. " " .. timeUnitText .. " | Reason: " .. reason)
        else
            setPlayerMuted(targetPlayer, false)
            outputChatBox("#707070|#ffffffAdmin#707070| #AA0000The player " .. getPlayerName(targetPlayer) .. " #AA0000 was unmuted by " .. thePlayerName .. "#AA0000!", getRootElement(), 0, 0, 0, true)
            if isTimer(g_muteTimers[getAccountName(getPlayerAccount(targetPlayer))]) then killTimer(g_muteTimers[getAccountName(getPlayerAccount(targetPlayer))]) end
            g_muteTimers[getAccountName(getPlayerAccount(targetPlayer))] = false
            triggerEvent("outputLog", getRootElement(), "adminlog", "d", "The player " .. getPlayerName(targetPlayer) .. " was unmuted by " .. thePlayerName)
        end
    else
        outputChatBox(g_noPermissions, thePlayer, 0, 0, 0, true)
    end
end
addCommandHandler("mute", mutePlayer)

local function getMuteTime(thePlayer)
    if isPlayerMuted(thePlayer) then
        local theTimer = g_muteTimers[getAccountName(getPlayerAccount(thePlayer))]
        if isTimer(theTimer) then
            local r, _, _ = getTimerDetails(theTimer)
            outputChatBox("#707070|#ffffffAdmin#707070| #AA0000You can write again in " .. math.floor((r/1000/60)+0.5) .. " minutes!", thePlayer, 0, 0, 0, true)
        end
    else
        outputChatBox("#707070|#ffffffAdmin#707070| #AA0000You are not muted.", thePlayer, 0, 0, 0, true)
    end
end
addCommandHandler("mtime", getMuteTime)

local function freezePlayer(thePlayer, _, targetPlayer)
    if hasUserPermissionTo(thePlayer, "freezePlayer") then
        local thePlayerName = getPlayerName(thePlayer)
        local targetPlayer = getPlayerFromNamePart(targetPlayer)

        if not targetPlayer then outputChatBox(g_cantFindTarget, thePlayer, 0, 0, 0, true) do return end end

        local targetPlayerVehicle = getPedOccupiedVehicle(targetPlayer)
        if targetPlayerVehicle then
            if not isElementFrozen(targetPlayerVehicle) then
                setElementFrozen(targetPlayerVehicle, true)
                outputChatBox("#707070|#ffffffAdmin#707070| #AA0000 You has been frozen the player " .. getPlayerName(targetPlayer), thePlayer, 0, 0, 0, true)
                outputChatBox("#707070|#ffffffAdmin#707070| #AA0000 You has been frozen by " .. thePlayerName, targetPlayer, 0, 0, 0, true)
                triggerEvent("outputLog", getRootElement(), "adminlog", "d", "The player " .. getPlayerName(targetPlayer) .. " has frozen " .. thePlayerName)
            else
                setElementFrozen(targetPlayerVehicle, false)
                outputChatBox("#707070|#ffffffAdmin#707070| #AA0000 You has been unfrozen the player " .. getPlayerName(targetPlayer), thePlayer, 0, 0, 0, true)
                outputChatBox("#707070|#ffffffAdmin#707070| #AA0000 You has been unfrozen by " .. thePlayerName, targetPlayer, 0, 0, 0, true)
                triggerEvent("outputLog", getRootElement(), "adminlog", "d", "The player " .. getPlayerName(targetPlayer) .. " has unfrozen " .. thePlayerName)
            end
        end
    else
        outputChatBox(g_noPermissions, thePlayer, 0, 0, 0, true)
    end
end
addCommandHandler("freeze", freezePlayer)

local function blowPlayer(thePlayer, _, targetPlayer)
    if hasUserPermissionTo(thePlayer, "blowPlayer") then
        local thePlayerName = getPlayerName(thePlayer)
        local targetPlayer = getPlayerFromNamePart(targetPlayer)

        if not targetPlayer then outputChatBox(g_cantFindTarget, thePlayer, 0, 0, 0, true) do return end end

        local targetPlayerVehicle = getPedOccupiedVehicle(targetPlayer)
        if targetPlayerVehicle then
            outputChatBox("#707070|#ffffffAdmin#707070| #AA0000You has been blowed by " .. thePlayerName, targetPlayer, 0, 0, 0, true)
            blowVehicle(targetPlayerVehicle)
            triggerEvent("outputLog", getRootElement(), "adminlog", "d", "The player " .. getPlayerName(targetPlayer) .. " was blowed by " .. thePlayerName)
        end
    else
        outputChatBox(g_noPermissions, thePlayer, 0, 0, 0, true)
    end
end
addCommandHandler("blow", blowPlayer)

---

local function deleteAccount(thePlayer, _, targetPlayer)
    if hasUserPermissionTo(thePlayer, "deleteAccount") then
        local targetAccount = getAccount(targetPlayer)
        if targetAccount then
            local targetAccountName = getAccountName(targetAccount)
            local bool = removeAccount(targetAccount)
            if bool then
                outputChatBox("#707070|#ffffffAdmin#707070| #AA0000The account " .. targetAccountName .. " #AA0000was successfully deleted!", thePlayer, 0, 0, 0, true)
                triggerEvent("outputLog", getRootElement(), "adminlog", "d", "The account " .. targetAccountName .. " was successfully deleted by" .. getPlayerName(thePlayer))
            end
        else
            outputChatBox("#707070|#ffffffAdmin#707070| #AA0000Can't find the account!", thePlayer, 0, 0, 0, true)
        end
    else
        outputChatBox(g_noPermissions, thePlayer, 0, 0, 0, true)
    end
end
addCommandHandler("removeAccount", deleteAccount)

local function setAccountDataFunc(thePlayer, _, targetPlayer, theData, theValue)
    if hasUserPermissionTo(thePlayer, "setAccountData") then
        local thePlayerName = getPlayerName(thePlayer)
        local targetPlayer = getPlayerFromNamePart(targetPlayer)

        if not targetPlayer then outputChatBox(g_cantFindTarget, thePlayer, 0, 0, 0, true) do return end end
        if not theData then outputChatBox("#707070|#ffffffAdmin#707070| #AA0000You must enter a valid datatype!", thePlayer, 0, 0, 0, true) do return end end
        if not theValue then outputChatBox("#707070|#ffffffAdmin#707070| #AA0000You must enter a valid value!", thePlayer, 0, 0, 0, true) do return end end

        local targetPlayerAccount = getPlayerAccount(targetPlayer)

        local bool = setAccountData(targetPlayerAccount, theData, theValue)
        if bool then
            outputChatBox("#707070|#ffffffAdmin#707070| #AA0000Changed successfully datatype '#ffffff" .. theData .. "#AA0000' to '#ffffff" .. theValue .. "#AA0000'", thePlayer, 0, 0, 0, true)
            outputChatBox("#707070|#ffffffAdmin#707070| #AA0000Changed successfully datatype '#ffffff" .. theData .. "#AA0000' to '#ffffff" .. theValue .. "#AA0000' by " .. thePlayerName, targetPlayer, 0, 0, 0, true)
            triggerEvent("outputLog", getRootElement(), "adminlog", "c", "Changed successfully datatype '" .. theData .. "' to '" .. theValue .. "' by " .. thePlayerName)
        end
    else
        outputChatBox(g_noPermissions, thePlayer, 0, 0, 0, true)
    end
end
addCommandHandler("setAccountData", setAccountDataFunc)

local function getAccountDataFunc(thePlayer, _, targetPlayer, theData)
    if hasUserPermissionTo(thePlayer, "getAccountData") then
        local thePlayerName = getPlayerName(thePlayer)
        local targetPlayer = getPlayerFromNamePart(targetPlayer)

        if not targetPlayer then outputChatBox(g_cantFindTarget, thePlayer, 0, 0, 0, true) do return end end
        if not theData then outputChatBox("#707070|#ffffffAdmin#707070| #AA0000You must enter a valid datatype!", thePlayer, 0, 0, 0, true) do return end end

        local targetPlayerAccount = getPlayerAccount(targetPlayer)
        local theAccountData = getAccountData(targetPlayerAccount, theData)
        outputChatBox("#707070|#ffffffAdmin#707070| #AA0000Account data #ffffff" .. theData .. "#AA0000: " .. tostring(theAccountData), thePlayer, 0, 0, 0, true)
    else
        outputChatBox(g_noPermissions, thePlayer, 0, 0, 0, true)
    end
end
addCommandHandler("getAccountData", getAccountDataFunc)

local function setAdminTeamGroup(thePlayer, _, targetPlayer, targetTeam)
    if hasUserPermissionTo(thePlayer, "addToTeam") then
        local thePlayerName = getPlayerName(thePlayer)
        local targetPlayer = getPlayerFromNamePart(targetPlayer)
        local teamToAdd = false

        if not targetPlayer then outputChatBox(g_cantFindTarget, thePlayer, 0, 0, 0, true) do return end end
        if not targetTeam then outputChatBox("#707070|#ffffffAdmin#707070| #AA0000You must enter a valid team group!", thePlayer, 0, 0, 0, true) do return end end

        if targetTeam:lower() == "projektleiter" then
            teamToAdd = "Projektleiter"
        elseif targetTeam:lower() == "admin" then
            teamToAdd = "Admin"
        elseif targetTeam:lower() == "moderator" then
            teamToAdd = "Moderator"
        elseif targetTeam:lower() == "supporter" then
            teamToAdd = "Supporter"
        elseif targetTeam:lower() == "member" then
            teamToAdd = "Member"
        else
            outputChatBox("#707070|#ffffffAdmin#707070| #AA0000Invalid admin group!", thePlayer, 0, 0, 0, true)
            do return end
        end

        local targetPlayerAccountName = getAccountName(getPlayerAccount(targetPlayer))
        addToAdminGroup(teamToAdd, targetPlayerAccountName)
        outputChatBox("#707070|#ffffffAdmin#707070| #AA0000" .. getPlayerName(targetPlayer) .. " is now a " .. teamToAddColor .. teamToAdd .. "#AA0000!", getRootElement(), 0, 0, 0, true)
    else
        outputChatBox(g_noPermissions, thePlayer, 0, 0, 0, true)
    end
end
addCommandHandler("addTeam", setAdminTeamGroup)

function removeFromTeam(thePlayer, _, targetPlayer)
    if hasUserPermissionTo(thePlayer, "removeFromTeam") then
        local thePlayerName = getPlayerName(thePlayer)
        local targetPlayer = getPlayerFromNamePart(targetPlayer)

        if not targetPlayer then outputChatBox(g_cantFindTarget, thePlayer, 0, 0, 0, true) do return end end

        local targetPlayerAccountName = getAccountName(getPlayerAccount(targetPlayer))
        removeFromAdminTeam(targetPlayerAccountName)

        outputChatBox("#707070|#ffffffAdmin#707070| #AA0000" .. getPlayerName(targetPlayer) .. " was removed from iRace-Team by " .. thePlayerName .. "#AA0000!", getRootElement(), 0, 0, 0, true)
    else
        outputChatBox(g_noPermissions, thePlayer, 0, 0, 0, true)
    end
end
addCommandHandler("removeTeam",removeFromTeam)

function addToAdminGroup(teamToAdd, theAccount)
    if isObjectInACLGroup("user." .. theAccount, aclGetGroup("Member")) then
        aclGroupRemoveObject(aclGetGroup("Member"), "user." .. theAccount)
    elseif isObjectInACLGroup("user." .. theAccount, aclGetGroup("Supporter")) then
        aclGroupRemoveObject(aclGetGroup("Supporter"), "user." .. theAccount)
    elseif isObjectInACLGroup("user." .. theAccount, aclGetGroup("Moderator")) then
        aclGroupRemoveObject(aclGetGroup("Moderator"), "user." .. theAccount)
    elseif isObjectInACLGroup("user." .. theAccount, aclGetGroup("Admin")) then
        aclGroupRemoveObject(aclGetGroup("Admin"), "user." .. theAccount)
    elseif isObjectInACLGroup("user." .. theAccount, aclGetGroup("Projektleiter")) then
        aclGroupRemoveObject(aclGetGroup("Projektleiter"), "user." .. theAccount)
    end

    aclGroupAddObject(aclGetGroup(teamToAdd), "user." .. theAccount)
end

function removeFromAdminTeam(theAccount)
    if isObjectInACLGroup("user." .. theAccount, aclGetGroup("Member")) then
        aclGroupRemoveObject(aclGetGroup("Member"), "user." .. theAccount)
    elseif isObjectInACLGroup("user." .. theAccount, aclGetGroup("Supporter")) then
        aclGroupRemoveObject(aclGetGroup("Supporter"), "user." .. theAccount)
    elseif isObjectInACLGroup("user." .. theAccount, aclGetGroup("Moderator")) then
        aclGroupRemoveObject(aclGetGroup("Moderator"), "user." .. theAccount)
    elseif isObjectInACLGroup("user." .. theAccount, aclGetGroup("Admin")) then
        aclGroupRemoveObject(aclGetGroup("Admin"), "user." .. theAccount)
    elseif isObjectInACLGroup("user." .. theAccount, aclGetGroup("Projektleiter")) then
        aclGroupRemoveObject(aclGetGroup("Projektleiter"), "user." .. theAccount)
    end
end

local function changeUserPassword(thePlayer, _, targetAccountName, thePassword)
    if hasUserPermissionTo(thePlayer, "changeUserPassword") then
        local targetAccount = getAccount(targetAccountName)

        if not targetAccount then outputChatBox(g_cantFindTarget, thePlayer, 0, 0, 0, true) do return end end

        local bool = setAccountPassword(targetAccount, thePassword)
        if bool then
            outputChatBox("#707070|#ffffffAdmin#707070| #AA0000Password from " .. targetAccountName .. " #AA0000changed to: '#ffffff" .. thePassword .."#AA0000'!", thePlayer, 0, 0, 0, true)
            triggerEvent("outputLog", getRootElement(), "adminlog", "c", "Password from " .. targetAccountName .. " changed to '" .. thePassword .. "' by " .. getPlayerName(thePlayer))
        end
    else
        outputChatBox(g_noPermissions, thePlayer, 0, 0, 0, true)
    end
end
addCommandHandler("setPassword", changeUserPassword)

local function changeUserStatus(thePlayer, _, targetPlayer, ...)
    if hasUserPermissionTo(thePlayer, "changeUserStatus") then
        local thePlayerName = getPlayerName(thePlayer)
        local targetPlayer = getPlayerFromNamePart(targetPlayer)
        local theStatus = table.concat({...}, " ")

        if not targetPlayer then outputChatBox(g_cantFindTarget, thePlayer, 0, 0, 0, true) do return end end
        if theStatus == "" then outputChatBox("#AA0000You must enter a valid status!", thePlayer, 0, 0, 0, true) do return end end

        local targetPlayerAccount = getPlayerAccount(targetPlayer)

        if not isGuestAccount(targetPlayerAccount) then
            setAccountData(targetPlayerAccount, "playerstatus", theStatus)
            outputChatBox("#707070|#ffffffAdmin#707070| #AA0000Status from " .. getPlayerName(targetPlayer) .. " #AA0000changed to '" .. theStatus .. "#AA0000'!", thePlayer, 0, 0, 0, true)
            outputChatBox("#707070|#ffffffAdmin#707070| #AA0000Your status changed to '" .. theStatus .. "#AA0000' by " .. thePlayerName, targetPlayer, 0, 0, 0, true)
            triggerEvent("outputLog", getRootElement(), "adminlog", "c", "Status from " .. getPlayerName(targetPlayer) .. " changed to '" .. theStatus)
        end
    else
        outputChatBox(g_noPermissions, thePlayer, 0, 0, 0, true)
    end
end
addCommandHandler("status", changeUserStatus)