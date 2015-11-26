--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 26.07.2014 - Time: 17:15
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local path = "systems/blacklistedMaps/blacklistedMaps.xml"
local bMaps = {}
local xml = xmlLoadFile(path)

function saveAndUnload(xml)
    xmlSaveFile(xml)
    xmlUnloadFile(xml)
end

function loadBMaps()
    bMaps = {}
    local xml = xmlLoadFile(path)
    local tbm = xmlNodeGetChildren(xml)
    for _, map in ipairs(tbm) do
        table.insert(bMaps, xmlNodeGetValue(map))
    end
    saveAndUnload(xml)
end
addEventHandler("onResourceStart", getResourceRootElement(), loadBMaps)

function addCurrentMap(player)
    local currentMap = getCurrentMapName()
    local xml = xmlLoadFile(path)
    if xml and currentMap then
        xmlNodeSetValue(xmlCreateChild(xml, "map"), currentMap)
        outputChatBox("Map '" .. currentMap .. "' successfully added!", player, 50, 200, 0)
        saveAndUnload(xml)
        loadBMaps()
    end
    saveAndUnload(xml)
end

function removeMap(player, ID)
    local xml = xmlLoadFile(path)
    local mapName = bMaps[tonumber(ID)]
    if mapName then
       -- local mChild = false
        local tbm = xmlNodeGetChildren(xml)
        for _, child in ipairs(tbm) do
            if xmlNodeGetValue(child) == mapName then
                xmlDestroyNode(child)
                outputChatBox("Map '" .. mapName .. "' successfully removed from blacklist!", player, 50, 200, 0)
                saveAndUnload(xml)
                loadBMaps()
                return
            end
        end
        outputChatBox("Can't find map", player, 200, 0, 0)
    else
        outputChatBox("Can't find map!", player, 200, 0, 0)
    end
    saveAndUnload(xml)
end

addCommandHandler("blacklist", function(pl, _, typ, id)
    if typ == "add" then
        if isAllowedToUse(pl) then
            addCurrentMap(pl)
        end
    elseif typ == "del" then
        if isAllowedToUse(pl) then
            if id then
                removeMap(pl, id)
            else
                outputChatBox("Unknown parameter. Use /blacklist del ID", pl, 200, 0, 0)
            end
        end
    elseif typ == "list" then
        for i, map in ipairs(bMaps) do
            outputConsole("[" .. i .. "] " .. map, pl)
        end
    else
        outputConsole("Unknown parameter. Use /blacklist [add/del/list]", pl, 200, 0, 0)
    end
end)

function isAllowedToUse(player)
    if getAdminRank(player) >= 4 then return true else return false end

    local serial = getPlayerSerial(player)
    if serial == "5940BC1D19146653F3A22021DF594954" or "6E2344B6265B8D2A8F6F6EC39DEBFFB4" then
        return true
    else
        local pA = getPlayerAccount(player)
        if not isGuestAccount(pA) then
            if getAccountName(pA) == "PewX" then
                return true
            end
        end
    end

    return false
end

function isMapBlacklisted(mapname)
    for _, map in ipairs(bMaps) do
        if map == mapname then
            return true
        end
    end
    return false
end