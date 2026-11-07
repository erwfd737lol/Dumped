
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
local v1 = require(FlagUtil)
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local GameSettings = UserSettings().GameSettings
local CameraUtils = script.Parent:WaitForChild("CameraUtils")
local v2 = require(CameraUtils)
local v3 = v1.getUserFlag("UserFixStuckShiftLock")
v1 = {}
v1.__index = v1

local function new() --[[ Upvalues: v1 (copy), GameSettings (copy), Players (copy), UserInputService (copy) ]]
    local v4 = setmetatable({}, v1)
    v4.isMouseLocked = false
    v4.savedMouseCursor = nil
    local v5 = {Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift}
    v4.boundKeys = v5
    v4.mouseLockToggledEvent = Instance.new("BindableEvent")
    local BoundKeys = script:FindFirstChild("BoundKeys")
    if not (BoundKeys and BoundKeys:IsA("StringValue")) then
        if BoundKeys then
            BoundKeys:Destroy()
        end

        BoundKeys = Instance.new("StringValue")
        assert(BoundKeys, "")
        BoundKeys.Name = "BoundKeys"
        BoundKeys.Value = "LeftShift,RightShift"
        BoundKeys.Parent = script
    end

    if BoundKeys then
        BoundKeys.Changed:Connect(function(a0) --[[ Upvalues: v4 (copy) ]]
            v4:OnBoundKeysObjectChanged(a0)
        end)
        v4:OnBoundKeysObjectChanged(BoundKeys.Value)
    end

    GameSettings.Changed:Connect(function(a0) --[[ Upvalues: v4 (copy) ]]
        if a0 == "ControlMode" or a0 == "ComputerMovementMode" then
            v4:UpdateMouseLockAvailability()
        end

    end)
    local v6 = Players.LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock")
    v6:Connect(function() --[[ Upvalues: v4 (copy) ]]
        v4:UpdateMouseLockAvailability()
    end)
    local v7 = Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode")
    v7:Connect(function() --[[ Upvalues: v4 (copy) ]]
        v4:UpdateMouseLockAvailability()
    end)
    local v8 = UserInputService:GetPropertyChangedSignal("PreferredInput")
    v8:Connect(function() --[[ Upvalues: v4 (copy) ]]
        v4:UpdateMouseLockAvailability()
    end)
    v4:UpdateMouseLockAvailability()
    return v4
end

v1.new = new

local function GetIsMouseLocked(a0)
    return a0.isMouseLocked
end

v1.GetIsMouseLocked = GetIsMouseLocked

local function GetBindableToggleEvent(a0)
    return a0.mouseLockToggledEvent.Event
end

v1.GetBindableToggleEvent = GetBindableToggleEvent

local function GetMouseLockOffset(a0)
    return Vector3.new(1.75, 0, 0)
end

v1.GetMouseLockOffset = GetMouseLockOffset

local function UpdateMouseLockAvailability(a0) --[[ Upvalues: Players (copy), GameSettings (copy), UserInputService (copy) ]]
    local v13 = UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse and Players.LocalPlayer.DevEnableMouseLock and GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch and not (GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove) and not (Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable)
    if v13 ~= a0.enabled then
        a0:EnableMouseLock(v13)
    end
end

v1.UpdateMouseLockAvailability = UpdateMouseLockAvailability

local function OnBoundKeysObjectChanged(a0, a1)
    a0.boundKeys = {}
    for k1 in string.gmatch(a1, "[^%s,]+") do
        local v17 = Enum.KeyCode:GetEnumItems()
        for k2, k3 in pairs(v17) do
            if k1 == k3.Name then
                a0.boundKeys[#a0.boundKeys + 1] = k3
                break
            end
        end
    end

    a0:UnbindContextActions()
    a0:BindContextActions()
end

v1.OnBoundKeysObjectChanged = OnBoundKeysObjectChanged

local function OnMouseLockToggled(a0) --[[ Upvalues: v2 (copy) ]]
    a0.isMouseLocked = not a0.isMouseLocked
    if a0.isMouseLocked then
        local CursorImage = script:FindFirstChild("CursorImage")
        if CursorImage and CursorImage:IsA("StringValue") and CursorImage.Value then
            v2.setMouseIconOverride(CursorImage.Value)
            -- jump to 73 (out of range)
        end

        if CursorImage then
            CursorImage:Destroy()
        end

        CursorImage = Instance.new("StringValue")
        assert(CursorImage, "")
        CursorImage.Name = "CursorImage"
        CursorImage.Value = "rbxasset://textures/MouseLockedCursor.png"
        CursorImage.Parent = script
        v2.setMouseIconOverride("rbxasset://textures/MouseLockedCursor.png")
    else
        v2.restoreMouseIcon()
    end

    a0.mouseLockToggledEvent:Fire()
end

v1.OnMouseLockToggled = OnMouseLockToggled

local function DoMouseLockSwitch(a0, a1, a2, a3)
    if a2 == Enum.UserInputState.Begin then
        a0:OnMouseLockToggled()
        return Enum.ContextActionResult.Sink
    end

    return Enum.ContextActionResult.Pass
end

v1.DoMouseLockSwitch = DoMouseLockSwitch
local Value = Enum.ContextActionPriority.Medium.Value

local function BindContextActions(a0) --[[ Upvalues: ContextActionService (copy), Value (copy) ]]
    local v22 = unpack(a0.boundKeys)
    ContextActionService:BindActionAtPriority("MouseLockSwitchAction", function(a0, a1, a2) --[[ Upvalues: a0 (copy) ]]
        local v21 = a0:DoMouseLockSwitch(a0, a1, a2)
        return v21
    end, false, Value, v22)
end

v1.BindContextActions = BindContextActions

local function UnbindContextActions(a0) --[[ Upvalues: ContextActionService (copy) ]]
    ContextActionService:UnbindAction("MouseLockSwitchAction")
end

v1.UnbindContextActions = UnbindContextActions

local function IsMouseLocked(a0)
    local v23 = a0.enabled and a0.isMouseLocked
    return v23
end

v1.IsMouseLocked = IsMouseLocked

local function EnableMouseLock(a0, a1) --[[ Upvalues: v2 (copy), v3 (copy) ]]
    if a1 ~= a0.enabled then
        a0.enabled = a1
        if a0.enabled then
            a0:BindContextActions()
            return
        end

        v2.restoreMouseIcon()
        a0:UnbindContextActions()
        if v3 then
            if a0.isMouseLocked then
                a0.isMouseLocked = false
                a0.mouseLockToggledEvent:Fire()
                return
                -- branch continues at 50
            end
        end

        if a0.isMouseLocked then
            a0.mouseLockToggledEvent:Fire()
        end

        a0.isMouseLocked = false
    end
end

v1.EnableMouseLock = EnableMouseLock
return v1
