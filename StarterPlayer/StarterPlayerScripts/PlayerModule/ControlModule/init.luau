
local t1 = {}
t1.__index = t1
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local VRService = game:GetService("VRService")
local CommonUtils = script.Parent:WaitForChild("CommonUtils")
local Keyboard = script:WaitForChild("Keyboard")
local v1 = require(Keyboard)
local Gamepad = script:WaitForChild("Gamepad")
local v2 = require(Gamepad)
local DynamicThumbstick = script:WaitForChild("DynamicThumbstick")
local v3 = require(DynamicThumbstick)
local v5, v6 = pcall(function()
    local v4 = UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
    return v4
end)
local v7 = v5 and v6
local TouchThumbstick = script:WaitForChild("TouchThumbstick")
local v8 = require(TouchThumbstick)
local ClickToMoveController = script:WaitForChild("ClickToMoveController")
local v9 = require(ClickToMoveController)
local TouchJump = script:WaitForChild("TouchJump")
local v10 = require(TouchJump)
local VehicleController = script:WaitForChild("VehicleController")
local v11 = require(VehicleController)
local v13, v14 = pcall(function()
    local v12 = UserSettings():IsUserFeatureEnabled("UserPlayerScriptsSupportMicroGamepad")
    return v12
end)
local v15 = v13 and v14
local Value = Enum.ContextActionPriority.Medium.Value
v14 = {
    [Enum.TouchMovementMode.DPad] = v3,
    [Enum.DevTouchMovementMode.DPad] = v3,
    [Enum.TouchMovementMode.Thumbpad] = v3,
    [Enum.DevTouchMovementMode.Thumbpad] = v3,
    [Enum.TouchMovementMode.Thumbstick] = v8,
    [Enum.DevTouchMovementMode.Thumbstick] = v8,
    [Enum.TouchMovementMode.DynamicThumbstick] = v3,
    [Enum.DevTouchMovementMode.DynamicThumbstick] = v3,
    [Enum.TouchMovementMode.ClickToMove] = v9,
    [Enum.DevTouchMovementMode.ClickToMove] = v9,
    [Enum.TouchMovementMode.Default] = v3,
    [Enum.ComputerMovementMode.Default] = v1,
    [Enum.ComputerMovementMode.KeyboardMouse] = v1,
    [Enum.DevComputerMovementMode.KeyboardMouse] = v1,
    [Enum.DevComputerMovementMode.Scriptable] = nil,
    [Enum.ComputerMovementMode.ClickToMove] = v9,
    [Enum.DevComputerMovementMode.ClickToMove] = v9
}

local function new() --[[ Upvalues: t1 (copy), Players (copy), v11 (copy), Value (copy), RunService (copy), UserGameSettings (copy), GuiService (copy), UserInputService (copy) ]]
    local v16 = setmetatable({}, t1)
    v16.controllers = {}
    v16.activeControlModule = nil
    v16.activeController = nil
    v16.touchJumpController = nil
    v16.moveFunction = Players.LocalPlayer.Move
    v16.humanoid = nil
    v16.controlsEnabled = true
    v16.humanoidSeatedConn = nil
    v16.vehicleController = nil
    v16.touchControlFrame = nil
    v16.currentTorsoAngle = 0
    v16.inputMoveVector = Vector3.new(0, 0, 0)
    v16.vehicleController = v11.new(Value)
    Players.LocalPlayer.CharacterAdded:Connect(function(a0) --[[ Upvalues: v16 (copy) ]]
        v16:OnCharacterAdded(a0)
    end)
    Players.LocalPlayer.CharacterRemoving:Connect(function(a0) --[[ Upvalues: v16 (copy) ]]
        v16:OnCharacterRemoving(a0)
    end)
    if Players.LocalPlayer.Character then
        v16:OnCharacterAdded(Players.LocalPlayer.Character)
    end

    RunService:BindToRenderStep("ControlScriptRenderstep", Enum.RenderPriority.Input.Value, function(a0) --[[ Upvalues: v16 (copy) ]]
        v16:OnRenderStepped(a0)
    end)
    local v17 = UserGameSettings:GetPropertyChangedSignal("TouchMovementMode")
    v17:Connect(function() --[[ Upvalues: v16 (copy) ]]
        v16:UpdateMovementMode()
    end)
    local v18 = Players.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode")
    v18:Connect(function() --[[ Upvalues: v16 (copy) ]]
        v16:UpdateMovementMode()
    end)
    local v19 = UserGameSettings:GetPropertyChangedSignal("ComputerMovementMode")
    v19:Connect(function() --[[ Upvalues: v16 (copy) ]]
        v16:UpdateMovementMode()
    end)
    local v20 = Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode")
    v20:Connect(function() --[[ Upvalues: v16 (copy) ]]
        v16:UpdateMovementMode()
    end)
    v16.playerGui = nil
    v16.touchGui = nil
    v16.playerGuiAddedConn = nil
    local v21 = GuiService:GetPropertyChangedSignal("TouchControlsEnabled")
    v21:Connect(function() --[[ Upvalues: v16 (copy) ]]
        v16:UpdateMovementMode()
        v16:UpdateActiveControlModuleEnabled()
    end)
    local v22 = UserInputService:GetPropertyChangedSignal("PreferredInput")
    v22:Connect(function() --[[ Upvalues: v16 (copy) ]]
        v16:UpdateMovementMode()
    end)
    v16.playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not v16.playerGui then
        v16.playerGuiAddedConn = Players.LocalPlayer.ChildAdded:Connect(function(a0) --[[ Upvalues: v16 (copy) ]]
            if a0:IsA("PlayerGui") then
                v16.playerGui = a0
                v16.playerGuiAddedConn:Disconnect()
                v16.playerGuiAddedConn = nil
                v16:UpdateMovementMode()
            end

        end)
    end

    v16:UpdateMovementMode()
    return v16
end

t1.new = new

local function GetMoveVector(a0)
    if a0.activeController then
        local v23 = a0.activeController:GetMoveVector()
        return v23
    end

    return Vector3.new(0, 0, 0)
end

t1.GetMoveVector = GetMoveVector

local function NormalizeAngle(a0)
    a0 = (a0 + 12.566370614359172) % 6.2831853071795862
    if 3.1415926535897931 < a0 then
        a0 = a0 - 6.2831853071795862
    end

    return a0
end

local function AverageAngle(a0, a1)
    local v24 = (a1 - a0 + 12.566370614359172) % 6.2831853071795862
    if 3.1415926535897931 < v24 then
        v24 = v24 - 6.2831853071795862
    end

    local v25 = (a0 + v24 / 2 + 12.566370614359172) % 6.2831853071795862
    if 3.1415926535897931 < v25 then
        v25 = v25 - 6.2831853071795862
    end

    return v25
end

local function GetEstimatedVRTorsoFrame(a0) --[[ Upvalues: VRService (copy) ]]
    local v26 = VRService:GetUserCFrame(Enum.UserCFrame.Head)
    local v27, v28, v29 = v26:ToEulerAnglesYXZ()
    v28 = -v28
    if not (VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) and VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)) then
        a0.currentTorsoAngle = v28
        -- jump to 150 (out of range)
    end

    local v30 = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand)
    v27 = VRService:GetUserCFrame(Enum.UserCFrame.RightHand)
    local v31 = v26.Position - v30.Position
    v30 = v26.Position - v27.Position
    v27 = -math.atan2(v31.X, v31.Z)
    local v32 = (-math.atan2(v30.X, v30.Z) - v27 + 12.566370614359172) % 6.2831853071795862
    if 3.1415926535897931 < v32 then
        v32 = v32 - 6.2831853071795862
    end

    local v33 = (v27 + v32 / 2 + 12.566370614359172) % 6.2831853071795862
    if 3.1415926535897931 < v33 then
        v33 = v33 - 6.2831853071795862
    end

    local v34 = (v28 - a0.currentTorsoAngle + 12.566370614359172) % 6.2831853071795862
    if 3.1415926535897931 < v34 then
        v34 = v34 - 6.2831853071795862
    end

    local v35 = (v33 - a0.currentTorsoAngle + 12.566370614359172) % 6.2831853071795862
    if 3.1415926535897931 < v35 then
        v35 = v35 - 6.2831853071795862
    end

    v33 = false
    if -1.5707963267948966 < v35 then
        v33 = v35 < 1.5707963267948966
    end

    if not v33 then
        v35 = v34
    end

    v33 = math.min(v35, v34)
    local v36 = math.max(v35, v34)
    v34 = 0
    if 0 < v33 then
        v34 = v33
    else
        if v36 < 0 then
            v34 = v36
        end
    end

    a0.currentTorsoAngle = v34 + a0.currentTorsoAngle
    local v37 = CFrame.new(v26.Position)
    local v38 = -a0.currentTorsoAngle
    return v37 * CFrame.fromEulerAnglesYXZ(0, v38, 0)
end

t1.GetEstimatedVRTorsoFrame = GetEstimatedVRTorsoFrame

local function GetActiveController(a0)
    return a0.activeController
end

t1.GetActiveController = GetActiveController

local function UpdateActiveControlModuleEnabled(a0) --[[ Upvalues: Players (copy), UserInputService (copy), v9 (copy), v8 (copy), v3 (copy), v10 (copy), GuiService (copy) ]]

    local function fn1() --[[ Upvalues: a0 (copy), Players (upvalue) ]]
        a0.activeController:Enable(false)
        if a0.touchJumpController then
            a0.touchJumpController:Enable(false)
        end

        if a0.moveFunction then
            a0.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true)
        end
    end

    local function fn2() --[[ Upvalues: a0 (copy), UserInputService (upvalue), v9 (upvalue), v8 (upvalue), v3 (upvalue), v10 (upvalue), Players (upvalue) ]]
        if a0.touchControlFrame then
            if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
                if a0.activeControlModule ~= v9 then
                    if a0.activeControlModule ~= v8 then
                        if a0.activeControlModule ~= v3 then
                            -- jump to 65
                        end
                    end
                end

                if not a0.controllers[v10] then
                    a0.controllers[v10] = v10.new()
                end

                a0.touchJumpController = a0.controllers[v10]
                a0.touchJumpController:Enable(true, a0.touchControlFrame)
                -- branch continues at 65
            end
        else
            if a0.touchJumpController then
                a0.touchJumpController:Enable(false)
            end
        end

        if a0.activeControlModule == v9 then
            a0.activeController:Enable(true, Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice, a0.touchJumpController)
            return
        end

        if a0.touchControlFrame then
            a0.activeController:Enable(true, a0.touchControlFrame)
            return
        end

        a0.activeController:Enable(true)
    end

    if not a0.activeController then
        return
    end

    if not a0.controlsEnabled then
        a0.activeController:Enable(false)
        if a0.touchJumpController then
            a0.touchJumpController:Enable(false)
        end

        if a0.moveFunction then
            a0.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true)
        end

        return
    end

    if not GuiService.TouchControlsEnabled then
        if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
            if a0.activeControlModule == v9 or a0.activeControlModule == v8 or a0.activeControlModule == v3 then
                a0.activeController:Enable(false)
                if a0.touchJumpController then
                    a0.touchJumpController:Enable(false)
                end

                if a0.moveFunction then
                    a0.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true)
                end

                return
            end
        end
    end

    fn2()
end

t1.UpdateActiveControlModuleEnabled = UpdateActiveControlModuleEnabled

local function Enable(a0, a1)
    if a1 == nil then
        a1 = true
    end

    if a0.controlsEnabled == a1 then
        return
    end

    a0.controlsEnabled = a1
    if not a0.activeController then
        return
    end

    a0:UpdateActiveControlModuleEnabled()
end

t1.Enable = Enable

local function Disable(a0)
    a0:Enable(false)
end

t1.Disable = Disable

local function SelectComputerMovementModule(a0) --[[ Upvalues: UserInputService (copy), Players (copy), v15 (ref), v2 (copy), v1 (copy), UserGameSettings (copy), v9 (copy), v14 (copy) ]]
    if not UserInputService.KeyboardEnabled and not UserInputService.GamepadEnabled then
        return nil, false
    end

    local v39 = nil
    local DevComputerMovementMode = Players.LocalPlayer.DevComputerMovementMode
    if DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice then
        local v40 = false
        if v15 then
            pcall(function() --[[ Upvalues: v40 (ref), UserInputService (upvalue) ]]
                v40 = UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad
            end)
        end

        if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad or v40 then
            v39 = v2
            -- jump to 49 (out of range)
        end

        if UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse then
            v39 = v1
        end

        if UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove and v39 == v1 then
            v39 = v9
        end
    else
        v39 = v14[DevComputerMovementMode]
        if not v39 and DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable then
            warn("No character control module is associated with DevComputerMovementMode ", DevComputerMovementMode)
        end
    end

    if v39 then
        return v39, true
    end

    if DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable then
        return nil, true
    end

    return nil, false
end

t1.SelectComputerMovementModule = SelectComputerMovementModule

local function SelectTouchModule(a0) --[[ Upvalues: Players (copy), v14 (copy), UserGameSettings (copy) ]]
    local DevTouchMovementMode = Players.LocalPlayer.DevTouchMovementMode
    local v41
    if DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice then
        v41 = v14[UserGameSettings.TouchMovementMode]
    else
        if DevTouchMovementMode == Enum.DevTouchMovementMode.Scriptable then
            return nil, true
        end

        v41 = v14[DevTouchMovementMode]
    end

    return v41, true
end

t1.SelectTouchModule = SelectTouchModule

local function getGamepadRightThumbstickPosition() --[[ Upvalues: UserInputService (copy) ]]
    local v42 = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)
    for k1, k2 in pairs(v42) do
        if k2.KeyCode == Enum.KeyCode.Thumbstick2 then
            return k2.Position
        end
    end

    return Vector3.new(0, 0, 0)
end

local function calculateRawMoveVector(a0, a1, a2) --[[ Upvalues: Workspace (copy), VRService (copy), getGamepadRightThumbstickPosition (copy) ]]
    local CurrentCamera = Workspace.CurrentCamera
    if not CurrentCamera then
        return a2
    end

    local CFrame = CurrentCamera.CFrame
    if VRService.VREnabled then
        if a1.RootPart then
            local v46 = VRService:GetUserCFrame(Enum.UserCFrame.Head)
            v46 = a0:GetEstimatedVRTorsoFrame()
            if (CurrentCamera.Focus.Position - CFrame.Position).Magnitude < 3 then
                CFrame = CFrame * v46
            else
                CFrame = CurrentCamera.CFrame * (v46.Rotation + v46.Position * CurrentCamera.HeadScale)
            end
        end
    end

    local v47 = a1:GetState()
    if v47 == Enum.HumanoidStateType.Swimming then
        if VRService.VREnabled then
            a2 = Vector3.new(a2.X, 0, a2.Z)
            if a2.Magnitude < 0.01 then
                return Vector3.new(0, 0, 0)
            end

            CurrentCamera = -getGamepadRightThumbstickPosition().Y * 1.3962634015954636
            local v48 = -a2.X
            local v49 = math.atan2(v48, -a2.Z)
            local v50, v51, v52 = CFrame:ToEulerAnglesYXZ()
            return CFrame.fromEulerAnglesYXZ(CurrentCamera, v49 + v51, 0).LookVector
        end

        local v53 = CFrame:VectorToWorldSpace(a2)
        return v53
    end

    local v54, v55, v56, v57, v58, v59, v60, v61, v62, v63, v64, v65 = CFrame:GetComponents()
    local v66, v67
    if v62 < 1 and -1 < v62 then
        v66 = v65
        v67 = v59
    else
        v66 = v57
        v67 = -v58 * math.sign(v62)
    end

    local v68 = math.sqrt(v66 * v66 + v67 * v67)
    local v69 = v66 * a2.X
    local v70 = (v69 + v67 * a2.Z) / v68
    local v71 = v66 * a2.Z
    return Vector3.new(v70, 0, (v71 - v67 * a2.X) / v68)
end

t1.calculateRawMoveVector = calculateRawMoveVector

local function OnRenderStepped(a0, a1) --[[ Upvalues: v2 (copy), VRService (copy), Players (copy) ]]
    if a0.activeController then
        if a0.activeController.enabled then
            if a0.humanoid then
                local v72 = a0.activeController:GetMoveVector()
                local v73 = a0.activeController:IsMoveVectorCameraRelative()
                local v74 = a0:GetClickToMoveController()
                if a0.activeController == v74 then
                    v74:OnRenderStepped(a1)
                else
                    if 0 < v72.magnitude then
                        v74:CleanupPath()
                    else
                        v74:OnRenderStepped(a1)
                        v72 = v74:GetMoveVector()
                        v73 = v74:IsMoveVectorCameraRelative()
                    end
                end

                if a0.vehicleController then
                    local v75, v76 = a0.vehicleController:Update(v72, v73, a0.activeControlModule == v2)
                    v72 = v75
                end

                if v73 then
                    v72 = a0:calculateRawMoveVector(a0.humanoid, v72)
                end

                a0.inputMoveVector = v72
                if VRService.VREnabled then
                    v72 = a0:updateVRMoveVector(v72)
                end

                a0.moveFunction(Players.LocalPlayer, v72, false)
                local humanoid = a0.humanoid
                local v77 = a0.activeController:GetIsJumping()
                if not v77 then
                    local v79 = a0.touchJumpController and a0.touchJumpController:GetIsJumping()
                end

                humanoid.Jump = v77
            end
        end
    end
end

t1.OnRenderStepped = OnRenderStepped

local function updateVRMoveVector(a0, a1) --[[ Upvalues: VRService (copy) ]]
    local CurrentCamera1 = workspace.CurrentCamera
    local v80 = CurrentCamera1.Focus.Position - CurrentCamera1.CFrame.Position
    local v81 = false
    if v80.Magnitude < 5 then
        v81 = true
    end

    if a1.Magnitude == 0 and v81 and VRService.AvatarGestures and a0.humanoid and not a0.humanoid.Sit then
        v80 = VRService:GetUserCFrame(Enum.UserCFrame.Head)
        v80 = v80.Rotation + v80.Position * CurrentCamera1.HeadScale
        local v82 = CurrentCamera1.CFrame * v80
        local v83 = (v82 * CFrame.new(0, -0.7 * a0.humanoid.RootPart.Size.Y / 2, 0)).Position - a0.humanoid.RootPart.CFrame.Position
        return Vector3.new(v83.x, 0, v83.z)
    end

    return a1
end

t1.updateVRMoveVector = updateVRMoveVector

local function OnHumanoidSeated(a0, a1, a2) --[[ Upvalues: Value (copy) ]]
    if a1 then
        if a2 then
            if a2:IsA("VehicleSeat") then
                if not a0.vehicleController then
                    a0.vehicleController = a0.vehicleController.new(Value)
                end

                a0.vehicleController:Enable(true, a2)
                return
                -- branch continues at 40
            end

            -- branch continues at 40
        end
    end

    if a0.vehicleController then
        a0.vehicleController:Enable(false, a2)
    end
end

t1.OnHumanoidSeated = OnHumanoidSeated

local function OnCharacterAdded(a0, a1)
    a0.humanoid = a1:FindFirstChildOfClass("Humanoid")
    while not a0.humanoid do
        a1.ChildAdded:wait()
        a0.humanoid = a1:FindFirstChildOfClass("Humanoid")
    end

    if a0.humanoidSeatedConn then
        a0.humanoidSeatedConn:Disconnect()
        a0.humanoidSeatedConn = nil
    end

    a0.humanoidSeatedConn = a0.humanoid.Seated:Connect(function(a0, a1) --[[ Upvalues: a0 (copy) ]]
        a0:OnHumanoidSeated(a0, a1)
    end)
    a0:UpdateMovementMode()
end

t1.OnCharacterAdded = OnCharacterAdded

local function OnCharacterRemoving(a0, a1)
    a0.humanoid = nil
    a0:UpdateMovementMode()
end

t1.OnCharacterRemoving = OnCharacterRemoving

local function UpdateTouchGuiVisibility(a0) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    local humanoid1 = a0.humanoid
    if humanoid1 then
        local TouchControlsEnabled = GuiService.TouchControlsEnabled
        if TouchControlsEnabled then
            TouchControlsEnabled = UserInputService.PreferredInput == Enum.PreferredInput.Touch
        end
    end

    if humanoid1 and not a0.touchGui then
        a0:CreateTouchGuiContainer()
    end

    if a0.touchGui then
        a0.touchGui.Enabled = not not humanoid1
    end
end

t1.UpdateTouchGuiVisibility = UpdateTouchGuiVisibility

local function SwitchToController(a0, a1) --[[ Upvalues: Value (copy) ]]
    if not a1 then
        if a0.activeController then
            a0.activeController:Enable(false)
        end

        a0.activeController = nil
        a0.activeControlModule = nil
        return
    end

    if not a0.controllers[a1] then
        a0.controllers[a1] = a1.new(Value)
    end

    if a0.activeController ~= a0.controllers[a1] then
        if a0.activeController then
            a0.activeController:Enable(false)
        end

        a0.activeController = a0.controllers[a1]
        a0.activeControlModule = a1
        a0:UpdateActiveControlModuleEnabled()
    end
end

t1.SwitchToController = SwitchToController

local function UpdateMovementMode(a0) --[[ Upvalues: UserInputService (copy) ]]
    a0:UpdateTouchGuiVisibility()
    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        local v84, v85 = a0:SelectTouchModule()
        if v85 then
            if a0.touchControlFrame then
                a0:SwitchToController(v84)
                return
                -- branch continues at 34
            end

            -- branch continues at 34
        end
    end

    a0:SwitchToController(a0:SelectComputerMovementModule())
end

t1.UpdateMovementMode = UpdateMovementMode

local function CreateTouchGuiContainer(a0) --[[ Upvalues: v7 (ref) ]]
    if not a0.playerGui then
        return
    end

    if a0.touchGui then
        a0.touchGui:Destroy()
    end

    a0.touchGui = Instance.new("ScreenGui")
    a0.touchGui.Name = "TouchGui"
    a0.touchGui.ResetOnSpawn = false
    a0.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if v7 then
        a0.touchGui.ClipToDeviceSafeArea = false
    end

    a0.touchControlFrame = Instance.new("Frame")
    a0.touchControlFrame.Name = "TouchControlFrame"
    a0.touchControlFrame.Size = UDim2.new(1, 0, 1, 0)
    a0.touchControlFrame.BackgroundTransparency = 1
    a0.touchControlFrame.Parent = a0.touchGui
    a0.touchGui.Parent = a0.playerGui
end

t1.CreateTouchGuiContainer = CreateTouchGuiContainer

local function GetClickToMoveController(a0) --[[ Upvalues: v9 (copy), Value (copy) ]]
    if not a0.controllers[v9] then
        a0.controllers[v9] = v9.new(Value)
    end

    return a0.controllers[v9]
end

t1.GetClickToMoveController = GetClickToMoveController
local v86 = t1.new()
return v86
