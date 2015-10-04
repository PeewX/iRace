local sx,sy = guiGetScreenSize()
--[[local posx = sy * 0.05
local posy = sy * 0.725]]
local posx = sy * 0.015
local posy = sy * 0.72
local height = sy * 0.225
local centerleft = posx + height / 2
local centertop = posy + height / 2
local blipsize = height / 16
local lpsize = height / 8
local range = 180

local lp = getLocalPlayer()

function findRotation(x1,y1,x2,y2)
  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then t = t + 360 end
  return t
end

function getDistanceRotation(x, y, dist, angle)
  local a = math.rad(90 - angle)
  local dx = math.cos(a) * dist
  local dy = math.sin(a) * dist
  return x+dx, y+dy
end

local huntersonly = false

setTimer(function()
	huntersonly = true
	for id, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "state") == "alive" then
			if getPedOccupiedVehicle(player) and getElementModel(getPedOccupiedVehicle(player)) ~= 425 then
				huntersonly = false
			end
		end
	end
	local target = getCameraTarget()
	if target and getElementType(target) == "vehicle" then
		lp = getVehicleOccupant(target)
	else
		lp = getLocalPlayer()
	end
end,1000,0)

local heliIDs = {497, 487, 488, 469, 513, 548, 425, 417, 563}
function isAircraft(id)
	for i, v in ipairs(heliIDs) do
		if v == id then
			return true
		end
	end
	return false
end

rotationRotator = 0
function drawRadar()
	showPlayerHudComponent("radar", false)
    if not getElementData(g_Me, "isLogedIn") then return end
	local px, py, pz = getElementPosition(lp)
    local pr = getPedRotation(lp)
    local cx,cy,_,tx,ty = getCameraMatrix()
    local north = findRotation(cx,cy,tx,ty)
	
	for i, v in pairs(getElementsByType("blip")) do
		local bx, by, bz = getElementPosition(v)
		local dist = getDistanceBetweenPoints2D(px,py,bx,by)
		if dist > range then
			dist = tonumber(range)
		end
		local angle = 180-north + findRotation(px,py,bx,by)
        local cblipx, cblipy = getDistanceRotation(0, 0, height*(dist/range)/2, angle)
		local blipsiz = blipsize/2
        local blipx = centerleft+cblipx-blipsiz/2
        local blipy = centertop+cblipy-blipsiz/2
--		local yoff = 0
		local r,g,b,a = 255,255,255,255
		r,g,b,_ = getBlipColor(v)
		dxDrawImage(blipx, blipy, blipsiz, blipsiz, "radar/img/white.png", north, 0, 0, tocolor(r,g,b,a))
	end
	
	dxDrawImage(posx,posy,height,height, "radar/img/radar.png")
	dxDrawImage(posx,posy,height,height, "radar/img/north.png", north)
	for id, player in ipairs(getElementsByType("player", root, true)) do
        if getElementData(player, "state") == "alive" or exports['iRace']:isPlayerRespawnMode(player) and player ~= lp then
            if compareDimensions(getElementDimension(lp), getElementDimension(player)) then
                local veh = getPedOccupiedVehicle(player)
                if veh then
                    local _,_,rot = getElementRotation(veh)
                    if not rot then return end
                    local ex, ey, ez = getElementPosition(veh)
                    local dist = getDistanceBetweenPoints2D(px,py,ex,ey)
                    if dist > range then
                        dist = tonumber(range)
                    end
                    local angle = 180-north + findRotation(px,py,ex,ey)
                    local cblipx, cblipy = getDistanceRotation(0, 0, height*(dist/range)/2, angle)
                    local blipx = centerleft+cblipx-blipsize/2
                    local blipy = centertop+cblipy-blipsize/2
                    local yoff = 0
                    local r,g,b,a = 255,255,255,255

                    if getPlayerTeam(player) then
                        r,g,b = getTeamColor( getPlayerTeam(player) )
                    end

                    local img = "radar/img/blip.png"
                    if (ez - pz) >= 5 then
                        img = "radar/img/blipup.png"
                    elseif (ez - pz) <= -5 then
                        img = "radar/img/blipdown.png"
                    end

                    if isAircraft(tonumber(getElementModel(veh))) then
                        --r, g, b, a = 255, 0, 0, 200
                        img = "radar/img/hunter.png"
                    end

                    dxDrawImage(blipx, blipy, blipsize, blipsize, img, north-rot+45, 0, 0, tocolor(r,g,b,a))

                    if img == "radar/img/hunter.png" then
                        rotationRotator = rotationRotator + 1.25
                        dxDrawImage(blipx, blipy, blipsize, blipsize, "radar/img/rotor.png", north-rot+45+rotationRotator, 0, 0)
                    end
                end
            end
        end
	end
	--Health
			local vehicle = getPedOccupiedVehicle(lp)
			if vehicle then 
			local healthColor = getElementHealth(vehicle)/4
			local healthHeight = healthColor/250
			local health = getElementHealth(vehicle)
			local health = math.max(health - 250, 0)/750
			local color = tocolor(255-healthColor,healthColor/1.5 ,0,255)
			if healthColor < 40 then 
			local number = math.random(0,1)
				if number == 1 then 
					alpha = 255
				else 
					alpha = 0
				end
				color = tocolor(255-healthColor,healthColor/1.5 ,0,alpha)
			end
			dxDrawImage(centerleft - lpsize/2, centertop - lpsize/2, lpsize,lpsize, "radar/img/local.png", north-pr,0,0,tocolor(255-healthColor,healthColor/1.5 ,0,255))
			end
end
addEventHandler("onClientHUDRender", root, drawRadar)

function compareDimensions(lpD, pD)
	if (lpD == 0) and (pD == 0 or 2000) then
		return true
	elseif lpD == 1338 and pD == 1338 then
		return true
	end
	return false
end

function setRaceGuiEnabled(state)
	if state then
		addEventHandler("onClientHUDRender", getRootElement(), drawRadar)
	else
		removeEventHandler("onClientHUDRender", getRootElement(), drawRadar)
	end
end