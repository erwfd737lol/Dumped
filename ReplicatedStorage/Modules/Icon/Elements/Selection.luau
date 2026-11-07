
return function(a0)
    local Frame = Instance.new("Frame")
    Frame.Name = "SelectionContainer"
    Frame.Visible = false
    local Frame1 = Instance.new("Frame")
    Frame1.Name = "Selection"
    Frame1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame1.BackgroundTransparency = 1
    Frame1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame1.BorderSizePixel = 0
    Frame1.Parent = Frame
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Name = "UIStroke"
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 3
    UIStroke.Parent = Frame1
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Name = "SelectionGradient"
    UIGradient.Parent = UIStroke
    UIStroke = Instance.new("UICorner")
    UIStroke:SetAttribute("Collective", "IconCorners")
    UIStroke.Name = "UICorner"
    UIStroke.CornerRadius = UDim.new(1, 0)
    UIStroke.Parent = Frame1
    UIStroke = game:GetService("RunService")
    local GuiService = game:GetService("GuiService")
    local v1 = 1
    local v2 = Frame1:GetAttributeChangedSignal("RotationSpeed")
    v2:Connect(function() --[[ Upvalues: v1 (ref), Frame1 (copy) ]]
        v1 = Frame1:GetAttribute("RotationSpeed")
    end)
    UIStroke.Heartbeat:Connect(function() --[[ Upvalues: GuiService (copy), UIGradient (copy), v1 (ref) ]]
        if not GuiService.SelectedObject then
            return
        end

        UIGradient.Rotation = os.clock() * v1 * 100 % 360
    end)
    return Frame
end
