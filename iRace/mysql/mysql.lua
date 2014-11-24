--
-- HorrorClown (PewX)
-- Date: 26.07.2014 - Time: 00:54
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local handler
settings = {}

addEventHandler("onResourceStart", resroot, function()
    handler = dbConnect("mysql", "dbname=iRace_main;host=localhost", "root", "", "autoreconnect=1") --Host for lel 192.168.230.129
end)

function mysqlQuery(q, ...)
   local query = dbQuery(handler, q, ...)
   local result, qRows, qliID = dbPoll(query, 100)
   if result == false then
        outputDebugString("Error while executing 'dbQuery(" .. q .. ", " .. table.concat({...}, ", ") .. ")'")
        outputDebugString("Error code: " .. tostring(qRows) .. " Error message: " .. tostring(qliID))
        return false
    elseif result then
        return result
    end
end

function mysqlInsert(t, c, v, ...)           --t = table | c = columns | v = values
    return dbExec(handler, "INSERT INTO " .. t .. " (" .. c .. ") VALUES (" .. v .. ")", ...)
end

function mysqlSet(t, c, cV, w, wV)   		--t = table | c = column | cV = columnValue | w = where | wV = whereValue
    --outputChatBox(("UPDATE %s SET %s=%s WHERE %s=%s"):format(t, c, cV, w, wV))
    return dbExec(handler, "UPDATE ?? SET ??=? WHERE ??=?", t, c, cV, w, wV)
end

function mysqlGet(t, c, w, wV)              --t = table | c = column | w = where | wV = whereValue
    local q = mysqlQuery("SELECT " .. c .. " FROM " .. t .. " WHERE " .. w .. " = " .. wV)
    for _, row in ipairs(q) do
        return row[c]
    end
end

--Loading global settings



----
---Simple examples
----

    --[[local q = mysqlSet("sys_msg_dl", "message", "Changed to what else..", "ID", 12)
    --outputChatBox(tostring(q))]]

    --[[local q = mysqlGet("sys_msg_dl", "message", "ID", 12)
    outputChatBox(tostring(q))]]

    --[[local q = mysqlInsert("sys_msg_dl", "ID,message", "?,?", 16, "Please wait while running away..")
    outputChatBox(tostring(q))]]

    --[[local q = table.concat({...}, " ")
    outputChatBox(q)

    local msgs = mysqlQuery(q)
    for i, row in ipairs(msgs) do
        outputChatBox(row.message)
    end]]
