local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local LocalPlayer: Player? = game:GetService("Players").LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

function isRodEquiped(): boolean
	if Character:FindFirstChildOfClass("Tool") and Character:FindFirstChildOfClass("Tool"):FindFirstChild("events") and Character:FindFirstChildOfClass("Tool"):FindFirstChild("events"):FindFirstChild("cast") then
		return true
	else
		return false
	end
end

function getRodToolFromBackpack(): Instance
	for i,v in pairs(LocalPlayer.Backpack:GetChildren()) do
		if v:FindFirstChild("events") and v:FindFirstChild("events"):FindFirstChild("cast") then
			return v
		else
			return nil
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

MainTab:AddSection({
	Name = "Auto Fish"
})

MainTab:AddToggle({
	Name = "Auto Equip Rod",
	Default = false,
	Callback = function(Value)
		print(getRodToolFromBackpack())
		AutoEquipRodEnabled = true
	end    
})
task.spawn(function()
	while AutoEquipRodEnabled do
		print(getRodToolFromBackpack())
		pcall(function()
			Character:WaitForChild("Humanoid"):EquipTool(getRodToolFromBackpack())
			task.wait(.25)
		end)
	end
end)

MainTab:AddToggle({
	Name = "Auto Shake",
	Default = false,
	Callback = function(Value)
		AutoShakeEnabled = true
	end    
})
task.spawn(function()
	while AutoShakeEnabled and LocalPlayer.PlayerGui:FindFirstChild("shakeui") and LocalPlayer.PlayerGui.shakeui.safezone:FindFirstChild("button") and LocalPlayer.PlayerGui.shakeui.safezone.button:FindFirstChild("buttonConsoleSense") do
		game:GetService("GuiService").SelectedObject = LocalPlayer.PlayerGui.shakeui.safezone.button
		keypress(Enum.KeyCode.Return)
		keyrelease(Enum.KeyCode.Return)
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
