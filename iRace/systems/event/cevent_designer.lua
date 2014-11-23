--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 26.07.2014 - Time: 17:27
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local evt = {infoBox = {x = x/2-(350/1920*x)/2, y = 0, w = 350/1920*x, h = 200/1080*y}, endScreen = {i = {w = 0, h = 0}, b = {w = 0, h = 0, a = 0}}}

function evt.render()
    if evt.renderTarget then
        dxDrawImage(evt.infoBox.x, evt.infoBox.y, evt.infoBox.w, evt.infoBox.h, evt.renderTarget)
    end
end

function evt.updateEventWindow()
    local x = 0
    if evt.event.pot == 1 and #evt.event.items > 5 then if evt.isClientInTop(evt.event.items) then x = 5 else x = 6 end else x = #evt.event.items end
    evt.infoBox.h = 115/1080*y+18/1080*y*x
    evt.renderTarget = dxCreateRenderTarget(evt.infoBox.w, evt.infoBox.h, true)

    local title, m
    if evt.event.pot == 1 then title,m = ("Player match - %s Event"):format(evt.event.type),"Players" else title,m = ("Team match - %s Event"):format(evt.event.type),"Teams" end

    dxSetRenderTarget(evt.renderTarget, true)
    dxDrawRectangle(0, 0, evt.infoBox.w, evt.infoBox.h, tocolor(0, 0, 0, 160))
    dxDrawRectangle(0, 0, evt.infoBox.w, 22/1080*y, tocolor(255, 80, 0))
    dxDrawText(title, 0, 0, evt.infoBox.w, 22/1080*y, tocolor(255, 255, 255), 1, iFontB[12], "center", "center")

    local cX, cY, cX2, r, ab = 7, 25/1080*y, evt.infoBox.w*0.5, evt.infoBox.w - 7, 18/1080*y
    dxDrawText("You can win:", cX, cY, x, y, tocolor(255, 255, 255), 1, iFont[12])                 dxDrawText(convertNumber(evt.event.price) .. "$", cX2, cY, r, y, tocolor(255, 255, 255), 1, iFont[12], "right")
    dxDrawText("Event ends in:", cX, cY + ab, x, y, tocolor(255, 255, 255), 1, iFont[12])          dxDrawText(getRealTimeString(evt.event.stop), cX2, cY + ab, r, y, tocolor(255, 255, 255), 1, iFont[12], "right")
    dxDrawText("Multiplicator:", cX, cY + ab*2, x, y, tocolor(255, 255, 255), 1, iFont[12])        dxDrawText("x" .. evt.event.cm, cX2, cY + ab*2, r, y, tocolor(255, 255, 255), 1, iFont[12], "right")
    dxDrawLine(cX, cY+(20/1080*y)*3, evt.infoBox.w - cX, cY+(20/1080*y)*3, tocolor(80, 80, 80), 1)
    local cY = cY+(20/1080*y)*3+5
    dxDrawText(m, cX, cY, x, y, tocolor(255, 255, 255), 1, iFont[12])                               dxDrawText("Points", cX2, cY, x,y, tocolor(255, 255, 255), 1, iFont[12])
    for i, item in ipairs(evt.event.items) do
        if i <= 5 then
            dxDrawText(i, cX, cY+ab*i, x, y, tocolor(255, 255, 255), 1, iFont[11])                  dxDrawText(item.name, cX+20, cY+ab*i, x, y, tocolor(255, 255, 255), 1, iFont[11], "left", "top", false, false, false, true) dxDrawText(item.points, cX2, cY+ab*i, x, y, tocolor(255, 255, 255), 1, iFont[11])
        elseif item.source == me then
            dxDrawText(i, cX, cY+ab*6, x, y, tocolor(255, 255, 255), 1, iFont[11])                  dxDrawText(item.name, cX+20, cY+ab*6, x, y, tocolor(255, 255, 255), 1, iFont[11], "left", "top", false, false, false, true) dxDrawText(item.points, cX2, cY+ab*6, x, y, tocolor(255, 255, 255), 1, iFont[11])
        end
    end
    dxSetRenderTarget()
end

function evt.isClientInTop(t)
    for i, item in ipairs(t) do
        if item.source == me then
            if i <= 5 then return true end
        end
    end
end

function evt.onClientPlayerWasted()
    if source ~= me then return end
    evt.moveWindow(0)
    removeEventHandler("onClientPlayerWasted", root, evt.onClientPlayerWasted)
end

addEvent("onClientRaceStateChanging", true)
addEventHandler("onClientRaceStateChanging", root,
    function(rs)
        if rs == "Running" then
            if not isEventHandlerAdded("onClientPlayerWasted", root, evt.onClientPlayerWasted) then
                addEventHandler("onClientPlayerWasted", root, evt.onClientPlayerWasted)
                evt.moveWindow(-evt.infoBox.h)
            end
        else
            if isEventHandlerAdded("onClientPlayerWasted", root, evt.onClientPlayerWasted) then
                removeEventHandler("onClientPlayerWasted", root, evt.onClientPlayerWasted)
                evt.moveWindow(0)
            end
        end
    end
)

function evt.moveWindow(np)
    local t = {}
    local function render()
        local p = (getTickCount()-t.sT)/(t.eT-t.sT)
        evt.infoBox.y = interpolateBetween(t.sY, 0, 0, t.eY, 0, 0, p, "InOutQuad")
        if p >= 1 then removeEventHandler("onClientRender", root, render) end
    end
    t.sT = getTickCount()
    t.eT = t.sT + 1000
    t.sY = evt.infoBox.y
    t.eY = np
    addEventHandler("onClientRender", root, render)
end

addEvent("onEventUpdate", true)
addEventHandler("onEventUpdate", me, function(dataTable)
    evt.event = dataTable
    evt.updateEventWindow()
end)

addEventHandler("onClientRestore", root, function(rts) if evt.event and rts then evt.updateEventWindow() end end)

addEvent("onRandomEventInitialised", true)
addEventHandler("onRandomEventInitialised", me, function(dataTable)
    evt.event = dataTable

    if dataTable then
        evt.updateEventWindow()
        addEventHandler("onClientRender", root, evt.render)
    else
        removeEventHandler("onClientRender", root, evt.render)
    end
end)

local nRot = 0
function evt.renderEndScreen()
    nRot = nRot + 1 if nRot > 360 then nRot = 0 end

    local bW, bH = evt.endScreen.b.w, evt.endScreen.b.h
    local sX, sY = x/2-bW/2, y/2-bH/2

    dxDrawImage(sX, sY, bW, bH, "files/images/event/bg.png", nRot, 0, 0, tocolor(255, 255, 255, evt.endScreen.b.a))
    if evt.endScreen.avatar then dxDrawImageBOB(x/2-128/2, y/2-128/2, 128, 128, evt.endScreen.avatar, tocolor(255, 255, 255, 255/200*evt.endScreen.b.a)) end
    dxDrawText(evt.endScreen.text, sX-2, y/2 +80-2, sX + bW, y, tocolor(0, 0, 0, evt.endScreen.b.a), 1, iFontB[20], "center", "top", true)
    dxDrawText(evt.endScreen.text, sX, y/2 +80, sX + bW, y, tocolor(220, 220, 220, 255/200*evt.endScreen.b.a), 1, iFontB[20], "center", "top", true)
end

function evt.resizeBG(n ,tx, na)
    local t = {}
    local function render()
        local p = (getTickCount()-t.sT)/(t.eT-t.sT)
        evt.endScreen.b.w, evt.endScreen.b.h, evt.endScreen.b.a = interpolateBetween(t.sW, t.sH, t.sA, t.eW, t.eH, t.eA, p, "OutQuad")
        if p >= 1 then removeEventHandler("onClientRender", root, render) end
    end
    t.sT = getTickCount()
    t.eT = t.sT + tx
    t.sW = evt.endScreen.b.w
    t.sH = evt.endScreen.b.h
    t.sA = evt.endScreen.b.a
    t.eW = n
    t.eH = n
    t.eA = na
    addEventHandler("onClientRender", root, render)
end

addEvent("onClientShowEndScreen", true)
addEventHandler("onClientShowEndScreen", me,
    function(text, avatar)
        evt.endScreen.text = text
        evt.endScreen.avatar = avatar
        addEventHandler("onClientRender", root, evt.renderEndScreen)
        --evt.resizeBG(600/1920*x)
        evt.resizeBG(900/1920*x, 3000, 200)
        setTimer(
            function()
                evt.resizeBG(0, 500, 0)
                setTimer(function() removeEventHandler("onClientRender", root, evt.renderEndScreen) end, 5000, 1)
            end
        , 10000, 1)
    end
)