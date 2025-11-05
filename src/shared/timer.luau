-- src/shared/timer.luau
local Timer = {}
Timer.__index = Timer

-- Create a new timer
-- totalSeconds: number (initial total seconds)
-- onFinished: optional callback when timer reaches zero
function Timer.new(totalSeconds, onFinished)
	local self = setmetatable({}, Timer)
	self.total = math.max(0, totalSeconds + 1 or 0)
	self.remaining = self.total
	self.running = false
	self.onFinished = onFinished
	return self
end

function Timer:start()
	if self.total <= 0 then
		if self.onFinished then
			task.spawn(self.onFinished)
		end
		return
	end
	self.running = true
end

function Timer:pause()
	self.running = false
end

-- Reset to a new total (or the original total if nil)
function Timer:reset(totalSeconds)
	if totalSeconds ~= nil then
		self.total = math.max(0, totalSeconds)
	end
	self.remaining = self.total
	self.running = false
end

-- Update should be called every frame with dt (seconds)
function Timer:update(dt)
	if not self.running then
		return
	end
	self.remaining = math.max(0, self.remaining - (dt or 0))
	if self.remaining <= 0 then
		self.running = false
		if self.onFinished then
			task.spawn(self.onFinished)
		end
	end
end

-- Returns formatted time like "2:00"
function Timer:getFormatted()
	local secs = math.max(0, math.ceil(self.remaining))
	local minutes = math.floor(secs / 60)
	local seconds = secs % 60
	return string.format("%d:%02d", minutes, seconds)
end

return Timer
