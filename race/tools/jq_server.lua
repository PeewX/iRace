local root = getRootElement()
 
addEventHandler("onPlayerLogin", root,
  function()
	triggerClientEvent ( "addClientMessage", getRootElement(), getPlayerName(source).." #FFFFFFhas logged in!",255,255,255, "login")
  end
)

--al_client.lua erweiterung

--[[function onMapResourcesStart(res)
	for i, player in pairs(getElementsByType("player")) do
		triggerClientEvent(player, "onClientMapResourceStart", player, getResourceName(res))
	end
end
addEventHandler("onResourceStart", getRootElement(), onMapResourcesStart)]]