
local VRService = game:GetService("VRService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CameraInput = script.Parent:WaitForChild("CameraInput")
local v1 = require(CameraInput)
local ZoomController = script.Parent:WaitForChild("ZoomController")
local v2 = require(ZoomController)
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
local v3 = require(FlagUtil)
local BaseCamera = script.Parent:WaitForChild("BaseCamera")
local v4 = require(BaseCamera)
CommonUtils = setmetatable({}, v4)
CommonUtils.__index = CommonUtils

local function new() --[[ Upvalues: v4 (copy), CommonUtils (copy) ]]
    local v5 = setmetatable(v4.new(), CommonUtils)
    local v6 = {0, 7}
    v5.gamepadZoomLevels = v6
    v5.headScale = 1
    v5:SetCameraToSubjectDistance(7)
    v5.VRFadeResetTimer = 0
    v5.VREdgeBlurTimer = 0
    v5.gamepadResetConnection = nil
    v5.needsReset = true
    v5.recentered = false
    v5:Reset()
    return v5
end

CommonUtils.new = new

local function Reset(a0)
    a0.stepRotateTimeout = 0
end

CommonUtils.Reset = Reset

local function GetModuleName(a0)
    return "VRBaseCamera"
end

CommonUtils.GetModuleName = GetModuleName

local function GamepadZoomPress(a0) --[[ Upvalues: v4 (copy) ]]
    v4.GamepadZoomPress(a0)
    a0:GamepadReset()
    a0:ResetZoom()
end

CommonUtils.GamepadZoomPress = GamepadZoomPress

local function GamepadReset(a0)
    a0.stepRotateTimeout = 0
    a0.needsReset = true
end

CommonUtils.GamepadReset = GamepadReset

local function ResetZoom(a0) --[[ Upvalues: v2 (copy) ]]
    v2.SetZoomParameters(a0.currentSubjectDistance, 0)
    v2.ReleaseSpring()
end

CommonUtils.ResetZoom = ResetZoom

local function OnEnabledChanged(a0) --[[ Upvalues: v4 (copy), v1 (copy), VRService (copy), Lighting (copy) ]]
    v4.OnEnabledChanged(a0)
    if a0.enabled then
        a0.gamepadResetConnection = v1.gamepadReset:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:GamepadReset()
        end)
        local v7 = VRService:GetPropertyChangedSignal("ThirdPersonFollowCamEnabled")
        a0.thirdPersonOptionChanged = v7:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:Reset()
        end)
        a0.vrRecentered = VRService.UserCFrameChanged:Connect(function(a0, a1) --[[ Upvalues: a0 (copy) ]]
            if a0 == Enum.UserCFrame.Floor then
                a0.recentered = true
            end

        end)
        return
    end

    if a0.inFirstPerson then
        a0:GamepadZoomPress()
    end

    if a0.thirdPersonOptionChanged then
        a0.thirdPersonOptionChanged:Disconnect()
        a0.thirdPersonOptionChanged = nil
    end

    if a0.vrRecentered then
        a0.vrRecentered:Disconnect()
        a0.vrRecentered = nil
    end

    if a0.cameraHeadScaleChangedConn then
        a0.cameraHeadScaleChangedConn:Disconnect()
        a0.cameraHeadScaleChangedConn = nil
    end

    if a0.gamepadResetConnection then
        a0.gamepadResetConnection:Disconnect()
        a0.gamepadResetConnection = nil
    end

    local VRFade = Lighting:FindFirstChild("VRFade")
    if VRFade then
        VRFade.Brightness = 0
    end
end

CommonUtils.OnEnabledChanged = OnEnabledChanged

local function OnCurrentCameraChanged(a0) --[[ Upvalues: v4 (copy) ]]
    v4.OnCurrentCameraChanged(a0)
    if a0.cameraHeadScaleChangedConn then
        a0.cameraHeadScaleChangedConn:Disconnect()
        a0.cameraHeadScaleChangedConn = nil
    end

    local CurrentCamera = workspace.CurrentCamera
    if CurrentCamera then
        local v8 = CurrentCamera:GetPropertyChangedSignal("HeadScale")
        a0.cameraHeadScaleChangedConn = v8:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:OnHeadScaleChanged()
        end)
        a0:OnHeadScaleChanged()
    end
end

CommonUtils.OnCurrentCameraChanged = OnCurrentCameraChanged

local function OnHeadScaleChanged(a0)
    local HeadScale = workspace.CurrentCamera.HeadScale
    local gamepadZoomLevels = a0.gamepadZoomLevels
    local v9 = nil
    local v10 = nil
    for k1, k2 in gamepadZoomLevels do
        a0.gamepadZoomLevels[k1] = k2 * HeadScale / a0.headScale
    end

    k1 = a0:GetCameraToSubjectDistance() * HeadScale
    a0:SetCameraToSubjectDistance(k1 / a0.headScale)
    a0.headScale = HeadScale
end

CommonUtils.OnHeadScaleChanged = OnHeadScaleChanged

local function GetVRFocus(a0, a1, a2)
    local v11 = a0.lastCameraFocus or a1
    local v12 = math.min(1, a0.cameraTranslationConstraints.y + a2)
    a0.cameraTranslationConstraints = Vector3.new(a0.cameraTranslationConstraints.x, v12, a0.cameraTranslationConstraints.z)
    local v13 = a0:GetCameraHeight()
    local v14 = Vector3.new(0, v13, 0)
    local v15 = Vector3.new(a1.x, v11.y, a1.z)
    local v16 = v15:Lerp(a1 + v14, a0.cameraTranslationConstraints.y)
    return CFrame.new(v16)
end

CommonUtils.GetVRFocus = GetVRFocus

local function StartFadeFromBlack(a0) --[[ Upvalues: UserGameSettings (copy), Lighting (copy) ]]
    if UserGameSettings.VignetteEnabled == false then
        return
    end

    local VRFade1 = Lighting:FindFirstChild("VRFade")
    if not VRFade1 then
        VRFade1 = Instance.new("ColorCorrectionEffect")
        VRFade1.Name = "VRFade"
        VRFade1.Parent = Lighting
    end

    VRFade1.Brightness = -1
    a0.VRFadeResetTimer = 0.1
end

CommonUtils.StartFadeFromBlack = StartFadeFromBlack

local function UpdateFadeFromBlack(a0, a1) --[[ Upvalues: Lighting (copy) ]]
    local VRFade2 = Lighting:FindFirstChild("VRFade")
    if 0 < a0.VRFadeResetTimer then
        local v17 = a0.VRFadeResetTimer - a1
        a0.VRFadeResetTimer = math.max(v17, 0)
        local VRFade3 = Lighting:FindFirstChild("VRFade")
        if VRFade3 then
            if VRFade3.Brightness < 0 then
                local v18 = VRFade3.Brightness + a1 * 10
                VRFade3.Brightness = math.min(v18, 0)
                return
                -- branch continues at 51
            end

            -- branch continues at 51
        end
    end

    if VRFade2 then
        VRFade2.Brightness = 0
    end
end

CommonUtils.UpdateFadeFromBlack = UpdateFadeFromBlack

local function StartVREdgeBlur(a0, a1, a2) --[[ Upvalues: UserGameSettings (copy), RunService (copy), VRService (copy) ]]
    if not a2 and UserGameSettings.VignetteEnabled == false then
        return
    end

    local VRBlurPart = workspace.CurrentCamera:FindFirstChild("VRBlurPart")
    if not VRBlurPart then
        VRBlurPart = Instance.new("Part")
        VRBlurPart.Name = "VRBlurPart"
        VRBlurPart.Parent = workspace.CurrentCamera
        VRBlurPart.CanTouch = false
        VRBlurPart.CanCollide = false
        VRBlurPart.CanQuery = false
        VRBlurPart.Anchored = true
        VRBlurPart.Size = Vector3.new(0.43999999761581421, 0.4699999988079071, 1)
        VRBlurPart.Transparency = 1
        VRBlurPart.CastShadow = false
        RunService.RenderStepped:Connect(function(a0) --[[ Upvalues: VRService (upvalue), VRBlurPart (ref) ]]
            local v19 = VRService:GetUserCFrame(Enum.UserCFrame.Head)
            local v20 = CFrame.new(v19.p * workspace.CurrentCamera.HeadScale)
            local v21 = workspace.CurrentCamera.CFrame * (v20 * (v19 - v19.p))
            v20 = v21 * CFrame.Angles(0, 3.1415926535897931, 0)
            VRBlurPart.CFrame = v20 + v21.LookVector * (1.05 * workspace.CurrentCamera.HeadScale)
            VRBlurPart.Size = Vector3.new(0.43999999761581421, 0.4699999988079071, 1) * workspace.CurrentCamera.HeadScale
        end)
    end

    local VRBlurScreen = a1.PlayerGui:FindFirstChild("VRBlurScreen")
    local v22 = nil
    if VRBlurScreen then
        v22 = VRBlurScreen:FindFirstChild("VRBlur")
    end

    if not v22 then
        if not VRBlurScreen then
            local v23 = Instance.new("SurfaceGui") or Instance.new("ScreenGui")
            VRBlurScreen = v23
        end

        VRBlurScreen.Name = "VRBlurScreen"
        VRBlurScreen.Parent = a1.PlayerGui
        VRBlurScreen.Adornee = VRBlurPart
        v22 = Instance.new("ImageLabel")
        v22.Name = "VRBlur"
        v22.Parent = VRBlurScreen
        v22.Image = "rbxasset://textures/ui/VR/edgeBlur.png"
        v22.AnchorPoint = Vector2.new(0.5, 0.5)
        v22.Position = UDim2.new(0.5, 0, 0.5, 0)
        local v24 = workspace.CurrentCamera.ViewportSize.X * 2.3 / 512
        local v25 = workspace.CurrentCamera.ViewportSize.Y * 2.3 / 512
        v22.Size = UDim2.fromScale(v24, v25)
        v22.BackgroundTransparency = 1
        v22.Active = true
        v22.ScaleType = Enum.ScaleType.Stretch
    end

    v22.Visible = true
    v22.ImageTransparency = 0
    a0.VREdgeBlurTimer = 0.14
end

CommonUtils.StartVREdgeBlur = StartVREdgeBlur

local function UpdateEdgeBlur(a0, a1, a2)
    local VRBlurScreen1 = a1.PlayerGui:FindFirstChild("VRBlurScreen")
    local v26 = nil
    if VRBlurScreen1 then
        v26 = VRBlurScreen1:FindFirstChild("VRBlur")
    end

    if v26 then
        if 0 < a0.VREdgeBlurTimer then
            a0.VREdgeBlurTimer = a0.VREdgeBlurTimer - a2
            VRBlurScreen1 = a1.PlayerGui:FindFirstChild("VRBlurScreen")
            if VRBlurScreen1 then
                local VRBlur = VRBlurScreen1:FindFirstChild("VRBlur")
                if VRBlur then
                    VRBlur.ImageTransparency = 1 - math.clamp(a0.VREdgeBlurTimer, 0.01, 0.14) * 7.1428571428571423
                    return
                    -- branch continues at 57
                end

                -- branch continues at 57
            end
        end

        v26.Visible = false
    end
end

CommonUtils.UpdateEdgeBlur = UpdateEdgeBlur

local function GetCameraHeight(a0)
    if not a0.inFirstPerson then
        return 0.25881904510252074 * a0.currentSubjectDistance
    end

    return 0
end

CommonUtils.GetCameraHeight = GetCameraHeight

local function GetSubjectCFrame(a0) --[[ Upvalues: v4 (copy) ]]
    local v27 = v4.GetSubjectCFrame(a0)
    local CurrentCamera1 = workspace.CurrentCamera
    local v29 = CurrentCamera1 and CurrentCamera1.CameraSubject
    if not v29 then
        return v27
    end

    if v29:IsA("Humanoid") then
        local v30 = v29:GetState()
        if v30 == Enum.HumanoidStateType.Dead and v29 == a0.lastSubject then
            v27 = a0.lastSubjectCFrame
        end
    end

    if v27 then
        a0.lastSubjectCFrame = v27
    end

    return v27
end

CommonUtils.GetSubjectCFrame = GetSubjectCFrame

local function GetSubjectPosition(a0) --[[ Upvalues: v4 (copy) ]]
    local v31 = v4.GetSubjectPosition(a0)
    local CurrentCamera2 = game.Workspace.CurrentCamera
    local v33 = CurrentCamera2 and CurrentCamera2.CameraSubject
    if not v33 then
        return nil
    end

    if v33:IsA("Humanoid") then
        local v34 = v33:GetState()
        if v34 == Enum.HumanoidStateType.Dead then
            if v33 == a0.lastSubject then
                v31 = a0.lastSubjectPosition
                -- branch continues at 62
            end

            -- branch continues at 62
        end
    else
        if v33:IsA("VehicleSeat") then
            v31 = v33.CFrame.p + v33.CFrame:vectorToWorldSpace(Vector3.new(0, 4, 0))
        end
    end

    a0.lastSubjectPosition = v31
    return v31
end

CommonUtils.GetSubjectPosition = GetSubjectPosition

local function getRotation(a0, a1) --[[ Upvalues: v1 (copy), UserGameSettings (copy) ]]
    local v35 = v1.getRotation(a1)
    local v36 = 0
    if UserGameSettings.VRSmoothRotationEnabled then
        return v35.X
    end

    local v37 = math.abs(v35.X)
    if 0.03 < v37 then
        if 0 < a0.stepRotateTimeout then
            a0.stepRotateTimeout = a0.stepRotateTimeout - a1
        end

        if a0.stepRotateTimeout <= 0 then
            v36 = 1
            if v35.X < 0 then
                v36 = -1
            end

            a0:StartFadeFromBlack()
            a0.stepRotateTimeout = 0.25
            return v36 * 0.52359877559829882
            -- branch continues at 66
        end
    end

    local v38 = math.abs(v35.X)
    if v38 < 0.02 then
        a0.stepRotateTimeout = 0
    end

    return v36
end

CommonUtils.getRotation = getRotation

local function HandleSubjectDistance(a0, a1)
    if a1 and a1.IsInFirstPerson and a1:IsInFirstPerson() then
        a0:SetCameraToSubjectDistance(0)
    end
end

CommonUtils.HandleSubjectDistance = HandleSubjectDistance
return CommonUtils
