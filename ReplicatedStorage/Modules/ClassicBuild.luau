
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local GamepadService = game:GetService("GamepadService")
local RunService = game:GetService("RunService")
local v1 = require(ReplicatedStorage.Modules.BaseObjectsLib)
local v2 = require(ReplicatedStorage.Modules.PaintController)
local v3 = require(ReplicatedStorage.Modules.ModernBuild)
local Preferences = v3.Preferences
local Catalogue = v3.Catalogue
local Categories = Catalogue.Categories
local t1 = {5, 15, 30, 45, 90}
v3 = {}
local v4 = setmetatable({}, {__mode = "k"})

local function make(a0, a1, a2)
    local v5 = Instance.new(a0)
    for k1, k2 in pairs(a1) do
        v5[k1] = k2
    end

    v5.Parent = a2
    return v5
end

local function clear(a0)
    local v9 = a0:GetChildren()
    for k3, k4 in ipairs(v9) do
        if k4:IsA("GuiObject") then
            k4:Destroy()
        end
    end
end

local function setText(a0, a1)
    if a0.Text ~= a1 then
        a0.Text = a1
    end
end

local function outline(a0)
    a0.BorderColor3 = Color3.new(1, 1, 1)
    a0.BorderSizePixel = 2
    a0.BorderMode = Enum.BorderMode.Inset
end

local function setPaused(a0, a1, a2) --[[ Upvalues: v4 (copy), GuiService (copy) ]]
    if a1 == a0.Paused then
        return
    end

    a0.Paused = a1
    if a1 then
        a2(a0)
        local CurrentCamera = workspace.CurrentCamera
        a0.MenuCamera = CurrentCamera
        a0.MenuCameraType = CurrentCamera.CameraType
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        if a0.Controls then
            CurrentCamera = v4[a0.Controls]
            if CurrentCamera then
                CurrentCamera.Connection:Disconnect()
                v4[a0.Controls] = nil
                a0.DisabledControls = true
            else
                if a0.Controls.controlsEnabled ~= false then
                    a0.Controls:Disable()
                    a0.DisabledControls = true
                end
            end
        end

        a0.Client.Player:Move(Vector3.new(0, 0, 0), false)
        return
    end

    if a0.MenuCamera then
        local MenuCamera = a0.MenuCamera
        a0.MenuCamera = nil
        if MenuCamera.Parent then
            if MenuCamera.CameraType == Enum.CameraType.Scriptable then
                local v13 = a0.MenuCameraType or Enum.CameraType.Custom
                MenuCamera.CameraType = v13
            end
        end

        a0.MenuCameraType = nil
        if a0.DisabledControls then
            a0.DisabledControls = nil
            MenuCamera = a0.Controls
            if GuiService.MenuIsOpen then
                local v14 = {}
                v4[MenuCamera] = v14
                v14.Connection = GuiService.MenuClosed:Once(function() --[[ Upvalues: v4 (upvalue), MenuCamera (copy), v14 (copy) ]]
                    local v15 = v4[MenuCamera]
                    if v15 == v14 then
                        v4[MenuCamera] = nil
                        MenuCamera:Enable()
                    end

                end)
                return
            end

            MenuCamera:Enable()
        end
    end
end

local function raycastAim(a0, a1, a2)
    local t2 = {a1}
    if a0.Character then
        table.insert(t2, a0.Character)
    end

    if a0.EditObject then
        table.insert(t2, a0.EditObject)
    end

    if a0.EditingExistingObject then
        table.insert(t2, a0.EditingExistingObject)
    end

    local v16 = RaycastParams.new()
    v16.FilterType = Enum.RaycastFilterType.Exclude
    v16.IgnoreWater = true
    for i1 = 1, 32 do
        v16.FilterDescendantsInstances = t2
        local v19 = a2.Direction * 500
        local v20 = workspace:Raycast(a2.Origin, v19, v16)
        if not v20 then
            return nil, nil
        end

        local Instance = v20.Instance
        if Instance:IsA("BasePart") then
            if 1 > Instance.Transparency then
                if 1 > Instance.LocalTransparencyModifier then
                    -- jump to 97
                end
            end

            table.insert(t2, Instance)
        else
            local v21 = CFrame.new(v20.Position)
            return v21, Instance
        end
    end

    return nil, nil
end

local function getDeleteTarget(a0)
    local v22 = a0.Client:GetPlacedBuildObjectAtScreenPosition(workspace.CurrentCamera.ViewportSize / 2)
    return v22
end

local function loadCataloguePreferences(a0) --[[ Upvalues: Preferences (copy) ]]
    local Data = a0.Data
    if not Data then
        Data = {}
    end

    a0.Data = Data
    local v23 = a0.ModernBuildFavorites or a0.Data.ModernBuildFavorites
    a0.ModernBuildFavorites = Preferences.Favorites(v23)
    local v24 = a0.ModernBuildRecents or a0.Data.ModernBuildRecents
    a0.ModernBuildRecents = Preferences.Recents(v24)
    a0.Data.ModernBuildFavorites = table.clone(a0.ModernBuildFavorites)
    a0.Data.ModernBuildRecents = table.clone(a0.ModernBuildRecents)
end

local function rememberObject(a0, a1, a2) --[[ Upvalues: Preferences (copy) ]]
    if not Preferences.IsValidName(a2) then
        return
    end

    if a0.ModernBuildRecents[1] == a2 then
        return
    end

    local v25 = table.clone(a0.ModernBuildRecents)
    for i2 = #v25, 1, -1 do
        if v25[i2] == a2 then
            table.remove(v25, i2)
        end
    end

    table.insert(v25, 1, a2)
    while Preferences.MAX_RECENTS < #v25 do
        table.remove(v25)
    end

    a0.ModernBuildRecents = v25
    a0.Data.ModernBuildRecents = table.clone(v25)
    a1:FireServer("RememberModernBuildObject", a2)
end

local function setFavorites(a0, a1, a2) --[[ Upvalues: Preferences (copy) ]]
    local ModernBuildFavorites2 = a0.ModernBuildFavorites
    local v28 = Preferences.Favorites(a2)
    a0.ModernBuildFavorites = v28
    a0.Data.ModernBuildFavorites = table.clone(v28)
    for k5 in pairs(ModernBuildFavorites2) do
        if not v28[k5] then
            a1:FireServer("ChangeModernBuildFavorite", k5, false)
        end
    end

    for k6 in pairs(v28) do
        if not ModernBuildFavorites2[k6] then
            a1:FireServer("ChangeModernBuildFavorite", k6, true)
        end
    end
end

local function saveAndHide(a0, a1)
    if not (a1 and a1:IsA("GuiObject")) then
        return
    end

    if a0.Hidden[a1] == nil then
        a0.Hidden[a1] = a1.Visible
    end

    a1.Visible = false
end

local function exit(a0)
    if a0.Client.EditingBase then
        a0.Client:StopEditStorage()
        return
    end

    if a0.Client.Painting then
        a0.Client:ClosePaintFrames()
        return
    end

    a0.Client:EndBuildMode()
end

local function createThumbnail(a0, a1, a2, a3) --[[ Upvalues: Catalogue (copy) ]]
    local CreateThumbnail = Catalogue.CreateThumbnail
    local v36
    if not (a3 and UDim2.new(1, -12, 0, a0.CardHeight - 68)) then
        local v37 = UDim2.new(1, -16, 0, 100)
    end

    local v38
    if a3 then
        v38 = 6
    else
        v38 = 8
    end

    local v39 = UDim2.fromOffset(v38, 4)
    if a3 then
        v38 = 1.5
    else
        v38 = 2.09
    end

    local v40
    if a3 then
        v40 = 2
    else
        v40 = 1
    end

    CreateThumbnail(a0, a1, a2, v36, v39, v38, v40, {Active = false})
end

local v41 = {}
v41.__index = v41
local v42 = {
    {Name = "PaintBrush", Image = "rbxassetid://104826770606433"},
    {Name = "PaintBucket", Image = "rbxassetid://122698818539369"}
}
local v43 = nil

local function label(a0, a1, a2, a3, a4, a5) --[[ Upvalues: v43 (copy) ]]
    local t3 = {
        BackgroundTransparency = 1,
        Size = a2,
        Position = a3,
        Text = a1,
        TextSize = a4 or 20,
        Font = Enum.Font.Code
    }
    local v45 = a5 or v43.Text
    t3.TextColor3 = v45
    t3.TextXAlignment = Enum.TextXAlignment.Left
    t3.TextYAlignment = Enum.TextYAlignment.Center
    t3.TextTruncate = Enum.TextTruncate.AtEnd
    local TextLabel = Instance.new("TextLabel")
    for k7, k8 in pairs(t3) do
        TextLabel[k7] = k8
    end

    TextLabel.Parent = a0
    return TextLabel
end

local function sameValues(a0, a1)
    for k9, k10 in pairs(a0) do
        if a1[k9] ~= k10 then
            return false
        end
    end

    for k11, k12 in pairs(a1) do
        if a0[k11] ~= k12 then
            return false
        end
    end

    return true
end

local function keyName(a0, a1) --[[ Upvalues: UserInputService (copy) ]]
    local v56, v57 = pcall(function() --[[ Upvalues: UserInputService (upvalue), a0 (copy) ]]
        local v55 = UserInputService:GetStringForKeyCode(a0)
        return v55
    end)
    if v56 then
        v57 = ({ButtonCross = "Cross", ButtonCircle = "Circle", ButtonSquare = "Square", ButtonTriangle = "Triangle", ButtonLB = "LB", ButtonRB = "RB", ButtonLT = "LT", ButtonRT = "RT", ButtonL1 = "L1", ButtonR1 = "R1", ButtonL2 = "L2", ButtonR2 = "R2"})[v57] or v57
    end

    return v56 and v57 ~= "" and v57 ~= a0.Name and v57 or a1
end

local function _button(a0, a1, a2, a3, a4, a5, a6) --[[ Upvalues: v43 (copy) ]]
    local v60 = {
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        TextSize = 20,
        Selectable = true,
        Active = true,
        Name = a2,
        Text = a3,
        Size = a4,
        Position = a5,
        BackgroundColor3 = v43.Card,
        TextColor3 = v43.Text,
        Font = Enum.Font.Code
    }
    local TextButton = Instance.new("TextButton")
    for k13, k14 in pairs(v60) do
        TextButton[k13] = k14
    end

    TextButton.Parent = a1
    TextButton.BorderColor3 = Color3.new(1, 1, 1)
    TextButton.BorderSizePixel = 2
    TextButton.BorderMode = Enum.BorderMode.Inset
    local v64 = TextButton:GetAttributeChangedSignal("CurrentTab")
    v64:Connect(function() --[[ Upvalues: TextButton (copy) ]]
        local v65 = TextButton
        local v66
        if TextButton:GetAttribute("CurrentTab") then
            v66 = 3
        else
            v66 = 2
        end

        v65.BorderSizePixel = v66
    end)
    local v67 = {
        Thickness = 3,
        Transparency = 1,
        Color = v43.Accent,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }
    local UIStroke = Instance.new("UIStroke")
    for k15, k16 in pairs(v67) do
        UIStroke[k15] = k16
    end

    UIStroke.Parent = TextButton
    TextButton.SelectionImageObject = a0.SelectionImage
    TextButton.SelectionGained:Connect(function() --[[ Upvalues: UIStroke (copy), TextButton (copy), v43 (upvalue), a0 (copy) ]]
        UIStroke.Transparency = 0
        TextButton.BackgroundColor3 = v43.Selected
        a0.LastFocus = TextButton
        a0:_scrollTo(TextButton)
        a0:_updateFavoriteHint(TextButton)
    end)
    TextButton.SelectionLost:Connect(function() --[[ Upvalues: UIStroke (copy), TextButton (copy), v43 (upvalue) ]]
        UIStroke.Transparency = 1
        local v71 = TextButton
        local v72
        if not (TextButton:GetAttribute("CurrentTab") and v43.Selected) then
            v72 = v43.Card
        end

        v71.BackgroundColor3 = v72
    end)
    TextButton.Activated:Connect(function() --[[ Upvalues: a0 (copy), a6 (copy) ]]
        if a0.Active and a0.MenuOpen then
            a6()
        end

    end)
    return TextButton
end

v43 = {
    Panel = Color3.fromRGB(0, 0, 0),
    Card = Color3.fromRGB(0, 0, 0),
    Selected = Color3.fromRGB(0, 0, 0),
    Accent = Color3.fromRGB(255, 255, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Muted = Color3.fromRGB(200, 200, 200),
    Danger = Color3.fromRGB(255, 139, 139),
    Line = Color3.fromRGB(255, 255, 255)
}
v41._button = _button

local function _scrollTo(a0, a1)
    local Parent = a1.Parent
    if not (Parent and Parent:IsA("ScrollingFrame")) then
        return
    end

    local v73 = a1.AbsolutePosition - Parent.AbsolutePosition
    local CanvasPosition = Parent.CanvasPosition
    local Scale = a0.MenuScale.Scale
    if Parent.ScrollingDirection == Enum.ScrollingDirection.X then
        local v74
        if not (v73.X < 0 and v73.X) then
            local v75 = v73.X + a1.AbsoluteSize.X
            local v76 = math.max(0, v75 - Parent.AbsoluteSize.X)
        end

        local v77 = math.max(0, CanvasPosition.X + v74 / Scale)
        Parent.CanvasPosition = Vector2.new(v77, CanvasPosition.Y)
        return
    end

    local v78
    if not (v73.Y < 0 and v73.Y) then
        local v79 = v73.Y + a1.AbsoluteSize.Y
        local v80 = math.max(0, v79 - Parent.AbsoluteSize.Y)
    end

    Parent.CanvasPosition = Vector2.new(CanvasPosition.X, math.max(0, CanvasPosition.Y + v78 / Scale))
end

v41._scrollTo = _scrollTo

local function _glyph(a0, a1, a2, a3, a4, a5, a6) --[[ Upvalues: UserInputService (copy), label (copy), keyName (copy), v43 (copy) ]]
    local v81 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(a6, 34),
        Position = UDim2.fromOffset(a5, 0)
    }
    local Frame = Instance.new("Frame")
    for k17, k18 in pairs(v81) do
        Frame[k17] = k18
    end

    Frame.Parent = a1
    local v86, v87 = pcall(function() --[[ Upvalues: UserInputService (upvalue), a2 (copy) ]]
        local v85 = UserInputService:GetImageForKeyCode(a2)
        return v85
    end)
    if v86 and v87 ~= "" then
        local v88 = {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(30, 30),
            Position = UDim2.fromOffset(0, 2),
            Image = v87
        }
        local ImageLabel = Instance.new("ImageLabel")
        for k19, k20 in pairs(v88) do
            ImageLabel[k19] = k20
        end

        ImageLabel.Parent = Frame
    else
        local v92 = keyName(a2, a3)
        local v93 = UDim2.fromOffset(36, 30)
        local v94 = UDim2.fromOffset(0, 2)
        local v95 = label(Frame, v92, v93, v94, 14, v43.Accent)
        v95.TextXAlignment = Enum.TextXAlignment.Center
    end

    local v96 = UDim2.fromOffset(a6 - 36, 34)
    local v97 = UDim2.fromOffset(36, 0)
    return label(Frame, a4, v96, v97, 17)
end

v41._glyph = _glyph

local function _createPaintTools(a0) --[[ Upvalues: label (copy), v43 (copy), v42 (copy) ]]
    local v98 = {
        Name = "PaintTools",
        BackgroundTransparency = 1,
        Visible = false,
        Size = UDim2.fromOffset(108, 48),
        Position = UDim2.fromOffset(24, 12)
    }
    local HUD = a0.HUD
    local Frame1 = Instance.new("Frame")
    for k21, k22 in pairs(v98) do
        Frame1[k21] = k22
    end

    Frame1.Parent = HUD
    a0.PaintTools = Frame1
    v98 = {
        Name = "CurrentPaintColor",
        BackgroundTransparency = 1,
        Visible = false,
        Size = UDim2.fromOffset(360, 48),
        Position = UDim2.fromOffset(696, 12)
    }
    local HUD1 = a0.HUD
    Frame1 = Instance.new("Frame")
    for k23, k24 in pairs(v98) do
        Frame1[k23] = k24
    end

    Frame1.Parent = HUD1
    a0.PaintColorIndicator = Frame1
    local v105 = UDim2.fromOffset(294, 22)
    local v106 = label(a0.PaintColorIndicator, "CURRENT COLOUR", v105, UDim2.new(), 16, v43.Muted)
    v106.TextXAlignment = Enum.TextXAlignment.Right
    local v107 = {
        Name = "Swatch",
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Active = false,
        Selectable = false,
        Size = UDim2.fromOffset(48, 48),
        Position = UDim2.fromOffset(312, 0),
        BackgroundColor3 = v43.Text
    }
    local PaintColorIndicator = a0.PaintColorIndicator
    local Frame2 = Instance.new("Frame")
    for k25, k26 in pairs(v107) do
        Frame2[k25] = k26
    end

    Frame2.Parent = PaintColorIndicator
    a0.PaintColorSwatch = Frame2
    Frame2 = {Thickness = 2, Color = v43.Accent, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}
    local PaintColorSwatch = a0.PaintColorSwatch
    v106 = Instance.new("UIStroke")
    for k27, k28 in pairs(Frame2) do
        v106[k27] = k28
    end

    v106.Parent = PaintColorSwatch
    a0.PaintToolIcons = {}
    local v114 = a0.Client.HUD and a0.Client.HUD:FindFirstChild("PaintEditBar")
    for k29, k30 in ipairs(v42) do
        local v121 = v114 and v114:FindFirstChild(k30.Name)
        local v122 = (k29 - 1) * 60
        local v123 = {
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Active = false,
            Selectable = false,
            Name = k30.Name,
            Image = k30.Image,
            Size = UDim2.fromOffset(48, 48),
            Position = UDim2.fromOffset(v122, 0),
            BackgroundColor3 = v43.Card,
            ImageColor3 = v43.Text
        }
        local PaintTools = a0.PaintTools
        local ImageLabel1 = Instance.new("ImageLabel")
        for k31, k32 in pairs(v123) do
            ImageLabel1[k31] = k32
        end

        ImageLabel1.Parent = PaintTools
        local v127
        if v121 then
            if v121:IsA("ImageLabel") or v121:IsA("ImageButton") then
                v127 = "ImageColor3"
                k31 = "ImageTransparency"
                k32 = "ImageRectOffset"
                local v128 = {
                    "Image",
                    v127,
                    k31,
                    k32,
                    "ImageRectSize",
                    "ScaleType",
                    "SliceCenter",
                    "SliceScale",
                    "ResampleMode"
                }
                for k33, k34 in ipairs(v128) do
                    k31 = v121[k34]
                    ImageLabel1[k34] = k31
                end
            end
        end

        v123 = {
            Thickness = 1,
            Color = v43.Accent,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }
        v121 = Instance.new("UIStroke")
        for k35, k36 in pairs(v123) do
            v121[k35] = k36
        end

        v121.Parent = ImageLabel1
        a0.PaintToolIcons[k30.Name] = ImageLabel1
    end
end

v41._createPaintTools = _createPaintTools

local function _updatePaintTools(a0, a1, a2)
    local itemName = a2.itemName
    if not a0.PaintToolIcons[itemName] then
        itemName = a2.paintTool
    end

    if not a0.PaintToolIcons[itemName] then
        itemName = "PaintBrush"
    end

    a0.PaintTools.Visible = a1
    a0.PaintColorIndicator.Visible = a1
    if typeof(a2.paintColor) == "Color3" then
        a0.PaintColorSwatch.BackgroundColor3 = a2.paintColor
    end

    for k37, k38 in pairs(a0.PaintToolIcons) do
        local v138 = k37 == itemName
        k38:SetAttribute("Selected", v138)
        local v139
        if v138 then
            v139 = 3
        else
            v139 = 1
        end

        k38.UIStroke.Thickness = v139
    end

    if a0.PaintLayout ~= a1 then
        a0.PaintLayout = a1
        local v140
        if a1 then
            v140 = 24
        else
            v140 = 0
        end

        a0.HUD.Size = UDim2.fromOffset(1080, 158 + v140)
        local ItemLabel = a0.ItemLabel
        local v141
        if a1 then
            v141 = 152
        else
            v141 = 24
        end

        local v142
        if a1 then
            v142 = 25
        else
            v142 = 13
        end

        ItemLabel.Position = UDim2.fromOffset(v141, v142)
        ItemLabel = a0.ItemLabel
        if a1 then
            v141 = 522
        else
            v141 = 650
        end

        ItemLabel.Size = UDim2.fromOffset(v141, 30)
        ItemLabel = a0.AxisLabel
        if a1 then
            v142 = 36
        else
            v142 = 13
        end

        ItemLabel.Position = UDim2.fromOffset(696, 30)
        ItemLabel = a0.AxisLabel
        if a1 then
            v141 = 294
        else
            v141 = 360
        end

        if a1 then
            v142 = 24
        else
            v142 = 30
        end

        ItemLabel.Size = UDim2.fromOffset(696, 30)
        a0.StatusLabel.Position = UDim2.fromOffset(24, 47 + v140)
        a0.HintRow.Position = UDim2.fromOffset(24, 79 + v140)
        a0.SecondaryLabel.Position = UDim2.fromOffset(24, 119 + v140)
    end

    return itemName
end

v41._updatePaintTools = _updatePaintTools

local function new(a0, a1) --[[ Upvalues: Preferences (copy), keyName (copy), v41 (copy), v43 (copy), label (copy), Categories (copy) ]]
    local v143 = {
        Active = false,
        MenuOpen = false,
        MenuKind = nil,
        Category = "Furniture",
        SubCategory = "All",
        Client = a0
    }
    local v144 = a1
    if not v144 then
        v144 = {}
    end

    v143.Callbacks = v144
    v143.Memory = {}
    v143.Connections = {}
    v143.State = {}
    v143.Cards = {}
    v143.ThumbnailItems = {}
    local v145 = a0.Data and a0.Data.ModernBuildFavorites
    v143.Favorites = Preferences.Favorites(v145)
    local v146 = a0.Data and a0.Data.ModernBuildRecents
    v143.Recents = Preferences.Recents(v146)
    v143.SubButtons = {}
    v143.CategoryButtons = {}
    v143.ActionKey = keyName(Enum.KeyCode.ButtonA, "A")
    v143.JumpKey = keyName(Enum.KeyCode.ButtonR1, "RB")
    local v147 = setmetatable(v143, v41)
    local v148 = {
        Name = "ClassicBuildControllerUI",
        Enabled = false,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 40,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }
    local PlayerGui = a0.Player:WaitForChild("PlayerGui")
    v143 = Instance.new("ScreenGui")
    for k39, k40 in pairs(v148) do
        v143[k39] = k40
    end

    v143.Parent = PlayerGui
    v147.Gui = v143
    v148 = {Name = "Root", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)}
    local Gui = v147.Gui
    v143 = Instance.new("Frame")
    for k41, k42 in pairs(v148) do
        v143[k41] = k42
    end

    v143.Parent = Gui
    v147.Root = v143
    v148 = {Name = "SelectionOutline", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)}
    local Gui1 = v147.Gui
    v143 = Instance.new("Frame")
    for k43, k44 in pairs(v148) do
        v143[k43] = k44
    end

    v143.Parent = Gui1
    v147.SelectionImage = v143
    v148 = {
        Name = "Aim",
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(7, 7),
        BackgroundColor3 = v43.Text
    }
    local Root = v147.Root
    v143 = Instance.new("Frame")
    for k45, k46 in pairs(v148) do
        v143[k45] = k46
    end

    v143.Parent = Root
    v147.Reticle = v143
    v143 = {Thickness = 2, Color = v43.Panel}
    local Reticle = v147.Reticle
    local UIStroke1 = Instance.new("UIStroke")
    for k47, k48 in pairs(v143) do
        UIStroke1[k47] = k48
    end

    UIStroke1.Parent = Reticle
    k47 = 0
    Reticle = {
        Name = "BuildHints",
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 0.96, k47),
        Size = UDim2.fromOffset(1080, 158),
        BackgroundColor3 = v43.Panel
    }
    local Root1 = v147.Root
    v143 = Instance.new("Frame")
    for k49, k50 in pairs(Reticle) do
        v143[k49] = k50
    end

    v143.Parent = Root1
    v147.HUD = v143
    v143 = v147.HUD
    v143.BorderColor3 = Color3.new(1, 1, 1)
    v143.BorderSizePixel = 2
    v143.BorderMode = Enum.BorderMode.Inset
    local HUD3 = v147.HUD
    v143 = Instance.new("UIScale")
    for k51, k52 in pairs({Scale = 1}) do
        v143[k51] = k52
    end

    v143.Parent = HUD3
    v147.HUDScale = v143
    v147:_createPaintTools()
    local v170 = UDim2.fromOffset(650, 30)
    local v171 = UDim2.fromOffset(24, 13)
    v147.ItemLabel = label(v147.HUD, "CLASSIC BUILD", v170, v171, 23)
    local v172 = UDim2.fromOffset(360, 30)
    local v173 = UDim2.fromOffset(696, 13)
    v147.AxisLabel = label(v147.HUD, "TURN (Y)  /  90\194\176", v172, v173, 19, v43.Accent)
    v147.AxisLabel.TextXAlignment = Enum.TextXAlignment.Right
    local v174 = UDim2.fromOffset(1032, 24)
    local v175 = UDim2.fromOffset(24, 47)
    local Muted = v43.Muted
    v147.StatusLabel = label(v147.HUD, "Aim at a surface to build", v174, v175, 17, Muted)
    local v176 = {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(24, 79),
        Size = UDim2.fromOffset(1032, 34)
    }
    local HUD4 = v147.HUD
    local Frame3 = Instance.new("Frame")
    for k53, k54 in pairs(v176) do
        Frame3[k53] = k54
    end

    Frame3.Parent = HUD4
    v147.HintRow = Frame3
    v147.ActionHint = v147:_glyph(Frame3, Enum.KeyCode.ButtonA, "A", "Place", 0, 150)
    v147.RotateLeftHint = v147:_glyph(Frame3, Enum.KeyCode.ButtonL2, "LT", "Rotate \226\136\146", 150, 150)
    v147.RotateRightHint = v147:_glyph(Frame3, Enum.KeyCode.ButtonR2, "RT", "Rotate +", 300, 150)
    v147.PrecisionHint = v147:_glyph(Frame3, Enum.KeyCode.ButtonL1, "LB", "Hold precision", 450, 190)
    v147.AxisHint = v147:_glyph(Frame3, Enum.KeyCode.ButtonX, "X", "Axis", 640, 95)
    v147.MenuHint = v147:_glyph(Frame3, Enum.KeyCode.ButtonY, "Y", "Catalogue", 735, 160)
    local v180 = 137
    v147.CancelHint = v147:_glyph(Frame3, Enum.KeyCode.ButtonB, "B", "Cancel", 895, v180)
    local v181 = "D-pad \226\134\144 Undo / \226\134\146 Redo     \226\134\147 Delete     \226\134\145 Options     " .. v147.JumpKey .. " Jump     L3 Sprint / R3 Crouch"
    local v182 = UDim2.fromOffset(1032, 26)
    local v183 = UDim2.fromOffset(24, 119)
    local Muted1 = v43.Muted
    v147.SecondaryLabel = label(v147.HUD, v181, v182, v183, 16, Muted1)
    local v184 = {
        Name = "MenuOverlay",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        Active = true,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new()
    }
    local Root2 = v147.Root
    local Frame4 = Instance.new("Frame")
    for k55, k56 in pairs(v184) do
        Frame4[k55] = k56
    end

    Frame4.Parent = Root2
    v147.Dimmer = Frame4
    v184 = {
        Name = "Menu",
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        SelectionGroup = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(1000, 640),
        BackgroundColor3 = v43.Panel,
        SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
        SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
        SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
        SelectionBehaviorRight = Enum.SelectionBehavior.Stop
    }
    local Dimmer = v147.Dimmer
    Frame4 = Instance.new("Frame")
    for k57, k58 in pairs(v184) do
        Frame4[k57] = k58
    end

    Frame4.Parent = Dimmer
    v147.Menu = Frame4
    Frame4 = v147.Menu
    Frame4.BorderColor3 = Color3.new(1, 1, 1)
    Frame4.BorderSizePixel = 2
    Frame4.BorderMode = Enum.BorderMode.Inset
    local Menu = v147.Menu
    Frame4 = Instance.new("UIScale")
    for k59, k60 in pairs({Scale = 1}) do
        Frame4[k59] = k60
    end

    Frame4.Parent = Menu
    v147.MenuScale = Frame4
    local v194 = UDim2.fromOffset(664, 34)
    local v195 = UDim2.fromOffset(26, 19)
    v147.Title = label(v147.Menu, "OBJECT CATALOGUE", v194, v195, 27)
    local v196 = UDim2.fromOffset(664, 25)
    local v197 = UDim2.fromOffset(26, 54)
    v147.Subtitle = label(v147.Menu, "Choose an object, then keep moving while you build.", v196, v197, 17, v43.Muted)
    local v198 = UDim2.fromOffset(150, 44)
    local v199 = UDim2.fromOffset(704, 24)
    v147.PaintModeButton = v147:_button(v147.Menu, "PaintMode", "Paint mode", v198, v199, function() --[[ Upvalues: v147 (copy) ]]
        if v147.Callbacks.Option then
            v147.Callbacks.Option("PaintMode")
        end

    end)
    local v200 = UDim2.fromOffset(110, 44)
    local v201 = UDim2.fromOffset(864, 24)

    local function v202() --[[ Upvalues: v147 (copy) ]]
        if v147.Callbacks.Close then
            v147.Callbacks.Close()
            return
        end

        v147:CloseMenu()
    end

    v147.CloseButton = v147:_button(v147.Menu, "Close", "Close", v200, v201, v202)
    local v203 = {
        Name = "Catalogue",
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(948, 500),
        Position = UDim2.fromOffset(26, 92)
    }
    local Menu1 = v147.Menu
    local Frame5 = Instance.new("Frame")
    for k61, k62 in pairs(v203) do
        Frame5[k61] = k62
    end

    Frame5.Parent = Menu1
    v147.Catalogue = Frame5
    for k63, k64 in ipairs(Categories) do
        local v210 = UDim2.fromOffset(184, 42)
        local v211 = (k63 - 1) * 191
        local v212 = UDim2.fromOffset(v211, 0)
        v147.CategoryButtons[k63] = v147:_button(v147.Catalogue, k64, k64, v210, v212, function() --[[ Upvalues: v147 (copy), k64 (copy) ]]
            v147:_selectCategory(k64)
        end)
        local v213 = v147.CategoryButtons[k63]
        local v214 = 18
        v213.TextSize = v214
    end

    local v215 = {
        Name = "Subcategories",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        Position = UDim2.fromOffset(0, 52),
        Size = UDim2.fromOffset(948, 46),
        ScrollingDirection = Enum.ScrollingDirection.X,
        ScrollBarImageColor3 = v43.Accent,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.X
    }
    local Catalogue1 = v147.Catalogue
    local ScrollingFrame = Instance.new("ScrollingFrame")
    for k65, k66 in pairs(v215) do
        ScrollingFrame[k65] = k66
    end

    ScrollingFrame.Parent = Catalogue1
    v147.SubList = ScrollingFrame
    ScrollingFrame = {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }
    local SubList = v147.SubList
    Frame3 = Instance.new("UIListLayout")
    for k67, k68 in pairs(ScrollingFrame) do
        Frame3[k67] = k68
    end

    Frame3.Parent = SubList
    SubList = {
        Name = "Items",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 5,
        Position = UDim2.fromOffset(0, 108),
        Size = UDim2.fromOffset(948, 388),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarImageColor3 = v43.Accent,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    }
    local Catalogue2 = v147.Catalogue
    ScrollingFrame = Instance.new("ScrollingFrame")
    for k69, k70 in pairs(SubList) do
        ScrollingFrame[k69] = k70
    end

    ScrollingFrame.Parent = Catalogue2
    v147.ItemList = ScrollingFrame
    ScrollingFrame = {
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 4)
    }
    local ItemList = v147.ItemList
    local UIPadding = Instance.new("UIPadding")
    for k71, k72 in pairs(ScrollingFrame) do
        UIPadding[k71] = k72
    end

    UIPadding.Parent = ItemList
    ScrollingFrame = {
        FillDirectionMaxCells = 4,
        CellSize = UDim2.fromOffset(225, 174),
        CellPadding = UDim2.fromOffset(10, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }
    local ItemList1 = v147.ItemList
    local UIGridLayout = Instance.new("UIGridLayout")
    for k73, k74 in pairs(ScrollingFrame) do
        UIGridLayout[k73] = k74
    end

    UIGridLayout.Parent = ItemList1
    local v231 = UDim2.fromOffset(900, 60)
    local v232 = UDim2.fromOffset(24, 190)
    local Muted2 = v43.Muted
    v147.Empty = label(v147.Catalogue, "No unlocked objects in this category.", v231, v232, 22, Muted2)
    v147.Empty.Visible = false
    local v233 = {
        Name = "Options",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 5,
        Visible = false,
        Position = UDim2.fromOffset(26, 100),
        Size = UDim2.fromOffset(948, 482),
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarImageColor3 = v43.Line
    }
    local Menu2 = v147.Menu
    local ScrollingFrame1 = Instance.new("ScrollingFrame")
    for k75, k76 in pairs(v233) do
        ScrollingFrame1[k75] = k76
    end

    ScrollingFrame1.Parent = Menu2
    v147.Options = ScrollingFrame1
    ScrollingFrame1 = {
        FillDirectionMaxCells = 2,
        CellSize = UDim2.fromOffset(462, 78),
        CellPadding = UDim2.fromOffset(14, 14),
        SortOrder = Enum.SortOrder.LayoutOrder
    }
    local Options = v147.Options
    local UIGridLayout1 = Instance.new("UIGridLayout")
    for k77, k78 in pairs(ScrollingFrame1) do
        UIGridLayout1[k77] = k78
    end

    UIGridLayout1.Parent = Options
    Options = {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(26, 601),
        Size = UDim2.fromOffset(948, 30)
    }
    local Menu3 = v147.Menu
    ScrollingFrame1 = Instance.new("Frame")
    for k79, k80 in pairs(Options) do
        ScrollingFrame1[k79] = k80
    end

    ScrollingFrame1.Parent = Menu3
    v147:_glyph(ScrollingFrame1, Enum.KeyCode.ButtonA, "A", "Select", 0, 130)
    v147.BackHint = v147:_glyph(ScrollingFrame1, Enum.KeyCode.ButtonB, "B", "Back", 130, 200)
    v147.FavoriteHint = v147:_glyph(ScrollingFrame1, Enum.KeyCode.ButtonX, "X", "Favorite", 330, 200)
    v147.CategoryLeftHint = v147:_glyph(ScrollingFrame1, Enum.KeyCode.ButtonL1, "LB", "Category \226\136\146", 530, 195)
    v147.CategoryRightHint = v147:_glyph(ScrollingFrame1, Enum.KeyCode.ButtonR1, "RB", "Category +", 725, 223)
    v147:_resize()
    local v243 = v147.Root:GetPropertyChangedSignal("AbsoluteSize")
    local v244 = v243:Connect(function() --[[ Upvalues: v147 (copy) ]]
        v147:_resize()
    end)
    table.insert(v147.Connections, v244)
    local v245 = v147.ItemList:GetPropertyChangedSignal("CanvasPosition")
    local v246 = v245:Connect(function() --[[ Upvalues: v147 (copy) ]]
        v147:_queueThumbnails()
    end)
    table.insert(v147.Connections, v246)
    return v147
end

v41.new = new

local function _resize(a0)
    local AbsoluteSize = a0.Root.AbsoluteSize
    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return
    end

    local v247 = AbsoluteSize.X * 0.9 / 1000
    local v248 = AbsoluteSize.Y * 0.84 / 640
    a0.MenuScale.Scale = math.min(v247, v248, 1.5)
    v247 = AbsoluteSize.X * 0.92 / 1080
    local v249 = AbsoluteSize.Y / 620
    a0.HUDScale.Scale = math.min(v247, v249, 1.5)
    a0:_queueThumbnails()
end

v41._resize = _resize

local function Owns(a0, a1)
    local v250 = false
    if a1 ~= nil then
        local v251 = a1:IsDescendantOf(a0.Gui)
    end

    return v250
end

v41.Owns = Owns

local function _remember(a0) --[[ Upvalues: GuiService (copy) ]]
    if a0.MenuKind ~= "Catalogue" then
        return
    end

    local v252 = a0.Category .. "/" .. a0.SubCategory
    local SelectedObject = GuiService.SelectedObject
    local v253 = a0.Memory[v252]
    if not v253 then
        v253 = {}
    end

    local Memory = a0.Memory
    local t4 = {}
    local v255 = a0:Owns(SelectedObject) and SelectedObject:GetAttribute("ItemName") or v253.Item
    t4.Item = v255
    t4.Scroll = a0.ItemList.CanvasPosition
    t4.SubScroll = a0.SubList.CanvasPosition
    Memory[v252] = t4
end

v41._remember = _remember

local function _selectCategory(a0, a1)
    a0:_remember()
    a0.Category = a1
    a0.SubCategory = a0.Memory[a1 .. "/SubCategory"] or "All"
    a0:RefreshCatalogue()
    if a0.Callbacks.CategoryChanged then
        a0.Callbacks.CategoryChanged(a1)
    end
end

v41._selectCategory = _selectCategory

local function _updateFavoriteHint(a0, a1) --[[ Upvalues: v43 (copy) ]]
    if not a0.FavoriteHint then
        return
    end

    local v258 = a1 and a1:GetAttribute("ItemName")
    local FavoriteHint = a0.FavoriteHint
    local v259
    if v258 and a0.Favorites[v258] then
        v259 = "Unfavorite"
    else
        v259 = "Favorite"
    end

    if FavoriteHint.Text ~= v259 then
        FavoriteHint.Text = v259
    end

    local v260
    if not (v258 and v43.Text) then
        v260 = v43.Muted
    end

    a0.FavoriteHint.TextColor3 = v260
end

v41._updateFavoriteHint = _updateFavoriteHint

local function ToggleFocusedFavorite(a0) --[[ Upvalues: GuiService (copy), Preferences (copy) ]]
    if not a0.Active or not a0.MenuOpen or a0.MenuKind ~= "Catalogue" then
        return false
    end

    local SelectedObject1 = GuiService.SelectedObject
    if not SelectedObject1 or SelectedObject1.Parent ~= a0.ItemList then
        return false
    end

    local v261 = SelectedObject1:GetAttribute("ItemName")
    if not Preferences.IsValidName(v261) then
        return false
    end

    a0.Favorites[v261] = not a0.Favorites[v261] or nil
    if a0.Callbacks.FavoritesChanged then
        local v262 = table.clone(a0.Favorites)
        a0.Callbacks.FavoritesChanged(v262)
    end

    if a0.Category == "Favorites" then
        a0:RefreshCatalogue()
    else
        local Favorite = SelectedObject1:FindFirstChild("Favorite")
        if Favorite then
            local v263
            if a0.Favorites[v261] then
                v263 = "\226\152\133"
            else
                v263 = "\226\152\134"
            end

            if Favorite.Text ~= v263 then
                Favorite.Text = v263
            end
        end

        a0:_updateFavoriteHint(SelectedObject1)
    end

    return true
end

v41.ToggleFocusedFavorite = ToggleFocusedFavorite

local function _thumbnail(a0, a1, a2, a3) --[[ Upvalues: createThumbnail (copy) ]]
    createThumbnail(a0, a1, a2, false)
end

v41._thumbnail = _thumbnail

local function _queueThumbnails(a0)
    a0.ThumbnailRequest = (a0.ThumbnailRequest or 0) + 1
    if not a0.Active or not a0.MenuOpen or a0.MenuKind ~= "Catalogue" then
        return
    end

    local CatalogueGeneration = a0.CatalogueGeneration
    local ThumbnailRequest = a0.ThumbnailRequest
    task.defer(function() --[[ Upvalues: a0 (copy), CatalogueGeneration (copy), ThumbnailRequest (copy) ]]

        local function current() --[[ Upvalues: a0 (upvalue), CatalogueGeneration (upvalue), ThumbnailRequest (upvalue) ]]
            local v264 = not a0.Destroyed
            if v264 then
                local Active = a0.Active
                if Active then
                    local MenuOpen = a0.MenuOpen
                    if MenuOpen then
                        MenuOpen = false
                        if a0.MenuKind == "Catalogue" then
                            MenuOpen = false
                            if a0.CatalogueGeneration == CatalogueGeneration then
                                MenuOpen = a0.ThumbnailRequest == ThumbnailRequest
                            end
                        end
                    end
                end
            end

            return v264
        end

        local v265 = not a0.Destroyed
        if v265 then
            local Active1 = a0.Active
            if Active1 then
                local MenuOpen1 = a0.MenuOpen
                if MenuOpen1 then
                    MenuOpen1 = false
                    if a0.MenuKind == "Catalogue" then
                        MenuOpen1 = false
                        if a0.CatalogueGeneration == CatalogueGeneration then
                            MenuOpen1 = a0.ThumbnailRequest == ThumbnailRequest
                        end
                    end
                end
            end
        end

        if not v265 then
            return
        end

        local Y1 = a0.ItemList.CanvasPosition.Y
        local v266 = a0.ItemList.AbsoluteSize.Y / a0.MenuScale.Scale
        local v267 = math.max(0, math.floor(Y1 / 184) - 1)
        local v268 = Y1 + v266
        local v269 = math.floor((v268 - 1) / 184) + 1
        v266 = {}
        for k81, k82 in ipairs(a0.Cards) do
            Y1 = a0.ThumbnailItems[k82]
            local v273 = math.floor((k81 - 1) / 4)
            if Y1 then
                if v267 <= v273 then
                    if v273 <= v269 then
                        if not Y1.Loaded then
                            if not Y1.Failed then
                                table.insert(v266, k82)
                                -- branch continues at 135
                            end

                            -- branch continues at 135
                        end

                        -- branch continues at 119
                    end
                else
                    if Y1.Loaded then
                        local Preview = k82:FindFirstChild("Preview")
                        if Preview then
                            Preview:Destroy()
                        end

                        Y1.Loaded = nil
                    end
                end
            end
        end

        for k83, k84 in ipairs(v266) do
            local v277 = not a0.Destroyed
            if v277 then
                local Active2 = a0.Active
                if Active2 then
                    local MenuOpen2 = a0.MenuOpen
                    if MenuOpen2 then
                        MenuOpen2 = false
                        if a0.MenuKind == "Catalogue" then
                            MenuOpen2 = false
                            if a0.CatalogueGeneration == CatalogueGeneration then
                                MenuOpen2 = a0.ThumbnailRequest == ThumbnailRequest
                            end
                        end
                    end
                end
            end

            if not v277 then
                return
            end

            v269 = a0.ThumbnailItems[k84]
            if v269 and k84.Parent and not v269.Loaded then
                v267 = pcall(function() --[[ Upvalues: a0 (upvalue), k84 (copy), v269 (copy) ]]
                    a0:_thumbnail(k84, v269.Name, v269.Info)
                end)
                if not v267 then
                    local Preview2 = k84:FindFirstChild("Preview")
                    if Preview2 then
                        Preview2:Destroy()
                    end
                end

                local v278 = v267
                if v278 then
                    v278 = k84:FindFirstChild("Preview") ~= nil
                end

                v269.Loaded = v278
                v269.Failed = not v269.Loaded
            end

            if k83 % 2 == 0 then
                task.wait()
            end
        end

    end)
end

v41._queueThumbnails = _queueThumbnails

local function RefreshCatalogue(a0) --[[ Upvalues: GuiService (copy), clear (copy), Catalogue (copy), Categories (copy), v43 (copy), label (copy), keyName (copy) ]]
    if not (a0.MenuKind == "Catalogue" and a0.MenuOpen) then
        return
    end

    a0.CatalogueGeneration = (a0.CatalogueGeneration or 0) + 1
    if a0.RenderedCategory == a0.Category and a0.RenderedSubCategory == a0.SubCategory then
        a0:_remember()
    end

    local v279 = a0.Memory[a0.Category .. "/" .. a0.SubCategory]
    if not v279 then
        v279 = {}
    end

    if a0:Owns(GuiService.SelectedObject) then
        GuiService.SelectedObject = nil
    end

    clear(a0.SubList)
    clear(a0.ItemList)
    a0.Cards = {}
    a0.SubButtons = {}
    a0.ThumbnailItems = {}
    local Data2 = a0.Client.Data
    if not Data2 then
        Data2 = {}
    end

    local BaseItems = Data2.BaseItems
    if not BaseItems then
        BaseItems = {}
    end

    local v280 = {
        Policy = "Controller",
        Data = Data2,
        Category = a0.Category,
        SubCategory = a0.SubCategory,
        SearchQuery = a0.SearchQuery,
        Favorites = a0.Favorites,
        Recents = a0.Recents
    }
    local v281 = Catalogue.Query(v280)
    v280 = v281.Subcategories
    local Objects = v281.Objects
    a0.SubCategory = v281.SubCategory
    Data2 = v281.Collection
    a0.SubList.Visible = not Data2
    local ItemList2 = a0.ItemList
    local v282
    if Data2 then
        v282 = 56
    else
        v282 = 108
    end

    ItemList2.Position = UDim2.fromOffset(0, v282)
    ItemList2 = a0.ItemList
    if Data2 then
        v282 = 440
    else
        v282 = 388
    end

    ItemList2.Size = UDim2.fromOffset(948, v282)
    for k85, k86 in ipairs(Categories) do
        v281 = a0.CategoryButtons[k85]
        v281:SetAttribute("CurrentTab", k86 == a0.Category)
        local v286
        if not (k86 == a0.Category and v43.Selected) then
            v286 = v43.Card
        end

        v281.BackgroundColor3 = v286
        local v287
        if not (k86 == a0.Category and v43.Accent) then
            v287 = v43.Text
        end

        v281.TextColor3 = v287
    end

    if Data2 then
        local v288 = {}
        if v288 then
            -- jump to 212
        end
    end

    local v289 = v280
    for k87, k88 in ipairs(v289) do
        local v293 = math.max(90, #k88 * 11 + 24)
        local v294 = UDim2.fromOffset(v293, 37)
        local v296 = a0:_button(a0.SubList, k88, k88, v294, UDim2.new(), function() --[[ Upvalues: a0 (copy), k88 (copy) ]]
            a0:_remember()
            a0.SubCategory = k88
            local v295 = a0.Category .. "/SubCategory"
            a0.Memory[v295] = k88
            a0:RefreshCatalogue()
        end)
        v296.LayoutOrder = k87
        v296.TextSize = 17
        v296:SetAttribute("CurrentTab", k88 == a0.SubCategory)
        local v297
        if not (k88 == a0.SubCategory and v43.Selected) then
            v297 = v43.Card
        end

        v296.BackgroundColor3 = v297
        local v298
        if not (k88 == a0.SubCategory and v43.Accent) then
            v298 = v43.Text
        end

        v296.TextColor3 = v298
        table.insert(a0.SubButtons, v296)
    end

    a0.DefaultFocus = nil
    for k89, k90 in ipairs(Objects) do
        local Name = k90.Name
        local Info = k90.Info
        v280 = tonumber(BaseItems[Name]) or 0
        Data2 = not Info.ItemObject
        if not Data2 then
            Data2 = 0 < v280
        end

        local v302 = UDim2.fromOffset(225, 174)
        local v303 = a0:_button(a0.ItemList, Name, "", v302, UDim2.new(), function() --[[ Upvalues: Data2 (copy), a0 (copy), Name (copy), Info (copy) ]]
            if not Data2 then
                local Subtitle = a0.Subtitle
                if Subtitle.Text ~= "This object needs an item in your inventory." then
                    Subtitle.Text = "This object needs an item in your inventory."
                end

                return
            end

            a0:_remember()
            if a0.Callbacks.SelectItem then
                a0.Callbacks.SelectItem(Name, Info.Type)
            end

        end)
        v303.LayoutOrder = k89
        v303:SetAttribute("ItemName", Name)
        local v304 = label
        local v305
        if a0.Favorites[Name] then
            v305 = "\226\152\133"
        else
            v305 = "\226\152\134"
        end

        local v306 = UDim2.fromOffset(32, 32)
        local v307 = UDim2.fromOffset(184, 5)
        local v308 = v304(v303, v305, v306, v307, 25)
        v308.Name = "Favorite"
        v308.ZIndex = 2
        v308.TextXAlignment = Enum.TextXAlignment.Center
        local v309 = UDim2.new(1, -20, 0, 39)
        local v310 = UDim2.fromOffset(10, 101)
        local v311 = label(v303, Name, v309, v310, 18)
        v311.TextWrapped = true
        v311.TextTruncate = Enum.TextTruncate.None
        if Info.ItemObject then
            if 0 < v280 then
                v311 = "Owned \195\151" .. v280
                if v311 then
                    -- jump to 437
                end
            end

            v311 = "None owned"
        else
            v311 = "$" .. tostring(Info.Price or 0)
        end

        local v312 = label
        local v313 = UDim2.new(1, -20, 0, 24)
        local v314 = UDim2.fromOffset(10, 142)
        local v315
        if not (Data2 and v43.Accent) then
            v315 = v43.Danger
        end

        v312(v303, v311, v313, v314, 17, v315)
        v305 = {Name = Name, Info = Info}
        a0.ThumbnailItems[v303] = v305
        table.insert(a0.Cards, v303)
        if Name == v279.Item then
            a0.DefaultFocus = v303
        end
    end

    local Empty = a0.Empty
    local v316
    if a0.Category == "Recent" then
        v316 = "Objects you use will appear here."
    else
        local v317 = keyName(Enum.KeyCode.ButtonX, "X")
        v316 = "Highlight an object and press " .. v317 .. " to favorite it."
    end

    if Empty.Text ~= v316 then
        Empty.Text = v316
    end

    a0.Empty.Visible = #a0.Cards == 0
    a0.RenderedCategory = a0.Category
    a0.RenderedSubCategory = a0.SubCategory
    local DefaultFocus = a0.DefaultFocus
    if not DefaultFocus then
        DefaultFocus = a0.Cards[1]
        if not DefaultFocus then
            DefaultFocus = a0.SubButtons[1]
            if not DefaultFocus then
                DefaultFocus = a0.CategoryButtons[table.find(Categories, a0.Category) or 1]
            end
        end
    end

    a0.DefaultFocus = DefaultFocus
    a0:_wireCatalogue()
    local v318 = v279.Scroll or Vector2.zero
    a0.ItemList.CanvasPosition = v318
    local v319 = v279.SubScroll or Vector2.zero
    a0.SubList.CanvasPosition = v319
    a0.LastFocus = nil
    a0:FocusDefault()
    local CatalogueGeneration1 = a0.CatalogueGeneration
    task.defer(function() --[[ Upvalues: a0 (copy), CatalogueGeneration1 (copy) ]]
        if not a0.Destroyed and a0.MenuOpen and a0.MenuKind == "Catalogue" and a0.CatalogueGeneration == CatalogueGeneration1 then
            a0:_scrollTo(a0.DefaultFocus)
            a0:_queueThumbnails()
        end

    end)
end

v41.RefreshCatalogue = RefreshCatalogue

local function _wireCatalogue(a0) --[[ Upvalues: Categories (copy) ]]
    local v320 = a0.CategoryButtons[table.find(Categories, a0.Category) or 1]
    local v321 = a0.SubButtons[1] or v320
    for k91, k92 in ipairs(a0.SubButtons) do
        if k92.Name == a0.SubCategory then
            v321 = k92
        end
    end

    for k93, k94 in ipairs(a0.CategoryButtons) do
        k94.NextSelectionLeft = a0.CategoryButtons[k93 - 1] or k94
        k94.NextSelectionRight = a0.CategoryButtons[k93 + 1] or k94
        k94.NextSelectionUp = a0.PaintModeButton
        local v329
        if not (a0.SubButtons[1] and v321) then
            local v331 = a0.Cards[1] or k94
        end

        k94.NextSelectionDown = v329
    end

    for k95, k96 in ipairs(a0.SubButtons) do
        k96.NextSelectionLeft = a0.SubButtons[k95 - 1] or k96
        k96.NextSelectionRight = a0.SubButtons[k95 + 1] or k96
        k96.NextSelectionUp = v320
        k96.NextSelectionDown = a0.Cards[1] or k96
    end

    for k97, k98 in ipairs(a0.Cards) do
        local v338 = (k97 - 1) % 4 + 1
        k98.NextSelectionLeft = 1 < v338 and a0.Cards[k97 - 1] or k98
        k98.NextSelectionRight = v338 < 4 and a0.Cards[k97 + 1] or k98
        k98.NextSelectionUp = a0.Cards[k97 - 4] or v321
        k98.NextSelectionDown = a0.Cards[k97 + 4] or k98
    end

    a0.PaintModeButton.NextSelectionDown = v320
    a0.PaintModeButton.NextSelectionLeft = a0.PaintModeButton
    a0.PaintModeButton.NextSelectionRight = a0.CloseButton
    a0.PaintModeButton.NextSelectionUp = a0.PaintModeButton
    a0.CloseButton.NextSelectionDown = v320
    a0.CloseButton.NextSelectionLeft = a0.PaintModeButton
    a0.CloseButton.NextSelectionRight = a0.CloseButton
    a0.CloseButton.NextSelectionUp = a0.CloseButton
end

v41._wireCatalogue = _wireCatalogue

local function _open(a0, a1)
    if not a0.Active then
        return false
    end

    a0:_remember()
    a0.MenuOpen = true
    a0.MenuKind = a1
    a0.Dimmer.Visible = true
    a0.HUD.Visible = false
    a0.Reticle.Visible = false
    a0.Catalogue.Visible = a1 == "Catalogue"
    a0.PaintModeButton.Visible = a1 == "Catalogue"
    local v343 = true
    if a1 ~= "Options" then
        v343 = a1 == "RotationSteps"
    end

    a0.Options.Visible = v343
    local BackHint = a0.BackHint
    if a1 == "RotationSteps" then
        v343 = "Back to options"
    else
        v343 = "Back to building"
    end

    if BackHint.Text ~= v343 then
        BackHint.Text = v343
    end

    a0.FavoriteHint.Parent.Visible = a1 == "Catalogue"
    a0.CategoryLeftHint.Parent.Visible = a1 == "Catalogue"
    a0.CategoryRightHint.Parent.Visible = a1 == "Catalogue"
    return true
end

v41._open = _open

local function OpenCatalogue(a0)
    if not a0:_open("Catalogue") then
        return
    end

    local Title = a0.Title
    if Title.Text ~= "OBJECT CATALOGUE" then
        Title.Text = "OBJECT CATALOGUE"
    end

    Title = a0.Subtitle
    if Title.Text ~= "Choose an object, then keep moving while you build." then
        Title.Text = "Choose an object, then keep moving while you build."
    end

    a0:RefreshCatalogue()
end

v41.OpenCatalogue = OpenCatalogue

local function OpenOptions(a0, a1) --[[ Upvalues: keyName (copy) ]]
    if not a0:_open("Options") then
        return
    end

    local Title1 = a0.Title
    if Title1.Text ~= "CLASSIC OPTIONS" then
        Title1.Text = "CLASSIC OPTIONS"
    end

    Title1 = a0.Subtitle
    if Title1.Text ~= "Switch modes, undo changes or manage your base." then
        Title1.Text = "Switch modes, undo changes or manage your base."
    end

    Title1 = {}
    local v344 = {}
    local v345
    if a1 then
        v345 = "ObjectsMode"
    else
        v345 = "PaintMode"
    end

    local v346
    if a1 then
        v346 = "Objects mode"
    else
        v346 = "Paint mode"
    end

    local v347
    if a1 then
        v347 = "Select, move and place objects"
    else
        v347 = "Enter painting; cycle tools with " .. keyName(Enum.KeyCode.ButtonR2, "RT")
    end

    v344[1] = v345
    v344[2] = v346
    v344[3] = v347
    v345 = {"Catalogue", "Object catalogue", "Browse furniture, decoration and traps"}
    v346 = {}
    local v348 = tostring(a0.State.undoCount or 0)
    local v349 = "Undo (" .. v348 .. ")"
    v346[1] = "Undo"
    v346[2] = v349
    v346[3] = "D-pad \226\134\144 restores the previous change"
    v347 = {}
    local v350 = tostring(a0.State.redoCount or 0)
    local v351 = "Redo (" .. v350 .. ")"
    v347[1] = "Redo"
    v347[2] = v351
    v347[3] = "D-pad \226\134\146 reapplies an undone change"
    local v352 = {}
    local v353 = tostring(a0.State.rotateStep or 90)
    local v354 = "Rotation increment: " .. v353 .. "\194\176"
    v352[1] = "RotationSteps"
    v352[2] = v354
    v352[3] = "Choose how far each trigger pull rotates"
    local v355 = {"Customize", "Customize base", "Walls, floor and base upgrades"}
    local v356 = {"SaveSlots", "Save slots", "Save or load a base layout"}
    local v357 = {
        "SwitchModern",
        "Building system: Modern",
        "Switch to the Modern building controls"
    }
    local v358 = {}
    local v359
    if a1 then
        v359 = "Resume painting"
    else
        v359 = "Resume building"
    end

    v358[1] = "Resume"
    v358[2] = v359
    v358[3] = "Close this menu"
    local v360 = {"Exit", "Finish building", "Return to normal controls"}
    Title1[1] = v344
    Title1[2] = v345
    Title1[3] = v346
    Title1[4] = v347
    Title1[5] = v352
    Title1[6] = v355
    Title1[7] = v356
    Title1[8] = v357
    Title1[9] = v358
    Title1[10] = v360
    if a0.Client.EditingBase then
        v347 = {
            "DeleteAll",
            "Delete all objects\226\128\166",
            "Opens a confirmation before removing objects"
        }
        table.insert(Title1, 9, v347)
    end

    a0:_showOptions(Title1)
end

v41.OpenOptions = OpenOptions

local function _showOptions(a0, a1) --[[ Upvalues: GuiService (copy), clear (copy), label (copy), v43 (copy) ]]
    if a0:Owns(GuiService.SelectedObject) then
        GuiService.SelectedObject = nil
    end

    clear(a0.Options)
    a0.HistoryButtons = {}
    local v361 = {}
    local v362 = nil
    for k99, k100 in ipairs(a1) do
        local v366 = UDim2.fromOffset(462, 78)
        local v369 = a0:_button(a0.Options, k100[1], "", v366, UDim2.new(), function() --[[ Upvalues: k100 (copy), a0 (copy) ]]
            if k100[1] == "Undo" then
                if a0.State.busy then
                    return
                end

                local v367 = a0.State.undoCount or 0
                if v367 <= 0 then
                    return
                end
            end

            if k100[1] == "Redo" then
                if a0.State.busy then
                    return
                end

                local v368 = a0.State.redoCount or 0
                if v368 <= 0 then
                    return
                end
            end

            if a0.Callbacks.Option then
                a0.Callbacks.Option(k100[1])
            end

        end)
        v369.LayoutOrder = k99
        v369:SetAttribute("CurrentTab", k100[4] == true)
        local v370 = label
        local v371 = k100[2]
        local v372 = UDim2.fromOffset(426, 30)
        local v373 = UDim2.fromOffset(18, 8)
        if k100[1] == "Exit" or k100[1] == "DeleteAll" then
            local Danger = v43.Danger
            if Danger then
                -- jump to 92
            end
        end

        local Text1 = v43.Text
        local v374 = v370(v369, v371, v372, v373, 21, Text1)
        local v375 = UDim2.fromOffset(426, 26)
        local v376 = UDim2.fromOffset(18, 40)
        label(v369, k100[3], v375, v376, 16, v43.Muted)
        if k100[1] == "Undo" or k100[1] == "Redo" then
            a0.HistoryButtons[k100[1]] = v374
        end

        if k100[4] then
            v362 = v369
        end

        table.insert(v361, v369)
    end

    a0:_updateHistoryLabels()
    a0:_wireOptions(v361, v362)
end

v41._showOptions = _showOptions

local function _updateHistoryLabels(a0) --[[ Upvalues: v43 (copy) ]]
    local HistoryButtons = a0.HistoryButtons
    if not HistoryButtons then
        HistoryButtons = {}
    end

    for k101, k102 in pairs(HistoryButtons) do
        if k102.Parent then
            local v380
            if k101 == "Undo" then
                v380 = "undoCount"
            else
                v380 = "redoCount"
            end

            local v381 = tonumber(a0.State[v380]) or 0
            local v382 = tostring(v381)
            local v383 = k101 .. " (" .. v382 .. ")"
            if k102.Text ~= v383 then
                k102.Text = v383
            end

            local v384
            if not (0 < v381 and not a0.State.busy and v43.Text) then
                v384 = v43.Muted
            end

            k102.TextColor3 = v384
        end
    end
end

v41._updateHistoryLabels = _updateHistoryLabels

local function OpenRotationSteps(a0, a1, a2) --[[ Upvalues: GuiService (copy), clear (copy), v43 (copy), label (copy) ]]
    if not a0:_open("RotationSteps") then
        return
    end

    local Title2 = a0.Title
    if Title2.Text ~= "ROTATION INCREMENT" then
        Title2.Text = "ROTATION INCREMENT"
    end

    Title2 = a0.Subtitle
    if Title2.Text ~= "Choose the angle for each trigger pull on any axis." then
        Title2.Text = "Choose the angle for each trigger pull on any axis."
    end

    if a0:Owns(GuiService.SelectedObject) then
        GuiService.SelectedObject = nil
    end

    clear(a0.Options)
    local v385 = {}
    local v386 = nil
    for k103, k104 in ipairs(a2) do
        local v390 = "Step" .. tostring(k104)
        local v391 = UDim2.fromOffset(462, 78)
        local v392 = a0:_button(a0.Options, v390, "", v391, UDim2.new(), function() --[[ Upvalues: a0 (copy), k104 (copy) ]]
            if a0.Callbacks.RotationStep then
                a0.Callbacks.RotationStep(k104)
            end

        end)
        v392.LayoutOrder = k103
        local v393 = k104 == a1
        v392:SetAttribute("CurrentTab", v393)
        local v394
        if not (v393 and v43.Selected) then
            v394 = v43.Card
        end

        v392.BackgroundColor3 = v394
        v394 = label
        local v395 = tostring(k104)
        local v396 = v395 .. "\194\176"
        local v397 = UDim2.fromOffset(426, 30)
        local v398 = UDim2.fromOffset(18, 8)
        local v399
        if not (v393 and v43.Accent) then
            v399 = v43.Text
        end

        v394(v392, v396, v397, v398, 21, v399)
        v394 = label
        if v393 then
            v396 = "Selected"
        else
            local v400 = tostring(k104)
            v396 = "Rotate by " .. v400 .. " degrees"
        end

        local v401 = UDim2.fromOffset(426, 26)
        local v402 = UDim2.fromOffset(18, 40)
        v394(v392, v396, v401, v402, 16, v43.Muted)
        table.insert(v385, v392)
        if v393 then
            v386 = v392
        end
    end

    a0:_wireOptions(v385, v386)
end

v41.OpenRotationSteps = OpenRotationSteps

local function _wireOptions(a0, a1, a2)
    for k105, k106 in ipairs(a1) do
        k106.NextSelectionLeft = k105 % 2 == 0 and a1[k105 - 1] or k106
        k106.NextSelectionRight = k105 % 2 == 1 and a1[k105 + 1] or k106
        local v411 = a1[k105 - 2] or a0.CloseButton
        k106.NextSelectionUp = v411
        k106.NextSelectionDown = a1[k105 + 2] or k106
    end

    a0.CloseButton.NextSelectionDown = a1[1]
    a0.CloseButton.NextSelectionLeft = a1[1]
    a0.CloseButton.NextSelectionRight = a0.CloseButton
    a0.CloseButton.NextSelectionUp = a0.CloseButton
    local v414 = a2 or a1[1]
    a0.DefaultFocus = v414
    a0.LastFocus = nil
    a0.Options.CanvasPosition = Vector2.zero
    a0:FocusDefault()
end

v41._wireOptions = _wireOptions

local function ChangeCategory(a0, a1) --[[ Upvalues: Categories (copy) ]]
    if not a0.MenuOpen or a0.MenuKind ~= "Catalogue" then
        return
    end

    local v415 = (table.find(Categories, a0.Category) or 1) - 1 + a1
    a0:_selectCategory(Categories[v415 % #Categories + 1])
end

v41.ChangeCategory = ChangeCategory

local function FocusDefault(a0) --[[ Upvalues: GuiService (copy) ]]
    if not (a0.Active and a0.MenuOpen) then
        return
    end

    local LastFocus = a0.LastFocus
    if LastFocus then
        if LastFocus.Parent then
            if a0:Owns(LastFocus) then
                if LastFocus ~= a0.CloseButton then
                    if LastFocus:IsDescendantOf(a0.MenuKind == "Catalogue" and a0.Catalogue or a0.Options) then
                        -- jump to 39
                    end

                    -- branch continues at 39
                end
            end
        end
    end

    LastFocus = a0.DefaultFocus
    if LastFocus and LastFocus.Parent then
        GuiService.SelectedObject = LastFocus
        return
    end

    GuiService.SelectedObject = a0.CloseButton
end

v41.FocusDefault = FocusDefault

local function CloseMenu(a0) --[[ Upvalues: GuiService (copy) ]]
    a0:_remember()
    a0.ThumbnailRequest = (a0.ThumbnailRequest or 0) + 1
    for k107, k108 in pairs(a0.ThumbnailItems) do
        local Preview3 = k107:FindFirstChild("Preview")
        if Preview3 then
            Preview3:Destroy()
        end

        k108.Loaded = nil
    end

    if a0:Owns(GuiService.SelectedObject) then
        GuiService.SelectedObject = nil
    end

    a0.MenuOpen = false
    a0.MenuKind = nil
    a0.Dimmer.Visible = false
    a0.HUD.Visible = true
    a0.Reticle.Visible = true
    a0:Update(a0.State)
end

v41.CloseMenu = CloseMenu

local function SetActive(a0, a1)
    a0.Active = a1 == true
    if not a0.Active then
        a0:CloseMenu()
    end

    a0.Gui.Enabled = a0.Active
end

v41.SetActive = SetActive
local t5 = {Y = "TURN (Y)", X = "TILT (X)", Z = "ROLL (Z)"}

local function Update(a0, a1) --[[ Upvalues: Preferences (copy), sameValues (copy), v43 (copy), t5 (copy), keyName (copy) ]]
    local v419 = a1
    if not v419 then
        v419 = {}
    end

    a0.State = v419
    a1 = a0.State
    v419 = false
    if type(a1.favorites) == "table" and a1.favorites ~= a0.FavoritesSource then
        a0.FavoritesSource = a1.favorites
        local v420 = Preferences.Favorites(a1.favorites)
        v419 = not sameValues(a0.Favorites, v420)
        a0.Favorites = v420
    end

    local v421 = a1.recents or a1.recent
    if type(v421) == "table" and v421 ~= a0.RecentsSource then
        a0.RecentsSource = v421
        local v422 = Preferences.Recents(v421)
        v419 = not sameValues(a0.Recents, v422) or v419
        a0.Recents = v422
    end

    if v419 and a0.MenuOpen and a0.MenuKind == "Catalogue" then
        a0:RefreshCatalogue()
    end

    a0:_updateHistoryLabels()
    local v423 = a1.deleting == true
    local v424 = true
    if a1.mode ~= "Paint" then
        v424 = a1.paintMode == true
    end

    v421 = v424
    if v421 then
        v421 = a1.pickerOpen == true
    end

    v419 = a0:_updatePaintTools(v424, a1)
    local itemName1 = a1.itemName
    if itemName1 then
        itemName1 = a1.itemName ~= ""
    end

    local v427
    if v424 then
        local v428
        if v419 == "PaintBucket" then
            v428 = "Paint bucket"
        else
            v428 = "Paint brush"
        end

        v427 = v428
    end

    if v423 then
        v419 = "DELETE MODE"
    else
        local v429
        if not (v424 and "PAINT MODE  /  " .. v427) then
            if a1.existing then
                local v433 = v427 or (a1.targetName and a1.targetName ~= "" and a1.targetName or nil) or "OBJECT"
                v429 = "OBJECTS  /  EDITING " .. v433
                if v429 then
                    -- jump to 182
                end
            end
        end
    end

    local ItemLabel1 = a0.ItemLabel
    if ItemLabel1.Text ~= v419 then
        ItemLabel1.Text = v419
    end

    local v435
    if not (v423 and v43.Danger) then
        v435 = v43.Text
    end

    a0.ItemLabel.TextColor3 = v435
    v427 = t5[a1.axis or "Y"]
    if not v427 then
        local v436 = tostring(a1.axis)
        v427 = v436 .. " AXIS"
    end

    local v437 = tostring(a1.rotateStep or 90)
    v419 = v427 .. "  /  " .. v437 .. "\194\176"
    local AxisLabel = a0.AxisLabel
    if v421 then
        v435 = "CHOOSE COLOUR"
    else
        if v423 then
            v435 = "TAP TO DELETE"
        else
            if v424 then
                if a1.precision then
                    v435 = "PRECISION AIM"
                    -- jump to 251 (out of range)
                end

                v435 = "AIM TO PAINT"
            else
                if a1.precision then
                    v437 = "PRECISION  /  "
                else
                    v437 = ""
                end

                v435 = v437 .. v419
            end
        end
    end

    if AxisLabel.Text ~= "  /  " then
        AxisLabel.Text = "  /  "
    end

    if v421 then
        v427 = "Choose a colour with the cursor. Close the wheel to resume painting."
    else
        v427 = a1.status
    end

    if not v427 or v427 == "" then
        if a1.busy then
            AxisLabel = "Applying your change\226\128\166"
        else
            if v423 then
                if a1.targetName and a1.targetName ~= "" and a1.targetName or nil then
                    AxisLabel = "Tap " .. a0.ActionKey .. " to delete " .. (a1.targetName and a1.targetName ~= "" and a1.targetName or nil) .. "."
                    if AxisLabel then
                        -- jump to 329
                    end
                end

                AxisLabel = "Aim at an object, then tap " .. a0.ActionKey .. " to delete it."
                if AxisLabel then
                    -- jump to 329
                end
            end

            local v438 = keyName(Enum.KeyCode.ButtonR2, "RT")
            local v439 = keyName(Enum.KeyCode.ButtonX, "X")
            local v440 = keyName(Enum.KeyCode.ButtonY, "Y")
            AxisLabel = "Aim to paint. " .. v438 .. " cycles tools; " .. v439 .. " samples colour; " .. v440 .. " toggles the colour wheel."
            if not (v424 and AxisLabel) then
                if a1.existing then
                    AxisLabel = "Move and rotate the selected object, then confirm to save. Cancel restores its original position."
                else
                    if itemName1 then
                        AxisLabel = "Move and look freely. Use the triggers to rotate your preview."
                    end
                end
            end
        end

        v427 = AxisLabel
    end

    AxisLabel = a0.StatusLabel
    if AxisLabel.Text ~= v427 then
        AxisLabel.Text = v427
    end

    AxisLabel = a0.ActionHint
    if v421 then
        v435 = "Choose"
    else
        if v423 then
            v435 = "Delete"
        else
            if v424 then
                v435 = "Paint"
            else
                if a1.existing then
                    v435 = "Save move"
                else
                    if itemName1 then
                        v435 = "Place"
                    else
                        v435 = "Select"
                    end
                end
            end
        end
    end

    if AxisLabel.Text ~= "  /  " then
        AxisLabel.Text = "  /  "
    end

    AxisLabel = a0.CancelHint
    if v421 then
        v435 = "Close"
    else
        if v423 or v424 or itemName1 or a1.existing then
            v435 = "Cancel"
            -- jump to 378 (out of range)
        end

        v435 = "Finish"
    end

    if AxisLabel.Text ~= "  /  " then
        AxisLabel.Text = "  /  "
    end

    AxisLabel = a0.RotateLeftHint
    if AxisLabel.Text ~= "Rotate \226\136\146" then
        AxisLabel.Text = "Rotate \226\136\146"
    end

    AxisLabel = a0.RotateRightHint
    if v424 then
        v435 = "Tool"
    else
        v435 = "Rotate +"
    end

    if AxisLabel.Text ~= AxisLabel.Text then
        AxisLabel.Text = AxisLabel.Text
    end

    AxisLabel = a0.AxisHint
    if v424 then
        v435 = "Sample"
    else
        v435 = "Axis"
    end

    if AxisLabel.Text ~= AxisLabel.Text then
        AxisLabel.Text = AxisLabel.Text
    end

    AxisLabel = a0.MenuHint
    if v421 then
        v435 = "Close colour"
    else
        if v424 then
            v435 = "Colour"
        else
            v435 = "Catalogue"
        end
    end

    if AxisLabel.Text ~= AxisLabel.Text then
        AxisLabel.Text = AxisLabel.Text
    end

    local v443 = not v423 and not v424
    a0.RotateLeftHint.Parent.Visible = v443
    local v445 = not v423 and not v421
    a0.RotateRightHint.Parent.Visible = v445
    local Parent1 = a0.RotateRightHint.Parent
    local v446
    if v424 then
        v446 = 150
    else
        v446 = 300
    end

    Parent1.Position = UDim2.fromOffset(v446, 0)
    local Parent2 = a0.PrecisionHint.Parent
    if v424 then
        v446 = 300
    else
        v446 = 450
    end

    Parent2.Position = UDim2.fromOffset(v446, 0)
    local Parent3 = a0.AxisHint.Parent
    if v424 then
        v446 = 130
    else
        v446 = 95
    end

    Parent3.Size = UDim2.fromOffset(v446, 34)
    Parent3 = a0.AxisHint
    if v424 then
        v446 = 94
    else
        v446 = 59
    end

    Parent3.Size = UDim2.fromOffset(v446, 34)
    local Parent4 = a0.AxisHint.Parent
    if v424 then
        v446 = 490
    else
        v446 = 640
    end

    Parent4.Position = UDim2.fromOffset(v446, 0)
    local Parent5 = a0.MenuHint.Parent
    if v424 then
        v446 = 630
    else
        v446 = 735
    end

    Parent5.Position = UDim2.fromOffset(v446, 0)
    local Parent6 = a0.CancelHint.Parent
    if v424 then
        v446 = 810
    else
        v446 = 895
    end

    Parent6.Position = UDim2.fromOffset(v446, 0)
    local v449 = not v423 and not v421
    a0.AxisHint.Parent.Visible = v449
    a0.PrecisionHint.Parent.Visible = not v421
    local SecondaryLabel = a0.SecondaryLabel
    local v450
    if v421 then
        v450 = "Painting, movement and history are paused while choosing a colour."
    else
        local v451 = tostring(a1.undoCount or 0)
        local v452 = tostring(a1.redoCount or 0)
        v450 = "D-pad \226\134\144 Undo " .. v451 .. " / \226\134\146 Redo " .. v452 .. "   \226\134\147 Delete   \226\134\145 Options   " .. a0.JumpKey .. " Jump   L3 Sprint / R3 Crouch"
    end

    if SecondaryLabel.Text ~= v450 then
        SecondaryLabel.Text = v450
    end

    local v453
    if not (v423 and v43.Danger) then
        local v454
        if not (a1.precision and v43.Accent) then
            v454 = v43.Text
        end
    end

    a0.Reticle.BackgroundColor3 = v453
end

v41.Update = Update

local function Destroy(a0)
    a0:CloseMenu()
    a0.Destroyed = true
    for k109, k110 in ipairs(a0.Connections) do
        k110:Disconnect()
    end

    a0.Connections = {}
    a0.Gui:Destroy()
end

v41.Destroy = Destroy
v3.UI = v41
v41 = {}
v41.__index = v41

local function selectOutline(a0, a1) --[[ Upvalues: v43 (copy) ]]
    local v458
    if a1 then
        v458 = 3
    else
        v458 = 2
    end

    a0.BorderSizePixel = v458
    local v459
    if not (a1 and v43.Selected) then
        v459 = v43.Line
    end

    a0.BorderColor3 = v459
    if a1 then
        v459 = 0.2
    else
        v459 = 0.5
    end

    a0.BackgroundTransparency = v459
end

local function label1(a0, a1, a2, a3, a4, a5) --[[ Upvalues: v43 (copy) ]]
    local t6 = {
        BackgroundTransparency = 1,
        Size = a2,
        Position = a3,
        Text = a1,
        TextSize = a4 or 16,
        Font = Enum.Font.Code
    }
    local v461 = a5 or v43.Text
    t6.TextColor3 = v461
    t6.TextXAlignment = Enum.TextXAlignment.Left
    t6.TextTruncate = Enum.TextTruncate.AtEnd
    local TextLabel1 = Instance.new("TextLabel")
    for k111, k112 in pairs(t6) do
        TextLabel1[k111] = k112
    end

    TextLabel1.Parent = a0
    return TextLabel1
end

local function rect(a0, a1, a2, a3, a4)
    a0.Position = UDim2.fromOffset(a1, a2)
    a0.Size = UDim2.fromOffset(a3, a4)
end

local function _allowed(a0, a1)
    local Active3 = a0.Active
    if Active3 then
        Active3 = not a0.Destroyed
        if Active3 then
            Active3 = not a0.State.blocked
            if Active3 then
                Active3 = true
                if a1 ~= nil then
                    Active3 = a0.MenuOpen == a1
                end
            end
        end
    end

    return Active3
end

v43 = {
    Panel = Color3.fromRGB(0, 0, 0),
    Card = Color3.fromRGB(0, 0, 0),
    Accent = Color3.fromRGB(255, 255, 255),
    Selected = Color3.fromRGB(156, 215, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Muted = Color3.fromRGB(200, 200, 200),
    Danger = Color3.fromRGB(255, 139, 139),
    Line = Color3.fromRGB(255, 255, 255)
}
v41._allowed = _allowed

local function _action(a0, a1)
    if a0:_allowed() and a0.Callbacks.Action then
        a0.Callbacks.Action(a1)
    end
end

v41._action = _action

local function _button1(a0, a1, a2, a3, a4, a5) --[[ Upvalues: v43 (copy) ]]
    local v465 = {
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        TextSize = 16,
        Selectable = false,
        Active = true,
        Name = a2,
        Text = a3,
        Size = UDim2.fromOffset(76, 48),
        BackgroundColor3 = v43.Card,
        TextColor3 = v43.Text,
        Font = Enum.Font.Code
    }
    local TextButton1 = Instance.new("TextButton")
    for k113, k114 in pairs(v465) do
        TextButton1[k113] = k114
    end

    TextButton1.Parent = a1
    TextButton1.BorderColor3 = Color3.new(1, 1, 1)
    TextButton1.BorderSizePixel = 2
    TextButton1.BorderMode = Enum.BorderMode.Inset
    if a4 then
        TextButton1.Activated:Connect(function() --[[ Upvalues: a0 (copy), a5 (copy), a4 (copy) ]]
            if a0:_allowed(a5) then
                a4()
            end

        end)
    end

    return TextButton1
end

v41._button = _button1

local function new1(a0, a1) --[[ Upvalues: Preferences (copy), v41 (copy), v43 (copy), label1 (copy), Categories (copy), UserInputService (copy) ]]
    local v469 = {
        Active = false,
        MenuOpen = false,
        Category = "Furniture",
        SubCategory = "All",
        SearchQuery = "",
        Columns = 3,
        CardHeight = 164,
        ThumbnailRequest = 0,
        CatalogueGeneration = 0,
        Client = a0
    }
    local v470 = a1
    if not v470 then
        v470 = {}
    end

    v469.Callbacks = v470
    v469.State = {}
    v469.Connections = {}
    v469.Cards = {}
    v469.ThumbnailItems = {}
    v469.SubButtons = {}
    v469.CategoryButtons = {}
    local v471 = a0.Data and a0.Data.ModernBuildFavorites
    v469.Favorites = Preferences.Favorites(v471)
    local v472 = a0.Data and a0.Data.ModernBuildRecents
    v469.Recents = Preferences.Recents(v472)
    local v473 = setmetatable(v469, v41)
    local PlayerGui1 = a0.Player:WaitForChild("PlayerGui")
    local v474 = {
        Name = "ClassicBuildMobileUI",
        Enabled = false,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 40,
        ScreenInsets = Enum.ScreenInsets.None,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }
    local ScreenGui = Instance.new("ScreenGui")
    for k115, k116 in pairs(v474) do
        ScreenGui[k115] = k116
    end

    ScreenGui.Parent = PlayerGui1
    v473.Root = ScreenGui
    v473.Root.ScreenInsets = Enum.ScreenInsets.None
    local v478 = {Name = "World", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)}
    local Root3 = v473.Root
    local Frame6 = Instance.new("Frame")
    for k117, k118 in pairs(v478) do
        Frame6[k117] = k118
    end

    Frame6.Parent = Root3
    v473.World = Frame6
    v478 = {
        Name = "Aim",
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(8, 8),
        BackgroundColor3 = v43.Text
    }
    local World = v473.World
    Frame6 = Instance.new("Frame")
    for k119, k120 in pairs(v478) do
        Frame6[k119] = k120
    end

    Frame6.Parent = World
    v473.Reticle = Frame6
    Frame6 = {Thickness = 2, Color = v43.Panel, LineJoinMode = Enum.LineJoinMode.Miter}
    local Reticle1 = v473.Reticle
    local UIStroke2 = Instance.new("UIStroke")
    for k121, k122 in pairs(Frame6) do
        UIStroke2[k121] = k122
    end

    UIStroke2.Parent = Reticle1
    k121 = 24
    Reticle1 = {
        Name = "DeleteProgress",
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Visible = false,
        BackgroundColor3 = v43.Panel,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, k121),
        Size = UDim2.fromOffset(100, 8)
    }
    local World1 = v473.World
    Frame6 = Instance.new("Frame")
    for k123, k124 in pairs(Reticle1) do
        Frame6[k123] = k124
    end

    Frame6.Parent = World1
    v473.Progress = Frame6
    Frame6 = v473.Progress
    Frame6.BorderColor3 = Color3.new(1, 1, 1)
    Frame6.BorderSizePixel = 2
    Frame6.BorderMode = Enum.BorderMode.Inset
    local v491 = {
        BorderSizePixel = 0,
        Size = UDim2.fromScale(0, 1),
        BackgroundColor3 = v43.Danger
    }
    local Progress = v473.Progress
    Frame6 = Instance.new("Frame")
    for k125, k126 in pairs(v491) do
        Frame6[k125] = k126
    end

    Frame6.Parent = Progress
    v473.ProgressFill = Frame6
    v491 = {
        Name = "ClassicBuildMobileControls",
        Enabled = false,
        ResetOnSpawn = false,
        DisplayOrder = 41,
        ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }
    Frame6 = Instance.new("ScreenGui")
    for k127, k128 in pairs(v491) do
        Frame6[k127] = k128
    end

    Frame6.Parent = PlayerGui1
    v473.ControlsGui = Frame6
    v491 = {Name = "SafeArea", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)}
    local ControlsGui = v473.ControlsGui
    Frame6 = Instance.new("Frame")
    for k129, k130 in pairs(v491) do
        Frame6[k129] = k130
    end

    Frame6.Parent = ControlsGui
    v473.Safe = Frame6
    v491 = {Name = "Controls", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)}
    local Safe = v473.Safe
    Frame6 = Instance.new("Frame")
    for k131, k132 in pairs(v491) do
        Frame6[k131] = k132
    end

    Frame6.Parent = Safe
    v473.Controls = Frame6
    v473.CatalogueButton = v473:_button(v473.Controls, "Catalogue", "Catalogue", function() --[[ Upvalues: v473 (copy) ]]
        v473:_action("Catalogue")
    end, false)
    v473.PaintButton = v473:_button(v473.Controls, "Paint", "Paint", function() --[[ Upvalues: v473 (copy) ]]
        local v504
        if v473.State.mode == "Paint" then
            v504 = "Objects"
        else
            v504 = "Paint"
        end

        v473:_action(v504)
    end, false)
    local v505 = false
    v473.OptionsButton = v473:_button(v473.Controls, "Options", "Options", function() --[[ Upvalues: v473 (copy) ]]
        v473:_action("Options")
    end, v505)
    local v506 = {
        Name = "History",
        BackgroundTransparency = 1,
        Active = true,
        Size = UDim2.fromOffset(208, 48)
    }
    local Controls = v473.Controls
    local Frame7 = Instance.new("Frame")
    for k133, k134 in pairs(v506) do
        Frame7[k133] = k134
    end

    Frame7.Parent = Controls
    v473.History = Frame7
    v473.HistoryButtons = {}
    local v510 = "Redo"
    v506 = {"Undo", v510}
    for k135, k136 in ipairs(v506) do
        k134 = v473.History
        local v514 = k136 .. "\n(0)"
        PlayerGui1 = v473:_button(k134, k136, v514, function() --[[ Upvalues: v473 (copy), k136 (copy) ]]
            v473:_action(k136)
        end, false)
        PlayerGui1.TextSize = 14
        v473.HistoryButtons[k136] = PlayerGui1
    end

    v473.HistoryOptionButtons = {}
    v473.ItemLabel = label1(v473.Controls, "", UDim2.new(), UDim2.new(), 16)
    local Muted3 = v43.Muted
    v473.StatusLabel = label1(v473.Controls, "", UDim2.new(), UDim2.new(), 14, Muted3)
    v473.ItemLabel.TextStrokeTransparency = 0.3
    v473.StatusLabel.TextStrokeTransparency = 0.3
    v473.StatusLabel.TextWrapped = true
    v473.StatusLabel.TextTruncate = Enum.TextTruncate.None
    v473.StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
    local v515 = {
        Name = "BuildActions",
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(156, 168)
    }
    local Controls1 = v473.Controls
    local Frame8 = Instance.new("Frame")
    for k137, k138 in pairs(v515) do
        Frame8[k137] = k138
    end

    Frame8.Parent = Controls1
    v473.Dock = Frame8
    v473.Cancel = v473:_button(v473.Dock, "Cancel", "Cancel", function() --[[ Upvalues: v473 (copy) ]]
        v473:_action("Deselect")
    end, false)
    v473.SelectExisting = v473:_button(v473.Dock, "SelectExisting", "Edit", function() --[[ Upvalues: v473 (copy) ]]
        v473:_action("SelectExisting")
    end, false)
    v473.Axis = v473:_button(v473.Dock, "Axis", "Axis Y", function() --[[ Upvalues: v473 (copy) ]]
        v473:_action("Axis")
    end, false)
    v473.Precision = v473:_button(v473.Dock, "Precision", "Precise", function() --[[ Upvalues: v473 (copy) ]]
        v473:_action("Precision")
    end, false)
    v473.RotateLeft = v473:_button(v473.Dock, "RotateLeft", "\226\136\146 90\194\176", function() --[[ Upvalues: v473 (copy) ]]
        v473:_action("RotateLeft")
    end, false)
    v473.RotateRight = v473:_button(v473.Dock, "RotateRight", "+ 90\194\176", function() --[[ Upvalues: v473 (copy) ]]
        v473:_action("RotateRight")
    end, false)
    v473.Brush = v473:_button(v473.Dock, "Brush", "Brush", function() --[[ Upvalues: v473 (copy) ]]
        v473:_action("Brush")
    end, false)
    v473.Bucket = v473:_button(v473.Dock, "Bucket", "Bucket", function() --[[ Upvalues: v473 (copy) ]]
        v473:_action("Bucket")
    end, false)
    v473.Dropper = v473:_button(v473.Dock, "Dropper", "Sample", function() --[[ Upvalues: v473 (copy) ]]
        v473:_action("Dropper")
    end, false)
    local v519 = false
    v473.ColorPicker = v473:_button(v473.Dock, "ColorPicker", "Colour", function() --[[ Upvalues: v473 (copy) ]]
        v473:_action("ColorPicker")
    end, v519)
    local v520 = {PaddingBottom = UDim.new(0, 8)}
    local ColorPicker = v473.ColorPicker
    local UIPadding1 = Instance.new("UIPadding")
    for k139, k140 in pairs(v520) do
        UIPadding1[k139] = k140
    end

    UIPadding1.Parent = ColorPicker
    local v524 = 5
    ColorPicker = {
        Name = "CurrentColor",
        BorderSizePixel = 0,
        Active = false,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -5),
        Size = UDim2.new(1, -16, 0, v524),
        BackgroundColor3 = v43.Text
    }
    local ColorPicker1 = v473.ColorPicker
    v520 = Instance.new("Frame")
    for k141, k142 in pairs(ColorPicker) do
        v520[k141] = k142
    end

    v520.Parent = ColorPicker1
    v473.ColorSwatch = v520
    v473.DeleteCancel = v473:_button(v473.Dock, "DeleteCancel", "Stop deleting", function() --[[ Upvalues: v473 (copy) ]]
        v473:_action("DeleteMode")
    end, false)
    local v528 = UDim2.fromOffset(156, 48)
    local v529 = UDim2.fromOffset(0, 56)
    v473.DeleteHint = label1(v473.Dock, "Aim at an outlined object", v528, v529, 14, v43.Danger)
    v473.DeleteHint.TextWrapped = true
    v473.DeleteHint.TextXAlignment = Enum.TextXAlignment.Center
    local v530 = false
    v473.Primary = v473:_button(v473.Dock, "Primary", "Place", nil, v530)
    v473.Primary.Font = Enum.Font.Code
    v473.Primary.TextSize = 19
    local v531 = {
        Name = "MenuOverlay",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        Active = true,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new()
    }
    local Safe1 = v473.Safe
    local Frame9 = Instance.new("Frame")
    for k143, k144 in pairs(v531) do
        Frame9[k143] = k144
    end

    Frame9.Parent = Safe1
    v473.Dimmer = Frame9
    v531 = {
        Name = "Menu",
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        BackgroundColor3 = v43.Panel
    }
    local Dimmer1 = v473.Dimmer
    Frame9 = Instance.new("Frame")
    for k145, k146 in pairs(v531) do
        Frame9[k145] = k146
    end

    Frame9.Parent = Dimmer1
    v473.Menu = Frame9
    Frame9 = v473.Menu
    Frame9.BorderColor3 = Color3.new(1, 1, 1)
    Frame9.BorderSizePixel = 2
    Frame9.BorderMode = Enum.BorderMode.Inset
    local v538 = UDim2.fromOffset(100, 48)
    local v539 = UDim2.fromOffset(8, 8)
    v473.Title = label1(v473.Menu, "Catalogue", v538, v539, 16)
    v473.Title.TextWrapped = true
    v473.Title.TextTruncate = Enum.TextTruncate.None
    local v540 = true
    v473.CloseButton = v473:_button(v473.Menu, "Close", "Close", function() --[[ Upvalues: v473 (copy) ]]
        if v473.Callbacks.Close then
            v473.Callbacks.Close()
            return
        end

        v473:CloseMenu()
    end, v540)
    local v541 = {
        Name = "Search",
        Text = "",
        PlaceholderText = "Search objects\226\128\166",
        TextSize = 16,
        ClearTextOnFocus = false,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        PlaceholderColor3 = v43.Muted,
        TextColor3 = v43.Text,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundColor3 = v43.Card
    }
    local Menu4 = v473.Menu
    local TextBox = Instance.new("TextBox")
    for k147, k148 in pairs(v541) do
        TextBox[k147] = k148
    end

    TextBox.Parent = Menu4
    v473.Search = TextBox
    TextBox = v473.Search
    TextBox.BorderColor3 = Color3.new(1, 1, 1)
    TextBox.BorderSizePixel = 2
    TextBox.BorderMode = Enum.BorderMode.Inset
    TextBox = {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 8)}
    local Search = v473.Search
    local UIPadding2 = Instance.new("UIPadding")
    for k149, k150 in pairs(TextBox) do
        UIPadding2[k149] = k150
    end

    UIPadding2.Parent = Search
    Search = {Name = "Catalogue", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)}
    local Menu5 = v473.Menu
    TextBox = Instance.new("Frame")
    for k151, k152 in pairs(Search) do
        TextBox[k151] = k152
    end

    TextBox.Parent = Menu5
    v473.Catalogue = TextBox
    Search = {
        Name = "Categories",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollingDirection = Enum.ScrollingDirection.X,
        ScrollBarImageColor3 = v43.Accent,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.X
    }
    local Catalogue4 = v473.Catalogue
    TextBox = Instance.new("ScrollingFrame")
    for k153, k154 in pairs(Search) do
        TextBox[k153] = k154
    end

    TextBox.Parent = Catalogue4
    v473.CategoryList = TextBox
    TextBox = {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }
    local CategoryList = v473.CategoryList
    local UIListLayout = Instance.new("UIListLayout")
    for k155, k156 in pairs(TextBox) do
        UIListLayout[k155] = k156
    end

    UIListLayout.Parent = CategoryList
    for k157, k158 in ipairs(Categories) do
        local v560 = v473:_button(v473.CategoryList, k158, k158, function() --[[ Upvalues: v473 (copy), k158 (copy) ]]
            v473.Category = k158
            v473.SubCategory = "All"
            v473:RefreshCatalogue()
        end, true)
        local v561 = math.max(76, #k158 * 9 + 20)
        v560.Size = UDim2.fromOffset(v561, 48)
        v560.LayoutOrder = k157
        local CategoryButtons = v473.CategoryButtons
        CategoryButtons[k157] = v560
    end

    local v562 = {
        Name = "Subcategories",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollingDirection = Enum.ScrollingDirection.X,
        ScrollBarImageColor3 = v43.Accent,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.X
    }
    local Catalogue5 = v473.Catalogue
    local ScrollingFrame2 = Instance.new("ScrollingFrame")
    for k159, k160 in pairs(v562) do
        ScrollingFrame2[k159] = k160
    end

    ScrollingFrame2.Parent = Catalogue5
    v473.SubList = ScrollingFrame2
    ScrollingFrame2 = {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }
    local SubList1 = v473.SubList
    local UIListLayout1 = Instance.new("UIListLayout")
    for k161, k162 in pairs(ScrollingFrame2) do
        UIListLayout1[k161] = k162
    end

    UIListLayout1.Parent = SubList1
    SubList1 = {
        Name = "Items",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarImageColor3 = v43.Accent,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    }
    local Catalogue6 = v473.Catalogue
    ScrollingFrame2 = Instance.new("ScrollingFrame")
    for k163, k164 in pairs(SubList1) do
        ScrollingFrame2[k163] = k164
    end

    ScrollingFrame2.Parent = Catalogue6
    v473.ItemList = ScrollingFrame2
    ScrollingFrame2 = {PaddingBottom = UDim.new(0, 8), PaddingRight = UDim.new(0, 6)}
    local ItemList3 = v473.ItemList
    local UIPadding3 = Instance.new("UIPadding")
    for k165, k166 in pairs(ScrollingFrame2) do
        UIPadding3[k165] = k166
    end

    UIPadding3.Parent = ItemList3
    ItemList3 = {
        CellSize = UDim2.fromOffset(120, 164),
        CellPadding = UDim2.fromOffset(8, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }
    local ItemList4 = v473.ItemList
    ScrollingFrame2 = Instance.new("UIGridLayout")
    for k167, k168 in pairs(ItemList3) do
        ScrollingFrame2[k167] = k168
    end

    ScrollingFrame2.Parent = ItemList4
    v473.Grid = ScrollingFrame2
    k168 = 80
    local v578 = UDim2.new(1, -32, 0, k168)
    local v579 = UDim2.fromOffset(16, 166)
    local Muted4 = v43.Muted
    v473.Empty = label1(v473.Catalogue, "No matching objects. Try another search or category.", v578, v579, 17, Muted4)
    v473.Empty.TextWrapped = true
    v473.Empty.TextXAlignment = Enum.TextXAlignment.Center
    v473.Empty.TextTruncate = Enum.TextTruncate.None
    local v580 = {
        Name = "Options",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        Visible = false,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y
    }
    local Menu6 = v473.Menu
    local ScrollingFrame3 = Instance.new("ScrollingFrame")
    for k169, k170 in pairs(v580) do
        ScrollingFrame3[k169] = k170
    end

    ScrollingFrame3.Parent = Menu6
    v473.Options = ScrollingFrame3
    v580 = {
        CellSize = UDim2.fromOffset(250, 76),
        CellPadding = UDim2.fromOffset(8, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }
    local Options2 = v473.Options
    ScrollingFrame3 = Instance.new("UIGridLayout")
    for k171, k172 in pairs(v580) do
        ScrollingFrame3[k171] = k172
    end

    ScrollingFrame3.Parent = Options2
    v473.OptionGrid = ScrollingFrame3
    local v587 = v473.Safe:GetPropertyChangedSignal("AbsoluteSize")
    local v588 = v587:Connect(function() --[[ Upvalues: v473 (copy) ]]
        v473:_resize()
    end)
    table.insert(v473.Connections, v588)
    local v589 = v473.World:GetPropertyChangedSignal("AbsoluteSize")
    local v590 = v589:Connect(function() --[[ Upvalues: v473 (copy) ]]
        v473:_syncAim()
    end)
    table.insert(v473.Connections, v590)
    local v591 = v473.World:GetPropertyChangedSignal("AbsolutePosition")
    local v592 = v591:Connect(function() --[[ Upvalues: v473 (copy) ]]
        v473:_syncAim()
    end)
    table.insert(v473.Connections, v592)
    local v593 = workspace:GetPropertyChangedSignal("CurrentCamera")
    local v594 = v593:Connect(function() --[[ Upvalues: v473 (copy) ]]
        v473:_bindAimCamera()
    end)
    table.insert(v473.Connections, v594)
    local v595 = v473.ItemList:GetPropertyChangedSignal("CanvasPosition")
    local v596 = v595:Connect(function() --[[ Upvalues: v473 (copy) ]]
        v473:_queueThumbnails()
    end)
    table.insert(v473.Connections, v596)
    local v597 = v473.Search:GetPropertyChangedSignal("Text")
    local v598 = v597:Connect(function() --[[ Upvalues: v473 (copy) ]]
        v473.SearchQuery = string.lower(v473.Search.Text)
        v473.SearchRequest = (v473.SearchRequest or 0) + 1
        local SearchRequest = v473.SearchRequest
        task.delay(0.12, function() --[[ Upvalues: v473 (upvalue), SearchRequest (copy) ]]
            if not v473.Destroyed and v473.SearchRequest == SearchRequest then
                v473:RefreshCatalogue()
            end

        end)
    end)
    table.insert(v473.Connections, v598)
    local v599 = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible")
    local v600 = v599:Connect(function() --[[ Upvalues: v473 (copy) ]]
        v473:_resize()
    end)
    table.insert(v473.Connections, v600)
    local v601 = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition")
    local v602 = v601:Connect(function() --[[ Upvalues: v473 (copy) ]]
        v473:_resize()
    end)
    table.insert(v473.Connections, v602)
    local v603 = v473.Search.Focused:Connect(function() --[[ Upvalues: v473 (copy) ]]
        v473:_resize()
    end)
    table.insert(v473.Connections, v603)
    local v604 = v473.Search.FocusLost:Connect(function() --[[ Upvalues: v473 (copy) ]]
        v473:_resize()
    end)
    table.insert(v473.Connections, v604)
    v473:_bindAimCamera()
    v473:_resize()
    v473:Update({})
    return v473
end

v41.new = new1

local function _syncAim(a0) --[[ Upvalues: GuiService (copy) ]]
    if a0.Destroyed then
        return
    end

    local CurrentCamera1 = workspace.CurrentCamera
    if not CurrentCamera1 then
        return
    end

    local v605 = CurrentCamera1.ViewportSize / 2 - GuiService:GetGuiInset()
    local v606 = v605 - a0.World.AbsolutePosition
    a0.Reticle.Position = UDim2.fromOffset(v606.X, v606.Y)
    a0.Progress.Position = UDim2.fromOffset(v606.X, v606.Y + 24)
end

v41._syncAim = _syncAim

local function _bindAimCamera(a0)
    if a0.AimCameraConnection then
        a0.AimCameraConnection:Disconnect()
    end

    a0.AimCameraConnection = nil
    local CurrentCamera2 = workspace.CurrentCamera
    if CurrentCamera2 then
        local v607 = CurrentCamera2:GetPropertyChangedSignal("ViewportSize")
        a0.AimCameraConnection = v607:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:_syncAim()
        end)
    end

    a0:_syncAim()
end

v41._bindAimCamera = _bindAimCamera

local function _resize1(a0) --[[ Upvalues: UserInputService (copy), GuiService (copy) ]]
    if a0.Destroyed then
        return
    end

    a0:_syncAim()
    local AbsoluteSize1 = a0.Safe.AbsoluteSize
    if AbsoluteSize1.X < 1 or AbsoluteSize1.Y < 1 then
        return
    end

    local v608 = AbsoluteSize1.Y < AbsoluteSize1.X
    local v609 = math.min(1040, AbsoluteSize1.X - 16)
    local v610 = math.min(820, AbsoluteSize1.Y - 16)
    local v612 = UserInputService.OnScreenKeyboardVisible and a0.Search:IsFocused()
    if v612 then
        local v615 = UserInputService.OnScreenKeyboardPosition.Y - GuiService:GetGuiInset().Y
        local v616 = v615 - a0.Safe.AbsolutePosition.Y
        if 0 < v616 then
            v610 = math.min(v610, math.max(112, v616 - 16))
        end
    end

    local v617 = v608
    if not v617 then
        v617 = v610 < 440
    end

    a0.Compact = v617
    v617 = v612
    if v617 then
        v617 = v610 < 260
    end

    a0.KeyboardCompact = v617
    v617 = a0.CatalogueButton
    v617.Position = UDim2.fromOffset(8, 8)
    v617.Size = UDim2.fromOffset(112, 48)
    v617 = a0.PaintButton
    v617.Position = UDim2.fromOffset(128, 8)
    v617.Size = UDim2.fromOffset(66, 48)
    v617 = a0.OptionsButton
    v617.Position = UDim2.fromOffset(202, 8)
    v617.Size = UDim2.fromOffset(78, 48)
    v617 = true
    if 680 > AbsoluteSize1.X then
        v617 = v608
        if v617 then
            v617 = 556 <= AbsoluteSize1.X
        end
    end

    if v617 then
        local v618 = math.min(208, AbsoluteSize1.X - 460)
        if v618 then
            -- jump to 210
        end
    end

    local v619 = math.min(208, math.max(136, AbsoluteSize1.X - 180))
    local History = a0.History
    local v620
    if v617 then
        v620 = 288
    else
        v620 = 8
    end

    local v621
    if v617 then
        v621 = 8
    else
        v621 = 136
    end

    History.Position = UDim2.fromOffset(v620, v621)
    History.Size = UDim2.fromOffset(v619, 48)
    v617 = math.floor((v619 - 8) / 2)
    local Undo = a0.HistoryButtons.Undo
    Undo.Position = UDim2.fromOffset(0, 0)
    Undo.Size = UDim2.fromOffset(v617, 48)
    local Redo = a0.HistoryButtons.Redo
    Redo.Position = UDim2.fromOffset(v617 + 8, 0)
    Redo.Size = UDim2.fromOffset(v617, 48)
    v619 = false
    if a0.State.itemName ~= nil then
        v619 = false
        if a0.State.mode ~= "Paint" then
            v619 = not a0.State.deleting
        end
    end

    v617 = false
    if a0.State.mode ~= "Paint" then
        local v623 = not a0.State.deleting and not v619
    end

    local v624
    if v608 and AbsoluteSize1.Y < 380 then
        v624 = 44
    else
        v624 = 48
    end

    local v625 = v624 + 6
    local v626 = v624 + 8
    if v617 then
        v619 = 0
    else
        v619 = (v619 and v625 or 0) + v625 * 2
    end

    v617 = v619 + v626
    local v629 = AbsoluteSize1.Y * 0.36
    local v630 = math.max(8, math.min(v629, AbsoluteSize1.Y - v617 - 112))
    local Dock = a0.Dock
    local v631 = AbsoluteSize1.X - 164
    Dock.Position = UDim2.fromOffset(v631, v630)
    Dock.Size = UDim2.fromOffset(156, v617)
    if v608 then
        local v632 = math.min(280, AbsoluteSize1.X - 196)
        if v632 then
            -- jump to 391
        end
    end

    v630 = AbsoluteSize1.X - 16
    local ItemLabel2 = a0.ItemLabel
    ItemLabel2.Position = UDim2.fromOffset(8, 64)
    ItemLabel2.Size = UDim2.fromOffset(v630, 23)
    ItemLabel2 = a0.StatusLabel
    ItemLabel2.Position = UDim2.fromOffset(8, 89)
    ItemLabel2.Size = UDim2.fromOffset(v630, 38)
    local v633 = {a0.Cancel, 0, 0}
    local v634 = {a0.SelectExisting, 80, 0}
    local v635 = {a0.Axis, 0, v619 and v625 or 0}
    local v636 = {a0.Precision, 80, v619 and v625 or 0}
    local v637 = {a0.RotateLeft, 0, (v619 and v625 or 0) + v625}
    local v638 = {a0.RotateRight, 80, (v619 and v625 or 0) + v625}
    local v639 = {a0.Brush, 0, 0}
    local v640 = {a0.Bucket, 80, 0}
    local v641 = {a0.Dropper, 0, v625}
    local v642 = {a0.ColorPicker, 80, v625}
    local v643 = {v633, v634, v635, v636, v637, v638, v639, v640, v641, v642}
    for k173, k174 in ipairs(v643) do
        v635 = k174[1]
        v635.Position = UDim2.fromOffset(k174[2], k174[3])
        v635.Size = UDim2.fromOffset(76, v624)
    end

    local DeleteCancel = a0.DeleteCancel
    DeleteCancel.Position = UDim2.fromOffset(0, 0)
    DeleteCancel.Size = UDim2.fromOffset(156, v624)
    DeleteCancel = a0.DeleteHint
    DeleteCancel.Position = UDim2.fromOffset(0, v625)
    DeleteCancel.Size = UDim2.fromOffset(156, v624)
    DeleteCancel = a0.Primary
    DeleteCancel.Position = UDim2.fromOffset(0, v619)
    DeleteCancel.Size = UDim2.fromOffset(156, v626)
    DeleteCancel = a0.Menu
    local v647 = math.floor((AbsoluteSize1.X - v609) / 2)
    local v648
    if v612 then
        v648 = 8
    else
        local v649 = math.floor((AbsoluteSize1.Y - v610) / 2)
    end

    DeleteCancel.Position = UDim2.fromOffset(v647, v648)
    DeleteCancel.Size = UDim2.fromOffset(v609, v610)
    DeleteCancel = a0.Title
    if a0.MenuKind == "Catalogue" then
        v647 = 100
    else
        v647 = v609 - 96
    end

    DeleteCancel.Position = UDim2.fromOffset(12, 8)
    DeleteCancel.Size = UDim2.fromOffset(v647, 48)
    DeleteCancel = a0.CloseButton
    DeleteCancel.Position = UDim2.fromOffset(v609 - 68, 8)
    DeleteCancel.Size = UDim2.fromOffset(56, 48)
    DeleteCancel = a0.Search
    local v650 = math.max(100, v609 - 196)
    DeleteCancel.Position = UDim2.fromOffset(120, 8)
    DeleteCancel.Size = UDim2.fromOffset(v650, 48)
    v650 = v609 - 24
    v630 = 840 <= v609
    local v651
    if v630 then
        v651 = 548
    else
        v651 = v650
    end

    v626 = a0.KeyboardCompact
    local CategoryList1 = a0.CategoryList
    CategoryList1.Position = UDim2.fromOffset(12, 64)
    CategoryList1.Size = UDim2.fromOffset(v651, 51)
    a0.CategoryList.Visible = not v626
    local SubList2 = a0.SubList
    local v654
    if v630 then
        v654 = 64
    else
        v654 = 120
    end

    SubList2.Position = UDim2.fromOffset(v630 and v651 + 20 or 12, v654)
    SubList2.Size = UDim2.fromOffset(v630 and v650 - v651 - 8 or v650, 51)
    local v657 = not v626
    if v657 then
        v657 = false
        if a0.Category ~= "Recent" then
            v657 = a0.Category ~= "Favorites"
        end
    end

    a0.SubList.Visible = v657
    local v658
    if v626 then
        v658 = 64
    else
        if not (not v630 and a0.SubList.Visible) then
            v658 = 120
            -- jump to 793 (out of range)
        end

        v658 = 176
    end

    local ItemList5 = a0.ItemList
    local v659 = math.max(36, v610 - v658 - 8)
    ItemList5.Position = UDim2.fromOffset(12, v658)
    ItemList5.Size = UDim2.fromOffset(v650, v659)
    ItemList5 = a0.Empty
    local v660 = math.max(36, v610 - v658 - 8)
    ItemList5.Position = UDim2.fromOffset(20, v658)
    ItemList5.Size = UDim2.fromOffset(v609 - 40, v660)
    v658 = math.max(1, math.floor((v650 + 2) / 126))
    local v661 = v650 - 6
    local v662 = (v658 - 1) * 8
    v630 = math.floor((v661 - v662) / v658)
    if a0.Compact then
        v651 = 132
    else
        v651 = 164
    end

    if a0.CardWidth ~= v630 or a0.CardHeight ~= v651 then
        for k175, k176 in pairs(a0.ThumbnailItems) do
            v626 = k175:FindFirstChild("Preview")
            if v626 then
                v626:Destroy()
            end

            k176.Loaded = nil
        end
    end

    a0.CardWidth = v630
    a0.Columns = v658
    a0.CardHeight = v651
    a0.Grid.FillDirectionMaxCells = v658
    a0.Grid.CellSize = UDim2.fromOffset(v630, a0.CardHeight)
    for k177, k178 in ipairs(a0.Cards) do
        a0:_layoutCard(k178)
    end

    local Options3 = a0.Options
    Options3.Position = UDim2.fromOffset(12, 64)
    Options3.Size = UDim2.fromOffset(v650, v610 - 76)
    if 620 <= v609 then
        v658 = 2
    else
        v658 = 1
    end

    a0.OptionGrid.FillDirectionMaxCells = v658
    local v669 = math.floor((v650 - 6 - (v658 - 1) * 8) / v658)
    a0.OptionGrid.CellSize = UDim2.fromOffset(v669, 76)
    a0:_queueThumbnails()
end

v41._resize = _resize1

local function _layoutCard(a0, a1)
    local ItemTitle = a1:FindFirstChild("ItemTitle")
    local Price = a1:FindFirstChild("Price")
    local Preview4 = a1:FindFirstChild("Preview")
    local Favorite1 = a1:FindFirstChild("Favorite")
    local v670 = a0.CardHeight - 68
    if ItemTitle then
        ItemTitle.Position = UDim2.fromOffset(8, v670 + 4)
    end

    if Price then
        Price.Position = UDim2.fromOffset(8, a0.CardHeight - 26)
    end

    if Preview4 then
        Preview4.Size = UDim2.new(1, -12, 0, v670)
    end

    if Favorite1 then
        local v671 = a0.CardWidth - 46
        Favorite1.Position = UDim2.fromOffset(v671, 2)
        Favorite1.Size = UDim2.fromOffset(44, 44)
    end
end

v41._layoutCard = _layoutCard

local function _thumbnail1(a0, a1, a2) --[[ Upvalues: createThumbnail (copy) ]]
    createThumbnail(a0, a1, a2, true)
end

v41._thumbnail = _thumbnail1

local function _queueThumbnails1(a0)
    a0.ThumbnailRequest = a0.ThumbnailRequest + 1
    if not a0:_allowed(true) or a0.MenuKind ~= "Catalogue" then
        return
    end

    local ThumbnailRequest1 = a0.ThumbnailRequest
    local CatalogueGeneration2 = a0.CatalogueGeneration
    task.defer(function() --[[ Upvalues: a0 (copy), ThumbnailRequest1 (copy), CatalogueGeneration2 (copy) ]]

        local function current1() --[[ Upvalues: a0 (upvalue), ThumbnailRequest1 (upvalue), CatalogueGeneration2 (upvalue) ]]
            local v672 = a0:_allowed(true)
            if v672 then
                v672 = false
                if a0.MenuKind == "Catalogue" then
                    v672 = false
                    if a0.ThumbnailRequest == ThumbnailRequest1 then
                        v672 = a0.CatalogueGeneration == CatalogueGeneration2
                    end
                end
            end

            return v672
        end

        local v673 = a0:_allowed(true)
        if v673 then
            v673 = false
            if a0.MenuKind == "Catalogue" then
                v673 = false
                if a0.ThumbnailRequest == ThumbnailRequest1 then
                    v673 = a0.CatalogueGeneration == CatalogueGeneration2
                end
            end
        end

        if not v673 then
            return
        end

        v673 = a0.CardHeight + 8
        local v674 = math.max(0, math.floor(a0.ItemList.CanvasPosition.Y / v673) - 1)
        local Y2 = a0.ItemList.CanvasPosition.Y
        local Y3 = a0.ItemList.AbsoluteSize.Y
        local v675 = math.floor((Y2 + Y3) / v673) + 1
        v673 = 0
        for k179, k180 in ipairs(a0.Cards) do
            local v679 = a0:_allowed(true)
            if v679 then
                v679 = false
                if a0.MenuKind == "Catalogue" then
                    v679 = false
                    if a0.ThumbnailRequest == ThumbnailRequest1 then
                        v679 = a0.CatalogueGeneration == CatalogueGeneration2
                    end
                end
            end

            if not v679 then
                return
            end

            v679 = a0.ThumbnailItems[k180]
            local v680 = math.floor((k179 - 1) / a0.Columns)
            if v674 <= v680 then
                if v680 <= v675 then
                    if not v679.Loaded then
                        if not v679.Failed then
                            local v681 = pcall(function() --[[ Upvalues: a0 (upvalue), k180 (copy), v679 (copy) ]]
                                a0:_thumbnail(k180, v679.Name)
                            end)
                            local v682 = v681
                            if v682 then
                                v682 = k180:FindFirstChild("Preview") ~= nil
                            end

                            v679.Loaded = v682
                            v679.Failed = not v679.Loaded
                            if not v681 and k180:FindFirstChild("Preview") then
                                k180.Preview:Destroy()
                            end

                            v673 = v673 + 1
                            if v673 % 2 == 0 then
                                task.wait()
                                -- branch continues at 204
                            end

                            -- branch continues at 204
                        end

                        -- branch continues at 204
                    end

                    -- branch continues at 188
                end
            else
                if v679.Loaded then
                    local Preview5 = k180:FindFirstChild("Preview")
                    if Preview5 then
                        Preview5:Destroy()
                    end

                    v679.Loaded = nil
                end
            end
        end

    end)
end

v41._queueThumbnails = _queueThumbnails1

local function RefreshCatalogue1(a0) --[[ Upvalues: clear (copy), Catalogue (copy), Categories (copy), v43 (copy), label1 (copy) ]]
    if not a0:_allowed(true) or a0.MenuKind ~= "Catalogue" then
        return
    end

    a0.CatalogueGeneration = a0.CatalogueGeneration + 1
    clear(a0.SubList)
    clear(a0.ItemList)
    a0.Cards = {}
    a0.ThumbnailItems = {}
    a0.SubButtons = {}
    local Data4 = a0.Client.Data
    if not Data4 then
        Data4 = {}
    end

    local BaseItems1 = Data4.BaseItems
    if not BaseItems1 then
        BaseItems1 = {}
    end

    local v683 = {
        Policy = "ClassicTouch",
        Data = Data4,
        Category = a0.Category,
        SubCategory = a0.SubCategory,
        SearchQuery = a0.SearchQuery,
        Favorites = a0.Favorites,
        Recents = a0.Recents
    }
    local v684 = Catalogue.Query(v683)
    v683 = v684.Subcategories
    local Objects1 = v684.Objects
    a0.SubCategory = v684.SubCategory
    for k181, k182 in ipairs(Categories) do
        v684 = a0.CategoryButtons[k181]
        local v688 = k182 == a0.Category
        local v689
        if v688 then
            v689 = 3
        else
            v689 = 2
        end

        v684.BorderSizePixel = v689
        local v690
        if not (v688 and v43.Selected) then
            v690 = v43.Line
        end

        v684.BorderColor3 = v690
        if v688 then
            v690 = 0.2
        else
            v690 = 0.5
        end

        v684.BackgroundTransparency = v690
        local v691
        if not (k182 == a0.Category and v43.Accent) then
            v691 = v43.Text
        end

        v684.TextColor3 = v691
    end

    for k183, k184 in ipairs(v683) do
        Data4 = a0:_button(a0.SubList, k184, k184, function() --[[ Upvalues: a0 (copy), k184 (copy) ]]
            a0.SubCategory = k184
            a0:RefreshCatalogue()
        end, true)
        local v695 = math.max(64, #k184 * 9 + 24)
        Data4.Size = UDim2.fromOffset(v695, 48)
        Data4.LayoutOrder = k183
        local v696 = k184 == a0.SubCategory
        local v697
        if v696 then
            v697 = 3
        else
            v697 = 2
        end

        Data4.BorderSizePixel = v697
        local v698
        if not (v696 and v43.Selected) then
            v698 = v43.Line
        end

        Data4.BorderColor3 = v698
        if v696 then
            v698 = 0.2
        else
            v698 = 0.5
        end

        Data4.BackgroundTransparency = v698
        local v699
        if not (k184 == a0.SubCategory and v43.Accent) then
            v699 = v43.Text
        end

        Data4.TextColor3 = v699
        table.insert(a0.SubButtons, Data4)
    end

    for k185, k186 in ipairs(Objects1) do
        local Name1 = k186.Name
        local Info1 = k186.Info
        v683 = tonumber(BaseItems1[Name1]) or 0
        local v705 = not Info1.ItemObject
        if not v705 then
            v705 = 0 < v683
        end

        local v706 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Name = Name1,
            LayoutOrder = k185
        }
        local ItemList6 = a0.ItemList
        local Frame10 = Instance.new("Frame")
        for k187, k188 in pairs(v706) do
            Frame10[k187] = k188
        end

        Frame10.Parent = ItemList6
        k187 = function() --[[ Upvalues: v705 (copy), a0 (copy), Name1 (copy), Info1 (copy) ]]
            if not v705 then
                local Title3 = a0.Title
                local v710 = "None owned\n" .. Name1
                if Title3.Text ~= v710 then
                    Title3.Text = v710
                end

                return
            end

            a0.Search:ReleaseFocus()
            if a0.Callbacks.SelectItem then
                a0.Callbacks.SelectItem(Name1, Info1.Type)
            end
        end

        k188 = true
        local v711 = a0:_button(Frame10, "Choose", "", k187, k188)
        v711.Size = UDim2.fromScale(1, 1)
        Frame10:SetAttribute("ItemName", Name1)
        k187 = -16
        k188 = 0
        local v712 = UDim2.new(1, k187, k188, 36)
        k187 = 15
        local v713 = label1(Frame10, Name1, v712, UDim2.new(), k187)
        v713.Name = "ItemTitle"
        v713.TextWrapped = true
        v713.TextTruncate = Enum.TextTruncate.None
        v713.ZIndex = 2
        if Info1.ItemObject then
            if 0 < v683 then
                v713 = "Owned \195\151" .. v683
                if v713 then
                    -- jump to 354
                end
            end

            v713 = "None owned"
        else
            v713 = "$" .. tostring(Info1.Price or 0)
        end

        local v714 = label1
        k187 = 1
        k188 = -16
        local v715 = UDim2.new(k187, k188, 0, 22)
        k187 = UDim2.new
        local v716 = k187()
        k188 = 15
        local v717
        if not (v705 and v43.Accent) then
            v717 = v43.Danger
        end

        v683 = v714(Frame10, v713, v715, v716, k188, v717)
        v683.Name = "Price"
        v683.ZIndex = 2
        k188 = a0.Favorites
        v716 = k188[Name1]
        if v716 then
            v715 = "\226\152\133"
        else
            v715 = "\226\152\134"
        end

        v716 = function() --[[ Upvalues: a0 (copy), Name1 (copy), Frame10 (copy), v43 (upvalue) ]]
            a0.Favorites[Name1] = not a0.Favorites[Name1] or nil
            a0.State.favorites = table.clone(a0.Favorites)
            if a0.Callbacks.Setting then
                local v718 = table.clone(a0.Favorites)
                a0.Callbacks.Setting("favorites", v718)
            end

            if a0.Category == "Favorites" then
                a0:RefreshCatalogue()
                return
            end

            local Favorite2 = Frame10.Favorite
            local v719
            if a0.Favorites[Name1] then
                v719 = "\226\152\133"
            else
                v719 = "\226\152\134"
            end

            if Favorite2.Text ~= v719 then
                Favorite2.Text = v719
            end

            local Favorite3 = Frame10.Favorite
            v719 = a0.Favorites[Name1] == true
            local v720
            if v719 then
                v720 = 3
            else
                v720 = 2
            end

            Favorite3.BorderSizePixel = v720
            local v721
            if not (v719 and v43.Selected) then
                v721 = v43.Line
            end

            Favorite3.BorderColor3 = v721
            if v719 then
                v721 = 0.2
            else
                v721 = 0.5
            end

            Favorite3.BackgroundTransparency = v721
        end

        k188 = true
        local v722 = a0:_button(Frame10, "Favorite", v715, v716, k188)
        v722.ZIndex = 3
        v722.TextSize = 25
        local v723 = a0.Favorites[Name1] == true
        local v724
        if v723 then
            v724 = 3
        else
            v724 = 2
        end

        v722.BorderSizePixel = v724
        local v725
        if not (v723 and v43.Selected) then
            v725 = v43.Line
        end

        v722.BorderColor3 = v725
        if v723 then
            v725 = 0.2
        else
            v725 = 0.5
        end

        v722.BackgroundTransparency = v725
        v725 = {Name = Name1}
        a0.ThumbnailItems[Frame10] = v725
        table.insert(a0.Cards, Frame10)
        a0:_layoutCard(Frame10)
    end

    local Title4 = a0.Title
    local v726 = "Catalogue\n" .. #Objects1 .. " objects"
    if Title4.Text ~= v726 then
        Title4.Text = v726
    end

    Title4 = a0.Empty
    if a0.Category == "Recent" then
        v726 = "Objects you use will appear here."
    else
        if a0.Category == "Favorites" then
            v726 = "Tap \226\152\134 on any object to save it here."
        else
            v726 = "No matching objects. Try another search or category."
        end
    end

    if Title4.Text ~= v726 then
        Title4.Text = v726
    end

    a0.Empty.Visible = #Objects1 == 0
    a0.ItemList.CanvasPosition = Vector2.zero
    a0:_resize()
end

v41.RefreshCatalogue = RefreshCatalogue1

local function _open1(a0, a1)
    if not a0:_allowed() then
        return false
    end

    a0.MenuOpen = true
    a0.MenuKind = a1
    a0.Dimmer.Visible = true
    a0.Controls.Visible = false
    a0.World.Visible = false
    local Search1 = a0.Search
    a0.Catalogue.Visible = a1 == "Catalogue"
    Search1.Visible = a1 == "Catalogue"
    Search1 = true
    if a1 ~= "Options" then
        Search1 = a1 == "RotationSteps"
    end

    a0.Options.Visible = Search1
    a0:_resize()
    return true
end

v41._open = _open1

local function OpenCatalogue1(a0)
    if a0:_open("Catalogue") then
        a0:RefreshCatalogue()
    end
end

v41.OpenCatalogue = OpenCatalogue1

local function OpenRotationSteps1(a0) --[[ Upvalues: clear (copy), t1 (copy), v43 (copy), label1 (copy) ]]
    if not a0:_open("RotationSteps") then
        return
    end

    local Title5 = a0.Title
    if Title5.Text ~= "Rotation increment" then
        Title5.Text = "Rotation increment"
    end

    clear(a0.Options)
    local v727 = a0.State.rotateStep or 90
    for k189, k190 in ipairs(t1) do
        local v731 = "RotationStep" .. k190
        local v732 = a0:_button(a0.Options, v731, "", function() --[[ Upvalues: a0 (copy), k190 (copy) ]]
            if a0.Callbacks.RotationStep then
                a0.Callbacks.RotationStep(k190)
            end

        end, true)
        v732.LayoutOrder = k189
        local v733 = k190 == v727
        local v734
        if v733 then
            v734 = 3
        else
            v734 = 2
        end

        v732.BorderSizePixel = v734
        local v735
        if not (v733 and v43.Selected) then
            v735 = v43.Line
        end

        v732.BorderColor3 = v735
        if v733 then
            v735 = 0.2
        else
            v735 = 0.5
        end

        v732.BackgroundTransparency = v735
        local v736 = tostring(k190)
        v731 = v736 .. "\194\176"
        local v737 = UDim2.new(1, -24, 0, 27)
        local v738 = UDim2.fromOffset(12, 8)
        label1(v732, v731, v737, v738, 20)
        local v739 = label1
        if k190 == v727 then
            v731 = "Current setting"
        else
            v731 = "Rotate " .. k190 .. "\194\176 per tap"
        end

        local v740 = UDim2.new(1, -24, 0, 28)
        local v741 = UDim2.fromOffset(12, 36)
        v739(v732, v731, v740, v741, 14, v43.Muted)
    end

    a0.Options.CanvasPosition = Vector2.zero
    a0:_resize()
end

v41.OpenRotationSteps = OpenRotationSteps1

local function OpenOptions1(a0) --[[ Upvalues: clear (copy), label1 (copy), v43 (copy) ]]
    if not a0:_open("Options") then
        return
    end

    local Title6 = a0.Title
    if Title6.Text ~= "Build options" then
        Title6.Text = "Build options"
    end

    clear(a0.Options)
    a0.HistoryOptionButtons = {}
    local v742 = {}
    local v743 = {"Catalogue", "Object catalogue", "Furniture, decoration and traps"}
    local v744 = {"Undo", "Undo", "Restore the previous saved change"}
    local v745 = {"Redo", "Redo", "Reapply an undone change"}
    local v746 = {"SelectExisting", "Edit an object", "Aim at an object, then tap Select"}
    local v747 = {}
    local v748
    if a0.State.deleting then
        v748 = "Stop deleting"
    else
        v748 = "Delete objects"
    end

    v747[1] = "DeleteMode"
    v747[2] = v748
    v747[3] = "Aim, then hold Delete to confirm"
    local v749 = {}
    local v750
    if a0.State.editing then
        v750 = "Cancel edit"
    else
        v750 = "Cancel preview"
    end

    v749[1] = "Deselect"
    v749[2] = v750
    v749[3] = "Put away the selected object"
    v748 = {"Customize", "Customize base", "Walls, floors and base upgrades"}
    v750 = {"SaveSlots", "Save slots", "Save or load a base layout"}
    local v751 = {"SwitchModern", "Modern mode", "Switch building controls"}
    local v752 = {"Exit", "Done building", "Return to normal controls"}
    v742[1] = v743
    v742[2] = v744
    v742[3] = v745
    v742[4] = v746
    v742[5] = v747
    v742[6] = v749
    v742[7] = v748
    v742[8] = v750
    v742[9] = v751
    v742[10] = v752
    if a0.State.canDeleteAll then
        v745 = #v742 - 1
        v747 = "DeleteAll"
        local v753 = {v747, "Delete all objects", "Confirm before deleting"}
        table.insert(v742, v745, v753)
    end

    if a0.State.mode == "Paint" then
        v747 = "ResetPaint"
        v746 = {v747, "Reset paint", "Review before restoring original colours"}
        table.insert(v742, #v742, v746)
    else
        if not a0.State.deleting then
            v747 = "RotationSteps"
            v751 = a0.State.rotateStep or 90
            v746 = {v747, "Rotation increment", "Currently " .. v751 .. "\194\176 per tap"}
            table.insert(v742, 2, v746)
        end
    end

    for k191, k192 in ipairs(v742) do
        local v757 = a0:_button(a0.Options, k192[1], "", function() --[[ Upvalues: a0 (copy), k192 (copy) ]]
            a0:_action(k192[1])
        end, true)
        v757.LayoutOrder = k191
        local v758 = label1
        local v759 = k192[2]
        local v760 = UDim2.new(1, -24, 0, 27)
        local v761 = UDim2.fromOffset(12, 8)
        if k192[1] == "DeleteMode" or k192[1] == "DeleteAll" then
            local Danger2 = v43.Danger
            if Danger2 then
                -- jump to 231
            end
        end

        local Text4 = v43.Text
        local v762 = v758(v757, v759, v760, v761, 18, Text4)
        local v763 = UDim2.new(1, -24, 0, 28)
        local v764 = UDim2.fromOffset(12, 36)
        label1(v757, k192[3], v763, v764, 14, v43.Muted)
        if k192[1] == "Undo" or k192[1] == "Redo" then
            local v765 = {Button = v757, Title = v762}
            a0.HistoryOptionButtons[k192[1]] = v765
        end
    end

    a0:_updateHistory()
    a0.Options.CanvasPosition = Vector2.zero
    a0:_resize()
end

v41.OpenOptions = OpenOptions1

local function _updateHistory(a0) --[[ Upvalues: v43 (copy) ]]
    for k193, k194 in pairs(a0.HistoryButtons) do
        local v769
        if k193 == "Undo" then
            v769 = "undoCount"
        else
            v769 = "redoCount"
        end

        local v770 = math.max(0, tonumber(a0.State[v769]) or 0)
        local v771 = a0:_allowed()
        if v771 then
            v771 = not a0.State.busy
            if v771 then
                v771 = 0 < v770
            end
        end

        local v772 = k193 .. "\n(" .. v770 .. ")"
        if k194.Text ~= v772 then
            k194.Text = v772
        end

        k194.Active = v771
        k194.Interactable = v771
        local v773
        if not (v771 and v43.Text) then
            v773 = v43.Muted
        end

        k194.TextColor3 = v773
        if v771 then
            v773 = 0
        else
            v773 = 0.45
        end

        k194.TextTransparency = v773
        if v771 then
            v773 = 0.5
        else
            v773 = 0.7
        end

        k194.BackgroundTransparency = v773
        v773 = a0.HistoryOptionButtons[k193]
        if v773 and v773.Button.Parent then
            v773.Button.Active = v771
            v773.Button.Interactable = v771
            local Title7 = v773.Title
            local v774 = k193 .. " (" .. v770 .. ")"
            if Title7.Text ~= v774 then
                Title7.Text = v774
            end

            local v775
            if not (v771 and v43.Text) then
                v775 = v43.Muted
            end

            v773.Title.TextColor3 = v775
            if v771 then
                v775 = 0
            else
                v775 = 0.45
            end

            v773.Title.TextTransparency = v775
        end
    end
end

v41._updateHistory = _updateHistory

local function CloseMenu1(a0)
    a0.MenuOpen = false
    a0.MenuKind = nil
    a0.ThumbnailRequest = a0.ThumbnailRequest + 1
    a0.Search:ReleaseFocus()
    for k195, k196 in pairs(a0.ThumbnailItems) do
        local Preview6 = k195:FindFirstChild("Preview")
        if Preview6 then
            Preview6:Destroy()
        end

        k196.Loaded = nil
    end

    a0.Dimmer.Visible = false
    a0:Update(a0.State)
end

v41.CloseMenu = CloseMenu1

local function SetActive1(a0, a1)
    a0.Active = a1 == true
    if not a0.Active then
        a0:CloseMenu()
    end

    a0:Update(a0.State)
end

v41.SetActive = SetActive1

local function Owns1(a0, a1)
    local v779 = false
    if a1 ~= nil then
        local v783 = a1:IsDescendantOf(a0.Root) or a1:IsDescendantOf(a0.ControlsGui)
    end

    return v779
end

v41.Owns = Owns1

local function Update1(a0, a1) --[[ Upvalues: Preferences (copy), v43 (copy) ]]
    local v784 = a1
    if not v784 then
        v784 = {}
    end

    a0.State = v784
    a1 = a0.State
    if a1.favorites and a1.favorites ~= a0.FavoritesSource then
        a0.FavoritesSource = a1.favorites
        a0.Favorites = Preferences.Favorites(a1.favorites)
    end

    if a1.recent and a1.recent ~= a0.RecentsSource then
        a0.RecentsSource = a1.recent
        a0.Recents = Preferences.Recents(a1.recent)
    end

    local v785 = a1.deleting == true
    local v786 = a1.mode == "Paint"
    local v788 = a0.Active and not a1.blocked
    a0.Root.Enabled = v788
    a0.ControlsGui.Enabled = v788
    local v789 = not a0.MenuOpen
    a0.World.Visible = v789
    a0.Controls.Visible = not a0.MenuOpen
    v788 = a1.itemName
    local v790 = a1.paintMode or a1.itemName
    if v786 then
        v788 = ({PaintBrush = "Paint brush", PaintBucket = "Paint bucket", ColorDropper = "Colour sample"})[v790] or "Paint"
    end

    local v794 = not v785 and not v786 and not v788
    v789 = a0.ItemLabel
    local v795
    if v785 then
        v795 = "Delete objects"
    else
        if a1.editing then
            v795 = "Editing " .. (v788 or "object")
            if v795 then
                -- jump to 126
            end
        end

        local v797 = v788 or a1.editTargetName or "Select an object"
    end

    if v789.Text ~= v795 then
        v789.Text = v795
    end

    local v798
    if not (v785 and v43.Danger) then
        v798 = v43.Text
    end

    a0.ItemLabel.TextColor3 = v798
    local status = a1.status
    if not status or status == "" then
        if v785 then
            v798 = "Hold Delete. Release to cancel."
        else
            if v786 then
                if v790 == "ColorDropper" then
                    v798 = "Aim at a surface to sample."
                    -- jump to 168 (out of range)
                end

                v798 = "Aim at a surface to paint."
            else
                if a1.editing then
                    v798 = "Move or rotate. Tap Apply to save."
                else
                    if v788 then
                        v798 = "Aim at a surface. Tap Place."
                    else
                        v798 = "Aim at an object to edit, or open Catalogue."
                    end
                end
            end
        end

        status = v798
    end

    v798 = a0.StatusLabel
    if v798.Text ~= status then
        v798.Text = status
    end

    local v799
    if not (a1.valid == false and v43.Danger) then
        v799 = v43.Muted
    end

    a0.StatusLabel.TextColor3 = v799
    v798 = a0.PaintButton
    if v786 then
        v799 = "Objects"
    else
        v799 = "Paint"
    end

    if v798.Text ~= v799 then
        v798.Text = v799
    end

    v798 = a0.PaintButton
    if v786 then
        v799 = 3
    else
        v799 = 2
    end

    v798.BorderSizePixel = v799
    local v800
    if not (v786 and v43.Selected) then
        v800 = v43.Line
    end

    v798.BorderColor3 = v800
    if v786 then
        v800 = 0.2
    else
        v800 = 0.5
    end

    v798.BackgroundTransparency = v800
    v798 = a0.Axis
    v800 = "Axis " .. tostring(a1.axis or "Y")
    if v798.Text ~= v800 then
        v798.Text = v800
    end

    local v801 = tostring(a1.rotateStep or 90)
    v798 = a0.RotateLeft
    v800 = "\226\136\146 " .. v801 .. "\194\176"
    if v798.Text ~= v800 then
        v798.Text = v800
    end

    v798 = a0.RotateRight
    v800 = "+ " .. v801 .. "\194\176"
    if v798.Text ~= v800 then
        v798.Text = v800
    end

    v798 = a0.Precision
    if a1.precision then
        v800 = "Precise \226\156\147"
    else
        v800 = "Precise"
    end

    if v798.Text ~= v800 then
        v798.Text = v800
    end

    v798 = a0.Precision
    v800 = a1.precision
    local v802
    if v800 then
        v802 = 3
    else
        v802 = 2
    end

    v798.BorderSizePixel = v802
    local v803
    if not (v800 and v43.Selected) then
        v803 = v43.Line
    end

    v798.BorderColor3 = v803
    if v800 then
        v803 = 0.2
    else
        v803 = 0.5
    end

    v798.BackgroundTransparency = v803
    local SelectExisting = a0.SelectExisting
    v800 = {a0.Cancel, SelectExisting, a0.Axis, a0.Precision, a0.RotateLeft, a0.RotateRight}
    for k197, k198 in ipairs(v800) do
        local v810 = not v786 and not v785 and not v794
        k198.Visible = v810
    end

    k198 = a0.Bucket
    local v811 = {a0.Brush, k198, a0.Dropper, a0.ColorPicker}
    for k199, k200 in ipairs(v811) do
        local v817 = v786 and not v785
        k200.Visible = v817
    end

    local Brush = a0.Brush
    local v818 = v790 == "PaintBrush"
    local v819
    if v818 then
        v819 = 3
    else
        v819 = 2
    end

    Brush.BorderSizePixel = v819
    local v820
    if not (v818 and v43.Selected) then
        v820 = v43.Line
    end

    Brush.BorderColor3 = v820
    if v818 then
        v820 = 0.2
    else
        v820 = 0.5
    end

    Brush.BackgroundTransparency = v820
    Brush = a0.Bucket
    v818 = v790 == "PaintBucket"
    if v818 then
        v820 = 3
    else
        v820 = 2
    end

    Brush.BorderSizePixel = v820
    local v821
    if not (v818 and v43.Selected) then
        v821 = v43.Line
    end

    Brush.BorderColor3 = v821
    if v818 then
        v821 = 0.2
    else
        v821 = 0.5
    end

    Brush.BackgroundTransparency = v821
    Brush = a0.Dropper
    v818 = v790 == "ColorDropper"
    if v818 then
        v821 = 3
    else
        v821 = 2
    end

    Brush.BorderSizePixel = v821
    local v822
    if not (v818 and v43.Selected) then
        v822 = v43.Line
    end

    Brush.BorderColor3 = v822
    if v818 then
        v822 = 0.2
    else
        v822 = 0.5
    end

    Brush.BackgroundTransparency = v822
    a0.DeleteCancel.Visible = v785
    a0.DeleteHint.Visible = v785
    local Primary = a0.Primary
    local v823
    if v785 then
        v823 = "Hold Delete"
    else
        if v786 then
            if v790 == "ColorDropper" then
                v823 = "Sample colour"
                -- jump to 483 (out of range)
            end

            v823 = "Paint"
        else
            if v794 then
                v823 = "Select object"
            else
                if a1.editing then
                    v823 = "Apply"
                else
                    v823 = "Place"
                end
            end
        end
    end

    if Primary.Text ~= v823 then
        Primary.Text = v823
    end

    a0.Primary.BackgroundColor3 = v43.Card
    local v824
    if not (v785 and v43.Danger) then
        v824 = v43.Text
    end

    a0.Primary.TextColor3 = v824
    a0.Primary.Interactable = not a1.busy
    if a1.busy then
        v824 = 0.45
    else
        v824 = 0
    end

    a0.Primary.TextTransparency = not a1.busy
    a0:_updateHistory()
    local v825
    if not (v785 and v43.Danger) then
        local v826
        if not (a1.valid == false and v43.Danger) then
            v826 = v43.Accent
        end
    end

    a0.Reticle.BackgroundColor3 = v825
    local v827 = tonumber(a1.deleteProgress) or 0
    local v828 = math.clamp(v827, 0, 1)
    local v829 = not a0.MenuOpen
    if v829 then
        v829 = v785
        if v829 then
            v829 = 0 < v828
        end
    end

    a0.Progress.Visible = v829
    a0.ProgressFill.Size = UDim2.fromScale(v828, 1)
    if typeof(a1.color) == "Color3" then
        a0.ColorSwatch.BackgroundColor3 = a1.color
    end

    local ColorPicker2 = a0.ColorPicker
    ColorPicker2.BorderSizePixel = 2
    ColorPicker2.BorderColor3 = v43.Line
    ColorPicker2.BackgroundTransparency = 0.5
    if v785 then
        v828 = "Delete"
    else
        if v786 then
            v828 = "Paint"
        else
            if v794 then
                v828 = "Select"
            else
                v828 = "Object"
            end
        end
    end

    if a0.LayoutKind ~= v828 then
        a0.LayoutKind = v828
        a0:_resize()
    end
end

v41.Update = Update1

local function Destroy1(a0)
    if a0.Destroyed then
        return
    end

    a0:CloseMenu()
    a0.Destroyed = true
    for k201, k202 in ipairs(a0.Connections) do
        k202:Disconnect()
    end

    if a0.AimCameraConnection then
        a0.AimCameraConnection:Disconnect()
    end

    a0.Root:Destroy()
    a0.ControlsGui:Destroy()
end

v41.Destroy = Destroy1

local function InstallLauncher(a0) --[[ Upvalues: UserInputService (copy), GuiService (copy), v43 (copy), RunService (copy) ]]
    if a0.ClassicMobileLauncher then
        return a0.ClassicMobileLauncher
    end

    local v833 = a0.HUD and a0.HUD:FindFirstChild("BaseEdit")
    if not (v833 and v833:IsA("GuiObject")) then
        return nil
    end

    local v834 = {}
    local v835 = {}
    local t7 = {}
    local v836 = false
    local v837 = false
    local t8 = {}
    local v838 = {
        Name = "ClassicLauncherOrigin",
        BackgroundTransparency = 1,
        Visible = false,
        Size = UDim2.fromOffset(0, 0),
        Position = UDim2.fromOffset(0, 0)
    }
    local Parent7 = v833.Parent
    local Frame11 = Instance.new("Frame")
    for k203, k204 in pairs(v838) do
        Frame11[k203] = k204
    end

    Frame11.Parent = Parent7

    local function set(a0, a1, a2) --[[ Upvalues: v834 (ref) ]]
        local v842 = v834[a0]
        if not v842 then
            v842 = {}
            v834[a0] = v842
        end

        if v842[a1] == nil then
            v842[a1] = a0[a1]
        end

        if a0[a1] ~= a2 then
            a0[a1] = a2
        end
    end

    local function removeConstraints(a0) --[[ Upvalues: v835 (ref) ]]
        local v843 = a0:GetChildren()
        for k205, k206 in ipairs(v843) do
            if k206:IsA("UIListLayout") or k206:IsA("UIGridLayout") or k206:IsA("UIAspectRatioConstraint") or k206:IsA("UISizeConstraint") or k206:IsA("UIScale") or k206:IsA("UICorner") then
                v835[k206] = a0
                k206.Parent = nil
            end
        end
    end

    local t9 = {}

    local function restore() --[[ Upvalues: v834 (ref), v835 (ref), t9 (ref), v836 (ref) ]]
        for k207, k208 in pairs(v834) do
            if k207.Parent then
                for k209, k210 in pairs(k208) do
                    k207[k209] = k210
                end
            end
        end

        for k211, k212 in pairs(v835) do
            if k212.Parent then
                k211.Parent = k212
            else
                k211:Destroy()
            end
        end

        for k213, k214 in ipairs(t9) do
            k214:Destroy()
        end

        v834 = {}
        v835 = {}
        t9 = {}
        v836 = false
    end

    local function Refresh(a0) --[[ Upvalues: v837 (ref), v833 (copy), UserInputService (upvalue), a0 (copy), v836 (ref), restore (copy), removeConstraints (copy), v834 (ref), GuiService (upvalue), Frame11 (copy), v43 (upvalue) ]]
        if not (not v837 and v833.Parent) then
            return
        end

        local TouchEnabled = UserInputService.TouchEnabled
        if TouchEnabled then
            TouchEnabled = UserInputService.PreferredInput == Enum.PreferredInput.Touch
        end

        local Data5 = a0.Data
        if Data5 then
            Data5 = a0.Data.BuildSystem == "Classic"
        end

        if not (TouchEnabled and Data5) then
            if v836 then
                restore()
            end

            return
        end

        v836 = true
        removeConstraints(v833)
        local v861 = v833
        local zero2 = Vector2.zero
        Data5 = v834[v861]
        if not Data5 then
            Data5 = {}
            v834[v861] = Data5
        end

        if Data5.AnchorPoint == nil then
            Data5.AnchorPoint = v861.AnchorPoint
        end

        if v861.AnchorPoint ~= zero2 then
            v861.AnchorPoint = zero2
        end

        v861 = v833
        zero2 = Enum.AutomaticSize.None
        TouchEnabled = v834[v861]
        if not TouchEnabled then
            TouchEnabled = {}
            v834[v861] = TouchEnabled
        end

        if TouchEnabled.AutomaticSize == nil then
            TouchEnabled.AutomaticSize = v861.AutomaticSize
        end

        if v861.AutomaticSize ~= zero2 then
            v861.AutomaticSize = zero2
        end

        v861 = v833
        zero2 = Enum.SizeConstraint.RelativeXY
        local v862 = v834[v861]
        if not v862 then
            v862 = {}
            v834[v861] = v862
        end

        if v862.SizeConstraint == nil then
            v862.SizeConstraint = v861.SizeConstraint
        end

        if v861.SizeConstraint ~= zero2 then
            v861.SizeConstraint = zero2
        end

        v861 = v833
        local v863 = UDim2.fromOffset(236, 104)
        local v864 = v834[v861]
        if not v864 then
            v864 = {}
            v834[v861] = v864
        end

        if v864.Size == nil then
            v864.Size = v861.Size
        end

        if v861.Size ~= v863 then
            v861.Size = v863
        end

        local v865 = GuiService:GetGuiInset()
        local v866 = Frame11.AbsolutePosition + v865
        local v867 = math.max(0, v865.X - v866.X) + 12
        local Y4 = v866.Y
        local v868 = math.max(0, v865.Y - Y4) + 8
        local v869 = v833
        local v870 = UDim2.fromOffset(v867, v868)
        v866 = v834[v869]
        if not v866 then
            v866 = {}
            v834[v869] = v866
        end

        if v866.Position == nil then
            v866.Position = v869.Position
        end

        if v869.Position ~= v870 then
            v869.Position = v870
        end

        v869 = v833
        v868 = v834[v869]
        if not v868 then
            v868 = {}
            v834[v869] = v868
        end

        if v868.BackgroundTransparency == nil then
            v868.BackgroundTransparency = v869.BackgroundTransparency
        end

        if v869.BackgroundTransparency ~= 1 then
            v869.BackgroundTransparency = 1
        end

        v869 = v833
        v867 = v834[v869]
        if not v867 then
            v867 = {}
            v834[v869] = v867
        end

        if v867.BorderSizePixel == nil then
            v867.BorderSizePixel = v869.BorderSizePixel
        end

        if v869.BorderSizePixel ~= 0 then
            v869.BorderSizePixel = 0
        end

        local v871 = "UnclaimBase"
        v865 = {"BaseObjects", "CustomizeBase", "BaseSaveSlots", v871}
        for k215, k216 in ipairs(v865) do
            local v875 = v833:FindFirstChild(k216)
            if v875 then
                if v875:IsA("TextButton") then
                    removeConstraints(v875)
                    local zero3 = Vector2.zero
                    local v876 = v834[v875]
                    if not v876 then
                        v876 = {}
                        v834[v875] = v876
                    end

                    if v876.AnchorPoint == nil then
                        v876.AnchorPoint = v875.AnchorPoint
                    end

                    if v875.AnchorPoint ~= zero3 then
                        v875.AnchorPoint = zero3
                    end

                    zero3 = Enum.AutomaticSize.None
                    v876 = v834[v875]
                    if not v876 then
                        v876 = {}
                        v834[v875] = v876
                    end

                    if v876.AutomaticSize == nil then
                        v876.AutomaticSize = v875.AutomaticSize
                    end

                    if v875.AutomaticSize ~= zero3 then
                        v875.AutomaticSize = zero3
                    end

                    zero3 = Enum.SizeConstraint.RelativeXY
                    v876 = v834[v875]
                    if not v876 then
                        v876 = {}
                        v834[v875] = v876
                    end

                    if v876.SizeConstraint == nil then
                        v876.SizeConstraint = v875.SizeConstraint
                    end

                    if v875.SizeConstraint ~= zero3 then
                        v875.SizeConstraint = zero3
                    end

                    v876 = (k215 - 1) % 2 * 122
                    local v877 = UDim2.fromOffset(v876, math.floor((k215 - 1) / 2) * 56)
                    v876 = v834[v875]
                    if not v876 then
                        v876 = {}
                        v834[v875] = v876
                    end

                    if v876.Position == nil then
                        v876.Position = v875.Position
                    end

                    if v875.Position ~= v877 then
                        v875.Position = v877
                    end

                    local v878 = UDim2.fromOffset(114, 48)
                    local v879 = v834[v875]
                    if not v879 then
                        v879 = {}
                        v834[v875] = v879
                    end

                    if v879.Size == nil then
                        v879.Size = v875.Size
                    end

                    if v875.Size ~= v878 then
                        v875.Size = v878
                    end

                    v878 = v834[v875]
                    if not v878 then
                        v878 = {}
                        v834[v875] = v878
                    end

                    if v878.TextScaled == nil then
                        v878.TextScaled = v875.TextScaled
                    end

                    if v875.TextScaled ~= false then
                        v875.TextScaled = false
                    end

                    v878 = v834[v875]
                    if not v878 then
                        v878 = {}
                        v834[v875] = v878
                    end

                    if v878.TextSize == nil then
                        v878.TextSize = v875.TextSize
                    end

                    if v875.TextSize ~= 16 then
                        v875.TextSize = 16
                    end

                    v878 = v834[v875]
                    if not v878 then
                        v878 = {}
                        v834[v875] = v878
                    end

                    if v878.TextWrapped == nil then
                        v878.TextWrapped = v875.TextWrapped
                    end

                    if v875.TextWrapped ~= true then
                        v875.TextWrapped = true
                    end

                    local v880 = Font.fromEnum(Enum.Font.Code)
                    local v881 = v834[v875]
                    if not v881 then
                        v881 = {}
                        v834[v875] = v881
                    end

                    if v881.FontFace == nil then
                        v881.FontFace = v875.FontFace
                    end

                    if v875.FontFace ~= v880 then
                        v875.FontFace = v880
                    end

                    local v882
                    if not (k216 == "UnclaimBase" and v43.Danger) then
                        v882 = v43.Text
                    end

                    v881 = v834[v875]
                    if not v881 then
                        v881 = {}
                        v834[v875] = v881
                    end

                    if v881.TextColor3 == nil then
                        v881.TextColor3 = v875.TextColor3
                    end

                    if v875.TextColor3 ~= v882 then
                        v875.TextColor3 = v882
                    end

                    if k216 ~= "UnclaimBase" then
                        v882 = v834[v875]
                        if not v882 then
                            v882 = {}
                            v834[v875] = v882
                        end

                        if v882.AutoButtonColor == nil then
                            v882.AutoButtonColor = v875.AutoButtonColor
                        end

                        if v875.AutoButtonColor ~= false then
                            v875.AutoButtonColor = false
                        end

                        v882 = v43.Card
                        local v883 = v834[v875]
                        if not v883 then
                            v883 = {}
                            v834[v875] = v883
                        end

                        if v883.BackgroundColor3 == nil then
                            v883.BackgroundColor3 = v875.BackgroundColor3
                        end

                        if v875.BackgroundColor3 ~= v882 then
                            v875.BackgroundColor3 = v882
                        end
                    end

                    v882 = v834[v875]
                    if not v882 then
                        v882 = {}
                        v834[v875] = v882
                    end

                    if v882.BackgroundTransparency == nil then
                        v882.BackgroundTransparency = v875.BackgroundTransparency
                    end

                    if v875.BackgroundTransparency ~= 0.5 then
                        v875.BackgroundTransparency = 0.5
                    end

                    v882 = v43.Line
                    local v884 = v834[v875]
                    if not v884 then
                        v884 = {}
                        v834[v875] = v884
                    end

                    if v884.BorderColor3 == nil then
                        v884.BorderColor3 = v875.BorderColor3
                    end

                    if v875.BorderColor3 ~= v882 then
                        v875.BorderColor3 = v882
                    end

                    v882 = v834[v875]
                    if not v882 then
                        v882 = {}
                        v834[v875] = v882
                    end

                    if v882.BorderSizePixel == nil then
                        v882.BorderSizePixel = v875.BorderSizePixel
                    end

                    if v875.BorderSizePixel ~= 2 then
                        v875.BorderSizePixel = 2
                    end

                    v882 = Enum.BorderMode.Inset
                    local v885 = v834[v875]
                    if not v885 then
                        v885 = {}
                        v834[v875] = v885
                    end

                    if v885.BorderMode == nil then
                        v885.BorderMode = v875.BorderMode
                    end

                    if v875.BorderMode ~= v882 then
                        v875.BorderMode = v882
                    end
                end
            end
        end
    end

    t8.Refresh = Refresh

    local function Destroy2(a0) --[[ Upvalues: v837 (ref), t7 (copy), restore (copy), Frame11 (copy), a0 (copy) ]]
        if v837 then
            return
        end

        v837 = true
        for k217, k218 in ipairs(t7) do
            k218:Disconnect()
        end

        restore()
        Frame11:Destroy()
        if a0.ClassicMobileLauncher == a0 then
            a0.ClassicMobileLauncher = nil
        end
    end

    t8.Destroy = Destroy2
    local v889 = UserInputService:GetPropertyChangedSignal("PreferredInput")
    local v890 = v889:Connect(function() --[[ Upvalues: t8 (copy) ]]
        t8:Refresh()
    end)
    table.insert(t7, v890)
    local v891 = 0
    local v892 = RunService.RenderStepped:Connect(function(a0) --[[ Upvalues: v891 (ref), t8 (copy) ]]
        v891 = v891 + a0
        if 0.25 <= v891 then
            v891 = 0
            t8:Refresh()
        end

    end)
    table.insert(t7, v892)
    local v893 = v833.Destroying:Connect(function() --[[ Upvalues: t8 (copy) ]]
        t8:Destroy()
    end)
    table.insert(t7, v893)
    a0.ClassicMobileLauncher = t8
    t8:Refresh()
    return t8
end

v41.InstallLauncher = InstallLauncher
v3.MobileUI = v41
v41 = {}
v41.__index = v41
local v894 = Color3.new(1, 1, 1)
local v895 = Color3.fromRGB(150, 155, 150)

local function new2(a0, a1) --[[ Upvalues: v41 (copy), v894 (copy), v895 (copy) ]]
    local v896 = {Active = false, Destroyed = false}
    local v897 = a1
    if not v897 then
        v897 = {}
    end

    v896.Callbacks = v897
    v896.Connections = {}
    v896.Buttons = {}
    v896.Counts = {Undo = 0, Redo = 0}
    local v898 = setmetatable(v896, v41)
    local v899 = {
        Name = "ClassicDesktopHistory",
        Enabled = false,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 35,
        ScreenInsets = Enum.ScreenInsets.None,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }
    local PlayerGui2 = a0.Player:WaitForChild("PlayerGui")
    v896 = Instance.new("ScreenGui")
    for k219, k220 in pairs(v899) do
        v896[k219] = k220
    end

    v896.Parent = PlayerGui2
    v898.Root = v896
    k219 = -56
    v899 = {
        Name = "History",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Active = true,
        Position = UDim2.new(0, 20, 1, k219),
        Size = UDim2.fromOffset(270, 40)
    }
    local Root4 = v898.Root
    v896 = Instance.new("Frame")
    for k221, k222 in pairs(v899) do
        v896[k221] = k222
    end

    v896.Parent = Root4
    v898.Row = v896
    local v906 = "Undo"
    local v907 = "Redo"
    v899 = {v906, v907}
    for k223, k224 in ipairs(v899) do
        local v913 = (k223 - 1) * 138
        k221 = {
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 0.28,
            BorderSizePixel = 0,
            Active = false,
            Interactable = false,
            Selectable = false,
            Name = k224,
            Position = UDim2.fromOffset(v913, 0),
            Size = UDim2.fromOffset(132, 40),
            BackgroundColor3 = Color3.new()
        }
        local Row = v898.Row
        local TextButton2 = Instance.new("TextButton")
        for k225, k226 in pairs(k221) do
            TextButton2[k225] = k226
        end

        TextButton2.Parent = Row
        k221 = {
            Name = "Outline",
            Thickness = 1,
            Transparency = 0.55,
            Color = v894,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }
        local UIStroke3 = Instance.new("UIStroke")
        for k227, k228 in pairs(k221) do
            UIStroke3[k227] = k228
        end

        UIStroke3.Parent = TextButton2
        k227 = 0
        k221 = {
            Name = "Title",
            TextSize = 15,
            BackgroundTransparency = 1,
            Text = k224 .. " (0)",
            Font = Enum.Font.Code,
            TextColor3 = v895,
            Position = UDim2.fromOffset(4, 0),
            Size = UDim2.new(1, -8, 1, k227)
        }
        local TextLabel2 = Instance.new("TextLabel")
        for k229, k230 in pairs(k221) do
            TextLabel2[k229] = k230
        end

        TextLabel2.Parent = TextButton2
        v898.Buttons[k224] = TextButton2
        local v927 = TextButton2.Activated:Connect(function() --[[ Upvalues: v898 (copy), TextButton2 (copy), k224 (copy) ]]
            if v898.Active then
                if not v898.Destroyed then
                    if TextButton2.Interactable then
                        local v926 = v898.Callbacks[k224]
                        if v926 then
                            v926()
                        end
                    end
                end
            end

        end)
        table.insert(v898.Connections, v927)
    end

    return v898
end

v41.new = new2

local function SetActive2(a0, a1)
    if a0.Destroyed then
        return
    end

    a0.Active = a1 == true
    a0.Root.Enabled = a0.Active
end

v41.SetActive = SetActive2

local function Refresh1(a0, a1, a2, a3, a4) --[[ Upvalues: v894 (copy), v895 (copy) ]]
    if a0.Destroyed then
        return
    end

    a0.Counts.Undo = math.max(0, tonumber(a1) or 0)
    local v928 = tonumber(a2)
    local v929 = v928 or 0
    a0.Counts.Redo = math.max(0, v929)
    for k231, k232 in pairs(a0.Buttons) do
        local v933 = a0.Counts[k231]
        local Active5 = a0.Active
        if Active5 then
            Active5 = false
            if 0 < v933 then
                local v935 = not a3 and not a4
            end
        end

        k232.Active = Active5
        k232.Interactable = Active5
        k232.AutoButtonColor = Active5
        k232.Title.Text = k231 .. " (" .. v933 .. ")"
        k232.Title.TextColor3 = Active5 and v894 or v895
        local v938
        if Active5 then
            v938 = 0.3
        else
            v938 = 0.65
        end

        k232.Outline.Transparency = v938
        local v939
        if Active5 then
            v939 = 0.2
        else
            v939 = 0.45
        end

        k232.BackgroundTransparency = v939
    end
end

v41.Refresh = Refresh1

local function IsPointerOver(a0, a1) --[[ Upvalues: UserInputService (copy) ]]
    if not (not a0.Destroyed and a0.Active and a0.Root.Enabled) then
        return false
    end

    local v942 = a1 or UserInputService:GetMouseLocation()
    local v943 = v942 + a0.Root.AbsolutePosition
    local AbsolutePosition = a0.Row.AbsolutePosition
    local AbsoluteSize2 = a0.Row.AbsoluteSize
    local v944 = false
    if AbsolutePosition.X <= v943.X then
        v944 = false
        if AbsolutePosition.Y <= v943.Y then
            v944 = false
            if v943.X < AbsolutePosition.X + AbsoluteSize2.X then
                v944 = v943.Y < AbsolutePosition.Y + AbsoluteSize2.Y
            end
        end
    end

    return v944
end

v41.IsPointerOver = IsPointerOver

local function Destroy3(a0)
    if a0.Destroyed then
        return
    end

    a0:SetActive(false)
    a0.Destroyed = true
    for k233, k234 in ipairs(a0.Connections) do
        k234:Disconnect()
    end

    table.clear(a0.Connections)
    a0.Root:Destroy()
end

v41.Destroy = Destroy3
v3.DesktopUI = v41
v894 = {}
v894.__index = v894
v895 = Enum.ContextActionPriority.High.Value + 100
v894.RotateSteps = t1
v894.PendingControlRestores = v4
local v948 = {
    Enum.KeyCode.ButtonR2,
    Enum.KeyCode.ButtonL2,
    Enum.KeyCode.ButtonL1,
    Enum.KeyCode.ButtonR1,
    Enum.KeyCode.ButtonA,
    Enum.KeyCode.ButtonX,
    Enum.KeyCode.ButtonY,
    Enum.KeyCode.ButtonB,
    Enum.KeyCode.DPadLeft,
    Enum.KeyCode.DPadRight,
    Enum.KeyCode.DPadUp,
    Enum.KeyCode.DPadDown,
    Enum.KeyCode.ButtonL3,
    Enum.KeyCode.ButtonR3
}

local function preferredGamepad() --[[ Upvalues: UserInputService (copy) ]]
    local GamepadEnabled = UserInputService.GamepadEnabled
    if GamepadEnabled then
        GamepadEnabled = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
    end

    return GamepadEnabled
end

local function releaseCursorActivation() --[[ Upvalues: ContextActionService (copy) ]]
    pcall(function() --[[ Upvalues: ContextActionService (upvalue) ]]
        ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
        ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
    end)
end

local function IsGamepad(a0)
    local v949 = false
    if a0.Active == true then
        v949 = not a0.Destroyed
    end

    return v949
end

v894.IsGamepad = IsGamepad

local function PickerOpen(a0)
    return a0.Client.ColorPickerHUD ~= nil
end

v894.PickerOpen = PickerOpen

local function BlocksWorld(a0) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    if not a0:IsGamepad() then
        return false
    end

    local MenuOpen3 = a0.UI.MenuOpen
    if not MenuOpen3 then
        local v950 = a0:PickerOpen()
        if not v950 then
            v950 = true
            if a0.ExternalMenu == nil then
                v950 = true
                if a0.Client.DeleteAllConfirmOpen ~= true then
                    v950 = true
                    if a0.Client.PaintResetConfirmOpen ~= true then
                        v950 = true
                        if a0.WindowUnfocused ~= true then
                            local MenuIsOpen = GuiService.MenuIsOpen
                            if not MenuIsOpen then
                                MenuIsOpen = UserInputService:GetFocusedTextBox() ~= nil
                            end
                        end
                    end
                end
            end
        end
    end

    return MenuOpen3
end

v894.BlocksWorld = BlocksWorld

local function Send(a0, a1)
    a0.Remote:FireServer(a1)
end

v894.Send = Send

local function SetPrecision(a0, a1)
    local v951 = false
    if a1 == true then
        local v955 = a0:IsGamepad() and not a0:BlocksWorld()
    end

    a1 = v951
    a0.Precision = a1
    if not a1 then
        a0.PrecisionCamera = nil
        a0.PrecisionRotation = nil
    end
end

v894.SetPrecision = SetPrecision

local function CapturePrecisionCamera(a0)
    a0.PrecisionCamera = nil
    a0.PrecisionRotation = nil
    if not a0:IsGamepad() or not a0.Precision or a0:BlocksWorld() then
        return
    end

    local CurrentCamera3 = workspace.CurrentCamera
    if not CurrentCamera3 or CurrentCamera3.CameraType == Enum.CameraType.Scriptable then
        return
    end

    a0.PrecisionCamera = CurrentCamera3
    a0.PrecisionRotation = CurrentCamera3.CFrame.Rotation
end

v894.CapturePrecisionCamera = CapturePrecisionCamera

local function ApplyPrecisionCamera(a0)
    local PrecisionCamera = a0.PrecisionCamera
    local PrecisionRotation = a0.PrecisionRotation
    a0.PrecisionCamera = nil
    a0.PrecisionRotation = nil
    if not PrecisionCamera or not PrecisionRotation or not a0:IsGamepad() or not a0.Precision or a0:BlocksWorld() then
        return
    end

    if PrecisionCamera ~= workspace.CurrentCamera or PrecisionCamera.CameraType == Enum.CameraType.Scriptable then
        return
    end

    local CFrame = PrecisionCamera.CFrame
    local v956 = CFrame.new(CFrame.Position)
    PrecisionCamera.CFrame = v956 * PrecisionRotation:Lerp(CFrame.Rotation, 0.3)
end

v894.ApplyPrecisionCamera = ApplyPrecisionCamera

local function SetJump(a0, a1)
    local JumpHeld = a0.JumpHeld
    local Humanoid = a0.Client.Humanoid
    local v957 = false
    if a1 == true then
        local v958 = a0:IsGamepad()
        if v958 then
            v958 = not a0:BlocksWorld()
            if v958 then
                if not a0.Controls or false ~= false then
                    v958 = false
                    if Humanoid ~= nil then
                        v958 = 0 < Humanoid.Health
                    end
                end
            end
        end
    end

    a0.JumpHeld = v957
    if a0.JumpHeld then
        Humanoid.Jump = true
        return
    end

    if JumpHeld and Humanoid then
        Humanoid.Jump = false
    end
end

v894.SetJump = SetJump

local function ApplyJump(a0)
    if a0.JumpHeld then
        a0:SetJump(true)
    end
end

v894.ApplyJump = ApplyJump

local function CancelHeldInputs(a0)
    a0:SetJump(false)
    a0:SetPrecision(false)
    a0:Send("RunOff")
end

v894.CancelHeldInputs = CancelHeldInputs

local function SetPaused(a0, a1) --[[ Upvalues: setPaused (copy) ]]
    setPaused(a0, a1, a0.CancelHeldInputs)
end

v894.SetPaused = SetPaused

local function SyncOwnership(a0) --[[ Upvalues: GuiService (copy), ContextActionService (copy), GamepadService (copy), UserInputService (copy) ]]
    if not a0:IsGamepad() then
        return
    end

    local v959 = a0:BlocksWorld()
    a0:SetPaused(v959)
    if GuiService.MenuIsOpen then
        return
    end

    local v960 = a0:PickerOpen()
    if not v960 then
        v960 = a0.ExternalMenu ~= nil
    end

    a0.Client.BuildGamepadNavigation = v960
    if a0.CursorWasNeeded ~= v960 then
        a0.CursorWasNeeded = v960
        if not v960 then
            pcall(function() --[[ Upvalues: ContextActionService (upvalue) ]]
                ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
                ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
            end)
        end
    end

    if not v960 and GamepadService.GamepadCursorEnabled then
        GamepadService:DisableGamepadCursor()
    end

    if a0.Client.DeleteAllConfirmOpen then
        local v961 = a0.Client.BuildGui and a0.Client.BuildGui:FindFirstChild("DeleteAllConfirm")
        local SelectedObject2 = GuiService.SelectedObject
        if v961 then
            if not (SelectedObject2 and SelectedObject2:IsDescendantOf(v961)) then
                local Cancel = v961:FindFirstChild("Cancel", true)
                if Cancel and Cancel:IsA("GuiButton") then
                    GuiService.SelectedObject = Cancel
                end
            end
        end
    end

    if not v959 then
        GuiService.SelectedObject = nil
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        UserInputService.MouseIconEnabled = false
    end
end

v894.SyncOwnership = SyncOwnership

local function GetAim(a0) --[[ Upvalues: raycastAim (copy) ]]
    local CurrentCamera4 = workspace.CurrentCamera
    if not CurrentCamera4 then
        return nil, nil
    end

    local v962 = CurrentCamera4.ViewportSize / 2
    local v963 = CurrentCamera4:ViewportPointToRay(v962.X, v962.Y)
    local v964 = raycastAim(a0.Client, CurrentCamera4, v963)
    return v964
end

v894.GetAim = GetAim
v894.GetDeleteTarget = getDeleteTarget

local function RememberObject(a0, a1) --[[ Upvalues: rememberObject (copy) ]]
    rememberObject(a0.Client, a0.Remote, a1)
end

v894.RememberObject = RememberObject

local function SetFavorites(a0, a1) --[[ Upvalues: setFavorites (copy) ]]
    if not a0:IsGamepad() then
        return
    end

    if type(a1) ~= "table" then
        return
    end

    setFavorites(a0.Client, a0.Remote, a1)
    a0:RefreshPresentation()
end

v894.SetFavorites = SetFavorites

local function NotifySelected(a0, a1, a2)
    if not a0:IsGamepad() then
        return
    end

    a0:RememberObject(a1)
    a0.LastObjectType = a2
    a0.Status = nil
    a0.StatusUntil = nil
    a0.AimTarget = nil
    a0:RefreshPresentation()
end

v894.NotifySelected = NotifySelected

local function ChooseItem(a0, a1, a2) --[[ Upvalues: v2 (copy) ]]
    if not a0:IsGamepad() or a0.Busy then
        return
    end

    if a0.Client.Painting then
        v2.Close(a0.Client)
    end

    a0:CloseMenu()
    a0.Client:SelectEditObject(a1, a2)
    a0.Status = nil
    a0:RefreshPresentation()
end

v894.ChooseItem = ChooseItem

local function Request(a0, a1)
    if not a0:IsGamepad() or a0.Busy then
        return {ok = false, reason = "Wait for the current change to finish."}
    end

    a0.Busy = true
    a0:RefreshPresentation()
    local v966, v967 = pcall(function() --[[ Upvalues: a0 (copy), a1 (copy) ]]
        local v965 = a0.RemoteFunction:InvokeServer("ModernBuildAction", a1)
        return v965
    end)
    a0.Busy = false
    if v966 then
        if type(v967) == "table" then
            -- jump to 37
        end
    end

    v967 = {ok = false, reason = "Connection interrupted. Please try again."}
    if a0.Destroyed then
        return v967
    end

    if type(v967.undo) == "number" then
        a0.UndoCount = v967.undo
    end

    if type(v967.redo) == "number" then
        a0.RedoCount = v967.redo
    end

    if a1.action ~= "State" then
        local v968
        if not v967.ok then
            v968 = v967.reason
            if not v968 then
                v968 = "The change could not be saved."
                -- branch continues at 78
            end
        else
            v968 = nil
        end

        a0.Status = v968
        local v970 = a0.Status and os.clock() + 3 or nil
        a0.StatusUntil = v970
    end

    a0:RefreshPresentation()
    if a0.NeedsStateRefresh then
        a0.NeedsStateRefresh = nil
        task.defer(function() --[[ Upvalues: a0 (copy) ]]
            a0:RefreshState()
        end)
    end

    return v967
end

v894.Request = Request

local function RefreshState(a0)
    if not a0:IsGamepad() then
        return
    end

    if a0.Busy then
        a0.NeedsStateRefresh = true
        return
    end

    local v971 = a0:Request({action = "State"})
    return v971
end

v894.RefreshState = RefreshState

local function Commit(a0, a1)
    if not a0:IsGamepad() or a0.Busy or a0:BlocksWorld() then
        return
    end

    local Client = a0.Client
    if Client.Painting then
        return
    end

    if not Client.EditObject then
        return
    end

    if typeof(a1) ~= "CFrame" then
        return
    end

    local EditObject = Client.EditObject
    local EditingExistingObject = Client.EditingExistingObject
    local ActivationEpoch = a0.ActivationEpoch
    local v972 = {}
    local v973
    if EditingExistingObject then
        v973 = "Move"
    else
        v973 = "Place"
    end

    v972.action = v973
    v972.name = EditObject.Name
    v972.object = EditingExistingObject
    v972.cframe = a1
    local v974 = a0:Request(v972)
    if not a0:IsGamepad() or a0.ActivationEpoch ~= ActivationEpoch then
        return v974
    end

    if v974.ok then
        if EditingExistingObject then
            if EditingExistingObject.Parent then
                EditingExistingObject:PivotTo(a1)
            end

            if Client.EditObject == EditObject and Client.EditingExistingObject == EditingExistingObject then
                Client:DeleteEditObject()
            end
        end
    end

    return v974
end

v894.Commit = Commit

local function Delete(a0, a1)
    if not a0:IsGamepad() or a0.Busy or a0:BlocksWorld() then
        return
    end

    local ActivationEpoch1 = a0.ActivationEpoch
    local v975 = {action = "Delete", object = a1}
    local v976 = a0:Request(v975)
    if v976.ok and a0:IsGamepad() and a0.ActivationEpoch == ActivationEpoch1 then
        a0.Client:ClearBuildObjectHover()
        a0.AimTarget = nil
    end

    return v976
end

v894.Delete = Delete

local function History1(a0, a1)
    if a1 == "Undo" or a1 == "Redo" then
        if not a0:IsGamepad() then
            return
        end

        if a0.Busy then
            return
        end

        if not a0:BlocksWorld() then
            -- jump to 18
        end
    end

    return
    if a1 == "Undo" then
        local v977 = a0.UndoCount or 0
        if v977 <= 0 then
            return
        end
    end

    if a1 == "Redo" then
        local v978 = a0.RedoCount or 0
        if v978 <= 0 then
            return
        end
    end

    local Client1 = a0.Client
    local EditObject1 = Client1.EditObject
    local EditingExistingObject1 = Client1.EditingExistingObject
    local ActivationEpoch2 = a0.ActivationEpoch
    local v979 = {action = a1}
    local v980 = a0:Request(v979)
    if v980.ok then
        if a0:IsGamepad() then
            if a0.ActivationEpoch == ActivationEpoch2 then
                if EditObject1 and Client1.EditObject == EditObject1 and Client1.EditingExistingObject == EditingExistingObject1 then
                    Client1:DeleteEditObject()
                end

                Client1:ClearBuildObjectHover()
                Client1:UpdateStorageCapacity()
                a0.AimTarget = nil
            end
        end
    end

    return v980
end

v894.History = History1

local function ToggleColourPicker(a0) --[[ Upvalues: v2 (copy) ]]
    if not a0:IsGamepad() or not a0.Client.Painting or a0.Busy then
        return
    end

    v2.ControllerPicker(a0.Client)
    a0:SyncOwnership()
    a0:RefreshPresentation()
end

v894.ToggleColourPicker = ToggleColourPicker

local function GetPaintTool(a0)
    local PaintMode = a0.Client.PaintMode
    if PaintMode == "ColorDropper" then
        PaintMode = a0.Client.PaintReturnMode
    end

    if PaintMode == "PaintBucket" then
        return "PaintBucket"
    end

    return "PaintBrush"
end

v894.GetPaintTool = GetPaintTool

local function CyclePaintTool(a0) --[[ Upvalues: v2 (copy) ]]
    if not a0:IsGamepad() or not a0.Client.Painting or a0.Busy or a0:BlocksWorld() then
        return
    end

    local v981
    if a0:GetPaintTool() == "PaintBrush" then
        v981 = "PaintBucket"
    else
        v981 = "PaintBrush"
    end

    v2.ControllerTool(a0.Client, v981)
    a0.Client.PaintReturnMode = nil
    a0.Status = nil
    a0.StatusUntil = nil
end

v894.CyclePaintTool = CyclePaintTool

local function SamplePaintColor(a0) --[[ Upvalues: v2 (copy) ]]
    if not a0:IsGamepad() or not a0.Client.Painting or a0.Busy or a0:BlocksWorld() then
        return
    end

    local v982 = v2.ControllerSample(a0.Client)
    local v983
    if v982 then
        v983 = "Colour sampled"
    else
        v983 = "Aim at a paintable surface to sample its colour."
    end

    a0.Status = v983
    a0.StatusUntil = os.clock() + 1.5
    return v982
end

v894.SamplePaintColor = SamplePaintColor

local function CloseMenu2(a0) --[[ Upvalues: GuiService (copy) ]]
    a0.UI:CloseMenu()
    GuiService.SelectedObject = nil
    a0:CancelHeldInputs()
    a0:SyncOwnership()
end

v894.CloseMenu = CloseMenu2

local function OpenCatalogue2(a0) --[[ Upvalues: v2 (copy) ]]
    if not a0:IsGamepad() then
        return
    end

    if a0:PickerOpen() then
        v2.ControllerClosePicker(a0.Client)
    end

    a0:CancelHeldInputs()
    a0.UI:OpenCatalogue()
    a0:SyncOwnership()
end

v894.OpenCatalogue = OpenCatalogue2

local function OpenOptions2(a0)
    a0:CancelHeldInputs()
    a0.UI:OpenOptions(a0.Client.Painting == true)
    a0:SyncOwnership()
end

v894.OpenOptions = OpenOptions2

local function OpenRotationSteps2(a0) --[[ Upvalues: t1 (copy) ]]
    if not a0:IsGamepad() then
        return
    end

    a0:CancelHeldInputs()
    a0.UI:OpenRotationSteps(a0.RotateStep, t1)
    a0:SyncOwnership()
end

v894.OpenRotationSteps = OpenRotationSteps2

local function SetRotationStep(a0, a1) --[[ Upvalues: t1 (copy) ]]
    if not (a0:IsGamepad() and table.find(t1, a1)) then
        return
    end

    a0.RotateStep = a1
    a0.Client.ClassicControllerRotateStep = a1
    if a0.Client.Data then
        a0.Client.Data.ClassicControllerRotateStep = a1
    end

    a0.Remote:FireServer("ChangeClassicControllerRotateStep", a1)
    a0.Status = nil
    a0:CloseMenu()
    a0:RefreshPresentation()
end

v894.SetRotationStep = SetRotationStep
v894.Exit = exit

local function OpenLegacyPanel(a0, a1) --[[ Upvalues: ContextActionService (copy), GuiService (copy), GamepadService (copy), UserInputService (copy), v895 (copy) ]]
    local Client2 = a0.Client
    a0:Exit()
    if Client2.ClassicReturnCleanup then
        Client2.ClassicReturnCleanup(false)
    end

    if a1 == "Customize" then
        Client2:OpenCustomizeBase()
    else
        Client2:OpenBaseSlots()
    end

    local v984
    if not (a1 == "Customize" and Client2.HUD.BaseCustomization) then
        v984 = Client2.HUD.BaseSlots
    end

    if not (v984 and v984.Visible) then
        return
    end

    Client2.MainContext.Enabled = false
    local v985 = {}
    local v986 = false
    local Enabled = Client2.MainContext.Enabled

    local function cleanup(a0) --[[ Upvalues: v986 (ref), v985 (copy), ContextActionService (upvalue), Client2 (copy), Enabled (copy), GuiService (upvalue), GamepadService (upvalue), UserInputService (upvalue) ]]
        if v986 then
            return
        end

        v986 = true
        for k235, k236 in ipairs(v985) do
            k236:Disconnect()
        end

        ContextActionService:UnbindAction("ClassicBuildExternalBack")
        Client2.ClassicReturnCleanup = nil
        Client2.MainContext.Enabled = Enabled
        GuiService.SelectedObject = nil
        if GamepadService.GamepadCursorEnabled then
            GamepadService:DisableGamepadCursor()
        end

        task.defer(function() --[[ Upvalues: a0 (copy), UserInputService (upvalue), Client2 (upvalue) ]]
            if a0 then
                local GamepadEnabled1 = UserInputService.GamepadEnabled
                if GamepadEnabled1 then
                    GamepadEnabled1 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
                end

                if GamepadEnabled1 and Client2.Player:GetAttribute("InBase") and Client2.Humanoid and 0 < Client2.Humanoid.Health and not Client2.EditingBase and not Client2.CustomizingBase and not Client2.InBaseSlots and not Client2.Painting then
                    Client2:EditStorage()
                end
            end

        end)
    end

    Client2.ClassicReturnCleanup = cleanup
    local v990 = v984:GetPropertyChangedSignal("Visible")
    local v991 = v990:Connect(function() --[[ Upvalues: v984 (copy), cleanup (copy) ]]
        if not v984.Visible then
            cleanup(true)
        end

    end)
    table.insert(v985, v991)
    local v992 = Client2.Player.CharacterRemoving:Connect(function() --[[ Upvalues: cleanup (copy) ]]
        cleanup(false)
    end)
    table.insert(v985, v992)
    local v993 = UserInputService.GamepadDisconnected:Connect(function() --[[ Upvalues: cleanup (copy) ]]
        cleanup(false)
    end)
    table.insert(v985, v993)
    ContextActionService:BindActionAtPriority("ClassicBuildExternalBack", function(a0, a1) --[[ Upvalues: GuiService (upvalue), UserInputService (upvalue), a1 (copy), Client2 (copy) ]]
        if GuiService.MenuIsOpen then
            return Enum.ContextActionResult.Pass
        end

        if a1 == Enum.UserInputState.Begin then
            if UserInputService:GetFocusedTextBox() then
                UserInputService:GetFocusedTextBox():ReleaseFocus()
            else
                if a1 == "Customize" then
                    Client2:CloseCustomizeBase()
                else
                    if Client2.BaseSlotConfirmAction then
                        Client2:CloseBaseSlotConfirmation()
                    else
                        Client2:CloseBaseSlots()
                    end
                end
            end
        end

        return Enum.ContextActionResult.Sink
    end, false, v895, Enum.KeyCode.ButtonB)
    local v994 = v984:FindFirstChildWhichIsA("GuiButton", true)
    GamepadService:EnableGamepadCursor(v994)
end

v894.OpenLegacyPanel = OpenLegacyPanel

local function Option(a0, a1) --[[ Upvalues: v2 (copy) ]]
    if not a0:IsGamepad() or a0.Busy then
        return
    end

    local Client3 = a0.Client
    if a1 == "PaintMode" then
        a0:CloseMenu()
        if not Client3.Painting then
            Client3:OpenPaintFrames()
        end

        a0.Status = nil
        a0.StatusUntil = nil
        a0:SyncOwnership()
        a0:RefreshPresentation()
        return
    end

    if a1 == "ObjectsMode" then
        a0:CloseMenu()
        if Client3.Painting then
            v2.Close(Client3)
        end

        a0:SyncOwnership()
        a0:RefreshPresentation()
        return
    end

    if a1 == "Undo" or a1 == "Redo" then
        a0:CloseMenu()
        a0:History(a1)
        return
    end

    if a1 == "Catalogue" then
        a0:OpenCatalogue()
        return
    end

    if a1 == "RotationSteps" then
        a0:OpenRotationSteps()
        return
    end

    if a1 == "DeleteAll" then
        if not (a0:IsGamepad() and Client3.EditingBase) then
            return
        end

        a0:CloseMenu()
        if Client3.Painting then
            v2.Close(Client3)
        end

        if not a0:IsGamepad() then
            return
        end

        Client3:SetDeleteAllConfirmation(true)
        a0:SyncOwnership()
        a0:RefreshPresentation()
        return
    end

    a0:CloseMenu()
    if a1 == "Resume" then
        return
    end

    if a1 == "Exit" then
        a0:Exit()
        return
    end

    if a1 == "SwitchModern" then
        if Client3.Painting then
            v2.Close(Client3)
        end

        if Client3.BuildCameraActive then
            Client3:SetBuildSystem("Modern", true)
            return
        end

        if Client3:SetBuildSystem("Modern") then
            Client3:EditStorage()
        end

        return
    end

    if a1 == "Customize" or a1 == "SaveSlots" then
        a0:OpenLegacyPanel(a1)
        return
    end
end

v894.Option = Option

local function CanPlace(a0) --[[ Upvalues: v1 (copy) ]]
    if a0.Client.CanPlaceClassicBuildObject then
        local v995 = a0.Client:CanPlaceClassicBuildObject()
        return v995
    end

    local Client4 = a0.Client
    local EditObject2 = Client4.EditObject
    if not EditObject2 then
        return false, "Open the catalogue to choose an object"
    end

    local v996 = a0:GetAim()
    if not v996 then
        return false, "Aim at a surface inside your base"
    end

    local v997 = Client4:CalcPlacementCFrame(v996.Position)
    EditObject2:PivotTo(v997)
    if not Client4:IsBuildObjectInBounds(EditObject2) then
        return false, "Keep the whole object inside your base"
    end

    local v998 = EditObject2:GetPivot()
    if Client4:HasBuildObjectAtCFrame(v998) then
        return false, "An object already occupies this position"
    end

    v996 = v1[EditObject2.Name]
    local Data6 = Client4.Data
    if not Data6 then
        Data6 = {}
    end

    if v996 then
        if v996.ItemObject then
            local BaseItems2 = Data6.BaseItems
            if not BaseItems2 then
                BaseItems2 = {}
            end

            local v999 = BaseItems2[EditObject2.Name] or 0
            if v999 < 1 then
                return false, "No copies remaining"
            end
        end

        if not v996.ItemObject then
            local v1000 = tonumber(Data6.Money) or 0
            if v1000 < (tonumber(v996.Price) or 0) then
                return false, "Not enough money"
            end
        end
    end

    return true
end

v894.CanPlace = CanPlace

local function Primary1(a0) --[[ Upvalues: v2 (copy) ]]
    if not a0:IsGamepad() or a0:BlocksWorld() or a0.Busy then
        return
    end

    local Client5 = a0.Client
    if Client5.Painting then
        v2.ControllerApply(Client5)
        return
    end

    if Client5.DeletingObjects then
        Client5:DeleteClassicBuildTarget()
        return
    end

    if not Client5.EditObject then
        local v1001 = a0:GetDeleteTarget()
        local v1004 = v1001 and Client5:SelectPlacedBuildObject(v1001)
        local v1005
        if not v1004 then
            v1005 = "Aim at a placed object to select it, or open the catalogue"
        else
            v1005 = nil
        end

        a0.Status = v1005
        return
    end

    local v1006 = os.clock() - (a0.LastPlace or 0)
    if v1006 < 0.2 then
        return
    end

    local v1007, v1008 = a0:CanPlace()
    if v1007 then
        a0.LastPlace = os.clock()
        Client5:PlaceClassicBuildObject()
        return
    end

    a0.Status = v1008
end

v894.Primary = Primary1

local function Back(a0) --[[ Upvalues: v2 (copy) ]]
    if a0.Client.DeleteAllConfirmOpen then
        a0.Client:SetDeleteAllConfirmation(false)
        a0:SyncOwnership()
        a0:RefreshPresentation()
        return
    end

    if a0:PickerOpen() then
        v2.ControllerClosePicker(a0.Client)
        a0:SyncOwnership()
        return
    end

    if a0.UI.MenuOpen then
        if a0.UI.MenuKind == "RotationSteps" then
            a0:OpenOptions()
            return
        end

        a0:CloseMenu()
        return
    end

    if a0.Client.Painting then
        v2.Close(a0.Client)
        a0:SyncOwnership()
        return
    end

    if a0.Client.DeletingObjects then
        a0.Client:SetDeletingObjects(false)
        return
    end

    if a0.Client.EditObject then
        a0.Client:DeleteEditObject()
        return
    end

    a0:Exit()
end

v894.Back = Back

local function HandleInput(a0, a1, a2, a3) --[[ Upvalues: GuiService (copy), v2 (copy), UserInputService (copy) ]]
    if not a0:IsGamepad() then
        return Enum.ContextActionResult.Pass
    end

    local KeyCode = a3.KeyCode
    local v1009 = a2 == Enum.UserInputState.Begin
    local v1010 = true
    if a2 ~= Enum.UserInputState.End then
        v1010 = a2 == Enum.UserInputState.Cancel
    end

    local v1011 = a0.HeldInputs[KeyCode]
    if v1010 then
        a0.HeldInputs[KeyCode] = nil
        if KeyCode == Enum.KeyCode.ButtonL1 then
            a0:SetPrecision(false)
        end

        if KeyCode == Enum.KeyCode.ButtonR1 then
            a0:SetJump(false)
        end

        if KeyCode == Enum.KeyCode.ButtonL3 then
            if a0.Client.Data.HoldToSprint then
                a0:Send("RunOff")
                -- branch continues at 75
            end

            -- branch continues at 75
        end
    else
        if v1009 then
            a0.HeldInputs[KeyCode] = true
        end
    end

    if KeyCode == Enum.KeyCode.ButtonA then
        local MenuPrimary = a0.MenuPrimary
        if not MenuPrimary then
            local MenuOpen4 = a0.UI.MenuOpen
            if not MenuOpen4 then
                local v1012 = a0:PickerOpen()
                if not v1012 then
                    v1012 = true
                    if a0.ExternalMenu == nil then
                        local MenuIsOpen1 = GuiService.MenuIsOpen
                        if not MenuIsOpen1 then
                            MenuIsOpen1 = a0.Client.DeleteAllConfirmOpen == true
                        end
                    end
                end
            end
        end

        if MenuPrimary then
            a0.MenuPrimary = not v1010
            return Enum.ContextActionResult.Pass
        end
    end

    if GuiService.MenuIsOpen then
        return Enum.ContextActionResult.Pass
    end

    if a0:PickerOpen() then
        if KeyCode == Enum.KeyCode.ButtonL2 or KeyCode == Enum.KeyCode.ButtonR2 or KeyCode == Enum.KeyCode.ButtonX then
            return Enum.ContextActionResult.Sink
        end

        if KeyCode == Enum.KeyCode.ButtonY or KeyCode == Enum.KeyCode.ButtonB then
            if v1009 and not v1011 then
                v2.ControllerClosePicker(a0.Client)
                a0:SyncOwnership()
                a0:RefreshPresentation()
            end

            return Enum.ContextActionResult.Sink
        end

        return Enum.ContextActionResult.Pass
    end

    if UserInputService:GetFocusedTextBox() then
        if v1009 and KeyCode == Enum.KeyCode.ButtonB then
            UserInputService:GetFocusedTextBox():ReleaseFocus()
        end

        return Enum.ContextActionResult.Sink
    end

    if a0.Client.DeleteAllConfirmOpen then
        if v1009 and KeyCode == Enum.KeyCode.ButtonB then
            a0:Back()
            return Enum.ContextActionResult.Sink
        end

        if KeyCode == Enum.KeyCode.DPadLeft or KeyCode == Enum.KeyCode.DPadRight or KeyCode == Enum.KeyCode.DPadUp or KeyCode == Enum.KeyCode.DPadDown then
            return Enum.ContextActionResult.Pass
        end

        return Enum.ContextActionResult.Sink
    end

    if a0.UI.MenuOpen then
        if KeyCode == Enum.KeyCode.DPadLeft or KeyCode == Enum.KeyCode.DPadRight or KeyCode == Enum.KeyCode.DPadUp or KeyCode == Enum.KeyCode.DPadDown then
            return Enum.ContextActionResult.Pass
        end
    end

    if not v1009 or v1011 then
        return Enum.ContextActionResult.Sink
    end

    if KeyCode == Enum.KeyCode.ButtonB then
        a0:Back()
        return Enum.ContextActionResult.Sink
    end

    if a0.UI.MenuOpen then
        if KeyCode == Enum.KeyCode.ButtonY then
            a0:CloseMenu()
        else
            if KeyCode == Enum.KeyCode.ButtonX and a0.UI.MenuKind == "Catalogue" then
                a0.UI:ToggleFocusedFavorite()
            else
                if KeyCode == Enum.KeyCode.ButtonL1 then
                    a0.UI:ChangeCategory(-1)
                else
                    if KeyCode == Enum.KeyCode.ButtonR1 then
                        a0.UI:ChangeCategory(1)
                    end
                end
            end
        end

        return Enum.ContextActionResult.Sink
    end

    if a0:BlocksWorld() then
        return Enum.ContextActionResult.Sink
    end

    if KeyCode == Enum.KeyCode.ButtonY then
        if a0.Client.Painting then
            a0:ToggleColourPicker()
            -- jump to 567 (out of range)
        end

        a0:OpenCatalogue()
    else
        if KeyCode == Enum.KeyCode.DPadUp then
            a0:OpenOptions()
        else
            if KeyCode == Enum.KeyCode.ButtonA then
                a0:Primary()
            else
                if KeyCode == Enum.KeyCode.ButtonL1 then
                    a0:SetPrecision(true)
                else
                    if KeyCode == Enum.KeyCode.ButtonR1 then
                        a0:SetJump(true)
                    else
                        if KeyCode == Enum.KeyCode.ButtonL2 or KeyCode == Enum.KeyCode.ButtonR2 then
                            if a0.Client.Painting then
                                if KeyCode == Enum.KeyCode.ButtonR2 then
                                    a0:CyclePaintTool()
                                    -- jump to 567 (out of range)
                                    -- branch continues at 567
                                end
                            end

                            if not a0.Client.DeletingObjects then
                                if not a0.Busy then
                                    local Axis = a0.Axis
                                    local v1013
                                    if KeyCode == Enum.KeyCode.ButtonL2 then
                                        v1013 = -1
                                    else
                                        v1013 = 1
                                    end

                                    a0.Client:RotateClassicBuildObject(Axis, v1013, a0.RotateStep)
                                    -- jump to 567 (out of range)
                                    -- branch continues at 567
                                end

                                -- branch continues at 567
                            end
                        end

                        if KeyCode == Enum.KeyCode.ButtonX then
                            if a0.Client.Painting then
                                a0:SamplePaintColor()
                                -- jump to 567 (out of range)
                            end

                            a0.Axis = ({Y = "X", X = "Z", Z = "Y"})[a0.Axis]
                        else
                            if KeyCode == Enum.KeyCode.DPadLeft then
                                a0:History("Undo")
                            else
                                if KeyCode == Enum.KeyCode.DPadRight then
                                    a0:History("Redo")
                                else
                                    if KeyCode == Enum.KeyCode.DPadDown then
                                        if a0.Busy then
                                            return Enum.ContextActionResult.Sink
                                        end

                                        if a0.Client.Painting then
                                            v2.Close(a0.Client)
                                        end

                                        a0:CancelHeldInputs()
                                        a0.Client:SetDeletingObjects(not a0.Client.DeletingObjects)
                                    else
                                        if KeyCode == Enum.KeyCode.ButtonL3 then
                                            if not (not a0.Client.Data.HoldToSprint and a0.Client.Character:GetAttribute("Running")) then
                                                a0:Send("Run")
                                                -- jump to 567 (out of range)
                                            end

                                            a0:Send("RunOff")
                                        else
                                            if KeyCode == Enum.KeyCode.ButtonR3 then
                                                a0:Send("Crouch")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    a0:RefreshPresentation()
    return Enum.ContextActionResult.Sink
end

v894.HandleInput = HandleInput
v894.SaveAndHide = saveAndHide

local function RefreshPresentation(a0) --[[ Upvalues: GuiService (copy) ]]
    if not a0:IsGamepad() then
        return
    end

    local Client6 = a0.Client
    local v1014 = "BaseEdit"
    local v1015 = {
        "BaseObjects",
        v1014,
        "PaintEditBar",
        "MobileEdits",
        "MobileMouse",
        "Crosshair"
    }
    for k237, k238 in ipairs(v1015) do
        local v1019 = Client6.HUD:FindFirstChild(k238)
        a0:SaveAndHide(v1019)
    end

    if Client6.BuildGui then
        k238 = "TransformPanel"
        local v1020 = {
            "Toolbar",
            k238,
            "ViewPanel",
            "Hint",
            "ControllerHotkeys",
            "BuildSystemToggle"
        }
        for k239, k240 in ipairs(v1020) do
            local v1024 = Client6.BuildGui:FindFirstChild(k240)
            a0:SaveAndHide(v1024)
        end
    end

    local EditObject3 = Client6.EditObject
    local UI = a0.UI
    k237 = {}
    local v1025
    if not (EditObject3 and EditObject3.Name) then
    end

    k237.itemName = v1025
    k237.axis = a0.Axis
    k237.precision = a0.Precision == true
    k237.rotateStep = a0.RotateStep
    k237.deleting = Client6.DeletingObjects == true
    k237.existing = Client6.EditingExistingObject ~= nil
    local v1027 = a0.AimTarget and a0.AimTarget.Name
    k237.targetName = v1027
    k237.undoCount = a0.UndoCount or 0
    k237.redoCount = a0.RedoCount or 0
    k237.busy = a0.Busy == true
    k237.paintMode = Client6.PaintMode
    k237.paintTool = a0:GetPaintTool()
    k237.pickerOpen = a0:PickerOpen()
    k237.paintColor = Client6.Painting and Client6.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3 or nil
    k237.status = a0.Status
    local v1029
    if Client6.Painting then
        v1029 = "Paint"
    else
        v1029 = "Objects"
    end

    k237.mode = v1029
    v1029 = Client6.ModernBuildFavorites
    if not v1029 then
        v1029 = {}
    end

    k237.favorites = v1029
    v1029 = Client6.ModernBuildRecents
    if not v1029 then
        v1029 = {}
    end

    k237.recents = v1029
    UI:Update(k237)
    EditObject3 = not a0:BlocksWorld()
    local v1030 = a0:PickerOpen()
    if v1030 then
        v1030 = not a0.UI.MenuOpen
        if v1030 then
            v1030 = false
            if a0.ExternalMenu == nil then
                local v1034 = not Client6.DeleteAllConfirmOpen and not Client6.PaintResetConfirmOpen and not GuiService.MenuIsOpen and not a0.WindowUnfocused
            end
        end
    end

    a0.UI.HUD.Visible = EditObject3 or v1030
    a0.UI.Reticle.Visible = EditObject3
end

v894.RefreshPresentation = RefreshPresentation

local function Step(a0, a1)
    if not a0:IsGamepad() then
        return
    end

    if not a0.Client.ClassicBuildActive then
        a0:Destroy()
        return
    end

    a0:SyncOwnership()
    a0.RefreshElapsed = (a0.RefreshElapsed or 0) + a1
    if 0.08 <= a0.RefreshElapsed then
        a0.RefreshElapsed = 0
        if a0.StatusUntil and a0.StatusUntil <= os.clock() then
            a0.Status = nil
            a0.StatusUntil = nil
        end

        if not a0:BlocksWorld() then
            if a0.Client.EditObject then
                if not a0.Client.Painting then
                    local v1035, v1036 = a0:CanPlace()
                    if not a0.StatusUntil or a0.StatusUntil <= os.clock() then
                        a0.Status = not v1035 and v1036 or nil
                        a0.StatusUntil = nil
                    end

                    local v1039 = a0.Client.EditObject:FindFirstChildOfClass("Highlight")
                    if v1039 then
                        local v1041
                        if not (v1035 and Color3.fromRGB(100, 220, 160)) then
                            local v1042 = Color3.fromRGB(255, 100, 110)
                        end

                        v1039.FillColor = v1041
                        v1039.OutlineColor = v1039.FillColor
                    end
                end
            end
        end

        if not a0:BlocksWorld() and not a0.Client.EditObject and not a0.Client.Painting then
            local v1043 = workspace.CurrentCamera.ViewportSize / 2
            a0.AimTarget = a0.Client:UpdateBuildObjectHover(v1043, true)
        else
            a0.AimTarget = nil
        end

        a0:RefreshPresentation()
    end
end

v894.Step = Step

local function SetActive3(a0, a1) --[[ Upvalues: GuiService (copy), UserInputService (copy), ContextActionService (copy), v895 (copy), v948 (copy), v2 (copy), GamepadService (copy) ]]
    if a0.Destroyed or a1 == a0.Active then
        return
    end

    a0.ActivationEpoch = (a0.ActivationEpoch or 0) + 1
    if a1 then
        if a0.Client.ClassicMobile and a0.Client.ClassicMobile:IsActive() then
            a0.Client.ClassicMobile:SetActive(false)
        end

        a0.Active = true
        a0.SavedContext = a0.Client.MainContext.Enabled
        a0.SavedAutoSelect = GuiService.AutoSelectGuiEnabled
        a0.SavedFreeMouse = a0.Client.FreeMouse
        a0.SavedMouseBehavior = UserInputService.MouseBehavior
        a0.SavedMouseIcon = UserInputService.MouseIconEnabled
        a0.Client.MainContext.Enabled = false
        a0.Client.FreeMouse = false
        pcall(function() --[[ Upvalues: ContextActionService (upvalue) ]]
            ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
            ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
        end)
        GuiService.AutoSelectGuiEnabled = false
        GuiService.SelectedObject = nil
        a0:Send("M1U")
        a0:Send("M2U")
        a0:Send("BlockOff")
        a0:Send("RunOff")
        local v1047 = table.unpack(v948)
        ContextActionService:BindActionAtPriority("ClassicBuildControllerActions", function(...) --[[ Upvalues: a0 (copy) ]]
            local v1046 = a0:HandleInput(...)
            return v1046
        end, false, v895, v1047)
        a0.UI:SetActive(true)
        if a0.Client.Painting then
            local v1048 = a0:GetPaintTool()
            v2.SetMode(a0.Client, v1048)
            a0.Client.PaintReturnMode = nil
        end

        a0:SyncOwnership()
        a0:RefreshPresentation()
        if not a0.Client.Painting then
            a0:OpenCatalogue()
        end

        task.defer(function() --[[ Upvalues: a0 (copy) ]]
            a0:RefreshState()
        end)
        return
    end

    a0:CancelHeldInputs()
    a0.HeldInputs = {}
    a0.MenuPrimary = nil
    a0.UI:CloseMenu()
    if a0.Client.DeleteAllConfirmOpen then
        a0.Client:SetDeleteAllConfirmation(false)
    end

    a0:SetPaused(false)
    ContextActionService:UnbindAction("ClassicBuildControllerActions")
    pcall(function() --[[ Upvalues: ContextActionService (upvalue) ]]
        ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
        ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
    end)
    GuiService.SelectedObject = nil
    if GamepadService.GamepadCursorEnabled then
        GamepadService:DisableGamepadCursor()
    end

    a0.Client.BuildGamepadNavigation = false
    GuiService.AutoSelectGuiEnabled = a0.SavedAutoSelect
    a0.Client.MainContext.Enabled = a0.SavedContext
    a0.Client.FreeMouse = a0.SavedFreeMouse
    UserInputService.MouseBehavior = a0.SavedMouseBehavior
    UserInputService.MouseIconEnabled = a0.SavedMouseIcon
    for k241, k242 in pairs(a0.Hidden) do
        if k241.Parent then
            k241.Visible = k242
        end
    end

    a0.Hidden = {}
    a0.Active = false
    a0.UI:SetActive(false)
    if a0.Client.ClassicBuildActive then
        a0.Client:ApplyClassicBuildPresentation()
    end
end

v894.SetActive = SetActive3

local function Destroy4(a0) --[[ Upvalues: RunService (copy) ]]
    if a0.Destroyed then
        return
    end

    if a0.Active then
        a0:SetActive(false)
    end

    a0.Destroyed = true
    a0.PrecisionCamera = nil
    a0.PrecisionRotation = nil
    if a0.JumpStep then
        RunService:UnbindFromRenderStep(a0.JumpStep)
    end

    if a0.PrecisionCaptureStep then
        RunService:UnbindFromRenderStep(a0.PrecisionCaptureStep)
    end

    if a0.PrecisionApplyStep then
        RunService:UnbindFromRenderStep(a0.PrecisionApplyStep)
    end

    for k243, k244 in ipairs(a0.Connections) do
        k244:Disconnect()
    end

    a0.Connections = {}
    a0.UI:Destroy()
end

v894.Destroy = Destroy4
local UI1 = v3.UI

local function Start(a0) --[[ Upvalues: loadCataloguePreferences (copy), t1 (copy), v894 (copy), ReplicatedStorage (copy), UI1 (copy), UserInputService (copy), GamepadService (copy), GuiService (copy), RunService (copy) ]]
    loadCataloguePreferences(a0)
    local v1055 = a0.Data and a0.Data.ClassicControllerRotateStep
    local v1056
    if not (table.find(t1, a0.ClassicControllerRotateStep) and a0.ClassicControllerRotateStep) then
        local v1058 = table.find(t1, v1055) and v1055 or 90
    end

    local v1059 = {
        Active = false,
        Axis = "Y",
        UndoCount = 0,
        RedoCount = 0,
        Client = a0,
        Connections = {},
        Hidden = {},
        HeldInputs = {},
        RotateStep = v1056
    }
    v1055 = setmetatable(v1059, v894)
    v1055.Remote = ReplicatedStorage.Remotes.RemoteEvent
    v1055.RemoteFunction = ReplicatedStorage.Remotes.RemoteFunction
    local PlayerScripts = a0.Player:FindFirstChild("PlayerScripts")
    local v1061 = PlayerScripts and PlayerScripts:FindFirstChild("PlayerModule")
    if v1061 then
        local v1063, v1064 = pcall(function() --[[ Upvalues: v1061 (copy) ]]
            local v1062 = require(v1061):GetControls()
            return v1062
        end)
        if v1063 then
            v1055.Controls = v1064
        end
    end

    local function SelectItem(a0, a1) --[[ Upvalues: v1055 (copy) ]]
        v1055:ChooseItem(a0, a1)
    end

    local function Close() --[[ Upvalues: v1055 (copy) ]]
        v1055:CloseMenu()
    end

    local function Option1(a0) --[[ Upvalues: v1055 (copy) ]]
        v1055:Option(a0)
    end

    local function RotationStep(a0) --[[ Upvalues: v1055 (copy) ]]
        v1055:SetRotationStep(a0)
    end

    local function FavoritesChanged(a0) --[[ Upvalues: v1055 (copy) ]]
        v1055:SetFavorites(a0)
    end

    local v1065 = {
        SelectItem = SelectItem,
        Close = Close,
        Option = Option1,
        RotationStep = RotationStep,
        FavoritesChanged = FavoritesChanged
    }
    v1055.UI = UI1.new(a0, v1065)

    local function connect(a0, a1) --[[ Upvalues: v1055 (copy) ]]
        local v1066 = a0:Connect(a1)
        table.insert(v1055.Connections, v1066)
    end

    local v1067 = UserInputService:GetPropertyChangedSignal("PreferredInput")
    local v1068 = v1067:Connect(function() --[[ Upvalues: v1055 (copy), UserInputService (upvalue) ]]
        local GamepadEnabled2 = UserInputService.GamepadEnabled
        if GamepadEnabled2 then
            GamepadEnabled2 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
        end

        v1055:SetActive(GamepadEnabled2)
    end)
    table.insert(v1055.Connections, v1068)
    local v1069 = UserInputService.GamepadConnected:Connect(function() --[[ Upvalues: v1055 (copy), UserInputService (upvalue) ]]
        local GamepadEnabled3 = UserInputService.GamepadEnabled
        if GamepadEnabled3 then
            GamepadEnabled3 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
        end

        v1055:SetActive(GamepadEnabled3)
    end)
    table.insert(v1055.Connections, v1069)
    local v1070 = UserInputService.GamepadDisconnected:Connect(function() --[[ Upvalues: v1055 (copy), UserInputService (upvalue) ]]
        local GamepadEnabled4 = UserInputService.GamepadEnabled
        if GamepadEnabled4 then
            GamepadEnabled4 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
        end

        v1055:SetActive(GamepadEnabled4)
    end)
    table.insert(v1055.Connections, v1070)
    local v1071 = GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled")
    local v1072 = v1071:Connect(function() --[[ Upvalues: v1055 (copy), GamepadService (upvalue), GuiService (upvalue) ]]
        if v1055:IsGamepad() and GamepadService.GamepadCursorEnabled and not v1055:PickerOpen() and not GuiService.MenuIsOpen then
            task.defer(function() --[[ Upvalues: v1055 (upvalue) ]]
                if v1055:IsGamepad() then
                    v1055:SyncOwnership()
                end

            end)
        end

    end)
    table.insert(v1055.Connections, v1072)
    local v1073 = GuiService.MenuOpened:Connect(function() --[[ Upvalues: v1055 (copy) ]]
        if v1055:IsGamepad() then
            v1055:CancelHeldInputs()
            v1055:SyncOwnership()
        end

    end)
    table.insert(v1055.Connections, v1073)
    local v1074 = GuiService.MenuClosed:Connect(function() --[[ Upvalues: v1055 (copy) ]]
        if v1055:IsGamepad() then
            v1055:SyncOwnership()
            if v1055.UI.MenuOpen then
                v1055.UI:FocusDefault()
            end
        end

    end)
    table.insert(v1055.Connections, v1074)
    local v1075 = UserInputService.WindowFocusReleased:Connect(function() --[[ Upvalues: v1055 (copy) ]]
        v1055.WindowUnfocused = true
        if v1055:IsGamepad() then
            v1055:CancelHeldInputs()
            v1055.HeldInputs = {}
            v1055.MenuPrimary = nil
        end

    end)
    table.insert(v1055.Connections, v1075)
    local v1076 = UserInputService.WindowFocused:Connect(function() --[[ Upvalues: v1055 (copy) ]]
        v1055.WindowUnfocused = false
        v1055:SyncOwnership()
    end)
    table.insert(v1055.Connections, v1076)
    local v1077 = UserInputService.TextBoxFocused:Connect(function() --[[ Upvalues: v1055 (copy) ]]
        if v1055:IsGamepad() then
            v1055:CancelHeldInputs()
            v1055:SyncOwnership()
        end

    end)
    table.insert(v1055.Connections, v1077)
    v1055.JumpStep = "ClassicBuildJump_" .. tostring(v1055)
    local v1078 = Enum.RenderPriority.Input.Value + 1
    RunService:BindToRenderStep(v1055.JumpStep, v1078, function() --[[ Upvalues: v1055 (copy) ]]
        v1055:ApplyJump()
    end)
    v1055.PrecisionCaptureStep = "ClassicBuildPrecisionCapture_" .. tostring(v1055)
    v1055.PrecisionApplyStep = "ClassicBuildPrecisionApply_" .. tostring(v1055)
    local v1079 = Enum.RenderPriority.Camera.Value - 1
    RunService:BindToRenderStep(v1055.PrecisionCaptureStep, v1079, function() --[[ Upvalues: v1055 (copy) ]]
        v1055:CapturePrecisionCamera()
    end)
    v1079 = Enum.RenderPriority.Camera.Value + 1
    RunService:BindToRenderStep(v1055.PrecisionApplyStep, v1079, function() --[[ Upvalues: v1055 (copy) ]]
        v1055:ApplyPrecisionCamera()
    end)
    local v1080 = RunService.RenderStepped:Connect(function(a0) --[[ Upvalues: v1055 (copy) ]]
        v1055:Step(a0)
    end)
    table.insert(v1055.Connections, v1080)
    local GamepadEnabled5 = UserInputService.GamepadEnabled
    if GamepadEnabled5 then
        GamepadEnabled5 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
    end

    v1055:SetActive(GamepadEnabled5)
    return v1055
end

v894.Start = Start
v3.Controller = v894
v1 = v3.MobileUI
UI1 = {}
UI1.__index = UI1

local function preferredTouch(a0) --[[ Upvalues: UserInputService (copy) ]]
    local TouchEnabled1 = UserInputService.TouchEnabled
    if TouchEnabled1 then
        TouchEnabled1 = false
        if UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad then
            TouchEnabled1 = true
            if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
                TouchEnabled1 = a0.ClassicMobile
                if TouchEnabled1 then
                    local v1081 = a0.ClassicMobile:IsActive()
                    if v1081 then
                        v1081 = UserInputService:GetFocusedTextBox() ~= nil
                    end
                end
            end
        end
    end

    return TouchEnabled1
end

local function IsActive(a0)
    local v1082 = false
    if a0.Active == true then
        v1082 = not a0.Destroyed
    end

    return v1082
end

UI1.IsActive = IsActive

local function BlocksWorld1(a0) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    if not a0:IsActive() then
        return false
    end

    local Client7 = a0.Client
    local MenuOpen5 = a0.UI.MenuOpen
    if not MenuOpen5 then
        MenuOpen5 = true
        if Client7.ColorPickerHUD == nil then
            MenuOpen5 = true
            if Client7.PaintResetConfirmOpen ~= true then
                MenuOpen5 = true
                if Client7.DeleteAllConfirmOpen ~= true then
                    local MenuIsOpen2 = GuiService.MenuIsOpen
                    if not MenuIsOpen2 then
                        MenuIsOpen2 = true
                        if UserInputService:GetFocusedTextBox() == nil then
                            MenuIsOpen2 = true
                            if a0.WindowUnfocused ~= true then
                                MenuIsOpen2 = Client7.BuildSystemSwitching == true
                            end
                        end
                    end
                end
            end
        end
    end

    return MenuOpen5
end

UI1.BlocksWorld = BlocksWorld1

local function GetRay(a0)
    local CurrentCamera5 = workspace.CurrentCamera
    local v1083 = CurrentCamera5.ViewportSize / 2
    local v1084 = CurrentCamera5:ViewportPointToRay(v1083.X, v1083.Y)
    return v1084
end

UI1.GetRay = GetRay

local function GetAim1(a0) --[[ Upvalues: raycastAim (copy) ]]
    local v1085 = a0:GetRay()
    local v1086 = raycastAim(a0.Client, workspace.CurrentCamera, v1085)
    return v1086
end

UI1.GetAim = GetAim1
UI1.GetDeleteTarget = getDeleteTarget

local function CancelHeld(a0)
    if a0.PrimaryStateConnection then
        a0.PrimaryStateConnection:Disconnect()
        a0.PrimaryStateConnection = nil
    end

    a0.PrimaryInput = nil
    a0.DeleteTarget = nil
    a0.DeleteStarted = nil
    a0.DeleteProgress = 0
end

UI1.CancelHeld = CancelHeld

local function IsSessionCurrent(a0, a1)
    local Client8 = a0.Client
    local v1087 = a0:IsActive()
    if v1087 then
        if a1 == nil or false == a1 then
            v1087 = false
            if Client8.ClassicMobile == a0 then
                v1087 = false
                if Client8.BuildCameraActive == true then
                    v1087 = false
                    if Client8.ClassicBuildActive == true then
                        v1087 = true
                        if Client8.EditingBase ~= true then
                            v1087 = Client8.Painting == true
                        end
                    end
                end
            end
        end
    end

    return v1087
end

UI1.IsSessionCurrent = IsSessionCurrent

local function Request1(a0, a1) --[[ Upvalues: ReplicatedStorage (copy) ]]
    local v1088 = false
    if type(a1) == "table" then
        v1088 = a1.action == "State"
    end

    if a0:IsSessionCurrent() then
        if not a0.Busy then
            if not v1088 then
                if not a0:BlocksWorld() then
                    -- jump to 30
                end

                -- branch continues at 30
            end
        end
    end

    return {ok = false, reason = "Wait for the current change to finish."}
    a0.Busy = true
    a0:CancelHeld()
    a0:RefreshPresentation()
    local Epoch = a0.Epoch
    if not v1088 then
        local v1089 = 0.065 - (os.clock() - (a0.LastMutationAt or -math.huge))
        if 0 < v1089 then
            task.wait(v1089)
        end
    end

    if a0:IsSessionCurrent(Epoch) then
        if not v1088 then
            if not a0:BlocksWorld() then
                -- jump to 79
            end

            -- branch continues at 79
        end
    end

    local v1090 = true
    local t10 = {ok = false, stale = true}
    a0.Busy = false
    if v1090 then
        if type(t10) == "table" then
            -- jump to 108
        end
    end

    t10 = {ok = false, reason = "Connection interrupted. Please try again."}
    if not (not t10.stale and a0:IsSessionCurrent(Epoch)) then
        t10 = {ok = false, stale = true}
        if a0:IsSessionCurrent() then
            a0.NeedsStateRefresh = true
            -- jump to 176 (out of range)
            -- branch continues at 176
        end
    end

    if type(t10.undo) == "number" then
        a0.UndoCount = t10.undo
    end

    if type(t10.redo) == "number" then
        a0.RedoCount = t10.redo
    end

    if not v1088 then
        local v1091
        if not t10.ok then
            v1091 = t10.reason
            if not v1091 then
                v1091 = "The change could not be saved."
                -- branch continues at 162
            end
        else
            v1091 = nil
        end

        a0.Status = v1091
        local v1093 = a0.Status and os.clock() + 3 or nil
        a0.StatusUntil = v1093
    end

    if not a0.Destroyed then
        a0:RefreshPresentation()
    end

    if a0.NeedsStateRefresh and a0:IsSessionCurrent() then
        a0.NeedsStateRefresh = nil
        task.defer(function() --[[ Upvalues: a0 (copy) ]]
            a0:RefreshState()
        end)
    end

    return t10
end

UI1.Request = Request1

local function RefreshState1(a0)
    if not a0:IsSessionCurrent() then
        return
    end

    if a0.Busy then
        a0.NeedsStateRefresh = true
        return
    end

    local v1094 = a0:Request({action = "State"})
    return v1094
end

UI1.RefreshState = RefreshState1

local function Commit1(a0, a1)
    if not a0:IsSessionCurrent() or a0.Busy or a0:BlocksWorld() then
        return
    end

    local Client9 = a0.Client
    if Client9.Painting then
        return
    end

    if Client9.BuildModeKind ~= "Objects" then
        return
    end

    if not Client9.EditObject then
        return
    end

    if typeof(a1) ~= "CFrame" then
        return
    end

    local EditObject4 = Client9.EditObject
    local EditingExistingObject2 = Client9.EditingExistingObject
    local Epoch1 = a0.Epoch
    local v1095 = {}
    local v1096
    if EditingExistingObject2 then
        v1096 = "Move"
    else
        v1096 = "Place"
    end

    v1095.action = v1096
    v1095.name = EditObject4.Name
    v1095.object = EditingExistingObject2
    v1095.cframe = a1
    local v1097 = a0:Request(v1095)
    if not (not v1097.stale and a0:IsSessionCurrent(Epoch1)) then
        return v1097
    end

    if v1097.ok then
        if EditingExistingObject2 then
            if EditingExistingObject2.Parent then
                EditingExistingObject2:PivotTo(a1)
            end

            if Client9.EditObject == EditObject4 and Client9.EditingExistingObject == EditingExistingObject2 then
                Client9:DeleteEditObject()
            end
        end

        Client9:UpdateStorageCapacity()
    end

    return v1097
end

UI1.Commit = Commit1

local function Delete1(a0, a1)
    if not a0:IsSessionCurrent() or a0.Busy or a0:BlocksWorld() then
        return
    end

    local Client10 = a0.Client
    local Epoch2 = a0.Epoch
    if Client10.Painting or Client10.BuildModeKind ~= "Objects" then
        return
    end

    local v1098 = {action = "Delete", object = a1}
    local v1099 = a0:Request(v1098)
    if v1099.ok and not v1099.stale and a0:IsSessionCurrent(Epoch2) then
        Client10:ClearBuildObjectHover()
        Client10:UpdateStorageCapacity()
        a0.EditTarget = nil
    end

    return v1099
end

UI1.Delete = Delete1

local function History2(a0, a1)
    if a1 == "Undo" or a1 == "Redo" then
        if not a0:IsSessionCurrent() then
            return
        end

        if a0.Busy then
            return
        end

        if not a0:BlocksWorld() then
            -- jump to 18
        end
    end

    return
    if a1 == "Undo" then
        local v1100 = a0.UndoCount or 0
        if v1100 <= 0 then
            return
        end
    end

    if a1 == "Redo" then
        local v1101 = a0.RedoCount or 0
        if v1101 <= 0 then
            return
        end
    end

    local Client11 = a0.Client
    local Epoch3 = a0.Epoch
    local EditObject5 = Client11.EditObject
    local EditingExistingObject3 = Client11.EditingExistingObject
    local v1102 = {action = a1}
    local v1103 = a0:Request(v1102)
    if v1103.ok then
        if not v1103.stale then
            if a0:IsSessionCurrent(Epoch3) then
                if EditObject5 and Client11.EditObject == EditObject5 and Client11.EditingExistingObject == EditingExistingObject3 then
                    Client11:DeleteEditObject()
                end

                Client11:ClearBuildObjectHover()
                Client11:UpdateStorageCapacity()
                a0.EditTarget = nil
            end
        end
    end

    return v1103
end

UI1.History = History2

local function RememberObject1(a0, a1) --[[ Upvalues: rememberObject (copy), ReplicatedStorage (copy) ]]
    rememberObject(a0.Client, ReplicatedStorage.Remotes.RemoteEvent, a1)
end

UI1.RememberObject = RememberObject1

local function Setting(a0, a1, a2) --[[ Upvalues: Preferences (copy), setFavorites (copy), ReplicatedStorage (copy) ]]
    if not a0:IsActive() or a1 ~= "favorites" then
        return
    end

    local Client12 = a0.Client
    if type(a2) == "string" and Preferences.IsValidName(a2) then
        local v1104 = table.clone(Client12.ModernBuildFavorites)
        v1104[a2] = not v1104[a2] or nil
        a2 = v1104
    end

    if type(a2) ~= "table" then
        return
    end

    setFavorites(Client12, ReplicatedStorage.Remotes.RemoteEvent, a2)
    a0:RefreshPresentation()
end

UI1.Setting = Setting

local function NotifySelected1(a0, a1)
    if not a0:IsActive() then
        return
    end

    a0:CancelHeld()
    a0:RememberObject(a1)
    a0.Status = nil
    a0.EditTarget = nil
    a0:RefreshPresentation()
end

UI1.NotifySelected = NotifySelected1

local function SetPaused1(a0, a1) --[[ Upvalues: setPaused (copy) ]]
    setPaused(a0, a1, a0.CancelHeld)
end

UI1.SetPaused = SetPaused1

local function SyncOwnership1(a0)
    if a0:IsActive() then
        local v1105 = a0:BlocksWorld()
        a0:SetPaused(v1105)
    end
end

UI1.SyncOwnership = SyncOwnership1

local function CloseMenu3(a0)
    a0:CancelHeld()
    a0.UI:CloseMenu()
    a0:SyncOwnership()
    a0:RefreshPresentation()
end

UI1.CloseMenu = CloseMenu3

local function ChooseItem1(a0, a1, a2) --[[ Upvalues: v2 (copy) ]]
    if not a0:IsActive() or a0.Busy then
        return
    end

    if a0.Client.Painting then
        v2.Close(a0.Client)
    end

    a0:CloseMenu()
    a0.Client:SelectEditObject(a1, a2)
    if a0.Client.EditObject then
        a0:NotifySelected(a1)
    end

    a0:RefreshPresentation()
end

UI1.ChooseItem = ChooseItem1

local function IsPrimaryPointer(a0, a1, a2)
    local Primary2 = a0.UI.Primary
    if not (Primary2 and Primary2.Parent and Primary2.Visible and a0.UI.ControlsGui.Enabled) then
        return false
    end

    local v1106 = Vector2.new(a1.Position.X, a1.Position.Y)
    local AbsolutePosition1 = Primary2.AbsolutePosition
    local AbsoluteSize3 = Primary2.AbsoluteSize
    a2 = a2 or 0
    local v1107 = false
    if AbsolutePosition1.X - a2 <= v1106.X then
        v1107 = false
        if v1106.X <= AbsolutePosition1.X + AbsoluteSize3.X + a2 then
            v1107 = false
            if AbsolutePosition1.Y - a2 <= v1106.Y then
                v1107 = v1106.Y <= AbsolutePosition1.Y + AbsoluteSize3.Y + a2
            end
        end
    end

    return v1107
end

UI1.IsPrimaryPointer = IsPrimaryPointer

local function PrimaryPress(a0, a1)
    if not a0:IsActive() or a0.Busy or a0:BlocksWorld() or a0.PrimaryInput then
        return
    end

    if a1.UserInputState ~= Enum.UserInputState.Begin then
        return
    end

    if a1.UserInputType == Enum.UserInputType.Touch or a1.UserInputType == Enum.UserInputType.MouseButton1 then
        if a0:IsPrimaryPointer(a1) then
            -- jump to 42
        end
    end

    return
    local v1108 = a0.Client.Player.PlayerGui:GetGuiObjectsAtPosition(a1.Position.X, a1.Position.Y)
    for k245, k246 in ipairs(v1108) do
        if k246 == a0.UI.Primary or k246:IsDescendantOf(a0.UI.Primary) then
            a0:PrimaryBegin(a1)
            return
        end

        if k246:IsA("GuiButton") or k246:IsA("TextBox") or k246.Active then
            return
        end
    end
end

UI1.PrimaryPress = PrimaryPress

local function PrimaryBegin(a0, a1) --[[ Upvalues: v2 (copy) ]]
    if not a0:IsActive() or a0.Busy or a0:BlocksWorld() or a0.PrimaryInput then
        return
    end

    a0.PrimaryInput = a1
    local v1112 = a1:GetPropertyChangedSignal("UserInputState")
    a0.PrimaryStateConnection = v1112:Connect(function() --[[ Upvalues: a1 (copy), a0 (copy) ]]
        if a1.UserInputState == Enum.UserInputState.End or a1.UserInputState == Enum.UserInputState.Cancel then
            a0:PrimaryEnd(a1)
        end

    end)
    local Client13 = a0.Client
    if Client13.Painting then
        v2.ControllerApply(Client13)
    else
        if Client13.DeletingObjects then
            a0.DeleteTarget = a0:GetDeleteTarget()
            local v1115 = a0.DeleteTarget and os.clock() or nil
            a0.DeleteStarted = v1115
            if a0.DeleteTarget then
                v1115 = "Keep holding to delete"
            else
                v1115 = "Aim at an object to delete"
            end

            a0.Status = v1115
        else
            if not Client13.EditObject then
                local v1116 = a0:GetDeleteTarget()
                local v1119 = v1116 and Client13:SelectPlacedBuildObject(v1116)
                if v1119 then
                    a0:NotifySelected(v1116.Name)
                    -- jump to 129 (out of range)
                end

                a0.Status = "Aim at an object in your base to edit"
            else
                local v1120 = os.clock() - (a0.LastPlace or 0)
                if v1120 < 0.2 then
                    return
                end

                local v1121, v1122 = Client13:CanPlaceClassicBuildObject()
                a0.Status = v1122
                if v1121 then
                    a0.LastPlace = os.clock()
                    Client13:PlaceClassicBuildObject()
                end
            end
        end
    end

    a0:RefreshPresentation()
end

UI1.PrimaryBegin = PrimaryBegin

local function PrimaryEnd(a0, a1)
    if a1 == a0.PrimaryInput then
        a0:CancelHeld()
        a0:RefreshPresentation()
    end
end

UI1.PrimaryEnd = PrimaryEnd

local function CheckPrimaryPointer(a0, a1)
    if not a0.PrimaryInput or a1 ~= a0.PrimaryInput then
        return
    end

    if not (a1.UserInputState ~= Enum.UserInputState.Cancel and a1.UserInputState ~= Enum.UserInputState.End and a0:IsPrimaryPointer(a1, 32)) then
        a0:CancelHeld()
    end
end

UI1.CheckPrimaryPointer = CheckPrimaryPointer
UI1.Exit = exit

local function OpenLegacyPanel1(a0, a1) --[[ Upvalues: ReplicatedStorage (copy), UserInputService (copy) ]]
    local Client14 = a0.Client
    a0:Exit()
    if Client14.ClassicReturnCleanup then
        Client14.ClassicReturnCleanup(false)
    end

    if a1 == "Customize" then
        Client14:OpenCustomizeBase()
    else
        Client14:OpenBaseSlots()
    end

    local v1123
    if not (a1 == "Customize" and Client14.HUD.BaseCustomization) then
        v1123 = Client14.HUD.BaseSlots
    end

    if not (v1123 and v1123.Visible) then
        return
    end

    Client14.MainContext.Enabled = false
    ReplicatedStorage.Remotes.RemoteEvent:FireServer("M1U")
    ReplicatedStorage.Remotes.RemoteEvent:FireServer("M2U")
    ReplicatedStorage.Remotes.RemoteEvent:FireServer("RunOff")
    local ScreenGui1 = Instance.new("ScreenGui")
    ScreenGui1.Name = "ClassicMobileReturn"
    ScreenGui1.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
    ScreenGui1.DisplayOrder = 90
    ScreenGui1.ResetOnSpawn = false
    local TextButton3 = Instance.new("TextButton")
    TextButton3.Name = "Return"
    TextButton3.Size = UDim2.fromOffset(164, 48)
    TextButton3.AnchorPoint = Vector2.new(1, 0)
    TextButton3.Position = UDim2.new(1, -12, 0, 8)
    TextButton3.Text = "Back to building"
    TextButton3.TextSize = 16
    TextButton3.Font = Enum.Font.Code
    TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextButton3.BackgroundTransparency = 0.5
    TextButton3.BorderColor3 = Color3.fromRGB(255, 255, 255)
    TextButton3.BorderSizePixel = 2
    TextButton3.BorderMode = Enum.BorderMode.Inset
    TextButton3.AutoButtonColor = false
    TextButton3.Parent = ScreenGui1
    ScreenGui1.Parent = Client14.Player.PlayerGui
    local v1124 = {}
    local v1125 = false
    local Enabled1 = Client14.MainContext.Enabled

    local function cleanup1(a0) --[[ Upvalues: v1125 (ref), v1124 (copy), ScreenGui1 (copy), Client14 (copy), Enabled1 (copy), UserInputService (upvalue) ]]
        if v1125 then
            return
        end

        v1125 = true
        for k247, k248 in ipairs(v1124) do
            k248:Disconnect()
        end

        ScreenGui1:Destroy()
        Client14.MainContext.Enabled = Enabled1
        Client14.ClassicReturnCleanup = nil
        task.defer(function() --[[ Upvalues: a0 (copy), Client14 (upvalue), UserInputService (upvalue) ]]
            if a0 then
                local v1129 = Client14
                local TouchEnabled2 = UserInputService.TouchEnabled
                if TouchEnabled2 then
                    TouchEnabled2 = false
                    if UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad then
                        TouchEnabled2 = true
                        if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
                            TouchEnabled2 = v1129.ClassicMobile
                            if TouchEnabled2 then
                                TouchEnabled2 = v1129.ClassicMobile:IsActive()
                                if TouchEnabled2 then
                                    TouchEnabled2 = UserInputService:GetFocusedTextBox() ~= nil
                                end
                            end
                        end
                    end
                end

                if TouchEnabled2 and Client14.Player:GetAttribute("InBase") and Client14.Humanoid and 0 < Client14.Humanoid.Health and not Client14.EditingBase and not Client14.CustomizingBase and not Client14.InBaseSlots and not Client14.Painting then
                    Client14:EditStorage()
                end
            end

        end)
    end

    Client14.ClassicReturnCleanup = cleanup1
    local v1130 = TextButton3.Activated:Connect(function() --[[ Upvalues: a1 (copy), Client14 (copy) ]]
        if a1 == "Customize" then
            Client14:CloseCustomizeBase()
            return
        end

        Client14:CloseBaseSlotConfirmation()
        Client14:CloseBaseSlots()
    end)
    table.insert(v1124, v1130)
    local v1131 = v1123:GetPropertyChangedSignal("Visible")
    local v1132 = v1131:Connect(function() --[[ Upvalues: v1123 (copy), cleanup1 (copy) ]]
        if not v1123.Visible then
            cleanup1(true)
        end

    end)
    table.insert(v1124, v1132)
    local v1133 = Client14.Player.CharacterRemoving:Connect(function() --[[ Upvalues: cleanup1 (copy) ]]
        cleanup1(false)
    end)
    table.insert(v1124, v1133)
    local v1134 = Client14.Player:GetAttributeChangedSignal("InBase")
    local v1135 = v1134:Connect(function() --[[ Upvalues: Client14 (copy), cleanup1 (copy) ]]
        if not Client14.Player:GetAttribute("InBase") then
            cleanup1(false)
        end

    end)
    table.insert(v1124, v1135)
end

UI1.OpenLegacyPanel = OpenLegacyPanel1

local function SetRotationStep1(a0, a1) --[[ Upvalues: t1 (copy) ]]
    if not (a0:IsActive() and not a0.Busy and table.find(t1, a1)) then
        return
    end

    a0.RotateStep = a1
    a0.Client.ClassicMobileRotateStep = a1
    a0.Status = nil
    a0:CloseMenu()
end

UI1.SetRotationStep = SetRotationStep1

local function Action(a0, a1) --[[ Upvalues: v2 (copy) ]]
    if not a0:IsActive() then
        return
    end

    if a0.Busy then
        if a1 ~= "Exit" then
            return
        end
    end

    a0:CancelHeld()
    local Client15 = a0.Client
    if a1 == "Undo" or a1 == "Redo" then
        a0:CloseMenu()
        a0:History(a1)
        return
    end

    if a1 == "RotationSteps" then
        if Client15.Painting or Client15.DeletingObjects then
            return
        end
    end

    if a1 == "Catalogue" or a1 == "Options" or a1 == "RotationSteps" then
        if Client15.ColorPickerHUD then
            v2.ClosePicker(Client15)
        end

        if a1 == "Catalogue" then
            a0.UI:OpenCatalogue()
        else
            if a1 == "RotationSteps" then
                a0.UI:OpenRotationSteps()
            else
                a0.UI:OpenOptions()
            end
        end

        a0:SyncOwnership()
        a0:RefreshPresentation()
        return
    end

    if a1 == "DeleteAll" then
        if not Client15.EditingBase then
            return
        end

        a0:CloseMenu()
        if Client15.Painting then
            v2.Close(Client15)
        end

        if not a0:IsActive() then
            return
        end

        Client15:SetDeleteAllConfirmation(true)
        a0:SyncOwnership()
        a0:RefreshPresentation()
        return
    end

    if a1 == "SwitchModern" then
        a0:CloseMenu()
        if Client15.Painting then
            v2.Close(Client15)
        end

        if Client15.BuildCameraActive then
            Client15:SetBuildSystem("Modern", true)
            return
        end

        if Client15:SetBuildSystem("Modern") then
            Client15:EditStorage()
        end

        return
    end

    if a1 == "Customize" or a1 == "SaveSlots" then
        a0:OpenLegacyPanel(a1)
        return
    end

    if a1 == "Exit" then
        a0:Exit()
        return
    end

    a0:CloseMenu()
    if a1 == "Paint" then
        if not Client15.Painting then
            Client15:OpenPaintFrames()
            -- branch continues at 328
        end
    else
        if a1 == "Objects" then
            if Client15.Painting then
                v2.Close(Client15)
                -- branch continues at 328
            end
        else
            if a1 == "DeleteMode" then
                if Client15.Painting then
                    v2.Close(Client15)
                end

                Client15:SetDeletingObjects(not Client15.DeletingObjects)
            else
                if a1 == "Deselect" or a1 == "SelectExisting" then
                    if Client15.Painting then
                        v2.Close(Client15)
                    end

                    Client15:DeleteEditObject()
                    Client15:SetDeletingObjects(false)
                    a0.EditTarget = nil
                    -- jump to 328 (out of range)
                end

                if a1 == "Axis" then
                    a0.Axis = ({Y = "X", X = "Z", Z = "Y"})[a0.Axis]
                else
                    if a1 == "RotateLeft" or a1 == "RotateRight" then
                        if not Client15.Painting then
                            local Axis1 = a0.Axis
                            local v1136
                            if a1 == "RotateLeft" then
                                v1136 = -1
                            else
                                v1136 = 1
                            end

                            Client15:RotateClassicBuildObject(Axis1, v1136, a0.RotateStep)
                            -- jump to 328 (out of range)
                            -- branch continues at 328
                        end
                    end

                    if a1 == "Precision" then
                        a0.Precision = not a0.Precision
                    else
                        if a1 == "ColorPicker" then
                            v2.ControllerPicker(Client15)
                        else
                            if a1 == "ResetPaint" then
                                v2.ShowResetConfirmation(Client15)
                            else
                                if a1 == "Brush" or a1 == "Bucket" or a1 == "Dropper" then
                                    if not Client15.Painting then
                                        Client15:OpenPaintFrames()
                                    end

                                    v2.ControllerTool(Client15, ({Brush = "PaintBrush", Bucket = "PaintBucket", Dropper = "ColorDropper"})[a1])
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    a0.Status = nil
    a0:SyncOwnership()
    a0:RefreshPresentation()
end

UI1.Action = Action
UI1.SaveAndHide = saveAndHide

local function RefreshPresentation1(a0) --[[ Upvalues: GuiService (copy) ]]
    if not a0:IsActive() then
        return
    end

    local Client16 = a0.Client
    local v1137 = "BaseEdit"
    local v1138 = {
        "BaseObjects",
        v1137,
        "PaintEditBar",
        "MobileEdits",
        "MobileMouse",
        "Crosshair"
    }
    for k249, k250 in ipairs(v1138) do
        local v1142 = Client16.HUD:FindFirstChild(k250)
        a0:SaveAndHide(v1142)
    end

    if Client16.BuildGui then
        k250 = "TransformPanel"
        local v1143 = {
            "Toolbar",
            k250,
            "ViewPanel",
            "Hint",
            "ControllerHotkeys",
            "BuildSystemToggle"
        }
        for k251, k252 in ipairs(v1143) do
            local v1147 = Client16.BuildGui:FindFirstChild(k252)
            a0:SaveAndHide(v1147)
        end
    end

    local UI2 = a0.UI
    k249 = {}
    k249.itemName = Client16.EditObject and Client16.EditObject.Name or nil
    k249.editing = Client16.EditingExistingObject ~= nil
    local v1152 = not Client16.EditObject and not Client16.Painting and not Client16.DeletingObjects
    k249.selecting = v1152
    k249.editTargetName = a0.EditTarget and a0.EditTarget.Name or nil
    local ModernBuildFavorites5 = Client16.ModernBuildFavorites
    if not ModernBuildFavorites5 then
        ModernBuildFavorites5 = {}
    end

    k249.favorites = ModernBuildFavorites5
    ModernBuildFavorites5 = Client16.ModernBuildRecents
    if not ModernBuildFavorites5 then
        ModernBuildFavorites5 = {}
    end

    k249.recent = ModernBuildFavorites5
    k249.axis = a0.Axis
    k249.precision = a0.Precision == true
    k249.rotateStep = a0.RotateStep
    k249.deleting = Client16.DeletingObjects == true
    k249.deleteProgress = a0.DeleteProgress or 0
    k249.undoCount = a0.UndoCount or 0
    k249.redoCount = a0.RedoCount or 0
    k249.busy = a0.Busy == true
    k249.status = a0.Status
    k249.valid = a0.Valid
    local v1154
    if Client16.Painting then
        v1154 = "Paint"
    else
        v1154 = "Objects"
    end

    k249.mode = v1154
    k249.paintMode = Client16.PaintMode
    k249.canDeleteAll = Client16.EditingBase == true
    k249.color = Client16.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3
    v1154 = Client16.ColorPickerHUD ~= nil
    if not v1154 then
        v1154 = true
        if Client16.PaintResetConfirmOpen ~= true then
            v1154 = true
            if Client16.DeleteAllConfirmOpen ~= true then
                v1154 = GuiService.MenuIsOpen
                if not v1154 then
                    v1154 = a0.WindowUnfocused == true
                end
            end
        end
    end

    k249.blocked = v1154
    UI2:Update(k249)
end

UI1.RefreshPresentation = RefreshPresentation1

local function CapturePrecision(a0)
    a0.PrecisionCamera = nil
    a0.PrecisionRotation = nil
    if not a0:IsActive() or not a0.Precision or a0:BlocksWorld() then
        return
    end

    local CurrentCamera6 = workspace.CurrentCamera
    if CurrentCamera6.CameraType == Enum.CameraType.Scriptable then
        return
    end

    a0.PrecisionCamera = CurrentCamera6
    a0.PrecisionRotation = CurrentCamera6.CFrame.Rotation
end

UI1.CapturePrecision = CapturePrecision

local function ApplyPrecision(a0)
    local PrecisionCamera1 = a0.PrecisionCamera
    local PrecisionRotation1 = a0.PrecisionRotation
    a0.PrecisionCamera = nil
    a0.PrecisionRotation = nil
    if not PrecisionCamera1 or not PrecisionRotation1 or not a0:IsActive() or not a0.Precision or a0:BlocksWorld() then
        return
    end

    if workspace.CurrentCamera ~= PrecisionCamera1 or PrecisionCamera1.CameraType == Enum.CameraType.Scriptable then
        return
    end

    local v1155 = CFrame.new(PrecisionCamera1.CFrame.Position)
    PrecisionCamera1.CFrame = v1155 * PrecisionRotation1:Lerp(PrecisionCamera1.CFrame.Rotation, 0.3)
end

UI1.ApplyPrecision = ApplyPrecision

local function Step1(a0, a1)
    if not a0:IsActive() then
        return
    end

    local Client17 = a0.Client
    if not Client17.ClassicBuildActive then
        a0:Destroy()
        return
    end

    a0:SyncOwnership()
    if a0.StatusUntil and a0.StatusUntil <= os.clock() then
        a0.StatusUntil = nil
    end

    if a0:BlocksWorld() or a0.Busy then
        a0:CancelHeld()
        Client17:ClearBuildObjectHover()
        -- jump to 135 (out of range)
    end

    if a0.DeleteStarted then
        local DeleteTarget = a0.DeleteTarget
        if not a0.PrimaryInput or not Client17.DeletingObjects or not DeleteTarget or not DeleteTarget.Parent or Client17:ResolvePlacedBuildObject(DeleteTarget) ~= DeleteTarget then
            a0:CancelHeld()
            -- jump to 135 (out of range)
        end

        local v1156 = (os.clock() - a0.DeleteStarted) / 0.45
        a0.DeleteProgress = math.clamp(v1156, 0, 1)
        if 1 <= a0.DeleteProgress then
            a0:CancelHeld()
            local v1157 = Client17:DeleteClassicBuildTarget(DeleteTarget)
            if not a0:IsSessionCurrent(a0.Epoch) then
                return
            end

            if v1157 then
                a0.Status = "Deleted"
                a0.StatusUntil = os.clock() + 1
            else
                if not a0.StatusUntil then
                    a0.Status = "Aim at an object to delete"
                end
            end
        end
    end

    a0.RefreshElapsed = (a0.RefreshElapsed or 0) + a1
    if 0.08 <= a0.RefreshElapsed then
        a0.RefreshElapsed = 0
        a0.Valid = nil
        a0.EditTarget = nil
        if not a0:BlocksWorld() then
            if not a0.Busy then
                if Client17.EditObject and not Client17.Painting then
                    local v1158, v1159 = Client17:CanPlaceClassicBuildObject()
                    a0.Valid = v1158
                    if not a0.StatusUntil then
                        a0.Status = v1159
                    end

                    local v1160 = Client17.EditObject:FindFirstChildOfClass("Highlight")
                    if v1160 then
                        local v1163
                        if not (v1158 and Color3.fromRGB(100, 220, 160)) then
                            local v1164 = Color3.fromRGB(255, 100, 110)
                        end

                        v1160.FillColor = v1163
                        v1160.OutlineColor = v1160.FillColor
                        -- branch continues at 278
                    end
                else
                    if Client17.DeletingObjects then
                        local v1165 = workspace.CurrentCamera.ViewportSize / 2
                        local v1166 = Client17:UpdateBuildObjectHover(v1165, true)
                        local v1167
                        if not a0.StatusUntil then
                            if v1166 then
                                if a0.DeleteStarted then
                                    v1167 = "Keep holding to delete"
                                    -- jump to 241 (out of range)
                                end

                                v1167 = "Hold to delete " .. v1166.Name
                                if v1167 then
                                    -- jump to 241
                                end
                            end

                            v1167 = "Aim at an object to delete"
                            a0.Status = v1167
                            -- branch continues at 278
                        end
                    else
                        if not Client17.Painting then
                            local v1168 = workspace.CurrentCamera.ViewportSize / 2
                            a0.EditTarget = Client17:UpdateBuildObjectHover(v1168, true)
                            if not a0.StatusUntil then
                                a0.Status = a0.EditTarget and "Select " .. a0.EditTarget.Name .. " to move or rotate" or "Aim at an object to edit, or choose from Catalogue"
                            end
                        end
                    end
                end
            end
        end

        a0:RefreshPresentation()
    end
end

UI1.Step = Step1

local function SetActive4(a0, a1)
    if a0.Destroyed or a0.Active == a1 then
        return
    end

    a0.Epoch = (a0.Epoch or 0) + 1
    if a1 then
        if a0.Client.ClassicController and a0.Client.ClassicController:IsGamepad() then
            a0.Client.ClassicController:SetActive(false)
        end

        a0.Active = true
        a0.UI:SetActive(true)
        a0:RefreshPresentation()
        a0.UI:OpenCatalogue()
        a0:SyncOwnership()
        task.defer(function() --[[ Upvalues: a0 (copy) ]]
            a0:RefreshState()
        end)
        return
    end

    a0:CancelHeld()
    if a0.Client.DeleteAllConfirmOpen then
        a0.Client:SetDeleteAllConfirmation(false)
    end

    a0.UI:CloseMenu()
    a0:SetPaused(false)
    a0.Active = false
    a0.Precision = false
    a0.UI:SetActive(false)
    for k253, k254 in pairs(a0.Hidden) do
        if k253.Parent then
            k253.Visible = k254
        end
    end

    a0.Hidden = {}
    if a0.Client.ClassicBuildActive then
        a0.Client:ApplyClassicBuildPresentation()
    end
end

UI1.SetActive = SetActive4

local function Destroy5(a0) --[[ Upvalues: RunService (copy) ]]
    if a0.Destroyed then
        return
    end

    if a0.Active then
        a0:SetActive(false)
    end

    a0.Destroyed = true
    for k255, k256 in ipairs(a0.Connections) do
        k256:Disconnect()
    end

    a0.Connections = {}
    RunService:UnbindFromRenderStep(a0.CaptureName)
    RunService:UnbindFromRenderStep(a0.ApplyName)
    a0.UI:Destroy()
end

UI1.Destroy = Destroy5

local function InstallLauncher1(a0) --[[ Upvalues: v1 (copy) ]]
    local v1177 = v1.InstallLauncher(a0)
    return v1177
end

UI1.InstallLauncher = InstallLauncher1

local function Start1(a0) --[[ Upvalues: loadCataloguePreferences (copy), t1 (copy), UI1 (copy), v1 (copy), UserInputService (copy), GuiService (copy), RunService (copy) ]]
    loadCataloguePreferences(a0)
    local v1179 = table.find(t1, a0.ClassicMobileRotateStep) and a0.ClassicMobileRotateStep or 90
    local v1180 = {
        Active = false,
        Axis = "Y",
        Epoch = 0,
        UndoCount = 0,
        RedoCount = 0,
        Client = a0,
        Connections = {},
        Hidden = {},
        RotateStep = v1179
    }
    local v1181 = setmetatable(v1180, UI1)
    v1179 = a0.Player:FindFirstChild("PlayerScripts")
    local v1183 = v1179 and v1179:FindFirstChild("PlayerModule")
    if v1183 then
        local v1185, v1186 = pcall(function() --[[ Upvalues: v1183 (copy) ]]
            local v1184 = require(v1183):GetControls()
            return v1184
        end)
        if v1185 then
            v1181.Controls = v1186
        end
    end

    local function Action1(a0) --[[ Upvalues: v1181 (copy) ]]
        v1181:Action(a0)
    end

    local function Setting1(a0, a1) --[[ Upvalues: v1181 (copy) ]]
        v1181:Setting(a0, a1)
    end

    local function RotationStep1(a0) --[[ Upvalues: v1181 (copy) ]]
        v1181:SetRotationStep(a0)
    end

    local function SelectItem1(a0, a1) --[[ Upvalues: v1181 (copy) ]]
        v1181:ChooseItem(a0, a1)
    end

    local function Close1() --[[ Upvalues: v1181 (copy) ]]
        v1181:CloseMenu()
    end

    local v1187 = {
        Action = Action1,
        Setting = Setting1,
        RotationStep = RotationStep1,
        SelectItem = SelectItem1,
        Close = Close1
    }
    v1181.UI = v1.new(a0, v1187)

    local function connect1(a0, a1) --[[ Upvalues: v1181 (copy) ]]
        local v1188 = a0:Connect(a1)
        table.insert(v1181.Connections, v1188)
    end

    local function sync() --[[ Upvalues: v1181 (copy), a0 (copy), UserInputService (upvalue) ]]
        task.defer(function() --[[ Upvalues: v1181 (upvalue), a0 (upvalue), UserInputService (upvalue) ]]
            if not v1181.Destroyed then
                local v1189 = v1181
                local v1190 = a0
                local TouchEnabled3 = UserInputService.TouchEnabled
                if TouchEnabled3 then
                    TouchEnabled3 = false
                    if UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad then
                        TouchEnabled3 = true
                        if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
                            TouchEnabled3 = v1190.ClassicMobile
                            if TouchEnabled3 then
                                TouchEnabled3 = v1190.ClassicMobile:IsActive()
                                if TouchEnabled3 then
                                    TouchEnabled3 = UserInputService:GetFocusedTextBox() ~= nil
                                end
                            end
                        end
                    end
                end

                v1189:SetActive(TouchEnabled3)
            end

        end)
    end

    local v1191 = UserInputService:GetPropertyChangedSignal("PreferredInput")
    local v1195 = v1191:Connect(function() --[[ Upvalues: v1181 (copy), a0 (copy), UserInputService (upvalue) ]]
        local v1192 = v1181
        v1192.Epoch = v1192.Epoch + 1
        task.defer(function() --[[ Upvalues: v1181 (upvalue), a0 (upvalue), UserInputService (upvalue) ]]
            if not v1181.Destroyed then
                local v1193 = v1181
                local v1194 = a0
                local TouchEnabled4 = UserInputService.TouchEnabled
                if TouchEnabled4 then
                    TouchEnabled4 = false
                    if UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad then
                        TouchEnabled4 = true
                        if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
                            TouchEnabled4 = v1194.ClassicMobile
                            if TouchEnabled4 then
                                TouchEnabled4 = v1194.ClassicMobile:IsActive()
                                if TouchEnabled4 then
                                    TouchEnabled4 = UserInputService:GetFocusedTextBox() ~= nil
                                end
                            end
                        end
                    end
                end

                v1193:SetActive(TouchEnabled4)
            end

        end)
    end)
    table.insert(v1181.Connections, v1195)
    local v1196 = UserInputService.TextBoxFocusReleased:Connect(sync)
    table.insert(v1181.Connections, v1196)
    local v1197 = UserInputService.InputBegan:Connect(function(a0) --[[ Upvalues: v1181 (copy) ]]
        v1181:PrimaryPress(a0)
    end)
    table.insert(v1181.Connections, v1197)
    local v1198 = UserInputService.InputEnded:Connect(function(a0) --[[ Upvalues: v1181 (copy) ]]
        v1181:PrimaryEnd(a0)
    end)
    table.insert(v1181.Connections, v1198)
    local v1199 = UserInputService.InputChanged:Connect(function(a0) --[[ Upvalues: v1181 (copy) ]]
        v1181:CheckPrimaryPointer(a0)
    end)
    table.insert(v1181.Connections, v1199)
    local v1200 = UserInputService.WindowFocusReleased:Connect(function() --[[ Upvalues: v1181 (copy) ]]
        v1181.WindowUnfocused = true
        v1181:CancelHeld()
        v1181:SyncOwnership()
        v1181:RefreshPresentation()
    end)
    table.insert(v1181.Connections, v1200)
    local v1201 = UserInputService.WindowFocused:Connect(function() --[[ Upvalues: v1181 (copy) ]]
        v1181.WindowUnfocused = false
        v1181:SyncOwnership()
        v1181:RefreshPresentation()
    end)
    table.insert(v1181.Connections, v1201)
    local v1202 = a0.Player.CharacterRemoving:Connect(function() --[[ Upvalues: v1181 (copy) ]]
        v1181:Destroy()
    end)
    table.insert(v1181.Connections, v1202)
    local v1203 = GuiService.MenuOpened:Connect(function() --[[ Upvalues: v1181 (copy) ]]
        v1181:CancelHeld()
        v1181:SyncOwnership()
        v1181:RefreshPresentation()
    end)
    table.insert(v1181.Connections, v1203)
    local v1204 = GuiService.MenuClosed:Connect(function() --[[ Upvalues: v1181 (copy) ]]
        v1181:SyncOwnership()
        v1181:RefreshPresentation()
    end)
    table.insert(v1181.Connections, v1204)
    local v1205 = UserInputService.TextBoxFocused:Connect(function() --[[ Upvalues: v1181 (copy) ]]
        v1181:CancelHeld()
        v1181:SyncOwnership()
    end)
    table.insert(v1181.Connections, v1205)
    local v1206 = RunService.RenderStepped:Connect(function(a0) --[[ Upvalues: v1181 (copy) ]]
        v1181:Step(a0)
    end)
    table.insert(v1181.Connections, v1206)
    v1181.CaptureName = "ClassicMobilePrecisionCapture_" .. tostring(v1181)
    v1181.ApplyName = "ClassicMobilePrecisionApply_" .. tostring(v1181)
    local v1207 = Enum.RenderPriority.Camera.Value - 1
    RunService:BindToRenderStep(v1181.CaptureName, v1207, function() --[[ Upvalues: v1181 (copy) ]]
        v1181:CapturePrecision()
    end)
    v1207 = Enum.RenderPriority.Camera.Value + 1
    RunService:BindToRenderStep(v1181.ApplyName, v1207, function() --[[ Upvalues: v1181 (copy) ]]
        v1181:ApplyPrecision()
    end)
    local TouchEnabled5 = UserInputService.TouchEnabled
    if TouchEnabled5 then
        TouchEnabled5 = false
        if UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad then
            TouchEnabled5 = true
            if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
                TouchEnabled5 = a0.ClassicMobile
                if TouchEnabled5 then
                    local v1208 = a0.ClassicMobile:IsActive()
                    if v1208 then
                        v1208 = UserInputService:GetFocusedTextBox() ~= nil
                    end
                end
            end
        end
    end

    v1181:SetActive(TouchEnabled5)
    return v1181
end

UI1.Start = Start1
v3.Mobile = UI1
saveAndHide = {}
saveAndHide.__index = saveAndHide

local function IsActive1(a0) --[[ Upvalues: UserInputService (copy) ]]
    local Client18 = a0.Client
    local v1209 = not a0.Destroyed
    if v1209 then
        v1209 = false
        if Client18.BuildCameraActive == true then
            v1209 = false
            if Client18.ClassicBuildActive == true then
                v1209 = false
                if Client18.EditingBase == true then
                    v1209 = false
                    if UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse then
                        local v1211 = Client18.ClassicMobile and Client18.ClassicMobile:IsActive()
                        v1209 = not v1211
                        if v1209 then
                            local v1213 = Client18.ClassicController and Client18.ClassicController:IsGamepad()
                            v1209 = not v1213
                        end
                    end
                end
            end
        end
    end

    return v1209
end

saveAndHide.IsActive = IsActive1

local function Blocked(a0) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    local Client19 = a0.Client
    local WindowUnfocused = a0.WindowUnfocused
    if not WindowUnfocused then
        local MenuIsOpen4 = GuiService.MenuIsOpen
        if not MenuIsOpen4 then
            MenuIsOpen4 = true
            if UserInputService:GetFocusedTextBox() == nil then
                MenuIsOpen4 = Client19.DeleteAllConfirmOpen
                if not MenuIsOpen4 then
                    MenuIsOpen4 = Client19.PaintResetConfirmOpen
                    if not MenuIsOpen4 then
                        MenuIsOpen4 = true
                        if Client19.ColorPickerHUD == nil then
                            MenuIsOpen4 = Client19.BuildSystemSwitching
                        end
                    end
                end
            end
        end
    end

    return WindowUnfocused
end

saveAndHide.Blocked = Blocked

local function Refresh2(a0)
    if a0.Destroyed then
        return
    end

    local v1214 = a0:IsActive()
    local v1217 = v1214 and not a0.WasActive
    if v1214 ~= a0.WasActive then
        a0.Epoch = a0.Epoch + 1
    end

    a0.WasActive = v1214
    a0.UI:SetActive(v1214)
    local v1218 = a0:Blocked()
    a0.UI:Refresh(a0.UndoCount, a0.RedoCount, a0.Busy, v1218)
    if v1217 then
        task.defer(function() --[[ Upvalues: a0 (copy) ]]
            if a0:IsActive() then
                a0:RefreshState()
            end

        end)
    end
end

saveAndHide.Refresh = Refresh2

local function Request2(a0, a1) --[[ Upvalues: ReplicatedStorage (copy) ]]
    local v1219 = false
    if type(a1) == "table" then
        v1219 = a1.action == "State"
    end

    if a0:IsActive() then
        if not a0.Busy then
            if not v1219 then
                if not a0:Blocked() then
                    -- jump to 30
                end

                -- branch continues at 30
            end
        end
    end

    return {ok = false, reason = "Wait for the current change to finish."}
    a0.Busy = true
    local Client20 = a0.Client
    if not v1219 then
        Client20:EndClassicBuildMouseDrag()
    end

    a0:Refresh()
    local Epoch4 = a0.Epoch
    if not v1219 then
        local v1220 = 0.065 - (os.clock() - (a0.LastMutationAt or -math.huge))
        if 0 < v1220 then
            task.wait(v1220)
        end
    end

    local Destroyed = a0.Destroyed
    if not Destroyed then
        Destroyed = true
        if a0.Epoch == Epoch4 then
            Destroyed = not a0:IsActive()
        end
    end

    if not Destroyed then
        if not v1219 then
            if not a0:Blocked() then
                -- jump to 90
            end

            -- branch continues at 90
        end
    end

    local v1221 = true
    local t11 = {ok = false, stale = true}
    a0.Busy = false
    if v1221 then
        if type(t11) == "table" then
            -- jump to 119
        end
    end

    t11 = {ok = false, reason = "Connection interrupted. Please try again."}
    local stale = t11.stale
    if not stale then
        stale = a0.Destroyed
        if not stale then
            stale = true
            if a0.Epoch == Epoch4 then
                stale = not a0:IsActive()
            end
        end
    end

    if stale then
        t11 = {ok = false, stale = true}
        if not a0.Destroyed then
            if a0:IsActive() then
                a0.NeedsStateRefresh = true
                -- branch continues at 189
            end

            -- branch continues at 189
        end
    else
        if type(t11.undo) == "number" then
            a0.UndoCount = t11.undo
        end

        if type(t11.redo) == "number" then
            a0.RedoCount = t11.redo
        end

        if not t11.ok and not v1219 then
            local v1222 = {
                Title = "Build Mode",
                Duration = 3,
                Text = t11.reason or "The change could not be saved."
            }
            Client20:Noti(v1222)
        end
    end

    a0:Refresh()
    if a0.NeedsStateRefresh and not a0.Destroyed then
        a0.NeedsStateRefresh = nil
        task.defer(function() --[[ Upvalues: a0 (copy) ]]
            a0:RefreshState()
        end)
    end

    return t11
end

saveAndHide.Request = Request2

local function RefreshState2(a0)
    if not a0:IsActive() then
        return
    end

    if a0.Busy then
        a0.NeedsStateRefresh = true
        return
    end

    local v1223 = a0:Request({action = "State"})
    return v1223
end

saveAndHide.RefreshState = RefreshState2

local function Commit2(a0, a1)
    if not a0:IsActive() or a0.Busy or a0:Blocked() then
        return
    end

    local Client21 = a0.Client
    if Client21.Painting then
        return
    end

    if Client21.BuildModeKind ~= "Objects" then
        return
    end

    if not Client21.EditObject then
        return
    end

    if typeof(a1) ~= "CFrame" then
        return
    end

    local EditObject6 = Client21.EditObject
    local EditingExistingObject4 = Client21.EditingExistingObject
    local Epoch5 = a0.Epoch
    local v1224 = {}
    local v1225
    if EditingExistingObject4 then
        v1225 = "Move"
    else
        v1225 = "Place"
    end

    v1224.action = v1225
    v1224.name = EditObject6.Name
    v1224.object = EditingExistingObject4
    v1224.cframe = a1
    local v1226 = a0:Request(v1224)
    if a0.Destroyed or a0.Epoch ~= Epoch5 or not a0:IsActive() or v1226.stale then
        return v1226
    end

    if v1226.ok then
        if EditingExistingObject4 then
            if EditingExistingObject4.Parent then
                EditingExistingObject4:PivotTo(a1)
            end

            if Client21.EditObject == EditObject6 and Client21.EditingExistingObject == EditingExistingObject4 then
                Client21:DeleteEditObject()
            end
        end

        Client21:UpdateStorageCapacity()
    end

    return v1226
end

saveAndHide.Commit = Commit2

local function Delete2(a0, a1)
    if not a0:IsActive() or a0.Busy or a0:Blocked() then
        return
    end

    local Client22 = a0.Client
    local Epoch6 = a0.Epoch
    if Client22.Painting or Client22.BuildModeKind ~= "Objects" then
        return
    end

    local v1227 = {action = "Delete", object = a1}
    local v1228 = a0:Request(v1227)
    if v1228.ok and not a0.Destroyed and a0.Epoch == Epoch6 and a0:IsActive() then
        Client22:ClearBuildObjectHover()
        Client22:UpdateStorageCapacity()
    end

    return v1228
end

saveAndHide.Delete = Delete2

local function History3(a0, a1)
    if a1 == "Undo" or a1 == "Redo" then
        if not a0:IsActive() then
            return
        end

        if a0.Busy then
            return
        end

        if not a0:Blocked() then
            -- jump to 18
        end
    end

    return
    if a1 ~= "Undo" or a0.UndoCount > 0 then
        if a1 == "Redo" then
            if a0.RedoCount > 0 then
                -- jump to 33
            end

            -- branch continues at 33
        end
    end

    return
    local Client23 = a0.Client
    local Epoch7 = a0.Epoch
    local EditObject7 = Client23.EditObject
    local EditingExistingObject5 = Client23.EditingExistingObject
    local v1229 = {action = a1}
    local v1230 = a0:Request(v1229)
    if v1230.ok then
        if not a0.Destroyed then
            if a0.Epoch == Epoch7 then
                if a0:IsActive() then
                    if EditObject7 and Client23.EditObject == EditObject7 and Client23.EditingExistingObject == EditingExistingObject5 then
                        Client23:DeleteEditObject()
                    end

                    Client23:ClearBuildObjectHover()
                    Client23:UpdateStorageCapacity()
                end
            end
        end
    end

    return v1230
end

saveAndHide.History = History3

local function IsPointerOver1(a0, a1)
    local v1233 = a0:IsActive() and a0.UI:IsPointerOver(a1)
    return v1233
end

saveAndHide.IsPointerOver = IsPointerOver1

local function Destroy6(a0)
    if a0.Destroyed then
        return
    end

    a0.Destroyed = true
    a0.Epoch = a0.Epoch + 1
    for k257, k258 in ipairs(a0.Connections) do
        k258:Disconnect()
    end

    table.clear(a0.Connections)
    a0.UI:Destroy()
end

saveAndHide.Destroy = Destroy6
local DesktopUI = v3.DesktopUI

local function Start2(a0) --[[ Upvalues: saveAndHide (copy), DesktopUI (copy), UserInputService (copy), GuiService (copy) ]]
    local v1237 = {UndoCount = 0, RedoCount = 0, Epoch = 0, Client = a0, Connections = {}}
    local v1238 = setmetatable(v1237, saveAndHide)

    local function Undo1() --[[ Upvalues: v1238 (copy) ]]
        v1238:History("Undo")
    end

    local function Redo1() --[[ Upvalues: v1238 (copy) ]]
        v1238:History("Redo")
    end

    local v1239 = {Undo = Undo1, Redo = Redo1}
    v1238.UI = DesktopUI.new(a0, v1239)

    local function connect2(a0, a1) --[[ Upvalues: v1238 (copy) ]]
        local v1240 = a0:Connect(a1)
        table.insert(v1238.Connections, v1240)
    end

    local v1241 = UserInputService:GetPropertyChangedSignal("PreferredInput")
    local v1243 = v1241:Connect(function() --[[ Upvalues: v1238 (copy) ]]
        local v1242 = v1238
        v1242.Epoch = v1242.Epoch + 1
        task.defer(function() --[[ Upvalues: v1238 (upvalue) ]]
            v1238:Refresh()
        end)
    end)
    table.insert(v1238.Connections, v1243)
    local v1244 = UserInputService.TextBoxFocused:Connect(function() --[[ Upvalues: v1238 (copy) ]]
        v1238:Refresh()
    end)
    table.insert(v1238.Connections, v1244)
    local v1245 = UserInputService.TextBoxFocusReleased:Connect(function() --[[ Upvalues: v1238 (copy) ]]
        task.defer(function() --[[ Upvalues: v1238 (upvalue) ]]
            v1238:Refresh()
        end)
    end)
    table.insert(v1238.Connections, v1245)
    local v1246 = GuiService.MenuOpened:Connect(function() --[[ Upvalues: v1238 (copy) ]]
        v1238:Refresh()
    end)
    table.insert(v1238.Connections, v1246)
    local v1247 = GuiService.MenuClosed:Connect(function() --[[ Upvalues: v1238 (copy) ]]
        v1238:Refresh()
    end)
    table.insert(v1238.Connections, v1247)
    local v1248 = UserInputService.WindowFocusReleased:Connect(function() --[[ Upvalues: v1238 (copy) ]]
        v1238.WindowUnfocused = true
        v1238:Refresh()
    end)
    table.insert(v1238.Connections, v1248)
    local v1249 = UserInputService.WindowFocused:Connect(function() --[[ Upvalues: v1238 (copy) ]]
        v1238.WindowUnfocused = false
        v1238:Refresh()
    end)
    table.insert(v1238.Connections, v1249)
    local v1250 = a0.Player.CharacterRemoving:Connect(function() --[[ Upvalues: v1238 (copy) ]]
        v1238:Destroy()
    end)
    table.insert(v1238.Connections, v1250)
    v1238:Refresh()
    return v1238
end

saveAndHide.Start = Start2
v3.Desktop = saveAndHide
return v3
