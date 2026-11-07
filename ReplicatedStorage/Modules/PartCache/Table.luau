
local v1 = Random.new()
local t1 = {}
for k1, k2 in pairs(table) do
    t1[k1] = k2
end

t1.contains = function(a0, a1) --[[ Upvalues: t1 (copy) ]]
    return t1.indexOf(a0, a1) ~= nil
end

t1.indexOf = function(a0, a1) --[[ Upvalues: t1 (copy) ]]
    local v5 = table.find(a0, a1)
    if v5 then
        return v5
    end

    local v6 = t1.keyOf(a0, a1)
    return v6
end

t1.keyOf = function(a0, a1)
    for k3, k4 in pairs(a0) do
        if k4 == a1 then
            return k3
        end
    end

    return nil
end

t1.skip = function(a0, a1)
    local v10 = table.create(#a0 - a1)
    local v11 = table.move(a0, a1 + 1, #a0, 1, v10)
    return v11
end

t1.take = function(a0, a1)
    local v12 = table.create(a1)
    local v13 = table.move(a0, 1, a1, 1, v12)
    return v13
end

t1.range = function(a0, a1, a2)
    local v14 = table.create(a2 - a1 + 1)
    local v15 = table.move(a0, a1, a2, 1, v14)
    return v15
end

t1.skipAndTake = function(a0, a1, a2)
    local v16 = table.create(a2)
    local v17 = table.move(a0, a1 + 1, a1 + a2, 1, v16)
    return v17
end

t1.random = function(a0) --[[ Upvalues: v1 (copy) ]]
    return a0[v1:NextInteger(1, #a0)]
end

t1.join = function(a0, a1)
    local v18 = table.create(#a0 + #a1)
    local v19 = #a0 + 1
    local v20 = table.move(a1, 1, #a1, v19, v18)
    return v20
end

t1.removeObject = function(a0, a1) --[[ Upvalues: t1 (copy) ]]
    local v21 = t1.indexOf(a0, a1)
    if v21 then
        table.remove(a0, v21)
    end
end

t1.expand = function(a0, a1)
    if a1 < 0 then
        error("Cannot expand a table by a negative amount of objects.")
    end

    local v22 = table.create(#a0 + a1)
    for i1 = 1, #a0 do
        v22[i1] = a0[i1]
    end

    return v22
end

return t1
