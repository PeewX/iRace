--This script will delete objects, that wouldn't deleted on resource stop..

addEventHandler("onResourceStart", resourceRoot,
	function()
		outputChatBox("Workaround started")
	end
)

local objects = {}
addEventHandler("onResourceStop", root,
	function(rResource)
		if rResource:getInfo("type") == "map" then
			outputChatBox("Its a map! Check for obejcts!")
			local objects = getElementsByType("object")
		end
	end
)

addEventHandler("onResourceStart", root,
	function(rResource)
		if rResource:getInfo("type") == "map" then
			local undeletedObjects = {}
			for _, ub in ipairs(objects) do
				if isElement(ub) then
					table.insert(undeletedObjects, ub)
				end
			end
			
			outputChatBox("Undeleted objects: " .. #undeletedObjects)
			
			if #undeletedObjects > 0 then
				for _, object in ipairs(undeletedObjects) do
					destroyElement(object)
				end
			end
		end
	end
)