--
-- PewX (HorrorClown)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 23.09.2015 - Time: 22:55
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--

CBottomInterface = {}

function CBottomInterface:constructor()
    triggerServerEvent("onClientRequestMessages", resourceRoot)
    self.width = x
    self.height = 40

    self.startX = 0
    self.startY = y-self.height

    self.mainTextCount = 1
    self.mainTexts = {
        {prefix = ""},
        {prefix = "Last time played: ",     showOnce = true},
        {prefix = "Played count: ",         showOnce = true},
        {prefix = "Hunters reached: ",      showOnce = true},
        {prefix = "Map rating: ",           showOnce = true},
        {prefix = "Rating times: ",         showOnce = true},
        {prefix = "#ff6000Next map: #ffffff"}
    }

    self.subTextAlpha = 0
    self.mainTextAlpha = 0
    self.interfaceTextAlpha = 255
    self.mainTextStartX = 0
    self.hunterTextStartX, self.hunterTextStartY = 5, 0
    self.fpsTextStartY, self.fpsTextHeight = 20, self.height

    self.hunterPickup = {currentDistance = 0, percentage = 0}
    self.ping = localPlayer.ping
    self.FPS = {startTick = getTickCount(), counter = 0, frames = 0}

    self.timeAlpha = 0
    self.timeVertDiff = 0
    self.timeFontSize = 0

    self.renderTarget = DxRenderTarget(self.width, self.height, true)
    self:updateRenderTarget()

    self:functionBinds()
    self:createAnimations()
    self:eventHandlers()

    addEventHandler("onServerSendNextMapName", localPlayer,
        function(sNextMapName)
            self.mainTexts[7].text = sNextMapName
        end
    )

    self.mainTextTimer = setTimer(self.setNextMainTextFunc, 10000, 0)
end

function CBottomInterface:destructor()

end

function CBottomInterface:functionBinds()
    self.clientRestoreEvent = bind(CBottomInterface.onClientRestore, self)
    self.clientReceiveMessagesEvent = bind(CBottomInterface.receiveMessages, self)
    self.clientReceiveCurrentMapInfos = bind(CBottomInterface.receiveMapInfos, self)
    self.renderFunc = bind(CBottomInterface.render, self)
    self.randomSubTextFunc = bind(CBottomInterface.setRandomSubText, self)
    self.setNextMainTextFunc = bind(CBottomInterface.setNextMainText, self)
    self.raceStateChangeEvent = bind(CBottomInterface.raceStateChanging, self)
    self.clientPlayerWastedEvent = bind(CBottomInterface.clientPlayerWasted, self)
end

function CBottomInterface:createAnimations()
    self.subTextAnimation = new(CAnimation, self, "subTextAlpha")
    self.mainTextAnimation = new(CAnimation, self, "mainTextAlpha", "mainTextStartX")
    self.interfaceAnimation = new(CAnimation, self, "startY")
    self.leftTextAnimation = new(CAnimation, self, "hunterTextStartX", "fpsTextStartY", "fpsTextHeight")
    self.timeAnimation = new(CAnimation, self, "timeAlpha", "timeVertDiff", "timeFontSize")
end

function CBottomInterface:eventHandlers()
    addEventHandler("onClientRestore", root, self.clientRestoreEvent)
    addEventHandler("onClientRender", root, self.renderFunc)
    addEventHandler("onServerSendMessages", localPlayer, self.clientReceiveMessagesEvent)
    addEventHandler("onClientMapStarting", root, self.clientReceiveCurrentMapInfos)
    addEventHandler("onClientRaceStateChanging", root, self.raceStateChangeEvent)
end

function CBottomInterface:raceStateChanging(rs)
    self.running = false

    if rs == "Running" then
        self.running = true
        self.startTick = getTickCount()

        if not self.isWastedEventAdded then
            self.isWastedEventAdded = true
            addEventHandler("onClientPlayerWasted", root, self.clientPlayerWastedEvent)
            self.interfaceAnimation:startAnimation(1200, "OutQuad", y-20)
            self.leftTextAnimation:startAnimation(1200, "OutQuad", 120, 0, 20)
        else
            if self.isWastedEventAdded then
                self.isWastedEventAdded = false
                removeEventHandler("onClientPlayerWasted", root, self.clientPlayerWastedEvent)
                self.interfaceAnimation:startAnimation(800, "OutQuad", y-self.height)
                self.leftTextAnimation:startAnimation(800, "OutQuad", 5, 20, self.height)
            end
        end
    elseif rs == "GridCountdown" then
        self.timePassed = msToTimeString(0)
        self.timeAnimation:startAnimation(500, "OutQuad", 255, 16, 1)
        self.diedTick = 0
    else
        if self.timeAlpha ~= 0 then
            self.timeAnimation:startAnimation(500, "OutQuad", 0, 0, 0)
        end
    end
end

function CBottomInterface:clientPlayerWasted()
    if source ~= localPlayer then return end
    self.interfaceAnimation:startAnimation(800, "OutQuad", y-self.height)
    self.leftTextAnimation:startAnimation(800, "OutQuad", 5, 20, self.height)
    removeEventHandler("onClientPlayerWasted", root, self.clientPlayerWastedEvent)
    self.isWastedEventAdded = false
    self.diedTick = getTickCount()
end

function CBottomInterface:onClientRestore(bRenderTargetsCleared)
    if bRenderTargetsCleared then
        self:updateRenderTarget()
    end
end

function CBottomInterface:receiveMessages(tMessages)
    self.subMessages = tMessages
    self:setRandomSubText()
end

function CBottomInterface:receiveMapInfos(tMap)
    self.mainTextCount = 1

    self.mainTexts[1].text = tMap.name or "-"
    self.mainTexts[2].text = timestampToDate(tMap.lastTimePlayed or getRealTime().timestamp)
    self.mainTexts[3].text = tMap.playedCount
    self.mainTexts[4].text = tMap.huntersReached
    self.mainTexts[5].text = tMap.mapRating
    self.mainTexts[6].text = tMap.mapRatingCount

    for i = 1, 7 do
       self.mainTexts[i].displayed = false
    end

    self.mainTextTimer:reset()
    self:setNextMainText()
    self:initialiseHunterDistance()
end

function CBottomInterface:setRandomSubText()
    if not self.subMessages then return end
    self.subTextAnimation:startAnimation(500, "OutQuad", 0)

    setTimer(function()
        local randomID = math.random(1, #self.subMessages)
        self.subText = self.subMessages[randomID].de
        self.subTextAnimation:startAnimation(500, "OutQuad", 255)

        setTimer(self.randomSubTextFunc, 30000, 1)
    end, 750, 1)
end

function CBottomInterface:setNextMainText()
    self.mainTextAnimation:startAnimation(500, "OutQuad", 0, -180)

    setTimer(function()
         local next = self.mainTexts[self.mainTextCount]
         self.mainTextStartX = 180

        self.mainText = ("%s%s"):format(next.prefix or "", next.text or "-")
        self.mainTextAnimation:startAnimation(500, "OutQuad", 255, 0)

        if next.showOnce then
            next.displayed = true
        end

        self.mainTextCount = self.mainTextCount + 1
        if self.mainTextCount > #self.mainTexts then self.mainTextCount = 1 end

        while self.mainTexts[self.mainTextCount].displayed do
            self.mainTextCount = self.mainTextCount + 1
        end
    end, 750, 1)
end

function CBottomInterface:updateRenderTarget()
    if not self.renderTarget then return end

    self.subTextColor = tocolor(255, 255, 255, self.subTextAlpha)
    self.mainTextColor = tocolor(255, 255, 255, self.mainTextAlpha)
    self.interfaceTextColor = tocolor(255, 255, 255, self.interfaceTextAlpha)

    dxSetRenderTarget(self.renderTarget, true)
    dxDrawRectangle(0, 0, self.width, self.height, tocolor(0, 0, 0, 180))
    dxDrawLine(0, 0, self.width, 0, tocolor(255, 60, 0, 255))

    dxDrawText(self.mainText or "-", self.mainTextStartX, 0, self.width, 20, self.mainTextColor, 1, "default-bold", "center", "center", false, false, false, true, false)
    dxDrawText(self.subText or "-", 0, 20, self.width, self.height, self.subTextColor, 1, "default-bold", "center", "center", false, false, false, true, false)
    dxDrawText(self.hunterPickup and ("Hunter: %sm (%s%%)"):format(self.hunterPickup.currentDistance, self.hunterPickup.percentage) or "Hunter: -", self.hunterTextStartX, self.hunterTextStartY, self.width, 20, self.interfaceTextColor, 1, "default-bold", "left", "center", false, false, false, true, false)
    dxDrawText(("FPS: %s"):format(self.FPS.frames), 5, self.fpsTextStartY, self.width, self.fpsTextHeight, self.interfaceTextColor, 1, "default-bold", "left", "center", false, false, false, true, false)
    dxSetRenderTarget()
end

function CBottomInterface:render()
    if not getElementData(localPlayer, "isLogedIn") then return end
    if g_Userpanel then return end

    --Update FPS
    self.FPS.counter = self.FPS.counter + 1
    if getTickCount() - self.FPS.startTick >= 1000 then
        if self.FPS.frames ~= self.FPS.counter then
            self.FPS.frames = self.FPS.counter
            self:updateRenderTarget()
        end

        self.FPS.counter = 0
        self.FPS.startTick = getTickCount()
    end

    --Update Ping
    if math.abs(self.ping - localPlayer.ping) > 1 then
       self.ping = localPlayer.ping
       self:updateRenderTarget()
    end

    --Update distance to hunter
    if self.hunterPickup and isElement(self.hunterPickup.element) then
        local pickupPos = self.hunterPickup.element:getPosition()
        local playerPos = self:getPlayer():getPosition()
        if pickupPos and playerPos then
            local distance = math.floor(getDistanceBetweenPoints3D(playerPos, pickupPos))

            if math.abs(self.hunterPickup.currentDistance - distance) > 0.5 then
                self.hunterPickup.currentDistance = distance
                self.hunterPickup.percentage =  100 - math.ceil(100/self.hunterPickup.distance*self.hunterPickup.currentDistance)
                self:updateRenderTarget()
            end
        end
    end

    --Update and render passed time
    if self.timeAlpha > 0 then
        if self.running and getTickCount() - self.diedTick > 3500 then
            local msPassed = getTickCount() - self.startTick
            self.timePassed = msToTimeString(msPassed)
        end

        dxDrawText(("Time passed: #ffffff%s"):format(self.timePassed), self.startX, self.startY - self.timeVertDiff, self.width, self.height, tocolor(180, 180, 180, self.timeAlpha), self.timeFontSize, "default-bold", "center", "top", false, false, false, true, false)
    end

    --Render Bottom Interface image
    dxDrawImage(self.startX, self.startY, self.width, self.height, self.renderTarget)
end

function CBottomInterface:getPlayer()
    local target = getCameraTarget()
    if target and getElementType(target) == "vehicle" then
        return getVehicleOccupant(target)
    end

    return localPlayer
end

function CBottomInterface:initialiseHunterDistance()
    self.hunterPickups = {}

    for _, ePickup in pairs(getElementsByType"racepickup") do
        local pickupType = getElementData(ePickup, "type")
        if pickupType == "vehiclechange" then
            local vehID = getElementData(ePickup, "vehicle")
            if tonumber(vehID) == 425 then

                local pickupPos = ePickup:getPosition()
                local playerPos = localPlayer:getPosition()
                local distance = math.floor(getDistanceBetweenPoints3D(playerPos, pickupPos))
                table.insert(self.hunterPickups, {element = ePickup, distance = distance, percentage = 0})
            end
        end
    end

    if #self.hunterPickups == 0 then
        self.hunterPickup = false
        return
    end

    if #self.hunterPickups > 1 then
        table.sort(self.hunterPickups, function(c1, c2) return (c1.distance > c2.distance) end)
    end

    self.hunterPickup = self.hunterPickups[1]
    self.hunterPickup.currentDistance = self.hunterPickup.distance
end

addEvent("onServerSendMessages", true)
addEvent("onServerSendNextMapName", true)
addEvent("onClientMapStarting", true)