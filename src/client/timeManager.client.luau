local player = game.Players.LocalPlayer
local plrGui = player.PlayerGui
local timerGui = plrGui:WaitForChild("Timer")
local RS = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local timeEvent = RS:WaitForChild("timeEvent")
local timeModule = require(RS:WaitForChild("Shared").utilities.timer)

timeEvent.onClientEvent:Connect(function(time)
	local timer = timeModule.new(time)
	timer:start()

	task.spawn(function()
		while timer.remaining > 0 do
			timer:update(1)
			print(timer:getFormatted())
			task.wait(1)
		end
	end)
end)
