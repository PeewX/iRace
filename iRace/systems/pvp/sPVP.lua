--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 20.12.2014 - Time: 13:52
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local pvp = {}
pvp.players = {}
pvp.matches = {}
pvp.enabled = true
pvp.debug = true
pvp.prefix = "|PvP| #ff6600"
pvp.maxBet = 100000
pvp.maxWins = 20

addCommandHandler("togglepvp",
    function(ePlayer)
        if hasUserPermissionTo(ePlayer, "togglePvpState") then
            pvp.enabled = not pvp.enabled
            pvp.message(("PvP was %s"):format(pvp.enabled and "enabled" or "disabled"), root)
        end
    end
)

function pvp.message(sText, eToElement)
    triggerClientEvent(eToElement, "addClientMessage", type(eToElement) == "table" and root or eToElement, ("%s%s"):format(pvp.prefix, sText), 255, 255, 255)
end

addEvent("onPlayerGetPvPRequest", true)
addEventHandler("onPlayerGetPvPRequest", root,
    function(nBet, nWins, eTargetPlayer)
        if not checkClient() then return end
        if not pvp.enabled then pvp.message("PvP is disabled!", client) return end

        if client == eTargetPlayer then return end
        if type(nBet) ~= "number" or (nBet <= 0 or nBet > pvp.maxBet) then return end
        if type(nWins) ~= "number" or (nWins <= 0 or nWins > pvp.maxWins) then return end
        if getElementType(eTargetPlayer) ~= "player" then return end

        if isGuestAccount(getPlayerAccount(client)) then return end
        if isGuestAccount(getPlayerAccount(eTargetPlayer)) then pvp.message("Your target is not logged in!", client) return end

        if getAccountData(getPlayerAccount(client), "cash") < nBet then pvp.message("You don't have enough money!", client) return end
        if getAccountData(getPlayerAccount(eTargetPlayer), "cash") < nBet then pvp.message("Your target don't have enough money!") return end

        if not pvp.players[client] then pvp.players[client] = {} end
        if not pvp.players[eTargetPlayer] then pvp.players[eTargetPlayer] = {} end

        if pvp.players[client].matchMaking then pvp.message(("You are already in match making with %s"):format(getPlayerName(pvp.players[client].eTargetPlayer)), client) return end
        if pvp.players[eTargetPlayer].matchMaking then pvp.message(("Your target is already in match making with %s"):format(getPlayerName(pvp.players[eTargetPlayer].eTargetPlayer)), client) return end

        if pvp.players[client].isInPvP then pvp.message("You are already in a PvP match!", client) return end
        if pvp.players[eTargetPlayer].isInPvP then pvp.message("Your target is already in a PvP match!", client) return end

        pvp.players[client].eTargetPlayer = eTargetPlayer
        pvp.players[client].matchMaking = true
        pvp.players[client].nBet = nBet
        pvp.players[client].nNeedWins = nWins
        pvp.players[client].nCurrentWins = 0

        pvp.players[eTargetPlayer].eTargetPlayer = client
        pvp.players[eTargetPlayer].matchMaking = true
        pvp.players[eTargetPlayer].nBet = nBet
        pvp.players[eTargetPlayer].nNeedWins = nWins
        pvp.players[eTargetPlayer].nCurrentWins = 0

        pvp.updateUserpanel(source)
        pvp.updateUserpanel(eTargetPlayer)

        triggerClientEvent(eTargetPlayer, "setPlayerNameToAcceptButton", eTargetPlayer, getPlayerName(client))
        pvp.message(("%s #ff6600wants a pvp match! Accept it in your userpanel."):format(getPlayerName(client)), eTargetPlayer)
        pvp.message(("Request send to %s"):format(getPlayerName(eTargetPlayer)), client)
    end
)

addEvent("onPlayerAcceptPvPRequest", true)
addEventHandler("onPlayerAcceptPvPRequest", root,
    function()
        if not checkClient() then return end
        if not pvp.players[client] then pvp.message("You don't received a pvp match request!", client) return end
        if pvp.players[client].isInPvP then pvp.message("You are already in a PvP match!", client) return end
--        if pvp.players[pvp.players[client].eTargetPlayer].isInPvP then pvp.message("Your target is already in a PvP match!", client) return end
        local eTargetPlayer = pvp.players[client].eTargetPlayer
        if pvp.players[client].matchMaking and pvp.players[eTargetPlayer].matchMaking then
            local eTargetPlayer = pvp.players[client].eTargetPlayer
            pvp.players[client].isInPvP = true
            pvp.players[eTargetPlayer].isInPvP = true
            pvp.message("PvP will start next map!", {client, eTargetPlayer})
            addEventHandler("onPlayerQuit", client, pvp.onPlayerQuit)
            addEventHandler("onPlayerQuit", eTargetPlayer, pvp.onPlayerQuit)
            pvp.updateUserpanel(source)
            pvp.updateUserpanel(eTargetPlayer)
        end
    end
)

addEvent("onPlayerDeclinePvPRequest", true)
addEventHandler("onPlayerDeclinePvPRequest", root,
    function()
        if not checkClient() then return end
        if not pvp.players[client] then pvp.message("You don't received a pvp match request!", client) return end
        if pvp.players[client].isInPvP then pvp.message("You are already in a PvP match!", client) return end
--      if pvp.players[pvp.players[client].eTargetPlayer].isInPvP then pvp.message("Your target is already in a PvP match!", client) return end
        local eTargetPlayer = pvp.players[client].eTargetPlayer
        if pvp.players[client].matchMaking and pvp.players[eTargetPlayer].matchMaking then
            pvp.players[client] = nil
            pvp.players[eTargetPlayer] = nil
            pvp.message("PvP match request was canceld!", {client, eTargetPlayer})
            triggerClientEvent({source, eTargetPlayer}, "resetAllPvPLabels", root)
        end
    end
)

function pvp.isRacePlayerDead(ePlayer)
    for _, eTPlayer in ipairs(pvp.deadPVPPlayers) do
        if eTPlayer == ePlayer then
            return true
        end
    end
    return false
end

function pvp.onPlayerWasted()
    if not pvp.isRacePlayerDead(source) then
        table.insert(pvp.deadPVPPlayers, source)
        if pvp.players[source] and pvp.players[source].isInPvP then
            local eTargetPlayer = pvp.players[source].eTargetPlayer
            if pvp.players[eTargetPlayer] and pvp.players[eTargetPlayer].isInPvP then
                pvp.players[eTargetPlayer].nCurrentWins = pvp.players[eTargetPlayer].nCurrentWins + 1
                removeEventHandler("onPlayerWasted", source, pvp.onPlayerWasted)
                removeEventHandler("onPlayerWasted", eTargetPlayer, pvp.onPlayerWasted)

                pvp.updateUserpanel(source)
                pvp.updateUserpanel(eTargetPlayer)

                if pvp.players[eTargetPlayer].nCurrentWins == pvp.players[eTargetPlayer].nNeedWins then
                    pvp.message(("Player %s #ff6600won the PvP match vs. %s#ff6600 and get %s!"):format(getPlayerName(eTargetPlayer), getPlayerName(source), pvp.players[eTargetPlayer].nBet), root)
                    addStat(getPlayerAccount(eTargetPlayer), "cash", pvp.players[eTargetPlayer].nBet)
                    addStat(getPlayerAccount(eTargetPlayer), "pvpWins", 1)
                    addStat(getPlayerAccount(source), "cash", -pvp.players[eTargetPlayer].nBet)
                    removeEventHandler("onPlayerQuit", source, pvp.onPlayerQuit)
                    removeEventHandler("onPlayerQuit", eTargetPlayer, pvp.onPlayerQuit)
                    pvp.players[source] = nil
                    pvp.players[eTargetPlayer] = nil
                    triggerClientEvent({source, eTargetPlayer}, "resetAllPvPLabels", root)
                end
            end
        end
    end
end

function pvp.onPlayerQuit()
    if pvp.players[source] and pvp.players[source].isInPvP then
        local eTargetPlayer = pvp.players[source].eTargetPlayer
        if pvp.players[eTargetPlayer] and pvp.players[eTargetPlayer].isInPvP then
            removeEventHandler("onPlayerWasted", source, pvp.onPlayerWasted)
            removeEventHandler("onPlayerWasted", eTargetPlayer, pvp.onPlayerWasted)
            removeEventHandler("onPlayerQuit", source, pvp.onPlayerQuit)
            removeEventHandler("onPlayerQuit", eTargetPlayer, pvp.onPlayerQuit)

            pvp.message(("Player %s #ff6600won the PvP match vs. %s#ff6600 and get %s!"):format(getPlayerName(eTargetPlayer), getPlayerName(source), pvp.players[eTargetPlayer].nBet), root)
            addStat(getPlayerAccount(eTargetPlayer), "cash", pvp.players[eTargetPlayer].nBet)
            addStat(getPlayerAccount(source), "cash", -pvp.players[eTargetPlayer].nBet)
            pvp.players[source] = nil
            pvp.players[eTargetPlayer] = nil
            triggerClientEvent(eTargetPlayer, "resetAllPvPLabels", root)
        end
    end
end

function pvp.updateUserpanel(ePlayer)
    triggerClientEvent(ePlayer, "setLabelsForPvP", ePlayer, pvp.players[ePlayer], pvp.players[pvp.players[ePlayer].eTargetPlayer])
end

addEventHandler("onServerGotMapType", root,
    function(type)
        if (type == "DM") then
            pvp.deadPVPPlayers = {}
            for _, ePlayer in ipairs(getElementsByType"player") do
                if pvp.players[ePlayer] and pvp.players[ePlayer].isInPvP then
                    addEventHandler("onPlayerWasted", ePlayer, pvp.onPlayerWasted)
                end
            end
        end
    end
)