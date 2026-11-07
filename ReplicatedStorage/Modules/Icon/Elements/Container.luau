
local v1 = false
local v2 = 0
return function(a0) --[[ Upvalues: v1 (ref), v2 (ref) ]]
    local GuiService = game:GetService("GuiService")
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local v3 = require(script.Parent.Parent.Packages.GoodSignal).new()
    local v4 = GuiService:GetGuiInset()
    local v5 = 0
    local v6 = 0
    local v7 = 0
    local v8 = false
    local v9 = false
    local v10 = 0

    local function checkInset(a0) --[[ Upvalues: GuiService (copy), v8 (ref), v9 (ref), UserInputService (copy), a0 (copy), v10 (ref), checkInset (copy), Players (copy), v1 (upvalue), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v3 (copy), v2 (upvalue) ]]
        local Height = GuiService.TopbarInset.Height
        local v11 = Height <= 36
        v8 = GuiService:IsTenFootInterface()
        v9 = UserInputService.VREnabled
        a0.isOldTopbar = v11
        v10 = v10 + 1
        if Height == 0 and a0 == nil then
            task.defer(function() --[[ Upvalues: checkInset (upvalue) ]]
                task.wait(8)
                checkInset("ForceConvertToOld")
            end)
        else
            if v10 == 1 then
                task.delay(5, function() --[[ Upvalues: Players (upvalue), v10 (upvalue), checkInset (upvalue) ]]
                    Players.LocalPlayer:WaitForChild("PlayerGui")
                    if v10 == 1 then
                        checkInset()
                    end

                end)
            end
        end

        if a0.isOldTopbar then
            if not v8 then
                if not v9 then
                    if v1 == false then
                        if Height ~= 0 or a0 == "ForceConvertToOld" then
                            v1 = true
                            task.defer(function() --[[ Upvalues: a0 (upvalue), GuiService (upvalue) ]]
                                local v12 = require(script.Parent.Parent.Features.Themes.Classic)
                                a0.modifyBaseTheme(v12)

                                local function decideToHideTopbar() --[[ Upvalues: GuiService (upvalue), a0 (upvalue) ]]
                                    if GuiService.MenuIsOpen then
                                        a0.setTopbarEnabled(false, true)
                                        return
                                    end

                                    a0.setTopbarEnabled()
                                end

                                local v13 = GuiService:GetPropertyChangedSignal("MenuIsOpen")
                                v13:Connect(decideToHideTopbar)
                                if GuiService.MenuIsOpen then
                                    a0.setTopbarEnabled(false, true)
                                    return
                                end

                                a0.setTopbarEnabled()
                            end)
                        end
                    end
                end
            end
        end

        v4 = GuiService:GetGuiInset()
        local v14
        if v11 then
            v14 = 12
        else
            v14 = v4.Y - 50
        end

        v5 = v14
        if v11 then
            v14 = 2
        else
            v14 = 0
        end

        v6 = v14
        v7 = -2
        if v8 then
            v5 = 10
            v6 = 0
        end

        if GuiService.TopbarInset.Height == 0 and not v1 then
            v6 = v6 + 13
            v7 = 50
        end

        v3:Fire(v4)
        local Y = v4.Y
        if Y ~= v2 then
            v2 = Y
            task.defer(function() --[[ Upvalues: a0 (upvalue), Y (copy) ]]
                a0.insetHeightChanged:Fire(Y)
            end)
        end
    end

    local v15 = GuiService:GetPropertyChangedSignal("TopbarInset")
    local v16 = {}
    v15:Connect(checkInset)
    checkInset("FirstTime")
    local ScreenGui = Instance.new("ScreenGui")
    v3:Connect(function() --[[ Upvalues: ScreenGui (copy), v5 (ref) ]]
        ScreenGui:SetAttribute("StartInset", v5)
    end)
    ScreenGui.Name = "TopbarStandard"
    ScreenGui.Enabled = true
    ScreenGui.DisplayOrder = a0.baseDisplayOrder
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets
    v16[ScreenGui.Name] = ScreenGui
    a0.baseDisplayOrderChanged:Connect(function() --[[ Upvalues: ScreenGui (copy), a0 (copy) ]]
        ScreenGui.DisplayOrder = a0.baseDisplayOrder
    end)
    local Frame = Instance.new("Frame")
    Frame.Name = "Holders"
    Frame.BackgroundTransparency = 1
    v3:Connect(function() --[[ Upvalues: v9 (ref), v8 (ref), v7 (ref), Frame (copy), v6 (ref) ]]
        local v17
        if v9 then
            v17 = 36
        else
            v17 = 56
        end

        local v18
        if v8 then
            local v19 = UDim2.new(1, 0, 0, v17)
        else
            local v20 = UDim2.new(1, 0, 1, v7)
        end

        Frame.Position = UDim2.new(0, 0, 0, v6)
        Frame.Size = v18
    end)
    Frame.Visible = true
    Frame.ZIndex = 1
    Frame.Parent = ScreenGui
    local v21 = ScreenGui:Clone()
    local Holders = v21.Holders

    local function updateCenteredHoldersHeight() --[[ Upvalues: Holders (copy), GuiService (copy), v7 (ref) ]]
        Holders.Size = UDim2.new(1, 0, 0, GuiService.TopbarInset.Height + v7)
    end

    v21.Name = "TopbarCentered"
    v21.DisplayOrder = a0.baseDisplayOrder
    v21.ScreenInsets = Enum.ScreenInsets.None
    a0.baseDisplayOrderChanged:Connect(function() --[[ Upvalues: v21 (copy), a0 (copy) ]]
        v21.DisplayOrder = a0.baseDisplayOrder
    end)
    v16[v21.Name] = v21
    v3:Connect(updateCenteredHoldersHeight)
    Holders.Size = UDim2.new(1, 0, 0, GuiService.TopbarInset.Height + v7)
    local v22 = ScreenGui:Clone()
    v22.Name = v22.Name .. "Clipped"
    v22.DisplayOrder = a0.baseDisplayOrder + 1
    a0.baseDisplayOrderChanged:Connect(function() --[[ Upvalues: v22 (copy), a0 (copy) ]]
        v22.DisplayOrder = a0.baseDisplayOrder + 1
    end)
    v16[v22.Name] = v22
    local v23 = v21:Clone()
    v23.Name = v23.Name .. "Clipped"
    v23.DisplayOrder = a0.baseDisplayOrder + 1
    a0.baseDisplayOrderChanged:Connect(function() --[[ Upvalues: v23 (copy), a0 (copy) ]]
        v23.DisplayOrder = a0.baseDisplayOrder + 1
    end)
    v16[v23.Name] = v23
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame:SetAttribute("IsAHolder", true)
    ScrollingFrame.Name = "Left"
    v3:Connect(function() --[[ Upvalues: ScrollingFrame (copy), v5 (ref) ]]
        ScrollingFrame.Position = UDim2.fromOffset(v5, 0)
    end)
    ScrollingFrame.Size = UDim2.new(1, -24, 1, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.Visible = true
    ScrollingFrame.ZIndex = 1
    ScrollingFrame.Active = false
    ScrollingFrame.ClipsDescendants = true
    ScrollingFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.None
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 1, -1)
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
    ScrollingFrame.ScrollBarThickness = 0
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Selectable = false
    ScrollingFrame.ScrollingEnabled = false
    ScrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Never
    ScrollingFrame.Parent = Frame
    local UIListLayout = Instance.new("UIListLayout")
    v3:Connect(function() --[[ Upvalues: UIListLayout (copy), v5 (ref) ]]
        UIListLayout.Padding = UDim.new(0, v5)
    end)
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    UIListLayout.Parent = ScrollingFrame
    local v24 = ScrollingFrame:Clone()
    v3:Connect(function() --[[ Upvalues: v24 (copy), v5 (ref) ]]
        v24.UIListLayout.Padding = UDim.new(0, v5)
    end)
    v24.ScrollingEnabled = false
    v24.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    v24.Name = "Center"
    v24.Parent = Holders
    local v25 = ScrollingFrame:Clone()
    v3:Connect(function() --[[ Upvalues: v25 (copy), v5 (ref) ]]
        v25.UIListLayout.Padding = UDim.new(0, v5)
    end)
    v25.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    v25.Name = "Right"
    v25.AnchorPoint = Vector2.new(1, 0)
    v25.Position = UDim2.new(1, -12, 0, 0)
    v25.Parent = Frame
    v3:Fire(v4)
    return v16
end
