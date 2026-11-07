
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local v1 = game:GetService("Players").LocalPlayer:GetMouse()

local function getGamepadPointerPosition() --[[ Upvalues: v1 (copy) ]]
    local v2 = Vector2.new(v1.X, v1.Y)
    return v2
end

local v3 = {}
v3.__index = v3

local function new(a0) --[[ Upvalues: v3 (copy) ]]
    local v4 = setmetatable({}, v3)
    v4.CallbackFunc = a0
    v4.Connected = false
    return v4
end

v3.new = new

local function GetPosition(a0)
    return a0.ActivePosition
end

v3.GetPosition = GetPosition

local function _finish(a0)
    if not a0.Connected then
        return
    end

    if a0.DisconnectCallback then
        a0.DisconnectCallback()
    end

    a0:Disconnect()
end

v3._finish = _finish

local function Connect(a0, a1, ...) --[[ Upvalues: UserInputService (copy), v1 (copy), RunService (copy) ]]
    if a0.Connected then
        a0:Disconnect()
    end

    a0.Connected = true
    local v5
    if typeof(a1) == "InputObject" then
        local v6 = {...}
        v5 = v6
        a0.EndUserInputType = a1.UserInputType
        a0.EndKeyCode = a1.KeyCode
        local v7 = UserInputService:GetLastInputType()
        local v8 = false
        if a1.UserInputType == Enum.UserInputType.MouseButton1 then
            v8 = string.match(v7.Name, "^Gamepad") ~= nil
        end

        local v9 = true
        if a1.KeyCode ~= Enum.KeyCode.ButtonA then
            v9 = v8
        end

        a0.GamepadDrag = v9
        a0.ActiveInput = a1.UserInputType == Enum.UserInputType.Touch and a1 or nil
        if a1.KeyCode == Enum.KeyCode.ButtonA then
            a0.ActivePosition = Vector2.new(v1.X, v1.Y)
            -- jump to 136 (out of range)
        end

        a0.ActivePosition = Vector2.new(a1.Position.X, a1.Position.Y)
    else
        local v11 = {a1, ...}
        v5 = v11
        if a1 == nil then
            v5 = {}
        end

        a0.ActiveInput = nil
        a0.ActivePosition = nil
        a0.EndUserInputType = Enum.UserInputType.MouseButton1
        a0.EndKeyCode = Enum.KeyCode.Unknown
    end

    local v12 = table.unpack(v5)
    a0.CallbackFunc(v12)
    if a0.ActiveInput then
        a0._activeInputChanged = a0.ActiveInput.Changed:Connect(function() --[[ Upvalues: a0 (copy), v5 (ref) ]]
            local ActiveInput = a0.ActiveInput
            if not ActiveInput then
                return
            end

            local v13 = Vector2.new(ActiveInput.Position.X, ActiveInput.Position.Y)
            if v13 ~= a0.ActivePosition then
                a0.ActivePosition = v13
                local v14 = table.unpack(v5)
                a0.CallbackFunc(v14)
            end

            if ActiveInput.UserInputState == Enum.UserInputState.End or ActiveInput.UserInputState == Enum.UserInputState.Cancel then
                a0:_finish()
            end

        end)
    else
        if typeof(a1) == "InputObject" then
            a0._initialInputChanged = a1.Changed:Connect(function() --[[ Upvalues: a1 (copy), a0 (copy) ]]
                if a1.UserInputState == Enum.UserInputState.End or a1.UserInputState == Enum.UserInputState.Cancel then
                    a0:_finish()
                end

            end)
        end
    end

    a0._mouseMovement = UserInputService.InputChanged:Connect(function(a0) --[[ Upvalues: a0 (copy), v1 (upvalue), v5 (ref) ]]
        if a0.ActiveInput then
            if a0 ~= a0.ActiveInput then
                return
                -- branch continues at 36
            end
        else
            if a0.GamepadDrag then
                if a0.UserInputType ~= Enum.UserInputType.MouseMovement then
                    return
                    -- branch continues at 36
                end
            else
                if a0.UserInputType ~= Enum.UserInputType.MouseMovement and a0.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end
            end
        end

        local v15 = a0
        local v17
        if not (a0.GamepadDrag and Vector2.new(v1.X, v1.Y)) then
            local v18 = Vector2.new(a0.Position.X, a0.Position.Y)
        end

        v15.ActivePosition = v17
        local v19 = table.unpack(v5)
        a0.CallbackFunc(v19)
    end)
    if a0.GamepadDrag then
        a0._gamepadMovement = RunService.RenderStepped:Connect(function() --[[ Upvalues: v1 (upvalue), a0 (copy), v5 (ref) ]]
            local v20 = Vector2.new(v1.X, v1.Y)
            if v20 == a0.ActivePosition then
                return
            end

            a0.ActivePosition = v20
            local v21 = table.unpack(v5)
            a0.CallbackFunc(v21)
        end)
    end

    a0._mouseUp = UserInputService.InputEnded:Connect(function(a0) --[[ Upvalues: a0 (copy), UserInputService (upvalue) ]]
        local v22
        if a0.ActiveInput then
            local v23 = true
            if a0 ~= a0.ActiveInput then
                v23 = false
                if a0.EndUserInputType == Enum.UserInputType.Touch then
                    v23 = a0.UserInputType == Enum.UserInputType.Touch
                end
            end

            v22 = v23
        else
            if a0.EndKeyCode then
                if a0.EndKeyCode ~= Enum.KeyCode.Unknown then
                    v22 = a0.KeyCode == a0.EndKeyCode
                    -- branch continues at 50
                end
            else
                v22 = a0.UserInputType == a0.EndUserInputType
                if not v22 then
                    if UserInputService.TouchEnabled then
                        local v25
                        if not (a0.EndUserInputType == Enum.UserInputType.MouseButton1 and a0.UserInputType == Enum.UserInputType.Touch) then
                            v25 = a0.EndUserInputType == Enum.UserInputType.Touch and a0.UserInputType == Enum.UserInputType.MouseButton1
                        end

                        v22 = v25
                    end
                end
            end
        end

        if not v22 then
            if a0.GamepadDrag then
                local v27
                if not (a0.EndUserInputType == Enum.UserInputType.MouseButton1 and a0.KeyCode == Enum.KeyCode.ButtonA) then
                    v27 = a0.EndKeyCode == Enum.KeyCode.ButtonA and a0.UserInputType == Enum.UserInputType.MouseButton1
                end

                v22 = v27
            end
        end

        if not v22 then
            return
        end

        a0:_finish()
    end)
end

v3.Connect = Connect

local function Disconnect(a0)
    a0.Connected = false
    if a0._activeInputChanged then
        a0._activeInputChanged:Disconnect()
        a0._activeInputChanged = nil
    end

    if a0._initialInputChanged then
        a0._initialInputChanged:Disconnect()
        a0._initialInputChanged = nil
    end

    a0.ActiveInput = nil
    a0.ActivePosition = nil
    a0.EndUserInputType = nil
    a0.EndKeyCode = nil
    a0.GamepadDrag = nil
    if a0._gamepadMovement then
        a0._gamepadMovement:Disconnect()
        a0._gamepadMovement = nil
    end

    if a0._mouseMovement then
        a0._mouseMovement:Disconnect()
        a0._mouseMovement = nil
    end

    if a0._mouseUp then
        a0._mouseUp:Disconnect()
        a0._mouseUp = nil
    end
end

v3.Disconnect = Disconnect

local function OnDisconnect(a0, a1)
    a0.DisconnectCallback = a1
end

v3.OnDisconnect = OnDisconnect

local function Destroy(a0)
    a0:Disconnect()
end

v3.Destroy = Destroy
return v3
