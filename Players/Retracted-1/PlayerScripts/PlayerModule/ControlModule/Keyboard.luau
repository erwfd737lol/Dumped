
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local v1 = Vector3.new()
local BaseCharacterController = script.Parent:WaitForChild("BaseCharacterController")
local v2 = require(BaseCharacterController)
local v3 = setmetatable({}, v2)
v3.__index = v3

local function new(a0) --[[ Upvalues: v2 (copy), v3 (copy) ]]
    local v4 = setmetatable(v2.new(), v3)
    v4.CONTROL_ACTION_PRIORITY = a0
    v4.forwardValue = 0
    v4.backwardValue = 0
    v4.leftValue = 0
    v4.rightValue = 0
    v4.jumpEnabled = true
    return v4
end

v3.new = new

local function Enable(a0, a1) --[[ Upvalues: v1 (copy) ]]
    if a1 == a0.enabled then
        return true
    end

    a0.forwardValue = 0
    a0.backwardValue = 0
    a0.leftValue = 0
    a0.rightValue = 0
    a0.moveVector = v1
    a0.jumpRequested = false
    a0:UpdateJump()
    if a1 then
        a0:BindContextActions()
        a0:ConnectFocusEventListeners()
    else
        a0._connectionUtil:disconnectAll()
    end

    a0.enabled = a1
    return true
end

v3.Enable = Enable

local function UpdateMovement(a0, a1) --[[ Upvalues: v1 (copy) ]]
    if a1 == Enum.UserInputState.Cancel then
        a0.moveVector = v1
        return
    end

    local v5 = a0.leftValue + a0.rightValue
    a0.moveVector = Vector3.new(v5, 0, a0.forwardValue + a0.backwardValue)
end

v3.UpdateMovement = UpdateMovement

local function UpdateJump(a0)
    a0.isJumping = a0.jumpRequested
end

v3.UpdateJump = UpdateJump

local function BindContextActions(a0) --[[ Upvalues: ContextActionService (copy) ]]
    ContextActionService:BindActionAtPriority("moveForwardAction", function(a0, a1, a2) --[[ Upvalues: a0 (copy) ]]
        local v6
        if a1 == Enum.UserInputState.Begin then
            v6 = -1
        else
            v6 = 0
        end

        a0.forwardValue = v6
        a0:UpdateMovement(a1)
        return Enum.ContextActionResult.Pass
    end, false, a0.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterForward)
    ContextActionService:BindActionAtPriority("moveBackwardAction", function(a0, a1, a2) --[[ Upvalues: a0 (copy) ]]
        local v7
        if a1 == Enum.UserInputState.Begin then
            v7 = 1
        else
            v7 = 0
        end

        a0.backwardValue = v7
        a0:UpdateMovement(a1)
        return Enum.ContextActionResult.Pass
    end, false, a0.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterBackward)
    ContextActionService:BindActionAtPriority("moveLeftAction", function(a0, a1, a2) --[[ Upvalues: a0 (copy) ]]
        local v8
        if a1 == Enum.UserInputState.Begin then
            v8 = -1
        else
            v8 = 0
        end

        a0.leftValue = v8
        a0:UpdateMovement(a1)
        return Enum.ContextActionResult.Pass
    end, false, a0.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterLeft)
    ContextActionService:BindActionAtPriority("moveRightAction", function(a0, a1, a2) --[[ Upvalues: a0 (copy) ]]
        local v9
        if a1 == Enum.UserInputState.Begin then
            v9 = 1
        else
            v9 = 0
        end

        a0.rightValue = v9
        a0:UpdateMovement(a1)
        return Enum.ContextActionResult.Pass
    end, false, a0.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterRight)
    ContextActionService:BindActionAtPriority("jumpAction", function(a0, a1, a2) --[[ Upvalues: a0 (copy) ]]
        local jumpEnabled = a0.jumpEnabled
        if jumpEnabled then
            jumpEnabled = a1 == Enum.UserInputState.Begin
        end

        a0.jumpRequested = jumpEnabled
        a0:UpdateJump()
        return Enum.ContextActionResult.Pass
    end, false, a0.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterJump)
    a0._connectionUtil:trackBoundFunction("moveForwardAction", function() --[[ Upvalues: ContextActionService (upvalue) ]]
        ContextActionService:UnbindAction("moveForwardAction")
    end)
    a0._connectionUtil:trackBoundFunction("moveBackwardAction", function() --[[ Upvalues: ContextActionService (upvalue) ]]
        ContextActionService:UnbindAction("moveBackwardAction")
    end)
    a0._connectionUtil:trackBoundFunction("moveLeftAction", function() --[[ Upvalues: ContextActionService (upvalue) ]]
        ContextActionService:UnbindAction("moveLeftAction")
    end)
    a0._connectionUtil:trackBoundFunction("moveRightAction", function() --[[ Upvalues: ContextActionService (upvalue) ]]
        ContextActionService:UnbindAction("moveRightAction")
    end)
    a0._connectionUtil:trackBoundFunction("jumpAction", function() --[[ Upvalues: ContextActionService (upvalue) ]]
        ContextActionService:UnbindAction("jumpAction")
    end)
end

v3.BindContextActions = BindContextActions

local function ConnectFocusEventListeners(a0) --[[ Upvalues: v1 (copy), UserInputService (copy) ]]

    local function onFocusReleased() --[[ Upvalues: a0 (copy), v1 (upvalue) ]]
        a0.moveVector = v1
        a0.forwardValue = 0
        a0.backwardValue = 0
        a0.leftValue = 0
        a0.rightValue = 0
        a0.jumpRequested = false
        a0:UpdateJump()
    end

    local function onTextFocusGained(a0) --[[ Upvalues: a0 (copy) ]]
        a0.jumpRequested = false
        a0:UpdateJump()
    end

    local v10 = UserInputService.TextBoxFocusReleased:Connect(onFocusReleased)
    a0._connectionUtil:trackConnection("textBoxFocusReleased", v10)
    local v11 = UserInputService.TextBoxFocused:Connect(onTextFocusGained)
    a0._connectionUtil:trackConnection("textBoxFocused", v11)
    local v12 = UserInputService.WindowFocused:Connect(onFocusReleased)
    a0._connectionUtil:trackConnection("windowFocusReleased", v12)
end

v3.ConnectFocusEventListeners = ConnectFocusEventListeners
return v3
