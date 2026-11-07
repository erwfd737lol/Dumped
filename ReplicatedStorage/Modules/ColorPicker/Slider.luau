
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GamepadService = game:GetService("GamepadService")
local Samples = script.Parent:WaitForChild("Samples")
local MouseMovement = script.Parent:WaitForChild("MouseMovement")
local v1 = require(MouseMovement)
MouseMovement = {}
MouseMovement.__index = MouseMovement

local function lerp(a0, a1, a2)
    return a0 + (a1 - a0) * a2
end

local function new(a0, a1, a2, a3) --[[ Upvalues: MouseMovement (copy) ]]
    local v2 = setmetatable({}, MouseMovement)
    v2.ColorPicker = a0
    v2.TextLabel = a1
    v2.Priority = a2
    v2.MaxValue = a3
    v2.Visible = true
    v2.Value = 0
    v2:Init()
    return v2
end

MouseMovement.new = new

local function Create(a0) --[[ Upvalues: Samples (copy) ]]
    local Sliders = a0.ColorPicker.Instance:WaitForChild("Sliders")
    local v3 = Samples:WaitForChild("SliderSample"):Clone()
    v3.Name = string.format("%02d", a0.Priority)
    v3.Text.Text = a0.TextLabel
    v3.Parent = Sliders
    a0.Instance = v3
end

MouseMovement.Create = Create

local function SetValue(a0, a1)
    a0.Value = math.clamp(a1, 0, 1)
    if a0.OnManualChange then
        a0.OnManualChange(a0.Value)
    end

    a0:UpdateVisual()
end

MouseMovement.SetValue = SetValue

local function SetVisible(a0, a1)
    a0.Visible = a1
    a0.Instance.Visible = a0.Visible
end

MouseMovement.SetVisible = SetVisible

local function UpdateVisual(a0)
    local Slider = a0.Instance:WaitForChild("Slider")
    local Select = Slider:WaitForChild("Select")
    local Input = a0.Instance:WaitForChild("Input")
    local v4 = Slider.Size.X.Offset - 14
    Select.Position = UDim2.new(0, -3 + (v4 - -3) * a0.Value, 0.5, 0)
    Input.Text = math.round(a0.Value * a0.MaxValue)
    if a0.OnValueChanged then
        a0.OnValueChanged()
    end
end

MouseMovement.UpdateVisual = UpdateVisual

local function ColorAdjusted(a0)
    if a0.GetValue then
        a0.Value = a0.GetValue()
        a0:UpdateVisual()
    end
end

MouseMovement.ColorAdjusted = ColorAdjusted

local function Init(a0) --[[ Upvalues: v1 (copy), GamepadService (copy) ]]
    a0:Create()
    a0:SetVisible(false)
    local SliderButton = a0.Instance:WaitForChild("SliderButton")
    local Slider1 = a0.Instance:WaitForChild("Slider")

    local function updateSliderAt(a0, a1) --[[ Upvalues: Slider1 (copy), a0 (copy) ]]
        local Offset = Slider1.Size.X.Offset
        local v7 = 4 * (0 < Offset and Slider1.AbsoluteSize.X / Offset or 1)
        Offset = a0 - Vector2.new(v7, 0)
        local v8 = (Offset.X - Slider1.AbsolutePosition.X) / math.max(1, Slider1.AbsoluteSize.X - 10 * (0 < Offset and Slider1.AbsoluteSize.X / Offset or 1))
        local v9 = math.clamp(v8, 0, 1)
        if a0.Value ~= v9 then
            a0:SetValue(v9)
            if a1 and a0.ColorPicker.Params.RealTimeEventCalling then
                a0.ColorPicker:_fireColorChanged()
            end
        end
    end

    a0._mouseMovement = v1.new(function() --[[ Upvalues: a0 (copy), updateSliderAt (copy) ]]
        local v10 = a0._mouseMovement:GetPosition()
        local v11 = updateSliderAt
        local v14 = v10 or a0.ColorPicker:GetMousePos()
        v11(v14, true)
    end)
    a0._mouseMovement:OnDisconnect(function() --[[ Upvalues: a0 (copy) ]]
        a0.ColorPicker:_fireColorChanged()
        a0.ColorPicker:WriteHistory()
    end)
    SliderButton.InputBegan:Connect(function(a0) --[[ Upvalues: GamepadService (upvalue), a0 (copy), updateSliderAt (copy) ]]
        local v15 = true
        if a0.KeyCode ~= Enum.KeyCode.ButtonA then
            local GamepadCursorEnabled = GamepadService.GamepadCursorEnabled
            if GamepadCursorEnabled then
                GamepadCursorEnabled = a0.UserInputType == Enum.UserInputType.MouseButton1
            end
        end

        if v15 then
            a0._mouseMovement:Disconnect()
            local v16 = a0.ColorPicker:GetMousePos()
            updateSliderAt(v16, false)
            a0.ColorPicker:_fireColorChanged()
            a0.ColorPicker:WriteHistory()
            return
        end

        if a0.UserInputType == Enum.UserInputType.MouseButton1 or a0.UserInputType == Enum.UserInputType.Touch then
            a0._mouseMovement:Connect(a0)
        end

    end)
    SliderButton = a0.Instance:WaitForChild("Input")
    SliderButton.FocusLost:Connect(function() --[[ Upvalues: SliderButton (copy), a0 (copy) ]]
        local v17 = tonumber(SliderButton.Text) or 0
        a0:SetValue(v17 / a0.MaxValue)
        a0.ColorPicker:WriteHistory()
        a0.ColorPicker:_fireColorChanged()
    end)
end

MouseMovement.Init = Init

local function Destroy(a0)
    if a0._mouseMovement then
        a0._mouseMovement:Destroy()
        a0._mouseMovement = nil
    end

    if a0.Instance then
        a0.Instance:Destroy()
        a0.Instance = nil
    end
end

MouseMovement.Destroy = Destroy
return MouseMovement
