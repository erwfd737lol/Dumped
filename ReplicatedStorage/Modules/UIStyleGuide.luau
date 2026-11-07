
local v1 = {
    "Inconsolata/Enum.Font.Code is the dominant typeface.",
    "Cool-white text, dark surfaces, and thin outlines form the core look.",
    "Trading and Build UI share the newer navy/blue-gray style.",
    "Older HUD panels use translucent black, square edges, white borders, and text strokes.",
    "Hotbar/backpack use charcoal slots, black outlines, and bright equipped-state strokes."
}
local v2 = {
    GuiObjectsReviewed = 756,
    TextObjectsReviewed = 518,
    Typography = {
        InconsolataRegular = 350,
        InconsolataFamilyTotal = 357,
        SourceSansLegacy = 149,
        GothamBold = 6
    }
    Observations = v1
}
v2 = {
    "Keep dark industrial surfaces quiet so gameplay and item viewports stay dominant.",
    "Use Inconsolata for body text, values, IDs, inputs, compact buttons, and inventory labels.",
    "Reserve GothamBold for prominent headings and short high-priority actions.",
    "Use cyan for focus, green for confirmation, red for danger, and yellow for warnings.",
    "Use one strong accent per component instead of coloring every edge.",
    "Use scale for major containers and offsets for heights, padding, strokes, and radii.",
    "Use Activated and mirror pointer hover with SelectionGained for console."
}
local v3 = {
    "StarterGui.TradingGui.ActiveTrade",
    "StarterGui.BuildModeGui.Toolbar",
    "StarterGui.BuildModeGui.TransformPanel"
}
v3 = {
    "StarterGui.HUD.Backpack",
    "StarterGui.HUD.Backpack.List.Template",
    "StarterGui.HUD.Hotbar.1",
    "StarterGui.HUD.BackpackTooltip"
}
v3 = {
    "StarterGui.HUD.ServerBrowser",
    "StarterGui.HUD.Menu",
    "StarterGui.HUD.Settings",
    "StarterGui.HUD.Bank",
    "StarterGui.HUD.BaseSlots"
}
v2 = {ModernIndustrial = v3, CompactHUD = v3, LegacyOverlay = v3}
v2 = {Body = Enum.Font.Code, Heading = Enum.Font.GothamBold, Legacy = Enum.Font.Code}
v2 = {
    Body = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular),
    BodyBold = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold)
}
v2 = {
    Background = Color3.fromRGB(18, 21, 29),
    BuildBackground = Color3.fromRGB(18, 22, 29),
    Panel = Color3.fromRGB(28, 33, 45),
    PanelRaised = Color3.fromRGB(37, 44, 59),
    Card = Color3.fromRGB(27, 33, 44),
    CardHover = Color3.fromRGB(34, 42, 55),
    Control = Color3.fromRGB(22, 27, 36),
    ListBackground = Color3.fromRGB(9, 12, 17),
    Stroke = Color3.fromRGB(86, 100, 130),
    StrokeStrong = Color3.fromRGB(120, 146, 181),
    Text = Color3.fromRGB(240, 244, 255),
    TextBright = Color3.fromRGB(244, 247, 255),
    Muted = Color3.fromRGB(162, 174, 197),
    Accent = Color3.fromRGB(77, 197, 255),
    AccentBlue = Color3.fromRGB(73, 169, 255),
    AccentDeep = Color3.fromRGB(35, 104, 136),
    Success = Color3.fromRGB(75, 215, 133),
    SuccessText = Color3.fromRGB(8, 28, 18),
    Danger = Color3.fromRGB(235, 79, 86),
    Warning = Color3.fromRGB(255, 211, 88),
    Disabled = Color3.fromRGB(78, 86, 101),
    DisabledCard = Color3.fromRGB(55, 55, 62)
}
local v4 = {
    Panel = Color3.fromRGB(40, 40, 40),
    Slot = Color3.fromRGB(40, 40, 40),
    Tooltip = Color3.fromRGB(20, 24, 32),
    Stroke = Color3.fromRGB(0, 0, 0),
    Text = Color3.fromRGB(240, 247, 255),
    Equipped = Color3.fromRGB(0, 170, 255),
    Held = Color3.fromRGB(255, 195, 55)
}
local v5 = {
    Panel = Color3.fromRGB(0, 0, 0),
    Stroke = Color3.fromRGB(255, 255, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextStroke = Color3.fromRGB(0, 0, 0),
    WarmBorder = Color3.fromRGB(200, 197, 176)
}
local v6 = {Modern = v2, CompactHUD = v4, Legacy = v5}
local v7 = {
    Tooltip = UDim.new(0, 5),
    Compact = UDim.new(0, 6),
    Control = UDim.new(0, 7),
    Card = UDim.new(0, 8),
    ToolPanel = UDim.new(0, 9),
    Panel = UDim.new(0, 10),
    Pill = UDim.new(0.5, 0)
}
v6 = {
    CornerRadius = v7,
    StrokeThickness = {Default = 1, ToolPanel = 1.5, Strong = 2, Selected = 3},
    Spacing = {Tiny = 4, Small = 6, Medium = 8, Large = 10, Panel = 12},
    ControlHeight = {Compact = 32, Default = 40, TouchMinimum = 44, Toolbar = 42},
    ScrollBarThickness = {Subtle = 2, Default = 5},
    TooltipPadding = {Horizontal = 10, Vertical = 7}
}
local v8 = {
    Size = 12,
    Font = (nil).Fonts.Body,
    FontFace = (nil).FontFaces.Body,
    Color = v2.Muted
}
v8 = {Size = 14, Font = (nil).Fonts.Body, FontFace = (nil).FontFaces.Body, Color = v2.Text}
v8 = {
    Size = 15,
    Font = (nil).Fonts.Body,
    FontFace = (nil).FontFaces.Body,
    Color = v2.TextBright
}
v8 = {Size = 16, Font = (nil).Fonts.Body, FontFace = (nil).FontFaces.Body, Color = v4.Text}
v8 = {Size = 17, Font = (nil).Fonts.Body, FontFace = (nil).FontFaces.Body, Color = v2.Text}
v8 = {Size = 22, Font = (nil).Fonts.Heading, Color = v2.TextBright}
v8 = {Size = 14, Font = (nil).Fonts.Body, FontFace = (nil).FontFaces.Body, Color = v2.Text}
v8 = {Size = 18, Font = (nil).Fonts.Body, FontFace = (nil).FontFaces.Body, Color = v2.Text}
v8 = {Size = 14, Font = (nil).Fonts.Heading, Color = v2.TextBright}
v8 = {Size = 14, Font = (nil).Fonts.Body, FontFace = (nil).FontFaces.Body, Color = v4.Text}
v6 = {
    Caption = v8,
    Body = v8,
    Input = v8,
    Tooltip = v8,
    Subtitle = v8,
    Title = v8,
    Button = v8,
    ModalButton = v8,
    ProminentButton = v8,
    Inventory = v8
}
local v9 = {
    Transparency = 0,
    StrokeThickness = 1,
    StrokeTransparency = 0.25,
    Color = v2.Background,
    CornerRadius = (nil).Metrics.CornerRadius.Panel,
    StrokeColor = v2.Stroke
}
v9 = {
    Transparency = 0.08,
    StrokeThickness = 1.5,
    StrokeTransparency = 0.15,
    Color = v2.BuildBackground,
    CornerRadius = (nil).Metrics.CornerRadius.ToolPanel,
    StrokeColor = v2.StrokeStrong
}
v9 = {
    Transparency = 0,
    StrokeThickness = 1,
    StrokeTransparency = 0.25,
    Color = v2.Card,
    CornerRadius = (nil).Metrics.CornerRadius.Card,
    StrokeColor = v2.Stroke
}
v9 = {
    Transparency = 0,
    StrokeThickness = 1,
    StrokeTransparency = 0.45,
    Color = v2.Control,
    CornerRadius = (nil).Metrics.CornerRadius.Control,
    StrokeColor = v2.Stroke
}
v9 = {
    Transparency = 0.25,
    StrokeTransparency = 1,
    Color = v2.ListBackground,
    CornerRadius = (nil).Metrics.CornerRadius.Card
}
local v10 = {Root = v9, ToolPanel = v9, Card = v9, Control = v9, List = v9}
v8 = {Surfaces = v10}
v9 = {
    Transparency = 0.2,
    StrokeThickness = 1,
    StrokeTransparency = 0,
    Color = v4.Panel,
    CornerRadius = UDim.new(0, 0),
    StrokeColor = v4.Stroke
}
v9 = {
    Transparency = 0.28,
    StrokeThickness = 1,
    StrokeTransparency = 0,
    Color = v4.Slot,
    CornerRadius = UDim.new(0, 0),
    StrokeColor = v4.Stroke,
    StrokeMode = Enum.ApplyStrokeMode.Border
}
v9 = {
    Transparency = 0.58,
    StrokeThickness = 1,
    StrokeTransparency = 0,
    Color = v4.Slot,
    CornerRadius = UDim.new(0, 0),
    StrokeColor = v4.Stroke,
    StrokeMode = Enum.ApplyStrokeMode.Border
}
v9 = {
    Transparency = 0.08,
    StrokeThickness = 1,
    StrokeTransparency = 0.2,
    Color = v4.Tooltip,
    CornerRadius = (nil).Metrics.CornerRadius.Tooltip,
    StrokeColor = v4.Equipped
}
v10 = {Panel = v9, Slot = v9, EmptySlot = v9, Tooltip = v9}
v8 = {Surfaces = v10}
v9 = {
    Transparency = 0.5,
    StrokeThickness = 1,
    StrokeTransparency = 0,
    Color = v5.Panel,
    CornerRadius = UDim.new(0, 0),
    StrokeColor = v5.Stroke
}
v10 = {Panel = v9}
v8 = {Surfaces = v10}
v6 = {ModernIndustrial = v8, CompactHUD = v8, LegacyOverlay = v8}
v8 = {StrokeThickness = 1, Background = v2.Card, Stroke = v2.Stroke}
v8 = {StrokeThickness = 1, Background = v2.CardHover, Stroke = v2.StrokeStrong}
v8 = {StrokeThickness = 2, Background = v2.CardHover, Stroke = v2.Accent}
v8 = {StrokeThickness = 2, Background = v2.AccentBlue, Stroke = v2.Accent}
v8 = {
    StrokeThickness = 3,
    StrokeTransparency = 0,
    Stroke = v4.Equipped,
    StrokeMode = Enum.ApplyStrokeMode.Border
}
v8 = {
    StrokeThickness = 3,
    StrokeTransparency = 0,
    Stroke = v4.Held,
    StrokeMode = Enum.ApplyStrokeMode.Border
}
v8 = {Background = v2.Success, Text = v2.SuccessText}
v8 = {Background = v2.Danger, Text = v2.TextBright}
v8 = {Background = v2.Warning, Text = v5.TextStroke}
v8 = {Background = v2.Disabled, Text = v2.Muted}
v8 = {Background = Color3.fromRGB(255, 91, 91)}
v8 = {Background = Color3.fromRGB(82, 218, 126)}
v6 = {
    Normal = v8,
    Hover = v8,
    Focused = v8,
    Selected = v8,
    Equipped = v8,
    Held = v8,
    Confirmed = v8,
    Destructive = v8,
    Warning = v8,
    Disabled = v8,
    InvalidPlacement = v8,
    ValidPlacement = v8
}
v6 = {
    HoverTweenTime = 0.12,
    PressTweenTime = 0.08,
    PanelTweenTime = 0.25,
    FadeTweenTime = 0.5,
    UseActivated = true,
    MirrorHoverWithSelection = true,
    ShowTooltipsOnHoverAndSelection = true,
    EasingStyle = Enum.EasingStyle.Quad,
    EasingDirection = Enum.EasingDirection.Out,
    ProgressEasingStyle = Enum.EasingStyle.Linear
}
local v11 = {
    "Use the shared Icon module for topbar actions.",
    "Use selected/deselected signals to mirror a toggle's open state.",
    "Prefer images for inventory/navigation icons and short labels only when the action needs text."
}
local v12 = {
    Backpack = {Name = "Backpack", Image = "rbxassetid://86890800998489", ImageOnly = true},
    Notes = v11
}
v12 = {
    "Use UISizeConstraint on major modal panels.",
    "Use UIAspectRatioConstraint for square slots, headshots, icons, and compact HUD controls.",
    "Use UITextSizeConstraint when TextScaled is required in a compact toolbar.",
    "Prefer fixed text sizes in modern modal panels; reserve TextScaled for constrained controls.",
    "Keep touch targets at least 44 pixels when space permits.",
    "Use UIListLayout or UIGridLayout plus UIPadding for repeated entries.",
    "Keep Studio-built templates authoritative for layout; apply tokens without resizing them."
}
v12 = {
    "Do not use SourceSans for new systems; it belongs to older/outlier screens.",
    "Do not round legacy black HUD panels unless the whole panel is intentionally modernized.",
    "Do not use bright accents as large decorative backgrounds.",
    "Do not rely on MouseButton1Click alone; use Activated for PC, mobile, and console.",
    "Do not communicate state with color alone; pair it with text, stroke weight, or an icon.",
    "Do not mutate these shared tables at runtime; copy values into a feature-local table."
}

local function ensureClass(a0, a1, a2)
    local v13 = a0:FindFirstChildOfClass(a1)
    if v13 then
        return v13
    end

    local v14 = Instance.new(a1)
    v14.Name = a2
    v14.Parent = a0
    return v14
end

local v15 = nil

local function ApplySurface(a0, a1, a2) --[[ Upvalues: v15 (copy) ]]
    local v18 = a0 and a0:IsA("GuiObject")
    assert(v18, "ApplySurface expects a GuiObject")
    local v20 = a2 or v15.DefaultProfile
    local v21 = v15.Profiles[v20]
    assert(v21, "Unknown UI style profile")
    local v22 = v21.Surfaces[a1]
    assert(v22, "Unknown surface for profile")
    a0.BackgroundColor3 = v22.Color
    a0.BackgroundTransparency = v22.Transparency
    a0.BorderSizePixel = 0
    local v23 = a0:FindFirstChildOfClass("UICorner")
    if v23 then
        v21 = v23
    else
        local UICorner = Instance.new("UICorner")
        UICorner.Name = "StyleCorner"
        UICorner.Parent = a0
        v21 = UICorner
    end

    v21.CornerRadius = v22.CornerRadius
    local v24 = a0:FindFirstChildOfClass("UIStroke")
    if v24 then
        v21 = v24
    else
        local UIStroke = Instance.new("UIStroke")
        UIStroke.Name = "StyleStroke"
        UIStroke.Parent = a0
        v21 = UIStroke
    end

    local v25 = v22.StrokeMode or Enum.ApplyStrokeMode.Contextual
    v21.ApplyStrokeMode = v25
    local v27 = v22.StrokeColor or Color3.new(0, 0, 0)
    v21.Color = v27
    v21.Thickness = v22.StrokeThickness or 1
    v21.Transparency = v22.StrokeTransparency or 1
    return a0
end

local function ApplyText(a0, a1) --[[ Upvalues: v15 (copy) ]]
    local v28 = a0
    if v28 then
        local v33 = a0:IsA("TextLabel") or a0:IsA("TextButton") or a0:IsA("TextBox")
    end

    assert(v28, "ApplyText expects a text GuiObject")
    local v34 = v15.TextRoles[a1 or "Body"]
    assert(v34, "Unknown text role")
    if v34.FontFace then
        a0.FontFace = v34.FontFace
    else
        a0.Font = v34.Font
    end

    a0.TextSize = v34.Size
    a0.TextColor3 = v34.Color
    a0.TextStrokeTransparency = 1
    return a0
end

local function ApplyButton(a0, a1, a2) --[[ Upvalues: v15 (copy), v2 (copy) ]]
    local v35 = a0
    if v35 then
        local v39 = a0:IsA("TextButton") or a0:IsA("ImageButton")
    end

    assert(v35, "ApplyButton expects a button")
    v15.ApplySurface(a0, "Control", "ModernIndustrial")
    a0.AutoButtonColor = true
    a0.Selectable = true
    a1 = a1 or "Secondary"
    if a1 == "Primary" then
        a0.BackgroundColor3 = v2.AccentDeep
    else
        if a1 == "Success" then
            a0.BackgroundColor3 = v2.Success
        else
            if a1 == "Danger" then
                a0.BackgroundColor3 = v2.Danger
            else
                if a1 == "Selected" then
                    a0.BackgroundColor3 = v2.AccentBlue
                end
            end
        end
    end

    if a0:IsA("TextButton") then
        local v40 = a2
        if not v40 then
            if a1 == "Primary" then
                v40 = "ProminentButton"
            else
                v40 = "Button"
            end
        end

        v15.ApplyText(a0, v40)
        if a1 == "Success" then
            a0.TextColor3 = v2.SuccessText
        end
    end

    return a0
end

local function ApplyState(a0, a1) --[[ Upvalues: v15 (copy) ]]
    local v43 = a0 and a0:IsA("GuiObject")
    assert(v43, "ApplyState expects a GuiObject")
    local v44 = v15.States[a1]
    assert(v44, "Unknown UI state")
    if v44.Background then
        a0.BackgroundColor3 = v44.Background
    end

    if v44.Text then
        if a0:IsA("TextLabel") or a0:IsA("TextButton") or a0:IsA("TextBox") then
            a0.TextColor3 = v44.Text
        end
    end

    if v44.Stroke or v44.StrokeThickness or v44.StrokeTransparency or v44.StrokeMode then
        local v45 = a0:FindFirstChildOfClass("UIStroke")
        local v46
        if v45 then
            v46 = v45
        else
            local UIStroke1 = Instance.new("UIStroke")
            UIStroke1.Name = "StyleStroke"
            UIStroke1.Parent = a0
            v46 = UIStroke1
        end

        local v47 = v44.StrokeMode or v46.ApplyStrokeMode
        v46.ApplyStrokeMode = v47
        local v48 = v44.Stroke or v46.Color
        v46.Color = v48
        local v49 = v44.StrokeThickness or v46.Thickness
        v46.Thickness = v49
        if v44.StrokeTransparency ~= nil then
            v46.Transparency = v44.StrokeTransparency
        end
    end

    return a0
end

local function GetHoverTweenInfo() --[[ Upvalues: v15 (copy) ]]
    local v50 = TweenInfo.new(v15.Interaction.HoverTweenTime, v15.Interaction.EasingStyle, v15.Interaction.EasingDirection)
    return v50
end

v15 = {
    Version = 1,
    AuditDate = "2026-08-25",
    DefaultProfile = "ModernIndustrial",
    AuditSnapshot = v2,
    Principles = v2,
    ReferencePaths = v2,
    Fonts = v2,
    FontFaces = v2,
    Colors = v6,
    Metrics = v6,
    TextRoles = v6,
    Profiles = v6,
    States = v6,
    Interaction = v6,
    NotificationDuration = {Lightweight = 2, Standard = 3, Important = 4},
    IconPatterns = v12,
    ResponsiveRules = v12,
    DoNot = v12,
    ApplySurface = ApplySurface,
    ApplyText = ApplyText,
    ApplyButton = ApplyButton,
    ApplyState = ApplyState,
    GetHoverTweenInfo = GetHoverTweenInfo
}
return v15
