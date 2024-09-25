local DSS = game:GetService("DataStoreService")

local plrInfo = DSS:GetDataStore("playerInfo")


game.Players.PlayerAdded:Connect(function(player)
	local expInfo = Instance.new("Folder")
	expInfo.Name = "expInfo"
	expInfo.Parent = player
	
	local level = Instance.new("IntValue")
	level.Name = "Level"
	level.Parent = expInfo
	
	local exp = Instance.new("IntValue")
	exp.Name = "EXP"
	exp.Parent = expInfo
	
	local maxExp = Instance.new("IntValue")
	maxExp.Name = "MaxExp"
	maxExp.Parent = expInfo
	
	local levelData
	local success, errormessage = pcall(function()
		levelData = plrInfo:GetAsync(player.UserId.."-level")
	end)
	if success then
		level.Value = levelData
		if level.Value == nil then
			level.Value = 1
			print("Level automatically set to 1.")
		end
	else
		print("There was an error whilst getting your data!")
		warn(errormessage)
	end
	level.Changed:Connect(function()
		maxExp.Value = math.floor(100*(1.25^(level-4)))
	end)
	
	local expData
	local success, errormessage = pcall(function()
		expData = plrInfo:GetAsync(player.UserId.."-exp")
	end)
	if success then
		exp.Value = expData
		if exp.Value == nil then
			exp.Value = 0
			print("EXP automatically set to 0.")
		end
	else
		print("There was an error whilst getting your data!")
		warn(errormessage)
	end
	
	local maxExpData
	local success, errormessage = pcall(function()
		maxExpData = plrInfo:GetAsync(player.UserId.."-maxExp")
	end)
	if success then
		maxExp.Value = maxExpData
		if maxExp.Value == nil then
			maxExp.Value = 51
			print("maxExp automatically set to 51.")
		end
	else
		print("There was an error whilst getting your data!")
		warn(errormessage)
	end
end)

game.Players.PlayerRemoving:Connect(function(player)
	local success, errormessage = pcall(function()
		plrInfo:SetAsync(player.UserId.."-level", player.expInfo.Level.Value)
	end)
	if success then
		print("Player data successfully saved!")
	else
		print("There was an error saving your data.")
		warn(errormessage)
	end
	
	local success, errormessage = pcall(function()
		plrInfo:SetAsync(player.UserId.."-exp", player.expInfo.EXP.Value)
	end)
	if success then
		print("Player data successfully saved!")
	else
		print("There was an error saving your data.")
		warn(errormessage)
	end
	
	local success, errormessage = pcall(function()
		plrInfo:SetAsync(player.UserId.."-maxExp", player.expInfo.MaxExp.Value)
	end)
	if success then
		print("Player data successfully saved!")
	else
		print("There was an error saving your data.")
		warn(errormessage)
	end
end)
