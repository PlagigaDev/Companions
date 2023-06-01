local Players = game:GetService("Players")
local Inventories = {}

function getCompanion(companionName: string): Companion
    
end

function playerAdded(player: Player)
    Inventories[player.Name] = {}
    
end

for _,player in Players:GetPlayers() do
    playerAdded(playerAdded)
end

Players.PlayerAdded:Connect(playerAdded)