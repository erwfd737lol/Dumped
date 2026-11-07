
return function(a0, a1)
    local widget = a0.widget
    local v1 = a0:getInstance("Contents")
    local Frame = Instance.new("Frame")
    Frame.Name = "Indicator"
    Frame.LayoutOrder = 9999999
    Frame.ZIndex = 6
    Frame.Size = UDim2.new(0, 42, 0, 42)
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 1
    Frame.Position = UDim2.new(1, 0, 0.5, 0)
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.Parent = v1
    v1 = Instance.new("Frame")
    v1.Name = "IndicatorButton"
    v1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    v1.AnchorPoint = Vector2.new(0.5, 0.5)
    v1.BorderSizePixel = 0
    v1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    v1.Parent = Frame
    local GuiService = game:GetService("GuiService")
    local GamepadService = game:GetService("GamepadService")
    local v2 = a0:getInstance("ClickRegion")

    local function selectionChanged() --[[ Upvalues: GuiService (copy), v2 (copy), v1 (copy) ]]
        if GuiService.SelectedObject == v2 then
            v1.BackgroundTransparency = 1
            v1.Position = UDim2.new(0.5, -2, 0.5, 0)
            v1.Size = UDim2.fromScale(1.2, 1.2)
            return
        end

        v1.BackgroundTransparency = 0.75
        v1.Position = UDim2.new(0.5, 2, 0.5, 0)
        v1.Size = UDim2.fromScale(1, 1)
    end

    local v3 = GuiService:GetPropertyChangedSignal("SelectedObject")
    local v4 = v3:Connect(selectionChanged)
    a0.janitor:add(v4)
    selectionChanged()
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.LayoutOrder = 2
    ImageLabel.ZIndex = 15
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    ImageLabel.Image = "rbxasset://textures/ui/Controls/XboxController/DPadUp@2x.png"
    ImageLabel.Parent = v1
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = v1
    local UserInputService = game:GetService("UserInputService")

    local function setIndicatorVisible(a0) --[[ Upvalues: Frame (copy), GamepadService (copy), a0 (copy) ]]
        if a0 == nil then
            a0 = Frame.Visible
        end

        if GamepadService.GamepadCursorEnabled then
            a0 = false
        end

        if a0 then
            local v6 = {"PaddingRight", "Size", UDim2.new(0, 0, 1, 0)}
            a0:modifyTheme(v6, "IndicatorPadding")
        else
            if Frame.Visible then
                a0:removeModification("IndicatorPadding")
            end
        end

        local v7 = {"Indicator", "Visible", a0}
        a0:modifyTheme(v7)
        a0.updateSize:Fire()
    end

    local v8 = GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled")
    local v9 = v8:Connect(setIndicatorVisible)
    a0.janitor:add(v9)
    a0.indicatorSet:Connect(function(a0) --[[ Upvalues: ImageLabel (copy), UserInputService (copy), setIndicatorVisible (copy) ]]
        local v10 = false
        if a0 then
            ImageLabel.Image = UserInputService:GetImageForKeyCode(a0)
            v10 = true
        end

        setIndicatorVisible(v10)
    end)

    local function updateSize() --[[ Upvalues: widget (copy), Frame (copy) ]]
        local v11 = widget.AbsoluteSize.Y * 0.96
        Frame.Size = UDim2.new(0, v11, 0, v11)
    end

    local v12 = widget:GetPropertyChangedSignal("AbsoluteSize")
    v12:Connect(updateSize)
    local v13 = widget.AbsoluteSize.Y * 0.96
    Frame.Size = UDim2.new(0, v13, 0, v13)
    return Frame
end
