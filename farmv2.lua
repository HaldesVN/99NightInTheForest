--// 99 Nights in the Forest: Auto Chop All Trees Script //--
-- Features: Chop all trees on map, choose tree type, show HP, Rayfield GUI

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "99 Nights - Auto Chop All Trees",
    LoadingTitle = "Auto Chop Tree Script",
    LoadingSubtitle = "by HaldesVN",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "99NightsAutoChop",
        FileName = "Settings"
    }
})

local AutoChopEnabled = false
local TreeType = "Small Tree"
local ShowTreeHP = false
local TeleportDelay = 0.16

local function isHoldingAxe()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Tool") and char:FindFirstChildOfClass("Tool").Name:lower():find("axe")
end

local function getHRP()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- Billboard HP
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

task.spawn(function()
    while true do
        if AutoChopEnabled and isHoldingAxe() then
            local hrp = getHRP()
            if hrp then
                local oldCFrame = hrp.CFrame
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
                        -- Teleport to tree, swing axe, return to old position
                        hrp.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                        task.wait(TeleportDelay)
                        for i=1,5 do
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
                            task.wait(0.08)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F, false, game)
                            task.wait(0.04)
                        end
                        if oldCFrame then
                            hrp.CFrame = oldCFrame
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
            end
        elseif not ShowTreeHP then
            for _, obj in workspace:GetDescendants() do
                removeTreeHPBillboard(obj)
            end
        end
        task.wait(0.6)
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
