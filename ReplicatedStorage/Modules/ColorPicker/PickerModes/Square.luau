
local t1 = {}
t1.__index = t1

local function new(a0) --[[ Upvalues: t1 (copy) ]]
    local v1 = setmetatable({}, t1)
    v1.ColorPicker = a0
    v1:Init()
    return v1
end

t1.new = new

local function Init(a0)
    local CanvasGroup = Instance.new("CanvasGroup")
    CanvasGroup.BackgroundTransparency = 0
    CanvasGroup.BackgroundColor3 = Color3.new(1, 1, 1)
    CanvasGroup.Size = UDim2.fromScale(1, 1)
    CanvasGroup.Parent = a0.ColorPicker.Instance:WaitForChild("Picker")
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = CanvasGroup
    local UIGradient = Instance.new("UIGradient")
    local v2 = Color3.new(1, 1, 1)
    UIGradient.Color = ColorSequence.new(v2)
    UIGradient.Parent = CanvasGroup
    local Frame = Instance.new("Frame")
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.BackgroundTransparency = 0
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Parent = CanvasGroup
    local UIGradient1 = Instance.new("UIGradient")
    local v3 = Color3.new(0, 0, 0)
    UIGradient1.Color = ColorSequence.new(v3)
    UIGradient1.Rotation = -90
    local v4 = NumberSequenceKeypoint.new(0, 0)
    v3 = {v4, NumberSequenceKeypoint.new(1, 1)}
    UIGradient1.Transparency = NumberSequence.new(v3)
    UIGradient1.Parent = Frame
    a0.Instance = CanvasGroup
    a0.Gradient = UIGradient
end

t1.Init = Init

local function SetVisible(a0, a1)
    a0.Instance.Visible = a1
end

t1.SetVisible = SetVisible

local function GetColor(a0, a1)
    local v6 = math.clamp(a1.X, 0, 1)
    local v7 = 1 - a1.Y
    return a0.ColorPicker.Color.Hue, v6, math.clamp(v7, 0, 1)
end

t1.GetColor = GetColor

local function GetPointerPositionFromColor(a0, a1, a2, a3)
    local v8 = UDim2.fromScale(a2, 1 - a3)
    return v8
end

t1.GetPointerPositionFromColor = GetPointerPositionFromColor

local function ColorChanged(a0)
    local v9 = Color3.new(1, 1, 1)
    local v10 = ColorSequenceKeypoint.new(0, v9)
    local v11 = Color3.fromHSV(a0.ColorPicker.Color.Hue, 1, 1)
    local t2 = {v10, ColorSequenceKeypoint.new(1, v11)}
    a0.Gradient.Color = ColorSequence.new(t2)
end

t1.ColorChanged = ColorChanged
return t1
