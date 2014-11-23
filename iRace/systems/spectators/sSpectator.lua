--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 31.07.2014 - Time: 19:20
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local playerData = {}
local spectator_players = {}

addEvent('onCameraTargetChange')
addEvent('removeClient', true)
addEvent('addClient', true)

function elementCheck (elem)
    if elem then
        if isElement (elem) then
            if (getElementType (elem) == 'player') then
                return true
            end
        end
    end
    return false
end

function repairTable()
    for i, val in ipairs (spectator_players) do
        if not elementCheck (val) then
            if playerData[val] then
                if playerData[val].target then
                    if (elementCheck(playerData[val].target) and playerData[val].target ~= val) then
                        triggerClientEvent(playerData[val].target, 'removeSpectator', playerData[val].target, player)
                    end
                end
                for k, _ in ipairs (playerData) do
                    if (k == val) then
                        table.remove (playerData, k)
                    end
                end
            end
            table.remove (spectator_players, i)
        end
    end
end

function spectators()
    for _, player in ipairs(spectator_players) do
        if elementCheck (player) then
            local target = getCameraTarget(player)
            if (not playerData[player]) then
                playerData[player] = {}
            end

            if (target ~= playerData[player].target) then -- if the target is different from previous one
                playerData[player].previous = playerData[player].target -- store the old target
                playerData[player].target = target -- store the new target
                triggerEvent('onCameraTargetChange', player, playerData[player].target, playerData[player].previous)
            end
        else
            repairTable()
        end
    end
end
setTimer(spectators, 1000, 0)

addEventHandler('onCameraTargetChange', root,
    function(target, oldTarget)
        if elementCheck (oldTarget) then -- if the old target is valid(ie. not false or nil(in which case the camera was fixed))
            triggerClientEvent(oldTarget, 'removeSpectator', oldTarget, source) -- trigger for the old target to remove from his list
        end
        if (target == source) or (not target) then -- if the new target is invalid or facing the player who invoked the event
            return
        end
        if elementCheck (target) then
            triggerClientEvent(target, 'addSpectator', target, source) -- else we add the player to the targets list
        end
    end
)

function removeClient()
    if (playerData[source]) then
        if (playerData[source].target) then
            triggerClientEvent(playerData[source].target, 'removeSpectator', playerData[source].target, source)
        end
        playerData[source] = nil
    end
    for i, val in ipairs(spectator_players) do
        if (val == source) then
            table.remove(spectator_players, i)
        end
    end
end
addEvent ('removeClient')
addEventHandler ('removeClient', root, removeClient)

function addClient()
    if elementCheck (source) then
        table.insert(spectator_players, source)
    end
end
addEvent ('addClient', true)
addEventHandler ('addClient', root, addClient)
addEventHandler ('onPlayerQuit', root, removeClient)