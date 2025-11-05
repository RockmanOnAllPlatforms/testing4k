local playerManager = {}
playerManager.__index = playerManager
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

playerManager.Players = {}

function playerManager.new(username, id)
	local newPlayerObj = {}
	newPlayerObj.username = username
	newPlayerObj.id = id
	newPlayerObj.active = true
	table.insert(playerManager.Players, newPlayerObj)
	setmetatable(newPlayerObj, playerManager)
	return newPlayerObj
end

Players.PlayerAdded:Connect(function(plr)
	playerManager.new(plr.Name, plr.UserId)
end)

function playerManager:changeStatus()
	self.active = not self.active
	print(self.active)
end

local timeRemote = ReplicatedStorage:WaitForChild("timeEvent")

function playerManager:startClientTimer(time)
	local Player = Players:GetPlayerByUserId(self.id)
	timeRemote:FireClient(Player, time)
end

function playerManager.getActivePlayers()
	local tmp = {}
	for _, v in pairs(playerManager.Players) do
		if v.active then
			table.insert(tmp, v)
		end
	end
	return tmp
end

return playerManager
