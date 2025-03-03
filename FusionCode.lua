local Fusion = require(game.ReplicatedStorage.Fusion)

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed

-- Simulating Leaderstats (In a real game, get this from a ServerScript)
local playerStats = Value({
    { Name = "Player1", Score = 50, TeamColor = Color3.fromRGB(255, 0, 0) },
    { Name = "Player2", Score = 120, TeamColor = Color3.fromRGB(0, 255, 0) },
    { Name = "Player3", Score = 85, TeamColor = Color3.fromRGB(0, 0, 255) }
})

-- Leaderboard UI
local LeaderboardFrame = New "Frame" {
    Size = UDim2.new(0.3, 0, 0.5, 0),
    Position = UDim2.new(0.7, 0, 0.2, 0),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    Parent = game.Players.LocalPlayer.PlayerGui
}

local LeaderboardList = New "UIListLayout" {
    Parent = LeaderboardFrame
}

local PlayersUI = Computed(function()
    local sortedPlayers = playerStats:get()
    table.sort(sortedPlayers, function(a, b) return a.Score > b.Score end)

    local children = {}
    for _, player in pairs(sortedPlayers) do
        table.insert(children, New "TextLabel" {
            Text = player.Name .. " - " .. player.Score .. " pts",
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = player.TeamColor,
            TextColor3 = Color3.new(1, 1, 1)
        })
    end
    return children
end)

PlayersUI:map(function(child) 
    child.Parent = LeaderboardFrame 
end)

-- Billboard Name Tag for Players
local function createBillboard(player)
    local Billboard = New "BillboardGui" {
        Size = UDim2.new(0, 200, 0, 50),
        Adornee = player.Character and player.Character:FindFirstChild("Head"),
        StudsOffset = Vector3.new(0, 2, 0),
        Parent = player.Character
    }

    local NameLabel = New "TextLabel" {
        Text = player.Name,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = player.TeamColor or Color3.new(1,1,1),
        Parent = Billboard
    }
end

for _, player in pairs(game.Players:GetPlayers()) do
    createBillboard(player)
end

game.Players.PlayerAdded:Connect(createBillboard)
