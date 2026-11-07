
local function getUserFlag(a0)
    local v2, v3 = pcall(function() --[[ Upvalues: a0 (copy) ]]
        local v1 = UserSettings():IsUserFeatureEnabled(a0)
        return v1
    end)
    return v2 and v3
end

local t1 = {getUserFlag = getUserFlag}
return t1
