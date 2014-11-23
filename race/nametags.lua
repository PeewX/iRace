ltfont = "default-bold"

nametag = {}
local nametags = {}
local g_screenX,g_screenY = guiGetScreenSize()
local bHideNametags = false
local showAvatars = true

local NAMETAG_SCALE = 0.8 --Overall adjustment of the nametag, use this to resize but constrain proportions
local NAMETAG_ALPHA_DISTANCE = 20 --Distance to start fading out
local NAMETAG_DISTANCE = 40 --Distance until we're gone
local NAMETAG_ALPHA = 255 --The overall alpha level of the nametag
--The following arent actual pixel measurements, they're just proportional constraints
local NAMETAG_TEXT_BAR_SPACE = 2
local NAMETAG_WIDTH = 50
local NAMETAG_HEIGHT = 10
local AVATAR_WIDTH = 50
local AVATAR_HEIGHT = 50
local NAMETAG_TEXTSIZE = 0.9
local NAMETAG_OUTLINE_THICKNESS = 0.9
local AVATAR_OUTLINE_THICKNESS = 1.4

local NAMETAG_ALPHA_DIFF = NAMETAG_DISTANCE - NAMETAG_ALPHA_DISTANCE
NAMETAG_SCALE = 2/NAMETAG_SCALE * 800 / g_screenY 

-- Ensure the name tag doesn't get too big
local maxScaleCurve = { {0, 0}, {3, 3}, {13, 5} }
-- Ensure the text doesn't get too small/unreadable
local textScaleCurve = { {0, 0.8}, {0.8, 1.2}, {99, 99} }
-- Make the text a bit brighter and fade more gradually
local textAlphaCurve = { {0, 0}, {25, 100}, {120, 190}, {255, 190} }

function nametag.create ( player )
	nametags[player] = true
end

function nametag.destroy ( player )
	nametags[player] = nil
end

function dxDrawColoredText(str, ax, ay, bx, by, color, textalpha,  scale, font)
  local pat = "(.-)#(%x%x%x%x%x%x)"
  local s, e, cap, col = str:find(pat, 1)
  local last = 1
  while s do
    if cap == "" and col then color = tocolor(tonumber("0x"..col:sub(1, 2)), tonumber("0x"..col:sub(3, 4)), tonumber("0x"..col:sub(5, 6)), textalpha) end
    if s ~= 1 or cap ~= "" then
      local w = dxGetTextWidth(cap, scale, font)
      dxDrawText(cap, ax, ay, ax + w, by, color, scale, font, "center", "bottom")
      ax = ax + w
      color = tocolor(tonumber("0x"..col:sub(1, 2)), tonumber("0x"..col:sub(3, 4)), tonumber("0x"..col:sub(5, 6)), textalpha)
    end
    last = e + 1
    s, e, cap, col = str:find(pat, last)
  end
  if last <= #str then
    cap = str:sub(last)
    local w = dxGetTextWidth(cap, scale, font)
    dxDrawText(cap, ax, ay, ax + w, by, color, scale, font, "center", "bottom")
  end
  --Shadow
end


addEventHandler ( "onClientPreRender", g_Root,
    function()
		--basic localPlayer
        -- Hideous quick fix --
        for i,player in ipairs(g_Players) do
			if player ~= g_Me then
                setPlayerNametagShowing ( player, false )
                if not nametags[player] then
                    nametag.create(player)
                end
			end
        end

        if not getElementData(g_Me, "isLogedIn") then return end
        if bHideNametags then return end
        local x,y,z = getCameraMatrix()
        for player in pairs(nametags) do
            while true do
                if not isPedInVehicle(player) or isPlayerDead(player) then break end
			if getElementInterior(player) == getElementInterior(g_Me) then 	
                local vehicle = getPedOccupiedVehicle(player)
                local px,py,pz = getElementPosition ( vehicle )
                local pdistance = getDistanceBetweenPoints3D ( x,y,z,px,py,pz )
                if pdistance <= NAMETAG_DISTANCE then
                    --Get screenposition
                    local sx,sy = getScreenFromWorldPosition ( px, py, pz+0.95, 0.06 )
                    if not sx or not sy then break end
                    --Calculate our components
                    local scale = 1/(NAMETAG_SCALE * (pdistance / NAMETAG_DISTANCE))
                    local alpha = ((pdistance - NAMETAG_ALPHA_DISTANCE) / NAMETAG_ALPHA_DIFF)
					local alpha2 = ((pdistance - NAMETAG_ALPHA_DISTANCE/1.25) / NAMETAG_ALPHA_DIFF/1.25)
                    alpha = (alpha < 0) and NAMETAG_ALPHA or NAMETAG_ALPHA-(alpha*NAMETAG_ALPHA)
					alpha2 = (alpha2 < 0) and NAMETAG_ALPHA or NAMETAG_ALPHA-(alpha*NAMETAG_ALPHA)
                    scale = math.evalCurve(maxScaleCurve,scale)
                    local textscale = math.evalCurve(textScaleCurve,scale)
                    textalpha = math.evalCurve(textAlphaCurve,alpha)
					local textalpha2 = math.evalCurve(textAlphaCurve,alpha2)
                    local outlineThickness = NAMETAG_OUTLINE_THICKNESS*(scale)
					local outlineThicknessA = AVATAR_OUTLINE_THICKNESS*(scale)
                    --Draw our text
                    local r,g,b = 255,255,255
                    local team = getPlayerTeam(player)
                    if team then
                        r,g,b = getTeamColor(team)
                    end
					--basic for me
                    local offset = (scale) * NAMETAG_TEXT_BAR_SPACE/2
					local offset2 = (scale) * NAMETAG_TEXT_BAR_SPACE*8
					local offset3 = (scale) * NAMETAG_TEXT_BAR_SPACE*3.75
					local drawX = sx - NAMETAG_WIDTH*scale/2
                    drawY = sy + offset
                    local width,height =  NAMETAG_WIDTH*scale, NAMETAG_HEIGHT*scale
					local widthA,heightA =  AVATAR_WIDTH*scale, AVATAR_HEIGHT*scale
					--end
					--Avatar
				if showAvatars == true then 
					if getPlayerAvatar(player) ~= false then
                        if fileExists(":iRace/" .. tostring(getElementData(player,"avatar"))) then
						    dxDrawImage (drawX + outlineThickness, drawY + offset, widthA - outlineThickness*1.8, heightA - outlineThickness*1.8, ":iRace/" .. tostring(getElementData(player,"avatar")), 0, 0, 0, tocolor(255,255,255,getAlphaFade (player)))
                        end
					end
				end	
					--Status description text
					--dxDrawingColorText ( string.gsub (getPlayerStatus(player), '#%x%x%x%x%x%x', '' ), sx + 1, sy - offset2 + 1, sx + 1, sy - offset2 + 1, tocolor(0,0,0,getAlphaFade (player)), getAlphaFade (player), textscale*0.625, "default-bold", "center", "bottom", false, false, false )
                    dxDrawingColorText( getPlayerStatus(player), sx, sy - offset2, sx, sy - offset2, tocolor(255,255,50,getAlphaFade (player)), getAlphaFade (player), textscale*0.475, "default-bold", 'center', 'bottom' )
					--PlayerName
					--dxDrawingColorText ( string.gsub (getPlayerNametagText(player), '#%x%x%x%x%x%x', '' ), sx + 1, sy - offset + 1, sx + 1, sy - offset + 1, tocolor(0,0,0,getAlphaFade (player)), getAlphaFade (player), textscale*NAMETAG_TEXTSIZE, "default-bold", "center", "bottom", false, false, false )
                    dxDrawingColorText( getPlayerNametagText(player), sx, sy - offset, sx, sy - offset, tocolor(r,g,b,getAlphaFade (player)),getAlphaFade (player), textscale*0.575, "default-bold", 'center', 'bottom' )
                    --[[Healthbar
					local healthColor = getElementHealth(vehicle)/4
					local health = getElementHealth(vehicle)
					health = math.max(health - 250, 0)/750
					local p = -510*(health^2)
					local r,g = math.max(math.min(p + 255*health + 255, 255), 0), math.max(math.min(p + 765*health, 255), 0)
					dxDrawImageSection(drawX, drawY, width, height, math.floor(256 - 256 * (health)), 0, 256, 16, "img/healthbar1.png", 0, 0, 0, tocolor(255-healthColor,healthColor/1.5 ,0,getAlphaFade (player)))
                    dxDrawImageSection(drawX, drawY, width, height, math.floor(256 - 256 * (health)), 0, 256, 16, "img/healthbar2.png", 0, 0, 0, tocolor(255-healthColor,healthColor/1.5 ,0,getAlphaFade (player)))
                    dxDrawImage(drawX - 1, drawY - 1, width + 2, height + 2, "img/healthbar3.png", 0, 0, 0, tocolor(255,255,255,getAlphaFade(player)))]]
                end	
                break
            end
			end
        end
    end
)
 
function dxDrawingColorText(str, ax, ay, bx, by, color, alpha, scale, font, alignX, alignY)

  if alignX then
    if alignX == "center" then
      local w = dxGetTextWidth(str:gsub("#%x%x%x%x%x%x",""), scale, font)
      ax = ax + (bx-ax)/2 - w/2
    elseif alignX == "right" then
      local w = dxGetTextWidth(str:gsub("#%x%x%x%x%x%x",""), scale, font)
      ax = bx - w
    end
  end

  if alignY then
    if alignY == "center" then
      local h = dxGetFontHeight(scale, font)
      ay = ay + (by-ay)/2 - h/2
    elseif alignY == "bottom" then
      local h = dxGetFontHeight(scale, font)
      ay = by - h
    end
  end

  local pat = "(.-)#(%x%x%x%x%x%x)"
  local s, e, cap, col = str:find(pat, 1)
  local last = 1
  while s do
    if cap == "" and col then color = tocolor(tonumber("0x"..col:sub(1, 2)), tonumber("0x"..col:sub(3, 4)), tonumber("0x"..col:sub(5, 6)), alpha) end
    if s ~= 1 or cap ~= "" then
      local w = dxGetTextWidth(cap, scale, font)
      dxDrawText(cap, ax, ay, ax + w, by, color, scale, font)
      ax = ax + w
      color = tocolor(tonumber("0x"..col:sub(1, 2)), tonumber("0x"..col:sub(3, 4)), tonumber("0x"..col:sub(5, 6)), alpha)
    end
    last = e + 1
    s, e, cap, col = str:find(pat, last)
  end
  if last <= #str then
    cap = str:sub(last)
    local w = dxGetTextWidth(cap, scale, font)
    dxDrawText(cap, ax, ay, ax + w, by, color, scale, font)
  end
end

function getPlayerStatus (player)
local admin = getElementData(player,"playerstatus")
if admin then 
	return admin
else
	return "Guest"
end
end

function getAlphaFade (player)
	if getElementAlpha(getPedOccupiedVehicle(player)) > 240 then 
		return textalpha
	else
		return getElementAlpha(getPedOccupiedVehicle(player))
end
end

function getPlayerAvatar (player)
	local avatar = getElementData(player,"avatar")
		if avatar ~= false then 
			return tostring(avatar)
		else
			return false
		end
end

function setAvatarVisiblie ()
showAvatars = not showAvatars
	if showAvatars == true then
		outputChatBox("[Avatars] #ff6600Avatars enabled.",255,255,255,true)
	else
		outputChatBox("[Avatars] #ff6600Avatars disabled.",255,255,255,true)
	end
end
addCommandHandler("toggleAvatars",setAvatarVisiblie)
---------------THE FOLLOWING IS THE MANAGEMENT OF NAMETAGS-----------------
addEventHandler('onClientResourceStart', g_ResRoot,
	function()
		for i,player in ipairs(getElementsByType"player") do
			if player ~= g_Me then
				nametag.create ( player )
			end
		end
	end
)

addEventHandler ( "onClientPlayerJoin", g_Root,
	function()
		if source == g_Me then return end
		setPlayerNametagShowing ( source, false )
		nametag.create ( source )
	end
)

addEventHandler ( "onClientPlayerQuit", g_Root,
	function()
		nametag.destroy ( source )
	end
)


addEvent ( "onClientScreenFadedOut", true )
addEventHandler ( "onClientScreenFadedOut", g_Root,
	function()
		bHideNametags = true
	end
)

addEvent ( "onClientScreenFadedIn", true )
addEventHandler ( "onClientScreenFadedIn", g_Root,
	function()
		bHideNametags = false
	end
)
