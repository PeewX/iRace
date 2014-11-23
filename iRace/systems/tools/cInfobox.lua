--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 29.07.2014 - Time: 20:48
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local screenWidth, screenHeight = guiGetScreenSize()
local infoBox = {}

function displayClientInfo(theHeader, theText, r, g, b, duration, timeToKill)
    infoBox["header"] = theHeader
    infoBox["text"] = theText
    infoBox["colorR"], infoBox["colorG"], infoBox["colorB"] = r, g, b

    infoBox.startTime = getTickCount()
    infoBox.startSize = {dxGetTextWidth(theText, 1, iFontB[16])+(20*2), 0}
    infoBox.endSize = {dxGetTextWidth(theText, 1, iFontB[16])+(20*2), 80}
    infoBox.endTime = infoBox.startTime + duration*1000

    addEventHandler("onClientRender", getRootElement(), popUpInfobox)
    deleteTimer = setTimer(function()
        removeEventHandler("onClientRender", getRootElement(), popUpInfobox)
        addEventHandler("onClientRender", getRootElement(), popOutInfobox)
        infoBox.startTime = getTickCount()
        infoBox.endTime = infoBox.startTime + 500
    end, timeToKill*1000, 1)
end

function popUpInfobox()
    local now = getTickCount()
    local elapsedTime = now-infoBox.startTime
    local duration = infoBox.endTime-infoBox.startTime
    local progress = elapsedTime/duration

    boxWidth, boxHeight, _ = interpolateBetween(infoBox.startSize[1], infoBox.startSize[2], 0, infoBox.endSize[1], infoBox.endSize[2], 0, progress, "OutBounce")

    dxDrawRectangle(screenWidth/2-(boxWidth/2), 0, boxWidth, boxHeight, tocolor(infoBox["colorR"], infoBox["colorG"], infoBox["colorB"], 180), true)
    dxDrawText(infoBox["header"], screenWidth/2-(boxWidth/2), 5, (screenWidth/2-(boxWidth/2))+boxWidth, boxHeight-5, tocolor(255, 255, 255, 255), 1, iFontB[16], "center", "top", true, false, true, true)
    dxDrawText(infoBox["text"], screenWidth/2-(boxWidth/2), 30, (screenWidth/2-(boxWidth/2))+boxWidth, boxHeight-30, tocolor(255, 255, 255, 255), 1, iFont[12], "center", "center", true, false, true, true)
end

function popOutInfobox()
    local now = getTickCount()
    local elapsedTime = now-infoBox.startTime
    local duration = infoBox.endTime-infoBox.startTime
    local progress = elapsedTime/duration

    boxWidth, boxHeight, _ = interpolateBetween(infoBox.endSize[1], infoBox.endSize[2], 0, infoBox.startSize[1], infoBox.startSize[2], 0, progress, "InBack")

    dxDrawRectangle(screenWidth/2-(boxWidth/2), 0, boxWidth, boxHeight, tocolor(infoBox["colorR"], infoBox["colorG"], infoBox["colorB"], 180), true)
    dxDrawText(infoBox["header"], screenWidth/2-(boxWidth/2), 5, (screenWidth/2-(boxWidth/2))+boxWidth, boxHeight-5, tocolor(255, 255, 255, 255), 1, iFontB[16], "center", "top", true, false, true, true)
    dxDrawText(infoBox["text"], screenWidth/2-(boxWidth/2), 30, (screenWidth/2-(boxWidth/2))+boxWidth, boxHeight-30, tocolor(255, 255, 255, 255), 1, iFont[12], "center", "center", true, false, true, true)

    if boxWidth == 0 or boxHeight == 0 then
        removeEventHandler("onClientRender", getRootElement(), popOutInfobox)
    end
end

function initialiseInfobox(theHeader, theText, r, g, b, durationS, removeInS)
    if not(theHeader and theText and r and g and b and durationS and removeInS) then
        outputDebugString("Infobox Error: Invalid arguments")
        return
    end

    if isTimer(deleteTimer) then
        killTimer(deleteTimer)
        removeEventHandler("onClientRender", getRootElement(), popUpInfobox)
        if isEventHandlerAdded("onClientRender", getRootElement(), popOutInfobox) then removeEventHandler("onClientRender", getRootElement(), popOutInfobox) end
    end

    displayClientInfo(theHeader, theText, r, g, b, durationS, removeInS)
end
addEvent("displayClientInfo", true)
addEventHandler("displayClientInfo", getLocalPlayer(), initialiseInfobox)

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if
    type( sEventName ) == 'string' and
            isElement( pElementAttachedTo ) and
            type( func ) == 'function'
    then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end

    return false
end