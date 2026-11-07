
local VRService = game:GetService("VRService")
local v1 = {
    "BasePart",
    "Decal",
    "Beam",
    "ParticleEmitter",
    "Trail",
    "Fire",
    "Smoke",
    "Sparkles",
    "Explosion"
}
local CameraUtils = script.Parent:WaitForChild("CameraUtils")
local v2 = require(CameraUtils)
CameraUtils = {}
CameraUtils.__index = CameraUtils

local function new() --[[ Upvalues: CameraUtils (copy) ]]
    local v3 = setmetatable({}, CameraUtils)
    v3.transparencyDirty = false
    v3.enabled = false
    v3.lastTransparency = nil
    v3.descendantAddedConn = nil
    v3.descendantRemovingConn = nil
    v3.toolDescendantAddedConns = {}
    v3.toolDescendantRemovingConns = {}
    v3.cachedParts = {}
    return v3
end

CameraUtils.new = new

local function HasToolAncestor(a0, a1)
    if a1.Parent == nil then
        return false
    end

    assert(a1.Parent, "")
    local v6 = a1.Parent:IsA("Tool") or a0:HasToolAncestor(a1.Parent)
    return v6
end

CameraUtils.HasToolAncestor = HasToolAncestor

local function IsValidPartToModify(a0, a1) --[[ Upvalues: v1 (copy) ]]
    local v7 = v1
    local v8 = nil
    local v9 = nil
    for k1, k2 in v7 do
        if a1:IsA(k2) then
            return not a0:HasToolAncestor(a1)
        end
    end

    return false
end

CameraUtils.IsValidPartToModify = IsValidPartToModify

local function CachePartsRecursive(a0, a1)
    if a1 then
        if a0:IsValidPartToModify(a1) then
            a0.cachedParts[a1] = true
            a0.transparencyDirty = true
        end

        local v10 = a1:GetChildren()
        for k3, k4 in pairs(v10) do
            a0:CachePartsRecursive(k4)
        end
    end
end

CameraUtils.CachePartsRecursive = CachePartsRecursive

local function TeardownTransparency(a0)
    for k5, k6 in pairs(a0.cachedParts) do
        k5.LocalTransparencyModifier = 0
    end

    a0.cachedParts = {}
    a0.transparencyDirty = true
    a0.lastTransparency = nil
    if a0.descendantAddedConn then
        a0.descendantAddedConn:disconnect()
        a0.descendantAddedConn = nil
    end

    if a0.descendantRemovingConn then
        a0.descendantRemovingConn:disconnect()
        a0.descendantRemovingConn = nil
    end

    for k7, k8 in pairs(a0.toolDescendantAddedConns) do
        k8:Disconnect()
        a0.toolDescendantAddedConns[k7] = nil
    end

    for k9, k10 in pairs(a0.toolDescendantRemovingConns) do
        k10:Disconnect()
        a0.toolDescendantRemovingConns[k9] = nil
    end
end

CameraUtils.TeardownTransparency = TeardownTransparency

local function SetupTransparency(a0, a1)
    a0:TeardownTransparency()
    if a0.descendantAddedConn then
        a0.descendantAddedConn:disconnect()
    end

    a0.descendantAddedConn = a1.DescendantAdded:Connect(function(a0) --[[ Upvalues: a0 (copy), a1 (copy) ]]
        if a0:IsValidPartToModify(a0) then
            a0.cachedParts[a0] = true
            a0.transparencyDirty = true
            return
        end

        if a0:IsA("Tool") then
            if a0.toolDescendantAddedConns[a0] then
                a0.toolDescendantAddedConns[a0]:Disconnect()
            end

            a0.toolDescendantAddedConns[a0] = a0.DescendantAdded:Connect(function(a0) --[[ Upvalues: a0 (upvalue) ]]
                a0.cachedParts[a0] = nil
                if a0:IsA("BasePart") or a0:IsA("Decal") then
                    a0.LocalTransparencyModifier = 0
                end

            end)
            if a0.toolDescendantRemovingConns[a0] then
                a0.toolDescendantRemovingConns[a0]:disconnect()
            end

            a0.toolDescendantRemovingConns[a0] = a0.DescendantRemoving:Connect(function(a0) --[[ Upvalues: a1 (upvalue), a0 (upvalue) ]]
                wait()
                if a1 and a0 and a0:IsDescendantOf(a1) and a0:IsValidPartToModify(a0) then
                    a0.cachedParts[a0] = true
                    a0.transparencyDirty = true
                end

            end)
        end

    end)
    if a0.descendantRemovingConn then
        a0.descendantRemovingConn:disconnect()
    end

    a0.descendantRemovingConn = a1.DescendantRemoving:connect(function(a0) --[[ Upvalues: a0 (copy) ]]
        if a0.cachedParts[a0] then
            a0.cachedParts[a0] = nil
            a0.LocalTransparencyModifier = 0
        end

    end)
    a0:CachePartsRecursive(a1)
end

CameraUtils.SetupTransparency = SetupTransparency

local function Enable(a0, a1)
    if a0.enabled ~= a1 then
        a0.enabled = a1
    end
end

CameraUtils.Enable = Enable

local function SetSubject(a0, a1)
    local v23 = nil
    if a1 and a1:IsA("Humanoid") then
        v23 = a1.Parent
    end

    if a1 and a1:IsA("VehicleSeat") and a1.Occupant then
        v23 = a1.Occupant.Parent
    end

    if v23 then
        a0:SetupTransparency(v23)
        return
    end

    a0:TeardownTransparency()
end

CameraUtils.SetSubject = SetSubject

local function Update(a0, a1) --[[ Upvalues: v2 (copy), VRService (copy) ]]
    local CurrentCamera = workspace.CurrentCamera
    if CurrentCamera then
        if a0.enabled then
            local magnitude = (CurrentCamera.Focus.p - CurrentCamera.CoordinateFrame.p).magnitude
            local v26
            if (magnitude < 2 and 1 - (magnitude - 0.5) / 1.5 or 0) < 0.5 then
                v26 = 0
            end

            if a0.lastTransparency and v26 < 1 and a0.lastTransparency < 0.95 then
                magnitude = v26 - a0.lastTransparency
                local v27 = 2.8 * a1
                magnitude = math.clamp(magnitude, -v27, v27)
                v26 = a0.lastTransparency + magnitude
            else
                a0.transparencyDirty = true
            end

            local v28 = v2.Round(v26, 2)
            local v29 = 1
            v26 = math.clamp(v28, 0, v29)
            if a0.transparencyDirty or a0.lastTransparency ~= v26 then
                for k11, k12 in pairs(a0.cachedParts) do
                    if VRService.VREnabled and VRService.AvatarGestures then
                        local v33 = {
                            [Enum.AccessoryType.Hat] = true,
                            [Enum.AccessoryType.Hair] = true,
                            [Enum.AccessoryType.Face] = true,
                            [Enum.AccessoryType.Eyebrow] = true,
                            [Enum.AccessoryType.Eyelash] = true
                        }
                        if not (k11.Parent:IsA("Accessory") and v33[k11.Parent.AccessoryType]) then
                            if k11.Name ~= "Head" then
                                -- jump to 142
                            end
                        end

                        k11.LocalTransparencyModifier = v26
                        -- jump to 148 (out of range)
                        k11.LocalTransparencyModifier = 0
                    else
                        k11.LocalTransparencyModifier = v26
                    end
                end

                a0.transparencyDirty = false
                a0.lastTransparency = v26
            end
        end
    end
end

CameraUtils.Update = Update
return CameraUtils
