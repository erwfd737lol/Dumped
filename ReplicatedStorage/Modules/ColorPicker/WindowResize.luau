
local MouseMovement = script.Parent:WaitForChild("MouseMovement")
local v1 = require(MouseMovement)
local TweenService = game:GetService("TweenService")
local v2 = {}
v2.__index = v2

local function new(a0) --[[ Upvalues: v2 (copy) ]]
    local v3 = setmetatable({}, v2)
    v3.ColorPicker = a0
    v3.ScaleElement = a0.Instance:WaitForChild("UIScale")
    v3.Window = a0.Instance
    v3.InfoMenu = v3.Window:WaitForChild("Info")
    local Scale = v3.InfoMenu:WaitForChild("Scale")
    v3.InputBox = Scale:WaitForChild("Input")
    v3:Init()
    return v3
end

v2.new = new

local function GetScaleBounds(a0)
    local v4 = math.floor(a0.ColorPicker.UI.AbsoluteSize.Y / 250)
    return 1, math.max(v4, 2)
end

v2.GetScaleBounds = GetScaleBounds

local function SetScale(a0, a1)
    local v5 = a0:GetScaleBounds()
    local v6 = math.round(math.clamp(a1, v5) * 100) / 100
    a0.ScaleElement.Scale = v6
    a0.InputBox.Text = tostring(v6)
end

v2.SetScale = SetScale

local function Init(a0)
    a0.InputBox.FocusLost:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:SetScale(tonumber(a0.InputBox.Text) or 1)
    end)
end

v2.Init = Init

local function Create(a0) --[[ Upvalues: TweenService (copy), v1 (copy) ]]
    local v7 = script.Parent:WaitForChild("Samples"):WaitForChild("ResizeFrame"):Clone()
    v7.Frame.BackgroundTransparency = 1
    v7.Parent = a0.ColorPicker.Instance
    v7.MouseEnter:Connect(function() --[[ Upvalues: TweenService (upvalue), v7 (copy) ]]
        local v8 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        TweenService:Create(v7.Frame, v8, {BackgroundTransparency = 0.5}):Play()
    end)
    v7.MouseLeave:Connect(function() --[[ Upvalues: TweenService (upvalue), v7 (copy) ]]
        local v9 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        TweenService:Create(v7.Frame, v9, {BackgroundTransparency = 1}):Play()
    end)
    a0._mouseMovement = v1.new(function(a0, a1) --[[ Upvalues: a0 (copy) ]]
        local v10 = a0.ColorPicker:GetMousePos().X - a0.X
        local v11 = a1 + v10 / a0.Window.Size.X.Offset
        local v12 = math.abs(a1 - v11)
        if v12 <= 0.05 then
            v11 = a1
        else
            local v13 = math.abs(math.round(v11) - v11)
            if v13 <= 0.075 then
                v11 = math.round(v11)
            end
        end

        a0:SetScale(v11)
    end)
    local UIScale = a0.ColorPicker.Instance:WaitForChild("UIScale")
    v7.Button.MouseButton1Down:Connect(function() --[[ Upvalues: a0 (copy), UIScale (copy) ]]
        local v14 = a0.ColorPicker:GetMousePos()
        a0._mouseMovement:Connect(v14, UIScale.Scale)
    end)
    a0.Instance = v7
end

v2.Create = Create

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

v2.Destroy = Destroy
return v2
