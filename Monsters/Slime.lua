--14180855554
--SlimeAttack1Execute

--To-Do-List

--Fix particle emitting problem(DONE)
--Fix Aggro System (DONE)
--Add mob wandering (DONE)
--Add hit and parry effect to target (DONE)

--Add another attack (Slime ball?)


-- Initializing all variables
local debris = game:GetService("Debris")
local TS = game:GetService("TweenService")
local runService = game:GetService("RunService")
local PS = game:GetService("PathfindingService")

local hum = script.Parent.Humanoid
local animator = hum:WaitForChild("Animator")
local hrp = script.Parent.HumanoidRootPart
local slime = script.Parent
local particleEffect = game.ReplicatedStorage.Effects.SlimeDustEffect
local parryEffect = game.ReplicatedStorage.Effects.ParryParticle
local box = game.ReplicatedStorage.Effects.HitEffectBox
local spawnPoint = slime.HumanoidRootPart.Position
local spawnEvent = game.ReplicatedStorage.SpawnEvents.SlimeSpawnEvent

local walkAnim = script.WalkAnim
local walkAnimTrack = animator:LoadAnimation(walkAnim)

local attack1Anim = script.AttackAnimations.Attack1
local attack1AnimTrack = animator:LoadAnimation(attack1Anim)

local points = workspace.CheckPoints
local attackDebounce = false
local dmgDebounce = false
local emitDebounce = false
local attacking = false
local targetFound = false
local canWander = true
local wanderReset = false

local damage
local range
local aggroDist = 20
local aggroTarget = nil


-- If the slime is moving, the animation will play
local function onWalking(speed)
	if speed > 0 then
		if not walkAnimTrack.IsPlaying then
			walkAnimTrack:Play()
		end
	else
		if walkAnimTrack.IsPlaying then
			walkAnimTrack:Stop()
		end
	end
end

-- [Function for the particle effect emmision]
local function emitEffect()
	if emitDebounce == true then return end
	local rayOrigin = slime:FindFirstChild("SlimeCore").Position
	local rayDirection = Vector3.new(0, -4, 0)
	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = {slime.SlimeCore, slime.HumanoidRootPart, slime.DustPart, slime.SlimeOuterLayer, slime.RightEye, slime.LeftEye}
	local rayResult = workspace:Raycast(rayOrigin, rayDirection, rayParams)
	local color = rayResult.Instance.Color
	local effect = particleEffect:Clone()
	effect.Parent = slime.DustPart
	effect.Color = ColorSequence.new(color)

	if emitDebounce == true then return end
	if emitDebounce == false then
		effect:Emit(20)	
	end
	local box = game.ReplicatedStorage.Effects.HitEffectBox

	emitDebounce = true
	debris:AddItem(effect, 3)
	task.delay(3, function()
		emitDebounce = false
		return
	end)

end
-- {This is the function for the slam attack}
local function attack1()
	if attackDebounce == true then return end
	attacking = true
	local possibleTargets = {}
	damage = 15
	range = 10
	attack1AnimTrack:Play()
	local function dmg(firstTick)
		if dmgDebounce == true then return end
		local counter = 0
		for i, v in pairs(possibleTargets) do
			if dmgDebounce == true then return end
			if counter <= #possibleTargets then
				if dmgDebounce == true then return end
				local bool = v.Parent:FindFirstChild("BlockingBool").Value
				--{Parry effect}
				if bool == true then -- {Checks if player is blocking}
					local clashSound = script.ClashSound:Clone()
					clashSound.Parent = v
					clashSound:Play()
					local effect = parryEffect:Clone()
					local part = Instance.new("Part")
					part.Size = Vector3.new(1, 1, 1)
					local midpoint = v.Parent.HumanoidRootPart.Position:Lerp(v.Parent.HumanoidRootPart.Position, 0.5)
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
					debris:AddItem(effect, 1)
					debris:AddItem(part, 1)
					debris:AddItem(clashSound, 1)
					return
				end
				--{Hit effect}
				for i, part in pairs(v.Parent:GetChildren()) do
					if part:IsA("Part") then

						local redBox = box:Clone()
						redBox.Parent = part
						redBox.Adornee = redBox.Parent

						debris:AddItem(redBox, 0.5)
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
				local target = v.Parent.HumanoidRootPart
				local enemyToTarget = (target.Position - hrp.Position).Magnitude



				local secondTick = tick()
				if secondTick - firstTick <= 0.5 then
					if enemyToTarget <= range and attacking == true then
						if dmgDebounce == false then
							dmgDebounce = true
							task.delay(1, function()
								dmgDebounce = false

							end)
							
							v:TakeDamage(damage)

							local character = slime
							local push = Instance.new("BodyVelocity")
							push.P = 3000000
							push.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
							push.Velocity = (v.Parent.HumanoidRootPart.Position - hrp.Position).Unit * 80
							push.Parent = v.Parent.HumanoidRootPart
							push.Parent.Anchored = false
							debris:AddItem(push, 0.4)
							attacking = false
							return attacking
						end
					end
				end

			end

		end
	end
	attack1AnimTrack:GetMarkerReachedSignal("Attack_Execute"):Connect(function()
		if attackDebounce == true then return end
		attackDebounce = true
		task.wait()
		emitEffect()
		script["Boom Hit"]:Play()
		attacking = true

		for i, v in pairs(game.Workspace:GetDescendants()) do
			if v:IsA("Humanoid") then
				if v.Parent ~= slime then
					local target = v.Parent.HumanoidRootPart
					local enemyToTarget = (target.Position - hrp.Position).Magnitude

					if enemyToTarget <= range then
						if table.find(possibleTargets, v) then 
						else
							table.insert(possibleTargets, v)
						end
					end
				end
			end
		end
		local firstTick = tick()
		dmg(firstTick)
		attacking = false
		canWander = false
		task.delay(1, function()
			canWander = true
		end)
		task.delay(3, function()
			attackDebounce = false
		end)

		return firstTick
	end)
end



local function aggro(target)
	canWander = false
	repeat
		--local Path = PS:CreatePath()
		--local MovingToPosition = target.Position --  + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
		--local ComputedPath = Path:ComputeAsync(hrp.Position, MovingToPosition)
		hum:MoveTo(target.Position)
		task.wait()
		if (target.Position - hrp.Position).Magnitude <= 8 then
			aggroTarget = target
			repeat
				attack1()
				repeat 
					task.wait(0.1)
				until attacking == false
				aggro(aggroTarget)
				--local Path2 = PS:CreatePath()
				--local MovingToPosition2 = target.Position -- - Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
				--local ComputedPath2 = Path:ComputeAsync(hrp.Position, MovingToPosition)
			until target.Parent.Humanoid.Health <= 0 or (target.Position - hrp.Position).Magnitude >= 30
			if target.Parent.Humanoid.Health <= 0 or (target.Position - hrp.Position).Magnitude >= 100 then
				task.wait(2)
				aggroTarget = nil
				targetFound = false
				canWander = true
				attacking = false

				return
			end
		end
		if (target.Position - hrp.Position).Magnitude >= 50 then
			task.wait()
			aggroTarget = nil
			targetFound = false
			attacking = false
			canWander = true
			wanderReset = true
			slime.Humanoid:MoveTo(spawnPoint)
			
			return aggroTarget, targetFound, attacking, canWander, wanderReset
		end
	until aggroTarget == nil

end

local function wander()
	if targetFound == true or aggroTarget ~= nil then
		return
	end
	local walkPoint = Vector3.new(math.random(spawnPoint.X - 50, spawnPoint.X + 50), 0, math.random(spawnPoint.Z - 50, spawnPoint.Z + 50))
	hum:MoveTo(walkPoint)
	repeat
		task.wait(0.1)
		hum:MoveTo(walkPoint)
		for i, v in pairs(game.Workspace:GetDescendants()) do
			if v:IsA("Humanoid") then
				if v.Parent ~= slime then
					--task.wait(0.75)
					local target = v.Parent.HumanoidRootPart
					local enemyToTarget = (target.Position - hrp.Position).Magnitude
					if enemyToTarget <= aggroDist then
						hum:MoveTo(hrp.Position)
						targetFound = true
						aggroTarget = target
						aggro(aggroTarget)
						return aggroTarget, targetFound
					end
					break
				end
				break
			end
		end
	until hum.MoveToFinished


end
--Vector3.new(0, 0, math.random(-25, -15)


hum.Running:Connect(onWalking)

while true do
	if aggroTarget ~= nil or targetFound == true then
		canWander = false
	end
	if canWander == true then
		wander()
		count = 0
		repeat
			if hum.MoveToFinished == false then
				continue
			end
			task.wait(0.1)
			count = count + 0.1
			for i, v in pairs(game.Workspace:GetDescendants()) do
				if v:IsA("Humanoid") then
					if v.Parent ~= slime then
						--task.wait(0.75)
						local target = v.Parent.HumanoidRootPart
						local enemyToTarget = (target.Position - hrp.Position).Magnitude
						if enemyToTarget <= aggroDist then
							hum:MoveTo(hrp.Position)
							targetFound = true
							aggroTarget = target
							aggro(aggroTarget)
							
							return aggroTarget, targetFound
						end

					end

				end
			end
		until count >= 5
		task.wait(7)
	end
	task.wait()
end
