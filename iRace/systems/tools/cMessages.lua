--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 19.09.2014 - Time: 01:40
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--

local mt = {}
mt.messages = {}
mt.startX = 20/1920*x
mt.startY = y/2.5

function mt.addMessage(text, r, g, b, image)
    if not getElementData(me, "isLogedIn") then return end
    for i, message in ipairs(mt.messages) do
        message.endPos = (message.endPos or message.sY) - dxGetFontHeight(1, message.font)
        mt.setMessageProperty(i, "sY", message.endPos)
    end

    local del = getTickCount() + 20000

    table.insert(mt.messages, {text = text, color = {r,g,b, 0}, image = image, removeTime = del, sX = mt.startX, sY = mt.startY, font = iFont[10], state = "fadeIN"})
    outputConsole(("CM: %s"):format(removeColorCodes(text)))
end
addEvent("addClientMessage", true)
addEventHandler("addClientMessage", root, mt.addMessage)

function mt.render()
    for i, msg in ipairs(mt.messages) do
        local r, g, b, a = unpack(msg.color)
        if msg.state == "fadeIN" then if a < 255 then msg.color = {r, g, b, a + 15} else msg.state = "render" end end
        if msg.state == "fadeOUT" then if a > 0 then msg.color = {r, g, b, a - 15} else msg.state = "destroyable" end end
        dxDrawText(removeColorCodes(msg.text), msg.sX+1, msg.sY+1, x, y, tocolor(0, 0, 0, a), 1, msg.font, "left", "top", false, false, false, true)
        dxDrawText(msg.text, msg.sX, msg.sY, x, y, tocolor(r,g,b, a), 1, msg.font, "left", "top", false, false, false, true)
    end
end
addEventHandler("onClientRender", root, mt.render)

addEventHandler("onClientPreRender", root,
    function()
        for i, msg in ipairs(mt.messages) do
            if mt.moving then return end
            if getTickCount() > msg.removeTime and msg.state == "render" then
                msg.state = "fadeOUT"
            elseif msg.state == "destroyable" then
                table.remove(mt.messages, i) --Eine schöne moveout und movein fehlt ;)
            end
        end
    end
)

function mt.setMessageProperty(index, prop, value)
    local t = {}
    local function render()
        if not mt.messages[t.msgIndex] then removeEventHandler("onClientPreRender", root, render) return end
        mt.moving = true
        local p = (getTickCount()-t.sT)/(t.eT-t.sT)
        mt.messages[t.msgIndex][t.msgProp] = interpolateBetween(t.s, 0, 0, t.e, 0, 0, p, "OutBack")
        if p >= 1 then removeEventHandler("onClientPreRender", root, render) mt.moving = false end
    end
    t.sT = getTickCount()
    t.eT = t.sT + 600
    t.msgIndex = index
    t.msgProp = prop
    t.s = mt.messages[index][prop]
    t.e = value
    addEventHandler("onClientPreRender", root, render)
end

addEventHandler("onClientPlayerQuit", root,
    function(rsn)
        mt.addMessage(("|Quit| %s#ffffff, left [%s]"):format(getPlayerName(source), rsn), 255, 255, 255)
    end
)