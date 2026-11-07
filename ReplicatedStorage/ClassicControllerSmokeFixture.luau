-- https://lua.expert

local _game = game
local _require = require
local v1 = assert(_G.__ClassicFixture, "Initialize fixture")
local Workspace = v1.Workspace
local t1 = {
    GetService = function(_, p2) -- GetService | line: 4
        -- upvalues: _game (copy), v1 (copy)
        return v1.Services[p2] or _game:GetService(p2)
    end
}

local function _require2(p3) -- line: 5
    -- upvalues: _require (copy), v1 (copy)
    if type(p3) == "table" then
        return p3
    end

    if p3 == v1.PlayerModule then
        return v1.PlayerModuleValue
    end

    return _require(p3)
end

t1:GetService("Players")

local ReplicatedStorage = t1:GetService("ReplicatedStorage")
local UserInputService = t1:GetService("UserInputService")
local ContextActionService = t1:GetService("ContextActionService")
local GuiService = t1:GetService("GuiService")
local GamepadService = t1:GetService("GamepadService")
local RunService = t1:GetService("RunService")
local ClassicBuild = ReplicatedStorage.Modules.ClassicBuild

if type(ClassicBuild) ~= "table" then
    ClassicBuild = if ClassicBuild == v1.PlayerModule then v1.PlayerModuleValue else _require(ClassicBuild)
end

local UI = ClassicBuild.UI
local PaintController = ReplicatedStorage.Modules.PaintController

if type(PaintController) ~= "table" then
    PaintController = if PaintController == v1.PlayerModule then v1.PlayerModuleValue else _require(PaintController)
end

local BaseObjectsLib = ReplicatedStorage.Modules.BaseObjectsLib

if type(BaseObjectsLib) ~= "table" then
    BaseObjectsLib = if BaseObjectsLib == v1.PlayerModule then v1.PlayerModuleValue else _require(BaseObjectsLib)
end

local t2 = {}

t2.__index = t2

local v2 = Enum.ContextActionPriority.High.Value + 100
local t3 = {
    5, 15, 30, 45, 90
}

t2.RotateSteps = t3

local self = setmetatable({}, {
    __mode = "k"
})

t2.PendingControlRestores = self

local t6 = {
    Enum.KeyCode.ButtonR2,
    Enum.KeyCode.ButtonL2,
    Enum.KeyCode.ButtonL1,
    Enum.KeyCode.ButtonR1,
    Enum.KeyCode.ButtonA,
    Enum.KeyCode.ButtonX,
    Enum.KeyCode.ButtonY,
    Enum.KeyCode.ButtonB,
    Enum.KeyCode.DPadLeft,
    Enum.KeyCode.DPadRight,
    Enum.KeyCode.DPadUp,
    Enum.KeyCode.DPadDown,
    Enum.KeyCode.ButtonL3,
    Enum.KeyCode.ButtonR3
}

local function preferredGamepad() -- line: 37
    -- upvalues: UserInputService (copy)
    return UserInputService.GamepadEnabled and UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
end

local function releaseCursorActivation() -- line: 41
    -- upvalues: ContextActionService (copy)
    local function v4() -- line: 42
        -- upvalues: ContextActionService (copy)
        ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
        ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
    end

    pcall(v4)
end

function t2.IsGamepad(p4) -- line: 48
    if p4.Active == true then
        return not p4.Destroyed
    end

    return false
end

function t2.PickerOpen(p5) -- line: 52
    return p5.Client.ColorPickerHUD ~= nil
end

function t2.BlocksWorld(p6) -- line: 56
    -- upvalues: UserInputService (copy), GuiService (copy)
    if not p6:IsGamepad() then
        return false
    end

    local MenuOpen = p6.UI.MenuOpen

    if not MenuOpen then
        MenuOpen = p6:PickerOpen()

        if not MenuOpen then
            MenuOpen = p6.ExternalMenu ~= nil or p6.Client.DeleteAllConfirmOpen == true or GuiService.MenuIsOpen or UserInputService:GetFocusedTextBox() ~= nil
        end
    end

    return MenuOpen
end

function t2.Send(p7, p8) -- line: 63
    p7.Remote:FireServer(p8)
end

function t2.SetPrecision(p9, p10) -- line: 67
    local v5 = p10 == true and p9:IsGamepad() and not p9:BlocksWorld()

    p9.Precision = v5

    if not v5 then
        p9.PrecisionCamera = nil
        p9.PrecisionRotation = nil
    end
end

function t2.CapturePrecisionCamera(p11) -- line: 78
    -- upvalues: Workspace (copy)
    p11.PrecisionCamera = nil
    p11.PrecisionRotation = nil

    if p11:IsGamepad() and p11.Precision and not p11:BlocksWorld() then
        local CurrentCamera = Workspace.CurrentCamera

        if CurrentCamera and CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
            p11.PrecisionCamera = CurrentCamera
            p11.PrecisionRotation = CurrentCamera.CFrame.Rotation
        end
    end
end

function t2.ApplyPrecisionCamera(p12) -- line: 88
    -- upvalues: Workspace (copy)
    local PrecisionCamera, PrecisionRotation = p12.PrecisionCamera, p12.PrecisionRotation

    p12.PrecisionCamera = nil
    p12.PrecisionRotation = nil

    if PrecisionCamera and PrecisionRotation and p12:IsGamepad() and p12.Precision and not p12:BlocksWorld() and PrecisionCamera == Workspace.CurrentCamera and PrecisionCamera.CameraType ~= Enum.CameraType.Scriptable then
        local _CFrame = PrecisionCamera.CFrame

        PrecisionCamera.CFrame = CFrame.new(_CFrame.Position) * PrecisionRotation:Lerp(_CFrame.Rotation, 0.3)
    end
end

function t2.SetJump(p13, p14) -- line: 100
    local JumpHeld = p13.JumpHeld
    local Humanoid = p13.Client.Humanoid
    local v6 = false

    if p14 == true then
        local v7 = p13:IsGamepad()

        if v7 then
            local v8 = not p13:BlocksWorld()

            v6 = v8 and (not p13.Controls or p13.Controls.controlsEnabled ~= false) and Humanoid ~= nil and Humanoid.Health > 0
        else
            v6 = v7
        end
    end

    p13.JumpHeld = v6

    if p13.JumpHeld then
        Humanoid.Jump = true
    elseif JumpHeld and Humanoid then
        Humanoid.Jump = false
    end
end

function t2.ApplyJump(p15) -- line: 113
    if p15.JumpHeld then
        p15:SetJump(true)
    end
end

function t2.CancelHeldInputs(p16) -- line: 117
    p16:SetJump(false)
    p16.DeleteStarted = nil
    p16.DeleteTarget = nil
    p16.DeleteProgress = 0
    p16:SetPrecision(false)
    p16:Send("RunOff")
end

function t2.SetPaused(p17, p18) -- line: 126
    -- upvalues: Workspace (copy), GuiService (copy), self (copy)
    if p18 == p17.Paused then
        return
    end

    p17.Paused = p18

    if p18 then
        p17:CancelHeldInputs()

        local CurrentCamera = Workspace.CurrentCamera

        p17.MenuCamera = CurrentCamera
        p17.MenuCameraType = CurrentCamera.CameraType
        CurrentCamera.CameraType = Enum.CameraType.Scriptable

        if p17.Controls then
            local v9 = self[p17.Controls]

            if v9 then
                v9.Connection:Disconnect()
                self[p17.Controls] = nil
                p17.DisabledControls = true
            elseif p17.Controls.controlsEnabled ~= false then
                p17.Controls:Disable()
                p17.DisabledControls = true
            end
        end

        p17.Client.Player:Move(Vector3.new(0, 0, 0), false)
    elseif p17.MenuCamera then
        local MenuCamera = p17.MenuCamera

        p17.MenuCamera = nil

        if MenuCamera.Parent and MenuCamera.CameraType == Enum.CameraType.Scriptable then
            MenuCamera.CameraType = p17.MenuCameraType or Enum.CameraType.Custom
        end

        p17.MenuCameraType = nil

        if p17.DisabledControls then
            p17.DisabledControls = nil

            local Controls = p17.Controls

            if GuiService.MenuIsOpen then
                local t7 = {}

                self[Controls] = t7
                t7.Connection = GuiService.MenuClosed:Once(function() -- line: 160
                    -- upvalues: Controls (copy), t7 (copy), self (copy)
                    if self[Controls] == t7 then
                        self[Controls] = nil
                        Controls:Enable()
                    end
                end)
            else
                Controls:Enable()
            end
        end
    end
end

function t2.SyncOwnership(p19) -- line: 173
    -- upvalues: UserInputService (copy), ContextActionService (copy), GuiService (copy), GamepadService (copy)
    if not p19:IsGamepad() then
        return
    end

    local v10 = p19:BlocksWorld()

    p19:SetPaused(v10)

    if GuiService.MenuIsOpen then
        return
    end

    local v11 = p19:PickerOpen() or p19.ExternalMenu ~= nil

    p19.Client.BuildGamepadNavigation = v11

    if p19.CursorWasNeeded ~= v11 then
        p19.CursorWasNeeded = v11

        if not v11 then
            local function v12() -- line: 42
                -- upvalues: ContextActionService (copy)
                ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
                ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
            end

            pcall(v12)
        end
    end

    if not v11 and GamepadService.GamepadCursorEnabled then
        GamepadService:DisableGamepadCursor()
    end

    if p19.Client.DeleteAllConfirmOpen then
        local v13 = p19.Client.BuildGui and p19.Client.BuildGui:FindFirstChild("DeleteAllConfirm")
        local SelectedObject = GuiService.SelectedObject

        if not (not v13 or SelectedObject and SelectedObject:IsDescendantOf(v13)) then
            local v14 = v13:FindFirstChild("Cancel", true)

            if v14 and v14:IsA("GuiButton") then
                GuiService.SelectedObject = v14
            end
        end
    end

    if not v10 then
        GuiService.SelectedObject = nil
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        UserInputService.MouseIconEnabled = false
    end
end

function t2.GetAim(p20) -- line: 202
    -- upvalues: Workspace (copy)
    local Client = p20.Client
    local CurrentCamera = Workspace.CurrentCamera
    local v15 = CurrentCamera.ViewportSize / 2
    local v16 = CurrentCamera:ViewportPointToRay(v15.X, v15.Y)
    local t8 = {
        CurrentCamera
    }

    if Client.Character then
        table.insert(t8, Client.Character)
    end

    if Client.EditObject then
        table.insert(t8, Client.EditObject)
    end

    local v17 = RaycastParams.new()

    v17.FilterType = Enum.RaycastFilterType.Exclude
    v17.FilterDescendantsInstances = t8

    local v18 = Workspace:Raycast(v16.Origin, v16.Direction * 500, v17)

    if v18 then
        return CFrame.new(v18.Position), v18.Instance
    end

    return nil, nil
end

function t2.GetDeleteTarget(p21) -- line: 218
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    return p21.Client:GetPlacedBuildObjectAtScreenPosition(CurrentCamera.ViewportSize / 2)
end

function t2.NotifySelected(p22, p23, p24) -- line: 223
    local v19

    if not p22:IsGamepad() or p22.CyclingRecent then
        return
    else
        v19 = p22.Client.ClassicBuildRecents or {}
    end

    p22.Client.ClassicBuildRecents = v19

    for i = #v19, 1, -1 do
        if v19[i] == p23 then
            table.remove(v19, i)
        end
    end

    table.insert(v19, 1, p23)

    while #v19 > 8 do
        table.remove(v19)
    end

    p22.RecentIndex = 1
    p22.LastObjectType = p24
end

function t2.ChooseItem(p25, p26, p27) -- line: 234
    -- upvalues: PaintController (ref)
    if p25.Client.Painting then
        PaintController.Close(p25.Client)
    end

    p25:CloseMenu()
    p25.Client:SelectEditObject(p26, p27)
    p25.Status = nil
    p25:RefreshPresentation()
end

function t2.CycleRecent(p28, p29) -- line: 242
    -- upvalues: ReplicatedStorage (copy), PaintController (ref), BaseObjectsLib (ref)
    local v21 = p28.Client.ClassicBuildRecents or {}

    if #v21 == 0 then
        p28:OpenCatalogue()
    else
        local v22 = p28.RecentIndex or 1

        for _ = 1, #v21 do
            v22 = (v22 - 1 + p29) % #v21 + 1

            local v23 = v21[v22]
            local v24 = BaseObjectsLib[v23]

            if v24 and ReplicatedStorage.BaseObjects:FindFirstChild(v23) and (not v24.Unlock or (p28.Client.Data.UnlockedObjects or {})[v23]) then
                if p28.Client.Painting then
                    PaintController.Close(p28.Client)
                end

                p28.CyclingRecent = true
                p28.Client:SelectEditObject(v23, v24.Type)
                p28.CyclingRecent = nil
                p28.RecentIndex = v22
                p28.Status = nil

                return
            end
        end
    end
end

function t2.CloseMenu(p30) -- line: 263
    -- upvalues: GuiService (copy)
    p30.UI:CloseMenu()
    GuiService.SelectedObject = nil
    p30:CancelHeldInputs()
    p30:SyncOwnership()
end

function t2.OpenCatalogue(p31) -- line: 270
    -- upvalues: PaintController (ref)
    if not p31:IsGamepad() then
        return
    end

    if p31:PickerOpen() then
        PaintController.ControllerClosePicker(p31.Client)
    end

    p31:CancelHeldInputs()
    p31.UI:OpenCatalogue()
    p31:SyncOwnership()
end

function t2.OpenOptions(p32) -- line: 278
    p32:CancelHeldInputs()
    p32.UI:OpenOptions(p32.Client.Painting == true)
    p32:SyncOwnership()
end

function t2.OpenRotationSteps(p33) -- line: 284
    -- upvalues: t3 (copy)
    if not p33:IsGamepad() then
        return
    end

    p33:CancelHeldInputs()
    p33.UI:OpenRotationSteps(p33.RotateStep, t3)
    p33:SyncOwnership()
end

function t2.SetRotationStep(p34, p35) -- line: 291
    -- upvalues: t3 (copy)
    if not (p34:IsGamepad() and table.find(t3, p35)) then
        return
    end

    p34.RotateStep = p35
    p34.Client.ClassicControllerRotateStep = p35

    if p34.Client.Data then
        p34.Client.Data.ClassicControllerRotateStep = p35
    end

    p34.Remote:FireServer("ChangeClassicControllerRotateStep", p35)
    p34.Status = nil
    p34:CloseMenu()
    p34:RefreshPresentation()
end

function t2.Exit(p36) -- line: 302
    if p36.Client.EditingBase then
        p36.Client:StopEditStorage()
    elseif p36.Client.Painting then
        p36.Client:ClosePaintFrames()
    else
        p36.Client:EndBuildMode()
    end
end

function t2.OpenLegacyPanel(p37, p38) -- line: 308
    -- upvalues: UserInputService (copy), ContextActionService (copy), GuiService (copy), GamepadService (copy), v2 (copy)
    local Client = p37.Client

    p37:Exit()

    if Client.ClassicReturnCleanup then
        Client.ClassicReturnCleanup(false)
    end

    if p38 == "Customize" then
        Client:OpenCustomizeBase()
    else
        Client:OpenBaseSlots()
    end

    local BaseCustomization = p38 == "Customize" and Client.HUD.BaseCustomization or Client.HUD.BaseSlots

    if not (BaseCustomization and BaseCustomization.Visible) then
        return
    end

    local Enabled = Client.MainContext.Enabled

    Client.MainContext.Enabled = false

    local t9 = {}
    local v25 = false

    local function cleanup(p39) -- line: 318
        -- upvalues: Client (copy), Enabled (copy), t9 (copy), v25 (ref), UserInputService (copy), ContextActionService (copy), GuiService (copy), GamepadService (copy)
        if v25 then
            return
        end

        v25 = true

        for _, v26 in ipairs(t9) do
            v26:Disconnect()
        end

        ContextActionService:UnbindAction("ClassicBuildExternalBack")
        Client.ClassicReturnCleanup = nil
        Client.MainContext.Enabled = Enabled
        GuiService.SelectedObject = nil

        if GamepadService.GamepadCursorEnabled then
            GamepadService:DisableGamepadCursor()
        end

        task.defer(function() -- line: 327
            -- upvalues: p39 (copy), Client (copy), UserInputService (copy)
            if p39 and UserInputService.GamepadEnabled and UserInputService.PreferredInput == Enum.PreferredInput.Gamepad and Client.Player:GetAttribute("InBase") and Client.Humanoid and Client.Humanoid.Health > 0 and not Client.EditingBase and not Client.CustomizingBase and not Client.InBaseSlots and not Client.Painting then
                Client:EditStorage()
            end
        end)
    end

    Client.ClassicReturnCleanup = cleanup
    table.insert(t9, BaseCustomization:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 335
        -- upvalues: BaseCustomization (copy), cleanup (copy)
        if not BaseCustomization.Visible then
            cleanup(true)
        end
    end))
    table.insert(t9, Client.Player.CharacterRemoving:Connect(function() -- line: 338
        -- upvalues: cleanup (copy)
        cleanup(false)
    end))
    table.insert(t9, UserInputService.GamepadDisconnected:Connect(function() -- line: 339
        -- upvalues: cleanup (copy)
        cleanup(false)
    end))
    ContextActionService:BindActionAtPriority("ClassicBuildExternalBack", function(_, p41) -- line: 340
        -- upvalues: p38 (copy), Client (copy), UserInputService (copy), GuiService (copy)
        if GuiService.MenuIsOpen then
            return Enum.ContextActionResult.Pass
        end

        if p41 == Enum.UserInputState.Begin then
            if UserInputService:GetFocusedTextBox() then
                UserInputService:GetFocusedTextBox():ReleaseFocus()
            elseif p38 == "Customize" then
                Client:CloseCustomizeBase()
            elseif Client.BaseSlotConfirmAction then
                Client:CloseBaseSlotConfirmation()
            else
                Client:CloseBaseSlots()
            end
        end

        return Enum.ContextActionResult.Sink
    end, false, v2, Enum.KeyCode.ButtonB)
    GamepadService:EnableGamepadCursor((BaseCustomization:FindFirstChildWhichIsA("GuiButton", true)))
end

function t2.Option(p42, p43) -- line: 354
    -- upvalues: PaintController (ref)
    local Client = p42.Client

    if p43 == "Catalogue" then
        p42:OpenCatalogue()
    elseif p43 == "RotationSteps" then
        p42:OpenRotationSteps()
    elseif p43 == "DeleteAll" then
        if p42:IsGamepad() and Client.EditingBase then
            p42:CloseMenu()

            if Client.Painting then
                PaintController.Close(Client)
            end

            if p42:IsGamepad() then
                Client:SetDeleteAllConfirmation(true)
                p42:SyncOwnership()
                p42:RefreshPresentation()
            end
        end
    else
        p42:CloseMenu()

        if p43 ~= "Resume" then
            if p43 == "Exit" then
                p42:Exit()
            elseif p43 == "SwitchModern" then
                if Client.Painting then
                    PaintController.Close(Client)
                end

                if Client.BuildCameraActive then
                    Client:SetBuildSystem("Modern", true)
                elseif Client:SetBuildSystem("Modern") then
                    Client:EditStorage()
                end
            elseif p43 == "Customize" or p43 == "SaveSlots" then
                p42:OpenLegacyPanel(p43)
            else
                if p43 ~= "Brush" and p43 ~= "Bucket" and p43 ~= "Dropper" and p43 ~= "ColourPicker" then
                    return
                end

                if not Client.Painting then
                    Client:OpenPaintFrames()
                end

                if Client.Painting then
                    if p43 == "ColourPicker" then
                        PaintController.ControllerPicker(Client)
                    else
                        PaintController.ControllerTool(Client, ({
                            Brush = "PaintBrush",
                            Bucket = "PaintBucket",
                            Dropper = "ColorDropper"
                        })[p43])
                    end

                    p42:SyncOwnership()
                end
            end
        end
    end
end

function t2.CanPlace(p44) -- line: 393
    -- upvalues: BaseObjectsLib (ref)
    if p44.Client.CanPlaceClassicBuildObject then
        return p44.Client:CanPlaceClassicBuildObject()
    end

    local Client = p44.Client
    local EditObject = Client.EditObject

    if not EditObject then
        return false, "Open the catalogue to choose an object"
    end

    local Aim = p44:GetAim()

    if not Aim then
        return false, "Aim at a surface inside your base"
    end

    EditObject:PivotTo(Client:CalcPlacementCFrame(Aim.Position))

    if not Client:IsBuildObjectInBounds(EditObject) then
        return false, "Keep the whole object inside your base"
    end

    if Client:HasBuildObjectAtCFrame(EditObject:GetPivot()) then
        return false, "An object already occupies this position"
    end

    local v32 = BaseObjectsLib[EditObject.Name]
    local v33 = Client.Data or {}

    if v32 then
        if v32.ItemObject and ((v33.BaseItems or {})[EditObject.Name] or 0) < 1 then
            return false, "No copies remaining"
        end

        if not v32.ItemObject and (tonumber(v33.Money) or 0) < (tonumber(v32.Price) or 0) then
            return false, "Not enough money"
        end
    end

    return true
end

function t2.Primary(p45) -- line: 412
    -- upvalues: PaintController (ref)
    if p45:BlocksWorld() then
        return
    end

    if p45.Client.Painting then
        PaintController.ControllerApply(p45.Client)
    elseif p45.Client.DeletingObjects then
        p45.DeleteTarget = p45:GetDeleteTarget()
        p45.DeleteStarted = p45.DeleteTarget and os.clock() or nil
        p45.DeleteProgress = 0
    elseif not (os.clock() - (p45.LastPlace or 0) < 0.2) then
        local v35, v36 = p45:CanPlace()

        if v35 then
            p45.LastPlace = os.clock()
            p45.Client:PlaceClassicBuildObject()
            p45.Status = nil
        else
            p45.Status = v36
        end
    end
end

function t2.Back(p46) -- line: 433
    -- upvalues: PaintController (ref)
    if p46.Client.DeleteAllConfirmOpen then
        p46.Client:SetDeleteAllConfirmation(false)
        p46:SyncOwnership()
        p46:RefreshPresentation()
    elseif p46:PickerOpen() then
        PaintController.ControllerClosePicker(p46.Client)
        p46:SyncOwnership()
    elseif p46.UI.MenuOpen then
        if p46.UI.MenuKind == "RotationSteps" then
            p46:OpenOptions()
        else
            p46:CloseMenu()
        end
    elseif p46.Client.Painting then
        PaintController.Close(p46.Client)
        p46:SyncOwnership()
    elseif p46.Client.DeletingObjects then
        p46.Client:SetDeletingObjects(false)
    elseif p46.Client.EditObject then
        p46.Client:DeleteEditObject()
    else
        p46:Exit()
    end
end

function t2.HandleInput(p47, _, p49, p50) -- line: 452
    -- upvalues: UserInputService (copy), GuiService (copy), PaintController (ref)
    if not p47:IsGamepad() then
        return Enum.ContextActionResult.Pass
    end

    local KeyCode = p50.KeyCode
    local v37 = p49 == Enum.UserInputState.Begin
    local v38 = p49 == Enum.UserInputState.End or p49 == Enum.UserInputState.Cancel
    local v39 = p47.HeldInputs[KeyCode]

    if v38 then
        p47.HeldInputs[KeyCode] = nil

        if KeyCode == Enum.KeyCode.ButtonA then
            p47.DeleteStarted = nil
            p47.DeleteTarget = nil
            p47.DeleteProgress = 0
        end

        if KeyCode == Enum.KeyCode.ButtonL1 then
            p47:SetPrecision(false)
        end

        if KeyCode == Enum.KeyCode.ButtonR1 then
            p47:SetJump(false)
        end

        if KeyCode == Enum.KeyCode.ButtonL3 and p47.Client.Data.HoldToSprint then
            p47:Send("RunOff")
        end
    elseif v37 then
        p47.HeldInputs[KeyCode] = true
    end

    if KeyCode == Enum.KeyCode.ButtonA then
        local MenuPrimary = p47.MenuPrimary

        if not MenuPrimary then
            MenuPrimary = p47.UI.MenuOpen

            if not MenuPrimary then
                MenuPrimary = p47:PickerOpen()

                if not MenuPrimary then
                    MenuPrimary = p47.ExternalMenu ~= nil or GuiService.MenuIsOpen or p47.Client.DeleteAllConfirmOpen == true
                end
            end
        end

        if MenuPrimary then
            p47.MenuPrimary = not v38

            return Enum.ContextActionResult.Pass
        end
    end

    if GuiService.MenuIsOpen then
        return Enum.ContextActionResult.Pass
    end

    if UserInputService:GetFocusedTextBox() then
        if v37 and KeyCode == Enum.KeyCode.ButtonB then
            UserInputService:GetFocusedTextBox():ReleaseFocus()
        end

        return Enum.ContextActionResult.Sink
    end

    if p47.Client.DeleteAllConfirmOpen then
        local v40 = if v37 then KeyCode == Enum.KeyCode.ButtonB else nil

        if not v37 or not v40 then
            if KeyCode ~= Enum.KeyCode.DPadLeft and KeyCode ~= Enum.KeyCode.DPadRight and KeyCode ~= Enum.KeyCode.DPadUp and KeyCode ~= Enum.KeyCode.DPadDown then
                return Enum.ContextActionResult.Sink
            end

            return Enum.ContextActionResult.Pass
        end

        p47:Back()

        return Enum.ContextActionResult.Sink
    end

    if p47.UI.MenuOpen and (KeyCode == Enum.KeyCode.DPadLeft or KeyCode == Enum.KeyCode.DPadRight or KeyCode == Enum.KeyCode.DPadUp or KeyCode == Enum.KeyCode.DPadDown) or p47:PickerOpen() and KeyCode ~= Enum.KeyCode.ButtonB then
        return Enum.ContextActionResult.Pass
    end

    if not v37 then
        return Enum.ContextActionResult.Sink
    end

    if KeyCode == Enum.KeyCode.ButtonB then
        p47:Back()

        return Enum.ContextActionResult.Sink
    end

    if p47.UI.MenuOpen then
        if KeyCode == Enum.KeyCode.ButtonY then
            p47:CloseMenu()
        elseif KeyCode == Enum.KeyCode.ButtonL1 then
            p47.UI:ChangeCategory(-1)
        elseif KeyCode == Enum.KeyCode.ButtonR1 then
            p47.UI:ChangeCategory(1)
        end

        return Enum.ContextActionResult.Sink
    end

    if p47:BlocksWorld() or v39 and (KeyCode == Enum.KeyCode.ButtonA or KeyCode == Enum.KeyCode.ButtonR2 or KeyCode == Enum.KeyCode.ButtonL2 or KeyCode == Enum.KeyCode.ButtonR1) then
        return Enum.ContextActionResult.Sink
    end

    if KeyCode == Enum.KeyCode.ButtonY then
        p47:OpenCatalogue()
    elseif KeyCode == Enum.KeyCode.DPadUp then
        p47:OpenOptions()
    elseif KeyCode == Enum.KeyCode.ButtonA then
        p47:Primary()
    elseif KeyCode == Enum.KeyCode.ButtonL1 then
        p47:SetPrecision(true)
    elseif KeyCode == Enum.KeyCode.ButtonR1 then
        p47:SetJump(true)
    elseif KeyCode == Enum.KeyCode.ButtonL2 or KeyCode == Enum.KeyCode.ButtonR2 then
        if not (p47.Client.Painting or p47.Client.DeletingObjects) then
            p47.Client:RotateClassicBuildObject(p47.Axis, KeyCode == Enum.KeyCode.ButtonL2 and -1 or 1, p47.RotateStep)
        end
    elseif KeyCode == Enum.KeyCode.ButtonX then
        p47.Axis = ({
            Y = "X",
            X = "Z",
            Z = "Y"
        })[p47.Axis]
    elseif KeyCode == Enum.KeyCode.DPadLeft then
        p47:CycleRecent(-1)
    elseif KeyCode == Enum.KeyCode.DPadRight then
        p47:CycleRecent(1)
    elseif KeyCode == Enum.KeyCode.DPadDown then
        if p47.Client.Painting then
            PaintController.Close(p47.Client)
        end

        p47:CancelHeldInputs()
        p47.Client:SetDeletingObjects(not p47.Client.DeletingObjects)
    elseif KeyCode == Enum.KeyCode.ButtonL3 then
        if p47.Client.Data.HoldToSprint or not p47.Client.Character:GetAttribute("Running") then
            p47:Send("Run")
        else
            p47:Send("RunOff")
        end
    else
        if KeyCode ~= Enum.KeyCode.ButtonR3 then
            p47:RefreshPresentation()

            return Enum.ContextActionResult.Sink
        end

        p47:Send("Crouch")
    end

    p47:RefreshPresentation()

    return Enum.ContextActionResult.Sink
end

function t2.SaveAndHide(p51, p52) -- line: 534
    if not (p52 and p52:IsA("GuiObject")) then
        return
    end

    if p51.Hidden[p52] == nil then
        p51.Hidden[p52] = p52.Visible
    end

    p52.Visible = false
end

function t2.RefreshPresentation(p53) -- line: 540
    if p53:IsGamepad() then
        local Client = p53.Client

        for _, v41 in ipairs({ "BaseObjects", "BaseEdit", "PaintEditBar", "MobileEdits", "MobileMouse", "Crosshair" }) do
            p53:SaveAndHide(Client.HUD:FindFirstChild(v41))
        end

        if Client.BuildGui then
            for _, v42 in ipairs({ "Toolbar", "TransformPanel", "ViewPanel", "Hint", "ControllerHotkeys", "BuildSystemToggle" }) do
                p53:SaveAndHide(Client.BuildGui:FindFirstChild(v42))
            end
        end

        local EditObject = Client.EditObject
        local UI = p53.UI
        local v43, v44

        if EditObject then
            local Name = EditObject.Name

            if Name then
                v43 = Name
                v44 = true
            elseif Client.Painting then
                local PaintMode = Client.PaintMode

                if PaintMode then
                    v43 = PaintMode
                    v44 = true
                else
                    v44 = false
                end
            else
                v44 = false
            end
        elseif Client.Painting then
            local PaintMode = Client.PaintMode

            if PaintMode then
                v43 = PaintMode
                v44 = true
            else
                v44 = false
            end
        else
            v44 = false
        end

        if not v44 then
            v43 = nil
        end

        UI:Update({
            itemName = v43,
            axis = p53.Axis,
            precision = p53.Precision == true,
            rotateStep = p53.RotateStep,
            deleting = Client.DeletingObjects == true,
            deleteProgress = p53.DeleteProgress or 0,
            status = p53.Status,
            mode = Client.Painting and "Paint" or "Objects",
            recents = Client.ClassicBuildRecents or {},
            recentIndex = p53.RecentIndex or 1
        })

        local v45 = not p53:BlocksWorld()

        p53.UI.HUD.Visible = v45
        p53.UI.Reticle.Visible = v45

        if not v45 then
            p53.UI.Progress.Visible = false
        end
    end
end

function t2.Step(p54, p55) -- line: 565
    if p54:IsGamepad() then
        if p54.Client.ClassicBuildActive then
            p54:SyncOwnership()

            if p54:BlocksWorld() then
                p54.DeleteStarted = nil
                p54.DeleteTarget = nil
                p54.DeleteProgress = 0
            elseif p54.DeleteStarted then
                local DeleteTarget = p54:GetDeleteTarget()

                if DeleteTarget == p54.DeleteTarget and DeleteTarget and DeleteTarget.Parent then
                    p54.DeleteProgress = math.clamp((os.clock() - p54.DeleteStarted) / 0.4, 0, 1)

                    if p54.DeleteProgress >= 1 then
                        p54.Client:DeleteClassicBuildTarget()
                        p54.DeleteStarted = nil
                        p54.DeleteTarget = nil
                        p54.DeleteProgress = 0
                    end
                else
                    p54.DeleteStarted = nil
                    p54.DeleteTarget = nil
                    p54.DeleteProgress = 0
                end
            end

            p54.RefreshElapsed = (p54.RefreshElapsed or 0) + p55

            if p54.RefreshElapsed >= 0.08 then
                p54.RefreshElapsed = 0

                if not p54:BlocksWorld() and p54.Client.EditObject and not p54.Client.Painting then
                    local v47, v48 = p54:CanPlace()

                    if v47 then
                        p54.Status = nil

                        local Highlight = p54.Client.EditObject:FindFirstChildOfClass("Highlight")

                        if Highlight then
                            Highlight.FillColor = Color3.fromRGB(100, 220, 160) or Color3.fromRGB(255, 100, 110)
                            Highlight.OutlineColor = Highlight.FillColor
                        end
                    else
                        p54.Status = v48 or nil

                        local Highlight = p54.Client.EditObject:FindFirstChildOfClass("Highlight")

                        if Highlight then
                            Highlight.FillColor = Color3.fromRGB(255, 100, 110)
                            Highlight.OutlineColor = Highlight.FillColor
                        end
                    end
                end

                p54:RefreshPresentation()
            end
        else
            p54:Destroy()
        end
    end
end

function t2.SetActive(p56, p57) -- line: 602
    -- upvalues: UserInputService (copy), ContextActionService (copy), GuiService (copy), GamepadService (copy), v2 (copy), t6 (copy)
    if p56.Destroyed or p57 == p56.Active then
        return
    end

    if p57 then
        if p56.Client.ClassicMobile and p56.Client.ClassicMobile:IsActive() then
            p56.Client.ClassicMobile:SetActive(false)
        end

        p56.Active = true
        p56.SavedContext = p56.Client.MainContext.Enabled
        p56.SavedAutoSelect = GuiService.AutoSelectGuiEnabled
        p56.SavedFreeMouse = p56.Client.FreeMouse
        p56.SavedMouseBehavior = UserInputService.MouseBehavior
        p56.SavedMouseIcon = UserInputService.MouseIconEnabled
        p56.Client.MainContext.Enabled = false
        p56.Client.FreeMouse = false

        local function v49() -- line: 42
            -- upvalues: ContextActionService (copy)
            ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
            ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
        end

        pcall(v49)
        GuiService.AutoSelectGuiEnabled = false
        GuiService.SelectedObject = nil
        p56:Send("M1U")
        p56:Send("M2U")
        p56:Send("BlockOff")
        p56:Send("RunOff")
        ContextActionService:BindActionAtPriority("ClassicBuildControllerActions", function(...) -- line: 618
            -- upvalues: p56 (copy)
            return p56:HandleInput(...)
        end, false, v2, table.unpack(t6))
        p56.UI:SetActive(true)
        p56:SyncOwnership()
        p56:RefreshPresentation()
        p56:OpenCatalogue()
    else
        p56:CancelHeldInputs()
        p56.HeldInputs = {}
        p56.MenuPrimary = nil
        p56.UI:CloseMenu()

        if p56.Client.DeleteAllConfirmOpen then
            p56.Client:SetDeleteAllConfirmation(false)
        end

        p56:SetPaused(false)
        ContextActionService:UnbindAction("ClassicBuildControllerActions")

        local function v51() -- line: 42
            -- upvalues: ContextActionService (copy)
            ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
            ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
        end

        pcall(v51)
        GuiService.SelectedObject = nil

        if GamepadService.GamepadCursorEnabled then
            GamepadService:DisableGamepadCursor()
        end

        p56.Client.BuildGamepadNavigation = false
        GuiService.AutoSelectGuiEnabled = p56.SavedAutoSelect
        p56.Client.MainContext.Enabled = p56.SavedContext
        p56.Client.FreeMouse = p56.SavedFreeMouse
        UserInputService.MouseBehavior = p56.SavedMouseBehavior
        UserInputService.MouseIconEnabled = p56.SavedMouseIcon

        for v52, v53 in pairs(p56.Hidden) do
            if v52.Parent then
                v52.Visible = v53
            end
        end

        p56.Hidden = {}
        p56.Active = false
        p56.UI:SetActive(false)

        if p56.Client.ClassicBuildActive then
            p56.Client:ApplyClassicBuildPresentation()
        end
    end
end

function t2.Destroy(p58) -- line: 648
    -- upvalues: RunService (copy)
    if p58.Destroyed then
        return
    end

    if p58.Active then
        p58:SetActive(false)
    end

    p58.Destroyed = true
    p58.PrecisionCamera = nil
    p58.PrecisionRotation = nil

    if p58.JumpStep then
        RunService:UnbindFromRenderStep(p58.JumpStep)
    end

    if p58.PrecisionCaptureStep then
        RunService:UnbindFromRenderStep(p58.PrecisionCaptureStep)
    end

    if p58.PrecisionApplyStep then
        RunService:UnbindFromRenderStep(p58.PrecisionApplyStep)
    end

    for _, v54 in ipairs(p58.Connections) do
        v54:Disconnect()
    end

    p58.Connections = {}
    p58.UI:Destroy()
end

function t2.Start(p59) -- line: 662
    -- upvalues: _require (copy), v1 (copy), ReplicatedStorage (copy), UserInputService (copy), GuiService (copy), GamepadService (copy), RunService (copy), UI (copy), t2 (copy), t3 (copy)
    local v55 = p59.Data and p59.Data.ClassicControllerRotateStep
    local v56, v57

    if table.find(t3, p59.ClassicControllerRotateStep) then
        local ClassicControllerRotateStep = p59.ClassicControllerRotateStep

        if ClassicControllerRotateStep then
            v56 = ClassicControllerRotateStep
            v57 = true
        elseif table.find(t3, v55) and v55 then
            v56 = v55
            v57 = true
        else
            v57 = false
        end
    elseif table.find(t3, v55) and v55 then
        v56 = v55
        v57 = true
    else
        v57 = false
    end

    if not v57 then
        v56 = 90
    end

    local v58 = setmetatable({
        Active = false,
        Axis = "Y",
        RecentIndex = 1,
        Client = p59,
        Connections = {},
        Hidden = {},
        HeldInputs = {},
        RotateStep = v56
    }, t2)

    v58.Remote = ReplicatedStorage.Remotes.RemoteEvent

    local PlayerScripts = p59.Player:FindFirstChild("PlayerScripts")
    local PlayerModule = PlayerScripts and PlayerScripts:FindFirstChild("PlayerModule")

    if PlayerModule then
        local function v59() -- line: 671
            -- upvalues: PlayerModule (copy), _require (copy), v1 (copy)
            local v60 = PlayerModule

            if type(PlayerModule) ~= "table" then
                v60 = if PlayerModule == v1.PlayerModule then v1.PlayerModuleValue else _require(PlayerModule)
            end

            return v60:GetControls()
        end

        local ok, result = pcall(v59)

        if ok then
            v58.Controls = result
        end
    end

    v58.UI = UI.new(p59, {
        SelectItem = function(p60, p61) -- SelectItem | line: 675
            -- upvalues: v58 (copy)
            v58:ChooseItem(p60, p61)
        end,
        Close = function() -- Close | line: 676
            -- upvalues: v58 (copy)
            v58:CloseMenu()
        end,
        Option = function(p62) -- Option | line: 677
            -- upvalues: v58 (copy)
            v58:Option(p62)
        end,
        RotationStep = function(p63) -- RotationStep | line: 678
            -- upvalues: v58 (copy)
            v58:SetRotationStep(p63)
        end
    })

    local function connect(p64, p65) -- line: 680
        -- upvalues: v58 (copy)
        table.insert(v58.Connections, p64:Connect(p65))
    end

    local PreferredInput = UserInputService:GetPropertyChangedSignal("PreferredInput")

    local function v61() -- line: 681
        -- upvalues: v58 (copy), UserInputService (copy)
        v58:SetActive(UserInputService.GamepadEnabled and UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)
    end

    table.insert(v58.Connections, PreferredInput:Connect(v61))

    local GamepadConnected = UserInputService.GamepadConnected

    local function v62() -- line: 682
        -- upvalues: v58 (copy), UserInputService (copy)
        v58:SetActive(UserInputService.GamepadEnabled and UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)
    end

    table.insert(v58.Connections, GamepadConnected:Connect(v62))

    local GamepadDisconnected = UserInputService.GamepadDisconnected

    local function v63() -- line: 683
        -- upvalues: v58 (copy), UserInputService (copy)
        v58:SetActive(UserInputService.GamepadEnabled and UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)
    end

    table.insert(v58.Connections, GamepadDisconnected:Connect(v63))

    local GamepadCursorEnabled = GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled")

    local function v64() -- line: 684
        -- upvalues: v58 (copy), GuiService (copy), GamepadService (copy)
        if v58:IsGamepad() and GamepadService.GamepadCursorEnabled and not v58:PickerOpen() and not GuiService.MenuIsOpen then
            task.defer(function() -- line: 686
                -- upvalues: v58 (copy)
                if v58:IsGamepad() then
                    v58:SyncOwnership()
                end
            end)
        end
    end

    table.insert(v58.Connections, GamepadCursorEnabled:Connect(v64))

    local MenuOpened = GuiService.MenuOpened

    local function v65() -- line: 689
        -- upvalues: v58 (copy)
        if v58:IsGamepad() then
            v58:CancelHeldInputs()
            v58:SyncOwnership()
        end
    end

    table.insert(v58.Connections, MenuOpened:Connect(v65))

    local MenuClosed = GuiService.MenuClosed

    local function v66() -- line: 690
        -- upvalues: v58 (copy)
        if v58:IsGamepad() then
            v58:SyncOwnership()

            if v58.UI.MenuOpen then
                v58.UI:FocusDefault()
            end
        end
    end

    table.insert(v58.Connections, MenuClosed:Connect(v66))

    local WindowFocusReleased = UserInputService.WindowFocusReleased

    local function v67() -- line: 696
        -- upvalues: v58 (copy)
        if not v58:IsGamepad() then
            return
        end

        v58:CancelHeldInputs()
        v58.HeldInputs = {}
        v58.MenuPrimary = nil
    end

    table.insert(v58.Connections, WindowFocusReleased:Connect(v67))

    local TextBoxFocused = UserInputService.TextBoxFocused

    local function v68() -- line: 703
        -- upvalues: v58 (copy)
        if v58:IsGamepad() then
            v58:CancelHeldInputs()
            v58:SyncOwnership()
        end
    end

    table.insert(v58.Connections, TextBoxFocused:Connect(v68))
    v58.JumpStep = "ClassicBuildJump_" .. tostring(v58)
    RunService:BindToRenderStep(v58.JumpStep, Enum.RenderPriority.Input.Value + 1, function() -- line: 706
        -- upvalues: v58 (copy)
        v58:ApplyJump()
    end)
    v58.PrecisionCaptureStep = "ClassicBuildPrecisionCapture_" .. tostring(v58)
    v58.PrecisionApplyStep = "ClassicBuildPrecisionApply_" .. tostring(v58)
    RunService:BindToRenderStep(v58.PrecisionCaptureStep, Enum.RenderPriority.Camera.Value - 1, function() -- line: 711
        -- upvalues: v58 (copy)
        v58:CapturePrecisionCamera()
    end)
    RunService:BindToRenderStep(v58.PrecisionApplyStep, Enum.RenderPriority.Camera.Value + 1, function() -- line: 714
        -- upvalues: v58 (copy)
        v58:ApplyPrecisionCamera()
    end)

    local RenderStepped = RunService.RenderStepped

    local function v72(p66) -- line: 717
        -- upvalues: v58 (copy)
        v58:Step(p66)
    end

    table.insert(v58.Connections, RenderStepped:Connect(v72))
    v58:SetActive(UserInputService.GamepadEnabled and UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)

    return v58
end

return t2
