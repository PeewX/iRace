addEvent("onClientRecieveSlotWinnings", true)
addEvent("onClientSlotSpin", false)

function recieveSpinResults(success, winAmount, tokensLeft, slotTable, winningLines)
	if (success) then
		--inject displays
		displayWinnings(winAmount, slotTable, winningLines)
		refreshTokenCount(tokensLeft)
	else
		--inject error message
		
	end
	currentlySpinning = false
end
addEventHandler("onClientRecieveSlotWinnings", getRootElement(), recieveSpinResults)

local currentlySpinning = false
function clientSlotSpin(tokens)
	if ( not currentlySpinning) then
		triggerServerEvent("onClientWantsToRollTheSlots", getRootElement(), tokens)
	end
end
addEventHandler("onClientSlotSpin", getRootElement(), recieveSpinResults)

function displayWinnings(wonAmount, slotTable, winningLines)

end

function refreshTokenCount(tokensLeft)

end

local screenWidth, screenHeight = guiGetScreenSize()
local width, height = 770*(screenWidth/1920), 650*((screenHeight*(1920/1080))/1920)

if (width < 500) then
	width = 500
	height = 500*(650/770)
end

local slotMachineOpened = false
local slotMachineBrowser

bindKey("F5", "down", 
	function()
		if not getElementData(me, "isLogedIn") then return end
		if (slotMachineBrowser) then
			if (slotMachineOpened) then
				slotMachineOpened:show(false)
				showCursor(false)
			else
				slotMachineBrowser:show(true)
				showCursor(true)
			end
			slotMachineOpened = not slotMachineOpened
		else
			slotMachineBrowser = WebWindow:new(Vector2(screenWidth/2-width/2, screenHeight/2-height/2), Vector2(width, height), "files/html/slots/index.html", true)
			showCursor(true)
			slotMachineOpened = true
		end
	end
)