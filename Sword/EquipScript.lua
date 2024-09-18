local Tool = script.Parent
local Sword = Tool:WaitForChild("Handle")
local oName = Tool.Name
local player = game.Players.LocalPlayer
local char = player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

local debounce = false
Tool.Equipped:Connect(function()
	if debounce == true then
		task.wait()
		hum:UnequipTools()
	end
	Tool.Enabled = true
	Tool.MainScript.Enabled = true
	--local char = Tool.Parent
	char.Animate.toolnone.ToolNoneAnim.AnimationId = "rbxassetid://12177940481"
	if char.Humanoid.WalkSpeed == 5 then
		char.Animate.walk.WalkAnim.AnimationId = "rbxassetid://7961415651"
	end
	if char.Humanoid.WalkSpeed == 30 then
		char.Animate.walk.WalkAnim.AnimationId = "rbxassetid://8012698677"
	end
	
	local character = script.Parent.Parent
	local arm = character:FindFirstChild("Right Arm")

	
	
	Tool.Unequipped:Connect(function()
		Tool.MainScript.Enabled = false
		char.Animate.idle.Animation1.AnimationId = "rbxassetid://8125732087"
		if debounce == true then return end
		Tool.Enabled = false
		debounce = true
		local countdown = 3
		Tool.Name = "3"
		repeat
			task.wait(1)
			countdown = countdown - 1
			Tool.Name = tostring(countdown)
		until countdown == 0
		debounce = false
		Tool.Enabled = true
		Tool.MainScript.Enabled = true
		Tool.Name = oName
	end)
end)


