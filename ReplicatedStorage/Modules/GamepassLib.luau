
local v1 = {Id = 1952937460, Label = "3 Storage Unit Base"}
local t1 = {
    {Id = 230541266, Label = "Extra Storage Capacity"},
    {Id = 245559423, Label = "Personal Clock"},
    {Id = 1538562178, Label = "1.5x Loot Sell"},
    {Id = 1536370672, Label = "Portable Safe"},
    v1
}
local t2 = {Passes = t1}
t1 = {}
for k1, k2 in ipairs(t2.Passes) do
    t1[k2.Id] = k2
end

t2.ById = t1

local function GetInfo(a0) --[[ Upvalues: t1 (copy) ]]
    return t1[tonumber(a0) or 0]
end

t2.GetInfo = GetInfo

local function Labels() --[[ Upvalues: t2 (copy) ]]
    local t3 = {}
    for k3, k4 in ipairs(t2.Passes) do
        table.insert(t3, k4.Label)
    end

    table.sort(t3)
    return t3
end

t2.Labels = Labels

local function HasGrant(a0, a1)
    if typeof(a0) ~= "table" then
        return false
    end

    return a0[tostring(a1)] == true
end

t2.HasGrant = HasGrant

local function Resolve(a0) --[[ Upvalues: t1 (copy), t2 (copy) ]]
    local v8 = tostring(a0 or ""):gsub("^%s+", "")
    a0 = v8:gsub("%s+$", "")
    if a0 == "" then
        return nil
    end

    local v9 = tonumber(a0)
    if v9 and t1[v9] then
        return v9
    end

    local v10 = string.lower(a0)
    for k5, k6 in ipairs(t2.Passes) do
        local v15 = string.lower(k6.Label)
        if v15 == v10 then
            return k6.Id
        end
    end

    local v16 = nil
    for k7, k8 in ipairs(t2.Passes) do
        local v20 = string.lower(k8.Label)
        if string.sub(v20, 1, #v10) == v10 then
            if v16 then
                return nil
            end

            v16 = k8.Id
        end
    end

    return v16
end

t2.Resolve = Resolve
return t2
