local lp = game.Players.LocalPlayer
local chest = workspace.Items:FindFirstChild("Stronghold Diamond Chest")
if not chest then
    game.StarterGui:SetCore("SendNotification", {Title="Thông báo", Text="Không tìm thấy chest!", Duration=3})
    return
end

lp.Character:PivotTo(CFrame.new(chest:GetPivot().Position))
local proxPrompt
repeat
    local main = chest:FindFirstChild("Main")
    if main and main:FindFirstChild("ProximityAttachment") then
        proxPrompt = main.ProximityAttachment:FindFirstChild("ProximityInteraction")
    end
    wait(0.1)
until proxPrompt

for i = 1, 20 do
    pcall(function() fireproximityprompt(proxPrompt) end)
    wait(0.2)
end

repeat wait(0.1) until workspace:FindFirstChild("Diamond", true)

for _,v in pairs(workspace:GetDescendants()) do
    if v.ClassName == "Model" and v.Name == "Diamond" then
        game:GetService("ReplicatedStorage").RemoteEvents.RequestTakeDiamonds:FireServer(v)
    end
end

game.StarterGui:SetCore("SendNotification", {Title="Thông báo", Text="Đã lấy xong diamond!", Duration=3})

local function hopServer()
    local Http = game:GetService("HttpService")
    local Teleport = game:GetService("TeleportService")
    local PlaceId = game.PlaceId
    local JobId = game.JobId
    local servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    for _,s in next, servers do
        if s.playing < s.maxPlayers and s.id ~= JobId then
            Teleport:TeleportToPlaceInstance(PlaceId, s.id)
            break
        end
    end
end

wait(1)
hopServer()