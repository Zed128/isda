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
        task.wait(0.25)
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
        task.wait(0.25)
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
