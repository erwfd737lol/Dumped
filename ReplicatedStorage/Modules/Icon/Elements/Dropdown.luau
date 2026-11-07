
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local v1 = require(script.Parent.Parent.Features.Themes)
return function(a0) --[[ Upvalues: v1 (copy), TweenService (copy), RunService (copy) ]]
    local Frame = Instance.new("Frame")
    Frame.Name = "Dropdown"
    Frame.AutomaticSize = Enum.AutomaticSize.X
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.AnchorPoint = Vector2.new(0.5, 0)
    Frame.Position = UDim2.new(0.5, 0, 1, 10)
    Frame.ZIndex = -2
    Frame.ClipsDescendants = true
    Frame.Parent = a0.widget
    local GuiService = game:GetService("GuiService")
    a0:setBehaviour("Dropdown", "BackgroundTransparency", function(a0) --[[ Upvalues: GuiService (copy) ]]
        if a0 == 1 then
            return a0
        end

        return a0 * GuiService.PreferredTransparency
    end)
    local v2 = GuiService:GetPropertyChangedSignal("PreferredTransparency")
    local v3 = v2:Connect(function() --[[ Upvalues: a0 (copy), Frame (copy) ]]
        a0:refreshAppearance(Frame, "BackgroundTransparency")
    end)
    a0.janitor:add(v3)
    local UICorner = Instance.new("UICorner")
    UICorner.Name = "DropdownCorner"
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Frame
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "DropdownScroller"
    ScrollingFrame.AutomaticSize = Enum.AutomaticSize.X
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.AnchorPoint = Vector2.new(0, 0)
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.ZIndex = -1
    ScrollingFrame.ClipsDescendants = true
    ScrollingFrame.Visible = true
    ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None
    ScrollingFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    ScrollingFrame.Active = false
    ScrollingFrame.ScrollingEnabled = true
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.ScrollBarThickness = 5
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    ScrollingFrame.ScrollBarImageTransparency = 0.8
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.Selectable = false
    ScrollingFrame.Active = true
    ScrollingFrame.Parent = Frame
    local NumberValue = Instance.new("NumberValue")
    NumberValue.Name = "DropdownSpeed"
    NumberValue.Value = 0.07
    NumberValue.Parent = Frame
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Name = "DropdownPadding"
    UIPadding.PaddingTop = UDim.new(0, 0)
    UIPadding.PaddingBottom = UDim.new(0, 0)
    UIPadding.Parent = ScrollingFrame
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Name = "DropdownList"
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceEvenly
    UIListLayout.Parent = ScrollingFrame
    UIListLayout = a0.dropdownJanitor
    local v4 = require(a0.iconModule)
    a0.dropdownChildAdded:Connect(function(a0)
        local v5 = {"Widget", "BorderSize", 0}
        local v7 = {"IconCorners", "CornerRadius", UDim.new(0, 10)}
        local v8 = {"Widget", "MinimumWidth", 190}
        local v9 = {"Widget", "MinimumHeight", 58}
        local v10 = {"IconLabel", "TextSize", 20}
        local v12 = {"IconOverlay", "Size", UDim2.new(1, 0, 1, 0)}
        local v14 = {"PaddingLeft", "Size", UDim2.fromOffset(25, 0)}
        local v16 = {"Notice", "Position", UDim2.new(1, -24, 0, 5)}
        local v17 = {"ContentsList", "HorizontalAlignment", Enum.HorizontalAlignment.Left}
        local v19 = {"Selection", "Size", UDim2.new(1, 0, 1, 0)}
        local v21 = {"Selection", "Position", UDim2.new(0, 0, 0, 0)}
        local v22 = {v5, v7, v8, v9, v10, v12, v14, v16, v17, v19, v21}
        local v23, v24 = a0:modifyTheme(v22)
        task.defer(function() --[[ Upvalues: a0 (copy), v24 (copy) ]]
            a0.joinJanitor:add(function() --[[ Upvalues: a0 (upvalue), v24 (upvalue) ]]
                a0:removeModification(v24)
            end)
        end)
    end)
    a0.dropdownSet:Connect(function(a0) --[[ Upvalues: a0 (copy), v4 (copy) ]]
        for k1, k2 in pairs(a0.dropdownIcons) do
            v4.getIconByUID(k2):destroy()
        end

        if type(a0) == "table" then
            for k3, k4 in pairs(a0) do
                k4:joinDropdown(a0)
            end
        end

    end)

    local function updateMaxIcons() --[[ Upvalues: Frame (copy), ScrollingFrame (copy), UIPadding (copy) ]]
        local v31 = Frame:GetAttribute("MaxIcons")
        if not v31 then
            return 0
        end

        local v32 = {}
        local v33 = ScrollingFrame:GetChildren()
        for k5, k6 in pairs(v33) do
            if k6:IsA("GuiObject") and k6.Visible then
                table.insert(v32, k6)
            end
        end

        table.sort(v32, function(a0, a1)
            return a0.AbsolutePosition.Y < a1.AbsolutePosition.Y
        end)
        local v37 = 0
        local v38 = math.ceil(v31)
        local v39 = v38
        k5 = 1
        for i1 = 1, v39, k5 do
            local v40 = v32[i1]
            if not v40 then
                break
            end

            v40 = false
            if i1 == v38 then
                v40 = v38 ~= v31
            end

            local v41
            if v40 then
                v41 = v41 * (v31 - v38 + 1)
            end

            v37 = v37 + v41
        end

        return v37 + (UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset)
    end

    local v42 = nil
    local v43 = nil
    local v44 = nil
    local v45 = nil

    local function getTweenInfo() --[[ Upvalues: v1 (upvalue), Frame (copy), v44 (ref), v45 (ref), NumberValue (copy) ]]
        local v46 = v1.getInstanceValue(Frame, "MaxIcons") or 1
        if v44 and v44 == v46 and v45 then
            return v45
        end

        local v47 = NumberValue.Value * v46
        local v48 = TweenInfo.new(v47, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
        v45 = v48
        v44 = v46
        return v48
    end

    local function updateVisibility() --[[ Upvalues: v1 (upvalue), Frame (copy), v44 (ref), v45 (ref), NumberValue (copy), v42 (ref), v43 (ref), a0 (copy), updateMaxIcons (copy), TweenService (upvalue) ]]
        local v49 = v1.getInstanceValue(Frame, "MaxIcons") or 1
        local v50
        if v44 and v44 == v49 and v45 then
            v50 = v45
        else
            local v51 = NumberValue.Value * v49
            local v52 = TweenInfo.new(v51, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
            v45 = v52
            v44 = v49
            v50 = v52
        end

        if v42 then
            v42:Cancel()
            v42 = nil
        end

        if v43 then
            v43:Cancel()
            v43 = nil
        end

        if a0.isSelected then
            Frame.Visible = true
            Frame.BackgroundTransparency = 0
            Frame.Size = UDim2.new(0, Frame.Size.X.Offset, 0, 0)
            local v53 = {Size = UDim2.new(0, Frame.Size.X.Offset, 0, updateMaxIcons())}
            v42 = TweenService:Create(Frame, v50, v53)
            v42:Play()
            v42.Completed:Connect(function() --[[ Upvalues: v42 (upvalue) ]]
                v42 = nil
            end)
            return
        end

        local v54 = TweenInfo.new(0)
        local v55 = {Size = UDim2.new(0, Frame.Size.X.Offset, 0, 0)}
        v43 = TweenService:Create(Frame, v54, v55)
        v43:Play()
        v43.Completed:Connect(function() --[[ Upvalues: v43 (upvalue) ]]
            v43 = nil
        end)
    end

    local v56 = a0.toggled:Connect(updateVisibility)
    UIListLayout:add(v56)
    updateVisibility()

    local function updateChildSize() --[[ Upvalues: v1 (upvalue), Frame (copy), v44 (ref), v45 (ref), NumberValue (copy), a0 (copy), v42 (ref), v43 (ref), RunService (upvalue), updateMaxIcons (copy), TweenService (upvalue) ]]
        local v57 = v1.getInstanceValue(Frame, "MaxIcons") or 1
        local v58
        if v44 and v44 == v57 and v45 then
            v58 = v45
        else
            local v59 = NumberValue.Value * v57
            local v60 = TweenInfo.new(v59, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
            v45 = v60
            v44 = v57
            v58 = v60
        end

        if not a0.isSelected then
            return
        end

        if v42 then
            v42:Cancel()
            v42 = nil
        end

        if v43 then
            v43:Cancel()
            v43 = nil
        end

        RunService.Heartbeat:Wait()
        local t1 = {Size = UDim2.new(0, Frame.Size.X.Offset, 0, updateMaxIcons())}
        v42 = TweenService:Create(Frame, v58, t1)
        v42:Play()
        v42.Completed:Connect(function() --[[ Upvalues: v42 (upvalue) ]]
            v42 = nil
        end)
    end

    local v61 = a0.toggled:Connect(updateVisibility)
    UIListLayout:add(v61)
    local v62 = 0
    local v63 = false

    local function updateMaxIconsListener() --[[ Upvalues: v62 (ref), v63 (ref), updateMaxIconsListener (copy), Frame (copy), ScrollingFrame (copy), v4 (copy), a0 (copy), UIPadding (copy) ]]
        v62 = v62 + 1
        if v63 then
            return
        end

        v63 = true
        local v64 = v62
        task.defer(function() --[[ Upvalues: v63 (upvalue), v62 (upvalue), v64 (copy), updateMaxIconsListener (upvalue) ]]
            v63 = false
            if v62 ~= v64 then
                updateMaxIconsListener()
            end

        end)
        local v65 = Frame:GetAttribute("MaxIcons")
        if not v65 then
            return
        end

        local v66 = {}
        local v67 = ScrollingFrame:GetChildren()
        for k7, k8 in pairs(v67) do
            if k8:IsA("GuiObject") and k8.Visible then
                local v71 = {k8, k8.AbsolutePosition.Y}
                table.insert(v66, v71)
            end
        end

        table.sort(v66, function(a0, a1)
            return a0[2] < a1[2]
        end)
        local v72 = 0
        local v73 = false
        local v74 = math.ceil(v65)
        local v75 = v74
        k8 = 1
        for i2 = 1, v75, k8 do
            local v76 = v66[i2]
            if not v76 then
                break
            end

            local v77 = v76[1]
            local v78 = false
            if i2 == v74 then
                v78 = v74 ~= v65
            end

            local v79
            if v78 then
                v79 = v79 * (v65 - v74 + 1)
            end

            v72 = v72 + v79
            if not v78 then
                local v80 = v77:GetAttribute("WidgetUID")
                local v82 = v80 and v4.getIconByUID(v80)
                if v82 then
                    local v83 = true
                    v80 = a0:getInstance("ClickRegion")
                    local v84 = nil or v83
                    v82:getInstance("ClickRegion").NextSelectionUp = v80
                end
            end
        end

        v72 = v72 + (UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset)
        ScrollingFrame.Size = UDim2.fromOffset(0, v72)
    end

    local v85 = ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize")
    local v86 = v85:Connect(updateMaxIconsListener)
    UIListLayout:add(v86)
    local v87 = ScrollingFrame.ChildAdded:Connect(updateMaxIconsListener)
    UIListLayout:add(v87)
    local v88 = ScrollingFrame.ChildRemoved:Connect(updateChildSize)
    UIListLayout:add(v88)
    local v89 = ScrollingFrame.ChildRemoved:Connect(updateMaxIconsListener)
    UIListLayout:add(v89)
    local v90 = Frame:GetAttributeChangedSignal("MaxIcons")
    local v91 = v90:Connect(updateMaxIconsListener)
    UIListLayout:add(v91)
    local v92 = Frame:GetAttributeChangedSignal("MaxIcons")
    local v93 = v92:Connect(updateChildSize)
    UIListLayout:add(v93)
    local v94 = a0.childThemeModified:Connect(updateMaxIconsListener)
    UIListLayout:add(v94)
    updateMaxIconsListener()

    local function connectVisibilityListeners(a0) --[[ Upvalues: updateChildSize (copy) ]]
        if a0:IsA("GuiObject") then
            local v95 = a0:GetPropertyChangedSignal("Visible")
            v95:Connect(updateChildSize)
            local v96 = a0:GetPropertyChangedSignal("Size")
            v96:Connect(updateChildSize)
        end
    end

    local v97 = ScrollingFrame:GetChildren()
    for k9, k10 in pairs(v97) do
        if k10:IsA("GuiObject") then
            local v101 = k10:GetPropertyChangedSignal("Visible")
            v101:Connect(updateChildSize)
            local v102 = k10:GetPropertyChangedSignal("Size")
            v102:Connect(updateChildSize)
        end
    end

    ScrollingFrame.ChildAdded:Connect(function(a0) --[[ Upvalues: RunService (upvalue), updateChildSize (copy) ]]
        RunService.Heartbeat:Wait()
        if a0:IsA("GuiObject") then
            local v103 = a0:GetPropertyChangedSignal("Visible")
            v103:Connect(updateChildSize)
            local v104 = a0:GetPropertyChangedSignal("Size")
            v104:Connect(updateChildSize)
        end

        updateChildSize()
    end)
    Frame.Visible = false
    return Frame
end
