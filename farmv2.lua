--// 99 Nights Auto Chop Tree Script with Rayfield GUI //--

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "99 Nights - Auto Chop Tree",
    LoadingTitle = "Auto Chop Tree Script",
    LoadingSubtitle = "by HaldesVN",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "AutoChopTreeSettings"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Variables
local AutoChopEnabled = false
local TreeType = "Small Tree" -- "Small Tree", "Big Tree", "All"
local Distance = 18

-- Helper: Check tool
local function isHoldingAxe()
    local char = LocalPlayer.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and tool.Name:lower():find("axe") then
            return true
        end
    end
    return false
end

-- Helper: Get RemoteEvent for chopping (if available)
local function getChopRemote()
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("chop") then
            return v
        end
    end
    return nil
end

-- Helper: Get HRP
local function getHRP()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- Chop tree logic
task.spawn(function()
    while true do
        if AutoChopEnabled and isHoldingAxe() then
            local hrp = getHRP()
            local remote = getChopRemote()
            if hrp then
                for _, obj in workspace:GetDescendants() do
                    local valid = false
                    if obj.Position and (obj.Name == "Trunk" or obj.Name == "Main") and obj.Parent then
                        if TreeType == "All" then
                            if obj.Parent.Name == "Small Tree" or obj.Parent.Name == "Big Tree" then valid = true end
                        else
                            if obj.Parent.Name == TreeType then valid = true end
                        end
                    end
                    if valid then
                        local dist = (obj.Position - hrp.Position).Magnitude
                        if dist <= Distance then
                            -- RemoteEvent (nếu có)
                            if remote then
                                remote:FireServer(obj)
                            end
                            -- ClickDetector
                            if obj:FindFirstChildOfClass("ClickDetector") then
                                fireclickdetector(obj:FindFirstChildOfClass("ClickDetector"))
                            end
                            -- ProximityPrompt
                            if obj:FindFirstChildWhichIsA("ProximityPrompt") then
                                fireproximityprompt(obj:FindFirstChildWhichIsA("ProximityPrompt"))
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.3)
    end
end)

-- UI
local Tab = Window:CreateTab("Auto Chop Tree", 4483362458)

Tab:CreateDropdown({
    Name = "Chọn Loại Cây",
    Options = {"Small Tree", "Big Tree", "All"},
    CurrentOption = "Small Tree",
    Callback = function(option)
        TreeType = option
        Rayfield:Notify({Title="Loại Cây", Content="Đã chọn: " .. option, Duration=2})
    end
})

Tab:CreateSlider({
    Name = "Khoảng Cách Chặt (Studs)",
    Range = {8, 50},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = Distance,
    Callback = function(v)
        Distance = v
        Rayfield:Notify({Title="Khoảng cách", Content="Đã chọn: " .. v .. " studs", Duration=2})
    end
})

Tab:CreateToggle({
    Name = "Bật/Tắt Auto Chặt Cây",
    CurrentValue = false,
    Callback = function(v)
        AutoChopEnabled = v
        Rayfield:Notify({
            Title = "Auto Chop Tree",
            Content = v and "Đã bật auto chặt cây!" or "Đã tắt auto chặt cây!",
            Duration = 3
        })
    end
})

Rayfield:Notify({Title="Auto Chop Tree Loaded", Content="Script đã sẵn sàng!", Duration=3})
