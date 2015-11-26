--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 24.12.2014 - Time: 04:34
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
if CLIENT then x, y = guiGetScreenSize() me = getLocalPlayer() end
iDEBUG = true

function isHover(startX, startY, width, height)
    if isCursorShowing() then
        local pos = {getCursorPosition()}
        return (x*pos[1] >= startX) and (x*pos[1] <= startX + width) and (y*pos[2] >= startY) and (y*pos[2] <= startY + height)
    end
    return false
end

function clearText(sText)
    return sText:gsub("#%x%x%x%x%x%x", ""):gsub("#%x%x%x%x%x%x", "")
end

function debugOutput(sText, nType, cr, cg, cb)
    if iDEBUG then
        outputDebugString(("[%s] %s"):format(SERVER and "Server" or "Client", sText), nType or 3, cr, cg, cb)
    end
end

function getDate(sFormat)
    local time = getRealTime()
    return (sFormat):format(time.year + 1900, time.month + 1, time.monthday)

    --Example formats:
    --YEAR_MONTH_DAY - 2015_11_22: %s_%02d_%02d
    --YEARMONTHDAY - 20151122: "%s%02d%02d"
end

function getTime(sFormat)
    local time = getRealTime()
    return (sFormat):format(time.hour, time.minute, time.second)

    --Example formats:
    --Hour_minute_second - 12_08_55: %02d_%02d_%02d
    --Hour:minute:second - 12_08_55: %02d:%02d:%02d
end