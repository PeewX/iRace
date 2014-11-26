function fChatMessageHandle(text)
	for k,v in ipairs(getElementData(localPlayer, "blocktable")) do
		if (text:find(getPlayerName(v)..": ")) then
			triggerEvent("addClientMessage", getRootElement(), "|Chat| Blocked a message from "..getPlayerName(v).."!") 
			cancelEvent()
		end
	end
end
addEventHandler("onClientChatMessage", getRootElement(), fChatMessageHandle)