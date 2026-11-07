
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local GamepadService = game:GetService("GamepadService")
local LocalPlayer = game.Players.LocalPlayer
local v1 = LocalPlayer:GetMouse()
local PickerModes = script:WaitForChild("PickerModes")
local Samples = script:WaitForChild("Samples")
local Circle = PickerModes:WaitForChild("Circle")
local Square = PickerModes:WaitForChild("Square")
local Triangle = PickerModes:WaitForChild("Triangle")
local v2 = {Circle = require(Circle), Square = require(Square), Triangle = require(Triangle)}
local BuiltinSliders = script:WaitForChild("BuiltinSliders")
PickerModes = require(BuiltinSliders)
local MouseMovement = script:WaitForChild("MouseMovement")
local v3 = require(MouseMovement)
local WindowResize = script:WaitForChild("WindowResize")
local v4 = require(WindowResize)
local History = script:WaitForChild("History")
local v5 = require(History)
History = {}
History.__index = History
History.COLOR_SPACE = {HSV = 1, RGB = 2}
History.PICKER_MODE = {CIRCLE = "Circle", SQUARE = "Square", TRIANGLE = "Triangle"}

local function template(a0, a1) --[[ Upvalues: template (copy) ]]
    local t1 = {}
    for k1, k2 in pairs(a1) do
        local v9 = a0[k1]
        if v9 == nil then
            v9 = k2
        end

        local v12 = typeof(v9) == "table" and template(v9, k2) or v9
        t1[k1] = v12
    end

    return t1
end

local function new(a0) --[[ Upvalues: History (copy), template (copy), v5 (copy) ]]
    local v13 = setmetatable({}, History)
    local v14 = v13:GetMousePos()
    local v15 = v14 + Vector2.new(20, 20)
    v14 = template
    local v16 = a0
    if not v16 then
        v16 = {}
    end

    local v17 = {
        Parent = "new",
        ZIndex = 1,
        Scale = 1,
        EnableTransparency = false,
        RealTimeEventCalling = false,
        Position = UDim2.fromOffset(v15.X, v15.Y),
        PickerMode = History.PICKER_MODE.CIRCLE,
        ColorSpace = History.COLOR_SPACE.HSV
    }
    v13.Params = v14(v16, v17)
    v13.History = v5.new()
    v13.PickerModes = {}
    v13.Sliders = {}
    v13.Color = {Hue = 0, Saturation = 1, Value = 1}
    v13:_init()
    return v13
end

History.new = new

local function GetHSV(a0)
    return a0.Color.Hue, a0.Color.Saturation, a0.Color.Value
end

History.GetHSV = GetHSV

local function GetColor(a0)
    local v18 = a0:GetHSV()
    local v19 = Color3.fromHSV(v18)
    return v19
end

History.GetColor = GetColor

local function SetColor(a0, a1)
    local v20, v21, v22 = a1:ToHSV()
    a0.Color.Hue = v20
    a0.Color.Saturation = v21
    a0.Color.Value = v22
    a0:_updateColorVisuals()
    a0:WriteHistory()
    a0:_fireColorChanged()
end

History.SetColor = SetColor

local function GetTransparency(a0)
    if not a0.Params.EnableTransparency then
        print("ColorPicker:GetTransparency - Transparency isn't enabled")
    end

    return a0.Color.Transparency
end

History.GetTransparency = GetTransparency

local function SetTransparency(a0, a1)
    if not a0.Params.EnableTransparency then
        print("ColorPicker:SetTransparency - Transparency isn't enabled")
        return
    end

    a0.Color.Transparency = math.clamp(a1, 0, 1)
    a0:_updateColorVisuals()
end

History.SetTransparency = SetTransparency

local function _setSliderVisible(a0, a1, a2)
    if a2 and a1.GetValue then
        a1.Value = a1.GetValue()
        a1:UpdateVisual()
    end

    a1:SetVisible(a2)
end

History._setSliderVisible = _setSliderVisible

local function _updateColorSpace(a0) --[[ Upvalues: History (copy) ]]
    local Right = a0.Instance:WaitForChild("Middle"):WaitForChild("Right")
    local TextLabel = Right:WaitForChild("ColorSpace"):WaitForChild("TextLabel")
    local v23 = a0.ColorSpace == History.COLOR_SPACE.HSV
    local v24
    if v23 then
        v24 = "HSV"
    else
        v24 = "RGB"
    end

    TextLabel.Text = v24
    a0:_setSliderVisible(a0.Sliders.Hue, v23)
    a0:_setSliderVisible(a0.Sliders.Saturation, v23)
    a0:_setSliderVisible(a0.Sliders.Value, v23)
    a0:_setSliderVisible(a0.Sliders.Red, not v23)
    a0:_setSliderVisible(a0.Sliders.Green, not v23)
    a0:_setSliderVisible(a0.Sliders.Blue, not v23)
    a0:_updateSize()
end

History._updateColorSpace = _updateColorSpace

local function SetColorSpace(a0, a1)
    a0.ColorSpace = a1
    a0:_updateColorSpace()
end

History.SetColorSpace = SetColorSpace

local function _updatePickerMode(a0)
    for k3, k4 in pairs(a0.PickerModes) do
        k4:SetVisible(k3 == a0.PickerMode)
    end

    local Options = a0.Instance:WaitForChild("Options")
    local PickerMode = Options:WaitForChild("PickerMode")
    local v28 = PickerMode:GetChildren()
    for k5, k6 in pairs(v28) do
        if k6:IsA("Frame") then
            local v32 = k6.Name == a0.PickerMode
            local v33
            if v32 then
                v33 = 0
            else
                v33 = 0.5
            end

            k6.Icon.ImageTransparency = v33
            k6.Selected.Visible = v32
        end
    end

    a0:_updateColorVisuals()
end

History._updatePickerMode = _updatePickerMode

local function SetPickerMode(a0, a1)
    a0.PickerMode = a1
    a0:_updatePickerMode()
end

History.SetPickerMode = SetPickerMode

local function _getPickerMode(a0, a1) --[[ Upvalues: v2 (copy) ]]
    if not a0.PickerModes[a1] then
        a0.PickerModes[a1] = v2[a1].new(a0)
    end

    return a0.PickerModes[a1]
end

History._getPickerMode = _getPickerMode

local function _fireColorChanged(a0)
    local v34 = a0:GetColor()
    a0._colorChangedEvent:Fire(v34, a0.Color.Transparency or 0)
end

History._fireColorChanged = _fireColorChanged

local function GetMousePos(a0) --[[ Upvalues: v1 (copy) ]]
    local v35 = Vector2.new(v1.X, v1.Y)
    return v35
end

History.GetMousePos = GetMousePos

local function _updateColorVisuals(a0) --[[ Upvalues: History (copy) ]]
    local v36 = a0:_getPickerMode(a0.PickerMode)
    local v37, v38, v39 = a0:GetHSV()
    local Select = a0.Instance:WaitForChild("Picker"):WaitForChild("Select")
    Select.ImageColor3 = Color3.fromHSV(0, 0, a0.PickerMode == History.PICKER_MODE.CIRCLE and 0.4 + v39 * 0.6 or 1)
    Select.Position = v36:GetPointerPositionFromColor(v37, v38, v39)
    if v36.ColorChanged then
        v36:ColorChanged()
    end

    local Middle = a0.Instance:WaitForChild("Middle")
    local Right1 = Middle:WaitForChild("Right")
    local Color = Right1:WaitForChild("Color")
    Color.BackgroundColor3 = a0:GetColor()
    Color.BackgroundTransparency = a0.Color.Transparency or 0
    local Hex = Middle:WaitForChild("Hex")
    Color = Hex:WaitForChild("Input")
    local v42 = a0:GetColor():ToHex()
    Color.Text = string.format("#%s", v42)
    for k7, k8 in pairs(a0.Sliders) do
        if k8.Visible and k8.GetValue then
            k8:ColorAdjusted()
        end
    end
end

History._updateColorVisuals = _updateColorVisuals

local function _updateSize(a0)
    local v46 = 0
    for k9, k10 in pairs(a0.Sliders) do
        if k10.Visible then
            v46 = v46 + 1
        end
    end

    local Instance = a0.Instance
    Instance.Size = UDim2.fromOffset(238, 256 + (0 < v46 and v46 * 26 or 0))
end

History._updateSize = _updateSize

local function _updateHistoryVisuals(a0)
    local Options1 = a0.Instance:WaitForChild("Options")
    local History1 = Options1:WaitForChild("History")
    local Undo = History1:WaitForChild("Undo")
    local Button = Undo:WaitForChild("Button")
    local Redo = History1:WaitForChild("Redo")
    local Button1 = Redo:WaitForChild("Button")
    local v52
    if a0.History._currentIndex <= 1 then
        v52 = 0.5
    else
        v52 = 0
    end

    Button.ImageTransparency = v52
    if a0.History._currentIndex == #a0.History.Records then
        v52 = 0.5
    else
        v52 = 0
    end

    Button1.ImageTransparency = v52
end

History._updateHistoryVisuals = _updateHistoryVisuals

local function WriteHistory(a0)
    local v53 = table.clone(a0.Color)
    a0.History:WriteHistory(v53)
    a0:_updateHistoryVisuals()
end

History.WriteHistory = WriteHistory

local function IncrementHistory(a0, a1)
    local v54 = a0.History:IncrementHistory(a1)
    if v54 then
        a0.Color = table.clone(v54)
        a0:_updateHistoryVisuals()
        a0:_updateColorVisuals()
        a0:_fireColorChanged()
    end
end

History.IncrementHistory = IncrementHistory

local function _create(a0) --[[ Upvalues: LocalPlayer (copy), Samples (copy), v3 (copy), GamepadService (copy), History (copy), v4 (copy), UserInputService (copy), RunService (copy) ]]
    a0.UI = a0.Params.Parent
    if not a0.UI or a0.UI == "new" then
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "COLOR_PICKER_UI"
        ScreenGui.DisplayOrder = 100
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        a0.UI = ScreenGui
        a0._deleteUIOnClose = true
        -- jump to 58 (out of range)
    end

    assert(a0.UI.ZIndexBehavior == Enum.ZIndexBehavior.Sibling, "ColorPicker - ZIndexBehavior needs to be 'Sibling'")
    local v55 = Samples:WaitForChild("ColorPickerSample"):Clone()
    v55.Position = a0.Params.Position
    v55.ZIndex = a0.Params.ZIndex
    v55.Parent = a0.UI
    a0.Instance = v55
    local Picker = a0.Instance:WaitForChild("Picker")

    local function updatePickerAt(a0, a1) --[[ Upvalues: Picker (copy), a0 (copy) ]]
        local v56 = a0 - Picker.AbsolutePosition
        local v57 = v56 / Picker.AbsoluteSize
        local v58 = a0:_getPickerMode(a0.PickerMode)
        local v59, v60, v61 = v58:GetColor(v57)
        a0.Color.Hue = v59
        a0.Color.Saturation = v60
        a0.Color.Value = v61
        a0:_updateColorVisuals()
        if a1 and a0.Params.RealTimeEventCalling then
            a0:_fireColorChanged()
        end
    end

    a0._pickerMouseMovement = v3.new(function() --[[ Upvalues: a0 (copy), updatePickerAt (copy) ]]
        local v62 = a0._pickerMouseMovement:GetPosition()
        local v63 = updatePickerAt
        local v66 = v62 or a0:GetMousePos()
        v63(v66, true)
    end)
    a0._pickerMouseMovement:OnDisconnect(function() --[[ Upvalues: a0 (copy) ]]
        a0:_fireColorChanged()
        a0:WriteHistory()
    end)
    Picker:WaitForChild("Button").InputBegan:Connect(function(a0) --[[ Upvalues: GamepadService (upvalue), a0 (copy), Picker (copy) ]]
        local v67 = true
        if a0.KeyCode ~= Enum.KeyCode.ButtonA then
            local GamepadCursorEnabled = GamepadService.GamepadCursorEnabled
            if GamepadCursorEnabled then
                GamepadCursorEnabled = a0.UserInputType == Enum.UserInputType.MouseButton1
            end
        end

        if v67 then
            a0._pickerMouseMovement:Disconnect()
            local v68 = a0:GetMousePos() - Picker.AbsolutePosition
            local v69 = v68 / Picker.AbsoluteSize
            local v70 = a0:_getPickerMode(a0.PickerMode)
            local v71, v72, v73 = v70:GetColor(v69)
            a0.Color.Hue = v71
            a0.Color.Saturation = v72
            a0.Color.Value = v73
            a0:_updateColorVisuals()
            a0:_fireColorChanged()
            a0:WriteHistory()
            return
        end

        if a0.UserInputType == Enum.UserInputType.MouseButton1 or a0.UserInputType == Enum.UserInputType.Touch then
            a0._pickerMouseMovement:Connect(a0)
        end

    end)
    local Middle1 = a0.Instance:WaitForChild("Middle")
    local Hex1 = Middle1:WaitForChild("Hex")
    local Input = Hex1:WaitForChild("Input")
    Input.FocusLost:Connect(function() --[[ Upvalues: Input (copy), a0 (copy) ]]
        local v75, v76 = pcall(function() --[[ Upvalues: Input (upvalue) ]]
            local v74 = Color3.fromHex(Input.Text)
            return v74
        end)
        local v77 = a0
        local v79
        if not (v75 and v76) then
            local v80 = Color3.new(1, 1, 1)
        end

        v77:SetColor(v79)
    end)
    local Right2 = Middle1:WaitForChild("Right")
    Right2:WaitForChild("ColorSpace"):WaitForChild("Button").Activated:Connect(function() --[[ Upvalues: a0 (copy), History (upvalue) ]]
        local v81
        if not (a0.ColorSpace == History.COLOR_SPACE.HSV and History.COLOR_SPACE.RGB) then
            v81 = History.COLOR_SPACE.HSV
        end

        a0:SetColorSpace(v81)
    end)
    a0._windowAdjust = v3.new(function(a0, a1) --[[ Upvalues: a0 (copy) ]]
        local v84 = a0._windowAdjust:GetPosition() or a0:GetMousePos()
        local v86 = v84 or Vector2.zero
        local v87 = v86 - a0
        a0.Instance.Position = a1 + UDim2.fromOffset(v87.X, v87.Y)
    end)
    local Topbar = a0.Instance:WaitForChild("Topbar")
    Topbar:WaitForChild("Button").InputBegan:Connect(function(a0) --[[ Upvalues: a0 (copy) ]]
        if a0.UserInputType == Enum.UserInputType.MouseButton1 or a0.UserInputType == Enum.UserInputType.Touch then
            local v88 = Vector2.new(a0.Position.X, a0.Position.Y)
            a0._windowAdjust:Connect(a0, v88, a0.Instance.Position)
        end

    end)
    local Info = Topbar:WaitForChild("Info")
    local Button2 = Info:WaitForChild("Button")
    local Info1 = a0.Instance:WaitForChild("Info")
    Info1.Visible = false
    local Title = Info1:WaitForChild("Title")
    Title.Text = "Version v3.0.1"
    Button2.Activated:Connect(function() --[[ Upvalues: Info1 (copy) ]]
        Info1.Visible = not Info1.Visible
    end)
    a0.WindowResize = v4.new(a0)
    if not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
        a0.WindowResize:Create()
    end

    a0.WindowResize:SetScale(a0.Params.Scale)
    local Options2 = a0.Instance:WaitForChild("Options")
    Button2 = Options2:WaitForChild("PickerMode")
    local v89 = Button2:GetChildren()
    for k11, k12 in pairs(v89) do
        if k12:IsA("Frame") then
            k12.Button.Activated:Connect(function() --[[ Upvalues: a0 (copy), k12 (copy) ]]
                a0:SetPickerMode(k12.Name)
            end)
        end
    end

    local Options3 = a0.Instance:WaitForChild("Options")
    Button2 = Options3:WaitForChild("History")
    local Undo1 = Button2:WaitForChild("Undo")
    local Button3 = Undo1:WaitForChild("Button")
    local Redo1 = Button2:WaitForChild("Redo")
    local Button4 = Redo1:WaitForChild("Button")

    local function _historyActionMouseDown(a0) --[[ Upvalues: a0 (copy), RunService (upvalue), UserInputService (upvalue) ]]
        a0:IncrementHistory(a0)
        local v93 = os.clock() + 0.5
        local v94 = nil
        v94 = RunService.Heartbeat:Connect(function() --[[ Upvalues: UserInputService (upvalue), v94 (ref), v93 (ref), a0 (upvalue), a0 (copy) ]]
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                v94:Disconnect()
                v94 = nil
                return
            end

            if v93 <= os.clock() then
                a0:IncrementHistory(a0)
                v93 = os.clock() + 0.1
            end

        end)
    end

    Button3.Activated:Connect(function() --[[ Upvalues: a0 (copy), RunService (upvalue), UserInputService (upvalue) ]]
        a0:IncrementHistory(-1)
        local v95 = os.clock() + 0.5
        local v96 = nil
        local v97 = -1
        v96 = RunService.Heartbeat:Connect(function() --[[ Upvalues: UserInputService (upvalue), v96 (ref), v95 (ref), a0 (upvalue), v97 (copy) ]]
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                v96:Disconnect()
                v96 = nil
                return
            end

            if v95 <= os.clock() then
                a0:IncrementHistory(v97)
                v95 = os.clock() + 0.1
            end

        end)
    end)
    Button4.Activated:Connect(function() --[[ Upvalues: a0 (copy), RunService (upvalue), UserInputService (upvalue) ]]
        a0:IncrementHistory(1)
        local v98 = os.clock() + 0.5
        local v99 = nil
        local v100 = 1
        v99 = RunService.Heartbeat:Connect(function() --[[ Upvalues: UserInputService (upvalue), v99 (ref), v98 (ref), a0 (upvalue), v100 (copy) ]]
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                v99:Disconnect()
                v99 = nil
                return
            end

            if v98 <= os.clock() then
                a0:IncrementHistory(v100)
                v98 = os.clock() + 0.1
            end

        end)
    end)
    local Options4 = a0.Instance:WaitForChild("Options")
    local Close = Options4:WaitForChild("Close")
    Close:WaitForChild("Button").Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        local v101 = a0:GetColor()
        a0._windowClosedEvent:Fire(v101)
    end)
    if a0.Params.EnableTransparency then
        local Right3 = a0.Instance:WaitForChild("Middle"):WaitForChild("Right")
        Button3 = Right3:WaitForChild("Color")
        local ImageLabel = Instance.new("ImageLabel")
        ImageLabel.Image = "rbxassetid://111137375763311"
        ImageLabel.ImageColor3 = Color3.new(1, 1, 1)
        ImageLabel.ImageTransparency = 0.5
        ImageLabel.ScaleType = Enum.ScaleType.Tile
        ImageLabel.TileSize = UDim2.fromOffset(14, 14)
        ImageLabel.ZIndex = -1
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Position = Button3.Position
        ImageLabel.Size = Button3.Size
        ImageLabel.Parent = Button3.Parent
        Button3 = Instance.new("UICorner")
        Button3.CornerRadius = UDim.new(0, 4)
        Button3.Parent = ImageLabel
    end
end

History._create = _create

local function _init(a0) --[[ Upvalues: PickerModes (copy) ]]
    a0:_create()
    a0._colorChangedEvent = Instance.new("BindableEvent")
    a0.ColorChanged = a0._colorChangedEvent.Event
    a0._windowClosedEvent = Instance.new("BindableEvent")
    a0.WindowClosed = a0._windowClosedEvent.Event
    a0.Sliders.Hue = PickerModes.Hue(a0)
    a0.Sliders.Saturation = PickerModes.Saturation(a0)
    a0.Sliders.Value = PickerModes.Value(a0)
    a0.Sliders.Red = PickerModes.Red(a0)
    a0.Sliders.Green = PickerModes.Green(a0)
    a0.Sliders.Blue = PickerModes.Blue(a0)
    if a0.Params.EnableTransparency then
        a0.Sliders.Transparency = PickerModes.Transparency(a0)
        a0.Sliders.Transparency:SetVisible(true)
    end

    a0:SetPickerMode(a0.Params.PickerMode)
    a0:SetColorSpace(a0.Params.ColorSpace)
    a0.Color.Hue = 0
    a0.Color.Saturation = 0
    a0.Color.Value = 1
    a0:_updateColorVisuals()
    a0:_updateSize()
    a0.Instance.Visible = true
end

History._init = _init

local function Destroy(a0)
    for k13, k14 in pairs(a0.Sliders) do
        k14:Destroy()
    end

    k14 = "_windowClosedEvent"
    local v105 = {
        "_colorChangedEvent",
        k14,
        "History",
        "_windowAdjust",
        "_pickerMouseMovement",
        "Instance",
        "WindowResize"
    }
    for k15, k16 in pairs(v105) do
        if k16 then
            a0[k16]:Destroy()
            a0[k16] = nil
        end
    end

    if a0.UI and a0._deleteUIOnClose then
        a0.UI:Destroy()
        a0.UI = nil
    end
end

History.Destroy = Destroy
return History
