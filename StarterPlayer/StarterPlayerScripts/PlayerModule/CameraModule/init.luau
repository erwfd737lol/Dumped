
local t1 = {}
t1.__index = t1
local t2 = {
    "CameraMinZoomDistance",
    "CameraMaxZoomDistance",
    "CameraMode",
    "DevCameraOcclusionMode",
    "DevComputerCameraMode",
    "DevTouchCameraMode",
    "DevComputerMovementMode",
    "DevTouchMovementMode",
    "DevEnableMouseLock"
}
local v1 = {
    "ComputerCameraMovementMode",
    "ComputerMovementMode",
    "ControlMode",
    "GamepadCameraSensitivity",
    "MouseSensitivity",
    "RotationType",
    "TouchCameraMovementMode",
    "TouchMovementMode"
}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CommonUtils = script.Parent:WaitForChild("CommonUtils")
local ConnectionUtil = CommonUtils:WaitForChild("ConnectionUtil")
local v2 = require(ConnectionUtil)
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
local v3 = require(FlagUtil)
local CameraUtils = script:WaitForChild("CameraUtils")
CommonUtils = require(CameraUtils)
local CameraInput = script:WaitForChild("CameraInput")
local v4 = require(CameraInput)
local ClassicCamera = script:WaitForChild("ClassicCamera")
local v5 = require(ClassicCamera)
local OrbitalCamera = script:WaitForChild("OrbitalCamera")
local v6 = require(OrbitalCamera)
local LegacyCamera = script:WaitForChild("LegacyCamera")
local v7 = require(LegacyCamera)
local VehicleCamera = script:WaitForChild("VehicleCamera")
local v8 = require(VehicleCamera)
local VRCamera = script:WaitForChild("VRCamera")
local v9 = require(VRCamera)
local VRVehicleCamera = script:WaitForChild("VRVehicleCamera")
local v10 = require(VRVehicleCamera)
local Invisicam = script:WaitForChild("Invisicam")
local v11 = require(Invisicam)
local Poppercam = script:WaitForChild("Poppercam")
local v12 = require(Poppercam)
local TransparencyController = script:WaitForChild("TransparencyController")
local v13 = require(TransparencyController)
local MouseLockController = script:WaitForChild("MouseLockController")
local v14 = require(MouseLockController)
if not Players.LocalPlayer then
    return {}
end

assert(Players.LocalPlayer, "Strict typing check")
local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Default)
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Follow)
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Classic)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Default)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Follow)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Classic)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.CameraToggle)
local v15 = v3.getUserFlag("UserPlayerConnectionMemoryLeak")
local v16 = v3.getUserFlag("UserPSFixCameraControllerReset")

local function new() --[[ Upvalues: v13 (copy), v15 (copy), v2 (copy), t1 (copy), Players (copy), v14 (copy), RunService (copy), t2 (copy), v1 (copy), UserGameSettings (copy), UserInputService (copy) ]]
    local v17 = {activeTransparencyController = v13.new()}
    local v18
    if v15 then
        local v19 = v2.new()
    else
        v18 = nil
    end

    v17.connectionUtil = v18
    local v20 = setmetatable(v17, t1)
    v20.activeCameraController = nil
    v20.activeOcclusionModule = nil
    v20.activeMouseLockController = nil
    v20.currentComputerCameraMovementMode = nil
    v20.cameraSubjectChangedConn = nil
    v20.cameraTypeChangedConn = nil
    local v21 = Players:GetPlayers()
    for k1, k2 in pairs(v21) do
        v20:OnPlayerAdded(k2)
    end

    Players.PlayerAdded:Connect(function(a0) --[[ Upvalues: v20 (copy) ]]
        v20:OnPlayerAdded(a0)
    end)
    if v15 then
        Players.PlayerRemoving:Connect(function(a0) --[[ Upvalues: v20 (copy) ]]
            v20:OnPlayerRemoving(a0)
        end)
    end

    v20.activeTransparencyController:Enable(true)
    v20.activeMouseLockController = v14.new()
    assert(v20.activeMouseLockController, "Strict typing check")
    local v25 = v20.activeMouseLockController:GetBindableToggleEvent()
    if v25 then
        v25:Connect(function() --[[ Upvalues: v20 (copy) ]]
            v20:OnMouseLockToggled()
        end)
    end

    v20:ActivateCameraController()
    v20:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode)
    v20:OnCurrentCameraChanged()

    local function v26(a0) --[[ Upvalues: v20 (copy) ]]
        v20:Update(a0)
    end

    RunService:BindToRenderStep("cameraRenderUpdate", Enum.RenderPriority.Camera.Value, v26)
    for k3, k4 in pairs(t2) do
        local v30 = Players.LocalPlayer:GetPropertyChangedSignal(k4)
        v30:Connect(function() --[[ Upvalues: v20 (copy), k4 (copy) ]]
            v20:OnLocalPlayerCameraPropertyChanged(k4)
        end)
    end

    for k5, k6 in pairs(v1) do
        local v34 = UserGameSettings:GetPropertyChangedSignal(k6)
        v34:Connect(function() --[[ Upvalues: v20 (copy), k6 (copy) ]]
            v20:OnUserGameSettingsPropertyChanged(k6)
        end)
    end

    local v35 = game.Workspace:GetPropertyChangedSignal("CurrentCamera")
    v35:Connect(function() --[[ Upvalues: v20 (copy) ]]
        v20:OnCurrentCameraChanged()
    end)
    local v36 = UserInputService:GetPropertyChangedSignal("PreferredInput")
    v36:Connect(function() --[[ Upvalues: v20 (copy) ]]
        v20:OnPreferredInputChanged()
    end)
    return v20
end

t1.new = new

local function GetCameraMovementModeFromSettings(a0) --[[ Upvalues: Players (copy), CommonUtils (copy), UserInputService (copy), UserGameSettings (copy) ]]
    if Players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        local v37 = CommonUtils.ConvertCameraModeEnumToStandard(Enum.ComputerCameraMovementMode.Classic)
        return v37
    end

    local v38, v39
    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        v38 = CommonUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevTouchCameraMode)
        v39 = CommonUtils.ConvertCameraModeEnumToStandard(UserGameSettings.TouchCameraMovementMode)
    else
        v38 = CommonUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevComputerCameraMode)
        v39 = CommonUtils.ConvertCameraModeEnumToStandard(UserGameSettings.ComputerCameraMovementMode)
    end

    if v38 == Enum.DevComputerCameraMovementMode.UserChoice then
        return v39
    end

    return v38
end

t1.GetCameraMovementModeFromSettings = GetCameraMovementModeFromSettings
local t3 = {}

local function ActivateOcclusionModule(a0, a1) --[[ Upvalues: v12 (copy), v11 (copy), t3 (copy), Players (copy) ]]
    local v40
    if a1 == Enum.DevCameraOcclusionMode.Zoom then
        v40 = v12
    else
        if a1 == Enum.DevCameraOcclusionMode.Invisicam then
            v40 = v11
        else
            warn("CameraScript ActivateOcclusionModule called with unsupported mode")
            return
        end
    end

    a0.occlusionMode = a1
    if a0.activeOcclusionModule then
        if a0.activeOcclusionModule:GetOcclusionMode() == a1 then
            if not a0.activeOcclusionModule:GetEnabled() then
                a0.activeOcclusionModule:Enable(true)
            end

            return
        end
    end

    local activeOcclusionModule = a0.activeOcclusionModule
    a0.activeOcclusionModule = t3[v40]
    if not a0.activeOcclusionModule then
        a0.activeOcclusionModule = v40.new()
        if a0.activeOcclusionModule then
            t3[v40] = a0.activeOcclusionModule
        end
    end

    if a0.activeOcclusionModule then
        if a0.activeOcclusionModule:GetOcclusionMode() ~= a1 then
            local v41 = a0.activeOcclusionModule:GetOcclusionMode()
            warn("CameraScript ActivateOcclusionModule mismatch: ", v41, "~=", a1)
        end

        if activeOcclusionModule then
            if activeOcclusionModule ~= a0.activeOcclusionModule then
                activeOcclusionModule:Enable(false)
            else
                warn("CameraScript ActivateOcclusionModule failure to detect already running correct module")
            end
        end

        if a1 == Enum.DevCameraOcclusionMode.Invisicam then
            if Players.LocalPlayer.Character then
                a0.activeOcclusionModule:CharacterAdded(Players.LocalPlayer.Character, Players.LocalPlayer)
                -- branch continues at 172
            end
        else
            local v42 = Players:GetPlayers()
            for k7, k8 in pairs(v42) do
                if k8 and k8.Character then
                    a0.activeOcclusionModule:CharacterAdded(k8.Character, k8)
                end
            end

            a0.activeOcclusionModule:OnCameraSubjectChanged(game.Workspace.CurrentCamera.CameraSubject)
        end

        a0.activeOcclusionModule:Enable(true)
    end
end

t1.ActivateOcclusionModule = ActivateOcclusionModule

local function ShouldUseVehicleCamera(a0)
    local CurrentCamera = workspace.CurrentCamera
    if not CurrentCamera then
        return false
    end

    local CameraType = CurrentCamera.CameraType
    local CameraSubject = CurrentCamera.CameraSubject
    CurrentCamera = true
    if CameraType ~= Enum.CameraType.Custom then
        CurrentCamera = CameraType == Enum.CameraType.Follow
    end

    local v47 = CameraSubject and CameraSubject:IsA("VehicleSeat") or false
    local v51 = v47 and CurrentCamera and a0.occlusionMode ~= Enum.DevCameraOcclusionMode.Invisicam
    return v51
end

t1.ShouldUseVehicleCamera = ShouldUseVehicleCamera
local t4 = {}

local function ActivateCameraController(a0) --[[ Upvalues: v7 (copy), VRService (copy), v9 (copy), v5 (copy), v6 (copy), v10 (copy), v8 (copy), t4 (copy), v16 (copy) ]]
    local CameraType1 = workspace.CurrentCamera.CameraType
    local v52 = a0:GetCameraMovementModeFromSettings()
    local v53 = nil
    if CameraType1 == Enum.CameraType.Scriptable then
        if a0.activeCameraController then
            a0.activeCameraController:Enable(false)
            a0.activeCameraController = nil
        end

        return
    end

    if CameraType1 == Enum.CameraType.Custom then
        v52 = a0:GetCameraMovementModeFromSettings()
    else
        if CameraType1 == Enum.CameraType.Track then
            v52 = Enum.ComputerCameraMovementMode.Classic
        else
            if CameraType1 == Enum.CameraType.Follow then
                v52 = Enum.ComputerCameraMovementMode.Follow
            else
                if CameraType1 == Enum.CameraType.Orbital then
                    v52 = Enum.ComputerCameraMovementMode.Orbital
                else
                    if CameraType1 == Enum.CameraType.Attach or CameraType1 == Enum.CameraType.Watch or CameraType1 == Enum.CameraType.Fixed then
                        v53 = v7
                        -- jump to 80 (out of range)
                    end

                    warn("CameraScript encountered an unhandled Camera.CameraType value: ", CameraType1)
                end
            end
        end
    end

    if not v53 then
        if VRService.VREnabled then
            v53 = v9
        else
            if v52 == Enum.ComputerCameraMovementMode.Classic or v52 == Enum.ComputerCameraMovementMode.Follow or v52 == Enum.ComputerCameraMovementMode.Default or v52 == Enum.ComputerCameraMovementMode.CameraToggle then
                v53 = v5
                -- jump to 117 (out of range)
            end

            if v52 == Enum.ComputerCameraMovementMode.Orbital then
                v53 = v6
            else
                warn("ActivateCameraController did not select a module.")
                return
            end
        end
    end

    if a0:ShouldUseVehicleCamera() then
        if VRService.VREnabled then
            v53 = v10
        else
            v53 = v8
        end
    end

    local v54
    if not t4[v53] then
        v54 = v53.new()
        t4[v53] = v54
    else
        v54 = t4[v53]
        if v16 then
            if v54.Reset then
                if a0.activeCameraController ~= v54 then
                    v54:Reset()
                    -- branch continues at 164
                end

                -- branch continues at 164
            end
        else
            if v54.Reset then
                v54:Reset()
            end
        end
    end

    if a0.activeCameraController then
        if a0.activeCameraController ~= v54 then
            if v54.HandleSubjectDistance then
                v54:HandleSubjectDistance(a0.activeCameraController)
            end

            a0.activeCameraController:Enable(false)
            a0.activeCameraController = v54
            a0.activeCameraController:Enable(true)
            -- jump to 231 (out of range)
        end

        if not a0.activeCameraController:GetEnabled() then
            a0.activeCameraController:Enable(true)
            -- branch continues at 231
        end
    else
        if v54 ~= nil then
            a0.activeCameraController = v54
            assert(a0.activeCameraController, "Strict typing check")
            a0.activeCameraController:Enable(true)
        end
    end

    if a0.activeCameraController then
        a0.activeCameraController:SetCameraMovementMode(v52)
        a0.activeCameraController:SetCameraType(CameraType1)
    end
end

t1.ActivateCameraController = ActivateCameraController

local function OnCameraSubjectChanged(a0)
    local CurrentCamera1 = workspace.CurrentCamera
    local v55
    if CurrentCamera1 then
        v55 = CurrentCamera1.CameraSubject
    else
        v55 = nil
    end

    if a0.activeTransparencyController then
        a0.activeTransparencyController:SetSubject(v55)
    end

    if a0.activeOcclusionModule then
        a0.activeOcclusionModule:OnCameraSubjectChanged(v55)
    end

    a0:ActivateCameraController()
end

t1.OnCameraSubjectChanged = OnCameraSubjectChanged

local function OnCameraTypeChanged(a0, a1) --[[ Upvalues: UserInputService (copy), CommonUtils (copy) ]]
    if a1 == Enum.CameraType.Scriptable and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
        CommonUtils.restoreMouseBehavior()
    end

    a0:ActivateCameraController()
end

t1.OnCameraTypeChanged = OnCameraTypeChanged

local function OnCurrentCameraChanged(a0)
    local CurrentCamera2 = game.Workspace.CurrentCamera
    if not CurrentCamera2 then
        return
    end

    if a0.cameraSubjectChangedConn then
        a0.cameraSubjectChangedConn:Disconnect()
    end

    if a0.cameraTypeChangedConn then
        a0.cameraTypeChangedConn:Disconnect()
    end

    local v56 = CurrentCamera2:GetPropertyChangedSignal("CameraSubject")
    a0.cameraSubjectChangedConn = v56:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:OnCameraSubjectChanged()
    end)
    local v57 = CurrentCamera2:GetPropertyChangedSignal("CameraType")
    a0.cameraTypeChangedConn = v57:Connect(function() --[[ Upvalues: a0 (copy), CurrentCamera2 (copy) ]]
        a0:OnCameraTypeChanged(CurrentCamera2.CameraType)
    end)
    a0:OnCameraSubjectChanged()
    a0:OnCameraTypeChanged(CurrentCamera2.CameraType)
end

t1.OnCurrentCameraChanged = OnCurrentCameraChanged

local function OnLocalPlayerCameraPropertyChanged(a0, a1) --[[ Upvalues: Players (copy) ]]
    if a1 == "CameraMode" then
        if Players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
            if not a0.activeCameraController or a0.activeCameraController:GetModuleName() ~= "ClassicCamera" then
                a0:ActivateCameraController()
            end

            if a0.activeCameraController then
                a0.activeCameraController:UpdateForDistancePropertyChange()
                return
                -- branch continues at 104
            end
        end

        if Players.LocalPlayer.CameraMode == Enum.CameraMode.Classic then
            a0:ActivateCameraController()
            return
        end

        warn("Unhandled value for property player.CameraMode: ", Players.LocalPlayer.CameraMode)
        return
    end

    if a1 == "DevComputerCameraMode" or a1 == "DevTouchCameraMode" then
        a0:ActivateCameraController()
        return
    end

    if a1 == "DevCameraOcclusionMode" then
        a0:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode)
        return
    end

    if a1 == "CameraMinZoomDistance" or a1 == "CameraMaxZoomDistance" then
        if a0.activeCameraController then
            a0.activeCameraController:UpdateForDistancePropertyChange()
            return
            -- branch continues at 104
        end
    end

    if a1 == "DevTouchMovementMode" then
        return
    end

    if a1 == "DevComputerMovementMode" then
        return
    end

    if a1 == "DevEnableMouseLock" then
    end
end

t1.OnLocalPlayerCameraPropertyChanged = OnLocalPlayerCameraPropertyChanged

local function OnUserGameSettingsPropertyChanged(a0, a1)
    if a1 == "ComputerCameraMovementMode" or a1 == "TouchCameraMovementMode" then
        a0:ActivateCameraController()
    end
end

t1.OnUserGameSettingsPropertyChanged = OnUserGameSettingsPropertyChanged

local function OnPreferredInputChanged(a0)
    a0:ActivateCameraController()
end

t1.OnPreferredInputChanged = OnPreferredInputChanged

local function Update(a0, a1) --[[ Upvalues: v4 (copy) ]]
    if a0.activeCameraController then
        a0.activeCameraController:UpdateMouseBehavior()
        local v58, v59 = a0.activeCameraController:Update(a1)
        if a0.activeOcclusionModule and not a0.activeCameraController.skipOcclusion then
            local v60, v61 = a0.activeOcclusionModule:Update(a1, v58, v59)
            v58 = v60
            v59 = v61
        end

        local CurrentCamera3 = game.Workspace.CurrentCamera
        CurrentCamera3.CFrame = v58
        CurrentCamera3.Focus = v59
        if a0.activeTransparencyController then
            a0.activeTransparencyController:Update(a1)
        end

        if v4.getInputEnabled() then
            v4.resetInputForFrameEnd()
        end
    end
end

t1.Update = Update

local function OnCharacterAdded(a0, a1, a2)
    if a0.activeOcclusionModule then
        a0.activeOcclusionModule:CharacterAdded(a1, a2)
    end
end

t1.OnCharacterAdded = OnCharacterAdded

local function OnCharacterRemoving(a0, a1, a2)
    if a0.activeOcclusionModule then
        a0.activeOcclusionModule:CharacterRemoving(a1, a2)
    end
end

t1.OnCharacterRemoving = OnCharacterRemoving

local function OnPlayerAdded(a0, a1) --[[ Upvalues: v15 (copy) ]]
    if v15 then
        if a0.connectionUtil then
            local v62 = ("%*CharacterAdded"):format(a1.UserId)
            local v63 = a1.CharacterAdded:Connect(function(a0) --[[ Upvalues: a0 (copy), a1 (copy) ]]
                a0:OnCharacterAdded(a0, a1)
            end)
            a0.connectionUtil:trackConnection(v62, v63)
            local v64 = ("%*CharacterRemoving"):format(a1.UserId)
            local v65 = a1.CharacterRemoving:Connect(function(a0) --[[ Upvalues: a0 (copy), a1 (copy) ]]
                a0:OnCharacterRemoving(a0, a1)
            end)
            a0.connectionUtil:trackConnection(v64, v65)
            return
            -- branch continues at 62
        end
    end

    a1.CharacterAdded:Connect(function(a0) --[[ Upvalues: a0 (copy), a1 (copy) ]]
        a0:OnCharacterAdded(a0, a1)
    end)
    a1.CharacterRemoving:Connect(function(a0) --[[ Upvalues: a0 (copy), a1 (copy) ]]
        a0:OnCharacterRemoving(a0, a1)
    end)
end

t1.OnPlayerAdded = OnPlayerAdded

local function OnPlayerRemoving(a0, a1)
    if a0.connectionUtil then
        a0.connectionUtil:disconnect(("%*CharacterAdded"):format(a1.UserId))
        a0.connectionUtil:disconnect(("%*CharacterRemoving"):format(a1.UserId))
    end
end

t1.OnPlayerRemoving = OnPlayerRemoving

local function OnMouseLockToggled(a0)
    if a0.activeMouseLockController then
        local v68 = a0.activeMouseLockController:GetIsMouseLocked()
        local v69 = a0.activeMouseLockController:GetMouseLockOffset()
        if a0.activeCameraController then
            a0.activeCameraController:SetIsMouseLocked(v68)
            a0.activeCameraController:SetMouseLockOffset(v69)
        end
    end
end

t1.OnMouseLockToggled = OnMouseLockToggled
t1.new()
return {}
