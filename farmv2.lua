--// 99 Nights MultiFarm Script with Rayfield GUI //--

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local Window = Rayfield:CreateWindow({
    Name = "99 Nights - MultiFarm",
    LoadingTitle = "MultiFarm Script",
    LoadingSubtitle = "by HaldesVN",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "MultiFarmSettings"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Variables
local AutoTreeEnabled = false
local AutoFireEnabled = false
local AutoChestEnabled = false
local AutoKillEnabled = false
local AutoPlantEnabled = false
local AutoCookEnabled = false
local AutoStrongholdEnabled = false
local AutoChestTPEnabled = false
local BringAllEnabled = false

-------------------------------------------------
-- AUTO CHẶT CÂY (Đứng một chỗ, chặt nhiều cây cùng lúc)
-------------------------------------------------
task.spawn(function()
    while true do
        if AutoTreeEnabled then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if (obj.Name == "Trunk" or obj.Name == "Main") and obj.Parent and (obj.Parent.Name == "Small Tree" or obj.Parent.Name == "Big Tree") then
                        -- Chỉ chặt cây trong phạm vi 25 studs xung quanh
                        if (obj.Position - hrp.Position).Magnitude < 25 then
                            if obj:FindFirstChildOfClass("ClickDetector") then
                                fireclickdetector(obj:FindFirstChildOfClass("ClickDetector"))
                            elseif obj:FindFirstChildWhichIsA("ProximityPrompt") then
                                fireproximityprompt(obj:FindFirstChildWhichIsA("ProximityPrompt"))
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.4) -- Spam nhanh nhưng không quá lag
    end
end)

-------------------------------------------------
-- AUTO FILL LỬA (Campfire, Firepit)
-------------------------------------------------
task.spawn(function()
    while true do
        if AutoFireEnabled then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name:lower():find("fire") or obj.Name:lower():find("campfire") or obj.Name:lower():find("firepit") then
                        if (obj.Position - hrp.Position).Magnitude < 25 then
                            if obj:FindFirstChildWhichIsA("ProximityPrompt") then
                                fireproximityprompt(obj:FindFirstChildWhichIsA("ProximityPrompt"))
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-------------------------------------------------
-- AUTO RƯƠNG (Item Chest, Stronghold Chest)
-------------------------------------------------
task.spawn(function()
    while true do
        if AutoChestEnabled then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name:lower():find("chest") then
                        if obj:GetPivot() and (obj:GetPivot().Position - hrp.Position).Magnitude < 30 then
                            if obj:FindFirstChildWhichIsA("ClickDetector") then
                                fireclickdetector(obj:FindFirstChildWhichIsA("ClickDetector"))
                            elseif obj:FindFirstChildWhichIsA("ProximityPrompt") then
                                fireproximityprompt(obj:FindFirstChildWhichIsA("ProximityPrompt"))
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-------------------------------------------------
-- AUTO KILL (Wolf, Cultist, Bear...)
-------------------------------------------------
local KillTargets = {"Wolf", "Alpha Wolf", "Bear", "Cultist", "Crossbow Cultist", "Polar Bear", "Bunny"}
task.spawn(function()
    while true do
        if AutoKillEnabled then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and table.find(KillTargets, obj.Name) and obj:FindFirstChild("HumanoidRootPart") then
                        if (obj.HumanoidRootPart.Position - hrp.Position).Magnitude < 20 then
                            -- Simulate attack (press F repeatedly)
                            for i=1,6 do
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
                                task.wait(0.08)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F, false, game)
                                task.wait(0.03)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.3)
    end
end)

-------------------------------------------------
-- AUTO PLANT (Sapling, Seed Box)
-------------------------------------------------
task.spawn(function()
    while true do
        if AutoPlantEnabled then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name == "Seed Box" or obj.Name == "Sapling" then
                        if (obj.Position - hrp.Position).Magnitude < 25 then
                            if obj:FindFirstChildWhichIsA("ProximityPrompt") then
                                fireproximityprompt(obj:FindFirstChildWhichIsA("ProximityPrompt"))
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-------------------------------------------------
-- AUTO COOK (Campfire/Firepit)
-------------------------------------------------
task.spawn(function()
    while true do
        if AutoCookEnabled then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name:lower():find("fire") or obj.Name:lower():find("campfire") or obj.Name:lower():find("firepit") then
                        if (obj.Position - hrp.Position).Magnitude < 25 then
                            if obj:FindFirstChildWhichIsA("ProximityPrompt") then
                                fireproximityprompt(obj:FindFirstChildWhichIsA("ProximityPrompt"))
                                -- Simulate press E to cook
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                task.wait(0.12)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-------------------------------------------------
-- AUTO STRONGHOLD (Stronghold Diamond Chest)
-------------------------------------------------
task.spawn(function()
    while true do
        if AutoStrongholdEnabled then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name == "Stronghold Diamond Chest" then
                        if obj:GetPivot() and (obj:GetPivot().Position - hrp.Position).Magnitude < 35 then
                            if obj:FindFirstChildWhichIsA("ProximityPrompt") then
                                fireproximityprompt(obj:FindFirstChildWhichIsA("ProximityPrompt"))
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-------------------------------------------------
-- AUTO CHEST TELEPORT (Teleport liên tục tới chest)
-------------------------------------------------
task.spawn(function()
    while true do
        if AutoChestTPEnabled then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local closest, shortest = nil, math.huge
            if hrp then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name:lower():find("chest") and obj:GetPivot() then
                        local dist = (obj:GetPivot().Position - hrp.Position).Magnitude
                        if dist < shortest then
                            shortest = dist
                            closest = obj
                        end
                    end
                end
                if closest then
                    LocalPlayer.Character:PivotTo(closest:GetPivot().Position + Vector3.new(0, 5, 0))
                end
            end
        end
        task.wait(5)
    end
end)

-------------------------------------------------
-- BRING ALL (Kéo tất cả model về vị trí mình)
-------------------------------------------------
task.spawn(function()
    while true do
        if BringAllEnabled then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChildWhichIsA("BasePart") and obj ~= LocalPlayer.Character then
                        local base = obj:FindFirstChildWhichIsA("BasePart")
                        base.CFrame = hrp.CFrame + Vector3.new(math.random(-5,5), 3, math.random(-5,5))
                    end
                end
            end
        end
        task.wait(8)
    end
end)

-------------------------------------------------
-- GUI Toggle
-------------------------------------------------
local Tab = Window:CreateTab("MultiFarm", 4483362458)

Tab:CreateToggle({
    Name = "Auto Chặt Cây (Đứng một chỗ)",
    CurrentValue = false,
    Callback = function(v) AutoTreeEnabled = v end
})

Tab:CreateToggle({
    Name = "Auto Fill Lửa",
    CurrentValue = false,
    Callback = function(v) AutoFireEnabled = v end
})

Tab:CreateToggle({
    Name = "Auto Mở Rương",
    CurrentValue = false,
    Callback = function(v) AutoChestEnabled = v end
})

Tab:CreateToggle({
    Name = "Auto Kill",
    CurrentValue = false,
    Callback = function(v) AutoKillEnabled = v end
})

Tab:CreateToggle({
    Name = "Auto Plant",
    CurrentValue = false,
    Callback = function(v) AutoPlantEnabled = v end
})

Tab:CreateToggle({
    Name = "Auto Cook",
    CurrentValue = false,
    Callback = function(v) AutoCookEnabled = v end
})

Tab:CreateToggle({
    Name = "Auto Stronghold",
    CurrentValue = false,
    Callback = function(v) AutoStrongholdEnabled = v end
})

Tab:CreateToggle({
    Name = "Auto Chest Teleport",
    CurrentValue = false,
    Callback = function(v) AutoChestTPEnabled = v end
})

Tab:CreateToggle({
    Name = "Bring All",
    CurrentValue = false,
    Callback = function(v) BringAllEnabled = v end
})

Rayfield:Notify({Title="MultiFarm Loaded", Content="Đã bật GUI MultiFarm!", Duration=5})
