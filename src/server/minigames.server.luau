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

function loadMap(mapIndex, activePlayers)
	local maps = game:GetService("ServerStorage"):WaitForChild("Maps"):GetChildren()
	local selectedMapModelClone = maps[mapIndex]:Clone()
	selectedMapModelClone.Parent = workspace
	local spawnPositionTable = createSpawns(selectedMapModelClone)

	-- spawn players into the map
	for _, v in pairs(activePlayers) do
		local character = v.Character
		local randomPosition = spawnPositionTable[getRandomTableIndex(spawnPositionTable)]
		character.HumanoidRootPart.Position = randomPosition
	end
end

local function main()
	local activePlayers = game:GetService("Players"):GetPlayers()
	loadMap(1, activePlayers)
end

task.wait(2)
main()
