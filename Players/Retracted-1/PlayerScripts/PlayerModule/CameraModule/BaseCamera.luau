
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local ConnectionUtil = CommonUtils:WaitForChild("ConnectionUtil")
local v1 = require(ConnectionUtil)
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
local v2 = require(FlagUtil)
local CameraUtils = script.Parent:WaitForChild("CameraUtils")
local v3 = require(CameraUtils)
local ZoomController = script.Parent:WaitForChild("ZoomController")
CommonUtils = require(ZoomController)
local CameraToggleStateController = script.Parent:WaitForChild("CameraToggleStateController")
local v4 = require(CameraToggleStateController)
local CameraInput = script.Parent:WaitForChild("CameraInput")
local v5 = require(CameraInput)
local CameraUI = script.Parent:WaitForChild("CameraUI")
local v6 = require(CameraUI)
CameraUI = Players.LocalPlayer
Players = Vector2.new(0, 0)
local v7 = {}
v7.__index = v7

local function new() --[[ Upvalues: v7 (copy), v1 (copy), CameraUI (copy), UserGameSettings (copy) ]]
    local v8 = setmetatable({}, v7)
    v8._connections = v1.new()
    local v9 = {0, 10, 20}
    v8.gamepadZoomLevels = v9
    v8.FIRST_PERSON_DISTANCE_THRESHOLD = 1
    v8.cameraType = nil
    v8.cameraMovementMode = nil
    v8.lastCameraTransform = nil
    v8.lastUserPanCamera = tick()
    v8.humanoidRootPart = nil
    v8.humanoidCache = {}
    v8.lastSubject = nil
    v8.lastSubjectPosition = Vector3.new(0, 5, 0)
    v8.lastSubjectCFrame = CFrame.new(v8.lastSubjectPosition)
    v8.currentSubjectDistance = math.clamp(12.5, CameraUI.CameraMinZoomDistance, CameraUI.CameraMaxZoomDistance)
    v8.inFirstPerson = false
    v8.inMouseLockedMode = false
    v8.resetCameraAngle = true
    v8.enabled = false
    v8.cameraChangedConn = nil
    v8.shouldUseVRRotation = false
    v8.VRRotationIntensityAvailable = false
    v8.lastVRRotationIntensityCheckTime = 0
    v8.lastVRRotationTime = 0
    v8.vrRotateKeyCooldown = {}
    v8.cameraTranslationConstraints = Vector3.new(1, 1, 1)
    v8.humanoidJumpOrigin = nil
    v8.trackingHumanoid = nil
    v8.cameraFrozen = false
    v8.subjectStateChangedConn = nil
    v8.gamepadZoomPressConnection = nil
    v8.mouseLockOffset = Vector3.new(0, 0, 0)
    UserGameSettings:SetCameraYInvertVisible()
    UserGameSettings:SetGamepadCameraSensitivityVisible()
    return v8
end

v7.new = new

local function GetModuleName(a0)
    return "BaseCamera"
end

v7.GetModuleName = GetModuleName

local function _setUpConfigurations(a0) --[[ Upvalues: CameraUI (copy) ]]
    local v10 = CameraUI.CharacterAdded:Connect(function(a0) --[[ Upvalues: a0 (copy) ]]
        a0:OnCharacterAdded(a0)
    end)
    a0._connections:trackConnection("CHARACTER_ADDED", v10)
    a0.humanoidRootPart = nil
    local v11 = CameraUI:GetPropertyChangedSignal("CameraMode")
    local v12 = v11:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:OnPlayerCameraPropertyChange()
    end)
    a0._connections:trackConnection("CAMERA_MODE_CHANGED", v12)
    local v13 = CameraUI:GetPropertyChangedSignal("CameraMinZoomDistance")
    local v14 = v13:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:OnPlayerCameraPropertyChange()
    end)
    a0._connections:trackConnection("CAMERA_MIN_DISTANCE_CHANGED", v14)
    local v15 = CameraUI:GetPropertyChangedSignal("CameraMaxZoomDistance")
    local v16 = v15:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:OnPlayerCameraPropertyChange()
    end)
    a0._connections:trackConnection("CAMERA_MAX_DISTANCE_CHANGED", v16)
    a0:OnPlayerCameraPropertyChange()
end

v7._setUpConfigurations = _setUpConfigurations

local function OnCharacterAdded(a0, a1)
    local v18 = a0.resetCameraAngle or a0:GetEnabled()
    a0.resetCameraAngle = v18
    a0.humanoidRootPart = nil
end

v7.OnCharacterAdded = OnCharacterAdded

local function GetHumanoidRootPart(a0) --[[ Upvalues: CameraUI (copy) ]]
    if not a0.humanoidRootPart then
        if CameraUI.Character then
            local v21 = CameraUI.Character:FindFirstChildOfClass("Humanoid")
            if v21 then
                a0.humanoidRootPart = v21.RootPart
            end
        end
    end

    return a0.humanoidRootPart
end

v7.GetHumanoidRootPart = GetHumanoidRootPart

local function GetBodyPartToFollow(a0, a1, a2)
    local v22 = a1:GetState()
    if v22 == Enum.HumanoidStateType.Dead then
        v22 = a1.Parent
        if v22 then
            if v22:IsA("Model") then
                local v23 = v22:FindFirstChild("Head") or a1.RootPart
                return v23
            end
        end
    end

    return a1.RootPart
end

v7.GetBodyPartToFollow = GetBodyPartToFollow

local function GetSubjectCFrame(a0)
    local CurrentCamera = workspace.CurrentCamera
    local v25 = CurrentCamera and CurrentCamera.CameraSubject
    if not v25 then
        return a0.lastSubjectCFrame
    end

    local v26
    if v25:IsA("Humanoid") then
        local v27 = v25:GetState()
        CurrentCamera = v27 == Enum.HumanoidStateType.Dead
        v27 = v25.CameraOffset
        if a0:GetIsMouseLocked() then
            v27 = Vector3.new()
        end

        local RootPart1 = v25.RootPart
        if CurrentCamera and v25.Parent and v25.Parent:IsA("Model") then
            RootPart1 = v25.Parent:FindFirstChild("Head") or RootPart1
        end

        if RootPart1 then
            local v29
            if RootPart1:IsA("BasePart") then
                if v25.RigType == Enum.HumanoidRigType.R15 then
                    if v25.AutomaticScalingEnabled then
                        local RootPart2 = v25.RootPart
                        if RootPart1 == RootPart2 then
                            v29 = Vector3.new(0, 1.5, 0) + Vector3.new(0, (RootPart2.Size.Y - 2) / 2, 0)
                            -- jump to 103 (out of range)
                            -- branch continues at 103
                        end
                    end

                    v29 = Vector3.new(0, 2, 0)
                else
                    v29 = Vector3.new(0, 1.5, 0)
                end

                if CurrentCamera then
                    v29 = Vector3.new(0, 0, 0)
                end

                v26 = RootPart1.CFrame * CFrame.new(nil + v27)
                -- branch continues at 143
            end

            -- branch continues at 143
        end
    else
        if v25:IsA("BasePart") then
            v26 = v25.CFrame
        else
            if v25:IsA("Model") then
                if v25.PrimaryPart then
                    v26 = v25:GetPrimaryPartCFrame()
                else
                    v26 = CFrame.new()
                end
            end
        end
    end

    if v26 then
        a0.lastSubjectCFrame = v26
    end

    return v26
end

v7.GetSubjectCFrame = GetSubjectCFrame

local function GetSubjectVelocity(a0)
    local CurrentCamera1 = workspace.CurrentCamera
    local v31 = CurrentCamera1 and CurrentCamera1.CameraSubject
    if not v31 then
        return Vector3.new(0, 0, 0)
    end

    if v31:IsA("BasePart") then
        return v31.Velocity
    end

    if v31:IsA("Humanoid") then
        CurrentCamera1 = v31.RootPart
        if CurrentCamera1 then
            return CurrentCamera1.Velocity
            -- branch continues at 45
        end
    else
        if v31:IsA("Model") then
            local PrimaryPart1 = v31.PrimaryPart
            if PrimaryPart1 then
                return PrimaryPart1.Velocity
            end
        end
    end

    return Vector3.new(0, 0, 0)
end

v7.GetSubjectVelocity = GetSubjectVelocity

local function GetSubjectRotVelocity(a0)
    local CurrentCamera2 = workspace.CurrentCamera
    local v33 = CurrentCamera2 and CurrentCamera2.CameraSubject
    if not v33 then
        return Vector3.new(0, 0, 0)
    end

    if v33:IsA("BasePart") then
        return v33.RotVelocity
    end

    if v33:IsA("Humanoid") then
        CurrentCamera2 = v33.RootPart
        if CurrentCamera2 then
            return CurrentCamera2.RotVelocity
            -- branch continues at 45
        end
    else
        if v33:IsA("Model") then
            local PrimaryPart3 = v33.PrimaryPart
            if PrimaryPart3 then
                return PrimaryPart3.RotVelocity
            end
        end
    end

    return Vector3.new(0, 0, 0)
end

v7.GetSubjectRotVelocity = GetSubjectRotVelocity

local function StepZoom(a0) --[[ Upvalues: v5 (copy), CommonUtils (copy) ]]
    local currentSubjectDistance = a0.currentSubjectDistance
    local v34 = v5.getZoomDelta()
    local v35 = math.abs(v34)
    if 0 < v35 then
        local v36
        if 0 < v34 then
            v36 = math.max(currentSubjectDistance + v34 * (currentSubjectDistance * 0.5 + 1), a0.FIRST_PERSON_DISTANCE_THRESHOLD)
        else
            v36 = math.max((currentSubjectDistance + v34) / (1 - v34 * 0.5), 0.5)
        end

        if v36 < a0.FIRST_PERSON_DISTANCE_THRESHOLD then
            v36 = 0.5
        end

        a0:SetCameraToSubjectDistance(v36)
    end

    local v37 = CommonUtils.GetZoomRadius()
    return v37
end

v7.StepZoom = StepZoom

local function GetSubjectPosition(a0)
    local lastSubjectPosition = a0.lastSubjectPosition
    local CurrentCamera3 = game.Workspace.CurrentCamera
    local v39 = CurrentCamera3 and CurrentCamera3.CameraSubject
    if not v39 then
        return nil
    end

    if v39:IsA("Humanoid") then
        local v40 = v39:GetState()
        CurrentCamera3 = v40 == Enum.HumanoidStateType.Dead
        v40 = v39.CameraOffset
        if a0:GetIsMouseLocked() then
            v40 = Vector3.new()
        end

        local RootPart3 = v39.RootPart
        if CurrentCamera3 and v39.Parent and v39.Parent:IsA("Model") then
            RootPart3 = v39.Parent:FindFirstChild("Head") or RootPart3
        end

        if RootPart3 then
            local v42
            if RootPart3:IsA("BasePart") then
                if v39.RigType == Enum.HumanoidRigType.R15 then
                    if v39.AutomaticScalingEnabled then
                        if RootPart3 == v39.RootPart then
                            v42 = Vector3.new(0, 1.5, 0) + Vector3.new(0, v39.RootPart.Size.Y / 2 - 1, 0)
                            -- jump to 106 (out of range)
                            -- branch continues at 106
                        end
                    end

                    v42 = Vector3.new(0, 2, 0)
                else
                    v42 = Vector3.new(0, 1.5, 0)
                end

                if CurrentCamera3 then
                    v42 = Vector3.new(0, 0, 0)
                end

                lastSubjectPosition = RootPart3.CFrame.p + RootPart3.CFrame:vectorToWorldSpace(nil + v40)
                -- branch continues at 189
            end

            -- branch continues at 189
        end
    else
        if v39:IsA("VehicleSeat") then
            lastSubjectPosition = v39.CFrame.p + v39.CFrame:vectorToWorldSpace(Vector3.new(0, 5, 0))
        else
            if v39:IsA("SkateboardPlatform") then
                lastSubjectPosition = v39.CFrame.p + Vector3.new(0, 5, 0)
            else
                if v39:IsA("BasePart") then
                    lastSubjectPosition = v39.CFrame.p
                else
                    if v39:IsA("Model") then
                        if v39.PrimaryPart then
                            lastSubjectPosition = v39:GetPrimaryPartCFrame().p
                        else
                            lastSubjectPosition = v39:GetModelCFrame().p
                        end
                    end
                end
            end
        end
    end

    a0.lastSubject = v39
    a0.lastSubjectPosition = lastSubjectPosition
    return lastSubjectPosition
end

v7.GetSubjectPosition = GetSubjectPosition

local function OnCurrentCameraChanged(a0)
    if a0.cameraSubjectChangedConn then
        a0.cameraSubjectChangedConn:Disconnect()
        a0.cameraSubjectChangedConn = nil
    end

    local CurrentCamera4 = game.Workspace.CurrentCamera
    if CurrentCamera4 then
        local v43 = CurrentCamera4:GetPropertyChangedSignal("CameraSubject")
        a0.cameraSubjectChangedConn = v43:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:OnNewCameraSubject()
        end)
        a0:OnNewCameraSubject()
    end
end

v7.OnCurrentCameraChanged = OnCurrentCameraChanged

local function OnPlayerCameraPropertyChange(a0)
    a0:SetCameraToSubjectDistance(a0.currentSubjectDistance)
end

v7.OnPlayerCameraPropertyChange = OnPlayerCameraPropertyChange

local function InputTranslationToCameraAngleChange(a0, a1, a2)
    return a1 * a2
end

v7.InputTranslationToCameraAngleChange = InputTranslationToCameraAngleChange

local function GamepadZoomPress(a0) --[[ Upvalues: CameraUI (copy) ]]
    local v44 = a0:GetCameraToSubjectDistance()
    local CameraMaxZoomDistance = CameraUI.CameraMaxZoomDistance
    for i1 = #a0.gamepadZoomLevels, 1, -1 do
        local v47 = a0.gamepadZoomLevels[i1]
        if CameraMaxZoomDistance >= v47 then
            if v47 < CameraUI.CameraMinZoomDistance then
                v47 = CameraUI.CameraMinZoomDistance
                if CameraMaxZoomDistance == v47 then
                    break
                end
            end

            if v47 + (CameraMaxZoomDistance - v47) / 2 < v44 then
                a0:SetCameraToSubjectDistance(v47)
                return
            end

            CameraMaxZoomDistance = v47
        end
    end

    a0:SetCameraToSubjectDistance(a0.gamepadZoomLevels[#a0.gamepadZoomLevels])
end

v7.GamepadZoomPress = GamepadZoomPress

local function Enable(a0, a1)
    if a0.enabled ~= a1 then
        a0.enabled = a1
        a0:OnEnabledChanged()
    end
end

v7.Enable = Enable

local function OnEnabledChanged(a0) --[[ Upvalues: v5 (copy), CameraUI (copy) ]]
    if a0.enabled then
        a0:_setUpConfigurations()
        v5.setInputEnabled(true)
        a0.gamepadZoomPressConnection = v5.gamepadZoomPress:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:GamepadZoomPress()
        end)
        if CameraUI.CameraMode == Enum.CameraMode.LockFirstPerson then
            a0.currentSubjectDistance = 0.5
            if not a0.inFirstPerson then
                a0:EnterFirstPerson()
            end
        end

        if a0.cameraChangedConn then
            a0.cameraChangedConn:Disconnect()
            a0.cameraChangedConn = nil
        end

        local v48 = workspace:GetPropertyChangedSignal("CurrentCamera")
        a0.cameraChangedConn = v48:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:OnCurrentCameraChanged()
        end)
        a0:OnCurrentCameraChanged()
        return
    end

    a0._connections:disconnectAll()
    v5.setInputEnabled(false)
    if a0.gamepadZoomPressConnection then
        a0.gamepadZoomPressConnection:Disconnect()
        a0.gamepadZoomPressConnection = nil
    end

    a0:Cleanup()
end

v7.OnEnabledChanged = OnEnabledChanged

local function GetEnabled(a0)
    return a0.enabled
end

v7.GetEnabled = GetEnabled

local function Cleanup(a0) --[[ Upvalues: v3 (copy) ]]
    if a0.subjectStateChangedConn then
        a0.subjectStateChangedConn:Disconnect()
        a0.subjectStateChangedConn = nil
    end

    if a0.cameraChangedConn then
        a0.cameraChangedConn:Disconnect()
        a0.cameraChangedConn = nil
    end

    a0.lastCameraTransform = nil
    a0.lastSubjectCFrame = nil
    v3.restoreMouseBehavior()
end

v7.Cleanup = Cleanup

local function UpdateMouseBehavior(a0) --[[ Upvalues: UserGameSettings (copy), v6 (copy), v5 (copy), v4 (copy), v3 (copy) ]]
    if a0.isCameraToggle and UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove == false then
        v6.setCameraModeToastEnabled(true)
        v5.enableCameraToggleInput()
        v4(a0.inFirstPerson)
        return
    end

    v6.setCameraModeToastEnabled(false)
    v5.disableCameraToggleInput()
    if a0.inFirstPerson or a0.inMouseLockedMode then
        v3.setRotationTypeOverride(Enum.RotationType.CameraRelative)
        v3.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)
        return
    end

    v3.restoreRotationType()
    if v5.getRotationActivated() then
        v3.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition)
        return
    end

    v3.restoreMouseBehavior()
end

v7.UpdateMouseBehavior = UpdateMouseBehavior

local function UpdateForDistancePropertyChange(a0)
    a0:SetCameraToSubjectDistance(a0.currentSubjectDistance)
end

v7.UpdateForDistancePropertyChange = UpdateForDistancePropertyChange

local function SetCameraToSubjectDistance(a0, a1) --[[ Upvalues: CameraUI (copy), CommonUtils (copy) ]]
    local currentSubjectDistance1 = a0.currentSubjectDistance
    if CameraUI.CameraMode == Enum.CameraMode.LockFirstPerson then
        a0.currentSubjectDistance = 0.5
        if not a0.inFirstPerson then
            a0:EnterFirstPerson()
            -- branch continues at 55
        end
    else
        local v49 = math.clamp(a1, CameraUI.CameraMinZoomDistance, CameraUI.CameraMaxZoomDistance)
        if v49 < 1 then
            a0.currentSubjectDistance = 0.5
            if not a0.inFirstPerson then
                a0:EnterFirstPerson()
                -- branch continues at 55
            end
        else
            a0.currentSubjectDistance = v49
            if a0.inFirstPerson then
                a0:LeaveFirstPerson()
            end
        end
    end

    CommonUtils.SetZoomParameters(a0.currentSubjectDistance, math.sign(a1 - currentSubjectDistance1))
    return a0.currentSubjectDistance
end

v7.SetCameraToSubjectDistance = SetCameraToSubjectDistance

local function SetCameraType(a0, a1)
    a0.cameraType = a1
end

v7.SetCameraType = SetCameraType

local function GetCameraType(a0)
    return a0.cameraType
end

v7.GetCameraType = GetCameraType

local function SetCameraMovementMode(a0, a1)
    a0.cameraMovementMode = a1
end

v7.SetCameraMovementMode = SetCameraMovementMode

local function GetCameraMovementMode(a0)
    return a0.cameraMovementMode
end

v7.GetCameraMovementMode = GetCameraMovementMode

local function SetIsMouseLocked(a0, a1)
    a0.inMouseLockedMode = a1
end

v7.SetIsMouseLocked = SetIsMouseLocked

local function GetIsMouseLocked(a0)
    return a0.inMouseLockedMode
end

v7.GetIsMouseLocked = GetIsMouseLocked

local function SetMouseLockOffset(a0, a1)
    a0.mouseLockOffset = a1
end

v7.SetMouseLockOffset = SetMouseLockOffset

local function GetMouseLockOffset(a0)
    return a0.mouseLockOffset
end

v7.GetMouseLockOffset = GetMouseLockOffset

local function InFirstPerson(a0)
    return a0.inFirstPerson
end

v7.InFirstPerson = InFirstPerson

local function EnterFirstPerson(a0)
    a0.inFirstPerson = true
    a0:UpdateMouseBehavior()
end

v7.EnterFirstPerson = EnterFirstPerson

local function LeaveFirstPerson(a0)
    a0.inFirstPerson = false
    a0:UpdateMouseBehavior()
end

v7.LeaveFirstPerson = LeaveFirstPerson

local function GetCameraToSubjectDistance(a0)
    return a0.currentSubjectDistance
end

v7.GetCameraToSubjectDistance = GetCameraToSubjectDistance

local function GetMeasuredDistanceToFocus(a0)
    local CurrentCamera5 = game.Workspace.CurrentCamera
    if CurrentCamera5 then
        return (CurrentCamera5.CoordinateFrame.p - CurrentCamera5.Focus.p).magnitude
    end

    return nil
end

v7.GetMeasuredDistanceToFocus = GetMeasuredDistanceToFocus

local function GetCameraLookVector(a0)
    local v51 = game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, 1)
    return v51
end

v7.GetCameraLookVector = GetCameraLookVector

local function CalculateNewLookCFrameFromArg(a0, a1, a2)
    local v54 = a1 or a0:GetCameraLookVector()
    local v55 = math.asin(v54.Y)
    local v56 = math.clamp(a2.Y, v55 + -1.3962634015954636, v55 + 1.3962634015954636)
    v55 = Vector2.new(a2.X, v56)
    local v57 = CFrame.new(Vector3.new(0, 0, 0), v54)
    local v58 = -v55.X
    local v59 = CFrame.Angles(0, v58, 0) * v57
    local v60 = -v55.Y
    return v59 * CFrame.Angles(v60, 0, 0)
end

v7.CalculateNewLookCFrameFromArg = CalculateNewLookCFrameFromArg

local function CalculateNewLookVectorFromArg(a0, a1, a2)
    return a0:CalculateNewLookCFrameFromArg(a1, a2).LookVector
end

v7.CalculateNewLookVectorFromArg = CalculateNewLookVectorFromArg

local function CalculateNewLookVectorVRFromArg(a0, a1)
    local v61 = a0:GetSubjectPosition() - game.Workspace.CurrentCamera.CFrame.p
    local v62 = Vector2.new(a1.X, 0)
    local v63 = CFrame.new(Vector3.new(0, 0, 0), (v61 * Vector3.new(1, 0, 1)).unit)
    local v64 = -v62.X
    local v65 = CFrame.Angles(0, v64, 0) * v63
    local v66 = -v62.Y
    return ((v65 * CFrame.Angles(v66, 0, 0)).LookVector * Vector3.new(1, 0, 1)).unit
end

v7.CalculateNewLookVectorVRFromArg = CalculateNewLookVectorVRFromArg

local function GetHumanoid(a0) --[[ Upvalues: CameraUI (copy) ]]
    local v68 = CameraUI and CameraUI.Character
    if v68 then
        local v69 = a0.humanoidCache[CameraUI]
        if v69 and v69.Parent == v68 then
            return v69
        end

        a0.humanoidCache[CameraUI] = nil
        local v70 = v68:FindFirstChildOfClass("Humanoid")
        if v70 then
            a0.humanoidCache[CameraUI] = v70
        end

        return v70
    end

    return nil
end

v7.GetHumanoid = GetHumanoid

local function GetHumanoidPartToFollow(a0, a1, a2)
    if a2 == Enum.HumanoidStateType.Dead then
        local Parent = a1.Parent
        if Parent then
            local v71 = Parent:FindFirstChild("Head") or a1.Torso
            return v71
        end

        return a1.Torso
    end

    return a1.Torso
end

v7.GetHumanoidPartToFollow = GetHumanoidPartToFollow

local function OnNewCameraSubject(a0)
    if a0.subjectStateChangedConn then
        a0.subjectStateChangedConn:Disconnect()
        a0.subjectStateChangedConn = nil
    end
end

v7.OnNewCameraSubject = OnNewCameraSubject

local function IsInFirstPerson(a0)
    return a0.inFirstPerson
end

v7.IsInFirstPerson = IsInFirstPerson

local function Update(a0, a1)
    error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2)
end

v7.Update = Update

local function GetCameraHeight(a0) --[[ Upvalues: VRService (copy) ]]
    if VRService.VREnabled and not a0.inFirstPerson then
        return 0.25881904510252074 * a0.currentSubjectDistance
    end

    return 0
end

v7.GetCameraHeight = GetCameraHeight
return v7
