-- LocalScript đặt trong StarterPlayer > StarterPlayerScripts

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- === Các chức năng cần kiểm soát ===
local enabled = {
    ChopTree = false,
    FillFire = false,
    OpenChest = false,
    KillAura = false,
    Plant = false,
    Stronghold = false,
    BringAllItem = false
}

-- === Tạo ScreenGui và các nút menu ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Offset Y để hạ giao diện xuống
local guiOffsetY = 50

-- Dữ liệu các nút
local buttonData = {
    {name="ChopTree",     text="Auto Chặt Cây",   pos=UDim2.new(0, 20, 0, 100)},
    {name="FillFire",     text="Auto Đổ Lửa",     pos=UDim2.new(0, 20, 0, 130)},
    {name="OpenChest",    text="Auto Mở Rương",   pos=UDim2.new(0, 20, 0, 160)},
    {name="KillAura",     text="Kill Aura",        pos=UDim2.new(0, 20, 0, 190)},
    {name="Plant",        text="Auto Trồng Cây",   pos=UDim2.new(0, 20, 0, 220)},
    {name="Stronghold",   text="Auto Stronghold",  pos=UDim2.new(0, 20, 0, 250)},
    {name="BringAllItem", text="Bring All Item",   pos=UDim2.new(0, 20, 0, 280)}
}

local buttons = {}

for _, data in ipairs(buttonData) do
    local btn = Instance.new("TextButton")
    btn.Name = data.name
    btn.Text = data.text .. " OFF"
    btn.Size = UDim2.new(0, 160, 0, 26)
    btn.Position = UDim2.new(
        data.pos.X.Scale,
        data.pos.X.Offset,
        data.pos.Y.Scale,
        data.pos.Y.Offset + guiOffsetY
    )
    btn.BackgroundColor3 = Color3.fromRGB(179, 51, 51)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = screenGui
    buttons[data.name] = btn

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

-- === Các hàm chức năng auto ===
function autoChopTree()
    local treeFolder = workspace:FindFirstChild("Trees") or workspace:FindFirstChild("TreeFolder")
    if not treeFolder then return end
    for _, tree in ipairs(treeFolder:GetChildren()) do
        if tree:FindFirstChild("Chop") and tree.Chop:FindFirstChild("ClickDetector") then
            fireclickdetector(tree.Chop.ClickDetector)
            wait(0.2)
        end
    end
end

function autoFillFire()
    local fireFolder = workspace:FindFirstChild("Fires") or workspace:FindFirstChild("FireFolder")
    if not fireFolder then return end
    for _, fire in ipairs(fireFolder:GetChildren()) do
        if fire:FindFirstChild("Fill") and fire.Fill:FindFirstChild("ClickDetector") then
            fireclickdetector(fire.Fill.ClickDetector)
            wait(0.2)
        end
    end
end

function autoOpenChest()
    local chestFolder = workspace:FindFirstChild("Chests") or workspace:FindFirstChild("ChestFolder")
    if not chestFolder then return end
    for _, chest in ipairs(chestFolder:GetChildren()) do
        if chest:FindFirstChild("Open") and chest.Open:FindFirstChild("ClickDetector") then
            fireclickdetector(chest.Open.ClickDetector)
            wait(0.2)
        end
    end
end

function killAura()
    local monsterFolder = workspace:FindFirstChild("Monsters") or workspace:FindFirstChild("EnemyFolder")
    if not monsterFolder then return end
    for _, mob in ipairs(monsterFolder:GetChildren()) do
        local humanoid = mob:FindFirstChildOfClass("Humanoid")
        if humanoid and character.PrimaryPart and mob.PrimaryPart and (mob.PrimaryPart.Position - character.PrimaryPart.Position).Magnitude < 20 then
            humanoid.Health = 0
        end
    end
end

function autoPlant()
    local plantEvent = ReplicatedStorage:FindFirstChild("PlantEvent")
    if plantEvent then
        plantEvent:FireServer()
    end
end

function autoStronghold()
    local strongholdEvent = ReplicatedStorage:FindFirstChild("StrongholdEvent")
    if strongholdEvent then
        strongholdEvent:FireServer()
    end
end

function bringAllItem()
    local itemFolder = workspace:FindFirstChild("Items") or workspace:FindFirstChild("ItemFolder")
    if not itemFolder then return end
    for _, item in ipairs(itemFolder:GetChildren()) do
        if item:IsA("BasePart") and character.PrimaryPart then
            item.CFrame = character.PrimaryPart.CFrame + Vector3.new(math.random(-2,2),2,math.random(-2,2))
        end
    end
end

-- === Vòng lặp auto ===
while true do
    if enabled.ChopTree then autoChopTree() end
    if enabled.FillFire then autoFillFire() end
    if enabled.OpenChest then autoOpenChest() end
    if enabled.KillAura then killAura() end
    if enabled.Plant then autoPlant() end
    if enabled.Stronghold then autoStronghold() end
    if enabled.BringAllItem then bringAllItem() end
    wait(2)
end
