--iR|HorrorClown (PewX) - iRace-mta.de--
local badChars = {"!","\"","§","&","/","=","?","`","´","\\","{","}","³","²","@","€","*","+","#","'","~","|","<",">",".",":",",",";","%","(",")","$","[","]"}

addEventHandler("onResourceStart", resroot, function()
    for _, player in ipairs(getElementsByType"player") do
        logOut(player)
    end
end)

local function containsBadChars(n)
	for _, theChar in ipairs(badChars) do
		if string.find(n, tostring(theChar), 1, true) then
			return true
		end
	end
	return false
end

local function isPlayerRegistered(player)
    if #getAccountsBySerial(getPlayerSerial(player)) ~= 0 then return true else return false end
end

local function getPlayersFirstAccount(player)
    if #getAccountsBySerial(getPlayerSerial(player)) ~= 0 then 
		return getAccountsBySerial(getPlayerSerial(player))[1]
	else 
		return false
	end
end

addEvent("onClientFinishedLoading", true)
addEventHandler("onClientFinishedLoading", root,
	function()
		outputServerLog("Server")
		triggerClientEvent(client, "onServerRequestLoginRegister", getRootElement(), getAccountName(getPlayersFirstAccount(client)))
	end
)


local function isAccountRegistered(n)
	local account = getAccount(n)
	if account then	return true else return false end
end

addEvent("onClientExecute", true)
addEventHandler("onClientExecute", root, function(s, inputs)
	if source ~= client then return end
	if s == 1 then
	    local pA = getAccount(inputs[1])
        if pA then
            local pL = logIn(client, pA, inputs[2])
            if pL then
				triggerClientEvent(client, "onClientSuccess", client)
                triggerEvent("onClientLoggedIn", resroot, client)
                triggerClientEvent(client, "addClientMessage", client, "|Info| #ff8000Type /report [text] for super very fast support :)", 255, 255, 255)
				return
            else
                triggerClientEvent(client, "showErrorMessage", client, "Invalid password!")
            end
        else
            triggerClientEvent(client, "showErrorMessage", client, "Can't find account!")
        end
	elseif s == 2 then
		for _, t in ipairs(inputs) do
			if t == nil or t == "" then
				triggerClientEvent(client, "showErrorMessage", client, "Invalid username or password")
				return
			end
		end
		
		if containsBadChars(inputs[1]) then
			triggerClientEvent(client, "showErrorMessage", client, "Your accountname contains invaild chars")
			return
		elseif #inputs[2] < 6 then
			triggerClientEvent(client, "showErrorMessage", client,"Your password must be at least 6 characters")
			return
		elseif inputs[2] ~= inputs[3] then
			triggerClientEvent(client, "showErrorMessage", client,"The passwords do not match.")
			return
		elseif isAccountRegistered(inputs[1]) then
			triggerClientEvent(client, "showErrorMessage", client,"Account allready registered.")
			return
        elseif isPlayerRegistered(client) then
            triggerClientEvent(client, "showErrorMessage", client, "You allready registered an account.")
            return
		end

        local nA = addAccount(inputs[1], inputs[2])
        if nA then
            logIn(client, nA, inputs[2])
            triggerClientEvent(client, "onClientSuccess", client)
            setPlayerTeam(client, getTeamFromName("User"))
			setAccountData(nA, "cash", 250000)
        else
            triggerClientEvent(client, "showErrorMessage", client, "An error occupied while creating account.")
        end
	end
end)

addEventHandler("onPlayerCommand", root, function(cmd)
	if cmd == "login" or cmd == "register" or cmd == "logout" then cancelEvent() end
end)