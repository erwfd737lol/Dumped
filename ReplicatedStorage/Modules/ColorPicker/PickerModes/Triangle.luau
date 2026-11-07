-- https://lua.expert

local t1 = {}

t1.__index = t1

local function heightToTriangleHeight(p1) -- line: 5
    return p1 / 0.8660254037844386 - 0.0669872981077807
end

local t2 = {
    Vector2.new(0.5, 0),
    Vector2.new(0, 1),
    (Vector2.new(1, 1))
}

function t1.new(p2) -- line: 16
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self.ColorPicker = p2
    self:Init()

    return self
end

function t1:Init() -- line: 24
    local Frame = Instance.new("Frame")

    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Parent = self.ColorPicker.Instance:WaitForChild("Picker")

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.Image = "rbxassetid://119614645478849"
    ImageLabel.ImageColor3 = Color3.new(1, 0, 0)
    ImageLabel.ZIndex = 1
    ImageLabel.Parent = Frame

    local ImageLabel2 = Instance.new("ImageLabel")

    ImageLabel2.BackgroundTransparency = 1
    ImageLabel2.Size = UDim2.fromScale(1, 1)
    ImageLabel2.Image = "rbxassetid://114393129271758"
    ImageLabel2.ImageColor3 = Color3.new(1, 1, 1)
    ImageLabel2.ZIndex = 2
    ImageLabel2.Parent = Frame

    local ImageLabel3 = Instance.new("ImageLabel")

    ImageLabel3.BackgroundTransparency = 1
    ImageLabel3.Size = UDim2.fromScale(1, 1)
    ImageLabel3.Image = "rbxassetid://90395096352510"
    ImageLabel3.ImageColor3 = Color3.new(1, 1, 1)
    ImageLabel3.ZIndex = 3
    ImageLabel3.Parent = Frame
    self.Instance = Frame
    self.ColorImage = ImageLabel
end

function t1:SetVisible(p5) -- line: 58
    self.Instance.Visible = p5
end

function t1:GetColor(p7) -- line: 62
    -- upvalues: t2 (copy)
    local X = p7.X
    local v3 = math.clamp(p7.Y / 0.8660254037844386 - 0.0669872981077807, 0, 1)
    local v6 = math.clamp(X, 0.5 - v3 / 2, v3 / 2 + 0.5)
    local v7 = t2[1]
    local v8 = t2[2]
    local v9 = t2[3]
    local v10 = ((v8.Y - v9.Y) * (v6 - v9.X) + (v9.X - v8.X) * (v3 - v9.Y)) / ((v8.Y - v9.Y) * (v7.X - v9.X) + (v9.X - v8.X) * (v7.Y - v9.Y))
    local v11 = ((v9.Y - v7.Y) * (v6 - v9.X) + (v7.X - v9.X) * (v3 - v9.Y)) / ((v8.Y - v9.Y) * (v7.X - v9.X) + (v9.X - v8.X) * (v7.Y - v9.Y))
    local v12 = 1 - v10 - v11
    local v13 = math.clamp(v10, 0, 1)
    local v14 = math.clamp(v11, 0, 1)
    local v15 = math.clamp(v12, 0, 1)
    local v16 = Color3.fromHSV(self.ColorPicker.Color.Hue, 1, 1)
    local _, v17, v18 = Color3.new(v13 * v16.R + v14 * 0 + v15 * 1, v13 * v16.G + v14 * 0 + v15 * 1, v13 * v16.B + v14 * 0 + v15 * 1):ToHSV()

    return self.ColorPicker.Color.Hue, v17, v18
end

function t1.GetPointerPositionFromColor(_, _, p10, p11) -- line: 107
    local v19 = Vector2.new(0.5, 0):Lerp(Vector2.new(1, 1), 1 - p10):Lerp(Vector2.new(0, 1), 1 - p11)

    return UDim2.fromScale(v19.X, 0.0669872981077807 + v19.Y * 0.8660254037844386)
end

function t1:ColorChanged() -- line: 112
    self.ColorImage.ImageColor3 = Color3.fromHSV(self.ColorPicker.Color.Hue, 1, 1)
end

return t1
