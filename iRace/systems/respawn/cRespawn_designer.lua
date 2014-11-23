--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 02.08.2014 - Time: 14:23
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local rsp = {selected = 1, modes = {}, infoBox = {x = x, y = y/2-300, w = 400, h = 200}}

function rsp.calcBoxResolution()
    --Calc Bottom Interface height
    rsp.BIHeight = (40/1080*y)

    --Calc box height
    rsp.tHeight = dxGetFontHeight(1, iFont[12])
    rsp.bHeight = ((#rsp.modes*rsp.tHeight)+(8*(#rsp.modes-1)))

    --Calc box width for largest text
    local cache = 0
    for _, mode in ipairs(rsp.modes) do
        local tWidth = dxGetTextWidth(mode.text, 1, iFont[12])
        if tWidth > cache then
            cache = tWidth
        end
    end
    rsp.bWidth = cache
end
addEventHandler("onClientResourceStart", resroot, rsp.calcBoxResolution)

function rsp.setRespawnModes(cSetMaps)
    rsp.modes = {}
    table.insert(rsp.modes, {text = "Press space to drive again", key = 0})
    for _, map in ipairs(cSetMaps) do
        table.insert(rsp.modes, {text = "Press space to join: " .. map.info.name, key = map.key})
    end
    rsp.calcBoxResolution()
end
addEvent("onClientSetRespawnModes")
addEventHandler("onClientSetRespawnModes", resroot, rsp.setRespawnModes)

function rsp.draw()
    if g_Userpanel then return end
    dxDrawRectangle(x-rsp.bWidth - 10, y - rsp.BIHeight - rsp.bHeight - 10, rsp.bWidth + 10, rsp.bHeight + 10, tocolor(0, 0, 0, 150))

    for i, mode in ipairs(rsp.modes) do
        if i == rsp.selected then
            dxDrawRectangle(x-rsp.bWidth - 10, y-rsp.BIHeight-rsp.bHeight-5+((rsp.tHeight+8)*(i-1)), rsp.bWidth + 10, rsp.tHeight + 5, tocolor(255, 80, 0, 200))
        end

        dxDrawText(mode.text, x-rsp.bWidth - 5, y-rsp.BIHeight-rsp.bHeight-5+((rsp.tHeight+8)*(i-1)), rsp.bWidth, rsp.bHeight, tocolor(255, 255, 255), 1, iFont[12])
    end
end

function rsp.onClientKey(btn, down)
    if g_Userpanel then return end
    if isChatBoxInputActive() then return end
    if not down then if isTimer(rsp.holdTimer) then killTimer(rsp.holdTimer) end if isTimer(rsp.timer) then killTimer(rsp.timer) end return end
    if btn == "arrow_u" or btn == "arrow_d" then if not isTimer(rsp.holdTimer) then rsp.holdTimer = setTimer(function() if not isTimer(rsp.timer) then rsp.timer = setTimer(rsp.onClientKey, 50, -1, btn, true) end end, 500, 1) end end
    if btn == "arrow_u" then rsp.select(1) return end
    if btn == "arrow_d" then rsp.select(-1) return end
    if btn == "mouse_wheel_up" then rsp.select(1) return end
    if btn == "mouse_wheel_down" then rsp.select(-1) return end
    if btn == "space" then rsp.execute() return end
end

function rsp.select(n)
    local c = rsp.selected - n
    if c == 0 then rsp.selected = #rsp.modes return end
    if c > #rsp.modes then rsp.selected = 1 return end
    rsp.selected = c
end

function rsp.execute()
    if isChatBoxInputActive() then return end
    triggerServerEvent("onClientJoinArea", resroot, rsp.modes[rsp.selected].key)
    rsp.showModes(false)
end

function rsp.showModes(state)
    if state then
        if not rsp.renderModes then
            addEventHandler("onClientRender", root, rsp.draw)
            addEventHandler("onClientKey", root, rsp.onClientKey)
            rsp.renderModes = true
        end
    else
        removeEventHandler("onClientRender", root, rsp.draw)
        removeEventHandler("onClientKey", root, rsp.onClientKey)
        rsp.renderModes = false
    end
end
addEvent("showRespawnModes", true)
addEventHandler("showRespawnModes", me, rsp.showModes)

function rsp.showInfos()
    local function render()
        dxDrawImage(rsp.infoBox.x, rsp.infoBox.y, rsp.infoBox.w, rsp.infoBox.h, rsp.infoBox.renderTarget)
    end

    addEventHandler("onClientRender", root, render)
    rsp.infoBox.move(rsp.infoBox.x - rsp.infoBox.w)
    setTimer(rsp.infoBox.move, 8000, 1, x)
    setTimer(function() removeEventHandler("onClientRender", root, render) end, 10000, 1)
end
addCommandHandler("showInfos", rsp.showInfos)

function rsp.infoBox.move(n) local t = {} local function render() local p = (getTickCount()-t.sT)/(t.eT-t.sT) rsp.infoBox.x = interpolateBetween(t.sX, 0, 0, t.eX, 0, 0, p, "InOutQuad") if p >= 1 then removeEventHandler("onClientRender", root, render) end end t.sT = getTickCount() t.eT = t.sT + 1000 t.sX = rsp.infoBox.x t.eX = n addEventHandler("onClientRender", root, render) end

addEvent("onServerToggleMapInfo", true)
addEventHandler("onServerToggleMapInfo", me, function(mi)
    rsp.info = mi

    rsp.infoBox.renderTarget = dxCreateRenderTarget(rsp.infoBox.w, rsp.infoBox.h, true)
    dxSetRenderTarget(rsp.infoBox.renderTarget, true)
    dxDrawRectangle(0, 0, rsp.infoBox.w, rsp.infoBox.h, tocolor(0, 0, 0, 159))
    dxDrawRectangle(0, 0, rsp.infoBox.w, 22, tocolor(255, 80, 0))
    dxDrawText("Map - Informations", 0, 0, rsp.infoBox.w, 22, tocolor(255, 255, 255), 1, iFontB[12], "center", "center")
    dxDrawText("Map", 20, 40, x, y, tocolor(255, 255, 255), 1, iFont[12])                                               dxDrawText(rsp.info.name, 200, 40, x, y, tocolor(255, 255, 255), 1, iFont[12])
    dxDrawText("Author", 20, 57, x, y, tocolor(255, 255, 255), 1, iFont[12])                                            dxDrawText(rsp.info.author, 200, 57, x, y, tocolor(255, 255, 255), 1, iFont[12])
    dxDrawText("Type", 20, 74, x, y, tocolor(255, 255, 255), 1, iFont[12])                                              dxDrawText(rsp.info.maptype, 200, 74, x, y, tocolor(255, 255, 255), 1, iFont[12])
    dxDrawText("Played count", 20, 91, x, y, tocolor(255, 255, 255), 1, iFont[12])                                      dxDrawText(rsp.info.joinedCount, 200, 91, x, y, tocolor(255, 255, 255), 1, iFont[12])
    dxDrawText("- - - -", 20, 108, x, y, tocolor(255, 255, 255), 1, iFont[12])
    dxDrawText("Shooting", 20, 125, x, y, tocolor(255, 255, 255), 1, iFont[12])                                         dxDrawText(returnStringFromBool(rsp.info.rockets, "preset", 1), 200, 125, x, y, tocolor(255, 255, 255), 1, iFont[12], "left", "top", false, false, false, true)
    dxDrawText("Boost", 20, 142, x, y, tocolor(255, 255, 255), 1, iFont[12])                                            dxDrawText(returnStringFromBool(rsp.info.boost, "preset", 1), 200, 142, x, y, tocolor(255, 255, 255), 1, iFont[12], "left", "top", false, false, false, true)
    dxDrawText("Jump", 20, 159, x, y, tocolor(255, 255, 255), 1, iFont[12])                                             dxDrawText(returnStringFromBool(rsp.info.jump, "preset", 1), 200, 159, x, y, tocolor(255, 255, 255), 1, iFont[12], "left", "top", false, false, false, true)
    dxSetRenderTarget()

    rsp.showInfos()
end)

