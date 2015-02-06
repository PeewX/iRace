--iR|HorrorClown (PewX) - iRace-mta.de--
local badChars = {"!","\"","§","&","/","=","?","`","´","\\","{","}","³","²","@","€","*","+","#","'","~","|","<",">",".",":",",",";","%","(",")","$","[","]" }

local function containsBadChars(n)
	for _, theChar in ipairs(badChars) do
		if string.find(n, theChar, 1, true) then
			return true
		end
	end
	return false
end

function showErrorMessage(msg)
	triggerEvent("showErrorMessage", me, msg)
end

function clientExecute(s, inputs)
	if s == 1 then 												--Login
		for _, t in ipairs(inputs) do
			if t == nil or t == "" then
				showErrorMessage("Invalid username or password")
				return
			end
		end
	elseif s == 2 then 											--Register
		for _, t in ipairs(inputs) do
			if t == nil or t == "" then
				showErrorMessage("Invalid username or password")
				return
			end
		end

		if containsBadChars(inputs[1]) then
			showErrorMessage("Your accountname contains invaild chars")
			return
		elseif #inputs[2] < 6 then
			showErrorMessage("Your password must be at least 6 characters")
			return
		elseif inputs[2] ~= inputs[3] then
			showErrorMessage("The passwords do not match.")
			return
		end
	end
	triggerServerEvent("onClientExecute", me, s, inputs)
end