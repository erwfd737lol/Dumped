
local t1 = {}
t1.__index = t1

local function new() --[[ Upvalues: t1 (copy) ]]
    local v1 = setmetatable({}, t1)
    local CameraModule = script:WaitForChild("CameraModule")
    v1.cameras = require(CameraModule)
    local ControlModule = script:WaitForChild("ControlModule")
    v1.controls = require(ControlModule)
    return v1
end

t1.new = new

local function GetCameras(a0)
    return a0.cameras
end

t1.GetCameras = GetCameras

local function GetControls(a0)
    return a0.controls
end

t1.GetControls = GetControls

local function GetClickToMoveController(a0)
    local v2 = a0.controls:GetClickToMoveController()
    return v2
end

t1.GetClickToMoveController = GetClickToMoveController
local v3 = t1.new()
return v3
