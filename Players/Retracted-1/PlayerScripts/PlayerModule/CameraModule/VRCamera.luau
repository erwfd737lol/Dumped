
local Players = game:GetService("Players")
local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CameraInput = script.Parent:WaitForChild("CameraInput")
local v1 = require(CameraInput)
local CameraUtils = script.Parent:WaitForChild("CameraUtils")
local v2 = require(CameraUtils)
local VRCameraTeleportDetector = script.Parent:WaitForChild("VRCameraTeleportDetector")
local v3 = require(VRCameraTeleportDetector)
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
local v4 = require(FlagUtil)
CommonUtils = v4.getUserFlag("UserVRRecenterOnExternalTeleport")
local v5 = v4.getUserFlag("UserFixVRImmersionAutoRotate")
local VRBaseCamera = script.Parent:WaitForChild("VRBaseCamera")
v4 = require(VRBaseCamera)
local v6 = setmetatable({}, v4)
v6.__index = v6

local function new() --[[ Upvalues: v4 (copy), v6 (copy), Players (copy) ]]
    local v7 = setmetatable(v4.new(), v6)
    v7.lastUpdate = tick()
    v7.focusOffset = CFrame.new()
    v7:Reset()
    local ControlModule = Players.LocalPlayer:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule")
    v7.controlModule = require(ControlModule)
    v7.savedAutoRotate = true
    v7.autoRotateOverridden = false
    return v7
end

v6.new = new

local function Reset(a0) --[[ Upvalues: v4 (copy) ]]
    a0.needsReset = true
    a0.needsBlackout = true
    a0.motionDetTime = 0
    a0.blackOutTimer = 0
    a0.lastCameraResetPosition = nil
    v4.Reset(a0)
end

v6.Reset = Reset

local function Update(a0, a1) --[[ Upvalues: Players (copy), VRService (copy) ]]
    local CurrentCamera = workspace.CurrentCamera
    local CFrame = CurrentCamera.CFrame
    local Focus = CurrentCamera.Focus
    local LocalPlayer = Players.LocalPlayer
    local v8 = a0:GetHumanoid()
    if a0.lastUpdate == nil or 1 < a1 then
        a0.lastCameraTransform = nil
    end

    a0:UpdateFadeFromBlack(a1)
    local lastSubjectPosition = a0.lastSubjectPosition
    local v9 = a0:GetSubjectPosition()
    if a0.needsBlackout then
        a0:StartFadeFromBlack()
        local v10 = math.clamp(a1, 0.0001, 0.1)
        a0.blackOutTimer = a0.blackOutTimer + v10
        if 0.1 < a0.blackOutTimer and game:IsLoaded() then
            a0.needsBlackout = false
            a0.needsReset = true
        end
    end

    if v9 then
        if LocalPlayer then
            if CurrentCamera then
                Focus = a0:GetVRFocus(v9, a1)
                if a0:IsInFirstPerson() then
                    if VRService.AvatarGestures then
                        local v11, v12 = a0:UpdateImmersionCamera(a1, CFrame, Focus, lastSubjectPosition, v9)
                        CFrame = v11
                        Focus = v12
                        -- jump to 146 (out of range)
                    end

                    local v13, v14 = a0:UpdateFirstPersonTransform(a1, CFrame, Focus, lastSubjectPosition, v9)
                    CFrame = v13
                    Focus = v14
                else
                    if VRService.ThirdPersonFollowCamEnabled then
                        local v15, v16 = a0:UpdateThirdPersonFollowTransform(a1, CFrame, Focus, lastSubjectPosition, v9)
                        CFrame = v15
                        Focus = v16
                    else
                        local v17, v18 = a0:UpdateThirdPersonComfortTransform(a1, CFrame, Focus, lastSubjectPosition, v9)
                        CFrame = v17
                        Focus = v18
                    end
                end

                a0.lastCameraTransform = CFrame
                a0.lastCameraFocus = Focus
            end
        end
    end

    a0.lastUpdate = tick()
    return CFrame, Focus
end

v6.Update = Update

local function GetAvatarFeetWorldYValue(a0)
    local CameraSubject = workspace.CurrentCamera.CameraSubject
    if not CameraSubject then
        return nil
    end

    if CameraSubject:IsA("Humanoid") and CameraSubject.RootPart then
        local RootPart = CameraSubject.RootPart
        local v19 = RootPart.Position.Y - RootPart.Size.Y / 2
        return v19 - CameraSubject.HipHeight
    end

    return nil
end

v6.GetAvatarFeetWorldYValue = GetAvatarFeetWorldYValue

local function UpdateFirstPersonTransform(a0, a1, a2, a3, a4, a5)
    if a0.needsReset then
        a0:StartFadeFromBlack()
        a0.needsReset = false
    end

    local p = a3.p
    local v20 = a0:GetCameraLookVector()
    v20 = Vector3.new(v20.X, 0, v20.Z).Unit
    local v21 = Vector2.new(a0:getRotation(a1), 0)
    local v22 = a0:CalculateNewLookVectorFromArg(v20, v21)
    local v23 = p - 0.5 * v22
    return CFrame.new(v23, p), a3
end

v6.UpdateFirstPersonTransform = UpdateFirstPersonTransform

local function UpdateImmersionCamera(a0, a1, a2, a3, a4, a5) --[[ Upvalues: Players (copy), CommonUtils (copy), v5 (copy), VRService (copy), v3 (copy) ]]
    local v24 = a0:GetSubjectCFrame()
    local CurrentCamera1 = workspace.CurrentCamera
    local Character = Players.LocalPlayer.Character
    local v25 = a0:GetHumanoid()
    if not v25 then
        return CurrentCamera1.CFrame, CurrentCamera1.Focus
    end

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then
        return CurrentCamera1.CFrame, CurrentCamera1.Focus
    end

    local v26 = nil
    if CommonUtils then
        if a4 then
            local v27 = a5.X - a4.X
            v26 = Vector3.new(v27, 0, a5.Z - a4.Z).Magnitude
        else
            v26 = 0
        end
    end

    a0.characterOrientation = HumanoidRootPart:FindFirstChild("CharacterAlignOrientation")
    if not a0.characterOrientation then
        local RootAttachment = HumanoidRootPart:FindFirstChild("RootAttachment")
        if not RootAttachment then
            return
        end

        a0.characterOrientation = Instance.new("AlignOrientation")
        a0.characterOrientation.Name = "CharacterAlignOrientation"
        a0.characterOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
        a0.characterOrientation.Attachment0 = RootAttachment
        a0.characterOrientation.RigidityEnabled = true
        a0.characterOrientation.Parent = HumanoidRootPart
    end

    if a0.characterOrientation.Enabled == false then
        a0.characterOrientation.Enabled = true
    end

    if a0.needsReset then
        a0.needsReset = false
        if v5 then
            a0:updateImmersionAutoRotate()
        else
            a0.savedAutoRotate = v25.AutoRotate
            v25.AutoRotate = false
        end

        if CommonUtils then
            VRService:RecenterUserHeadCFrame()
            a0.lastTeleportRecenter = tick()
        end

        a0:StartFadeFromBlack()
        a2 = v24
    else
        if v25.Sit then
            a2 = v24
        else
            HumanoidRootPart = a0.controlModule:GetEstimatedVRTorsoFrame()
            a0.characterOrientation.CFrame = CurrentCamera1.CFrame * HumanoidRootPart
            if 0 < a0.controlModule.inputMoveVector.Magnitude then
                a0.motionDetTime = 0.1
            end

            if 0 < a0.controlModule.inputMoveVector.Magnitude or 0 < a0.motionDetTime then
                a0.motionDetTime = a0.motionDetTime - a1
                HumanoidRootPart = VRService:GetUserCFrame(Enum.UserCFrame.Head)
                HumanoidRootPart = HumanoidRootPart.Rotation + HumanoidRootPart.Position * CurrentCamera1.HeadScale
                local HumanoidRootPart1 = Character.HumanoidRootPart
                local v28 = CurrentCamera1.CFrame * HumanoidRootPart
                local v29 = v28 * CFrame.new(0, -0.7 * HumanoidRootPart1.Size.Y / 2, 0)
                local LookVector = HumanoidRootPart1.CFrame.LookVector
                local v30 = a5 - (v29 - Vector3.new(LookVector.X, 0, LookVector.Z).Unit * HumanoidRootPart1.Size.Y * 0.125).Position
                LookVector = v30 + CurrentCamera1.CFrame.Position
                LookVector = Vector3.new(LookVector.X, a5.Y, LookVector.Z)
                a2 = CurrentCamera1.CFrame.Rotation + LookVector
                -- jump to 423 (out of range)
            end

            if CommonUtils then
                local v32 = tick()
                if v3.shouldRecenter(a0.prevSubjStep, v26, a0.lastTeleportRecenter, v32) then
                    local v33 = VRService:GetUserCFrame(Enum.UserCFrame.Head)
                    v33 = v33.Rotation + v33.Position * CurrentCamera1.HeadScale
                    local HumanoidRootPart2 = Character.HumanoidRootPart
                    local v34 = CurrentCamera1.CFrame * v33
                    local v35 = v34 * CFrame.new(0, -0.7 * HumanoidRootPart2.Size.Y / 2, 0)
                    local LookVector1 = HumanoidRootPart2.CFrame.LookVector
                    local v36 = a5 - (v35 - Vector3.new(LookVector1.X, 0, LookVector1.Z).Unit * HumanoidRootPart2.Size.Y * 0.125).Position
                    LookVector1 = v36 + CurrentCamera1.CFrame.Position
                    LookVector1 = Vector3.new(LookVector1.X, a5.Y, LookVector1.Z)
                    a2 = CurrentCamera1.CFrame.Rotation + LookVector1
                    VRService:RecenterUserHeadCFrame()
                    a0:StartFadeFromBlack()
                    a0.lastTeleportRecenter = tick()
                    -- branch continues at 400
                end
            else
                a2 = CurrentCamera1.CFrame.Rotation + Vector3.new(CurrentCamera1.CFrame.Position.X, a5.Y, CurrentCamera1.CFrame.Position.Z)
            end

            local v37 = a0:getRotation(a1)
            local v38 = math.abs(v37)
            if 0 < v38 then
                local v39 = VRService:GetUserCFrame(Enum.UserCFrame.Head)
                v39 = v39.Rotation + v39.Position * CurrentCamera1.HeadScale
                local v40 = a2 * v39
                local v41 = CFrame.new(v40.Position)
                local v42 = -math.rad(v37 * 90)
                local v43 = v41 * CFrame.Angles(0, v42, 0)
                local v44 = v43 * v40.Rotation
                a2 = v44 * v39:Inverse()
            end
        end
    end

    if CommonUtils then
        a0.prevSubjStep = v26
    end

    return a2, a2 * CFrame.new(0, 0, -0.5)
end

v6.UpdateImmersionCamera = UpdateImmersionCamera

local function UpdateThirdPersonComfortTransform(a0, a1, a2, a3, a4, a5) --[[ Upvalues: Players (copy), VRService (copy) ]]
    local v45 = a0:GetCameraToSubjectDistance()
    if v45 < 0.5 then
        v45 = 0.5
    end

    if a4 ~= nil then
        if a0.lastCameraFocus ~= nil then
            local LocalPlayer1 = Players.LocalPlayer
            local v46 = a0.controlModule:GetMoveVector()
            local v47 = true
            if 0.01 >= (a4 - a5).magnitude then
                v47 = 0.01 < v46.magnitude
            end

            if v47 then
                a0.motionDetTime = 0.1
            end

            a0.motionDetTime = a0.motionDetTime - a1
            if 0 < a0.motionDetTime then
                v47 = true
            end

            if v47 and not a0.needsReset then
                a0.VRCameraFocusFrozen = true
                return a2, a0.lastCameraFocus
            end

            v46 = true
            if a0.lastCameraResetPosition ~= nil then
                v46 = 1 < (a5 - a0.lastCameraResetPosition).Magnitude
            end

            local v48 = a0:getRotation(a1)
            local v49 = math.abs(v48)
            if 0 < v49 then
                local v50 = a3:ToObjectSpace(a2)
                a2 = a3 * CFrame.Angles(0, -v48, 0) * v50
            end

            if not (a0.VRCameraFocusFrozen and v46) then
                if not a0.needsReset then
                    -- jump to 185
                end
            end

            VRService:RecenterUserHeadCFrame()
            a0.VRCameraFocusFrozen = false
            a0.needsReset = false
            a0.lastCameraResetPosition = a5
            a0:ResetZoom()
            a0:StartFadeFromBlack()
            v48 = a0:GetHumanoid()
            local v52 = v48.Torso and v48.Torso.CFrame.lookVector or Vector3.new(1, 0, 0)
            v48 = Vector3.new(v52.X, 0, v52.Z)
            v52 = a3.Position - v48 * v45
            v48 = Vector3.new(a3.Position.X, v52.Y, a3.Position.Z)
            a2 = CFrame.new(v52, v48)
        end
    end

    return a2, a3
end

v6.UpdateThirdPersonComfortTransform = UpdateThirdPersonComfortTransform

local function UpdateThirdPersonFollowTransform(a0, a1, a2, a3, a4, a5) --[[ Upvalues: VRService (copy), Players (copy) ]]
    local CurrentCamera2 = workspace.CurrentCamera
    local v53 = a0:GetCameraToSubjectDistance()
    local v54 = a0:GetVRFocus(a5, a1)
    if a0.needsReset then
        a0.needsReset = false
        VRService:RecenterUserHeadCFrame()
        a0:ResetZoom()
        a0:StartFadeFromBlack()
    end

    if a0.recentered then
        local v55 = a0:GetSubjectCFrame()
        if not v55 then
            return CurrentCamera2.CFrame, CurrentCamera2.Focus
        end

        local v56 = v54 * v55.Rotation
        a2 = v56 * CFrame.new(0, 0, v53)
        a0.focusOffset = v54:ToObjectSpace(a2)
        a0.recentered = false
        return a2, v54
    end

    local v57 = v54:ToWorldSpace(a0.focusOffset)
    local LocalPlayer2 = Players.LocalPlayer
    local controlModule = a0.controlModule
    local v58 = controlModule:GetMoveVector()
    if 0.01 < (a4 - a5).magnitude or 0 < v58.magnitude then
        local v59 = controlModule:GetEstimatedVRTorsoFrame()
        v59 = v59.Rotation + v59.Position * CurrentCamera2.HeadScale
        local v60 = CurrentCamera2.CFrame * v59
        v59 = v60.LookVector
        local v61 = Vector3.new(v59.X, 0, v59.Z).Unit * v53
        v59 = v54.Position - v61
        local v62 = CurrentCamera2.CFrame.Position + v59
        local v63 = CFrame.new(v62 - v60.Position)
        a2 = v57:Lerp(v63 * v57.Rotation, 0.01)
        -- jump to 152 (out of range)
    end

    a2 = v57
    local v64 = a0:getRotation(a1)
    local v65 = math.abs(v64)
    if 0 < v65 then
        controlModule = v54:ToObjectSpace(a2)
        a2 = v54 * CFrame.Angles(0, -v64, 0) * controlModule
    end

    a0.focusOffset = v54:ToObjectSpace(a2)
    return a2, a2 * CFrame.new(0, 0, -v53)
end

v6.UpdateThirdPersonFollowTransform = UpdateThirdPersonFollowTransform

local function updateImmersionAutoRotate(a0) --[[ Upvalues: VRService (copy) ]]
    local v66 = a0:GetHumanoid()
    if not v66 then
        return
    end

    if a0:IsInFirstPerson() then
        if VRService.AvatarGestures then
            if not a0.autoRotateOverridden then
                a0.savedAutoRotate = v66.AutoRotate
                a0.autoRotateOverridden = true
            end

            v66.AutoRotate = false
            return
        end
    end

    if a0.autoRotateOverridden then
        v66.AutoRotate = a0.savedAutoRotate
        a0.autoRotateOverridden = false
    end
end

v6.updateImmersionAutoRotate = updateImmersionAutoRotate

local function OnEnabledChanged(a0) --[[ Upvalues: v4 (copy), v5 (copy), VRService (copy) ]]
    v4.OnEnabledChanged(a0)
    if not v5 then
        return
    end

    if a0.enabled then
        if not a0.avatarGesturesChangedConn then
            local v67 = VRService:GetPropertyChangedSignal("AvatarGestures")
            a0.avatarGesturesChangedConn = v67:Connect(function() --[[ Upvalues: a0 (copy) ]]
                a0:updateImmersionAutoRotate()
            end)
            return
            -- branch continues at 42
        end
    end

    if a0.avatarGesturesChangedConn then
        a0.avatarGesturesChangedConn:Disconnect()
        a0.avatarGesturesChangedConn = nil
    end
end

v6.OnEnabledChanged = OnEnabledChanged

local function LeaveFirstPerson(a0) --[[ Upvalues: v4 (copy), v5 (copy) ]]
    v4.LeaveFirstPerson(a0)
    a0.needsReset = true
    if a0.VRBlur then
        a0.VRBlur.Visible = false
    end

    if a0.characterOrientation then
        a0.characterOrientation.Enabled = false
    end

    if v5 then
        a0:updateImmersionAutoRotate()
        return
    end

    local v68 = a0:GetHumanoid()
    if v68 then
        v68.AutoRotate = a0.savedAutoRotate
    end
end

v6.LeaveFirstPerson = LeaveFirstPerson
return v6
