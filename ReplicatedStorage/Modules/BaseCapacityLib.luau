
local v1 = nil

local function GetLimit(a0, a1, a2, a3, a4) --[[ Upvalues: v1 (copy) ]]
    local v2 = math.floor(tonumber(a0) or 1)
    local v3
    if a1 == true then
        v3 = v3 * 2
    end

    if a2 == true then
        v3 = v3 + v1.GAMEPASS_BONUS
    end

    if a3 == true or a4 == true then
        v3 = v3 + v1.MONEY_UPGRADE_BONUS
    end

    return v3
end

v1 = {
    CAPACITY_PER_UNIT = 40,
    GAMEPASS_BONUS = 80,
    MONEY_UPGRADE_BONUS = 60,
    GetLimit = GetLimit
}
return v1
