
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local VRService = game:GetService("VRService")
local GuiService = game:GetService("GuiService")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
local v1 = require(FlagUtil)
CommonUtils = v1.getUserFlag("UserPSSinkUnknownTouchEvents")
local v2 = v1.getUserFlag("UserPSTextboxResetCameraInput")
local v3 = v1.getUserFlag("UserFixVRCameraGamepadReset")
local v4 = v1.getUserFlag("UserPlayerScriptsSupportTVRemoteKeycodes")
v1 = Players.LocalPlayer
local Value = Enum.ContextActionPriority.Medium.Value
local v5 = Vector2.new(1, 0.77) * 0.069813170079773182 * 60
local v6 = Vector2.new(1, 0.77) * 0.0087266462599716477
local v7 = Vector2.new(1, 0.77) * 0.12217304763960307
local v8 = Vector2.new(1, 0.66) * 0.017453292519943295
local BindableEvent = Instance.new("BindableEvent")
local BindableEvent1 = Instance.new("BindableEvent")
local Event = BindableEvent.Event
local Event1 = BindableEvent1.Event
UserInputService.InputBegan:Connect(function(a0, a1) --[[ Upvalues: BindableEvent (copy) ]]
    if not a1 and a0.UserInputType == Enum.UserInputType.MouseButton2 then
        BindableEvent:Fire()
    end

end)
UserInputService.InputEnded:Connect(function(a0, a1) --[[ Upvalues: BindableEvent1 (copy) ]]
    if a0.UserInputType == Enum.UserInputType.MouseButton2 then
        BindableEvent1:Fire()
    end

end)

local function thumbstickCurve(a0)
    local v9 = math.sign(a0)
    return v9 * math.clamp((math.exp((math.abs(a0) - 0.1) / 0.9 * 2) - 1) / 6.3890560989306504, 0, 1)
end

local function adjustTouchPitchSensitivity(a0)
    local CurrentCamera = workspace.CurrentCamera
    if not CurrentCamera then
        return a0
    end

    local v10 = CurrentCamera.CFrame:ToEulerAnglesYXZ()
    local v11 = a0.Y * v10
    if 0 <= v11 then
        return a0
    end

    return Vector2.new(1, (1 - (math.abs(v10) * 2 / 3.1415926535897931) ^ 0.75) * 0.75 + 0.25) * a0
end

local function isInDynamicThumbstickArea(a0) --[[ Upvalues: v1 (copy) ]]
    local v12 = v1:FindFirstChildOfClass("PlayerGui")
    local v14 = v12 and v12:FindFirstChild("TouchGui")
    local v15 = v14 and v14:FindFirstChild("TouchControlFrame")
    local v17 = v15 and v15:FindFirstChild("DynamicThumbstickFrame")
    if not v17 then
        return false
    end

    if not v14.Enabled then
        return false
    end

    v14 = v17.AbsolutePosition
    v15 = v14 + v17.AbsoluteSize
    local v18 = false
    if v14.X <= a0.X then
        v18 = false
        if v14.Y <= a0.Y then
            v18 = false
            if a0.X <= v15.X then
                v18 = a0.Y <= v15.Y
            end
        end
    end

    return v18
end

local v19 = 0

local function incPanInputCount() --[[ Upvalues: v19 (ref) ]]
    v19 = math.max(0, v19 + 1)
end

local function decPanInputCount() --[[ Upvalues: v19 (ref) ]]
    v19 = math.max(0, v19 - 1)
end

local function resetPanInputCount() --[[ Upvalues: v19 (ref) ]]
    v19 = 0
end

local v20 = {ButtonLeft = 0, ButtonRight = 0, Thumbstick2 = Vector2.new()}
local v21 = {Left = 0, Right = 0, I = 0, O = 0}
local v22 = {Wheel = 0, Pinch = 0, Movement = Vector2.new(), Pan = Vector2.new()}
local v23 = {Pinch = 0, Move = Vector2.new()}
local BindableEvent2 = Instance.new("BindableEvent")
local v24 = {gamepadZoomPress = BindableEvent2.Event}
local v25
if v3 then
    v25 = Instance.new("BindableEvent")
    v24.gamepadReset = v25.Event
else
    local v27 = VRService.VREnabled and Instance.new("BindableEvent") or nil
    v25 = v27
    if VRService.VREnabled then
        v24.gamepadReset = v25.Event
    end
end

local function getRotationActivated() --[[ Upvalues: v4 (copy), v19 (ref), v20 (copy) ]]
    if v4 then
        local v28 = true
        if 0 >= v19 then
            v28 = true
            if 0 >= v20.Thumbstick2.Magnitude then
                v28 = v20.ButtonRight - v20.ButtonLeft ~= 0
            end
        end

        return v28
    end

    local v29 = true
    if 0 >= v19 then
        v29 = 0 < v20.Thumbstick2.Magnitude
    end

    return v29
end

v24.getRotationActivated = getRotationActivated

local function getRotation(a0, a1) --[[ Upvalues: UserGameSettings (copy), v21 (copy), v4 (copy), v20 (copy), v22 (copy), adjustTouchPitchSensitivity (copy), v23 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy) ]]
    local v30 = UserGameSettings:GetCameraYInvertValue()
    local v31 = Vector2.new(1, v30)
    local v32 = v21.Right - v21.Left
    local v33 = Vector2.new(v32, 0) * a0
    local v34
    if v4 then
        local v35 = v20.ButtonRight - v20.ButtonLeft
        local v36 = v20.Thumbstick2 + Vector2.new(v35, 0)
        v34 = v36 * UserGameSettings.GamepadCameraSensitivity * a0
    else
        v34 = v20.Thumbstick2 * UserGameSettings.GamepadCameraSensitivity * a0
    end

    local Movement = v22.Movement
    local Pan = v22.Pan
    local v37 = adjustTouchPitchSensitivity(v23.Move)
    if a1 then
        v33 = Vector2.new()
    end

    local v38 = v33 * 2.0943951023931953 + v34 * v5
    local v39 = v38 + Movement * v6
    local v40 = v39 + Pan * v7
    return (v40 + v37 * v8) * v31
end

v24.getRotation = getRotation

local function getZoomDelta() --[[ Upvalues: v21 (copy), v22 (copy), v23 (copy) ]]
    local v41 = v21.O - v21.I
    local v42 = -v22.Wheel
    local v43 = v42 + v22.Pinch
    local v44 = v41 * 0.1 + v43 * 1
    return v44 + -v23.Pinch * 0.04
end

v24.getZoomDelta = getZoomDelta

local function thumbstick(a0, a1, a2) --[[ Upvalues: v20 (copy), thumbstickCurve (ref) ]]
    local Position = a2.Position
    local v45 = thumbstickCurve(Position.X)
    v20[a2.KeyCode.Name] = Vector2.new(v45, -thumbstickCurve(Position.Y))
    return Enum.ContextActionResult.Pass
end

local function directionalButtons(a0, a1, a2) --[[ Upvalues: v20 (copy), thumbstickCurve (ref) ]]
    if a1 == Enum.UserInputState.Cancel then
        v20[a2.KeyCode.Name] = 0
    else
        v20[a2.KeyCode.Name] = thumbstickCurve(a2.Position.Z)
    end

    return Enum.ContextActionResult.Pass
end

local function mouseMovement(a0) --[[ Upvalues: v22 (copy) ]]
    local Delta = a0.Delta
    v22.Movement = Vector2.new(Delta.X, Delta.Y)
end

local function mouseWheel(a0, a1, a2) --[[ Upvalues: v22 (copy) ]]
    v22.Wheel = a2.Position.Z
    return Enum.ContextActionResult.Pass
end

local function keypress(a0, a1, a2) --[[ Upvalues: v21 (copy) ]]
    local v46
    if a1 == Enum.UserInputState.Begin then
        v46 = 1
    else
        v46 = 0
    end

    v21[a2.KeyCode.Name] = v46
end

local function gamepadZoomPress(a0, a1, a2) --[[ Upvalues: BindableEvent2 (copy) ]]
    if a1 == Enum.UserInputState.Begin then
        BindableEvent2:Fire()
    end
end

local function gamepadReset(a0, a1, a2) --[[ Upvalues: v25 (ref) ]]
    if a1 == Enum.UserInputState.Begin then
        v25:Fire()
    end
end

local function resetInputDevices() --[[ Upvalues: v20 (copy), v21 (copy), v22 (copy), v23 (copy), v19 (ref) ]]
    local v47 = v21
    local v48 = {v20, v47, v22, v23}
    for k1, k2 in pairs(v48) do
        for k3, k4 in pairs(k2) do
            if type(k4) == "boolean" then
                k2[k3] = false
            else
                k2[k3] = k2[k3] * 0
            end
        end
    end

    v19 = 0
end

local v57 = {}
local v58 = nil
local v59 = nil

local function touchBegan(a0, a1) --[[ Upvalues: v58 (ref), isInDynamicThumbstickArea (copy), v19 (ref), v57 (ref) ]]
    assert(a0.UserInputType == Enum.UserInputType.Touch)
    assert(a0.UserInputState == Enum.UserInputState.Begin)
    if v58 == nil and isInDynamicThumbstickArea(a0.Position) and not a1 then
        v58 = a0
        return
    end

    if not a1 then
        v19 = math.max(0, v19 + 1)
    end

    v57[a0] = a1
end

local function touchEnded(a0, a1) --[[ Upvalues: v58 (ref), v57 (ref), v59 (ref), v19 (ref) ]]
    assert(a0.UserInputType == Enum.UserInputType.Touch)
    assert(a0.UserInputState == Enum.UserInputState.End)
    if a0 == v58 then
        v58 = nil
    end

    if v57[a0] == false then
        v59 = nil
        v19 = math.max(0, v19 - 1)
    end

    v57[a0] = nil
end

local function touchChanged(a0, a1) --[[ Upvalues: v58 (ref), v57 (ref), CommonUtils (copy), v23 (copy), v59 (ref) ]]
    assert(a0.UserInputType == Enum.UserInputType.Touch)
    assert(a0.UserInputState == Enum.UserInputState.Change)
    if a0 == v58 then
        return
    end

    if v57[a0] == nil then
        if CommonUtils then
            v57[a0] = true
        else
            v57[a0] = a1
        end
    end

    local v60 = {}
    for k5, k6 in pairs(v57) do
        if not k6 then
            table.insert(v60, k5)
        end
    end

    if #v60 == 1 and v57[a0] == false then
        local Delta1 = a0.Delta
        local v64 = v23
        v64.Move = v64.Move + Vector2.new(Delta1.X, Delta1.Y)
    end

    if #v60 == 2 then
        local Magnitude = (v60[1].Position - v60[2].Position).Magnitude
        if v59 then
            local v65 = v23
            v65.Pinch = v65.Pinch + (Magnitude - v59)
        end

        v59 = Magnitude
        return
    end

    v59 = nil
end

local function resetTouchState() --[[ Upvalues: v57 (ref), v58 (ref), v59 (ref), v19 (ref) ]]
    v57 = {}
    v58 = nil
    v59 = nil
    v19 = 0
end

local function pointerAction(a0, a1, a2, a3) --[[ Upvalues: v22 (copy) ]]
    if not a3 then
        v22.Wheel = a0
        v22.Pan = a1
        v22.Pinch = -a2
    end
end

local function inputBegan(a0, a1) --[[ Upvalues: touchBegan (ref), v19 (ref) ]]
    if a0.UserInputType == Enum.UserInputType.Touch then
        touchBegan(a0, a1)
        return
    end

    if a0.UserInputType == Enum.UserInputType.MouseButton2 and not a1 then
        v19 = math.max(0, v19 + 1)
    end
end

local function inputChanged(a0, a1) --[[ Upvalues: touchChanged (ref), v22 (copy) ]]
    if a0.UserInputType == Enum.UserInputType.Touch then
        touchChanged(a0, a1)
        return
    end

    if a0.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta2 = a0.Delta
        v22.Movement = Vector2.new(Delta2.X, Delta2.Y)
    end
end

local function inputEnded(a0, a1) --[[ Upvalues: touchEnded (ref), v19 (ref) ]]
    if a0.UserInputType == Enum.UserInputType.Touch then
        touchEnded(a0, a1)
        return
    end

    if a0.UserInputType == Enum.UserInputType.MouseButton2 then
        v19 = math.max(0, v19 - 1)
    end
end

local v66 = false
local t1 = {}

local function setInputEnabled(a0) --[[ Upvalues: v66 (ref), resetInputDevices (copy), resetTouchState (ref), ContextActionService (copy), thumbstick (copy), Value (copy), v4 (copy), directionalButtons (copy), keypress (copy), VRService (copy), gamepadReset (copy), gamepadZoomPress (copy), t1 (ref), UserInputService (copy), inputBegan (copy), inputChanged (copy), inputEnded (copy), pointerAction (copy), GuiService (copy) ]]
    if v66 == a0 then
        return
    end

    v66 = a0
    resetInputDevices()
    resetTouchState()
    if v66 then
        ContextActionService:BindActionAtPriority("RbxCameraThumbstick", thumbstick, false, Value, Enum.KeyCode.Thumbstick2)
        if v4 then
            ContextActionService:BindActionAtPriority("RbxCameraDirectionalButtons", directionalButtons, false, Value, Enum.KeyCode.ButtonLeft, Enum.KeyCode.ButtonRight)
        end

        ContextActionService:BindActionAtPriority("RbxCameraKeypress", keypress, false, Value, Enum.KeyCode.Left, Enum.KeyCode.Right, Enum.KeyCode.I, Enum.KeyCode.O)
        if VRService.VREnabled then
            ContextActionService:BindAction("RbxCameraGamepadReset", gamepadReset, false, Enum.KeyCode.ButtonL3)
        end

        ContextActionService:BindAction("RbxCameraGamepadZoom", gamepadZoomPress, false, Enum.KeyCode.ButtonR3)
        local v68 = UserInputService.InputBegan:Connect(inputBegan)
        table.insert(t1, v68)
        local v69 = UserInputService.InputChanged:Connect(inputChanged)
        table.insert(t1, v69)
        local v70 = UserInputService.InputEnded:Connect(inputEnded)
        table.insert(t1, v70)
        local v71 = UserInputService.PointerAction:Connect(pointerAction)
        table.insert(t1, v71)
        local v72 = GuiService.MenuOpened:connect(resetTouchState)
        table.insert(t1, v72)
        return
    end

    ContextActionService:UnbindAction("RbxCameraThumbstick")
    if v4 then
        ContextActionService:UnbindAction("RbxCameraDirectionalButtons")
    end

    ContextActionService:UnbindAction("RbxCameraMouseMove")
    ContextActionService:UnbindAction("RbxCameraMouseWheel")
    ContextActionService:UnbindAction("RbxCameraKeypress")
    ContextActionService:UnbindAction("RbxCameraGamepadZoom")
    if VRService.VREnabled then
        ContextActionService:UnbindAction("RbxCameraGamepadReset")
    end

    for k7, k8 in pairs(t1) do
        k8:Disconnect()
    end

    t1 = {}
end

v24.setInputEnabled = setInputEnabled

local function getInputEnabled() --[[ Upvalues: v66 (ref) ]]
    return v66
end

v24.getInputEnabled = getInputEnabled

local function resetInputForFrameEnd() --[[ Upvalues: v22 (copy), v23 (copy) ]]
    v22.Movement = Vector2.new()
    v23.Move = Vector2.new()
    v23.Pinch = 0
    v22.Wheel = 0
    v22.Pan = Vector2.new()
    v22.Pinch = 0
end

v24.resetInputForFrameEnd = resetInputForFrameEnd
UserInputService.WindowFocused:Connect(resetInputDevices)
UserInputService.WindowFocusReleased:Connect(resetInputDevices)
if v2 then
    UserInputService.TextBoxFocusReleased:Connect(resetInputDevices)
end

t1 = false
v19 = false

local function getHoldPan() --[[ Upvalues: t1 (ref) ]]
    return t1
end

v24.getHoldPan = getHoldPan

local function getTogglePan() --[[ Upvalues: v19 (ref) ]]
    return v19
end

v24.getTogglePan = getTogglePan

local function getPanning() --[[ Upvalues: v19 (ref), t1 (ref) ]]
    local v78 = v19 or t1
    return v78
end

v24.getPanning = getPanning

local function setTogglePan(a0) --[[ Upvalues: v19 (ref) ]]
    v19 = a0
end

v24.setTogglePan = setTogglePan
setTogglePan = false
resetPanInputCount = nil
v20 = nil
local v79 = 0

local function enableCameraToggleInput() --[[ Upvalues: setTogglePan (ref), t1 (ref), v19 (ref), resetPanInputCount (ref), v20 (ref), Event (ref), v79 (ref), Event1 (ref), UserInputService (copy) ]]
    if setTogglePan then
        return
    end

    setTogglePan = true
    t1 = false
    v19 = false
    if resetPanInputCount then
        resetPanInputCount:Disconnect()
    end

    if v20 then
        v20:Disconnect()
    end

    resetPanInputCount = Event:Connect(function() --[[ Upvalues: t1 (upvalue), v79 (upvalue) ]]
        t1 = true
        v79 = tick()
    end)
    v20 = Event1:Connect(function() --[[ Upvalues: t1 (upvalue), v79 (upvalue), v19 (upvalue), UserInputService (upvalue) ]]
        t1 = false
        local v80 = tick() - v79
        if v80 < 0.3 then
            if v19 or UserInputService:GetMouseDelta().Magnitude < 2 then
                v19 = not v19
            end
        end

    end)
end

v24.enableCameraToggleInput = enableCameraToggleInput

local function disableCameraToggleInput() --[[ Upvalues: setTogglePan (ref), resetPanInputCount (ref), v20 (ref) ]]
    if not setTogglePan then
        return
    end

    setTogglePan = false
    if resetPanInputCount then
        resetPanInputCount:Disconnect()
        resetPanInputCount = nil
    end

    if v20 then
        v20:Disconnect()
        v20 = nil
    end
end

v24.disableCameraToggleInput = disableCameraToggleInput
return v24
