--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 29.07.2014 - Time: 21:17
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
function createScoreboardColumns()
    exports.scoreboard:scoreboardAddColumn("cash", getRootElement(), 60, "Cash")
    exports.scoreboard:scoreboardAddColumn("level", getRootElement(), 40, "Level")
    exports.scoreboard:scoreboardAddColumn("sbplaytime", getRootElement(), 50, "Playtime")
    exports.scoreboard:scoreboardAddColumn("playerstatus", getRootElement(), 120, "Status")
    exports.scoreboard:scoreboardAddColumn("sbwins", getRootElement(), 40, "Wins")
end
addEventHandler("onResourceStart", resroot, createScoreboardColumns)

function destroyScoreboardColumns()
    exports.scoreboard:removeScoreboardColumn("cash")
    exports.scoreboard:removeScoreboardColumn("level")
    exports.scoreboard:removeScoreboardColumn("sbplaytime")
    exports.scoreboard:removeScoreboardColumn("playerstatus")
    exports.scoreboard:removeScoreboardColumn("sbwins")
end
addEventHandler("onResourceStop", resroot, destroyScoreboardColumns)

function onJoinSetGuest()
    setElementData(source, "cash", "guest")
    setElementData(source, "level", "guest")
    setElementData(source, "sbplaytime", "guest")
    setElementData(source, "playerstatus", "guest")
    setElementData(source, "sbwins", "guest")
end
addEventHandler("onPlayerJoin", root, onJoinSetGuest)

function onLoginSetCurrentStates(_, current)
    if getAccountData(current, "cash") and getAccountData(current, "level") then
        setElementData(source, "cash", getAccountData(current, "cash"))
        setElementData(source, "level", getAccountData(current, "level"))
        setElementData(source, "sbplaytime", roundTime(getAccountData(current, "playtime")*60))
        setElementData(source, "playerstatus", getAccountData(current, "playerstatus"))
        setElementData(source, "sbwins", getAccountData(current, "ddswon") + getAccountData(current, "dmswon"))
    end
end
addEventHandler("onPlayerLogin", root, onLoginSetCurrentStates)

function setCash()
    for _,player in ipairs(getElementsByType("player")) do
        if isGuestAccount(getPlayerAccount(player)) == false then
            if getAccountData(getPlayerAccount(player), "cash") then
                setElementData(player, "sbplaytime", roundTime(getAccountData(getPlayerAccount(player), "playtime")*60))
                setElementData(player, "sbwins", getAccountData(getPlayerAccount(player), "ddswon")+getAccountData(getPlayerAccount(player), "dmswon"))
            end
        end
    end
end
setTimer(setCash, 10000, -1)