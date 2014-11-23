--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 02.08.2014 - Time: 14:04
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
-----------------------------------------
-- Update #1 -- 03.01.2012 |
-- Farbcode fix
-- Save ReportID
-----------------------------------------
-- Update #2 -- 16.02.2014 |
-- Security fix
-----------------------------------------
-- Update #3 -- 18.03.2014 |
-- Check report text and answer length. Return error if 0

local report = {reports = {}}
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function()
    if not get("reportID") then
        set("reportID", 1)
    end
end)

function report.getReportID()
    return get("reportID")
end

function report.onReport(thePlayer, _, ...)
    if not getElementData(thePlayer, "isLogedIn") then return end
    local reportText = table.concat({...}, " ")
    if string.len(reportText) ~= 0 then
        outputAdminChatBox("|Report| #ff0000ID: " .. report.getReportID() .. " - From: " .. getPlayerName(thePlayer), 255, 255, 255, true)
        outputAdminChatBox("|Report| #ff0000Text: " .. reportText, 255, 255, 255, true)
        report.reports[report.getReportID()] = thePlayer
        outputChatBox("|Report| #ff0000You report was successfully sended to an admin.", thePlayer, 255, 255, 255, true)
        set("reportID", report.getReportID() + 1)
    else
        outputChatBox("|Report| #ff0000Invalid argument. Syntax: /report [text]", thePlayer, 255, 255, 255, true)
    end
end
addCommandHandler("report", report.onReport)
addCommandHandler("support", report.onReport)

function report.answer(thePlayer, _, reportID, ...)
    if isPlayerInAdminGroup(thePlayer) then
        local answerText = table.concat({...}, " ")
        if type(tonumber(reportID)) == "number" and string.len(answerText) ~= 0 then
            local theReportPlayer = report.reports[tonumber(reportID)]
            if theReportPlayer then
                outputChatBox("|Report| " .. getPlayerName(thePlayer) .. "#ffffff:#ff0000 " .. answerText, theReportPlayer, 255, 255, 255, true)
                outputAdminChatBox("|Report| " .. getPlayerName(thePlayer) .. "#ff0000 answered. Report ID: '" .. reportID .. "' from: '" .. getPlayerName(theReportPlayer) .. "#ff0000'", 255, 255, 255, true)
                outputAdminChatBox("|Report| Text: #ff0000" .. answerText, 255, 255, 255, true)
            end
        else
            outputChatBox("|Report| #ff0000Invalid argument. Syntax: /a [id] [text]", thePlayer, 255, 255, 255, true)
        end
    end
end
addCommandHandler("a", report.answer)