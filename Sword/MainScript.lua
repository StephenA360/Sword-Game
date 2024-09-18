--To-do List

--[Stage 1]
--Change Dash to Body Velocity (DONE)
--Fix combo reseting when tool unequipped (DONE)
--FIX STUN PLS (DONE)
--Add hit animation (DONE, but change later)
--Clean up some prints/comments (DONE....for now...)
--Make run script replicate to server (DONE?)
--Redo how character is found (for buying swords in the future) (DONE?)
--Add an effect for blocking (DONE)

--[Stage 2]
--Fix possibleTargets problem :(
--Xp System (DONE)
--Add UI
--Health Bar (DONE)
--Menu
--Stats
--Shop

--[Stage 3]
--Add heavy attacks
--Add Enemies (More info in slime script)
--Add Sword Shop

--Make it possible to hit multiple enemies at once (FIGURE OUT ANIM EVENTS)
--Change some bindings (Run to w+w or shift and dash to Q)
--Dash effects
--Add abilities for each sword
--Add some anti-cheat

--Add different weapon types (Heavy, medium, light)
--Improve hit animation pls
--Mobile compatibility
--Change swing effect
--Change block animation ;-;
--Do other dash animations

--[Possible ideas]
--Add feinting?
--Figure out some sort of long ranged ability
--Air combat?


--{Defining Stuff}
local RS = game:GetService("ReplicatedStorage")
local CAS = game:GetService("ContextActionService")
local action_block = "Block"
local DRE = RS.RemoteEvents:WaitForChild("Dash")
local BRE = RS.RemoteEvents:WaitForChild("Block")
local RE = RS.RemoteEvents:WaitForChild("Hit")
local tool = script.Parent
local mouse = game.Players.LocalPlayer:GetMouse()
local uis = game:GetService("UserInputService")

local dmg = 8 -- Change Later
local range = 5
local PPush = game.ReplicatedStorage.RemoteEvents:WaitForChild("PPush")
local swingSound = script:WaitForChild("Swing")
local finalSound = script:WaitForChild("Final")

local combo = 0
local swingDebounce = false
local comboEnded = true
local character
local player = game.Players.LocalPlayer
if tool.Parent:IsA("Model") and tool.Parent.Name == player.Name then
	character = tool.Parent
elseif tool.Parent.Name == "Backpack" then
	character = player.Character
end
local hum = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local canAttackHumans = character:WaitForChild("CanAttackHumans")
local firstTime = true
local attackTime_e = 0
local dmgDebounce = false
local fireDebounce = false
local stunned = false
local stunCheck = 0
local stun = game.ReplicatedStorage.RemoteEvents.Stun
local trail = script.Parent.Handle.Trail
trail.Enabled = false
local speedDebounce = false
local blocking = false
local blockDebounce = false
local attacking = false
local bool = character:WaitForChild("BlockingBool")
local dashDebounce = false



--{Animation Table}
local comboAnim = {
	"rbxassetid://8035912129",
	"rbxassetid://8120953676",
	"rbxassetid://8035912129",
	"rbxassetid://8437090620"
}

--{Target Check Function}

local possibleTargets = {}
local function findTargets()
	table.clear(possibleTargets)
	--task.wait()
	for i, v in pairs(game.Workspace:GetDescendants()) do
		if v:IsA("Humanoid") then
			if v.Parent.Type == "Human" and canAttackHumans == false then return end
			if v.Parent ~= game.Players.LocalPlayer.Character then
				local target = v.Parent.HumanoidRootPart
				if table.find(possibleTargets, target) then return end
				--for i, v in pairs(possibleTargets) do
				--if v == target then
				--	if v.Parent == nil then
				--		local oldPos = table.find(possibleTargets, v)
				--		table.remove(possibleTargets, oldPos)
				--	end
				--	end
				--end

				table.insert(possibleTargets, target)

			end
		end
	end
end

--{Dash System}

uis.InputBegan:Connect(function(input, gameProcessed)

	if dashDebounce == true then return end
	if attacking == true then return end
	if swingDebounce == true then return end

	if input.KeyCode == Enum.KeyCode.W  then
		local tick1 = tick()
		uis.InputBegan:Connect(function(input2, gameProcessed)

			if input2.KeyCode == Enum.KeyCode.W then
				local tick2 = tick()
				if tick2 - tick1 <= 1 then
					if tick2 == tick1 then return end
					if dashDebounce == true then return end
					local dashAnimation = Instance.new("Animation")
					dashAnimation.AnimationId = "rbxassetid://13674951243"
					local dashAnim = character.Humanoid:LoadAnimation(dashAnimation)
					dashAnim:Play()
					dashDebounce = true
					local direction = input2.KeyCode
					DRE:FireServer(character, hrp, direction)
					task.delay(3, function()
						dashDebounce = false
					end)

				end
			end

		end)
	end
	if input.KeyCode == Enum.KeyCode.A then
		--pressedKey = keys[1]
		local tick1 = tick()
		uis.InputBegan:Connect(function(input2, gameProcessed)

			if input2.KeyCode == Enum.KeyCode.A then
				local tick2 = tick()
				if tick2 - tick1 <= 1 then
					if tick2 == tick1 then return end
					if dashDebounce == true then return end
					local dashAnimation = Instance.new("Animation")
					dashAnimation.AnimationId = "rbxassetid://13674951243"
					local dashAnim = character.Humanoid:LoadAnimation(dashAnimation)
					dashAnim:Play()
					dashDebounce = true
					local direction = input2.KeyCode
					DRE:FireServer(character, hrp, direction)
					task.delay(3, function()
						dashDebounce = false
					end)

				end
			end

		end)
	end
	if input.KeyCode == Enum.KeyCode.S then
		local tick1 = tick()
		uis.InputBegan:Connect(function(input2, gameProcessed)

			if input2.KeyCode == Enum.KeyCode.S then
				local tick2 = tick()
				if tick2 - tick1 <= 1 then
					if tick2 == tick1 then return end
					if dashDebounce == true then return end
					local dashAnimation = Instance.new("Animation")
					dashAnimation.AnimationId = "rbxassetid://13674951243"
					local dashAnim = character.Humanoid:LoadAnimation(dashAnimation)
					dashAnim:Play()
					dashDebounce = true
					local direction = input2.KeyCode
					DRE:FireServer(character, hrp, direction)
					task.delay(3, function()
						dashDebounce = false
					end)

				end
			end

		end)
	end
	if input.KeyCode == Enum.KeyCode.D then
		local tick1 = tick()
		uis.InputBegan:Connect(function(input2, gameProcessed)

			if input2.KeyCode == Enum.KeyCode.D then
				local tick2 = tick()
				if tick2 - tick1 <= 1 then
					if tick2 == tick1 then return end
					if dashDebounce == true then return end
					local dashAnimation = Instance.new("Animation")
					dashAnimation.AnimationId = "rbxassetid://13674951243"
					local dashAnim = character.Humanoid:LoadAnimation(dashAnimation)
					dashAnim:Play()
					dashDebounce = true
					local direction = input2.KeyCode
					DRE:FireServer(character, hrp, direction)
					task.delay(3, function()
						dashDebounce = false
					end)

				end
			end

		end)
	end
	--{W.I.P.?}
	if uis.GamepadEnabled == true then
		if input.KeyCode == Enum.KeyCode.ButtonB then

			if dashDebounce == true then return end
			local dashAnimation = Instance.new("Animation")
			dashAnimation.AnimationId = "rbxassetid://13674951243"
			local dashAnim = character.Humanoid:LoadAnimation(dashAnimation)
			dashAnim:Play()
			dashDebounce = true
			DRE:FireServer(character, hrp)
			task.delay(3, function()
				dashDebounce = false
			end)
		end
	end


end)


local function comboTimeOut()
	local currentCombo = combo


	task.wait(0.9)
	if combo == currentCombo then
		combo = 0
		trail.Enabled = false
	end
end

stun.OnClientEvent:Connect(function(v, reason)
	if reason == "block" then
		if v == hrp then
			stunned = true
			swingDebounce = true
			dmgDebounce = true
			task.wait(1.3)
			stunned = false
			swingDebounce = false
			dmgDebounce = false
		end
	end
	if reason == "hit" then
		if v == hrp then
			-- idek figure it out
			stunCheck = stunCheck + 1
			stunned = true
			task.wait(1.05)
			if stunCheck == 1 then
				stunned = false
				stunCheck = 0
			else
				stunCheck = 0
			end

		end
	end
end)

--{Blocking}
local function handleAction(actionName, inputState, inputObject)
	if actionName == action_block and inputState == Enum.UserInputState.Begin then
		if stunned == true then return end
		if tool.Enabled == false then return end
		if blockDebounce == true then return end
		if attacking == true then return end
		blockDebounce = true
		blocking = true
		BRE:FireServer(hum, bool, character)
		task.wait(1)
		blocking = false
		blockDebounce = false
	end
end



--{Main Stuff}




tool.Equipped:Connect(function()
	if tool.Enabled == false then return end
	CAS:BindAction(action_block, handleAction, true, Enum.KeyCode.F, Enum.KeyCode.ButtonX)

	local function swing()
		if stunned == true then return end

		if speedDebounce == false then
			speedDebounce = true
			character.Animate.walk.WalkAnim.AnimationId = "rbxassetid://7961415651"
			character.Humanoid.WalkSpeed = 5
			task.delay(1.25, function()
				character.Humanoid.WalkSpeed = 10
				speedDebounce = false
			end)
		end
		if stunned == true then return end
		findTargets()

		if combo == 0 then comboEnded = false end
		if comboEnded == true then return end
		if swingDebounce == false then
			attacking = true
			task.delay(0.37, function()
				trail.Enabled = true
			end)
			swingDebounce = true

			if combo == 0 then comboEnded = false end
			local attackTime_s = tick()
			combo = combo + 1

			if combo > #comboAnim then
				combo = 1
				print("Combo Reset")
				trail.Enabled = false
			end
			print("Combo: "..combo)
			tool.Unequipped:Connect(function()
				return function()
					return combo
				end
			end)

			local animation = Instance.new("Animation")
			animation.AnimationId = comboAnim[combo]
			local anim = hum:LoadAnimation(animation)
			anim:Play()
			script.PreSwing.TimePosition = 0.165
			script.PreSwing:Play()
			task.delay(0.43, function()
				swingSound:Play()
			end)

			task.delay(anim.Length, function()
				task.wait()
				trail.Enabled = false
			end)
			if combo == 4 then
				swingDebounce = true
				task.delay(1.25, function()
					swingDebounce = false
				end)
			elseif 0 == 0 then
				swingDebounce = true
				task.delay(0.75, function()
					swingDebounce = false
					comboTimeOut()
				end)
			end

			anim.Ended:Connect(function()
				attacking = false
			end)

			stun.OnClientEvent:Connect(function(v)
				if v == hrp then
					anim:Stop()
					return
				end
			end)


			if dmgDebounce == false then
				--{Function that finds the closest character in range}
				local function findTarget()
					local target
					findTargets()
					local distances = {}
					--for i, v in pairs(possibleTargets) do
					--	local distance = (v.Parent.HumanoidRootPart.Position - hrp.Position).Magnitude

					--	if distance <= range then
					--		table.insert(distances, distance)
					--	end
					--	table.sort(distances, function(a, b)
					--		return a < b
					--	end)


					--if (v.Parent.HumanoidRootPart.Position - hrp.Position).Magnitude == distances[1] then
					--	target = v
					--end 
					--end
					--return distances
				end
				findTargets()
				local finalTable = possibleTargets
				--for i, v in pairs(finalTable) do
				local counter = 0
				local lastCounter = 0
				local function mainFunction(v)
					local lastTable = {}

					--local v = findTarget()
					if v == nil then return end -- v is the enemy hrp
					local enemyToTarget = (v.Position - hrp.Position).Unit
					local charLook = hrp.CFrame.LookVector
					local dotProduct = enemyToTarget:Dot(charLook)
					if dotProduct <= 0.1 then return end
					if v == nil then return end
					table.insert(lastTable, v)
					lastCounter = lastCounter + 1

					if fireDebounce == false then
						if counter >= #finalTable then
							fireDebounce = true	
							dmgDebounce = true
						end

						if stunned == true then return end

						--{Combo Stuff}

						--if v.Parent == nil then 
						--	local i = table.find(possibleTargets, v)
						--	table.remove(possibleTargets, i)
					end -- Slime is dead

					--if v.Parent.Type == "Human" and canAttackHumans == false then return end
					if combo == 1 then
						--task.spawn(function()
						wait()
						anim:GetMarkerReachedSignal("Attack_Execute"):Connect(function()
							if (v.Position - hrp.Position).Magnitude > range then return end
							trail.Enabled = true
							RE:FireServer(v, combo, dmg)
							task.wait(0.25)
							dmgDebounce = false
							fireDebounce = false
							trail.Enabled = false
						end)
						--end)
					end
					if combo == 2 then
						--task.spawn(function()
						wait()
						anim:GetMarkerReachedSignal("Attack_Execute"):Connect(function()
							if (v.Position - hrp.Position).Magnitude > range then return end
							trail.Enabled = true
							RE:FireServer(v, combo, dmg)
							print(0)
							task.wait(0.25)
							dmgDebounce = false
							fireDebounce = false
							trail.Enabled = false
						end)

						--end)
					end
					if combo == 3 then
						--task.spawn(function()
						wait()
						anim:GetMarkerReachedSignal("Attack_Execute"):Connect(function()
							if (v.Position - hrp.Position).Magnitude > range then return end
							trail.Enabled = true
							RE:FireServer(v, combo, dmg)
							print(0)
							task.wait(0.25)
							dmgDebounce = false
							fireDebounce = false
							trail.Enabled = false
						end)
						--end)
					end
					if combo == 4 then
						--task.spawn(function()
						wait()
						anim:GetMarkerReachedSignal("Attack_Execute"):Connect(function()
							if (v.Position - hrp.Position).Magnitude > range then return end
							trail.Enabled = true
							finalSound:Play()
							RE:FireServer(v, combo, dmg)
							print(0)
							PPush:FireServer(v, combo, dmg)
							task.wait(0.5)
							dmgDebounce = false
							fireDebounce = false
							trail.Enabled = false
						end)
						--end)
					end
					if combo == 5 then
						comboEnded = true
						combo = 0
					end
					return lastCounter
				end

				for i, v in pairs(finalTable) do
					mainFunction(v)
					counter = counter + 1

				end
			elseif dmgDebounce == true then
				local checks = {}
				local Xcounter = 0
				repeat
					task.wait(0.1)
					if dmgDebounce == true then
						table.insert(checks, 1)
					elseif dmgDebounce == false then
						table.insert(checks, 2)
					end
					Xcounter = Xcounter + 0.1
				until Xcounter == 20
				if checks[50] == 1 then return end
				local tCount = 0
				local fCount = 0
				for i, v in pairs(checks) do
					if v == 1 then tCount = tCount + 1 end
					if v == 2 then fCount = fCount + 1 end
				end
				if tCount >= fCount then dmgDebounce = false end
			end


		end



		

	end
	if stunned == true then return end

	tool.Activated:Connect(swing)
end)


