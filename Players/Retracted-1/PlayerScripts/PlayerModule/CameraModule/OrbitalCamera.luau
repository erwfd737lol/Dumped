
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
CommonUtils = require(FlagUtil).getUserFlag("UserFixOrbitalCameraAzimuth")
local v1 = {
    InitialDistance = 25,
    MinDistance = 10,
    MaxDistance = 100,
    InitialElevation = 35,
    MinElevation = 35,
    MaxElevation = 35,
    ReferenceAzimuth = -45,
    CWAzimuthTravel = 90,
    CCWAzimuthTravel = 90,
    UseAzimuthLimits = false
}
local CameraUtils = script.Parent:WaitForChild("CameraUtils")
local v2 = require(CameraUtils)
local CameraInput = script.Parent:WaitForChild("CameraInput")
local v3 = require(CameraInput)
local Players = game:GetService("Players")
local BaseCamera = script.Parent:WaitForChild("BaseCamera")
local v4 = require(BaseCamera)
local v5 = setmetatable({}, v4)
v5.__index = v5

local function new() --[[ Upvalues: v4 (copy), v5 (copy) ]]
    local v6 = setmetatable(v4.new(), v5)
    v6.lastUpdate = tick()
    v6.changedSignalConnections = {}
    v6.refAzimuthRad = nil
    v6.curAzimuthRad = nil
    v6.minAzimuthAbsoluteRad = nil
    v6.maxAzimuthAbsoluteRad = nil
    v6.useAzimuthLimits = nil
    v6.curElevationRad = nil
    v6.minElevationRad = nil
    v6.maxElevationRad = nil
    v6.curDistance = nil
    v6.minDistance = nil
    v6.maxDistance = nil
    v6.gamepadDollySpeedMultiplier = 1
    v6.lastUserPanCamera = tick()
    v6.externalProperties = {}
    v6.externalProperties.InitialDistance = 25
    v6.externalProperties.MinDistance = 10
    v6.externalProperties.MaxDistance = 100
    v6.externalProperties.InitialElevation = 35
    v6.externalProperties.MinElevation = 35
    v6.externalProperties.MaxElevation = 35
    v6.externalProperties.ReferenceAzimuth = -45
    v6.externalProperties.CWAzimuthTravel = 90
    v6.externalProperties.CCWAzimuthTravel = 90
    v6.externalProperties.UseAzimuthLimits = false
    v6:LoadNumberValueParameters()
    return v6
end

v5.new = new

local function LoadOrCreateNumberValueParameter(a0, a1, a2, a3)
    local v7 = script:FindFirstChild(a1)
    if v7 and v7:IsA(a2) then
        a0.externalProperties[a1] = v7.Value
    else
        if a0.externalProperties[a1] ~= nil then
            v7 = Instance.new(a2)
            v7.Name = a1
            v7.Parent = script
            v7.Value = a0.externalProperties[a1]
        else
            return
        end
    end

    if a3 then
        if a0.changedSignalConnections[a1] then
            a0.changedSignalConnections[a1]:Disconnect()
        end

        a0.changedSignalConnections[a1] = v7.Changed:Connect(function(a0) --[[ Upvalues: a0 (copy), a1 (copy), a3 (copy) ]]
            a0.externalProperties[a1] = a0
            a3(a0)
        end)
    end
end

v5.LoadOrCreateNumberValueParameter = LoadOrCreateNumberValueParameter

local function SetAndBoundsCheckAzimuthValues(a0)
    local v8 = math.rad(a0.externalProperties.ReferenceAzimuth)
    a0.minAzimuthAbsoluteRad = v8 - math.abs(math.rad(a0.externalProperties.CWAzimuthTravel))
    local v9 = math.rad(a0.externalProperties.ReferenceAzimuth)
    a0.maxAzimuthAbsoluteRad = v9 + math.abs(math.rad(a0.externalProperties.CCWAzimuthTravel))
    a0.useAzimuthLimits = a0.externalProperties.UseAzimuthLimits
    if a0.useAzimuthLimits then
        a0.curAzimuthRad = math.max(a0.curAzimuthRad, a0.minAzimuthAbsoluteRad)
        a0.curAzimuthRad = math.min(a0.curAzimuthRad, a0.maxAzimuthAbsoluteRad)
    end
end

v5.SetAndBoundsCheckAzimuthValues = SetAndBoundsCheckAzimuthValues

local function SetAndBoundsCheckElevationValues(a0)
    local MinElevation = a0.externalProperties.MinElevation
    local v10 = math.max(MinElevation, -80)
    local MaxElevation = a0.externalProperties.MaxElevation
    local v11 = math.min(MaxElevation, 80)
    a0.minElevationRad = math.rad(math.min(v10, v11))
    a0.maxElevationRad = math.rad(math.max(v10, v11))
    a0.curElevationRad = math.max(a0.curElevationRad, a0.minElevationRad)
    a0.curElevationRad = math.min(a0.curElevationRad, a0.maxElevationRad)
end

v5.SetAndBoundsCheckElevationValues = SetAndBoundsCheckElevationValues

local function SetAndBoundsCheckDistanceValues(a0)
    a0.minDistance = a0.externalProperties.MinDistance
    a0.maxDistance = a0.externalProperties.MaxDistance
    a0.curDistance = math.max(a0.curDistance, a0.minDistance)
    a0.curDistance = math.min(a0.curDistance, a0.maxDistance)
end

v5.SetAndBoundsCheckDistanceValues = SetAndBoundsCheckDistanceValues

local function LoadNumberValueParameters(a0) --[[ Upvalues: CommonUtils (copy) ]]
    a0:LoadOrCreateNumberValueParameter("InitialElevation", "NumberValue", nil)
    a0:LoadOrCreateNumberValueParameter("InitialDistance", "NumberValue", nil)
    local v12
    if CommonUtils then
        v12 = a0.SetAndBoundsCheckAzimuthValues
    else
        v12 = a0.SetAndBoundsCheckAzimuthValue
    end

    a0:LoadOrCreateNumberValueParameter("ReferenceAzimuth", "NumberValue", v12)
    a0:LoadOrCreateNumberValueParameter("CWAzimuthTravel", "NumberValue", a0.SetAndBoundsCheckAzimuthValues)
    a0:LoadOrCreateNumberValueParameter("CCWAzimuthTravel", "NumberValue", a0.SetAndBoundsCheckAzimuthValues)
    a0:LoadOrCreateNumberValueParameter("MinElevation", "NumberValue", a0.SetAndBoundsCheckElevationValues)
    a0:LoadOrCreateNumberValueParameter("MaxElevation", "NumberValue", a0.SetAndBoundsCheckElevationValues)
    a0:LoadOrCreateNumberValueParameter("MinDistance", "NumberValue", a0.SetAndBoundsCheckDistanceValues)
    a0:LoadOrCreateNumberValueParameter("MaxDistance", "NumberValue", a0.SetAndBoundsCheckDistanceValues)
    a0:LoadOrCreateNumberValueParameter("UseAzimuthLimits", "BoolValue", a0.SetAndBoundsCheckAzimuthValues)
    a0.curAzimuthRad = math.rad(a0.externalProperties.ReferenceAzimuth)
    a0.curElevationRad = math.rad(a0.externalProperties.InitialElevation)
    a0.curDistance = a0.externalProperties.InitialDistance
    a0:SetAndBoundsCheckAzimuthValues()
    a0:SetAndBoundsCheckElevationValues()
    a0:SetAndBoundsCheckDistanceValues()
end

v5.LoadNumberValueParameters = LoadNumberValueParameters

local function GetModuleName(a0)
    return "OrbitalCamera"
end

v5.GetModuleName = GetModuleName

local function SetInitialOrientation(a0, a1) --[[ Upvalues: v2 (copy) ]]
    if not (a1 and a1.RootPart) then
        warn("OrbitalCamera could not set initial orientation due to missing humanoid")
        return
    end

    assert(a1.RootPart, "")
    local Unit = (a1.RootPart.CFrame.LookVector - Vector3.new(0, 0.23000000417232513, 0)).Unit
    local v13 = a0:GetCameraLookVector()
    local v14 = v2.GetAngleBetweenXZVectors(Unit, v13)
    local v15 = math.asin(a0:GetCameraLookVector().Y)
    local v16 = v15 - math.asin(Unit.Y)
    if not v2.IsFinite(v14) then
    end

    if not v2.IsFinite(v16) then
    end
end

v5.SetInitialOrientation = SetInitialOrientation

local function GetCameraToSubjectDistance(a0)
    return a0.curDistance
end

v5.GetCameraToSubjectDistance = GetCameraToSubjectDistance

local function SetCameraToSubjectDistance(a0, a1) --[[ Upvalues: Players (copy) ]]
    if Players.LocalPlayer then
        a0.currentSubjectDistance = math.clamp(a1, a0.minDistance, a0.maxDistance)
        a0.currentSubjectDistance = math.max(a0.currentSubjectDistance, a0.FIRST_PERSON_DISTANCE_THRESHOLD)
    end

    a0.inFirstPerson = false
    a0:UpdateMouseBehavior()
    return a0.currentSubjectDistance
end

v5.SetCameraToSubjectDistance = SetCameraToSubjectDistance

local function CalculateNewLookVector(a0, a1, a2)
    local v19 = a1 or a0:GetCameraLookVector()
    local v20 = math.asin(v19.Y)
    local v21 = math.clamp(a2.Y, v20 - 1.3962634015954636, v20 - -1.3962634015954636)
    v20 = Vector2.new(a2.X, v21)
    local v22 = CFrame.new(Vector3.new(0, 0, 0), v19)
    local v23 = -v20.X
    local v24 = CFrame.Angles(0, v23, 0) * v22
    local v25 = -v20.Y
    return (v24 * CFrame.Angles(v25, 0, 0)).LookVector
end

v5.CalculateNewLookVector = CalculateNewLookVector

local function Update(a0, a1) --[[ Upvalues: v3 (copy), Players (copy) ]]
    local v26 = tick()
    local v27 = v26 - a0.lastUpdate
    local v28 = v3.getRotation(a1)
    local CurrentCamera = workspace.CurrentCamera
    local CFrame = CurrentCamera.CFrame
    local Focus = CurrentCamera.Focus
    local LocalPlayer = Players.LocalPlayer
    local v30 = CurrentCamera and CurrentCamera.CameraSubject
    local v33 = v30 and v30:IsA("VehicleSeat")
    local v36 = v30 and v30:IsA("SkateboardPlatform")
    if a0.lastUpdate == nil or 1 < v27 then
        a0.lastCameraTransform = nil
    end

    if v28 ~= Vector2.new() then
        a0.lastUserPanCamera = tick()
    end

    local v37 = a0:GetSubjectPosition()
    if v37 then
        if LocalPlayer then
            if CurrentCamera then
                if a0.gamepadDollySpeedMultiplier ~= 1 then
                    a0:SetCameraToSubjectDistance(a0.currentSubjectDistance * a0.gamepadDollySpeedMultiplier)
                end

                Focus = CFrame.new(v37)
                v27 = v3.getRotation(a1)
                a0.curAzimuthRad = a0.curAzimuthRad - v27.X
                if a0.useAzimuthLimits then
                    a0.curAzimuthRad = math.clamp(a0.curAzimuthRad, a0.minAzimuthAbsoluteRad, a0.maxAzimuthAbsoluteRad)
                else
                    local v38 = math.sign(a0.curAzimuthRad)
                    local v39 = v38 * (math.abs(a0.curAzimuthRad) % 6.2831853071795862)
                    a0.curAzimuthRad = a0.curAzimuthRad ~= 0 and v39 or 0
                end

                local v40 = a0.curElevationRad + v27.Y
                a0.curElevationRad = math.clamp(v40, a0.minElevationRad, a0.maxElevationRad)
                local v41 = -a0.curElevationRad
                local v42 = CFrame.fromEulerAnglesYXZ(v41, a0.curAzimuthRad, 0)
                CFrame = CFrame.new(v37 + a0.currentSubjectDistance * (v42 * Vector3.new(0, 0, 1)), v37)
                a0.lastCameraTransform = CFrame
                a0.lastCameraFocus = Focus
                if v33 or v36 then
                    if v30:IsA("BasePart") then
                        a0.lastSubjectCFrame = v30.CFrame
                        -- jump to 204 (out of range)
                    end
                end

                a0.lastSubjectCFrame = nil
            end
        end
    end

    a0.lastUpdate = v26
    return CFrame, Focus
end

v5.Update = Update
return v5
