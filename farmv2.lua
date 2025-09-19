--// 99 Nights Auto Chop Tree Script: Hiện HP cây với Rayfield GUI //--

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "99 Nights - Auto Chop Tree (Show HP)",
    LoadingTitle = "Auto Chop Tree Script",
    LoadingSubtitle = "by HaldesVN",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "AutoChopTreeHPSettings"
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
local ShowTreeHP = false

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

local function getChopRemote()
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("chop") then
            return v
        end
    end
    return nil
end

-- Billboard cho HP cây
local function showTreeHPBillboard(tree)
    if not tree or not tree:IsA("BasePart") then return end
    -- Xoá cũ
    if tree:FindFirstChild("TreeHP_Billboard") then
        tree.TreeHP_Billboard:Destroy()
    end
    -- Tìm giá trị HP
    local hpValue = nil
    for _, v in pairs(tree.Parent:GetChildren()) do
        if v.Name:lower():find("hp") and (v:IsA("NumberValue") or v:IsA("IntValue")) then
            hpValue = v.Value
        end
    end
    -- Nếu không tìm thấy, thử lấy Attribute
    if not hpValue and tree.Parent:GetAttribute("HP") then
        hpValue = tree.Parent:GetAttribute("HP")
    end
    -- Nếu không tìm thấy, thử lấy mọi Value trong tree
    if not hpValue then
        for _, v in pairs(tree.Parent:GetChildren()) do
            if v:IsA("NumberValue") or v:IsA("IntValue") then
                hpValue = v.Value
                break
            end
        end
    end

    -- Nếu tìm thấy HP
    if hpValue then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "TreeHP_Billboard"
        billboard.Adornee = tree
        billboard.Size = UDim2.new(0, 80, 0, 30)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 3, 0)

        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = "HP: " .. tostring(hpValue)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(85,255,85)
        label.TextStrokeTransparency = 0.3
        label.TextScaled = true
        billboard.Parent = tree
    end
end

-- Xoá billboard khi không hiện HP
local function removeTreeHPBillboard(tree)
    if tree and tree:FindFirstChild("TreeHP_Billboard") then
        tree.TreeHP_Billboard:Destroy()
    end
end

-- Loop auto chặt cây và hiện HP
task.spawn(function()
    while true do
        if AutoChopEnabled and isHoldingAxe() then
            local remote = getChopRemote()
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
                    if remote then
                        remote:FireServer(obj)
                    end
                    if obj:FindFirstChildOfClass("ClickDetector") then
                        fireclickdetector(obj:FindFirstChildOfClass("ClickDetector"))
                    end
                    if obj:FindFirstChildWhichIsA("ProximityPrompt") then
                        fireproximityprompt(obj:FindFirstChildWhichIsA("ProximityPrompt"))
                    end
                    if ShowTreeHP then
                        showTreeHPBillboard(obj)
                    else
                        removeTreeHPBillboard(obj)
                    end
                elseif ShowTreeHP == false then
                    removeTreeHPBillboard(obj)
                end
            end
        elseif not ShowTreeHP then
            -- Xoá mọi HP billboard khi tắt
            for _, obj in workspace:GetDescendants() do
                removeTreeHPBillboard(obj)
            end
        end
        task.wait(0.4)
    end
end)

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

Tab:CreateToggle({
    Name = "Hiện HP của Cây",
    CurrentValue = false,
    Callback = function(v)
        ShowTreeHP = v
        Rayfield:Notify({
            Title = "Hiện HP Cây",
            Content = v and "Đã hiện HP cây!" or "Đã tắt hiện HP cây!",
            Duration = 3
        })
    end
})

Rayfield:Notify({Title="Auto Chop Tree Loaded", Content="Script đã sẵn sàng!", Duration=3})
