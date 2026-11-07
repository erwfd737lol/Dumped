
local v1 = Color3.fromRGB(39, 41, 48)
return function(a0) --[[ Upvalues: v1 (copy) ]]
    local v2 = a0:getInstance("ClickRegion")
    local CanvasGroup = Instance.new("CanvasGroup")
    CanvasGroup.Name = "Caption"
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0)
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.BorderSizePixel = 0
    CanvasGroup.GroupTransparency = 1
    CanvasGroup.Position = UDim2.fromOffset(0, 0)
    CanvasGroup.Visible = true
    CanvasGroup.ZIndex = 30
    CanvasGroup.Parent = v2
    local Frame = Instance.new("Frame")
    Frame.Name = "Box"
    Frame.AutomaticSize = Enum.AutomaticSize.XY
    Frame.BackgroundColor3 = v1
    Frame.Position = UDim2.fromOffset(4, 7)
    Frame.ZIndex = 12
    Frame.Parent = CanvasGroup
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Header"
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    TextLabel.Text = "Caption"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 15
    TextLabel.TextTruncate = Enum.TextTruncate.None
    TextLabel.TextWrapped = false
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutomaticSize = Enum.AutomaticSize.X
    TextLabel.BackgroundTransparency = 1
    TextLabel.LayoutOrder = 1
    TextLabel.Size = UDim2.fromOffset(0, 16)
    TextLabel.ZIndex = 18
    TextLabel.Parent = Frame
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Name = "Layout"
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Frame
    local UICorner = Instance.new("UICorner")
    UICorner.Name = "CaptionCorner"
    UICorner.Parent = Frame
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Name = "Padding"
    UIPadding.PaddingBottom = UDim.new(0, 12)
    UIPadding.PaddingLeft = UDim.new(0, 12)
    UIPadding.PaddingRight = UDim.new(0, 12)
    UIPadding.PaddingTop = UDim.new(0, 12)
    UIPadding.Parent = Frame
    local Frame1 = Instance.new("Frame")
    Frame1.Name = "Hotkeys"
    Frame1.AutomaticSize = Enum.AutomaticSize.Y
    Frame1.BackgroundTransparency = 1
    Frame1.LayoutOrder = 3
    Frame1.Size = UDim2.fromScale(1, 0)
    Frame1.Visible = false
    Frame1.Parent = Frame
    local UIListLayout1 = Instance.new("UIListLayout")
    UIListLayout1.Name = "Layout1"
    UIListLayout1.Padding = UDim.new(0, 6)
    UIListLayout1.FillDirection = Enum.FillDirection.Vertical
    UIListLayout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout1.HorizontalFlex = Enum.UIFlexAlignment.None
    UIListLayout1.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    UIListLayout1.VerticalFlex = Enum.UIFlexAlignment.None
    UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout1.Parent = Frame1
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "Key1"
    ImageLabel.Image = "rbxasset://textures/ui/Controls/key_single.png"
    ImageLabel.ImageTransparency = 0.7
    ImageLabel.ScaleType = Enum.ScaleType.Slice
    ImageLabel.SliceCenter = Rect.new(5, 5, 23, 24)
    ImageLabel.AutomaticSize = Enum.AutomaticSize.X
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.LayoutOrder = 1
    ImageLabel.Size = UDim2.fromOffset(0, 30)
    ImageLabel.ZIndex = 15
    ImageLabel.Parent = Frame1
    local UIPadding1 = Instance.new("UIPadding")
    UIPadding1.Name = "Inset"
    UIPadding1.PaddingLeft = UDim.new(0, 8)
    UIPadding1.PaddingRight = UDim.new(0, 8)
    UIPadding1.Parent = ImageLabel
    local TextLabel1 = Instance.new("TextLabel")
    TextLabel1.AutoLocalize = false
    TextLabel1.Name = "LabelContent"
    TextLabel1.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    TextLabel1.Text = ""
    TextLabel1.TextColor3 = Color3.fromRGB(189, 190, 190)
    TextLabel1.TextSize = 15
    TextLabel1.AutomaticSize = Enum.AutomaticSize.X
    TextLabel1.BackgroundTransparency = 1
    TextLabel1.Position = UDim2.fromOffset(0, -1)
    TextLabel1.Size = UDim2.fromScale(1, 1)
    TextLabel1.ZIndex = 16
    TextLabel1.Parent = ImageLabel
    ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "Caret"
    ImageLabel.Image = "rbxassetid://101906294438076"
    ImageLabel.ImageColor3 = v1
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.new(0, 0, 0, 4)
    ImageLabel.Size = UDim2.fromOffset(16, 8)
    ImageLabel.ZIndex = 12
    ImageLabel.Parent = CanvasGroup
    local ImageLabel1 = Instance.new("ImageLabel")
    ImageLabel1.Visible = true
    ImageLabel1.Name = "DropShadow"
    ImageLabel1.Image = "rbxassetid://124920646932671"
    ImageLabel1.ImageColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel1.ImageTransparency = 0.45
    ImageLabel1.ScaleType = Enum.ScaleType.Slice
    ImageLabel1.SliceCenter = Rect.new(12, 12, 13, 13)
    ImageLabel1.BackgroundTransparency = 1
    ImageLabel1.Position = UDim2.fromOffset(0, 5)
    ImageLabel1.Size = UDim2.new(1, 0, 0, 48)
    ImageLabel1.Parent = CanvasGroup
    local v3 = Frame:GetPropertyChangedSignal("AbsoluteSize")
    v3:Connect(function() --[[ Upvalues: ImageLabel1 (copy), Frame (copy) ]]
        ImageLabel1.Size = UDim2.new(1, 0, 0, Frame.AbsoluteSize.Y + 8)
    end)
    local captionJanitor = a0.captionJanitor
    local v4, v5 = a0:clipOutside(CanvasGroup)
    v5.AutomaticSize = Enum.AutomaticSize.None

    local function matchSize() --[[ Upvalues: CanvasGroup (copy), v5 (copy) ]]
        local AbsoluteSize = CanvasGroup.AbsoluteSize
        v5.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)
    end

    local v6 = CanvasGroup:GetPropertyChangedSignal("AbsoluteSize")
    local v7 = v6:Connect(matchSize)
    captionJanitor:add(v7)
    local AbsoluteSize1 = CanvasGroup.AbsoluteSize
    v5.Size = UDim2.fromOffset(AbsoluteSize1.X, AbsoluteSize1.Y)
    AbsoluteSize1 = false
    local Header = CanvasGroup.Box.Header
    local UserInputService = game:GetService("UserInputService")

    local function updateHotkey(a0) --[[ Upvalues: UserInputService (copy), CanvasGroup (copy), a0 (copy), Header (copy), TextLabel1 (copy), Frame1 (copy) ]]
        local KeyboardEnabled = UserInputService.KeyboardEnabled
        local v8 = CanvasGroup:GetAttribute("CaptionText") or ""
        local v9 = v8 == "_hotkey_"
        if not KeyboardEnabled and v9 then
            a0:setCaption()
            return
        end

        Header.Text = v8
        Header.Visible = not v9
        if a0 then
            TextLabel1.Text = a0.Name
            Frame1.Visible = true
        end

        if not KeyboardEnabled then
            Frame1.Visible = false
        end
    end

    local v10 = CanvasGroup:GetAttributeChangedSignal("CaptionText")
    v10:Connect(updateHotkey)
    local Quad = Enum.EasingStyle.Quad
    local v11 = TweenInfo.new(0.2, Quad, Enum.EasingDirection.In)
    local v12 = TweenInfo.new(0.2, Quad, Enum.EasingDirection.Out)
    Quad = game:GetService("TweenService")
    local RunService = game:GetService("RunService")

    local function getCaptionPosition(a0) --[[ Upvalues: AbsoluteSize1 (ref) ]]
        local v13
        if a0 ~= nil then
            v13 = a0
        else
            v13 = AbsoluteSize1
        end

        local v14
        if v13 then
            v14 = 10
        else
            v14 = 2
        end

        local v15 = UDim2.new(0.5, 0, 1, v14)
        return v15
    end

    local function updatePosition(a0) --[[ Upvalues: AbsoluteSize1 (ref), ImageLabel (copy), CanvasGroup (copy), v2 (copy), v5 (copy), v11 (copy), v12 (copy), Quad (copy), RunService (copy) ]]
        if not AbsoluteSize1 then
            return
        end

        local v16
        if a0 ~= nil then
            v16 = a0
        else
            v16 = AbsoluteSize1
        end

        local v17 = not v16
        local v18
        if v17 ~= nil then
            v18 = v17
        else
            v18 = AbsoluteSize1
        end

        local v19
        if v18 then
            v19 = 10
        else
            v19 = 2
        end

        local v20 = UDim2.new(0.5, 0, 1, v19)
        if v16 ~= nil then
            v18 = v16
        else
            v18 = AbsoluteSize1
        end

        if v18 then
            v19 = 10
        else
            v19 = 2
        end

        v17 = UDim2.new(0.5, 0, 1, v19)
        if v16 then
            ImageLabel.Position = UDim2.fromOffset(0, ImageLabel.Position.Y.Offset)
            CanvasGroup.AutomaticSize = Enum.AutomaticSize.XY
            CanvasGroup.Size = UDim2.fromOffset(32, 53)
        else
            v18 = CanvasGroup.AbsoluteSize
            CanvasGroup.AutomaticSize = Enum.AutomaticSize.Y
            CanvasGroup.Size = UDim2.fromOffset(v18.X, v18.Y)
        end

        local function updateCaret() --[[ Upvalues: v2 (upvalue), CanvasGroup (upvalue), ImageLabel (upvalue), v18 (ref) ]]
            local v21 = v2.AbsolutePosition.X - CanvasGroup.AbsolutePosition.X
            local v22 = v21 + v2.AbsoluteSize.X / 2
            local v23 = v22 - ImageLabel.AbsoluteSize.X / 2
            local Offset = ImageLabel.Position.Y.Offset
            local v24 = UDim2.fromOffset(v23, Offset)
            if v18 ~= v23 then
                v18 = v23
                ImageLabel.Position = UDim2.fromOffset(0, Offset)
                task.wait()
            end

            ImageLabel.Position = v24
        end

        v5.Position = v20
        updateCaret()
        local v26 = {Position = v17}
        v16 = Quad:Create(v5, v16 and v11 or v12, v26)
        v17 = RunService.Heartbeat:Connect(updateCaret)
        v16:Play()
        v16.Completed:Once(function() --[[ Upvalues: v17 (copy) ]]
            v17:Disconnect()
        end)
    end

    local v27 = v2:GetPropertyChangedSignal("AbsoluteSize")
    local v28 = v27:Connect(function() --[[ Upvalues: updatePosition (copy) ]]
        updatePosition()
    end)
    captionJanitor:add(v28)
    updatePosition(false)
    local v29 = a0.toggleKeyAdded:Connect(updateHotkey)
    captionJanitor:add(v29)
    for k1, k2 in pairs(a0.bindedToggleKeys) do
        local KeyboardEnabled1 = UserInputService.KeyboardEnabled
        local v33 = CanvasGroup:GetAttribute("CaptionText") or ""
        local v34 = v33 == "_hotkey_"
        if not KeyboardEnabled1 and v34 then
            a0:setCaption()
            break
        end

        Header.Text = v33
        Header.Visible = not v34
        if k1 then
            TextLabel1.Text = k1.Name
            Frame1.Visible = true
        end

        if KeyboardEnabled1 then
            break
        end

        Frame1.Visible = false
        break
    end

    local v35 = a0.fakeToggleKeyChanged:Connect(updateHotkey)
    captionJanitor:add(v35)
    local fakeToggleKey = a0.fakeToggleKey
    if fakeToggleKey then
        local KeyboardEnabled2 = UserInputService.KeyboardEnabled
        v35 = CanvasGroup:GetAttribute("CaptionText") or ""
        local v36 = v35 == "_hotkey_"
        if not KeyboardEnabled2 and v36 then
            a0:setCaption()
        else
            Header.Text = v35
            Header.Visible = not v36
            if fakeToggleKey then
                TextLabel1.Text = fakeToggleKey.Name
                Frame1.Visible = true
            end

            if not KeyboardEnabled2 then
                Frame1.Visible = false
            end
        end
    end

    local function setCaptionEnabled(a0) --[[ Upvalues: AbsoluteSize1 (ref), a0 (copy), v11 (copy), v12 (copy), Quad (copy), CanvasGroup (copy), v5 (copy), updatePosition (copy), UserInputService (copy), Header (copy), Frame1 (copy) ]]
        if AbsoluteSize1 == a0 then
            return
        end

        local joinedFrame = a0.joinedFrame
        if joinedFrame and string.match(joinedFrame.Name, "Dropdown") then
            a0 = false
        end

        AbsoluteSize1 = a0
        if a0 then
            joinedFrame = 0
        else
            joinedFrame = 1
        end

        local v39 = {GroupTransparency = joinedFrame}
        Quad:Create(CanvasGroup, a0 and v11 or v12, v39):Play()
        if a0 then
            v5:SetAttribute("ForceUpdate", true)
        end

        updatePosition()
        local KeyboardEnabled3 = UserInputService.KeyboardEnabled
        local v40 = CanvasGroup:GetAttribute("CaptionText") or ""
        joinedFrame = v40 == "_hotkey_"
        if not KeyboardEnabled3 and joinedFrame then
            a0:setCaption()
            return
        end

        Header.Text = v40
        Header.Visible = not joinedFrame
        if not KeyboardEnabled3 then
            Frame1.Visible = false
        end
    end

    local v41 = require(a0.iconModule)
    local v45 = a0.stateChanged:Connect(function(a0) --[[ Upvalues: v41 (copy), a0 (copy), setCaptionEnabled (copy) ]]
        if a0 == "Viewing" then
            local captionLastClosedClock = v41.captionLastClosedClock
            local v44 = captionLastClosedClock and os.clock() - captionLastClosedClock or 999
            if v44 < 0.3 then
                captionLastClosedClock = 0
            else
                captionLastClosedClock = 0.5
            end

            task.delay(captionLastClosedClock, function() --[[ Upvalues: a0 (upvalue), setCaptionEnabled (upvalue) ]]
                if a0.activeState == "Viewing" then
                    setCaptionEnabled(true)
                end

            end)
            return
        end

        v41.captionLastClosedClock = os.clock()
        setCaptionEnabled(false)
    end)
    captionJanitor:add(v45)
    return CanvasGroup
end
