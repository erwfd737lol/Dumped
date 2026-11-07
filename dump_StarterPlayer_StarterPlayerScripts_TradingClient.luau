-- decompiled by Velocity decompiler v1.0.3

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local TradingRemotes = ReplicatedStorage:WaitForChild("TradingRemotes")
local Event = TradingRemotes:WaitForChild("Event")
local v1 = TradingRemotes:GetAttribute("SkinTradingEnabled") == true
if not (TradingRemotes:GetAttribute("TradingEnabled") ~= false) then
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    TradingRemotes = PlayerGui:WaitForChild("TradingGui", 10)
    if TradingRemotes then
        TradingRemotes.Enabled = false
    end

    TradingRemotes = LocalPlayer.PlayerGui:WaitForChild("HUD", 10)
    local v3 = TradingRemotes and TradingRemotes:FindFirstChild("Settings")
    local v4 = v3 and v3:FindFirstChild("Main")
    local v5 = v4 and v4:FindFirstChild("TradeRequests")
    if v5 then
        v5.Visible = false
    end

    return
end

local v6 = require(ReplicatedStorage.Modules.Icon)
local v7 = require(ReplicatedStorage.Modules.ToolsLib)
local v8 = require(ReplicatedStorage.Modules.SkinsLib)
local Objects = ReplicatedStorage:WaitForChild("Objects")
local Tools = Objects:WaitForChild("Tools")
local Skins = Objects:WaitForChild("Skins")
Objects = ReplicatedStorage:WaitForChild("Sounds")
local v9 = {
    Background = Color3.fromRGB(0, 0, 0),
    Panel = Color3.fromRGB(0, 0, 0),
    Panel2 = Color3.fromRGB(0, 0, 0),
    Border = Color3.fromRGB(200, 197, 176),
    Blue = Color3.fromRGB(73, 169, 255),
    Green = Color3.fromRGB(75, 215, 133),
    Red = Color3.fromRGB(235, 79, 86),
    Yellow = Color3.fromRGB(255, 211, 88),
    Text = Color3.fromRGB(244, 247, 255),
    Muted = Color3.fromRGB(164, 176, 196)
}
local v10 = Font.new("rbxasset://fonts/families/Inconsolata.json")

local function make(a0, a1, a2)
    local v11 = Instance.new(a0)
    local v12 = a1
    if not v12 then
        v12 = {}
    end

    for k1, k2 in pairs(v12) do
        v11[k1] = k2
    end

    v11.Parent = a2
    return v11
end

local function decorate(a0) --[[ Upvalues: v9 (copy) ]]
    a0.BackgroundTransparency = 0.5
    a0.BorderColor3 = v9.Border
    a0.BorderSizePixel = 1
end

local function button(a0, a1, a2, a3, a4) --[[ Upvalues: make (copy), v9 (copy), v10 (copy) ]]
    local v16 = make
    local v17 = {AutoButtonColor = true, TextScaled = true, TextSize = 18, Selectable = true}
    local v19 = a4 or v9.Panel2
    v17.BackgroundColor3 = v19
    v17.Size = a2
    v17.Position = a3
    v17.FontFace = v10
    v17.Text = a1
    v17.TextColor3 = v9.Text
    local v20 = v16("TextButton", v17, a0)
    make("UITextSizeConstraint", {MinTextSize = 8, MaxTextSize = 18}, v20)
    v20.BackgroundTransparency = 0.5
    v20.BorderColor3 = v9.Border
    v20.BorderSizePixel = 1
    return v20
end

local PlayerGui1 = LocalPlayer:WaitForChild("PlayerGui")
local v21 = PlayerGui1:FindFirstChild("TradingGui") or PlayerGui1:WaitForChild("TradingGui", 10)
if not v21 then
    local TradingGui2 = StarterGui:FindFirstChild("TradingGui")
    if not TradingGui2 then
        error("StarterGui.TradingGui is missing.")
    end

    v21 = TradingGui2:Clone()
    v21.Parent = PlayerGui1
end

PlayerGui1 = v21:WaitForChild("PlayerBrowser")
local CloseButton = PlayerGui1:WaitForChild("CloseButton")
local RefreshButton = PlayerGui1:WaitForChild("RefreshButton")
local PlayerList = PlayerGui1:WaitForChild("PlayerList")
local IncomingRequest = v21:WaitForChild("IncomingRequest")
local Title = IncomingRequest:WaitForChild("Title")
local RequestText = IncomingRequest:WaitForChild("RequestText")
local AcceptButton = IncomingRequest:WaitForChild("AcceptButton")
local DeclineButton = IncomingRequest:WaitForChild("DeclineButton")
local ActiveTrade = v21:WaitForChild("ActiveTrade")
v21 = ActiveTrade:WaitForChild("Title")
local TimerLabel = ActiveTrade:WaitForChild("TimerLabel")
local Fill = ActiveTrade:WaitForChild("CountdownBar"):WaitForChild("Fill")
local YourOffer = ActiveTrade:WaitForChild("YourOffer")
local Title1 = YourOffer:WaitForChild("Title")
local Status = YourOffer:WaitForChild("Status")
local OfferList = YourOffer:WaitForChild("OfferList")
local TheirOffer = ActiveTrade:WaitForChild("TheirOffer")
local Title2 = TheirOffer:WaitForChild("Title")
local Status1 = TheirOffer:WaitForChild("Status")
local OfferList1 = TheirOffer:WaitForChild("OfferList")
local BackgroundColor3 = YourOffer.BackgroundColor3
local BackgroundColor31 = TheirOffer.BackgroundColor3
local v24 = YourOffer:GetAttribute("ConfirmedBackgroundColor") or Color3.fromRGB(35, 120, 65)
local v27 = TheirOffer:GetAttribute("ConfirmedBackgroundColor") or Color3.fromRGB(35, 120, 65)
local InventoryPanel = ActiveTrade:WaitForChild("InventoryPanel")
local ItemsTitle = InventoryPanel:WaitForChild("ItemsTitle")
local SkinsTitle = InventoryPanel:WaitForChild("SkinsTitle")
local ItemSearchBox = InventoryPanel:WaitForChild("ItemSearchBox")
local QuantityBox = InventoryPanel:WaitForChild("QuantityBox")
local ItemList = InventoryPanel:WaitForChild("ItemList")
local SkinList = InventoryPanel:WaitForChild("SkinList")
local Scale = ItemsTitle.Size.Y.Scale
local Scale1 = ItemSearchBox.Position.Y.Scale
local Scale2 = ItemSearchBox.Size.Y.Scale
local Scale3 = ItemList.Size.Y.Scale
local Scale4 = ItemList.Position.X.Scale
SkinsTitle.Visible = v1
SkinList.Visible = v1
if v1 then
    ItemsTitle.Size = UDim2.fromScale(0.12, Scale)
    ItemSearchBox.Position = UDim2.fromScale(0.12, Scale1)
    local v28 = 0.12 - Scale4 * 0.5
    ItemSearchBox.Size = UDim2.fromScale(v28, Scale2)
    QuantityBox.Position = UDim2.fromScale(0.25, Scale1)
    QuantityBox.Size = UDim2.fromScale(0.22 - Scale4, Scale2)
    local v29 = 0.48 - Scale4 * 1.5
    ItemList.Size = UDim2.fromScale(v29, Scale3)
else
    ItemsTitle.Size = UDim2.fromScale(0.23, Scale)
    ItemSearchBox.Position = UDim2.fromScale(0.23, Scale1)
    ItemSearchBox.Size = UDim2.fromScale(0.5 - Scale4, Scale2)
    QuantityBox.Position = UDim2.fromScale(0.75, Scale1)
    QuantityBox.Size = UDim2.fromScale(0.23 - Scale4, Scale2)
    local v30 = 1 - Scale4 * 2
    ItemList.Size = UDim2.fromScale(v30, Scale3)
end

local ConfirmButton = ActiveTrade:WaitForChild("ConfirmButton")
Scale3 = ActiveTrade:WaitForChild("CancelButton")
Scale2 = v6.new()
Scale2:setLabel("Trade")
local v31 = nil
local v32 = {Items = {}, Skins = {}}
local v33 = nil
local v34 = nil
local v35 = 0

local function notify(a0, a1) --[[ Upvalues: StarterGui (copy) ]]
    pcall(function() --[[ Upvalues: StarterGui (upvalue), a0 (copy), a1 (copy) ]]
        local t1 = {Duration = 3, Title = a0, Text = a1}
        StarterGui:SetCore("SendNotification", t1)
    end)
end

local function parseTradeAmount(a0)
    local v36 = tonumber(a0)
    if typeof(v36) ~= "number" or v36 ~= v36 or v36 <= 0 or math.huge <= v36 or v36 % 1 ~= 0 then
        return nil
    end

    return v36
end

local t2 = {TradeAdd = true, TradeRemove = true, TradeConfirm = true, TradeSuccess = true}

local function playTradeSound(a0) --[[ Upvalues: t2 (copy), Objects (copy), SoundService (copy), Debris (copy) ]]
    if not t2[a0] then
        return
    end

    local v37 = Objects:FindFirstChild(a0)
    if not (v37 and v37:IsA("Sound")) then
        warn("[Trading] Missing sound " .. tostring(a0))
        return
    end

    local v38 = v37:Clone()
    v38.Parent = SoundService
    v38.Ended:Once(function() --[[ Upvalues: v38 (copy) ]]
        if v38.Parent then
            v38:Destroy()
        end

    end)
    Debris:AddItem(v38, 30)
    v38:Play()
end

local function clearDynamic(a0)
    local v39 = a0:GetChildren()
    for k3, k4 in ipairs(v39) do
        if k4:GetAttribute("TradeDynamic") then
            k4:Destroy()
        end
    end
end

local function objectCFrame(a0)
    if a0:IsA("Model") then
        local v44 = a0.PrimaryPart or a0:FindFirstChildWhichIsA("BasePart", true)
        return v44 and v44.CFrame or nil
    end

    if a0:IsA("BasePart") then
        return a0.CFrame
    end

    return nil
end

local function prepareViewport(a0) --[[ Upvalues: make (copy) ]]
    local ItemViewport = a0:FindFirstChild("ItemViewport")
    if not (ItemViewport and ItemViewport:IsA("ViewportFrame")) then
        local v46 = {
            Name = "ItemViewport",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LightDirection = Vector3.new(-1, -1, -1),
            Size = UDim2.fromScale(0.1, 0.95),
            Position = UDim2.fromScale(0.0075, 0.025),
            Ambient = Color3.fromRGB(190, 190, 190),
            LightColor = Color3.fromRGB(255, 255, 255),
            ZIndex = a0.ZIndex + 1
        }
        return make("ViewportFrame", v46, a0)
    end

    ItemViewport.CurrentCamera = nil
    local v47 = ItemViewport:GetChildren()
    for k5, k6 in ipairs(v47) do
        if k6:IsA("Camera") or k6.Name == "VPObject" then
            k6:Destroy()
        end
    end

    return ItemViewport
end

local function populateViewport(a0, a1, a2, a3, a4) --[[ Upvalues: prepareViewport (copy) ]]
    if not a1 then
        return
    end

    if typeof(a2) ~= "CFrame" then
        return
    end

    local v51 = a1:Clone()
    local v52
    if v51:IsA("Model") then
        local v54 = v51.PrimaryPart or v51:FindFirstChildWhichIsA("BasePart", true)
        if v54 then
            v52 = v54.CFrame
            if v52 then
                -- jump to 44
            end
        end

        v52 = nil
    else
        if v51:IsA("BasePart") then
            v52 = v51.CFrame
        else
            v52 = nil
        end
    end

    if not v52 then
        v51:Destroy()
        return
    end

    local v55 = prepareViewport(a0)
    v51.Name = "VPObject"
    v51.Parent = v55
    v51 = Instance.new("Camera")
    v51.Name = "Camera"
    v51.CFrame = v52 * a2
    v51.Parent = v55
    v55.CurrentCamera = v51
    v55:SetAttribute("ViewportItem", a3)
    v55:SetAttribute("ViewportSkin", a4)
end

local function addItemViewport(a0, a1) --[[ Upvalues: v7 (copy), Tools (copy), populateViewport (copy) ]]
    local v56 = v7[a1]
    local v57 = Tools:FindFirstChild(a1)
    if not (typeof(v56) == "table" and v57) then
        return
    end

    populateViewport(a0, v57, v56.ViewportOffset, a1, nil)
end

local function addSkinViewport(a0, a1, a2) --[[ Upvalues: v7 (copy), Skins (copy), Tools (copy), populateViewport (copy), v8 (copy) ]]
    local v58 = v7[a1]
    local v59 = Skins:FindFirstChild(a1)
    local v62 = v59 and v59:FindFirstChild(a2)
    if not (typeof(v58) == "table" and v62) then
        v59 = v7[a1]
        local v63 = Tools:FindFirstChild(a1)
        if typeof(v59) == "table" then
            if not v63 then
                return
            end

            populateViewport(a0, v63, v59.ViewportOffset, a1, nil)
        end

        return
    end

    local v64 = v8[a1]
    local v67 = typeof(v64) == "table" and v64[a2] or nil
    local v68 = typeof(v67) == "table" and typeof(v67.ViewportOffset) == "CFrame" and v67.ViewportOffset or v58.ViewportOffset
    populateViewport(a0, v62, v68, a1, a2)
end

local function listRow(a0, a1, a2, a3, a4, a5, a6) --[[ Upvalues: button (copy), v9 (copy), make (copy), addSkinViewport (copy), v7 (copy), Tools (copy), populateViewport (copy) ]]
    local v71 = a5 and a0:FindFirstChild(a5)
    local v72
    if v71 and v71:IsA("TextButton") then
        v72 = v71:Clone()
        v72.Name = "TradeEntry"
        v72.Visible = true
        local Label = v72:FindFirstChild("Label")
        if Label and Label:IsA("TextLabel") then
            v72.Text = ""
            Label.Text = a1
        else
            v72.Text = a1
        end

        if a2 then
            v72.BackgroundColor3 = a2
        end

        v72:SetAttribute("TradeTemplate", nil)
        v72.Parent = a0
    else
        local v73 = button
        local v74 = UDim2.fromScale(0.990147783, 0.092165899)
        local v75 = UDim2.fromScale(0, 0)
        local v77 = a2 or v9.Panel2
        v72 = v73(a0, a1, v74, v75, v77)
        v72.TextXAlignment = Enum.TextXAlignment.Left
        v72.TextTruncate = Enum.TextTruncate.AtEnd
        local v78 = make
        local v79 = {}
        if a4 then
            v75 = 0.134328358
        else
            v75 = 0.024875622
        end

        v79.PaddingLeft = UDim.new(v75, 0)
        v79.PaddingRight = UDim.new(0.019900498, 0)
        v78("UIPadding", v79, v72)
    end

    v72:SetAttribute("TradeDynamic", true)
    if a6 and a4 then
        addSkinViewport(v72, a4, a6)
    else
        if a4 then
            v71 = v7[a4]
            local v80 = Tools:FindFirstChild(a4)
            if typeof(v71) == "table" then
                if not v80 then
                else
                    populateViewport(v72, v80, v71.ViewportOffset, a4, nil)
                end
            end
        end
    end

    if a3 then
        v72.AutoButtonColor = true
        v72.Selectable = true
        v72.Activated:Connect(a3)
        return v72
    end

    v72.AutoButtonColor = false
    v72.Selectable = false
    return v72
end

local function offeredItemAmount(a0) --[[ Upvalues: v33 (ref) ]]
    if not (v33 and v33.Own) then
        return 0
    end

    local Items = v33.Own.Items
    if not Items then
        Items = {}
    end

    for k7, k8 in ipairs(Items) do
        if k8.Item == a0 then
            return k8.Amount
        end
    end

    return 0
end

local function skinIsOffered(a0) --[[ Upvalues: v33 (ref) ]]
    if not (v33 and v33.Own) then
        return false
    end

    local Skins1 = v33.Own.Skins
    if not Skins1 then
        Skins1 = {}
    end

    for k9, k10 in ipairs(Skins1) do
        if k10.Uid == a0 then
            return true
        end
    end

    return false
end

local function itemMatchesSearch(a0) --[[ Upvalues: ItemSearchBox (copy) ]]
    local v87 = string.lower(ItemSearchBox.Text)
    v87 = string.match(v87, "^%s*(.-)%s*$") or ""
    if v87 == "" then
        return true
    end

    local v88 = tostring(a0.Item)
    return string.find(string.lower(v88 .. " " .. tostring(a0.ToolType or "")), v87, 1, true) ~= nil
end

local function renderInventory() --[[ Upvalues: clearDynamic (copy), ItemList (copy), SkinList (copy), v31 (ref), v33 (ref), v32 (ref), itemMatchesSearch (copy), offeredItemAmount (copy), listRow (copy), QuantityBox (copy), StarterGui (copy), Event (copy), v1 (copy), skinIsOffered (copy) ]]
    clearDynamic(ItemList)
    clearDynamic(SkinList)
    local v89 = not v31
    if not v89 then
        local v90 = v33 and v33.Locked
    end

    local Items1 = v32.Items
    if not Items1 then
        Items1 = {}
    end

    for k11, k12 in ipairs(Items1) do
        if itemMatchesSearch(k12) then
            local v94 = math.max(0, k12.Quantity - offeredItemAmount(k12.Item))
            local v95 = string.format("%s  x%d", k12.Item, v94)
            local v96 = listRow
            local v97 = ItemList
            local v100 = v94 <= 0 and Color3.fromRGB(55, 55, 62) or nil
            if v89 then
            end

            v96(v97, v95, v100, function() --[[ Upvalues: QuantityBox (upvalue), StarterGui (upvalue), Event (upvalue), k12 (copy) ]]
                local v101 = tonumber(QuantityBox.Text)
                if typeof(v101) ~= "number" or v101 ~= v101 or v101 <= 0 or math.huge <= v101 or v101 % 1 ~= 0 then
                    local v102 = nil
                    -- jump to 29 (out of range)
                end

                local v103 = v101
                if not v103 then
                    local v104 = "Trade Error"
                    local v105 = "Enter a positive whole-number quantity."
                    pcall(function() --[[ Upvalues: StarterGui (upvalue), v104 (copy), v105 (copy) ]]
                        local t3 = {Duration = 3, Title = v104, Text = v105}
                        StarterGui:SetCore("SendNotification", t3)
                    end)
                    return
                end

                local v106 = {Kind = "Item", Item = k12.Item, Amount = v103}
                Event:FireServer("Add", v106)
            end, k12.Item, "ItemTemplate")
        end
    end

    local v107
    if not (v1 and v32.Skins) then
        v107 = {}
    end

    for k13, k14 in ipairs(v107) do
        local v111 = skinIsOffered(k14.Uid)
        local v112 = string.sub(k14.Uid, math.max(1, #k14.Uid - 7))
        local v113 = string.format("%s \194\183 %s  [%s]", k14.Skin, k14.Item, v112)
        local v114 = listRow
        local v115 = SkinList
        local v118 = v111 and Color3.fromRGB(55, 55, 62) or nil
        if not v89 and v111 then
        end

        v114(v115, v113, v118, function() --[[ Upvalues: Event (upvalue), k14 (copy) ]]
            local t4 = {Kind = "Skin", Item = k14.Item, Uid = k14.Uid}
            Event:FireServer("Add", t4)
        end, k14.Item, "SkinTemplate", k14.Skin)
    end
end

local v119 = ItemSearchBox:GetPropertyChangedSignal("Text")
local v120 = 0
v119:Connect(function() --[[ Upvalues: v120 (ref), renderInventory (copy) ]]
    v120 = v120 + 1
    local v121 = v120
    task.delay(0.08, function() --[[ Upvalues: v121 (copy), v120 (upvalue), renderInventory (upvalue) ]]
        if v121 == v120 then
            renderInventory()
        end

    end)
end)

local function renderOfferList(a0, a1, a2) --[[ Upvalues: clearDynamic (copy), listRow (copy), Event (copy), v1 (copy) ]]
    clearDynamic(a0)
    local v122
    if not (a1 and a1.Items) then
        v122 = {}
    end

    for k15, k16 in ipairs(v122) do
        local v126 = listRow
        local v127 = string.format("%s  x%d", k16.Item, k16.Amount)
        if a2 then

            local function v128() --[[ Upvalues: Event (upvalue), k16 (copy) ]]
                local t5 = {Kind = "Item", Item = k16.Item}
                Event:FireServer("Remove", t5)
            end

            if v128 then
                -- jump to 33
            end
        end

        local v129 = nil
        v126(a0, v127, nil, v129, k16.Item, "ItemTemplate")
    end

    local v130
    if not (v1 and a1 and a1.Skins) then
        v130 = {}
    end

    for k17, k18 in ipairs(v130) do
        local v134 = string.sub(k18.Uid, math.max(1, #k18.Uid - 7))
        local v135 = listRow
        local v136 = string.format("%s \194\183 %s  [%s]", k18.Skin, k18.Item, v134)
        if a2 then

            local function v137() --[[ Upvalues: Event (upvalue), k18 (copy) ]]
                local t6 = {Kind = "Skin", Uid = k18.Uid}
                Event:FireServer("Remove", t6)
            end

            if v137 then
                -- jump to 89
            end
        end

        local v138 = nil
        v135(a0, v136, nil, v138, k18.Item, "SkinTemplate", k18.Skin)
    end
end

local function renderState() --[[ Upvalues: v33 (ref), v35 (ref), TimerLabel (copy), Fill (copy), renderOfferList (copy), OfferList (copy), OfferList1 (copy), YourOffer (copy), v24 (copy), BackgroundColor3 (copy), TheirOffer (copy), v27 (copy), BackgroundColor31 (copy), Status (copy), v9 (copy), Status1 (copy), ConfirmButton (copy), renderInventory (copy) ]]
    if not v33 then
        return
    end

    if v33.State ~= "Countdown" then
        v35 = v35 + 1
        TimerLabel.Text = ""
        Fill.Size = UDim2.fromScale(1, 1)
    end

    renderOfferList(OfferList, v33.Own, not (v33.Locked == true))
    renderOfferList(OfferList1, v33.Other, false)
    YourOffer.BackgroundColor3 = v33.OwnConfirmed and v24 or BackgroundColor3
    TheirOffer.BackgroundColor3 = v33.OtherConfirmed and v27 or BackgroundColor31
    local v143
    if v33.OwnConfirmed then
        v143 = "CONFIRMED"
    else
        v143 = "NOT CONFIRMED"
    end

    Status.Text = v143
    local v144
    if not (v33.OwnConfirmed and v9.Green) then
        v144 = v9.Muted
    end

    Status.TextColor3 = v144
    if v33.OtherConfirmed then
        v144 = "CONFIRMED"
    else
        v144 = "NOT CONFIRMED"
    end

    Status1.Text = v144
    local v145
    if not (v33.OtherConfirmed and v9.Green) then
        v145 = v9.Muted
    end

    Status1.TextColor3 = v145
    local v146 = v33.State == "Committing"
    if v146 then
        v145 = "FINALIZING"
    else
        if v33.OwnConfirmed then
            v145 = "UNCONFIRM"
        else
            v145 = "CONFIRM"
        end
    end

    ConfirmButton.Text = v145
    ConfirmButton.BackgroundColor3 = v9.Background
    ConfirmButton.BackgroundTransparency = 0.5
    local v147
    if not (v146 and v9.Muted) then
        v147 = v9.Green
    end

    ConfirmButton.TextColor3 = v147
    renderInventory()
end

local function refreshPlayerList() --[[ Upvalues: clearDynamic (copy), PlayerList (copy), Players (copy), LocalPlayer (copy), listRow (copy), v9 (copy), Event (copy), GuiService (copy) ]]
    clearDynamic(PlayerList)
    local v148 = nil
    local v149 = Players:GetPlayers()
    for k19, k20 in ipairs(v149) do
        if k20 ~= LocalPlayer then
            local v153 = k20.DisplayName .. "  (@" .. k20.Name .. ")"
            v148 = v148 or listRow(PlayerList, v153, v9.Panel2, function() --[[ Upvalues: Event (upvalue), k20 (copy) ]]
                local t7 = {TargetUserId = k20.UserId}
                Event:FireServer("Request", t7)
            end)
        end
    end

    if not v148 then
        listRow(PlayerList, "No other players are in this server.", v9.Panel2, nil)
        return
    end

    if GuiService:IsTenFootInterface() then
        GuiService.SelectedObject = v148
    end
end

local function closeTradeUi() --[[ Upvalues: v35 (ref), ItemSearchBox (copy), QuantityBox (copy), v31 (ref), v33 (ref), v32 (ref), ActiveTrade (copy), TimerLabel (copy), Fill (copy), clearDynamic (copy), OfferList (copy), OfferList1 (copy), ItemList (copy), SkinList (copy) ]]
    v35 = v35 + 1
    if ItemSearchBox:IsFocused() then
        ItemSearchBox:ReleaseFocus()
    end

    if QuantityBox:IsFocused() then
        QuantityBox:ReleaseFocus()
    end

    ItemSearchBox.Text = ""
    v31 = nil
    v33 = nil
    local v154 = {Items = {}, Skins = {}}
    v32 = v154
    ActiveTrade.Visible = false
    TimerLabel.Text = ""
    Fill.Size = UDim2.fromScale(1, 1)
    clearDynamic(OfferList)
    clearDynamic(OfferList1)
    clearDynamic(ItemList)
    clearDynamic(SkinList)
end

Scale2.selected:Connect(function() --[[ Upvalues: v31 (ref), ActiveTrade (copy), PlayerGui1 (copy), refreshPlayerList (copy) ]]
    if v31 then
        ActiveTrade.Visible = true
        PlayerGui1.Visible = false
        return
    end

    PlayerGui1.Visible = true
    refreshPlayerList()
end)
Scale2.deselected:Connect(function() --[[ Upvalues: v31 (ref), PlayerGui1 (copy) ]]
    if not v31 then
        PlayerGui1.Visible = false
    end

end)
CloseButton.Activated:Connect(function() --[[ Upvalues: PlayerGui1 (copy), Scale2 (copy) ]]
    PlayerGui1.Visible = false
    Scale2:deselect()
end)
RefreshButton.Activated:Connect(refreshPlayerList)
Players.PlayerAdded:Connect(function() --[[ Upvalues: PlayerGui1 (copy), refreshPlayerList (copy) ]]
    if PlayerGui1.Visible then
        refreshPlayerList()
    end

end)
Players.PlayerRemoving:Connect(function() --[[ Upvalues: PlayerGui1 (copy), refreshPlayerList (copy) ]]
    if PlayerGui1.Visible then
        refreshPlayerList()
    end

end)
AcceptButton.Activated:Connect(function() --[[ Upvalues: v34 (ref), Event (copy), IncomingRequest (copy) ]]
    if v34 then
        local t8 = {FromUserId = v34}
        Event:FireServer("Accept", t8)
    end

    IncomingRequest.Visible = false
    v34 = nil
end)
DeclineButton.Activated:Connect(function() --[[ Upvalues: Event (copy), IncomingRequest (copy), v34 (ref) ]]
    Event:FireServer("Decline")
    IncomingRequest.Visible = false
    v34 = nil
end)
ConfirmButton.Activated:Connect(function() --[[ Upvalues: v31 (ref), v33 (ref), Event (copy) ]]
    if v31 then
        if v33 then
            if v33.State == "Open" or v33.State == "Countdown" then
                Event:FireServer("Confirm")
            end
        end
    end

end)
Scale3.Activated:Connect(function() --[[ Upvalues: v31 (ref), Event (copy) ]]
    if v31 then
        Event:FireServer("Cancel")
    end

end)
Event.OnClientEvent:Connect(function(a0, a1) --[[ Upvalues: v34 (ref), RequestText (copy), IncomingRequest (copy), GuiService (copy), AcceptButton (copy), v31 (ref), v32 (ref), v33 (ref), PlayerGui1 (copy), v21 (copy), ActiveTrade (copy), Scale2 (copy), renderState (copy), ConfirmButton (copy), v35 (ref), TimerLabel (copy), Fill (copy), playTradeSound (copy), closeTradeUi (copy), StarterGui (copy) ]]
    local v156
    if not (typeof(a1) == "table" and a1) then
        v156 = {}
    end

    a1 = v156
    if a0 == "TradeRequest" then
        v34 = a1.FromUserId
        local v157 = tostring(a1.FromName)
        RequestText.Text = v157 .. " wants to trade with you."
        IncomingRequest.Visible = true
        if GuiService:IsTenFootInterface() then
            GuiService.SelectedObject = AcceptButton
        end

        local v158 = v34
        task.delay(20, function() --[[ Upvalues: v34 (upvalue), v158 (copy), IncomingRequest (upvalue) ]]
            if v34 == v158 then
                IncomingRequest.Visible = false
                v34 = nil
            end

        end)
        return
    end

    if a0 == "SessionStarted" then
        v31 = a1.SessionId
        v156 = a1.Inventory
        if not v156 then
            v156 = {Items = {}, Skins = {}}
        end

        v32 = v156
        local v159 = {Items = {}, Skins = {}}
        v159 = {Items = {}, Skins = {}}
        v156 = {Own = v159, Other = v159}
        v33 = v156
        PlayerGui1.Visible = false
        IncomingRequest.Visible = false
        v21.Text = "TRADING WITH " .. string.upper(tostring(a1.PartnerName))
        ActiveTrade.Visible = true
        Scale2:select()
        renderState()
        if GuiService:IsTenFootInterface() then
            GuiService.SelectedObject = ConfirmButton
            return
            -- branch continues at 274
        end
    end

    if a0 == "OfferState" then
        if not v31 then
            return
        end

        v33 = a1
        renderState()
        return
    end

    if a0 == "CountdownStarted" then
        if not v31 then
            return
        end

        v35 = v35 + 1
        v156 = v35
        local v162 = tonumber(a1.EndsAt) or workspace:GetServerTimeNow()
        local v163 = tonumber(a1.Duration) or 5
        task.spawn(function() --[[ Upvalues: v156 (copy), v35 (upvalue), v31 (upvalue), v162 (copy), TimerLabel (upvalue), Fill (upvalue), v163 (copy) ]]
            while v156 == v35 and v31 do
                local v164 = math.max(0, v162 - workspace:GetServerTimeNow())
                TimerLabel.Text = string.format("FINALIZING IN %.1f", math.ceil(v164 * 10) / 10)
                local v165 = v164 / v163
                local v166 = math.clamp(v165, 0, 1)
                Fill.Size = UDim2.fromScale(v166, 1)
                if v164 <= 0 then
                    break
                end

                task.wait(0.03)
            end

        end)
        return
    end

    if a0 == "TradeSound" then
        playTradeSound(a1.Name)
        return
    end

    if a0 == "TradeEnded" then
        v156 = a1.Success == true
        closeTradeUi()
        IncomingRequest.Visible = false
        PlayerGui1.Visible = false
        Scale2:deselect()
        local v167
        if v156 then
            v167 = "Trade Successful"
        else
            v167 = "Trade Failed"
        end

        local Message = a1.Message
        if not Message then
            if v156 then
                Message = "Trade was successful."
            else
                Message = "Trade failed."
            end
        end

        pcall(function() --[[ Upvalues: StarterGui (upvalue), v167 (copy), Message (copy) ]]
            local t9 = {Duration = 3, Title = v167, Text = Message}
            StarterGui:SetCore("SendNotification", t9)
        end)
        return
    end

    if a0 == "Error" then
        local v168 = "Trade Error"
        pcall(function() --[[ Upvalues: StarterGui (upvalue), v168 (copy), v156 (copy) ]]
            local t10 = {Duration = 3, Title = v168, Text = v156}
            StarterGui:SetCore("SendNotification", t10)
        end)
        return
    end

    if a0 == "Info" then
        local v169 = "Trading"
        pcall(function() --[[ Upvalues: StarterGui (upvalue), v169 (copy), v156 (copy) ]]
            local t11 = {Duration = 3, Title = v169, Text = v156}
            StarterGui:SetCore("SendNotification", t11)
        end)
    end

end)
