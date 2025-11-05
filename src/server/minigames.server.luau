local Players = game:GetService("Players")
local sharedFolder = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local playerManager = require(sharedFolder.playerManager)
local timerModule = require(sharedFolder.utilities.timer)
local mapModule = require(script.Parent.mapModule)

local function createSpawns(map: Model)
	local Positions = {}
	local spawnsFolder = map:FindFirstChild("Spawns")
	if not spawnsFolder then
		error("No spawns located")
	end
	local spawns = spawnsFolder:GetChildren()
	for _, v in pairs(spawns) do
		table.insert(Positions, v.Position)
	end
	return Positions
end

local function getRandomTableIndex(tbl)
	local max = 100000000
	local seed = math.random(max)
	local generator = Random.new(seed)

	return generator:NextInteger(1, #tbl)
end

--[[ Map Data Example

["Example Map"] = {
    ["Name"] = "Example",
    ["mapObject"] = mapFolder[1],
    ["mapBehaviorFunction"] = nil, 
    ["mapTime"] = 120
}

]]--

function loadMap(mapIndex, activePlayers)
	local maps = mapModule.maps
	local selectedMap = maps[mapIndex]
	local selectedMapModelClone = selectedMap["mapObject"]:Clone()
	-- here
	selectedMapModelClone.Parent = workspace
	local spawnPositionTable = createSpawns(selectedMapModelClone)

	-- spawn players into the map
	for _, plrObj in pairs(activePlayers) do
		print(plrObj)
		local Player = Players:GetPlayerByUserId(plrObj.id)
		plrObj:changeStatus()
		plrObj:startClientTimer(selectedMap.mapTime)
		local character = Player.Character
		local randomPosition = spawnPositionTable[getRandomTableIndex(spawnPositionTable)]
		character.HumanoidRootPart.Position = randomPosition
	end
end
-- TODO: 
-- Create module for seperate levels
local function main()
	local activePlayers = playerManager.getActivePlayers()
	local serverTimerObject = timerModule.new(120) -- could add a callback 
	loadMap(1, activePlayers)
end

task.wait(2)
main()
