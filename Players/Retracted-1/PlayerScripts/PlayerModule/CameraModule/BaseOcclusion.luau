
local t1 = {}
t1.__index = t1

local function __call(a0, ...) --[[ Upvalues: t1 (copy) ]]
    local v1 = t1.new(...)
    return v1
end

local t2 = {__call = __call}
setmetatable(t1, t2)

local function new() --[[ Upvalues: t1 (copy) ]]
    return setmetatable({}, t1)
end

t1.new = new

local function CharacterAdded(a0, a1, a2)
end

t1.CharacterAdded = CharacterAdded

local function CharacterRemoving(a0, a1, a2)
end

t1.CharacterRemoving = CharacterRemoving

local function OnCameraSubjectChanged(a0, a1)
end

t1.OnCameraSubjectChanged = OnCameraSubjectChanged

local function GetOcclusionMode(a0)
    warn("BaseOcclusion GetOcclusionMode must be overridden by derived classes")
    return nil
end

t1.GetOcclusionMode = GetOcclusionMode

local function Enable(a0, a1)
    warn("BaseOcclusion Enable must be overridden by derived classes")
end

t1.Enable = Enable

local function Update(a0, a1, a2, a3)
    warn("BaseOcclusion Update must be overridden by derived classes")
    return a2, a3
end

t1.Update = Update
return t1
