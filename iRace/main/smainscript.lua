----------------Colors:
--Projektleiter: RGB: 255, 0, 0 | Hex: #FF0000
--Admin: RBG: 255, 60, 0 |Hex: #FF3C00
--Moderator: 255, 100, 0 | Hex: #FF6400
--Member: 0, 100, 255 | Hex: #0064FF

--------Data Tables---------
local m = 1
local rankTable =  {
    [1] = {"Newbie",10},
    [2] = {"Beginner",25},
    [3] = {"Biker",50},
    [4] = {"Scooterist",100},
    [5] = {"Pogo",200},
    [6] = {"Noob Racer",400},
    [7] = {"Horrible Drifter",600},
    [8] = {"Failer",800},
    [9] = {"Poser",1000},
    [10] = {"Godlike Survivor",1250},
    [11] = {"Crusher",1500},
    [12] = {"Car Racer",2000},
    [13] = {"Angelo Merte",2500},
    [14] = {"Drifter",3000},
    [15] = {"Small Geek",4000},
    [16] = {"Tournament Biker",5000},
    [17] = {"Toptime King",6000},
    [18] = {"Skilled Racer",8000},
    [19] = {"Freaking Racer",10000},
    [20] = {"Rich-ass Racer",12500},
    [21] = {"International Biker", 15000},
    [22] = {"Championship Racer", 17500},
    [23] = {"Sponsored Pro", 20000},
    [24] = {"Professional Biker", 25000},
    [25] = {"Stunting Expert", 30000},
    [26] = {"Famous Movie Stuntman", 35000},
    [27] = {"Winner of Race-Championships", 40000},
    [28] = {"Allstar",50000},
    [29] = {"Champion",60000},
    [30] = {"Expert of Motorsport",75000},
    [31] = {"Legendary Star",100000},
    [32] = {"Living Legend of iRace",150000},
}

local achiveTable =  {
    ["Fucking Noob"] = {"achive1"},
    ["Noob Racer"] = {"achive2"},
    ["COLOR FTW"] = {"achive3"},
    ["REEEEED MAN"] = {"achive4"},
    ["Millionaire"] = {"achive5"},
    ["Get a Million"] = {"achive6"},
    ["Get Started"] = {"achive7"},
    ["TOP HUNTER"] = {"achive8"},
    ["Pro Racer"] = {"achive9"},
    ["I like Rainbows"] = {"achive10"},
    ["Can u own me ?"] = {"achive11"},
    ["Legend"] = {"achive12"},
    ["Rich man"] = {"achive13"},
    ["Speeder"] = {"achive14"},
    ["Swimming Prof"] = {"achive15"},
    ["Like meh."] = {"achive18"},
    ["Famous rich man"] = {"achive19"},
}

local dataTable = {
    "cash",
    "cashearned",
    "cashspent",
    "deaths",
    "toptimes12",
    "distancetravelled",
    "racesplayed",
    "ddsplayed",
    "ddswon",
    "dmsplayed",
    "dmswon",
    "shootersplayed",
    "shooterswon",
    "huntersplayed",
    "hunterswon",
    "lastseen",
    "playtime",
    "level",
    "points",
    "jointimes",
    "mapsfinished",
    "funareakills",
}

local elementDataTable = {
    "JoinText",
    "chatcolor",
    "boughtWheels",
    "WinText",
    "vcolorr",
    "vcolorg",
    "vcolorb",
    "playerstatus",
    "rainbowcolor",
    "avatar",
    "achive1",
    "achive2",
    "achive3",
    "achive4",
    "achive5",
    "achive6",
    "achive7",
    "achive8",
    "achive9",
    "achive10",
    "achive11",
    "achive12",
    "achive13",
    "achive14",
    "achive15",
    "achive18",
    "achive19",
    "pulsatingheadlightsON",
    "mapsfinished",
    "funareakills",
    "antiBounce",
    "rainbowcolorstate"}

local textDataTable = {
    "ranktitle",
}
--------Data Tables---------


local oldplaytime = {}
g_ruhe = false --Darf kein local sein!!
g_racestate = "" --Darf kein local sein!!

--general--
local accountS
--end general--

--Maps buy----
local MapBuylevel = 10
local MapBuyPrice = 5000
local ddMapTimer
local shooterMapTimer
-----------------

--utility--
local minPlayers = 3
local playerTable = {}
activePlayers = {}
mapBuyEnabled = true
g_muteTimers = {}

local ghostDuration = 120000
local countdownUsed = false
--------------------------------------------------------------------------------------------------------------------------------------------

local targetError = "* Sorry, but your target is not logged in!"
local registerError = "* Sorry, but you have to register to use this function!"
local scriptcol = {{255,178,0,true},{255,0,0,true},{255,255,255,true}}
beta = false
version = "1.1.0.4"
--end utility--

--[[*************************************************
*        Part I: general, start etc.                *
*****************************************************]]

addEventHandler("onResourceStart", resroot, function()
    outputChatBox ("* #ffffffiRace system started!", root, 0, 255, 0, true)
    outputChatBox ("* #ffffffVersion "..version, root, 0, 255, 0, true)
end)


addEvent("onRaceStateChanging")
addEventHandler("onRaceStateChanging", root, function(ns, os)
    g_racestate = ns
    triggerClientEvent("onClientRaceStateChanging", resroot, ns, os)
    outputDebugString(("Race state: %s"):format(ns))
    if ns == "Running" then
        activePlayers = {}
        for _, player in ipairs(getElementsByType"player") do
            if getElementData(player, "isLogedIn") then
                if not getElementData(player, "AFK") then table.insert(activePlayers, player) end
            else
                setElementHealth(player, 0)
            end
        end
        --TODO: ADD BETA
        --outputChatBox("AcitvePlayers: " .. #activePlayers)
    end
end)

--add some stat number
function addStat(account, data, val)
    if (tostring(data)) and (tonumber(val)) then
        local theData = getAccountData(account, data)
        local player = getAccountPlayer(account)
        if (theData) then
            if (data == "points") then
                checkForRankUp(account, tonumber(getAccountData(account, "points")), tonumber(getAccountData(account, "points")) + tonumber(val))
            elseif (data == "cash") then
                if (val > 0) then
                    addStat(account, "cashearned", val)
                elseif (val < 0) then
                    addStat(account, "cashspent", -val)
                end
            end
            setAccountData(account, data, math.floor(tonumber(theData) + tonumber(val)))
        else
            outputDebugString("Bad argument at function addStat (Could not get theData) in LTstats\core_server.lua", 1, 255, 0, 0)
        end
    else
        outputDebugString("Bad argument at function addStat in LTstats\core_server.lua", 1, 255, 0, 0)
    end
end


function setMultiplier(value)
    m = value
end

--LevelSystem
function buyNextLevel()
    if not (isGuestAccount(getPlayerAccount(client))) then
        local account = getPlayerAccount(client)
        local cash = tonumber(getAccountData(account,"cash"))
        local level = tonumber(getAccountData(account, "level"))
        local x = 1200
        local cashforlevel = level*1.2*x
        local cashfornextlevel = (level+1)*1.2*x
        --local cashforlevelsucces = tonumber(tonumber(tonumber(tonumber(level+1)*1.2))*x)
        if level then
            if cash >= cashforlevel then
                --outputChatBox(("|Userpanel| %s #FF9900has bought level #ffffff%s #ff9900for #ffffff%s#ff9900!"):format(getPlayerName(client), level+1, cashforlevel), root, 255, 255, 255, true)
                addStat(account, "level", 1)
                addStat(account, "cash", -cashforlevel)
                triggerClientEvent(client, "setPanelObjects", client, cashfornextlevel, level+1)
                triggerClientEvent("addClientMessage", root, ("|Userpanel| %s #FF9900has bought level #ffffff%s #ff9900for #ffffff%s#ff9900!"):format(getPlayerName(client), level+1, cashforlevel), 255,255,255)
            else
                outputChatBox(("|Userpanel| #FF9900You need #ffffff%s#ff9900$ more to buy next level!"):format(cashforlevel-cash), client, 255, 255, 255, true)
            end
        else
            setAccountData(account,	"level", 0)
        end
    end
end
addEvent("buyNextLevelPerPanel",true)
addEventHandler( "buyNextLevelPerPanel", resroot, buyNextLevel )

function sendMemoandButtonDatasToClient()
    if isPlayerInAdminGroup(source) then
        local adminLevel, adminColor = getPlayerAdminGroupColor(source)
        triggerClientEvent("addClientMessage", root, ("|%s%s#ffffff| %s #fffffflogged in!"):format(adminColor, adminLevel, getPlayerName(source)), 255,255,255)
    end

    local account = getPlayerAccount(source)
    local level = getAccountData(account, "level")
    local name = getAccountName(account)

    if g_muteTimers[name] then
        if isTimer(g_muteTimers[name]) then
            setPlayerMuted(source, true)
        else
            setPlayerMuted(source, false)
        end
    end
    if level then
        local cashforlevel = tonumber(tonumber(level*1.2)*1200)
        triggerClientEvent("setPanelObjects",source,cashforlevel,level)
    end
    if getAccountData(account, "serialchecked") then

    else
        setAccountData(account, "serial", getPlayerSerial(source))
        setAccountData(account, "ip", getPlayerIP(source))
        setAccountData(account, "serialchecked", true)
    end
end
addEventHandler( "onPlayerLogin", root, sendMemoandButtonDatasToClient )

--function for floats
function round(value,dec)
    if value then
        local decimals = dec or 2
        return tonumber(string.format("%.0"..tostring(decimals).."f",math.floor(((value)*10^decimals)+0.5)/(10^decimals)))
    end
    return false
end

--calc points and cash
function calcPoints(rank)
    local x = #activePlayers - rank
    if (x >= 0) then
        --nothing
    else
        x = 0
    end
    return round((0.07*x^2+x))
end

--calc Hunterpoints
function calcPointsHunter(rank)
    local account = getPlayerAccount(source)
    local x = getAccountData(account, "level")
    if (x >= 0) then
        --nothing
    else
        x = 0
    end
    return round((4.21*x))
end

local calcLimit = 40

function calcCash(rank,player)
    local level = getAccountData(getPlayerAccount(player),"level")
    if level then
        local aP = #activePlayers
        if aP > 40 then aP = 40 end

        local x = aP - rank
        if x < 0 then x = 0 end

        local summe = math.floor((0.4*x^2+x)*9*m)
        local summe2 = tonumber((level)/100+1)
        local summeWithLevel = math.floor((summe*summe2)-summe)
        return summe, summeWithLevel
    end
end

--calc ratio
function calcRatio(val1, val2)
    if (val1) and (val2) then
        local val1= tonumber(val1)
        local val2 = tonumber(val2)
        if (val1) and (val2) then
            if not (val1 == 0) and not (val2 == 0) then
                if (val1 >= val2) then
                    return 100
                end
                local ratio = round(((val1/val2)*100))
                return ratio
            else
                return 0
            end
        else
            return false
        end
    else
        return false
    end
end

--RGBtoHEX
function RGBToHex(red, green, blue, alpha)
    if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
        return nil
    end
    if(alpha) then
        return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
    else
        return string.format("#%.2X%.2X%.2X", red,green,blue)
    end
end

--alive players
function getRaceAlivePlayers()
    local result = {}
    for i,v in ipairs(getElementsByType("player")) do
        if getElementData(v,"state") == "alive" then
            table.insert(result,v)
        end
    end
    return result
end

--format time
function formatTime()
    local thetime = getRealTime()
    local year = tostring(thetime.year+1900)
    local month = thetime.month+1 >= 10 and tostring(thetime.month+1) or "0"..tostring(thetime.month+1)
    local day = thetime.monthday >= 10 and tostring(thetime.monthday) or "0"..tostring(thetime.monthday)
    local hour = thetime.hour >= 10 and tostring(thetime.hour) or "0"..tostring(thetime.hour)
    local minute = thetime.minute >= 10 and tostring(thetime.minute) or "0"..tostring(thetime.minute)
    local second = thetime.second >= 10 and tostring(thetime.second) or "0"..tostring(thetime.second)

    return ("%s.%s.%s %s:%s"):format(day, month, year, hour, minute)
end

function isMemberOnline()
    for i, thePlayer in ipairs(getElementsByType("player")) do
        if isPlayerInAdminGroup(thePlayer) then
            return true
        end
    end
    return false
end

function elementDataChangeIfAccountDataChange(account, key, value)
    local player = getAccountPlayer (account)
    if player then
        setElementData(player,key, value)
        if key == "cash" then
            checkAchivementState(player)
        end
    end
end
addEventHandler("onAccountDataChange", getRootElement(), elementDataChangeIfAccountDataChange)

--check for Achivements
function checkAchivementState(player)
    --basic
    local account = getPlayerAccount(player)
    local cash = tonumber(getAccountData(account,"cash"))
    local level = tonumber(getAccountData(account,"level"))
    local toptimes = tonumber(getAccountData(account,"toptimes12"))
    local deaths = tonumber(getAccountData(account,"deaths"))
    local cashearned = tonumber(getAccountData(account,"cashearned"))
    local cashspent = tonumber(getAccountData(account,"cashspent"))
    local ddsplayed = tonumber(getAccountData(account,"ddsplayed"))
    local ddswon = tonumber(getAccountData(account,"ddswon"))
    local dmsplayed = tonumber(getAccountData(account,"dmsplayed"))
    local dmswon = tonumber(getAccountData(account,"dmswon"))
    local rainbowcolor = getAccountData(account,"rainbowcolor")
    local playtime = tonumber(getAccountData(account,"playtime"))
    local jointimes = tonumber(getAccountData(account,"jointimes"))
    local JoinmessageBought = getAccountData(account,"joinmessage")
    local wheelsBought = getAccountData(account,"boughtWheels")
    local wintextBought = getAccountData(account,"onBuyWinText")
    local customcolor = getAccountData(account, "customcolor")
    local rColor,bColor,bColor = tonumber(getAccountData(account, "vcolorr")), tonumber(getAccountData(account, "vcolorg")), tonumber(getAccountData(account, "vcolorb"))
    local topspeed = tonumber(getAccountData(account,"topspeed")) or 0
    --Fucking Noob | achive1
    if not getAccountData(account,"achive1") then
        if deaths ~= nil and deaths >= 200 then -- QUESTION
            setAccountData(account,"achive1",true)
            outputChatBox("|Userpanel|"..getPlayerName(player).." #FF9900unlocked achievement #FFFFFFFucking Noob!",getRootElement(),255,255,255,true)
        end
    end
    --Noob Racer | achive2
    if not getAccountData(account,"achive2") then
        if tonumber(dmswon) >= 1  then -- QUESTION
            setAccountData(account,"achive2",true)
            outputChatBox("|Userpanel|"..getPlayerName(player).." #FF9900unlocked achievement #FFFFFFNoob Racer!",getRootElement(),255,255,255,true)
        end
    end
    --Color FTW | achive3
    if not getAccountData(account,"achive3") then
        if customcolor == true then
            --if isUserInACLGroup(player, "customcolor") then
            setAccountData(account,"achive3",true)
            outputChatBox("|Userpanel|"..getPlayerName(player).." #FF9900unlocked achievement #FFFFFFCOLOR FTW!",getRootElement(),255,255,255,true)
        end
    end
    --Reeeeed Man | achive4
    if not getAccountData(account,"achive4") then
        if rColor == 255 and bColor == 0 and bColor == 0 then  -- QUESTION
            setAccountData(account,"achive4",true)
            outputChatBox("|Userpanel|"..getPlayerName(player).." #FF9900unlocked achievement #FFFFFFReeeeed Man!",getRootElement(),255,255,255,true)
        end
    end
    --Millionaire | achive5
    if not getAccountData(account,"achive5") then
        if cash >= 1000000 then  -- QUESTION
            setAccountData(account,"achive5",true)
            outputChatBox("|Userpanel|"..getPlayerName(player).." #FF9900unlocked achievement #FFFFFFMillionaire!",getRootElement(),255,255,255,true)
        end
    end
    --Get a Million | achive6
    if not getAccountData(account,"achive6") then
        if cash >= 500000 then  -- QUESTION
            setAccountData(account,"achive6",true)
            outputChatBox("|Userpanel|"..getPlayerName(player).." #FF9900unlocked achievement #FFFFFFGet a Million!",getRootElement(),255,255,255,true)
        end
    end
    --Get Started | achive7
    if not getAccountData(account,"achive7") then
        setAccountData(account,"achive7",true)
        outputChatBox("|Userpanel|"..getPlayerName(player).." #FF9900unlocked achievement #FFFFFFGet Started!",getRootElement(),255,255,255,true)
    end
    --TOP HUNTER | achive8
    if not getAccountData(account,"achive8") then
        if tonumber(dmswon) >= 750 then  -- QUESTION
            setAccountData(account,"achive8",true)
            outputChatBox("|Userpanel|"..getPlayerName(player).." #FF9900unlocked achievement #FFFFFFTOP HUNTER!",getRootElement(),255,255,255,true)
        end
    end
    --Pro Racer | achive9
    if not getAccountData(account,"achive9") then
        if tonumber(dmswon) >= 100 and level >= 10 then  -- QUESTION
            setAccountData(account,"achive9",true)
            outputChatBox("|Userpanel|"..getPlayerName(player).." #FF9900unlocked achievement #FFFFFFPro Racer!",getRootElement(),255,255,255,true)
        end
    end
    --I like Rainbows | achive10
    if not getAccountData(account,"achive10") then
        if rainbowcolor then  -- QUESTION
            setAccountData(account,"achive10",true)
            outputChatBox("|Userpanel|"..getPlayerName(player).." #FF9900unlocked achievement #FFFFFFI like Rainbows!",getRootElement(),255,255,255,true)
        end
    end
    --Can u own me ? | achive11
    if not getAccountData(account,"achive11") then
        if dmsplayed >= 5555 then  -- QUESTION
            setAccountData(account,"achive11",true)
            outputChatBox("|Userpanel|"..getPlayerName(player).." #FF9900unlocked achievement #FFFFFFCan u own me ?!",getRootElement(),255,255,255,true)
        end
    end
    --Legend | achive12
    if not getAccountData(account,"achive12") then
        if playtime >= 17500 then  -- QUESTION
            setAccountData(account,"achive12",true)
            outputChatBox("|Userpanel|"..getPlayerName(player).." #FF9900unlocked achievement #FFFFFFLegend!",getRootElement(),255,255,255,true)
        end
    end
    --Rich man | achive13
    if not getAccountData(account,"achive13") then
        if cashspent >= 500000 then  -- QUESTION
            setAccountData(account,"achive13",true)
            outputChatBox("|Userpanel|"..getPlayerName(player).." #FF9900unlocked achievement #FFFFFFRich man!",getRootElement(),255,255,255,true)
        end
    end
    --Speeder | achive14
    if not getAccountData(account,"achive14") then
        if topspeed >= 650 then  -- QUESTION
            setAccountData(account,"achive14",true)
            outputChatBox("|Userpanel|"..getPlayerName(player).." #FF9900unlocked achievement #FFFFFFSpeeder!",getRootElement(),255,255,255,true)
        end
    end
    --Swimming Prof | achive15
    if not getAccountData(account,"achive15") then
        if deaths >= 1000 then  -- QUESTION
            setAccountData(account,"achive15",true)
            outputChatBox("|Userpanel|"..getPlayerName(player).." #FF9900unlocked achievement #FFFFFFSwimming Prof!",getRootElement(),255,255,255,true)
        end
    end
    --Like meh. | achive18
    if not getAccountData(account,"achive18") then
        if toptimes >= 20 then  -- QUESTION
            setAccountData(account,"achive18",true)
            outputChatBox("|Userpanel|"..getPlayerName(player).." #FF9900unlocked achievement #FFFFFFLike meh.!",getRootElement(),255,255,255,true)
        end
    end
    --Famous rich man | achive19
    if not getAccountData(account,"achive19") then
        if cashearned >= 1000000 then  -- QUESTION
            setAccountData(account,"achive19",true)
            outputChatBox("|Userpanel|"..getPlayerName(player).." #FF9900unlocked achievement #FFFFFFFamous rich man!",getRootElement(),255,255,255,true)
        end
    end
end

--[[*************************************************
*        Part III: Player Stats                      *
*****************************************************]]

--create data tables for new player
--very important
--set lastPlayerName and set all data key values from a player to '0' because getAccountData returns 'false' if there is no data given to the key
function createNewTables()
    local account = getPlayerAccount(source)
    if not (isGuestAccount(account)) then
        for i, data in ipairs(dataTable) do
            if not (getAccountData(account, data)) then
                setAccountData(account, data, "0")
                --outputDebugString("Setting data: "..tostring(data).." for player: "..tostring(getPlayerName(source)).." to 0")
                setElementData(source,data,"0")
            else
                local theDATA = getAccountData(account,data)
                setElementData(source,data,theDATA)
                --outputDebugString("Setting ElementData: "..tostring(data).." for player: "..tostring(getPlayerName(source)).." to "..theDATA)
            end
        end
        for i, data in ipairs(elementDataTable) do
            if (getAccountData(account, data)) then
                local theDATA = getAccountData(account,data)
                setElementData(source,data,theDATA)
                --outputDebugString("Setting ElementData: "..tostring(data).." for player: "..tostring(getPlayerName(source)).." to "..tostring(theDATA))
            end
        end
        addStat(account,"jointimes",1)
        setElementData(source,"isLogedIn",true)
    end
    checkAchivementState(source)
    --bindKey(source, "f3", "down", RenderRadarObjects)
end
addEventHandler("onPlayerLogin", root, createNewTables)

addEventHandler("onPlayerLogout", root, function()
    if getElementData(source,"isLogedIn") == true then	setElementData(source,"isLogedIn",false) end
end)

function onPlayerWin()
    if isElement(playerblip[source]) then
        destroyElement(playerblip[source])
    end

    if hasUserPermissionTo(source, "adminSound") then
        triggerClientEvent("onAdminWin", getRootElement(), getAccountName(getPlayerAccount(source)))
    end

    if #activePlayers >= minPlayers then
        local account = getPlayerAccount(source)
        if not (isGuestAccount(account)) then
            local cash, levelCash = calcCash(1,source)
			triggerClientEvent("addClientMessage", root, ("|Win| %s #4ADE00won as final survivor #ffffff%s#4ADE00$"):format(getPlayerName(source), cash + levelCash), 255, 255, 255)
			--triggerClientEvent("addClientMessage", root, "|Win| " .. getPlayerName(source).. " #4ADE00won as the final survivor and earned #ffffff" .. tostring(cash) .. "#4ADE00$! Level bonus: #ffffff" .. tostring(levelCash) .. "#4ADE00$",255,255,255)

            if isMapType("DD") then addStat(account,"ddsplayed",1) addStat(account,"ddswon",1)
            elseif isMapType("DM") then addStat(account,"dmsplayed",1) addStat(account,"dmswon",1)
			elseif isMapType("SHOOTER") then addStat(account, "shootersplayed", 1) addStat(account, "shooterswon", 1)
			elseif isMapType("HUNTER") then addStat(account, "huntersplayed", 1) addStat(account, "hunterswon", 1)
            end

            addStat(account,"cash",cash + levelCash)
        end

        for theKey,thePlayer in ipairs(activePlayers) do
            local hasbet = getElementData(thePlayer, "hasbet")

            if hasbet then
                local beton = getElementData (thePlayer,"beton")
                local betcash = getElementData (thePlayer,"betmoney")

                if source == beton then
                    local account = getPlayerAccount(thePlayer)
                    local cashToWin = math.floor(betcash * 2.5) --/ 2 * (#activePlayers*0.22)
                    addStat(account,"cash", cashToWin)
                    triggerClientEvent("addClientMessage", root, ("|Bets| %s#00ccff earned #ffffff%s#00ccff$ for his bet!"):format(getPlayerName(thePlayer), cashToWin), 255, 255, 255)
                    --outputChatBox("|Bets| "..getPlayerName(thePlayer).."#00ccff earned " ..tostring(cashToWin).. "$ for his bet!", root, 255, 255, 255)
                end
            end

        end
    end
end
addEvent("onPlayerDestructionDerbyWin")
addEventHandler("onPlayerDestructionDerbyWin",getRootElement(), onPlayerWin)

function playerWasted(ammo,attacker)
    if #activePlayers >= minPlayers then
        if isPlayerRespawnMode(source) then
            if(state == "true")then
                if attacker then
                    local player = getVehicleController(attacker)
                    local account = getPlayerAccount(attacker)
                    if not (isGuestAccount(account)) then
                        addStat(account,"funareakills",1)
                    end
                end
                return
            end
        end

        local account = getPlayerAccount(source)
        if not (isGuestAccount(account)) then
            addStat(account,"deaths",1)
        end
    end
end
addEventHandler("onPlayerWasted",getRootElement(),playerWasted)

function playerQuit()
    local account = getPlayerAccount(source)
    if not (isGuestAccount(account)) then
        local thestring = formatTime()
        setAccountData(account, "lastseen", thestring)
        setAccountData(account, "lastPlayerName", getPlayerName(source))
    end
end
addEventHandler("onPlayerQuit",getRootElement(),playerQuit)

addEventHandler("onResourceStop", resroot, function()
    for _, source in ipairs(getElementsByType("player")) do
        local account = getPlayerAccount(source)
        if not (isGuestAccount(account)) then
            local thestring = formatTime()
            setAccountData(account, "lastseen", thestring)
            setAccountData(account, "lastPlayerName", getPlayerName(source))
        end
    end
end)

--[[*************************************************
*        Part IV: checking functions                 *
*****************************************************]]
function updatePlayTime()
    for i, v in ipairs(getElementsByType("player")) do
        if not getElementData(v, "AFK") then
            local account = getPlayerAccount(v)
            if not isGuestAccount(account) then
                local playtime = getAccountData(account,"playtime")
                addStat(account,"playtime",1)

                if oldplaytime[account] then
                    if math.floor(getAccountData(account, "playtime")/60) > oldplaytime[account] then
                        local level = getAccountData(account, "level")
                        local paydayCash = (gtst.getTeamBoni(getAccountName(account), v)*level*m)+1000
                        triggerClientEvent(v, "payDaySound", v)
                        triggerClientEvent(v, "addClientMessage", v, ("|Payday| #ff6600You get #ffffff%s #ff6600$ for complete a full hour!"):format(paydayCash), 255, 255, 255)
                        addStat(account, "cash", paydayCash)
                    end
                end
                if getAccountData(account, "playtime") then oldplaytime[account] = math.floor(getAccountData(account, "playtime")/60) end
            end
        end
    end
end
setTimer(updatePlayTime, 60000, 0)



--[[*************************************************
*        Part IV: race triggers                      *
*****************************************************]]
local deadRacePlayer = {}
function isRacePlayerDead(tp)
    for i, player in ipairs(deadRacePlayer) do
        if player == tp then return true end
    end
    return false
end

addEventHandler("onPlayerWasted", root, function()
    if not getElementData(source, "isLogedIn") then return end

    if not isRacePlayerDead(source) then
        table.insert(deadRacePlayer, source)
        racePlayerWasted(source)
        gevt.onPlayerWasted(source)
    end

    if isMapType("DM") then
        setTimer(function(source)
            --triggerClientEvent(source, "showRespawnModes", source, true) --dev!
            if g_racestate == "Running" then
                triggerClientEvent(source, "showRespawnModes", source, true)
                if #getRaceAlivePlayers() >= 1 then triggerClientEvent(source, "showRespawnModes", source, true) end
            end
        end, 3000, 1, source)
    end
end)


function racePlayerWasted(source)
    if #activePlayers >= minPlayers then
        if isMapType("DD") or isMapType("DM") then
            local alivePlayers = getRaceAlivePlayers()
            local account = getPlayerAccount(source)
            if #alivePlayers == 1 then
                if not (isGuestAccount(account)) then
                    if not getElementData(source, "AFK") then
                        local cash, levelCash = calcCash(2,source)
                        triggerClientEvent("addClientMessage", source, "|Stats| #4ADE00You earned #ffffff" .. tostring(cash) .. "#4ADE00$ for rank #ffffff2#4ADE00! Level bonus: #ffffff" .. tostring(levelCash), 255, 255, 255)

						if isMapType("DD") then addStat(account,"ddsplayed",1)
						elseif isMapType("DM") then addStat(account,"dmsplayed",1)
						elseif isMapType("SHOOTER") then addStat(account, "shootersplayed", 1)
						elseif isMapType("HUNTER") then addStat(account, "huntersplayed", 1)
						end
						
                        addStat(account,"cash",cash + levelCash)
                    end
                end
            elseif #alivePlayers <= 1 then
                --nothing
            else
                if not (isGuestAccount(account)) then
                    if not getElementData(source, "AFK") then
                        local rank = #alivePlayers + 1
                        local cash, levelCash = calcCash(rank,source)
                        triggerClientEvent("addClientMessage", source, "|Stats| #4ADE00You earned #ffffff" .. tostring(cash) .. "#4ADE00$ for rank #ffffff" .. rank .. "#4ADE00! Level bonus: #ffffff" .. tostring(levelCash), 255, 255, 255)

 						if isMapType("DD") then addStat(account,"ddsplayed",1)
						elseif isMapType("DM") then addStat(account,"dmsplayed",1)
						elseif isMapType("SHOOTER") then addStat(account, "shootersplayed", 1)
						elseif isMapType("HUNTER") then addStat(account, "huntersplayed", 1)
						end
						
                        addStat(account,"cash",cash + levelCash)
                    end
                end
            end
            outputDebugString(removeColorCodes(getPlayerName(source)) .. " died, rank #" .. #alivePlayers + 1)
        end
    end
end

function racePlayerQuit()
    if #activePlayers >= minPlayers then
        if mapType == "Destruction derby" or mapType == "Deathmatch" then
            --if mapState == "Running" then
            if getElementData(source,"state") == "alive" then
                local alivePlayers = getRaceAlivePlayers()
                local account = getPlayerAccount(source)
                if #alivePlayers == 2 then
                    if not (isGuestAccount(account)) then
                        local cash, levelCash = calcCash(2,source)
						
						if isMapType("DD") then addStat(account,"ddsplayed",1)
						elseif isMapType("DM") then addStat(account,"dmsplayed",1)
						elseif isMapType("SHOOTER") then addStat(account, "shootersplayed", 1)
						elseif isMapType("HUNTER") then addStat(account, "huntersplayed", 1)
						end
						
                        addStat(account,"ddsplayed",1)
                        addStat(account,"cash",cash + levelCash)
                    end
                elseif #alivePlayers <= 2 then
                    --nothing
                else
                    if not (isGuestAccount(account)) then
                        local rank = #alivePlayers + 1
                        local cash, levelCash = calcCash(rank,source)
						
						if isMapType("DD") then addStat(account,"ddsplayed",1)
						elseif isMapType("DM") then addStat(account,"dmsplayed",1)
						elseif isMapType("SHOOTER") then addStat(account, "shootersplayed", 1)
						elseif isMapType("HUNTER") then addStat(account, "huntersplayed", 1)
						end
				
                        addStat(account,"cash",cash + levelCash)
                    end
                end
                outputDebugString(getPlayerName(source).." quit, rank #"..#alivePlayers)
            end
            --end
        end
    end
end
addEventHandler("onPlayerQuit",getRootElement(),racePlayerQuit)

addEvent("onPlayerToptimeImprovement",true)
addEventHandler("onPlayerToptimeImprovement",getRootElement(),
    function (newPos, newTime, oldPos, oldTime, displayTopCount, validEntryCount)
        local account = getPlayerAccount(source)
        if newPos < displayTopCount then
            if newPos == 1 then
                triggerClientEvent("addClientMessage", getRootElement(), getPlayerName(source) .. "#ff0000 has gotten top time 1!", 255, 255, 255, "toptime")
                addStat(account, "toptimes12", 1)
                addStat(account, "cash", 2000)
            elseif newPos < oldPos and newTime < oldTime then
                triggerClientEvent("addClientMessage", getRootElement(), getPlayerName(source) .. "#ff5500 improved his top time [" .. newPos .. "]", 255, 255, 255, "toptime")
            else
                triggerClientEvent("addClientMessage", getRootElement(), getPlayerName(source) .. "#ff5500 has gotten a top time [" .. newPos .. "]", 255, 255, 255, "toptime")
            end
        elseif not oldTime or not oldPos then
            triggerClientEvent("addClientMessage", root, getPlayerName(source) .. "#aaff00 has gotten a new hunter time [" .. newPos .. "]", 255, 255, 255, "toptime")
        elseif newPos < oldPos and newTime < oldTime then
            triggerClientEvent("addClientMessage", getRootElement(), getPlayerName(source) .. "#aaff00 improved his hunter timer [" .. newPos .. "]", 255, 255, 255, "toptime")
        end
    end)




playerWithHunters = {}
local lmsRepaid = false
addEvent('onPlayerPickUpRacePickup')
addEventHandler('onPlayerPickUpRacePickup', getRootElement(),
	function(number, sort, model)
		if sort == "vehiclechange" then
			local theVehicle = getPedOccupiedVehicle(source)
			if isAircraft(theVehicle) then
				triggerClientEvent(source, "onClientDrawAltitude", source)
			end

			if model == 425 then
				if not playerWithHunters[source] then
					playerWithHunters[source] = true

					local account = getPlayerAccount(source)
					triggerClientEvent("addClientMessage", root, ("|Hunter| %s #ff9900has reached the hunter!"):format(getPlayerName(source)), 255, 255, 255)
					--outputChatBox ("|Hunter| "..getPlayerName(source).." #ff9900has reached the hunter!", getRootElement(), 255, 255, 255, true )
					if gevt.getEventType() == "DM" then
						triggerClientEvent(source, "|Event| #7788EEYou get #ffffff10.000$#7788EE for reaching the hunter while event!", source, 255, 255, 255)
						--outputChatBox("|Event| #7788EEYou get 10.000$ for reaching the Hunter while DM-Event!", source, 255, 255, 255, true)
						addStat(account, "cash", 10000)
					end

					if not getElementData(source, "AFK") then addStat(account, "mapsfinished", 1) end

					local hunterreached = getResourceInfo (exports.mapmanager:getRunningGamemodeMap(),"hunterreached")
					setResourceInfo (exports.mapmanager:getRunningGamemodeMap(),"hunterreached",hunterreached == false and "1" or hunterreached and tostring(hunterreached+1))
					resetSkyGradient()
					setWeather(1)
					setTime(0, 0)

					if #getRaceAlivePlayers() == 1 then
						triggerEvent("startNewMap", getRootElement())
					end
				end
			end
		end
	end
)

--[[*************************************************
*        Part V: Destruction Derby/ Bet functions   *
*****************************************************]]

---------------------------------------
--Bet functions
---------------------------------------
local allowBets = false
local function initialiseFeaturesForNextMap()
    if areBetsallowedAdmin == true then
        if #activePlayers >= minPlayers then
            if isMapType("DM") then
                allowBets = true
                deleteAllCurrentBetsOnMapStart()
                outputChatBox("|Bets| #00ccffBets are opened now!", getRootElement(), 255, 255, 255, true)
                setTimer(function() allowBets = false end, 30000, 1)
                setTimer(outputChatBox, 30000, 1, "|Bets| #00ccffBets are closed now!", getRootElement(), 255, 255, 255, true)
            end
        end
    end
    ----------------------
    lmsRepaid = false
    playerWithHunters = {}
    deadRacePlayer = {}
    resetRespawnPlayers()
end
addEvent("onServerGotMapType")
addEventHandler("onServerGotMapType", resroot, initialiseFeaturesForNextMap)


function deleteAllCurrentBetsOnMapStart()
    local players = getElementsByType ( "player" )
    for theKey,thePlayer in ipairs(players) do
        setElementData(thePlayer,"hasbet", false, false)
        setElementData(thePlayer,"betmoney", "", false)
        setElementData(thePlayer,"beton", "", false)
    end
end

areBetsallowedAdmin = true

--Bet command 
addCommandHandler("betallow",
    function (player, command)
        local account = getPlayerAccount(player)
        if hasUserPermissionTo(player, "toggleBetState") then
            local va = ""
            areBetsallowedAdmin = not areBetsallowedAdmin
            if areBetsallowedAdmin then va = "enabled" else va = "disabled" end
            outputChatBox("#FFFFFF|Bets| #00ccffBets are "..va.." now!", player, 0, 0, 0, true)
        end
    end
)


addCommandHandler("bet", function (playersource,command,target,amount)
    if not (isGuestAccount(getPlayerAccount(playersource))) then
        if isMapType("DM") and areBetsallowedAdmin then
            if (allowBets == true) then
                if target then
                    amount = math.floor(tonumber(amount))
                    if amount then
                        if (getPlayerFromNamePart(target)) then
                            local targetPlayer = getPlayerFromNamePart(target)
                            local hasbet = getElementData(playersource, "hasbet")
                            if (tonumber(amount) >= 1) and (tonumber(amount) < 2001) then
                                if (getPlayerCount() >= minPlayers) then
                                    local account = getPlayerAccount(playersource)
                                    local playerCash = getAccountData(account, "cash")
                                    if (tonumber(playerCash) > tonumber(amount)) then
                                        if not hasbet then
                                            if (isMemberOnline() == true) then
                                                addStat(account,"cash", -amount, true)
                                                outputChatBox("#FFFFFF|Bets| "..getPlayerName(playersource).. "#00ccff placed a bet of #FFFFFF" ..amount.. "$ #00ccffon #FFFFFF" ..tostring(getPlayerName(targetPlayer)), getRootElement(), 0, 0, 0, true)
                                                setTimer(outputChatBox,500,1,"#ffffff|Bets| #00ccffType /unbet to cancel your current bet!", playersource,unpack(scriptcol[3]))
                                                setElementData(playersource,"beton", targetPlayer, false)
                                                setElementData(playersource,"betmoney",tonumber(amount), false)
                                                setElementData(playersource,"hasbet", true, false)
                                            else outputChatBox("#ffffff|Bets| #00ccffYou can only bet if an Admin is Online!", playersource, 0, 0, 0, true)
                                            cancelEvent()
                                            end
                                        else outputChatBox("#ffffff|Bets| #00ccffYou already bet on someone!", playersource, 0, 0, 0, true)
                                        cancelEvent()
                                        end
                                    else outputChatBox("#FFFFFF|Bets| #00ccffYou don't have enough money for your bet!", playersource, 0, 0, 0, true)
                                    cancelEvent()
                                    end
                                else outputChatBox("#FFFFFF|Bets| #00ccffMore than " .. minPlayers .. " must be on the server!", 0, 0, 0, true)
                                cancelEvent()
                                end
                            else outputChatBox("#FFFFFF|Bets| #00ccffYou have to choose an amount between 1$-2000$!", playersource, 0, 0, 0, true)
                            cancelEvent()
                            end
                        else outputChatBox("#FFFFFF|Bets| #00ccffCan't find the player!", playersource,unpack(scriptcol[2]))
                        cancelEvent()
                        end
                    else outputChatBox("#FFFFFF|Bets| #00ccffPlease choose an amount! Syntax: /bet <playername> <amount>", playersource, 0, 0, 0, true)
                    cancelEvent()
                    end
                else outputChatBox("#FFFFFF|Bets| #00ccffPlease choose a player! Syntax: /bet <playername> <amount>", playersource, 0, 0, 0, true)
                cancelEvent()
                end
            else outputChatBox("#FFFFFF|Bets| #00ccffSorry, but you can't bet anymore!", playersource, 0, 0, 0, true)
            cancelEvent()
            end
        else outputChatBox("#FFFFFF|Bets| #00ccffSorry, but you can't bet anymore!", playersource, 0, 0, 0, true)
        cancelEvent()
        end
    else outputChatBox(registerError, playersource,unpack(scriptcol[2]))
    cancelEvent()
    end
end)

--Unbet command
addCommandHandler ("unbet",
    function (playersource,command)
        local account = getPlayerAccount(playersource)
        if not (isGuestAccount(account)) then
            local betcash = getElementData (playersource,"betmoney")
            local hasbet = getElementData (playersource,"hasbet")
            if allowBets then
                if hasbet then
                    setElementData(playersource,"beton","")
                    addStat(account,"cash",math.floor(tonumber(betcash)))
                    setElementData(playersource,"betmoney","")
                    outputChatBox("#FFFFFF|Bets| #00ccffYour bet has been canceled!", playersource, 0, 0, 0, true)
                    setElementData(playersource,"hasbet",false)
                else
                    outputChatBox("#FFFFFF|Bets| #00ccffYou didn't bet on a player!", playersource, 0, 0, 0, true)
                    cancelEvent()
                end
            else
                outputChatBox("#FFFFFF|Bets| #00ccffYou can't unbet anymore!", playersource, 0, 0, 0, true)
                cancelEvent()
            end
        else
            outputChatBox(registerError, playersource, unpack(scriptcol[2]))
            cancelEvent()
        end
    end)


--[[*************************************************
*        Userpanel Functions						*
*****************************************************]]
function setvcolor(color,r,g,b)
    local account = getPlayerAccount(source)
    local vehicle = getPedOccupiedVehicle (source)
    if getAccountData(account, "customcolor") then
        --if isUserInACLGroup(source, "customcolor") or getAccountData(account,"vcolorr") ~= false then
        if color == 1 then
            setAccountData(account, "vcolorr", r)
            setAccountData(account, "vcolorg", g)
            setAccountData(account, "vcolorb", b)
            if vehicle then
                local r2 = getAccountData(account, "vcolorr2")
                local g2 = getAccountData(account, "vcolorg2")
                local b2 = getAccountData(account, "vcolorb2")
                setVehicleColor(vehicle,r,g,b,r2,g2,b2)
            end
        elseif color == 2 then
            setAccountData(account, "vcolorr2", r)
            setAccountData(account, "vcolorg2", g)
            setAccountData(account, "vcolorb2", b)
            if vehicle then
                local r1 = getAccountData(account, "vcolorr")
                local g1 = getAccountData(account, "vcolorg")
                local b1 = getAccountData(account, "vcolorb")
                setVehicleColor(vehicle,r1,g1,b1,r,g,b)
            end
        end
        outputChatBox("|Color| You successfully changed your vehicle color!",source,r,g,b,true)
    else
        outputChatBox("|Info| #00ccffYou don't have bought vehicle color",source,255,255,255,true)
    end
end
addEvent("triggerRGBColors",true)
addEventHandler("triggerRGBColors",getRootElement(),setvcolor)

function setfadeoptions(selected)
    local account = getPlayerAccount(source)
    if not getAccountData(account,"camerafade") or getAccountData(account,"camerafade") == 0 then
        setAccountData(account,"camerafade",1)
        triggerClientEvent(source, "displayClientInfo", source, "Camerafade", "Camerafade is enabled now!", 0, 100, 255, 1, 5)
    else
        setAccountData(account,"camerafade",0)
        triggerClientEvent(source, "displayClientInfo", source, "Camerafade", "Camerafade is disabled now!", 0, 100, 255, 1, 5)
    end
end
addEvent("setOptionCameraFade",true)
addEventHandler("setOptionCameraFade",getRootElement(),setfadeoptions)

--[[function setInfernusLabel (selected)
    local account = getPlayerAccount(source)
    if not getAccountData(account,"infernusmod") or getAccountData(account,"infernusmod") == 0 then
        setAccountData(account,"infernusmod",1)
        triggerClientEvent(source, "displayClientInfo", source, "Infernus", "Infernus modifikation is enabled now!", 0, 100, 255, 1, 5)
        triggerClientEvent("infernusModOn",source,1)
    else
        setAccountData(account,"infernusmod",0)
        triggerClientEvent(source, "displayClientInfo", source, "Infernus", "Infernus modifikation is disabled now!", 0, 100, 255, 1, 5)
        triggerClientEvent("infernusModOn",source,0)
    end
end
addEvent("setOptionInfernusBox",true)
addEventHandler("setOptionInfernusBox",getRootElement(),setInfernusLabel)]]

--[[function infernusmodOnLogin ()
    local account = getPlayerAccount(source)
    local yesorno = getAccountData(account,"infernusmod")
    if not yesorno then
        setAccountData(account,"infernusmod",1)
        triggerClientEvent("infernusModOn",source, 1)
    end
    if yesorno == 1 then
        triggerClientEvent("infernusModOn",source, 1)
    else
        triggerClientEvent("infernusModOn",source, 0)
    end
end
addEvent("onPlayerLogin",true)
addEventHandler("onPlayerLogin",getRootElement(),infernusmodOnLogin)]]

local wheelIDs = {["Shadow"] = 1073, ["Mega"] = 1074, ["Offriad"] = 0125, ["Rimshine"] = 1075, ["Wires"] = 1076, ["Classic"] = 1077, ["Twist"] = 1078, ["Cutter"] = 1079, ["Switch"] = 1080, ["Grove"] = 1081, ["Import"] = 1082, ["Dollar"] = 1083, ["Trance"] = 1084, ["Atomic"] = 1085, ["Ahab"] = 1096, ["Virtual"] = 1097, ["Access"] = 1098}
function setwheels(wheels)
    local account = getPlayerAccount(client)
    local boughtwheels = getAccountData(account,"boughtWheels")
    if boughtwheels then
		local vehicle = getPedOccupiedVehicle (client)
        if wheels == "Standart" then
			setAccountData(account, "wheels", false)
            setTimer(outputChatBox,50,1,"|Userpanel|#FF9900You have sucessfully reset your wheels!",client,255,255,255,true)
            return
        end
		
		local wheelID = wheelsIDs[wheels]
		if wheelID then
			addVehicleUpgrade(vehicle, wheelID)
			setAccountData(account, "wheels", wheelID)
			outputChatBox("|Userpanel| #ff9900You have sucessfully changed your wheels", client, 255, 255, 255, true)
		else
			outputChatBox("|Userpanel| #ff9900Invalid wheels selected!", client, 255, 255, 255, true)
		end
    else
        outputChatBox("|Userpanel| #ff9900You don't bought custom wheels!", client, 255, 255, 255, true)
    end
end
addEvent("setSelectedWheels",true)
addEventHandler("setSelectedWheels",getRootElement(),setwheels)

function setavatar (avatar)
    local account = getPlayerAccount(client)
    local boughtavatar = getAccountData(account,"boughtAvatar")
    if boughtavatar then
        if avatar == "Standart" then
            setAccountData(account, "avatar", false)
            outputChatBox("|Userpanel|#FF9900You successfully removed your avatar!",client,255,255,255,true)
        else
            setAccountData(account,"avatar", avatar)
            outputChatBox("|Userpanel|#FF9900Your avatar was successfully changed!",client,255,255,255,true)
        end
    else
        outputChatBox("|Userpanel|#FF9900You don't bought a avatar!",client,255,255,255,true)
    end
end
addEvent("setSelectedAvatar",true)
addEventHandler("setSelectedAvatar",getRootElement(),setavatar)
--[[*************************************************
*        Part VI: Buy functions                     *
*****************************************************]]
--------------------
function setstatusplayer (achivementOriginal)
    local achivement = getAchivementScriptNameFromRealName(achivementOriginal)
    local account = getPlayerAccount(client)
    local achivement = getAccountData(account,achivement)
    if achivement then
        setAccountData(account,"playerstatus",achivementOriginal)
        triggerClientEvent(client, "displayClientInfo", client, "Status", "Status: " .. achivementOriginal .. " saved!", 0, 100, 255, 1, 5)
    else
        triggerClientEvent(client, "displayClientInfo", client, "Status", "You don't unlocked this achievement!", 0, 100, 255, 1, 5)
    end
end
addEvent("setPlayerStatus",true)
addEventHandler("setPlayerStatus",getRootElement(),setstatusplayer)

function setOwnStatus(...)
    local account = getPlayerAccount(client)
    local msg = table.concat({...}, " ")
    if (string.len(msg) <= 20) then
        if tonumber(getAccountData(account, "cash")) >= 200000 then
            setAccountData(account,"playerstatus",msg)
            addStat(account, "cash", -200000)
            triggerClientEvent(client, "displayClientInfo", client, "Status", "Status: " .. msg .. " saved!", 0, 100, 255, 1, 5)
        else
            triggerClientEvent(client, "displayClientInfo", client, "Status", "You don't have enough money!", 0, 100, 255, 1, 5)
        end
    else
        triggerClientEvent(client, "displayClientInfo", client, "Status", "Sorry, but your join text should not conatin more than 20 characters", 0, 100, 255, 1, 5)
    end
end
addEvent("setPlayerStatusVioR",true)
addEventHandler("setPlayerStatusVioR",getRootElement(), setOwnStatus)

function setjointext (...)
    local account = getPlayerAccount(client)
    local msg = table.concat({...}, " ")
    if (getAccountData(account, "joinmessage")) then
        if (string.len(msg) == 0) then
            setAccountData(account,"JoinText", false)
            triggerClientEvent(client, "displayClientInfo", client, "Join text", "Join text removed!", 0, 100, 255, 1, 5)
        elseif (string.len(msg) <= 70) then
            setAccountData(account,"JoinText",msg)
            triggerClientEvent(client, "displayClientInfo", client, "Join text", "Join text: " .. msg .. " #ffffffsaved!", 0, 100, 255, 1, 5)
        else
            triggerClientEvent(client, "displayClientInfo", client, "Join text", "Sorry, but your join text should not conatin more than 70 characters!", 0, 100, 255, 1, 5)
        end
    else
        triggerClientEvent(client, "displayClientInfo", client, "Join text", "You don't have bought Join message!", 0, 100, 255, 1, 5)
    end
end
addEvent("triggerJointextText",true)
addEventHandler("triggerJointextText",getRootElement(),setjointext)

function setRainbowcolor()
    local account = getPlayerAccount(client)
    if getAccountData(account, "rainbowcolor") then
        if getAccountData(account, "rainbowcolorstate") then
            setAccountData(account,"rainbowcolorstate", false)
            setElementData(client,"rainbowcolorstate", false)
            triggerClientEvent(client, "displayClientInfo", client, "Rainbowcolor", "Your rainbowcolor is disabled now!", 0, 100, 255, 1, 5)
        else
            setAccountData(account,"rainbowcolorstate", true)
            setElementData(client,"rainbowcolorstate", true)
            triggerClientEvent(client, "displayClientInfo", client, "Rainbowcolor", "Your rainbowcolor is enabled now!", 0, 100, 255, 1, 5)
        end
    else
        triggerClientEvent(client, "displayClientInfo", client, "Rainbowcolor", "You don't have bought rainbowcolor!", 0, 100, 255, 1, 5)
    end
end
addEvent("setRainbowColor",true)
addEventHandler("setRainbowColor",getRootElement(),setRainbowcolor)

function toggleAntiBounce()
    local account = getPlayerAccount(client)
    if getAccountData(account, "antiBounce") then
        setAccountData(account, "antiBounce", false)
        setElementData(client, "antiBounce", false)
        triggerClientEvent(client, "displayClientInfo", client, "AntiBounce", "AntiBounce is disabled now!", 0, 100, 255, 1, 5)
    else
        setAccountData(account, "antiBounce", true)
        setElementData(client, "antiBounce", true)
        triggerClientEvent(client, "displayClientInfo", client, "AntiBounce", "AntiBounce is enabled now!", 0, 100, 255, 1, 5)
    end
end
addEvent("toggleAntiBounce", true)
addEventHandler("toggleAntiBounce", getRootElement(), toggleAntiBounce)

function togglePulsatingHeadlights()
    local account = getPlayerAccount(client)
    if getAccountData(account, "pulsatingheadlights") then
        if getAccountData(account, "pulsatingheadlightsON") then
            setAccountData(account, "pulsatingheadlightsON", false)
            setElementData(client, "pulsatingheadlightsON", false)
            triggerClientEvent(client, "displayClientInfo", client, "Pulsating Headlights", "Pulsating Headlights are disabled now!", 0, 100, 255, 1, 5)
        else
            setAccountData(account, "pulsatingheadlightsON", true)
            setElementData(client, "pulsatingheadlightsON", true)
        end
    else
        triggerClientEvent(client, "displayClientInfo", client, "Pulsating Headlights", "Pulsating Headlights are enabled now!", 0, 100, 255, 1, 5)
    end
end
addEvent("togglePulsatingHeadlights", true)
addEventHandler("togglePulsatingHeadlights", getRootElement(), togglePulsatingHeadlights)

function setwintext (...)
    local account = getPlayerAccount(client)
    local msg = table.concat({...}, " ")
    local winsoundbuy = getAccountData(account, "onBuyWinText")
    if winsoundbuy then
        if (string.len(msg) <= 40) then
            setAccountData(account,"WinText",msg)
            triggerClientEvent(client, "displayClientInfo", client, "Wintext" ,"Wintext: " ..msg.. " #ffffffsaved!", 0, 100, 255, 1, 5)
        else
            triggerClientEvent(client, "displayClientInfo", client, "Wintext", "Sorry, but your message should not contain more than 40 characters!", 0, 100, 255, 1, 5)
        end
    else
        triggerClientEvent(client, "displayClientInfo", client, "Wintext", "Sorry, but you have to buy a wintext per Userpanel~>Shop first!", 0, 100, 255, 1, 5)
    end
end
addEvent("triggerWinText",true)
addEventHandler("triggerWinText",getRootElement(),setwintext)

function outputTheWinText()
    local account = getPlayerAccount(source)
    local wintext = getAccountData(account, "WinText")
    if wintext then
        triggerClientEvent("onPlayerWinWithWinText",source,wintext)
    end
end
addEventHandler ( "onPlayerDestructionDerbyWin", getRootElement(), outputTheWinText )

--check joined player for join msg
function checkJoinMsg(old, account)
    local lastPlayerName = getAccountData(account, "lastPlayerName")
    showNickchange = false
    setPlayerName(source, lastPlayerName)
    showNickchange = true
    setPlayerNametagShowing(source, false)

    local joinmsg = getAccountData(account, "JoinText")
    local joinmessage = getAccountData(account, "joinmessage")
    if joinmsg and joinmessage then
        if joinmsg ~= "" then
            triggerClientEvent("addClientMessage", root, ("|Join| %s#ffffff %s"):format(getPlayerName(source), joinmsg), 255, 255, 255)
        end
    end
    local camerafade = getAccountData(account,"camerafade")
    if not camerafade then
        setAccountData(account,"camerafade",1)
    end
    --set status
    local playerstatus = getAccountData(account,"playerstatus")
    if not playerstatus then
        setAccountData(account, "playerstatus", "Beginner")
    end
end
addEventHandler ( "onPlayerLogin", getRootElement(), checkJoinMsg )

--buyghost functions--
----------------------
function startBuyGhost(source)
    local theVehicle = getPedOccupiedVehicle(source)

    setElementData(source,"invisible", true)

    outputChatBox("|Shop| #ff9900You're now invisible for two minutes!", source, 255, 255, 255, true)
    setElementAlpha(source,0)
    setElementAlpha ( theVehicle, 0 )
    setTimer(setElementAlpha, ghostDuration, 1,source,255)
    setTimer(outputChatBox, (ghostDuration/2), 1,"#FFFFFF|Shop| #ff9900"..tostring(round((ghostDuration/1000/60)/2)).."minute left",source,unpack(scriptcol[3]))
    setTimer(setElementAlpha, ghostDuration, 1,getPedOccupiedVehicle(source),255)
    setTimer(setElementData, ghostDuration, 1,source,"invisible", false)

    addEventHandler("onPlayerPickUpRacePickup", source, setVehicleInvisible)

    setTimer(removeEventFromPlayer, ghostDuration, 1, source)
end

--extra buyghost functions
function removeEventFromPlayer(source)
    removeEventHandler("onPlayerPickUpRacePickup", source, setVehicleInvisible)
    outputChatBox("#FFFFFF|Shop| #ff9900You are visible again.", source, 0, 0, 0, true)
end

function setVehicleInvisible(pid, ptype, pveh)
    if (ptype == "vehiclechange") and not (pveh == 425) then
        setElementAlpha(source, 0)
        setElementAlpha(getPedOccupiedVehicle(source), 0)
    end
end
--buy object functions--
------------------------

--COUNTDOWN FUNCTION--
----------------------
addCommandHandler("countdown",
    function (player, cmd)
        local account = getPlayerAccount(player)
        if hasUserPermissionTo(player, "countdown") then
            if not (countdownUsed) then
                triggerClientEvent("onPlayerUseCountdown", player)
                countdownUsed = true
                outputChatBox("#FFFFFF[Countdown] "..getPlayerName(player).."#ff9900 hat den Countdown aktiviert!", root, unpack(scriptcol[1]))
            else
                outputChatBox("#FFFFFF[Countdown] #ff9900Bitte warte, ein Countdown läuft schon!", player, unpack(scriptcol[2]))
            end
        else
            outputChatBox("#FFFFFF[Countdown] #ff9900Du hast nicht die Berechtigung dazu!", player, unpack(scriptcol[2]))
        end
    end)

function setCountDownUsed()
    countdownUsed = false
end
addEvent("onClientStopCountdown", true)
addEventHandler("onClientStopCountdown", root, setCountDownUsed)

function startCountdownForClients(a1,a2,a3,a4,a5)
    triggerClientEvent("onPlayerClickDrawCountdown", root, a1, a2, a3, a4)
end
addEvent("onPlayerClickDrawCountdownSendServer", true)
addEventHandler("onPlayerClickDrawCountdownSendServer", root, startCountdownForClients)
--

addCommandHandler("bets",
    function (playersource,message, typ)
        local count = 0
        outputChatBox("#FFFFFF|Bets| #00ccffCurrent bets:", playersource, unpack(scriptcol[3]))

        for i,v in ipairs (getElementsByType("player")) do
            local hasbet = getElementData(v,"hasbet")
            if hasbet then
                local beton = getElementData(v,"beton")
                local betcash = getElementData(v,"betmoney")
                count = count + 1
                outputChatBox("#FFFFFF|Bets| #00ccff"..tostring(count).." Player: "..getPlayerName(v).."#00FF00 | Money: "..betcash.."$ | On player: ".. getPlayerName(beton), playersource, unpack(scriptcol[3]))
            end
        end

        if count == 0 then
            outputChatBox("#FFFFFF|Bets| #00ccffNo bets on this map!", playersource, unpack(scriptcol[2]))
        end
    end)


addCommandHandler("donate", function (playersource, cmd, object, amount, ...)
    local target = object
    local account = getPlayerAccount(playersource)
    local reason = table.concat({...}, " ")
    if not (isGuestAccount(account)) then
        if target then
            if amount then
                local targetPlayer = getPlayerFromNamePart(target)
                local amount = math.floor(tonumber(amount))
                if (targetPlayer) then
                    local targetAccount = getPlayerAccount(targetPlayer)
                    if not (isGuestAccount(targetAccount)) then
                        if not (playersource == targetPlayer) then
                            if (amount > 0) then
                                local sourceCash = getAccountData(account, "cash")
                                if (tonumber(sourceCash) > amount) then
                                    if not isPlayerMuted(playersource) then	if reason ~= "" then reason = " (" .. reason .. ")" else reason = "" end else reason = "" end
                                    outputChatBox("|Donate| " .. getPlayerName(playersource) .. " #00ccffdonated " ..tostring(amount).. "$ to #FFFFFF" .. getPlayerName(targetPlayer) .. "#00ccff!" .. reason, getRootElement(), 255, 255, 255, true)
                                    addStat(account, "cash", -amount, true)
                                    addStat(targetAccount, "cash", amount)
                                else
                                    outputChatBox("#FFFFFF|Donate| #00ccffSorry but you don't that much money that you want to donate!", playersource, unpack(scriptcol[2]))
                                end
                            else
                                outputChatBox("#FFFFFF|Donate| #00ccffInvalid number! Please enter a number > 0!", playersource, unpack(scriptcol[2]))
                            end
                        else
                            outputChatBox("#FFFFFF|Donate| #00ccffYou can't donate money to yourself!", playersource, unpack(scriptcol[2]))
                        end
                    else
                        outputChatBox(targetError, playersource, unpack(scriptcol[2]))
                    end
                else
                    outputChatBox("#FFFFFF|Donate| #00ccffCould not find player!", playersource, unpack(scriptcol[2]))
                end
            else
                outputChatBox("#FFFFFF|Donate| #00ccffPlease enter an amount! SYNTAX: !donate <player> <amoutn>", playersource, unpack(scriptcol[2]))
            end
        else
            outputChatBox("#FFFFFF|Donate| #00ccffPlease enter a player name! SYNTAX: !donate <player> <amoutn>", playersource, unpack(scriptcol[2]))
        end
    else
        outputChatBox(registerError, playersource, unpack(scriptcol[2]))
    end
end)


--PUBLIC MESSAGE

function PublicMessage(source, command, ...)
    local account = getPlayerAccount(source)
    if (isGuestAccount(account) == false) then
        local accountname = getAccountName(account)
        if hasUserPermissionTo(source, "publicMSG") then
            local message = table.concat({...}, " ")
            triggerClientEvent("onAdminSendPMSG", getRootElement(), source, message)
        end
    end
end
addCommandHandler("pmsg", PublicMessage)

-------------------------------------------------------------------
function setLabelBoxOptions ()
    local account = getPlayerAccount(source)
    labelbox = getAccountData(account,"labelbox")
    if labelbox == 1 then
        dontshow = 1
        triggerClientEvent("LabelsettingsOnLogin",source,dontshow)
    else
        dontshow = 0
        triggerClientEvent("LabelsettingsOnLogin",source,dontshow)
        setAccountData(account,"labelbox",0)
    end
end
--addEventHandler( "onPlayerLogin", getRootElement(), setLabelBoxOptions )

function vehicleUpgradesOnSpawn(thePlayer, seat, jacked)
    local vehicle = getPedOccupiedVehicle(thePlayer)
    local account = getPlayerAccount(thePlayer)
    local r = getAccountData(account, "vcolorr") or 255
    local g = getAccountData(account, "vcolorg") or 255
    local b = getAccountData(account, "vcolorb") or 255
    local r2 = getAccountData(account, "vcolorr2") or 255
    local g2 = getAccountData(account, "vcolorg2") or 255
    local b2 = getAccountData(account, "vcolorb2") or 255

    if r and g and b then
        setVehicleColor(vehicle,r,g,b,r2,g2,b2)
        setVehicleHeadLightColor(vehicle, r,g,b)
    else
        setVehicleColor(vehicle,255,255,255,255,255,255)
        setVehicleHeadLightColor(vehicle ,0,0,0)
    end

    local wheels = getAccountData(account, "wheels")
    if wheels then
        addVehicleUpgrade (vehicle,wheels)
    end
end
addEventHandler("onVehicleEnter", getRootElement(), vehicleUpgradesOnSpawn)

function upgradewheels ()
    local account = getPlayerAccount(source)
    local wheels = getAccountData(account, "wheels")
    local vehicle = getPedOccupiedVehicle(source)
    if tonumber(wheels) then
        addVehicleUpgrade (vehicle,tonumber(wheels))
    end
    local r = getAccountData(account, "vcolorr") or 255
    local g = getAccountData(account, "vcolorg") or 255
    local b = getAccountData(account, "vcolorb") or 255
    local r2 = getAccountData(account, "vcolorr2") or 255
    local g2 = getAccountData(account, "vcolorg2") or 255
    local b2 = getAccountData(account, "vcolorb2") or 255
    if r and g and b then
        setVehicleColor(vehicle,r,g,b,r2,g2,b2)
        setVehicleHeadLightColor(vehicle, r,g,b)
    else
        setVehicleColor(vehicle,255,255,255,255,255,255)
        setVehicleHeadLightColor(vehicle ,0,0,0)
    end
end
addEvent("onPlayerPickUpRacePickup",true)
addEventHandler("onPlayerPickUpRacePickup", getRootElement(), upgradewheels)

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------other-------------------------------------

function checkPlayerLoggedIn()
    for i, player in ipairs(getElementsByType("player")) do
        local account = getPlayerAccount(player)
        if not isGuestAccount(account) then
            setElementData(player,"isLogedIn",false)
        end
    end
end
addEventHandler("onResourceStart", resroot, checkPlayerLoggedIn)

function playerVoice()
    if not (isUserInACLGroup(source, "Projektleiter") or isUserInACLGroup(source, "Admin") or isUserInACLGroup(source, "Moderator") or isUserInACLGroup(source, "Member")) then
        cancelEvent()
    end
end
addEventHandler( "onPlayerVoiceStart", getRootElement(), playerVoice )


function randomCashWin()
    if #activePlayers >= minPlayers then
        local randomCash = math.random(100,math.random(5000, 50000))
        local randomPlayer = activePlayers[math.random(1, #activePlayers)]
        if not randomPlayer then return end
        local account = getPlayerAccount (randomPlayer)
        if not isGuestAccount(account) then
            --outputChatBox("|iRace| #0066ff" .. getPlayerName(randomPlayer) .. "#0066ff won #ffffff" .. randomCash .. " #0066ff$!", getRootElement(), 255, 255, 255, true)
            triggerClientEvent("addClientMessage", root, ("|iRace| %s#0066ff won #ffffff%s #0066ff$"):format(getPlayerName(randomPlayer), randomCash), 255, 255, 255)
            addStat(account, "cash", randomCash)
        end
    end
end
setTimer(randomCashWin, 300000, 0)

function setTheKMHData (kmh) --Für 2.2.1 fixen
    local account = getPlayerAccount(source)
    local currentbest = getAccountData(account,"topspeed")
    if currentbest then
        if kmh > currentbest then
            local account = getPlayerAccount(source)
            setAccountData(account,"topspeed",tonumber(kmh))
        end
    else
        local account = getPlayerAccount(source)
        setAccountData(account,"topspeed",0)
    end
end
addEvent("setKMHData",true)
addEventHandler("setKMHData",getRootElement(),setTheKMHData)

------------------------------------------------------------------------#
--#
--Archivements																--#
--#
------------------------------------------------------------------------#																		

function getAchivementScriptNameFromRealName(achivement)
    for i,achive in pairs(achiveTable) do
        if i == achivement then
            return achive[1]
        end
    end
end

------------------------------------------------------------------------#
--#
--Maps																		--#
--#
------------------------------------------------------------------------#	
local mapList = {}
function initialiseServerMaps()
    local tableOut, gamemodes = {}
    local gamemodes = {}
    gamemodes = call(getResourceFromName("mapmanager"), "getGamemodes")
    for id,gamemode in ipairs (gamemodes) do
        tableOut[id] = {}
        tableOut[id].name = getResourceInfo(gamemode, "name") or getResourceName(gamemode)
        tableOut[id].resname = getResourceName(gamemode)
        tableOut[id].maps = {}
        local maps = call(getResourceFromName("mapmanager"), "getMapsCompatibleWithGamemode" , gamemode)
        for _,map in ipairs (maps) do
            table.insert(tableOut[id]["maps"] ,{name = getResourceInfo(map, "name") or getResourceName(map), resname = getResourceName(map)})
        end
        table.sort(tableOut[id]["maps"], sortCompareFunction)
    end
    table.sort((tableOut), sortCompareFunction)
    table.insert(tableOut, {name = "no gamemode", resname = "no gamemode", maps = {}})
    local countGmodes = #tableOut
    local maps = call(getResourceFromName("mapmanager"), "getMapsCompatibleWithGamemode")
    for id,map in ipairs (maps) do
        table.insert(tableOut[countGmodes]["maps"] ,{name = getResourceInfo(map, "name") or getResourceName(map), resname = getResourceName(map)})
    end
    table.sort(tableOut[countGmodes]["maps"], sortCompareFunction)

    mapList = tableOut
    return true
end
addEventHandler("onResourceStart", resroot, initialiseServerMaps)

function getServerMaps()
    triggerClientEvent(client, "onClientLoadMapList", client, mapList)
end
addEvent("getServerMaps", true)
addEventHandler("getServerMaps", root, getServerMaps)

function sortCompareFunction(s1, s2)
    if type(s1) == "table" and type(s2) == "table" then
        s1, s2 = s1.name, s2.name
    end
    s1, s2 = s1:lower(), s2:lower()
    if s1 == s2 then
        return false
    end
    local byte1, byte2 = string.byte(s1:sub(1,1)), string.byte(s2:sub(1,1))
    if not byte1 then
        return true
    elseif not byte2 then
        return false
    elseif byte1 < byte2 then
        return true
    elseif byte1 == byte2 then
        return sortCompareFunction(s1:sub(2), s2:sub(2))
    else
        return false
    end
end

function toggleMapBuy(player, command)
    if hasUserPermissionTo(player, "toggleMapBuyState") then
        if mapBuyEnabled == true then
            mapBuyEnabled = false
            outputChatBox("Map buy #ffffffdisabled #ff0000by " .. getPlayerName(player), getRootElement(), 255, 0, 0, true)
        else
            mapBuyEnabled = true
            outputChatBox("Map buy #ffffffenabled #ff0000by " .. getPlayerName(player), getRootElement(), 255, 0, 0, true)
        end
    end
end
addCommandHandler("toggleMapBuy", toggleMapBuy)

-- Buy a next map
function buyMap(mapName)
    if mapBuyEnabled == false then
        outputChatBox("|Map| #FF9900This function is currently deactivated!",client,255,255,255,true)
        do return end
    end

    if isMapBlacklisted(mapName) then
        outputChatBox("|Map| #FF9900This map is blacklisted. You can't buy it!",client,255,255,255,true)
        do return end
    end

    local account = getPlayerAccount(client)
    local cash = getAccountData(account, "cash")
    local level = getAccountData(account, "level")
    local pt = getAccountData(account, "playtime")
    if not (mapName == "") then
        if not (isGuestAccount(getPlayerAccount(client))) then
            if tonumber(level) >= tonumber(MapBuylevel) then
                if pt < 1500 then outputChatBox("|Map| #FF9900You need at least 25h playtime!", client, 255, 255, 255, true) return end

                if tonumber(cash) >= tonumber(MapBuyPrice) then
                    if getMapTypeByName(mapName) == "DD" then -- Überprüfen ob die zu kaufende Map eine DD ist
                        if not isTimer(ddMapTimer) then -- Wenn DD Map ist, und dd timer noch nicht läuft, sette map und starte timer
                            triggerEvent("onNextmapBuy",client,mapName)
                            ddMapTimer = setTimer(DDMapCanBoughtAgain, 600000, 1)
                        else -- Wenn dd timer schon läuft, map nicht kaufen und fehlermeldung
                            local tl = getTimerDetails(ddMapTimer)
                            outputChatBox("|Map| #FF9900Please wait #ffffff" .. math.floor((tl/1000)/60) .. " #ff9900min to buy a DD Map again!",client,255,255,255,true)
                        end
                    elseif getMapTypeByName(mapName) == "SHOOTER" then
                        if not isTimer(shooterMapTimer) then
                            triggerEvent("onNextmapbuy", client, mapName)
                            shooterMapTimer = setTimer(shoterCanBoughtAgain, 600000, 1)
                        else
                            local tl = getTimerDetails(shooterMapTimer)
                            outputChatBox("|Map| #FF9900Please wait #ffffff" .. math.floor((tl/1000)/60) .. " #ff9900min to buy a Shooter Map again!",client,255,255,255,true)
                        end
                    else -- wenn zu kaufende map keine dd map ist
                        triggerEvent("onNextmapBuy",client,mapName)
                    end
                else
                    outputChatBox("|Map| #FF9900You have not enough money to buy a map!",client,255,255,255,true)
                end
            else
                outputChatBox("|Map| #FF9900You need level #FFFFFF" .. tonumber(MapBuylevel) .. " #FF9900to buy a map!",client,255,255,255,true)
            end
        end
    else
        outputChatBox("|Map| #FF9900Please select a map!",client,255,255,255,true)
    end
end
addEvent("triggerbuyMap",true)
addEventHandler( "triggerbuyMap", getRootElement(),buyMap )

function DDMapCanBoughtAgain()
    triggerClientEvent("addClientMessage", root, "|Map| #FF9900A destruction derby map can be bought again!", root, 255, 255, 255)
end

function shoterCanBoughtAgain()
    triggerClientEvent("addClientMessage", root, "|Map| #FF9900A shooter map can be bought again!", root, 255, 255, 255)
end

function onBuyMapReady()
    local account = getPlayerAccount(source)
    addStat(account,"cash", -5000)
end
addEvent("setCashofBuyMap")
addEventHandler( "setCashofBuyMap", getRootElement(), onBuyMapReady )

--end MAP
playerblip = {}

function createBlipToPlayer(thePlayer,seat,jacked)
    if isElement(playerblip[thePlayer]) then
        destroyElement(playerblip[thePlayer])
    end

    --local adminText, adminColor = getPlayerAdminGroupColor(thePlayer)
    --r,g,b,a = getColorFromString(adminColor)
end
addEventHandler( "onVehicleEnter", getRootElement(), createBlipToPlayer )

local blockedMuteCommands = {["say"] = true, ["teamsay"] = true, ["donate"] = true, ["pm"] = true, ["msg"] = true, ["rate"] = true}
function AntiSpamCommand(cmd)
    if isPlayerMuted(source) then
        if blockedMuteCommands[cmd] then
            cancelEvent()
            outputChatBox("Sorry, you can't do this while you're muted.", source, 200, 0, 0,true)
        end
    end
end
addEventHandler("onPlayerCommand",getRootElement(),AntiSpamCommand)

--[[
--------------------------------------------------------------------
--PVPSystem
--------------------------------------------------------------------
]]

PVPdisabled	= false
addCommandHandler("togglepvp",
    function(playersource,command,whoban,reason)
        if hasUserPermissionTo(playersource, "togglePvpState") then
            if PVPdisabled == false then
                PVPdisabled = true
                outputChatBox("#ffffff[PvP] #ff6600PvP was disabled!", getRootElement(),255,255,255,true)
            else
                PVPdisabled = false
                outputChatBox("#ffffff[PvP] #ff6600PvP was enabled!", getRootElement(),255,255,255,true)
            end
        else
            outputChatBox("Youre not cool enough to do that",playersource)
        end
    end
)

function onPlayerGetPvPRequest(bet,wins,targetPlayer)
    if tonumber(bet) <= 0 or tonumber(bet) > 10000 then
        cancelEvent()
    elseif tonumber (wins) <= 0 and tonumber (wins) > 5 then
        cancelEvent()
    elseif client == targetPlayer then
        cancelEvent()
    end

    if getElementData(client,"isInPvP") == true then
        outputChatBox("[PvP] #ff9900You are already in a PvP Match!",client,255,255,255,true)
        return
    end
    if getElementData(client,"pvpEnemie") == true then
        outputChatBox("[PvP] "..getPlayerName(client).." got allready a request from "..getPlayerName(getElementData(client,"pvpEnemie")).."!",client,255,255,255,true)
        return
    end
    if getAccountData(getPlayerAccount(client),"cash") <= tonumber(bet) then
        outputChatBox("[PvP] You#FF9900 don't got enought cash!",client,255,255,255,true)
        return
    end
    if getAccountData(getPlayerAccount(targetPlayer),"cash") <= tonumber(bet) then
        outputChatBox("[PvP] "..getPlayerName(requestedPlayer).." don't got enought cash.",client,255,255,255,true)
        return
    end
    if PVPdisabled == true then
        outputChatBox("[PvP] PVP is disabled",client,255,255,255,true)
        return
    end
    if not getElementData(targetPlayer,"isInPvP") == true then
        setElementData(targetPlayer,"pvpWins",nil)
        setElementData(targetPlayer,"pvpBetAmount",nil)
        setElementData(targetPlayer,"pvpEnemie",nil)
        setElementData(targetPlayer,"pvpWinsNeeded",nil)
        setElementData(client,"pvpWins",nil)
        setElementData(client,"pvpBetAmount",nil)
        setElementData(client,"pvpEnemie",nil)
        setElementData(client,"pvpWinsNeeded",nil)
        outputChatBox("[PvP] "..getPlayerName(client).."#FF9900 requested you for a PvP Match, go to the UserPanel to Accept it.!",targetPlayer,255,255,255,true)
        outputChatBox("[PvP] Bet: "..bet.."$ Wins: "..wins.."!",targetPlayer,255,255,255,true)
        outputChatBox("[PvP] Wait for Accept...",client,255,255,255,true)
        setElementData(targetPlayer,"pvpEnemie",client)
        setElementData(client,"pvpEnemie",targetPlayer)
        setElementData(targetPlayer,"pvpWinsNeeded",wins)
        setElementData(client,"pvpWinsNeeded",wins)
        setElementData(targetPlayer,"pvpBetAmount",bet)
        setElementData(client,"pvpBetAmount",bet)
        setElementData(targetPlayer,"pvpRequest",true)
        triggerClientEvent("setPlayerNameToAcceptButton",targetPlayer,getPlayerName(client))
    else
        outputChatBox("[PvP] "..getPlayerName(targetPlayer).."#FF9900 is already in a PvP Match!",client,255,255,255,true)
    end
end
addEvent("onPlayerGetPvPRequest",true)
addEventHandler("onPlayerGetPvPRequest",getRootElement(),onPlayerGetPvPRequest)

function onPlayerAcceptPvPRequest ()
    if getElementData(client,"isInPvP") == true then
        outputChatBox("[PvP] You#FF9900 are already in a PvP Match!",client,255,255,255,true)
        return
    end
    if getElementData(getElementData(client,"pvpEnemie"),"isInPvP") == true then
        outputChatBox("[PvP] Enemie#FF9900 is already in a PvP Match!",client,255,255,255,true)
        return
    end
    if getElementData(client,"pvpRequest") == true then
        outputChatBox("[PvP] PvP will start next Map!",client,255,255,255,true)
        outputChatBox("[PvP] PvP will start next Map!",getElementData(client,"pvpEnemie"),255,255,255,true)
        setElementData(getElementData(client,"pvpEnemie"),"pvpEnemie",client)
        setElementData(client,"isInPvP",true)
        setElementData(getElementData(client,"pvpEnemie"),"isInPvP",true)
        setElementData(getElementData(client,"pvpEnemie"),"pvpWins",0)
        --setElementData(getElementData(client,"pvpEnemie"),"pvpBetAmount",getElementData(getElementData(client,"pvpEnemie"),"pvpBetAmount"))
        setElementData(getElementData(client,"pvpEnemie"),"pvpEnemie",client)
        setElementData(client,"pvpWins",0)
        triggerClientEvent("setLabelsForPvP",client)
        triggerClientEvent("setLabelsForPvP",getElementData(client,"pvpEnemie"))
    end
end
addEvent("onPlayerAcceptPvPRequest",true)
addEventHandler("onPlayerAcceptPvPRequest",getRootElement(),onPlayerAcceptPvPRequest)

function onPlayerDeclinePvPRequest ()
    if getElementData(client,"isInPvP") == true then
        outputChatBox("[PvP] You#FF9900 are in a PvP Match!",client,255,255,255,true)
        return
    end
    if getElementData(getElementData(client,"pvpEnemie"),"isInPvP") == true then
        triggerClientEvent("setLabelsForPvP",client)
        triggerClientEvent("setLabelsForPvP",getElementData(client,"pvpEnemie"))
        outputChatBox("[PvP] PvP Request was declined!",client,255,255,255,true)
        outputChatBox("[PvP] PvP will start next Map!",getElementData(client,"pvpEnemie"),255,255,255,true)
    end
end
addEvent("onPlayerDeclinePvPRequest",true)
addEventHandler("onPlayerDeclinePvPRequest",getRootElement(),onPlayerDeclinePvPRequest)

function startPvPRound()
    for i,player in ipairs(getElementsByType("player")) do
        if getElementData(player,"isInPvP") == true then
            outputChatBox("[PvP] PvP Match Started! Your wins:"..getElementData(player,"pvpWins").."/"..getElementData(player,"pvpWinsNeeded"),player,255,255,255,true)
            addEventHandler("onPlayerWasted",player,playerWastedPvP)
        end
    end
end
addEvent("onMapStarting",true)
addEventHandler("onMapStarting",getRootElement(),startPvPRound)

function debugPvP(ps)
    setElementData(ps,"isInPvP",false)
    setElementData(ps,"pvpWins",nil)
    setElementData(ps,"pvpBetAmount",nil)
    setElementData(ps,"pvpEnemie",nil)
    setElementData(ps,"pvpWinsNeeded",nil)
    setElementData(source,"pvpRequest",false)
    --outputChatBox("debuged")
end
--addCommandHandler("i",debugPvP)

function playerWastedPvP()
    if isRespawnMode(source) then return end
    if getElementData(source,"isInPvP") == true then
        if getElementData(getElementData(source,"pvpEnemie"),"state") == "alive" then
            setElementData(getElementData(source,"pvpEnemie"),"pvpWins",getElementData(getElementData(source,"pvpEnemie"),"pvpWins")+1)
            outputChatBox("[PvP] "..getPlayerName(getElementData(source,"pvpEnemie")).." #FF9900won this PvP round!",source,255,255,255,true)
            outputChatBox("[PvP] "..getPlayerName(getElementData(source,"pvpEnemie")).." #FF9900won this PvP round!",getElementData(source,"pvpEnemie"),255,255,255,true)
        end
        if tonumber(getElementData(getElementData(source,"pvpEnemie"),"pvpWins")) == tonumber(getElementData(getElementData(source,"pvpEnemie"),"pvpWinsNeeded")) then
            outputChatBox("[PvP] "..getPlayerName(getElementData(source,"pvpEnemie")).." #FF9900won the PvP Match vs. "..getPlayerName(source).." #FF9900!",getRootElement(),255,255,255,true)
            outputChatBox("[PvP] #FF6600He earned: "..tonumber(getElementData(source,"pvpBetAmount")).."$!",getRootElement(),255,255,255,true)
            setElementData(getElementData(source,"pvpEnemie"),"isInPvP",false)
            setElementData(getElementData(source,"pvpEnemie"),"isInPvP",false)
            local cash = tonumber(getElementData(source,"pvpBetAmount"))
            addStat(getPlayerAccount(getElementData(source,"pvpEnemie")),"cash",cash)
            addStat(getPlayerAccount(source),"cash",-cash)
            triggerClientEvent("resetAllPvPLabels",source)
            triggerClientEvent("resetAllPvPLabels",getElementData(source,"pvpEnemie"))
            debugPvP(getElementData(source,"pvpEnemie"))
            debugPvP(source)
        end
        triggerClientEvent("setLabelsForPvP",source)
        triggerClientEvent("setLabelsForPvP",getElementData(source,"pvpEnemie"))
        removeEventHandler("onPlayerWasted",source,playerWastedPvP)
        removeEventHandler("onPlayerWasted",getElementData(source,"pvpEnemie"),playerWastedPvP)
    end
end

function playerQuitPvP(qt)
    if getElementData(source,"isInPvP") == true then
        --outputChatBox("[PvP] "..getPlayerName(source).." won this PvP round!",getElementData(source,"pvpEnemie"),255,255,255,true)
        outputChatBox("[PvP] "..getPlayerName(getElementData(source,"pvpEnemie")).." #FF9900won the PvP Match vs. "..getPlayerName(source).." #FF9900!",getRootElement(),255,255,255,true)
        outputChatBox("[PvP] #FF6600He earned: "..tonumber(getElementData(source,"pvpBetAmount")).."$!",getRootElement(),255,255,255,true)
        local cash = tonumber(getElementData(source,"pvpBetAmount"))
        addStat(getPlayerAccount(getElementData(source,"pvpEnemie")),"cash",cash)
        addStat(getPlayerAccount(source),"cash",-cash)
        triggerClientEvent("resetAllPvPLabels",getElementData(source,"pvpEnemie"))
        debugPvP (getElementData(source,"pvpEnemie"))
    end
    if getElementData(source,"pvpEnemie") == true then
        triggerClientEvent("resetAllPvPLabels",getElementData(source,"pvpEnemie"))
        debugPvP (getElementData(source,"pvpEnemie"))
        return
    end
end
addEventHandler("onPlayerQuit",getRootElement(),playerQuitPvP)

local classicraceposition = 1

--[[function classicRaceMapWin (dataName,oldValue)
    if getElementType(source) == "player" then
        if dataName == "state" then
            local newValue = getElementData(source,dataName)
            if newValue == "finished" then
                local account = getPlayerAccount(source)
                if not (isGuestAccount(account)) then
                    local cash,summeWithLevel = calcCash(classicraceposition, source)
                    cash = cash*2
                    outputChatBox("#FFFFFF>>"..getPlayerName(source).."#00ccff hat das Rennen als Platz "..classicraceposition.." abgeschlossen!",getRootElement(),unpack(scriptcol[1]))
                    outputChatBox("#FFFFFF>>#00ccffEr hat "..tostring(cash).." $ erhalten und für sein Level "..summeWithLevel.." $ extra erhalten!",getRootElement(),unpack(scriptcol[1]))
                    classicraceposition = classicraceposition+1
                    addStat(account,"ddsplayed",1)
                    if classicRaceMapWin == 1 then
                        addStat(account,"ddswon",1)
                    end
                    addStat(account,"cash",cash + summeWithLevel)
                end
            end
        end
    end
end
addEventHandler("onElementDataChange", getRootElement(), classicRaceMapWin)]]

--[[function classicRaceResetRank ()
    classicraceposition = 1
end
addEventHandler("onMapStarting", getRootElement(), classicRaceResetRank)]]

local wrapTable = {"shootersplayed", "shooterswon", "huntersplayed", "hunterswon" }
addCommandHandler("wrap", function()
    local sT = getTickCount()
    for i, account in ipairs(getAccounts()) do
        outputChatBox("Wraping account ID " .. i)
        for _, data in ipairs(wrapTable) do
            outputChatBox("Adding: " .. data)
            setAccountData(account, data, 0)
        end
    end
    outputChatBox("Wrapping done: " .. getTickCount() - sT .. "ms")
end)