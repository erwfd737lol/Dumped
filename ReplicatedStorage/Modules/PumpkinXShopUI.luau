
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = require(ReplicatedStorage.Modules.PumpkinXShopLib)
local v2 = require(ReplicatedStorage.Modules.ToolsLib)
local v3 = require(ReplicatedStorage.Modules.SkinsLib)
local v4 = require(ReplicatedStorage.Modules.BaseObjectsLib)
local v5 = Color3.fromRGB(255, 192, 90)

local function formatAmount(a0)
    local v6 = _G.Utl.addComas(tostring(a0))
    return v6
end

local function createPriceDisplay(a0, a1)
    a0.Text = ""
    local Frame = Instance.new("Frame")
    Frame.Name = "PriceDisplay"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.BackgroundTransparency = 1
    Frame.Active = false
    Frame.Parent = a0
    local v7 = a1.HUD and a1.HUD:FindFirstChild("Money")
    local v9 = v7 and v7:FindFirstChild("CandyCorn")
    local v10 = v9 and v9:FindFirstChild("CandyCornIcon")
    local v12
    if not (v10 and v10:Clone()) then
        local ImageLabel = Instance.new("ImageLabel")
    end

    v12:ClearAllChildren()
    v12.Name = "CandyCornIcon"
    v12.Image = v10 and v10.Image or "rbxassetid://88593657959347"
    v12.BackgroundTransparency = 1
    v12.AnchorPoint = Vector2.zero
    v12.Position = UDim2.fromScale(0, 0)
    v12.ScaleType = Enum.ScaleType.Fit
    v12.Active = false
    v12.Selectable = false
    v12.ZIndex = a0.ZIndex + 1
    v12.Parent = Frame
    v10 = Instance.new("TextLabel")
    v10.Name = "Amount"
    v10.BackgroundTransparency = 1
    v10.FontFace = a0.FontFace
    v10.TextColor3 = a0.TextColor3
    v10.TextStrokeColor3 = a0.TextStrokeColor3
    v10.TextStrokeTransparency = a0.TextStrokeTransparency
    v10.TextWrapped = false
    v10.TextScaled = true
    v10.Active = false
    v10.Selectable = false
    v10.ZIndex = v12.ZIndex
    v10.Parent = Frame

    local function layout() --[[ Upvalues: a0 (copy), v10 (copy), Frame (copy), v12 (copy) ]]
        local v14 = math.max(1, a0.AbsoluteSize.Y * 0.84)
        local v15 = v14 * 0.18
        local TextService = game:GetService("TextService")
        local v16 = Vector2.new(10000, v14)
        local v17 = TextService:GetTextSize(v10.Text, v14, a0.Font, v16).X + 2
        local v18 = a0.AbsoluteSize.X * 0.9
        local v19 = math.min(1, v18 / (v14 + v15 + v17))
        v18 = (v14 + v15 + v17) * v19
        Frame.Size = UDim2.fromOffset(v18, v14 * v19)
        v12.Size = UDim2.fromOffset(v14 * v19, v14 * v19)
        local v20 = (v14 + v15) * v19
        v10.Position = UDim2.fromOffset(v20, 0)
        v10.Size = UDim2.fromOffset(v17 * v19, v14 * v19)
    end

    local v21 = a0:GetPropertyChangedSignal("AbsoluteSize")
    v21:Connect(layout)
    local v22 = v10:GetPropertyChangedSignal("Text")
    v22:Connect(layout)
    layout()
end

local function ownedCount(a0, a1)
    if a1.Type == "BaseItem" then
        local BaseItems = a0.Data.BaseItems
        local v25 = BaseItems and BaseItems[a1.Item]
        return math.max(0, math.floor(tonumber(v25) or 0))
    end

    local Skins = a0.Data.Skins
    local v28 = Skins and Skins[a1.Item]
    Skins = 0
    local v29 = v28
    if not v29 then
        v29 = {}
    end

    for k1, k2 in pairs(v29) do
        if k2.Skin == a1.Skin then
            Skins = Skins + 1
        end
    end

    return Skins
end

local function createPreview(a0, a1) --[[ Upvalues: ReplicatedStorage (copy), v4 (copy), v2 (copy), v3 (copy) ]]
    local v33 = a1.Type == "BaseItem"
    local v36 = not v33 and ReplicatedStorage.Objects.Skins:FindFirstChild(a1.Item)
    local v38
    if not (v33 and ReplicatedStorage.BaseObjects:FindFirstChild(a1.Item)) then
        local v40 = v36 and v36:FindFirstChild(a1.Skin)
    end

    local v41
    if not (v33 and v4[a1.Item]) then
        v41 = v2[a1.Item]
    end

    if not (v38 and v41) then
        return
    end

    local v42 = v38:Clone()
    v42.Name = "VPObject"
    v42.Parent = a0
    local v44 = v42:IsA("Model") and v42.PrimaryPart or v42
    if not v44 then
        v42:Destroy()
        return
    end

    v42 = not v33
    if v42 then
        local v45 = v3[a1.Item]
        v42 = v45[a1.Skin]
        if not (v3[a1.Item] and v42) then
            local v47 = v3.Guns and v3.Guns[a1.Skin]
        end
    end

    v33 = Instance.new("Camera")
    v33.CFrame = v44.CFrame * (v42 and v42.ViewportOffset or v41.ViewportOffset)
    v33.Parent = a0
    a0.CurrentCamera = v33
end

local BaseObjectsLib = ReplicatedStorage.Modules.BaseObjectsLib

local function Update(a0) --[[ Upvalues: BaseObjectsLib (copy), v1 (copy), v5 (copy), ownedCount (copy) ]]
    local ShopGui = a0.ShopGui
    if not ShopGui or not a0.ShopArgs or a0.ShopArgs[2] ~= "Pumpkin X" then
        return
    end

    local v48
    if a0.Data.ShopFormat == "Grid" then
        v48 = "Grid"
    else
        v48 = "List"
    end

    if ShopGui:GetAttribute("PumpkinXFormat") ~= v48 then
        BaseObjectsLib.Render(a0)
        return
    end

    local Main = ShopGui.Main
    ShopGui = tonumber(a0.Data.CandyCorn) or 0
    local v49 = ShopGui
    local v50 = _G.Utl.addComas(tostring(v49))
    local v51 = " Candy Corn"
    Main.CandyCornBalance.Text = v50 .. v51
    for k3, k4 in pairs(v1.Items) do
        local v55 = Main[v48]:FindFirstChild(k3)
        if v55 then
            local v56 = k4.Price <= ShopGui
            v55.Buy.PriceDisplay.Amount.Text = _G.Utl.addComas(tostring(k4.Price))
            v55.Buy.Active = v56
            v55.Buy.AutoButtonColor = v56
            local Amount = v55.Buy.PriceDisplay.Amount
            local v58
            if not (v56 and v5) then
                local v59 = Color3.fromRGB(155, 155, 155)
            end

            Amount.TextColor3 = v58
            if v56 then
                v58 = 0
            else
                v58 = 0.4
            end

            v55.Buy.PriceDisplay.CandyCornIcon.ImageTransparency = v58
            if v48 == "List" then
                local Buy = v55.Buy
                local v61
                if not (v56 and Color3.fromRGB(105, 62, 23)) then
                    local v62 = Color3.fromRGB(60, 60, 60)
                end

                Buy.BackgroundColor3 = v61
            end

            local v63 = ownedCount(a0, k4)
            local v65
            if not (k4.Type == "BaseItem" and "Available x" .. v63) then
            end

            ;(v48 == "List" and v55.Stock or v55.Owned).Text = v65
        end
    end
end

local function Render(a0) --[[ Upvalues: v1 (copy), v5 (copy), createPreview (copy), createPriceDisplay (copy), ReplicatedStorage (copy), BaseObjectsLib (copy) ]]
    local ShopGui1 = a0.ShopGui
    if not (ShopGui1 and a0.ShopArgs) then
        return
    end

    local v67 = a0.ShopArgs[1]
    local Main1 = ShopGui1.Main
    local v68
    if a0.Data.ShopFormat == "Grid" then
        v68 = "Grid"
    else
        v68 = "List"
    end

    local v69 = "Grid"
    local v70 = {"List", v69}
    for k5, k6 in ipairs(v70) do
        local v74 = Main1[k6]
        v74.Visible = k6 == v68
        local v75 = v74:GetChildren()
        for k7, k8 in ipairs(v75) do
            if k8:GetAttribute("PumpkinXEntry") then
                k8:Destroy()
            end
        end
    end

    ShopGui1:SetAttribute("PumpkinXFormat", v68)
    Main1.Label.Text = v1.DisplayName
    local v79 = " Mode"
    Main1.Toggle.Text = v68 .. v79
    if not Main1:FindFirstChild("CandyCornBalance") then
        local v80 = Main1.Label:Clone()
        v80.Name = "CandyCornBalance"
        k6 = -0.175
        v80.Position = UDim2.new(0.35, 0, k6, -5)
        local v81 = 0.075
        v80.Size = UDim2.fromScale(0.65, v81)
        v80.TextXAlignment = Enum.TextXAlignment.Right
        v80.TextColor3 = v5
        v80.Parent = Main1
    end

    for k9, k10 in pairs(v1.Items) do
        local v85 = Main1[v68].Sample:Clone()
        v85.Name = k9
        v85:SetAttribute("noDelete", nil)
        v85:SetAttribute("PumpkinXEntry", true)
        v85.LayoutOrder = k10.LayoutOrder
        v85.ItemName.Text = k10.Item
        v85.Req.Visible = false
        v85.Visible = true
        if v68 == "List" then
            v85.ItemName.Size = UDim2.fromScale(0.55, 0.45)
            local v86
            if k10.Type == "BaseItem" then
                v86 = "Base Item (1 per purchase)"
            else
                v86 = k10.Skin .. " Skin"
            end

            v85.ItemType.Text = v86
            v85.ItemType.Size = UDim2.fromScale(0.55, 0.4)
            v85.ItemType.TextColor3 = v5
            v85.Buy.Position = UDim2.fromScale(0.7, 0)
            v85.Buy.Size = UDim2.fromScale(0.3, 0.5)
            v85.Stock.Position = UDim2.fromScale(0.7, 0.6)
            v85.Stock.Size = UDim2.fromScale(0.3, 0.4)
            createPreview(v85.ViewportFrame, k10)
        else
            local v87
            if k10.Type == "BaseItem" then
                v87 = "Base Item x1"
            else
                v87 = k10.Skin
            end

            v85.ItemName.Text = k10.Item .. "\n" .. v87
            v85.ItemName.Size = UDim2.fromScale(1, 0.28)
            local v88 = v85.ItemName:Clone()
            v88.Name = "Owned"
            v88.Position = UDim2.fromScale(0, 0.82)
            v88.Size = UDim2.fromScale(1, 0.16)
            v88.TextColor3 = v5
            v88.Parent = v85
            createPreview(v85, k10)
        end

        createPriceDisplay(v85.Buy, a0)
        v85.Parent = Main1[v68]
        local v89 = -math.huge
        v85.Buy.Activated:Connect(function() --[[ Upvalues: a0 (copy), ShopGui1 (copy), k10 (copy), v89 (ref), ReplicatedStorage (upvalue), k9 (copy), v67 (copy) ]]
            if a0.ShopGui ~= ShopGui1 then
                return
            end

            local v90 = tonumber(a0.Data.CandyCorn) or 0
            if v90 < k10.Price then
                return
            end

            v90 = os.clock() - v89
            if v90 < 0.4 then
                return
            end

            v89 = os.clock()
            local t1 = {k9, "Pumpkin X", v67}
            ReplicatedStorage.Remotes.RemoteEvent:FireServer("BuyItem", t1)
        end)
    end

    BaseObjectsLib.Update(a0)
end

BaseObjectsLib = {Update = Update, Render = Render}
return BaseObjectsLib
