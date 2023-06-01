local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local FRONT_OFFSET = -5
local RIGHT_OFFSET = 3
local DOWN_RAY_LENGTH = 10

local CHECK_HEIGHT_OFFSET = 5

local CompanionParams = RaycastParams.new()

local FOLLOWSPEED = 5

local playersFolder = Instance.new("Folder", Workspace)
playersFolder.Name = "Characters"

CompanionParams.FilterDescendantsInstances = {playersFolder}
CompanionParams.FilterType = Enum.RaycastFilterType.Exclude

local companionVisuals = ReplicatedStorage:WaitForChild("Companions")

function getPlayerCharacterFolder(player: Player): Folder?
    return playersFolder:FindFirstChild(player.Name)
end

function getCompanion(player: Player)
    local playerFolder = getPlayerCharacterFolder(player)
    --Test ist for testing only
    local companion = companionVisuals:FindFirstChild("Test")
    local clone = companion:Clone()
    clone.Name = "Companion"
    clone.Parent = playerFolder
end



function playerAdded(player: Player)
    local playerFolder = Instance.new("Folder")
    playerFolder.Name = player.Name
    playerFolder.Parent = playersFolder
    if player.Character ~= nil then 
        player.Character.Parent = playerFolder
        getCompanion(player)
    end
    player.CharacterAdded:Connect(function(character)
        character.Parent = playerFolder
        getCompanion(player)
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    task.spawn(function() playerAdded(player) end)
end

Players.PlayerAdded:Connect(playerAdded)

RunService.Heartbeat:Connect(function(deltaTime)
    for _, player in pairs(Players:GetPlayers()) do
        
        if player.Character == nil then continue end

        local playerFolder = getPlayerCharacterFolder(player)
        local companion = playerFolder:FindFirstChild("Companion")
        local primaryPart = player.Character.PrimaryPart
        local finalPosition = primaryPart.CFrame.Position + primaryPart.CFrame.LookVector * FRONT_OFFSET + primaryPart.CFrame.RightVector * RIGHT_OFFSET
        local result = Workspace:Raycast(finalPosition + Vector3.new(0,CHECK_HEIGHT_OFFSET,0),Vector3.new(0,-(DOWN_RAY_LENGTH + CHECK_HEIGHT_OFFSET),0), CompanionParams)
        if result ~= nil then 
            finalPosition = result.Position
        else
            finalPosition -= Vector3.new(0,player.Character:GetExtentsSize().Y/2,0)
        end
        companion:PivotTo(companion.PrimaryPart.CFrame:Lerp(CFrame.new(finalPosition) * primaryPart.CFrame.Rotation, deltaTime*FOLLOWSPEED))
    end  
end)