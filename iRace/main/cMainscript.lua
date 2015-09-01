--setCloudsEnabled(false)
--general--
local root = getRootElement()
local resRoot = getResourceRootElement(getThisResource())
local localPlayer = getLocalPlayer()
local screenWidth, screenHeight = guiGetScreenSize() -- Get the screen resolution
beta = false
--end general--

--distance--
local distanceTravelled
local oldx,oldy,oldz
--end distance--
--[[*************************************************
*        Part I: sounds                             *
*****************************************************]]
--PUBLIC MESSAGE FOR ALL PLAYERS
function displayPMSG(source, message)
    pmsg = dxText:create("(" ..getPlayerName(source).."): " ..message, 0.5, 0.5, true, "default-bold", 3, "center")
    setTimer(deletePMSGfromGUI, 6000, 1)
end
function deletePMSGfromGUI()
    pmsg:visible(false)
end
addEvent("onAdminSendPMSG", true)
addEventHandler("onAdminSendPMSG", getRootElement(), displayPMSG)

--[[*************************************************
*        Part II: client events/functions            *
*****************************************************]]

function playerRankUp()
    if source == localPlayer then
        playSound("/files/RankUp.mp3",false)
    else
        local x,y,z = getElementPosition(source)
        local sound = playSound3D("/files/RankUp.mp3",x,y,z,false)
        setSoundMinDistance(sound,5)
        setSoundMaxDistance(sound,40)
        attachElements(sound,source)
    end
end
addEvent("onPlayerRankUp",true)
addEventHandler("onPlayerRankUp",root,playerRankUp)

--[[function startRecordingDistanceTravelled()
	distanceTravelled = 0
	addEventHandler("onClientRender",root,distanceRecord)
end
addEvent("startRecordingDistanceTravelled",true)
addEventHandler("startRecordingDistanceTravelled",root,startRecordingDistanceTravelled)

function getRecordedDistanceTravelled(stop)
	triggerServerEvent("onDistanceTravelledReturn",localPlayer,distanceTravelled)
	distanceTravelled = 0
	if stop then
		removeEventHandler("onClientRender",root,distanceRecord)
	end
end
addEvent("getRecordedDistanceTravelled",true)
addEventHandler("getRecordedDistanceTravelled",root,getRecordedDistanceTravelled)

function resourceStop()
	if distanceTravelled > 0 then
		triggerServerEvent("onDistanceTravelledReturn",localPlayer,distanceTravelled)
	end
end
addEventHandler("onClientResourceStop",resRoot,resourceStop)

function distanceRecord()
	local veh = getPedOccupiedVehicle(getLocalPlayer())
	if veh then
		local x,y,z = getElementPosition(veh)
		if oldx then
			distanceTravelled = distanceTravelled + getDistanceBetweenPoints3D(x,y,z,oldx,oldy,oldz)
		end
		oldx,oldy,oldz = x,y,z
	end
end]]

--[[*************************************************
*        Part III: disco functions                  *
*****************************************************]]
local cr,cg,cb
local polilight
local cablight



addEvent("onAtzenFun",true)
addEventHandler("onAtzenFun",getRootElement(),
    function ()
        playSound("files/disco_pogo.mp3")
        local vehic = getPedOccupiedVehicle ( getLocalPlayer() )
        if ( vehic ) then
            cr,cg,cb = getVehicleHeadLightColor(vehic)
            local polilight = getVehicleSirensOn(vehic)
            local cablight = isVehicleTaxiLightOn(vehic)
            triggerServerEvent("globalSirensOn",getRootElement(),vehic,true)
            triggerServerEvent("globalTaxiLight",getRootElement(),vehic,true)
            setTimer(party,300,46)
            setTimer(orig,(300*46+3000),1)
        end
    end
)

function party()
    local vehic = getPedOccupiedVehicle ( getLocalPlayer() )
    if ( vehic ) then
        triggerServerEvent("globalTaxiLight",getRootElement(),vehic,not isVehicleTaxiLightOn(vehic))
        triggerServerEvent("globalLightColor",getRootElement(),vehic,math.random(0,255),math.random(0,255),math.random(0,255))
    end
end

function orig()
    local vehic = getPedOccupiedVehicle ( getLocalPlayer() )
    if ( vehic ) then
        triggerServerEvent("globalLightColor",getRootElement(),vehic,cr,cg,cb)
        triggerServerEvent("globalSirensOn",getRootElement(),vehic,polilight)
        triggerServerEvent("globalTaxiLight",getRootElement(),vehic,not cablight)
    end

end

--[[*************************************************
*        Part IV: 2D countdown                      *
*****************************************************]]

local instructionText
function showCursorForStart()
    if (source == localPlayer) then
        showCursor(true)
        instructionText = dxText:create("Please Click somewhere on your screen where you want the countdown to appear!", 0.5, 0.6, true, "sans", 2, "center")
        instructionText:color(0,255, 55)

        setTimer(
            function()
                instructionText:destroy()
            end
            , 5000, 1)

        addEventHandler("onClientClick", root, onPlayerClickReturnPosition)
    end
end
addEvent("onPlayerUseCountdown", true)
addEventHandler("onPlayerUseCountdown", root, showCursorForStart)

function onPlayerClickReturnPosition(btn, state, sx, sy, x, y, z, element)
    if (btn == "left") and (state == "down") then
        removeEventHandler("onClientClick", root, onPlayerClickReturnPosition)
        local startTime = getTickCount()
        showCursor(false)
        triggerServerEvent("onPlayerClickDrawCountdownSendServer",root, x, y, z, element)
    end
end

function drawCountdownInWorld(px, py, pz,element)
    local nx, ny, nz = getCameraMatrix(localPlayer)
    local between = getDistanceBetweenPoints3D(px, py, pz, nx, ny, nz)
    local start = getTickCount()
    if (between < 125) then
        setTimer(playSoundFrontEnd, 1000, 1, 44)
        setTimer(playSoundFrontEnd, 2000, 1, 44)
        setTimer(playSoundFrontEnd, 3000, 1, 44)
        setTimer(playSoundFrontEnd, 4000, 1, 44)
        setTimer(playSoundFrontEnd, 5000, 1, 44)
        setTimer(playSoundFrontEnd, 6000, 1, 45)
    end
    function drawCd()
        local sx,sy = getScreenFromWorldPosition(px,py,pz+5,0.06)
        local timePassed = getTickCount() - start
        if sx and sy then
            local cx,cy,cz = getCameraMatrix()
            local size = getDistanceBetweenPoints3D(cx,cy,cz,px,py,pz)
            local pixel = 200 - size*2
            if size <= 125 then
                if (timePassed > 1000) and (timePassed < 1500) then
                    dxDrawImage(sx-(pixel*0.5),sy-(pixel*0.5),pixel,pixel,"files/5.png")
                elseif (timePassed > 2000) and (timePassed <2500) then
                    dxDrawImage(sx-(pixel*0.5),sy-(pixel*0.5),pixel,pixel,"files/4.png")
                elseif (timePassed > 3000) and (timePassed < 3500) then
                    dxDrawImage(sx-(pixel*0.5),sy-(pixel*0.5),pixel,pixel,"files/3.png")
                elseif (timePassed > 4000) and (timePassed <4500) then
                    dxDrawImage(sx-(pixel*0.5),sy-(pixel*0.5),pixel,pixel,"files/2.png")
                elseif (timePassed > 5000) and (timePassed <5500) then
                    dxDrawImage(sx-(pixel*0.5),sy-(pixel*0.5),pixel,pixel,"files/1.png")
                elseif (timePassed > 6000) and (timePassed <9000) then
                    dxDrawImage(sx-(pixel*0.5),sy-(pixel*0.5),pixel,pixel,"files/go.png")
                elseif (timePassed > 9000) then
                    triggerServerEvent("onClientStopCountdown", root)
                    triggerServerEvent("getplayername", localPlayer, timePassed)
                    removeEventHandler("onClientRender", root, drawCd)
                else
                    --nothing
                end
            else
                if (timePassed > 9000) then
                    triggerServerEvent("onClientStopCountdown", root)
                    triggerServerEvent("getplayername", localPlayer, timePassed)
                    removeEventHandler("onClientRender", root, drawCd)
                end
            end
        else
            if (timePassed > 9000) then
                triggerServerEvent("onClientStopCountdown", root)
                triggerServerEvent("getplayername", localPlayer, timePassed)
                removeEventHandler("onClientRender", root, drawCd)
            end
        end
    end
    addEventHandler("onClientRender", root, drawCd)
    function onPlayerQuitCD()
        triggerServerEvent("onClientStopCountdown", source)
    end
    addEventHandler("onClientResourceStop", resRoot, onPlayerQuitCD)
end
addEvent("onPlayerClickDrawCountdown", true)
addEventHandler("onPlayerClickDrawCountdown", root, drawCountdownInWorld)

------------------------------------------


-------------------------------------------------------
function checkResolutionOnStart ( theResource )
    if theResource ~= getThisResource() then return end
    local x,y = guiGetScreenSize()
    if ( x <= 1000 ) and ( y <= 700 ) then
        outputChatBox ( "WARNING: You are running on a low resolution.  \nSome GUI or Labels may be placed or appear incorrectly.(please change it higher)" )
        outputChatBox ( "WARNUNG: Dein MTA läuft auf zu niedriger Auflösung.  \nManche Fenster könnten falsch angezeigt werden, bitte änder deine Auflösung." )
    end
end
addEventHandler ( "onClientResourceStart", getRootElement(), checkResolutionOnStart )
--------------------------------------------------------
--------------------------------------------------------


function showWinText(wintext)
    local x, y = guiGetScreenSize()
    local wintext = string.gsub(wintext,"[*]DD[*]", tostring(math.floor(tonumber(getElementData(source,"ddswon")))))
    local wintext = string.gsub(wintext,"[*]DM[*]", tostring(math.floor(tonumber(getElementData(source,"dmswon")))))
    local wintext = string.gsub(wintext, "[*]WINS[*]", tostring(math.floor(tonumber(getElementData(source, "ddswon")) + tonumber(getElementData(source, "dmswon")))))
    local wintext = string.gsub(wintext,"[*]MAPS[*]", tostring(math.floor(tonumber(getElementData(source,"mapsfinished")))))
    local wintext = string.gsub(wintext,"[*]CASH[*]", tostring(math.floor(tonumber(getElementData(source,"cash")))))
    local wintext = string.gsub(wintext,"[*]EARNED[*]", tostring(math.floor(tonumber(getElementData(source,"cashearned")))))
    local wintext = string.gsub(wintext,"[*]LEVEL[*]", tostring(math.floor(tonumber(getElementData(source,"level")))))
    winnertext = dxText:create(wintext, x/2, y/2 -150 + 1, false, "bankgothic", 1, "center" )
    winnertext:type('stroke', 0.6, 0, 0, 0, 255)
    setTimer(function()
        winnertext:visible(false)
    end, 5000, 1)
end
addEvent("onPlayerWinWithWinText", true)
addEventHandler("onPlayerWinWithWinText", getRootElement(), showWinText)
---------------------------------------------------------------
local r,g,b = 255,255,255
local upValues = true
function rainbowColor ()
    --math
    --down
    if upValues == true then
        if g <= 255 and g >= 0 and r == 0 and b == 255 then
            r,g,b = r,g-6.375,b
        end
        if r <= 255 and r >= 0 and g == 255 and b == 255 then
            r,g,b = r-6.375,g,b
        end
        if b <= 255 and b >= 0 and r == 0 and g == 0 then
            r,g,b = r,g,b-6.375
        end
        if r == 0 and g == 0 and b == 0 then
            upValues = false
        end
    end
    --up
    if upValues == false then
        if g <= 255 and g >= 0 and r == 255 and b == 0 then
            r,g,b = r,g+6.375,b
        end
        if r <= 255 and r >= 0 and g == 0 and b == 0 then
            r,g,b = r+6.375,g,b
        end
        if b <= 255 and b >= 0 and r == 255 and g == 255 then
            r,g,b = r,g,b+6.375
        end
        if r == 255 and g == 255 and b == 255 then
            upValues = true
        end
    end
    for id, player in ipairs(getElementsByType("player")) do
        if getElementData(player,"rainbowcolorstate") == true then
            local vehicle = getPedOccupiedVehicle(player)
            if vehicle then
                if getElementDimension(vehicle) == 0 then
                    setVehicleColor(vehicle,r,g,b,r,g,b)
                end
            end
        end
    end
end
setTimer(rainbowColor,50,0)


function discoheadlights()
    for id,player in ipairs(getElementsByType("player")) do
        if getElementData(player, "pulsatingheadlightsON") then
            local car = getPedOccupiedVehicle(player)
            if car and isElement(car) then
                local l1 = getVehicleLightState(car,0)
                if  l1 == 0 then
                    setVehicleHeadLightColor(car,math.random(0,255),math.random(0,255),math.random(0,255))
                    setVehicleLightState(car,0,1)
                    setVehicleLightState(car,2,1)
                    setVehicleLightState(car,1,0)
                    setVehicleLightState(car,3,0)
                else
                    setVehicleHeadLightColor(car,math.random(0,255),math.random(0,255),math.random(0,255))
                    setVehicleLightState(car,0,0)
                    setVehicleLightState(car,2,0)
                    setVehicleLightState(car,1,1)
                    setVehicleLightState(car,3,1)
                end
            end
        end
    end
end
setTimer(discoheadlights,1000,0)

function betamodusC (bool)
    if bool then
        beta = true
    else
        beta = false
    end
    call(getResourceFromName("race"), "betamodusCAFK", beta)
end
addEvent("betamodus", true)
addEventHandler("betamodus", root, betamodusC)

function reenablefire ()
    toggleControl("vehicle_fire", true)
end

function reenablesfire ()
    toggleControl("vehicle_secondary_fire", true)
end

function hunterantispray ()
    local veh = getPedOccupiedVehicle(localPlayer)
    if getElementModel(veh) == 425 then
        toggleControl("vehicle_secondary_fire", false)
        if not isTimer(hunterspaytimer) then
            hunterspaytimer = setTimer(reenablefire, 1500, 1)
            toggleControl("vehicle_fire", false)
            setControlState("vehicle_fire", true)
            setTimer(setControlState, 100, 1, "vehicle_fire", false)
        end
    elseif getElementModel(veh) == 520 then
        toggleControl("vehicle_fire", false)
        if not isTimer(hunterspaytimer) then
            hunterspaytimer = setTimer(reenablesfire, 1500, 1)
            toggleControl("vehicle_secondary_fire", false)
            setControlState("vehicle_secondary_fire", true)
            setTimer(setControlState, 100, 1, "vehicle_secondary_fire", false)
        end
    else
        toggleControl("vehicle_secondary_fire", true)
        toggleControl("vehicle_fire", true)
    end
end

bindKey("vehicle_fire", "down", hunterantispray)
bindKey("vehicle_secondary_fire", "down", hunterantispray)

function paydaysound ()
    playSound("files/payday.mp3")
end
addEvent("payDaySound", true)
addEventHandler("payDaySound", getLocalPlayer(), paydaysound)
