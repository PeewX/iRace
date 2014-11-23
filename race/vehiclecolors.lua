function onEnter(player)
 	if(isObjectInACLGroup("user."..getPlayerName(player),aclGetGroup("Everyone") then    	
         	setVehicleColor(source, 6, 6, 6, 6 )
)
 	end
end
addEventHandler("onVehicleEnter",getRootElement(),onEnter)

function onEnter(player)
 	if(isObjectInACLGroup("user."..getPlayerName(player),aclGetGroup("Inhaber") then    	
         	setVehicleColor(source, 2, 2, 0, 0 )
)
 	end
end
addEventHandler("onVehicleEnter",getRootElement(),onEnter)

function onEnter(player)
 	if(isObjectInACLGroup("user."..getPlayerName(player),aclGetGroup("Admin") then    	
         	setVehicleColor(source, 0, 0, 0, 0 )
)
 	end
end
addEventHandler("onVehicleEnter",getRootElement(),onEnter)

function onEnter(player)
 	if(isObjectInACLGroup("user."..getPlayerName(player),aclGetGroup("Vip") then    	
         	setVehicleColor(source, 86, 86, 86, 86 )
)
    end
end
addEventHandler("onVehicleEnter",getRootElement(),onEnter)