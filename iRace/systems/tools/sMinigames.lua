--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 22.12.2014 - Time: 20:56
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
---------------------------------------------------------------------------------------
----------------------Dice-------------------------------------------------------------
---------------------------------------------------------------------------------------

function diceFunction(thePlayer)
    local theAccount = getPlayerAccount(thePlayer)
    if not isGuestAccount(theAccount) then
        if not isPlayerWaitlist(thePlayer, "dice") then
            local theCube = math.random(1,6)
            local moneyWin = math.random(0,20000)
            local moneyLost = math.random(0,20000)
            local theVehicle = getPedOccupiedVehicle(thePlayer)

            if not theVehicle then
                outputChatBox("|Dice| #BB00FFYou are not in a vehicle!", thePlayer, 255, 255, 255, true)
                do return end
            end

            if g_raceState ~= "Running" then
                outputChatBox("|Dice| #BB00FFPlease wait.. O:", thePlayer, 255, 255, 255, true)
                do return end
            end

            addPlayerWaitlist(thePlayer, "dice")
            setTimer(function()
                if theCube == 1 then
                    local todo = math.random(1,3)
                    if todo == 1 then
                        if checkVehicle(theVehicle, thePlayer) then
                            blowVehicle(theVehicle, true)
                            outputChatBox("|Dice| " .. getPlayerName(thePlayer) .. " #BB00FFdiced a 1 and was blowed by the awesome cube! :>", getRootElement(), 255, 255, 255, true)
                        end
                    elseif todo == 2 then
                        if checkVehicle(theVehicle, thePlayer) then
                            setElementAlpha(theVehicle, 0)
                            setElementAlpha(thePlayer, 0)
                            outputChatBox("|Dice| " .. getPlayerName(thePlayer) .. " #BB00FFdiced a 1 and was set invisible by the awesome cube! :>", getRootElement(), 255, 255, 255, true)
                            setTimer(function(vehicle, player) if not checkVehicle(vehicle, player) then return end	setElementAlpha(theVehicle, 0) setElementAlpha(thePlayer, 0) end, 120000, 1, theVehicle, thePlayer)
                        end
                    elseif todo == 3 then
                        outputChatBox("|Dice| #BB00FFYou have diced a 1 and nothing happens :(", thePlayer, 255, 255, 255, true)
                    end

                elseif theCube == 2 then
                    local todo = math.random(1,2)
                    if todo == 1 then
                        if not isPlayerMuted(thePlayer) then
                            setPlayerMuted(thePlayer, true)
                            outputChatBox("|Dice| " .. getPlayerName(thePlayer) .. " #BB00FFdiced a 2 and was muted by the awesome cube! :>", getRootElement(), 255, 255, 255, true)
                            setTimer(function()
                                outputChatBox("|Dice| #BB00FFYou can now write again :>", thePlayer, 255, 255, 255, true)
                                setPlayerMuted(thePlayer, false)
                            end, 15000, 1, thePlayer, false)
                        else
                            outputChatBox("|Dice| #BB00FFThe awesome cube says 'You are already muted' :(", thePlayer, 255, 255, 255, true)
                        end
                    end

                elseif theCube == 3 then
                    if checkVehicle(theVehicle, thePlayer) then
                        addVehicleUpgrade(theVehicle, 1010)
                        outputChatBox("|Dice| #BB00FFYou have diced a 3 and get nitro!", thePlayer, 255, 255, 255, true)
                    end
                elseif theCube == 4 then
                    local todo = math.random(1,2)
                    if todo == 1 then
                        if checkVehicle(theVehicle, thePlayer) then
                            setElementHealth(theVehicle, 1000)
                            outputChatBox("|Dice| " .. getPlayerName(thePlayer) .. " #BB00FFdiced a 4 and was repaired!", getRootElement(), 255, 255, 255, true)
                        end
                    elseif todo == 2 then
                        if checkVehicle(theVehicle, thePlayer) then
                            local rx, ry, rz = getVehicleRotation(theVehicle)
                            setVehicleRotation (theVehicle, 0, tonumber(ry), tonumber(rz))
                            outputChatBox("|Dice| " .. getPlayerName(thePlayer) .. " #BB00FFdiced a 4 and was flipped!", getRootElement(), 255, 255, 255, true)
                        end
                    end
                elseif theCube == 5 then
                    outputChatBox("|Dice| #BB00FFYou have diced a 5 and you lost " .. tostring(moneyLost) .. "$!", thePlayer, 255, 255, 255, true)
                    addStat(theAccount, "cash", -moneyLost)
                elseif theCube == 6 then
                    outputChatBox("|Dice| #BB00FFYou have diced a 6 and you earn " .. tostring(moneyWin) .. "$!", thePlayer, 255, 255, 255, true)
                    addStat(theAccount, "cash", moneyWin)
                end
            end, 5000, 1)
        else
            outputChatBox("|Dice| #BB00FFYou can only use dice every 30 seconds!", thePlayer, 255, 255, 255, true)
        end
    end
end
addCommandHandler("dice", diceFunction)
addCommandHandler("roll", diceFunction)

---------------------------------------------------------------------------------------
----------------------Flip-------------------------------------------------------------
---------------------------------------------------------------------------------------

function flipFunction(thePlayer, theCommand, amount)
    local theAccount = getPlayerAccount(thePlayer)
    if not isGuestAccount(theAccount) then
        if not isPlayerWaitlist(thePlayer, "flip") then
            local playerMoney = getAccountData(theAccount, "cash")
            local amount = tonumber(amount)
            if amount then
                if amount >= 500 and amount <= 20000 then
                    if tonumber(playerMoney) >= amount then
                        addPlayerWaitlist(thePlayer, "flip")
                        local chance = math.random(1,2)
                        if chance == 1 then
                            addStat(theAccount, "cash", amount)
                            outputChatBox("|Flip| #BB00FFYou have flipped a coin and won " .. amount .. "$!", thePlayer, 255, 255, 255, true)
                        else
                            addStat(theAccount, "cash", -amount)
                            outputChatBox("|Flip| #BB00FFYou have flipped a coin and loose " .. amount .. "$!", thePlayer ,255, 255, 255, true)
                        end
                    else
                        outputChatBox("|Flip| #BB00FFYou haven't enough money to flip the coint!", thePlayer, 255, 255, 255, true)
                    end
                else
                    outputChatBox("|Flip| #BB00FFThe amount must be between 500$ and 20000$", thePlayer, 255, 255, 255, true)
                end
            else
                outputChatBox("|Flip| #BB00FFSyntax '/flip <amount>'", thePlayer, 255, 255, 255, true)
            end
        else
            outputChatBox("|Flip| #BB00FFYou can only use flip every 30 seconds!", thePlayer, 255, 255, 255, true)
        end
    end
end
addCommandHandler("flip", flipFunction)

---------------------------------------------------------------------------------------
----------------------Wingame----------------------------------------------------------
---------------------------------------------------------------------------------------
startWingameIn = math.random(900000, 1800000)
tableWingamePlayers ={}
winGameON = false
winPot = 0
winGameUsers = 0
betCash = 0
infosShowed = 0

function winGameCommand(thePlayer)
    local theAccount = getPlayerAccount(thePlayer)
    if not isGuestAccount(theAccount) then
        local playerMoney = tonumber(getAccountData(theAccount, "cash"))
        if winGameON then
            if not isPlayerAccountInWingame(theAccount) then
                if not (betCash > playerMoney) then
                    addStat(theAccount, "cash", -betCash, true)
                    winPot = winPot + betCash
                    winGameUsers = winGameUsers + 1
                    table.insert(tableWingamePlayers, theAccount)
                    outputChatBox("|Wingame| " .. getPlayerName(thePlayer) .. " #11ff11joined the wingame for #B4FF11" .. betCash .. "#11ff11$!", getRootElement(), 255, 255, 255, true)
                else
                    outputChatBox("|Wingame| #11ff11You dont have enough money!", thePlayer, 255, 255, 255, true)
                end
            else
                outputChatBox("|Wingame| #11ff11You are already in!", thePlayer, 255, 255, 255, true)
            end
        else
            outputChatBox("|Wingame| #11ff11The wingame hasn't started yet!", thePlayer, 255, 255, 255, true)
        end
    end
end
addCommandHandler("getawin",winGameCommand)

function wInfoCommand(thePlayer)
    if winGameON then
        outputChatBox("|Wingame|#11ff11 Players in wingame: #22dd22" .. winGameUsers, thePlayer, 255, 255, 255, true)
        outputChatBox("|Wingame|#11ff11 Pot: #22dd22" .. winPot, thePlayer, 255, 255, 255, true)
        outputChatBox("|Wingame|#11ff11 Bet price: #22dd22" .. betCash, thePlayer, 255, 255, 255, true)
        for i, account in pairs(tableWingamePlayers) do
            local playerInWingame = getPlayerName(getAccountPlayer(account)) or getAccountName(account)
            outputChatBox("- " .. playerInWingame, thePlayer, 255, 255, 255, true)
        end
    else
        outputChatBox("|Wingame|#11ff11 The wingame hasn't started yet!", thePlayer, 255, 255, 255, true)
    end
end
addCommandHandler("winfo", wInfoCommand)

function showWingameInfos()
    if winGameON then
        infosShowed = infosShowed + 1
        if infosShowed == 1 then
            outputChatBox("|Wingame| #11ff11The wingame ends in 10 minutes. Pot: #B4FF11" .. winPot .. "#11ff11$ Players: #B4FF11" .. winGameUsers, getRootElement(), 255, 255, 255, true)
            setTimer(showWingameInfos, 300000, 1)
        elseif infosShowed == 2 then
            outputChatBox("|Wingame| #11ff11The wingame ends in 5 minutes. Pot: #B4FF11" .. winPot .. "#11ff11$ Players: #B4FF11" .. winGameUsers, getRootElement(), 255, 255, 255, true)
            setTimer(showWingameInfos, 300000, 1)
        elseif infosShowed == 3 then
            outputChatBox("|Wingame| #ff11ffThe wingame ends in one minute!", getRootElement(), 255, 255, 255, true)
            setTimer(showWingameInfos, 60000, 1)
        else
            stopAndOutPot()
        end
    end
end

function startWingame()
    if not winGameON then
        tableWingamePlayers = {}
        winGameON = true
        winPot = 0
        winGameUsers = 0
        infosShowed = 0
        betCash = math.random(0, 20000)
        outputChatBox("|Wingame| #11ff11The wingame has started. The prizepool is #B4FF11" .. betCash .. "#11ff11.", getRootElement(), 255, 255, 255, true)
        setTimer(showWingameInfos, 300000, 1)
    end
end
setTimer(startWingame, startWingameIn, 1)

function stopAndOutPot()
    if winGameON then
        if winGameUsers > 0 then
            local theWinner = table.random(tableWingamePlayers)
            local theWinnerName = getPlayerName(getAccountPlayer(theWinner)) or getAccountName(theWinner)
            local nextWingame = math.random(1800000, 3600000)
            outputChatBox("|Wingame| " .. theWinnerName .. "#11ff11 has won the wingame and earned #B4FF11" .. tostring(winPot) .. " #11ff11$!", getRootElement(), 255, 255, 255, true)
            outputChatBox("|Wingame| #11ff11The next wingame starts in #B4FF11" .. math.floor((nextWingame/1000)/60) .. " #11ff11minutes!", getRootElement(), 255, 255, 255, true)
            addStat(theWinner, "cash", tonumber(winPot))
            winGameON = false
            if isTimer(nextRoundTimer) then killTimer(nextRoundTimer) end
            nextRoundTimer = setTimer(startWingame, nextWingame, 1)
        else
            local nextWingame = math.random(1800000, 3600000)
            outputChatBox("|Wingame| #11ff11Nobody joined the wingame. Next wingame starts in #B4FF11" .. math.floor((nextWingame/1000)/60) .. " #11ff11minutes!", getRootElement(), 255, 255, 255, true)
            winGameON = false
            if isTimer(nextRoundTimer) then killTimer(nextRoundTimer) end
            nextRoundTimer = setTimer(startWingame, nextWingame, 1)
        end
    end
end

function isPlayerAccountInWingame (account)
    returnValue = false
    for i,sAccount in pairs(tableWingamePlayers) do
        if account == sAccount then
            returnValue = true
        end
    end
    return returnValue
end

---------------------------------------------------------------------------------------
----------------------Util for minigames-----------------------------------------------
---------------------------------------------------------------------------------------
local tFlip, tDice = {}, {}
function addPlayerWaitlist(player, list)
    if list == "flip" then
        tFlip[player] = setTimer(function() killTimer(tFlip[player]) tFlip[player] = nil end, 30000, 1, player)
    elseif  list == "dice" then
        tDice[player] = setTimer(function() killTimer(tDice[player]) tDice[player] = nil end, 30000, 1, player)
    end
end

function isPlayerWaitlist(player, list)
    if list == "flip" then if isTimer(tFlip[player]) then return true end
    elseif list == "dice" then if isTimer(tDice[player]) then return true end
    end
    return false
end


function checkVehicle(vehicle, player)
    if isElement(vehicle) then
        if getElementType(vehicle) == "vehicle" then
            return true
        end
    end
    outputChatBox("|Dice| #BB00FFSomething is wrong... WAAAAAH. -shutdown", thePlayer, 255, 255, 255, true)
    return false
end