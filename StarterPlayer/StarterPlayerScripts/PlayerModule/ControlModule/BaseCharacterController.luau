
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local ConnectionUtil = CommonUtils:WaitForChild("ConnectionUtil")
local v1 = require(ConnectionUtil)
CommonUtils = Vector3.new()
local v2 = {}
v2.__index = v2

local function new() --[[ Upvalues: v2 (copy), CommonUtils (copy), v1 (copy) ]]
    local v3 = setmetatable({}, v2)
    v3.enabled = false
    v3.moveVector = CommonUtils
    v3.moveVectorIsCameraRelative = true
    v3.isJumping = false
    v3._connectionUtil = v1.new()
    return v3
end

v2.new = new

local function GetMoveVector(a0)
    return a0.moveVector
end

v2.GetMoveVector = GetMoveVector

local function IsMoveVectorCameraRelative(a0)
    return a0.moveVectorIsCameraRelative
end

v2.IsMoveVectorCameraRelative = IsMoveVectorCameraRelative

local function GetIsJumping(a0)
    return a0.isJumping
end

v2.GetIsJumping = GetIsJumping

local function Enable(a0, a1)
    error("BaseCharacterController:Enable must be overridden in derived classes and should not be called.")
    return false
end

v2.Enable = Enable
return v2
