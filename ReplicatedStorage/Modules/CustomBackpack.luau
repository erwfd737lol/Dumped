
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local GamepadService = game:GetService("GamepadService")
local RunService = game:GetService("RunService")
local v1 = require(ReplicatedStorage.Modules.ToolsLib)
local v2 = require(ReplicatedStorage.Modules.Icon)
local v3 = {}
v3.__index = v3
local v4 = Color3.fromRGB(0, 170, 255)
local v5 = Color3.fromRGB(255, 195, 55)
local v6 = Color3.fromRGB(0, 0, 0)
local v7 = {
    [Enum.KeyCode.One] = 1,
    [Enum.KeyCode.Two] = 2,
    [Enum.KeyCode.Three] = 3,
    [Enum.KeyCode.Four] = 4,
    [Enum.KeyCode.Five] = 5,
    [Enum.KeyCode.Six] = 6,
    [Enum.KeyCode.Seven] = 7,
    [Enum.KeyCode.Eight] = 8,
    [Enum.KeyCode.Nine] = 9,
    [Enum.KeyCode.Zero] = 10
}
local v9, v10 = pcall(function()
    local v8 = Font.new("rbxasset://fonts/families/Inconsolata.json")
    return v8
end)
if not v9 then
    v10 = Font.fromEnum(Enum.Font.Code)
end

local function setInconsolata(a0) --[[ Upvalues: v10 (ref) ]]
    for k1, k2 in a0:GetDescendants() do
        if k2:IsA("TextLabel") or k2:IsA("TextButton") or k2:IsA("TextBox") then
            k2.FontFace = v10
        end
    end
end

local function isTool(a0)
    local v16 = a0 and a0:IsA("Tool")
    return v16
end

local function getToolKey(a0)
    local v17 = a0:GetAttribute("ToolName")
    if typeof(v17) == "string" and v17 ~= "" then
        return v17
    end

    return a0.Name
end

local function getDisplayName(a0)
    local v18 = a0:GetAttribute("ToolName")
    if typeof(v18) == "string" and v18 ~= "" then
        return v18
    end

    return a0.Name
end

local function getTooltip(a0)
    if a0.ToolTip ~= "" then
        return a0.ToolTip
    end

    local v19 = a0:GetAttribute("ToolName")
    if typeof(v19) == "string" and v19 ~= "" then
        return v19
    end

    return a0.Name
end

local function getQuantity(a0)
    local v20 = a0:GetAttribute("Quantity")
    local v21 = tonumber(v20)
    if not v21 then
        local v22 = string.match(a0.Name, "%[x(%d+)%]%s*$")
        v21 = tonumber(v22)
    end

    if not v21 or v21 ~= v21 or v21 < 1 then
        return 1
    end

    return math.floor(v21)
end

local function isInside(a0, a1)
    local AbsolutePosition = a0.AbsolutePosition
    local AbsoluteSize = a0.AbsoluteSize
    local v23 = false
    if AbsolutePosition.X <= a1.X then
        v23 = false
        if AbsolutePosition.Y <= a1.Y then
            v23 = false
            if a1.X <= AbsolutePosition.X + AbsoluteSize.X then
                v23 = a1.Y <= AbsolutePosition.Y + AbsoluteSize.Y
            end
        end
    end

    return v23
end

local function new(a0, a1, a2) --[[ Upvalues: v3 (copy) ]]
    local v24 = setmetatable({}, v3)
    v24.Player = a0
    v24.PlayerGui = a0:WaitForChild("PlayerGui")
    v24.HUD = a1
    v24.RemoteEvent = a2
    v24.Backpack = a0:WaitForChild("Backpack")
    v24.Character = a0.Character
    v24.Enabled = true
    v24.Open = false
    v24.Destroyed = false
    v24.DataLoaded = false
    v24.SavedInitialized = false
    v24.AllowRestoredAutoSlot = false
    v24.ApplySavedLayout = false
    v24.RefreshQueued = false
    v24.ForceFullRefresh = false
    v24.HasRendered = false
    v24.LastEquippedTool = nil
    v24.SavedNames = table.create(10, "")
    v24.RestoreNames = {}
    v24.LastSentNames = table.create(10, "")
    v24.LastSentInitialized = false
    v24.HotbarTools = table.create(10)
    v24.Tools = {}
    v24.ToolSet = {}
    v24.ToolConnections = {}
    v24.PendingAutoSlot = setmetatable({}, {__mode = "k"})
    v24.NewItemSequence = 0
    v24.Connections = {}
    v24.ButtonConnections = {}
    v24.CharacterConnections = {}
    v24.BackpackConnections = {}
    v24.ButtonTools = setmetatable({}, {__mode = "k"})
    v24.RenderedTools = setmetatable({}, {__mode = "k"})
    v24.BackpackButtons = {}
    v24.ToolVisualRefreshQueued = setmetatable({}, {__mode = "k"})
    v24.BackpackViewportRefreshQueued = false
    v24.SuppressActivatedUntil = setmetatable({}, {__mode = "k"})
    v24.BlockedMouseActivations = setmetatable({}, {__mode = "k"})
    v24.PointerDrag = nil
    v24.DragGhosts = {}
    v24.DragVisuals = setmetatable({}, {__mode = "k"})
    v24.GamepadHeldTool = nil
    v24.GamepadHeldSlot = nil
    v24.GamepadHeldButton = nil
    v24.PreviousSelectedObject = nil
    v24.EnabledBackpackGamepadCursor = false
    v24.ControllerNavigationActive = false
    v24.ControllerCursorMode = false
    v24.PreferredControllerCursorMode = false
    v24.CursorPreferenceDirty = false
    v24.ControllerTransfer = nil
    v24.ControllerInputRevision = 0
    v24.ControllerStatusUntil = 0
    v24.ControllerSection = "Hotbar"
    v24.LastControllerHotbarSlot = 1
    v24.LastControllerBackpackTool = nil
    v24.ControllerDirection = nil
    v24.ControllerRepeatAt = 0
    v24.ControllerControls = nil
    v24.RestoreControllerMovement = false
    v24.ControllerCamera = nil
    v24.SavedControllerCameraType = nil
    v24.SavedGuiNavigationEnabled = nil
    v24.PlayerGui:SetAttribute("ControllerBackpackActive", false)
    v24.PlayerGui:SetAttribute("ControllerBackpackCursorMode", false)
    v24.OpenRevision = 0
    v24:_prepareUI()
    v24:_prepareTouchLayout()
    v24:_createControllerGui()
    v24:_destroyAllDragGhosts()
    v24:_bindInputs()
    v24:_connect(v24.HUD.Destroying, function() --[[ Upvalues: v24 (copy) ]]
        v24:Destroy()
    end)
    v24:_watchTools()
    v24:_disableCoreBackpack()
    v24:_queueRefresh()
    task.spawn(function() --[[ Upvalues: a0 (copy), v24 (copy) ]]
        local v25 = a0:FindFirstChild("PlayerScripts") or a0:WaitForChild("PlayerScripts", 5)
        if not (not v24.Destroyed and v25) then
            return
        end

        local v26 = v25:FindFirstChild("PlayerModule") or v25:WaitForChild("PlayerModule", 5)
        if not (not v24.Destroyed and v26) then
            return
        end

        local v27, v28 = pcall(require, v26)
        if v27 and not v24.Destroyed and v28.GetControls then
            v24.ControllerControls = v28:GetControls()
            if v24.ControllerNavigationActive and v24.ControllerCursorMode then
                v24:_takeControllerMovement()
            end
        end

    end)
    return v24
end

v3.new = new

local function _connect(a0, a1, a2)
    local v29 = a1:Connect(a2)
    table.insert(a0.Connections, v29)
    return v29
end

v3._connect = _connect

local function _disableCoreBackpack(a0) --[[ Upvalues: StarterGui (copy) ]]
    task.spawn(function() --[[ Upvalues: a0 (copy), StarterGui (upvalue) ]]
        for i1 = 1, 8 do
            if a0.Destroyed then
                return
            end

            pcall(function() --[[ Upvalues: StarterGui (upvalue) ]]
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
            end)
            task.wait(0.5)
        end

    end)
end

v3._disableCoreBackpack = _disableCoreBackpack

local function _makeViewport(a0, a1)
    local ItemIcon = a1:FindFirstChild("ItemIcon")
    if ItemIcon and ItemIcon:IsA("ViewportFrame") then
        return ItemIcon
    end

    local v32 = UDim2.fromScale(0.5, 0.42)
    local v33 = UDim2.fromScale(0.88, 0.7)
    local v34 = Vector2.new(0.5, 0.5)
    local v35 = a1.ZIndex + 1
    if ItemIcon and ItemIcon:IsA("GuiObject") then
        v32 = ItemIcon.Position
        v33 = ItemIcon.Size
        v34 = ItemIcon.AnchorPoint
        v35 = ItemIcon.ZIndex
        ItemIcon:Destroy()
    end

    ItemIcon = Instance.new("ViewportFrame")
    ItemIcon.Name = "ItemIcon"
    ItemIcon.AnchorPoint = v34
    ItemIcon.Position = v32
    ItemIcon.Size = v33
    ItemIcon.BackgroundTransparency = 1
    ItemIcon.BorderSizePixel = 0
    ItemIcon.Ambient = Color3.fromRGB(185, 185, 200)
    ItemIcon.LightColor = Color3.fromRGB(255, 255, 255)
    ItemIcon.LightDirection = Vector3.new(-1, -0.80000001192092896, -1)
    ItemIcon.ZIndex = v35
    ItemIcon.Visible = false
    ItemIcon.Parent = a1
    return ItemIcon
end

v3._makeViewport = _makeViewport

local function _clearViewport(a0, a1)
    a1.CurrentCamera = nil
    for k3, k4 in a1:GetChildren() do
        k4:Destroy()
    end
end

v3._clearViewport = _clearViewport

local function _renderViewport(a0, a1, a2) --[[ Upvalues: v1 (copy), ReplicatedStorage (copy) ]]
    a0:_clearViewport(a1)
    local v39 = a2:GetAttribute("ToolName")
    local v40
    if typeof(v39) == "string" and v39 ~= "" then
        v40 = v39
    else
        v40 = a2.Name
    end

    v39 = v1[v40]
    if not v39 then
        return false
    end

    if typeof(v39.ViewportOffset) ~= "CFrame" then
        return false
    end

    local Objects = ReplicatedStorage:FindFirstChild("Objects")
    local v42 = Objects and Objects:FindFirstChild("Tools")
    local v44 = v42 and v42:FindFirstChild(v40)
    if not v44 then
        return false
    end

    local v46, v47 = pcall(function() --[[ Upvalues: v44 (copy) ]]
        local v45 = v44:Clone()
        return v45
    end)
    if not (v46 and v47) then
        return false
    end

    local function preparePart(a0)
        a0.Anchored = true
        a0.CanCollide = false
        a0.CanTouch = false
        a0.CanQuery = false
        a0.Massless = true
    end

    if v47:IsA("BasePart") then
        v47.Anchored = true
        v47.CanCollide = false
        v47.CanTouch = false
        v47.CanQuery = false
        v47.Massless = true
    end

    local v48 = v47:GetDescendants()
    for k5, k6 in ipairs(v48) do
        if k6:IsA("BaseScript") or k6:IsA("ModuleScript") or k6:IsA("Sound") then
            k6:Destroy()
            -- jump to 143 (out of range)
        end

        if k6:IsA("BasePart") then
            k6.Anchored = true
            k6.CanCollide = false
            k6.CanTouch = false
            k6.CanQuery = false
            k6.Massless = true
        end
    end

    local v52
    if v47:IsA("Model") then
        if not v47.PrimaryPart then
            v47:Destroy()
            return false
        end

        v52 = v47.PrimaryPart.CFrame
    else
        if v47:IsA("BasePart") then
            v52 = v47.CFrame
        else
            v47:Destroy()
            return false
        end
    end

    v47.Name = "VPObject"
    v47.Parent = a1
    v47 = Instance.new("Camera")
    v47.Name = "ItemCamera"
    v47.CFrame = v52 * v39.ViewportOffset
    v47.Parent = a1
    a1.CurrentCamera = v47
    return true
end

v3._renderViewport = _renderViewport

local function _createSupportGui(a0) --[[ Upvalues: v2 (copy), v4 (copy), v10 (ref) ]]
    local BackpackToggle = a0.HUD:FindFirstChild("BackpackToggle")
    if BackpackToggle then
        BackpackToggle:Destroy()
    end

    local v53 = v2.new()
    v53:setName("Backpack")
    v53:setImage("rbxassetid://86890800998489")
    local v54 = v53:getInstance("ClickRegion")
    v54:SetAttribute("ControllerBackpackButton", true)
    a0.BackpackIcon = v53
    v53.selected:Connect(function() --[[ Upvalues: a0 (copy), v53 (copy) ]]
        if a0.Destroyed or a0.SyncingBackpackIcon then
            return
        end

        if a0.Enabled then
            a0:SetOpen(true)
            return
        end

        v53:deselect("Disabled", v53)
    end)
    v53.deselected:Connect(function() --[[ Upvalues: a0 (copy) ]]
        if not a0.Destroyed and not a0.SyncingBackpackIcon then
            a0:SetOpen(false)
        end

    end)
    local BackpackTooltip = a0.HUD:FindFirstChild("BackpackTooltip")
    if not BackpackTooltip then
        BackpackTooltip = Instance.new("TextLabel")
        BackpackTooltip.Name = "BackpackTooltip"
        BackpackTooltip.AnchorPoint = Vector2.new(0.5, 1)
        BackpackTooltip.Size = UDim2.fromOffset(280, 0)
        BackpackTooltip.AutomaticSize = Enum.AutomaticSize.Y
        BackpackTooltip.BackgroundColor3 = Color3.fromRGB(20, 24, 32)
        BackpackTooltip.BackgroundTransparency = 0.08
        BackpackTooltip.TextColor3 = Color3.fromRGB(240, 247, 255)
        BackpackTooltip.TextSize = 16
        BackpackTooltip.TextWrapped = true
        BackpackTooltip.TextXAlignment = Enum.TextXAlignment.Left
        BackpackTooltip.TextYAlignment = Enum.TextYAlignment.Center
        BackpackTooltip.Visible = false
        BackpackTooltip.ZIndex = 500
        BackpackTooltip.Parent = a0.HUD
        local UIPadding = Instance.new("UIPadding")
        UIPadding.PaddingLeft = UDim.new(0, 10)
        UIPadding.PaddingRight = UDim.new(0, 10)
        UIPadding.PaddingTop = UDim.new(0, 7)
        UIPadding.PaddingBottom = UDim.new(0, 7)
        UIPadding.Parent = BackpackTooltip
        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = v4
        UIStroke.Transparency = 0.2
        UIStroke.Thickness = 1
        UIStroke.Parent = BackpackTooltip
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 5)
        UICorner.Parent = BackpackTooltip
    end

    BackpackTooltip.FontFace = v10
    a0.Tooltip = BackpackTooltip
end

v3._createSupportGui = _createSupportGui

local function _prepareUI(a0) --[[ Upvalues: UserInputService (copy), setInconsolata (copy) ]]
    a0.HotbarFrame = a0.HUD:WaitForChild("Hotbar")
    a0.HotbarFrame.Visible = false
    a0.BackpackFrame = a0.HUD:WaitForChild("Backpack")
    a0.BackpackList = a0.BackpackFrame:WaitForChild("List")
    a0.Template = a0.BackpackList:WaitForChild("Template")
    a0.Search = a0.BackpackFrame:FindFirstChild("Search")
    a0.BackpackLabel = a0.BackpackFrame:FindFirstChild("BackpackLabel")
    a0:_createSupportGui()
    local v57 = a0.BackpackList:FindFirstChildOfClass("UIListLayout") or a0.BackpackList:FindFirstChildOfClass("UIGridLayout")
    a0.BackpackLayout = v57
    local v58 = a0.BackpackList:GetPropertyChangedSignal("CanvasPosition")
    a0:_connect(v58, function() --[[ Upvalues: a0 (copy) ]]
        a0:_queueBackpackViewportRefresh()
    end)
    local v59 = a0.BackpackList:GetPropertyChangedSignal("AbsoluteSize")
    a0:_connect(v59, function() --[[ Upvalues: a0 (copy) ]]
        a0:_queueBackpackViewportRefresh()
    end)
    if a0.BackpackLayout then
        local v60 = a0.BackpackLayout:GetPropertyChangedSignal("AbsoluteContentSize")
        a0:_connect(v60, function() --[[ Upvalues: a0 (copy) ]]
            a0:_queueBackpackViewportRefresh()
        end)
    end

    a0.Template.Visible = false
    a0.Template.Selectable = false
    local v61 = a0.Template:FindFirstChildOfClass("UIDragDetector")
    if v61 then
        v61:Destroy()
    end

    a0:_makeViewport(a0.Template)
    a0.HotbarButtons = {}
    for i2 = 1, 10 do
        if i2 == 10 then
            v61 = "0"
        else
            v61 = tostring(i2)
        end

        local v64 = a0.HotbarFrame:WaitForChild(v61)
        v64.Visible = true
        v64.LayoutOrder = i2
        v64.Selectable = true
        v64:SetAttribute("InventoryButton", true)
        v64:SetAttribute("ButtonKind", "Hotbar")
        v64:SetAttribute("SlotIndex", i2)
        local v65 = v64:FindFirstChildOfClass("UIDragDetector")
        if v65 then
            v65:Destroy()
        end

        local Number = v64:FindFirstChild("Number")
        if Number and Number:IsA("TextLabel") then
            Number.Text = v61
            local v67 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
            Number.Visible = not v67
        end

        a0:_makeViewport(v64)
        a0.HotbarButtons[i2] = v64
        a0:_bindButton(v64)
    end

    if a0.BackpackLabel and a0.BackpackLabel:IsA("TextLabel") then
        a0.BackpackLabel.Text = "BACKPACK"
    end

    if a0.Search and a0.Search:IsA("TextBox") then
        a0.Search.PlaceholderText = "SEARCH ITEMS..."
        a0.Search.ClearTextOnFocus = false
        local v68 = a0.Search:GetPropertyChangedSignal("Text")
        a0:_connect(v68, function() --[[ Upvalues: a0 (copy) ]]
            a0:_updateBackpackVisibility()
        end)
    end

    a0.BackpackFrame.Visible = false
    setInconsolata(a0.HotbarFrame)
    setInconsolata(a0.BackpackFrame)
end

v3._prepareUI = _prepareUI

local function _considerNewTool(a0, a1)
    local v71 = a1 and a1:IsA("Tool")
    if not v71 or a0.ToolSet[a1] or a0.PendingAutoSlot[a1] then
        return
    end

    if a1:GetAttribute("HotbarRestored") and not a0.AllowRestoredAutoSlot then
        return
    end

    a0.NewItemSequence = a0.NewItemSequence + 1
    a0.PendingAutoSlot[a1] = a0.NewItemSequence
end

v3._considerNewTool = _considerNewTool

local function _watchCharacter(a0, a1)
    a0:_cancelControllerTransfer()
    if a0.ControllerNavigationActive then
        a0:SetOpen(false)
    end

    a0:_cancelPointerDrag()
    local CharacterConnections = a0.CharacterConnections
    local v72 = nil
    local v73 = nil
    for k7, k8 in CharacterConnections do
        k8:Disconnect()
    end

    table.clear(a0.CharacterConnections)
    a0.Character = a1
    if a1 then

        local function watchHumanoid(a0) --[[ Upvalues: a0 (copy) ]]
            if a0:IsA("Humanoid") then

                local function releaseOnDeath() --[[ Upvalues: a0 (upvalue) ]]
                    if a0.ControllerNavigationActive then
                        a0:SetOpen(false)
                    end
                end

                local v74 = a0.Died:Connect(releaseOnDeath)
                table.insert(a0.CharacterConnections, v74)
                local v75 = a0.HealthChanged:Connect(function(a0) --[[ Upvalues: a0 (upvalue) ]]
                    if a0 <= 0 and a0.ControllerNavigationActive then
                        a0:SetOpen(false)
                    end

                end)
                table.insert(a0.CharacterConnections, v75)
            end
        end

        local v76 = a1:FindFirstChildOfClass("Humanoid")
        if v76 then
            watchHumanoid(v76)
        end

        local v77 = a1.ChildAdded:Connect(function(a0) --[[ Upvalues: watchHumanoid (copy), a0 (copy) ]]
            watchHumanoid(a0)
            a0:_considerNewTool(a0)
            a0:_queueRefresh()
        end)
        table.insert(a0.CharacterConnections, v77)
        local v78 = a1.ChildRemoved:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:_queueRefresh()
        end)
        table.insert(a0.CharacterConnections, v78)
    end

    a0:_queueRefresh()
end

v3._watchCharacter = _watchCharacter

local function _watchBackpack(a0, a1)
    a0:_cancelPointerDrag()
    local BackpackConnections = a0.BackpackConnections
    local v79 = nil
    local v80 = nil
    for k9, k10 in BackpackConnections do
        k10:Disconnect()
    end

    table.clear(a0.BackpackConnections)
    a0.Backpack = a1
    if a1 then
        local v81 = a1.ChildAdded:Connect(function(a0) --[[ Upvalues: a0 (copy) ]]
            a0:_considerNewTool(a0)
            a0:_queueRefresh()
        end)
        table.insert(a0.BackpackConnections, v81)
        local v82 = a1.ChildRemoved:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:_queueRefresh()
        end)
        table.insert(a0.BackpackConnections, v82)
    end

    a0:_queueRefresh()
end

v3._watchBackpack = _watchBackpack

local function _watchTools(a0)
    a0:_connect(a0.Player.CharacterAdded, function(a0) --[[ Upvalues: a0 (copy) ]]
        a0:_watchCharacter(a0)
        task.defer(function() --[[ Upvalues: a0 (upvalue) ]]
            if a0.Destroyed then
                return
            end

            local v83 = a0.Player:FindFirstChildOfClass("Backpack")
            if v83 ~= a0.Backpack then
                a0:_watchBackpack(v83)
            end

        end)
    end)
    a0:_connect(a0.Player.CharacterRemoving, function(a0) --[[ Upvalues: a0 (copy) ]]
        if a0.ControllerNavigationActive then
            a0:SetOpen(false)
        end

        a0.AllowRestoredAutoSlot = false
        for i3 = 1, 10 do
            local v86 = a0.SavedNames[i3]
            if v86 and v86 ~= "" then
                a0.RestoreNames[i3] = v86
            end
        end

        if a0.Character == a0 then
            a0:_watchCharacter(nil)
        end

    end)
    a0:_connect(a0.Player.ChildAdded, function(a0) --[[ Upvalues: a0 (copy) ]]
        if a0:IsA("Backpack") and a0 ~= a0.Backpack then
            a0:_watchBackpack(a0)
        end

    end)
    a0:_connect(a0.Player.ChildRemoved, function(a0) --[[ Upvalues: a0 (copy) ]]
        if a0 == a0.Backpack then
            a0:_watchBackpack(nil)
        end

    end)
    local v88 = a0.Player:FindFirstChildOfClass("Backpack") or a0.Backpack
    a0:_watchBackpack(v88)
    a0:_watchCharacter(a0.Player.Character)
end

v3._watchTools = _watchTools

local function _collectTools(a0)
    local t1 = {}
    local t2 = {}

    local function collect(a0) --[[ Upvalues: t2 (copy), t1 (copy) ]]
        if not a0 then
            return
        end

        for k11, k12 in a0:GetChildren() do
            local v94 = k12 and k12:IsA("Tool")
            if v94 and not t2[k12] then
                t2[k12] = true
                table.insert(t1, k12)
            end
        end
    end

    collect(a0.Backpack)
    collect(a0.Character)
    table.sort(t1, function(a0, a1)
        local lower = string.lower
        local v95 = a0:GetAttribute("ToolName")
        local v96
        if typeof(v95) == "string" and v95 ~= "" then
            v96 = v95
        else
            v96 = a0.Name
        end

        local v97 = lower(v96)
        v96 = string.lower
        local v98 = a1:GetAttribute("ToolName")
        if typeof(v98) == "string" and v98 ~= "" then
            v95 = v98
        else
            v95 = a1.Name
        end

        local v99 = v96(v95)
        if v97 == v99 then
            return a0.Name < a1.Name
        end

        return v97 < v99
    end)
    return t1, t2
end

v3._collectTools = _collectTools

local function _reconcileTools(a0, a1, a2)
    if not (a1 and a2) then
        local v100, v101 = a0:_collectTools()
        a1 = v100
        a2 = v101
    end

    local v102 = {}
    local ToolConnections = a0.ToolConnections
    local v103 = nil
    local v104 = nil
    local v105, v106
    for k13, k14 in ToolConnections do
        v105 = a2[k13]
        if not v105 then
            v105 = k14
            local v108 = nil
            local v109 = nil
            for k15, k16 in v105 do
                k16:Disconnect()
            end

            v105 = a0.ToolConnections
            v105[k13] = nil
        end
    end

    ToolConnections = a1
    v103 = nil
    v104 = nil
    for k17, k18 in ToolConnections do
        a0:_considerNewTool(k18)
        local v110 = a0.ToolConnections[k18]
        if not v110 then
            v110 = a0.ToolConnections
            local v111 = k18:GetPropertyChangedSignal("Name")
            local v112 = v111:Connect(function() --[[ Upvalues: a0 (copy), k18 (copy) ]]
                a0:_queueToolVisualRefresh(k18)
            end)
            local v113 = k18:GetAttributeChangedSignal("Quantity")
            local v114 = v113:Connect(function() --[[ Upvalues: a0 (copy), k18 (copy) ]]
                a0:_queueToolVisualRefresh(k18)
            end)
            local v115 = k18:GetAttributeChangedSignal("ToolName")
            local v117 = {
                v112,
                v114,
                v115:Connect(function() --[[ Upvalues: a0 (copy) ]]
                a0:_queueRefresh(true)
            end)
            }
            v110[k18] = v117
        end
    end

    if a0.ApplySavedLayout then
        table.clear(a0.HotbarTools)
    else
        local v118 = 10
        v103 = 1
        for i4 = 1, v118, v103 do
            k17 = a0.HotbarTools[i4]
            local v119
            if k17 and a2[k17] and not v102[k17] then
                v119 = true
                v102[k17] = v119
            else
                v119 = a0.HotbarTools
                v105 = nil
                v119[i4] = v105
            end
        end
    end

    local v120 = 10
    v103 = 1
    for i5 = 1, v120, v103 do
        k18 = a0.HotbarTools
        if not k18[i5] then
            k18 = a0.RestoreNames
            local v122 = k18[i5]
            if v122 and v122 ~= "" then
                k18 = a1
                v105 = nil
                local v123 = nil
                for k19, k20 in k18 do
                    if not v102[k20] then
                        if not a0.PendingAutoSlot[k20] then
                            if a0.ApplySavedLayout or k20:GetAttribute("HotbarRestored") then
                                local v124 = k20:GetAttribute("ToolName")
                                local v125
                                if typeof(v124) == "string" and v124 ~= "" then
                                    v125 = v124
                                else
                                    v125 = k20.Name
                                end

                                if v125 == v122 then
                                    a0.HotbarTools[i5] = k20
                                    a0.RestoreNames[i5] = nil
                                    v102[k20] = true
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    v120 = {}
    v103 = a0.PendingAutoSlot
    i5 = nil
    k17 = nil
    for k21, k22 in v103 do
        if a2[k21] then
            v106 = {Tool = k21, Sequence = k22}
            table.insert(v120, v106)
        else
            a0.PendingAutoSlot[k21] = nil
        end
    end

    table.sort(v120, function(a0, a1)
        return a0.Sequence < a1.Sequence
    end)
    local v126 = v120
    local v127 = nil
    local v128 = nil
    for k23, k24 in v126 do
        local Tool = k24.Tool
        if not v102[Tool] then
            local v129 = 10
            v106 = 1
            for i6 = 1, v129, v106 do
                if not a0.HotbarTools[i6] then
                    a0.HotbarTools[i6] = Tool
                    a0.RestoreNames[i6] = nil
                    v102[Tool] = true
                    break
                end
            end
        end

        a0.PendingAutoSlot[Tool] = nil
    end

    a0.Tools = a1
    a0.ToolSet = a2
    a0.ApplySavedLayout = false
    v120 = false
    local v130 = 10
    v127 = 1
    for i7 = 1, v130, v127 do
        v102 = a0.HotbarTools[i7]
        if v102 then
            local v131 = v102:GetAttribute("ToolName")
            if typeof(v131) == "string" and v131 ~= "" then
                k23 = v131
            else
                k23 = v102.Name
            end

            if a0.HotbarTools then
                -- jump to 287
            end
        end

        k23 = ""
        if a0.SavedNames[i7] ~= k23 then
            a0.SavedNames[i7] = k23
            v120 = true
        end
    end

    if a0.DataLoaded and not a0.SavedInitialized and 0 < #a1 then
        a0.SavedInitialized = true
        v120 = true
    end

    if v120 then
        a0:_scheduleSave()
    end
end

v3._reconcileTools = _reconcileTools

local function _findEquippedTool(a0)
    local Tools1 = a0.Tools
    local v132 = nil
    local v133 = nil
    for k25, k26 in Tools1 do
        if a0:_isEquipped(k26) then
            return k26
        end
    end

    return nil
end

v3._findEquippedTool = _findEquippedTool

local function _canUseEquipOnlyRefresh(a0, a1)
    if not a0.HasRendered or a0.ApplySavedLayout or next(a0.PendingAutoSlot) ~= nil then
        return false
    end

    local ToolSet = a0.ToolSet
    local v134 = nil
    local v135 = nil
    for k27 in ToolSet do
        if not a1[k27] then
            return false
        end
    end

    ToolSet = a1
    v134 = nil
    v135 = nil
    for k28 in ToolSet do
        if not a0.ToolSet[k28] then
            return false
        end
    end

    ToolSet = {}
    v134 = 10
    v135 = 1
    local v136
    for i8 = 1, v134, v135 do
        v136 = a0.HotbarTools[i8]
        if v136 then
            ToolSet[v136] = true
        end
    end

    v134 = a1
    v135 = nil
    i8 = nil
    for k29 in v134 do
        if not ToolSet[k29] then
            local v137 = a0.BackpackButtons[k29]
            if not v137 or v137.Parent ~= a0.BackpackList then
                return false
            end
        end
    end

    return true
end

v3._canUseEquipOnlyRefresh = _canUseEquipOnlyRefresh

local function _refreshEquippedStyles(a0)
    local v138 = a0:_findEquippedTool()
    local v139 = {}
    if a0.LastEquippedTool then
        v139[a0.LastEquippedTool] = true
    end

    if v138 then
        v139[v138] = true
    end

    local ButtonTools = a0.ButtonTools
    local v140 = nil
    local v141 = nil
    for k30, k31 in ButtonTools do
        if k31 then
            if v139[k31] then
                local v142 = false
                if a0.GamepadHeldTool == k31 then
                    v142 = a0.GamepadHeldButton == k30
                end

                a0:_styleButton(k30, k31, v142)
            end
        end
    end

    a0.LastEquippedTool = v138
end

v3._refreshEquippedStyles = _refreshEquippedStyles

local function _queueRefresh(a0, a1)
    if a1 then
        a0.ForceFullRefresh = true
    end

    if not (not a0.RefreshQueued and not a0.Destroyed and a0.DataLoaded) then
        return
    end

    a0.RefreshQueued = true
    task.defer(function() --[[ Upvalues: a0 (copy) ]]
        if a0.Destroyed then
            return
        end

        a0.RefreshQueued = false
        local v143, v144 = a0:_collectTools()
        local v146 = a0.ForceFullRefresh or not a0:_canUseEquipOnlyRefresh(v144)
        a0.ForceFullRefresh = false
        if not v146 then
            a0.Tools = v143
            a0.ToolSet = v144
            a0:_refreshEquippedStyles()
            return
        end

        a0:_reconcileTools(v143, v144)
        a0:_render()
        a0.HasRendered = true
        a0.HotbarFrame.Visible = a0.Enabled
    end)
end

v3._queueRefresh = _queueRefresh

local function _buttonTool(a0, a1)
    return a0.ButtonTools[a1]
end

v3._buttonTool = _buttonTool

local function _usingGamepadCursor(a0) --[[ Upvalues: GamepadService (copy) ]]
    return GamepadService.GamepadCursorEnabled
end

v3._usingGamepadCursor = _usingGamepadCursor

local function _getPointerPosition(a0) --[[ Upvalues: UserInputService (copy), GuiService (copy) ]]
    local v147 = UserInputService:GetMouseLocation()
    return v147 - GuiService:GetGuiInset()
end

v3._getPointerPosition = _getPointerPosition

local function _isInventoryGuiVisible(a0, a1)
    if not a1 then
        return false
    end

    if not a0.HUD then
        return false
    end

    if a1 ~= a0.HUD then
        if not a1:IsDescendantOf(a0.HUD) then
            return false
        end
    end

    local v148 = a1
    while v148 do
        if v148 == a0.PlayerGui then
            break
        end

        if not v148:IsA("GuiObject") or v148.Visible then
            if v148:IsA("ScreenGui") then
                if v148.Enabled then
                    -- jump to 43
                end

                -- branch continues at 43
            end
        end

        return false
        v148 = v148.Parent
    end

    return v148 == a0.PlayerGui
end

v3._isInventoryGuiVisible = _isInventoryGuiVisible

local function _releaseSearchFocus(a0) --[[ Upvalues: UserInputService (copy) ]]
    if a0.Search then
        local v150 = UserInputService:GetFocusedTextBox()
        if v150 == a0.Search then
            a0.Search:ReleaseFocus()
        end
    end
end

v3._releaseSearchFocus = _releaseSearchFocus

local function _syncInventoryVisibility(a0)
    if a0.Destroyed then
        return
    end

    if a0:_isInventoryGuiVisible(a0.HUD) then
        if a0.Open then
            if a0:_isInventoryGuiVisible(a0.BackpackFrame) then
                -- jump to 35
            end

            -- branch continues at 35
        end
    end

    if a0.Open or a0.ControllerNavigationActive or a0.PointerDrag then
        a0:SetOpen(false)
    end

    if a0.Search and not a0:_isInventoryGuiVisible(a0.Search) then
        a0:_releaseSearchFocus()
    end
end

v3._syncInventoryVisibility = _syncInventoryVisibility

local function _blockMouseActivation(a0, a1)
    if a1 then
        if a1.Mouse then
            if not a1.VirtualCursor then
                if a1.Button then
                    local BlockedMouseActivations = a0.BlockedMouseActivations
                    if not BlockedMouseActivations then
                        local v151 = setmetatable({}, {__mode = "k"})
                    end

                    a0.BlockedMouseActivations = BlockedMouseActivations
                    a0.BlockedMouseActivations[a1.Button] = true
                end
            end
        end
    end
end

v3._blockMouseActivation = _blockMouseActivation

local function _disconnectButton(a0, a1)
    local v152 = a0.ButtonConnections[a1]
    if v152 then
        local v153 = v152
        local v154 = nil
        local v155 = nil
        for k32, k33 in v153 do
            k33:Disconnect()
        end

        a0.ButtonConnections[a1] = nil
    end

    if a1 and a1.Parent then
        a1:SetAttribute("CustomBackpackBound", nil)
    end
end

v3._disconnectButton = _disconnectButton

local function _bindButton(a0, a1) --[[ Upvalues: GuiService (copy) ]]
    if a1:GetAttribute("CustomBackpackBound") then
        return
    end

    a1:SetAttribute("CustomBackpackBound", true)
    local v156 = {}
    a0.ButtonConnections[a1] = v156

    local function bind(a0, a1) --[[ Upvalues: v156 (copy) ]]
        local v157 = a0:Connect(a1)
        table.insert(v156, v157)
    end

    local v159 = a1.Activated:Connect(function(a0) --[[ Upvalues: a0 (copy), a1 (copy), GuiService (upvalue) ]]
        if a0 and a0.UserInputType == Enum.UserInputType.Touch then
            return
        end

        if not a0 or a0.UserInputType == Enum.UserInputType.MouseButton1 then
            if a0.BlockedMouseActivations and a0.BlockedMouseActivations[a1] then
                return
            end
        end

        if not (not a0.Destroyed and not GuiService.MenuIsOpen and a0:_isInventoryGuiVisible(a1)) then
            return
        end

        if a0.PointerDrag then
            if not a0.PointerDrag.Mouse or a0.PointerDrag.Dragging then
                return
            end
        end

        if not a0.Enabled then
            return
        end

        if os.clock() < (a0.SuppressActivatedUntil[a1] or 0) then
            return
        end

        if a0.ControllerNavigationActive then
            if not a0.ControllerCursorMode then
                return
            end

            if a0.GamepadHeldTool then
                a0:_handleGamepadMove(a1)
                return
            end
        end

        local v158 = a0:_buttonTool(a1)
        if v158 then
            a0:_toggleEquip(v158)
        end

    end)
    table.insert(v156, v159)
    local v161 = a1.MouseEnter:Connect(function() --[[ Upvalues: a0 (copy), a1 (copy) ]]
        local v160 = a0:_buttonTool(a1)
        if v160 then
            a0:_showTooltip(v160, a1)
        end

    end)
    table.insert(v156, v161)
    local v162 = a1.MouseLeave:Connect(function() --[[ Upvalues: a0 (copy), a1 (copy), GuiService (upvalue) ]]
        if a0.TooltipOwner == a1 and GuiService.SelectedObject ~= a1 then
            a0:_hideTooltip(a1)
        end

    end)
    table.insert(v156, v162)
    local v164 = a1.SelectionGained:Connect(function() --[[ Upvalues: a0 (copy), a1 (copy) ]]
        local v163 = a0:_buttonTool(a1)
        if v163 then
            a0:_showTooltip(v163, a1)
        end

    end)
    table.insert(v156, v164)
    local v165 = a1.SelectionLost:Connect(function() --[[ Upvalues: a0 (copy), a1 (copy) ]]
        if a0.TooltipOwner == a1 and a0.GamepadHeldButton ~= a1 then
            a0:_hideTooltip(a1)
        end

    end)
    table.insert(v156, v165)
    local v178 = a1.InputBegan:Connect(function(a0) --[[ Upvalues: a0 (copy), GuiService (upvalue), a1 (copy) ]]
        if not (a0.Enabled and not a0.Destroyed and not GuiService.MenuIsOpen and a0:_isInventoryGuiVisible(a1)) then
            return
        end

        local UserInputType = a0.UserInputType
        if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local v166 = false
        if UserInputType == Enum.UserInputType.MouseButton1 then
            v166 = not a0:_usingGamepadCursor()
        end

        if UserInputType == Enum.UserInputType.Touch or v166 then
            if a0.ControllerNavigationActive then
                a0:_setControllerNavigation(false)
            end
        end

        if v166 and a0.PointerDrag and a0.PointerDrag.Mouse and not a0.PointerDrag.VirtualCursor then
            a0:_cancelPointerDrag()
        end

        if UserInputType == Enum.UserInputType.MouseButton1 then
            if a0.BlockedMouseActivations then
                a0.BlockedMouseActivations[a1] = nil
            end

            if v166 then
                a0.SuppressActivatedUntil[a1] = nil
            end
        end

        if a0.PointerDrag or a0.GamepadHeldTool then
            return
        end

        local v167 = a0:_buttonTool(a1)
        if not v167 then
            return
        end

        if not a0.Open and UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local v168 = false
        if UserInputType == Enum.UserInputType.MouseButton1 then
            local v169 = a0:_usingGamepadCursor()
        end

        local v171
        if not (v168 and a0:_getPointerPosition()) then
            local v172 = Vector2.new(a0.Position.X, a0.Position.Y)
        end

        local v173 = {
            Dragging = false,
            Ghost = nil,
            Scrolling = false,
            Button = a1,
            Tool = v167
        }
        local v176 = a1:GetAttribute("ButtonKind") == "Hotbar" and a1:GetAttribute("SlotIndex") or nil
        v173.SourceSlot = v176
        v173.Input = a0
        v173.Mouse = UserInputType == Enum.UserInputType.MouseButton1
        v173.VirtualCursor = v168
        v173.Start = v171
        v173.Position = v171
        v173.CanDrag = a0.Open
        v173.StartedAt = os.clock()
        v173.CanvasStart = a0.BackpackList.CanvasPosition
        a0.PointerDrag = v173
        if UserInputType == Enum.UserInputType.Touch then
            v173.InputStateConnection = a0.Changed:Connect(function() --[[ Upvalues: a0 (upvalue), v173 (copy), a0 (copy) ]]
                if a0.PointerDrag ~= v173 then
                    a0:_disconnectDragInput(v173)
                    return
                end

                local UserInputState = a0.UserInputState
                if UserInputState == Enum.UserInputState.Cancel then
                    a0:_cancelPointerDrag()
                    return
                end

                local v177 = Vector2.new(a0.Position.X, a0.Position.Y)
                if v177 ~= v173.Position then
                    a0:_updatePointerDragPosition(v173, v177)
                end

                if UserInputState == Enum.UserInputState.End then
                    a0:_finishPointerDrag(a0)
                end

            end)
            a0:_showTooltip(v167, a1)
        end

    end)
    table.insert(v156, v178)
end

v3._bindButton = _bindButton

local function _restoreDragScrolling(a0, a1)
    if a1 and a1.SavedScrollingEnabled ~= nil then
        a0.BackpackList.ScrollingEnabled = a1.SavedScrollingEnabled
        a1.SavedScrollingEnabled = nil
    end
end

v3._restoreDragScrolling = _restoreDragScrolling

local function _startPointerDrag(a0, a1)
    if a1.Dragging then
        return
    end

    a1.Dragging = true
    if not a1.Mouse then
        a1.SavedScrollingEnabled = a0.BackpackList.ScrollingEnabled
        a0.BackpackList.ScrollingEnabled = false
        a0.BackpackList:ResetScrollVelocity()
        a0:_hideTooltip(a1.Button)
    end

    a0.SuppressActivatedUntil[a1.Button] = os.clock() + 0.35
    a0:_createDragGhost(a1)
    a0:_styleButton(a1.Button, a1.Tool, false)
end

v3._startPointerDrag = _startPointerDrag

local function _updateTouchHold(a0, a1)
    if a1.Mouse or a1.Dragging or a1.Scrolling or not a1.CanDrag or a1.SourceSlot then
        return
    end

    if 2 < (a0.BackpackList.CanvasPosition - a1.CanvasStart).Magnitude then
        a1.Scrolling = true
        a0:_hideTooltip(a1.Button)
        return
    end

    local v179 = os.clock() - a1.StartedAt
    if 0.2 <= v179 then
        a0:_startPointerDrag(a1)
    end
end

v3._updateTouchHold = _updateTouchHold

local function _disconnectDragInput(a0, a1)
    local v181 = a1 and a1.InputStateConnection
    if v181 then
        a1.InputStateConnection = nil
        v181:Disconnect()
    end
end

v3._disconnectDragInput = _disconnectDragInput

local function _destroyDragGhost(a0, a1)
    if not a1 then
        return
    end

    a0.DragGhosts[a1] = nil
    a1:Destroy()
end

v3._destroyDragGhost = _destroyDragGhost

local function _destroyAllDragGhosts(a0, a1)
    local v182
    if a1 and a1.Ghost then
        a1.Ghost = nil
        v182 = a1.Ghost
        a0:_destroyDragGhost(v182)
    end

    local DragGhosts = a0.DragGhosts
    local v183 = nil
    local v184 = nil
    for k34 in DragGhosts do
        a0:_destroyDragGhost(k34)
    end

    table.clear(a0.DragGhosts)
    if a0.HUD then
        for k35, k36 in a0.HUD:GetChildren() do
            if k36.Name == "BackpackDragGhost" or k36:GetAttribute("CustomBackpackDragGhost") == true then
                k36:Destroy()
            end
        end
    end
end

v3._destroyAllDragGhosts = _destroyAllDragGhosts

local function _positionDragGhost(a0, a1)
    if not a1.Ghost then
        return
    end

    local v188 = a1.Position - a0.HUD.AbsolutePosition
    a1.Ghost.Position = UDim2.fromOffset(v188.X, v188.Y)
end

v3._positionDragGhost = _positionDragGhost

local function _createDragGhost(a0, a1)
    a0:_destroyAllDragGhosts()
    local v189 = a1.Button:Clone()
    v189.Name = "BackpackDragGhost"
    v189:SetAttribute("CustomBackpackDragGhost", true)
    v189:SetAttribute("InventoryButton", nil)
    v189:SetAttribute("ButtonKind", nil)
    v189:SetAttribute("SlotIndex", nil)
    v189:SetAttribute("CustomBackpackBound", nil)
    v189.Active = false
    v189.Selectable = false
    v189.AutoButtonColor = false
    v189.AnchorPoint = Vector2.new(0.5, 0.5)
    v189.Size = UDim2.fromOffset(a1.Button.AbsoluteSize.X, a1.Button.AbsoluteSize.Y)
    v189.ZIndex = 450
    v189.BackgroundTransparency = 0.15
    for k37, k38 in v189:GetDescendants() do
        if k38:IsA("UIDragDetector") then
            k38:Destroy()
        else
            if k38:IsA("GuiObject") then
                k38.ZIndex = math.max(k38.ZIndex, 451)
            end
        end
    end

    a1.Ghost = v189
    a0.DragGhosts[v189] = true
    v189.Parent = a0.HUD
    a0:_positionDragGhost(a1)
end

v3._createDragGhost = _createDragGhost

local function _updatePointerDragPosition(a0, a1, a2)
    a1.Position = a2
    local Magnitude = (a2 - a1.Start).Magnitude
    if not a1.Mouse then
        if not a1.Dragging then
            if not a1.SourceSlot and a1.CanvasStart and 2 < (a0.BackpackList.CanvasPosition - a1.CanvasStart).Magnitude then
                a1.Scrolling = true
                a0:_hideTooltip(a1.Button)
            end

            if 14 <= Magnitude then
                if a1.CanDrag and a1.SourceSlot and not a1.Scrolling then
                    a0:_startPointerDrag(a1)
                    -- jump to 79 (out of range)
                end

                a1.Scrolling = true
                a0:_hideTooltip(a1.Button)
                -- branch continues at 79
            end

            -- branch continues at 68
        end
    else
        if not a1.Dragging and 9 <= Magnitude then
            a0:_startPointerDrag(a1)
        end
    end

    a0:_positionDragGhost(a1)
end

v3._updatePointerDragPosition = _updatePointerDragPosition

local function _updatePointerDrag(a0, a1)
    local PointerDrag = a0.PointerDrag
    if not PointerDrag or PointerDrag.VirtualCursor then
        return
    end

    if PointerDrag.Mouse then
        if a1.UserInputType ~= Enum.UserInputType.MouseMovement then
            return
            -- branch continues at 23
        end
    else
        if a1 ~= PointerDrag.Input then
            return
        end
    end

    local v193 = Vector2.new(a1.Position.X, a1.Position.Y)
    a0:_updatePointerDragPosition(PointerDrag, v193)
end

v3._updatePointerDrag = _updatePointerDrag

local function _cancelPointerDrag(a0)
    local PointerDrag1 = a0.PointerDrag
    a0.PointerDrag = nil
    a0:_blockMouseActivation(PointerDrag1)
    a0:_disconnectDragInput(PointerDrag1)
    a0:_destroyAllDragGhosts(PointerDrag1)
    if PointerDrag1 then
        a0:_restoreDragScrolling(PointerDrag1)
        if PointerDrag1.Button then
            a0:_setButtonDragVisual(PointerDrag1.Button, false)
            if PointerDrag1.Button.Parent then
                local v194 = a0:_buttonTool(PointerDrag1.Button)
                a0:_styleButton(PointerDrag1.Button, v194, false)
            end
        end

        if PointerDrag1.Dragging and PointerDrag1.Button then
            a0.SuppressActivatedUntil[PointerDrag1.Button] = os.clock() + 0.25
        end

        a0:_hideTooltip(PointerDrag1.Button)
    end
end

v3._cancelPointerDrag = _cancelPointerDrag

local function _updateMousePointerDrag(a0)
    local PointerDrag2 = a0.PointerDrag
    if not (PointerDrag2 and PointerDrag2.Mouse) then
        return
    end

    if PointerDrag2.VirtualCursor and not a0:_usingGamepadCursor() then
        a0:_cancelPointerDrag()
        return
    end

    local v195 = a0:_getPointerPosition()
    a0:_updatePointerDragPosition(PointerDrag2, v195)
end

v3._updateMousePointerDrag = _updateMousePointerDrag

local function _isPointerDragValid(a0, a1) --[[ Upvalues: GuiService (copy) ]]
    local v196 = not a0.Destroyed
    if v196 then
        v196 = a0.Enabled
        if v196 then
            v196 = not GuiService.MenuIsOpen
            if v196 then
                if a0.Open or false == false then
                    if a1.CanDrag == false or a0:_isInventoryGuiVisible(a0.BackpackFrame) then
                        local v199 = a0:_validControllerTool(a1.Tool)
                        if v199 then
                            local v200 = a0:_isInventoryGuiVisible(a1.Button)
                            if v200 then
                                local v201 = a0:_buttonTool(a1.Button)
                                v200 = v201 == a1.Tool
                            end
                        end
                    end
                end
            end
        end
    end

    return v196
end

v3._isPointerDragValid = _isPointerDragValid

local function _validatePointerDrag(a0) --[[ Upvalues: UserInputService (copy) ]]
    local PointerDrag3 = a0.PointerDrag
    if not PointerDrag3 then
        return
    end

    if not a0:_isPointerDragValid(PointerDrag3) then
        a0:_cancelPointerDrag()
        return
    end

    local UserInputState1 = PointerDrag3.Input.UserInputState
    if UserInputState1 == Enum.UserInputState.Cancel then
        a0:_cancelPointerDrag()
        return
    end

    if UserInputState1 == Enum.UserInputState.End then
        a0:_finishPointerDrag(PointerDrag3.Input)
        return
    end

    if PointerDrag3.Mouse and not PointerDrag3.VirtualCursor and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        a0:_cancelPointerDrag()
        return
    end

    if not PointerDrag3.Mouse then
        a0:_updateTouchHold(PointerDrag3)
    end

    if PointerDrag3.Dragging then
        if not PointerDrag3.Ghost or PointerDrag3.Ghost.Parent ~= a0.HUD then
            a0:_cancelPointerDrag()
            return
        end
    end
end

v3._validatePointerDrag = _validatePointerDrag

local function _findInventoryButton(a0, a1)
    local v202 = a1
    while v202 do
        if v202 == a0.HUD then
            break
        end

        if v202:IsA("TextBox") then
            return nil
        end

        if v202 == a0.BackpackFrame and a0.ControllerNavigationActive then
            return v202
        end

        if v202:IsA("GuiButton") then
            if v202:GetAttribute("InventoryButton") then
                if v202:IsDescendantOf(a0.HotbarFrame) or v202:IsDescendantOf(a0.BackpackFrame) then
                    return v202
                end

                return nil
            end
        end

        v202 = v202.Parent
    end

    return nil
end

v3._findInventoryButton = _findInventoryButton

local function _findInventoryButtonAt(a0, a1, a2)
    local v203 = a0.PlayerGui:GetGuiObjectsAtPosition(a1.X, a1.Y)
    local v204 = nil
    local v205 = nil
    for k39, k40 in v203 do
        local v206 = a2
        if v206 then
            v206 = true
            if k40 ~= a2 then
                local v207 = k40:IsDescendantOf(a2)
            end
        end

        if not v206 then
            if k40 ~= a0.Tooltip then
                if not k40:IsDescendantOf(a0.Tooltip) then
                    if a0.Search then
                        if k40 == a0.Search or k40:IsDescendantOf(a0.Search) then
                            return nil, true
                        end
                    end

                    local v208 = a0:_findInventoryButton(k40)
                    if v208 and v208.Visible then
                        return v208
                    end

                    v208 = k40
                    while v208 do
                        if v208 == a0.HUD then
                            break
                        end

                        if v208 == a0.PlayerGui then
                            break
                        end

                        if v208 == a0.BackpackList or v208 == a0.BackpackFrame or v208 == a0.HotbarFrame then
                            return nil, false
                        end

                        if v208:IsA("GuiButton") then
                            return nil, true
                        end

                        if v208:IsA("TextBox") then
                            return nil, true
                        end

                        if v208:IsA("GuiObject") then
                            if v208.Active then
                                return nil, true
                            end
                        end

                        v208 = v208.Parent
                    end
                end
            end
        end
    end

    return nil
end

v3._findInventoryButtonAt = _findInventoryButtonAt

local function _dropPointerDrag(a0, a1)
    if not a0:_validControllerTool(a1.Tool) then
        return
    end

    local v209 = nil
    for i9 = 1, 10 do
        local v212 = a0.HotbarTools[i9]
        if v212 == a1.Tool then
            v209 = i9
            break
        end
    end

    local v213, v214 = a0:_findInventoryButtonAt(a1.Position, a1.Ghost)
    if v214 then
        return
    end

    if v213 then
        a0:_placeToolOnButton(a1.Tool, v213)
        return
    end

    if v209 then
        local HotbarFrame = a0.HotbarFrame
        local Position = a1.Position
        v214 = HotbarFrame.AbsolutePosition
        local AbsoluteSize1 = HotbarFrame.AbsoluteSize
        local v215 = false
        if v214.X <= Position.X then
            v215 = false
            if v214.Y <= Position.Y then
                v215 = false
                if Position.X <= v214.X + AbsoluteSize1.X then
                    v215 = Position.Y <= v214.Y + AbsoluteSize1.Y
                end
            end
        end

        if not v215 then
            if a1.Mouse or a0:_isBackpackBackgroundAt(a1.Position) then
                a0:_removeToolFromHotbar(v209)
            end
        end
    end
end

v3._dropPointerDrag = _dropPointerDrag

local function _isBackpackBackgroundAt(a0, a1)
    local BackpackFrame = a0.BackpackFrame
    local AbsolutePosition1 = BackpackFrame.AbsolutePosition
    local AbsoluteSize2 = BackpackFrame.AbsoluteSize
    local v216 = false
    local X = a1.X
    if AbsolutePosition1.X <= X then
        v216 = false
        X = a1.Y
        if AbsolutePosition1.Y <= X then
            v216 = false
            X = a1.X
            if X <= AbsolutePosition1.X + AbsoluteSize2.X then
                X = a1.Y
                v216 = X <= AbsolutePosition1.Y + AbsoluteSize2.Y
            end
        end
    end

    if not v216 then
        return false
    end

    for k41, k42 in a0.PlayerGui:GetGuiObjectsAtPosition(a1.X, a1.Y) do
        if k42 ~= a0.Tooltip then
            if not k42:IsDescendantOf(a0.Tooltip) then
                if k42 == a0.BackpackList or k42 == a0.BackpackFrame then
                    return true
                end

                if not k42:IsDescendantOf(a0.BackpackFrame) then
                    if k42:IsA("GuiButton") then
                        return false
                    end

                    if k42:IsA("TextBox") then
                        return false
                    end

                    if k42.Active then
                        return false
                        -- branch continues at 115
                    end
                else
                    if k42:IsA("GuiButton") or k42:IsA("TextBox") then
                        return false
                    end
                end
            end
        end
    end

    return false
end

v3._isBackpackBackgroundAt = _isBackpackBackgroundAt

local function _finishPointerDrag(a0, a1) --[[ Upvalues: GuiService (copy) ]]
    local PointerDrag4 = a0.PointerDrag
    if not PointerDrag4 then
        return
    end

    if PointerDrag4.Mouse then
        local VirtualCursor = PointerDrag4.VirtualCursor
        if VirtualCursor then
            VirtualCursor = a1.KeyCode == Enum.KeyCode.ButtonA
        end

        if not (a1.UserInputType == Enum.UserInputType.MouseButton1) then
            if not VirtualCursor then
                return
                -- branch continues at 53
            end

            -- branch continues at 53
        end
    else
        if a1 ~= PointerDrag4.Input then
            local UserInputState2 = PointerDrag4.Input.UserInputState
            if a1.UserInputType ~= Enum.UserInputType.Touch then
                return
            end

            if UserInputState2 ~= Enum.UserInputState.End then
                if UserInputState2 ~= Enum.UserInputState.Cancel then
                    return
                end
            end
        end
    end

    if a1.UserInputState == Enum.UserInputState.Cancel or PointerDrag4.Input.UserInputState == Enum.UserInputState.Cancel then
        a0:_cancelPointerDrag()
        return
    end

    if not a0:_isPointerDragValid(PointerDrag4) then
        a0:_cancelPointerDrag()
        return
    end

    if PointerDrag4.VirtualCursor then
        PointerDrag4.Position = a0:_getPointerPosition()
    else
        if PointerDrag4.Mouse then
            PointerDrag4.Position = Vector2.new(a1.Position.X, a1.Position.Y)
        else
            local v220 = Vector2.new(PointerDrag4.Input.Position.X, PointerDrag4.Input.Position.Y)
            a0:_updatePointerDragPosition(PointerDrag4, v220)
        end
    end

    a0.PointerDrag = nil
    a0:_disconnectDragInput(PointerDrag4)
    if PointerDrag4.Dragging then
        a0:_blockMouseActivation(PointerDrag4)
    end

    a0:_destroyAllDragGhosts(PointerDrag4)
    a0:_restoreDragScrolling(PointerDrag4)
    a0:_setButtonDragVisual(PointerDrag4.Button, false)
    if PointerDrag4.Button.Parent then
        local v221 = a0:_buttonTool(PointerDrag4.Button)
        a0:_styleButton(PointerDrag4.Button, v221, false)
    end

    local Dragging = PointerDrag4.Dragging
    local v222 = not PointerDrag4.Mouse
    if v222 then
        v222 = not Dragging
        if v222 then
            v222 = not PointerDrag4.Scrolling
            if v222 then
                v222 = a0.Enabled
                if v222 then
                    v222 = not a0.Destroyed
                    if v222 then
                        v222 = not GuiService.MenuIsOpen
                        if v222 then
                            local v223
                            if a0.Open or not PointerDrag4.CanDrag then
                                v223 = PointerDrag4.Button.Parent
                                if v223 then
                                    v223 = PointerDrag4.Button.Visible
                                    if v223 then
                                        v223 = false
                                        local v224 = a0:_buttonTool(PointerDrag4.Button)
                                        if v224 == PointerDrag4.Tool then
                                            local v225 = a0:_validControllerTool(PointerDrag4.Tool)
                                            if v225 then
                                                local Button = PointerDrag4.Button
                                                local Position1 = PointerDrag4.Position
                                                local AbsolutePosition2 = Button.AbsolutePosition
                                                local AbsoluteSize3 = Button.AbsoluteSize
                                                v225 = false
                                                if AbsolutePosition2.X <= Position1.X then
                                                    v225 = false
                                                    if AbsolutePosition2.Y <= Position1.Y then
                                                        v225 = false
                                                        if Position1.X <= AbsolutePosition2.X + AbsoluteSize3.X then
                                                            v225 = Position1.Y <= AbsolutePosition2.Y + AbsoluteSize3.Y
                                                        end
                                                    end
                                                end

                                                if v225 then
                                                    local v226 = a0:_findInventoryButtonAt(PointerDrag4.Position)
                                                    v225 = v226 == PointerDrag4.Button
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if Dragging then
        a0.SuppressActivatedUntil[PointerDrag4.Button] = os.clock() + 0.2
    end

    if Dragging then
        local v227, v228 = pcall(function() --[[ Upvalues: a0 (copy), PointerDrag4 (copy) ]]
            a0:_dropPointerDrag(PointerDrag4)
        end)
        if not v227 then
            warn("[CustomBackpack] Failed to finish pointer drag: " .. tostring(v228))
            a0:_queueRefresh()
        end
    end

    if v222 then
        a0:_toggleEquip(PointerDrag4.Tool)
    end

    if PointerDrag4.Input.UserInputType == Enum.UserInputType.Touch then
        local TooltipRevision = a0.TooltipRevision
        task.delay(0.8, function() --[[ Upvalues: a0 (copy), PointerDrag4 (copy), TooltipRevision (copy) ]]
            if not a0.Destroyed and a0.TooltipOwner == PointerDrag4.Button and a0.TooltipRevision == TooltipRevision then
                a0:_hideTooltip(PointerDrag4.Button)
            end

        end)
    end
end

v3._finishPointerDrag = _finishPointerDrag

local function _showTooltip(a0, a1, a2)
    a0.TooltipRevision = (a0.TooltipRevision or 0) + 1
    a0.TooltipOwner = a2
    local v229
    if a1.ToolTip ~= "" then
        v229 = a1.ToolTip
    else
        local v230 = a1:GetAttribute("ToolName")
        if typeof(v230) == "string" and v230 ~= "" then
            v229 = v230
        else
            v229 = a1.Name
        end
    end

    a0.Tooltip.Text = v229
    a0.Tooltip.Visible = v229 ~= ""
    if not a0.Tooltip.Visible then
        return
    end

    v229 = workspace.CurrentCamera
    local v232 = a2.AbsolutePosition.X + a2.AbsoluteSize.X * 0.5
    v229 = math.clamp(v232, 145, (v229 and v229.ViewportSize.X or 1280) - 145)
    v229 = v229 - a0.HUD.AbsolutePosition.X
    v233 = v233 - a0.HUD.AbsolutePosition.Y
    a0.Tooltip.Position = UDim2.fromOffset(v229, v233)
end

v3._showTooltip = _showTooltip

local function _hideTooltip(a0, a1)
    if a1 and a0.TooltipOwner ~= a1 then
        return
    end

    a0.TooltipOwner = nil
    a0.Tooltip.Visible = false
end

v3._hideTooltip = _hideTooltip

local function _isEquipped(a0, a1)
    local Character = a0.Character
    if Character then
        Character = a1.Parent == a0.Character
    end

    return Character
end

v3._isEquipped = _isEquipped

local function _toggleEquip(a0, a1)
    local Character1 = a0.Player.Character
    if not Character1 then
        return
    end

    local v234 = Character1:FindFirstChildOfClass("Humanoid")
    if Character1 ~= a0.Character or not v234 or v234.Health <= 0 then
        return
    end

    if a1.Parent == Character1 then
        v234:UnequipTools()
    else
        if a1.Parent == a0.Backpack then
            v234:EquipTool(a1)
        end
    end

    a0:_queueRefresh()
end

v3._toggleEquip = _toggleEquip

local function _placeToolOnButton(a0, a1, a2)
    if not (a0:_validControllerTool(a1) and a2 and a2.Parent) then
        return
    end

    local v235 = a2:GetAttribute("ButtonKind")
    if v235 == "Hotbar" then
        local v236 = a2:GetAttribute("SlotIndex")
        a0:_placeToolInSlot(a1, v236)
        return
    end

    if v235 ~= "Backpack" and a2 ~= a0.BackpackFrame then
        return
    end

    local v237 = nil
    for i10 = 1, 10 do
        if a0.HotbarTools[i10] == a1 then
            v237 = i10
            break
        end
    end

    if not v237 then
        return
    end

    local v242 = v235 == "Backpack" and a0:_buttonTool(a2) or nil
    if v242 then
        if not a0:_validControllerTool(v242) then
            return
        end

        a0:_placeToolInSlot(v242, v237)
        return
    end

    if a2 == a0.BackpackFrame then
        a0:_removeToolFromHotbar(v237)
    end
end

v3._placeToolOnButton = _placeToolOnButton

local function _placeToolInSlot(a0, a1, a2)
    local v245 = a1 and a1:IsA("Tool")
    if not v245 then
        return
    end

    if typeof(a2) ~= "number" or a2 < 1 or 10 < a2 then
        return
    end

    local v246 = nil
    for i11 = 1, 10 do
        if a0.HotbarTools[i11] == a1 then
            v246 = i11
            break
        end
    end

    if v246 == a2 then
        return
    end

    local v249 = a0.HotbarTools[a2]
    if v246 then
        a0.HotbarTools[v246] = v249
        a0.RestoreNames[v246] = nil
        local SavedNames = a0.SavedNames
        if v249 then
            local v250 = v249:GetAttribute("ToolName")
            local v251
            if typeof(v250) == "string" and v250 ~= "" then
                v251 = v250
            else
                v251 = v249.Name
            end

            if v251 then
                -- jump to 72
            end
        end

        local v252 = ""
        SavedNames[v246] = v252
    end

    a0.HotbarTools[a2] = a1
    a0.RestoreNames[a2] = nil
    local SavedNames1 = a0.SavedNames
    v249 = a1:GetAttribute("ToolName")
    local v253
    if typeof(v249) == "string" and v249 ~= "" then
        v253 = v249
    else
        v253 = a1.Name
    end

    SavedNames1[a2] = v253
    a0.SavedInitialized = true
    a0:_scheduleSave()
    a0:_render()
end

v3._placeToolInSlot = _placeToolInSlot

local function _removeToolFromHotbar(a0, a1)
    if typeof(a1) ~= "number" or a1 < 1 or 10 < a1 then
        return
    end

    if not a0.HotbarTools[a1] then
        if (a0.SavedNames[a1] or "") == "" and not a0.RestoreNames[a1] then
            return
        end
    end

    a0.HotbarTools[a1] = nil
    a0.RestoreNames[a1] = nil
    a0.SavedNames[a1] = ""
    a0.SavedInitialized = true
    a0:_scheduleSave()
    a0:_render()
end

v3._removeToolFromHotbar = _removeToolFromHotbar

local function _serializeHotbar(a0)
    local v254 = table.create(10, "")
    for i12 = 1, 10 do
        v254[i12] = a0.SavedNames[i12] or ""
    end

    local v257 = {Initialized = true, Slots = v254}
    return v257
end

v3._serializeHotbar = _serializeHotbar

local function _scheduleSave(a0)
    if not a0.DataLoaded or a0.Destroyed then
        return
    end

    local v258 = {}
    for i13 = 1, 10 do
        local v261 = a0.SavedNames[i13] or ""
        if a0.LastSentNames[i13] ~= v261 then
            v258[tostring(i13)] = v261
        end
    end

    if next(v258) == nil and a0.LastSentInitialized then
        return
    end

    local v262 = {Initialized = true, Changes = v258}
    a0.RemoteEvent:FireServer("SaveHotbarDelta", v262)
    for i14 = 1, 10 do
        a0.LastSentNames[i14] = a0.SavedNames[i14] or ""
    end

    a0.LastSentInitialized = true
end

v3._scheduleSave = _scheduleSave

local function SetSavedHotbar(a0, a1)
    local v265 = not a0.DataLoaded
    local v266 = {}
    local v267 = false
    if typeof(a1) == "table" then
        if typeof(a1.Slots) == "table" then
            v266 = a1.Slots
            v267 = a1.Initialized == true
        else
            v266 = a1
            v267 = next(a1) ~= nil
        end
    end

    local v268 = true
    if a0.DataLoaded ~= false then
        v268 = a0.SavedInitialized ~= v267
    end

    for i15 = 1, 10 do
        local v271 = v266[i15]
        if not v271 then
            v271 = v266[tostring(i15)]
        end

        if typeof(v271) ~= "string" then
            v271 = ""
        end

        if a0.SavedNames[i15] ~= v271 then
            v268 = true
        end

        a0.SavedNames[i15] = v271
        a0.LastSentNames[i15] = v271
    end

    a0.DataLoaded = true
    a0.SavedInitialized = v267
    a0.LastSentInitialized = v267
    if v265 then
        a0.AllowRestoredAutoSlot = not v267
    end

    if v268 then
        a0.RestoreNames = table.clone(a0.SavedNames)
        a0.ApplySavedLayout = true
        a0:_queueRefresh()
    end
end

v3.SetSavedHotbar = SetSavedHotbar

local function _setButtonDragVisual(a0, a1, a2)
    local v272 = a0.DragVisuals[a1]
    if not a2 then
        if v272 then
            local v273 = v272
            local v274 = nil
            local v275 = nil
            for k43, k44 in v273 do
                local v278 = k44
                local v279 = nil
                local v280 = nil
                for k45, k46 in v278 do
                    k43[k45] = k46
                end
            end

            a0.DragVisuals[a1] = nil
        end

        return
    end

    if not v272 then
        v272 = {}
        a0.DragVisuals[a1] = v272
    end

    local function fadeVisual(a0) --[[ Upvalues: v272 (ref) ]]
        if not a0 then
            return
        end

        local v281 = v272[a0]
        if not v281 then
            if a0:IsA("ViewportFrame") or a0:IsA("ImageLabel") or a0:IsA("ImageButton") then
                local v282 = {ImageTransparency = a0.ImageTransparency}
                v281 = v282
                -- jump to 58 (out of range)
            end

            if a0:IsA("TextLabel") or a0:IsA("TextButton") or a0:IsA("TextBox") then
                local v283 = {
                    TextTransparency = a0.TextTransparency,
                    TextStrokeTransparency = a0.TextStrokeTransparency
                }
                v281 = v283
            end

            v272[a0] = v281
        end

        if v281 then
            local v284 = v281
            local v285 = nil
            local v286 = nil
            for k47, k48 in v284 do
                a0[k47] = k48 + (1 - k48) * 0.55
            end
        end
    end

    fadeVisual(a1)
    local v287 = "ItemLabel"
    local v288 = {"ItemIcon", v287, "Quantity"}
    local v289 = nil
    local v290 = nil
    for k49, k50 in v288 do
        local v291 = a1:FindFirstChild(k50)
        fadeVisual(v291)
    end
end

v3._setButtonDragVisual = _setButtonDragVisual

local function _styleButton(a0, a1, a2, a3) --[[ Upvalues: v5 (copy), v4 (copy), v6 (copy) ]]
    local v292 = a1:FindFirstChildOfClass("UIStroke")
    if not v292 then
        v292 = Instance.new("UIStroke")
        v292.Parent = a1
    end

    v292.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    if a3 then
        v292.Color = v5
        v292.Thickness = 3
    else
        if a2 and a0:_isEquipped(a2) then
            v292.Color = v4
            v292.Thickness = 3
        else
            v292.Color = v6
            v292.Thickness = 1
        end
    end

    v292 = a0.PointerDrag
    local v293 = false
    if a2 ~= nil then
        v293 = a3
        if not v293 then
            v293 = false
            if v292 ~= nil then
                v293 = v292.Dragging
                if v293 then
                    v293 = false
                    if v292.Button == a1 then
                        v293 = v292.Tool == a2
                    end
                end
            end
        end
    end

    if a2 then
        v292 = 0.28
    else
        v292 = 0.58
    end

    a1.BackgroundTransparency = v293 and v292 + (1 - v292) * 0.55 or v292
    a0:_setButtonDragVisual(a1, v293)
end

v3._styleButton = _styleButton

local function _setButtonViewportActive(a0, a1, a2, a3)
    local v296 = a0:_makeViewport(a1)
    if not (a3 and a2) then
        if a0.RenderedTools[a1] ~= nil or v296.CurrentCamera ~= nil or v296:GetAttribute("ViewportActive") == true then
            a0.RenderedTools[a1] = nil
            v296:SetAttribute("HasVisual", nil)
            v296:SetAttribute("RenderedToolKey", nil)
            v296:SetAttribute("ViewportActive", nil)
            a0:_clearViewport(v296)
        end

        v296.Visible = false
        return
    end

    local v297 = a2:GetAttribute("ToolName")
    local v298
    if typeof(v297) == "string" and v297 ~= "" then
        v298 = v297
    else
        v298 = a2.Name
    end

    if a0.RenderedTools[a1] ~= a2 or v296:GetAttribute("RenderedToolKey") ~= v298 then
        a0.RenderedTools[a1] = a2
        v296:SetAttribute("RenderedToolKey", v298)
        local v299 = a0:_renderViewport(v296, a2)
        v296:SetAttribute("HasVisual", v299)
    end

    v296:SetAttribute("ViewportActive", true)
    v296.Visible = v296:GetAttribute("HasVisual") == true
end

v3._setButtonViewportActive = _setButtonViewportActive

local function _renderButton(a0, a1, a2, a3, a4) --[[ Upvalues: v10 (ref) ]]
    a0.ButtonTools[a1] = a2
    if a2 then
        local v300 = a2:GetAttribute("ToolName")
        local v301
        if typeof(v300) == "string" and v300 ~= "" then
            v301 = v300
        else
            v301 = a2.Name
        end

        if v301 then
            -- jump to 25
        end
    end

    local v302 = nil
    a1:SetAttribute("ToolKey", v302)
    local ItemLabel = a1:FindFirstChild("ItemLabel")
    local Quantity = a1:FindFirstChild("Quantity")
    if ItemLabel and ItemLabel:IsA("TextLabel") then
        ItemLabel.FontFace = v10
        if a2 then
            local v303 = a2:GetAttribute("ToolName")
            local v304
            if typeof(v303) == "string" and v303 ~= "" then
                v304 = v303
            else
                v304 = a2.Name
            end

            if v304 then
                -- jump to 70
            end
        end

        local v305 = ""
        ItemLabel.Text = v305
        ItemLabel.Visible = a2 ~= nil
    end

    if Quantity then
        if Quantity:IsA("TextLabel") then
            if a2 then
                local v306 = a2:GetAttribute("Quantity")
                local v307 = tonumber(v306)
                if not v307 then
                    local v308 = string.match(a2.Name, "%[x(%d+)%]%s*$")
                    v307 = tonumber(v308)
                end

                if not v307 or v307 ~= v307 or v307 < 1 then
                    ItemLabel = 1
                    -- jump to 120 (out of range)
                end

                ItemLabel = math.floor(v307)
                if ItemLabel then
                    -- jump to 122
                end
            end

            ItemLabel = 1
            Quantity.FontFace = v10
            Quantity.Text = "x" .. tostring(ItemLabel)
            local v309 = false
            if a2 ~= nil then
                v309 = 1 < ItemLabel
            end

            Quantity.Visible = v309
        end
    end

    if a4 ~= nil then
        a0:_setButtonViewportActive(a1, a2, a4)
    end

    a0:_styleButton(a1, a2, a3)
end

v3._renderButton = _renderButton

local function _queueToolVisualRefresh(a0, a1)
    if a0.Destroyed or a0.ToolVisualRefreshQueued[a1] then
        return
    end

    a0.ToolVisualRefreshQueued[a1] = true
    task.defer(function() --[[ Upvalues: a0 (copy), a1 (copy) ]]
        a0.ToolVisualRefreshQueued[a1] = nil
        if a0.Destroyed then
            return
        end

        if not (a0.ToolSet[a1] and a1.Parent) then
            a0:_queueRefresh()
            return
        end

        for i16 = 1, 10 do
            local v312 = a0.HotbarTools[i16]
            if v312 == a1 then
                v312 = a0.HotbarButtons[i16]
                local v313 = false
                if a0.GamepadHeldTool == a1 then
                    v313 = a0.GamepadHeldButton == v312
                end

                a0:_renderButton(v312, a1, v313, true)
                return
            end
        end

        local v314 = a0.BackpackButtons[a1]
        if v314 then
            if v314.Parent then
                local v315 = false
                if a0.GamepadHeldTool == a1 then
                    v315 = a0.GamepadHeldButton == v314
                end

                a0:_renderButton(v314, a1, v315, nil)
                return
            end
        end

        a0:_queueRefresh()
    end)
end

v3._queueToolVisualRefresh = _queueToolVisualRefresh

local function _updateBackpackVisibility(a0)
    if a0.Destroyed then
        return
    end

    local v318 = a0.Search and string.lower(a0.Search.Text) or ""
    local BackpackButtons = a0.BackpackButtons
    local v319 = nil
    local v320 = nil
    for k51, k52 in BackpackButtons do
        local v321 = false
        if a0.ToolSet[k51] == true then
            v321 = true
            if v318 ~= "" then
                v321 = true
                local find = string.find
                local lower1 = string.lower
                local v322 = k51:GetAttribute("ToolName")
                local v323
                if typeof(v322) == "string" and v322 ~= "" then
                    v323 = v322
                else
                    v323 = k51.Name
                end

                local v324 = lower1(v323)
                if find(v324, v318, 1, true) == nil then
                    local find1 = string.find
                    v324 = string.lower
                    if k51.ToolTip ~= "" then
                        v323 = k51.ToolTip
                    else
                        local v325 = k51:GetAttribute("ToolName")
                        if typeof(v325) == "string" and v325 ~= "" then
                            v323 = v325
                        else
                            v323 = k51.Name
                        end
                    end

                    local v326 = v324(v318)
                    v321 = find1(v326, v318, 1, true) ~= nil
                end
            end
        end

        k52.Visible = v321
        k52.Selectable = v321
        if not v321 then
            a0:_setButtonViewportActive(k52, k51, false)
        end
    end

    a0:_queueBackpackViewportRefresh()
    a0:_repairControllerSelection()
end

v3._updateBackpackVisibility = _updateBackpackVisibility

local function _refreshBackpackViewports(a0)
    if not (not a0.Destroyed and a0.Open and a0.BackpackFrame.Visible) then
        return
    end

    local Y = a0.BackpackList.AbsolutePosition.Y
    local Y1 = a0.BackpackList.AbsoluteSize.Y
    local v327 = Y + Y1
    local v328 = math.min(16, Y1 * 0.1)
    local BackpackButtons1 = a0.BackpackButtons
    local v329 = nil
    local v330 = nil
    for k53, k54 in BackpackButtons1 do
        local Y2 = k54.AbsolutePosition.Y
        local v331 = Y2 + k54.AbsoluteSize.Y
        local Visible = k54.Visible
        if Visible then
            Visible = false
            if 0 < k54.AbsoluteSize.Magnitude then
                Visible = false
                if Y - v328 <= v331 then
                    Visible = Y2 <= v327 + v328
                end
            end
        end

        a0:_setButtonViewportActive(k54, k53, Visible)
    end
end

v3._refreshBackpackViewports = _refreshBackpackViewports

local function _queueBackpackViewportRefresh(a0) --[[ Upvalues: RunService (copy) ]]
    if a0.Destroyed or not a0.Open or a0.BackpackViewportRefreshQueued then
        return
    end

    a0.BackpackViewportRefreshQueued = true
    task.defer(function() --[[ Upvalues: RunService (upvalue), a0 (copy) ]]
        RunService.RenderStepped:Wait()
        a0.BackpackViewportRefreshQueued = false
        if not a0.Destroyed then
            a0:_refreshBackpackViewports()
        end

    end)
end

v3._queueBackpackViewportRefresh = _queueBackpackViewportRefresh

local function _clearBackpackViewports(a0)
    local BackpackButtons2 = a0.BackpackButtons
    local v332 = nil
    local v333 = nil
    for k55, k56 in BackpackButtons2 do
        if k56.Parent then
            a0:_setButtonViewportActive(k56, k55, false)
        end
    end
end

v3._clearBackpackViewports = _clearBackpackViewports

local function _render(a0)
    if a0.Destroyed then
        return
    end

    if a0.PointerDrag then
        a0:_validatePointerDrag()
    end

    if a0.GamepadHeldTool then
        if a0.ToolSet[a0.GamepadHeldTool] then
            if a0.GamepadHeldTool.Parent ~= a0.Backpack then
                if a0.GamepadHeldTool.Parent == a0.Character then
                    -- jump to 41
                end

                -- branch continues at 41
            end
        end

        a0:_clearGamepadHeld(false)
    end

    local v334 = {}
    local v337, v338, v339
    for i17 = 1, 10 do
        v337 = a0.HotbarButtons[i17]
        v338 = a0.HotbarTools[i17]
        if v338 then
            v334[v338] = true
        end

        v339 = false
        if a0.GamepadHeldTool == v338 then
            v339 = a0.GamepadHeldButton == v337
        end

        a0:_renderButton(v337, v338, v339, true)
    end

    local BackpackButtons3 = a0.BackpackButtons
    local v340 = nil
    i17 = nil
    for k57, k58 in BackpackButtons3 do
        if not a0.ToolSet[k57] or v334[k57] or k58.Parent ~= a0.BackpackList then
            if a0.PointerDrag and a0.PointerDrag.Button == k58 then
                a0:_cancelPointerDrag()
            end

            if a0.GamepadHeldButton == k58 then
                a0:_clearGamepadHeld(false)
            end

            a0:_hideTooltip(k58)
            a0.BackpackButtons[k57] = nil
            a0.ButtonTools[k58] = nil
            a0.RenderedTools[k58] = nil
            a0:_disconnectButton(k58)
            k58:Destroy()
            local v342 = k58.Parent and k58:Destroy()
        end
    end

    BackpackButtons3 = 0
    v340 = a0.Tools
    i17 = nil
    k57 = nil
    for k59, k60 in v340 do
        if not v334[k60] then
            BackpackButtons3 = BackpackButtons3 + 1
            local v343 = a0.BackpackButtons[k60]
            if not v343 then
                v343 = a0.Template:Clone()
                v343:SetAttribute("InventoryButton", true)
                v343:SetAttribute("ButtonKind", "Backpack")
                v343:SetAttribute("SlotIndex", nil)
                v343:SetAttribute("CustomBackpackBound", nil)
                v343.Parent = a0.BackpackList
                a0:_makeViewport(v343)
                a0:_bindButton(v343)
                a0.BackpackButtons[k60] = v343
            end

            v343.Name = "Item_" .. tostring(BackpackButtons3)
            v343.LayoutOrder = BackpackButtons3
            local v344 = false
            if a0.GamepadHeldTool == k60 then
                v344 = a0.GamepadHeldButton == v343
            end

            a0:_renderButton(v343, k60, v344, nil)
        end
    end

    a0:_updateBackpackVisibility()
    a0.LastEquippedTool = a0:_findEquippedTool()
    if not a0.PointerDrag and next(a0.DragGhosts) ~= nil then
        a0:_destroyAllDragGhosts()
    end
end

v3._render = _render

local function _findSelectedInventoryButton(a0) --[[ Upvalues: GuiService (copy) ]]
    if a0:_usingGamepadCursor() then
        if not a0.ControllerNavigationActive or a0.ControllerCursorMode then
            local v345 = a0:_getPointerPosition()
            local v346 = a0:_findInventoryButtonAt(v345)
            return v346
        end
    end

    local SelectedObject = GuiService.SelectedObject
    if not SelectedObject then
        return nil
    end

    local v347 = a0:_findInventoryButton(SelectedObject)
    return v347
end

v3._findSelectedInventoryButton = _findSelectedInventoryButton

local function _createControllerGui(a0) --[[ Upvalues: setInconsolata (copy) ]]
    a0.SavedBackpackSelectable = a0.BackpackFrame.Selectable
    local Frame = Instance.new("Frame")
    Frame.Name = "BackpackControllerControls"
    Frame.AnchorPoint = Vector2.new(0.5, 1)
    Frame.Size = UDim2.fromOffset(650, 52)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 24, 32)
    Frame.BackgroundTransparency = 0.08
    Frame.BorderSizePixel = 0
    Frame.Visible = false
    Frame.ZIndex = 470
    Frame.Parent = a0.HUD
    a0.ControllerPanel = Frame
    local UICorner1 = Instance.new("UICorner")
    UICorner1.CornerRadius = UDim.new(0, 5)
    UICorner1.Parent = Frame
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "ControllerHints"
    TextLabel.Position = UDim2.fromOffset(8, 4)
    TextLabel.Size = UDim2.new(1, -16, 0, 44)
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextColor3 = Color3.fromRGB(230, 237, 245)
    TextLabel.TextSize = 18
    TextLabel.TextWrapped = true
    TextLabel.ZIndex = 471
    TextLabel.Parent = Frame
    a0.ControllerHint = TextLabel
    local TextLabel1 = Instance.new("TextLabel")
    TextLabel1.Name = "ControllerModeHint"
    TextLabel1.Position = UDim2.fromOffset(8, 4)
    TextLabel1.Size = UDim2.new(1, -16, 0, 22)
    TextLabel1.BackgroundTransparency = 1
    TextLabel1.TextColor3 = Color3.fromRGB(140, 205, 255)
    TextLabel1.TextSize = 16
    TextLabel1.TextWrapped = false
    TextLabel1.ZIndex = 471
    TextLabel1.Parent = Frame
    a0.ControllerModeHint = TextLabel1
    local TextLabel2 = Instance.new("TextLabel")
    TextLabel2.Name = "InventoryActionStatus"
    TextLabel2.AnchorPoint = Vector2.new(0, 1)
    TextLabel2.Position = UDim2.new(0, 8, 1, -4)
    TextLabel2.Size = UDim2.new(1, -16, 0, 22)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.TextColor3 = Color3.fromRGB(255, 216, 115)
    TextLabel2.TextSize = 17
    TextLabel2.TextWrapped = false
    TextLabel2.TextTruncate = Enum.TextTruncate.AtEnd
    TextLabel2.Text = ""
    TextLabel2.Visible = false
    TextLabel2.ZIndex = 471
    TextLabel2.Parent = Frame
    a0.ControllerStatus = TextLabel2
    setInconsolata(Frame)
    local Frame1 = Instance.new("Frame")
    Frame1.Name = "BackpackControllerFocus"
    Frame1.BackgroundTransparency = 1
    Frame1.BorderSizePixel = 0
    Frame1.Active = false
    Frame1.Visible = false
    Frame1.ZIndex = 480
    Frame1.Parent = a0.HUD
    Frame = Instance.new("UIStroke")
    Frame.Color = Color3.fromRGB(255, 255, 255)
    Frame.Thickness = 2
    Frame.Parent = Frame1
    a0.ControllerFocus = Frame1
end

v3._createControllerGui = _createControllerGui

local function IsControllerNavigationActive(a0)
    local Open = a0.Open
    if Open then
        Open = a0.ControllerNavigationActive == true
    end

    return Open
end

v3.IsControllerNavigationActive = IsControllerNavigationActive

local function _controllerButtonLabel(a0, a1, a2) --[[ Upvalues: UserInputService (copy) ]]
    local v349, v350 = pcall(function() --[[ Upvalues: UserInputService (upvalue), a1 (copy) ]]
        local v348 = UserInputService:GetStringForKeyCode(a1)
        return v348
    end)
    if not v349 or v350 == "" then
        return a2
    end

    return ({ButtonA = "A", ButtonB = "B", ButtonX = "X", ButtonY = "Y", ButtonTriangle = "Triangle", ButtonCross = "Cross", ButtonCircle = "Circle", ButtonSquare = "Square"})[v350] or a2
end

v3._controllerButtonLabel = _controllerButtonLabel

local function _refreshControllerHint(a0)
    if not a0.ControllerHint then
        return
    end

    local v351 = a0:_controllerButtonLabel(Enum.KeyCode.ButtonA, "A")
    local v352 = a0:_controllerButtonLabel(Enum.KeyCode.ButtonB, "B")
    local v353 = a0:_controllerButtonLabel(Enum.KeyCode.ButtonX, "X")
    local v354 = a0:_controllerButtonLabel(Enum.KeyCode.ButtonY, "Y")
    if a0.GamepadHeldTool then
        a0.ControllerHint.Text = v351 .. " / " .. v353 .. ": PLACE   " .. v352 .. ": CANCEL"
    else
        a0.ControllerHint.Text = v351 .. ": EQUIP   " .. v353 .. ": MOVE" .. "   " .. v354 .. ": TRANSFER / HOLD DROP   " .. v352 .. ": CLOSE"
    end

    local v355
    if a0.ControllerCursorMode then
        v355 = "CURSOR   R3: DIRECTIONAL MODE"
    else
        v355 = "DIRECTIONAL   R3: CURSOR MODE"
    end

    a0.ControllerModeHint.Text = v355
end

v3._refreshControllerHint = _refreshControllerHint

local function _updateControllerVisuals(a0) --[[ Upvalues: GuiService (copy) ]]
    if not a0.ControllerNavigationActive then
        return
    end

    local CurrentCamera = workspace.CurrentCamera
    CurrentCamera = math.min(650, math.max(280, (CurrentCamera and CurrentCamera.ViewportSize.X or 1280) - 24))
    local AbsolutePosition3 = a0.HUD.AbsolutePosition
    local v357
    if CurrentCamera < 480 then
        v357 = 80
    else
        v357 = 44
    end

    local v358 = a0.ControllerStatus.Text ~= ""
    local v359 = 22 + v357 + 12
    local v360
    if v358 then
        v360 = 24
    else
        v360 = 0
    end

    local v361 = v359 + v360
    a0.ControllerHint.Position = UDim2.fromOffset(8, 30)
    a0.ControllerHint.Size = UDim2.new(1, -16, 0, v357)
    a0.ControllerStatus.Visible = v358
    a0.ControllerPanel.Size = UDim2.fromOffset(CurrentCamera, v361)
    local v362 = a0.BackpackFrame.AbsolutePosition.X + a0.BackpackFrame.AbsoluteSize.X * 0.5
    local v363 = CurrentCamera * 0.5 + 8
    local v364 = CurrentCamera * 0.5 + 8
    local v365 = math.clamp(v362, v363, math.max(v364, (CurrentCamera and CurrentCamera.ViewportSize.X or 1280) - CurrentCamera * 0.5 - 8))
    local v366 = v365 - AbsolutePosition3.X
    local v367 = math.max(v361 + 8, a0.BackpackFrame.AbsolutePosition.Y - 8)
    a0.ControllerPanel.Position = UDim2.fromOffset(v366, v367 - AbsolutePosition3.Y)
    local SelectedObject1 = GuiService.SelectedObject
    if a0.ControllerCursorMode then
        local v370 = a0.GamepadHeldTool and a0:_findSelectedInventoryButton() or nil
        SelectedObject1 = v370
    end

    v358 = a0:_isControllerButton(SelectedObject1)
    if v358 then
        v358 = not a0.ControllerCursorMode
        if not v358 then
            v358 = SelectedObject1 == a0.BackpackFrame
        end
    end

    a0.ControllerFocus.Visible = v358
    if v358 then
        local v371 = SelectedObject1.AbsolutePosition.X - AbsolutePosition3.X - 4
        a0.ControllerFocus.Position = UDim2.fromOffset(v371, SelectedObject1.AbsolutePosition.Y - AbsolutePosition3.Y - 4)
        v371 = SelectedObject1.AbsoluteSize.X + 8
        a0.ControllerFocus.Size = UDim2.fromOffset(v371, SelectedObject1.AbsoluteSize.Y + 8)
    end
end

v3._updateControllerVisuals = _updateControllerVisuals

local function _isControllerButton(a0, a1)
    if not (a1 and a1.Parent and a1.Visible and a1.Selectable) then
        return false
    end

    if a1 == a0.BackpackFrame then
        return a0.ControllerNavigationActive
    end

    local Parent1 = a1.Parent
    while Parent1 do
        if Parent1 == a0.HUD then
            break
        end

        if Parent1:IsA("GuiObject") and not Parent1.Visible then
            return false
        end

        Parent1 = Parent1.Parent
    end

    if Parent1 ~= a0.HUD then
        return false
    end

    return a0:_findInventoryButton(a1) == a1
end

v3._isControllerButton = _isControllerButton

local function _controllerButtons(a0, a1)
    local t3 = {}
    if a1 == "Hotbar" then
        local HotbarButtons = a0.HotbarButtons
        local v373 = nil
        local v374 = nil
        for k61, k62 in HotbarButtons do
            if a0:_isControllerButton(k62) then
                table.insert(t3, k62)
            end
        end

        return t3
    end

    local BackpackButtons4 = a0.BackpackButtons
    local v375 = nil
    local v376 = nil
    for k63, k64 in BackpackButtons4 do
        if a0:_isControllerButton(k64) then
            table.insert(t3, k64)
        end
    end

    table.sort(t3, function(a0, a1)
        return a0.LayoutOrder < a1.LayoutOrder
    end)
    table.insert(t3, a0.BackpackFrame)
    return t3
end

v3._controllerButtons = _controllerButtons

local function _scrollControllerSelection(a0, a1)
    if a1.Parent ~= a0.BackpackList then
        return
    end

    local BackpackList = a0.BackpackList
    local AbsolutePosition4 = BackpackList.AbsolutePosition
    local AbsoluteWindowSize = BackpackList.AbsoluteWindowSize
    local CanvasPosition = BackpackList.CanvasPosition
    local AbsolutePosition5 = a1.AbsolutePosition
    local AbsoluteSize4 = a1.AbsoluteSize

    local function reveal(a0, a1, a2, a3, a4, a5)
        if a1 < a3 then
            a0 = a0 + (a1 - a3)
        else
            if a3 + a4 < a1 + a2 then
                a0 = a0 + (a1 + a2 - a3 - a4)
            end
        end

        return math.clamp(a0, 0, math.max(0, a5 - a4))
    end

    local new1 = Vector2.new
    local X3 = CanvasPosition.X
    local X4 = AbsolutePosition5.X
    local X5 = AbsoluteSize4.X
    local X6 = AbsolutePosition4.X
    local X7 = AbsoluteWindowSize.X
    if X4 < X6 then
        X3 = X3 + (X4 - X6)
    else
        if X6 + X7 < X4 + X5 then
            X3 = X3 + (X4 + X5 - X6 - X7)
        end
    end

    local v377 = math.clamp(X3, 0, math.max(0, BackpackList.AbsoluteCanvasSize.X - X7))
    X4 = CanvasPosition.Y
    X5 = AbsolutePosition5.Y
    X6 = AbsoluteSize4.Y
    X7 = AbsolutePosition4.Y
    local Y3 = AbsoluteWindowSize.Y
    if X5 < X7 then
        X4 = X4 + (X5 - X7)
    else
        if X7 + Y3 < X5 + X6 then
            X4 = X4 + (X5 + X6 - X7 - Y3)
        end
    end

    BackpackList.CanvasPosition = new1(v377, math.clamp(X4, 0, math.max(0, BackpackList.AbsoluteCanvasSize.Y - Y3)))
end

v3._scrollControllerSelection = _scrollControllerSelection

local function _selectControllerButton(a0, a1) --[[ Upvalues: GamepadService (copy), GuiService (copy) ]]
    if not a0:_isControllerButton(a1) then
        return
    end

    if a0.ControllerTransfer and a0.ControllerTransfer.Button ~= a1 then
        a0:_cancelControllerTransfer()
    end

    a0.ControllerSelectionCleared = false
    local v378 = a1:GetAttribute("ButtonKind")
    local v379
    if v378 == "Hotbar" then
        v379 = "Hotbar"
    else
        v379 = "Backpack"
    end

    a0.ControllerSection = v379
    if v378 == "Hotbar" then
        a0.LastControllerHotbarSlot = a1:GetAttribute("SlotIndex")
    else
        if v378 == "Backpack" then
            a0.LastControllerBackpackTool = a0:_buttonTool(a1)
        end
    end

    a0:_scrollControllerSelection(a1)
    if a0.ControllerCursorMode then
        pcall(function() --[[ Upvalues: GamepadService (upvalue), a1 (copy) ]]
            GamepadService:EnableGamepadCursor(a1)
        end)
        GuiService.SelectedObject = nil
    else
        GuiService.SelectedObject = a1
        a0:_scrollControllerSelection(a1)
    end

    a0:_updateControllerVisuals()
end

v3._selectControllerButton = _selectControllerButton

local function _repairControllerSelection(a0) --[[ Upvalues: GuiService (copy) ]]
    if not a0.ControllerNavigationActive then
        return
    end

    local SelectedObject2 = GuiService.SelectedObject
    if SelectedObject2 and SelectedObject2.Parent and SelectedObject2.Visible and not a0:_findInventoryButton(SelectedObject2) then
        a0:SetOpen(false)
        return
    end

    if a0.ControllerSelectionCleared or a0.ControllerCursorMode or a0:_isControllerButton(SelectedObject2) then
        return
    end

    local v380
    if a0.ControllerSection == "Backpack" then
        local v382 = a0.LastControllerBackpackTool and a0.BackpackButtons[a0.LastControllerBackpackTool]
        v380 = v382
        if not a0:_isControllerButton(v380) then
            v380 = a0:_controllerButtons("Backpack")[1]
            -- branch continues at 72
        end
    else
        v380 = a0.HotbarButtons[a0.LastControllerHotbarSlot or 1]
    end

    local v385 = v380 or a0.HotbarButtons[1]
    a0:_selectControllerButton(v385)
end

v3._repairControllerSelection = _repairControllerSelection

local function _jumpControllerSection(a0, a1)
    a0.ControllerSection = a1
    local v386
    if a1 == "Hotbar" then
        v386 = a0.HotbarButtons[a0.LastControllerHotbarSlot or 1]
    else
        local v387
        if not (a0.GamepadHeldTool and a0.BackpackFrame) then
            local v389 = a0.LastControllerBackpackTool and a0.BackpackButtons[a0.LastControllerBackpackTool]
        end

        v386 = v387
        if not a0:_isControllerButton(v386) then
            v386 = a0:_controllerButtons("Backpack")[1]
        end
    end

    a0:_selectControllerButton(v386)
end

v3._jumpControllerSection = _jumpControllerSection

local function _navigateController(a0, a1, a2) --[[ Upvalues: GuiService (copy) ]]
    if not a0.ControllerNavigationActive or a0.ControllerCursorMode then
        return
    end

    a0.ControllerSelectionCleared = false
    a0:_repairControllerSelection()
    if a0.ControllerSelectionCleared then
        return
    end

    local SelectedObject3 = GuiService.SelectedObject
    if not SelectedObject3 then
        return
    end

    if SelectedObject3:GetAttribute("ButtonKind") == "Hotbar" then
        if a1 ~= 0 then
            local v391 = SelectedObject3:GetAttribute("SlotIndex") + a1
            a0:_selectControllerButton(a0.HotbarButtons[math.clamp(v391, 1, 10)])
            return
        end

        if a2 < 0 then
            a0:_jumpControllerSection("Backpack")
        end

        return
    end

    if SelectedObject3 == a0.BackpackFrame then
        if 0 < a2 then
            a0:_jumpControllerSection("Hotbar")
            return
        end

        if a2 < 0 or a1 ~= 0 then
            local v392 = a0:_controllerButtons("Backpack")
            if 1 < #v392 then
                a0:_selectControllerButton(v392[1])
                return
            end

            a0:_jumpControllerSection("Hotbar")
        end

        return
    end

    local v393 = SelectedObject3.AbsolutePosition + SelectedObject3.AbsoluteSize * 0.5
    local v394 = nil
    local v395 = nil
    for k65, k66 in a0:_controllerButtons("Backpack") do
        if k66 ~= SelectedObject3 then
            if k66 ~= a0.BackpackFrame then
                local v399 = k66.AbsolutePosition + k66.AbsoluteSize * 0.5 - v393
                local v401
                if not (a1 ~= 0 and v399.X * a1) then
                    v401 = v399.Y * a2
                end

                if a1 ~= 0 then
                    local v402 = math.abs(v399.Y)
                    if v402 then
                        -- jump to 151
                    end
                end

                local v403 = math.abs(v399.X)
                if 1 < v401 then
                    v399 = v401 + v403 * 4
                    if not v395 or v399 < v395 then
                        v394 = k66
                        v395 = v399
                    end
                end
            end
        end
    end

    if v394 then
        a0:_selectControllerButton(v394)
        return
    end

    if a2 < 0 then
        a0:_selectControllerButton(a0.BackpackFrame)
        return
    end

    if 0 < a2 then
        a0:_jumpControllerSection("Hotbar")
    end
end

v3._navigateController = _navigateController

local function _clearGamepadHeld(a0, a1)
    local GamepadHeldButton = a0.GamepadHeldButton
    a0.GamepadHeldTool = nil
    a0.GamepadHeldSlot = nil
    a0.GamepadHeldButton = nil
    if GamepadHeldButton then
        a0:_setButtonDragVisual(GamepadHeldButton, false)
    end

    if GamepadHeldButton and GamepadHeldButton.Parent then
        local v404 = a0:_buttonTool(GamepadHeldButton)
        a0:_styleButton(GamepadHeldButton, v404, false)
    end

    a0:_refreshControllerHint()
    if a1 then
        a0:_render()
    end
end

v3._clearGamepadHeld = _clearGamepadHeld

local function _returnGamepadToolToBackpack(a0)
    local GamepadHeldTool = a0.GamepadHeldTool
    if not GamepadHeldTool then
        return
    end

    a0:_clearGamepadHeld(false)
    if not a0:_validControllerTool(GamepadHeldTool) then
        return
    end

    a0:_clearControllerSelectionAfterTransfer()
    for i18 = 1, 10 do
        if a0.HotbarTools[i18] == GamepadHeldTool then
            a0:_removeToolFromHotbar(i18)
            return
        end
    end
end

v3._returnGamepadToolToBackpack = _returnGamepadToolToBackpack

local function _handleGamepadMove(a0, a1)
    local v409 = a1 or a0:_findSelectedInventoryButton()
    a1 = v409
    if not a1 then
        return
    end

    if a1 == a0.BackpackFrame then
        a0:_returnGamepadToolToBackpack()
        return
    end

    local v410 = a0:_buttonTool(a1)
    if not a0.GamepadHeldTool then
        if not v410 then
            return
        end

        if not a0.ToolSet[v410] then
            return
        end

        if v410.Parent ~= a0.Backpack then
            if v410.Parent ~= a0.Character then
                return
            end
        end

        a0.GamepadHeldTool = v410
        a0.GamepadHeldButton = a1
        local v413 = a1:GetAttribute("ButtonKind") == "Hotbar" and a1:GetAttribute("SlotIndex") or nil
        a0.GamepadHeldSlot = v413
        a0:_styleButton(a1, v410, true)
        a0:_showTooltip(v410, a1)
        a0:_refreshControllerHint()
        return
    end

    v410 = a0.GamepadHeldTool
    if not a0.ToolSet[v410] then
        a0:_clearGamepadHeld(true)
        return
    end

    if v410.Parent ~= a0.Backpack then
        if v410.Parent ~= a0.Character then
            a0:_clearGamepadHeld(true)
            return
        end
    end

    a0:_clearGamepadHeld(false)
    a0:_clearControllerSelectionAfterTransfer()
    a0:_placeToolOnButton(v410, a1)
end

v3._handleGamepadMove = _handleGamepadMove

local function _controllerConfirm(a0)
    local v414 = a0:_findSelectedInventoryButton()
    if not v414 then
        return
    end

    if v414 == a0.BackpackFrame then
        a0:_returnGamepadToolToBackpack()
        return
    end

    if a0.GamepadHeldTool then
        a0:_handleGamepadMove(v414)
        return
    end

    local v415 = a0:_buttonTool(v414)
    if v415 then
        a0:_toggleEquip(v415)
    end
end

v3._controllerConfirm = _controllerConfirm

local function _setControllerStatus(a0, a1, a2)
    if a0.ControllerStatus then
        a0.ControllerStatus.Text = a1
    end

    a0.ControllerStatusUntil = os.clock() + (a2 or 2.5)
end

v3._setControllerStatus = _setControllerStatus

local function _cancelControllerTransfer(a0)
    local ControllerTransfer = a0.ControllerTransfer
    if ControllerTransfer then
        ControllerTransfer.Cancelled = true
    end
end

v3._cancelControllerTransfer = _cancelControllerTransfer

local function _validControllerTool(a0, a1)
    local v417 = a0.Character and a0.Character:FindFirstChildOfClass("Humanoid")
    local v418 = false
    if a0.Player.Character == a0.Character then
        v418 = false
        if a1 ~= nil then
            v418 = false
            if a0.ToolSet[a1] == true then
                v418 = false
                if v417 ~= nil then
                    v418 = false
                    if 0 < v417.Health then
                        v418 = true
                        if a1.Parent ~= a0.Backpack then
                            v418 = a1.Parent == a0.Character
                        end
                    end
                end
            end
        end
    end

    return v418
end

v3._validControllerTool = _validControllerTool

local function _clearControllerSelectionAfterTransfer(a0) --[[ Upvalues: GuiService (copy) ]]
    a0.ControllerSelectionCleared = true
    GuiService.SelectedObject = nil
    a0:_hideTooltip()
    a0:_updateControllerVisuals()
end

v3._clearControllerSelectionAfterTransfer = _clearControllerSelectionAfterTransfer

local function _quickTransferControllerTool(a0, a1)
    if not a0:_validControllerTool(a1) then
        return
    end

    a0:_clearGamepadHeld(false)
    for i19 = 1, 10 do
        if a0.HotbarTools[i19] == a1 then
            a0:_clearControllerSelectionAfterTransfer()
            a0:_removeToolFromHotbar(i19)
            local v421 = a1:GetAttribute("ToolName")
            local v422
            if typeof(v421) == "string" and v421 ~= "" then
                v422 = v421
            else
                v422 = a1.Name
            end

            a0:_setControllerStatus("Moved to backpack: " .. v422)
            return
        end
    end

    for i20 = 1, 10 do
        if not a0.HotbarTools[i20] then
            a0:_clearControllerSelectionAfterTransfer()
            a0:_placeToolInSlot(a1, i20)
            local v425 = a1:GetAttribute("ToolName")
            local v426
            if typeof(v425) == "string" and v425 ~= "" then
                v426 = v425
            else
                v426 = a1.Name
            end

            a0:_setControllerStatus("Added to hotbar: " .. v426)
            return
        end
    end

    local v427 = a0.BackpackButtons[a1]
    if v427 then
        a0:_handleGamepadMove(v427)
        a0:_jumpControllerSection("Hotbar")
        a0:_setControllerStatus("Hotbar full \226\128\148 choose a slot")
    end
end

v3._quickTransferControllerTool = _quickTransferControllerTool

local function _requestControllerDrop(a0, a1) --[[ Upvalues: v1 (copy) ]]
    if not a0:_validControllerTool(a1) then
        a0:_setControllerStatus("Item is no longer available")
        return
    end

    local v428 = v1
    local v429 = a1:GetAttribute("ToolName")
    local v430
    if typeof(v429) == "string" and v429 ~= "" then
        v430 = v429
    else
        v430 = a1.Name
    end

    local v431 = v428[v430]
    if not v431 or v431.CantDrop then
        a0:_setControllerStatus("This item cannot be dropped")
        return
    end

    a0.RemoteEvent:FireServer("DropItem", a1)
    v431 = a1:GetAttribute("ToolName")
    local v432
    if typeof(v431) == "string" and v431 ~= "" then
        v432 = v431
    else
        v432 = a1.Name
    end

    a0:_setControllerStatus("Dropping 1 " .. v432 .. "\226\128\166")
end

v3._requestControllerDrop = _requestControllerDrop

local function _controllerTransferInput(a0, a1)
    if a1 == Enum.UserInputState.Begin then
        if a0.ControllerTransfer then
            return
        end

        local v433 = a0:_findSelectedInventoryButton()
        local v436 = v433 and a0:_buttonTool(v433)
        local v437 = {
            Button = v433,
            Tool = v436,
            Started = os.clock(),
            Character = a0.Character
        }
        local v438 = true
        if a0.PointerDrag == nil then
            v438 = true
            if a0.GamepadHeldTool == nil then
                v438 = not a0:_validControllerTool(v436)
            end
        end

        v437.Cancelled = v438
        a0.ControllerTransfer = v437
        return
    end

    if a1 == Enum.UserInputState.End or a1 == Enum.UserInputState.Cancel then
        local ControllerTransfer1 = a0.ControllerTransfer
        a0.ControllerTransfer = nil
        if not ControllerTransfer1 or ControllerTransfer1.Cancelled or ControllerTransfer1.Triggered or a1 == Enum.UserInputState.Cancel then
            return
        end

        local v439 = a0:_findSelectedInventoryButton()
        if not (v439 == ControllerTransfer1.Button and a0.Character == ControllerTransfer1.Character and a0:_validControllerTool(ControllerTransfer1.Tool)) then
            return
        end

        local v440 = os.clock() - ControllerTransfer1.Started
        if v440 <= 0.3 then
            a0:_quickTransferControllerTool(ControllerTransfer1.Tool)
            return
        end

        a0:_setControllerStatus("Drop cancelled")
    end
end

v3._controllerTransferInput = _controllerTransferInput

local function _updateControllerTransfer(a0) --[[ Upvalues: v1 (copy) ]]
    local ControllerTransfer2 = a0.ControllerTransfer
    if not ControllerTransfer2 or ControllerTransfer2.Cancelled or ControllerTransfer2.Triggered then
        return
    end

    if not a0:IsControllerNavigationActive() or a0.Character ~= ControllerTransfer2.Character or a0.PointerDrag or a0.GamepadHeldTool or not a0:_validControllerTool(ControllerTransfer2.Tool) or a0:_findSelectedInventoryButton() ~= ControllerTransfer2.Button then
        a0:_cancelControllerTransfer()
        return
    end

    local v442 = os.clock() - ControllerTransfer2.Started
    if 0.7 <= v442 then
        ControllerTransfer2.Triggered = true
        a0:_requestControllerDrop(ControllerTransfer2.Tool)
        return
    end

    if 0.3 <= v442 then
        local v443 = v1
        local Tool1 = ControllerTransfer2.Tool
        local v444 = Tool1:GetAttribute("ToolName")
        local v445
        if typeof(v444) == "string" and v444 ~= "" then
            v445 = v444
        else
            v445 = Tool1.Name
        end

        local v446 = v443[v445]
        if not v446 or v446.CantDrop then
            ControllerTransfer2.Cancelled = true
            a0:_setControllerStatus("This item cannot be dropped")
            return
        end

        local Tool2 = ControllerTransfer2.Tool
        local v447 = Tool2:GetAttribute("ToolName")
        local v448
        if typeof(v447) == "string" and v447 ~= "" then
            v448 = v447
        else
            v448 = Tool2.Name
        end

        local v449 = math.floor(v442 / 0.7 * 100)
        Tool1 = "Hold to drop 1 " .. v448 .. " \226\128\148 " .. v449 .. "%"
        a0:_setControllerStatus(Tool1, 0.2)
    end
end

v3._updateControllerTransfer = _updateControllerTransfer

local function OwnsControllerKey(a0, a1)
    if not a0:IsControllerNavigationActive() then
        return false
    end

    if a1 == Enum.KeyCode.Thumbstick1 then
        return a0.ControllerCursorMode
    end

    local v450 = true
    if a1 ~= Enum.KeyCode.ButtonA then
        v450 = true
        if a1 ~= Enum.KeyCode.ButtonB then
            v450 = true
            if a1 ~= Enum.KeyCode.ButtonX then
                v450 = true
                if a1 ~= Enum.KeyCode.ButtonY then
                    v450 = true
                    if a1 ~= Enum.KeyCode.ButtonL1 then
                        v450 = true
                        if a1 ~= Enum.KeyCode.ButtonR1 then
                            v450 = true
                            if a1 ~= Enum.KeyCode.ButtonR3 then
                                v450 = true
                                if a1 ~= Enum.KeyCode.DPadLeft then
                                    v450 = true
                                    if a1 ~= Enum.KeyCode.DPadRight then
                                        v450 = true
                                        if a1 ~= Enum.KeyCode.DPadUp then
                                            v450 = a1 == Enum.KeyCode.DPadDown
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return v450
end

v3.OwnsControllerKey = OwnsControllerKey

local function _publishControllerInput(a0)
    a0.PlayerGui:SetAttribute("ControllerBackpackActive", a0.ControllerNavigationActive)
    a0.PlayerGui:SetAttribute("ControllerBackpackCursorMode", a0.ControllerCursorMode)
    a0.ControllerInputRevision = a0.ControllerInputRevision + 1
    a0.PlayerGui:SetAttribute("ControllerBackpackInputRevision", a0.ControllerInputRevision)
end

v3._publishControllerInput = _publishControllerInput

local function SetCursorPreference(a0, a1)
    if a0.CursorPreferenceDirty then
        return
    end

    a0.PreferredControllerCursorMode = a1 == true
    if a0.ControllerNavigationActive then
        a0:_setControllerCursorMode(a0.PreferredControllerCursorMode)
    end
end

v3.SetCursorPreference = SetCursorPreference

local function _restoreControllerMovement(a0)
    if a0.RestoreControllerMovement then
        a0.RestoreControllerMovement = false
        if a0.ControllerControls and a0.ControllerControls.controlsEnabled == false then
            a0.ControllerControls:Enable()
        end
    end
end

v3._restoreControllerMovement = _restoreControllerMovement

local function _takeControllerMovement(a0)
    local ControllerControls = a0.ControllerControls
    if ControllerControls and ControllerControls.controlsEnabled ~= false and not a0.RestoreControllerMovement then
        a0.RestoreControllerMovement = true
        ControllerControls:Disable()
    end

    local v452 = a0.Character and a0.Character:FindFirstChildOfClass("Humanoid")
    if v452 then
        v452:Move(Vector3.new(0, 0, 0), false)
    end
end

v3._takeControllerMovement = _takeControllerMovement

local function _releaseBackpackGamepadCursor(a0) --[[ Upvalues: GamepadService (copy) ]]
    if a0.ControllerNavigationActive or a0.EnabledBackpackGamepadCursor then
        if GamepadService.GamepadCursorEnabled then
            pcall(function() --[[ Upvalues: GamepadService (upvalue) ]]
                GamepadService:DisableGamepadCursor()
            end)
        end
    end

    a0.EnabledBackpackGamepadCursor = false
end

v3._releaseBackpackGamepadCursor = _releaseBackpackGamepadCursor

local function _setControllerCursorMode(a0, a1, a2) --[[ Upvalues: GuiService (copy), GamepadService (copy) ]]
    if not a0.ControllerNavigationActive then
        return
    end

    a0.ControllerSelectionCleared = false
    a0.ControllerBackpackPress = nil
    a0:_cancelControllerTransfer()
    a0:_cancelPointerDrag()
    a0.ControllerDirection = nil
    a0.ControllerDirectionKey = nil
    a0.ControllerCursorMode = false
    a0:_releaseBackpackGamepadCursor()
    GuiService.SelectedObject = nil
    if a1 then
        local BackpackFrame2 = a0.BackpackFrame
        a0:_scrollControllerSelection(BackpackFrame2)
        local v454 = pcall(function() --[[ Upvalues: GamepadService (upvalue), BackpackFrame2 (copy) ]]
            GamepadService:EnableGamepadCursor(BackpackFrame2)
        end) and GamepadService.GamepadCursorEnabled
        a0.ControllerCursorMode = v454
        a0.EnabledBackpackGamepadCursor = a0.ControllerCursorMode
    end

    if a0.ControllerCursorMode then
        a0:_takeControllerMovement()
    else
        a0:_restoreControllerMovement()
        a0:_repairControllerSelection()
    end

    if a2 then
        a0.CursorPreferenceDirty = true
        a0.PreferredControllerCursorMode = a0.ControllerCursorMode
        a0.RemoteEvent:FireServer("ChangeBackpackCursorMode", a0.PreferredControllerCursorMode)
        local v455
        if a0.ControllerCursorMode then
            v455 = "Cursor mode"
        else
            v455 = "Directional mode"
        end

        a0:_setControllerStatus(v455, 1.2)
    end

    a0:_publishControllerInput()
    a0:_refreshControllerHint()
    a0:_updateControllerVisuals()
end

v3._setControllerCursorMode = _setControllerCursorMode

local function _setControllerNavigation(a0, a1) --[[ Upvalues: GuiService (copy) ]]
    local v456 = false
    if a1 == true then
        local v458 = a0.Open and a0.Enabled and not a0.Destroyed
    end

    a1 = v456
    if a1 == a0.ControllerNavigationActive then
        return
    end

    local v460 = a1 or a0.SavedBackpackSelectable
    a0.BackpackFrame.Selectable = v460
    a0.ControllerSelectionCleared = false
    a0.ControllerCursorToggleDown = nil
    a0.ControllerConfirmDown = nil
    a0.ControllerBackpackPress = nil
    a0:_cancelControllerTransfer()
    a0.ControllerTransfer = nil
    if a1 then
        a0.ControllerNavigationActive = true
        a0.PreviousSelectedObject = nil
        a0.ControllerPanel.Visible = true
        pcall(function() --[[ Upvalues: a0 (copy), GuiService (upvalue) ]]
            a0.SavedGuiNavigationEnabled = GuiService.GuiNavigationEnabled
            GuiService.GuiNavigationEnabled = false
        end)
        a0:_bindOpenGamepadActions(true)
        a0:_setControllerCursorMode(a0.PreferredControllerCursorMode)
        if not a0.LastControllerBackpackTool then
            if not a0.HotbarTools[a0.LastControllerHotbarSlot] then
                local v461 = nil
                for i21 = 1, 10 do
                    if a0.HotbarTools[i21] then
                        v461 = i21
                        break
                    end
                end

                if v461 then
                    a0.LastControllerHotbarSlot = v461
                    a0:_jumpControllerSection("Hotbar")
                    return
                end

                local v464 = #a0:_controllerButtons("Backpack")
                if 1 < v464 then
                    a0:_jumpControllerSection("Backpack")
                    return
                    -- branch continues at 203
                end

                -- branch continues at 203
            end

            -- branch continues at 203
        end
    end

    a0:_cancelPointerDrag()
    a0:_clearGamepadHeld(false)
    a0:_releaseBackpackGamepadCursor()
    a0.ControllerNavigationActive = false
    a0.ControllerCursorMode = false
    a0.ControllerDirection = nil
    a0.ControllerDirectionKey = nil
    a0:_publishControllerInput()
    a0:_bindOpenGamepadActions(false)
    a0.ControllerPanel.Visible = false
    a0.ControllerFocus.Visible = false
    local SelectedObject4 = GuiService.SelectedObject
    if SelectedObject4 == a0.BackpackFrame or a0:_findInventoryButton(SelectedObject4) then
        GuiService.SelectedObject = nil
    end

    if a0.SavedGuiNavigationEnabled ~= nil then
        pcall(function() --[[ Upvalues: GuiService (upvalue), a0 (copy) ]]
            if GuiService.GuiNavigationEnabled == false then
                GuiService.GuiNavigationEnabled = a0.SavedGuiNavigationEnabled
            end

        end)
        a0.SavedGuiNavigationEnabled = nil
    end

    a0:_restoreControllerMovement()
    a0:_hideTooltip()
end

v3._setControllerNavigation = _setControllerNavigation

local function _handleControllerInput(a0, a1, a2)
    if not a0:IsControllerNavigationActive() then
        return Enum.ContextActionResult.Pass
    end

    local KeyCode = a2.KeyCode
    if a0.ControllerCursorMode then
        if KeyCode == Enum.KeyCode.Thumbstick1 or KeyCode == Enum.KeyCode.ButtonA then
            if KeyCode == Enum.KeyCode.ButtonA and a1 == Enum.UserInputState.Begin then
                a0:_cancelControllerTransfer()
            end

            return Enum.ContextActionResult.Pass
        end
    end

    if not a0:OwnsControllerKey(KeyCode) then
        return Enum.ContextActionResult.Pass
    end

    if KeyCode == Enum.KeyCode.ButtonA or KeyCode == Enum.KeyCode.ButtonR3 then
        return Enum.ContextActionResult.Sink
    end

    if KeyCode == Enum.KeyCode.ButtonY then
        a0:_controllerTransferInput(a1)
        return Enum.ContextActionResult.Sink
    end

    local v465 = {
        [Enum.KeyCode.DPadLeft] = Vector2.new(-1, 0),
        [Enum.KeyCode.DPadRight] = Vector2.new(1, 0),
        [Enum.KeyCode.DPadUp] = Vector2.new(0, -1),
        [Enum.KeyCode.DPadDown] = Vector2.new(0, 1)
    }
    local v466 = v465[KeyCode]
    if v466 then
        if a1 == Enum.UserInputState.Begin then
            a0:_cancelControllerTransfer()
            a0.ControllerDirection = v466
            a0.ControllerDirectionKey = KeyCode
            a0:_navigateController(v466.X, v466.Y)
            a0.ControllerRepeatAt = os.clock() + 0.35
            -- jump to 221 (out of range)
        end

        if a1 ~= Enum.UserInputState.End then
            if a1 ~= Enum.UserInputState.Cancel then
                -- jump to 221
            end
        end

        if a0.ControllerDirectionKey == KeyCode then
            a0.ControllerDirection = nil
            a0.ControllerDirectionKey = nil
            -- branch continues at 221
        end
    else
        if a1 == Enum.UserInputState.Begin then
            a0:_cancelControllerTransfer()
            if KeyCode == Enum.KeyCode.ButtonB then
                if a0.PointerDrag then
                    a0:_cancelPointerDrag()
                    -- jump to 221 (out of range)
                end

                if a0.GamepadHeldTool then
                    a0:_clearGamepadHeld(true)
                    -- jump to 221 (out of range)
                end

                a0:SetOpen(false)
            else
                if KeyCode == Enum.KeyCode.ButtonX then
                    if not a0.PointerDrag then
                        a0:_handleGamepadMove()
                        -- branch continues at 221
                    end
                else
                    if KeyCode == Enum.KeyCode.ButtonL1 then
                        a0:_jumpControllerSection("Hotbar")
                    else
                        if KeyCode == Enum.KeyCode.ButtonR1 then
                            a0:_jumpControllerSection("Backpack")
                        end
                    end
                end
            end
        end
    end

    return Enum.ContextActionResult.Sink
end

v3._handleControllerInput = _handleControllerInput

local function _bindOpenGamepadActions(a0, a1) --[[ Upvalues: ContextActionService (copy) ]]
    if a1 then
        ContextActionService:BindActionAtPriority("CustomBackpackMove", function(a0, a1, a2) --[[ Upvalues: a0 (copy) ]]
            local v467 = a0:_handleControllerInput(a1, a2)
            return v467
        end, false, 3200, Enum.KeyCode.ButtonA, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1, Enum.KeyCode.ButtonR3, Enum.KeyCode.DPadLeft, Enum.KeyCode.DPadRight, Enum.KeyCode.DPadUp, Enum.KeyCode.DPadDown)
        return
    end

    ContextActionService:UnbindAction("CustomBackpackMove")
end

v3._bindOpenGamepadActions = _bindOpenGamepadActions

local function SetOpen(a0, a1, a2) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    local v468 = false
    if a1 == true then
        local v470 = a0.Enabled and not a0.Destroyed
    end

    a1 = v468
    if not a1 then
        a0:_releaseSearchFocus()
        a0:_cancelPointerDrag()
    end

    if a0.TouchLayout then
        a0:_queueTouchLayout()
    end

    if a0.Open ~= a1 then
        if a1 then
            a0.PreviousSelectedObject = GuiService.SelectedObject
        end

        a0.OpenRevision = a0.OpenRevision + 1
        a0.Open = a1
        a0.BackpackFrame.Visible = a1
        if a1 then
            a0:_queueBackpackViewportRefresh()
        else
            a0:_clearBackpackViewports()
        end

        if a0.BackpackIcon then
            a0.SyncingBackpackIcon = true
            if a1 then
                a0.BackpackIcon:select("BackpackController", a0.BackpackIcon)
            else
                a0.BackpackIcon:deselect("BackpackController", a0.BackpackIcon)
            end

            a0.SyncingBackpackIcon = false
        end
    end

    if a1 then
        if a2 == true then
            a0:_setControllerNavigation(true)
            return
        end

        if a2 == nil then
            if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
                a0:_setControllerNavigation(true)
                return
            end
        end

        if a2 == false then
            a0:_setControllerNavigation(false)
            return
            -- branch continues at 202
        end
    end

    a0:_setControllerNavigation(false)
    if a0:_findInventoryButton(GuiService.SelectedObject) then
        local PreviousSelectedObject = a0.PreviousSelectedObject
        local v474 = PreviousSelectedObject and PreviousSelectedObject.Parent and PreviousSelectedObject:IsDescendantOf(a0.PlayerGui) and PreviousSelectedObject:IsA("GuiObject") and PreviousSelectedObject.Selectable and PreviousSelectedObject.Visible
        local v475 = PreviousSelectedObject
        while v474 do
            if not v475 then
                break
            end

            if v475 == a0.PlayerGui then
                break
            end

            if not v475:IsA("GuiObject") or v475.Visible then
                if v475:IsA("ScreenGui") then
                    if v475.Enabled then
                        -- jump to 176
                    end

                    -- branch continues at 176
                end
            end

            v474 = false
            v475 = v475.Parent
        end

        GuiService.SelectedObject = v474 and PreviousSelectedObject or nil
    end

    a0.PreviousSelectedObject = nil
    a0:_cancelPointerDrag()
    a0:_clearGamepadHeld(false)
    a0:_hideTooltip()
end

v3.SetOpen = SetOpen

local function SetEnabled(a0, a1)
    a0.Enabled = a1 == true
    local v478 = a0.Enabled and a0.HasRendered
    a0.HotbarFrame.Visible = v478
    if not a0.Enabled then
        a0:SetOpen(false)
    end

    if a0.BackpackIcon then
        a0.BackpackIcon:setEnabled(a0.Enabled)
    end
end

v3.SetEnabled = SetEnabled

local function _cycleHotbar(a0, a1)
    local v479 = nil
    for i22 = 1, 10 do
        local v482 = a0.HotbarTools[i22]
        if v482 and a0:_isEquipped(v482) then
            v479 = i22
            break
        end
    end

    if not v479 then
        local v483
        if 0 < a1 then
            v483 = 1
        else
            v483 = 10
        end

        local v484
        if 0 < a1 then
            v484 = 10
        else
            v484 = 1
        end

        for i23 = v483, v484, a1 do
            local v487 = a0.HotbarTools[i23]
            if v487 then
                a0:_toggleEquip(v487)
                return
            end
        end

        return
    end

    local v488
    if 0 < a1 then
        v488 = 10
    else
        v488 = 1
    end

    for i24 = v479 + a1, v488, a1 do
        local v491 = a0.HotbarTools[i24]
        if v491 then
            a0:_toggleEquip(v491)
            return
        end
    end

    a0:_toggleEquip(a0.HotbarTools[v479])
end

v3._cycleHotbar = _cycleHotbar

local function _controllerConfirmInput(a0, a1, a2) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    if not (a2.KeyCode == Enum.KeyCode.ButtonA and string.match(a2.UserInputType.Name, "^Gamepad")) then
        return
    end

    if a1 == Enum.UserInputState.End or a1 == Enum.UserInputState.Cancel then
        if a0.ControllerConfirmDown == a2.UserInputType then
            a0.ControllerConfirmDown = nil
        end

        return
    end

    if not (a1 == Enum.UserInputState.Begin and not a0.ControllerConfirmDown and a0.Enabled and not a0.Destroyed and a0:IsControllerNavigationActive()) then
        return
    end

    a0.ControllerConfirmDown = a2.UserInputType
    if a0.ControllerCursorMode or GuiService.MenuIsOpen or UserInputService:GetFocusedTextBox() then
        return
    end

    a0:_cancelControllerTransfer()
    a0:_controllerConfirm()
end

v3._controllerConfirmInput = _controllerConfirmInput

local function _controllerCursorToggleInput(a0, a1, a2) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    if not (a2.KeyCode == Enum.KeyCode.ButtonR3 and string.match(a2.UserInputType.Name, "^Gamepad")) then
        return
    end

    if a1 == Enum.UserInputState.End or a1 == Enum.UserInputState.Cancel then
        if a0.ControllerCursorToggleDown == a2.UserInputType then
            a0.ControllerCursorToggleDown = nil
        end

        return
    end

    if a1 ~= Enum.UserInputState.Begin or a0.ControllerCursorToggleDown or not a0.Enabled or a0.Destroyed or not a0:IsControllerNavigationActive() or GuiService.MenuIsOpen or UserInputService:GetFocusedTextBox() then
        return
    end

    a0.ControllerCursorToggleDown = a2.UserInputType
    local v492 = not a0.ControllerCursorMode
    a0:_setControllerCursorMode(v492, true)
end

v3._controllerCursorToggleInput = _controllerCursorToggleInput

local function _controllerBackpackPointerInput(a0, a1, a2)
    local v493 = true
    if a2.UserInputType ~= Enum.UserInputType.MouseButton1 then
        v493 = false
        if a2.KeyCode == Enum.KeyCode.ButtonA then
            local v494 = string.match(a2.UserInputType.Name, "^Gamepad")
        end
    end

    if not v493 then
        return
    end

    if not (a0:IsControllerNavigationActive() and a0.ControllerCursorMode) then
        a0.ControllerBackpackPress = nil
        return
    end

    if a1 == Enum.UserInputState.Begin then
        if not a0.PointerDrag then
            if a0.GamepadHeldTool then
                local v497 = a0:_findSelectedInventoryButton()
                if v497 == a0.BackpackFrame then
                    a0.ControllerBackpackPress = a0.GamepadHeldTool
                    return
                end
            end
        end

        a0.ControllerBackpackPress = nil
        return
    end

    if a1 == Enum.UserInputState.End or a1 == Enum.UserInputState.Cancel then
        v493 = a0.ControllerBackpackPress
        a0.ControllerBackpackPress = nil
        if a1 == Enum.UserInputState.End then
            if v493 then
                if v493 == a0.GamepadHeldTool then
                    if not a0.PointerDrag then
                        local v502 = a0:_findSelectedInventoryButton()
                        if v502 == a0.BackpackFrame then
                            a0:_returnGamepadToolToBackpack()
                        end
                    end
                end
            end
        end
    end
end

v3._controllerBackpackPointerInput = _controllerBackpackPointerInput

local function touchLayoutRect(a0)
    local AbsolutePosition6 = a0.AbsolutePosition
    local v503 = Rect.new(AbsolutePosition6, AbsolutePosition6 + a0.AbsoluteSize)
    return v503
end

local function touchLayoutVisible(a0)
    local v504 = a0
    while v504 do
        if v504:IsA("GuiObject") and not v504.Visible then
            return false
        end

        if v504:IsA("ScreenGui") and not v504.Enabled then
            return false
        end

        v504 = v504.Parent
    end

    return true
end

local function _queueTouchLayout(a0)
    if a0.TouchLayoutQueued or a0.Destroyed then
        return
    end

    a0.TouchLayoutQueued = true
    task.defer(function() --[[ Upvalues: a0 (copy) ]]
        a0.TouchLayoutQueued = false
        if a0.Destroyed then
            return
        end

        if a0.PointerDrag then
            a0.TouchLayoutPending = true
            return
        end

        a0:_updateTouchLayout()
    end)
end

v3._queueTouchLayout = _queueTouchLayout

local function _prepareTouchLayout(a0) --[[ Upvalues: v10 (ref), UserInputService (copy) ]]
    local t4 = {
        Active = false,
        Properties = {},
        Detached = {},
        Controls = {},
        StatusVisibility = {}
    }
    a0.TouchLayout = t4

    local function remember(a0, a1) --[[ Upvalues: t4 (copy) ]]
        if not a0 then
            return
        end

        local t5 = {}
        local v505 = a1
        local v506 = nil
        local v507 = nil
        for k67, k68 in v505 do
            t5[k68] = a0[k68]
        end

        t4.Properties[a0] = t5
    end

    local HotbarFrame1 = a0.HotbarFrame
    local v508 = {"Position", "Size", "AnchorPoint"}
    local v509
    if not HotbarFrame1 then
    else
        local v510 = {}
        local v511 = v508
        local v512 = nil
        local v513 = nil
        for k69, k70 in v511 do
            v510[k70] = HotbarFrame1[k70]
        end

        t4.Properties[HotbarFrame1] = v510
    end

    HotbarFrame1 = a0.BackpackFrame
    v508 = {"Position", "Size", "AnchorPoint"}
    if not HotbarFrame1 then
    else
        local v514 = {}
        local v515 = v508
        local v516 = nil
        local v517 = nil
        for k71, k72 in v515 do
            v514[k72] = HotbarFrame1[k72]
        end

        t4.Properties[HotbarFrame1] = v514
    end

    HotbarFrame1 = a0.BackpackList
    v509 = "ScrollingDirection"
    v508 = {
        "Position",
        "Size",
        "AnchorPoint",
        "AutomaticCanvasSize",
        "CanvasSize",
        v509,
        "ScrollBarThickness"
    }
    if not HotbarFrame1 then
    else
        local v518 = {}
        local v519 = v508
        local v520 = nil
        local v521 = nil
        for k73, k74 in v519 do
            v518[k74] = HotbarFrame1[k74]
        end

        t4.Properties[HotbarFrame1] = v518
    end

    HotbarFrame1 = a0.Search
    v508 = {"Position", "Size", "AnchorPoint", "TextScaled", "TextSize"}
    if not HotbarFrame1 then
    else
        local v522 = {}
        local v523 = v508
        local v524 = nil
        local v525 = nil
        for k75, k76 in v523 do
            v522[k76] = HotbarFrame1[k76]
        end

        t4.Properties[HotbarFrame1] = v522
    end

    HotbarFrame1 = a0.BackpackLabel
    local v526 = "AnchorPoint"
    v508 = {"Position", "Size", v526, "TextScaled", "TextSize"}
    if not HotbarFrame1 then
    else
        local v527 = {}
        local v528 = v508
        v526 = nil
        local v529 = nil
        for k77, k78 in v528 do
            v527[k78] = HotbarFrame1[k78]
        end

        t4.Properties[HotbarFrame1] = v527
    end

    if a0.BackpackLayout and a0.BackpackLayout:IsA("UIGridLayout") then
        local BackpackLayout = a0.BackpackLayout
        v526 = "FillDirectionMaxCells"
        local v530 = {
            "CellSize",
            "CellPadding",
            v526,
            "HorizontalAlignment",
            "VerticalAlignment"
        }
        if not BackpackLayout then
        else
            local v531 = {}
            local v532 = v530
            v526 = nil
            local v533 = nil
            for k79, k80 in v532 do
                v531[k80] = BackpackLayout[k80]
            end

            t4.Properties[BackpackLayout] = v531
        end
    end

    local HotbarButtons1 = a0.HotbarButtons
    local v534 = nil
    local v535 = nil
    local v536, v538
    for k81, k82 in HotbarButtons1 do
        local v539 = {"Size"}
        if not k82 then
        else
            local v540 = {}
            v509 = v539
            local v541 = nil
            v536 = nil
            for k83, k84 in v509 do
                v538 = k82[k84]
                v540[k84] = v538
            end

            t4.Properties[k82] = v540
        end

        local Number1 = k82:FindFirstChild("Number")
        if Number1 and Number1:IsA("GuiObject") then
            local v542 = {"Visible"}
            if not Number1 then
            else
                local v543 = {}
                local v544 = v542
                v536 = nil
                local v545 = nil
                for k85, k86 in v544 do
                    v543[k86] = Number1[k86]
                end

                t4.Properties[Number1] = v543
            end
        end
    end

    k82 = a0.BackpackFrame
    HotbarButtons1 = {a0.HotbarFrame, k82}
    v534 = nil
    v535 = nil
    for k87, k88 in HotbarButtons1 do
        for k89, k90 in k88:GetChildren() do
            if not k90:IsA("UIAspectRatioConstraint") then
                if not k90:IsA("UISizeConstraint") then
                    if k88 == a0.HotbarFrame then
                        if not k90:IsA("UIGridStyleLayout") then
                            -- jump to 286
                        end

                        -- branch continues at 286
                    end
                end
            end

            t4.Detached[k90] = k88
        end
    end

    local UIGridLayout = Instance.new("UIGridLayout")
    UIGridLayout.Name = "TouchHotbarLayout"
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.FillDirection = Enum.FillDirection.Horizontal
    UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    t4.HotbarGrid = UIGridLayout
    local TextLabel3 = Instance.new("TextLabel")
    TextLabel3.Name = "TouchHint"
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Active = false
    TextLabel3.FontFace = v10
    TextLabel3.TextSize = 12
    TextLabel3.TextColor3 = Color3.fromRGB(210, 213, 220)
    TextLabel3.Text = "Tap to equip \194\183 Hold to move \194\183 Swipe to scroll"
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel3.ZIndex = math.max(a0.BackpackList.ZIndex, a0.Search and a0.Search.ZIndex or 1)
    TextLabel3.Visible = false
    TextLabel3.Parent = a0.BackpackFrame
    t4.Hint = TextLabel3

    local function changed() --[[ Upvalues: a0 (copy) ]]
        a0:_queueTouchLayout()
    end

    local function resized() --[[ Upvalues: a0 (copy) ]]
        a0:_cancelPointerDrag()
        a0:_queueTouchLayout()
    end

    local v550 = a0.HUD:GetPropertyChangedSignal("AbsoluteSize")
    a0:_connect(v550, resized)
    local v551 = a0.HUD:GetPropertyChangedSignal("AbsolutePosition")
    a0:_connect(v551, resized)
    local v552 = UserInputService:GetPropertyChangedSignal("PreferredInput")
    a0:_connect(v552, changed)
    local v553 = "TouchEnabled"
    local v554 = UserInputService:GetPropertyChangedSignal(v553)
    a0:_connect(v554, changed)

    local function watchControl(a0) --[[ Upvalues: t4 (copy), a0 (copy), changed (copy) ]]
        if not a0:IsA("GuiObject") or t4.Controls[a0] then
            return
        end

        local v555 = a0:FindFirstAncestor("MobileButtons")
        local v556 = a0:FindFirstAncestor("TouchGui")
        if not v555 or not a0:IsA("GuiButton") or true ~= v555:FindFirstChild("Buttons") then
            v557 = v556
            if v557 then
                v557 = true
                if a0.Name ~= "JumpButton" then
                    v557 = a0.Name == "ThumbstickFrame"
                end
            end
        end

        if not v557 then
            return
        end

        t4.Controls[a0] = true
        local v558 = a0:GetPropertyChangedSignal("AbsolutePosition")
        a0:_connect(v558, changed)
        local v559 = a0:GetPropertyChangedSignal("AbsoluteSize")
        a0:_connect(v559, changed)
        a0:_queueTouchLayout()
    end

    for k91, k92 in a0.PlayerGui:GetDescendants() do
        watchControl(k92)
    end

    a0:_connect(a0.PlayerGui.DescendantAdded, function(a0) --[[ Upvalues: watchControl (copy), a0 (copy) ]]
        watchControl(a0)
        if a0.Name == "MobileButtons" or a0.Name == "TouchGui" then
            a0:_queueTouchLayout()
        end

    end)
    a0:_updateTouchLayout()
end

v3._prepareTouchLayout = _prepareTouchLayout

local function _restoreTouchLayout(a0)
    local TouchLayout = a0.TouchLayout
    if not (TouchLayout and TouchLayout.Active) then
        return
    end

    TouchLayout.Active = false
    TouchLayout.HotbarGrid.Parent = nil
    TouchLayout.Hint.Visible = false
    local StatusVisibility = TouchLayout.StatusVisibility
    local v563 = nil
    local v564 = nil
    for k93, k94 in StatusVisibility do
        if k93.Parent then
            k93.Visible = k94
        end
    end

    table.clear(TouchLayout.StatusVisibility)
    local Properties = TouchLayout.Properties
    local v565 = nil
    v564 = nil
    for k95, k96 in Properties do
        if k95.Parent then
            local v568 = k96
            local v569 = nil
            local v570 = nil
            for k97, k98 in v568 do
                k95[k97] = k98
            end
        end
    end

    Properties = TouchLayout.Detached
    v565 = nil
    v564 = nil
    for k99, k100 in Properties do
        if k100.Parent and k99.Parent == nil then
            k99.Parent = k100
        end
    end
end

v3._restoreTouchLayout = _restoreTouchLayout

local function _updateTouchLayout(a0) --[[ Upvalues: UserInputService (copy), GuiService (copy), touchLayoutVisible (copy), touchLayoutRect (copy) ]]
    local TouchLayout1 = a0.TouchLayout
    if not TouchLayout1 then
        return
    end

    local TouchEnabled1 = UserInputService.TouchEnabled
    if TouchEnabled1 then
        TouchEnabled1 = UserInputService.PreferredInput == Enum.PreferredInput.Touch
    end

    if not TouchEnabled1 then
        a0:_restoreTouchLayout()
        return
    end

    local HUD = a0.HUD
    local AbsolutePosition7 = HUD.AbsolutePosition
    TouchEnabled1 = Rect.new(AbsolutePosition7, AbsolutePosition7 + HUD.AbsoluteSize)
    HUD = TouchEnabled1
    local v572, v573 = pcall(function() --[[ Upvalues: GuiService (upvalue) ]]
        local v571 = GuiService:GetInsetArea(Enum.ScreenInsets.CoreUISafeInsets)
        return v571
    end)
    local v575, v576
    if v572 then
        local v578 = math.max(TouchEnabled1.Min.X, v573.Min.X)
        local v579 = Vector2.new(v578, math.max(TouchEnabled1.Min.Y, v573.Min.Y))
        local v580 = math.min(TouchEnabled1.Max.X, v573.Max.X)
        local v581 = Vector2.new(v580, math.min(TouchEnabled1.Max.Y, v573.Max.Y))
        HUD = Rect.new(v579, v581)
    end

    v573 = HUD.Max - HUD.Min
    if v573.X < 100 or v573.Y < 100 then
        return
    end

    if not TouchLayout1.Active then
        TouchLayout1.Active = true
        local Detached = TouchLayout1.Detached
        local v582 = nil
        local v583 = nil
        for k101, k102 in Detached do
            if k101.Parent == k102 then
                k101.Parent = nil
            end
        end

        TouchLayout1.HotbarGrid.Parent = a0.HotbarFrame
    end

    TouchLayout1.Hint.Visible = true
    v572 = {}
    local Controls = TouchLayout1.Controls
    local v584 = nil
    local v585 = nil
    for k103 in Controls do
        if k103.Parent then
            local AbsolutePosition8 = k103.AbsolutePosition
            TouchEnabled1 = Rect.new(AbsolutePosition8, AbsolutePosition8 + k103.AbsoluteSize)
            table.insert(v572, TouchEnabled1)
            if k103.Name == "JumpButton" and k103:FindFirstAncestor("TouchGui") then
                local Parent3 = k103.Parent
                local AbsolutePosition9 = Parent3.AbsolutePosition
                v576 = AbsolutePosition9 + Parent3.AbsoluteSize
                local v586 = Rect.new(AbsolutePosition9, v576)
                Parent3 = v586.Min.X + v586.Max.X
                v576 = Parent3 - TouchEnabled1.Max.X
                local v587 = Vector2.new(v576, TouchEnabled1.Min.Y)
                v576 = Vector2.new
                local v588 = Parent3 - TouchEnabled1.Min.X
                local v589 = v576(v588, TouchEnabled1.Max.Y)
                local v590 = Rect.new(v587, v589)
                table.insert(v572, v590)
            end
        end
    end

    local v591 = table.clone(v572)
    local Open1 = a0.Open
    if Open1 then
        Open1 = false
        if v573.Y < v573.X then
            Open1 = v573.Y < 360
        end
    end

    local v592 = "HealthBar"
    v585 = {"Health", v592, "Hunger", "Thirst", "Armor", "Level"}
    k103 = nil
    v575 = nil
    for k104, k105 in v585 do
        local v593 = a0.HUD:FindFirstChild(k105)
        if v593 then
            if v593:IsA("GuiObject") then
                if Open1 then
                    if TouchLayout1.StatusVisibility[v593] == nil then
                        TouchLayout1.StatusVisibility[v593] = v593.Visible
                    end

                    v593.Visible = false
                else
                    if TouchLayout1.StatusVisibility[v593] ~= nil then
                        v593.Visible = TouchLayout1.StatusVisibility[v593]
                        TouchLayout1.StatusVisibility[v593] = nil
                    end

                    if touchLayoutVisible(v593) then
                        v576 = v593
                        local v594 = touchLayoutRect(v576)
                        table.insert(v591, v594)
                    end
                end
            end
        end
    end

    Open1 = HUD.Max.Y - 4
    local v595 = (HUD.Min.X + HUD.Max.X) / 2

    local function findHorizontalSpace(a0, a1, a2) --[[ Upvalues: HUD (ref), v591 (copy), v595 (copy) ]]
        local v596 = HUD.Min.X + 8
        local v597 = {v596, HUD.Max.X - 8}
        local v598 = {v597}
        v597 = a2 - a1
        if v597 < HUD.Min.Y + 8 then
            return nil
        end

        local v599 = v591
        local v600 = nil
        local v601 = nil
        local v602
        for k106, k107 in v599 do
            if v597 < k107.Max.Y and k107.Min.Y < a2 then
                local v604 = {}
                v602 = v598
                local v605 = nil
                local v606 = nil
                for k108, k109 in v602 do
                    local v607 = k107.Max.X + 4
                    if v607 <= k109[1] or k107.Min.X - 4 <= v607 then
                        table.insert(v604, k109)
                        -- jump to 125 (out of range)
                    end

                    v607 = k107.Min.X - 4
                    if k109[1] < v607 then
                        local v608 = {k109[1], k107.Min.X - 4}
                        table.insert(v604, v608)
                    end

                    v607 = k107.Max.X + 4
                    if v607 < k109[2] then
                        local v609 = k107.Max.X + 4
                        local v610 = {v609, k109[2]}
                        table.insert(v604, v610)
                    end
                end

                v598 = v604
            end
        end

        v599 = nil
        v600 = nil
        v601 = v598
        k106 = nil
        k107 = nil
        for k110, k111 in v601 do
            if a0 <= k111[2] - k111[1] then
                local v611 = k111[1] + a0 / 2
                v597 = math.clamp(v595, v611, k111[2] - a0 / 2)
                if v600 then
                    if math.abs(v597 - v595) >= v600 then
                        -- jump to 170
                    end
                end

                v599 = v597
                v600 = math.abs(v597 - v595)
            end
        end

        return v599
    end

    v575 = nil
    if 600 <= v573.X then
        local v612 = {10, 5}
        if v612 then
            -- jump to 381
        end
    end

    local v613 = {5, 10}
    local v614 = {Open1}
    local v615 = v591
    local v616 = nil
    local v617 = nil
    for k112, k113 in v615 do
        if k113.Min.Y - 8 < Open1 then
            table.insert(v614, k113.Min.Y - 8)
        end
    end

    table.sort(v614, function(a0, a1)
        return a1 < a0
    end)
    local v618 = v614
    local v619 = nil
    local v620 = nil
    for k114, k115 in v618 do
        local v621 = v613
        local v622 = nil
        local v623 = nil
        for k116, k117 in v621 do
            local v624 = 44
            local v625 = {48, v624}
            local v626 = nil
            local v627 = nil
            for k118, k119 in v625 do
                local v628 = math.ceil(10 / k117)
                local v629 = k117 * k119 + (k117 - 1) * 4
                local v630 = v628 * k119 + (v628 - 1) * 4
                local v631 = findHorizontalSpace(v629, v630, k115)
                if v631 then
                    local v632 = {
                        Center = v631,
                        Top = k115 - v630,
                        Width = v629,
                        Height = v630,
                        Cell = k119,
                        Columns = k117
                    }
                    v575 = v632
                    break
                end
            end

            if v575 then
                break
            end
        end

        if v575 then
            break
        end
    end

    if not v575 then
        if 492 <= v573.X then
            v614 = 10
        else
            v614 = 5
        end

        local v633 = math.ceil(10 / v614)
        local v634 = v614 * 44 + (v614 - 1) * 4
        local v635 = v633 * 44 + (v633 - 1) * 4
        local v636 = HUD.Min.Y + 8
        local v637 = {Cell = 44, Center = v595}
        v637.Top = math.max(v636, Open1 - v635)
        v637.Width = v634
        v637.Height = v635
        v637.Columns = v614
        v575 = v637
    end

    local AbsolutePosition10 = a0.HUD.AbsolutePosition
    a0.HotbarFrame.AnchorPoint = Vector2.zero
    k114 = v575.Center - v575.Width / 2
    v620 = k114 - AbsolutePosition10.X
    local Top = v575.Top
    a0.HotbarFrame.Position = UDim2.fromOffset(v620, Top - AbsolutePosition10.Y)
    a0.HotbarFrame.Size = UDim2.fromOffset(v575.Width, v575.Height)
    TouchLayout1.HotbarGrid.CellSize = UDim2.fromOffset(v575.Cell, v575.Cell)
    TouchLayout1.HotbarGrid.CellPadding = UDim2.fromOffset(4, 4)
    TouchLayout1.HotbarGrid.FillDirectionMaxCells = v575.Columns
    local HotbarButtons2 = a0.HotbarButtons
    local v638 = nil
    local v639 = nil
    for k120, k121 in HotbarButtons2 do
        findHorizontalSpace = k121:FindFirstChild("Number")
        if findHorizontalSpace and findHorizontalSpace:IsA("GuiObject") then
            findHorizontalSpace.Visible = false
        end
    end

    Open1 = math.min(672, v573.X - 16)
    local v640 = v575.Top - 8
    local Y4 = v573.Y
    local v641 = math.min(v640 - HUD.Min.Y - 8, 360, math.max(220, math.floor(Y4 * 0.58)))
    if v641 < 120 then
        local v642 = v573.Y - 16
        v641 = math.min(v642, 220)
        v640 = HUD.Min.Y + 8 + v641
    end

    local v643 = HUD.Min.X + 8
    local v644 = HUD.Max.X - 8
    local v645 = v572
    local v646 = nil
    local v647 = nil
    for k122, k123 in v645 do
        if v640 - v641 < k123.Max.Y then
            if k123.Min.Y < v640 then
                if (k123.Min.X + k123.Max.X) / 2 < v595 then
                    v643 = math.max(v643, k123.Max.X + 8)
                else
                    v644 = math.min(v644, k123.Min.X - 8)
                end
            end
        end
    end

    if math.min(240, v573.X - 16) <= v644 - v643 then
        Open1 = math.min(Open1, math.floor(v644 - v643))
    else
        v643 = HUD.Min.X + 8
        v644 = HUD.Max.X - 8
    end

    local v648 = v643 + Open1 / 2
    v575 = math.clamp(v595, v648, v644 - Open1 / 2)
    a0.BackpackFrame.AnchorPoint = Vector2.zero
    local v649 = v575 - Open1 / 2
    v648 = v649 - AbsolutePosition10.X
    a0.BackpackFrame.Position = UDim2.fromOffset(v648, v640 - v641 - AbsolutePosition10.Y)
    a0.BackpackFrame.Size = UDim2.fromOffset(Open1, v641)
    local v650 = math.floor(math.min(280, Open1 * 0.56))
    if a0.Search then
        a0.Search.AnchorPoint = Vector2.zero
        local v651 = Open1 - v650 - 8
        a0.Search.Position = UDim2.fromOffset(v651, 6)
        a0.Search.Size = UDim2.fromOffset(v650, 44)
        a0.Search.TextScaled = false
        a0.Search.TextSize = 16
    end

    if a0.BackpackLabel then
        a0.BackpackLabel.AnchorPoint = Vector2.zero
        a0.BackpackLabel.Position = UDim2.fromOffset(8, 6)
        local v652 = Open1 - v650 - 24
        a0.BackpackLabel.Size = UDim2.fromOffset(v652, 40)
        a0.BackpackLabel.TextScaled = false
        a0.BackpackLabel.TextSize = 16
    end

    a0.BackpackList.AnchorPoint = Vector2.zero
    TouchLayout1.Hint.Position = UDim2.fromOffset(8, 48)
    TouchLayout1.Hint.Size = UDim2.fromOffset(Open1 - 16, 20)
    a0.BackpackList.Position = UDim2.fromOffset(8, 72)
    a0.BackpackList.Size = UDim2.fromOffset(Open1 - 16, math.max(44, v641 - 80))
    a0.BackpackList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    a0.BackpackList.CanvasSize = UDim2.fromOffset(0, 0)
    a0.BackpackList.ScrollingDirection = Enum.ScrollingDirection.Y
    a0.BackpackList.ScrollBarThickness = 6
    v650 = a0.BackpackLayout
    if v650 and v650:IsA("UIGridLayout") then
        v643 = Open1 - 32
        local v653 = math.floor((v643 + 6) / 54)
        v641 = math.clamp(v653, 1, 10)
        local v654 = math.floor((v643 - (v641 - 1) * 6) / v641)
        v640 = math.clamp(v654, 44, 56)
        v650.CellSize = UDim2.fromOffset(v640, v640)
        v650.CellPadding = UDim2.fromOffset(6, 6)
        v650.FillDirectionMaxCells = v641
        v650.HorizontalAlignment = Enum.HorizontalAlignment.Center
        v650.VerticalAlignment = Enum.VerticalAlignment.Top
    end

    a0:_queueBackpackViewportRefresh()
end

v3._updateTouchLayout = _updateTouchLayout

local function _bindInputs(a0) --[[ Upvalues: RunService (copy), GamepadService (copy), GuiService (copy), UserInputService (copy), v7 (copy), ContextActionService (copy) ]]
    a0:_connect(RunService.RenderStepped, function() --[[ Upvalues: a0 (copy), GamepadService (upvalue), GuiService (upvalue) ]]
        if a0.Destroyed then
            return
        end

        a0:_syncInventoryVisibility()
        if a0.PointerDrag then
            a0:_validatePointerDrag()
            a0:_updateMousePointerDrag()
        else
            if next(a0.DragGhosts) ~= nil then
                a0:_destroyAllDragGhosts()
            end
        end

        if a0.TouchLayoutPending and not a0.PointerDrag then
            a0.TouchLayoutPending = nil
            a0:_queueTouchLayout()
        end

        if a0.ControllerNavigationActive then
            a0:_updateControllerTransfer()
            if a0.ControllerStatus and a0.ControllerStatusUntil <= os.clock() then
                a0.ControllerStatus.Text = ""
            end

            if a0.ControllerCursorMode and not GamepadService.GamepadCursorEnabled then
                a0:_setControllerCursorMode(false)
            else
                if not a0.ControllerCursorMode and GamepadService.GamepadCursorEnabled then
                    a0:_releaseBackpackGamepadCursor()
                end
            end

            local ControllerDirection = a0.ControllerDirection
            if ControllerDirection and a0.ControllerRepeatAt <= os.clock() then
                a0.ControllerRepeatAt = os.clock() + 0.12
                a0:_navigateController(ControllerDirection.X, ControllerDirection.Y)
            end

            a0:_repairControllerSelection()
            local SelectedObject5 = GuiService.SelectedObject
            if SelectedObject5 and a0:_isControllerButton(SelectedObject5) then
                a0:_scrollControllerSelection(SelectedObject5)
            end

            a0:_updateControllerVisuals()
        end

    end)
    local v655 = UserInputService:GetPropertyChangedSignal("PreferredInput")
    a0:_connect(v655, function() --[[ Upvalues: UserInputService (upvalue), a0 (copy), GuiService (upvalue) ]]
        if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
            if a0.Open then
                if not GuiService.MenuIsOpen then
                    a0:_setControllerNavigation(true)
                    return
                    -- branch continues at 32
                end

                -- branch continues at 32
            end
        end

        if a0.ControllerNavigationActive then
            a0:_setControllerNavigation(false)
        end

    end)
    a0:_connect(UserInputService.GamepadDisconnected, function() --[[ Upvalues: a0 (copy) ]]
        if a0.ControllerNavigationActive then
            a0:SetOpen(false)
        end

    end)
    a0:_connect(GuiService.MenuOpened, function() --[[ Upvalues: a0 (copy) ]]
        a0:_cancelPointerDrag()
        if a0.ControllerNavigationActive then
            a0:SetOpen(false)
        end

    end)
    a0:_connect(UserInputService.WindowFocusReleased, function() --[[ Upvalues: a0 (copy) ]]
        a0:_cancelPointerDrag()
        if a0.ControllerNavigationActive then
            a0:SetOpen(false)
        end

    end)
    a0:_connect(UserInputService.InputChanged, function(a0) --[[ Upvalues: a0 (copy) ]]
        a0:_updatePointerDrag(a0)
    end)
    a0:_connect(UserInputService.InputEnded, function(a0) --[[ Upvalues: a0 (copy) ]]
        a0:_controllerConfirmInput(a0.UserInputState, a0)
        a0:_controllerCursorToggleInput(a0.UserInputState, a0)
        a0:_controllerBackpackPointerInput(a0.UserInputState, a0)
        a0:_finishPointerDrag(a0)
    end)
    a0:_connect(UserInputService.InputBegan, function(a0, a1) --[[ Upvalues: a0 (copy), UserInputService (upvalue), v7 (upvalue) ]]
        a0:_controllerConfirmInput(Enum.UserInputState.Begin, a0)
        a0:_controllerCursorToggleInput(Enum.UserInputState.Begin, a0)
        a0:_controllerBackpackPointerInput(Enum.UserInputState.Begin, a0)
        if a0.ControllerNavigationActive then
            if a0.UserInputType ~= Enum.UserInputType.Keyboard then
                if a0.UserInputType ~= Enum.UserInputType.Touch then
                    if a0.UserInputType == Enum.UserInputType.MouseButton1 then
                        if a0:_usingGamepadCursor() then
                            -- jump to 58
                        end

                        -- branch continues at 58
                    end
                end
            end

            a0:_setControllerNavigation(false)
        end

        if a1 or not a0.Enabled or UserInputService:GetFocusedTextBox() then
            return
        end

        local v656 = v7[a0.KeyCode]
        if v656 then
            local v657 = a0.HotbarTools[v656]
            if v657 then
                a0:_toggleEquip(v657)
                return
                -- branch continues at 103
            end
        end

        if a0.KeyCode == Enum.KeyCode.Backquote then
            local v658 = not a0.Open
            a0:SetOpen(v658, false)
        end

    end)
    a0:_connect(UserInputService.InputBegan, function(a0, a1) --[[ Upvalues: a0 (copy) ]]
        if a1 or not a0.Enabled or not a0.Open or a0.PointerDrag or a0.GamepadHeldTool then
            return
        end

        local UserInputType1 = a0.UserInputType
        if UserInputType1 ~= Enum.UserInputType.MouseButton1 and UserInputType1 ~= Enum.UserInputType.Touch then
            return
        end

        if UserInputType1 == Enum.UserInputType.MouseButton1 and a0:_usingGamepadCursor() then
            return
        end

        local v659 = Vector2.new(a0.Position.X, a0.Position.Y)
        local BackpackFrame3 = a0.BackpackFrame
        local AbsolutePosition11 = BackpackFrame3.AbsolutePosition
        local AbsoluteSize5 = BackpackFrame3.AbsoluteSize
        local v660 = false
        if AbsolutePosition11.X <= v659.X then
            v660 = false
            if AbsolutePosition11.Y <= v659.Y then
                v660 = false
                if v659.X <= AbsolutePosition11.X + AbsoluteSize5.X then
                    v660 = v659.Y <= AbsolutePosition11.Y + AbsoluteSize5.Y
                end
            end
        end

        if v660 then
            return
        end

        local HotbarFrame2 = a0.HotbarFrame
        AbsolutePosition11 = HotbarFrame2.AbsolutePosition
        AbsoluteSize5 = HotbarFrame2.AbsoluteSize
        v660 = false
        if AbsolutePosition11.X <= v659.X then
            v660 = false
            if AbsolutePosition11.Y <= v659.Y then
                v660 = false
                if v659.X <= AbsolutePosition11.X + AbsoluteSize5.X then
                    v660 = v659.Y <= AbsolutePosition11.Y + AbsoluteSize5.Y
                end
            end
        end

        if v660 then
            return
        end

        if a0:_findInventoryButtonAt(v659) then
            return
        end

        a0:SetOpen(false)
    end)
    ContextActionService:BindActionAtPriority("CustomBackpackToggle", function(a0, a1, a2) --[[ Upvalues: a0 (copy), GuiService (upvalue), UserInputService (upvalue) ]]
        if not a0.Enabled or GuiService.MenuIsOpen or UserInputService:GetFocusedTextBox() then
            return Enum.ContextActionResult.Pass
        end

        if a0.ControllerNavigationActive then
            local v661 = a0:_handleControllerInput(a1, a2)
            return v661
        end

        if a1 == Enum.UserInputState.Begin then
            a0:SetOpen(true, true)
        end

        return Enum.ContextActionResult.Sink
    end, false, 3000, Enum.KeyCode.DPadDown)
    ContextActionService:BindActionAtPriority("CustomBackpackCycle", function(a0, a1, a2) --[[ Upvalues: a0 (copy), GuiService (upvalue) ]]
        if not a0.Enabled or GuiService.MenuIsOpen then
            return Enum.ContextActionResult.Pass
        end

        if a0.Open then
            a0:_setControllerNavigation(true)
            local v662 = a0:_handleControllerInput(a1, a2)
            return v662
        end

        if a1 == Enum.UserInputState.Begin then
            if a2.KeyCode == Enum.KeyCode.ButtonL1 then
                a0:_cycleHotbar(-1)
            else
                if a2.KeyCode == Enum.KeyCode.ButtonR1 then
                    a0:_cycleHotbar(1)
                end
            end
        end

        return Enum.ContextActionResult.Sink
    end, false, 2900, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
end

v3._bindInputs = _bindInputs

local function Destroy(a0) --[[ Upvalues: ContextActionService (copy) ]]
    if a0.Destroyed then
        return
    end

    a0.Destroyed = true
    a0:SetOpen(false)
    a0:_cancelPointerDrag()
    a0:_releaseBackpackGamepadCursor()
    ContextActionService:UnbindAction("CustomBackpackToggle")
    ContextActionService:UnbindAction("CustomBackpackCycle")
    ContextActionService:UnbindAction("CustomBackpackMove")
    if a0.BackpackIcon then
        a0.BackpackIcon:destroy()
        a0.BackpackIcon = nil
    end

    local CharacterConnections1 = a0.CharacterConnections
    local v663 = nil
    local v664 = nil
    for k124, k125 in CharacterConnections1 do
        k125:Disconnect()
    end

    CharacterConnections1 = a0.BackpackConnections
    v663 = nil
    v664 = nil
    for k126, k127 in CharacterConnections1 do
        k127:Disconnect()
    end

    CharacterConnections1 = a0.Connections
    v663 = nil
    v664 = nil
    for k128, k129 in CharacterConnections1 do
        k129:Disconnect()
    end

    CharacterConnections1 = a0.ToolConnections
    v663 = nil
    v664 = nil
    for k130, k131 in CharacterConnections1 do
        local v666 = k131
        local v667 = nil
        local v668 = nil
        for k132, k133 in v666 do
            k133:Disconnect()
        end

        a0.ToolConnections[k130] = nil
    end

    CharacterConnections1 = a0.BackpackButtons
    v663 = nil
    v664 = nil
    for k134, k135 in CharacterConnections1 do
        a0.BackpackButtons[k134] = nil
        a0:_disconnectButton(k135)
        if k135.Parent then
            k135:Destroy()
        end
    end

    CharacterConnections1 = a0.HotbarButtons
    v663 = nil
    v664 = nil
    for k136, k137 in CharacterConnections1 do
        a0:_disconnectButton(k137)
        if k137.Parent then
            a0:_setButtonViewportActive(k137, nil, false)
        end
    end

    a0:_restoreTouchLayout()
    if a0.TouchLayout then
        a0.TouchLayout.HotbarGrid:Destroy()
        a0.TouchLayout.Hint:Destroy()
    end

    a0:_destroyAllDragGhosts()
    a0:_hideTooltip()
    a0.BackpackFrame.Selectable = a0.SavedBackpackSelectable
    a0.ControllerPanel:Destroy()
    a0.ControllerFocus:Destroy()
end

v3.Destroy = Destroy
return v3
