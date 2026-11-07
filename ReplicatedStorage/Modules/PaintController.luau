-- https://lua.expert

local t1 = {}

game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local GamepadService = game:GetService("GamepadService")
local ColorPicker = require(ReplicatedStorage.Modules.ColorPicker)
local RemoteEvent = ReplicatedStorage.Remotes.RemoteEvent
local t2 = {
    PaintBrush = true,
    PaintBucket = true,
    ColorDropper = true
}
local t3 = {
    GridPart = true,
    BoundingBox = true,
    RootPart = true,
    HumanoidRootPart = true,
    Barrier = true
}

local function isVisualPart(p1) -- line: 27
    -- upvalues: t3 (copy)
    return p1:IsA("BasePart") and p1.Transparency < 0.98 and not t3[p1.Name] and p1:GetAttribute("PaintProtected") ~= true and p1:GetAttribute("Paintable") ~= false
end

local function quantize(p2) -- line: 35
    return Color3.fromRGB(math.clamp(math.round(p2.R * 255), 0, 255), math.clamp(math.round(p2.G * 255), 0, 255), (math.clamp(math.round(p2.B * 255), 0, 255)))
end

local function getCurrentColor(p3) -- line: 43
    return p3.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3
end

local function setCurrentColor(p4, p5) -- line: 47
    local v17 = Color3.fromRGB(math.clamp(math.round(p5.R * 255), 0, 255), math.clamp(math.round(p5.G * 255), 0, 255), (math.clamp(math.round(p5.B * 255), 0, 255)))

    p4.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3 = v17

    if p4.ColorPickerHUD then
        p4.ColorPickerHUD:SetColor(v17)
    end

    return v17
end

local function disconnectAll(p6) -- line: 54
    for _, v18 in ipairs(p6.PaintConnections or {}) do
        v18:Disconnect()
    end

    p6.PaintConnections = nil
end

local function restoreQuery(p7) -- line: 59
    for v19, v20 in pairs(p7.PaintQueryOriginal or {}) do
        if v19 and v19.Parent then
            v19.CanQuery = v20
        end
    end

    p7.PaintQueryOriginal = nil
    p7.PaintParts = nil
    p7.PaintRaycastParams = nil
end

local function getObjectRoot(p8, p9) -- line: 68
    local StorageBase = p8.StorageBase and p8.StorageBase:FindFirstChild("Contents") and p8.StorageBase.Contents:FindFirstChild("Objects")

    if StorageBase and p9:IsDescendantOf(StorageBase) then
        local v21 = p9
        local n1 = 0

        while v21 and v21.Parent ~= StorageBase and n1 < 20 do
            v21 = v21.Parent
            n1 += 1
        end

        if v21 and v21.Parent == StorageBase and v21:IsA("Model") then
            return v21
        end
    end

    return nil
end

local function getObjectCohort(p10, p11) -- line: 80
    local n2 = 0

    while p11 and p11.Parent ~= p10 and n2 < 20 do
        p11 = p11.Parent
        n2 += 1
    end

    return if p11 and p11.Parent == p10 and typeof(p11:GetAttribute("PaintId")) == "string" then p11 else nil
end

local function rebuildTargets(p12) -- line: 90
    -- upvalues: t3 (copy), restoreQuery (copy), getObjectRoot (copy)
    restoreQuery(p12)

    if p12.StorageBase then
        local t4 = {}
        local t5 = {}
        local v23 = p12.StorageBase:FindFirstChild("Contents") and p12.StorageBase.Contents:FindFirstChild("Objects")

        for _, descendant in ipairs(p12.StorageBase:GetDescendants()) do
            local BasePart = descendant:IsA("BasePart") and descendant.Transparency < 0.98 and not t3[descendant.Name] and descendant:GetAttribute("PaintProtected") ~= true and descendant:GetAttribute("Paintable") ~= false

            if BasePart and (descendant:GetAttribute("PaintGroup") ~= nil or v23 and descendant:IsDescendantOf(v23) and getObjectRoot(p12, descendant) ~= nil) then
                t4[#t4 + 1] = descendant
                t5[descendant] = descendant.CanQuery
                descendant.CanQuery = true
            end
        end

        local v24 = RaycastParams.new()

        v24.FilterType = Enum.RaycastFilterType.Include
        v24.FilterDescendantsInstances = t4
        v24.IgnoreWater = true
        p12.PaintParts = t4
        p12.PaintQueryOriginal = t5
        p12.PaintRaycastParams = v24
    end
end

local function usingClassicController(p13) -- line: 117
    return p13.ClassicController and p13.ClassicController:IsGamepad()
end

local function usingModernController(p14) -- line: 121
    return p14.ModernController and p14.ModernController:IsGamepad()
end

local function usingClassicMobile(p15) -- line: 125
    return p15.ClassicMobile and p15.ClassicMobile:IsActive()
end

local function usingModernMobile(p16) -- line: 129
    return p16.ModernMobile and p16.ModernMobile:IsActive()
end

local function usingBuildController(p17) -- line: 133
    return p17.ClassicController and p17.ClassicController:IsGamepad() or p17.ModernController and p17.ModernController:IsGamepad() or p17.ClassicMobile and p17.ClassicMobile:IsActive() or p17.ModernMobile and p17.ModernMobile:IsActive()
end

local function raycastTarget(p18, p19) -- line: 137
    local CurrentCamera = workspace.CurrentCamera

    if not (CurrentCamera and p18.PaintRaycastParams) then
        return nil
    end

    if p18.ClassicMobile and p18.ClassicMobile:IsActive() then
        local _, Aim = p18.ClassicMobile:GetAim()

        return if Aim and table.find(p18.PaintParts or {}, Aim) then Aim else nil
    end

    local v25

    if p18.ModernMobile and p18.ModernMobile:IsActive() then
        if not p19 then
            return nil
        end

        v25 = CurrentCamera:ViewportPointToRay(p19.X, p19.Y)
    elseif p18.ClassicController and p18.ClassicController:IsGamepad() or p18.ModernController and p18.ModernController:IsGamepad() or p18.ClassicMobile and p18.ClassicMobile:IsActive() or p18.ModernMobile and p18.ModernMobile:IsActive() then
        local v26 = CurrentCamera.ViewportSize / 2

        v25 = CurrentCamera:ViewportPointToRay(v26.X, v26.Y)
    else
        v25 = CurrentCamera:ScreenPointToRay(p19.X, p19.Y)
    end

    local v27 = workspace:Raycast(v25.Origin, v25.Direction * 1000, p18.PaintRaycastParams)

    return v27 and v27.Instance or nil
end

local function resolveSelection(p20, p21, p22) -- line: 158
    -- upvalues: t3 (copy), getObjectRoot (copy), getObjectCohort (copy)
    if not p21 then
        return nil
    end

    local BasePart = p21:IsA("BasePart") and p21.Transparency < 0.98 and not t3[p21.Name] and p21:GetAttribute("PaintProtected") ~= true and p21:GetAttribute("Paintable") ~= false

    if BasePart then
        if p22 == "ColorDropper" then
            return p21
        end

        local v28 = getObjectRoot(p20, p21)

        if v28 then
            if p22 == "PaintBucket" then
                return v28
            end

            return (getObjectCohort(v28, p21))
        end

        local PaintGroup = p21:GetAttribute("PaintGroup")

        if not PaintGroup then
            return nil
        end

        if p22 ~= "PaintBucket" then
            return p21
        end

        local t6 = {}

        for _, v29 in ipairs(p20.PaintParts or {}) do
            if v29:GetAttribute("PaintGroup") == PaintGroup then
                t6[#t6 + 1] = v29
            end
        end

        if not (#t6 > 0) or not t6 then
            t6 = nil
        end

        return t6
    end

    return nil
end

local function pointerBlocked(p23, p24) -- line: 180
    if p23.ModernMobile and p23.ModernMobile:IsActive() then
        return p23.ModernMobile:BlocksWorld()
    end

    if p23.ClassicMobile and p23.ClassicMobile:IsActive() then
        return p23.ClassicMobile:BlocksWorld()
    end

    if p23.ClassicController and p23.ClassicController:BlocksWorld() or p23.ModernController and p23.ModernController:BlocksWorld() or p23.ClassicDesktop and p23.ClassicDesktop:IsPointerOver() then
        return true
    end

    local v30 = p23.Player and p23.Player:FindFirstChildOfClass("PlayerGui")

    if v30 then
        local GetGuiObjectsAtPosition = v30.GetGuiObjectsAtPosition
        local v31 = math.floor(p24.X)
        local v32 = math.floor(p24.Y)
        local ok, result = pcall(GetGuiObjectsAtPosition, v30, v31, v32)

        if ok then
            local v33 = p23.ColorPickerHUD and p23.ColorPickerHUD.Instance

            for _, v34 in ipairs(result) do
                local v35 = v34

                while v35 and v35 ~= v30 do
                    if v35 == v33 or v35 == p23.HUD.PaintEditBar or v35:IsA("GuiButton") and v35.Visible or v35:IsA("ScrollingFrame") and v35.Visible then
                        return true
                    end

                    v35 = v35.Parent
                end
            end
        end
    end

    return false
end

local function pointerPosition(p25) -- line: 203
    -- upvalues: UserInputService (copy), GuiService (copy)
    local CurrentCamera = workspace.CurrentCamera
    local LastInputType = UserInputService:GetLastInputType()
    local v36 = p25.ClassicController and p25.ClassicController:IsGamepad() or p25.ModernController and p25.ModernController:IsGamepad() or p25.ClassicMobile and p25.ClassicMobile:IsActive() or p25.ModernMobile and p25.ModernMobile:IsActive() or string.match(LastInputType.Name, "^Gamepad") ~= nil

    if (p25.ClassicController and p25.ClassicController:IsGamepad() or p25.ModernController and p25.ModernController:IsGamepad() or p25.ClassicMobile and p25.ClassicMobile:IsActive() or p25.ModernMobile and p25.ModernMobile:IsActive()) and CurrentCamera then
        return CurrentCamera.ViewportSize / 2
    end

    if v36 and not p25.BuildGamepadNavigation and CurrentCamera then
        local GuiInset, GuiInset2 = GuiService:GetGuiInset()
        local v37 = CurrentCamera.ViewportSize - GuiInset - GuiInset2

        return Vector2.new(math.max(0, v37.X) / 2, math.max(0, v37.Y) / 2)
    end

    local Mouse = p25.Mouse

    if Mouse then
        return Vector2.new(Mouse.X, Mouse.Y)
    end

    local GuiInset = GuiService:GetGuiInset()

    return UserInputService:GetMouseLocation() - GuiInset
end

local function clearHighlights(p26) -- line: 227
    for _, v39 in ipairs(p26.PaintHighlights or {}) do
        v39:Destroy()
    end

    p26.PaintHighlights = nil
    p26.PaintHoverHit = nil
    p26.PaintHoverMode = nil
end

local function addHighlight(p27, p28, p29) -- line: 236
    if p28 and p28.Parent then
        local Highlight = Instance.new("Highlight")

        Highlight.Name = "PaintTargetHighlight"
        Highlight.Adornee = p28
        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        Highlight.FillColor = p29
        Highlight.FillTransparency = 0.78
        Highlight.OutlineColor = Color3.new(1, 1, 1)
        Highlight.OutlineTransparency = 0.08
        Highlight.Parent = workspace.CurrentCamera
        p27.PaintHighlights = p27.PaintHighlights or {}
        table.insert(p27.PaintHighlights, Highlight)
    end
end

local function highlightSelection(p30, p31, p32) -- line: 251
    -- upvalues: t3 (copy), clearHighlights (copy), addHighlight (copy)
    if p30.PaintHoverHit == p32 and p30.PaintHoverMode == p30.PaintMode then
        return
    end

    clearHighlights(p30)

    if p31 then
        p30.PaintHoverHit = p32
        p30.PaintHoverMode = p30.PaintMode

        local v40 = p30.PaintMode == "ColorDropper" and Color3.fromRGB(0, 190, 255) or p30.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3

        if typeof(p31) == "table" then
            for _, v41 in ipairs(p31) do
                addHighlight(p30, v41, v40)
            end
        elseif p31:IsA("Folder") then
            for _, descendant in ipairs(p31:GetDescendants()) do
                local BasePart = descendant:IsA("BasePart") and descendant.Transparency < 0.98 and not t3[descendant.Name] and descendant:GetAttribute("PaintProtected") ~= true and descendant:GetAttribute("Paintable") ~= false

                if BasePart then
                    addHighlight(p30, descendant, v40)
                end
            end
        else
            addHighlight(p30, p31, v40)
        end
    end
end

local function applyColorToInstance(p33, p34) -- line: 270
    -- upvalues: t3 (copy)
    if not p33:IsA("BasePart") then
        return
    end

    local BasePart = p33:IsA("BasePart") and p33.Transparency < 0.98 and not t3[p33.Name] and p33:GetAttribute("PaintProtected") ~= true and p33:GetAttribute("Paintable") ~= false

    if not BasePart then
        return
    end

    p33.Color = p34

    local SurfaceAppearance = p33:FindFirstChildWhichIsA("SurfaceAppearance")

    if SurfaceAppearance then
        SurfaceAppearance.Color = p34
    end
end

local function previewSelection(p35, p36) -- line: 278
    -- upvalues: t3 (copy)
    if typeof(p35) == "table" then
        for _, v42 in ipairs(p35) do
            if v42:IsA("BasePart") then
                local BasePart = v42:IsA("BasePart") and v42.Transparency < 0.98 and not t3[v42.Name] and v42:GetAttribute("PaintProtected") ~= true and v42:GetAttribute("Paintable") ~= false

                if BasePart then
                    v42.Color = p36

                    local SurfaceAppearance = v42:FindFirstChildWhichIsA("SurfaceAppearance")

                    if SurfaceAppearance then
                        SurfaceAppearance.Color = p36
                    end
                end
            end
        end
    elseif p35:IsA("BasePart") then
        if p35:IsA("BasePart") then
            local BasePart = p35:IsA("BasePart") and p35.Transparency < 0.98 and not t3[p35.Name] and p35:GetAttribute("PaintProtected") ~= true and p35:GetAttribute("Paintable") ~= false

            if BasePart then
                p35.Color = p36

                local SurfaceAppearance = p35:FindFirstChildWhichIsA("SurfaceAppearance")

                if SurfaceAppearance then
                    SurfaceAppearance.Color = p36
                end
            end
        end
    else
        for _, descendant in ipairs(p35:GetDescendants()) do
            if descendant:IsA("BasePart") then
                local BasePart = descendant:IsA("BasePart") and descendant.Transparency < 0.98 and not t3[descendant.Name] and descendant:GetAttribute("PaintProtected") ~= true and descendant:GetAttribute("Paintable") ~= false

                if BasePart then
                    descendant.Color = p36

                    local SurfaceAppearance = descendant:FindFirstChildWhichIsA("SurfaceAppearance")

                    if SurfaceAppearance then
                        SurfaceAppearance.Color = p36
                    end
                end
            end
        end
    end
end

local function updateHover(p37, p38) -- line: 290
    -- upvalues: raycastTarget (copy), resolveSelection (copy), pointerBlocked (copy), clearHighlights (copy), highlightSelection (copy)
    if not p37.Painting or pointerBlocked(p37, p38) then
        clearHighlights(p37)

        return nil
    end

    local v43 = raycastTarget(p37, p38)
    local v44 = resolveSelection(p37, v43, p37.PaintMode)

    highlightSelection(p37, v44, v43)

    return v43, v44
end

local function updateButtons(p39) -- line: 301
    local PaintEditBar = p39.HUD.PaintEditBar

    for _, v45 in ipairs({ "PaintBrush", "PaintBucket", "ColorDropper" }) do
        local v46 = PaintEditBar:FindFirstChild(v45)
        local UIStroke = v46 and v46:FindFirstChildWhichIsA("UIStroke")

        if UIStroke then
            local v47 = p39.PaintMode == v45

            UIStroke.Color = Color3.new(1, 1, 1)
            UIStroke.Thickness = v47 and 3 or 1
        end
    end

    local ColorPicker = PaintEditBar:FindFirstChild("ColorPicker")
    local UIStroke = ColorPicker and ColorPicker:FindFirstChildWhichIsA("UIStroke")

    if not UIStroke then
        return
    end

    UIStroke.Color = Color3.new(1, 1, 1)
    UIStroke.Thickness = p39.ColorPickerHUD and 3 or 1
end

function t1.SetMode(p40, p41) -- line: 320
    -- upvalues: t1 (copy), t2 (copy), clearHighlights (copy), updateButtons (copy)
    if not (t2[p41] and p40.Painting) then
        return
    end

    if p41 == "ColorDropper" and p40.PaintMode ~= "ColorDropper" then
        p40.PaintReturnMode = t2[p40.PaintMode] and p40.PaintMode or "PaintBrush"
    end

    p40.PaintMode = p41
    clearHighlights(p40)
    updateButtons(p40)

    if p40.ModernMobile and p40.ModernMobile:IsActive() and t1.MobileRefresh then
        t1.MobileRefresh(p40)
    end
end

local function applyAt(p42, p43) -- line: 331
    -- upvalues: t1 (copy), RemoteEvent (copy), pointerBlocked (copy), clearHighlights (copy), updateHover (copy)
    if p42.ModernMobile and p42.ModernMobile:IsActive() then
        return t1.MobileApply(p42)
    end

    if p42.Painting and not p42.PaintResetConfirmOpen and not pointerBlocked(p42, p43) then
        local v48, v49 = updateHover(p42, p43)

        if v48 and v49 then
            if p42.PaintMode == "ColorDropper" then
                local Color = v48.Color
                local v58 = Color3.fromRGB(math.clamp(math.round(Color.R * 255), 0, 255), math.clamp(math.round(Color.G * 255), 0, 255), (math.clamp(math.round(Color.B * 255), 0, 255)))

                p42.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3 = v58

                if p42.ColorPickerHUD then
                    p42.ColorPickerHUD:SetColor(v58)
                end

                local v59 = p42.PaintReturnMode or "PaintBrush"

                p42.PaintReturnMode = nil
                t1.SetMode(p42, v59)
                updateHover(p42, p43)
            elseif not (time() - (p42.PaintLastCommit or 0) < 0.08) then
                p42.PaintLastCommit = time()

                local BackgroundColor3 = p42.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3
                local v68 = Color3.fromRGB(math.clamp(math.round(BackgroundColor3.R * 255), 0, 255), math.clamp(math.round(BackgroundColor3.G * 255), 0, 255), (math.clamp(math.round(BackgroundColor3.B * 255), 0, 255)))
                local ClassicController, ModernController, ClassicMobile = p42.ClassicController, p42.ModernController, p42.ClassicMobile
                local v69 = p42.ClassicDesktop or p42.ModernDesktop

                if ClassicController and ClassicController:IsGamepad() then
                    local ActivationEpoch = ClassicController.ActivationEpoch

                    if not ClassicController:Request({
                        action = "Paint",
                        target = v48,
                        paintMode = p42.PaintMode,
                        color = v68
                    }).ok or not ClassicController:IsGamepad() or ClassicController.ActivationEpoch ~= ActivationEpoch or not p42.Painting then
                        return
                    end
                elseif ModernController and ModernController:IsGamepad() then
                    local ActivationEpoch = ModernController.ActivationEpoch

                    if not ModernController:Request({
                        action = "Paint",
                        target = v48,
                        paintMode = p42.PaintMode,
                        color = v68
                    }).ok or not ModernController:IsGamepad() or ModernController.ActivationEpoch ~= ActivationEpoch or not p42.Painting then
                        return
                    end
                elseif ClassicMobile and ClassicMobile:IsActive() then
                    local Epoch = ClassicMobile.Epoch
                    local v70 = ClassicMobile:Request({
                        action = "Paint",
                        target = v48,
                        paintMode = p42.PaintMode,
                        color = v68
                    })

                    if not v70.ok
                        or v70.stale
                        or p42.ClassicMobile ~= ClassicMobile
                        or not ClassicMobile:IsActive()
                        or ClassicMobile.Epoch ~= Epoch
                        or not p42.Painting then
                        return
                    end
                elseif not (v69 and v69:IsActive()) then
                    RemoteEvent:FireServer("PaintBaseObject", {
                        Target = v48,
                        Mode = p42.PaintMode,
                        Color = v68
                    })
                else
                    if v69:Blocked() then
                        return
                    end

                    local Epoch = v69.Epoch

                    if not v69:Request({
                        action = "Paint",
                        target = v48,
                        paintMode = p42.PaintMode,
                        color = v68
                    }).ok or not v69:IsActive() or v69.Epoch ~= Epoch or not p42.Painting then
                        return
                    end
                end

                clearHighlights(p42)
                updateHover(p42, p43)
            end
        end
    end
end

local function disconnectPickerLayout(p44) -- line: 384
    for _, v71 in pairs(p44.PaintPickerLayoutConnections or {}) do
        v71:Disconnect()
    end

    p44.PaintPickerLayoutConnections = nil
end

local function layoutControllerPicker(p45, p46) -- line: 389
    -- upvalues: GuiService (copy), disconnectPickerLayout (copy)
    disconnectPickerLayout(p45)

    local t7 = {}

    p45.PaintPickerLayoutConnections = t7

    local HUD = (p45.ClassicController and p45.ClassicController:IsGamepad() and p45.ClassicController or p45.ModernController).UI.HUD
    local UIScale = p46.Instance:FindFirstChildWhichIsA("UIScale")

    local function refresh() -- line: 396
        -- upvalues: p45 (copy), p46 (copy), HUD (copy), UIScale (copy), GuiService (copy)
        if p45.ColorPickerHUD ~= p46 or not p46.Instance then
            return
        end

        local CurrentCamera = workspace.CurrentCamera
        local ViewportSize = CurrentCamera and CurrentCamera.ViewportSize or Vector2.new(1280, 720)
        local GuiInset, GuiInset2 = GuiService:GetGuiInset()
        local v75 = Vector2.new(math.max(1, ViewportSize.X - GuiInset.X - GuiInset2.X), (math.max(1, ViewportSize.Y - GuiInset.Y - GuiInset2.Y)))
        local v78 = math.min(ViewportSize.X * 0.92 / 1080, ViewportSize.Y / 620, 1.5)
        local v79 = if p45.ClassicController and p45.ClassicController:IsGamepad() then 158 else 182
        local v80 = ViewportSize.Y * 0.96 - v79 * v78 - GuiInset.Y

        if HUD and HUD.Parent and HUD.AbsoluteSize.Y > 0 and HUD.AbsolutePosition.Y > 0 then
            v80 = HUD.AbsolutePosition.Y
        end

        local v83 = math.min(v75.Y - 12, v80 - 16)
        local v85 = math.max(1, v75.X - 24)
        local v87 = math.max(1, v83 - 12)
        local v92 = math.min(math.clamp(1.5 + (ViewportSize.Y - 720) / 1200, 1.25, 1.8), v85 / 238, v87 / 282)

        UIScale.Scale = v92
        p46.Instance.AnchorPoint = Vector2.zero
        p46.Instance.Position = UDim2.fromOffset(math.floor((v75.X - v92 * 238) / 2 + 0.5), (math.floor((v87 - v92 * 282) / 2 + 12 + 0.5)))
    end

    local function watchCamera() -- line: 426
        -- upvalues: t7 (copy), refresh (copy)
        if t7.Viewport then
            t7.Viewport:Disconnect()
            t7.Viewport = nil
        end

        local CurrentCamera = workspace.CurrentCamera

        if CurrentCamera then
            t7.Viewport = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refresh)
        end

        refresh()
    end

    t7.Camera = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchCamera)
    t7.Insets = p46.UI:GetPropertyChangedSignal("AbsoluteSize"):Connect(refresh)

    if HUD then
        t7.HUDPosition = HUD:GetPropertyChangedSignal("AbsolutePosition"):Connect(refresh)
        t7.HUDSize = HUD:GetPropertyChangedSignal("AbsoluteSize"):Connect(refresh)
    end

    if t7.Viewport then
        t7.Viewport:Disconnect()
        t7.Viewport = nil
    end

    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera then
        t7.Viewport = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refresh)
    end

    refresh()
end

local function closePicker(p47) -- line: 441
    -- upvalues: UserInputService (copy), clearHighlights (copy), updateButtons (copy), disconnectPickerLayout (copy)
    disconnectPickerLayout(p47)

    local ColorPickerHUD, PaintPickerPreviousGamepadNavigation = p47.ColorPickerHUD, p47.PaintPickerPreviousGamepadNavigation

    p47.PaintPickerPreviousGamepadNavigation = nil

    if ColorPickerHUD then
        p47.ColorPickerHUD = nil
        ColorPickerHUD:Destroy()
    end

    if p47.ClassicController and p47.ClassicController:IsGamepad() or p47.ModernController and p47.ModernController:IsGamepad() or p47.ClassicMobile and p47.ClassicMobile:IsActive() or p47.ModernMobile and p47.ModernMobile:IsActive() then
        p47:SetBuildGamepadNavigation(false)
    elseif PaintPickerPreviousGamepadNavigation ~= nil and p47.BuildCameraActive and UserInputService.GamepadEnabled then
        p47:SetBuildGamepadNavigation(PaintPickerPreviousGamepadNavigation)
    end

    if p47.Painting and not (p47.ClassicController and p47.ClassicController:IsGamepad()) and not (p47.ModernController and p47.ModernController:IsGamepad()) then
        p47.HUD.PaintEditBar.Visible = true
    end

    clearHighlights(p47)
    updateButtons(p47)

    if p47.ClassicController then
        p47.ClassicController:SyncOwnership()
        p47.ClassicController:RefreshPresentation()
    end

    if p47.ModernController then
        p47.ModernController:SyncOwnership()
        p47.ModernController:RefreshPresentation()
    end

    if p47.ClassicMobile then
        p47.ClassicMobile:RefreshPresentation()
    end

    if p47.ModernMobile then
        p47.ModernMobile:RefreshPresentation()
    end

    if p47.ClassicDesktop then
        p47.ClassicDesktop:Refresh()
    end
end

function t1.ClosePicker(p48) -- line: 474
    -- upvalues: closePicker (copy)
    closePicker(p48)
end

local function setResetConfirmation(p49, p50) -- line: 478
    -- upvalues: UserInputService (copy), GuiService (copy), clearHighlights (copy), closePicker (copy)
    local v96 = p49.BuildGui and p49.BuildGui:FindFirstChild("PaintResetConfirm")

    if not v96 then
        return false
    end

    if p50 == true and p49.Painting == true then
        if p49.PaintResetConfirmOpen then
            return true
        end

        if p49.ColorPickerHUD then
            closePicker(p49)
        end

        p49.PaintResetPreviousSelection = GuiService.SelectedObject
        p49.PaintResetConfirmOpen = true
        v96.Visible = true
        clearHighlights(p49)

        local v97 = v96:FindFirstChild("Cancel", true)

        if UserInputService.GamepadEnabled and v97 and v97:IsA("GuiButton") then
            GuiService.SelectedObject = v97
        end
    else
        local v98 = p49.PaintResetConfirmOpen == true
        local PaintResetPreviousSelection = p49.PaintResetPreviousSelection

        p49.PaintResetConfirmOpen = nil
        p49.PaintResetPreviousSelection = nil
        v96.Visible = false

        local GuiService2, PaintResetPreviousSelection2

        if v98 then
            local SelectedObject = GuiService.SelectedObject

            if SelectedObject and SelectedObject:IsDescendantOf(v96) then
                GuiService2 = GuiService

                if PaintResetPreviousSelection and PaintResetPreviousSelection.Parent then
                    PaintResetPreviousSelection2 = PaintResetPreviousSelection
                end

                GuiService2.SelectedObject = PaintResetPreviousSelection2
            end
        end
    end

    if p49.ClassicDesktop then
        p49.ClassicDesktop:Refresh()
    end

    if p49.ModernDesktop then
        p49.ModernDesktop:Refresh()
    end

    return true
end

function t1.ShowResetConfirmation(p51) -- line: 512
    -- upvalues: setResetConfirmation (copy)
    return (setResetConfirmation(p51, true))
end

function t1.HideResetConfirmation(p52) -- line: 516
    -- upvalues: setResetConfirmation (copy)
    return (setResetConfirmation(p52, false))
end

local function styleBuildPaintPicker(p53, p54) -- line: 520
    local function panel(p55) -- line: 522
        p55.BackgroundColor3 = Color3.new(0, 0, 0)
        p55.BackgroundTransparency = 0.5
        p55.BorderColor3 = Color3.new(1, 1, 1)
        p55.BorderSizePixel = 2
        p55.BorderMode = Enum.BorderMode.Inset

        for _, child in ipairs(p55:GetChildren()) do
            if child:IsA("UICorner") or child:IsA("UIStroke") then
                child:Destroy()
            end
        end
    end

    panel(p53.Instance)
    panel(p53.Instance.Topbar)
    panel(p53.Instance.Middle.Right)
    panel(p54)

    for _, v99 in pairs(p53.Sliders) do
        panel(v99.Instance)
    end

    for _, descendant in ipairs(p53.Instance:GetDescendants()) do
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
            descendant.Font = Enum.Font.Code
            descendant.TextColor3 = Color3.new(1, 1, 1)
        end
    end
end

function t1.TogglePicker(p56) -- line: 546
    -- upvalues: UserInputService (copy), GuiService (copy), GamepadService (copy), ColorPicker (copy), clearHighlights (copy), updateButtons (copy), layoutControllerPicker (copy), closePicker (copy), styleBuildPaintPicker (copy)
    if p56.Painting then
        if p56.ColorPickerHUD then
            closePicker(p56)
        else
            clearHighlights(p56)

            local v100 = ColorPicker.new({
                RealTimeEventCalling = true,
                Position = UDim2.fromOffset(0, 0),
                PickerMode = ColorPicker.PICKER_MODE.CIRCLE,
                ColorSpace = ColorPicker.COLOR_SPACE.HSV
            })

            for v101, v102 in pairs(v100.Sliders) do
                v102:SetVisible(v101 == "Value")
            end

            v100.Instance.Options.Visible = false
            v100.Instance.Topbar.Info.Visible = false
            v100.Instance.Middle.Hex.Visible = false
            v100.Instance.Middle.Right.ColorSpace.Visible = false
            v100.Instance.Middle.Right.Position = UDim2.fromScale(0, 0)
            v100.Instance.Middle.Right.AnchorPoint = Vector2.zero
            v100.Instance.Middle.Right.Size = UDim2.fromScale(1, 1)
            v100.Instance.Middle.Right.Color.Size = UDim2.new(1, -8, 1, -8)
            v100.Instance.Size = UDim2.fromOffset(238, 282)

            local TextButton = Instance.new("TextButton")

            TextButton.Name = "PaintDone"
            TextButton.AnchorPoint = Vector2.new(1, 0)
            TextButton.Position = UDim2.new(1, -4, 0, 4)
            TextButton.Size = UDim2.fromOffset(44, 44)
            TextButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
            TextButton.BackgroundTransparency = 0.08
            TextButton.BorderSizePixel = 0
            TextButton.Text = "X"
            TextButton.TextColor3 = Color3.new(1, 1, 1)
            TextButton.TextScaled = true
            TextButton.Font = Enum.Font.Code
            TextButton.ZIndex = 20
            TextButton.Selectable = true
            TextButton.Parent = v100.Instance

            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0, 7)
            UICorner.Parent = TextButton
            styleBuildPaintPicker(v100, TextButton)

            local CurrentCamera = workspace.CurrentCamera
            local ViewportSize = CurrentCamera and CurrentCamera.ViewportSize or Vector2.new(1280, 720)
            local GuiInset, GuiInset2 = GuiService:GetGuiInset()
            local v106 = Vector2.new(math.max(1, ViewportSize.X - GuiInset.X - GuiInset2.X), (math.max(1, ViewportSize.Y - GuiInset.Y - GuiInset2.Y)))
            local v110 = math.clamp(math.min((v106.X - 24) / 238, (v106.Y - 24) / 282), 0.8, 1)
            local UIScale = v100.Instance:FindFirstChildWhichIsA("UIScale")

            if not UIScale then
                UIScale = Instance.new("UIScale")
                UIScale.Parent = v100.Instance
            end

            UIScale.Scale = v110

            local PaintEditBar = p56.HUD.PaintEditBar

            if not (p56.ClassicController and p56.ClassicController:IsGamepad()) and not (p56.ModernController and p56.ModernController:IsGamepad()) then
                PaintEditBar.Visible = true
            end

            local AbsolutePosition, AbsoluteSize = PaintEditBar.AbsolutePosition, PaintEditBar.AbsoluteSize
            local v111 = Vector2.new(v110 * 238, v110 * 282)
            local X = AbsolutePosition.X
            local v112 = AbsolutePosition.Y + AbsoluteSize.Y + 8
            local v114 = math.max(12, v106.X - v111.X - 12)
            local v116 = math.max(12, v106.Y - v111.Y - 12)

            if v116 < v112 then
                X = AbsolutePosition.X + AbsoluteSize.X + 8
                v112 = math.clamp(AbsolutePosition.Y, 12, v116)
            end

            local v117 = math.clamp(X, 12, v114)
            local v118 = math.clamp(v112, 12, v116)

            v100.Instance.Position = UDim2.fromOffset(math.floor(v117 + 0.5), (math.floor(v118 + 0.5)))
            v100:SetColor(p56.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3)
            p56.ColorPickerHUD = v100
            p56.PaintPickerPreviousGamepadNavigation = p56.BuildGamepadNavigation == true

            local v122 = p56.ClassicController and p56.ClassicController:IsGamepad() or p56.ModernController and p56.ModernController:IsGamepad() or string.match(UserInputService:GetLastInputType().Name, "^Gamepad") ~= nil

            if v122 and not p56.BuildGamepadNavigation then
                p56:SetBuildGamepadNavigation(true)
            end

            if p56.ClassicController and p56.ClassicController:IsGamepad() or p56.ModernController and p56.ModernController:IsGamepad() then
                local ClassicController = p56.ClassicController and p56.ClassicController:IsGamepad() and p56.ClassicController or p56.ModernController

                ClassicController:SyncOwnership()
                ClassicController:RefreshPresentation()
                layoutControllerPicker(p56, v100)
            end

            if v122 then
                task.defer(function() -- line: 647
                    -- upvalues: p56 (copy), v100 (copy), TextButton (copy), GuiService (copy), GamepadService (copy)
                    if p56.ColorPickerHUD ~= v100 or not TextButton.Parent then
                        return
                    end

                    local function v123() -- line: 649
                        -- upvalues: v100 (copy), GamepadService (copy)
                        GamepadService:EnableGamepadCursor(v100.Instance.Picker.Button)
                    end

                    pcall(v123)
                    GuiService.SelectedObject = v100.Instance.Picker.Button
                end)
            end

            TextButton.Activated:Connect(function() -- line: 655
                -- upvalues: p56 (copy), v100 (copy), closePicker (copy)
                if p56.ColorPickerHUD == v100 then
                    closePicker(p56)
                end
            end)

            if p56.ClassicMobile and p56.ClassicMobile:IsActive() or p56.ModernMobile and p56.ModernMobile:IsActive() then
                v100.Instance.Position = UDim2.fromOffset(math.max(8, (v106.X - v111.X) / 2), (math.max(8, (v106.Y - v111.Y) / 2)))
                TextButton.Size = UDim2.fromOffset(48 / v110, 48 / v110)

                if p56.ClassicMobile and p56.ClassicMobile:IsActive() then
                    p56.ClassicMobile:SyncOwnership()
                    p56.ClassicMobile:RefreshPresentation()
                else
                    local ScreenGui = v100.Instance:FindFirstAncestorWhichIsA("ScreenGui")

                    if ScreenGui then
                        ScreenGui.DisplayOrder = math.max(ScreenGui.DisplayOrder, p56.ModernMobile.UI.Root.DisplayOrder + 10)
                    end

                    p56.ModernMobile:RefreshPresentation()
                end
            end

            updateButtons(p56)
            v100.ColorChanged:Connect(function(p57) -- line: 673
                -- upvalues: p56 (copy), v100 (copy), clearHighlights (copy)
                if p56.ColorPickerHUD == v100 and p56.Painting then
                    local v136 = Color3.fromRGB(math.clamp(math.round(p57.R * 255), 0, 255), math.clamp(math.round(p57.G * 255), 0, 255), (math.clamp(math.round(p57.B * 255), 0, 255)))

                    p56.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3 = v136
                    clearHighlights(p56)
                end
            end)
            v100.WindowClosed:Connect(function() -- line: 679
                -- upvalues: p56 (copy), v100 (copy), closePicker (copy)
                if p56.ColorPickerHUD == v100 then
                    closePicker(p56)
                end
            end)

            if p56.ClassicDesktop then
                p56.ClassicDesktop:Refresh()
            end
        end
    end
end

function t1.ControllerApply(p58) -- line: 686
    -- upvalues: pointerPosition (copy), applyAt (copy)
    if p58.ClassicController and p58.ClassicController:IsGamepad() or p58.ModernController and p58.ModernController:IsGamepad() or p58.ClassicMobile and p58.ClassicMobile:IsActive() or p58.ModernMobile and p58.ModernMobile:IsActive() then
        return applyAt(p58, pointerPosition(p58))
    end
end

function t1.ControllerSample(p59) -- line: 692
    -- upvalues: t3 (copy), raycastTarget (copy), pointerBlocked (copy), pointerPosition (copy), clearHighlights (copy), updateHover (copy), updateButtons (copy)
    if not (p59.ClassicController and p59.ClassicController:IsGamepad() or p59.ModernController and p59.ModernController:IsGamepad() or p59.ClassicMobile and p59.ClassicMobile:IsActive() or p59.ModernMobile and p59.ModernMobile:IsActive()) or not p59.Painting or p59.ColorPickerHUD or p59.PaintResetConfirmOpen then
        return false
    end

    local v137 = pointerPosition(p59)

    if not pointerBlocked(p59, v137) then
        local v138 = raycastTarget(p59, v137)

        if v138 and v138:IsA("BasePart") and v138.Transparency < 0.98 and not t3[v138.Name] and v138:GetAttribute("PaintProtected") ~= true and v138:GetAttribute("Paintable") ~= false and v138 then
            local Color = v138.Color
            local v147 = Color3.fromRGB(math.clamp(math.round(Color.R * 255), 0, 255), math.clamp(math.round(Color.G * 255), 0, 255), (math.clamp(math.round(Color.B * 255), 0, 255)))

            p59.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3 = v147

            if p59.ColorPickerHUD then
                p59.ColorPickerHUD:SetColor(v147)
            end

            clearHighlights(p59)
            updateButtons(p59)
            updateHover(p59, v137)

            return true
        end
    end

    return false
end

function t1.ControllerTool(p60, p61) -- line: 706
    -- upvalues: t1 (copy)
    if p60.ClassicController and p60.ClassicController:IsGamepad() then
        t1.SetMode(p60, p61)
    elseif p60.ModernController and p60.ModernController:IsGamepad() then
        t1.SetMode(p60, p61)
    elseif p60.ClassicMobile and p60.ClassicMobile:IsActive() then
        t1.SetMode(p60, p61)
    elseif p60.ModernMobile and p60.ModernMobile:IsActive() then
        t1.SetMode(p60, p61)
    end
end

function t1.ControllerPicker(p62) -- line: 711
    -- upvalues: t1 (copy)
    if p62.ClassicController and p62.ClassicController:IsGamepad() then
        t1.TogglePicker(p62)
    elseif p62.ModernController and p62.ModernController:IsGamepad() then
        t1.TogglePicker(p62)
    elseif p62.ClassicMobile and p62.ClassicMobile:IsActive() then
        t1.TogglePicker(p62)
    elseif p62.ModernMobile and p62.ModernMobile:IsActive() then
        t1.TogglePicker(p62)
    end
end

function t1.ControllerSetColor(p63, p64) -- line: 716
    -- upvalues: t1 (copy), updateButtons (copy)
    if (p63.ClassicController and p63.ClassicController:IsGamepad() or p63.ModernController and p63.ModernController:IsGamepad() or p63.ClassicMobile and p63.ClassicMobile:IsActive() or p63.ModernMobile and p63.ModernMobile:IsActive()) and typeof(p64) == "Color3" then
        local v156 = Color3.fromRGB(math.clamp(math.round(p64.R * 255), 0, 255), math.clamp(math.round(p64.G * 255), 0, 255), (math.clamp(math.round(p64.B * 255), 0, 255)))

        p63.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3 = v156

        if p63.ColorPickerHUD then
            p63.ColorPickerHUD:SetColor(v156)
        end

        updateButtons(p63)

        if p63.ModernMobile and p63.ModernMobile:IsActive() then
            t1.MobileRefresh(p63)
        end
    end
end

function t1.ControllerClosePicker(p65) -- line: 723
    -- upvalues: closePicker (copy)
    closePicker(p65)
end

function t1.MobileRefresh(p66) -- line: 728
    -- upvalues: resolveSelection (copy), clearHighlights (copy), highlightSelection (copy)
    if not (p66.ModernMobile and p66.ModernMobile:IsActive() and p66.Painting) then
        return nil
    end

    local ModernPaintTarget = p66.ModernPaintTarget

    if ModernPaintTarget and ModernPaintTarget.Parent and p66.StorageBase and ModernPaintTarget:IsDescendantOf(p66.StorageBase) then
        local v157 = resolveSelection(p66, ModernPaintTarget, p66.PaintMode)

        p66.ModernPaintSelection = v157
        clearHighlights(p66)

        if not p66.ModernMobile:BlocksWorld() then
            highlightSelection(p66, v157, ModernPaintTarget)
        end

        return ModernPaintTarget, v157
    end

    p66.ModernPaintTarget = nil
    p66.ModernPaintSelection = nil
    clearHighlights(p66)

    return nil
end

function t1.MobileHover(p67, p68) -- line: 745
    -- upvalues: t1 (copy), raycastTarget (copy), clearHighlights (copy)
    if not (p67.ModernMobile and p67.ModernMobile:IsActive() and p67.Painting) then
        return nil
    end

    if p68 then
        if p67.ModernMobile:BlocksWorld() then
            return nil
        end

        p67.ModernPaintTarget = raycastTarget(p67, p68)

        return t1.MobileRefresh(p67)
    end

    p67.ModernPaintTarget = nil
    p67.ModernPaintSelection = nil
    clearHighlights(p67)

    return nil
end

function t1.MobileApply(p69, p70) -- line: 758
    -- upvalues: t1 (copy), previewSelection (copy)
    local ModernMobile = p69.ModernMobile

    if not p69.ModernMobile or not p69.ModernMobile:IsActive() or not p69.Painting or ModernMobile:BlocksWorld() then
        return {
            ok = false,
            reason = "Close the menu before painting."
        }
    elseif p70 then
        t1.MobileHover(p69, p70)
    end

    local v159, v160 = t1.MobileRefresh(p69)

    if not v159 or not v160 then
        return {
            ok = false,
            reason = "Tap a paintable surface first."
        }
    end

    if p69.PaintMode ~= "ColorDropper" then
        local BackgroundColor3 = p69.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3
        local v169 = Color3.fromRGB(math.clamp(math.round(BackgroundColor3.R * 255), 0, 255), math.clamp(math.round(BackgroundColor3.G * 255), 0, 255), (math.clamp(math.round(BackgroundColor3.B * 255), 0, 255)))
        local v170 = ModernMobile:Request({
            action = "Paint",
            target = v159,
            paintMode = p69.PaintMode,
            color = v169
        })

        if v170 and v170.ok then
            previewSelection(v160, v169)

            if ModernMobile.RememberColor then
                ModernMobile:RememberColor(v169)
            end

            t1.MobileRefresh(p69)
        end

        return v170 or {
            ok = false,
            reason = "Paint could not be applied."
        }
    end

    local Color = v159.Color
    local v179 = Color3.fromRGB(math.clamp(math.round(Color.R * 255), 0, 255), math.clamp(math.round(Color.G * 255), 0, 255), (math.clamp(math.round(Color.B * 255), 0, 255)))

    p69.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3 = v179

    if p69.ColorPickerHUD then
        p69.ColorPickerHUD:SetColor(v179)
    end

    local v180 = p69.PaintReturnMode or "PaintBrush"

    p69.PaintReturnMode = nil
    t1.SetMode(p69, v180)

    if ModernMobile.RememberColor then
        ModernMobile:RememberColor(v179)
    end

    t1.MobileRefresh(p69)

    return {
        ok = true,
        reason = "Color sampled."
    }
end

local t8 = {
    "BasePaintBrush",
    "BasePaintBucket",
    "BasePaintDropper",
    "BasePaintPicker",
    "BasePaintClose"
}

local function bindInputs(p71) -- line: 789
    -- upvalues: t1 (copy), RunService (copy), UserInputService (copy), ContextActionService (copy), RemoteEvent (copy), pointerPosition (copy), clearHighlights (copy), updateHover (copy), applyAt (copy), closePicker (copy), setResetConfirmation (copy)
    local function connect(p72, p73) -- line: 790
        -- upvalues: p71 (copy)
        local connection = p72:Connect(p73)

        p71.PaintConnections = p71.PaintConnections or {}
        table.insert(p71.PaintConnections, connection)
    end

    local PaintEditBar = p71.HUD.PaintEditBar
    local connection = PaintEditBar.PaintBrush.Activated:Connect(function() -- line: 796
        -- upvalues: p71 (copy), t1 (copy)
        t1.SetMode(p71, "PaintBrush")
    end)

    p71.PaintConnections = p71.PaintConnections or {}
    table.insert(p71.PaintConnections, connection)

    local connection2 = PaintEditBar.PaintBucket.Activated:Connect(function() -- line: 797
        -- upvalues: p71 (copy), t1 (copy)
        t1.SetMode(p71, "PaintBucket")
    end)

    p71.PaintConnections = p71.PaintConnections or {}
    table.insert(p71.PaintConnections, connection2)

    local connection3 = PaintEditBar.ColorDropper.Activated:Connect(function() -- line: 798
        -- upvalues: p71 (copy), t1 (copy)
        t1.SetMode(p71, "ColorDropper")
    end)

    p71.PaintConnections = p71.PaintConnections or {}
    table.insert(p71.PaintConnections, connection3)

    local connection4 = PaintEditBar.ColorPicker.Activated:Connect(function() -- line: 799
        -- upvalues: p71 (copy), t1 (copy)
        t1.TogglePicker(p71)
    end)

    p71.PaintConnections = p71.PaintConnections or {}
    table.insert(p71.PaintConnections, connection4)

    local ResetPaint = PaintEditBar:FindFirstChild("ResetPaint")

    if ResetPaint and ResetPaint:IsA("GuiButton") then
        local connection = ResetPaint.Activated:Connect(function() -- line: 802
            -- upvalues: p71 (copy), t1 (copy)
            t1.ShowResetConfirmation(p71)
        end)

        p71.PaintConnections = p71.PaintConnections or {}
        table.insert(p71.PaintConnections, connection)
    end

    local v182 = p71.BuildGui and p71.BuildGui:FindFirstChild("PaintResetConfirm")
    local Panel = v182 and v182:FindFirstChild("Panel")

    if Panel then
        local Confirm = Panel:FindFirstChild("Confirm")
        local Cancel = Panel:FindFirstChild("Cancel")

        if Confirm and Confirm:IsA("GuiButton") then
            local connection = Confirm.Activated:Connect(function() -- line: 812
                -- upvalues: p71 (copy), RemoteEvent (copy), setResetConfirmation (copy)
                if p71.PaintResetConfirmOpen and (not p71.ClassicDesktop or not p71.ClassicDesktop.Busy) and (not p71.ModernDesktop or not p71.ModernDesktop.Busy) and (not p71.ClassicMobile or not p71.ClassicMobile.Busy) and (not p71.ClassicController or not p71.ClassicController.Busy) and (not p71.ModernController or not p71.ModernController.Busy) then
                    setResetConfirmation(p71, false)
                    RemoteEvent:FireServer("ResetAllBasePaint")

                    local ClassicDesktop = p71.ClassicDesktop

                    if ClassicDesktop then
                        task.defer(function() -- line: 822
                            -- upvalues: ClassicDesktop (copy)
                            ClassicDesktop:RefreshState()
                        end)
                    end

                    local ClassicMobile = p71.ClassicMobile

                    if ClassicMobile then
                        task.defer(function() -- line: 824
                            -- upvalues: ClassicMobile (copy)
                            ClassicMobile:RefreshState()
                        end)
                    end

                    local ModernDesktop = p71.ModernDesktop

                    if ModernDesktop then
                        task.defer(function() -- line: 826
                            -- upvalues: ModernDesktop (copy)
                            ModernDesktop:RefreshState()
                        end)
                    end

                    local ClassicController = p71.ClassicController

                    if ClassicController then
                        task.defer(function() -- line: 828
                            -- upvalues: ClassicController (copy)
                            ClassicController:RefreshState()
                        end)
                    end

                    local ModernController = p71.ModernController

                    if ModernController then
                        task.defer(function() -- line: 830
                            -- upvalues: ModernController (copy)
                            ModernController:RefreshState()
                        end)
                    end
                end
            end)

            p71.PaintConnections = p71.PaintConnections or {}
            table.insert(p71.PaintConnections, connection)
        end

        if Cancel and Cancel:IsA("GuiButton") then
            local connection = Cancel.Activated:Connect(function() -- line: 834
                -- upvalues: p71 (copy), setResetConfirmation (copy)
                setResetConfirmation(p71, false)
            end)

            p71.PaintConnections = p71.PaintConnections or {}
            table.insert(p71.PaintConnections, connection)
        end
    end

    local connection5 = PaintEditBar.Exit.Activated:Connect(function() -- line: 839
        -- upvalues: p71 (copy), t1 (copy)
        t1.Close(p71)
    end)

    p71.PaintConnections = p71.PaintConnections or {}
    table.insert(p71.PaintConnections, connection5)

    local connection6 = UserInputService.InputBegan:Connect(function(p74, p75) -- line: 841
        -- upvalues: p71 (copy), pointerPosition (copy), updateHover (copy), applyAt (copy)
        if p71.Painting and (not p71.ClassicMobile or not p71.ClassicMobile:IsActive()) and (not p71.ModernMobile or not p71.ModernMobile:IsActive()) then
            local v184 = Vector2.new(p74.Position.X, p74.Position.Y)

            if p74.UserInputType == Enum.UserInputType.MouseButton1 and not p75 then
                applyAt(p71, v184)

                return
            end

            if p74.UserInputType ~= Enum.UserInputType.Touch or p75 then
                if p74.KeyCode == Enum.KeyCode.ButtonA and not (p71.ClassicController and p71.ClassicController:IsGamepad() or p71.ModernController and p71.ModernController:IsGamepad() or p71.ClassicMobile and p71.ClassicMobile:IsActive() or p71.ModernMobile and p71.ModernMobile:IsActive()) then
                    applyAt(p71, pointerPosition(p71))
                end
            else
                p71.PaintTouchInput = p74
                p71.PaintTouchStart = v184
                p71.PaintTouchMoved = false
                updateHover(p71, v184)
            end
        end
    end)

    p71.PaintConnections = p71.PaintConnections or {}
    table.insert(p71.PaintConnections, connection6)

    local connection7 = UserInputService.InputChanged:Connect(function(p76) -- line: 857
        -- upvalues: p71 (copy), clearHighlights (copy)
        if p76 == p71.PaintTouchInput and p71.PaintTouchStart and (Vector2.new(p76.Position.X, p76.Position.Y) - p71.PaintTouchStart).Magnitude > 10 then
            p71.PaintTouchMoved = true
            clearHighlights(p71)
        end
    end)

    p71.PaintConnections = p71.PaintConnections or {}
    table.insert(p71.PaintConnections, connection7)

    local connection8 = UserInputService.InputEnded:Connect(function(p77) -- line: 865
        -- upvalues: p71 (copy), clearHighlights (copy)
        if p77 ~= p71.PaintTouchInput then
            return
        end

        p71.PaintTouchInput = nil
        p71.PaintTouchStart = nil
        p71.PaintTouchMoved = nil
        clearHighlights(p71)
    end)

    p71.PaintConnections = p71.PaintConnections or {}
    table.insert(p71.PaintConnections, connection8)

    local connection9 = UserInputService.TouchTapInWorld:Connect(function(p78, p79) -- line: 872
        -- upvalues: p71 (copy), clearHighlights (copy), updateHover (copy), applyAt (copy)
        local v185, v186

        if not p71.Painting or p79 then
            v186 = true
        else
            v185 = p71.ClassicMobile and p71.ClassicMobile:IsActive()
            v186 = false
        end

        if v186 or v185 or p71.ModernMobile and p71.ModernMobile:IsActive() then
            return
        end

        updateHover(p71, p78)
        applyAt(p71, p78)
        task.delay(0.15, function() -- line: 876
            -- upvalues: p71 (copy), clearHighlights (copy)
            if p71.Painting and not p71.PaintTouchInput then
                clearHighlights(p71)
            end
        end)
    end)

    p71.PaintConnections = p71.PaintConnections or {}
    table.insert(p71.PaintConnections, connection9)

    local connection10 = RunService.RenderStepped:Connect(function() -- line: 880
        -- upvalues: p71 (copy), UserInputService (copy), pointerPosition (copy), updateHover (copy)
        if p71.Painting and not (p71.ModernMobile and p71.ModernMobile:IsActive()) then
            local LastInputType = UserInputService:GetLastInputType()

            if p71.ClassicMobile and p71.ClassicMobile:IsActive() or UserInputService.MouseEnabled or string.match(LastInputType.Name, "^Gamepad") then
                updateHover(p71, pointerPosition(p71))
            end
        end
    end)

    p71.PaintConnections = p71.PaintConnections or {}
    table.insert(p71.PaintConnections, connection10)

    local function action(p80, p81, p82) -- line: 888
        -- upvalues: p71 (copy), t1 (copy), UserInputService (copy), closePicker (copy), setResetConfirmation (copy)
        if p82 and string.match(p82.UserInputType.Name, "^Gamepad") and (p71.ClassicController and p71.ClassicController:IsGamepad() or p71.ModernController and p71.ModernController:IsGamepad() or p71.ClassicMobile and p71.ClassicMobile:IsActive() or p71.ModernMobile and p71.ModernMobile:IsActive()) or p81 ~= Enum.UserInputState.Begin then
            return Enum.ContextActionResult.Pass
        end

        if p71.PaintResetConfirmOpen then
            if p80 == "BasePaintClose" then
                setResetConfirmation(p71, false)
            end
        elseif p80 == "BasePaintClose" then
            if p71.ColorPickerHUD then
                closePicker(p71)
            else
                t1.Close(p71)
            end
        elseif not UserInputService:GetFocusedTextBox() then
            if p80 == "BasePaintBrush" then
                t1.SetMode(p71, "PaintBrush")
            elseif p80 == "BasePaintBucket" then
                t1.SetMode(p71, "PaintBucket")
            elseif p80 == "BasePaintDropper" then
                t1.SetMode(p71, "ColorDropper")
            elseif p80 == "BasePaintPicker" then
                t1.TogglePicker(p71)
            end
        end

        return Enum.ContextActionResult.Sink
    end

    local v187 = Enum.ContextActionPriority.High.Value + 20

    ContextActionService:BindActionAtPriority("BasePaintBrush", action, false, v187, Enum.KeyCode.One, Enum.KeyCode.DPadLeft)
    ContextActionService:BindActionAtPriority("BasePaintBucket", action, false, v187, Enum.KeyCode.Two, Enum.KeyCode.DPadUp)
    ContextActionService:BindActionAtPriority("BasePaintDropper", action, false, v187, Enum.KeyCode.Three, Enum.KeyCode.DPadRight)
    ContextActionService:BindActionAtPriority("BasePaintPicker", action, false, v187, Enum.KeyCode.Four, Enum.KeyCode.DPadDown)
    ContextActionService:BindActionAtPriority("BasePaintClose", action, false, v187, Enum.KeyCode.Escape, Enum.KeyCode.ButtonB)
end

local function unbindInputs() -- line: 917
    -- upvalues: ContextActionService (copy), t8 (copy)
    for _, v188 in ipairs(t8) do
        ContextActionService:UnbindAction(v188)
    end
end

local function savePaintGuiState(p83) -- line: 921
    -- upvalues: UserInputService (copy)
    local function originalVisibility(p84) -- line: 922
        -- upvalues: p83 (copy)
        if p83.ModernMobile and p83.ModernMobile:IsActive() then
            return p83.ModernMobile:GetLegacyVisibility(p84)
        end

        if p83.ModernController and p83.ModernController:IsGamepad() then
            return p83.ModernController:GetLegacyVisibility(p84)
        end

        return p84.Visible
    end

    local BuildGui = p83.BuildGui
    local TextLabel = p83.HUD.PaintEditBar.Exit:FindFirstChild("TextLabel")
    local Toolbar = BuildGui.Toolbar
    local t9 = {}

    t9.Toolbar = if p83.ModernMobile and p83.ModernMobile:IsActive() then p83.ModernMobile:GetLegacyVisibility(Toolbar) elseif p83.ModernController and p83.ModernController:IsGamepad() then p83.ModernController:GetLegacyVisibility(Toolbar) else Toolbar.Visible

    local TransformPanel = BuildGui.TransformPanel

    t9.TransformPanel = if p83.ModernMobile and p83.ModernMobile:IsActive() then p83.ModernMobile:GetLegacyVisibility(TransformPanel) elseif p83.ModernController and p83.ModernController:IsGamepad() then p83.ModernController:GetLegacyVisibility(TransformPanel) else TransformPanel.Visible

    local ViewPanel = BuildGui.ViewPanel

    t9.ViewPanel = if p83.ModernMobile and p83.ModernMobile:IsActive() then p83.ModernMobile:GetLegacyVisibility(ViewPanel) elseif p83.ModernController and p83.ModernController:IsGamepad() then p83.ModernController:GetLegacyVisibility(ViewPanel) else ViewPanel.Visible

    local Hint = BuildGui.Hint

    t9.Hint = if p83.ModernMobile and p83.ModernMobile:IsActive() then p83.ModernMobile:GetLegacyVisibility(Hint) elseif p83.ModernController and p83.ModernController:IsGamepad() then p83.ModernController:GetLegacyVisibility(Hint) else Hint.Visible
    t9.HintText = BuildGui.Hint.Text

    local BaseObjects = p83.HUD.BaseObjects

    t9.BaseObjects = if p83.ModernMobile and p83.ModernMobile:IsActive() then p83.ModernMobile:GetLegacyVisibility(BaseObjects) elseif p83.ModernController and p83.ModernController:IsGamepad() then p83.ModernController:GetLegacyVisibility(BaseObjects) else BaseObjects.Visible
    t9.BaseEditButtons = {}
    t9.ExitText = TextLabel and TextLabel.Text or nil
    t9.CanvasPosition = BuildGui.Toolbar.Buttons.CanvasPosition
    t9.ButtonVisibility = {}
    p83.PaintGuiSaved = t9

    for _, child in ipairs(BuildGui.Toolbar.Buttons:GetChildren()) do
        if child:IsA("GuiObject") then
            p83.PaintGuiSaved.ButtonVisibility[child] = child.Visible
        end
    end

    for _, child in ipairs(p83.HUD.BaseEdit:GetChildren()) do
        if child:IsA("GuiObject") then
            p83.PaintGuiSaved.BaseEditButtons[child] = child.Visible
            child.Visible = false
        end
    end

    if p83.PaintIntegrated and TextLabel then
        TextLabel.Text = "Back"
    end

    if p83.PaintIntegrated then
        BuildGui.Toolbar.Visible = not p83.ClassicBuildActive

        for v189 in pairs(p83.PaintGuiSaved.ButtonVisibility) do
            if v189.Name == "PaintMode" or v189.Name == "Capacity" then
                v189.Visible = true
            else
                v189.Visible = v189.Name == "Exit"
            end
        end

        BuildGui.Toolbar.Buttons.CanvasPosition = Vector2.zero
        p83.HUD.BaseObjects.Visible = false
    else
        BuildGui.Toolbar.Visible = false
    end

    BuildGui.TransformPanel.Visible = false
    BuildGui.ViewPanel.Visible = not p83.ClassicBuildActive
    BuildGui.Hint.Visible = not p83.ClassicBuildActive

    if UserInputService.TouchEnabled then
        BuildGui.Hint.Visible = false
        BuildGui.Hint.Text = "Tap to paint · Drag to orbit · Pinch to pan/zoom"
    elseif p83.ClassicController and p83.ClassicController:IsGamepad() then
        BuildGui.Hint.Text = "A paint · LB precision · RB jump · D-pad Up tools · B back"
    elseif p83.ModernController and p83.ModernController:IsGamepad() then
        BuildGui.Hint.Text = "A paint · RT tool · X sample · Y colour · LT slow camera · LB/RB camera height · B back"
    elseif UserInputService.GamepadEnabled then
        BuildGui.Hint.Text = "A paint · R3 cursor · Sticks/LB-RB camera · D-pad tools"
    else
        BuildGui.Hint.Text = "Click to paint · RMB orbit · MMB pan · Wheel/WASD/QE camera"
    end
end

local function restorePaintGuiState(p85) -- line: 986
    local PaintGuiSaved, BuildGui = p85.PaintGuiSaved, p85.BuildGui

    if PaintGuiSaved and BuildGui then
        BuildGui.Toolbar.Visible = PaintGuiSaved.Toolbar
        BuildGui.TransformPanel.Visible = PaintGuiSaved.TransformPanel
        BuildGui.ViewPanel.Visible = PaintGuiSaved.ViewPanel
        BuildGui.Hint.Visible = PaintGuiSaved.Hint
        BuildGui.Hint.Text = PaintGuiSaved.HintText
        BuildGui.Toolbar.Buttons.CanvasPosition = PaintGuiSaved.CanvasPosition or Vector2.zero

        for v190, v191 in pairs(PaintGuiSaved.ButtonVisibility or {}) do
            if v190.Parent then
                v190.Visible = v191
            end
        end

        if p85.HUD and p85.HUD:FindFirstChild("BaseObjects") then
            p85.HUD.BaseObjects.Visible = PaintGuiSaved.BaseObjects
        end

        for v192, v193 in pairs(PaintGuiSaved.BaseEditButtons or {}) do
            if v192.Parent then
                v192.Visible = v193
            end
        end

        local v194 = p85.HUD and p85.HUD:FindFirstChild("PaintEditBar")
        local Exit = v194 and v194:FindFirstChild("Exit")
        local TextLabel = Exit and Exit:FindFirstChild("TextLabel")

        if TextLabel and PaintGuiSaved.ExitText then
            TextLabel.Text = PaintGuiSaved.ExitText
        end
    end

    if PaintGuiSaved then
        if p85.ModernMobile and p85.ModernMobile:IsActive() then
            p85.ModernMobile:RestoreLegacyVisibility(PaintGuiSaved)
        end

        if p85.ModernController and p85.ModernController:IsGamepad() then
            p85.ModernController:RestoreLegacyVisibility(PaintGuiSaved)
        end
    end

    p85.PaintGuiSaved = nil
end

local function setMobileGameplayVisible(p86, p87) -- line: 1018
    if not p86.TouchEnabled or not p86.MobileButtons then
        return
    end

    if p87 then
        if p86.PaintMobileVisibility then
            for v195, v196 in pairs(p86.PaintMobileVisibility) do
                if v195.Parent then
                    v195.Visible = v196
                end
            end

            p86.PaintMobileVisibility = nil
        end
    else
        p86.PaintMobileVisibility = {}

        for _, child in ipairs(p86.MobileButtons.Buttons:GetChildren()) do
            if child:IsA("GuiObject") then
                p86.PaintMobileVisibility[child] = child.Visible
                child.Visible = false
            end
        end

        p86.HUD.MobileMouse.Visible = false
        p86.HUD.MobileEdits.Visible = false
    end
end

function t1.Open(p88) -- line: 1038
    -- upvalues: t1 (copy), UserInputService (copy), rebuildTargets (copy), bindInputs (copy), savePaintGuiState (copy), setMobileGameplayVisible (copy)
    if p88.Painting then
        return true
    end

    if not (p88.StorageBase and p88.StorageBase.Parent) then
        return false
    end

    local v197 = p88.BuildCameraActive and p88.EditingBase

    p88.PaintIntegrated = v197 == true
    p88.Painting = true
    p88.PaintMode = "PaintBrush"
    p88.PaintReturnMode = nil
    p88.PaintLastCommit = 0

    local v198

    if v197 then
        v198 = p88:SetBuildModeKind("Paint") == true
    else
        if p88:BeginBuildMode("Paint") ~= true then
            p88.PaintIntegrated = nil
            p88.Painting = nil
            p88.PaintMode = nil

            return false
        end

        p88:DestroyBuildGrid()
    end

    if v197 and v198 or not v197 then
        savePaintGuiState(p88)

        if not v197 then
            p88:EnableBackpack(false)
            p88:BarsVisible(false)
            setMobileGameplayVisible(p88, false)
        end

        local PaintEditBar = p88.HUD.PaintEditBar
        local v199 = p88.BuildGui and p88.BuildGui:FindFirstChild("PaintResetConfirm")

        if v199 then
            v199.Visible = false
        end

        p88.PaintResetConfirmOpen = nil
        p88.PaintResetPreviousSelection = nil
        PaintEditBar.Visible = true

        if v197 and p88.BuildGamepadNavigation and UserInputService.GamepadEnabled then
            p88:SetBuildGamepadNavigation(true)
        end

        local CurrentCamera = workspace.CurrentCamera
        local Y = CurrentCamera and CurrentCamera.ViewportSize.Y or 720
        local v200 = math.max(1, PaintEditBar.Size.Y.Offset)
        local v202 = math.clamp((Y - 68) / v200, 0.45, 1)
        local v203 = PaintEditBar:FindFirstChild("PaintUIScale") or Instance.new("UIScale")

        v203.Name = "PaintUIScale"
        v203.Scale = v202
        v203.Parent = PaintEditBar

        local Paint = p88.HUD.BaseEdit:FindFirstChild("Paint")

        if Paint then
            Paint.Text = "Close Paint"
        end

        rebuildTargets(p88)
        bindInputs(p88)
        t1.SetMode(p88, "PaintBrush")

        local v204 = p88.StorageBase:FindFirstChild("Contents") and p88.StorageBase.Contents:FindFirstChild("Objects")

        if v204 then
            local function refresh() -- line: 1096
                -- upvalues: p88 (copy), rebuildTargets (copy)
                task.defer(function() -- line: 1096
                    -- upvalues: p88 (copy), rebuildTargets (copy)
                    if p88.Painting then
                        rebuildTargets(p88)
                    end
                end)
            end

            local connection = v204.ChildAdded:Connect(refresh)
            local connection2 = v204.ChildRemoved:Connect(refresh)

            p88.PaintConnections = p88.PaintConnections or {}
            table.insert(p88.PaintConnections, connection)
            table.insert(p88.PaintConnections, connection2)
        end

        if p88.ClassicController then
            p88.ClassicController:RefreshPresentation()
        end

        if p88.ModernController then
            p88.ModernController:RefreshPresentation()
        end

        if p88.ClassicMobile then
            p88.ClassicMobile:RefreshPresentation()
        end

        if p88.ModernMobile then
            p88.ModernMobile:RefreshPresentation()
        end

        if p88.ClassicDesktop then
            p88.ClassicDesktop:Refresh()
        end

        if p88.ModernDesktop then
            p88.ModernDesktop:Refresh()
        end

        if p88.ClassicBuildActive then
            p88:ApplyClassicBuildPresentation()
        end

        return true
    end

    p88.PaintIntegrated = nil
    p88.Painting = nil
    p88.PaintMode = nil

    return false
end

function t1.Close(p89) -- line: 1115
    -- upvalues: UserInputService (copy), ContextActionService (copy), disconnectAll (copy), restoreQuery (copy), clearHighlights (copy), closePicker (copy), setResetConfirmation (copy), t8 (copy), restorePaintGuiState (copy)
    if p89.Painting then
        local v206 = p89.PaintIntegrated == true

        setResetConfirmation(p89, false)
        p89.Painting = nil

        for _, v207 in ipairs(t8) do
            ContextActionService:UnbindAction(v207)
        end

        disconnectAll(p89)
        closePicker(p89)
        clearHighlights(p89)
        restoreQuery(p89)

        if not v206 and p89.TouchEnabled and p89.MobileButtons and p89.PaintMobileVisibility then
            for v208, v209 in pairs(p89.PaintMobileVisibility) do
                if v208.Parent then
                    v208.Visible = v209
                end
            end

            p89.PaintMobileVisibility = nil
        end

        p89.HUD.PaintEditBar.Visible = false

        local Paint = p89.HUD.BaseEdit:FindFirstChild("Paint")

        if Paint then
            Paint.Text = "Paint"
        end

        restorePaintGuiState(p89)

        if not (v206 and p89.BuildCameraActive) then
            if p89.BuildCameraActive then
                p89:EndBuildMode()
            end
        else
            p89:SetBuildModeKind("Objects")

            if p89.BuildGamepadNavigation and UserInputService.GamepadEnabled then
                p89:SetBuildGamepadNavigation(true)
            end
        end

        if not v206 then
            p89:EnableBackpack(true)
            p89:BarsVisible(true)
        end

        p89.PaintIntegrated = nil
        p89.PaintMode = nil
        p89.PaintReturnMode = nil
        p89.PaintLastCommit = nil
        p89.PaintTouchInput = nil
        p89.PaintTouchStart = nil
        p89.PaintTouchMoved = nil
        p89.ModernPaintTarget = nil
        p89.ModernPaintSelection = nil

        if p89.ClassicController then
            p89.ClassicController:RefreshPresentation()
        end

        if p89.ModernController then
            p89.ModernController:RefreshPresentation()
        end

        if p89.ClassicMobile then
            p89.ClassicMobile:RefreshPresentation()
        end

        if p89.ModernMobile then
            p89.ModernMobile:RefreshPresentation()
        end

        if p89.ClassicDesktop then
            p89.ClassicDesktop:Refresh()
        end

        if p89.ModernDesktop then
            p89.ModernDesktop:Refresh()
        end
    end
end

t1.Start = t1.Open
t1.Stop = t1.Close

return t1
