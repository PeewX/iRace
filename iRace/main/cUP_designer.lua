--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 26.07.2014 - Time: 16:32
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local pTable = {enabled = false, panels = {"Stats", "Shop", "Achievements", "Settings", "PvP", "Close"}, pWidth = 0, pHeight = 100, hover = 0, hoverX = 0, hoverY = y - 10, selected = 0, selectedX = 0, selectedWidth = 0}
g_Userpanel = false

addEventHandler("onClientResourceStart", resroot, function()
    pTable.pWidth = x/#pTable.panels
    pTable.hoverX = -pTable.pWidth
    pTable.pHeight = pTable.pHeight/1080*y
    bindKey("u", "down", togglePanel)
    bindKey("F7", "down", togglePanel)
end)

function togglePanel()
    if not getElementData(me, "isLogedIn") then return end

    if not pTable.enabled then
        showCursor(true, true)
        guiSetInputMode("no_binds_when_editing")
       -- refreshAchieves()
        pTable.enabled = true
        g_Userpanel = true
        addEventHandler("onClientRender", root, drawPanel)
        exports['race']:setRaceGuiEnabled(false)
    else
        pTable.selected = 0
        pTable.selectedWidth = 0
        showCursor(false, true)
        guiSetInputMode("allow_binds")
        pTable.enabled = false
        g_Userpanel = false
        removeEventHandler("onClientRender", root, drawPanel)
        exports['race']:setRaceGuiEnabled(true)
        hideAllPanels()
    end
end

function drawPanel()
    local x1, y1 = 0, y - pTable.pHeight
    dxDrawRectangle(x1, y1, x, pTable.pHeight, tocolor(0, 0, 0, 150))
    dxDrawDoubleLine(x1, y1, x)
    dxDrawRectangle(pTable.hoverX, pTable.hoverY, pTable.pWidth, 2, tocolor(255, 80, 0))

    if pTable.selected ~= 0 then
        dxDrawRectangle(pTable.selectedX, y1+2, pTable.pWidth, pTable.selectedWidth, tocolor(255, 80, 0, 200))
    end

    local hoverCache
    for i, panel in ipairs(pTable.panels) do
        dxDrawText(panel, x1+(pTable.pWidth*(i-1)), y1, x1+pTable.pWidth*i, y, tocolor(255, 255, 255), 2, "arial", "center", "center")

        if isHover(x1+(pTable.pWidth*(i-1)), y1, pTable.pWidth, pTable.pHeight) then
            hoverCache = i
        end
    end

    if hoverCache == nil then
        pTable.hover = 0
        pTable.hoverY = y + 10
    elseif hoverCache ~= nil and pTable.hover == 0 then
        pTable.hover = hoverCache
        pTable.hoverY = y1
        pTable.hoverX = pTable.pWidth*(pTable.hover-1)
    else
        if pTable.hover ~= hoverCache then
            pTable.hover = hoverCache
            selectHoveredPanel()
        end
    end
end

function dxDrawDoubleLine(lx, ly, lwidth)
    ly = math.floor(ly)
    dxDrawLine(lx, ly, lx+lwidth, ly, tocolor(80, 80, 80), 1)
    dxDrawLine(lx, ly+1, lx+lwidth, ly+1, tocolor(50, 50, 50), 1)
end

function selectHoveredPanel()
    local t = {}
    local function render()
        local progress = (getTickCount()-t.sT)/(t.eT-t.sT)
        pTable.hoverX = interpolateBetween(t.sX, 0, 0, t.eX, 0, 0, progress, "OutBack")
        if progress >= 1 then removeEventHandler("onClientPreRender", root, render) end
    end

    t.sT = getTickCount()
    t.eT = t.sT + 600
    t.sX = pTable.hoverX
    t.eX = pTable.pWidth*(pTable.hover-1)
    addEventHandler("onClientPreRender", root, render)
end

function toggleSelectedInOut()
    local t = {}
    local function render()
        local progress = (getTickCount()-t.sT)/(t.eT-t.sT)
        pTable.selectedWidth = interpolateBetween(t.sW, 0, 0, t.eW, 0, 0, progress, "OutQuad")
        if progress >= 1 then removeEventHandler("onClientPreRender", root, render) if pTable.selectedWidth == 0 then pTable.selected = 0 end end
    end

    t.sT = getTickCount()
    t.eT = t.sT + 300
    t.sW = pTable.selectedWidth
    if pTable.selectedWidth > 0 then t.eW = 0 else t.eW = 100 end
    addEventHandler("onClientPreRender", root, render)
end

function selectPanel(_, hover)
    if pTable.selected == 0 then pTable.selectedX = pTable.pWidth*(hover-1) pTable.selected = hover toggleSelectedInOut() return end

    local t = {}
    local function render()
        pTable.selected = hover
        local progress = (getTickCount()-t.sT)/(t.eT-t.sT)
        pTable.selectedX = interpolateBetween(t.sX, 0, 0, t.eX, 0, 0, progress, "OutBack")
        if progress >= 1 then removeEventHandler("onClientPreRender", root, render) end
    end

    t.sT = getTickCount()
    t.eT = t.sT + 400
    t.sX = pTable.selectedX
    t.eX = pTable.pWidth*(hover-1)
    addEventHandler("onClientPreRender", root, render)
end

function panelExecute(panel)
    if panel == 1 then
        toggleStatsPanel()
    elseif panel == 2 then
        toggleShopPanel()
    elseif panel == 3 then
        toggleAchievementsPanel()
    elseif panel == 4 then
        toggleSettingsPanel()
    elseif panel == 5 then
        togglePVPPanel()
    else
        togglePanel()
        return false
    end
    return true
end

addEventHandler("onClientClick", root, function(btn, state)
    if not g_Userpanel then return end
    if btn == "left" and state == "down" then
        for i, _ in ipairs(pTable.panels) do
            if isHover(pTable.pWidth*(i-1), y-pTable.pHeight, pTable.pWidth, pTable.pHeight) then
                if panelExecute(i) then
                    if i == pTable.selected then toggleSelectedInOut() else	selectPanel(i, pTable.hover) end
                end
            end
        end
    end
end)