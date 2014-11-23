local running = false -- if race is running
addEvent("onClientRequestRespawn", true)
addEventHandler("onClientRequestRespawn", getRootElement(),
function(spawnPosition)
	-- source is the player that requested respawn.
	-- spawn at the position where last saved.
	triggerClientEvent(source, 'onClientCall_race', source, "Spectate.stop", 'manual')
	triggerEvent('onClientRequestSpectate', source, false)
	spawnPlayer(source, spawnPosition[1], spawnPosition[2], spawnPosition[3])
	if g_Vehicles[source] then
		destroyElement(g_Vehicles[source])
	end
	funVehicle = createVehicle(480, 0, 0, 0)
			if setElementSyncer then
				setElementSyncer( funVehicle, false )
			end
            g_Vehicles[source] = funVehicle
	warpPedIntoVehicle(source, funVehicle)
	triggerClientEvent(source, 'onClientCall_race', source, "Spectate.stop", 'manual')
	setElementData(source, "race.spectating", true)
	setElementData(source, "status1", "dead")
	setElementData(source, "status2", "")
	setElementData(source, "state", "funarea")
	setElementData(source, "race.finished", true)
	setCameraTarget(source, source)
	setElementData(funVehicle, "race.collideworld", 1)
	setElementData(funVehicle, "race.collideothers", 0)
	setElementData(source, "race.alpha", 100)
	setElementData(funVehicle, "race.alpha", 100)
	setTimer(setFunAreaReady,6000,1,source,funVehicle)
	setElementHealth(funVehicle, 1000)
	setElementModel(funVehicle, 481) -- fix motor sound.
	setElementModel(funVehicle, 480)
	setElementPosition(funVehicle, spawnPosition[1], spawnPosition[2], spawnPosition[3])
	setElementRotation(funVehicle, spawnPosition[4], spawnPosition[5], spawnPosition[6])
	setElementDimension(funVehicle, 279)
	setElementDimension(source, 279)
	--setElementFrozen(funVehicle, true)
	toggleAllControls(source, true)
	setVehicleLandingGearDown(funVehicle, true)
end)

function setFunAreaReady (player,vehicle)
	setElementData(vehicle, "race.collideworld", 1)
	setElementData(vehicle, "race.collideothers", 1)
	setElementData(player, "race.alpha", 255)
	setElementData(vehicle, "race.alpha", 255)
	setElementFrozen(funVehicle, false)
end

addEvent("onRaceStateChanging", true)
addEventHandler("onRaceStateChanging", getRootElement(),
function(newState, oldState)
	triggerClientEvent("onClientRaceStateChanging", getRootElement(), newState, oldState)
	if(newState == "Running")then
		running = true
	end
	if(newState == "PostFinish" or newState == "NoMap")then
		running = false
		local player = getElementsByType("player")
		for i = 1, #player do
			local replaying = getElementData(player[i], "respawn.playing")
			if(replaying)then
				setElementData(source, "race.spectating", false)
				setElementData(source, "status1", "dead")
				setElementData(source, "status2", "")
				setElementData(source, "race.finished", false)
			end
		end
	end
end)

-- Add training mode before player has played once
addEventHandler("onElementDataChange", getRootElement(),
function(theName, oldValue)
	if(getElementType(source) == "player")then
		if(tostring(getElementData(source, "state")) == "waiting" and running)then
			--triggerClientEvent(source, "onClientRaceStateChanging", source, "Running", "GridCountdown")
		end
	end
end)
