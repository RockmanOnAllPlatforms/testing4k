local ServerStorage = game:GetService("ServerStorage")
local mapFolder = ServerStorage:WaitForChild("Maps")

local maps = {
	{
		["Name"] = "Example",
		["mapObject"] = mapFolder["Glass Houses map"],
		["mapBehaviorFunction"] = nil, -- could add a reference to another module to create the custom behavior for specific games
		["mapTime"] = 120,
	},
	{
		["Name"] = "Example2",
		["mapObject"] = mapFolder["Map City"],
		["mapBehaviorFunction"] = nil, -- could add a reference to another module to create the custom behavior for specific games
		["mapTime"] = 60,
	},
}

return maps
