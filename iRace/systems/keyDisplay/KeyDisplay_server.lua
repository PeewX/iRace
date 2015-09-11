--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 19.08.2015 - Time: 13:40
-- iGaming-mta.de // iRace-mta.de // pewx.de // iSurvival.de // mtasa.de
--
CKeyDisplay = {}

function CKeyDisplay:constructor()
    self.players = {}

    self.onTargetChangeEvent = bind(CKeyDisplay.targetChange, self)
    self.onTargetKeysChangeEvent = bind(CKeyDisplay.targetKeysChange, self)

    addEvent("onClientChangeKeyDisplayTarget", true)
    addEventHandler("onClientChangeKeyDisplayTarget", root, self.onTargetChangeEvent)

    addEvent("onTargetKeysChange", true)
    addEventHandler("onTargetKeysChange", root, self.onTargetKeysChangeEvent)
end

function CKeyDisplay:destructor()

end

function CKeyDisplay:targetChange(ePlayerTarget, bAdd)
    if not bAdd then
        for i, ePlayer in ipairs(self.players[ePlayerTarget].spectatedBy) do
            if ePlayer == client then
                table.remove(self.players[ePlayerTarget].spectatedBy, i)

                if #self.players[ePlayerTarget].spectatedBy == 0 then
                    triggerClientEvent(ePlayerTarget, "onServerWantKeyPresses", ePlayerTarget, false)
                    self.players[ePlayerTarget] = nil
                end
                return
            end
        end

        return
    end

    if not self.players[ePlayerTarget] then
        self.players[ePlayerTarget] = {
            keyPresses = {},
            spectatedBy = {}
        }

        triggerClientEvent(ePlayerTarget, "onServerWantKeyPresses", ePlayerTarget, true)
    end

    table.insert(self.players[ePlayerTarget].spectatedBy, client)
end

function CKeyDisplay:targetKeysChange(tKeys)
    for _, ePlayer in ipairs(self.players[client].spectatedBy) do
        if isElement(ePlayer) then
            triggerClientEvent(ePlayer, "onServerSendKeys", ePlayer, tKeys)
        end
    end
end

addEventHandler("onResourceStart", resourceRoot, function() new(CKeyDisplay) end)