
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
CommonUtils = require(FlagUtil).getUserFlag("UserPlayerScriptsSupportTVRemoteKeycodes")
local None = Enum.UserInputType.None
local BaseCharacterController = script.Parent:WaitForChild("BaseCharacterController")
local v1 = require(BaseCharacterController)
local v2 = setmetatable({}, v1)
v2.__index = v2

local function new(a0) --[[ Upvalues: v1 (copy), v2 (copy), None (copy) ]]
    local v3 = setmetatable(v1.new(), v2)
    v3.CONTROL_ACTION_PRIORITY = a0
    v3.forwardValue = 0
    v3.backwardValue = 0
    v3.leftValue = 0
    v3.rightValue = 0
    v3.thumbstickVector = Vector3.new(0, 0, 0)
    v3.activeGamepad = None
    v3.gamepadConnectedConn = nil
    v3.gamepadDisconnectedConn = nil
    return v3
end

v2.new = new

local function Enable(a0, a1) --[[ Upvalues: None (copy) ]]
    if a1 == a0.enabled then
        return true
    end

    a0.forwardValue = 0
    a0.backwardValue = 0
    a0.leftValue = 0
    a0.rightValue = 0
    a0.thumbstickVector = Vector3.new(0, 0, 0)
    a0.moveVector = Vector3.new(0, 0, 0)
    a0.isJumping = false
    if a1 then
        a0.activeGamepad = a0:GetHighestPriorityGamepad()
        if a0.activeGamepad ~= None then
            a0:BindContextActions()
            a0:ConnectGamepadConnectionListeners()
            -- jump to 62 (out of range)
        end

        return false
    else
        a0:UnbindContextActions()
        a0:DisconnectGamepadConnectionListeners()
        a0.activeGamepad = None
    end

    a0.enabled = a1
    return true
end

v2.Enable = Enable

local function GetHighestPriorityGamepad(a0) --[[ Upvalues: UserInputService (copy), None (copy) ]]
    local v4 = UserInputService:GetConnectedGamepads()
    local v5 = None
    for k1, k2 in pairs(v4) do
        if k2.Value < v5.Value then
            v5 = k2
        end
    end

    return v5
end

v2.GetHighestPriorityGamepad = GetHighestPriorityGamepad

local function UpdateMovement(a0)
    a0.moveVector = a0.thumbstickVector + Vector3.new(0, 0, a0.forwardValue + a0.backwardValue)
end

v2.UpdateMovement = UpdateMovement

local function BindContextActions(a0) --[[ Upvalues: None (copy), CommonUtils (copy), ContextActionService (copy) ]]
    if a0.activeGamepad == None then
        return false
    end

    local function v9(a0, a1, a2) --[[ Upvalues: a0 (copy) ]]
        a0.isJumping = a1 == Enum.UserInputState.Begin
        return Enum.ContextActionResult.Sink
    end

    local function v10(a0, a1, a2) --[[ Upvalues: CommonUtils (upvalue), a0 (copy) ]]
        if a1 == Enum.UserInputState.Cancel then
            if CommonUtils then
                a0.thumbstickVector = Vector3.new(0, 0, 0)
                a0:UpdateMovement()
            else
                a0.moveVector = Vector3.new(0, 0, 0)
            end

            return Enum.ContextActionResult.Sink
        end

        if a0.activeGamepad ~= a2.UserInputType then
            return Enum.ContextActionResult.Pass
        end

        if a2.KeyCode ~= Enum.KeyCode.Thumbstick1 then
            return
        end

        if CommonUtils then
            if 0.2 < a2.Position.magnitude then
                a0.thumbstickVector = Vector3.new(a2.Position.X, 0, -a2.Position.Y)
            else
                a0.thumbstickVector = Vector3.new(0, 0, 0)
            end

            a0:UpdateMovement()
        else
            if 0.2 < a2.Position.magnitude then
                a0.moveVector = Vector3.new(a2.Position.X, 0, -a2.Position.Y)
            else
                a0.moveVector = Vector3.new(0, 0, 0)
            end
        end

        return Enum.ContextActionResult.Sink
    end

    local function fn1(a0, a1, a2) --[[ Upvalues: a0 (copy) ]]
        if a1 == Enum.UserInputState.Cancel then
            a0.forwardValue = 0
            a0.backwardValue = 0
            a0:UpdateMovement()
            return Enum.ContextActionResult.Sink
        end

        local v11 = 0
        if 0.2 < a2.Position.magnitude then
            v11 = a2.Position.Z
        end

        if a2.KeyCode == Enum.KeyCode.ButtonUp then
            a0.forwardValue = -v11
        else
            if a2.KeyCode == Enum.KeyCode.ButtonDown then
                a0.backwardValue = v11
            end
        end

        a0:UpdateMovement()
        return Enum.ContextActionResult.Sink
    end

    ContextActionService:BindActivate(a0.activeGamepad, Enum.KeyCode.ButtonR2)
    if CommonUtils then
        ContextActionService:BindActionAtPriority("jumpAction", v9, false, a0.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonA, Enum.KeyCode.ButtonCenter)
        ContextActionService:BindActionAtPriority("moveDirectionalButton", fn1, false, a0.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonUp, Enum.KeyCode.ButtonDown)
    else
        ContextActionService:BindActionAtPriority("jumpAction", v9, false, a0.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonA)
    end

    ContextActionService:BindActionAtPriority("moveThumbstick", v10, false, a0.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Thumbstick1)
    return true
end

v2.BindContextActions = BindContextActions

local function UnbindContextActions(a0) --[[ Upvalues: None (copy), ContextActionService (copy), CommonUtils (copy) ]]
    if a0.activeGamepad ~= None then
        ContextActionService:UnbindActivate(a0.activeGamepad, Enum.KeyCode.ButtonR2)
    end

    if CommonUtils then
        ContextActionService:UnbindAction("moveDirectionalButton")
    end

    ContextActionService:UnbindAction("moveThumbstick")
    ContextActionService:UnbindAction("jumpAction")
end

v2.UnbindContextActions = UnbindContextActions

local function OnNewGamepadConnected(a0) --[[ Upvalues: None (copy) ]]
    local v12 = a0:GetHighestPriorityGamepad()
    if v12 == a0.activeGamepad then
        return
    end

    if v12 == None then
        warn("Gamepad:OnNewGamepadConnected found no connected gamepads")
        a0:UnbindContextActions()
        return
    end

    if a0.activeGamepad ~= None then
        a0:UnbindContextActions()
    end

    a0.activeGamepad = v12
    a0:BindContextActions()
end

v2.OnNewGamepadConnected = OnNewGamepadConnected

local function OnCurrentGamepadDisconnected(a0) --[[ Upvalues: None (copy), ContextActionService (copy) ]]
    if a0.activeGamepad ~= None then
        ContextActionService:UnbindActivate(a0.activeGamepad, Enum.KeyCode.ButtonR2)
    end

    local v13 = a0:GetHighestPriorityGamepad()
    if a0.activeGamepad ~= None and v13 == a0.activeGamepad then
        warn("Gamepad:OnCurrentGamepadDisconnected found the supposedly disconnected gamepad in connectedGamepads.")
        a0:UnbindContextActions()
        a0.activeGamepad = None
        return
    end

    if v13 == None then
        a0:UnbindContextActions()
        a0.activeGamepad = None
        return
    end

    a0.activeGamepad = v13
    ContextActionService:BindActivate(a0.activeGamepad, Enum.KeyCode.ButtonR2)
end

v2.OnCurrentGamepadDisconnected = OnCurrentGamepadDisconnected

local function ConnectGamepadConnectionListeners(a0) --[[ Upvalues: UserInputService (copy) ]]
    a0.gamepadConnectedConn = UserInputService.GamepadConnected:Connect(function(a0) --[[ Upvalues: a0 (copy) ]]
        a0:OnNewGamepadConnected()
    end)
    a0.gamepadDisconnectedConn = UserInputService.GamepadDisconnected:Connect(function(a0) --[[ Upvalues: a0 (copy) ]]
        if a0.activeGamepad == a0 then
            a0:OnCurrentGamepadDisconnected()
        end

    end)
end

v2.ConnectGamepadConnectionListeners = ConnectGamepadConnectionListeners

local function DisconnectGamepadConnectionListeners(a0)
    if a0.gamepadConnectedConn then
        a0.gamepadConnectedConn:Disconnect()
        a0.gamepadConnectedConn = nil
    end

    if a0.gamepadDisconnectedConn then
        a0.gamepadDisconnectedConn:Disconnect()
        a0.gamepadDisconnectedConn = nil
    end
end

v2.DisconnectGamepadConnectionListeners = DisconnectGamepadConnectionListeners
return v2
