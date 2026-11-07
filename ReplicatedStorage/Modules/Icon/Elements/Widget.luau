
return function(a0, a1)
    local Frame = Instance.new("Frame")
    Frame:SetAttribute("WidgetUID", a0.UID)
    Frame.Name = "Widget"
    Frame.BackgroundTransparency = 1
    Frame.Visible = true
    Frame.ZIndex = 20
    Frame.Active = false
    Frame.ClipsDescendants = true
    local Frame1 = Instance.new("Frame")
    Frame1.Name = "IconButton"
    Frame1.Visible = true
    Frame1.ZIndex = 2
    Frame1.BorderSizePixel = 0
    Frame1.Parent = Frame
    Frame1.ClipsDescendants = true
    Frame1.Active = false
    a0.deselected:Connect(function() --[[ Upvalues: Frame1 (copy), a0 (copy) ]]
        Frame1.ClipsDescendants = true
        task.delay(0.2, function() --[[ Upvalues: a0 (upvalue), Frame1 (upvalue) ]]
            if a0.isSelected then
                Frame1.ClipsDescendants = false
            end

        end)
    end)
    local GuiService = game:GetService("GuiService")
    a0:setBehaviour("IconButton", "BackgroundTransparency", function(a0) --[[ Upvalues: GuiService (copy) ]]
        if a0 == 1 then
            return a0
        end

        return a0 * GuiService.PreferredTransparency
    end)
    local v1 = GuiService:GetPropertyChangedSignal("PreferredTransparency")
    local v2 = v1:Connect(function() --[[ Upvalues: a0 (copy), Frame1 (copy) ]]
        a0:refreshAppearance(Frame1, "BackgroundTransparency")
    end)
    a0.janitor:add(v2)
    local UICorner = Instance.new("UICorner")
    UICorner:SetAttribute("Collective", "IconCorners")
    UICorner.Name = "UICorner"
    UICorner.Parent = Frame1
    local v3 = require(script.Parent.Menu)
    local v4 = v3(a0)
    local MenuUIListLayout = v4.MenuUIListLayout
    local MenuGap = v4.MenuGap
    v4.Parent = Frame1
    local Frame2 = Instance.new("Frame")
    Frame2.Name = "IconSpot"
    Frame2.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
    Frame2.BackgroundTransparency = 0.9
    Frame2.Visible = true
    Frame2.AnchorPoint = Vector2.new(0, 0.5)
    Frame2.ZIndex = 5
    Frame2.Parent = v4
    UICorner:Clone().Parent = Frame2
    local v5 = Frame2:Clone()
    v5.UICorner.Name = "OverlayUICorner"
    v5.Name = "IconOverlay"
    v5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    v5.ZIndex = Frame2.ZIndex + 1
    v5.Size = UDim2.new(1, 0, 1, 0)
    v5.Position = UDim2.new(0, 0, 0, 0)
    v5.AnchorPoint = Vector2.new(0, 0)
    v5.Visible = false
    v5.Parent = Frame2
    local TextButton = Instance.new("TextButton")
    TextButton:SetAttribute("CorrespondingIconUID", a0.UID)
    TextButton.Name = "ClickRegion"
    TextButton.BackgroundTransparency = 1
    TextButton.Visible = true
    TextButton.Text = ""
    TextButton.ZIndex = 20
    TextButton.Selectable = true
    TextButton.SelectionGroup = true
    TextButton.Parent = Frame2
    require(script.Parent.Parent.Features.Gamepad).registerButton(TextButton)
    UICorner:Clone().Parent = TextButton
    local Frame3 = Instance.new("Frame")
    Frame3.Name = "Contents"
    Frame3.BackgroundTransparency = 1
    Frame3.Size = UDim2.fromScale(1, 1)
    Frame3.Parent = Frame2
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Name = "ContentsList"
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.VerticalFlex = Enum.UIFlexAlignment.SpaceEvenly
    UIListLayout.Padding = UDim.new(0, 3)
    UIListLayout.Parent = Frame3
    local Frame4 = Instance.new("Frame")
    Frame4.Name = "PaddingLeft"
    Frame4.LayoutOrder = 1
    Frame4.ZIndex = 5
    Frame4.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame4.BackgroundTransparency = 1
    Frame4.BorderSizePixel = 0
    Frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame4.Parent = Frame3
    local Frame5 = Instance.new("Frame")
    Frame5.Name = "PaddingCenter"
    Frame5.LayoutOrder = 3
    Frame5.ZIndex = 5
    Frame5.Size = UDim2.new(0, 0, 1, 0)
    Frame5.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame5.BackgroundTransparency = 1
    Frame5.BorderSizePixel = 0
    Frame5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame5.Parent = Frame3
    local Frame6 = Instance.new("Frame")
    Frame6.Name = "PaddingRight"
    Frame6.LayoutOrder = 5
    Frame6.ZIndex = 5
    Frame6.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame6.BackgroundTransparency = 1
    Frame6.BorderSizePixel = 0
    Frame6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame6.Parent = Frame3
    local Frame7 = Instance.new("Frame")
    Frame7.Name = "IconLabelContainer"
    Frame7.LayoutOrder = 4
    Frame7.ZIndex = 3
    Frame7.AnchorPoint = Vector2.new(0, 0.5)
    Frame7.Size = UDim2.new(0, 0, 0.5, 0)
    Frame7.BackgroundTransparency = 1
    Frame7.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame7.Parent = Frame3
    local TextLabel = Instance.new("TextLabel")
    local v6 = workspace.CurrentCamera.ViewportSize.X + 200
    TextLabel.Name = "IconLabel"
    TextLabel.LayoutOrder = 4
    TextLabel.ZIndex = 15
    TextLabel.AnchorPoint = Vector2.new(0, 0)
    TextLabel.Size = UDim2.new(0, v6, 1, 0)
    TextLabel.ClipsDescendants = false
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.fromScale(0, 0)
    TextLabel.RichText = true
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Text = ""
    TextLabel.TextWrapped = true
    TextLabel.TextWrap = true
    TextLabel.TextScaled = false
    TextLabel.Active = false
    TextLabel.AutoLocalize = true
    TextLabel.Parent = Frame7
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "IconImage"
    ImageLabel.LayoutOrder = 2
    ImageLabel.ZIndex = 15
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
    ImageLabel.Size = UDim2.new(0, 0, 0.5, 0)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.new(0, 11, 0.5, 0)
    ImageLabel.ScaleType = Enum.ScaleType.Stretch
    ImageLabel.Active = false
    ImageLabel.Parent = Frame3
    local v7 = UICorner:Clone()
    v7:SetAttribute("Collective", nil)
    v7.CornerRadius = UDim.new(0, 0)
    v7.Name = "IconImageCorner"
    v7.Parent = ImageLabel
    local TweenService = game:GetService("TweenService")
    local v8 = 0

    local function handleLabelAndImageChangesUnstaggered(a0) --[[ Upvalues: a0 (copy), TextLabel (copy), ImageLabel (copy), Frame7 (copy), Frame4 (copy), Frame5 (copy), Frame6 (copy), Frame1 (copy), UIListLayout (copy), Frame3 (copy), Frame (copy), v6 (copy), v4 (copy), Frame2 (copy), MenuUIListLayout (copy), MenuGap (copy), TweenService (copy), TextButton (copy), v8 (ref), a1 (copy) ]]
        task.defer(function() --[[ Upvalues: a0 (upvalue), TextLabel (upvalue), ImageLabel (upvalue), Frame7 (upvalue), Frame4 (upvalue), Frame5 (upvalue), Frame6 (upvalue), Frame1 (upvalue), UIListLayout (upvalue), Frame3 (upvalue), Frame (upvalue), v6 (upvalue), v4 (upvalue), Frame2 (upvalue), MenuUIListLayout (upvalue), MenuGap (upvalue), TweenService (upvalue), TextButton (upvalue), v8 (upvalue), a1 (upvalue) ]]
            local indicator = a0.indicator
            local v10 = indicator and indicator.Visible
            indicator = v10
            if not indicator then
                indicator = TextLabel.Text ~= ""
            end

            local v11 = false
            if ImageLabel.Image ~= "" then
                v11 = ImageLabel.Image ~= nil
            end

            local v12 = UDim2.fromScale(1, 1)
            if v11 and not indicator then
                Frame7.Visible = false
                ImageLabel.Visible = true
                Frame4.Visible = false
                Frame5.Visible = false
                Frame6.Visible = false
            else
                if not v11 and indicator then
                    Frame7.Visible = true
                    ImageLabel.Visible = false
                    Frame4.Visible = true
                    Frame5.Visible = false
                    Frame6.Visible = true
                else
                    if v11 and indicator then
                        Frame7.Visible = true
                        ImageLabel.Visible = true
                        Frame4.Visible = true
                        Frame5.Visible = not v10
                        Frame6.Visible = not v10
                    end
                end
            end

            Frame1.Size = v12

            local function getItemWidth(a0)
                local v14 = a0:GetAttribute("TargetWidth") or a0.AbsoluteSize.X
                return v14
            end

            local Offset = UIListLayout.Padding.Offset
            v11 = Offset
            Frame7.Size = UDim2.new(0, TextLabel.TextBounds.X, TextLabel.Size.Y.Scale, 0)
            local v15 = Frame3:GetChildren()
            for k1, k2 in pairs(v15) do
                if k2:IsA("GuiObject") then
                    if k2.Visible == true then
                        local v20 = k2:GetAttribute("TargetWidth") or k2.AbsoluteSize.X
                        v11 = v11 + (v20 + Offset)
                    end
                end
            end

            Offset = Frame:GetAttribute("MinimumWidth")
            indicator = Frame:GetAttribute("MinimumHeight")
            local v21 = Frame:GetAttribute("BorderSize")
            local v22 = math.clamp(v11, Offset, v6)
            local v23 = 0
            local v25 = 0 < #a0.menuIcons and a0.isSelected
            if v25 then
                local v26 = v4:GetChildren()
                for k3, k4 in pairs(v26) do
                    if k4 ~= Frame2 then
                        if k4:IsA("GuiObject") then
                            if k4.Visible then
                                local v31 = k4:GetAttribute("TargetWidth") or k4.AbsoluteSize.X
                                v23 = v23 + (v31 + MenuUIListLayout.Padding.Offset)
                            end
                        end
                    end
                end

                if not Frame2.Visible then
                    k3 = Frame2
                    local v33 = k3:GetAttribute("TargetWidth") or k3.AbsoluteSize.X
                    v22 = v22 - (v33 + MenuUIListLayout.Padding.Offset * 2 + v21)
                end

                v23 = v23 - v21 * 0.5
                v22 = v22 + (v23 - v21 * 0.75)
            end

            local v35 = v25 and Frame2.Visible
            MenuGap.Visible = v35
            local v36 = Frame:GetAttribute("DesiredWidth")
            if v36 and v22 < v36 then
                v22 = v36
            end

            a0.updateMenu:Fire()
            local v37 = math.max(v22 - v23, Offset)
            v23 = v37 - v21 * 2
            local v38 = v4:GetAttribute("MenuWidth")
            local v40 = v38 and v38 + v23 + MenuUIListLayout.Padding.Offset + 10
            if v40 then
                local v41 = v4:GetAttribute("MaxWidth")
                if v41 then
                    v40 = math.max(v41, Offset)
                end

                v4:SetAttribute("MenuCanvasWidth", v22)
                if v40 < v22 then
                    v22 = v40
                end
            end

            Offset = Enum.EasingStyle.Quint
            v40 = Enum.EasingDirection.Out
            local v42 = Frame2
            local v44 = v42:GetAttribute("TargetWidth") or v42.AbsoluteSize.X
            local v45 = math.max(v23, v44, Frame2.AbsoluteSize.X)
            local v46 = Frame
            local v48 = v46:GetAttribute("TargetWidth") or v46.AbsoluteSize.X
            local v49 = math.max(v22, v48, Frame.AbsoluteSize.X)
            getItemWidth = TweenInfo.new(v45 / 750, Offset, v40)
            v45 = TweenInfo.new(v49 / 750, Offset, v40)
            local v50 = {
                Position = UDim2.new(0, v21, 0.5, 0),
                Size = UDim2.new(0, v23, 1, -v21 * 2)
            }
            TweenService:Create(Frame2, getItemWidth, v50):Play()
            v50 = {Size = UDim2.new(0, v23, 1, 0)}
            TweenService:Create(TextButton, getItemWidth, v50):Play()
            local v51 = UDim2.fromOffset(v22, indicator)
            if Frame.Size.Y.Offset ~= indicator then
                Frame.Size = v51
            end

            Frame:SetAttribute("TargetWidth", v51.X.Offset)
            v50 = {Size = v51}
            TweenService:Create(Frame, v45, v50):Play()
            v8 = v8 + 1
            for i1 = 1, v45.Time * 100 do
                task.delay(i1 / 100, function() --[[ Upvalues: a1 (upvalue), a0 (upvalue) ]]
                    a1.iconChanged:Fire(a0)
                end)
            end

            local v54 = v45.Time - 0.2
            task.delay(v54, function() --[[ Upvalues: v8 (upvalue), a0 (upvalue) ]]
                v8 = v8 - 1
                task.defer(function() --[[ Upvalues: v8 (upvalue), a0 (upvalue) ]]
                    if v8 == 0 then
                        a0.resizingComplete:Fire()
                    end

                end)
            end)
            a0:updateParent()
        end)
    end

    local v55 = require(script.Parent.Parent.Utility).createStagger(0.01, handleLabelAndImageChangesUnstaggered)
    a0:setBehaviour("IconLabel", "Text", v55)
    local v56 = true
    a0:setBehaviour("IconLabel", "FontFace", function(a0) --[[ Upvalues: TextLabel (copy), v55 (copy), v56 (ref) ]]
        if TextLabel.FontFace == a0 then
            return
        end

        task.spawn(function() --[[ Upvalues: v55 (upvalue), v56 (upvalue) ]]
            v55()
            if v56 then
                v56 = false
                for i2 = 1, 10 do
                    task.wait(1)
                    v55()
                end
            end

        end)
    end)

    local function updateBorderSize() --[[ Upvalues: Frame (copy), a0 (copy), Frame2 (copy), v4 (copy), MenuGap (copy), MenuUIListLayout (copy), v55 (copy) ]]
        task.defer(function() --[[ Upvalues: Frame (upvalue), a0 (upvalue), Frame2 (upvalue), v4 (upvalue), MenuGap (upvalue), MenuUIListLayout (upvalue), v55 (upvalue) ]]
            local v59 = Frame:GetAttribute("BorderSize")
            local v60
            if Frame2.Visible == false then
                v60 = 0
            end

            v4.Position = UDim2.new(0, v60, 0, 0)
            MenuGap.Size = UDim2.fromOffset(v59, 0)
            MenuUIListLayout.Padding = UDim.new(0, 0)
            v55()
        end)
    end

    a0:setBehaviour("Widget", "BorderSize", updateBorderSize)
    a0:setBehaviour("IconSpot", "Visible", updateBorderSize)
    a0.startMenuUpdate:Connect(v55)
    a0.updateSize:Connect(v55)
    a0:setBehaviour("ContentsList", "HorizontalAlignment", v55)
    a0:setBehaviour("Widget", "Visible", v55)
    a0:setBehaviour("Widget", "DesiredWidth", v55)
    a0:setBehaviour("Widget", "MinimumWidth", v55)
    a0:setBehaviour("Widget", "MinimumHeight", v55)
    a0:setBehaviour("Indicator", "Visible", v55)
    a0:setBehaviour("IconImageRatio", "AspectRatio", v55)
    a0:setBehaviour("IconImage", "Image", function(a0) --[[ Upvalues: ImageLabel (copy), v55 (copy) ]]
        local v63
        if not (tonumber(a0) and "http://www.roblox.com/asset/?id=" .. a0) then
            local v65 = a0 or ""
        end

        if ImageLabel.Image ~= v63 then
            v55()
        end

        return v63
    end)
    a0.alignmentChanged:Connect(function(a0) --[[ Upvalues: MenuUIListLayout (copy), Frame (copy), a0 (copy), Frame2 (copy), v4 (copy), MenuGap (copy), v55 (copy) ]]
        if a0 == "Center" then
            a0 = "Left"
        end

        MenuUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment[a0]
        task.defer(function() --[[ Upvalues: Frame (upvalue), a0 (upvalue), Frame2 (upvalue), v4 (upvalue), MenuGap (upvalue), MenuUIListLayout (upvalue), v55 (upvalue) ]]
            local v66 = Frame:GetAttribute("BorderSize")
            local v67
            if Frame2.Visible == false then
                v67 = 0
            end

            v4.Position = UDim2.new(0, v67, 0, 0)
            MenuGap.Size = UDim2.fromOffset(v66, 0)
            MenuUIListLayout.Padding = UDim.new(0, 0)
            v55()
        end)
    end)
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local v69 = LocalPlayer:GetPropertyChangedSignal("LocaleId")
    local LocaleId = LocalPlayer.LocaleId
    local v70 = v69:Connect(function() --[[ Upvalues: LocalPlayer (copy), LocaleId (ref), a0 (copy) ]]
        task.delay(0.2, function() --[[ Upvalues: LocalPlayer (upvalue), LocaleId (upvalue), a0 (upvalue) ]]
            local LocaleId1 = LocalPlayer.LocaleId
            if LocaleId1 ~= LocaleId then
                LocaleId = LocaleId1
                a0:refresh()
                task.wait(0.5)
                a0:refresh()
            end

        end)
    end)
    a0.janitor:add(v70)
    local NumberValue = Instance.new("NumberValue")
    NumberValue.Name = "IconImageScale"
    NumberValue.Parent = ImageLabel
    local v71 = NumberValue:GetPropertyChangedSignal("Value")
    v71:Connect(function() --[[ Upvalues: ImageLabel (copy), NumberValue (copy) ]]
        ImageLabel.Size = UDim2.new(NumberValue.Value, 0, NumberValue.Value, 0)
    end)
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    UIAspectRatioConstraint.Name = "IconImageRatio"
    UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
    UIAspectRatioConstraint.Parent = ImageLabel
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Name = "IconGradient"
    UIGradient.Enabled = true
    UIGradient.Parent = Frame1
    local UIGradient1 = Instance.new("UIGradient")
    UIGradient1.Name = "IconSpotGradient"
    UIGradient1.Enabled = true
    UIGradient1.Parent = Frame2
    return Frame
end
