-- LocalScript ▶ StarterPlayer ▶ StarterPlayerScripts

-- DEBUG: Kiểm tra LocalScript có chạy
print("✅ AutoMenu LocalScript loaded")

-- Tham chiếu
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Bảng trạng thái
local enabled = {
    ChopTree      = false,
    FillFire      = false,
    OpenChest     = false,
    KillAura      = false,
    Plant         = false,
    Stronghold    = false,
    BringAllItem  = false
}

-- Tạo ScreenGui
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Khoảng cách hạ menu xuống
local guiOffsetY = 50

-- Dữ liệu các nút
local buttonData = {
    {name="ChopTree",     text="Auto Chặt Cây",   y=100},
    {name="FillFire",     text="Auto Đổ Lửa",     y=140},
    {name="OpenChest",    text="Auto Mở Rương",   y=180},
    {name="KillAura",     text="Kill Aura",        y=220},
    {name="Plant",        text="Auto Trồng Cây",   y=260},
    {name="Stronghold",   text="Auto Stronghold",  y=300},
    {name="BringAllItem", text="Bring All Item",   y=340}
}

-- Tạo các nút
for _, data in ipairs(buttonData) do
    local btn = Instance.new("TextButton")
    btn.Name             = data.name
    btn.Text             = data.text .. " OFF"
    btn.Size             = UDim2.new(0, 200, 0, 32)
    btn.Position         = UDim2.new(0, 20, 0, data.y + guiOffsetY)
    btn.BackgroundColor3 = Color3.fromRGB(179, 51, 51)
    btn.TextColor3       = Color3.fromRGB(255, 255, 255)
    btn.Font             = Enum.Font.SourceSansBold
    btn.TextSize         = 18
    btn.Parent           = screenGui

    -- Click để bật/tắt
    btn.MouseButton1Click:Connect(function()
        enabled[data.name] = not enabled[data.name]
        if enabled[data.name] then
            btn.BackgroundColor3 = Color3.fromRGB(51, 179, 51)
            btn.Text = data.text .. " ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(179, 51, 51)
            btn.Text = data.text .. " OFF"
        end
    end)
end

-- ===== Định nghĩa hàm Auto =====

local function autoChopTree()
    local folder = workspace:FindFirstChild("Trees") or workspace:FindFirstChild("TreeFolder")
    if not folder then return end
    for _, tree in ipairs(folder:GetChildren()) do
        if tree:FindFirstChild("Chop") and tree.Chop:FindFirstChild("ClickDetector") then
            fireclickdetector(tree.Chop.ClickDetector)
            task.wait(0.2)
        end
    end
end

local function autoFillFire()
    local folder = workspace:FindFirstChild("Fires") or workspace:FindFirstChild("FireFolder")
    if not folder then return end
    for _, fire in ipairs(folder:GetChildren()) do
        if fire:FindFirstChild("Fill") and fire.Fill:FindFirstChild("ClickDetector") then
            fireclickdetector(fire.Fill.ClickDetector)
            task.wait(0.2)
        end
    end
end

local function autoOpenChest()
    local folder = workspace:FindFirstChild("Chests") or workspace:FindFirstChild("ChestFolder")
    if not folder then return end
    for _, chest in ipairs(folder:GetChildren()) do
        if chest:FindFirstChild("Open") and chest.Open:FindFirstChild("ClickDetector") then
            fireclickdetector(chest.Open.ClickDetector)
            task.wait(0.2)
        end
    end
end

local function killAura()
    local folder = workspace:FindFirstChild("Monsters") or workspace:FindFirstChild("EnemyFolder")
    if not folder or not character.PrimaryPart then return end
    for _, mob in ipairs(folder:GetChildren()) do
        local hum = mob:FindFirstChildOfClass("Humanoid")
        local root = mob.PrimaryPart or mob:FindFirstChild("HumanoidRootPart")
        if hum and root and (root.Position - character.PrimaryPart.Position).Magnitude < 20 then
            hum.Health = 0
        end
    end
end

local function autoPlant()
    local evt = ReplicatedStorage:FindFirstChild("PlantEvent")
    if evt then evt:FireServer() end
end

local function autoStronghold()
    local evt = ReplicatedStorage:FindFirstChild("StrongholdEvent")
    if evt then evt:FireServer() end
end

local function bringAllItem()
    local folder = workspace:FindFirstChild("Items") or workspace:FindFirstChild("ItemFolder")
    if not folder or not character.PrimaryPart then return end
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("BasePart") then
            item.CFrame = character.PrimaryPart.CFrame 
                         + Vector3.new(math.random(-2,2), 2, math.random(-2,2))
        end
    end
end

-- ===== Vòng lặp chính =====

task.spawn(function()
    while task.wait(2) do
        if enabled.ChopTree      then autoChopTree()    end
        if enabled.FillFire      then autoFillFire()    end
        if enabled.OpenChest     then autoOpenChest()   end
        if enabled.KillAura      then killAura()        end
        if enabled.Plant         then autoPlant()       end
        if enabled.Stronghold    then autoStronghold()  end
        if enabled.BringAllItem  then bringAllItem()    end
    end
end)
