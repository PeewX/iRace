--iR|HorrorClown (PewX) - iRace-mta.de - 05.06.2014--
root, resroot = getRootElement(), getResourceRootElement()

function calcBanTime(time, unitOfTime) -- s, m, h, d, w, mo, y (Sekunden, minuten, stunden, Tage, wochen, monate, jahre) --> Umrechnung in Sekunden
    if unitOfTime == "s" then
        if time > 1 then return time, "seconds" else return time, "second" end
    elseif unitOfTime == "m" then
        if time*60 > 60 then return time*60, "minutes" else return time, "minute" end
    elseif unitOfTime == "h" then
        if (time*60)*60 > 3600 then return (time*60)*60, "hours" else return (time*60)*60, "hour" end
    elseif unitOfTime == "d" then
        if ((time*60)*60)*24 > 86400 then return ((time*60)*60)*24, "days" else return ((time*60)*60)*24, "day" end
    elseif unitOfTime == "w" then
        if (((time*60)*60)*24)*7 > 604800 then return (((time*60)*60)*24)*7, "weeks" else return (((time*60)*60)*24)*7, "week" end
    elseif unitOfTime == "mo" then
        if ((((time*60)*60)*24)*7)*30 > 18144000 then return ((((time*60)*60)*24)*7)*30, "months" else return ((((time*60)*60)*24)*7)*30, "month" end
    elseif unitOfTime == "y" then
        if (((((time*60)*60)*24)*7)*30)*12 > 217728000 then return (((((time*60)*60)*24)*7)*30)*12, "years" else return (((((time*60)*60)*24)*7)*30)*12, "year" end
    else
        return false, false
    end
end

function calcMuteTime(time, unitOfTime) -- s, m, h, d (Sekunden, minuten, stunden, Tage) --> Umrechnung in Millisekunden
    if unitOfTime == "s" then
        if time*1000 > 1000 then return time*1000, "seconds" else return time*1000, "second" end
    elseif unitOfTime == "m" then
        if (time*60)*1000 > 60000 then return (time*60)*1000, "minutes" else return (time*60)*1000, "minute" end
    elseif unitOfTime == "h" then
        if ((time*60)*60)*1000 > 3600000 then return ((time*60)*60)*1000, "hours" else return ((time*60)*60)*1000, "hour" end
    elseif unitOfTime == "d" then
        if (((time*60)*60)*24)*1000 > 86400000 then return (((time*60)*60)*24)*1000, "days" else return (((time*60)*60)*24)*1000, "day" end
    else
        return false, false
    end
end

function getAccountFromNamePart(name)
    if name then
        for _, account in ipairs(getAccounts()) do
            if string.find(string.gsub(getAccountName(account), "#%x%x%x%x%x%x", ""):lower(), tostring(name):lower(), 1, true) then
                return account
            elseif string.find(string.gsub(tostring(getAccountData(account, "lastPlayerName")), "#%x%x%x%x%x%x", ""):lower(), tostring(name):lower(), 1, true) then
                return account
            end
        end
    end
    return false
end

function getPlayerFromAccountName(tA)
    for i, player in ipairs(getElementsByType("player")) do
        local plAcc = getPlayerAccount(player)
        if not isGuestAccount(plAcc) then
            local plAccName = getAccountName(plAcc)
            if tA == plAccName then
                return player
            end
        end
    end
    return false
end

function outputAdminChatBox(theText, r, g, b, colorCoded)
    for _, thePlayer in ipairs(getElementsByType("player")) do
        if isPlayerInAdminGroup(thePlayer) then
            outputChatBox(theText, thePlayer, r, g, b, colorCoded)
        end
    end
end

function comp(w1,w2)
    if w1 > w2 then
        return true
    end
end

function checkClient(source, client)
    if source ~= client then
        outputServerLog("AC-INFO: "
                .. " source/client mismatch! "
                .. " Player: " .. tostring(getPlayerName(client))
                .. " Serial: " .. tostring(getPlayerSerial(client))
                .. " IP: " ..     tostring(getPlayerIP(client))
        )
        return false
    else
        return true
    end
end

local eDC = 0
function oEDC(name, oldData)
    if client then if client ~= source then setElementData(source, name, oldData) return end end
    eDC = eDC + 1
    local newData = getElementData(source, name)

    local resourceName = "unknown"
    if sourceResource then resourceName = getResourceName(sourceResource) end

    if getElementType(source) == "player" then
        outputChatBox(("[%s - %s] Changed '%s' from *%s* to %s (%s)"):format(getPlayerName(source), tostring(resourceName),name, tostring(oldData), tostring(newData), eDC))
    else
        outputChatBox(("[%s - %s] Changed '%s' from *%s* to %s (%s)"):format(getElementType(source), tostring(resourceName),name, tostring(oldData), tostring(newData), eDC))
    end
end

addCommandHandler("EDC", function()
    if isEventHandlerAdded("onElementDataChange", root, oEDC) then
        removeEventHandler("onElementDataChange", root, oEDC)
    else
        addEventHandler("onElementDataChange", root, oEDC)
    end
end)