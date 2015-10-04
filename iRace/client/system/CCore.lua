--
-- PewX (HorrorClown)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 02.10.2015 - Time: 21:32
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
CCore = {}

function CCore:constructor()
    self.managers = {}
    self.systems = {}

    --table.insert(self.managers, {"ManagerClass", {arguments}})
    --table.insert(self.systems, {"instanceName", "ClassName", {arguments}})
    table.insert(self.systems, {"Interface", "CBottomInterface", {}})
    table.insert(self.systems, {"Nickname", "CNickname", {}})
    table.insert(self.systems, {"KeyDisplay", "CKeyDisplay", {}})
end

function CCore:destructor()

end

function CCore:loadManagers()
    for _, v in ipairs(self.managers) do
        if (type(_G[v[1]]) == "table") then
            debugOutput(("[CCore] Loading manager '%s'"):format(tostring(v[1])))
            self[tostring(v[1])] = new(_G[v[1]], unpack(v[2]))
        else
            debugOutput(("[CCore] Couldn't find manager '%s'"):format(tostring(v[1])))
        end
    end
end

function CCore:loadSystems()
    for _, v in ipairs(self.systems) do
        if (type(_G[v[2]]) == "table") then
            debugOutput(("[CCore] Loading system '%s'"):format(tostring(v[2])))
            _G[v[1]] = new(_G[v[2]], unpack(v[3]))
        else
            debugOutput(("[CCore] Couldn't find system '%s'"):format(tostring(v[2])))
        end
    end
end

function CCore:getManager(sName)
    return self[sName]
end

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        local sT = getTickCount()
        debugOutput("[CCore] Starting Core")
        Core = new(CCore)
        Core:loadManagers()
        Core:loadSystems()
        debugOutput(("[CCore] Starting finished (%sms)"):format(math.floor(getTickCount()-sT)))
    end
)