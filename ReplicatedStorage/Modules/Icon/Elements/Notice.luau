
return function(a0, a1)
    local Frame = Instance.new("Frame")
    Frame.Name = "Notice"
    Frame.ZIndex = 25
    Frame.AutomaticSize = Enum.AutomaticSize.X
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.BackgroundTransparency = 0.1
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame.Visible = false
    Frame.Parent = a0.widget
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame
    Instance.new("UIStroke").Parent = Frame
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "NoticeLabel"
    TextLabel.ZIndex = 26
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.AutomaticSize = Enum.AutomaticSize.X
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0.5, 0, 0.515, 0)
    TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.FontSize = Enum.FontSize.Size14
    TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.Text = "1"
    TextLabel.TextWrapped = true
    TextLabel.TextWrap = true
    TextLabel.Font = Enum.Font.Arial
    TextLabel.Parent = Frame
    local Parent = script.Parent.Parent
    local Packages = Parent.Packages
    local v1 = require(Packages.Janitor)
    local v2 = require(Packages.GoodSignal)
    Packages = require(Parent.Utility)
    a0.noticeChanged:Connect(function(a0) --[[ Upvalues: TextLabel (copy), a1 (copy), a0 (copy), Packages (copy), Frame (copy) ]]
        if not a0 then
            return
        end

        local v3 = 99 < a0
        local v4
        if v3 then
            v4 = "99+"
        else
            v4 = a0
        end

        TextLabel.Text = v4
        if v3 then
            TextLabel.TextSize = 11
        end

        v4 = true
        if a0 < 1 then
            v4 = false
        end

        v3 = a1.getIconByUID(a0.parentIconUID)
        local v5 = true
        local v6 = #a0.dropdownIcons
        if 0 >= v6 then
            v6 = #a0.menuIcons
            v5 = 0 < v6
        end

        if a0.isSelected and v5 then
            v4 = false
        else
            if v3 and not v3.isSelected then
                v4 = false
            end
        end

        Packages.setVisible(Frame, v4, "NoticeHandler")
    end)
    a0.noticeStarted:Connect(function(a0, a1) --[[ Upvalues: a0 (copy), a1 (copy), v1 (copy), v2 (copy), Packages (copy) ]]
        local v7 = a0 or a0.deselected
        local v8 = a1.getIconByUID(a0.parentIconUID)
        if v8 then
            v8:notify(v7)
        end

        local v9 = v1.new()
        local v10 = a0.janitor:add(v9)
        local v11 = v2.new()
        local v12 = v10:add(v11)
        local v13 = a0.endNotices:Connect(function() --[[ Upvalues: v12 (copy) ]]
            v12:Fire()
        end)
        v10:add(v13)
        local v14 = v7:Connect(function() --[[ Upvalues: v12 (copy) ]]
            v12:Fire()
        end)
        v10:add(v14)
        local v17 = a1 or Packages.generateUID()
        a1 = v17
        local v18 = {completeSignal = v12, clearNoticeEvent = v7}
        a0.notices[a1] = v18

        local function updateNotice() --[[ Upvalues: a0 (upvalue) ]]
            a0.noticeChanged:Fire(a0.totalNotices)
        end

        a0.notified:Fire(a1)
        local v19 = a0
        v19.totalNotices = v19.totalNotices + 1
        a0.noticeChanged:Fire(a0.totalNotices)
        v12:Once(function() --[[ Upvalues: v10 (copy), a0 (upvalue), a1 (ref) ]]
            v10:destroy()
            local v20 = a0
            v20.totalNotices = v20.totalNotices - 1
            a0.notices[a1] = nil
            a0.noticeChanged:Fire(a0.totalNotices)
        end)
    end)
    Frame:SetAttribute("ClipToJoinedParent", true)
    a0:clipOutside(Frame)
    return Frame
end
