--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 26.07.2014 - Time: 16:38
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
addEvent("onDownloadFinished")

local fixPrice = 3000
local flipPrice = 2500
local nitroPrice = 10000
local BoomBoomSongPrice = 60000
local ghostPrice = 5000
local pulsatingHeadlightsPrice = 30000
local wheelsPrice = 30000
local customcolorPrice = 40000
local wintextPrice = 70000
local rainbowcolorPrice = 150000
local avatarPrice = 100000
local joinmessagePrice = 10000

local minLevelJoinmessage = 10
local minLevelPulsatingHeadlights = 30
local minLevelFix = 5
local minLevelFlip = 10
local minLevelWheels = 15
local minLevelCustomcolor = 20
local minLevelWintext = 30
local minLevelRainbowcolor = 40
local minLevelAvatar = 25
local minLevelBuyMap = 20
--player Wildcard
function getPlayerWildcard(namePart)
    namePart = string.lower(namePart)

    local bestaccuracy = 0
    local foundPlayer, b, e
    for _,player in ipairs(getElementsByType("player")) do
        b,e = string.find(string.lower(string.gsub(getPlayerName(player), "#%x%x%x%x%x%x", "")), namePart)
        if b and e then
            if e-b > bestaccuracy then
                bestaccuracy = e-b
                foundPlayer = player
            end
        end
    end

    if (foundPlayer) then
        return foundPlayer
    else
        return false
    end
end

local achiveTableDataNames =  {
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
    ["Famous rich man"] = {"achive19"}}

--Table's
avatarPfad = {
    "files/images/avatar/alien.png",
    "files/images/avatar/alien2.png",
    "files/images/avatar/alienglubsch.png",
    "files/images/avatar/angrybird.png",
    "files/images/avatar/applejack.png",
    "files/images/avatar/aquaheart.png",
    "files/images/avatar/atomic.png",
    "files/images/avatar/banana.png",
    "files/images/avatar/birne.png",
    "files/images/avatar/bobmarley.png",
    "files/images/avatar/brazil.png",
    "files/images/avatar/cobra.png",
    "files/images/avatar/deagle.png",
    "files/images/avatar/dislike.png",
    "files/images/avatar/ReWrite.png",
    "files/images/avatar/Nick.png",
    "files/images/avatar/MrSir.png",
    "files/images/avatar/fire.png",
    "files/images/avatar/frankenstein.png",
    "files/images/avatar/germany.png",
    "files/images/avatar/gta.png",
    "files/images/avatar/HammerSmiley.png",
    "files/images/avatar/hellokitty.png",
    "files/images/avatar/highsmiley.png",
    "files/images/avatar/HorrorClown.png",
    "files/images/avatar/ironman.png",
    "files/images/avatar/jack_skellington.png",
    "files/images/avatar/kuh.png",
    "files/images/avatar/luigi.png",
	"files/images/avatar/MaliBu.png",
    "files/images/avatar/monkey.png",
    "files/images/avatar/mushroom.png",
    "files/images/avatar/netherland.png",
    "files/images/avatar/network.png",
    "files/images/avatar/pedobaer.png",
    "files/images/avatar/pokeball.png",
    "files/images/avatar/portugal.png",
    "files/images/avatar/Pyro.png",
    "files/images/avatar/redgirl.png",
    "files/images/avatar/shockface.png",
    "files/images/avatar/smile1.png",
    "files/images/avatar/smile2.png",
    "files/images/avatar/smile3.png",
    "files/images/avatar/smile4.png",
    "files/images/avatar/smile5.png",
    "files/images/avatar/smile6.png",
    "files/images/avatar/smile7.png",
    "files/images/avatar/smile8.png",
    "files/images/avatar/smile9.png",
    "files/images/avatar/smile10.png",
    "files/images/avatar/smile11.png",
    "files/images/avatar/smile12.png",
    "files/images/avatar/smile13.png",
    "files/images/avatar/smile14.png",
    "files/images/avatar/smile15.png",
    "files/images/avatar/smile16.png",
    "files/images/avatar/smile17.png",
    "files/images/avatar/smile18.png",
    "files/images/avatar/smile19.png",
    "files/images/avatar/smile20.png",
    "files/images/avatar/smile21.png",
    "files/images/avatar/smile22.png",
    "files/images/avatar/smile23.png",
    "files/images/avatar/smile24.png",
    "files/images/avatar/smile25.png",
    "files/images/avatar/smile26.png",
    "files/images/avatar/smile27.png",
    "files/images/avatar/smile28.png",
    "files/images/avatar/smile29.png",
    "files/images/avatar/smile30.png",
    "files/images/avatar/smile31.png",
    "files/images/avatar/smile32.png",
    "files/images/avatar/smile33.png",
    "files/images/avatar/smile34.png",
    "files/images/avatar/smile35.png",
    "files/images/avatar/smile36.png",
    "files/images/avatar/smile37.png",
    "files/images/avatar/smile38.png",
    "files/images/avatar/smile39.png",
    "files/images/avatar/smile40.png",
    "files/images/avatar/smile41.png",
    "files/images/avatar/smile42.png",
    "files/images/avatar/smile43.png",
    "files/images/avatar/smile44.png",
    "files/images/avatar/smile45.png",
    "files/images/avatar/smile46.png",
    "files/images/avatar/smile47.png",
    "files/images/avatar/smile48.png",
    "files/images/avatar/smile49.png",
    "files/images/avatar/smile50.png",
    "files/images/avatar/smile51.png",
    "files/images/avatar/smile52.png",
    "files/images/avatar/smile53.png",
    "files/images/avatar/smile54.png",
    "files/images/avatar/smile55.png",
    "files/images/avatar/smile56.png",
    "files/images/avatar/smile57.png",
    "files/images/avatar/smile58.png",
    "files/images/avatar/smile59.png",
    "files/images/avatar/smile60.png",
    "files/images/avatar/smile61.png",
    "files/images/avatar/smile62.png",
    "files/images/avatar/smile63.png",
    "files/images/avatar/smile64.png",
    "files/images/avatar/smile65.png",
    "files/images/avatar/smile66.png",
    "files/images/avatar/smile67.png",
    "files/images/avatar/smile68.png",
    "files/images/avatar/smile69.png",
    "files/images/avatar/smile70.png",
    "files/images/avatar/smile71.png",
    "files/images/avatar/smile72.png",
    "files/images/avatar/smile73.png",
    "files/images/avatar/smile74.png",
    "files/images/avatar/smile75.png",
    "files/images/avatar/smile76.png",
    "files/images/avatar/smile77.png",
    "files/images/avatar/smile78.png",
    "files/images/avatar/smile79.png",
    "files/images/avatar/smile80.png",
    "files/images/avatar/spongebob.png",
    "files/images/avatar/summsumm.png",
    "files/images/avatar/Triforce.png",
    "files/images/avatar/turkey.png",
    "files/images/avatar/uglybird.png",
    "files/images/avatar/usa.png",
    "files/images/avatar/USK18.png",
    "files/images/avatar/vision.png",
    "files/images/avatar/Vincent1896.png",
    "files/images/avatar/weed.png",
    "files/images/avatar/yoshi.png",
    "files/images/avatar/zelda.png"
}

--achivements--
local achiveTable =  {
    ["Fucking Noob"] = {"Die more than \n200 times."},
    ["Noob Racer"] = {"Win one race."},
    ["COLOR FTW"] = {"Buy vehiclecolor."},
    ["REEEEED MAN"] = {"Paint your vehicle pure red."},
    ["Millionaire"] = {"Get 1.000.000 $"},
    ["Get a Million"] = {"Get 500.000 $"},
    ["Get Started"] = {"Login for the first time"},
    ["TOP HUNTER"] = {"Win 750 Races"},
    ["Pro Racer"] = {"Win 100 Races and be level 10"},
    ["I like Rainbows"] = {"Buy Rainbow \nColor."},
    ["Can u own me ?"] = {"Drive more than \n5.555 Races."},
    ["Legend"] = {"Your playtime musst \nbe higher than 17.500"},
    ["Rich man"] = {"Donate more than 500.000 $ \nin the whole time."},
    ["Speeder"] = {"Drive faster than 650 km/h"},
    ["Swimming Prof"] = {"Die more than \n1.000 times"},
    ["Like meh."] = {"Get 20 Toptimes"},
    ["Famous rich man"] = {"Earn more \nthan 1.000.000 $"}}
--end achivements--

-----------------------Guis----------
local GUIEditor_Window = {}
local GUIEditor_Button = {}
local GUIEditor_Label = {}
local GUIEditor_Image = {}
local GUIEditor_Edit = {}
local GUIEditor_GridList = {}
local ltfontmiddle = guiCreateFont( "files/fonts/calibrii.ttf", 16 )
local ltfontspecialMiddle = guiCreateFont( "files/fonts/calibrii.ttf", 14 )
local ltfontspecialBig = guiCreateFont( "files/fonts/calibrii.ttf", 26 )
local ltfontspecial = guiCreateFont( "files/fonts/calibrii.ttf", 12 )
local ltfontspecialVeryBig = guiCreateFont( "files/fonts/calibrii.ttf", 32 )

-----##-----------------------------------------------++------------
--EXTRA FUNCTION FOR SMOOTH GUI WINDOWS
local visibleElement
local visibleBool
function guiSetSlowVisible(element, bool)
    if (element) then
        local bool = bool or false
        if (isElement(element)) then
            if (bool == false) then
                local visible = guiGetVisible(element)
                if (visible) then
                    visibleBool = bool
                    visibleElement = element
                    addEventHandler("onClientRender", root, guiSmoothVisible)
                    return true
                else
                    outputDebugString ( "guiSetSlowVisible - Element already invisible", 0, 112, 112, 112 )
                    return false
                end
            elseif (bool == true) then
                local visible = guiGetVisible(element)
                if not (visible) then
                    guiSetVisible(element, true)
                    guiSetAlpha(element, 0)
                    visibleBool = bool
                    visibleElement = element
                    addEventHandler("onClientRender", root, guiSmoothVisible)
                    return true
                else
                    outputDebugString ( "guiSetSlowVisible - Element already invisible", 0, 112, 112, 112 )
                    return false
                end
            else
                outputDebugString ( "guiSetSlowVisible - Bad element pointer", 0, 112, 112, 112 )
                return false
            end
        else
            outputDebugString ( "guiSetSlowVisible - Given element pointer is not an element", 0, 112, 112, 112 )
            return false
        end
    else
        outputDebugString ( "guiSetSlowVisible - Missing argument", 0, 112, 112, 112 )
        return false
    end
end

local smoothInvisible = 1
local smoothVisible = 0
function guiSmoothVisible()
    local bool = visibleBool
    local element = visibleElement
    if (bool == true) then
        if not (smoothVisible >= 1) then
            local test1 = guiSetAlpha(element, smoothVisible)
            smoothVisible = smoothVisible + 0.05
        else
            smoothVisible = 0
            removeEventHandler("onClientRender", root, guiSmoothVisible)
        end
    else
        if not (smoothInvisible <= 0) then
            local test2 = guiSetAlpha(element, smoothInvisible)
            smoothInvisible = smoothInvisible -0.04
        else
            guiSetVisible(element, false)
            smoothVisible = 1
            removeEventHandler("onClientRender", root, guiSmoothVisible)
        end
    end
end
-----##-----------------------------------------------++------------

addEventHandler("onDownloadFinished",resroot,
    function()
    --------------------------Stats--------------------------
    --General
        GUIEditor_Window[2] = guiCreateStaticImage(0,0,1,0.907,"files/images/environment/background.png",true)
        guiCreateStaticImage(0,0,1,0.025,"files/images/environment/tab.png",true,GUIEditor_Window[2])
        GUIEditor_Label[1] = guiCreateLabel(0.025,0.2000,0.3811,0.1245,"General",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[1],255,153,0)
        guiSetFont(GUIEditor_Label[1],ltfontspecialBig)
        GUIEditor_Label[2] = guiCreateLabel(0.025,0.2500,0.3811,0.1245,"Cash:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[2],255,153,0)
        guiSetFont(GUIEditor_Label[2],ltfontspecialMiddle)
        GUIEditor_Label[3] = guiCreateLabel(0.025,0.2800,0.3811,0.1245,"Toptimes:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[3],255,153,0)
        guiSetFont(GUIEditor_Label[3],ltfontspecialMiddle)
        GUIEditor_Label[4] = guiCreateLabel(0.025,0.3100,0.3811,0.1245,"Level:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[4],255,153,0)
        guiSetFont(GUIEditor_Label[4],ltfontspecialMiddle)
        GUIEditor_Label[5] = guiCreateLabel(0.025,0.3400,0.3811,0.1245,"Playtime:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[5],255,153,0)
        guiSetFont(GUIEditor_Label[5],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.025,0.3700,0.3811,0.1245,"DM:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.025,0.4000,0.3811,0.1245,"DD:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.025,0.4300,0.3811,0.1245,"Jointimes:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)
        GUIEditor_Label[7] = guiCreateLabel(0.025,0.4600,0.3811,0.1245,"Mapsfinished:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[7],255,153,0)
        guiSetFont(GUIEditor_Label[7],ltfontspecialMiddle)
        --GUIEditor_Label[7] = guiCreateLabel(0.025,0.4900,0.3811,0.1245,"Funareakills:",true,GUIEditor_Window[2])
        --guiLabelSetColor(GUIEditor_Label[7],255,153,0)
        --guiSetFont(GUIEditor_Label[7],ltfontspecialMiddle)
        nameStatsLabel = guiCreateLabel(0.475,0.1000,0.3811,0.1245,"No Player",true,GUIEditor_Window[2])
        guiLabelSetColor(nameStatsLabel,255,153,0)
        guiSetFont(nameStatsLabel,ltfontspecialBig)
        cashStatsLabel = guiCreateLabel(0.25,0.2500,0.3811,0.1245,"No Player",true,GUIEditor_Window[2])
        guiLabelSetColor(cashStatsLabel,255,255,255)
        guiSetFont(cashStatsLabel,ltfontspecialMiddle)
        toptimesStatsLabel = guiCreateLabel(0.25,0.2800,0.3811,0.1245,"No Player",true,GUIEditor_Window[2])
        guiLabelSetColor(toptimesStatsLabel,255,255,255)
        guiSetFont(toptimesStatsLabel,ltfontspecialMiddle)
        levelStatsLabel = guiCreateLabel(0.25,0.3100,0.3811,0.1245,"No Player",true,GUIEditor_Window[2])
        guiLabelSetColor(levelStatsLabel,255,255,255)
        guiSetFont(levelStatsLabel,ltfontspecialMiddle)
        playtimeStatsLabel = guiCreateLabel(0.25,0.3400,0.3811,0.1245,"No Player",true,GUIEditor_Window[2])
        guiLabelSetColor(playtimeStatsLabel,255,255,255)
        guiSetFont(playtimeStatsLabel,ltfontspecialMiddle)
        DMStatsLabel = guiCreateLabel(0.25,0.3700,0.3811,0.1245,"No Player",true,GUIEditor_Window[2])
        guiLabelSetColor(DMStatsLabel,255,255,255)
        guiSetFont(DMStatsLabel,ltfontspecialMiddle)
        DDStatsLabel = guiCreateLabel(0.25,0.4000,0.3811,0.1245,"No Player",true,GUIEditor_Window[2])
        guiLabelSetColor(DDStatsLabel,255,255,255)
        guiSetFont(DDStatsLabel,ltfontspecialMiddle)
        jointimesStatsLabel = guiCreateLabel(0.25,0.4300,0.3811,0.1245,"No Player",true,GUIEditor_Window[2])
        guiLabelSetColor(jointimesStatsLabel,255,255,255)
        guiSetFont(jointimesStatsLabel,ltfontspecialMiddle)
        hunterStatsLabel = guiCreateLabel(0.25,0.4600,0.3811,0.1245,"No Player",true,GUIEditor_Window[2])
        guiLabelSetColor(hunterStatsLabel,255,255,255)
        guiSetFont(hunterStatsLabel,ltfontspecialMiddle)
        --funareaStatsLabel = guiCreateLabel(0.25,0.4900,0.3811,0.1245,"No Player",true,GUIEditor_Window[2])
        --guiLabelSetColor(funareaStatsLabel,255,255,255)
        --guiSetFont(funareaStatsLabel,ltfontspecialMiddle)
        avatarStatsImage = guiCreateStaticImage(0.2400,0.05,0.175,0.175,"files/images/environment/star.png",true,GUIEditor_Window[2])
        --Shop Items
        GUIEditor_Label[1] = guiCreateLabel(0.025,0.5000+0.1,0.3811,0.1245,"Shop Items",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[1],255,153,0)
        guiSetFont(GUIEditor_Label[1],ltfontspecialBig)
        GUIEditor_Label[2] = guiCreateLabel(0.025,0.5500+0.1,0.3811,0.1245,"Vehiclecolor:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[2],255,153,0)
        guiSetFont(GUIEditor_Label[2],ltfontspecialMiddle)
        --GUIEditor_Label[3] = guiCreateLabel(0.025,0.5800+0.1,0.3811,0.1245,"Chatcolor:",true,GUIEditor_Window[2])
        --guiLabelSetColor(GUIEditor_Label[3],255,153,0)
        --guiSetFont(GUIEditor_Label[3],ltfontspecialMiddle)
        GUIEditor_Label[4] = guiCreateLabel(0.025,0.6100+0.1,0.1911,0.1245,"Wintext:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[4],255,153,0)
        guiSetFont(GUIEditor_Label[4],ltfontspecialMiddle)
        GUIEditor_Label[5] = guiCreateLabel(0.025,0.6400+0.1,0.1911,0.1245,"Joinmessage:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[5],255,153,0)
        guiSetFont(GUIEditor_Label[5],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.025,0.6700+0.1,0.3811,0.1245,"Wheels:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.025,0.7000+0.1,0.3811,0.1245,"Status:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.025,0.5800+0.1,0.3811,0.1245,"Rainbowcolor:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)
        vcolorStatsLabel = guiCreateLabel(0.25,0.5500+0.1,0.3811,0.1245,"No Player",true,GUIEditor_Window[2])
        guiLabelSetColor(vcolorStatsLabel,255,255,255)
        guiSetFont(vcolorStatsLabel,ltfontspecialMiddle)

        rainbowStatsLabel = guiCreateLabel(0.25,0.5800+0.1,0.3811,0.1245,"No Player",true,GUIEditor_Window[2])
        guiLabelSetColor(rainbowStatsLabel,255,255,255)
        guiSetFont(rainbowStatsLabel,ltfontspecialMiddle)

        wintextStatsLabel = guiCreateLabel(0.25,0.6100+0.1,0.1911,0.1245,"No Player",true,GUIEditor_Window[2])
        guiLabelSetColor(wintextStatsLabel,255,255,255)
        guiSetFont(wintextStatsLabel,ltfontspecialMiddle)
        joinmessageStatsLabel = guiCreateLabel(0.25,0.6400+0.1,0.1911,0.1245,"No Player",true,GUIEditor_Window[2])
        guiLabelSetColor(joinmessageStatsLabel,255,255,255)
        guiSetFont(joinmessageStatsLabel,ltfontspecialMiddle)
        WheelsStatsLabel = guiCreateLabel(0.25,0.6700+0.1,0.3811,0.1245,"No Player",true,GUIEditor_Window[2])
        guiLabelSetColor(WheelsStatsLabel,255,255,255)
        guiSetFont(WheelsStatsLabel,ltfontspecialMiddle)
        StatusStatsLabel = guiCreateLabel(0.25,0.7000+0.1,0.3811,0.1245,"No Player",true,GUIEditor_Window[2])
        guiLabelSetColor(StatusStatsLabel,255,255,255)
        guiSetFont(StatusStatsLabel,ltfontspecialMiddle)
        --Achivements --------------------------------------------------------------------------------------------------------Adden wenn neues Achivement geadded wird Marwinius !!!!!!
        GUIEditor_Label[1] = guiCreateLabel(0.45,0.2000,0.3811,0.1245,"Achievements",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[1],255,153,0)
        guiSetFont(GUIEditor_Label[1],ltfontspecialBig)
        GUIEditor_Label[2] = guiCreateLabel(0.45,0.2500,0.3811,0.1245,"Fucking Noob:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[2],255,153,0)
        guiSetFont(GUIEditor_Label[2],ltfontspecialMiddle)
        GUIEditor_Label[3] = guiCreateLabel(0.45,0.2800,0.3811,0.1245,"Noob Racer:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[3],255,153,0)
        guiSetFont(GUIEditor_Label[3],ltfontspecialMiddle)
        GUIEditor_Label[4] = guiCreateLabel(0.45,0.3100,0.3811,0.1245,"COLOR FTW:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[4],255,153,0)
        guiSetFont(GUIEditor_Label[4],ltfontspecialMiddle)
        GUIEditor_Label[5] = guiCreateLabel(0.45,0.3400,0.3811,0.1245,"REEEEED MAN:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[5],255,153,0)
        guiSetFont(GUIEditor_Label[5],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.45,0.3700,0.3811,0.1245,"Millionaire:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.45,0.4000,0.3811,0.1245,"Get a Million:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.45,0.4300,0.3811,0.1245,"Get Started:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.45,0.4600,0.3811,0.1245,"TOP HUNTER:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.45,0.4900,0.3811,0.1245,"Pro Racer:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.45,0.5200,0.3811,0.1245,"I like Rainbows:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.45,0.5500,0.3811,0.1245,"Can u own me ?:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.45,0.5800,0.3811,0.1245,"Legend:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.45,0.6100,0.3811,0.1245,"Rich man:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.45,0.6400,0.3811,0.1245,"Speeder:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.45,0.6700,0.3811,0.1245,"Swimming Prof:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.45,0.7000,0.3811,0.1245,"Like meh.:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)
        GUIEditor_Label[6] = guiCreateLabel(0.45,0.7300,0.3811,0.1245,"Famous rich man:",true,GUIEditor_Window[2])
        guiLabelSetColor(GUIEditor_Label[6],255,153,0)
        guiSetFont(GUIEditor_Label[6],ltfontspecialMiddle)

        achive1StatsLabel = guiCreateLabel(0.65,0.2500,0.3811,0.1245,"()",true,GUIEditor_Window[2])
        guiLabelSetColor(achive1StatsLabel,255,255,255)
        guiSetFont(achive1StatsLabel,ltfontspecialMiddle)
        achive2StatsLabel = guiCreateLabel(0.65,0.2800,0.3811,0.1245,"()",true,GUIEditor_Window[2])
        guiLabelSetColor(achive2StatsLabel,255,255,255)
        guiSetFont(achive2StatsLabel,ltfontspecialMiddle)
        achive3StatsLabel = guiCreateLabel(0.65,0.3100,0.3811,0.1245,"()",true,GUIEditor_Window[2])
        guiLabelSetColor(achive3StatsLabel,255,255,255)
        guiSetFont(achive3StatsLabel,ltfontspecialMiddle)
        achive4StatsLabel = guiCreateLabel(0.65,0.3400,0.3811,0.1245,"()",true,GUIEditor_Window[2])
        guiLabelSetColor(achive4StatsLabel,255,255,255)
        guiSetFont(achive4StatsLabel,ltfontspecialMiddle)
        achive5StatsLabel = guiCreateLabel(0.65,0.3700,0.3811,0.1245,"()",true,GUIEditor_Window[2])
        guiLabelSetColor(achive5StatsLabel,255,255,255)
        guiSetFont(achive5StatsLabel,ltfontspecialMiddle)
        achive6StatsLabel = guiCreateLabel(0.65,0.4000,0.3811,0.1245,"()",true,GUIEditor_Window[2])
        guiLabelSetColor(achive6StatsLabel,255,255,255)
        guiSetFont(achive6StatsLabel,ltfontspecialMiddle)
        achive7StatsLabel = guiCreateLabel(0.65,0.4300,0.3811,0.1245,"()",true,GUIEditor_Window[2])
        guiLabelSetColor(achive7StatsLabel,255,255,255)
        guiSetFont(achive7StatsLabel,ltfontspecialMiddle)
        achive8StatsLabel = guiCreateLabel(0.65,0.4600,0.3811,0.1245,"()",true,GUIEditor_Window[2])
        guiLabelSetColor(achive8StatsLabel,255,255,255)
        guiSetFont(achive8StatsLabel,ltfontspecialMiddle)
        achive9StatsLabel = guiCreateLabel(0.65,0.4900,0.3811,0.1245,"()",true,GUIEditor_Window[2])
        guiLabelSetColor(achive9StatsLabel,255,255,255)
        guiSetFont(achive9StatsLabel,ltfontspecialMiddle)
        achive10StatsLabel = guiCreateLabel(0.65,0.5200,0.3811,0.1245,"()",true,GUIEditor_Window[2]) --
        guiLabelSetColor(achive10StatsLabel,255,255,255)
        guiSetFont(achive10StatsLabel,ltfontspecialMiddle)
        achive11StatsLabel = guiCreateLabel(0.65,0.5500,0.3811,0.1245,"()",true,GUIEditor_Window[2]) --
        guiLabelSetColor(achive11StatsLabel,255,255,255)
        guiSetFont(achive11StatsLabel,ltfontspecialMiddle)
        achive12StatsLabel = guiCreateLabel(0.65,0.5800,0.3811,0.1245,"()",true,GUIEditor_Window[2]) --
        guiLabelSetColor(achive12StatsLabel,255,255,255)
        guiSetFont(achive12StatsLabel,ltfontspecialMiddle)
        achive13StatsLabel = guiCreateLabel(0.65,0.6100,0.3811,0.1245,"()",true,GUIEditor_Window[2]) --
        guiLabelSetColor(achive13StatsLabel,255,255,255)
        guiSetFont(achive13StatsLabel,ltfontspecialMiddle)
        achive14StatsLabel = guiCreateLabel(0.65,0.6400,0.3811,0.1245,"()",true,GUIEditor_Window[2]) --
        guiLabelSetColor(achive14StatsLabel,255,255,255)
        guiSetFont(achive14StatsLabel,ltfontspecialMiddle)
        achive15StatsLabel = guiCreateLabel(0.65,0.6700,0.3811,0.1245,"()",true,GUIEditor_Window[2]) --
        guiLabelSetColor(achive15StatsLabel,255,255,255)
        guiSetFont(achive15StatsLabel,ltfontspecialMiddle)
        achive16StatsLabel = guiCreateLabel(0.65,0.7000,0.3811,0.1245,"()",true,GUIEditor_Window[2]) --
        guiLabelSetColor(achive16StatsLabel,255,255,255)
        guiSetFont(achive16StatsLabel,ltfontspecialMiddle)
        achive17StatsLabel = guiCreateLabel(0.65,0.7300,0.3811,0.1245,"()",true,GUIEditor_Window[2]) --
        guiLabelSetColor(achive17StatsLabel,255,255,255)
        guiSetFont(achive17StatsLabel,ltfontspecialMiddle)
        --------------------------buy options--------------------------
        GUIEditor_Window[3] = guiCreateStaticImage(0,0,1,0.907,"files/images/environment/background.png",true)
        guiCreateStaticImage(0,0,1,0.025,"files/images/environment/tab.png",true,GUIEditor_Window[3])
        GUIEditor_Label[200] = guiCreateLabel(0.0258,0.0589,0.252,0.1159,"Settings",true,GUIEditor_Window[3])
        guiLabelSetColor(GUIEditor_Label[200],255,153,0)
        guiSetFont(GUIEditor_Label[200],ltfontspecialBig)
        ---------------------------------------
        GUIEditor_Label[15] = guiCreateLabel(0.0258,0.185,0.1712,0.0649,"Vehiclecolor",true,GUIEditor_Window[3])
        guiLabelSetColor(GUIEditor_Label[15],255,153,0)
        guiSetFont(GUIEditor_Label[15],ltfontmiddle)
        GUIEditor_Label[18] = guiCreateLabel(0.0258,0.2724,0.0738,0.0487,"Red",true,GUIEditor_Window[3])
        guiLabelSetColor(GUIEditor_Label[18],255,0,0)
        guiSetFont(GUIEditor_Label[18],ltfontmiddle)
        GUIEditor_Label[19] = guiCreateLabel(0.0258,0.313,0.0738,0.0487,"Green",true,GUIEditor_Window[3])
        guiLabelSetColor(GUIEditor_Label[19],0,255,0)
        guiSetFont(GUIEditor_Label[19],ltfontmiddle)
        GUIEditor_Label[20] = guiCreateLabel(0.0258,0.3516,0.0738,0.0487,"Blue",true,GUIEditor_Window[3])
        guiLabelSetColor(GUIEditor_Label[20],0,0,255)
        guiSetFont(GUIEditor_Label[20],ltfontmiddle)
        GUIEditor_Edit[2] = guiCreateEdit(0.1000,0.2703,0.091,0.0386,"0",true,GUIEditor_Window[3])
        GUIEditor_Edit[3] = guiCreateEdit(0.1000,0.3089,0.091,0.0386,"0",true,GUIEditor_Window[3])
        GUIEditor_Edit[4] = guiCreateEdit(0.1000,0.3476,0.091,0.0386,"0",true,GUIEditor_Window[3])
        guiEditSetMaxLength(GUIEditor_Edit[2], 3)
        guiEditSetMaxLength(GUIEditor_Edit[3], 3)
        guiEditSetMaxLength(GUIEditor_Edit[4], 3)
        GUIEditor_Label[201] = guiCreateLabel(0.0258,0.225,0.1953,0.0325,"-Color",true,GUIEditor_Window[3])
        guiSetFont(GUIEditor_Label[201],ltfontspecial)
        GUIEditor_Button[6] = guiCreateButton(0.1000,0.3905,0.045,0.0386,"1",true,GUIEditor_Window[3])
        guiSetFont(GUIEditor_Button[6],ltfontspecial)
        GUIEditor_Button[77] = guiCreateButton(0.1460,0.3905,0.045,0.0386,"2",true,GUIEditor_Window[3])
        guiSetFont(GUIEditor_Button[77],ltfontspecial)
        --------------------------------------------------------------
        GUIEditor_Label[204] = guiCreateLabel(0.0258,0.7585,0.1293,0.0589,"-Custom Variables\n-Use Colorcodes\n-40 Characters",true,GUIEditor_Window[3])
        guiSetFont(GUIEditor_Label[204],ltfontspecial)
        GUIEditor_Label[16] = guiCreateLabel(0.0258,0.7215,0.1712,0.0649,"Wintext",true,GUIEditor_Window[3])
        guiLabelSetColor(GUIEditor_Label[16],255,153,0)
        guiSetFont(GUIEditor_Label[16],ltfontmiddle)
        wintextInfo = guiCreateStaticImage(0.0258+0.1235,0.8044,0.015,0.015,"files/images/environment/help.png",true,GUIEditor_Window[3])
        addEventHandler("onClientMouseEnter",wintextInfo,showWintextInfo,false)
        addEventHandler("onClientMouseLeave",wintextInfo,removeWintextInfo,false)
        GUIEditor_Edit[5] = guiCreateEdit(0.0258,0.8194,0.1385,0.0487,"",true,GUIEditor_Window[3])
        guiEditSetMaxLength(GUIEditor_Edit[5], 40)
        GUIEditor_Button[7] = guiCreateButton(0.0258,0.87,0.1385,0.0487,"Set",true,GUIEditor_Window[3])
        guiSetFont(GUIEditor_Button[7],ltfontspecial)
        ----------------------------------------------------------------
        GUIEditor_Label[167] = guiCreateLabel(0.2443,0.7585,0.1293,0.0589,"-Use Colorcodes\n-70 Characters",true,GUIEditor_Window[3])
        guiSetFont(GUIEditor_Label[167],ltfontspecial)
        GUIEditor_Label[250] = guiCreateLabel(0.2443,0.7215,0.1712,0.0549,"Joinmsg",true,GUIEditor_Window[3])
        guiLabelSetColor(GUIEditor_Label[250],255,153,0)
        guiSetFont(GUIEditor_Label[250],ltfontmiddle)
        GUIEditor_Edit[14] = guiCreateEdit(0.2443,0.8194,0.1385,0.0487,"",true,GUIEditor_Window[3])
        guiEditSetMaxLength(GUIEditor_Edit[14], 70)
        GUIEditor_Button[33] = guiCreateButton(0.2443,0.87,0.1385,0.0487,"Set",true,GUIEditor_Window[3])
        guiSetFont(GUIEditor_Button[33],ltfontspecial)
        -----------------------------------------------------------------
        GUIEditor_Label[203] = guiCreateLabel(0.0258,0.45,0.1712,0.0649,"Chatcolor",true,GUIEditor_Window[3])
        guiLabelSetColor(GUIEditor_Label[203],255,153,0)
        guiSetFont(GUIEditor_Label[203],ltfontmiddle)
        GUIEditor_Label[213] = guiCreateLabel(0.0258,0.5424,0.0738,0.0487,"Red",true,GUIEditor_Window[3])
        guiLabelSetColor(GUIEditor_Label[213],255,0,0)
        guiSetFont(GUIEditor_Label[213],ltfontmiddle)
        GUIEditor_Label[211] = guiCreateLabel(0.0258,0.5824,0.0738,0.0487,"Green",true,GUIEditor_Window[3])
        guiLabelSetColor(GUIEditor_Label[211],0,255,0)
        guiSetFont(GUIEditor_Label[211],ltfontmiddle)
        GUIEditor_Label[212] = guiCreateLabel(0.0258,0.6234,0.0738,0.0487,"Blue",true,GUIEditor_Window[3])
        guiLabelSetColor(GUIEditor_Label[212],0,0,255)
        guiSetFont(GUIEditor_Label[212],ltfontmiddle)
        GUIEditor_Edit[11] = guiCreateEdit(0.1000,0.5424,0.091,0.0386,"0",true,GUIEditor_Window[3])
        GUIEditor_Edit[12] = guiCreateEdit(0.1000,0.5824,0.091,0.0386,"0",true,GUIEditor_Window[3])
        GUIEditor_Edit[13] = guiCreateEdit(0.1000,0.6234,0.091,0.0386,"0",true,GUIEditor_Window[3])
        guiEditSetMaxLength(GUIEditor_Edit[11], 3)
        guiEditSetMaxLength(GUIEditor_Edit[12], 3)
        guiEditSetMaxLength(GUIEditor_Edit[13], 3)
        GUIEditor_Label[213] = guiCreateLabel(0.0258,0.49,0.1953,0.0325,"-Color",true,GUIEditor_Window[3])
        guiSetFont(GUIEditor_Label[213],ltfontspecial)
        GUIEditor_Button[214] = guiCreateButton(0.1000,0.6665,0.091,0.0386,"Set",true,GUIEditor_Window[3])
        guiSetFont(GUIEditor_Button[214],ltfontspecial)
        ---------------------------------------------------------------------
        GUIEditor_Label[205] = guiCreateLabel(0.2443,0.1789,0.1512,0.0549,"Wheels",true,GUIEditor_Window[3])
        guiLabelSetColor(GUIEditor_Label[205],255,153,0)
        guiSetFont(GUIEditor_Label[205],ltfontmiddle)
        GUIEditor_Label[206] = guiCreateLabel(0.2443,0.2114,0.1953,0.0325,"-Choose your Wheels",true,GUIEditor_Window[3])
        guiSetFont(GUIEditor_Label[206],ltfontspecial)
        GUIEditor_GridList[350] = guiCreateGridList(0.2443,0.252,0.1517,0.3175,true,GUIEditor_Window[3])
        GUIEditor_GridList[300] = guiGridListAddColumn (GUIEditor_GridList[350],"Wheels",0.8 )
        GUIEditor_GridList[301] = guiGridListAddRow (GUIEditor_GridList[350])
        GUIEditor_GridList[302] = guiGridListAddRow (GUIEditor_GridList[350])
        GUIEditor_GridList[303] = guiGridListAddRow (GUIEditor_GridList[350])
        GUIEditor_GridList[304] = guiGridListAddRow (GUIEditor_GridList[350])
        GUIEditor_GridList[305] = guiGridListAddRow (GUIEditor_GridList[350])
        GUIEditor_GridList[306] = guiGridListAddRow (GUIEditor_GridList[350])
        GUIEditor_GridList[307] = guiGridListAddRow (GUIEditor_GridList[350])
        GUIEditor_GridList[308] = guiGridListAddRow (GUIEditor_GridList[350])
        GUIEditor_GridList[309] = guiGridListAddRow (GUIEditor_GridList[350])
        GUIEditor_GridList[310] = guiGridListAddRow (GUIEditor_GridList[350])
        GUIEditor_GridList[311] = guiGridListAddRow (GUIEditor_GridList[350])
        GUIEditor_GridList[312] = guiGridListAddRow (GUIEditor_GridList[350])
        GUIEditor_GridList[313] = guiGridListAddRow (GUIEditor_GridList[350])
        GUIEditor_GridList[314] = guiGridListAddRow (GUIEditor_GridList[350])
        GUIEditor_GridList[315] = guiGridListAddRow (GUIEditor_GridList[350])
        GUIEditor_GridList[316] = guiGridListAddRow (GUIEditor_GridList[350])
        GUIEditor_GridList[317] = guiGridListAddRow (GUIEditor_GridList[350])
        guiGridListSetItemText ( GUIEditor_GridList[350], GUIEditor_GridList[301], GUIEditor_GridList[300], "Shadow", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[350], GUIEditor_GridList[302], GUIEditor_GridList[300], "Mega", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[350], GUIEditor_GridList[303], GUIEditor_GridList[300], "Rimshine", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[350], GUIEditor_GridList[304], GUIEditor_GridList[300], "Wires", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[350], GUIEditor_GridList[305], GUIEditor_GridList[300], "Classic", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[350], GUIEditor_GridList[306], GUIEditor_GridList[300], "Twist", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[350], GUIEditor_GridList[307], GUIEditor_GridList[300], "Cutter", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[350], GUIEditor_GridList[308], GUIEditor_GridList[300], "Switch", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[350], GUIEditor_GridList[309], GUIEditor_GridList[300], "Grove", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[350], GUIEditor_GridList[310], GUIEditor_GridList[300], "Import", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[350], GUIEditor_GridList[311], GUIEditor_GridList[300], "Dollar", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[350], GUIEditor_GridList[312], GUIEditor_GridList[300], "Trance", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[350], GUIEditor_GridList[313], GUIEditor_GridList[300], "Atomic", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[350], GUIEditor_GridList[314], GUIEditor_GridList[300], "Ahab", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[350], GUIEditor_GridList[315], GUIEditor_GridList[300], "Virtual", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[350], GUIEditor_GridList[316], GUIEditor_GridList[300], "Access", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[350], GUIEditor_GridList[317], GUIEditor_GridList[300], "Offroad", false, false )
        GUIEditor_Button[178] = guiCreateButton(0.2443,0.5720,0.1517,0.0550,"Set",true,GUIEditor_Window[3])
        guiSetFont(GUIEditor_Button[178],ltfontspecial)
        wheelsresetbutton = guiCreateButton(0.2443,0.63,0.1517,0.0550,"Reset",true,GUIEditor_Window[3])
        guiSetFont(wheelsresetbutton,ltfontspecial)
        -------------------###---------------
        --Settings

        GUIEditor_Label[222] = guiCreateButton(0.6443,	0.86,0.1517,0.0550,"Camerafade on Death",true,GUIEditor_Window[3])
        --GUIEditor_Label[224] = guiCreateButton(0.6443,	0.80,0.1517,0.0550,"Infernus Mod",true,GUIEditor_Window[3])
        rainbowcoloronoff = guiCreateButton(0.6443,		0.74,0.1517,0.0550,"Rainbowcolor",true,GUIEditor_Window[3])
        watershader = guiCreateButton(0.6443,			0.68,0.1517,0.0550,"Water effect",true,GUIEditor_Window[3])
        carshader = guiCreateButton(0.6443,				0.62,0.1517,0.0550,"Carpaint effect",true,GUIEditor_Window[3])
        roadshader = guiCreateButton(0.6443,			0.56,0.1517,0.0550,"Roadshine effect",true,GUIEditor_Window[3])
        hdshader = guiCreateButton(0.6443,				0.50,0.1517,0.0550,"HD effect",true,GUIEditor_Window[3])
        bPH = guiCreateButton(0.6443,				0.44,0.1517,0.0550,"Pulsating Headlights",true,GUIEditor_Window[3])
        bAB = guiCreateButton(0.6443,					0.38,0.1517,0.0550,"Toggle Anti Bounce",true,GUIEditor_Window[3])

        guiSetProperty(watershader, "Disabled", "True")
        guiSetProperty(carshader, "Disabled", "True")
        guiSetProperty(roadshader, "Disabled", "True")
        guiSetProperty(hdshader, "Disabled", "True")

        --Avatars
        avatarlabel1 = guiCreateLabel(0.4443,0.41,0.1512,0.0549,"Avatar",true,GUIEditor_Window[3])
        guiLabelSetColor(avatarlabel1,255,153,0)
        guiSetFont(avatarlabel1,ltfontmiddle)
        previewAvatar = guiCreateStaticImage(0.4443,0.21,0.15,0.15,"files/images/avatars/alien.png",true,GUIEditor_Window[3])
        avatarlabel2 = guiCreateLabel(0.4443,0.45,0.1953,0.0325,"-Choose your Avatar",true,GUIEditor_Window[3])
        guiSetFont(avatarlabel2,ltfontspecial)
        avatargridlist = guiCreateGridList(0.4443,0.478,0.1517,0.3175,true,GUIEditor_Window[3])
        avatarcolumn = guiGridListAddColumn (avatargridlist,"Avatar",0.8 )
        --Create
        --Now i make it with tables xD I was noob.
        for id,avatar in pairs (avatarPfad) do
            local row = guiGridListAddRow ( avatargridlist )
            guiGridListSetItemText ( avatargridlist, row, avatarcolumn, string.gsub(avatar, "files/images/avatar/",""), false, false )
        end
        avatarsetbutton = guiCreateButton(0.4443,0.81,0.1517,0.0550,"Set",true,GUIEditor_Window[3])
        guiSetFont(avatarsetbutton,ltfontspecial)
        avatarresetbutton = guiCreateButton(0.4443,0.87,0.1517,0.0550,"Reset",true,GUIEditor_Window[3])
        guiSetFont(avatarresetbutton,ltfontspecial)
        -------------------------------------
        addEventHandler("onClientGUIChanged", getRootElement(),
            function ()
                guiLabelSetColor(GUIEditor_Label[213],guiGetText (GUIEditor_Edit[11]),guiGetText (GUIEditor_Edit[12]),guiGetText (GUIEditor_Edit[13]) )
            end)
        addEventHandler("onClientGUIChanged", getRootElement(),
            function ()
                guiLabelSetColor(GUIEditor_Label[201],guiGetText (GUIEditor_Edit[2]),guiGetText (GUIEditor_Edit[3]),guiGetText (GUIEditor_Edit[4]) )
            end)
        --------------------------------------
        --------------------------------BuyLists--------------------
        GUIEditor_Window[7] = guiCreateStaticImage(0,0,1,0.907,"files/images/environment/background.png",true)
        guiCreateStaticImage(0,0,1,0.025,"files/images/environment/tab.png",true,GUIEditor_Window[7])
        GUIEditor_Label[70] = guiCreateLabel(0.0345,0.5776,0.2311,0.1245,"Description",true,GUIEditor_Window[7])
        guiSetFont(GUIEditor_Label[70],ltfontspecial)
        GUIEditor_Label[66] = guiCreateLabel(0.0345,0.0776,0.3811,0.1245,"Buylist",true,GUIEditor_Window[7])
        guiLabelSetColor(GUIEditor_Label[66],255,153,0)
        guiSetFont(GUIEditor_Label[66],ltfontspecialBig)
        GUIEditor_GridList[100] = guiCreateGridList(0.0345,0.1776,0.2311,0.3516,true,GUIEditor_Window[7])
        GUIEditor_GridList[102] = guiGridListAddColumn (GUIEditor_GridList[100],"Buy",0.8 )
        GUIEditor_GridList[140] = guiGridListAddRow (GUIEditor_GridList[100])
        GUIEditor_GridList[141] = guiGridListAddRow (GUIEditor_GridList[100])
        GUIEditor_GridList[142] = guiGridListAddRow (GUIEditor_GridList[100])
        GUIEditor_GridList[143] = guiGridListAddRow (GUIEditor_GridList[100])
        GUIEditor_GridList[143] = guiGridListAddRow (GUIEditor_GridList[100])
        GUIEditor_GridList[144] = guiGridListAddRow (GUIEditor_GridList[100])
        guiGridListSetItemText ( GUIEditor_GridList[100], GUIEditor_GridList[140], GUIEditor_GridList[102], "Ghost", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[100], GUIEditor_GridList[141], GUIEditor_GridList[102], "Repair", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[100], GUIEditor_GridList[142], GUIEditor_GridList[102], "Flip", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[100], GUIEditor_GridList[143], GUIEditor_GridList[102], "Special Music", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[100], GUIEditor_GridList[144], GUIEditor_GridList[102], "", false, false )
        GUIEditor_Button[67] = guiCreateButton(0.0345,0.6700,0.2311,0.0592,"BUY",true,GUIEditor_Window[7])
        guiSetFont(GUIEditor_Button[67],ltfontspecial)

        GUIEditor_Label[153] = guiCreateLabel(0.6345,0.0776,0.3811,0.1245,"Buy Map",true,GUIEditor_Window[7])
        guiLabelSetColor(GUIEditor_Label[153],255,153,0)
        guiSetFont(GUIEditor_Label[153],ltfontspecialBig)
        mapgridlist = guiCreateGridList(0.6345,0.1776,0.2311,0.3516,true,GUIEditor_Window[7])
        guiGridListSetSortingEnabled(mapgridlist,false)
        GUIEditor_GridList[155] = guiGridListAddColumn (mapgridlist,"Map Name",1.9 )
        mapbuybutton = guiCreateButton(0.6345,0.6700,0.2311,0.0592,"Buy Map (5000$)",true,GUIEditor_Window[7])
        guiSetFont(mapbuybutton,ltfontspecial)
        mapsearchlist = guiCreateEdit(0.6345,0.5776,0.2311,0.04,"",true,GUIEditor_Window[7])

        levelinfolabel = guiCreateLabel(0.0345,0.7600,0.2811,0.03,"Your Level: 0",true,GUIEditor_Window[7])
        guiLabelSetColor(levelinfolabel,255,153,0)
        guiSetFont(levelinfolabel,ltfontspecialMiddle)
        levelbuybutton = guiCreateButton(0.0345,0.8000,0.2311,0.06,"",true,GUIEditor_Window[7])
        guiSetFont(levelbuybutton,ltfontspecial)
        levelinfolabeltwo = guiCreateLabel(0.3345,0.7600,0.1811,0.4,"Object\nFix\nFlip\nVehiclecolor\nWintext\nBuy map\nJoinmessage\nWheels\nAvatar\nRainbow Color\nPulsating Headlights",true,GUIEditor_Window[7])
        guiLabelSetColor(levelinfolabeltwo,255,153,0)
        guiSetFont(levelinfolabeltwo,ltfontspecial)
        levelinfolabelthr = guiCreateLabel(0.4925,0.7600,0.2811,0.4,"Level \n" .. minLevelFix .. "\n" .. minLevelFlip .. "\n" .. minLevelCustomcolor .. "\n" .. minLevelWintext .. "\n" .. minLevelBuyMap .. "\n" .. minLevelJoinmessage .. "\n" .. minLevelWheels .. "\n" .. minLevelAvatar .. "\n" .. minLevelRainbowcolor .. "\n" .. minLevelPulsatingHeadlights,true,GUIEditor_Window[7])
        guiLabelSetColor(levelinfolabelthr,255,255,255)
        guiSetFont(levelinfolabelthr,ltfontspecial)

        --LT+ Panel
        ltPLUSbutton = guiCreateButton(0.6345,0.8000,0.2311,0.06,"Status",true,GUIEditor_Window[7])
        guiSetFont(levelbuybutton,ltfontspecial)
        GUIEditor_Window["lt+"] = guiCreateStaticImage(0.25,0.25,0.5,0.5,"files/images/environment/background.png",true)
        guiSetVisible(GUIEditor_Window["lt+"],false)
        guiCreateStaticImage(0,0,1,0.025,"files/images/environment/tab.png",true,GUIEditor_Window["lt+"])
        ltPLUSbuttonClose = guiCreateButton(0.75,0.9,0.21,0.06,"Close",true,GUIEditor_Window["lt+"])
        guiSetFont(levelbuybutton,ltfontspecial)
        GUIEditor_Label["headlineLT+"] = guiCreateLabel(0.0345,0.0776,0.3811,0.1245,"iRace Panel",true,GUIEditor_Window["lt+"])
        guiLabelSetColor(GUIEditor_Label["headlineLT+"],255,153,0)
        guiSetFont(GUIEditor_Label["headlineLT+"],ltfontspecialBig)

        GUIEditor_Label["statusLT+"] = guiCreateLabel(0.1,0.35,0.25,0.15,"Status",true,GUIEditor_Window["lt+"])
        guiLabelSetColor(GUIEditor_Label["statusLT+"],255,153,0)
        guiSetFont(GUIEditor_Label["statusLT+"],ltfontspecial)
        --GUIEditor_Edit["settedStatusLT+"] = guiCreateEdit(0.1,0.4,0.225,0.05,"LT+ Member",true,GUIEditor_Window["lt+"])
        GUIEditor_Edit["settedStatusLT+"] = guiCreateEdit(0.1,0.4,0.225,0.05,"Buy a custom status for 200.000$",true,GUIEditor_Window["lt+"])
        setStatusButton = guiCreateButton(0.1,0.47,0.225,0.05,"Set",true,GUIEditor_Window["lt+"])
        guiSetFont(setStatusButton,ltfontspecial)


        GUIEditor_Label[67] = guiCreateLabel(0.3345,0.0776,0.3811,0.1245,"Special",true,GUIEditor_Window[7])
        guiLabelSetColor(GUIEditor_Label[67],255,153,0)
        guiSetFont(GUIEditor_Label[67],ltfontspecialBig)
        GUIEditor_GridList[110] = guiCreateGridList(0.3345,0.1776,0.2311,0.3516,true,GUIEditor_Window[7])
        GUIEditor_GridList[112] = guiGridListAddColumn (GUIEditor_GridList[110],"Special",0.8 )
        GUIEditor_Label[71] = guiCreateLabel(0.3345,0.5776,0.2311,0.1245,"Description",true,GUIEditor_Window[7])
        guiSetFont(GUIEditor_Label[71],ltfontspecial)
        GUIEditor_GridList[152] = guiGridListAddRow (GUIEditor_GridList[110])
        GUIEditor_GridList[153] = guiGridListAddRow (GUIEditor_GridList[110])
        GUIEditor_GridList[156] = guiGridListAddRow (GUIEditor_GridList[110])
        GUIEditor_GridList[157] = guiGridListAddRow (GUIEditor_GridList[110])
        GUIEditor_GridList[158] = guiGridListAddRow (GUIEditor_GridList[110])
        GUIEditor_GridList[159] = guiGridListAddRow (GUIEditor_GridList[110])
        GUIEditor_GridList[160] = guiGridListAddRow (GUIEditor_GridList[110])
        guiGridListSetItemText ( GUIEditor_GridList[110], GUIEditor_GridList[152], GUIEditor_GridList[112], "Wheels", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[110], GUIEditor_GridList[153], GUIEditor_GridList[112], "Pulsating Headlights", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[110], GUIEditor_GridList[156], GUIEditor_GridList[112], "Vehiclecolor", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[110], GUIEditor_GridList[157], GUIEditor_GridList[112], "Wintext", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[110], GUIEditor_GridList[158], GUIEditor_GridList[112], "Joinmessage", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[110], GUIEditor_GridList[159], GUIEditor_GridList[112], "Avatar", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[110], GUIEditor_GridList[160], GUIEditor_GridList[112], "Rainbow Color", false, false )
        GUIEditor_Button[68] = guiCreateButton(0.3345,0.6700,0.2311,0.0592,"BUY",true,GUIEditor_Window[7])
        guiSetFont(GUIEditor_Button[68],ltfontspecial)
        --------------------------Archivements--------------------------
        GUIEditor_Window[4] = guiCreateStaticImage(0,0,1,0.907,"files/images/environment/background.png",true)
        guiCreateStaticImage(0,0,1,0.025,"files/images/environment/tab.png",true,GUIEditor_Window[4])
        GUIEditor_Label[24] = guiCreateLabel(0.0345,0.0776,0.4502,0.1286,"Achievements",true,GUIEditor_Window[4])
        guiLabelSetColor(GUIEditor_Label[24],255,153,0)
        guiSetFont(GUIEditor_Label[24],ltfontspecialBig)
        --create
        local x,y = 0.0345,0.2
        local achieve = 0
        achive_state = {}
        achive_check = {}
        local img = "files/images/environment/locked.png"
        for id,achive in pairs(achiveTable) do
            local achivement = getAchivementScriptNameFromRealName(id)
            local img = getBoolInString (getElementData(getLocalPlayer(),achivement),"files/images/environment/unlocked.png","files/images/environment/locked.png")
            achive_background = guiCreateStaticImage(x,y,0.225,0.075,"files/images/environment/tab.png",true,GUIEditor_Window[4])
            achive_state[id] = guiCreateStaticImage(0.025,0.3,0.14,0.4,img,true,achive_background)
            achive_name = guiCreateLabel(0.3,0.125,0.7,0.6,id,true,achive_background)
            achive_check[id] = guiCreateCheckBox(0.7,0.125,0.3,0.3,"Status",false,true,achive_background)
            setElementData(achive_check[id],"parentName",id)
            addEventHandler ( "onClientGUIClick", achive_check[id] , setstatusperpanel,false )
            achive_description = guiCreateLabel(0.3,0.4,0.7,0.6,achive[1],true,achive_background)
            guiLabelSetColor(achive_name,0,0,0)
            guiLabelSetColor(achive_description,255,255,255)
            guiSetFont(achive_name,ltfontspecial)
            guiSetFont(achive_description,ltfontspecial)
            achieve = achieve+1
            if achieve < 9 then
                y = y+0.1
            elseif achieve == 9 then
                x = x+0.25
                y = 0.2
            elseif achieve > 9 then
                y = y+0.1
            end
        end
        --------------------------PvP--------------------------
        GUIEditor_Window["pvp"] = guiCreateStaticImage(0,0,1,0.907,"files/images/environment/background.png",true)
        guiCreateStaticImage(0,0,1,0.025,"files/images/environment/tab.png",true,GUIEditor_Window["pvp"])
        GUIEditor_Label["pvphead"] = guiCreateLabel(0.0345,0.1000,0.3811,0.1245,"PvP Mode",true,GUIEditor_Window["pvp"])
        guiLabelSetColor(GUIEditor_Label["pvphead"],255,153,0)
        guiSetFont(GUIEditor_Label["pvphead"],ltfontspecialBig)
        --Infos
        GUIEditor_Label["lbl"] = guiCreateLabel(0.54,0.2,0.25,0.25,"Statistics",true,GUIEditor_Window["pvp"])
        guiLabelSetColor(GUIEditor_Label["lbl"],255,153,0)
        guiSetFont(GUIEditor_Label["lbl"],ltfontspecialBig)
        GUIEditor_Label["pvpme"] = guiCreateLabel(0.65,0.25,0.25,0.25,"-",true,GUIEditor_Window["pvp"])
        guiLabelSetColor(GUIEditor_Label["pvpme"],255,153,0)
        guiSetFont(GUIEditor_Label["pvpme"],ltfontspecialMiddle)
        GUIEditor_Label["pvpenemie"] = guiCreateLabel(0.65,0.3,0.25,0.25,"-",true,GUIEditor_Window["pvp"])
        guiLabelSetColor(GUIEditor_Label["pvpenemie"],255,153,0)
        guiSetFont(GUIEditor_Label["pvpenemie"],ltfontspecialMiddle)
        GUIEditor_Label["pvpmeName"] = guiCreateLabel(0.55,0.25,0.25,0.25,string.gsub(getPlayerName(getLocalPlayer()), '#%x%x%x%x%x%x', '')..":",true,GUIEditor_Window["pvp"])
        guiLabelSetColor(GUIEditor_Label["pvpmeName"],255,153,0)
        guiSetFont(GUIEditor_Label["pvpmeName"],ltfontspecialMiddle)
        GUIEditor_Label["pvpenemieName"] = guiCreateLabel(0.55,0.3,0.25,0.25,"Enemie",true,GUIEditor_Window["pvp"])
        guiLabelSetColor(GUIEditor_Label["pvpenemieName"],255,153,0)
        guiSetFont(GUIEditor_Label["pvpenemieName"],ltfontspecialMiddle)
        GUIEditor_Label["pvpNeedWinsLBL"] = guiCreateLabel(0.55,0.35,0.25,0.25,"Wins:",true,GUIEditor_Window["pvp"])
        guiLabelSetColor(GUIEditor_Label["pvpNeedWinsLBL"],255,153,0)
        guiSetFont(GUIEditor_Label["pvpNeedWinsLBL"],ltfontspecialMiddle)
        GUIEditor_Label["pvpBetLBL"] = guiCreateLabel(0.55,0.4,0.25,0.25,"Bet:",true,GUIEditor_Window["pvp"])
        guiLabelSetColor(GUIEditor_Label["pvpBetLBL"],255,153,0)
        guiSetFont(GUIEditor_Label["pvpBetLBL"],ltfontspecialMiddle)
        GUIEditor_Label["pvpNeedWins"] = guiCreateLabel(0.65,0.35,0.25,0.25,"-",true,GUIEditor_Window["pvp"])
        guiLabelSetColor(GUIEditor_Label["pvpNeedWins"],255,153,0)
        guiSetFont(GUIEditor_Label["pvpNeedWins"],ltfontspecialMiddle)
        GUIEditor_Label["pvpBetValue"] = guiCreateLabel(0.65,0.4,0.25,0.25,"-",true,GUIEditor_Window["pvp"])
        guiLabelSetColor(GUIEditor_Label["pvpBetValue"],255,153,0)
        guiSetFont(GUIEditor_Label["pvpBetValue"],ltfontspecialMiddle)
        --Settings
        --Name
        GUIEditor_Label["pvpDescriptionName"] = guiCreateLabel(0.05,0.2+0.1,0.075,0.025,"Name:",true,GUIEditor_Window["pvp"])
        guiLabelSetColor(GUIEditor_Label["pvpDescriptionName"],255,153,0)
        guiSetFont(GUIEditor_Label["pvpDescriptionName"],ltfontspecialMiddle)
        GUIEditor_Edit["pvpName"] = guiCreateEdit(0.05,0.23+0.1,0.075,0.035,"",true,GUIEditor_Window["pvp"])
        --Bet
        GUIEditor_Label["pvpDescriptionBet"] = guiCreateLabel(0.05,0.3+0.1,0.1,0.025,"Bet  (max. 100.000$)",true,GUIEditor_Window["pvp"])
        guiLabelSetColor(GUIEditor_Label["pvpDescriptionBet"],255,153,0)
        guiSetFont(GUIEditor_Label["pvpDescriptionBet"],ltfontspecialMiddle)
        GUIEditor_Edit["pvpBet"] = guiCreateEdit(0.05,0.33+0.1,0.075,0.035,"0",true,GUIEditor_Window["pvp"])
        --Rounds
        GUIEditor_Label["pvpDescriptionRounds"] = guiCreateLabel(0.05,0.4+0.1,0.075,0.025,"Wins:",true,GUIEditor_Window["pvp"])
        guiLabelSetColor(GUIEditor_Label["pvpDescriptionRounds"],255,153,0)
        guiSetFont(GUIEditor_Label["pvpDescriptionRounds"],ltfontspecialMiddle)
        GUIEditor_Edit["pvpRounds"] = guiCreateEdit(0.05,0.43+0.1,0.075,0.035,"1",true,GUIEditor_Window["pvp"])
        --Start Button
        GUIEditor_Button["pvpStart"] = guiCreateButton(0.05,0.6,0.075,0.05,"Request",true,GUIEditor_Window["pvp"])
        guiSetFont(GUIEditor_Button["pvpStart"],ltfontspecial)

        --Accept
        GUIEditor_Label["pvpDescriptionRequests"] = guiCreateLabel(0.25,0.57, 0.3,0.1,"Request from: -",true, GUIEditor_Window["pvp"])   --GUIEditor_Label["pvpDescriptionRequests"] = guiCreateLabel(0.05,0.76,0.3,0.1,"Request from: -",true, GUIEditor_Window["pvp"])
        GUIEditor_Button["pvpAccept"] = guiCreateButton(0.25,0.6, 0.075,0.05,"Accept",true,GUIEditor_Window["pvp"])                     --GUIEditor_Button["pvpAccept"] = guiCreateButton(0.05,0.8,0.075,0.075,"Accept",true,GUIEditor_Window["pvp"])
        GUIEditor_Button["pvpDecline"] = guiCreateButton(0.35,0.6, 0.075,0.05,"Decline",true,GUIEditor_Window["pvp"])                     --GUIEditor_Button["pvpAccept"] = guiCreateButton(0.05,0.8,0.075,0.075,"Accept",true,GUIEditor_Window["pvp"])

        guiLabelSetColor(GUIEditor_Label["pvpDescriptionRequests"],255,153,0)
        guiSetFont(GUIEditor_Label["pvpDescriptionRequests"],ltfontspecialMiddle)
        guiSetFont(GUIEditor_Button["pvpAccept"], ltfontspecial)
        guiSetFont(GUIEditor_Button["pvpDecline"], ltfontspecial)
        --------------------------Top--------------------------
        GUIEditor_Window[6] = guiCreateStaticImage(0,0,1,0.907,"files/images/environment/background.png",true)
        guiCreateStaticImage(0,0,1,0.025,"files/images/environment/tab.png",true,GUIEditor_Window[6])
        GUIEditor_Label[26] = guiCreateLabel(0.0345,0.0776,0.4502,0.1286,"Top Players",true,GUIEditor_Window[6])
        guiLabelSetColor(GUIEditor_Label[26],255,153,0)
        guiSetFont(GUIEditor_Label[26],ltfontspecialBig)
        GUIEditor_GridList[4] = guiCreateGridList(0.0425,0.2000,0.2311,0.7816,true,GUIEditor_Window[6])
        GUIEditor_GridList[5] = guiGridListAddColumn (GUIEditor_GridList[4],"Top",0.8 )
        GUIEditor_GridList[6] = guiGridListAddRow (GUIEditor_GridList[4])
        GUIEditor_GridList[9] = guiGridListAddRow (GUIEditor_GridList[4])
        GUIEditor_GridList[10] = guiGridListAddRow (GUIEditor_GridList[4])
        GUIEditor_GridList[11] = guiGridListAddRow (GUIEditor_GridList[4])
        GUIEditor_GridList[12] = guiGridListAddRow (GUIEditor_GridList[4])
        GUIEditor_GridList[14] = guiGridListAddRow (GUIEditor_GridList[4])
        GUIEditor_GridList[16] = guiGridListAddRow (GUIEditor_GridList[4])
        GUIEditor_GridList[17] = guiGridListAddRow (GUIEditor_GridList[4])
        --GUIEditor_GridList[18] = guiGridListAddRow (GUIEditor_GridList[4])
        guiGridListSetItemText ( GUIEditor_GridList[4], GUIEditor_GridList[6], GUIEditor_GridList[5], "Cash", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[4], GUIEditor_GridList[9], GUIEditor_GridList[5], "Level", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[4], GUIEditor_GridList[10], GUIEditor_GridList[5], "Toptimes", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[4], GUIEditor_GridList[11], GUIEditor_GridList[5], "DDswon", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[4], GUIEditor_GridList[12], GUIEditor_GridList[5], "DDsplayed", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[4], GUIEditor_GridList[14], GUIEditor_GridList[5], "Playtime", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[4], GUIEditor_GridList[16], GUIEditor_GridList[5], "Mapsfinished", false, false )
        guiGridListSetItemText ( GUIEditor_GridList[4], GUIEditor_GridList[17], GUIEditor_GridList[5], "Deaths", false, false )
    --guiGridListSetItemText ( GUIEditor_GridList[4], GUIEditor_GridList[18], GUIEditor_GridList[5], "Funareakills", false, false )
    ----------------------------------------------------------------------
    end)

-----------------------##--------------------
-----------------------##--------------------ShowPanel
function showUserPanelLT ()
    if getElementData(getLocalPlayer(),"isLogedIn") then
        --getVisible = guiGetVisible (GUIEditor_Window[1]) __iRUPewX
        playerName = getPlayerName ( getLocalPlayer() )
        if (getVisible == true) then
            --guiSetVisible (GUIEditor_Window[1], false) __iRUPewX
            guiSetVisible (GUIEditor_Window[2], false)
            guiSetVisible (GUIEditor_Window[3], false)
            guiSetVisible (GUIEditor_Window[4], false)
            guiSetVisible (GUIEditor_Window[6], false)
            guiSetVisible (GUIEditor_Window[7], false)
            guiSetVisible (GUIEditor_Window["lt+"], false)
            guiSetVisible (GUIEditor_Window["pvp"], false)
            --guiSetText ( GUIEditor_Button[1], "Stats")
            --guiSetText ( GUIEditor_Button[2], "Shop")
            guiSetInputMode("allow_binds")
            showCursor (false)
        end
        if (getVisible == false) then
            --guiSetVisible (GUIEditor_Window[1], true)	__iRUPewX
            guiSetInputMode("no_binds_when_editing")
            showCursor (true)
            refreshAchieves()
        end
    end
end

function hideAllPanels()
    guiSetVisible (GUIEditor_Window[2], false)
    guiSetVisible (GUIEditor_Window[3], false)
    guiSetVisible (GUIEditor_Window[4], false)
    guiSetVisible (GUIEditor_Window[6], false)
    guiSetVisible (GUIEditor_Window[7], false)
    guiSetVisible (GUIEditor_Window["lt+"], false)
    guiSetVisible (GUIEditor_Window["pvp"], false)
end

function toggleStatsPanel()
    if guiGetVisible(GUIEditor_Window[2]) then
        guiSetVisible (GUIEditor_Window[2], false)
        guiSetVisible (GUIEditor_Window[3], false)
        guiSetVisible (GUIEditor_Window[4], false)
        guiSetVisible (GUIEditor_Window[7], false)
        guiSetVisible (GUIEditor_Window["lt+"], false)
        guiSetVisible (GUIEditor_Window["pvp"], false)
    else
        guiSetVisible (GUIEditor_Window[2], true)
        guiSetVisible (GUIEditor_Window[3], false)
        guiSetVisible (GUIEditor_Window[4], false)
        guiSetVisible (GUIEditor_Window["lt+"], false)
        guiSetVisible (GUIEditor_Window[7], false)
        guiSetVisible (GUIEditor_Window["pvp"], false)
    end
end

function toggleShopPanel()
    if guiGetVisible (GUIEditor_Window[7]) then
        guiSetVisible (GUIEditor_Window[2], false)
        guiSetVisible (GUIEditor_Window[3], false)
        guiSetVisible (GUIEditor_Window[4], false)
        guiSetVisible (GUIEditor_Window[6], false)
        guiSetVisible (GUIEditor_Window[7], false)
        guiSetVisible (GUIEditor_Window["lt+"], false)
        guiSetVisible (GUIEditor_Window[3], false)
        guiSetVisible (GUIEditor_Window["pvp"], false)
    else
        guiSetVisible (GUIEditor_Window[2], false)
        guiSetVisible (GUIEditor_Window[7], true)
        guiSetVisible (GUIEditor_Window[4], false)
        guiSetVisible (GUIEditor_Window[6], false)
        guiSetVisible (GUIEditor_Window["lt+"], false)
        guiSetVisible (GUIEditor_Window["pvp"], false)
    end
end


function toggleAchievementsPanel()
    if guiGetVisible(GUIEditor_Window[4])  then
        guiSetVisible (GUIEditor_Window[2], false)
        guiSetVisible (GUIEditor_Window[3], false)
        guiSetVisible (GUIEditor_Window["lt+"], false)
        guiSetVisible (GUIEditor_Window[4], false)
        guiSetVisible (GUIEditor_Window[6], false)
        guiSetVisible (GUIEditor_Window[7], false)
        guiSetVisible (GUIEditor_Window["pvp"], false)
    else
        guiSetVisible (GUIEditor_Window[2], false)
        guiSetVisible (GUIEditor_Window[3], false)
        guiSetVisible (GUIEditor_Window["lt+"], false)
        guiSetVisible (GUIEditor_Window[4], true)
        guiSetVisible (GUIEditor_Window[6], false)
        guiSetVisible (GUIEditor_Window[7], false)
        guiSetVisible (GUIEditor_Window["pvp"], false)
    end
end

function toggleSettingsPanel()
    if guiGetVisible (GUIEditor_Window[3])  then
        guiSetVisible (GUIEditor_Window[2], false)
        guiSetVisible (GUIEditor_Window[3], false)
        guiSetVisible (GUIEditor_Window[4], false)
        guiSetVisible (GUIEditor_Window[6], false)
        guiSetVisible (GUIEditor_Window[7], false)
        guiSetVisible (GUIEditor_Window["pvp"], false)
        guiSetVisible (GUIEditor_Window["lt+"], false)
    else
        guiSetVisible (GUIEditor_Window[2], false)
        guiSetVisible (GUIEditor_Window[3], true)
        guiSetVisible (GUIEditor_Window[4], false)
        guiSetVisible (GUIEditor_Window[6], false)
        guiSetVisible (GUIEditor_Window[7], false)
        guiSetVisible (GUIEditor_Window["pvp"], false)
        guiSetVisible (GUIEditor_Window["lt+"], false)
    end
end

function togglePVPPanel()
    if guiGetVisible (GUIEditor_Window["pvp"]) then
        guiSetVisible (GUIEditor_Window[2], false)
        guiSetVisible (GUIEditor_Window[3], false)
        guiSetVisible (GUIEditor_Window[4], false)
        guiSetVisible (GUIEditor_Window[6], false)
        guiSetVisible (GUIEditor_Window[7], false)
        guiSetVisible (GUIEditor_Window["pvp"], false)
        guiSetVisible (GUIEditor_Window["lt+"], false)
    else
        guiSetVisible (GUIEditor_Window[2], false)
        guiSetVisible (GUIEditor_Window[3], false)
        guiSetVisible (GUIEditor_Window[4], false)
        guiSetVisible (GUIEditor_Window[6], false)
        guiSetVisible (GUIEditor_Window[7], false)
        guiSetVisible (GUIEditor_Window["lt+"], false)
        guiSetVisible (GUIEditor_Window["pvp"], true)
    end
end
--------------------------------

function setPanelOnLogin (cashForLevel,level)
    guiSetText ( levelbuybutton, "Buy level "..tonumber(level+1).." \nfor "..cashForLevel.."$")
    guiSetText ( levelinfolabel, "Current level: "..level)
end
addEvent("setPanelObjects", true)
addEventHandler("setPanelObjects", getLocalPlayer(), setPanelOnLogin)

function buylevelperpanel (button,state)
    if button == "left" and state == "up" then
        triggerServerEvent("buyNextLevelPerPanel", resroot)
    end
end

--PvP Mode
function sendPvPInfos (button,state)
    if button == "left" and state == "up" then
        local name = guiGetText (GUIEditor_Edit["pvpName"])
        local bet = guiGetText (GUIEditor_Edit["pvpBet"])
        local wins = guiGetText (GUIEditor_Edit["pvpRounds"])
        --getPlayer
        local targetPlayer = getPlayerFromNamePart(name)
        if not targetPlayer then
            initialiseInfobox("PvP", "Can't find the player!", 255, 50, 0, 1, 5)
            return
        end
        --getBet
        if tonumber (bet) <= 0 or tonumber (bet) > 100000  then
            initialiseInfobox("PvP", "Use a bet between 0$ and 100.000$!", 255, 50, 0, 1, 5)
            return
        end
        --getRounds
        if tonumber (wins) <= 0 and tonumber (wins) > 20  then
            initialiseInfobox("PvP", "User a win value between 0 and 20!", 255, 50, 0, 1, 5)
            return
        end
        triggerServerEvent("onPlayerGetPvPRequest", getLocalPlayer(), tonumber(bet), tonumber(wins), targetPlayer)
    end
end

function acceptPvPRequest()
    triggerServerEvent("onPlayerAcceptPvPRequest",getLocalPlayer())
end

function declinePvPRequest()
    triggerServerEvent("onPlayerDeclinePvPRequest", getLocalPlayer())
end

function setPlayerNameToAcceptButton(name)
    guiSetText(GUIEditor_Label["pvpDescriptionRequests"],"Request from: "..string.gsub(name, '#%x%x%x%x%x%x', ''))
end
addEvent("setPlayerNameToAcceptButton", true)
addEventHandler("setPlayerNameToAcceptButton", getLocalPlayer(), setPlayerNameToAcceptButton)

function setLabelForPvP(tMe, tEnemy)
    guiSetText(GUIEditor_Label["pvpenemieName"], removeColorCodes(getPlayerName(tMe.eTargetPlayer) .. ":"))
    guiSetText(GUIEditor_Label["pvpenemie"], tEnemy.nCurrentWins)
    guiSetText(GUIEditor_Label["pvpme"], tMe.nCurrentWins)
    guiSetText(GUIEditor_Label["pvpNeedWins"], tMe.nNeedWins)
    guiSetText(GUIEditor_Label["pvpBetValue"], tMe.nBet)
end
addEvent("setLabelsForPvP", true)
addEventHandler("setLabelsForPvP", getLocalPlayer(), setLabelForPvP)

function resetAllPvPLabels ()
        guiSetText(GUIEditor_Label["pvpenemieName"],"Enemie:")
        guiSetText(GUIEditor_Label["pvpenemie"], "-")
        guiSetText(GUIEditor_Label["pvpme"], "-")
        guiSetText(GUIEditor_Label["pvpNeedWins"], "-")
        guiSetText(GUIEditor_Label["pvpBetValue"], "-")

        guiSetText(GUIEditor_Label["pvpDescriptionRequests"],"Request from: -")
end
addEvent("resetAllPvPLabels", true)
addEventHandler("resetAllPvPLabels", root, resetAllPvPLabels)



function sendVehicleColors (button,state)
    if button == "left" and state == "up" then
        local r = guiGetText (GUIEditor_Edit[2])
        local g = guiGetText (GUIEditor_Edit[3])
        local b = guiGetText (GUIEditor_Edit[4])
        if tonumber (r) >= 0 and tonumber (r) < 256 and tonumber (g) >= 0 and tonumber (g) < 256 and tonumber (b) >= 0 and tonumber (b) < 256 then
            if source == GUIEditor_Button[77] then
                color = 2
            elseif source == GUIEditor_Button[6] then
                color = 1
            end
            triggerServerEvent ( "triggerRGBColors",getLocalPlayer(),color,guiGetText (GUIEditor_Edit[2]),guiGetText (GUIEditor_Edit[3]),guiGetText (GUIEditor_Edit[4]) )
        else
            outputClientErrorBox("Use amount between 0 and 255 !")
        end
    end
end

function sendChatColors (button,state)
    if button == "left" and state == "up" then
        local r = guiGetText (GUIEditor_Edit[11])
        local g = guiGetText (GUIEditor_Edit[12])
        local b = guiGetText (GUIEditor_Edit[13])
        if tonumber (r) >= 0 and tonumber (r) < 256 and tonumber (g) >= 0 and tonumber (g) < 256 and tonumber (b) >= 0 and tonumber (b) < 256 then
            triggerServerEvent ( "triggerRGBChatColors",getLocalPlayer(),guiGetText (GUIEditor_Edit[11]),guiGetText (GUIEditor_Edit[12]),guiGetText (GUIEditor_Edit[13]) )
        else
            outputClientErrorBox("Use amount between 0 and 255 !")
        end
    end
end

function buyselectedmap (button,state)
    if button == "left" and state == "up" then
        mapName = guiGridListGetItemText ( mapgridlist, guiGridListGetSelectedItem ( mapgridlist ), 1 )
        triggerServerEvent ( "triggerbuyMap",getLocalPlayer(),mapName)
    end
end

function sendWinText (button,state)
    if button == "left" and state == "up" then
        local text = guiGetText (GUIEditor_Edit[5])
        triggerServerEvent ( "triggerWinText",getLocalPlayer(),text)
    end
end

function sendJoinmsgText (button,state)
    if button == "left" and state == "up" then
        local text = guiGetText (GUIEditor_Edit[14])
        triggerServerEvent ( "triggerJointextText",getLocalPlayer(),text)
    end
end

--------------Stats-Gridlist------------------
function getBoolInString (bool,trueReturn,falseReturn)
    if bool then
        return trueReturn
    else
        return falseReturn
    end
end

function round(value,dec)
    if value then
        local decimals = dec or 2
        return tonumber(string.format("%.0"..tostring(decimals).."f",math.floor(((value)*10^decimals)+0.5)/(10^decimals)))
    end
    return false
end

function roundTime(value)
    if value then
        local time = getRealTime(value)
        local yearday = time.yearday
        local hours = time.hour
        local minutes = time.minute
        return yearday.." days, "..hours.." hours, "..minutes.." minutes"
    end
    return false
end

function clickOnPlayerInStatsMenu ()
    local row,colum = guiGridListGetSelectedItem ( playerList )
    local player = guiGridListGetItemData ( playerList, row, colum )
    if player then
        local player = getPlayerFromName(player)
        --Basic
        local playerName = string.gsub(getPlayerName( player ), "#%x%x%x%x%x%x","")
        local cash = tonumber(getElementData(player,"cash"))
        local level = tonumber(getElementData(player,"level"))
        local toptimes = tonumber(getElementData(player,"toptimes12"))
        local hunter = tonumber(getElementData(player,"mapsfinished"))
        --local funareakills = tonumber(getElementData(player,"funareakills"))
        local deaths = tonumber(getElementData(player,"deaths"))
        --local cashearned = tonumber(getElementData(player,"cashearned"))
        --local cashspent = tonumber(getElementData(player,"cashspent"))
        local ddsplayed = tonumber(getElementData(player,"ddsplayed"))
        local ddswon = tonumber(getElementData(player,"ddswon"))

        local dmsplayed = tonumber(getElementData(player,"dmsplayed"))
        local dmswon = tonumber(getElementData(player,"dmswon"))

        local playtime = tonumber(getElementData(player,"playtime"))
        local jointimes = getElementData(player,"jointimes")
        local joinmessage = getBoolInString(getElementData(player,"JoinText"),getElementData(player,"JoinText"),"Not bought")
        local rainbowcolor = getBoolInString(getElementData(player,"rainbowcolor"),"Bought","Not bought")
        local wheelsBought = getBoolInString(getElementData(player,"boughtWheels"),"Bought","Not bought")
        local wintext = getBoolInString(getElementData(player,"WinText"),getElementData(player,"WinText"),"Not bought")
        local playerstatus = getBoolInString(getElementData(player,"playerstatus"),getElementData(player,"playerstatus"),"Not bought")
        local rColor,gColor,bColor = tonumber(getElementData(player, "vcolorr")) or 255, tonumber(getElementData(player, "vcolorg")) or 255, tonumber(getElementData(player, "vcolorb")) or 255
        local rColor2,gColor2,bColor2 = tonumber(getElementData(player, "vcolorr2")) or 255, tonumber(getElementData(player, "vcolorg2")) or 255, tonumber(getElementData(player, "vcolorb2")) or 255
        if getElementData(player, "avatar") == false then
            avatarPfad = "files/images/environment/star.png"
        else
            avatarPfad = tostring(getElementData(player,"avatar"))
        end
        local achive1 = getBoolInString(getElementData(player,"achive1"),"(x)","()")
        local achive2 = getBoolInString(getElementData(player,"achive2"),"(x)","()")
        local achive3 = getBoolInString(getElementData(player,"achive3"),"(x)","()")
        local achive4 = getBoolInString(getElementData(player,"achive4"),"(x)","()")
        local achive5 = getBoolInString(getElementData(player,"achive5"),"(x)","()")
        local achive6 = getBoolInString(getElementData(player,"achive6"),"(x)","()")
        local achive7 = getBoolInString(getElementData(player,"achive7"),"(x)","()")
        local achive8 = getBoolInString(getElementData(player,"achive8"),"(x)","()")
        local achive9 = getBoolInString(getElementData(player,"achive9"),"(x)","()")
        local achive10 = getBoolInString(getElementData(player,"achive10"),"(x)","()")
        local achive11 = getBoolInString(getElementData(player,"achive11"),"(x)","()")
        local achive12 = getBoolInString(getElementData(player,"achive12"),"(x)","()")
        local achive13 = getBoolInString(getElementData(player,"achive13"),"(x)","()")
        local achive14 = getBoolInString(getElementData(player,"achive14"),"(x)","()")
        local achive15 = getBoolInString(getElementData(player,"achive15"),"(x)","()")
        local achive18 = getBoolInString(getElementData(player,"achive18"),"(x)","()")
        local achive19 = getBoolInString(getElementData(player,"achive19"),"(x)","()")

        --end
        --General
        guiSetText ( nameStatsLabel, playerName)
        guiSetText ( cashStatsLabel, cash)
        guiSetText ( toptimesStatsLabel, toptimes)
        guiSetText ( hunterStatsLabel, hunter)
        --guiSetText ( funareaStatsLabel, funareakills)
        guiSetText ( levelStatsLabel, level)
        guiSetText ( playtimeStatsLabel, roundTime((playtime*60)))

        --DDStatsLabel, DDStatsLabel DD: DM:
        if 100*dmswon == 0 and 100*dmsplayed == 0 then
            guiSetText(DMStatsLabel, "0%")
        else
            --	guiSetText ( DMStatsLabel, math.ceil((100*dmswon)/dmsplayed).."%")
            guiSetText(DMStatsLabel, dmswon .. "/" .. dmsplayed .. " (" .. math.ceil((dmswon/dmsplayed)*100) .. "%)")
        end

        if 100*ddswon == 0 and 100*ddsplayed == 0 then
            guiSetText(DDStatsLabel, "0%")
        else
            --guiSetText ( DDStatsLabel, math.ceil((100*ddswon)/ddsplayed).."%")
            guiSetText(DDStatsLabel, ddswon .. "/" .. ddsplayed .. " (" .. math.ceil((ddswon/ddsplayed)*100) .. "%)")
        end



        guiSetText ( jointimesStatsLabel, jointimes)
        guiStaticImageLoadImage(avatarStatsImage,avatarPfad)
        --Shop Items
        guiSetText ( vcolorStatsLabel, tostring(rColor..","..gColor..","..bColor.." - "..rColor2..","..gColor2..","..bColor2))
        guiSetText ( wintextStatsLabel, wintext)
        guiSetText ( joinmessageStatsLabel, joinmessage)
        guiSetText ( WheelsStatsLabel, wheelsBought)
        guiSetText ( StatusStatsLabel, playerstatus)
        guiSetText ( rainbowStatsLabel, rainbowcolor)
        --Achivements
        guiSetText ( achive1StatsLabel, achive1)
        guiSetText ( achive2StatsLabel, achive2)
        guiSetText ( achive3StatsLabel, achive3)
        guiSetText ( achive4StatsLabel, achive4)
        guiSetText ( achive5StatsLabel, achive5)
        guiSetText ( achive6StatsLabel, achive6)
        guiSetText ( achive7StatsLabel, achive7)
        guiSetText ( achive8StatsLabel, achive8)
        guiSetText ( achive9StatsLabel, achive9)
        guiSetText ( achive10StatsLabel, achive10)
        guiSetText ( achive11StatsLabel, achive11)
        guiSetText ( achive12StatsLabel, achive12)
        guiSetText ( achive13StatsLabel, achive13)
        guiSetText ( achive14StatsLabel, achive14)
        guiSetText ( achive15StatsLabel, achive15)
        guiSetText ( achive16StatsLabel, achive18)
        guiSetText ( achive17StatsLabel, achive19)
    end
end
--------------------------------
------------------------Archivements
function refreshAchieves ()
    for i,achive in pairs(achiveTable) do
        local achivement = getAchivementScriptNameFromRealName(i)
        local img = getBoolInString (getElementData(getLocalPlayer(),tostring(achivement)),"files/images/environment/unlocked.png","files/images/environment/locked.png")
        guiStaticImageLoadImage (achive_state[i],img)
        local status = getElementData(getLocalPlayer(),"playerstatus")
        if status == i then
            guiCheckBoxSetSelected ( achive_check[i],true)
        else
            guiCheckBoxSetSelected ( achive_check[i],false)
        end
    end
end


function getAchivementScriptNameFromRealName(achivement)
    for i,achive in pairs(achiveTableDataNames) do
        if i == achivement then
            return achive[1]
        end
    end
end

function clickbuy (button,state)
    if button == "left" and state == "up" then
        local object = guiGridListGetItemText ( GUIEditor_GridList[100], guiGridListGetSelectedItem ( GUIEditor_GridList[100] ), 1 )
        triggerServerEvent ( "getSelectedBuyPerPanel",getLocalPlayer(),object )
    end
end

function clickspecialbuy (button,state)
    if button == "left" and state == "up" then
        local object = guiGridListGetItemText ( GUIEditor_GridList[110], guiGridListGetSelectedItem ( GUIEditor_GridList[110] ), 1 )
        triggerServerEvent ( "getSelectedBuyPerPanel",getLocalPlayer(),object )
    end
end

function optioncamerafade (button,state)
    if button == "left" and state == "up" then
        triggerServerEvent ( "setOptionCameraFade",getLocalPlayer())
    end
end

--[[function optioninfernusMod (button,state)
    if button == "left" and state == "up" then
        triggerServerEvent ( "setOptionInfernusBox",getLocalPlayer())
    end
end]]

function clickbuygridlist (button,state)
    local object = guiGridListGetItemText ( GUIEditor_GridList[100], guiGridListGetSelectedItem ( GUIEditor_GridList[100] ), 1 )
    if object == "Repair" then
        guiSetText ( GUIEditor_Label[70], "-Repair your vehicle\n-" .. fixPrice .. "$")
    elseif object == "Flip" then
        guiSetText ( GUIEditor_Label[70], "-Flip your vehicle\n-".. flipPrice .. "$")
    elseif object == "Special Music" then
        guiSetText ( GUIEditor_Label[70], "-Plays a random music \n-" .. BoomBoomSongPrice .. "$")
    elseif object == "Ghost" then
        guiSetText ( GUIEditor_Label[70], "-Your vehicle became \ninvisible for 2 min. \n-" .. ghostPrice .. "$")
    end
end



function clickspecialbuygridlist (button,state)
    local object = guiGridListGetItemText ( GUIEditor_GridList[110], guiGridListGetSelectedItem ( GUIEditor_GridList[110] ), 1 )
    if object == "Joinmessage" then
        guiSetText ( GUIEditor_Label[71], "-Set an message for joining \nthe Server\n-" .. joinmessagePrice .. "$")
    elseif object == "Wintext" then
        guiSetText ( GUIEditor_Label[71], "-Set an Text who shows up\n if you win\n-" .. wintextPrice .. "$")
    elseif object == "Vehiclecolor" then
        guiSetText ( GUIEditor_Label[71], "-Set your custom vehicle color \n-" .. customcolorPrice .. "$")
    elseif object == "Wheels" then
        guiSetText ( GUIEditor_Label[71], "-Change your custom wheels\n-" .. wheelsPrice .. "$")
    elseif object == "Pulsating Headlights" then
        guiSetText ( GUIEditor_Label[71], "-Pulsating Headlights \n-" .. pulsatingHeadlightsPrice .. "$")
    elseif object == "Avatar" then
        guiSetText ( GUIEditor_Label[71], "-Set your custom \navatar \n-" .. avatarPrice .. "$")
    elseif object == "Rainbow Color" then
        guiSetText ( GUIEditor_Label[71], "-Your vehicle will change the color \non every frame \n-" .. rainbowcolorPrice .. "$")
    end
end

function cklickwheels (button,state)
    if button == "left" and state == "up" then
        local wheels = guiGridListGetItemText ( GUIEditor_GridList[350], guiGridListGetSelectedItem ( GUIEditor_GridList[350] ), 1 )
        if source == wheelsresetbutton then
            wheels = "Standart"
        end
        triggerServerEvent ( "setSelectedWheels",getLocalPlayer(),wheels )
    end
end

function onoffrainbow (button,state)
    if button == "left" and state == "up" then
        triggerServerEvent ( "setRainbowColor",getLocalPlayer())
    end
end

function toggleAntiBounce(button, state)
    if button == "left" and state == "up" then
        triggerServerEvent("toggleAntiBounce", getLocalPlayer())
    end
end

addCommandHandler("ab", function()
    triggerServerEvent("toggleAntiBounce", getLocalPlayer())
end)

function togglePulsatingHeadlights(button, state)
    if button == "left" and state == "up" then
        triggerServerEvent("togglePulsatingHeadlights", getLocalPlayer())
    end
end

function setPreviewAvatar (button,state)
    if button == "left" and state == "up" then
        local avatar = guiGridListGetItemText ( avatargridlist, guiGridListGetSelectedItem ( avatargridlist ), 1 )
        guiStaticImageLoadImage(previewAvatar,"files/images/avatars/"..avatar)
    end
end

function buyAvatar (button,state)
    if button == "left" and state == "up" then
        local avatar1 = guiGridListGetItemText ( avatargridlist, guiGridListGetSelectedItem ( avatargridlist ), 1 )
        local avatar = "files/images/avatars/"..avatar1
        if source == avatarresetbutton then
            avatar = "Standart"
        end
        triggerServerEvent ( "setSelectedAvatar", me, avatar )
    end
end


function setstatusperpanel ()
    local achivement = getElementData(source,"parentName")
    if achivement then
        triggerServerEvent ( "setPlayerStatus",getLocalPlayer(),achivement )
        setTimer(function()
            refreshAchieves()
        end,200,1)
    else
        outputClientErrorBox("Please Select a achievement")
    end
end

--------------------------Nextmap--------------------------------------
function callClientFunction(funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do arg[key] = tonumber(value) or value end
    end
    loadstring("return "..funcname)()(unpack(arg))
end
addEvent("onServerCallsClientFunction", true)
addEventHandler("onServerCallsClientFunction", resourceRoot, callClientFunction)

-- Get all maps on server
function getMaps()
    triggerServerEvent("getServerMaps", me)
end
addEventHandler("onDownloadFinished", resroot,getMaps)
setTimer(getMaps, 600000, -1)

function loadMaps(gamemodeMapTable)
    guiGridListClear(mapgridlist)
    if gamemodeMapTable then
        aGamemodeMapTable = gamemodeMapTable
        for id,gamemode in pairs (gamemodeMapTable) do
            if (gamemode.name == "Race") then
                for id,map in ipairs (gamemode.maps) do
                    local row = guiGridListAddRow ( mapgridlist )
                    guiGridListSetItemText ( mapgridlist, row, 1, map.name, false, false )
                    guiGridListSetItemData ( mapgridlist, row, 1, map.resname)
                end
            end
        end
    end
end
addEvent("onClientLoadMapList", true)
addEventHandler("onClientLoadMapList", me, loadMaps)

-- Map search
function mapSearch()
    guiGridListClear(mapgridlist)
    local searchString = string.lower(guiGetText(mapsearchlist))
    if ( searchString == "" ) then
        for id,gamemode in pairs (aGamemodeMapTable) do
            if (gamemode.name == "Race") then
                for id,map in ipairs (gamemode.maps) do
                    local row = guiGridListAddRow ( mapgridlist )
                    guiGridListSetItemText ( mapgridlist, row, 1, map.name, false, false )
                    guiGridListSetItemData ( mapgridlist, row, 1, map.resname)
                end
            end
        end
    else
        for id,gamemode in pairs (aGamemodeMapTable) do
            if (gamemode.name == "Race") then
                local noMapsFound = true
                for id,map in ipairs (gamemode.maps) do
                    if string.find(string.lower(map.name.." "..map.resname), searchString, 1, true) then
                        local row = guiGridListAddRow ( mapgridlist )
                        guiGridListSetItemText ( mapgridlist, row, 1, map.name, false, false )
                        guiGridListSetItemData ( mapgridlist, row, 1, map.resname)
                        noMapsFound = false
                    end
                end
                if noMapsFound == true then
                    local row = guiGridListAddRow(mapgridlist)
                    guiGridListSetItemText (mapgridlist, row, 1, "No maps matching your search query!", false, false)
                    guiGridListSetItemColor (mapgridlist, row, 1, 255,50,50)
                end
            end
        end
    end
end

--[[function infernusMod (onornot)
    if onornot == 1 then --on
        infernusTXD = engineLoadTXD ("files/mods/infernus.txd");
        engineImportTXD (infernusTXD, 411);
        infernusDFF = engineLoadDFF ("files/mods/infernus.dff", 411);
        engineReplaceModel (infernusDFF, 411);
    elseif onornot == 0 then --not on
        engineRestoreModel ( 411 )
    end

    --Remove Nitro
    local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
    if theVehicle then
        removeVehicleUpgrade(theVehicle, 1010)
    end
end
--addEvent("infernusModOn",true)
addEventHandler("infernusModOn",getLocalPlayer(),infernusMod)]]


shaderTable = {}
confFile = xmlLoadFile("shaderSettings.xml")
if (confFile) then
    shaderTable["watershader"] = xmlNodeGetAttribute(confFile,"watershader")
    shaderTable["carshader"] = xmlNodeGetAttribute(confFile,"carshader")
    shaderTable["roadshader"] = xmlNodeGetAttribute(confFile,"roadshader")
    shaderTable["hdshader"] = xmlNodeGetAttribute(confFile,"hdshader")
else
    confFile = xmlCreateFile("shaderSettings.xml","shader")
    xmlNodeSetAttribute(confFile,"watershader","true")
    xmlNodeSetAttribute(confFile,"carshader","true")
    xmlNodeSetAttribute(confFile,"roadshader","false")
    xmlNodeSetAttribute(confFile,"hdshader","false")
    shaderTable["watershader"] = "true"
    shaderTable["carshader"] = "true"
    shaderTable["roadshader"] = "false"
    shaderTable["hdshader"] = "false"
end
xmlSaveFile(confFile)

function saveShaderData ()
    shaderTable["watershader"] = xmlNodeGetAttribute(confFile,"watershader")
    shaderTable["carshader"] = xmlNodeGetAttribute(confFile,"carshader")
    shaderTable["roadshader"] = xmlNodeGetAttribute(confFile,"roadshader")
    shaderTable["hdshader"] = xmlNodeGetAttribute(confFile,"hdshader")
end


--Shader's
function enableShaders (button,state)
    if source == watershader then
        toggleWaterShader (not returnBool(shaderTable["watershader"]))
        xmlNodeSetAttribute(confFile,"watershader",tostring(not returnBool(shaderTable["watershader"])))
    elseif source == carshader then
        enableCarpaint(not returnBool(shaderTable["carshader"]))
        xmlNodeSetAttribute(confFile,"carshader",tostring(not returnBool(shaderTable["carshader"])))
    elseif source == roadshader then
        switchRoadshine3(not returnBool(shaderTable["roadshader"]))
        xmlNodeSetAttribute(confFile,"roadshader",tostring(not returnBool(shaderTable["roadshader"])))
    elseif source == hdshader then
        enbaleHDContrast(not returnBool(shaderTable["hdshader"]))
        xmlNodeSetAttribute(confFile,"hdshader",tostring(not returnBool(shaderTable["hdshader"])))
    end
    xmlSaveFile(confFile)
    saveShaderData()
end

function returnBool (boolString)
    if boolString == "true" then
        return true
    else
        return false
    end
end

setTimer(function()
    --toggleWaterShader(returnBool(shaderTable["watershader"]))
    --enableCarpaint(returnBool(shaderTable["carshader"]))
    --switchRoadshine3(returnBool(shaderTable["roadshader"]))
    --enbaleHDContrast(returnBool(shaderTable["hdshader"]))
end,3000,1)

--LT+
function openLTPlusPanel ()
    guiSetVisible (GUIEditor_Window["lt+"], true)
    guiBringToFront(GUIEditor_Window["lt+"])
end

function closeLTPlusPanel ()
    guiSetVisible (GUIEditor_Window["lt+"], false)
end

function setLTPlusStatus (button,state)
    if button == "left" and state == "up" then
        local text = guiGetText (GUIEditor_Edit["settedStatusLT+"])
        triggerServerEvent("setPlayerStatusVioR", getLocalPlayer(), text)
    end
end


--onResourceStart
function onresourceStart ()
    guiSetVisible (GUIEditor_Window[2], false)
    guiSetVisible (GUIEditor_Window[3], false)
    guiSetVisible (GUIEditor_Window[4], false)
    guiSetVisible (GUIEditor_Window[6], false)
    guiSetVisible (GUIEditor_Window[7], false)
    guiSetVisible (GUIEditor_Window["pvp"], false)

    addEventHandler ( "onClientGUIClick",GUIEditor_Button[6],sendVehicleColors,false)
    addEventHandler ( "onClientGUIClick",GUIEditor_Button[77],sendVehicleColors,false)
    addEventHandler ( "onClientGUIClick",GUIEditor_Button[214],sendChatColors,false)
    addEventHandler ( "onClientGUIClick",GUIEditor_Button[7],sendWinText,false)
    addEventHandler ( "onClientGUIClick",GUIEditor_Button[33],sendJoinmsgText,false)

    addEventHandler ( "onClientGUIClick",GUIEditor_Button["pvpStart"],sendPvPInfos,false)
    addEventHandler ( "onClientGUIClick",GUIEditor_Button["pvpAccept"],acceptPvPRequest,false)
    addEventHandler ( "onClientGUIClick",GUIEditor_Button["pvpDecline"],declinePvPRequest,false)
    addEventHandler ( "onClientGUIClick", GUIEditor_Button[67], clickbuy,false)
    addEventHandler ( "onClientGUIClick", GUIEditor_Button[68], clickspecialbuy,false )

    addEventHandler ( "onClientGUIClick", GUIEditor_Button[178] , cklickwheels,false )
    addEventHandler ( "onClientGUIClick", wheelsresetbutton , cklickwheels,false )
    addEventHandler ( "onClientGUIClick", rainbowcoloronoff , onoffrainbow,false )
    addEventHandler ( "onClientGUIClick", GUIEditor_GridList[100], clickbuygridlist,false )
    addEventHandler ( "onClientGUIClick", GUIEditor_GridList[110], clickspecialbuygridlist,false )
    addEventHandler ( "onClientGUIClick", GUIEditor_Label[222], optioncamerafade,false )
    --addEventHandler ( "onClientGUIClick", GUIEditor_Label[224], optioninfernusMod,false )

    addEventHandler ( "onClientGUIClick", mapbuybutton , buyselectedmap,false )
    addEventHandler ( "onClientGUIChanged", mapsearchlist, mapSearch, false )
    addEventHandler ( "onClientGUIClick", levelbuybutton , buylevelperpanel,false )
    addEventHandler ( "onClientGUIClick", avatargridlist , setPreviewAvatar,false )
    addEventHandler ( "onClientGUIClick", avatarsetbutton , buyAvatar,false )
    addEventHandler ( "onClientGUIClick", avatarresetbutton , buyAvatar,false )
    addEventHandler ( "onClientGUIClick", ltPLUSbutton , openLTPlusPanel,false )
    addEventHandler ( "onClientGUIClick", ltPLUSbuttonClose , closeLTPlusPanel,false )
    addEventHandler ( "onClientGUIClick", setStatusButton , setLTPlusStatus,false )
    addEventHandler ( "onClientGUIClick", bPH , togglePulsatingHeadlights,false )
    addEventHandler ( "onClientGUIClick", bAB , toggleAntiBounce,false )
    refreshAchieves()
    --shader
    addEventHandler ( "onClientGUIClick", watershader , enableShaders,false )
    addEventHandler ( "onClientGUIClick", carshader , enableShaders,false )
    addEventHandler ( "onClientGUIClick", roadshader , enableShaders,false )
    addEventHandler ( "onClientGUIClick", hdshader , enableShaders,false )


    local isPlayerStatsListCreated = false
    function createPlayerList ()
        if isPlayerStatsListCreated == false then
            playerList = guiCreateGridList (0.7500,0.1900,0.2200,0.7800, true,GUIEditor_Window[2])
            columnStatsPlayer = guiGridListAddColumn( playerList, "Player", 0.85 )
            addEventHandler ( "onClientGUIClick", playerList, clickOnPlayerInStatsMenu )
            isPlayerStatsListCreated = true
        end
        -- Clear it
        guiGridListClear(playerList)
        -- Create the grid list
        for id, playeritem in ipairs(getElementsByType("player")) do
            if getElementData(playeritem,"cash") then
                local row = guiGridListAddRow ( playerList )
                guiGridListSetItemText ( playerList, row, columnStatsPlayer, string.gsub(getPlayerName( playeritem ), "#%x%x%x%x%x%x",""), false, false )
                guiGridListSetItemData ( playerList, row, columnStatsPlayer, tostring(getPlayerName( playeritem )) )
            end
        end
    end
    setTimer(createPlayerList,5000,0)
end
addEventHandler("onDownloadFinished", resroot, onresourceStart)

function showWintextInfo ()
    local x,y = getCursorPosition()
    wintextInfo = guiCreateStaticImage(x,y-0.075,0.125,0.075,"files/button_standart.png", true)
    wintextInfoLabel = guiCreateLabel(0.025,0.025,0.975,0.975,"*DM* - Your DM wins\n*DD* - Your DD wins\n*MAPS* - Maps finished\n*CASH* - You cash\n*EARNED* - Complete earned money\n*LEVEL* - Your level",true,wintextInfo)
    guiSetFont(wintextInfoLabel,ltfontspecial)
end

function removeWintextInfo ()
    destroyElement(wintextInfo)
end