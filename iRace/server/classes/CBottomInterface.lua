--
-- PewX (HorrorClown)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 02.10.2015 - Time: 20:20
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
CBottomInterface = {}

function CBottomInterface:constructor()
    mysqlQuery("SET NAMES utf8")
    self.messages = mysqlQuery("SELECT * FROM sys_messages")

    self.clientRequestMessagesEvent = bind(CBottomInterface.requestMessages, self)

    addEvent("onClientRequestMessages", true)
    addEventHandler("onClientRequestMessages", resourceRoot, self.clientRequestMessagesEvent)
end

function CBottomInterface:destructor()

end

function CBottomInterface:requestMessages()
    triggerClientEvent(client, "onServerSendMessages", client, self.messages)
end