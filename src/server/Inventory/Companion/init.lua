local stats = require(script:WaitForChild("CompanionStats"))

local Companion = {}
Companion.__index = Companion

function Companion.new(companionName: string)
    local companionStats = stats[companionName]
    if companionStats == nil then return end
    -- We need the values of companionStats not the reference
    local newCompanionStats = {}
    newCompanionStats["name"] = companionName
    for name, value in pairs(companionStats["stats"]) do
        newCompanionStats[name] = value
    end
    local abilities = companionStats["abilities"]
    newCompanionStats["ability"] = abilities[math.random(1, #abilities)]
    return setmetatable(newCompanionStats, Companion)
end

function Companion.from(companionStats: {})
    if companionStats["name"] == nil or stats[companionStats["name"]] == nil then return end
    return setmetatable(companionStats, Companion)
end

return Companion