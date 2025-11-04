-- user presses key to toggle radio start listening
-- user sends a chat
-- filter chat
-- replicates to all clients
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local radioEvent = ReplicatedStorage:WaitForChild("radioEvent")
local activeClients = {}

local spamReset = 10
local spamMessages = 10

local function getFilterResult(text, fromUserId)
	local filterResult

	local success, errorMessage = pcall(function()
		filterResult = TextService:FilterStringAsync(text, fromUserId)
	end)

	if success then
		return filterResult
	else
		warn("Error generating TextFilterResult:", errorMessage)
		return nil
	end
end

local function onInputReceived(player, text)
	if text ~= "" then
		local filterResult = getFilterResult(text, player.UserId)

		if filterResult then
			local success, filteredText = pcall(function()
				return filterResult:GetNonChatStringForBroadcastAsync()
			end)

			if success then
				return filteredText
			else
				return "Filtering Error..."
			end
		end
	end
end

local function replicateMessage(player, msg)
	local client = activeClients[player.UserId]
	if not client["active"] then
		return
	end
	if
		(client["recentMessages"] >= spamMessages) and ((os.time() - client["lastMessageTimestamp"]) < spamReset)
		or client["tempBlock"]
	then
		radioEvent:FireClient(player, "Sending too many messages, slow down!")
		print(string.format("%s has been blocked for spamming the chat", player.Name))
		if not client["tempBlock"] then
			client["tempBlock"] = true
			client["recentMessages"] = 0
			client["lastMessageTimestamp"] = os.time()
			task.delay(5, function()
				client["tempBlock"] = false
			end)
		end
	end

	client["recentMessages"] += 1
	client["lastMessageTimestamp"] = os.time()
	print(client["lastMessageTimestamp"])
end

local function setupConnections(plr)
	activeClients[plr.UserId] = {
		["active"] = false,
		["recentMessages"] = 0,
		["lastMessageTimestamp"] = 0,
		["tempBlock"] = false,
	}
	plr.Chatted:Connect(function(msg)
		local filteredMsg = onInputReceived(plr, msg)
		replicateMessage(plr, filteredMsg)
	end)
end

local function init()
	local players = Players:GetPlayers()
	for _, plr in pairs(players) do
		setupConnections(plr)
	end
	Players.PlayerAdded:Connect(function(plr)
		setupConnections(plr)
	end)
end

local function changeActiveStatus(player)
	activeClients[player.UserId]["active"] = not activeClients[player.UserId]["active"]
	print(player, activeClients[player.UserId])
end

init()
radioEvent.OnServerEvent:Connect(changeActiveStatus)
