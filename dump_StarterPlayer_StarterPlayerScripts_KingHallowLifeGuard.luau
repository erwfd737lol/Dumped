-- decompiled by Velocity decompiler v1.0.3

local Workspace = game:GetService("Workspace")
local v1 = {}
local t1 = {}

local function isKingHallow(a0)
    local v2 = a0
    if v2 then
        local v3 = a0:IsA("Model")
        if v3 then
            v3 = true
            if a0.Name ~= "King Hallow" then
                v3 = a0:GetAttribute("KingHallowDeathAllowed") ~= nil
            end
        end
    end

    return v2
end

local function unbind(a0) --[[ Upvalues: v1 (copy) ]]
    local v4 = v1[a0]
    if not v4 then
        return
    end

    v1[a0] = nil
    local connections = v4.connections
    local v5 = nil
    local v6 = nil
    for k1, k2 in connections do
        k2:Disconnect()
    end

    table.clear(v4.connections)
end

local Dead = Enum.HumanoidStateType.Dead

local function bind(a0) --[[ Upvalues: v1 (copy), Dead (copy), Workspace (copy) ]]
    if v1[a0] then
        return
    end

    local Parent = a0.Parent
    local v7 = Parent
    if v7 then
        local v8 = Parent:IsA("Model")
        if v8 then
            v8 = true
            if Parent.Name ~= "King Hallow" then
                v8 = Parent:GetAttribute("KingHallowDeathAllowed") ~= nil
            end
        end
    end

    if not v7 then
        return
    end

    v7 = {applying = false, character = Parent, connections = {}}
    v1[a0] = v7

    local function synchronize() --[[ Upvalues: v1 (upvalue), a0 (copy), v7 (copy), Parent (copy), Dead (upvalue) ]]
        local v9 = v1[a0]
        if v9 ~= v7 or v7.applying or a0.Parent ~= Parent then
            return
        end

        local v10 = Parent:GetAttribute("KingHallowDeathAllowed") == true
        if a0:GetStateEnabled(Dead) == v10 then
            return
        end

        v7.applying = true
        a0:SetStateEnabled(Dead, v10)
        v7.applying = false
    end

    local v11 = Parent:GetAttributeChangedSignal("KingHallowDeathAllowed")
    local v12 = v11:Connect(synchronize)
    table.insert(v7.connections, v12)
    local v13 = a0.StateEnabledChanged:Connect(function(a0) --[[ Upvalues: Dead (upvalue), synchronize (copy) ]]
        if a0 == Dead then
            synchronize()
        end

    end)
    table.insert(v7.connections, v13)
    local v18 = a0.AncestryChanged:Connect(function() --[[ Upvalues: a0 (copy), Parent (copy), Workspace (upvalue), v1 (upvalue) ]]
        if not (a0.Parent == Parent and Parent:IsDescendantOf(Workspace)) then
            local v14 = a0
            local v15 = v1[v14]
            if not v15 then
                return
            end

            v1[v14] = nil
            local connections1 = v15.connections
            local v16 = nil
            local v17 = nil
            for k3, k4 in connections1 do
                k4:Disconnect()
            end

            table.clear(v15.connections)
        end

    end)
    table.insert(v7.connections, v18)
    local v23 = a0.Destroying:Connect(function() --[[ Upvalues: a0 (copy), v1 (upvalue) ]]
        local v19 = a0
        local v20 = v1[v19]
        if not v20 then
            return
        end

        v1[v19] = nil
        local connections2 = v20.connections
        local v21 = nil
        local v22 = nil
        for k5, k6 in connections2 do
            k6:Disconnect()
        end

        table.clear(v20.connections)
    end)
    table.insert(v7.connections, v23)
    synchronize()
end

local function inspect(a0) --[[ Upvalues: bind (copy) ]]
    if a0:IsA("Humanoid") then
        bind(a0)
        return
    end

    local v24 = a0
    if v24 then
        local v25 = a0:IsA("Model")
        if v25 then
            v25 = true
            if a0.Name ~= "King Hallow" then
                v25 = a0:GetAttribute("KingHallowDeathAllowed") ~= nil
            end
        end
    end

    if v24 then
        local v27 = a0:FindFirstChildOfClass("Humanoid")
        if v27 then
            bind(v27)
        end
    end
end

local v28 = Workspace.DescendantAdded:Connect(inspect)
table.insert(t1, v28)
for k7, k8 in Workspace:GetDescendants() do
    if k8:IsA("Humanoid") then
        bind(k8)
    end
end

script.Destroying:Connect(function() --[[ Upvalues: t1 (copy), v1 (copy) ]]
    local v32 = t1
    local v33 = nil
    local v34 = nil
    local v35
    for k9, k10 in v32 do
        k10:Disconnect()
    end

    table.clear(t1)
    local v36 = {}
    local v37 = v1
    v34 = nil
    k9 = nil
    for k11 in v37 do
        table.insert(v36, k11)
    end

    v37 = v36
    v34 = nil
    k9 = nil
    local v38
    for k12, k13 in v37 do
        local v39 = v1[k13]
        if not v39 then
        else
            v1[k13] = nil
            local connections3 = v39.connections
            local v40 = nil
            local v41 = nil
            for k14, k15 in connections3 do
                k15:Disconnect()
            end

            table.clear(v39.connections)
        end
    end

end)
