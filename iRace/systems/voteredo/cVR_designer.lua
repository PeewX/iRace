--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 22.12.2014 - Time: 17:07
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local vrt = {}
vrt.window = {x = -200, y = y*0.6, w = 200, h = 60}

function vrt.render()
    if vrt.renderTarget then
        dxDrawImage(vrt.window.x, vrt.window.y, vrt.window.w/1920*x, vrt.window.h/1080*y, vrt.renderTarget)
        --outputChatBox("Render: " .. vrt.window.x)
    end
end

addEventHandler("onClientRestore", root, function(rts) if vrt.enabled and rts then vrt.updateWindow() end end)

function vrt.updateWindow()
    vrt.renderTarget = dxCreateRenderTarget(vrt.window.w, vrt.window.h, true)
    dxSetRenderTarget(vrt.renderTarget, true)
    dxDrawRectangle(0, 0, vrt.window.w, vrt.window.h, tocolor(0, 0, 0, 160))
    dxDrawRectangle(0, 0, vrt.window.w, 22, tocolor(255, 80, 0))
    dxDrawText("VoteRedo Progress", 0, 0, vrt.window.w, 22, tocolor(255, 255, 255), 1, iFontU[12], "center", "center")
    dxDrawRectangle(2, 24, vrt.window.w/vrt.neededPlayers*vrt.votedPlayers-4, vrt.window.h-26, tocolor(120, 140, 255))
    dxDrawText(("%s/%s"):format(vrt.votedPlayers, vrt.neededPlayers), 0, 22, vrt.window.w, vrt.window.h, tocolor(50, 50, 50), 1, iFontU[10], "center", "center")
    dxSetRenderTarget()
end

function vrt.moveWindow(np, tV)
    local t = {}
    local function render()
        local p = (getTickCount()-t.sT)/(t.eT-t.sT)
        vrt.window.x = interpolateBetween(t.sX, 0, 0, t.eX, 0, 0, p, "InOutQuad")
        if p >= 1 then removeEventHandler("onClientRender", root, render) end
    end
    t.sT = getTickCount()
    t.eT = t.sT + tV
    t.sX = vrt.window.x
    t.eX = np
    addEventHandler("onClientRender", root, render)
end

addEvent("onUpdateVRTable", true)
addEventHandler("onUpdateVRTable", root,
    function(tPlayer)
        if not isEventHandlerAdded("onClientRender", root, vrt.render) then addEventHandler("onClientRender", root, vrt.render) vrt.moveWindow(0, 600) end
        vrt.votedPlayers = tPlayer[1]
        vrt.neededPlayers = tPlayer[2]
        vrt.updateWindow()
    end
)

addEvent("onVREnded", true)
addEventHandler("onVREnded", root,
    function()
        if isEventHandlerAdded("onClientRender", root, vrt.render) then
            vrt.moveWindow(-200, 200)
            setTimer(function() removeEventHandler("onClientRender", root, vrt.render) end, 210, 1)
        end
    end
)