--
-- PewX (HorrorClown)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 04.10.2015 - Time: 19:47
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
CNickname = {}

function CNickname:constructor()
    self.onApplyChangeEvent = bind(CNickname.onApplyChange, self)

    addEventHandler("onClientApplyNickchange", resourceRoot, self.onApplyChangeEvent)
    addEventHandler("onPlayerLogin", root,
        function(_, eAccount)
            local lastPlayerName = getAccountData(eAccount, "lastPlayerName")
            if lastPlayerName then
                if getPlayerName(source) ~= lastPlayerName then
                    triggerClientEvent(source, "onServerWantChangeNickname", source, lastPlayerName)
                end
            end
        end
    )
end

function CNickname:destructor()

end

function CNickname:onApplyChange(bState)
    local eAccount = getPlayerAccount(client)
    if not eAccount then return end

    local lastPlayerName = getAccountData(eAccount, "lastPlayerName")

    if bState then
        showNickchange = false
        setPlayerName(client, lastPlayerName)
        showNickchange = true
    elseif not bState then
        setAccountData(eAccount, "lastPlayerName", client.name)
    end
end

addEvent("onClientApplyNickchange", true)