
local v1 = require
local v2 = assert(_G.__ModernFixture, "Initialize fixture")
local v3 = game

local function GetService(a0, a1) --[[ Upvalues: v2 (copy), v3 (copy) ]]
    local v6 = v2[a1] or v3:GetService(a1)
    return v6
end

local v7 = {GetService = GetService}

local function require(a0) --[[ Upvalues: v1 (copy) ]]
    if type(a0) == "table" then
        return a0
    end

    local v8 = v1(a0)
    return v8
end

local ReplicatedStorage = v7:GetService("ReplicatedStorage")
local UserInputService = v7:GetService("UserInputService")
local ContextActionService = v7:GetService("ContextActionService")
local GuiService = v7:GetService("GuiService")
local GamepadService = v7:GetService("GamepadService")
local ModernBuild = ReplicatedStorage.Modules.ModernBuild
if type(ModernBuild) == "table" then
    v7 = ModernBuild
else
    v7 = v1(ModernBuild)
end

v7 = v7.UI
local PaintController = ReplicatedStorage.Modules.PaintController
if type(PaintController) == "table" then
    ModernBuild = PaintController
else
    ModernBuild = v1(PaintController)
end

local BaseObjectsLib = ReplicatedStorage.Modules.BaseObjectsLib
if type(BaseObjectsLib) == "table" then
    PaintController = BaseObjectsLib
else
    PaintController = v1(BaseObjectsLib)
end

BaseObjectsLib = {}
BaseObjectsLib.__index = BaseObjectsLib
local v9 = Enum.ContextActionPriority.High.Value + 110
local v10 = {0.1, 0.25, 0.5, 1, 2, 5}
local v11 = {5, 15, 30, 45, 90}
local v12 = {"Y", "X", "Z"}
local v13 = setmetatable({}, {__mode = "k"})
local v14 = {
    Enum.KeyCode.ButtonA,
    Enum.KeyCode.ButtonB,
    Enum.KeyCode.ButtonX,
    Enum.KeyCode.ButtonY,
    Enum.KeyCode.ButtonL1,
    Enum.KeyCode.ButtonR1,
    Enum.KeyCode.ButtonL2,
    Enum.KeyCode.ButtonR2,
    Enum.KeyCode.DPadLeft,
    Enum.KeyCode.DPadRight,
    Enum.KeyCode.DPadUp,
    Enum.KeyCode.DPadDown,
    Enum.KeyCode.ButtonL3,
    Enum.KeyCode.ButtonR3
}
local v15 = {
    "EditObject",
    "EditingExistingObject",
    "EditExistingOriginalTransparency",
    "ObjectType",
    "BuildObjectPosition",
    "BuildObjectRotation",
    "BuildLastValidPosition",
    "BuildLastValidRotation",
    "BuildPlacementValid",
    "BuildInvalidReason",
    "BuildTransformDirty",
    "CurrentFrame",
    "EditObjectRotate",
    "EditObjectFlip",
    "EditObjectFlip2",
    "breathingNum"
}

local function preferredGamepad() --[[ Upvalues: UserInputService (copy) ]]
    local GamepadEnabled = UserInputService.GamepadEnabled
    if GamepadEnabled then
        GamepadEnabled = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
    end

    return GamepadEnabled
end

local function releaseCursorActivation() --[[ Upvalues: ContextActionService (copy) ]]
    pcall(function() --[[ Upvalues: ContextActionService (upvalue) ]]
        ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
        ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
    end)
end

local function isDirection(a0)
    local v16 = true
    if a0 ~= Enum.KeyCode.DPadLeft then
        v16 = true
        if a0 ~= Enum.KeyCode.DPadRight then
            v16 = true
            if a0 ~= Enum.KeyCode.DPadUp then
                v16 = a0 == Enum.KeyCode.DPadDown
            end
        end
    end

    return v16
end

local function deadzone(a0)
    local Magnitude = a0.Magnitude
    if Magnitude <= 0.15 then
        return Vector2.zero
    end

    return a0.Unit * math.min(1, (Magnitude - 0.15) / 0.85)
end

local function IsGamepad(a0)
    local v17 = false
    if a0.Active == true then
        v17 = not a0.Destroyed
    end

    return v17
end

BaseObjectsLib.IsGamepad = IsGamepad

local function ExternalBlocked(a0) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    local Client = a0.Client
    local MenuIsOpen = GuiService.MenuIsOpen
    if not MenuIsOpen then
        MenuIsOpen = true
        if a0.WindowUnfocused ~= true then
            MenuIsOpen = true
            if UserInputService:GetFocusedTextBox() == nil then
                MenuIsOpen = true
                if Client.DeleteAllConfirmOpen ~= true then
                    MenuIsOpen = true
                    if Client.PaintResetConfirmOpen ~= true then
                        MenuIsOpen = true
                        if Client.ColorPickerHUD == nil then
                            MenuIsOpen = a0.ExternalMenu ~= nil
                        end
                    end
                end
            end
        end
    end

    return MenuIsOpen
end

BaseObjectsLib.ExternalBlocked = ExternalBlocked

local function BlocksWorld(a0)
    if a0:IsGamepad() then
        local MenuOpen = a0.UI.MenuOpen
        if not MenuOpen then
            local v18 = a0:ExternalBlocked()
            if v18 then
                -- jump to 16
            end

            -- branch continues at 16
        end
    end

    local v19 = false
    return v19
end

BaseObjectsLib.BlocksWorld = BlocksWorld

local function GetPad(a0) --[[ Upvalues: UserInputService (copy) ]]
    return UserInputService:GetConnectedGamepads()[1]
end

BaseObjectsLib.GetPad = GetPad

local function CancelHeldInputs(a0) --[[ Upvalues: v14 (copy), UserInputService (copy) ]]
    a0.DeleteStarted = nil
    a0.DeleteTarget = nil
    a0.DeleteProgress = 0
    a0.RepeatDirection = nil
    a0.RepeatAt = nil
    a0:StopGridAdjustment(false)
    a0:StopQuickRotation(false)
    local RequireRelease = a0.RequireRelease
    if not RequireRelease then
        RequireRelease = {}
    end

    a0.RequireRelease = RequireRelease
    local v20 = a0:GetPad()
    if v20 then
        for k1, k2 in ipairs(v14) do
            if UserInputService:IsGamepadButtonDown(v20, k2) then
                a0.RequireRelease[k2] = true
            else
                a0.RequireRelease[k2] = nil
                a0.HeldKeys[k2] = nil
            end
        end

        local v25 = UserInputService:GetGamepadState(v20)
        for k3, k4 in ipairs(v25) do
            if k4.KeyCode == Enum.KeyCode.Thumbstick1 or k4.KeyCode == Enum.KeyCode.Thumbstick2 then
                if 0.15 < Vector2.new(k4.Position.X, k4.Position.Y).Magnitude then
                    a0.RequireRelease[k4.KeyCode] = true
                else
                    a0.RequireRelease[k4.KeyCode] = nil
                end
            end
        end

        return
    end

    local HeldKeys = a0.HeldKeys
    if not HeldKeys then
        HeldKeys = {}
    end

    for k5 in pairs(HeldKeys) do
        a0.RequireRelease[k5] = true
    end
end

BaseObjectsLib.CancelHeldInputs = CancelHeldInputs

local function SyncOwnership(a0) --[[ Upvalues: GuiService (copy), ContextActionService (copy), GamepadService (copy), UserInputService (copy) ]]
    if not a0:IsGamepad() then
        return
    end

    local v32 = a0:BlocksWorld()
    if v32 ~= a0.WasBlocked then
        a0:CancelHeldInputs()
        a0.WasBlocked = v32
    end

    if a0.UI.SetObscured then
        local v33 = a0:ExternalBlocked()
        a0.UI:SetObscured(v33)
    end

    if GuiService.MenuIsOpen then
        return
    end

    a0.Client.BuildGamepadNavigation = false
    pcall(function() --[[ Upvalues: ContextActionService (upvalue) ]]
        ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
        ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
    end)
    if GamepadService.GamepadCursorEnabled then
        GamepadService:DisableGamepadCursor()
    end

    if not v32 or a0.UI.MenuKind == "Precision" then
        GuiService.SelectedObject = nil
    end

    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    UserInputService.MouseIconEnabled = false
    a0.Client.Player:Move(Vector3.new(0, 0, 0), false)
    if a0.Client.Humanoid then
        a0.Client.Humanoid.Jump = false
    end
end

BaseObjectsLib.SyncOwnership = SyncOwnership

local function Center(a0)
    return workspace.CurrentCamera.ViewportSize / 2
end

BaseObjectsLib.Center = Center

local function NotifySelected(a0, a1, a2)
    if not a0:IsGamepad() then
        return
    end

    a0.Client:SetDeletingObjects(false)
    a0.Following = true
    a0.FollowCamera = nil
    a0.GrabOffset = Vector3.new(0, 0, 0)
    a0.Status = nil
    if not a0.CyclingRecent then
        local ModernBuildRecents = a0.Client.ModernBuildRecents
        if not ModernBuildRecents then
            ModernBuildRecents = {}
        end

        a0.Client.ModernBuildRecents = ModernBuildRecents
        for i1 = #ModernBuildRecents, 1, -1 do
            if ModernBuildRecents[i1] == a1 then
                table.remove(ModernBuildRecents, i1)
            end
        end

        table.insert(ModernBuildRecents, 1, a1)
        while 8 < #ModernBuildRecents do
            table.remove(ModernBuildRecents)
        end

        a0.RecentIndex = 1
    end

    a0.LastObjectType = a2
end

BaseObjectsLib.NotifySelected = NotifySelected

local function SetFollowing(a0, a1, a2)
    local v36 = false
    if a1 == true then
        v36 = a0.Client.EditObject ~= nil
    end

    a0.Following = v36
    a0.Client:EndDirectBuildDrag()
    if not a0.Following then
        return
    end

    local v37 = a0:Center()
    local v38 = a0.Client:BuildPointerHitsObject(v37)
    if a2 and v38 or nil then
        a0.GrabOffset = a0.Client.EditObject:GetBoundingBox():PointToObjectSpace((a2 and v38 or nil).Position)
        a0.FollowCamera = workspace.CurrentCamera.CFrame
        return
    end

    a0.GrabOffset = Vector3.new(0, 0, 0)
    a0.FollowCamera = nil
end

BaseObjectsLib.SetFollowing = SetFollowing

local function ChooseItem(a0, a1, a2) --[[ Upvalues: ModernBuild (copy) ]]
    if not a0:IsGamepad() then
        return
    end

    if a0.Client.Painting then
        ModernBuild.Close(a0.Client)
    end

    a0:CloseMenu()
    a0.Client:SetDeletingObjects(false)
    a0.Client:SelectEditObject(a1, a2)
    a0:RefreshPresentation()
end

BaseObjectsLib.ChooseItem = ChooseItem

local function CycleRecent(a0, a1) --[[ Upvalues: PaintController (copy), ReplicatedStorage (copy) ]]
    local ModernBuildRecents1 = a0.Client.ModernBuildRecents
    if not ModernBuildRecents1 then
        ModernBuildRecents1 = {}
    end

    if #ModernBuildRecents1 == 0 then
        a0:OpenCatalogue()
        return
    end

    local v39 = a0.RecentIndex or 1
    for i2 = 1, #ModernBuildRecents1 do
        local v42 = v39 - 1 + a1
        v39 = v42 % #ModernBuildRecents1 + 1
        local v43 = ModernBuildRecents1[v39]
        v42 = PaintController[v43]
        if v42 then
            if ReplicatedStorage.BaseObjects:FindFirstChild(v43) then
                if v42.Unlock then
                    local UnlockedObjects = a0.Client.Data.UnlockedObjects
                    if not UnlockedObjects then
                        UnlockedObjects = {}
                    end

                    if not UnlockedObjects[v43] then
                        -- jump to 70
                    end
                end

                a0.CyclingRecent = true
                a0:ChooseItem(v43, v42.Type)
                a0.CyclingRecent = nil
                a0.RecentIndex = v39
                return
            end
        end
    end
end

BaseObjectsLib.CycleRecent = CycleRecent

local function CloseMenu(a0) --[[ Upvalues: GuiService (copy) ]]
    a0:CancelHeldInputs()
    a0.UI:CloseMenu()
    a0.Precision = false
    a0.StepsMode = nil
    a0.StepsReturn = nil
    GuiService.SelectedObject = nil
    a0:SyncOwnership()
end

BaseObjectsLib.CloseMenu = CloseMenu

local function OpenCatalogue(a0)
    if not a0:IsGamepad() then
        return
    end

    a0:CancelHeldInputs()
    a0.Precision = false
    a0.UI:OpenCatalogue()
    a0:SyncOwnership()
end

BaseObjectsLib.OpenCatalogue = OpenCatalogue

local function OpenOptions(a0)
    a0:CancelHeldInputs()
    a0.Precision = false
    a0.UI:OpenOptions(a0.Client.Painting == true)
    a0:SyncOwnership()
end

BaseObjectsLib.OpenOptions = OpenOptions

local function OpenPrecision(a0)
    if not a0.Client.EditObject or a0.Client.Painting or a0:ExternalBlocked() then
        a0.Status = "Choose an object to adjust"
        return
    end

    a0:CancelHeldInputs()
    a0:SetFollowing(false)
    a0.Precision = true
    local v44 = a0:PresentationState()
    a0.UI:OpenPrecision(v44)
    a0:SyncOwnership()
end

BaseObjectsLib.OpenPrecision = OpenPrecision

local function SetPrecisionMode(a0, a1)
    if not a0.Precision then
        return
    end

    if a1 ~= "Move" then
        if a1 ~= "Rotate" then
            return
        end
    end

    a0.RepeatDirection = nil
    a0.RepeatAt = nil
    a0.Client:SetBuildTransformMode(a1)
    a0:RefreshPresentation()
end

BaseObjectsLib.SetPrecisionMode = SetPrecisionMode

local function SetAxis(a0, a1)
    if a1 ~= "X" and a1 ~= "Y" and a1 ~= "Z" then
        return
    end

    a0.RepeatDirection = nil
    a0.RepeatAt = nil
    a0.Axis = a1
    a0:RefreshPresentation()
end

BaseObjectsLib.SetAxis = SetAxis

local function Nudge(a0, a1)
    if not a0.Precision or a0.UI.MenuKind ~= "Precision" or a0:ExternalBlocked() then
        return
    end

    local Axis = a0.Axis
    local v45
    if a1 < 0 then
        v45 = -1
    else
        v45 = 1
    end

    a0.Client:NudgeBuildObject(Axis, v45)
    a0.Client:RefreshBuildValidation(true)
    a0.Status = nil
    a0:RefreshPresentation()
end

BaseObjectsLib.Nudge = Nudge

local function OpenSteps(a0, a1)
    if not a0:IsGamepad() or not a0:QuickAdjustAvailable() or a0:ExternalBlocked() then
        return
    end

    local Precision = a0.Precision
    if Precision then
        Precision = a0.UI.MenuKind == "Precision"
    end

    if not Precision and not (a0.UI.MenuKind == "Options") then
        return
    end

    local v48 = a1 or a0.Client.BuildTransformMode or "Move"
    a1 = v48
    if a1 ~= "Move" and a1 ~= "Rotate" then
        return
    end

    a0:CancelHeldInputs()
    a0.StepsMode = a1
    local v49
    if Precision then
        v49 = "Precision"
    else
        v49 = "Options"
    end

    a0.StepsReturn = v49
    local v50
    if not (a1 == "Rotate" and a0.Client.BuildRotateStep) then
        v50 = a0.Client.BuildMoveStep
    end

    a0.UI:OpenSteps(a1, v50)
    a0:SyncOwnership()
end

BaseObjectsLib.OpenSteps = OpenSteps

local function ReturnFromSteps(a0)
    a0.StepsMode = nil
    a0.StepsReturn = nil
    if a0.StepsReturn == "Options" then
        a0:OpenOptions()
        return
    end

    a0:OpenPrecision()
end

BaseObjectsLib.ReturnFromSteps = ReturnFromSteps

local function SetStep(a0, a1) --[[ Upvalues: v11 (copy), v10 (copy) ]]
    if not a0:IsGamepad() or a0.UI.MenuKind ~= "Steps" or a0:ExternalBlocked() then
        return
    end

    local v51 = a0.StepsMode == "Rotate"
    if not table.find(v51 and v11 or v10, a1) then
        return
    end

    if v51 then
        a0.Client.BuildRotateStep = a1
    else
        a0.Client.BuildMoveStep = a1
        a0.Client:RebuildBuildGrid()
    end

    a0:ReturnFromSteps()
end

BaseObjectsLib.SetStep = SetStep

local function QuickAdjustAvailable(a0)
    local v54 = not a0.Client.Painting
    if v54 then
        v54 = false
        if a0.Client.BuildModeKind ~= "Paint" then
            v54 = not a0.Client.DeletingObjects
        end
    end

    return v54
end

BaseObjectsLib.QuickAdjustAvailable = QuickAdjustAvailable

local function StopGridAdjustment(a0, a1)
    local GridAdjustKey = a0.GridAdjustKey
    if a1 and GridAdjustKey and a0.HeldKeys[GridAdjustKey] then
        a0.RequireRelease[GridAdjustKey] = true
    end

    a0.GridAdjustDirection = nil
    a0.GridAdjustKey = nil
    a0.GridRepeatAt = nil
end

BaseObjectsLib.StopGridAdjustment = StopGridAdjustment

local function StopQuickRotation(a0, a1)
    local QuickRotateKey = a0.QuickRotateKey
    if a1 and QuickRotateKey and a0.HeldKeys[QuickRotateKey] then
        a0.RequireRelease[QuickRotateKey] = true
    end

    a0.QuickRotateDirection = nil
    a0.QuickRotateKey = nil
    a0.QuickRotateRepeatAt = nil
end

BaseObjectsLib.StopQuickRotation = StopQuickRotation

local function CycleQuickRotateAxis(a0) --[[ Upvalues: v12 (copy) ]]
    if not a0:IsGamepad() or not a0:QuickAdjustAvailable() or a0:ExternalBlocked() or a0.Precision or a0.UI.MenuOpen then
        return
    end

    a0:StopQuickRotation(true)
    a0.QuickRotateAxis = v12[(table.find(v12, a0.QuickRotateAxis) or 1) % #v12 + 1]
    a0.QuickRotateAxisNoticeUntil = os.clock() + 1.6
    a0.Status = nil
    a0:RefreshPresentation()
end

BaseObjectsLib.CycleQuickRotateAxis = CycleQuickRotateAxis

local function QuickRotate(a0, a1, a2)
    local v55 = false
    if a2 == true then
        v55 = a0.Precision
        if v55 then
            v55 = a0.UI.MenuKind == "Precision"
        end
    end

    if not a0:IsGamepad() then
        return false
    end

    if not a0:QuickAdjustAvailable() then
        return false
    end

    if a0:ExternalBlocked() then
        return false
    end

    if a0.Precision or a0.UI.MenuOpen then
        if not v55 then
            return false
        end
    end

    local Client1 = a0.Client
    if not (Client1.EditObject and Client1.BuildObjectPosition) then
        a0.Status = "Choose an object to rotate"
        return false
    end

    if v55 then
        a0.RepeatDirection = nil
        a0.RepeatAt = nil
        local Axis1 = a0.Axis
        local v56
        if a1 < 0 then
            v56 = -1
        else
            v56 = 1
        end

        Client1:RotateBuildObjectStep(Axis1, v56)
        Client1:RefreshBuildValidation(true)
        a0.Status = nil
        a0:RefreshPresentation()
        return true
    end

    v55 = Client1.BuildObjectRotation or Vector3.new(-90, 90, 0)
    local v57 = Client1.BuildRotateStep or 15
    local v58
    if a1 < 0 then
        v58 = -1
    else
        v58 = 1
    end

    local v59 = v57 * v58
    v57 = a0.QuickRotateAxis or "Y"
    local v60 = math.rad(v59)
    local v67 = CFrame.Angles(v57 == "X" and v60 or 0, v57 == "Y" and v60 or 0, v57 == "Z" and v60 or 0)
    local v68 = math.rad(v55.X)
    local v69 = math.rad(v55.Y)
    local v70, v71, v72 = (v67 * CFrame.Angles(v68, v69, math.rad(v55.Z))):ToEulerAnglesXYZ()
    local v73 = math.deg(v70)
    local v74 = math.deg(v71)
    Client1.BuildObjectRotation = Vector3.new(v73, v74, math.deg(v72))
    Client1:ClampBuildObjectToBounds()
    Client1.BuildTransformDirty = true
    Client1:RefreshBuildValidation(true)
    a0.Status = nil
    a0:RefreshPresentation()
    return true
end

BaseObjectsLib.QuickRotate = QuickRotate

local function AdjustGrid(a0, a1)
    if not a0:IsGamepad() then
        return false
    end

    if not a0:QuickAdjustAvailable() then
        return false
    end

    if a0:ExternalBlocked() then
        return false
    end

    if a0.UI.MenuOpen then
        if a0.UI.MenuKind ~= "Precision" then
            return false
        end
    end

    local Client2 = a0.Client
    if type(Client2.AdjustBuildGridHeight) ~= "function" then
        return false
    end

    if Client2.BuildGridEnabled == false then
        Client2.BuildGridEnabled = true
        if type(Client2.RebuildBuildGrid) == "function" then
            Client2:RebuildBuildGrid()
        end
    end

    Client2:AdjustBuildGridHeight(a1)
    a0.Status = nil
    return true
end

BaseObjectsLib.AdjustGrid = AdjustGrid

local function CycleStep(a0, a1) --[[ Upvalues: v11 (copy), v10 (copy) ]]
    if not a0:IsGamepad() then
        return
    end

    if not a0:QuickAdjustAvailable() then
        return
    end

    if a0:ExternalBlocked() then
        return
    end

    if a0.UI.MenuOpen then
        if a0.UI.MenuKind ~= "Precision" then
            return
        end
    end

    local Client3 = a0.Client
    local v75 = a1 == "Rotate"
    local v78
    if v75 then
        v78 = Client3.BuildRotateStep
        if not v78 then
            v78 = 15
            -- branch continues at 46
        end
    else
        v78 = Client3.BuildMoveStep or 0.5
    end

    local v79 = table.find(v75 and v11 or v10, v78) or 0
    local v80 = (v75 and v11 or v10)[v79 % #(v75 and v11 or v10) + 1]
    if v75 then
        Client3.BuildRotateStep = v80
    else
        Client3.BuildMoveStep = v80
        if type(Client3.RebuildBuildGrid) == "function" then
            Client3:RebuildBuildGrid()
        end
    end

    a0.Status = nil
    a0:RefreshPresentation()
end

BaseObjectsLib.CycleStep = CycleStep

local function OpenPalette(a0)
    if not a0:IsGamepad() then
        return
    end

    if not a0.Client.Painting then
        a0.Client:OpenPaintFrames()
    end

    if not a0.Client.Painting then
        return
    end

    a0:CancelHeldInputs()
    a0.Precision = false
    local BackgroundColor3 = a0.Client.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3
    local ModernPaintColors = a0.Client.ModernPaintColors
    if not ModernPaintColors then
        ModernPaintColors = {}
    end

    a0.UI:OpenPalette(BackgroundColor3, ModernPaintColors)
    a0:SyncOwnership()
end

BaseObjectsLib.OpenPalette = OpenPalette

local function ChooseColor(a0, a1) --[[ Upvalues: ModernBuild (copy) ]]
    if not (typeof(a1) == "Color3" and a0.Client.Painting) then
        return
    end

    ModernBuild.ControllerSetColor(a0.Client, a1)
    local ModernPaintColors1 = a0.Client.ModernPaintColors
    if not ModernPaintColors1 then
        ModernPaintColors1 = {}
    end

    a0.Client.ModernPaintColors = ModernPaintColors1
    for i3 = #ModernPaintColors1, 1, -1 do
        if ModernPaintColors1[i3] == a1 then
            table.remove(ModernPaintColors1, i3)
        end
    end

    table.insert(ModernPaintColors1, 1, a1)
    while 8 < #ModernPaintColors1 do
        table.remove(ModernPaintColors1)
    end

    a0:RefreshPresentation()
end

BaseObjectsLib.ChooseColor = ChooseColor

local function SuspendPreview(a0) --[[ Upvalues: v15 (copy) ]]
    local Client4 = a0.Client
    if not (a0:IsGamepad() and Client4.EditObject) then
        return false
    end

    a0:SetFollowing(false)
    a0:CloseMenu()
    local v83 = {}
    for k6, k7 in ipairs(v15) do
        v83[k7] = Client4[k7]
        Client4[k7] = nil
    end

    v83.EditObject.Parent = nil
    local EditExistingOriginalTransparency = v83.EditExistingOriginalTransparency
    if not EditExistingOriginalTransparency then
        EditExistingOriginalTransparency = {}
    end

    for k8, k9 in pairs(EditExistingOriginalTransparency) do
        if k8.Parent then
            k8.LocalTransparencyModifier = k9
        end
    end

    Client4.Mouse.TargetFilter = nil
    Client4:HideBuildGizmos()
    a0.SuspendedPreview = v83
    return true
end

BaseObjectsLib.SuspendPreview = SuspendPreview

local function ResumePreview(a0) --[[ Upvalues: v15 (copy) ]]
    local SuspendedPreview = a0.SuspendedPreview
    local Client5 = a0.Client
    if not SuspendedPreview or Client5.BuildModeKind == "Paint" then
        return
    end

    a0.SuspendedPreview = nil
    if Client5.EditObject then
        Client5:DeleteEditObject()
    end

    if SuspendedPreview.EditingExistingObject and not SuspendedPreview.EditingExistingObject.Parent then
        SuspendedPreview.EditObject:Destroy()
        return
    end

    if SuspendedPreview.EditingExistingObject then

        local function copyColors(a0, a1) --[[ Upvalues: copyColors (copy) ]]
            if a0:IsA("BasePart") and a1:IsA("BasePart") then
                a1.Color = a0.Color
            end

            local v90 = a1:GetChildren()
            local v91 = {}
            local v92 = a0:GetChildren()
            for k10, k11 in ipairs(v92) do
                for k12, k13 in ipairs(v90) do
                    if not v91[k12] and k13.Name == k11.Name and k13.ClassName == k11.ClassName then
                        v91[k12] = true
                        copyColors(k11, k13)
                        break
                    end
                end
            end
        end

        copyColors(SuspendedPreview.EditingExistingObject, SuspendedPreview.EditObject)
    end

    for k14, k15 in ipairs(v15) do
        Client5[k15] = SuspendedPreview[k15]
    end

    local EditExistingOriginalTransparency1 = Client5.EditExistingOriginalTransparency
    if not EditExistingOriginalTransparency1 then
        EditExistingOriginalTransparency1 = {}
    end

    for k16 in pairs(EditExistingOriginalTransparency1) do
        if k16.Parent then
            k16.LocalTransparencyModifier = 1
        end
    end

    Client5.EditObject.Parent = workspace.CurrentCamera
    local v107 = Client5:GetBuildObjectCFrame()
    Client5.EditObject:PivotTo(v107)
    Client5.Mouse.TargetFilter = Client5.EditObject
    a0.Following = false
    a0.Status = "Object restored where you left it"
    local v108 = Client5:GetBuildObjectCFrame()
    Client5:UpdateBuildGizmo(v108)
end

BaseObjectsLib.ResumePreview = ResumePreview

local function Exit(a0)
    if a0.Client.EditingBase then
        a0.Client:StopEditStorage()
        return
    end

    if a0.Client.Painting then
        a0.Client:ClosePaintFrames()
        return
    end

    a0.Client:EndBuildMode()
end

BaseObjectsLib.Exit = Exit

local function OpenLegacyPanel(a0, a1) --[[ Upvalues: ModernBuild (copy), ContextActionService (copy), GuiService (copy), GamepadService (copy), UserInputService (copy), v9 (copy) ]]
    local Client6 = a0.Client
    local t1 = {
        Base = Client6.StorageBase,
        CameraPosition = Client6.BuildCameraPosition,
        CameraYaw = Client6.BuildCameraYaw,
        CameraPitch = Client6.BuildCameraPitch,
        Focus = Client6.BuildFocus,
        Distance = Client6.BuildDistance
    }
    if Client6.Painting then
        ModernBuild.Close(Client6)
    end

    if a0:SuspendPreview() then
        t1.Preview = a0.SuspendedPreview
        t1.Preview.CurrentFrame = nil
        a0.SuspendedPreview = nil
    end

    local function discardPreview() --[[ Upvalues: t1 (copy) ]]
        local Preview = t1.Preview
        if not Preview then
            return
        end

        t1.Preview = nil
        if Preview.EditObject then
            Preview.EditObject:Destroy()
        end
    end

    a0:Exit()
    if Client6.ModernReturnCleanup then
        Client6.ModernReturnCleanup(false)
    end

    if a1 == "Customize" then
        Client6:OpenCustomizeBase()
    else
        Client6:OpenBaseSlots()
    end

    local v109
    if not (a1 == "Customize" and Client6.HUD.BaseCustomization) then
        v109 = Client6.HUD.BaseSlots
    end

    if not (v109 and v109.Visible) then
        local Preview1 = t1.Preview
        if not Preview1 then
            return
        end

        t1.Preview = nil
        if Preview1.EditObject then
            Preview1.EditObject:Destroy()
        end

        return
    end

    Client6.MainContext.Enabled = false
    local v110 = {}
    local v111 = false
    local Enabled = Client6.MainContext.Enabled

    local function cleanup(a0) --[[ Upvalues: v111 (ref), v110 (copy), ContextActionService (upvalue), Client6 (copy), Enabled (copy), GuiService (upvalue), GamepadService (upvalue), t1 (copy) ]]
        if v111 then
            return
        end

        v111 = true
        for k17, k18 in ipairs(v110) do
            k18:Disconnect()
        end

        ContextActionService:UnbindAction("ModernBuildExternalBack")
        Client6.ModernReturnCleanup = nil
        Client6.MainContext.Enabled = Enabled
        GuiService.SelectedObject = nil
        if GamepadService.GamepadCursorEnabled then
            GamepadService:DisableGamepadCursor()
        end

        task.defer(function() --[[ Upvalues: a0 (copy), Client6 (upvalue), t1 (upvalue) ]]
            if a0 then
                if Client6.Player:GetAttribute("InBase") then
                    if Client6.Humanoid then
                        if 0 < Client6.Humanoid.Health then
                            if not Client6.EditingBase then
                                if not Client6.CustomizingBase then
                                    if not Client6.InBaseSlots then
                                        if not Client6.Painting then
                                            Client6:EditStorage()
                                            local ModernController8 = Client6.ModernController
                                            if ModernController8 and Client6.StorageBase == t1.Base then
                                                ModernController8:CloseMenu()
                                                ModernController8.SuspendedPreview = t1.Preview
                                                t1.Preview = nil
                                                ModernController8:ResumePreview()
                                                Client6.BuildCameraPosition = t1.CameraPosition
                                                Client6.BuildCameraYaw = t1.CameraYaw
                                                Client6.BuildCameraPitch = t1.CameraPitch
                                                Client6.BuildFocus = t1.Focus
                                                Client6.BuildDistance = t1.Distance
                                                Client6:UpdateBuildCameraCFrame()
                                                ModernController8:RefreshPresentation()
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            local Preview2 = t1.Preview
            if not Preview2 then
                return
            end

            t1.Preview = nil
            if Preview2.EditObject then
                Preview2.EditObject:Destroy()
            end

        end)
    end

    Client6.ModernReturnCleanup = cleanup
    local v115 = v109:GetPropertyChangedSignal("Visible")
    local v116 = v115:Connect(function() --[[ Upvalues: v109 (copy), cleanup (copy) ]]
        if not v109.Visible then
            cleanup(true)
        end

    end)
    table.insert(v110, v116)
    local v117 = Client6.Player.CharacterRemoving:Connect(function() --[[ Upvalues: cleanup (copy) ]]
        cleanup(false)
    end)
    table.insert(v110, v117)
    ContextActionService:BindActionAtPriority("ModernBuildExternalBack", function(a0, a1) --[[ Upvalues: GuiService (upvalue), UserInputService (upvalue), a1 (copy), Client6 (copy) ]]
        if GuiService.MenuIsOpen then
            return Enum.ContextActionResult.Pass
        end

        if a1 == Enum.UserInputState.Begin then
            if UserInputService:GetFocusedTextBox() then
                UserInputService:GetFocusedTextBox():ReleaseFocus()
            else
                if a1 == "Customize" then
                    Client6:CloseCustomizeBase()
                else
                    if Client6.BaseSlotConfirmAction then
                        Client6:CloseBaseSlotConfirmation()
                    else
                        Client6:CloseBaseSlots()
                    end
                end
            end
        end

        return Enum.ContextActionResult.Sink
    end, false, v9, Enum.KeyCode.ButtonB)
    local v118 = v109:FindFirstChildWhichIsA("GuiButton", true)
    GamepadService:EnableGamepadCursor(v118)
end

BaseObjectsLib.OpenLegacyPanel = OpenLegacyPanel

local function Option(a0, a1) --[[ Upvalues: ModernBuild (copy) ]]
    local Client7 = a0.Client
    if a1 == "Catalogue" then
        a0:OpenCatalogue()
        return
    end

    if a1 == "ColourPicker" then
        a0:OpenPalette()
        return
    end

    if a1 == "MoveSteps" or a1 == "RotateSteps" then
        local v119
        if a1 == "RotateSteps" then
            v119 = "Rotate"
        else
            v119 = "Move"
        end

        a0:OpenSteps(v119)
        return
    end

    a0:CloseMenu()
    if a1 == "Resume" then
        return
    end

    if a1 == "Exit" then
        a0:Exit()
        return
    end

    if a1 == "SwitchClassic" then
        if Client7.Painting then
            ModernBuild.Close(Client7)
        end

        Client7:SetBuildSystem("Classic", true)
        return
    end

    if a1 == "Customize" or a1 == "SaveSlots" then
        a0:OpenLegacyPanel(a1)
        return
    end

    if a1 == "Brush" or a1 == "Bucket" or a1 == "Dropper" then
        if not Client7.Painting then
            Client7:OpenPaintFrames()
        end

        if Client7.Painting then
            ModernBuild.ControllerTool(Client7, ({Brush = "PaintBrush", Bucket = "PaintBucket", Dropper = "ColorDropper"})[a1])
            -- jump to 193 (out of range)
            -- branch continues at 193
        end
    end

    if a1 == "Objects" then
        if Client7.Painting then
            ModernBuild.Close(Client7)
            -- branch continues at 193
        end
    else
        if a1 == "Delete" then
            if Client7.Painting then
                ModernBuild.Close(Client7)
            end

            a0:SetFollowing(false)
            Client7:SetDeletingObjects(not Client7.DeletingObjects)
        else
            if a1 == "Grid" then
                Client7.BuildGridEnabled = not Client7.BuildGridEnabled
                Client7:RebuildBuildGrid()
            else
                if a1 == "GridUp" or a1 == "GridDown" then
                    local v120
                    if a1 == "GridUp" then
                        v120 = 1
                    else
                        v120 = -1
                    end

                    Client7:AdjustBuildGridHeight(v120)
                    -- jump to 193 (out of range)
                end

                if a1 == "DeleteAll" then
                    if Client7.Painting then
                        ModernBuild.Close(Client7)
                    end

                    Client7:SetDeleteAllConfirmation(true)
                else
                    if a1 == "ResetPaint" then
                        ModernBuild.ShowResetConfirmation(Client7)
                    else
                        local v121 = ({ViewTop = "Top", ViewFront = "Front", ViewBack = "Back", ViewLeft = "Left", ViewRight = "Right", ViewIso = "Iso", ViewSide = "Right", ViewReset = "Iso"})[a1]
                        if v121 then
                            Client7:SetBuildView(v121)
                        end
                    end
                end
            end
        end
    end

    a0:SyncOwnership()
    a0:RefreshPresentation()
end

BaseObjectsLib.Option = Option

local function Commit(a0, a1)
    local v122 = false
    if a1 == true then
        v122 = a0.Precision
        if v122 then
            v122 = a0.UI.MenuKind == "Precision"
        end
    end

    if not a0:IsGamepad() then
        return
    end

    if a0:ExternalBlocked() then
        return
    end

    if a0.Precision or a0.UI.MenuOpen then
        if not v122 then
            return
        end
    end

    if not a0.Client.EditObject then
        return
    end

    if a0.Committing then
        return
    end

    a0.Committing = true
    local v123, v124 = pcall(function() --[[ Upvalues: a0 (copy) ]]
        a0.Client:AttemptPlaceBuildObject()
    end)
    a0.Committing = false
    if not v123 then
        warn("Modern building could not commit: " .. tostring(v124))
    end

    if not a0.Client.EditObject then
        a0.Following = false
        if v122 and a0:IsGamepad() and a0.Precision and a0.UI.MenuKind == "Precision" then
            a0:CloseMenu()
        end
    end

    a0:RefreshPresentation()
end

BaseObjectsLib.Commit = Commit

local function Primary(a0) --[[ Upvalues: ModernBuild (copy) ]]
    if a0:BlocksWorld() then
        return
    end

    local Client8 = a0.Client
    if Client8.Painting then
        ModernBuild.ControllerApply(Client8)
        return
    end

    if Client8.DeletingObjects then
        local v125 = a0:Center()
        a0.DeleteTarget = Client8:GetPlacedBuildObjectAtScreenPosition(v125)
        local v128 = a0.DeleteTarget and os.clock() or nil
        a0.DeleteStarted = v128
        a0.DeleteProgress = 0
        return
    end

    if Client8.EditObject then
        a0:Commit()
        return
    end

    local v129 = a0:Center()
    local v130 = Client8:GetPlacedBuildObjectAtScreenPosition(v129)
    if v130 and Client8:SelectPlacedBuildObject(v130) then
        a0:SetFollowing(true, true)
        return
    end

    a0.Status = "Aim at an object, or press Y for the catalogue"
end

BaseObjectsLib.Primary = Primary

local function Back(a0) --[[ Upvalues: ModernBuild (copy) ]]
    local Client9 = a0.Client
    if Client9.DeleteAllConfirmOpen then
        Client9:SetDeleteAllConfirmation(false)
    else
        if Client9.PaintResetConfirmOpen then
            ModernBuild.HideResetConfirmation(Client9)
        else
            if Client9.ColorPickerHUD then
                ModernBuild.ControllerClosePicker(Client9)
            else
                if a0.UI.MenuKind == "Steps" then
                    a0:ReturnFromSteps()
                else
                    if a0.UI.MenuOpen then
                        a0:CloseMenu()
                    else
                        if Client9.EditObject then
                            a0:SetFollowing(false)
                            Client9:DeleteEditObject()
                        else
                            if Client9.Painting then
                                ModernBuild.Close(Client9)
                            else
                                if Client9.DeletingObjects then
                                    Client9:SetDeletingObjects(false)
                                else
                                    a0:OpenOptions()
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    a0.Status = nil
    a0:SyncOwnership()
    a0:RefreshPresentation()
end

BaseObjectsLib.Back = Back

local function HandleInput(a0, a1, a2, a3) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    if not a0:IsGamepad() then
        return Enum.ContextActionResult.Pass
    end

    local KeyCode = a3.KeyCode
    local v131 = a2 == Enum.UserInputState.Begin
    local v132 = true
    if a2 ~= Enum.UserInputState.End then
        v132 = a2 == Enum.UserInputState.Cancel
    end

    local v133 = a0.HeldKeys[KeyCode]
    if v131 then
        a0.HeldKeys[KeyCode] = true
    end

    if v132 then
        a0.HeldKeys[KeyCode] = nil
        a0.RequireRelease[KeyCode] = nil
        if KeyCode == Enum.KeyCode.ButtonA then
            a0.DeleteStarted = nil
            a0.DeleteTarget = nil
            a0.DeleteProgress = 0
        end

        if KeyCode == Enum.KeyCode.ButtonL1 or KeyCode == Enum.KeyCode.ButtonR1 then
            a0.RepeatDirection = nil
            a0.RepeatAt = nil
        end

        if KeyCode == Enum.KeyCode.ButtonL2 or KeyCode == a0.GridAdjustKey then
            a0:StopGridAdjustment(true)
        end

        if KeyCode == Enum.KeyCode.ButtonL2 or KeyCode == a0.QuickRotateKey then
            a0:StopQuickRotation(true)
        end
    end

    if KeyCode == Enum.KeyCode.ButtonA then
        if a0.MenuPrimary then
            if v132 then
                a0.MenuPrimary = nil
            end

            return Enum.ContextActionResult.Pass
        end
    end

    if GuiService.MenuIsOpen then
        if KeyCode == Enum.KeyCode.ButtonA and v131 and not a0.RequireRelease[KeyCode] then
            a0.MenuPrimary = true
        end

        return Enum.ContextActionResult.Pass
    end

    if a0.WindowUnfocused then
        return Enum.ContextActionResult.Sink
    end

    if UserInputService:GetFocusedTextBox() then
        if v131 and KeyCode == Enum.KeyCode.ButtonB then
            UserInputService:GetFocusedTextBox():ReleaseFocus()
        end

        return Enum.ContextActionResult.Sink
    end

    if a0.RequireRelease[KeyCode] and not v132 then
        return Enum.ContextActionResult.Sink
    end

    if a0:ExternalBlocked() then
        if v131 and KeyCode == Enum.KeyCode.ButtonB then
            a0:Back()
            return Enum.ContextActionResult.Sink
        end

        if KeyCode ~= Enum.KeyCode.ButtonA then
            local v134 = true
            if KeyCode ~= Enum.KeyCode.DPadLeft then
                v134 = true
                if KeyCode ~= Enum.KeyCode.DPadRight then
                    v134 = true
                    if KeyCode ~= Enum.KeyCode.DPadUp then
                        v134 = KeyCode == Enum.KeyCode.DPadDown
                    end
                end
            end

            if not v134 then
                -- jump to 221
            end
        end

        if KeyCode == Enum.KeyCode.ButtonA and v131 then
            a0.MenuPrimary = true
        end

        return Enum.ContextActionResult.Pass
        return Enum.ContextActionResult.Sink
    end

    if a0.UI.MenuOpen then
        if a0.UI.MenuKind ~= "Precision" then
            if KeyCode ~= Enum.KeyCode.ButtonA then
                local v135 = true
                if KeyCode ~= Enum.KeyCode.DPadLeft then
                    v135 = true
                    if KeyCode ~= Enum.KeyCode.DPadRight then
                        v135 = true
                        if KeyCode ~= Enum.KeyCode.DPadUp then
                            v135 = KeyCode == Enum.KeyCode.DPadDown
                        end
                    end
                end

                if not v135 then
                    -- jump to 272
                end
            end

            if KeyCode == Enum.KeyCode.ButtonA and v131 then
                a0.MenuPrimary = true
            end

            return Enum.ContextActionResult.Pass
            if v131 then
                if KeyCode == Enum.KeyCode.ButtonB then
                    a0:Back()
                else
                    if KeyCode == Enum.KeyCode.ButtonY then
                        a0:CloseMenu()
                    else
                        if a0.UI.MenuKind == "Catalogue" and KeyCode == Enum.KeyCode.ButtonL1 then
                            a0.UI:ChangeCategory(-1)
                        else
                            if a0.UI.MenuKind == "Catalogue" and KeyCode == Enum.KeyCode.ButtonR1 then
                                a0.UI:ChangeCategory(1)
                            end
                        end
                    end
                end
            end

            return Enum.ContextActionResult.Sink
        end
    end

    if not v131 then
        return Enum.ContextActionResult.Sink
    end

    if v133 then
        if KeyCode == Enum.KeyCode.ButtonA or KeyCode == Enum.KeyCode.ButtonR2 then
            return Enum.ContextActionResult.Sink
        end
    end

    if not a0:QuickAdjustAvailable() then
        a0:StopGridAdjustment(true)
        a0:StopQuickRotation(true)
    end

    if a0:QuickAdjustAvailable() then
        if KeyCode == Enum.KeyCode.ButtonR3 then
            if a0.HeldKeys[Enum.KeyCode.ButtonL2] or a0.RequireRelease[Enum.KeyCode.ButtonL2] then
                if not a0.RequireRelease[Enum.KeyCode.ButtonL2] and not v133 then
                    a0:CycleQuickRotateAxis()
                end

                return Enum.ContextActionResult.Sink
            end
        end

        if KeyCode == Enum.KeyCode.ButtonL3 then
            if not a0.RequireRelease[Enum.KeyCode.ButtonL2] then
                if not v133 then
                    local v136
                    if a0.HeldKeys[Enum.KeyCode.ButtonL2] then
                        v136 = "Rotate"
                    else
                        v136 = "Move"
                    end

                    a0:CycleStep(v136)
                end
            end

            return Enum.ContextActionResult.Sink
        end

        if KeyCode == Enum.KeyCode.ButtonR3 then
            if not v133 and not a0.Precision then
                local v137 = not a0.Following
                a0:SetFollowing(v137, true)
            end

            a0:RefreshPresentation()
            return Enum.ContextActionResult.Sink
        end

        if KeyCode == Enum.KeyCode.DPadUp or KeyCode == Enum.KeyCode.DPadDown then
            if a0.HeldKeys[Enum.KeyCode.ButtonL2] or a0.RequireRelease[Enum.KeyCode.ButtonL2] then
                if not a0.RequireRelease[Enum.KeyCode.ButtonL2] then
                    if not v133 then
                        a0:StopGridAdjustment(true)
                        a0:StopQuickRotation(true)
                        if KeyCode == Enum.KeyCode.DPadUp then
                            v132 = 1
                        else
                            v132 = -1
                        end

                        if a0:AdjustGrid(v132) then
                            a0.GridAdjustDirection = v132
                            a0.GridAdjustKey = KeyCode
                            a0.GridRepeatAt = os.clock() + 0.35
                        end
                    end
                end

                a0:RefreshPresentation()
                return Enum.ContextActionResult.Sink
            end
        end

        if not a0.Precision then
            if KeyCode == Enum.KeyCode.DPadLeft or KeyCode == Enum.KeyCode.DPadRight then
                if a0.HeldKeys[Enum.KeyCode.ButtonL2] or a0.RequireRelease[Enum.KeyCode.ButtonL2] then
                    if not a0.RequireRelease[Enum.KeyCode.ButtonL2] then
                        if not v133 then
                            a0:StopGridAdjustment(true)
                            a0:StopQuickRotation(true)
                            if KeyCode == Enum.KeyCode.DPadLeft then
                                v131 = -1
                            else
                                v131 = 1
                            end

                            if a0:QuickRotate(v131) then
                                a0.QuickRotateDirection = v131
                                a0.QuickRotateKey = KeyCode
                                a0.QuickRotateRepeatAt = os.clock() + 0.35
                            end
                        end
                    end

                    a0:RefreshPresentation()
                    return Enum.ContextActionResult.Sink
                end
            end
        end
    end

    if KeyCode == Enum.KeyCode.ButtonB then
        a0:Back()
    else
        if a0.Precision then
            if KeyCode == Enum.KeyCode.ButtonX then
                a0:CloseMenu()
                -- jump to 846 (out of range)
            end

            if KeyCode == Enum.KeyCode.ButtonY then
                a0:OpenSteps()
                -- jump to 846 (out of range)
            end

            if KeyCode == Enum.KeyCode.ButtonR2 then
                if not a0.RequireRelease[Enum.KeyCode.ButtonL2] then
                    local v138
                    if a0.HeldKeys[Enum.KeyCode.ButtonL2] then
                        v138 = -1
                    else
                        v138 = 1
                    end

                    a0:QuickRotate(v138, true)
                    -- jump to 846 (out of range)
                    -- branch continues at 846
                end
            end

            if KeyCode == Enum.KeyCode.ButtonA then
                a0:Commit(true)
                -- jump to 846 (out of range)
            end

            if KeyCode == Enum.KeyCode.DPadUp or KeyCode == Enum.KeyCode.DPadDown then
                local v139
                if a0.Client.BuildTransformMode == "Rotate" then
                    v139 = "Move"
                else
                    v139 = "Rotate"
                end

                a0:SetPrecisionMode(v139)
                -- jump to 846 (out of range)
            end

            if KeyCode == Enum.KeyCode.DPadLeft or KeyCode == Enum.KeyCode.DPadRight then
                v133 = {"X", "Y", "Z"}
                local v140
                if KeyCode == Enum.KeyCode.DPadLeft then
                    v140 = -1
                else
                    v140 = 1
                end

                a0:SetAxis(v133[((table.find(v133, a0.Axis) or 2) - 1 + v140) % 3 + 1])
                -- jump to 846 (out of range)
            end

            if KeyCode ~= Enum.KeyCode.ButtonL1 then
                if KeyCode ~= Enum.KeyCode.ButtonR1 then
                    -- jump to 846
                end
            end

            local v141
            if KeyCode == Enum.KeyCode.ButtonL1 then
                v141 = -1
            else
                v141 = 1
            end

            a0.RepeatDirection = v141
            a0.RepeatAt = os.clock() + 0.35
            a0:Nudge(a0.RepeatDirection)
        else
            if KeyCode == Enum.KeyCode.ButtonA then
                a0:Primary()
            else
                if KeyCode == Enum.KeyCode.ButtonR2 then
                    local v142
                    if not a0.RequireRelease[Enum.KeyCode.ButtonL2] then
                        a0:StopQuickRotation(true)
                        if a0.HeldKeys[Enum.KeyCode.ButtonL2] then
                            v142 = -1
                        else
                            v142 = 1
                        end

                        a0:QuickRotate(true)
                        -- branch continues at 846
                    end
                else
                    if KeyCode == Enum.KeyCode.ButtonX then
                        if a0.Client.Painting then
                            a0:OpenPalette()
                            -- jump to 846 (out of range)
                        end

                        a0:OpenPrecision()
                    else
                        if KeyCode == Enum.KeyCode.ButtonY then
                            a0:OpenCatalogue()
                        else
                            if KeyCode == Enum.KeyCode.DPadUp then
                                a0:OpenOptions()
                            else
                                if KeyCode == Enum.KeyCode.DPadLeft then
                                    a0:CycleRecent(-1)
                                else
                                    if KeyCode == Enum.KeyCode.DPadRight then
                                        a0:CycleRecent(1)
                                    else
                                        if KeyCode == Enum.KeyCode.DPadDown then
                                            a0:Option("Delete")
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

    a0:RefreshPresentation()
    return Enum.ContextActionResult.Sink
end

BaseObjectsLib.HandleInput = HandleInput

local function GetLegacyVisibility(a0, a1)
    if a0.Hidden[a1] ~= nil then
        return a0.Hidden[a1]
    end

    return a1.Visible
end

BaseObjectsLib.GetLegacyVisibility = GetLegacyVisibility

local function RestoreLegacyVisibility(a0, a1)
    if not (a0:IsGamepad() and a1) then
        return
    end

    local Client10 = a0.Client
    local v143 = "TransformPanel"
    local v144 = {"Toolbar", v143, "ViewPanel", "Hint"}
    for k19, k20 in ipairs(v144) do
        local v149 = Client10.BuildGui and Client10.BuildGui:FindFirstChild(k20)
        if v149 and a1[k20] ~= nil then
            a0.Hidden[v149] = a1[k20]
        end
    end

    if a1.BaseObjects ~= nil then
        a0.Hidden[Client10.HUD.BaseObjects] = a1.BaseObjects
    end

    a0.Hidden[Client10.HUD.PaintEditBar] = false
end

BaseObjectsLib.RestoreLegacyVisibility = RestoreLegacyVisibility

local function SaveAndHide(a0, a1)
    if not (a1 and a1:IsA("GuiObject")) then
        return
    end

    if a0.Hidden[a1] == nil then
        a0.Hidden[a1] = a1.Visible
    end

    a1.Visible = false
end

BaseObjectsLib.SaveAndHide = SaveAndHide

local function PresentationState(a0) --[[ Upvalues: PaintController (copy) ]]
    local Client11 = a0.Client
    local EditObject = Client11.EditObject
    local v152 = EditObject and PaintController[EditObject.Name]
    local v153 = Client11.BuildGui and Client11.BuildGui:FindFirstChild("Toolbar")
    local v155 = v153 and v153:FindFirstChild("Buttons")
    local v156 = v155 and v155:FindFirstChild("Capacity")
    local v159 = type(Client11.GetBuildGridFloor) == "function" and Client11:GetBuildGridFloor() or nil
    local v162 = a0.Status or Client11.BuildInvalidReason
    if not v162 and Client11.BuildPlacementValid ~= false and not a0.Precision and not a0.UI.MenuOpen and a0:QuickAdjustAvailable() then
        local v163 = a0.QuickRotateAxisNoticeUntil or 0
        if os.clock() < v163 then
            v162 = "Rotation axis: " .. (a0.QuickRotateAxis or "Y")
        end
    end

    local v164 = {}
    local v165
    if Client11.Painting then
        v165 = "Paint"
    else
        v165 = "Objects"
    end

    v164.mode = v165
    local v166
    if not (EditObject and EditObject.Name) then
        local v167 = Client11.Painting and Client11.PaintMode
    end

    v164.itemName = v166
    v164.deleting = Client11.DeletingObjects == true
    v164.deleteProgress = a0.DeleteProgress or 0
    local v168
    if a0.DeleteTarget or Client11.ObjectHover then
        local v169 = a0.DeleteTarget or Client11.ObjectHover
        v169 = v169.Name
    end

    v164.targetName = v168
    v168 = false
    if a0.Following == true then
        v168 = EditObject ~= nil
    end

    v164.following = v168
    v164.editingExisting = Client11.EditingExistingObject ~= nil
    local v171 = v156 and v156.Text
    v164.capacityText = v171
    local v172 = v152 and v152.Price
    v164.price = v172
    v164.moveStep = Client11.BuildMoveStep or 0.5
    v164.rotateStep = Client11.BuildRotateStep or 15
    v164.quickRotateAxis = a0.QuickRotateAxis or "Y"
    local v173 = false
    if a0.HeldKeys[Enum.KeyCode.ButtonL2] == true then
        v173 = not a0.RequireRelease[Enum.KeyCode.ButtonL2]
    end

    v164.slowModifier = v173
    v164.gridHeight = v159 and Client11.BuildGridOffsets and Client11.BuildGridOffsets[v159] or 0
    v164.gridEnabled = Client11.BuildGridEnabled == true
    v164.gridAdjusting = a0.GridAdjustDirection or false
    v164.quickAdjustAvailable = a0:QuickAdjustAvailable()
    v164.axis = a0.Axis
    v164.transformMode = Client11.BuildTransformMode or "Move"
    v164.valid = Client11.BuildPlacementValid
    v164.status = v162
    local ModernBuildRecents2 = Client11.ModernBuildRecents
    if not ModernBuildRecents2 then
        ModernBuildRecents2 = {}
    end

    v164.recents = ModernBuildRecents2
    v164.recentIndex = a0.RecentIndex or 1
    v164.paintColor = Client11.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3
    return v164
end

BaseObjectsLib.PresentationState = PresentationState

local function RefreshPresentation(a0)
    if not a0:IsGamepad() then
        return
    end

    local Client12 = a0.Client
    local v174 = "BaseEdit"
    local v175 = {
        "BaseObjects",
        v174,
        "PaintEditBar",
        "MobileEdits",
        "MobileMouse",
        "Crosshair"
    }
    for k21, k22 in ipairs(v175) do
        local v179 = Client12.HUD:FindFirstChild(k22)
        a0:SaveAndHide(v179)
    end

    if Client12.BuildGui then
        k22 = "TransformPanel"
        local v180 = {
            "Toolbar",
            k22,
            "ViewPanel",
            "Hint",
            "ControllerHotkeys",
            "BuildSystemToggle",
            "MobileCameraControls",
            "MobileCameraContols"
        }
        for k23, k24 in ipairs(v180) do
            local v184 = Client12.BuildGui:FindFirstChild(k24)
            a0:SaveAndHide(v184)
        end
    end

    Client12:HideBuildGizmos()
    local v185 = a0:PresentationState()
    a0.UI:Update(v185)
    Client12 = not a0:BlocksWorld()
    a0.UI.HUD.Visible = Client12
    a0.UI.Reticle.Visible = Client12
    if not Client12 then
        a0.UI.Progress.Visible = false
    end
end

BaseObjectsLib.RefreshPresentation = RefreshPresentation

local function Step(a0, a1)
    if not a0:IsGamepad() then
        return
    end

    local Client13 = a0.Client
    if not Client13.BuildCameraActive or Client13.ClassicBuildActive then
        a0:Destroy()
        return
    end

    a0:SyncOwnership()
    if a0.GridAdjustDirection then
        local GridAdjustKey1 = a0.GridAdjustKey
        if a0:QuickAdjustAvailable() then
            if not a0:ExternalBlocked() then
                if not a0.UI.MenuOpen or a0.UI.MenuKind == "Precision" then
                    if a0.HeldKeys[Enum.KeyCode.ButtonL2] then
                        if a0.HeldKeys[GridAdjustKey1] then
                            if not a0.RequireRelease[Enum.KeyCode.ButtonL2] then
                                if not a0.RequireRelease[GridAdjustKey1] then
                                    -- jump to 75
                                end
                            end
                        end
                    end
                end
            end
        end

        a0:StopGridAdjustment(true)
    end

    if a0.QuickRotateDirection then
        local QuickRotateKey1 = a0.QuickRotateKey
        if not a0:QuickAdjustAvailable() or a0:ExternalBlocked() or a0.UI.MenuOpen or a0.Precision or not a0.HeldKeys[Enum.KeyCode.ButtonL2] or not a0.HeldKeys[QuickRotateKey1] or a0.RequireRelease[Enum.KeyCode.ButtonL2] or a0.RequireRelease[QuickRotateKey1] then
            a0:StopQuickRotation(true)
            -- jump to 178 (out of range)
        end

        if a0.QuickRotateRepeatAt <= os.clock() then
            a0.QuickRotateRepeatAt = os.clock() + 0.12
            if not a0:QuickRotate(a0.QuickRotateDirection) then
                a0:StopQuickRotation(true)
            end
        end
    end

    if a0.Precision and a0.UI.MenuKind == "Precision" and not a0:ExternalBlocked() and a0.RepeatDirection and a0.RepeatAt <= os.clock() then
        a0.RepeatAt = os.clock() + 0.12
        a0:Nudge(a0.RepeatDirection)
    end

    if not a0:BlocksWorld() then
        if a0.DeleteStarted then
            local v186 = a0:Center()
            local v187 = Client13:GetPlacedBuildObjectAtScreenPosition(v186)
            if not (v187 == a0.DeleteTarget and v187 and v187.Parent) then
                a0.DeleteStarted = nil
                a0.DeleteTarget = nil
                a0.DeleteProgress = 0
                -- jump to 290 (out of range)
            end

            v186 = (os.clock() - a0.DeleteStarted) / 0.4
            a0.DeleteProgress = math.clamp(v186, 0, 1)
            if 1 <= a0.DeleteProgress then
                a0.Remote:FireServer("DeleteBaseObject", v187)
                Client13:ClearBuildObjectHover()
                a0.DeleteStarted = nil
                a0.DeleteTarget = nil
                a0.DeleteProgress = 0
            end
        end

        if Client13.EditObject then
            if not Client13.Painting then
                local CFrame = workspace.CurrentCamera.CFrame
                if a0.Following and CFrame ~= a0.FollowCamera then
                    Client13.BuildDirectGrabBoxLocal = a0.GrabOffset or Vector3.new(0, 0, 0)
                    local v188 = a0:Center()
                    Client13:UpdateDirectBuildDrag(v188)
                    a0.FollowCamera = CFrame
                end

                Client13:RefreshBuildValidation(false)
                -- branch continues at 328
            end
        else
            if not Client13.Painting then
                local v189 = a0:Center()
                Client13:UpdateBuildObjectHover(v189)
            end
        end
    end

    a0.RefreshElapsed = (a0.RefreshElapsed or 0) + a1
    if 0.08 <= a0.RefreshElapsed then
        a0.RefreshElapsed = 0
        a0:RefreshPresentation()
    end
end

BaseObjectsLib.Step = Step

local function StepCamera(a0, a1) --[[ Upvalues: UserInputService (copy) ]]
    if not a0:IsGamepad() then
        return false
    end

    a0:SyncOwnership()
    local Client14 = a0.Client
    local v190, v191 = Client14:GetBuildReference()
    if not (v190 and v191) then
        a0:Step(a1)
        return true
    end

    local v192 = a0:GetPad()
    if not a0:BlocksWorld() and v192 then
        local zero = Vector2.zero
        local zero1 = Vector2.zero
        local v193 = UserInputService:GetGamepadState(v192)
        for k25, k26 in ipairs(v193) do
            local KeyCode1 = k26.KeyCode
            if KeyCode1 == Enum.KeyCode.Thumbstick1 or KeyCode1 == Enum.KeyCode.Thumbstick2 then
                local v197 = Vector2.new(k26.Position.X, k26.Position.Y)
                local Magnitude1 = v197.Magnitude
                local v198
                if Magnitude1 <= 0.15 then
                    v198 = Vector2.zero
                else
                    v198 = v197.Unit * math.min(1, (Magnitude1 - 0.15) / 0.85)
                end

                if v198.Magnitude == 0 then
                    a0.RequireRelease[KeyCode1] = nil
                end

                if not a0.RequireRelease[KeyCode1] then
                    if KeyCode1 == Enum.KeyCode.Thumbstick1 then
                        zero = v198
                    else
                        zero1 = v198
                    end
                end
            end
        end

        local function down(a0) --[[ Upvalues: UserInputService (upvalue), v192 (copy), a0 (copy) ]]
            if not UserInputService:IsGamepadButtonDown(v192, a0) then
                a0.RequireRelease[a0] = nil
                return false
            end

            return not a0.RequireRelease[a0]
        end

        local ButtonL2 = Enum.KeyCode.ButtonL2
        local v199
        if not UserInputService:IsGamepadButtonDown(v192, ButtonL2) then
            a0.RequireRelease[ButtonL2] = nil
            v199 = false
        else
            v199 = not a0.RequireRelease[ButtonL2]
        end

        local ButtonR1 = Enum.KeyCode.ButtonR1
        local v200
        if not UserInputService:IsGamepadButtonDown(v192, ButtonR1) then
            a0.RequireRelease[ButtonR1] = nil
            v200 = false
        else
            v200 = not a0.RequireRelease[ButtonR1]
        end

        local v201
        if v200 then
            v201 = 1
        else
            v201 = 0
        end

        local ButtonL1 = Enum.KeyCode.ButtonL1
        if not UserInputService:IsGamepadButtonDown(v192, ButtonL1) then
            a0.RequireRelease[ButtonL1] = nil
            ButtonR1 = false
        else
            ButtonR1 = not a0.RequireRelease[ButtonL1]
        end

        if ButtonR1 then
            v200 = 1
        else
            v200 = 0
        end

        ButtonL2 = v201 - v200
        down = math.clamp(a1, 0, 0.1)
        if 0 < zero1.Magnitude then
            Client14.BuildViewPreset = nil
            v200 = Client14.BuildCameraYaw or 0
            local v202 = zero1.X * 2.2
            local v203
            if v199 then
                v203 = 0.3
            else
                v203 = 1
            end

            Client14.BuildCameraYaw = v200 - v202 * v203 * down
            local v204 = Client14.BuildCameraPitch or 0
            v203 = zero1.Y * 2.2
            local v205
            if v199 then
                v205 = 0.3
            else
                v205 = 1
            end

            v200 = v204 + v203 * v205 * down
            Client14.BuildCameraPitch = math.clamp(v200, -1.5533430342749532, 1.3089969389957472)
        end

        local v206 = Client14.BuildCameraYaw or 0
        zero1 = v190.CFrame.Rotation * CFrame.Angles(0, v206, 0)
        local v207 = zero1.RightVector * zero.X
        local v208 = v207 + zero1.LookVector * zero.Y
        local v209 = v208 + v190.CFrame.UpVector * ButtonL2
        if 1 < v209.Magnitude then
            v209 = v209.Unit
        end

        local v210 = Client14.BuildCameraPosition or workspace.CurrentCamera.CFrame.Position
        local v211
        if v199 then
            v211 = 0.25
        else
            v211 = 1
        end

        Client14.BuildCameraPosition = Client14:ClampBuildCameraPosition(v210 + v209 * 24 * v211 * down)
        Client14:UpdateBuildCameraCFrame()
        if Client14.BuildModeKind ~= "Paint" then
            Client14:UpdateBuildGridSurface()
        end
    end

    a0:Step(a1)
    return true
end

BaseObjectsLib.StepCamera = StepCamera

local function SetActive(a0, a1) --[[ Upvalues: GuiService (copy), UserInputService (copy), ContextActionService (copy), v13 (copy), v9 (copy), v14 (copy), GamepadService (copy) ]]
    local v212 = false
    if a1 == true then
        v212 = false
        if a0.Client.BuildCameraActive == true then
            v212 = not a0.Client.ClassicBuildActive
        end
    end

    a1 = v212
    if a0.Destroyed or a1 == a0.Active then
        return
    end

    local Client15 = a0.Client
    local v213
    if a1 then
        a0.Active = true
        a0.SavedContext = Client15.MainContext.Enabled
        a0.SavedAutoSelect = GuiService.AutoSelectGuiEnabled
        a0.SavedFreeMouse = Client15.FreeMouse
        a0.SavedMouseBehavior = UserInputService.MouseBehavior
        a0.SavedMouseIcon = UserInputService.MouseIconEnabled
        a0.SavedCameraLock = Client15.BuildCameraLocked
        Client15.BuildCameraLocked = false
        Client15.MainContext.Enabled = false
        Client15.FreeMouse = false
        Client15:EndBuildTouchGizmoDrag()
        Client15:EndBuildTransformHold()
        Client15:EndDirectBuildDrag()
        Client15:EndBuildMouseCameraDrag()
        pcall(function() --[[ Upvalues: ContextActionService (upvalue) ]]
            ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
            ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
        end)
        GuiService.AutoSelectGuiEnabled = false
        GuiService.SelectedObject = nil
        v213 = "M2U"
        local v214 = {"M1U", v213, "BlockOff", "RunOff"}
        for k27, k28 in ipairs(v214) do
            a0.Remote:FireServer(k28)
        end

        if a0.Controls then
            local v218 = v13[a0.Controls]
            if v218 then
                v218.Connection:Disconnect()
                v13[a0.Controls] = nil
                a0.DisabledControls = true
            else
                if a0.Controls.controlsEnabled ~= false then
                    a0.Controls:Disable()
                    a0.DisabledControls = true
                end
            end
        end

        local v220 = table.unpack(v14)
        ContextActionService:BindActionAtPriority("ModernBuildControllerActions", function(...) --[[ Upvalues: a0 (copy) ]]
            local v219 = a0:HandleInput(...)
            return v219
        end, false, v9, v220)
        a0.Following = false
        a0.UI:SetActive(true)
        a0:CancelHeldInputs()
        a0:SyncOwnership()
        a0:RefreshPresentation()
        if not Client15.EditObject then
            if not Client15.Painting then
                a0:OpenCatalogue()
                return
                -- branch continues at 423
            end

            -- branch continues at 423
        end
    end

    a0:CancelHeldInputs()
    a0.UI:CloseMenu()
    a0.Precision = false
    a0.Following = false
    a0.MenuPrimary = nil
    a0.StepsMode = nil
    a0.StepsReturn = nil
    a0.Active = false
    ContextActionService:UnbindAction("ModernBuildControllerActions")
    pcall(function() --[[ Upvalues: ContextActionService (upvalue) ]]
        ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
        ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
    end)
    Client15:EndDirectBuildDrag()
    GuiService.SelectedObject = nil
    if GamepadService.GamepadCursorEnabled then
        GamepadService:DisableGamepadCursor()
    end

    Client15.BuildGamepadNavigation = false
    GuiService.AutoSelectGuiEnabled = a0.SavedAutoSelect
    Client15.MainContext.Enabled = a0.SavedContext
    Client15.FreeMouse = a0.SavedFreeMouse
    Client15.BuildCameraLocked = a0.SavedCameraLock
    local SavedMouseIcon = a0.SavedMouseIcon
    UserInputService.MouseBehavior = a0.SavedMouseBehavior
    UserInputService.MouseIconEnabled = SavedMouseIcon
    for k29, k30 in pairs(a0.Hidden) do
        if k29.Parent then
            k29.Visible = k30
        end
    end

    a0.Hidden = {}
    a0.UI:SetActive(false)
    if Client15.Painting then
        Client15.HUD.PaintEditBar.Visible = true
        Client15.HUD.BaseObjects.Visible = false
        Client15.BuildGui.Toolbar.Visible = Client15.PaintIntegrated == true
        Client15.BuildGui.TransformPanel.Visible = false
        Client15.BuildGui.ViewPanel.Visible = true
        Client15.BuildGui.Hint.Visible = not Client15.TouchEnabled
    end

    if a0.DisabledControls then
        a0.DisabledControls = nil
        local Controls = a0.Controls
        if GuiService.MenuIsOpen then
            local v224 = {}
            v13[Controls] = v224
            v224.Connection = GuiService.MenuClosed:Once(function() --[[ Upvalues: v13 (upvalue), Controls (copy), v224 (copy) ]]
                local v225 = v13[Controls]
                if v225 == v224 then
                    v13[Controls] = nil
                    Controls:Enable()
                end

            end)
        else
            Controls:Enable()
        end
    end

    if Client15.BuildCameraActive then
        Client15:UpdateBuildGui()
        if Client15.EditObject then
            local v226 = Client15:GetBuildObjectCFrame()
            Client15:UpdateBuildGizmo(v226)
        end
    end
end

BaseObjectsLib.SetActive = SetActive

local function Destroy(a0)
    if a0.Destroyed then
        return
    end

    if a0.Active then
        a0:SetActive(false)
    end

    a0.Destroyed = true
    if a0.SuspendedPreview then
        local SuspendedPreview1 = a0.SuspendedPreview
        local EditExistingOriginalTransparency2 = SuspendedPreview1.EditExistingOriginalTransparency
        if not EditExistingOriginalTransparency2 then
            EditExistingOriginalTransparency2 = {}
        end

        for k31, k32 in pairs(EditExistingOriginalTransparency2) do
            if k31.Parent then
                k31.LocalTransparencyModifier = k32
            end
        end

        if SuspendedPreview1.EditObject then
            SuspendedPreview1.EditObject:Destroy()
        end

        a0.SuspendedPreview = nil
    end

    for k33, k34 in ipairs(a0.Connections) do
        k34:Disconnect()
    end

    a0.Connections = {}
    a0.UI:Destroy()
end

BaseObjectsLib.Destroy = Destroy

local function Start(a0) --[[ Upvalues: BaseObjectsLib (copy), ReplicatedStorage (copy), v1 (copy), v7 (copy), UserInputService (copy), GuiService (copy) ]]
    local v234 = {
        Active = false,
        Axis = "Y",
        QuickRotateAxis = "Y",
        RecentIndex = 1,
        Client = a0,
        Connections = {},
        Hidden = {},
        HeldKeys = {},
        RequireRelease = {}
    }
    local v235 = setmetatable(v234, BaseObjectsLib)
    v235.Remote = ReplicatedStorage.Remotes.RemoteEvent
    local PlayerScripts = a0.Player:FindFirstChild("PlayerScripts")
    local v237 = PlayerScripts and PlayerScripts:FindFirstChild("PlayerModule")
    if v237 then
        local v241, v242 = pcall(function() --[[ Upvalues: v237 (copy), v1 (upvalue) ]]
            local v238 = v237
            local v239
            if type(v238) == "table" then
                v239 = v238
            else
                v239 = v1(v238)
            end

            local v240 = v239:GetControls()
            return v240
        end)
        if v241 then
            v235.Controls = v242
        end
    end

    local function SelectItem(a0, a1) --[[ Upvalues: v235 (copy) ]]
        v235:ChooseItem(a0, a1)
    end

    local function Close() --[[ Upvalues: v235 (copy) ]]
        v235:Back()
    end

    local function Option1(a0) --[[ Upvalues: v235 (copy) ]]
        v235:Option(a0)
    end

    local function Mode(a0) --[[ Upvalues: v235 (copy) ]]
        v235:SetPrecisionMode(a0)
    end

    local function Axis2(a0) --[[ Upvalues: v235 (copy) ]]
        v235:SetAxis(a0)
    end

    local function Nudge1(a0) --[[ Upvalues: v235 (copy) ]]
        v235:Nudge(a0)
    end

    local function Steps() --[[ Upvalues: v235 (copy) ]]
        v235:OpenSteps()
    end

    local function Step1(a0) --[[ Upvalues: v235 (copy) ]]
        v235:SetStep(a0)
    end

    local function Commit1() --[[ Upvalues: v235 (copy) ]]
        v235:Commit(true)
    end

    local function Color(a0) --[[ Upvalues: v235 (copy) ]]
        v235:ChooseColor(a0)
    end

    local v243 = {
        SelectItem = SelectItem,
        Close = Close,
        Option = Option1,
        Mode = Mode,
        Axis = Axis2,
        Nudge = Nudge1,
        Steps = Steps,
        Step = Step1,
        Commit = Commit1,
        Color = Color
    }
    v235.UI = v7.new(a0, v243)

    local function connect(a0, a1) --[[ Upvalues: v235 (copy) ]]
        local v244 = a0:Connect(a1)
        table.insert(v235.Connections, v244)
    end

    local function syncDevice() --[[ Upvalues: v235 (copy), UserInputService (upvalue) ]]
        local GamepadEnabled1 = UserInputService.GamepadEnabled
        if GamepadEnabled1 then
            GamepadEnabled1 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
        end

        v235:SetActive(GamepadEnabled1)
    end

    local v245 = UserInputService:GetPropertyChangedSignal("PreferredInput")
    local v246 = v245:Connect(syncDevice)
    table.insert(v235.Connections, v246)
    local v247 = UserInputService.GamepadConnected:Connect(syncDevice)
    table.insert(v235.Connections, v247)
    local v248 = UserInputService.GamepadDisconnected:Connect(function() --[[ Upvalues: v235 (copy), UserInputService (upvalue) ]]
        v235:CancelHeldInputs()
        local GamepadEnabled2 = UserInputService.GamepadEnabled
        if GamepadEnabled2 then
            GamepadEnabled2 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
        end

        v235:SetActive(GamepadEnabled2)
    end)
    table.insert(v235.Connections, v248)
    local v249 = GuiService.MenuOpened:Connect(function() --[[ Upvalues: v235 (copy) ]]
        if v235:IsGamepad() then
            v235:CancelHeldInputs()
            v235:SyncOwnership()
        end

    end)
    table.insert(v235.Connections, v249)
    local v250 = GuiService.MenuClosed:Connect(function() --[[ Upvalues: v235 (copy) ]]
        if v235:IsGamepad() then
            v235:CancelHeldInputs()
            v235:SyncOwnership()
            if v235.UI.MenuOpen then
                v235.UI:FocusDefault()
            end
        end

    end)
    table.insert(v235.Connections, v250)
    local v251 = UserInputService.WindowFocusReleased:Connect(function() --[[ Upvalues: v235 (copy) ]]
        v235.WindowUnfocused = true
        if v235:IsGamepad() then
            v235:CancelHeldInputs()
            v235:SetFollowing(false)
        end

    end)
    table.insert(v235.Connections, v251)
    local v252 = UserInputService.WindowFocused:Connect(function() --[[ Upvalues: v235 (copy) ]]
        v235.WindowUnfocused = false
        if v235:IsGamepad() then
            v235:CancelHeldInputs()
            v235:SyncOwnership()
        end

    end)
    table.insert(v235.Connections, v252)
    local v253 = UserInputService.TextBoxFocused:Connect(function() --[[ Upvalues: v235 (copy) ]]
        if v235:IsGamepad() then
            v235:CancelHeldInputs()
            v235:SyncOwnership()
        end

    end)
    table.insert(v235.Connections, v253)
    local v254 = UserInputService.TextBoxFocusReleased:Connect(function() --[[ Upvalues: v235 (copy) ]]
        if v235:IsGamepad() then
            v235:CancelHeldInputs()
            v235:SyncOwnership()
        end

    end)
    table.insert(v235.Connections, v254)
    local v255 = a0.Player.CharacterRemoving:Connect(function() --[[ Upvalues: v235 (copy) ]]
        v235:Destroy()
    end)
    table.insert(v235.Connections, v255)
    local GamepadEnabled3 = UserInputService.GamepadEnabled
    if GamepadEnabled3 then
        GamepadEnabled3 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
    end

    v235:SetActive(GamepadEnabled3)
    return v235
end

BaseObjectsLib.Start = Start
return BaseObjectsLib
