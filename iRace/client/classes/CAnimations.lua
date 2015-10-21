--
-- PewX (HorrorClown)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 30.09.2015 - Time: 22:28
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
CAnimation = {}

function CAnimation:constructor(CInstance, ...)
    self.isRendering = false

    self.instance = CInstance
    self.tbl_Objects = {...}

    self.renderFunc = bind(CAnimation.render, self)
end

function CAnimation:destructor()

end

function CAnimation:startAnimation(nDuration, sAnimationType, ...)
    self.startTick = getTickCount()
    self.endTick = self.startTick + nDuration
    self.animationType = sAnimationType
    self.tbl_animateTo = {...}

    if #self.tbl_Objects ~= #self.tbl_animateTo then
        outputDebugString("Invalid animations to object count")
        return false
    end

    self.n_ObjectCount = #self.tbl_Objects

    self.startValues = {}
    for i = 1, self.n_ObjectCount do
        self.startValues[i] = self.instance[self.tbl_Objects[i]]
    end

    if not self.isRendering then
        self.isRendering = true
        addEventHandler("onClientRender", root, self.renderFunc)
    end
end

function CAnimation:render()
    local p = (getTickCount()-self.startTick)/(self.endTick-self.startTick)
    for i = 1, #self.tbl_Objects do
        self.instance[self.tbl_Objects[i]] = interpolateBetween(self.startValues[i], 0, 0, self.tbl_animateTo[i], 0, 0, p, self.animationType)
    end
    self.instance:updateRenderTarget()

    if p >= 1 then
        self.isRendering = false
        removeEventHandler("onClientRender", root, self.renderFunc)
    end
end