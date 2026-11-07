-- https://lua.expert

local t1 = {}

t1.__index = t1

local function toPolar(p1) -- line: 4
    return math.atan2(p1.Y, p1.X), p1.Magnitude
end

function t1.new(p2) -- line: 8
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self.ColorPicker = p2
    self:Init()

    return self
end

function t1:Init() -- line: 16
    local CanvasGroup = Instance.new("CanvasGroup")

    CanvasGroup.Name = "GeneratedColorWheel"
    CanvasGroup.Size = UDim2.fromScale(1, 1)
    CanvasGroup.BackgroundColor3 = Color3.new(1, 1, 1)
    CanvasGroup.BackgroundTransparency = 0
    CanvasGroup.BorderSizePixel = 0
    CanvasGroup.ClipsDescendants = true
    CanvasGroup.ZIndex = 1
    CanvasGroup.Parent = self.ColorPicker.Instance:WaitForChild("Picker")

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = CanvasGroup

    for i = 0, 143 do
        local v2 = i / 144
        local Frame = Instance.new("Frame")

        Frame.Name = "SpokeRotator"
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Position = UDim2.fromScale(0.5, 0.5)
        Frame.Size = UDim2.fromScale(1, 1)
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        Frame.Rotation = -90 - v2 * 360
        Frame.ZIndex = 1
        Frame.Parent = CanvasGroup

        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Spoke"
        Frame2.AnchorPoint = Vector2.new(0.5, 1)
        Frame2.Position = UDim2.fromScale(0.5, 0.5)
        Frame2.Size = UDim2.new(0, 5, 0.5, 1)
        Frame2.BackgroundColor3 = Color3.new(1, 1, 1)
        Frame2.BorderSizePixel = 0
        Frame2.ZIndex = 1
        Frame2.Parent = Frame

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = 90
        UIGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHSV(v2, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
        })
        UIGradient.Parent = Frame2
    end

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = Color3.fromRGB(225, 225, 225)
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.35
    UIStroke.Parent = CanvasGroup
    self.Instance = CanvasGroup
end

function t1:SetVisible(p5) -- line: 73
    self.Instance.Visible = p5
end

function t1:GetColor(p7) -- line: 77
    local v3 = (p7 - Vector2.new(0.5, 0.5)) * Vector2.new(1, -1)
    local v4 = math.atan2(v3.Y, v3.X)
    local Magnitude = v3.Magnitude

    return math.clamp((v4 + 3.141592653589793) / 6.283185307179586, 0, 1), math.clamp(Magnitude * 2, 0, 1), self.ColorPicker.Color.Value
end

function t1.GetPointerPositionFromColor(_, p9, p10, _) -- line: 86
    local v8 = p9 * 3.141592653589793 * 2

    return UDim2.fromScale(0.5 - math.cos(v8) / 2 * p10, 0.5 + math.sin(v8) / 2 * p10)
end

return t1
