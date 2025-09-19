--// 99 Nights in the Forest Script with Rayfield UI //--

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/enjoythejax/Rayfield/main/source'))()

-- Services và biến chung
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Các flag chức năng
local enabled = {
    ChopTree       = false,
    FillFire       = false,
    OpenChest      = false,
    KillAura       = false,
    Plant          = false,
    Stronghold     = false,
    BringAllItem   = false
}

-- Tạo cửa sổ chính
local Window = Rayfield:CreateWindow({
    Name = "99 Nights Hub",
    LoadingTitle = "Đang Khởi Tạo…",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "99NightsHub",
        FileName = "Settings"
    }
})

-- Tạo Tab chính cho các tính năng Auto
local MainTab = Window:CreateTab("Auto Features")

-- Danh sách toggle và callback
local features = {
    {label = "Auto Chặt Cây",      key = "ChopTree"},
    {label = "Auto Đổ Lửa",         key = "FillFire"},
    {label = "Auto Mở Rương",       key = "OpenChest"},
    {label = "Kill Aura",           key = "KillAura"},
    {label = "Auto Trồng Cây",      key = "Plant"},
    {label = "Auto Stronghold",     key = "Stronghold"},
    {label = "Bring All Item",      key = "BringAllItem"}
}

-- Tạo toggle cho mỗi tính năng
for _, feat in ipairs(features) do
    MainTab:CreateToggle({
        Name = feat.label,
        CurrentValue = false,
        Flag = feat.key,
        Callback = function(value)
            enabled[feat.key] = value
        end
    })
end

--// ====== Định nghĩa hàm auto ====== //--

-- Auto Chop Tree
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

-- Auto Fill Fire
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

-- Auto Open Chest
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

-- Kill Aura
local function killAura()
    local folder = workspace:FindFirstChild("Monsters") or workspace:FindFirstChild("EnemyFolder")
    if not folder or not character.PrimaryPart then return end
    for _, mob in ipairs(folder:GetChildren()) do
        local humanoid = mob:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local root = mob.PrimaryPart or mob:FindFirstChild("HumanoidRootPart")
            if root and (root.Position - character.PrimaryPart.Position).Magnitude < 20 then
                humanoid.Health = 0
            end
        end
    end
end

-- Auto Plant
local function autoPlant()
    local plantEvent = ReplicatedStorage:FindFirstChild("PlantEvent")
    if plantEvent then plantEvent:FireServer() end
end

-- Auto Stronghold
local function autoStronghold()
    local shEvent = ReplicatedStorage:FindFirstChild("StrongholdEvent")
    if shEvent then shEvent:FireServer() end
end

-- Bring All Items
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

-- Vòng lặp chính chạy auto
task.spawn(function()
    while task.wait(2) do
        if enabled.ChopTree     then autoChopTree()    end
        if enabled.FillFire     then autoFillFire()    end
        if enabled.OpenChest    then autoOpenChest()   end
        if enabled.KillAura     then killAura()        end
        if enabled.Plant        then autoPlant()       end
        if enabled.Stronghold   then autoStronghold()  end
        if enabled.BringAllItem then bringAllItem()    end
    end
end)

-- In ra console khi load xong
print("🌲 99 Nights Hub loaded! Mở UI để bật/tắt tính năng.")
