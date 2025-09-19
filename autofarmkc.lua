local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Remote = game:GetService("ReplicatedStorage").RemoteEvents.RequestTakeDiamonds
local Interface = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Interface")
local DiamondCount = Interface:WaitForChild("DiamondCount"):WaitForChild("Count")

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DiamondFarmUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 90)
frame.Position = UDim2.new(0, 80, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 1.5
task.spawn(function()
    while task.wait() do
        for hue = 0, 1, 0.01 do
            stroke.Color = Color3.fromHSV(hue, 1, 1)
            task.wait(0.02)
        end
    end
end)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Farm Diamond | Cáo Mod"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextStrokeTransparency = 0.6

local diamondLabel = Instance.new("TextLabel", frame)
diamondLabel.Size = UDim2.new(1, -20, 0, 35)
diamondLabel.Position = UDim2.new(0, 10, 0, 40)
diamondLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
diamondLabel.TextColor3 = Color3.new(1, 1, 1)
diamondLabel.Font = Enum.Font.GothamBold
diamondLabel.TextSize = 14
diamondLabel.BorderSizePixel = 0

local diamondCorner = Instance.new("UICorner", diamondLabel)
diamondCorner.CornerRadius = UDim.new(0, 6)

-- Cập nhật số diamond liên tục
task.spawn(function()
    while task.wait(0.2) do
        diamondLabel.Text = "Diamonds: " .. DiamondCount.Text
    end
end)

-- Farm diamond
local function hopServer()
    local gameId = game.PlaceId
    local JobId = game.JobId
    local success, body = pcall(function()
        return game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(gameId))
    end)
    if success then
        local data = HttpService:JSONDecode(body)
        for _, server in ipairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= JobId then
                TeleportService:TeleportToPlaceInstance(gameId, server.id, LocalPlayer)
                break
            end
        end
    end
end

repeat task.wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local chest = workspace.Items:FindFirstChild("Stronghold Diamond Chest")
if not chest then
    CoreGui:SetCore("SendNotification", {Title = "Thông báo", Text = "Không tìm thấy chest!", Duration = 3})
    hopServer()
    return
end

LocalPlayer.Character:PivotTo(CFrame.new(chest:GetPivot().Position))

local proxPrompt
repeat
    local main = chest:FindFirstChild("Main")
    if main and main:FindFirstChild("ProximityAttachment") then
        proxPrompt = main.ProximityAttachment:FindFirstChild("ProximityInteraction")
    end
    task.wait(0.1)
until proxPrompt

for i = 1, 20 do
    pcall(function() fireproximityprompt(proxPrompt) end)
    task.wait(0.2)
end

repeat task.wait(0.1) until workspace:FindFirstChild("Diamond", true)

for _, v in pairs(workspace:GetDescendants()) do
    if v.ClassName == "Model" and v.Name == "Diamond" then
        Remote:FireServer(v)
    end
end

CoreGui:SetCore("SendNotification", {Title="Thông báo", Text="Đã lấy xong diamond!", Duration=3})
task.wait(1)
hopServer()
