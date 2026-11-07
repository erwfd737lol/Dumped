
local Slider = script.Parent:WaitForChild("Slider")
local v1 = require(Slider)
local v2 = Color3.fromRGB(255, 0, 0)
local v3 = ColorSequenceKeypoint.new(0, v2)
local v4 = Color3.fromRGB(255, 255, 0)
local v5 = ColorSequenceKeypoint.new(0.16666666666666666, v4)
local v6 = Color3.fromRGB(0, 255, 0)
local v7 = ColorSequenceKeypoint.new(0.33333333333333331, v6)
local v8 = Color3.fromRGB(0, 255, 255)
local v9 = ColorSequenceKeypoint.new(0.5, v8)
local v10 = Color3.fromRGB(0, 0, 255)
local v11 = ColorSequenceKeypoint.new(0.66666666666666663, v10)
local v12 = Color3.fromRGB(255, 0, 255)
local v13 = ColorSequenceKeypoint.new(0.83333333333333337, v12)
local v14 = Color3.fromRGB(255, 0, 0)
local v16 = {v3, v5, v7, v9, v11, v13, ColorSequenceKeypoint.new(1, v14)}
local v17 = ColorSequence.new(v16)

local function Transparency(a0) --[[ Upvalues: v1 (copy) ]]
    local v18 = v1.new(a0, "T", 4, 100)
    local Slider1 = v18.Instance:WaitForChild("Slider")
    local Gradient = Slider1:WaitForChild("Gradient")
    local v19 = NumberSequenceKeypoint.new(0, 0)
    local v21 = {v19, NumberSequenceKeypoint.new(1, 1)}
    Gradient.Transparency = NumberSequence.new(v21)
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.fromOffset(4, 4)
    ImageLabel.Size = UDim2.new(0, 165, 1, -8)
    ImageLabel.Image = "rbxassetid://111137375763311"
    ImageLabel.ImageTransparency = 0.5
    ImageLabel.ScaleType = Enum.ScaleType.Tile
    ImageLabel.TileSize = UDim2.fromOffset(10, 10)
    ImageLabel.ZIndex = -1
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = ImageLabel
    ImageLabel.Parent = v18.Instance
    v18.OnManualChange = function(a0) --[[ Upvalues: a0 (copy) ]]
        a0.Color.Transparency = a0
        a0:_updateColorVisuals()
    end

    v18.GetValue = function() --[[ Upvalues: a0 (copy) ]]
        return a0.Color.Transparency or 0
    end

    v18.OnValueChanged = function() --[[ Upvalues: Gradient (copy), a0 (copy) ]]
        local v22 = a0:GetColor()
        Gradient.Color = ColorSequence.new(v22)
    end

    return v18
end

local function Hue(a0) --[[ Upvalues: v1 (copy), v17 (copy) ]]
    local v23 = v1.new(a0, "H", 1, 360)
    local Slider2 = v23.Instance:WaitForChild("Slider")
    local Gradient1 = Slider2:WaitForChild("Gradient")
    Gradient1.Color = v17
    v23.OnManualChange = function(a0) --[[ Upvalues: a0 (copy) ]]
        a0.Color.Hue = a0
        a0:_updateColorVisuals()
    end

    v23.GetValue = function() --[[ Upvalues: a0 (copy) ]]
        return a0.Color.Hue or 0
    end

    return v23
end

local function Saturation1(a0) --[[ Upvalues: v1 (copy) ]]
    local v24 = v1.new(a0, "S", 2, 100)
    v24.OnManualChange = function(a0) --[[ Upvalues: a0 (copy) ]]
        a0.Color.Saturation = a0
        a0:_updateColorVisuals()
    end

    v24.GetValue = function() --[[ Upvalues: a0 (copy) ]]
        return a0.Color.Saturation or 0
    end

    v24.OnValueChanged = function() --[[ Upvalues: a0 (copy), v24 (copy) ]]
        local Saturation = a0.Color.Saturation
        local Slider3 = v24.Instance:WaitForChild("Slider")
        local Gradient2 = Slider3:WaitForChild("Gradient")
        local v25 = Color3.fromRGB(255, 255, 255)
        local v26 = ColorSequenceKeypoint.new(0, v25)
        local v27 = Color3.fromHSV(a0.Color.Hue, 1, a0.Color.Value)
        local v29 = {v26, ColorSequenceKeypoint.new(1, v27)}
        Gradient2.Color = ColorSequence.new(v29)
    end

    return v24
end

local function Value1(a0) --[[ Upvalues: v1 (copy) ]]
    local v30 = v1.new(a0, "V", 3, 100)
    v30.OnManualChange = function(a0) --[[ Upvalues: a0 (copy) ]]
        a0.Color.Value = a0
        a0:_updateColorVisuals()
    end

    v30.GetValue = function() --[[ Upvalues: a0 (copy) ]]
        return a0.Color.Value or 0
    end

    v30.OnValueChanged = function() --[[ Upvalues: a0 (copy), v30 (copy) ]]
        local Value = a0.Color.Value
        local Slider4 = v30.Instance:WaitForChild("Slider")
        local Gradient3 = Slider4:WaitForChild("Gradient")
        local v31 = Color3.fromRGB(0, 0, 0)
        local v32 = ColorSequenceKeypoint.new(0, v31)
        local v33 = Color3.fromHSV(a0.Color.Hue, a0.Color.Saturation, 1)
        local v35 = {v32, ColorSequenceKeypoint.new(1, v33)}
        Gradient3.Color = ColorSequence.new(v35)
    end

    return v30
end

local function Red(a0) --[[ Upvalues: v1 (copy) ]]
    local v36 = v1.new(a0, "R", 1, 255)
    v36.OnManualChange = function(a0) --[[ Upvalues: a0 (copy) ]]
        local v37 = a0:GetColor()
        local v38, v39, v40 = Color3.new(a0, v37.G, v37.B):ToHSV()
        a0.Color.Hue = v38
        a0.Color.Saturation = v39
        a0.Color.Value = v40
        a0:_updateColorVisuals()
    end

    v36.GetValue = function() --[[ Upvalues: a0 (copy) ]]
        return a0:GetColor().R or 0
    end

    v36.OnValueChanged = function() --[[ Upvalues: a0 (copy), v36 (copy) ]]
        local v41 = a0:GetColor()
        local G = v41.G
        local B = v41.B
        local Slider5 = v36.Instance:WaitForChild("Slider")
        v41 = Slider5:WaitForChild("Gradient")
        local v42 = Color3.new(0, G, B)
        local v43 = ColorSequenceKeypoint.new(0, v42)
        local v44 = Color3.new(1, G, B)
        local v46 = {v43, ColorSequenceKeypoint.new(1, v44)}
        v41.Color = ColorSequence.new(v46)
    end

    return v36
end

local function Green(a0) --[[ Upvalues: v1 (copy) ]]
    local v47 = v1.new(a0, "G", 2, 255)
    v47.OnManualChange = function(a0) --[[ Upvalues: a0 (copy) ]]
        local v48 = a0:GetColor()
        local v49, v50, v51 = Color3.new(v48.R, a0, v48.B):ToHSV()
        a0.Color.Hue = v49
        a0.Color.Saturation = v50
        a0.Color.Value = v51
        a0:_updateColorVisuals()
    end

    v47.GetValue = function() --[[ Upvalues: a0 (copy) ]]
        return a0:GetColor().G or 0
    end

    v47.OnValueChanged = function() --[[ Upvalues: a0 (copy), v47 (copy) ]]
        local v52 = a0:GetColor()
        local R = v52.R
        local B1 = v52.B
        local Slider6 = v47.Instance:WaitForChild("Slider")
        v52 = Slider6:WaitForChild("Gradient")
        local v53 = Color3.new(R, 0, B1)
        local v54 = ColorSequenceKeypoint.new(0, v53)
        local v55 = Color3.new(R, 1, B1)
        local v57 = {v54, ColorSequenceKeypoint.new(1, v55)}
        v52.Color = ColorSequence.new(v57)
    end

    return v47
end

local function Blue(a0) --[[ Upvalues: v1 (copy) ]]
    local v58 = v1.new(a0, "B", 3, 255)
    v58.OnManualChange = function(a0) --[[ Upvalues: a0 (copy) ]]
        local v59 = a0:GetColor()
        local v60, v61, v62 = Color3.new(v59.R, v59.G, a0):ToHSV()
        a0.Color.Hue = v60
        a0.Color.Saturation = v61
        a0.Color.Value = v62
        a0:_updateColorVisuals()
    end

    v58.GetValue = function() --[[ Upvalues: a0 (copy) ]]
        return a0:GetColor().B or 0
    end

    v58.OnValueChanged = function() --[[ Upvalues: a0 (copy), v58 (copy) ]]
        local v63 = a0:GetColor()
        local R1 = v63.R
        local G1 = v63.G
        local Slider7 = v58.Instance:WaitForChild("Slider")
        v63 = Slider7:WaitForChild("Gradient")
        local v64 = Color3.new(R1, G1, 0)
        local v65 = ColorSequenceKeypoint.new(0, v64)
        local v66 = Color3.new(R1, G1, 1)
        local v68 = {v65, ColorSequenceKeypoint.new(1, v66)}
        v63.Color = ColorSequence.new(v68)
    end

    return v58
end

v16 = {
    Transparency = Transparency,
    Hue = Hue,
    Saturation = Saturation1,
    Value = Value1,
    Red = Red,
    Green = Green,
    Blue = Blue
}
return v16
