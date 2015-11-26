CRPC = {}

function CRPC:constructor()
	self.registeredFunctions = {}
	
	addEvent("RPC:Call", true)
	addEventHandler("RPC:Call", root, bind(CRPC.receiveCall, self))
end

function CRPC:destructor()

end

if not SERVER then
	function CRPC:call(str_RPC, ...)
		triggerServerEvent("RPC:Call", resourceRoot, str_RPC, ...)
	end
	
	function CRPC:latentCall(str_RPC, ...)
		triggerLatentServerEvent("RPC:Call", 2097152, false, root, str_RPC, ...)
	end
else
	function CRPC:call(ePlayer, str_RPC, ...)
		if isElement(ePlayer) then
			triggerClientEvent(ePlayer, "RPC:Call", root, str_RPC, ...)
		else
			--ePlayer equal str_RPC
			--str_RPC is the first argument
			triggerClientEvent("RPC:Call", resourceRoot, ePlayer, str_RPC, ...)
		end
	end
	
	function CRPC:latentCall(ePlayer, str_RPC, ...)
		if isElement(ePlayer) then
			triggerLatentClientEvent(ePlayer, "RPC:Call", 2097152, false, root, str_RPC, ...)
		else
			--ePlayer equal str_RPC
			--str_RPC is the first argument
			triggerLatentClientEvent("RPC:Call", 2097152, false, root, ePlayer, str_RPC, ...)
		end
	end
end

function CRPC:receiveCall(str_RPC, ...)
	if self.registeredFunctions[str_RPC] then
		if SERVER then
			self.registeredFunctions[str_RPC](client, ...)
		else
			self.registeredFunctions[str_RPC](...)
		end
	else
		debugOutput(("[RPC] Unregistered call: '%s'"):format(tostring(str_RPC)))
	end
end

function CRPC:registerFunction(str_RPC, attachedFunction)
	if type(attachedFunction) ~= "function" then debugOutput("Attached function is not a function") return end
	self.registeredFunctions[str_RPC] = attachedFunction
	debugOutput(("[RPC] Registered '%s'"):format(str_RPC))
end

function CRPC:unregisterFunction(str_RPC)
	if self.registeredFunctions[str_RPC] then
		self.registeredFunctions[str_RPC] = nil
		debugOutput(("[RPC] Unregistered '%s'"):format(str_RPC))
	end
end