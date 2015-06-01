--PaylineCombos

local paylineCombos = {}
--[[
1.
- - - - -
x x x x x
- - - - -
]]
table.insert(paylineCombos, {1, 1, 1, 1, 1})
--[[
2.
x x x x x
- - - - -
- - - - -
]]
table.insert(paylineCombos, {0, 0, 0, 0, 0})
--[[
3.
- - - - -
- - - - -
x x x x x
]]
table.insert(paylineCombos, {2, 2, 2, 2, 2})
--[[
4.
x - - - x
- x - x -
- - x - -
]]
table.insert(paylineCombos, {0, 1, 2, 1, 0})
--[[
5.
- - x - -
- x - x -
x - - - x
]]
table.insert(paylineCombos, {2, 1, 0, 1, 2})
--[[
6.
- x x x -
x - - - x
- - - - -
]]
table.insert(paylineCombos, {1, 0, 0, 0, 1})
--[[
7.
- - - - -
x - - - x
- x x x -
]]
table.insert(paylineCombos, {1, 2, 2, 2, 1})
--[[
8.
x x - - -
- - x - -
- - - x x
]]
table.insert(paylineCombos, {0, 0, 1, 2, 2})
--[[
9.
- - - x x
- - x - -
x x - - -
]]
table.insert(paylineCombos, {2, 2, 1, 0, 0})
--[[
10.
- - - x -
x - x - x
- x - - -
]]
table.insert(paylineCombos, {1, 2, 1, 0, 1})
--[[
11.
- x - - -
x - x - x
- - - x -
]]
table.insert(paylineCombos, {1, 0, 1, 2, 1})
--[[
12.
x - - - x
- x x x -
- - - - -
]]
table.insert(paylineCombos, {0, 1, 1, 1, 0})
--[[
13.
- - - - -
- x x x -
x - - - x
]]
table.insert(paylineCombos, {2, 1, 1, 1, 2})
--[[
14.
x - x - x
- x - x -
- - - - -
]]
table.insert(paylineCombos, {0, 1, 0, 1, 0})
--[[
15.
- - - - -
- x - x -
x - x - x
]]
table.insert(paylineCombos, {2, 1, 2, 1, 2})
--[[
16.
- - x - -
x x - x x
- - - - -
]]
table.insert(paylineCombos, {1, 1, 0, 1, 1})
--[[
17.
- - - - -
x x - x x
- - x - -
]]
table.insert(paylineCombos, {1, 1, 2, 1, 1})
--[[
18.
x x - x x
- - - - -
- - x - -
]]
table.insert(paylineCombos, {0, 0, 2, 0, 0})
--[[
19.
- - x - -
- - - - -
x x - x x
]]
table.insert(paylineCombos, {2, 2, 0, 2, 2})
--[[
20.
x - - - x
- - - - -
- x x x -
]]
table.insert(paylineCombos, {0, 2, 2, 2, 0})


--Chance
local randSymbols = {}

--iR Logo	1:27
table.insert(randSymbols, 1)

--Katze 	2:27
table.insert(randSymbols, 2)
table.insert(randSymbols, 2)

--Infernus	1:9
table.insert(randSymbols, 3)
table.insert(randSymbols, 3)
table.insert(randSymbols, 3)

--NOS		4:27
table.insert(randSymbols, 4)
table.insert(randSymbols, 4)
table.insert(randSymbols, 4)
table.insert(randSymbols, 4)

--King		4:27
table.insert(randSymbols, 5)
table.insert(randSymbols, 5)
table.insert(randSymbols, 5)
table.insert(randSymbols, 5)

--Queen		6:27
table.insert(randSymbols, 6)
table.insert(randSymbols, 6)
table.insert(randSymbols, 6)
table.insert(randSymbols, 6)
table.insert(randSymbols, 6)
table.insert(randSymbols, 6)

--Joker		6:27
table.insert(randSymbols, 7)
table.insert(randSymbols, 7)
table.insert(randSymbols, 7)
table.insert(randSymbols, 7)
table.insert(randSymbols, 7)
table.insert(randSymbols, 7)

--Wildcard	1:27
table.insert(randSymbols, 8)

--SymbolValues
local symbolValue = {
	[1] = {[1] = 0, [2] = 0, [3] = 1500, [4] = 2500, [5] = 5000 },
	[2] = {[1] = 0, [2] = 0, [3] = 500, [4] = 1000, [5] = 2000 },
	[3] = {[1] = 0, [2] = 50, [3] = 100, [4] = 200, [5] = 500 },
	[4] = {[1] = 0, [2] = 10, [3] = 50, [4] = 100, [5] = 150 },
	[5] = {[1] = 0, [2] = 10, [3] = 50, [4] = 100, [5] = 150 },
	[6] = {[1] = 0, [2] = 10, [3] = 50, [4] = 100, [5] = 150 },
	[7] = {[1] = 0, [2] = 10, [3] = 50, [4] = 100, [5] = 150 },
	[8] = {[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 10000 }
}

local rows = 3
local columns = 5
function generateWinTable()
	local winTable = {}

	for i=1, rows, 1 do
		winTable[i] = {}
		for u=1, columns, 1 do
			winTable[i][u] = randSymbols[math.random(1, #randSymbols)]
		end
	end
	
	return winTable
end

local lineCount = 20
function getWinTableValue(rateTable)
	local winningLines = {}
	
	for k=1, lineCount, 1 do
		
	end
end

function clientWantsToPlay(tokens)
	
end
addEvent("onClientWantsToRollTheSlots", true)
addEventHandler("onClientWantsToRollTheSlots", getRootElement(), clientWantsToPlay)