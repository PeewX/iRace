--
-- PewX (HorrorClown)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 22.11.2015 - Time: 16:42
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
CLogManager = inherit(CSingleton)

function CLogManager:constructor()
    self.Logs = {}
end

function CLogManager:destructor()
    for _, v in pairs(self.Logs) do
        delete(v)
    end
end


--Create instance for specific logging object
function CLogManager:create(sObject)
    if not sObject then return false, "Invalid argument" end
    if self.Logs[sObject:lower()] then return false, "Object already exists" end

    local log = new(CLog, sObject:lower())
    self.Logs[sObject:lower()] = log

    return true
end

function CLogManager:add(sObject, sText)
    if not sObject or not sText then return false, "Invalid arguments" end
    if not self.Logs[sObject:lower()] then return false, "Invalid object" end

    self.Logs[sObject:lower()]:add(sText)
end

--non oop
function create(sObject) return Core:getManager("CLogManager"):create(sObject) end
function add(sObject, sText) return Core:getManager("CLogManager"):add(sObject, sText) end