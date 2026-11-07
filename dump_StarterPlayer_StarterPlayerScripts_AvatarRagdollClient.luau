-- decompiled by Velocity decompiler v1.0.3

local LocalPlayer = game:GetService("Players").LocalPlayer
local v1 = nil
local v2 = {}
local v3 = nil
local v4 = false
local v5 = nil
local v6 = false

local function disconnectAll(a0)
    for k1, k2 in ipairs(a0) do
        k2:Disconnect()
    end

    table.clear(a0)
end

local function alive() --[[ Upvalues: v3 (ref) ]]
    local v10 = v3
    if v10 then
        local Parent = v3.Parent
        if Parent then
            Parent = false
            if 0 < v3.Health then
                local v11 = v3:GetState()
                Parent = v11 ~= Enum.HumanoidStateType.Dead
            end
        end
    end

    return v10
end

local function isRagdolled() --[[ Upvalues: v1 (ref) ]]
    local v12 = v1
    if v12 then
        v12 = v1:GetAttribute("Ragdolled") == true
    end

    return v12
end

local function savedProperty(a0, a1) --[[ Upvalues: v1 (ref) ]]
    local v13 = v1:GetAttribute(a0)
    if typeof(v13) == "boolean" then
        return v13
    end

    return a1
end

local function enforceRagdoll() --[[ Upvalues: v6 (ref), v4 (ref), v1 (ref), v3 (ref) ]]
    if v6 then
        return
    end

    if not v4 then
        return
    end

    local v14 = v1
    if v14 then
        v14 = v1:GetAttribute("Ragdolled") == true
    end

    if not (v14 and v3 and v3.Parent) then
        return
    end

    v6 = true
    v3:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
    v3:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    v3.PlatformStand = true
    v3.AutoRotate = false
    local v15 = v3
    if v15 then
        local Parent1 = v3.Parent
        if Parent1 then
            Parent1 = false
            if 0 < v3.Health then
                local v16 = v3:GetState()
                Parent1 = v16 ~= Enum.HumanoidStateType.Dead
            end
        end
    end

    if v15 then
        local v18 = v3:GetState()
        if v18 ~= Enum.HumanoidStateType.Physics then
            v3:ChangeState(Enum.HumanoidStateType.Physics)
        end
    end

    v6 = false
end

local function synchronize() --[[ Upvalues: v3 (ref), v1 (ref), v4 (ref), v5 (ref), enforceRagdoll (copy) ]]
    if not (v3 and v3.Parent) then
        return
    end

    local v19 = v1
    if v19 then
        v19 = v1:GetAttribute("Ragdolled") == true
    end

    if v19 then
        if not v4 then
            local v20 = {
                GettingUp = v3:GetStateEnabled(Enum.HumanoidStateType.GettingUp),
                FallingDown = v3:GetStateEnabled(Enum.HumanoidStateType.FallingDown)
            }
            local v21 = v1:GetAttribute("AJUPlatformStandBefore")
            local v22
            if typeof(v21) == "boolean" then
                v22 = v21
            else
                v22 = false
            end

            v20.PlatformStand = v22
            local v23 = v1:GetAttribute("AJUAutoRotateBefore")
            if typeof(v23) == "boolean" then
                v22 = v23
            else
                v22 = true
            end

            v20.AutoRotate = v22
            local v24 = v1:GetAttribute("AJUFishingBefore")
            if typeof(v24) == "boolean" then
                v22 = v24
            else
                v22 = false
            end

            v20.Fishing = v22
            v5 = v20
            v4 = true
        end

        enforceRagdoll()
        return
    end

    if v4 then
        v4 = false
        local v25 = v5
        v5 = nil
        v3:SetStateEnabled(Enum.HumanoidStateType.GettingUp, v25.GettingUp)
        v3:SetStateEnabled(Enum.HumanoidStateType.FallingDown, v25.FallingDown)
        local v26 = v3
        if v26 then
            local Parent2 = v3.Parent
            if Parent2 then
                Parent2 = false
                if 0 < v3.Health then
                    local v27 = v3:GetState()
                    Parent2 = v27 ~= Enum.HumanoidStateType.Dead
                end
            end
        end

        if v26 then
            v3.PlatformStand = v25.PlatformStand
            local v28 = v3
            local v29
            if v25.AutoRotate or v25.Fishing then
                v29 = not v1:GetAttribute("Fishing")
            end

            v28.AutoRotate = v29
            if v25.GettingUp and not v25.PlatformStand then
                v3:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end
end

local t1 = {}

local function bindHumanoid(a0) --[[ Upvalues: v3 (ref), t1 (copy), v4 (ref), v5 (ref), v6 (ref), enforceRagdoll (copy), synchronize (copy) ]]
    if v3 == a0 then
        return
    end

    local v30 = t1
    for k3, k4 in ipairs(v30) do
        k4:Disconnect()
    end

    table.clear(v30)
    v3 = a0
    v4 = false
    v5 = nil
    v6 = false
    if not v3 then
        return
    end

    local v34 = v3.StateEnabledChanged:Connect(function(a0, a1) --[[ Upvalues: v4 (upvalue), v5 (upvalue), enforceRagdoll (upvalue) ]]
        if a1 then
            if a0 == Enum.HumanoidStateType.GettingUp or a0 == Enum.HumanoidStateType.FallingDown then
                if v4 and v5 then
                    v5[a0.Name] = true
                end

                enforceRagdoll()
            end
        end

    end)
    table.insert(t1, v34)
    local v35 = v3:GetPropertyChangedSignal("PlatformStand")
    local v36 = v35:Connect(enforceRagdoll)
    table.insert(t1, v36)
    local v37 = v3:GetPropertyChangedSignal("AutoRotate")
    local v38 = v37:Connect(enforceRagdoll)
    table.insert(t1, v38)
    local v39 = v3.StateChanged:Connect(function(a0, a1) --[[ Upvalues: enforceRagdoll (upvalue) ]]
        if a1 ~= Enum.HumanoidStateType.Physics and a1 ~= Enum.HumanoidStateType.Dead then
            enforceRagdoll()
        end

    end)
    table.insert(t1, v39)
    synchronize()
end

local function bindCharacter(a0) --[[ Upvalues: v1 (ref), v2 (copy), bindHumanoid (copy), synchronize (copy), v3 (ref) ]]
    if v1 == a0 then
        return
    end

    local v40 = v2
    for k5, k6 in ipairs(v40) do
        k6:Disconnect()
    end

    table.clear(v40)
    bindHumanoid(nil)
    v1 = a0
    if not a0 then
        return
    end

    local v44 = a0:GetAttributeChangedSignal("Ragdolled")
    local v45 = v44:Connect(synchronize)
    table.insert(v2, v45)
    local v46 = a0.ChildAdded:Connect(function(a0) --[[ Upvalues: v1 (upvalue), a0 (copy), bindHumanoid (upvalue) ]]
        if a0:IsA("Humanoid") and v1 == a0 then
            bindHumanoid(a0)
        end

    end)
    table.insert(v2, v46)
    local v48 = a0.ChildRemoved:Connect(function(a0) --[[ Upvalues: v3 (upvalue), bindHumanoid (upvalue), a0 (copy) ]]
        if a0 == v3 then
            local v47 = a0:FindFirstChildOfClass("Humanoid")
            bindHumanoid(v47)
        end

    end)
    table.insert(v2, v48)
    local v49 = a0:FindFirstChildOfClass("Humanoid")
    bindHumanoid(v49)
end

LocalPlayer.CharacterAdded:Connect(bindCharacter)
LocalPlayer.CharacterRemoving:Connect(function(a0) --[[ Upvalues: v1 (ref), v2 (copy), bindHumanoid (copy) ]]
    if v1 == a0 then
        if v1 == nil then
            return
        end

        local v50 = v2
        for k7, k8 in ipairs(v50) do
            k8:Disconnect()
        end

        table.clear(v50)
        bindHumanoid(nil)
        v1 = nil
    end

end)
bindCharacter(LocalPlayer.Character)
