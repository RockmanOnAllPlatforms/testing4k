local ServerStorage = game:GetService("ServerStorage")
local mapFolder = ServerStorage:WaitForChild("Maps")
local maps = {
    [1] = {
        ["Name"] = "Example",
        ["mapObject"] = mapFolder[1],
        ["mapBehaviorFunction"] = nil, -- could add a reference to another module to create the custom behavior for specific games
        ["mapTime"] = 120
    }
}

return maps