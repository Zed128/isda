local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local LocalPlayer = game:GetService("Players").LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

function isRodEquiped()
	local tool = Character:FindFirstChildOfClass("Tool")
	if tool and tool:FindFirstChild("events") and tool.events:FindFirstChild("cast") then
		return true
	else
		return false
	end
end

function getRodToolFromBackpack()
	for i, v in pairs(LocalPlayer.Backpack:GetChildren()) do
		if v:FindFirstChild("events") and v.events:FindFirstChild("cast") then
			return v
		end
	end
	return nil
end

function getRodToolFromCharacter()
	local tool = Character:FindFirstChildOfClass("Tool")
	if tool and tool:FindFirstChild("events") and tool.events:FindFirstChild("cast") then
		return tool
	else
		return nil
	end
end

local Window = OrionLib:MakeWindow({Name = "Isda by Zed256", HidePremium = false})

local MainTab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4370345169",
	PremiumOnly = false
})

--None, Shaking, Reeling
local CurrentAction = "None"
LocalPlayer.PlayerGui.ChildAdded:Connect(function(child)
	if child.Name == "shakeui" then
		CurrentAction = "Shaking"
	elseif child.Name == "reel" then 
		CurrentAction = "Shaking"
	end
end)
LocalPlayer.PlayerGui.ChildRemoved:Connect(function(child)
	if child.Name == "shakeui" or child.Name == "reel" then
		CurrentAction = "None"
	end
end)
if LocalPlayer.PlayerGui:FindFirstChild("shakeui") then
	CurrentAction = "Shaking"
elseif LocalPlayer.PlayerGui:FindFirstChild("reel") then
	CurrentAction = "Shaking"
end

local AutoEquipRodEnabled = false
local AutoCastEnabled = false
local AutoCastRange = {95, 100}
local AutoShakeEnabled = false
local AutoReelEnabled = false
local AutoReelType = "Fire Event"

MainTab:AddSection({
	Name = "Auto Fish"
})

MainTab:AddToggle({
	Name = "Auto Equip Rod",
	Default = false,
	Callback = function(Value)
		AutoEquipRodEnabled = Value
	end    
})

task.spawn(function()
	while true do
		if AutoEquipRodEnabled then
			local rod = getRodToolFromBackpack()
			if rod then
				pcall(function()
					Character:WaitForChild("Humanoid"):EquipTool(rod)
				end)
			end
		end
		task.wait(0.5)
	end
end)

MainTab:AddToggle({
	Name = "Auto Cast",
	Default = false,
	Callback = function(Value)
		AutoCastEnabled = Value
	end    
})
MainTab:AddSlider({
	Name = "Starting Auto Cast Range",
	Min = 0,
	Max = 100,
	Default = 95,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Starting Auto Cast Range",
	Callback = function(Value)
		AutoCastRange[1] = tonumber(Value)
	end    
})
MainTab:AddSlider({
	Name = "Ending Auto Cast Range",
	Min = 0,
	Max = 100,
	Default = 100,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Ending Auto Cast Range",
	Callback = function(Value)
		AutoCastRange[2] = tonumber(Value)
	end    
})
task.spawn(function()
	while true do
		if AutoCastEnabled and CurrentAction == "None" and isRodEquiped() then
			local rod = getRodToolFromCharacter()
			if rod and rod:FindFirstChild("events") and rod.events:FindFirstChild("cast") then
				local args = {
					[1] = Random.new():NextInteger(AutoCastRange[1], AutoCastRange[2]),
					[2] = 1
				}
				rod.events.cast:FireServer(unpack(args))
			end
		end
		task.wait(0.5)
	end
end)

MainTab:AddToggle({
	Name = "Auto Shake",
	Default = false,
	Callback = function(Value)
		AutoShakeEnabled = Value
	end    
})

task.spawn(function()
	while true do
		if AutoShakeEnabled and CurrentAction == "Shaking" and LocalPlayer.PlayerGui:FindFirstChild("shakeui") and LocalPlayer.PlayerGui.shakeui.safezone:FindFirstChild("button") and LocalPlayer.PlayerGui.shakeui.safezone.button:FindFirstChild("buttonConsoleSense") then
			if LocalPlayer.PlayerGui.shakeui.safezone:FindFirstChild("button") then
				game:GetService("GuiService").SelectedObject = LocalPlayer.PlayerGui.shakeui.safezone.button	
			end
			keypress(Enum.KeyCode.Return)
			keyrelease(Enum.KeyCode.Return)
		end
		task.wait(0.05)
	end
end)

MainTab:AddToggle({
	Name = "Auto Reel",
	Default = false,
	Callback = function(Value)
		AutoReelEnabled = Value
	end    
})

MainTab:AddDropdown({
	Name = "Dropdown",
	Default = "Fire Event",
	Options = {"Fire Event", "Follow Fish"},
	Callback = function(Value)
		AutoReelType = Value
	end    
})

task.spawn(function()
	while true do
		if AutoReelEnabled and CurrentAction == "Reeling" then
			print(1)
			if AutoReelType == "Fire Event" then
				print(2)
				local args = {
					[1] = 100,
					[2] = true
				}
				-- Fire the remote event (replace 'RemoteEvent' with the actual event name)
				local remoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("reelfinished")
				if remoteEvent then
					remoteEvent:FireServer(unpack(args))
				end
			elseif AutoReelType == "Follow Fish" then
				print(3)
				-- Follow the fish by adjusting the playerbar X position to match the fish X position
				local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
				if playerGui then
					local reel = playerGui:FindFirstChild("reel")
					if reel and reel:FindFirstChild("bar") and reel.bar:FindFirstChild("playerbar") and reel.bar:FindFirstChild("fish") then
						reel.bar.playerbar.Position = UDim2.new(reel.bar.fish.Position.X.Scale, reel.bar.fish.Position.X.Offset, reel.bar.playerbar.Position.Y.Scale, reel.bar.playerbar.Position.Y.Offset)
					end
				end
			end
		end
		task.wait(0.1)  -- Adjust the delay as needed
	end
end)

MainTab:AddSection({
	Name = "Exploits"
})

MainTab:AddButton({
	Name = "Max Rod Stats (Not sure if everything works)",
	Callback = function()
		require(game:GetService("ReplicatedStorage").modules.library.rods)[getRodToolFromBackpack().Name].Luck = math.huge
		require(game:GetService("ReplicatedStorage").modules.library.rods)[getRodToolFromBackpack().Name].LureSpeed = math.huge
		require(game:GetService("ReplicatedStorage").modules.library.rods)[getRodToolFromBackpack().Name].Strength = math.huge
		require(game:GetService("ReplicatedStorage").modules.library.rods)[getRodToolFromBackpack().Name].Resilience = math.huge
		require(game:GetService("ReplicatedStorage").modules.library.rods)[getRodToolFromBackpack().Name].Control = .7
		
		OrionLib:MakeNotification({
			Name = "Successfully Maxed Rod",
			Content = "Note: This resets once you leave the game",
			Image = "rbxassetid://4483345998",
			Time = 5
		})
	end    
})

MainTab:AddButton({
	Name = "Is Rod Equipped",
	Callback = function()
		print(isRodEquiped())
	end    
})

local PlayerTab = Window:MakeTab({
	Name = "Player",
	Icon = "rbxassetid://6961018899",
	PremiumOnly = false
})

local SettingsTab = Window:MakeTab({
	Name = "Settings",
	Icon = "rbxassetid://4483345743",
	PremiumOnly = false
})

OrionLib:Init()
