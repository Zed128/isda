local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local LocalPlayer = game:GetService("Players").LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

function isRodEquiped()
	if Character:FindFirstChildOfClass("Tool") and Character:FindFirstChildOfClass("Tool"):FindFirstChild("events") and Character:FindFirstChildOfClass("Tool"):FindFirstChild("events"):FindFirstChild("cast") then
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

local Window = OrionLib:MakeWindow({Name = "Isda by Zed256", HidePremium = false})

local MainTab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local AutoEquipRodEnabled = false
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
		task.wait(0.5)  -- Reduced delay for faster checking
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
		if AutoShakeEnabled and LocalPlayer.PlayerGui:FindFirstChild("shakeui") and LocalPlayer.PlayerGui.shakeui.safezone:FindFirstChild("button") and LocalPlayer.PlayerGui.shakeui.safezone.button:FindFirstChild("buttonConsoleSense") then
			game:GetService("GuiService").SelectedObject = LocalPlayer.PlayerGui.shakeui.safezone.button
			keypress(Enum.KeyCode.Return)
			keyrelease(Enum.KeyCode.Return)
		end
		task.wait(0.05)  -- Reduced delay for faster shaking
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
		if AutoReelEnabled then
			if AutoReelType == "Fire Event" then
				local args = {
					[1] = 100,
					[2] = true
				}
				-- Fire the remote event (replace 'RemoteEvent' with the actual event name)
				local remoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("reelfinished"):FireServer(unpack(args))
				if remoteEvent then
					remoteEvent:FireServer()
				end
			elseif AutoReelType == "Follow Fish" then
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

MainTab:AddButton({
	Name = "Is Rod Equipped",
	Callback = function()
		print(isRodEquiped())
	end    
})

local PlayerTab = Window:MakeTab({
	Name = "Player",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

OrionLib:Init()
