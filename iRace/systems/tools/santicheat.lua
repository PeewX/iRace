--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 23.10.2014 - Time: 20:58
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de // pewx.de
--
local vmd5 = {}
local lastDetectedACList = {}

addEventHandler("onResourceStart", resroot,
    function()
        local hashs = mysqlQuery("SELECT * FROM sys_d3d9")
        for _, hash in ipairs(hashs) do
            vmd5[hash.hash] = toboolean(hash.enabled)
        end
    end
)

addEventHandler("onElementDataChange", root,
    function(name, oldData)
        if client and getElementType(source) == "player" and client ~= source then
            setElementData(source, name, oldData)
            outputServerLog("AC-INFO: "
                .. " Player: " .. tostring(getPlayerName(client))
                .. " Serial: " .. tostring(getPlayerSerial(client))
                .. " IP: " ..     tostring(getPlayerIP(client))
                .. " ElementData: " .. tostring(name)
            )
        end
    end
)

addEventHandler( "onResourceStart", resroot,
    function()
        for _, p in ipairs(getElementsByType"player") do
            lastDetectedACList[p] = ""
        end
    end
)

addEventHandler( "onPlayerJoin", root,
    function()
        lastDetectedACList[source] = ""
    end
)

addEventHandler( "onPlayerQuit", root,
    function()
        lastDetectedACList[source] = nil
    end
)

local function checkPlayersACInfo()
    for plr,lastAC in pairs( lastDetectedACList ) do
        local info = getPlayerACInfo(plr)
        if info.DetectedAC ~= lastAC then
            lastDetectedACList[plr] = info.DetectedAC
            if not vmd5[info.d3d9MD5] then
                outputServerLog( "AC-INFO: "
                        .. " Player:" .. tostring(getPlayerName(plr))
                        .. " Serial: " .. tostring(getPlayerSerial(plr))
                        .. " DetectedAC:" .. tostring(info.DetectedAC)
                        .. " d3d9MD5:" .. tostring(info.d3d9MD5)
                        .. " d3d9Size:" .. tostring(info.d3d9Size)
                )
                --kickPlayer(plr, "iRace AC", "Invalid d3d9.dll! More infos: d3d9.irace-mta.de")
            end
        end
    end
end
setTimer(checkPlayersACInfo, 3000, 0)

function refreshHashs()
    vmd5 = {}
    local hashs = mysqlQuery("SELECT * FROM sys_d3d9")
    for _, hash in ipairs(hashs) do
        vmd5[hash.hash] = toboolean(hash.enabled)
    end
    return true
end