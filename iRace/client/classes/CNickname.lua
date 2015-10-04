--
-- PewX (HorrorClown)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 04.10.2015 - Time: 17:44
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
CNickname = {}

function CNickname:constructor()
    self.width = 400
    self.height = 150

    self.startX = x/2-self.width/2
    self.startY = y/2-self.height/2

    self.onChangeEvent = bind(CNickname.onChangeNick, self)
    self.onRenderEvent = bind(CNickname.render, self)
    self.clientClickEvent = bind(CNickname.onClientClick, self)

    self.mainText = "There is a difference at your nickname since last join"
    self.submitText = "Do you want apply the saved nickname?"

    self.renderTarget = DxRenderTarget(self.width, self.height, true)

    addEvent("onServerWantChangeNickname", true)
    addEventHandler("onServerWantChangeNickname", localPlayer, self.onChangeEvent)
end

function CNickname:destructor()

end

function CNickname:onClientClick(sButton, sState)
    if sButton ~= "left" or sState ~= "down" then return end

    if isHover(self.startX + self.width-135-135, self.startY + 120, 130, 21) then
        self:removeEvents()
        triggerServerEvent("onClientApplyNickchange", resourceRoot, true)
    elseif isHover(self.startX + self.width-135, self.startY + 120, 130, 21) then
        self:removeEvents()
        triggerServerEvent("onClientApplyNickchange", resourceRoot, false)
    end
end

function CNickname:removeEvents()
    removeEventHandler("onClientRender", root, self.onRenderEvent)
    removeEventHandler("onClientClick", root, self.clientClickEvent)
    showCursor(false)
end

function CNickname:onChangeNick(sSavedNickname)
    self.savedNick = sSavedNickname
    self:updateRenderTarget()
    addEventHandler("onClientRender", root, self.onRenderEvent)
    addEventHandler("onClientClick", root, self.clientClickEvent)
    showCursor(true)
end

function CNickname:updateRenderTarget()
    if not self.renderTarget then return end

    self.renderTarget:setAsTarget(true)
    dxDrawRectangle(0, 0, self.width, self.height, tocolor(0, 0, 0, 240))
    dxDrawRectangle(0, 0, self.width, 20, tocolor(255, 80, 0, 200))
    dxDrawText("Nickname", 0, 0, self.width, 20, tocolor(255, 255, 255), 1, "default-bold", "center", "center")

    self.coloredNicknames = ("%s\n#ffffff%s"):format(localPlayer.name, self.savedNick or "-")
    self.uncoloredNicknames = ("(%s)\n(%s)"):format(localPlayer.name, self.savedNick or "-")

    dxDrawText("There is a difference at your nickname since last join", 5, 25, self.width, self.height, tocolor(255, 255, 255), 1, "default-bold")
    dxDrawText("Current nick:\nSaved nick:", 5, 50, self.width, self.height,tocolor(255, 255, 255), 1, "default-bold")
    dxDrawText(self.coloredNicknames, 100, 50, self.width, self.height,tocolor(255, 255, 255), 1, "arial", "left", "top", false, false, false, true)
    dxDrawText(self.uncoloredNicknames, 100 + dxGetTextWidth(self.coloredNicknames, 1, "arial", true) + 5, 50, self.width, self.height, tocolor(150, 150, 150), 1, "arial")

    dxDrawText("Apply the saved nick?", 5 , 100, self.width, self.height, tocolor(255, 255, 255), 1, "default-bold")
    dxDrawRectangle(self.width-135-135, 120, 130, 21, tocolor(0, 240, 0, 200))
    dxDrawRectangle(self.width-135, 120, 130, 21, tocolor(240, 0, 0, 200))

    dxDrawText("No, thanks", self.width-135, 120, self.width-5, 120+21, tocolor(255,255,255), 1, "default-bold", "center", "center")
    dxDrawText("Yes", self.width-135-135, 120, self.width-135-5, 120+21, tocolor(255,255,255), 1, "default-bold", "center", "center")
    dxSetRenderTarget()
end

function CNickname:render()
    showCursor(true)
    dxDrawImage(self.startX, self.startY, self.width, self.height, self.renderTarget)
end