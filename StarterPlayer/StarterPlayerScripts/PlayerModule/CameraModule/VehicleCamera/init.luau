
local t1 = {0, 15, 30}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local BaseCamera = script.Parent:WaitForChild("BaseCamera")
local v1 = require(BaseCamera)
local CameraInput = script.Parent:WaitForChild("CameraInput")
local v2 = require(CameraInput)
local CameraUtils = script.Parent:WaitForChild("CameraUtils")
local v3 = require(CameraUtils)
local ZoomController = script.Parent:WaitForChild("ZoomController")
local v4 = require(ZoomController)
local VehicleCameraCore = script:WaitForChild("VehicleCameraCore")
local v5 = require(VehicleCameraCore)
local VehicleCameraConfig = script:WaitForChild("VehicleCameraConfig")
local v6 = require(VehicleCameraConfig)
VehicleCameraConfig = Players.LocalPlayer
local mapClamp = v3.mapClamp

local function pitchVelocity(a0, a1)
    return math.abs(a1.XVector:Dot(a0))
end

local function yawVelocity(a0, a1)
    return math.abs(a1.YVector:Dot(a0))
end

local v7 = 0.016666666666666666
RunService.Stepped:Connect(function(a0, a1) --[[ Upvalues: v7 (ref) ]]
    v7 = a1
end)
RunService = setmetatable({}, v1)
RunService.__index = RunService

local function new() --[[ Upvalues: v1 (copy), RunService (copy) ]]
    local v8 = setmetatable(v1.new(), RunService)
    v8:Reset()
    return v8
end

RunService.new = new
local Spring = v3.Spring

local function Reset(a0) --[[ Upvalues: v5 (copy), Spring (copy), v6 (copy), v3 (copy), t1 (copy) ]]
    local v9 = a0:GetSubjectCFrame()
    a0.vehicleCameraCore = v5.new(v9)
    a0.pitchSpring = Spring.new(0, -math.rad(v6.pitchBaseAngle))
    a0.yawSpring = Spring.new(0, 0)
    a0.lastPanTick = 0
    local CurrentCamera = workspace.CurrentCamera
    local v11 = CurrentCamera and CurrentCamera.CameraSubject
    assert(CurrentCamera)
    assert(v11)
    local v12 = v11:IsA("VehicleSeat")
    assert(v12)
    CurrentCamera = v11:GetConnectedParts(true)
    local v13, v14 = v3.getLooseBoundingSphere(CurrentCamera)
    a0.assemblyRadius = math.max(v14, 5)
    a0.assemblyOffset = v11.CFrame:Inverse() * v13
    a0.gamepadZoomLevels = {}
    local v15 = t1
    local v16 = nil
    local v17 = nil
    for k1, k2 in v15 do
        table.insert(a0.gamepadZoomLevels, k2 * a0.assemblyRadius / 10)
    end

    a0:SetCameraToSubjectDistance(a0.gamepadZoomLevels[#a0.gamepadZoomLevels])
end

RunService.Reset = Reset
local sanitizeAngle = v3.sanitizeAngle

local function _StepRotation(a0, a1, a2) --[[ Upvalues: v2 (copy), sanitizeAngle (copy), v6 (copy), mapClamp (copy) ]]
    local yawSpring = a0.yawSpring
    local pitchSpring = a0.pitchSpring
    local v18 = v2.getRotation(a1, true)
    local v19 = -v18.X
    local v20 = -v18.Y
    yawSpring.pos = sanitizeAngle(yawSpring.pos + v19)
    local v21 = pitchSpring.pos + v20
    pitchSpring.pos = sanitizeAngle(math.clamp(v21, -1.3962634015954636, 1.3962634015954636))
    if v2.getRotationActivated() then
        a0.lastPanTick = os.clock()
    end

    v20 = -math.rad(v6.pitchBaseAngle)
    v19 = math.rad(v6.pitchDeadzoneAngle)
    local v22 = os.clock() - a0.lastPanTick
    if v6.autocorrectDelay < v22 then
        v18 = mapClamp(a2, v6.autocorrectMinCarSpeed, v6.autocorrectMaxCarSpeed, 0, v6.autocorrectResponse)
        yawSpring.freq = v18
        pitchSpring.freq = v18
        if yawSpring.freq < 0.001 then
            yawSpring.vel = 0
        end

        if pitchSpring.freq < 0.001 then
            pitchSpring.vel = 0
        end

        if math.abs(sanitizeAngle(v20 - pitchSpring.pos)) <= v19 then
            pitchSpring.goal = pitchSpring.pos
            -- jump to 148 (out of range)
        end

        pitchSpring.goal = v20
    else
        yawSpring.freq = 0
        yawSpring.vel = 0
        pitchSpring.freq = 0
        pitchSpring.vel = 0
        pitchSpring.goal = v20
    end

    local v23 = pitchSpring:step(a1)
    local v24 = yawSpring:step(a1)
    local v25 = CFrame.fromEulerAnglesYXZ(v23, v24, 0)
    return v25
end

RunService._StepRotation = _StepRotation

local function _GetThirdPersonLocalOffset(a0) --[[ Upvalues: v6 (copy) ]]
    local v26 = a0.assemblyRadius * v6.verticalCenterOffset
    return a0.assemblyOffset + Vector3.new(0, v26, 0)
end

RunService._GetThirdPersonLocalOffset = _GetThirdPersonLocalOffset

local function _GetFirstPersonLocalOffset(a0, a1) --[[ Upvalues: VehicleCameraConfig (copy) ]]
    local Character = VehicleCameraConfig.Character
    if Character then
        if Character.Parent then
            local Head2 = Character:FindFirstChild("Head")
            if Head2 and Head2:IsA("BasePart") then
                local v27 = a1:Inverse()
                return v27 * Head2.Position
            end
        end
    end

    local v28 = a0:_GetThirdPersonLocalOffset()
    return v28
end

RunService._GetFirstPersonLocalOffset = _GetFirstPersonLocalOffset

local function Update(a0) --[[ Upvalues: v7 (ref), mapClamp (copy) ]]
    local CurrentCamera1 = workspace.CurrentCamera
    local v30 = CurrentCamera1 and CurrentCamera1.CameraSubject
    local vehicleCameraCore = a0.vehicleCameraCore
    assert(CurrentCamera1)
    assert(v30)
    local v31 = v30:IsA("VehicleSeat")
    assert(v31)
    v30 = v7
    v7 = 0
    CurrentCamera1 = a0:GetSubjectCFrame()
    local v32 = a0:GetSubjectVelocity()
    local v33 = a0:GetSubjectRotVelocity()
    local v34 = math.abs(v32:Dot(CurrentCamera1.ZVector))
    v32 = math.abs(CurrentCamera1.YVector:Dot(v33))
    local v35 = math.abs(CurrentCamera1.XVector:Dot(v33))
    v33 = a0:StepZoom()
    local v36 = a0:_StepRotation(v30, v34)
    v34 = mapClamp(v33, 0.5, a0.assemblyRadius, 1, 0)
    local v37 = a0:_GetThirdPersonLocalOffset()
    local v38 = v37:Lerp(a0:_GetFirstPersonLocalOffset(CurrentCamera1), v34)
    vehicleCameraCore:setTransform(CurrentCamera1)
    v37 = CFrame.new(CurrentCamera1 * v38) * vehicleCameraCore:step(v30, v35, v32, v34) * v36
    v38 = v37 * CFrame.new(0, 0, v33)
    return v38, v37
end

RunService.Update = Update

local function ApplyVRTransform(a0)
end

RunService.ApplyVRTransform = ApplyVRTransform
return RunService
