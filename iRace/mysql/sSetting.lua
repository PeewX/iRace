--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 13 Ultimate
-- Date: 08.11.2014 - Time: 20:24
-- iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--

local st = {}

function st.loadBottomMessages()
    local msg = mysqlQuery("SELECT * FROM sys_msg_bar")
    --TODO: Trigger to client Bottom Panel
    --TODO: Add a function for reinit command
end