--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 31.07.2014 - Time: 20:55
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local draw = false
local maxHeight = 930

local function dxDrawDoubleLine(lx, ly, lwidth)
    ly = math.floor(ly)
    dxDrawLine(lx, ly, lx+lwidth, ly, tocolor(0, 160, 255, 255), 1)
    dxDrawLine(lx, ly+1, lx+lwidth, ly+1, tocolor(100, 100, 100, 255), 1)
end

addEvent("onClientDrawAltitude", true)
addEventHandler("onClientDrawAltitude", me, function()
    if not draw then
        draw = true
        addEventHandler("onClientRender", root, drawAltitude)
    end
end)

function drawAltitude()
    local theVehicle = getPedOccupiedVehicle(me)
    if isAircraft(theVehicle) then
        local _, _, z = getElementPosition(theVehicle)
        if not g_Userpanel then
            dxDrawDoubleLine(0, y-2, x/maxHeight*z)--dxDrawDoubleLine(0, sy-(40/1080)*sy, sx/maxHeight*z)
        end
    else
        removeEventHandler("onClientRender", root, drawAltitude)
        draw = false
    end
end

local function dxDrawCountdownLine(lx, ly, lwidth)
    ly = math.floor(ly)
    dxDrawLine(lx, ly, lx+lwidth, ly, tocolor(0, 0, 0, 255), 1)
    --dxDrawLine(lx, ly-1, lx+lwidth, ly-1, tocolor(100, 100, 100, 255), 1)
end

local cd = {}
addEvent("drawNextMapCountdown", true)
addEventHandler("drawNextMapCountdown", root, function()
    local function render()
        if not getElementData(me, "isLogedIn") then return end
        local progress = (getTickCount()-cd.sT)/(cd.eT-cd.sT)
        local width, _, _ = interpolateBetween(cd.sX, 0, 0, cd.eX, 0, 0, progress, "InOutQuad")

        if not g_Userpanel then	dxDrawCountdownLine(0, Interface.startY, width) end
        if progress >= 1.5 then removeEventHandler("onClientRender", root, render) end
    end
    cd.sX, cd.eX = 0, x
    cd.sT = getTickCount()
    cd.eT = cd.sT + 5000
    addEventHandler("onClientRender", root, render)
end)