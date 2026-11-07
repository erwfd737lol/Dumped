
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local v1 = nil

local function FireServer(a0, a1, ...) --[[ Upvalues: v1 (ref) ]]
    if v1 then
        local t1 = {...}
        local t2 = {kind = "RemoteCaptured", action = a1, args = t1}
        table.insert(v1.Events, t2)
    end
end

local v2 = {FireServer = FireServer}

local function HideResetConfirmation(a0)
    a0.PaintResetConfirmOpen = nil
end

HideResetConfirmation = {0.1, 0.25, 0.5, 1, 2, 5}
local v3 = {5, 15, 30, 45, 90}
local v4 = Color3.fromRGB(42, 170, 255)
local v5 = Color3.fromRGB(0, 0, 0)
local v6 = Color3.fromRGB(82, 218, 126)
local v7 = Color3.fromRGB(255, 91, 91)

local function styleBuildButton(a0, a1, a2) --[[ Upvalues: v5 (copy) ]]
    a0.BackgroundColor3 = v5
    a0.BackgroundTransparency = 0.5
    a0.BorderColor3 = Color3.new(1, 1, 1)
    local v8
    if a1 then
        v8 = 3
    else
        v8 = 1
    end

    a0.BorderSizePixel = v8
    if a0:IsA("TextButton") then
        local v11 = a2 or Color3.new(1, 1, 1)
        a0.TextColor3 = v11
    end
end

local function usingBuildController() --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    local v12 = GuiService:IsTenFootInterface()
    if not v12 then
        local GamepadEnabled = UserInputService.GamepadEnabled
        if GamepadEnabled then
            GamepadEnabled = not UserInputService.KeyboardEnabled
            if not GamepadEnabled then
                GamepadEnabled = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
            end
        end
    end

    return v12
end

local function buildSnap(a0, a1)
    if not a1 or a1 <= 0 then
        return a0
    end

    return math.round(a0 / a1) * a1
end

local function buildFormatNumber(a0)
    local v13 = math.abs(a0 - math.round(a0))
    if v13 < 0.001 then
        return tostring(math.round(a0))
    end

    local v14 = string.format("%.2f", a0)
    local v15 = v14:gsub("0+$", "")
    local v16 = v15:gsub("%.$", "")
    return v16
end

local function findBuildMobileCameraControls(a0)
    if not a0 then
        return nil
    end

    local v17 = a0:FindFirstChild("MobileCameraContols") or a0:FindFirstChild("MobileCameraControls")
    return v17
end

local function IsClassicBuildSystem(a0)
    local v18 = false
    if a0.Data ~= nil then
        v18 = a0.Data.BuildSystem == "Classic"
    end

    return v18
end

local function UpdateBuildSystem(a0)
    local v19 = a0:IsClassicBuildSystem()
    local BuildSystem = a0.HUD.Settings.Main:FindFirstChild("BuildSystem")
    if BuildSystem then
        local v20
        if v19 then
            v20 = "Building: Classic"
        else
            v20 = "Building: Modern"
        end

        BuildSystem.Text = v20
    end

    local v21 = a0.BuildGui and a0.BuildGui:FindFirstChild("BuildSystemToggle")
    if v21 then
        local v22
        if v19 then
            v22 = "System: Classic"
        else
            v22 = "System: Modern"
        end

        v21.Text = v22
    end
end

local function UpdateBuildGui(a0) --[[ Upvalues: styleBuildButton (copy), buildFormatNumber (copy), v7 (copy), GuiService (copy), UserInputService (copy) ]]
    local BuildGui = a0.BuildGui
    if not BuildGui then
        return
    end

    a0:UpdateBuildSystem()
    if a0.ModernController and a0.ModernController:IsGamepad() then
        a0:UpdateStorageCapacity()
        a0.ModernController:RefreshPresentation()
        return
    end

    local BuildSystemToggle1 = BuildGui:FindFirstChild("BuildSystemToggle")
    if BuildSystemToggle1 then
        local v23 = false
        if a0.BuildCameraActive == true then
            v23 = false
            if a0.BuildModeKind == "Objects" then
                v23 = not a0.Painting
            end
        end

        local v26 = v23 and not a0.BuildSystemSwitching
        BuildSystemToggle1.Visible = v23
        BuildSystemToggle1.Active = v26
        BuildSystemToggle1.Interactable = v26
    end

    if a0.ClassicBuildActive then
        a0:ApplyClassicBuildPresentation()
        a0:UpdateStorageCapacity()
        return
    end

    local Buttons = BuildGui.Toolbar.Buttons
    local v27 = a0.BuildTransformMode ~= "Rotate"
    styleBuildButton(Buttons.MoveMode, v27)
    styleBuildButton(Buttons.RotateMode, not v27)
    local v28
    if a0.BuildGridEnabled then
        v28 = "Grid: On"
    else
        v28 = "Grid: Off"
    end

    Buttons.Grid.Text = v28
    Buttons.MoveStep.Text = "Move " .. buildFormatNumber(a0.BuildMoveStep or 0.5)
    local v29 = buildFormatNumber(a0.BuildRotateStep or 15)
    Buttons.RotateStep.Text = "Rotate " .. v29 .. "\194\176"
    if a0.EditingExistingObject then
        v28 = "Save Move"
    else
        v28 = "Place"
    end

    Buttons.Place.Text = "Rotate " .. v29 .. "\194\176"
    a0:UpdateBuildGridLabel()
    local DeleteMode = Buttons:FindFirstChild("DeleteMode")
    if DeleteMode then
        local v30
        if a0.DeletingObjects then
            v30 = "Delete: On"
        else
            v30 = "Delete: Off"
        end

        DeleteMode.Text = v30
        styleBuildButton(DeleteMode, a0.DeletingObjects, a0.DeletingObjects and v7 or nil)
    end

    local PaintMode = Buttons:FindFirstChild("PaintMode")
    if PaintMode then
        local v33 = false
        if a0.BuildModeKind == "Paint" then
            v33 = a0.Painting
        end

        local v34
        if v33 then
            v34 = "Objects"
        else
            v34 = "Paint"
        end

        PaintMode.Text = v34
        styleBuildButton(PaintMode, v33)
    end

    local ControllerHotkeys = BuildGui:FindFirstChild("ControllerHotkeys")
    if ControllerHotkeys then
        local v35 = false
        if a0.BuildModeKind == "Objects" then
            local v36 = GuiService:IsTenFootInterface()
            if not v36 then
                local GamepadEnabled1 = UserInputService.GamepadEnabled
                if GamepadEnabled1 then
                    GamepadEnabled1 = not UserInputService.KeyboardEnabled
                    if not GamepadEnabled1 then
                        GamepadEnabled1 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
                    end
                end
            end
        end

        ControllerHotkeys.Visible = v35
        if v27 then
            v35 = "Move / Grid " .. buildFormatNumber(a0.BuildMoveStep or 0.5)
            if v35 then
                -- jump to 248
            end
        end

        local v37 = buildFormatNumber(a0.BuildRotateStep or 15)
        v35 = "Rotate " .. v37 .. "\194\176"
        local v38 = buildFormatNumber(a0.BuildRotateStep or 15)
        ControllerHotkeys.Text = "D-PAD  \226\134\147 Exit  \194\183  \226\134\146 Mode  \194\183  \226\134\144 " .. v35 .. "  \194\183  \226\134\145 Paint  \194\183  R2 Rotate " .. v38 .. "\194\176"
    end

    local CameraLock = Buttons:FindFirstChild("CameraLock")
    if CameraLock then
        local v39
        if a0.BuildCameraLocked then
            v39 = "Cam: Locked"
        else
            v39 = "Cam: Free"
        end

        CameraLock.Text = v39
        styleBuildButton(CameraLock, a0.BuildCameraLocked)
    end

    local Title = BuildGui.TransformPanel.Title
    if v27 then
        local v40 = buildFormatNumber(a0.BuildMoveStep or 0.5)
        local v41 = "MOVE \194\183 " .. v40 .. " STUD"
        if v41 then
            -- jump to 305
        end
    end

    local v42 = buildFormatNumber(a0.BuildRotateStep or 15)
    local v43 = "ROTATE \194\183 " .. v42 .. "\194\176"
    Title.Text = v43
    if a0.BuildModeKind == "Paint" then
        if a0.TouchEnabled then
            if a0.BuildCameraLocked then
                v43 = "CAMERA LOCKED \194\183 Tap to paint \194\183 Use Cam: Locked to unlock"
            else
                v43 = "Tap to paint \194\183 Camera arrows move \194\183 Drag to look \194\183 Pinch to zoom"
            end

            BuildGui.Hint.Text = v43
            -- jump to 494 (out of range)
        end

        if not UserInputService.GamepadEnabled or UserInputService.KeyboardEnabled then
            if not GuiService:IsTenFootInterface() then
                -- jump to 364
            end
        end

        if a0.BuildGamepadNavigation then
            if a0.BuildCameraLocked then
                v43 = "CAMERA LOCKED \194\183 FREE CURSOR \194\183 A paint/select UI \194\183 L3 unlock \194\183 D-pad tools"
            else
                v43 = "CURSOR MODE \194\183 A paint/select UI \194\183 L3 lock camera \194\183 R3 camera \194\183 D-pad tools"
            end

            BuildGui.Hint.Text = v43
            -- jump to 494 (out of range)
        end

        if a0.BuildCameraLocked then
            v43 = "CAMERA LOCKED \194\183 L3 unlock \194\183 R3 cursor \194\183 D-pad tools"
        else
            v43 = "CAMERA MODE \194\183 A paint \194\183 Sticks/LB-RB camera \194\183 L3 lock \194\183 R3 cursor \194\183 D-pad tools"
        end

        BuildGui.Hint.Text = v43
        -- jump to 494 (out of range)
        if a0.BuildCameraLocked then
            v43 = "CAMERA LOCKED \194\183 Click to paint \194\183 Use Cam: Locked to unlock"
        else
            v43 = "Click to paint \194\183 RMB orbit \194\183 MMB pan \194\183 Wheel/WASD/QE camera"
        end

        BuildGui.Hint.Text = v43
    else
        if a0.TouchEnabled then
            if a0.DeletingObjects then
                if a0.BuildCameraLocked then
                    v43 = "CAMERA LOCKED \194\183 Tap object to delete \194\183 Delete: On to stop"
                else
                    v43 = "Tap object to delete \194\183 Delete: On to stop \194\183 Drag empty space to look"
                end

                BuildGui.Hint.Text = v43
                -- jump to 494 (out of range)
            end

            if a0.BuildCameraLocked then
                if a0.EditObject then
                    v43 = "CAMERA LOCKED \194\183 Drag object \194\183 Use transform panel to move/rotate"
                else
                    v43 = "CAMERA LOCKED \194\183 Hold object 0.4s to edit \194\183 Cam: Locked to unlock"
                end

                BuildGui.Hint.Text = v43
                -- jump to 494 (out of range)
            end

            if a0.EditObject then
                v43 = "Drag object \194\183 Use transform panel to move/rotate \194\183 Camera arrows move"
            else
                v43 = "Hold object 0.4s to edit \194\183 Camera arrows move \194\183 Drag empty space to look"
            end

            BuildGui.Hint.Text = v43
        else
            if not UserInputService.GamepadEnabled or UserInputService.KeyboardEnabled then
                if not GuiService:IsTenFootInterface() then
                    -- jump to 456
                end
            end

            if a0.BuildGamepadNavigation then
                if a0.BuildCameraLocked then
                    v43 = "CAMERA LOCKED \194\183 FREE CURSOR \194\183 A select/drag/handles/UI \194\183 L3 unlock"
                else
                    v43 = "CURSOR MODE \194\183 A select/drag/handles/UI \194\183 L3 lock camera \194\183 R3 camera mode"
                end

                BuildGui.Hint.Text = v43
            else
                if a0.BuildCameraLocked then
                    v43 = "CAMERA LOCKED \194\183 A select/drag \194\183 L3 unlock \194\183 R3 cursor mode"
                else
                    v43 = "CAMERA MODE \194\183 A select/drag \194\183 Sticks move/look \194\183 LB/RB forward/back \194\183 L3 lock \194\183 R3 cursor"
                end

                BuildGui.Hint.Text = v43
            end
        end
    end

    a0:UpdateBuildViewPanel()
    a0:UpdateStorageCapacity()
end

local function SetupBuildGui(a0) --[[ Upvalues: v2 (copy) ]]
    if a0.BuildGuiWired and a0.BuildGui and a0.BuildGui.Parent then
        return true
    end

    local v44 = a0.Player.PlayerGui:FindFirstChild("BuildModeGui") or a0.Player.PlayerGui:WaitForChild("BuildModeGui", 5)
    if not v44 then
        return false
    end

    a0.BuildGui = v44
    a0.BuildGuiWired = true
    local BuildGuiCons = a0.BuildGuiCons
    if not BuildGuiCons then
        BuildGuiCons = {}
    end

    a0.BuildGuiCons = BuildGuiCons

    local function connect(a0, a1) --[[ Upvalues: a0 (copy) ]]
        local v45 = a0.Activated:Connect(a1)
        table.insert(a0.BuildGuiCons, v45)
    end

    local BuildTransformButtonCallbacks = a0.BuildTransformButtonCallbacks
    if not BuildTransformButtonCallbacks then
        local v46 = setmetatable({}, {__mode = "k"})
    end

    a0.BuildTransformButtonCallbacks = BuildTransformButtonCallbacks

    local function connectHold(a0, a1) --[[ Upvalues: a0 (copy) ]]
        a0.BuildTransformButtonCallbacks[a0] = a1
        local v48 = a0.InputBegan:Connect(function(a0) --[[ Upvalues: a0 (upvalue), a0 (copy), a1 (copy) ]]
            local v47 = true
            if a0.UserInputType ~= Enum.UserInputType.MouseButton1 then
                v47 = true
                if a0.UserInputType ~= Enum.UserInputType.Touch then
                    v47 = a0.KeyCode == Enum.KeyCode.ButtonA
                end
            end

            if v47 then
                a0:BeginBuildTransformHold(a0, a0, a1)
            end

        end)
        table.insert(a0.BuildGuiCons, v48)
        local v49 = a0.InputEnded:Connect(function(a0) --[[ Upvalues: a0 (upvalue) ]]
            a0:EndBuildTransformHold(a0)
            task.delay(1, function() --[[ Upvalues: a0 (upvalue), a0 (copy) ]]
                local BuildTransformHandledActivations = a0.BuildTransformHandledActivations
                if BuildTransformHandledActivations then
                    BuildTransformHandledActivations[a0] = nil
                end

            end)
        end)
        table.insert(a0.BuildGuiCons, v49)
        local v50 = a0.Activated:Connect(function(a0) --[[ Upvalues: a0 (upvalue), a1 (copy) ]]
            local BuildTransformHandledActivations1 = a0.BuildTransformHandledActivations
            if a0 and BuildTransformHandledActivations1 and BuildTransformHandledActivations1[a0] then
                BuildTransformHandledActivations1[a0] = nil
                return
            end

            a1()
        end)
        table.insert(a0.BuildGuiCons, v50)
    end

    local BuildSystemToggle2 = v44:FindFirstChild("BuildSystemToggle")
    if BuildSystemToggle2 and BuildSystemToggle2:IsA("GuiButton") then
        local v51 = BuildSystemToggle2.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:SetBuildSystem(nil, true)
        end)
        table.insert(a0.BuildGuiCons, v51)
    end

    local Buttons1 = v44.Toolbar.Buttons
    local v52 = Buttons1.MoveMode.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:SetBuildTransformMode("Move")
    end)
    table.insert(a0.BuildGuiCons, v52)
    local v53 = Buttons1.RotateMode.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:SetBuildTransformMode("Rotate")
    end)
    table.insert(a0.BuildGuiCons, v53)
    local v54 = Buttons1.Place.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:AttemptPlaceBuildObject()
    end)
    table.insert(a0.BuildGuiCons, v54)
    local v55 = Buttons1.Cancel.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:DeleteEditObject()
    end)
    table.insert(a0.BuildGuiCons, v55)
    local v56 = Buttons1.Grid.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0.BuildGridEnabled = not a0.BuildGridEnabled
        a0:RebuildBuildGrid()
        a0:UpdateBuildGui()
    end)
    table.insert(a0.BuildGuiCons, v56)
    local v57 = Buttons1.MoveStep.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:CycleBuildMoveStep()
    end)
    table.insert(a0.BuildGuiCons, v57)
    local v58 = Buttons1.RotateStep.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:CycleBuildRotateStep()
    end)
    table.insert(a0.BuildGuiCons, v58)
    local CameraLock1 = Buttons1:FindFirstChild("CameraLock")
    if CameraLock1 then
        local v59 = CameraLock1.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:SetBuildCameraLocked(not a0.BuildCameraLocked)
        end)
        table.insert(a0.BuildGuiCons, v59)
    end

    local PaintMode1 = Buttons1:FindFirstChild("PaintMode")
    if PaintMode1 then
        local v60 = PaintMode1.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
            if a0.Painting then
                a0:ClosePaintFrames()
                return
            end

            if a0.EditingBase then
                a0:OpenPaintFrames()
            end

        end)
        table.insert(a0.BuildGuiCons, v60)
    end

    local v61 = Buttons1.DeleteMode.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:SetDeletingObjects(not a0.DeletingObjects)
    end)
    table.insert(a0.BuildGuiCons, v61)
    local v62 = Buttons1.DeleteAll.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:SetDeleteAllConfirmation(true)
    end)
    table.insert(a0.BuildGuiCons, v62)
    local DeleteAllConfirm = v44:FindFirstChild("DeleteAllConfirm")
    local v64 = DeleteAllConfirm and DeleteAllConfirm:FindFirstChild("Panel")
    if v64 then
        DeleteAllConfirm = v64:FindFirstChild("Confirm")
        local Cancel = v64:FindFirstChild("Cancel")
        if DeleteAllConfirm and DeleteAllConfirm:IsA("GuiButton") then
            local v65 = DeleteAllConfirm.Activated:Connect(function() --[[ Upvalues: a0 (copy), v2 (upvalue) ]]
                if not a0.DeleteAllConfirmOpen then
                    return
                end

                a0:SetDeleteAllConfirmation(false)
                a0:DeleteEditObject()
                a0:SetDeletingObjects(false)
                v2:FireServer("DeleteAllObjects", true)
            end)
            table.insert(a0.BuildGuiCons, v65)
        end

        if Cancel and Cancel:IsA("GuiButton") then
            local v66 = Cancel.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
                a0:SetDeleteAllConfirmation(false)
            end)
            table.insert(a0.BuildGuiCons, v66)
        end
    end

    local v67 = Buttons1.Exit.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        if a0.EditingBase then
            a0:StopEditStorage()
            return
        end

        if a0.Painting then
            a0:ClosePaintFrames()
        end

    end)
    table.insert(a0.BuildGuiCons, v67)
    v67 = "Y"
    local v68 = {"X", v67, "Z"}
    for k1, k2 in ipairs(v68) do
        v64 = v44.TransformPanel.AxisRows[k2]
        connectHold(v64.Minus, function() --[[ Upvalues: a0 (copy), k2 (copy) ]]
            a0:NudgeBuildObject(k2, -1)
        end)
        connectHold(v64.Plus, function() --[[ Upvalues: a0 (copy), k2 (copy) ]]
            a0:NudgeBuildObject(k2, 1)
        end)
    end

    Buttons1 = v44.TransformPanel.AxisRows:FindFirstChild("GridHeight")
    if Buttons1 then
        connectHold(Buttons1.Minus, function() --[[ Upvalues: a0 (copy) ]]
            a0:AdjustBuildGridHeight(-1)
        end)
        connectHold(Buttons1.Plus, function() --[[ Upvalues: a0 (copy) ]]
            a0:AdjustBuildGridHeight(1)
        end)
    end

    k2 = "Front"
    local v72 = {"Top", k2, "Back", "Left", "Right", "Iso"}
    for k3, k4 in ipairs(v72) do
        local v76 = v44.ViewPanel.Views[k4]
        local v77 = v76.Activated:Connect(function() --[[ Upvalues: a0 (copy), k4 (copy) ]]
            a0:SetBuildView(k4)
        end)
        table.insert(a0.BuildGuiCons, v77)
    end

    Buttons1 = v44.ViewPanel:FindFirstChild("CollapseButton")
    if Buttons1 and Buttons1:IsA("GuiButton") then
        local v78 = Buttons1.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:ToggleBuildViewPanel()
        end)
        table.insert(a0.BuildGuiCons, v78)
    end

    a0:UpdateBuildViewPanel()
    if not v44 then
        connectHold = nil
    else
        local v79 = v44:FindFirstChild("MobileCameraContols") or v44:FindFirstChild("MobileCameraControls")
    end

    if connectHold then
        connectHold.Visible = false
        for k5, k6 in pairs({Forward = Vector3.new(0, 0, -1), Back = Vector3.new(0, 0, 1), Left = Vector3.new(-1, 0, 0), Right = Vector3.new(1, 0, 0), Up = Vector3.new(0, 1, 0), Down = Vector3.new(0, -1, 0)}) do
            connect = connectHold:FindFirstChild(k5, true)
            if connect and connect:IsA("GuiButton") then
                local v83 = connect.InputBegan:Connect(function(a0) --[[ Upvalues: a0 (copy), connect (copy), k6 (copy) ]]
                    if a0.UserInputType == Enum.UserInputType.Touch or a0.UserInputType == Enum.UserInputType.MouseButton1 then
                        a0:BeginBuildMobileCameraInput(a0, connect, k6)
                    end

                end)
                table.insert(a0.BuildGuiCons, v83)
                local v84 = connect.InputEnded:Connect(function(a0) --[[ Upvalues: a0 (copy) ]]
                    a0:EndBuildMobileCameraInput(a0)
                end)
                table.insert(a0.BuildGuiCons, v84)
            end
        end
    end

    k4 = "MoveY"
    local v85 = {"MoveX", k4, "MoveZ"}
    for k7, k8 in ipairs(v85) do
        local v89 = v44[k8]
        local v90 = v89.MouseButton1Down:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:EndDirectBuildDrag()
            a0.BuildGizmoActivatedAt = os.clock()
            a0.BuildGizmoDragging = true
            a0.BuildDragStartPosition = a0.BuildObjectPosition
        end)
        table.insert(a0.BuildGuiCons, v90)
        local v97 = v89.MouseDrag:Connect(function(a0, a1) --[[ Upvalues: a0 (copy) ]]
            if not (a0.EditObject and a0.BuildDragStartPosition) then
                return
            end

            local v91 = a0.StorageBase and a0.StorageBase:FindFirstChild("Floor")
            if not v91 then
                return
            end

            local v92 = Vector3.FromNormalId(a0)
            local Unit = v91.CFrame:VectorToObjectSpace(v92).Unit
            local v93 = a0.BuildMoveStep or 0.5
            if not v93 or v93 <= 0 then
                local v94 = a1
                -- jump to 53 (out of range)
            end

            local v95 = math.round(a1 / v93) * v93
            v92 = Unit * v95
            local v96 = a0.BuildDragStartPosition + v92
            a0.BuildObjectPosition = a0:GetClampedBuildPosition(v96, a0.BuildObjectRotation)
            a0.BuildTransformDirty = true
        end)
        table.insert(a0.BuildGuiCons, v97)
        local v98 = v89.MouseButton1Up:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0.BuildDragStartPosition = nil
            a0.BuildGizmoDragging = nil
        end)
        table.insert(a0.BuildGuiCons, v98)
    end

    k8 = "RotateY"
    local v99 = {"RotateX", k8, "RotateZ"}
    for k9, k10 in ipairs(v99) do
        connectHold = v44[k10]
        local v103 = connectHold.MouseButton1Down:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:EndDirectBuildDrag()
            a0.BuildGizmoActivatedAt = os.clock()
            a0.BuildGizmoDragging = true
            a0.BuildDragStartRotation = a0.BuildObjectRotation
        end)
        table.insert(a0.BuildGuiCons, v103)
        local v108 = connectHold.MouseDrag:Connect(function(a0, a1) --[[ Upvalues: a0 (copy) ]]
            if not (a0.EditObject and a0.BuildDragStartRotation) then
                return
            end

            local v104 = math.deg(a1)
            local v105 = a0.BuildRotateStep or 15
            if not v105 or v105 <= 0 then
                local v106 = v104
                -- jump to 30 (out of range)
            end

            local v107 = math.round(v104 / v105) * v105
            if a0 == Enum.Axis.X then
                v104 = "X"
            else
                if a0 == Enum.Axis.Y then
                    v104 = "Y"
                else
                    v104 = false
                    if a0 == Enum.Axis.Z then
                        v104 = "Z"
                    end
                end
            end

            if not v104 then
                return
            end

            a0.BuildObjectRotation = rotateBuildRotationOnLocalAxis(a0.BuildDragStartRotation, v104, v107)
            a0:ClampBuildObjectToBounds()
            a0.BuildTransformDirty = true
        end)
        table.insert(a0.BuildGuiCons, v108)
        local v109 = connectHold.MouseButton1Up:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0.BuildDragStartRotation = nil
            a0.BuildGizmoDragging = nil
        end)
        table.insert(a0.BuildGuiCons, v109)
    end

    return true
end

local function UpdateBuildViewPanel(a0) --[[ Upvalues: styleBuildButton (copy) ]]
    local BuildGui1 = a0.BuildGui
    local v111 = BuildGui1 and BuildGui1:FindFirstChild("ViewPanel")
    if not v111 then
        return
    end

    BuildGui1 = v111:FindFirstChild("Title")
    local Views = v111:FindFirstChild("Views")
    local v112 = v111:FindFirstChildOfClass("UIStroke")
    local CollapseButton = v111:FindFirstChild("CollapseButton")
    local BuildViewPanelExpandedState = a0.BuildViewPanelExpandedState
    if not BuildViewPanelExpandedState or BuildViewPanelExpandedState.Panel ~= v111 then
        local v113 = {Panel = v111, BackgroundTransparency = v111.BackgroundTransparency}
        local v115 = v112 and v112.Enabled
        v113.StrokeEnabled = v115
        local v116 = BuildGui1 and BuildGui1.Visible
        v113.TitleVisible = v116
        local v117 = Views and Views.Visible
        v113.ViewsVisible = v117
        BuildViewPanelExpandedState = v113
        a0.BuildViewPanelExpandedState = BuildViewPanelExpandedState
    end

    local v118 = a0.BuildViewPanelCollapsed == true
    local v119
    if v118 then
        v119 = 1
    else
        v119 = BuildViewPanelExpandedState.BackgroundTransparency
    end

    v111.BackgroundTransparency = v119
    if v112 then
        local v120 = not v118 and BuildViewPanelExpandedState.StrokeEnabled
        v112.Enabled = v120
    end

    if BuildGui1 then
        local v121 = not v118 and BuildViewPanelExpandedState.TitleVisible
        BuildGui1.Visible = v121
    end

    if Views then
        local v122 = not v118 and BuildViewPanelExpandedState.ViewsVisible
        Views.Visible = v122
    end

    if CollapseButton then
        if CollapseButton:IsA("GuiButton") then
            local v123
            if v118 then
                v123 = "<"
            else
                v123 = ">"
            end

            CollapseButton.Text = v123
            styleBuildButton(CollapseButton, v118)
            CollapseButton:SetAttribute("Collapsed", v118)
        end
    end

    v111:SetAttribute("Collapsed", v118)
end

local function ToggleBuildViewPanel(a0)
    a0.BuildViewPanelCollapsed = not a0.BuildViewPanelCollapsed
    a0:UpdateBuildViewPanel()
end

local function UpdateBuildMobileCameraControlsVisibility(a0, a1)
    local BuildGui2 = a0.BuildGui
    local v124
    if not BuildGui2 then
        v124 = nil
    else
        local v125 = BuildGui2:FindFirstChild("MobileCameraContols") or BuildGui2:FindFirstChild("MobileCameraControls")
    end

    if not v124 then
        return
    end

    BuildGui2 = false
    if a1 == true then
        BuildGui2 = false
        if a0.BuildCameraActive == true then
            BuildGui2 = a0.TouchEnabled == true
        end
    end

    v124.Visible = BuildGui2
end

local function UpdateBuildGridLabel(a0) --[[ Upvalues: buildFormatNumber (copy) ]]
    if not a0.BuildGui then
        return
    end

    local GridHeight = a0.BuildGui.TransformPanel.AxisRows:FindFirstChild("GridHeight")
    if not GridHeight then
        return
    end

    local v126 = a0:GetBuildGridFloor()
    GridHeight.Axis.Text = "GRID " .. buildFormatNumber(v126 and a0.BuildGridOffsets and a0.BuildGridOffsets[v126] or 0 or 0)
end

local function UpdateStorageCapacity(a0)
    local v129 = a0:GetStorageCapacityLimit()
    local v130 = tostring(a0:GetStorageCapacity())
    local v131 = "Capacity: " .. v130 .. "/" .. tostring(v129)
    local BuildGui3 = a0.BuildGui
    if not (BuildGui3 and BuildGui3.Parent) then
        BuildGui3 = a0.Player.PlayerGui:FindFirstChild("BuildModeGui")
    end

    local v132 = BuildGui3 and BuildGui3:FindFirstChild("Toolbar") and BuildGui3.Toolbar:FindFirstChild("Buttons")
    local v133 = v132 and v132:FindFirstChild("Capacity")
    if v133 then
        v133.Text = v131
    end
end

local function SetBuildTransformMode(a0, a1)
    if a1 ~= "Move" and a1 ~= "Rotate" then
        return
    end

    a0:EndBuildTouchGizmoDrag()
    a0.BuildTransformMode = a1
    a0.BuildTransformDirty = true
    a0:UpdateBuildGui()
    if a0.EditObject then
        local v134 = a0:GetBuildObjectCFrame()
        a0:UpdateBuildGizmo(v134)
    end
end

local function CycleBuildMoveStep(a0) --[[ Upvalues: HideResetConfirmation (copy) ]]
    local v136 = a0.BuildMoveStep or HideResetConfirmation[3]
    local v137 = 1
    for k11, k12 in ipairs(HideResetConfirmation) do
        local v141 = math.abs(k12 - v136)
        if v141 < 0.001 then
            v137 = k11 % #HideResetConfirmation + 1
            break
        end
    end

    a0.BuildMoveStep = HideResetConfirmation[v137]
    a0:RebuildBuildGrid()
    a0:UpdateBuildGui()
end

local function CycleBuildRotateStep(a0) --[[ Upvalues: v3 (copy) ]]
    local v143 = a0.BuildRotateStep or v3[2]
    local v144 = 1
    for k13, k14 in ipairs(v3) do
        if k14 == v143 then
            v144 = k13 % #v3 + 1
            break
        end
    end

    a0.BuildRotateStep = v3[v144]
    a0:UpdateBuildGui()
end

local function EndBuildTransformHold(a0, a1)
    local BuildTransformHolds = a0.BuildTransformHolds
    if a1 then
        if BuildTransformHolds then
            BuildTransformHolds[a1] = nil
        end

        return
    end

    a0.BuildTransformHolds = {}
    a0.BuildTransformHandledActivations = setmetatable({}, {__mode = "k"})
end

local function BeginBuildTransformHold(a0, a1, a2, a3)
    if not a0.BuildCameraActive then
        return
    end

    if not a2 then
        return
    end

    if typeof(a3) ~= "function" then
        return
    end

    local BuildTransformHolds1 = a0.BuildTransformHolds
    if not BuildTransformHolds1 then
        BuildTransformHolds1 = {}
    end

    a0.BuildTransformHolds = BuildTransformHolds1
    BuildTransformHolds1 = a0.BuildTransformHandledActivations
    if not BuildTransformHolds1 then
        local v148 = setmetatable({}, {__mode = "k"})
    end

    a0.BuildTransformHandledActivations = BuildTransformHolds1
    a0.BuildTransformHandledActivations[a2] = true
    if a0.BuildTransformHolds[a2] then
        return
    end

    local v149 = {Button = a1, Callback = a3}
    a0.BuildTransformHolds[a2] = v149
    a3()
    task.spawn(function() --[[ Upvalues: a0 (copy), a2 (copy), v149 (copy), a1 (copy), a3 (copy) ]]
        task.wait(0.35)
        while a0.BuildTransformHolds do
            local v150 = a0.BuildTransformHolds[a2]
            if v150 ~= v149 then
                break
            end

            if not a0.BuildCameraActive then
                break
            end

            if not a0.BuildGui then
                break
            end

            if not a0.BuildGui.Enabled then
                break
            end

            if not a1.Parent then
                break
            end

            if a2.UserInputState == Enum.UserInputState.End then
                break
            end

            if a2.UserInputState == Enum.UserInputState.Cancel then
                break
            end

            a3()
            task.wait(0.08)
        end

        if a0.BuildTransformHolds then
            local v152 = a0.BuildTransformHolds[a2]
            if v152 == v149 then
                a0.BuildTransformHolds[a2] = nil
            end
        end

    end)
end

local function SetBuildCameraLocked(a0, a1) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    if not a0.BuildCameraActive then
        return
    end

    local v153 = a0.BuildCameraLocked == true
    a0.BuildCameraLocked = a1 == true
    local BuildCameraLocked = a0.BuildCameraLocked
    if BuildCameraLocked then
        local v154 = GuiService:IsTenFootInterface()
        if not v154 then
            local GamepadEnabled2 = UserInputService.GamepadEnabled
            if GamepadEnabled2 then
                GamepadEnabled2 = not UserInputService.KeyboardEnabled
                if not GamepadEnabled2 then
                    GamepadEnabled2 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
                end
            end
        end
    end

    if BuildCameraLocked then
        if not v153 then
            local v155 = a0.BuildGamepadNavigation == true
            if a0.PaintPickerPreviousGamepadNavigation ~= nil then
                v155 = a0.PaintPickerPreviousGamepadNavigation == true
            end

            a0.BuildGamepadNavigationBeforeCameraLock = v155
            a0.BuildCameraLockManagedGamepadNavigation = true
        end
    end

    if a0.BuildCameraLocked then
        a0:ClearBuildMobileCameraInputs()
        a0:EndBuildMouseCameraDrag()
        a0.BuildPinchMid = nil
        a0.BuildPinchDistance = nil
    end

    if BuildCameraLocked then
        a0:SetBuildGamepadNavigation(true)
    else
        if v153 then
            if not a0.BuildCameraLocked then
                if a0.BuildCameraLockManagedGamepadNavigation then
                    local v156 = a0.BuildGamepadNavigationBeforeCameraLock == true
                    a0.BuildGamepadNavigationBeforeCameraLock = nil
                    a0.BuildCameraLockManagedGamepadNavigation = nil
                    if a0.ColorPickerHUD then
                        a0.PaintPickerPreviousGamepadNavigation = v156
                        a0:SetBuildGamepadNavigation(true)
                    else
                        a0:SetBuildGamepadNavigation(v156)
                    end
                end
            end
        end
    end

    a0:UpdateBuildGui()
end

local function SetDeletingObjects(a0, a1) --[[ Upvalues: styleBuildButton (copy), v7 (copy) ]]
    a0.DeletingObjects = a1 == true
    if a0.DeletingObjects and a0.EditObject then
        a0:DeleteEditObject()
    end

    a0:ClearBuildObjectHover()
    local BuildGui4 = a0.BuildGui
    if not (BuildGui4 and BuildGui4.Parent) then
        BuildGui4 = a0.Player.PlayerGui:FindFirstChild("BuildModeGui")
    end

    local v158 = BuildGui4 and BuildGui4:FindFirstChild("Toolbar") and BuildGui4.Toolbar:FindFirstChild("Buttons")
    local v159 = v158 and v158:FindFirstChild("DeleteMode")
    if v159 then
        local v160
        if a0.DeletingObjects then
            v160 = "Delete: On"
        else
            v160 = "Delete: Off"
        end

        v159.Text = v160
        styleBuildButton(v159, a0.DeletingObjects, a0.DeletingObjects and v7 or nil)
    end

    if a0.ClassicBuildActive then
        a0:ApplyClassicBuildPresentation()
    end
end

local function SetDeleteAllConfirmation(a0, a1) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    local v163 = a0.BuildGui and a0.BuildGui:FindFirstChild("DeleteAllConfirm")
    if not v163 then
        return false
    end

    local v164 = false
    if a1 == true then
        v164 = false
        if a0.BuildCameraActive == true then
            v164 = a0.BuildModeKind == "Objects"
        end
    end

    if v164 then
        if a0.DeleteAllConfirmOpen then
            return true
        end

        a0.PaintResetConfirmOpen = nil
        a0.DeleteAllPreviousSelection = GuiService.SelectedObject
        a0.DeleteAllConfirmOpen = true
        v163.Visible = true
        a0:EndBuildTouchGizmoDrag()
        a0:EndBuildTransformHold()
        a0:EndDirectBuildDrag()
        a0:ClearBuildMobileCameraInputs()
        a0.BuildPendingTouchSelection = nil
        a0.BuildPendingGamepadGrab = nil
        a0:EndBuildMouseCameraDrag()
        local Cancel1 = v163:FindFirstChild("Cancel", true)
        if UserInputService.GamepadEnabled then
            if Cancel1 then
                if Cancel1:IsA("GuiButton") then
                    GuiService.SelectedObject = Cancel1
                    -- branch continues at 133
                end

                -- branch continues at 133
            end

            -- branch continues at 133
        end
    else
        local DeleteAllPreviousSelection = a0.DeleteAllPreviousSelection
        a0.DeleteAllConfirmOpen = nil
        a0.DeleteAllPreviousSelection = nil
        v163.Visible = false
        if a0.DeleteAllConfirmOpen == true then
            local SelectedObject = GuiService.SelectedObject
            if SelectedObject then
                if SelectedObject:IsDescendantOf(v163) then
                    GuiService.SelectedObject = DeleteAllPreviousSelection and DeleteAllPreviousSelection.Parent and DeleteAllPreviousSelection or nil
                end
            end
        end
    end

    return true
end

local function BeginBuildMobileCameraInput(a0, a1, a2, a3) --[[ Upvalues: v5 (copy) ]]
    if not a0.BuildCameraActive or a0.BuildCameraLocked then
        return
    end

    a0:EndBuildMobileCameraInput(a1)
    local BuildMobileCameraInputs = a0.BuildMobileCameraInputs
    if not BuildMobileCameraInputs then
        BuildMobileCameraInputs = {}
    end

    a0.BuildMobileCameraInputs = BuildMobileCameraInputs
    local v167 = {Button = a2, Direction = a3}
    a0.BuildMobileCameraInputs[a1] = v167
    if a2 and a2.Parent then
        a2.BackgroundColor3 = v5
        a2.BackgroundTransparency = 0.5
        a2.BorderColor3 = Color3.new(1, 1, 1)
        a2.BorderSizePixel = 3
        if a2:IsA("TextButton") then
            a2.TextColor3 = Color3.new(1, 1, 1)
        end
    end

    a0.BuildViewPreset = nil
end

local function EndBuildMobileCameraInput(a0, a1) --[[ Upvalues: v5 (copy) ]]
    local BuildMobileCameraInputs1 = a0.BuildMobileCameraInputs
    local v170 = BuildMobileCameraInputs1 and BuildMobileCameraInputs1[a1]
    if not v170 then
        return
    end

    BuildMobileCameraInputs1[a1] = nil
    local Button = v170.Button
    if Button and Button.Parent then
        v170 = false
        for k15, k16 in pairs(BuildMobileCameraInputs1) do
            if k16.Button == Button then
                v170 = true
                break
            end
        end

        if not v170 then
            Button.BackgroundColor3 = v5
            Button.BackgroundTransparency = 0.5
            Button.BorderColor3 = Color3.new(1, 1, 1)
            Button.BorderSizePixel = 1
            if Button:IsA("TextButton") then
                Button.TextColor3 = Color3.new(1, 1, 1)
            end
        end
    end
end

local function ClearBuildMobileCameraInputs(a0) --[[ Upvalues: v5 (copy) ]]
    local BuildMobileCameraInputs2 = a0.BuildMobileCameraInputs
    if BuildMobileCameraInputs2 then
        for k17, k18 in pairs(BuildMobileCameraInputs2) do
            local Button1 = k18.Button
            if Button1 and Button1.Parent then
                Button1.BackgroundColor3 = v5
                Button1.BackgroundTransparency = 0.5
                Button1.BorderColor3 = Color3.new(1, 1, 1)
                Button1.BorderSizePixel = 1
                if Button1:IsA("TextButton") then
                    Button1.TextColor3 = Color3.new(1, 1, 1)
                end
            end
        end
    end

    a0.BuildMobileCameraInputs = {}
end

local t3 = {
    IsClassicBuildSystem = IsClassicBuildSystem,
    UpdateBuildSystem = UpdateBuildSystem,
    UpdateBuildGui = UpdateBuildGui,
    SetupBuildGui = SetupBuildGui,
    UpdateBuildViewPanel = UpdateBuildViewPanel,
    ToggleBuildViewPanel = ToggleBuildViewPanel,
    UpdateBuildMobileCameraControlsVisibility = UpdateBuildMobileCameraControlsVisibility,
    UpdateBuildGridLabel = UpdateBuildGridLabel,
    UpdateStorageCapacity = UpdateStorageCapacity,
    SetBuildTransformMode = SetBuildTransformMode,
    CycleBuildMoveStep = CycleBuildMoveStep,
    CycleBuildRotateStep = CycleBuildRotateStep,
    EndBuildTransformHold = EndBuildTransformHold,
    BeginBuildTransformHold = BeginBuildTransformHold,
    SetBuildCameraLocked = SetBuildCameraLocked,
    SetDeletingObjects = SetDeletingObjects,
    SetDeleteAllConfirmation = SetDeleteAllConfirmation,
    BeginBuildMobileCameraInput = BeginBuildMobileCameraInput,
    EndBuildMobileCameraInput = EndBuildMobileCameraInput,
    ClearBuildMobileCameraInputs = ClearBuildMobileCameraInputs
}
ClearBuildMobileCameraInputs = {}
ClearBuildMobileCameraInputs.__index = ClearBuildMobileCameraInputs

local function visible(a0, a1)
    local v177 = a0
    while v177 do
        if v177 == a1.Parent then
            break
        end

        if v177:IsA("GuiObject") and not v177.Visible then
            return false
        end

        if v177:IsA("LayerCollector") and not v177.Enabled then
            return false
        end

        v177 = v177.Parent
    end

    return true
end

local function call(a0, a1, ...)
    local t4 = {...}
    local t5 = {kind = "ActionCaptured", action = a1, args = t4}
    table.insert(a0.Events, t5)
end

local function Start(a0) --[[ Upvalues: v1 (ref), ClearBuildMobileCameraInputs (copy), UserInputService (copy), t3 (copy), call (copy) ]]
    if v1 then
        v1:Cleanup()
    end

    local v178 = {
        Events = {},
        Hidden = {},
        SourceMethods = script:GetAttribute("SourceMethods")
    }
    local v179 = setmetatable(v178, ClearBuildMobileCameraInputs)
    v1 = v179
    local LocalPlayer = game:GetService("Players").LocalPlayer
    assert(LocalPlayer, "Run fixture from Client")
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local v180 = PlayerGui:GetChildren()
    for k19, k20 in ipairs(v180) do
        if k20:IsA("ScreenGui") and k20.Enabled then
            v179.Hidden[k20] = true
            k20.Enabled = false
        end
    end

    LocalPlayer = script:WaitForChild("BuildModeTemplate"):Clone()
    LocalPlayer.Name = "QAAuthoredBuildModeGui"
    LocalPlayer.ResetOnSpawn = false
    LocalPlayer.DisplayOrder = 200
    local v184 = LocalPlayer:GetDescendants()
    for k21, k22 in ipairs(v184) do
        if k22:IsA("LuaSourceContainer") then
            k22:Destroy()
        end
    end

    LocalPlayer.Parent = PlayerGui
    LocalPlayer.Enabled = true
    v179.Gui = LocalPlayer

    local function FindFirstChild(a0, a1) --[[ Upvalues: LocalPlayer (copy), PlayerGui (copy) ]]
        if a1 == "BuildModeGui" then
            return LocalPlayer
        end

        local v188 = PlayerGui:FindFirstChild(a1)
        return v188
    end

    local function WaitForChild(a0, a1)
        local v189 = a0:FindFirstChild(a1)
        return v189
    end

    local v190 = {FindFirstChild = FindFirstChild, WaitForChild = WaitForChild}

    local function FindFirstChild1(a0)
        return nil
    end

    WaitForChild = {FindFirstChild = FindFirstChild1}
    k22 = {PlayerGui = v190}
    local v191 = {Main = WaitForChild}
    k22 = {Settings = v191}
    k21 = {
        BuildCameraActive = true,
        BuildModeKind = "Objects",
        EditingBase = true,
        BuildTransformMode = "Move",
        BuildMoveStep = 0.5,
        BuildRotateStep = 15,
        BuildGridEnabled = true,
        BuildObjectPosition = Vector3.new(0, 0, 0),
        BuildObjectRotation = Vector3.new(0, 0, 0),
        Player = k22,
        HUD = k22,
        BuildGui = LocalPlayer,
        Data = {BuildSystem = "Modern"},
        TouchEnabled = UserInputService.TouchEnabled,
        BuildGridOffsets = {},
        EditCons = {}
    }
    local v192 = {__index = t3}
    local v193 = setmetatable(k21, v192)
    v179.Client = v193

    local function GetStorageCapacity(a0)
        return 12
    end

    v193.GetStorageCapacity = GetStorageCapacity

    local function GetStorageCapacityLimit(a0)
        return 100
    end

    v193.GetStorageCapacityLimit = GetStorageCapacityLimit

    local function GetBuildGridFloor(a0)
        return "FixtureFloor"
    end

    v193.GetBuildGridFloor = GetBuildGridFloor

    local function RebuildBuildGrid(a0) --[[ Upvalues: call (upvalue) ]]
        call(a0.QA, "RebuildBuildGrid")
        a0:UpdateBuildGridLabel()
    end

    v193.RebuildBuildGrid = RebuildBuildGrid

    local function EndBuildTouchGizmoDrag(a0)
    end

    v193.EndBuildTouchGizmoDrag = EndBuildTouchGizmoDrag

    local function EndDirectBuildDrag(a0)
    end

    v193.EndDirectBuildDrag = EndDirectBuildDrag

    local function EndBuildMouseCameraDrag(a0)
    end

    v193.EndBuildMouseCameraDrag = EndBuildMouseCameraDrag

    local function ClearBuildObjectHover(a0)
    end

    v193.ClearBuildObjectHover = ClearBuildObjectHover

    local function GetBuildObjectCFrame(a0)
        local v194 = CFrame.new()
        return v194
    end

    v193.GetBuildObjectCFrame = GetBuildObjectCFrame

    local function UpdateBuildGizmo(a0)
    end

    v193.UpdateBuildGizmo = UpdateBuildGizmo

    local function SetBuildGamepadNavigation(a0, a1)
        a0.BuildGamepadNavigation = a1
    end

    v193.SetBuildGamepadNavigation = SetBuildGamepadNavigation

    local function AttemptPlaceBuildObject(a0) --[[ Upvalues: call (upvalue) ]]
        call(a0.QA, "Place", a0.EditingExistingObject == true)
    end

    v193.AttemptPlaceBuildObject = AttemptPlaceBuildObject

    local function DeleteEditObject(a0) --[[ Upvalues: call (upvalue) ]]
        call(a0.QA, "Deselect")
        a0.EditObject = nil
        a0.EditingExistingObject = nil
        a0:UpdateBuildGui()
    end

    v193.DeleteEditObject = DeleteEditObject

    local function NudgeBuildObject(a0, a1, a2) --[[ Upvalues: call (upvalue) ]]
        call(a0.QA, "Nudge", a1, a2, a0.BuildTransformMode)
    end

    v193.NudgeBuildObject = NudgeBuildObject

    local function AdjustBuildGridHeight(a0, a1) --[[ Upvalues: call (upvalue) ]]
        call(a0.QA, "GridHeight", a1)
        local v195 = a0.BuildGridOffsets.FixtureFloor or 0
        a0.BuildGridOffsets.FixtureFloor = v195 + a1 * (a0.BuildMoveStep or 0.5)
        a0:UpdateBuildGridLabel()
    end

    v193.AdjustBuildGridHeight = AdjustBuildGridHeight

    local function SetBuildView(a0, a1) --[[ Upvalues: call (upvalue) ]]
        a0.BuildViewPreset = a1
        call(a0.QA, "View", a1)
    end

    v193.SetBuildView = SetBuildView

    local function StopEditStorage(a0) --[[ Upvalues: call (upvalue) ]]
        call(a0.QA, "Exit")
        a0.BuildCameraActive = false
        a0.BuildGui.Enabled = false
    end

    v193.StopEditStorage = StopEditStorage

    local function OpenPaintFrames(a0) --[[ Upvalues: call (upvalue) ]]
        call(a0.QA, "Paint")
        a0.Painting = true
        a0.BuildModeKind = "Paint"
        a0:UpdateBuildGui()
    end

    v193.OpenPaintFrames = OpenPaintFrames

    local function ClosePaintFrames(a0) --[[ Upvalues: call (upvalue) ]]
        call(a0.QA, "Objects")
        a0.Painting = false
        a0.BuildModeKind = "Objects"
        a0:UpdateBuildGui()
    end

    v193.ClosePaintFrames = ClosePaintFrames

    local function SetBuildSystem(a0) --[[ Upvalues: call (upvalue) ]]
        call(a0.QA, "SwitchSystem")
    end

    v193.SetBuildSystem = SetBuildSystem
    v193.QA = v179
    local v196 = v193:SetupBuildGui()
    assert(v196, "actual SetupBuildGui failed")
    local v197 = a0
    if not v197 then
        v197 = {}
    end

    v179:SetCase(v197)
    return v179
end

ClearBuildMobileCameraInputs.Start = Start

local function SetCase(a0, a1) --[[ Upvalues: UserInputService (copy) ]]
    if type(a1) == "string" then
        local v198 = {
            Desktop = {touch = false},
            Mobile = {touch = true},
            Selected = {selected = true},
            Deleting = {deleting = true},
            Paint = {paint = true},
            Locked = {locked = true}
        }
        local v199 = v198[a1]
        if not v199 then
            v199 = {}
        end

        a1 = v199
    end

    local Client = a0.Client
    Client.BuildCameraActive = true
    local v200
    if a1.paint then
        v200 = "Paint"
    else
        v200 = "Objects"
    end

    Client.BuildModeKind = v200
    Client.Painting = a1.paint == true
    local v201
    if not (a1.touch == nil and UserInputService.TouchEnabled) then
        v201 = a1.touch == true
    end

    Client.TouchEnabled = v201
    Client.DeletingObjects = a1.deleting == true
    Client.BuildCameraLocked = a1.locked == true
    Client.BuildTransformMode = a1.mode or "Move"
    if a1.selected then
        v201 = {Name = "QA Chair"}
        if v201 then
            -- jump to 95
        end
    end

    v201 = nil
    Client.EditObject = v201
    if a1.existing then
        v201 = {Name = "QA Existing Chair"}
        if v201 then
            -- jump to 103
        end
    end

    v201 = nil
    Client.EditingExistingObject = v201
    Client.BuildViewPanelCollapsed = a1.collapsed == true
    Client.BuildMoveStep = a1.moveStep or 0.5
    Client.BuildRotateStep = a1.rotateStep or 15
    Client.BuildGridEnabled = a1.grid ~= false
    Client.DeleteAllConfirmOpen = nil
    local DeleteAllConfirm2 = a0.Gui:FindFirstChild("DeleteAllConfirm")
    if DeleteAllConfirm2 then
        DeleteAllConfirm2.Visible = false
    end

    local v202 = "TransformPanel"
    local v203 = {"Toolbar", v202, "ViewPanel", "Hint"}
    for k23, k24 in ipairs(v203) do
        DeleteAllConfirm2 = a0.Gui:FindFirstChild(k24)
        if DeleteAllConfirm2 then
            DeleteAllConfirm2.Visible = true
        end
    end

    a0.Gui.Enabled = true
    Client:UpdateBuildGui()
    Client:UpdateBuildMobileCameraControlsVisibility(Client.TouchEnabled)
    if a1.confirm then
        Client:SetDeleteAllConfirmation(true)
    end

    local v207 = a0:Inspect()
    return v207
end

ClearBuildMobileCameraInputs.SetCase = SetCase

local function Inspect(a0) --[[ Upvalues: visible (copy) ]]
    local Client1 = a0.Client
    local Gui = a0.Gui
    local t6 = {}
    local t7 = {}
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local v208 = Gui:GetDescendants()
    for k25, k26 in ipairs(v208) do
        if k26:IsA("GuiObject") then
            if visible(k26, Gui) then
                if 0 < k26.AbsoluteSize.X then
                    if 0 < k26.AbsoluteSize.Y then
                        local AbsolutePosition = k26.AbsolutePosition
                        local AbsoluteSize = k26.AbsoluteSize
                        local v212 = k26:GetFullName():sub(#Gui:GetFullName() + 2)
                        if k26:IsA("TextLabel") or k26:IsA("TextButton") or k26:IsA("TextBox") then
                            if k26.Text ~= "" then
                                local v213 = {path = v212, text = k26.Text}
                                v213.font = tostring(k26.Font)
                                v213.textSize = k26.TextSize
                                v213.textFits = k26.TextFits
                                local v214 = {AbsolutePosition.X, AbsolutePosition.Y}
                                v213.position = v214
                                v214 = {AbsoluteSize.X, AbsoluteSize.Y}
                                v213.size = v214
                                v213.backgroundTransparency = k26.BackgroundTransparency
                                v213.border = k26.BorderSizePixel
                                local v215 = {
                                    k26.TextColor3.R,
                                    k26.TextColor3.G,
                                    k26.TextColor3.B
                                }
                                v213.textColor = v215
                                table.insert(t7, v213)
                                if not k26.TextFits then
                                    v213 = {
                                        kind = "TextDoesNotFit",
                                        path = v212,
                                        text = k26.Text
                                    }
                                    table.insert(t6, v213)
                                end

                                if AbsolutePosition.X < 0 or AbsolutePosition.Y < 0 or AbsolutePosition.X + AbsoluteSize.X < v216 or AbsolutePosition.Y + AbsoluteSize.Y < v216 then
                                    v215 = {AbsolutePosition.X, AbsolutePosition.Y}
                                    v215 = {AbsoluteSize.X, AbsoluteSize.Y}
                                    local v217 = {
                                        kind = "OutsideViewport",
                                        path = v212,
                                        position = v215,
                                        size = v215
                                    }
                                    table.insert(t6, v217)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    local v218 = 0
    local BuildMobileCameraInputs3 = Client1.BuildMobileCameraInputs
    if not BuildMobileCameraInputs3 then
        BuildMobileCameraInputs3 = {}
    end

    for k27 in pairs(BuildMobileCameraInputs3) do
        v218 = v218 + 1
    end

    local v222 = {ViewportSize.X, ViewportSize.Y}
    local v223 = {
        fixture = "QAAuthoredBuildModeGui",
        viewport = v222,
        sourceMethods = a0.SourceMethods
    }
    local v224 = {touch = Client1.TouchEnabled, mode = Client1.BuildTransformMode}
    v224.paint = Client1.Painting == true
    v224.deleting = Client1.DeletingObjects == true
    v224.locked = Client1.BuildCameraLocked == true
    v224.selected = Client1.EditObject ~= nil
    v224.existing = Client1.EditingExistingObject ~= nil
    v224.moveStep = Client1.BuildMoveStep
    v224.rotateStep = Client1.BuildRotateStep
    v224.grid = Client1.BuildGridEnabled
    v224.view = Client1.BuildViewPreset
    v224.collapsed = Client1.BuildViewPanelCollapsed
    v224.confirm = Client1.DeleteAllConfirmOpen == true
    v224.heldCameraInputs = v218
    v223.state = v224
    v223.hint = Gui.Hint.Text
    v223.events = a0.Events
    v223.texts = t7
    v223.issues = t6
    return v223
end

ClearBuildMobileCameraInputs.Inspect = Inspect

local function ClearEvents(a0)
    a0.Events = {}
    return true
end

ClearBuildMobileCameraInputs.ClearEvents = ClearEvents

local function Cleanup(a0) --[[ Upvalues: v1 (ref) ]]
    if a0.Cleaned then
        return
    end

    a0.Cleaned = true
    a0.Client.BuildCameraActive = false
    a0.Client:EndBuildTransformHold()
    a0.Client:ClearBuildMobileCameraInputs()
    local BuildGuiCons1 = a0.Client.BuildGuiCons
    if not BuildGuiCons1 then
        BuildGuiCons1 = {}
    end

    for k28, k29 in ipairs(BuildGuiCons1) do
        k29:Disconnect()
    end

    a0.Gui:Destroy()
    for k30 in pairs(a0.Hidden) do
        if k30.Parent then
            k30.Enabled = true
        end
    end

    if v1 == a0 then
        v1 = nil
    end
end

ClearBuildMobileCameraInputs.Cleanup = Cleanup
return ClearBuildMobileCameraInputs
