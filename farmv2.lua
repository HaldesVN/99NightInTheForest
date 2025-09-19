--// 99 Nights Auto Chop Tree Script: Vung rìu toàn map //--

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "99 Nights - Auto Chop Tree (Swing All)",
    LoadingTitle = "Auto Chop Tree Script",
    LoadingSubtitle = "by HaldesVN",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "AutoChopTreeSwingAllSettings"
    }
})

-- Variables
local AutoChopEnabled = false
local TreeType = "Small Tree"
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

-- Hiện HP cây
local function showTreeHPBillboard(tree)
    if not tree or not tree:IsA("BasePart") then return end
    if tree:FindFirstChild("TreeHP_Billboard") then
        tree.TreeHP_Billboard:Destroy()
    end
    local hpValue = nil
    for _, v in pairs(tree.Parent:GetChildren()) do
        if v.Name:lower():find("hp") and (v:IsA("NumberValue") or v:IsA("IntValue")) then
            hpValue = v.Value
        end
    end
    if not hpValue and tree.Parent:GetAttribute("HP") then
        hpValue = tree.Parent:GetAttribute("HP")
    end
    if not hpValue then
        for _, v in pairs(tree.Parent:GetChildren()) do
            if v:IsA("NumberValue") or v:IsA("IntValue") then
                hpValue = v.Value
                break
            end
        end
    end
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
        label.TextColor3 = Color3.fromRGB(255, 200, 85)
        label.TextStrokeTransparency = 0.3
        label.TextScaled = true
        billboard.Parent = tree
    end
end

local function removeTreeHPBillboard(tree)
    if tree and tree:FindFirstChild("TreeHP_Billboard") then
        tree.TreeHP_Billboard:Destroy()
    end
end

-- Vung rìu lên tất cả cây hợp lệ trên map
task.spawn(function()
    while true do
        if AutoChopEnabled and isHoldingAxe() then
            for _, obj in pairs(workspace:GetDescendants()) do
                local valid = false
                if obj.Position and (obj.Name == "Trunk" or obj.Name == "Main") and obj.Parent then
                    if TreeType == "All" then
                        if obj.Parent.Name == "Small Tree" or obj.Parent.Name == "Big Tree" then valid = true end
                    else
                        if obj.Parent.Name == TreeType then valid = true end
                    end
                end
                if valid then
                    -- Teleport rìu (hoặc nhân vật) tới cây rồi vung rìu ảo
                    -- Cách hiệu quả nhất: tạo effect va chạm rìu với cây
                    -- Nhưng do script client không thể di chuyển rìu, ta sẽ teleport nhân vật tạm thời tới cây, vung rìu rồi trở về vị trí cũ
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local oldCFrame = hrp and hrp.CFrame
                    if hrp then
                        hrp.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.13)
                        for i=1,4 do
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
                            task.wait(0.08)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F, false, game)
                            task.wait(0.03)
                        end
                        if oldCFrame then
                            hrp.CFrame = oldCFrame
                        end
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
            for _, obj in workspace:GetDescendants() do
                removeTreeHPBillboard(obj)
            end
        end
        task.wait(0.5)
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
    Name = "Bật/Tắt Auto Chặt Cây Toàn Map",
    CurrentValue = false,
    Callback = function(v)
        AutoChopEnabled = v
        Rayfield:Notify({
            Title = "Auto Chop Tree",
            Content = v and "Đã bật auto chặt cây toàn map!" or "Đã tắt auto chặt cây!",
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
