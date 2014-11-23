--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 31.07.2014 - Time: 19:45
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local fixPrice = 3000
local flipPrice = 2500
local BoomBoomSongPrice = 5000
local ghostPrice = 5000
local pulsatingHeadlightsPrice = 30000
local wheelsPrice = 30000
local customcolorPrice = 40000
local wintextPrice = 70000
local rainbowcolorPrice = 150000
local avatarPrice = 100000
local joinmessagePrice = 10000

local minLevelGhostmode = 10
local minLevelJoinmessage = 10
local minLevelPulsatingHeadlights = 30
local minLevelFix = 5
local minLevelFlip = 10
local minLevelWheels = 15
local minLevelCustomcolor = 20
local minLevelWintext = 30
local minLevelRainbowcolor = 40
local minLevelAvatar = 25

local isMusicPlaying = false

function buyShopItem(thePlayer, _, theObject)
    if isGuestAccount(getPlayerAccount(thePlayer)) then return end
    if not theObject then outputChatBox("|Shop| #ff9900Invalid arguments (flip, fix)", thePlayer, 255, 255, 255, true) return end
    if not isMapType("DM") then outputChatBox("|Shop| #ff9900You can only buy this items on DM maps!", thePlayer, 255, 255, 255, true) return end
    if isPlayerRespawnMode(thePlayer) then return end

    local theAccount = getPlayerAccount(thePlayer)
    local thePlayerCash = getAccountData(theAccount, "cash")
    local level = getAccountData(theAccount, "level")

    if theObject == "fix" then
        if not (tonumber(level) >= minLevelFix) then outputChatBox("#FFFFFF|Shop| #ff9900You need level " .. minLevelFix .. " to fix your vehicle!", thePlayer, 0, 0, 0, true) return end
        if not (tonumber(thePlayerCash) >= fixPrice) then outputChatBox("#FFFFFF|Shop| #ff9900You don't have enough money to fix your vehicle!", thePlayer, 0, 0, 0, true) return end
        if isPedInVehicle(thePlayer) then
            fixVehicle(getPedOccupiedVehicle(thePlayer))
            outputChatBox("#FFFFFF|Shop| #ff9900Your vehicle was successfully fixed", thePlayer, 0, 0, 0, true)
            outputServerLog("[Shop| " .. removeColorCodes(getPlayerName(thePlayer)) .. " bought vehicle: fix")
            addStat(theAccount, "cash", -fixPrice)
        else
            outputChatBox("#FFFFFF|Shop| #ff9900You are not in a vehicle!", thePlayer, 0, 0, 0, true)
        end
    elseif theObject == "flip" then
        if not (tonumber(level) >= minLevelFlip) then outputChatBox("#FFFFFF|Shop| #ff9900You need level " .. minLevelFix .. " to flip your vehicle!", thePlayer, 0, 0, 0, true) return end
        if not (tonumber(thePlayerCash) >= flipPrice) then outputChatBox("#FFFFFF|Shop| #ff9900You don't have enough money to flip your vehicle!", thePlayer, 0, 0, 0, true) return end
        if isPedInVehicle(thePlayer) then
            local _, ry, rz = getElementRotation(getPedOccupiedVehicle(thePlayer))
            setVehicleRotation(getPedOccupiedVehicle(thePlayer), 0, tonumber(ry), tonumber(rz))
            outputChatBox("#FFFFFF|Shop| #ff9900Your vehicle was successfully flipped", thePlayer, 0, 0, 0, true)
            outputServerLog("[Shop| " .. removeColorCodes(getPlayerName(thePlayer)) .. " bought vehicle: flip")
            addStat(theAccount, "cash", -flipPrice)
        else
            outputChatBox("#FFFFFF|Shop| #ff9900You are not in a vehicle!", thePlayer, 0, 0, 0, true)
        end
    end
end
addCommandHandler("buy", buyShopItem)

-- - - - - - - - - - -  - --

function buyPerPanel(theObject)
    if isGuestAccount(getPlayerAccount(source)) then return end
    if not theObject then return end

    local theAccount = getPlayerAccount(source)
    local thePlayerCash = getAccountData(theAccount, "cash")
    local level = getAccountData(theAccount, "level")

    if theObject == "Vehiclecolor" then
        if not (getAccountData(theAccount, "customcolor")) then
            if not (tonumber(level) >= minLevelCustomcolor) then outputChatBox("#FFFFFF|Shop| #ff9900You need level " .. minLevelCustomcolor .. " to buy customcolor!", source, 0, 0, 0, true) return end
            if not (tonumber(thePlayerCash) >= customcolorPrice) then outputChatBox("#FFFFFF|Shop| #ff9900You don't have enough money to buy customcolor!", source, 0, 0, 0, true) return end
            setAccountData(theAccount, "customcolor", true)
            outputChatBox("#FFFFFF|Shop| #ff9900You successfully bought vehiclecolor. You can change your colors in the settings (U -> Settings)", source, 0, 0, 0, true)
            addStat(theAccount, "cash", -customcolorPrice)
        else
            outputChatBox("#FFFFFF|Shop| #ff9900You allready bought 'vehiclecolor'!", source, 0, 0, 0, true)
        end
    elseif theObject == "Wintext" then
        if not (getAccountData(theAccount, "onBuyWinText")) then
            if not (tonumber(level) >= minLevelWintext) then outputChatBox("#FFFFFF|Shop| #ff9900You need level " .. minLevelWintext .. " to buy a wintext!", source, 0, 0, 0, true) return end
            if not (tonumber(thePlayerCash) >= wintextPrice) then outputChatBox("#FFFFFF|Shop| #ff9900You don't have enough money to buy a wintext!", source, 0, 0, 0, true) return end
            setAccountData(theAccount, "onBuyWinText", true)
            outputChatBox("#FFFFFF|Shop| #ff9900You successfully bought wintext. You can change your wintext in the settings (U -> Settings)", source, 0, 0, 0, true)
            addStat(theAccount, "cash", -wintextPrice)
        else
            outputChatBox("#FFFFFF|Shop| #ff9900You allready bought 'wintext'!", source, 0, 0, 0, true)
        end
    elseif theObject == "Rainbow Color" then
        if not (getAccountData(theAccount, "rainbowcolor")) then
            if not (tonumber(level) >= minLevelRainbowcolor) then outputChatBox("#FFFFFF|Shop| #ff9900You need level " .. minLevelRainbowcolor .. " to buy rainbow color!", source, 0, 0, 0, true) return end
            if not (tonumber(thePlayerCash) >= rainbowcolorPrice) then outputChatBox("#FFFFFF|Shop| #ff9900You don't have enough money to buy rainbow color!", source, 0, 0, 0, true) return end
            outputChatBox("#FFFFFF|Shop| #ff9900You successfully bought rainbowcolor", source, 0, 0, 0, true)
            addStat(theAccount, "cash", -rainbowcolorPrice)
            setAccountData(theAccount, "rainbowcolor", true)
        else
            outputChatBox("#FFFFFF|Shop| #ff9900You allready bought 'rainbowcolor'!", source, 0, 0, 0, true)
        end
    elseif theObject == "Wheels" then
        if not (getAccountData(theAccount, "boughtWheels")) then
            if not (tonumber(level) >= minLevelWheels) then outputChatBox("#FFFFFF|Shop| #ff9900You need level " .. minLevelWheels .. " to buy custom wheels!", source, 0, 0, 0, true) return end
            if not (tonumber(thePlayerCash) >= wheelsPrice) then outputChatBox("#FFFFFF|Shop| #ff9900You don't have enough money to buy custom wheels!", source, 0, 0, 0, true) return end
            outputChatBox("#FFFFFF|Shop| #ff9900You successfully bought custom wheels. You can change your wheels in the settings (U -> Settings)", source, 0, 0, 0, true)
            addStat(theAccount, "cash", -wheelsPrice)
            setAccountData(theAccount, "boughtWheels", true)
        else
            outputChatBox("#FFFFFF|Shop| #ff9900You allready bought 'Wheels'!", source, 0, 0, 0, true)
        end
    elseif theObject == "Avatar" then
        if not (getAccountData(theAccount, "boughtAvatar")) then
            if not (tonumber(level) >= minLevelAvatar) then outputChatBox("#FFFFFF|Shop| #ff9900You need level " .. minLevelAvatar .. " to buy a avatar!", source, 0, 0, 0, true) return end
            if not (tonumber(thePlayerCash) >= avatarPrice) then outputChatBox("#FFFFFF|Shop| #ff9900You don't have enough money to buy a avatar!", source, 0, 0, 0, true) return end
            outputChatBox("#FFFFFF|Shop| #ff9900You successfully bought a Avatar. You can change your avatar in the settings (U -> Settings)", source, 0, 0, 0, true)
            addStat(theAccount, "cash", -avatarPrice)
            setAccountData(theAccount, "boughtAvatar", true)
        else
            outputChatBox("#FFFFFF|Shop| #ff9900You allready bought 'Avatar'!", source, 0, 0, 0, true)
        end
    elseif theObject == "Pulsating Headlights" then
        if not (getAccountData(theAccount, "pulsatingheadlights")) then
            if not (tonumber(level) >= minLevelPulsatingHeadlights) then outputChatBox("#FFFFFF|Shop| #ff9900You need level " .. minLevelPulsatingHeadlights .. " to buy pulsating headlights!", source, 0, 0, 0, true) return end
            if not (tonumber(thePlayerCash) >= pulsatingHeadlightsPrice) then outputChatBox("#FFFFFF|Shop| #ff9900You don't have enough money to buy pulsating headlights!", source, 0, 0, 0, true) return end
            outputChatBox("#FFFFFF|Shop| #ff9900You successfully bought a pulsating headlights", source, 0, 0, 0, true)
            addStat(theAccount, "cash", -pulsatingHeadlightsPrice)
            setAccountData(theAccount, "pulsatingheadlights", true)
        else
            outputChatBox("#FFFFFF|Shop| #ff9900You allready bought 'pulsating headlights'!", source, 0, 0, 0, true)
        end
    elseif theObject == "Joinmessage" then
        if not (getAccountData(theAccount, "joinmessage")) then
            if not (tonumber(level) >= minLevelJoinmessage) then outputChatBox("#FFFFFF|Shop| #ff9900You need level " .. minLevelJoinmessage .. " to buy a join message!", source, 0, 0, 0, true) return end
            if not (tonumber(thePlayerCash) >= joinmessagePrice) then outputChatBox("#FFFFFF|Shop| #ff9900You don't have enough money to buy join message!", source, 0, 0, 0, true) return end
            outputChatBox("#FFFFFF|Shop| #ff9900You successfully bought a join message", source, 0, 0, 0, true)
            addStat(theAccount, "cash", -joinmessagePrice)
            setAccountData(theAccount, "joinmessage", true)
        else
            outputChatBox("#FFFFFF|Shop| #ff9900You allready bought 'joinmessage'!", source, 0, 0, 0, true)
        end
    elseif theObject == "Ghost" then
        if not isMapType("DD") then outputChatBox("#FFFFFF|Shop| #ff9900You can only buy ghost mode on DD maps!", source, 0, 0, 0, true) return end
        if not (tonumber(level) >= minLevelGhostmode) then outputChatBox("#FFFFFF|Shop| #ff9900You need level " .. minLevelGhostmode .. " to buy ghost-mode!", source, 0, 0, 0, true) return end
        if not (tonumber(thePlayerCash) >= ghostPrice) then outputChatBox("#FFFFFF|Shop| #ff9900You don't have enough money to buy ghost-mode!", source, 0, 0, 0, true) return end
        if not (call(getResourceFromName("race"), "getTimePassed") > 0) then outputChatBox("#FFFFFF|Shop| #ff9900You can only buy ghost mode, until the map is started!", source, 0, 0, 0, true) return end
        if getElementData(source, "invisible") then outputChatBox("#FFFFFF|Shop| #ff9900You allready invisible!", source, 0, 0, 0, true) return end
        if getElementModel(getPedOccupiedVehicle(source)) == 425 then outputChatBox("#FFFFFF|Shop| #ff9900You can't buy ghost mode if your vehicle is a hunter!", source, 0, 0, 0, true) return end

        addStat(theAccount, "cash", -ghostPrice)
        startBuyGhost(source)
    elseif theObject == "Repair" then
        if not isMapType("DM") then outputChatBox("#FFFFFF|Shop| #ff9900You can only buy vehicle fix on DM maps!", source, 0, 0, 0, true) return end

        if not (tonumber(level) >= minLevelFix) then outputChatBox("#FFFFFF|Shop| #ff9900You need level " .. minLevelFix .. " to fix your vehicle!", source, 0, 0, 0, true) return end
        if not (tonumber(thePlayerCash) >= fixPrice) then outputChatBox("#FFFFFF|Shop| #ff9900You don't have enough money to fix your vehicle!", source, 0, 0, 0, true) return end
        if isPedInVehicle(source) then
            fixVehicle(getPedOccupiedVehicle(source))
            outputChatBox("#FFFFFF|Shop| #ff9900Your vehicle was successfully fixed", client, 0, 0, 0, true)
            outputServerLog("[Shop| " .. removeColorCodes(getPlayerName(source)) .. " bought vehicle: fix")
            addStat(theAccount, "cash", -fixPrice)
        else
            outputChatBox("#FFFFFF|Shop| #ff9900You are not in a vehicle!", client, 0, 0, 0, true)
        end
    elseif theObject == "Flip" then
        if not isMapType("DM") then outputChatBox("|Shop| #ff9900You can only buy vehicle flip on DM maps!", client, 255, 255, 255, true) return end

        if not (tonumber(level) >= minLevelFlip) then outputChatBox("#FFFFFF|Shop| #ff9900You need level " .. minLevelFix .. " to flip your vehicle!", client, 0, 0, 0, true) return end
        if not (tonumber(thePlayerCash) >= flipPrice) then outputChatBox("#FFFFFF|Shop| #ff9900You don't have enough money to flip your vehicle!", client, 0, 0, 0, true) return end
        if isPedInVehicle(source) then
            local _, ry, rz = getElementRotation(getPedOccupiedVehicle(client))
            setVehicleRotation(getPedOccupiedVehicle(client, 0, tonumber(ry), tonumber(rz)))
            outputChatBox("|Shop| #ff9900Your vehicle was successfully flipped", source, 255, 255, 255, true)
            outputServerLog("[Shop| " .. removeColorCodes(getPlayerName(client)) .. " bought vehicle: flip")
            addStat(theAccount, "cash", -flipPrice)
        else
            outputChatBox("|Shop| #ff9900You are not in a vehicle!", client, 255, 255, 255, true)
        end
    elseif theObject == "Special Music" then
        --if not isMapType("DM") then outputChatBox("|Shop| #ff9900You can only play a special music on non DM maps!", client, 255, 255, 255, true) return end
        if not (tonumber(thePlayerCash) >= BoomBoomSongPrice) then outputChatBox("|Shop| #ff9900You don't have enough money!!", client, 255, 255, 255, true) return end
        if isMusicPlaying then outputChatBox("|Shop| #ff9900The song can be bought only every 5 minutes!", client, 255, 255, 255, true) return end
        isMusicPlaying = true
        local rndSongURL = getRandomSongURL()
        addStat(theAccount, "cash", -BoomBoomSongPrice)
        triggerClientEvent("onPlayerPlaySpecialMusic", root, rndSongURL)
        triggerClientEvent("addClientMessage", root, ("|Music| #ff9900%s started a special music :>"):format(getPlayerName(client)) , 255, 255, 255)
        setTimer(function()
            isMusicPlaying = false
        end, 300000, 1)
    end
end
addEvent("getSelectedBuyPerPanel", true)
addEventHandler("getSelectedBuyPerPanel", root, buyPerPanel)

function getRandomSongURL()
    local tbl = getMusicList("specialMusic")
    local rnd = tbl[math.random(1,#tbl)]
    return rnd
end