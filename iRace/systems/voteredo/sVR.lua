--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 22.12.2014 - Time: 17:07
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local vrt = {}
vrt.prefix = "|VR|#A4B2F3 "
vrt.enabled = true
vrt.mapAllowed = false
vrt.state = "wait"
vrt.players = {}
vrt.activePlayers = {}
vrt.minPlayers = 1
vrt.lastRedoMap = nil
vrt.lastMap = nil

function vrt.message(sText, eToElement)
    triggerClientEvent(eToElement, "addClientMessage", type(eToElement) == "table" and root or eToElement, ("%s%s"):format(vrt.prefix, sText), 255, 255, 255)
end

function vrt.isPlayerInTable(ePlayer)
    for _, p in ipairs(vrt.players) do
       if p == ePlayer then return true end
    end
    return false
end

function vrt.isActivePlayer(ePlayer)
    for _, p in ipairs(activePlayers) do
        if p == ePlayer then return true end
    end
    return false
end

function vrt.check()
    if #vrt.players >= vrt.needPlayerCount then
        vrt.mapRedo = true
        vrt.message("Voting success! Current map has been requeued.", root)
        triggerEvent("onVoteRedoSuccess", root)
        setTimer(function() triggerClientEvent("onVREnded", root) end, 1500, 1)
    end
end

function vrt.updatePlayers()
    triggerClientEvent("onUpdateVRTable", root, {#vrt.players, vrt.needPlayerCount})
end

addCommandHandler("vr",
    function(ePlayer)
        if not vrt.enabled then vrt.message("VoteRedo ist currently disabled!", ePlayer) return end
        if #activePlayers < vrt.minPlayers then vrt.message(("More than %s players are required!"):format(vrt.minPlayers), ePlayer) return end
        if not vrt.isActivePlayer(ePlayer) then vrt.message("You are not an active player!", ePlayer) return end
        if vrt.isPlayerInTable(ePlayer) then vrt.message("You already voted!", ePlayer) return end
        if not vrt.mapAllowed then vrt.message("Map can be repeated only once!", ePlayer) return end
        if not vrt.mapRunning then vrt.message("You can only vote while a map is running!", ePlayer) return end
        if vrt.mapRedo then vrt.message("Current map has already been requeued!", ePlayer) return end

        table.insert(vrt.players, ePlayer)
        vrt.check()
        vrt.updatePlayers()
    end
)

addEvent("onMapStarting")
addEventHandler("onMapStarting", root,
    function(tMap)
        vrt.lastMap = vrt.currentMap
        vrt.currentMap = tMap
        vrt.mapAllowed = not (vrt.lastMap.name == vrt.currentMap.name)
    end
, false, "low-99999")

addEventHandler("onRaceStateChanging", root,
    function(ns)
        if ns == "Running" then
            vrt.players = {}
            vrt.mapRedo = false
            if #activePlayers >= vrt.minPlayers then
                vrt.needPlayerCount =  math.ceil(#activePlayers*0.6)
                vrt.mapRunning = true
            end
        else
            vrt.mapRunning = false
            triggerClientEvent("onVREnded", root)
        end
    end
)