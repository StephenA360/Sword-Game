local RE = game.ReplicatedStorage.RemoteEvents.Hit
local Debris = game:GetService("Debris")
local TS = game:GetService("TweenService")
local debounceVal = game.ReplicatedStorage:WaitForChild("debounceVal")

local comboEnd = true
local debounce = false
local PPush = game.ReplicatedStorage.RemoteEvents.PPush
local Sound = script.Sound
local stun = game.ReplicatedStorage.RemoteEvents.Stun
local box = game.ReplicatedStorage.Effects.HitEffectBox
local particleEffect = game.ReplicatedStorage.Effects.ParryParticle

local currentEXP = 0
local level = 1
local maxEXP = 100*(1.25^(level-4))
local expRE = game.ReplicatedStorage.RemoteEvents.EXP
plr0 = game.Players.PlayerAdded:Wait()

local expValues = require(game.ServerScriptService.XPInfo)

local function addEXP(plr, amount)
	if (currentEXP + amount) > maxEXP then
		print("X")
		local overflow = currentEXP + amount - maxEXP
		level = level + 1
		currentEXP = 0
		addEXP(plr, overflow)


	elseif (currentEXP + amount) == maxEXP then
		level = level + 1
		currentEXP = 0
	else
		currentEXP = currentEXP + amount
	end
	maxEXP = math.floor(100*(1.25^(level-4)))
	print(plr)
	plr:WaitForChild("expInfo").Level.Value = level
	plr:WaitForChild("expInfo").EXP.Value = currentEXP
	plr:WaitForChild("expInfo").MaxExp.Value = maxEXP
	expRE:FireClient(plr, level, currentEXP, maxEXP)
end
addEXP(plr0, 0)

PPush.OnServerEvent:Connect(function(player, v, combo)
	local bool = v.Parent:FindFirstChild("BlockingBool").Value
	if bool == true then
		return
	end
	local character = player.Character
	local push = Instance.new("BodyVelocity")
	push.P = 3000000
	push.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	push.Velocity = character.HumanoidRootPart.CFrame.lookVector * 80
	push.Parent = v
	push.Parent.Anchored = false
	Debris:AddItem(push, 0.3)
end)

RE.OnServerEvent:Connect(function(player, v, combo, dmg)
	if v.Parent:FindFirstChild("BlockingBool") then
		local bool = v.Parent:FindFirstChild("BlockingBool").Value
		if bool == true then
			local clashSound = script.ClashSound:Clone()
			clashSound.Parent = v
			clashSound:Play()
			local effect = particleEffect:Clone()
			local part = Instance.new("Part")
			part.Size = Vector3.new(1, 1, 1)
			local midpoint = v.Position:Lerp(player.Character.HumanoidRootPart.Position, 0.5)
			part.Position = midpoint
			part.Anchored = true
			part.CanCollide = false
			part.Transparency = 1
			part.Parent = workspace
			effect.Parent = part
			effect.Name = "Effect"
			effect.Enabled = false
			effect:Clear()
			task.wait()
			effect:Emit(30)
			Debris:AddItem(effect, 1)
			Debris:AddItem(part, 1)
			v = player.Character.HumanoidRootPart
			local reason = "block"
			stun:FireClient(player, v, reason)

			task.wait(1)
			clashSound:Destroy()
			return
		end
	end



	for i, part in pairs(v.Parent:GetChildren()) do
		if part:IsA("Part") then

			local redBox = box:Clone()
			redBox.Parent = part
			redBox.Adornee = redBox.Parent

			Debris:AddItem(redBox, 0.5)
			local tweenInfo = TweenInfo.new(

				0.3, --Time

				Enum.EasingStyle.Linear, --Easing Style

				Enum.EasingDirection.InOut, --EasingDirection

				1, --Repeat Count

				false, --Reverse

				0.2 --DelayTime

			)

			local tween = TS:Create(redBox, tweenInfo, {SurfaceTransparency = 1})
			tween:Play()
		end
	end
	--FIGURE THIS OUT LATER

	--if v.Parent.Type == "Human" then
	--if not v.Parent.Animate.hit then
	local soundEffect = Sound:Clone()
	soundEffect.Parent = v
	soundEffect:Play()
	Debris:AddItem(soundEffect, 1.5)
	v.Parent.Humanoid.Health = v.Parent.Humanoid.Health - dmg
	if v.Parent.Humanoid.Health <= 0 then
		if v.Parent.Name == "Slime" then
			addEXP(player, expValues.slimeEXP())
		end
	end
	local x = game.Players:GetPlayerFromCharacter(v.Parent)
	if x~= nil then
		local reason = "hit"
		stun:FireClient(x, v, reason)
	end

	debounceVal.Value = true
	task.wait(0.5)

	debounceVal.Value = false
	--end
	--else if v.Type == "Monster"
	--end
end)
