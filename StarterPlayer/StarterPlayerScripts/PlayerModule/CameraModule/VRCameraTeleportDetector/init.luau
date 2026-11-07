
local v1 = nil

local function shouldRecenter(a0, a1, a2, a3) --[[ Upvalues: v1 (copy) ]]
    if a1 <= v1.JUMP_STUDS then
        return false
    end

    if a0 ~= nil and v1.SETTLED_STUDS <= a0 then
        return false
    end

    if a2 ~= nil and a3 - a2 < v1.DEBOUNCE_SECONDS then
        return false
    end

    return true
end

v1 = {
    JUMP_STUDS = 4,
    SETTLED_STUDS = 1,
    DEBOUNCE_SECONDS = 0.25,
    shouldRecenter = shouldRecenter
}
return v1
