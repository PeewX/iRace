--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 19.08.2015 - Time: 13:40
-- iGaming-mta.de // iRace-mta.de // pewx.de // iSurvival.de // mtasa.de
--
CKeyDisplay = {}

function CKeyDisplay:constructor()
    self.enabled = false
    self.spectator = false

    self:loadImages()
    self:loadPresets()

    self.colorNormal = tocolor(200, 200, 200, 230)
    self.colorPressed = tocolor(255, 80, 0, 230)
    self.validKeys = {"w", "a", "s", "d", "lctrl", "lalt", "mouse1", "space", "arrow_l", "arrow_u", "arrow_r", "arrow_d"}
    self.keys = {}

    --set default values:
    for _, key in ipairs(self.validKeys) do
        self.keys[key] = false
    end

    self.clientRestoreEvent = bind(CKeyDisplay.onClientRestore, self)
    self.renderFunc = bind(CKeyDisplay.render, self)
    self.clientKeyEvent = bind(CKeyDisplay.onClientKey, self)
    self.receiveKeysEvent = bind(CKeyDisplay.onReceiveKeys, self)
    self.toggleBindFunc = bind(CKeyDisplay.toggleBind, self)
    self.toggleKeyPressesFunc = bind(CKeyDisplay.toggleKeyPresses, self)
    self.setSizeCommandFunc = bind(CKeyDisplay.setSizeCommand, self)

    bindKey("k", "down", self.toggleBindFunc)

    addEvent("onServerSendKeys", true)
    addEventHandler("onServerSendKeys", localPlayer, self.receiveKeysEvent)

    addEvent("onServerWantKeyPresses", true)
    addEventHandler("onServerWantKeyPresses", localPlayer, self.toggleKeyPressesFunc)

    self.renderTarget = DxRenderTarget(self.width, self.height, true)
    self:updateRenderTarget()

    addEventHandler("onClientRestore", root, self.clientRestoreEvent)
    addCommandHandler("key", self.setSizeCommandFunc)
end

function CKeyDisplay:destructor()

end

function CKeyDisplay:onClientRestore(bRenderTargetsCleared)
    if bRenderTargetsCleared then
        self:updateRenderTarget()
    end
end

function CKeyDisplay:loadImages()
    self.images = {
        "key_bg",
        "key_space_bg",
        "key_arrow",
        "key_W",
        "key_A",
        "key_S",
        "key_D",
        "key_lctrl",
        "key_space"
    }

    for _, img in ipairs(self.images) do
        self[img] = DxTexture(("files/images/keys/%s.png"):format(img))
    end
end

function CKeyDisplay:loadPresets(nFit)
    if not nFit then nFit = 1 end
    self.keyWidth = (64*nFit)/1920*x --64
    self.keyHeight = self.keyWidth --64
    self.spaceWidth = self.keyWidth * 4 --256

    self.keySpacing = 5*nFit
    self.windowSpacing = 10*nFit

    self.width = self.windowSpacing + self.keyWidth + self.keySpacing + self.keyWidth + self.keySpacing + self.spaceWidth + self.keySpacing + self.keyWidth + self.keySpacing + self.keyWidth + self.windowSpacing
    self.height = self.windowSpacing + self.keyHeight + self.keySpacing + self.keyHeight + self.keySpacing + self.keyHeight + self.windowSpacing

    self.key_bg_color = {
        [false] = tocolor (200, 200, 200),
        [true] = tocolor(255, 80, 0)
    }

    self.key_arrow_color = {
        [false] = tocolor(140, 140, 140),
        [true] = tocolor(235, 235, 235)
    }
end

function CKeyDisplay:setSizeCommand(_, sSize)
    local nSize = tonumber(sSize)
    if not nSize then outputChatBox("NaN", 200, 0, 0) return end

    if nSize < 0.5 or nSize > 2 then outputChatBox("Min: 0.5 - Max: 2") return end

    self:loadPresets(nSize)

    self.renderTarget = DxRenderTarget(self.width, self.height, true)
    self:updateRenderTarget()
end

function CKeyDisplay:toggleDisplay()
    if not self.enabled then

        --self.spectator = localPlayer
        self.spectator = getSpectatedPlayer()
        if not self.spectator then return end

        triggerServerEvent("onClientChangeKeyDisplayTarget", localPlayer, self.spectator, true)
        self.enabled = true

        addEventHandler("onClientRender", root, self.renderFunc)
        return
    end

    if self.enabled then
        triggerServerEvent("onClientChangeKeyDisplayTarget", localPlayer,self.spectator, false)
        removeEventHandler("onClientRender", root, self.renderFunc)

        self.enabled = false
        self.spectator = false
       return
    end
end

function CKeyDisplay:onClientKey(sButton, bPressed)
    if self:isValidKey(sButton) then
        if sButton == "lalt" or sButton == "mouse1" then sButton = "lctrl" end
        self.keys[sButton] = bPressed
        triggerServerEvent("onTargetKeysChange", localPlayer, self.keys)
    end
end

function CKeyDisplay:isValidKey(sButton)
    for _, sKey in ipairs(self.validKeys) do
       if sKey == sButton then
           return true
       end
    end
    return false
end

function CKeyDisplay:toggleKeyPresses(bEnable)
    if bEnable then
        addEventHandler("onClientKey", root, self.clientKeyEvent)
    else
        removeEventHandler("onClientKey", root, self.clientKeyEvent)
    end
end

function CKeyDisplay:toggleBind()
    if getKeyState("lctrl") then
        self:toggleDisplay()
    end
end

function CKeyDisplay:onReceiveKeys(tKeys)
    self.keys = tKeys
    self:updateRenderTarget()
end

function CKeyDisplay:updateRenderTarget()
    if not self.renderTarget then return end

    --Test here if the spectated player was changed and disable Display
    if self.spectator ~= getSpectatedPlayer() then
        self:toggleDisplay()
        return
    end

    dxSetRenderTarget(self.renderTarget, true)
    --dxDrawRectangle(0, 0, self.width, self.height, tocolor(0, 0, 0, 80))

    --Key: W
    local keyDrawX = self.windowSpacing + self.keyWidth + self.keySpacing
    local keyDrawY = self.windowSpacing
    dxDrawImage(keyDrawX, keyDrawY, self.keyWidth, self.keyHeight, self.key_bg,0 ,0 ,0, self.key_bg_color[self.keys.w])
    dxDrawImage(keyDrawX, keyDrawY, self.keyWidth, self.keyHeight, self.key_W, 0, 0, 0, self.key_arrow_color[self.keys.w])

    --Key: A
    local keyDrawX = self.windowSpacing
    local keyDrawY = self.windowSpacing + self.keyHeight + self.keySpacing
    dxDrawImage(keyDrawX, keyDrawY, self.keyWidth, self.keyHeight, self.key_bg,0 ,0 ,0, self.key_bg_color[self.keys.a])
    dxDrawImage(keyDrawX, keyDrawY, self.keyWidth, self.keyHeight, self.key_A, 0, 0, 0, self.key_arrow_color[self.keys.a])

    --Key: S
    local keyDrawX = self.windowSpacing + self.keyWidth + self.keySpacing
    --local keyDrawY = keyDrawY //same line
    dxDrawImage(keyDrawX, keyDrawY, self.keyWidth, self.keyHeight, self.key_bg,0 ,0 ,0, self.key_bg_color[self.keys.s])
    dxDrawImage(keyDrawX, keyDrawY, self.keyWidth, self.keyHeight, self.key_S, 0, 0, 0, self.key_arrow_color[self.keys.s])

    --Key: D
    local keyDrawX = self.windowSpacing + self.keyWidth + self.keySpacing + self.keyWidth + self.keySpacing
    --local keyDrawY = keyDrawY //same line
    dxDrawImage(keyDrawX, keyDrawY, self.keyWidth, self.keyHeight, self.key_bg,0 ,0 ,0, self.key_bg_color[self.keys.d])
    dxDrawImage(keyDrawX, keyDrawY, self.keyWidth, self.keyHeight, self.key_D, 0, 0, 0, self.key_arrow_color[self.keys.d])

    --Key: Space
    local keyDrawX = self.windowSpacing + self.keyWidth + self.keySpacing + self.keyWidth + self.keySpacing
    local keyDrawY = self.windowSpacing + self.keyHeight + self.keySpacing + self.keyHeight + self.keySpacing
    dxDrawImage(keyDrawX, keyDrawY, self.spaceWidth, self.keyHeight, self.key_space_bg, 0, 0, 0, self.key_bg_color[self.keys.space])
    dxDrawImage(keyDrawX, keyDrawY, self.spaceWidth, self.keyHeight, self.key_space, 0, 0, 0, self.key_arrow_color[self.keys.space])

    --Key: lctrl
    local keyDrawX = self.windowSpacing
    local keyDrawY = self.windowSpacing + self.keyHeight + self.keySpacing + self.keyHeight + self.keySpacing
    dxDrawImage(keyDrawX, keyDrawY, self.keyWidth, self.keyHeight, self.key_bg, 0, 0, 0, self.key_bg_color[self.keys.lctrl])
    dxDrawImage(keyDrawX, keyDrawY, self.keyWidth, self.keyHeight, self.key_lctrl, 0, 0, 0, self.key_arrow_color[self.keys.lctrl])

    --Key: arrow up
    local keyDrawX = self.windowSpacing + self.keyWidth + self.keySpacing + self.keyWidth + self.keySpacing + self.spaceWidth + self.keySpacing
    local keyDrawY = self.windowSpacing
    dxDrawImage(keyDrawX, keyDrawY, self.keyWidth, self.keyHeight, self.key_bg, 0, 0, 0, self.key_bg_color[self.keys.arrow_u])
    dxDrawImage(keyDrawX, keyDrawY, self.keyWidth, self.keyHeight, self.key_arrow, 0, 0, 0, self.key_arrow_color[self.keys.arrow_u])

    --Key: arrow down
    local keyDrawX = self.windowSpacing + self.keyWidth + self.keySpacing + self.keyWidth + self.keySpacing + self.spaceWidth + self.keySpacing
    local keyDrawY = self.windowSpacing + self.keyHeight + self.keySpacing
    dxDrawImage(keyDrawX, keyDrawY, self.keyWidth, self.keyHeight, self.key_bg, 180, 0, 0, self.key_bg_color[self.keys.arrow_d])
    dxDrawImage(keyDrawX, keyDrawY, self.keyWidth, self.keyHeight, self.key_arrow, 180, 0, 0, self.key_arrow_color[self.keys.arrow_d])

    --Key: arrow left
    local keyDrawX = self.windowSpacing + self.keyWidth + self.keySpacing + self.keyWidth + self.keySpacing + self.spaceWidth - self.keyWidth
    --local keyDrawY = self.windowSpacing + self.keyHeight + self.keySpacing //same line
    dxDrawImage(keyDrawX, keyDrawY, self.keyWidth, self.keyHeight, self.key_bg, 270, 0, 0, self.key_bg_color[self.keys.arrow_l])
    dxDrawImage(keyDrawX, keyDrawY, self.keyWidth, self.keyHeight, self.key_arrow, 270, 0, 0, self.key_arrow_color[self.keys.arrow_l])

    --Key: arrow right
    local keyDrawX = self.windowSpacing + self.keyWidth + self.keySpacing + self.keyWidth + self.keySpacing + self.spaceWidth + self.keySpacing + self.keyWidth + self.keySpacing
    --local keyDrawY = self.windowSpacing + self.keyHeight + self.keySpacing //same line
    dxDrawImage(keyDrawX, keyDrawY, self.keyWidth, self.keyHeight, self.key_bg, 90, 0, 0, self.key_bg_color[self.keys.arrow_r])
    dxDrawImage(keyDrawX, keyDrawY, self.keyWidth, self.keyHeight, self.key_arrow, 90, 0, 0, self.key_arrow_color[self.keys.arrow_r])

    dxSetRenderTarget()
end

function CKeyDisplay:render()
    dxDrawImage(x/2-self.width/2, 0, self.width, self.height, self.renderTarget)
end

--addEventHandler("onClientResourceStart", resourceRoot, function() new(CKeyDisplay) end)

addEvent("onClientSuccess", true)
addEventHandler("onClientSuccess", localPlayer,
    function()
        new(CKeyDisplay)
    end
)