
local t1 = {0, 30}
local VRBaseCamera = script.Parent:WaitForChild("VRBaseCamera")
local v1 = require(VRBaseCamera)
local CameraUtils = script.Parent:WaitForChild("CameraUtils")
local v2 = require(CameraUtils)
local CameraInput = script.Parent:WaitForChild("CameraInput")
local v3 = require(CameraInput)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local VehicleCamera = script.Parent:WaitForChild("VehicleCamera")
local VehicleCameraConfig = VehicleCamera:FindFirstChild("VehicleCameraConfig")
local v4 = require(VehicleCameraConfig)
local v5 = RaycastParams.new()
v5.FilterType = Enum.RaycastFilterType.Exclude
v5.IgnoreWater = true

local function yawVelocity(a0, a1)
    return math.abs(a1.YVector:Dot(a0))
end

local function computeCameraCFrame(a0, a1, a2)
    local v6 = math.atan2(a1.X, a1.Z)
    local v7 = CFrame.new(a0.Position + a1 * a2)
    return v7 * CFrame.Angles(0, v6, 0)
end

local function vrOccludeDisplace(a0, a1, a2, a3) --[[ Upvalues: LocalPlayer (copy), v5 (copy) ]]
    local v8 = math.atan2(a1.X, a1.Z)
    local v9 = CFrame.new(a0.Position + a1 * a2)
    local v10 = v9 * CFrame.Angles(0, v8, 0)
    local CurrentCamera = workspace.CurrentCamera
    if not CurrentCamera then
        return v10
    end

    v9 = a0.Position
    local v11 = v10.Position - v9
    local v12 = v11 * Vector3.new(1, 0, 1)
    v11 = v12.Magnitude
    if v11 < 0.5 then
        return v10
    end

    local v13 = {CurrentCamera}
    if a3 then
        table.insert(v13, a3)
    end

    local v14 = LocalPlayer and LocalPlayer.Character
    if v14 then
        table.insert(v13, v14)
    end

    v5.FilterDescendantsInstances = v13
    v13 = v12.Unit
    v14 = workspace:Raycast(v9, v12, v5)
    if v14 then
        local v16 = v14.Normal:Dot(v13)
        if v16 < 0 then
            v12 = (v14.Position - v9).Magnitude - 0.5
            if v12 < v11 then
                local v17 = math.max(v12, 0.5)
                local v18 = CFrame.new(a0.Position + v13 * v17)
                return v18 * v10.Rotation
            end
        end
    end

    return v10
end

local v19 = OverlapParams.new()
v19.FilterType = Enum.RaycastFilterType.Exclude

local function findObstructions(a0, a1, a2, a3) --[[ Upvalues: VRService (copy), LocalPlayer (copy), v5 (copy), v19 (copy) ]]
    local CurrentCamera1 = workspace.CurrentCamera
    if not CurrentCamera1 then
        return 0, {}
    end

    local Position = a1.Position
    local v20 = VRService:GetUserCFrame(Enum.UserCFrame.Head)
    local v21 = CFrame.new(v20.Position * CurrentCamera1.HeadScale)
    local v22 = a0 * (v21 * v20.Rotation)
    local v23 = v22.Position - Position
    v20 = v23.Magnitude
    if v20 < 0.5 then
        return 0, {}
    end

    local v24 = {CurrentCamera1}
    if a3 then
        table.insert(v24, a3)
    end

    local v25 = LocalPlayer and LocalPlayer.Character
    if v25 then
        table.insert(v24, v25)
    end

    v5.FilterDescendantsInstances = v24
    v25 = workspace:Raycast(Position, v23, v5)
    if v25 then
        local Magnitude1 = (v25.Position - Position).Magnitude
        if Magnitude1 < v20 then
            local v26 = (1 - -v23.Unit:Dot(v22.LookVector)) / 0.13397459621556129
            local v27 = math.clamp(v26, 0, 1)
            local v28 = math.max(v27, 1 - Magnitude1 / a2, 0.15)
            local Position1 = v25.Position
            v27 = v22.Position
            local v29 = (Position1 + v27) / 2
            local v30 = Vector3.new(2, 2, (v27 - Position1).Magnitude)
            Position1 = CFrame.lookAt(v29, v27)
            v19.FilterDescendantsInstances = v24
            return v28, workspace:GetPartBoundsInBox(Position1, v30, v19)
        end
    end

    return 0, {}
end

local v31 = 0.016666666666666666
local v32 = setmetatable({}, v1)
v32.__index = v32

local function new() --[[ Upvalues: v1 (copy), v32 (copy), RunService (copy), v31 (ref) ]]
    local v33 = setmetatable(v1.new(), v32)
    v33.skipOcclusion = true
    v33:Reset()
    if v33.thirdPersonOptionChanged then
        v33.thirdPersonOptionChanged:Disconnect()
        v33.thirdPersonOptionChanged = nil
    end

    RunService.Stepped:Connect(function(a0, a1) --[[ Upvalues: v31 (upvalue) ]]
        v31 = a1
    end)
    return v33
end

v32.new = new

local function Reset(a0) --[[ Upvalues: v2 (copy), t1 (copy) ]]
    local CurrentCamera2 = workspace.CurrentCamera
    local v35 = CurrentCamera2 and CurrentCamera2.CameraSubject
    assert(CurrentCamera2, "VRVehicleCamera initialization error")
    assert(v35)
    local v36 = v35:IsA("VehicleSeat")
    assert(v36)
    a0.lastOrbitalDir = nil
    a0.wasInFirstPerson = nil
    CurrentCamera2 = v35:GetConnectedParts(true)
    table.insert(CurrentCamera2, v35)
    local v37, v38 = v2.getLooseBoundingSphere(CurrentCamera2)
    local v39 = v35:FindFirstAncestorOfClass("Model") or v35.Parent
    a0.vehicleModel = v39
    a0.assemblyRadius = math.max(v38, 5)
    a0.assemblyOffset = v35.CFrame:Inverse() * v37
    a0.gamepadZoomLevels = {}
    local v40 = t1
    local v41 = nil
    local v42 = nil
    for k1, k2 in v40 do
        local v43 = k2 * a0.headScale
        table.insert(a0.gamepadZoomLevels, v43 * a0.assemblyRadius / 10)
    end

    a0.lastCameraFocus = nil
    if not a0:IsInFirstPerson() then
        a0:SetCameraToSubjectDistance(a0.gamepadZoomLevels[#a0.gamepadZoomLevels])
    end

    a0.needsReset = false
end

v32.Reset = Reset

local function _getThirdPersonLocalOffset(a0) --[[ Upvalues: v4 (copy) ]]
    local v44 = a0.assemblyRadius * v4.verticalCenterOffset
    return a0.assemblyOffset + Vector3.new(0, v44, 0)
end

v32._getThirdPersonLocalOffset = _getThirdPersonLocalOffset

local function _getFirstPersonLocalOffset(a0, a1) --[[ Upvalues: LocalPlayer (copy) ]]
    local Character2 = LocalPlayer.Character
    if Character2 then
        if Character2.Parent then
            local Head2 = Character2:FindFirstChild("Head")
            if Head2 and Head2:IsA("BasePart") then
                local v45 = a1:Inverse()
                return v45 * Head2.Position
            end
        end
    end

    local v46 = a0:_getThirdPersonLocalOffset()
    return v46
end

v32._getFirstPersonLocalOffset = _getFirstPersonLocalOffset

local function _vrOccludeVignette(a0, a1, a2, a3) --[[ Upvalues: findObstructions (copy), Lighting (copy), LocalPlayer (copy) ]]
    local v47 = math.atan2(a2.X, a2.Z)
    local v48 = CFrame.new(a1.Position + a2 * a3)
    local v49 = v48 * CFrame.Angles(0, v47, 0)
    local v50, v51 = findObstructions(v49, a1, a3, a0.vehicleModel)
    local VRFade = Lighting:FindFirstChild("VRFade")
    if not VRFade then
        VRFade = Instance.new("ColorCorrectionEffect")
        VRFade.Name = "VRFade"
        VRFade.Parent = Lighting
    end

    VRFade.Brightness = -v50
    if a0.lastOccludedParts then
        local lastOccludedParts = a0.lastOccludedParts
        local v53 = nil
        local v54 = nil
        for k3, k4 in lastOccludedParts do
            k4.LocalTransparencyModifier = 0
        end
    end

    if 0 < #v51 then
        local v55 = v51
        local v56 = nil
        local v57 = nil
        for k5, k6 in v55 do
            k6.LocalTransparencyModifier = 1
        end

        a0:StartVREdgeBlur(LocalPlayer, true)
    end

    a0.lastOccludedParts = v51
    return v49
end

v32._vrOccludeVignette = _vrOccludeVignette

local function Update(a0) --[[ Upvalues: v31 (ref), LocalPlayer (copy) ]]
    local v58 = v31
    v31 = 0
    a0:UpdateFadeFromBlack(v58)
    a0:UpdateEdgeBlur(LocalPlayer, v58)
    local v59, v60 = a0:_updateStepRotation(v58)
    return v59, v60
end

v32.Update = Update
local mapClamp = v2.mapClamp

local function _updateStepRotation(a0, a1) --[[ Upvalues: mapClamp (copy), v3 (copy), v4 (copy), vrOccludeDisplace (copy) ]]
    local v61 = a0:GetSubjectCFrame()
    local v62 = a0:GetCameraToSubjectDistance()
    local v63 = mapClamp(v62, 0.5, a0.assemblyRadius, 1, 0)
    local v64 = a0:_getThirdPersonLocalOffset()
    local v65 = v61 * v64:Lerp(a0:_getFirstPersonLocalOffset(v61), v63)
    local v66 = a0:GetCameraHeight()
    local v67 = CFrame.new(v65 + Vector3.new(0, v66, 0))
    if a0.needsReset or a0.recentered then
        a0.lastOrbitalDir = nil
        a0.needsReset = false
        a0.recentered = false
    end

    local Unit = (v61.LookVector * Vector3.new(-1, 0, -1)).Unit
    a0:StartFadeFromBlack()
    local v68 = a0.lastOrbitalDir or Unit
    local v69 = a0:GetSubjectVelocity()
    v63 = 2 < (v69 * Vector3.new(1, 0, 1)).Magnitude
    if not v63 then
        local v70 = a0:getRotation(a1)
        local v71 = math.abs(v70)
        if 0 < v71 then
            local v72 = CFrame.Angles(0, -v70, 0)
            v68 = (v72 * CFrame.new(v68)).Position.Unit
            a0.lastRotateTime = os.clock()
            -- branch continues at 134
        end
    else
        v3.getRotation(a1)
    end

    local v73
    if a0:IsInFirstPerson() then
        if not a0.wasInFirstPerson or v63 then
            v68 = (v61.LookVector * Vector3.new(-1, 0, -1)).Unit
            a0.wasInFirstPerson = true
        end

        local v74 = -v61.LookVector.X
        local v75 = math.atan2(v74, -v61.LookVector.Z)
        if a0.lastVehicleYaw then
            local v76 = (v75 - a0.lastVehicleYaw + 3.1415926535897931) % 6.2831853071795862 - 3.1415926535897931
            local v77 = math.abs(v76)
            if 0.001 < v77 then
                local v78 = CFrame.Angles(0, v76, 0)
                v68 = (v78 * CFrame.new(v68)).Position.Unit
            end
        end

        a0.lastVehicleYaw = v75
        v75 = math.atan2(v68.X, v68.Z)
        local v79 = CFrame.new(v67.Position + v68 * v62)
        v73 = v79 * CFrame.Angles(0, v75, 0)
    else
        a0.wasInFirstPerson = false
        a0.lastVehicleYaw = nil
        local lastRotateTime = a0.lastRotateTime
        if lastRotateTime then
            local v80 = os.clock() - a0.lastRotateTime
            lastRotateTime = v80 < v4.autocorrectDelay
        end

        if v63 and not lastRotateTime then
            local Unit1 = (v61.LookVector * Vector3.new(-1, 0, -1)).Unit
            local v81 = v68:Dot(Unit1)
            local v82 = math.acos(math.clamp(v81, -1, 1))
            local v83 = 0.01 + v82 / 3.1415926535897931 * 0.05
            local v84 = v83 + math.abs(v61.YVector:Dot(a0:GetSubjectRotVelocity())) * 0.02
            v68 = v68:Lerp(Unit1, math.min(v84, 0.15))
        end

        v73 = vrOccludeDisplace(v67, v68, v62, a0.vehicleModel)
    end

    a0.lastOrbitalDir = v68
    return v73, v73 * CFrame.new(0, 0, -v62)
end

v32._updateStepRotation = _updateStepRotation
return v32
