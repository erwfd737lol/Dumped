
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local v1 = require(script.Types)
v1 = script
local v2 = require(v1.Reference)
local v3 = v2.getObject()
local v5 = v3 and v3.Value
if v5 and v5 ~= v1 then
    return require(v5)
end

if not v3 then
    v2.addToReplicatedStorage()
end

local v6 = require(v1.Packages.GoodSignal)
v3 = require(v1.Packages.Janitor)
v2 = require(v1.Utility)
local v7 = require(v1.Features.Themes)
local v8 = require(v1.Features.Gamepad)
local v9 = require(v1.Features.Overflow)
local v10 = {}
v10.__index = v10
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v11 = v6.new()
local Elements = v1.Elements
local t2 = {
    mobile = Enum.PreferredInput.Touch,
    desktop = Enum.PreferredInput.KeyboardAndMouse,
    console = Enum.PreferredInput.Gamepad
}
v10.baseDisplayOrderChanged = v6.new()
v10.baseDisplayOrder = 10
v10.baseTheme = require(v1.Features.Themes.Default)
v10.isOldTopbar = false
v10.iconsDictionary = t1
v10.insetHeightChanged = v6.new()
local v12 = require(Elements.Container)
v10.container = v12(v10)
v10.topbarEnabled = true
v10.iconAdded = v6.new()
v10.iconRemoved = v6.new()
v10.iconChanged = v6.new()

local function getIcons() --[[ Upvalues: v10 (copy) ]]
    return v10.iconsDictionary
end

v10.getIcons = getIcons

local function getIconByUID(a0) --[[ Upvalues: v10 (copy) ]]
    local v13 = v10.iconsDictionary[a0]
    if v13 then
        return v13
    end

    return nil
end

v10.getIconByUID = getIconByUID

local function getIcon(a0) --[[ Upvalues: v10 (copy), t1 (copy) ]]
    local v14 = v10.getIconByUID(a0)
    if v14 then
        return v14
    end

    for k1, k2 in pairs(t1) do
        if k2.name == a0 then
            return k2
        end
    end

    return nil
end

v10.getIcon = getIcon

local function setTopbarEnabled(a0, a1) --[[ Upvalues: v10 (copy) ]]
    if typeof(a0) ~= "boolean" then
        a0 = v10.topbarEnabled
    end

    if not a1 then
        v10.topbarEnabled = a0
    end

    for k3, k4 in pairs(v10.container) do
        k4.Enabled = a0
    end
end

v10.setTopbarEnabled = setTopbarEnabled

local function modifyBaseTheme(a0) --[[ Upvalues: v7 (copy), v10 (copy), t1 (copy) ]]
    a0 = v7.getModifications(a0)
    for k5, k6 in pairs(a0) do
        for k7, k8 in pairs(v10.baseTheme) do
            v7.merge(k8, k6)
        end
    end

    for k9, k10 in pairs(t1) do
        k10:setTheme(v10.baseTheme)
    end
end

v10.modifyBaseTheme = modifyBaseTheme

local function setDisplayOrder(a0) --[[ Upvalues: v10 (copy) ]]
    v10.baseDisplayOrder = a0
    v10.baseDisplayOrderChanged:Fire(a0)
end

v10.setDisplayOrder = setDisplayOrder
task.defer(v8.start, v10)
task.defer(v9.start, v10)
task.defer(function() --[[ Upvalues: LocalPlayer (copy), v10 (copy) ]]
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    for k11, k12 in pairs(v10.container) do
        k12.Parent = PlayerGui
    end

end)
local v34 = 0

local function new() --[[ Upvalues: v10 (copy), v3 (copy), v2 (copy), t1 (copy), v6 (copy), v1 (copy), Elements (copy), v34 (ref), UserInputService (copy), t2 (copy), v11 (copy), StarterGui (copy) ]]
    local t3 = {}
    setmetatable(t3, v10)
    local v35 = v3.new()
    t3.janitor = v35
    local v36 = v3.new()
    t3.themesJanitor = v35:add(v36)
    local v37 = v3.new()
    t3.singleClickJanitor = v35:add(v37)
    local v38 = v3.new()
    t3.captionJanitor = v35:add(v38)
    local v39 = v3.new()
    t3.joinJanitor = v35:add(v39)
    local v40 = v3.new()
    t3.menuJanitor = v35:add(v40)
    local v41 = v3.new()
    t3.dropdownJanitor = v35:add(v41)
    local v42 = v2.generateUID()
    t1[v42] = t3
    v35:add(function() --[[ Upvalues: t1 (upvalue), v42 (copy) ]]
        t1[v42] = nil
    end)
    local v43 = v6.new()
    t3.selected = v35:add(v43)
    local v44 = v6.new()
    t3.deselected = v35:add(v44)
    local v45 = v6.new()
    t3.toggled = v35:add(v45)
    local v46 = v6.new()
    t3.viewingStarted = v35:add(v46)
    local v47 = v6.new()
    t3.viewingEnded = v35:add(v47)
    local v48 = v6.new()
    t3.stateChanged = v35:add(v48)
    local v49 = v6.new()
    t3.notified = v35:add(v49)
    local v50 = v6.new()
    t3.noticeStarted = v35:add(v50)
    local v51 = v6.new()
    t3.noticeChanged = v35:add(v51)
    local v52 = v6.new()
    t3.endNotices = v35:add(v52)
    local v53 = v6.new()
    t3.toggleKeyAdded = v35:add(v53)
    local v54 = v6.new()
    t3.fakeToggleKeyChanged = v35:add(v54)
    local v55 = v6.new()
    t3.alignmentChanged = v35:add(v55)
    local v56 = v6.new()
    t3.updateSize = v35:add(v56)
    local v57 = v6.new()
    t3.resizingComplete = v35:add(v57)
    local v58 = v6.new()
    t3.joinedParent = v35:add(v58)
    local v59 = v6.new()
    t3.menuSet = v35:add(v59)
    local v60 = v6.new()
    t3.dropdownSet = v35:add(v60)
    local v61 = v6.new()
    t3.updateMenu = v35:add(v61)
    local v62 = v6.new()
    t3.startMenuUpdate = v35:add(v62)
    local v63 = v6.new()
    t3.childThemeModified = v35:add(v63)
    local v64 = v6.new()
    t3.indicatorSet = v35:add(v64)
    local v65 = v6.new()
    t3.dropdownChildAdded = v35:add(v65)
    local v66 = v6.new()
    t3.menuChildAdded = v35:add(v66)
    t3.iconModule = v1
    t3.UID = v42
    t3.isEnabled = true
    t3.enabled = t3.isEnabled
    t3.isSelected = false
    t3.isViewing = false
    t3.joinedFrame = false
    t3.parentIconUID = false
    t3.deselectWhenOtherIconSelected = true
    t3.totalNotices = 0
    t3.activeState = "Deselected"
    t3.alignment = ""
    t3.originalAlignment = ""
    t3.appliedTheme = {}
    t3.appearance = {}
    t3.cachedInstances = {}
    t3.cachedNamesToInstances = {}
    t3.cachedCollectives = {}
    t3.bindedToggleKeys = {}
    t3.customBehaviours = {}
    t3.toggleItems = {}
    t3.bindedEvents = {}
    t3.notices = {}
    t3.menuIcons = {}
    t3.dropdownIcons = {}
    t3.childIconsDict = {}
    t3.creationTime = os.clock()
    local v67 = require(Elements.Widget)
    local v68 = v67(t3, v10)
    t3.widget = v35:add(v68)
    t3:setAlignment()
    v34 = v34 + 1
    local v69 = v34 * 0.01 + 1
    t3:setOrder(v69, "deselected")
    t3:setOrder(v69, "selected")
    t3:setTheme(v10.baseTheme)
    local v70 = t3:getInstance("ClickRegion")
    local v71 = false
    local v72 = 0

    local function handleToggle() --[[ Upvalues: t3 (copy), v72 (ref) ]]
        if t3.locked then
            return
        end

        local v73 = tick()
        local v74 = v73 - v72
        if v74 < 0.1 then
            return
        end

        v72 = v73
        if t3.isSelected then
            t3:deselect("User", t3)
            return
        end

        t3:select("User", t3)
    end

    v70.MouseButton1Click:Connect(function() --[[ Upvalues: v71 (ref), t3 (copy), v72 (ref) ]]
        v71 = true
        if t3.locked then
            return
        end

        local v75 = tick()
        local v76 = v75 - v72
        if v76 < 0.1 then
            return
        end

        v72 = v75
        if t3.isSelected then
            t3:deselect("User", t3)
            return
        end

        t3:select("User", t3)
    end)
    v70.TouchTap:Connect(function() --[[ Upvalues: v71 (ref), t3 (copy), v72 (ref) ]]
        if not v71 then
            if t3.locked then
                return
            end

            local v77 = tick()
            local v78 = v77 - v72
            if v78 < 0.1 then
                return
            end

            v72 = v77
            if t3.isSelected then
                t3:deselect("User", t3)
                return
            end

            t3:select("User", t3)
        end

    end)
    local v81 = UserInputService.InputBegan:Connect(function(a0, a1) --[[ Upvalues: t3 (copy), v72 (ref) ]]
        if t3.locked then
            return
        end

        if t3.bindedToggleKeys[a0.KeyCode] then
            if not a1 then
                if t3.locked then
                    return
                end

                local v79 = tick()
                local v80 = v79 - v72
                if v80 < 0.1 then
                    return
                end

                v72 = v79
                if t3.isSelected then
                    t3:deselect("User", t3)
                    return
                end

                t3:select("User", t3)
            end
        end

    end)
    v35:add(v81)

    local function viewingStarted(a0) --[[ Upvalues: t3 (copy) ]]
        if t3.locked then
            return
        end

        t3.isViewing = true
        t3.viewingStarted:Fire(true)
        if not a0 then
            t3:setState("Viewing", "User", t3)
        end
    end

    local function viewingEnded() --[[ Upvalues: t3 (copy) ]]
        if t3.locked then
            return
        end

        t3.isViewing = false
        t3.viewingEnded:Fire(true)
        t3:setState(nil, "User", t3)
    end

    t3.joinedParent:Connect(function() --[[ Upvalues: t3 (copy) ]]
        if t3.isViewing then
            if t3.locked then
                return
            end

            t3.isViewing = false
            t3.viewingEnded:Fire(true)
            t3:setState(nil, "User", t3)
        end

    end)
    v70.MouseEnter:Connect(function() --[[ Upvalues: UserInputService (upvalue), t2 (upvalue), t3 (copy) ]]
        if t3.locked then
            return
        end

        t3.isViewing = true
        t3.viewingStarted:Fire(true)
        if not (UserInputService.PreferredInput ~= t2.desktop) then
            t3:setState("Viewing", "User", t3)
        end

    end)
    local v82 = 0
    local v83 = UserInputService.TouchEnded:Connect(viewingEnded)
    v35:add(v83)
    v70.MouseLeave:Connect(viewingEnded)
    v70.SelectionGained:Connect(viewingStarted)
    v70.SelectionLost:Connect(viewingEnded)
    v70.MouseButton1Down:Connect(function() --[[ Upvalues: t3 (copy), UserInputService (upvalue), t2 (upvalue), v82 (ref) ]]
        if not t3.locked and UserInputService.PreferredInput == t2.mobile then
            v82 = v82 + 1
            local v84 = v82
            task.delay(0.2, function() --[[ Upvalues: v84 (copy), v82 (upvalue), t3 (upvalue) ]]
                if v84 == v82 then
                    if t3.locked then
                        return
                    end

                    t3.isViewing = true
                    t3.viewingStarted:Fire(true)
                    t3:setState("Viewing", "User", t3)
                end

            end)
        end

    end)
    v70.MouseButton1Up:Connect(function() --[[ Upvalues: v82 (ref) ]]
        v82 = v82 + 1
    end)
    v70 = t3:getInstance("IconOverlay")
    t3.viewingStarted:Connect(function() --[[ Upvalues: v70 (copy), t3 (copy) ]]
        v70.Visible = not t3.overlayDisabled
    end)
    t3.viewingEnded:Connect(function() --[[ Upvalues: v70 (copy) ]]
        v70.Visible = false
    end)
    local v85 = v11:Connect(function(a0) --[[ Upvalues: t3 (copy) ]]
        if a0 ~= t3 and t3.deselectWhenOtherIconSelected and a0.deselectWhenOtherIconSelected then
            t3:deselect("AutoDeselect", a0)
        end

    end)
    v35:add(v85)
    v35 = debug.info(2, "s")
    local v86 = string.split(v35, ".")
    v35 = game
    local v87 = nil
    for k13, k14 in pairs(v86) do
        v35 = v35:FindFirstChild(k14)
        if not v35 then
            break
        end

        if v35:IsA("ScreenGui") then
            v87 = v35
        end
    end

    if v35 and v87 and v87.ResetOnSpawn == true then
        t3.originsScreenGui = v87
        v2.localPlayerRespawned(function() --[[ Upvalues: t3 (copy) ]]
            t3:destroy()
        end)
    end

    t3.toggled:Connect(function(a0) --[[ Upvalues: t3 (copy), v10 (upvalue) ]]
        t3.noticeChanged:Fire(t3.totalNotices)
        for k15, k16 in pairs(t3.childIconsDict) do
            local v94 = v10.getIconByUID(k15)
            v94.noticeChanged:Fire(v94.totalNotices)
            if not a0 and v94.isSelected then
                for k17, k18 in pairs(v94.childIconsDict) do
                    v94:deselect("HideParentFeature", t3)
                end
            end
        end

    end)
    t3.selected:Connect(function() --[[ Upvalues: t3 (copy), StarterGui (upvalue) ]]
        local v98 = #t3.dropdownIcons
        if 0 < v98 then
            if StarterGui:GetCore("ChatActive") and t3.alignment ~= "Right" then
                t3.chatWasPreviouslyActive = true
                StarterGui:SetCore("ChatActive", false)
            end

            if StarterGui:GetCoreGuiEnabled("PlayerList") and t3.alignment ~= "Left" then
                t3.playerlistWasPreviouslyActive = true
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
            end
        end

    end)
    t3.deselected:Connect(function() --[[ Upvalues: t3 (copy), StarterGui (upvalue) ]]
        if t3.chatWasPreviouslyActive then
            t3.chatWasPreviouslyActive = nil
            StarterGui:SetCore("ChatActive", true)
        end

        if t3.playerlistWasPreviouslyActive then
            t3.playerlistWasPreviouslyActive = nil
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
        end

    end)
    task.delay(0.1, function() --[[ Upvalues: t3 (copy) ]]
        if t3.activeState == "Deselected" then
            t3.stateChanged:Fire("Deselected")
            t3:refresh()
        end

    end)
    v10.iconAdded:Fire(t3)
    return t3
end

v10.new = new

local function setName(a0, a1)
    a0.widget.Name = a1
    a0.name = a1
    return a0
end

v10.setName = setName

local function setState(a0, a1, a2, a3) --[[ Upvalues: v2 (copy), v11 (copy) ]]
    if not a1 then
        local v99
        if a0.isSelected then
            v99 = "Selected"
        else
            v99 = "Deselected"
        end

        a1 = v99
    end

    local v100 = v2.formatStateName(a1)
    if a0.activeState == v100 then
        return
    end

    local isSelected = a0.isSelected
    a0.activeState = v100
    if v100 == "Deselected" then
        a0.isSelected = false
        if isSelected then
            a0.toggled:Fire(false, a2, a3)
            a0.deselected:Fire(a2, a3)
        end

        a0:_setToggleItemsVisible(false, a2, a3)
    else
        if v100 == "Selected" then
            a0.isSelected = true
            if not isSelected then
                a0.toggled:Fire(true, a2, a3)
                a0.selected:Fire(a2, a3)
                v11:Fire(a0, a2, a3)
            end

            a0:_setToggleItemsVisible(true, a2, a3)
        end
    end

    a0.stateChanged:Fire(v100, a2, a3)
end

v10.setState = setState

local function getInstance(a0, a1) --[[ Upvalues: v7 (copy) ]]
    local v101 = a0.cachedNamesToInstances[a1]
    if v101 then
        return v101
    end

    local function cacheInstance(a0, a1) --[[ Upvalues: a0 (copy) ]]
        if not a0.cachedInstances[a1] then
            local v102 = a1:GetAttribute("Collective")
            local v105 = v102 and a0.cachedCollectives[v102]
            if v105 then
                table.insert(v105, a1)
            end

            a0.cachedNamesToInstances[a0] = a1
            a0.cachedInstances[a1] = true
            a1.Destroying:Once(function() --[[ Upvalues: a0 (upvalue), a0 (copy), a1 (copy) ]]
                a0.cachedNamesToInstances[a0] = nil
                a0.cachedInstances[a1] = nil
            end)
        end
    end

    local widget = a0.widget
    cacheInstance("Widget", widget)
    if a1 == "Widget" then
        return widget
    end

    local v106 = nil

    local function scanChildren(a0) --[[ Upvalues: a0 (copy), v7 (upvalue), scanChildren (copy), cacheInstance (copy), a1 (copy), v106 (ref) ]]
        local v107 = a0:GetChildren()
        for k19, k20 in pairs(v107) do
            local v111 = k20:GetAttribute("WidgetUID")
            if not v111 or v111 == a0.UID then
                local v112 = v7.getRealInstance(k20)
                if v112 then
                    k20 = v112
                end

                scanChildren(k20)
                if k20:IsA("GuiBase") or k20:IsA("UIBase") or k20:IsA("ValueBase") then
                    v112 = k20.Name
                    cacheInstance(v112, k20)
                    if v112 == a1 then
                        v106 = k20
                    end
                end
            end
        end
    end

    scanChildren(widget)
    return v106
end

v10.getInstance = getInstance

local function getCollective(a0, a1)
    local v113 = a0.cachedCollectives[a1]
    if v113 then
        return v113
    end

    v113 = {}
    for k21, k22 in pairs(a0.cachedInstances) do
        if k21:GetAttribute("Collective") == a1 then
            table.insert(v113, k21)
        end
    end

    a0.cachedCollectives[a1] = v113
    return v113
end

v10.getCollective = getCollective

local function getInstanceOrCollective(a0, a1)
    local v117 = {}
    local v118 = a0:getInstance(a1)
    if v118 then
        table.insert(v117, v118)
    end

    if #v117 == 0 then
        v117 = a0:getCollective(a1)
    end

    return v117
end

v10.getInstanceOrCollective = getInstanceOrCollective

local function getStateGroup(a0, a1)
    local v120 = a1 or a0.activeState
    local v121 = a0.appearance[v120]
    if not v121 then
        v121 = {}
        a0.appearance[v120] = v121
    end

    return v121
end

v10.getStateGroup = getStateGroup

local function refreshAppearance(a0, a1, a2) --[[ Upvalues: v7 (copy) ]]
    v7.refresh(a0, a1, a2)
    return a0
end

v10.refreshAppearance = refreshAppearance

local function refresh(a0)
    a0:refreshAppearance(a0.widget)
    a0.updateSize:Fire()
    return a0
end

v10.refresh = refresh

local function updateParent(a0) --[[ Upvalues: v10 (copy) ]]
    local v122 = v10.getIconByUID(a0.parentIconUID)
    if v122 then
        v122.updateSize:Fire()
    end
end

v10.updateParent = updateParent

local function setBehaviour(a0, a1, a2, a3, a4)
    local v123 = a1 .. "-" .. a2
    a0.customBehaviours[v123] = a3
    if a4 then
        local v124 = a0:getInstanceOrCollective(a1)
        for k23, k24 in pairs(v124) do
            a0:refreshAppearance(k24, a2)
        end
    end
end

v10.setBehaviour = setBehaviour

local function modifyTheme(a0, a1, a2) --[[ Upvalues: v7 (copy) ]]
    local v128 = v7.modify(a0, a1, a2)
    return a0, v128
end

v10.modifyTheme = modifyTheme

local function modifyChildTheme(a0, a1, a2) --[[ Upvalues: v10 (copy) ]]
    a0.childModifications = a1
    a0.childModificationsUID = a2
    for k25, k26 in pairs(a0.childIconsDict) do
        v10.getIconByUID(k25):modifyTheme(a1, a2)
    end

    a0.childThemeModified:Fire()
    return a0
end

v10.modifyChildTheme = modifyChildTheme

local function removeModification(a0, a1) --[[ Upvalues: v7 (copy) ]]
    v7.remove(a0, a1)
    return a0
end

v10.removeModification = removeModification

local function removeModificationWith(a0, a1, a2, a3) --[[ Upvalues: v7 (copy) ]]
    v7.removeWith(a0, a1, a2, a3)
    return a0
end

v10.removeModificationWith = removeModificationWith

local function setTheme(a0, a1) --[[ Upvalues: v7 (copy) ]]
    v7.set(a0, a1)
    return a0
end

v10.setTheme = setTheme

local function setEnabled(a0, a1)
    a0.isEnabled = a1
    a0.enabled = a0.isEnabled
    a0.widget.Visible = a1
    a0:updateParent()
    return a0
end

v10.setEnabled = setEnabled

local function select(a0, a1, a2)
    a0:setState("Selected", a1, a2)
    return a0
end

v10.select = select

local function deselect(a0, a1, a2)
    a0:setState("Deselected", a1, a2)
    return a0
end

v10.deselect = deselect

local function notify(a0, a1, a2) --[[ Upvalues: Elements (copy), v10 (copy) ]]
    if not a0.notice then
        local v132 = require(Elements.Notice)
        a0.notice = v132(a0, v10)
    end

    a0.noticeStarted:Fire(a1, a2)
    return a0
end

v10.notify = notify

local function clearNotices(a0)
    a0.endNotices:Fire()
    return a0
end

v10.clearNotices = clearNotices

local function disableOverlay(a0, a1)
    a0.overlayDisabled = a1
    return a0
end

v10.disableOverlay = disableOverlay
v10.disableStateOverlay = v10.disableOverlay

local function setImage(a0, a1, a2) --[[ Upvalues: ContentProvider (copy) ]]
    local t4 = {"IconImage", "Image", a1, a2}
    a0:modifyTheme(t4)
    task.spawn(function() --[[ Upvalues: a1 (copy), ContentProvider (upvalue) ]]
        local v133
        if tonumber(a1) then
            local v134 = ("rbxassetid://%*"):format(a1)
        else
            v133 = a1
        end

        local v135 = ContentProvider:GetAssetFetchStatus(v133)
        if v135 ~= Enum.AssetFetchStatus.Success then
            local t5 = {v133}
            pcall(ContentProvider.PreloadAsync, ContentProvider, t5)
        end

    end)
    return a0
end

v10.setImage = setImage

local function setLabel(a0, a1, a2)
    local t6 = {"IconLabel", "Text", a1, a2}
    a0:modifyTheme(t6)
    return a0
end

v10.setLabel = setLabel

local function setOrder(a0, a1, a2)
    local v136 = a1 * 100
    local t7 = {"IconSpot", "LayoutOrder", v136, a2}
    a0:modifyTheme(t7)
    t7 = {"Widget", "LayoutOrder", v136, a2}
    a0:modifyTheme(t7)
    return a0
end

v10.setOrder = setOrder

local function setCornerRadius(a0, a1, a2)
    local t8 = {"IconCorners", "CornerRadius", a1, a2}
    a0:modifyTheme(t8)
    return a0
end

v10.setCornerRadius = setCornerRadius

local function align(a0, a1, a2) --[[ Upvalues: v10 (copy) ]]
    local v137 = tostring(a1):lower()
    local v138
    if (v137 ~= "mid" and v137 or "center") ~= "left" and (v137 ~= "mid" and v137 or "center") ~= "center" and (v137 ~= "mid" and v137 or "center") ~= "right" then
        v138 = "left"
    end

    local v139
    if not (v138 == "center" and v10.container.TopbarCentered) then
        v139 = v10.container.TopbarStandard
    end

    local Holders = v139.Holders
    local v140 = string.upper(string.sub(v138, 1, 1))
    local v141 = v140 .. string.sub(v138, 2)
    if not a2 then
        a0.originalAlignment = v141
    end

    v138 = a0.joinedFrame
    v140 = Holders[v141]
    a0.screenGui = v139
    a0.alignmentHolder = v140
    if not a0.isDestroyed then
        a0.widget.Parent = v138 or v140
    end

    a0.alignment = v141
    a0.alignmentChanged:Fire(v141)
    v10.iconChanged:Fire(a0)
    return a0
end

v10.align = align
v10.setAlignment = v10.align

local function setLeft(a0)
    a0:setAlignment("Left")
    return a0
end

v10.setLeft = setLeft

local function setMid(a0)
    a0:setAlignment("Center")
    return a0
end

v10.setMid = setMid

local function setRight(a0)
    a0:setAlignment("Right")
    return a0
end

v10.setRight = setRight

local function setWidth(a0, a1, a2)
    local t9 = {"Widget", "DesiredWidth", a1, a2}
    a0:modifyTheme(t9)
    return a0
end

v10.setWidth = setWidth

local function setImageScale(a0, a1, a2)
    local t10 = {"IconImageScale", "Value", a1, a2}
    a0:modifyTheme(t10)
    return a0
end

v10.setImageScale = setImageScale

local function setImageRatio(a0, a1, a2)
    local t11 = {"IconImageRatio", "AspectRatio", a1, a2}
    a0:modifyTheme(t11)
    return a0
end

v10.setImageRatio = setImageRatio

local function setTextSize(a0, a1, a2)
    local t12 = {"IconLabel", "TextSize", a1, a2}
    a0:modifyTheme(t12)
    return a0
end

v10.setTextSize = setTextSize

local function setTextFont(a0, a1, a2, a3, a4)
    local v143 = a2 or Enum.FontWeight.Regular
    a2 = v143
    local v144 = a3 or Enum.FontStyle.Normal
    a3 = v144
    v144 = nil
    local v145 = typeof(a1)
    if v145 == "number" then
        v144 = Font.fromId(a1, a2, a3)
    else
        if v145 == "EnumItem" then
            v144 = Font.fromEnum(a1)
        else
            if v145 == "string" and not a1:match("rbxasset") then
                v144 = Font.fromName(a1, a2, a3)
            end
        end
    end

    local v146 = v144 or Font.new(a1, a2, a3)
    local v147 = {"IconLabel", "FontFace", v146, a4}
    a0:modifyTheme(v147)
    return a0
end

v10.setTextFont = setTextFont

local function setTextColor(a0, a1, a2)
    if a1 ~= nil and a1 ~= "" then
        if type(a1) == "userdata" then
            if typeof(a1) == "Color3" then
                -- jump to 35
            end
        end
    end

    if a1 ~= nil and a1 ~= "" then
        warn("setTextColor item must be a Color3 value! Changed the color to white.")
    end

    a1 = Color3.fromRGB(255, 255, 255)
    local v148 = {"IconLabel", "TextColor3", a1, a2}
    a0:modifyTheme(v148)
    return a0
end

v10.setTextColor = setTextColor

local function bindToggleItem(a0, a1)
    if not a1:IsA("GuiObject") and not a1:IsA("LayerCollector") then
        error("Toggle item must be a GuiObject or LayerCollector!")
    end

    a0.toggleItems[a1] = true
    a0:_updateSelectionInstances()
    return a0
end

v10.bindToggleItem = bindToggleItem

local function unbindToggleItem(a0, a1)
    a0.toggleItems[a1] = nil
    a0:_updateSelectionInstances()
    return a0
end

v10.unbindToggleItem = unbindToggleItem

local function _updateSelectionInstances(a0)
    for k27, k28 in pairs(a0.toggleItems) do
        local t13 = {}
        local v152 = k27:GetDescendants()
        for k29, k30 in pairs(v152) do
            if k30:IsA("TextButton") or k30:IsA("ImageButton") then
                if k30.Active then
                    table.insert(t13, k30)
                end
            end
        end

        a0.toggleItems[k27] = t13
    end
end

v10._updateSelectionInstances = _updateSelectionInstances

local function _setToggleItemsVisible(a0, a1, a2, a3)
    for k31, k32 in pairs(a0.toggleItems) do
        if not a3 or a3 == a0 or a3.toggleItems[k31] == nil then
            local v159 = "Visible"
            if k31:IsA("LayerCollector") then
                v159 = "Enabled"
            end

            k31[v159] = a1
        end
    end
end

v10._setToggleItemsVisible = _setToggleItemsVisible

local function bindEvent(a0, a1, a2)
    local v160 = a0[a1]
    local v161 = v160
    if v161 then
        v161 = false
        if typeof(v160) == "table" then
            v161 = v160.Connect
        end
    end

    assert(v161, "argument[1] must be a valid topbarplus icon event name!")
    assert(typeof(a2) == "function", "argument[2] must be a function!")
    a0.bindedEvents[a1] = v160:Connect(function(...) --[[ Upvalues: a2 (copy), a0 (copy) ]]
        a2(a0, ...)
    end)
    return a0
end

v10.bindEvent = bindEvent

local function unbindEvent(a0, a1)
    local v162 = a0.bindedEvents[a1]
    if v162 then
        v162:Disconnect()
        a0.bindedEvents[a1] = nil
    end

    return a0
end

v10.unbindEvent = unbindEvent

local function bindToggleKey(a0, a1)
    assert(typeof(a1) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
    a0.bindedToggleKeys[a1] = true
    a0.toggleKeyAdded:Fire(a1)
    a0:setCaption("_hotkey_")
    return a0
end

v10.bindToggleKey = bindToggleKey

local function unbindToggleKey(a0, a1)
    assert(typeof(a1) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
    a0.bindedToggleKeys[a1] = nil
    return a0
end

v10.unbindToggleKey = unbindToggleKey

local function call(a0, a1, ...)
    local v163 = table.pack(...)
    task.spawn(function() --[[ Upvalues: a1 (copy), a0 (copy), v163 (copy) ]]
        local v164 = table.unpack(v163)
        a1(a0, v164)
    end)
    return a0
end

v10.call = call

local function addToJanitor(a0, a1, a2, a3)
    a0.janitor:add(a1, a2, a3)
    return a0
end

v10.addToJanitor = addToJanitor

local function lock(a0)
    local v165 = a0:getInstance("ClickRegion")
    v165.Visible = false
    a0.locked = true
    return a0
end

v10.lock = lock

local function unlock(a0)
    local v166 = a0:getInstance("ClickRegion")
    v166.Visible = true
    a0.locked = false
    return a0
end

v10.unlock = unlock

local function debounce(a0, a1)
    a0:lock()
    task.wait(a1)
    a0:unlock()
    return a0
end

v10.debounce = debounce

local function autoDeselect(a0, a1)
    if a1 == nil then
        a1 = true
    end

    a0.deselectWhenOtherIconSelected = a1
    return a0
end

v10.autoDeselect = autoDeselect

local function oneClick(a0, a1)
    local singleClickJanitor = a0.singleClickJanitor
    singleClickJanitor:clean()
    if a1 or a1 == nil then
        local v167 = a0.selected:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:deselect("OneClick", a0)
        end)
        singleClickJanitor:add(v167)
    end

    a0.oneClickEnabled = true
    return a0
end

v10.oneClick = oneClick

local function setCaption(a0, a1) --[[ Upvalues: Elements (copy) ]]
    if a1 == "_hotkey_" and a0.captionText then
        return a0
    end

    local captionJanitor = a0.captionJanitor
    a0.captionJanitor:clean()
    if not a1 or a1 == "" then
        a0.caption = nil
        a0.captionText = nil
        return a0
    end

    local v168 = require(Elements.Caption)
    local v169 = v168(a0)
    local v170 = captionJanitor:add(v169)
    v170:SetAttribute("CaptionText", a1)
    a0.caption = v170
    a0.captionText = a1
    return a0
end

v10.setCaption = setCaption

local function setCaptionHint(a0, a1)
    assert(typeof(a1) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
    a0.fakeToggleKey = a1
    a0.fakeToggleKeyChanged:Fire(a1)
    a0:setCaption("_hotkey_")
    return a0
end

v10.setCaptionHint = setCaptionHint

local function leave(a0)
    a0.joinJanitor:clean()
    return a0
end

v10.leave = leave

local function joinMenu(a0, a1) --[[ Upvalues: v2 (copy) ]]
    local v171 = a1:getInstance("Menu")
    v2.joinFeature(a0, a1, a1.menuIcons, v171)
    a1.menuChildAdded:Fire(a0)
    return a0
end

v10.joinMenu = joinMenu

local function setMenu(a0, a1)
    a0.menuSet:Fire(a1)
    return a0
end

v10.setMenu = setMenu

local function setFixedMenu(a0, a1)
    a0:freezeMenu(a1)
    a0:setMenu(a1)
end

v10.setFixedMenu = setFixedMenu
v10.setFrozenMenu = v10.setFixedMenu

local function freezeMenu(a0)
    a0:select("FrozenMenu", a0)
    a0:bindEvent("deselected", function(a0) --[[ Upvalues: a0 (copy) ]]
        a0:select("FrozenMenu", a0)
    end)
    local v172 = {"IconSpot", "Visible", false}
    a0:modifyTheme(v172)
end

v10.freezeMenu = freezeMenu

local function joinDropdown(a0, a1) --[[ Upvalues: v2 (copy) ]]
    a1:getDropdown()
    local v173 = a1:getInstance("DropdownScroller")
    v2.joinFeature(a0, a1, a1.dropdownIcons, v173)
    a1.dropdownChildAdded:Fire(a0)
    return a0
end

v10.joinDropdown = joinDropdown

local function getDropdown(a0) --[[ Upvalues: Elements (copy) ]]
    local dropdown = a0.dropdown
    if not dropdown then
        local v174 = require(Elements.Dropdown)
        dropdown = v174(a0)
        a0.dropdown = dropdown
        a0:clipOutside(dropdown)
    end

    return dropdown
end

v10.getDropdown = getDropdown

local function setDropdown(a0, a1)
    a0:getDropdown()
    a0.dropdownSet:Fire(a1)
    return a0
end

v10.setDropdown = setDropdown

local function clipOutside(a0, a1) --[[ Upvalues: v2 (copy) ]]
    local v175 = v2.clipOutside(a0, a1)
    a0:refreshAppearance(a1)
    return a0, v175
end

v10.clipOutside = clipOutside

local function setIndicator(a0, a1) --[[ Upvalues: Elements (copy), v10 (copy) ]]
    if not a0.indicator then
        local v176 = require(Elements.Indicator)
        local v177 = v176(a0, v10)
        a0.indicator = a0.janitor:add(v177)
    end

    a0.indicatorSet:Fire(a1)
end

v10.setIndicator = setIndicator

local function convertLabelToNumberSpinner(a0, a1, a2)
    task.defer(function() --[[ Upvalues: a0 (copy), a1 (copy), a2 (copy) ]]
        local v178 = a0:getInstance("IconLabel")
        v178.Transparency = 1
        a1.Parent = v178.Parent
        a1.Size = UDim2.fromScale(1, 1)
        a1.AnchorPoint = Vector2.new(0.5, 0.5)
        a1.Position = UDim2.new(0.5, 0, 0.5, 0)
        a1.TextXAlignment = Enum.TextXAlignment.Center
        a1.ClipsDescendants = false
        local v179 = "TextStrokeTransparency"
        local v180 = {
            "FontFace",
            "BorderSizePixel",
            "BorderColor3",
            "Rotation",
            v179,
            "TextStrokeColor3",
            "TextStrokeTransparency",
            "TextColor3"
        }
        for k33, k34 in ipairs(v180) do
            a1[k34] = v178[k34]
            local v184 = v178:GetPropertyChangedSignal(k34)
            local v185 = v184:Connect(function() --[[ Upvalues: a1 (upvalue), k34 (copy), v178 (copy) ]]
                a1[k34] = v178[k34]
            end)
            a0:addToJanitor(v185)
        end

        local function getSpinnerSizeAndDigitCount() --[[ Upvalues: a1 (upvalue) ]]
            local v186 = 0
            local v187 = 0
            for k35, k36 in a1.Frame:GetChildren() do
                local v191 = string.lower(k36.Name)
                if v191 == "digit" then
                    v186 = v186 + k36.AbsoluteSize.X
                    v187 = v187 + 1
                else
                    if v191 == "prefix" or v191 == "suffix" or v191 == "comma" then
                        if k36.Text ~= "" then
                            v186 = v186 + k36.AbsoluteSize.X
                            v187 = v187 + 1
                        end
                    end
                end
            end

            return v186, v187
        end

        local function getLabelParentContainerXSize() --[[ Upvalues: v178 (copy), a1 (upvalue) ]]
            local Parent = v178.Parent
            local v193 = Parent and Parent.Parent
            if v193 == nil then
                return 0
            end

            if v193.IconImage.Visible == true then
                return a1.Frame.AbsoluteSize.X + v178.Parent.Parent.IconImage.AbsoluteSize.X
            end

            return v193.AbsoluteSize.X
        end

        local function getNumberSpinnerXSize() --[[ Upvalues: a1 (upvalue) ]]
            return a1.Frame.AbsoluteSize.X
        end

        local function adjustSize() --[[ Upvalues: getSpinnerSizeAndDigitCount (copy), a0 (upvalue), a1 (upvalue), v178 (copy) ]]
            local v194, v195 = getSpinnerSizeAndDigitCount()
            if v195 < 18 then
                a0:setLabel(a1.Value)
            end

            local X = a1.Frame.AbsoluteSize.X
            while v194 < X do
                if a0.isDestroyed == true then
                    break
                end

                task.wait(0.05)
                if 0 < v195 and v195 < 8 then
                    a1.TextSize = v178.TextSize
                    break
                end

                local v196 = a1
                v196.TextSize = v196.TextSize + 1
                X = a1
                X = X.Frame
                X = X.AbsoluteSize
                X = X.X
                local v197, v198 = getSpinnerSizeAndDigitCount()
                v194 = v197
                v195 = v198
            end

            local Parent2 = v178.Parent
            local v200 = Parent2 and Parent2.Parent
            if v200 == nil then
                X = 0
            else
                if v200.IconImage.Visible == true then
                    X = a1.Frame.AbsoluteSize.X + v178.Parent.Parent.IconImage.AbsoluteSize.X
                else
                    local X1 = v200.AbsoluteSize.X
                end
            end

            while X < v194 do
                if a0.isDestroyed == true then
                    break
                end

                task.wait(0.05)
                if v195 < 8 and 0 < v195 then
                    a1.TextSize = v178.TextSize
                    return
                end

                local v201 = a1
                v201.TextSize = v201.TextSize - 1
                local Parent4 = v178.Parent
                local v203 = Parent4 and Parent4.Parent
                if v203 == nil then
                    X = 0
                else
                    if v203.IconImage.Visible == true then
                        X = a1.Frame.AbsoluteSize.X + v178.Parent.Parent.IconImage.AbsoluteSize.X
                    else
                        X = v203.AbsoluteSize
                        X = X.X
                    end
                end

                local v204, v205 = getSpinnerSizeAndDigitCount()
                v194 = v204
                v195 = v205
            end
        end

        local v206 = a1.Frame.ChildAdded:Connect(adjustSize)
        a0:addToJanitor(v206)
        local v207 = a1.Frame.ChildRemoved:Connect(adjustSize)
        a0:addToJanitor(v207)
        local v208 = a0.iconAdded:Connect(function() --[[ Upvalues: adjustSize (copy) ]]
            task.wait(1)
            adjustSize()
        end)
        a0:addToJanitor(v208)
        a0:updateParent()
        a1.Name = "LabelSpinner"
        a1.Prefix = "$"
        a1.Commas = true
        a1.Decimals = 0
        a1.Duration = 0.25
        a1.Value = 10
        task.wait(0.2)
        if typeof(a2) == "function" then
            a2()
        end

    end)
    return a0
end

v10.convertLabelToNumberSpinner = convertLabelToNumberSpinner

local function destroy(a0) --[[ Upvalues: v10 (copy) ]]
    if a0.isDestroyed then
        return
    end

    a0:clearNotices()
    if a0.parentIconUID then
        a0:leave()
    end

    a0.isDestroyed = true
    a0.janitor:clean()
    v10.iconRemoved:Fire(a0)
end

v10.destroy = destroy
v10.Destroy = v10.destroy
return v10
