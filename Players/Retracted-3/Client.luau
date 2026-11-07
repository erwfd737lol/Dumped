
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ContextActionService = game:GetService("ContextActionService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local GamepadService = game:GetService("GamepadService")
local MarketplaceService = game:GetService("MarketplaceService")
local VoiceChatService = game:GetService("VoiceChatService")
local CollectionService = game:GetService("CollectionService")
local AvatarEditorService = game:GetService("AvatarEditorService")
local v1 = require(ReplicatedStorage.Modules.SpringModule)
local v2 = require(ReplicatedStorage.Modules.ToolsLib)
local v3 = require(ReplicatedStorage.Modules.ShopLib)
local v4 = require(ReplicatedStorage.Modules.PumpkinXShopUI)
local v5 = require(ReplicatedStorage.Modules.Achievements)
local v6 = require(ReplicatedStorage.Modules.BaseObjectsLib)
local v7 = require(ReplicatedStorage.Modules.ModernBuild)
local Preferences = v7.Preferences
local v8 = require(ReplicatedStorage.Modules.BaseCustomLib)
local v9 = require(ReplicatedStorage.Modules.BaseCapacityLib)
local v10 = require(ReplicatedStorage.Modules.GamepassLib)
local v11 = require(ReplicatedStorage.Modules.SkinsLib)
local v12 = require(ReplicatedStorage.Modules.CraftLib)
local v13 = require(ReplicatedStorage.Modules.ExchangeLib)
local v14 = require(ReplicatedStorage.Modules.CustomBackpack)
local v15 = require(ReplicatedStorage.Modules.ColorPicker)
local v16 = require(ReplicatedStorage.Modules.PaintController)
local v17 = require(ReplicatedStorage.Modules.ClassicBuild)
local v18 = require(ReplicatedStorage.Modules.Events)
local v19 = require(ReplicatedStorage.Modules.BaitsLib)
local v20 = require(ReplicatedStorage.Modules.ProductLib)
local RemoteEvent = ReplicatedStorage.Remotes.RemoteEvent
local RemoteFunction = ReplicatedStorage.Remotes.RemoteFunction
local UnreliableRemoteEvent = ReplicatedStorage.Remotes.UnreliableRemoteEvent
local Animations = ReplicatedStorage.Animations
local Objects = ReplicatedStorage.Objects

local function getBobbing(a0, a1, a2)
    return math.sin(tick() * a0 * a1) * a2
end

getBobbing = {}
getBobbing.__index = getBobbing

local function new(a0) --[[ Upvalues: getBobbing (copy) ]]
    local t1 = {
        Player = a0,
        WalkSpeed = 12,
        JumpHeight = 7.2,
        Camera = workspace.CurrentCamera,
        Skills = {},
        Weapon = "",
        GuiCons = {},
        SkinCons = {},
        GlobalShops = {},
        EditCons = {},
        TempCons = {},
        BankCons = {},
        Data = {}
    }
    return setmetatable(t1, getBobbing)
end

getBobbing.new = new
local Events = workspace.Events

local function SetUp(a0) --[[ Upvalues: v14 (copy), RemoteEvent (copy), v17 (copy), v1 (copy), ContextActionService (copy), UserInputService (copy), RunService (copy), TweenService (copy), UnreliableRemoteEvent (copy), Animations (copy), Events (copy), v18 (copy), MarketplaceService (copy) ]]
    a0.HUD = a0.Player.PlayerGui:WaitForChild("HUD")
    a0.CustomBackpack = v14.new(a0.Player, a0.HUD, RemoteEvent)
    a0.MobileButtons = a0.Player.PlayerGui:WaitForChild("MobileButtons")
    local ReplicatedStorage1 = game:GetService("ReplicatedStorage")
    local Stats = game:GetService("Stats")
    local Player = a0.Player
    local ServerRegion = a0.HUD:FindFirstChild("ServerRegion")
    if ServerRegion then
        ServerRegion.RichText = true

        local function escapeRich(a0)
            return a0:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
        end

        local function getPingMs() --[[ Upvalues: Stats (copy), Player (copy) ]]
            local v22, v23 = pcall(function() --[[ Upvalues: Stats (upvalue) ]]
                local v21 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                return v21
            end)
            if v22 then
                if type(v23) == "number" and 0 < v23 then
                    return math.floor(v23 + 0.5)
                end
            end

            local v24, v25 = pcall(function() --[[ Upvalues: Player (upvalue) ]]
                return Player:GetNetworkPing() * 1000
            end)
            if v24 then
                if type(v25) == "number" and 0 < v25 then
                    return math.floor(v25 + 0.5)
                end
            end

            return nil
        end

        local function renderRegion() --[[ Upvalues: ServerRegion (copy), ReplicatedStorage1 (copy), getPingMs (copy) ]]
            if not ServerRegion.Parent then
                return
            end

            local v26 = ReplicatedStorage1:GetAttribute("ServerRegion")
            local v27 = type(v26) == "string" and v26 or "Locating..."
            local v28 = getPingMs()
            if v28 then
                local v29
                if v28 <= 100 then
                    v29 = "4ADE80"
                else
                    if v28 <= 200 then
                        v29 = "FBBF24"
                    else
                        v29 = "F87171"
                    end
                end

                local v30 = v27:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                ServerRegion.Text = v30 .. "  \226\128\162  " .. string.format("<font color=\"#%s\">%d ms</font>", v29, v28)
                return
            end

            ServerRegion.Text = v27:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
        end

        renderRegion()
        local v31 = ReplicatedStorage1:GetAttributeChangedSignal("ServerRegion")
        v31:Connect(renderRegion)
        task.spawn(function() --[[ Upvalues: ServerRegion (copy), renderRegion (copy) ]]
            while ServerRegion.Parent do
                renderRegion()
                task.wait(1)
            end

        end)
    end

    a0.MainContext = a0.Player.PlayerScripts:WaitForChild("MainContext")
    a0.Mouse = a0.Player:GetMouse()
    a0.TouchEnabled = _G.Utl.isTouchDevice()
    a0.ClassicMobileLauncher = v17.Mobile.InstallLauncher(a0)
    a0.RunView = false
    a0.DefaultIcon = "rbxassetid://14500597267"
    a0.BaseStorage = nil
    a0.SlideCD = 0
    a0.EditObjectRotate = 0
    a0.EditObjectFlip = 0
    a0.EditObjectFlip2 = 0
    a0.DeletingObjects = false
    a0.CrouchView = false
    a0.BaseCustomType = "Wall"
    a0.Mouse.Icon = a0.DefaultIcon
    a0.HighlightHover = Instance.new("Highlight")
    a0.HighlightHover.FillTransparency = 0.5
    a0.HighlightHover.FillColor = Color3.fromRGB(255, 224, 224)
    a0.HighlightHover.OutlineColor = Color3.fromRGB(255, 162, 162)
    a0.HighlightHover.OutlineTransparency = 0
    a0.HighlightHover.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    a0.Player.CharacterAdded:Connect(function(a0) --[[ Upvalues: a0 (copy) ]]
        a0:CharacterLoaded(a0)
    end)
    if a0.Player.Character then
        a0:CharacterLoaded(a0.Player.Character)
    end

    a0.Springs = {}
    a0.Springs.recoil = v1.create()
    a0.ClientButtons = {}

    local function getModel(a0) --[[ Upvalues: a0 (copy) ]]
        local v32 = nil
        local v33 = a0
        for i1 = 1, 5 do
            local Parent = v33.Parent
            if Parent and Parent.Parent == Objects1 then
                v32 = Parent
                return v32
            end

            v33 = Parent
        end

        return v32
    end

    if a0.TouchEnabled then

        local function handleAction(a0, a1, a2) --[[ Upvalues: a0 (copy), RemoteEvent (upvalue) ]]
            if a0 == "Claim" and a1 == Enum.UserInputState.Begin and a0.StorageHover then
                RemoteEvent:FireServer("ClaimStorage", a0.StorageHover)
            end
        end

        ContextActionService:BindAction("Claim", handleAction, true)
        ContextActionService:SetTitle("Claim", "Claim")
        local v36 = ContextActionService:GetButton("Claim")
        v36.ActionTitle.TextScaled = true
        v36.Position = UDim2.new(-0.7, 0, -0.25, 0)
        v36.Size = UDim2.new(0.2, 0, 0.2, 0)
        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
        UIAspectRatioConstraint.AspectRatio = 1
        UIAspectRatioConstraint.Parent = v36
        UserInputService.TouchTapInWorld:Connect(function(a0, a1) --[[ Upvalues: a0 (copy), RemoteEvent (upvalue) ]]
            if a1 or a0.Painting then
                return
            end

            if a0.Painting then
                local v37, v38 = a0:GetMobileAim(a0, true, "Viewport")
                v37 = nil
                if v38 then
                    v37 = v38.Instance
                end

                if a0.PaintMode == "ColorDropper" and v37 then
                    a0.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3 = v37.Color
                    return
                end

                if a0.PaintMode ~= "ColorDropper" and a0.PaintMode ~= "None" and v37 and v37:IsDescendantOf(a0.StorageBase.Contents.Objects) then
                    local t2 = {
                        v37,
                        a0.PaintMode,
                        a0.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3
                    }
                    RemoteEvent:FireServer("PaintBaseObject", t2)
                end
            end

        end)
    end

    local v39 = {
        "RightUpperArm",
        "RightLowerArm",
        "RightHand",
        "LeftUpperArm",
        "LeftLowerArm",
        "LeftHand"
    }
    RunService:UnbindFromRenderStep("StorageFPSArmVisibility")
    local v40 = Enum.RenderPriority.Camera.Value + 1
    RunService:BindToRenderStep("StorageFPSArmVisibility", v40, function() --[[ Upvalues: a0 (copy), v39 (copy) ]]
        local Character = a0.Character
        if not Character then
            return
        end

        if not a0.BuildCameraActive then
            if a0.Data then
                if not a0.Data.HideArm then
                    -- jump to 21
                end

                -- branch continues at 21
            end
        end

        local v41 = 1
        for k1, k2 in ipairs(v39) do
            local v45 = Character:FindFirstChild(k2)
            if v45 and v45:IsA("BasePart") and v45.LocalTransparencyModifier ~= v41 then
                v45.LocalTransparencyModifier = v41
            end
        end

    end)
    a0:SetupSafezoneGates()
    local v46 = 0
    local v47 = nil
    local v48 = 0
    RunService.RenderStepped:Connect(function(a0) --[[ Upvalues: a0 (copy), TweenService (upvalue), v46 (ref), v47 (ref), UnreliableRemoteEvent (upvalue), Animations (upvalue), v48 (ref), UserInputService (upvalue), ContextActionService (upvalue) ]]
        a0:UpdateFreeMouse()
        a0:UpdateSafezoneGates(a0)
        if a0.Humanoid then
            local JumpHeight = a0.JumpHeight
            if a0.Sliding then
                JumpHeight = 0
            end

            local v49
            if a0.Humanoid.Health < 20 then
                v49 = v49 * 0.5
                JumpHeight = 0
            end

            if a0.Humanoid.WalkSpeed ~= v49 then
                a0.Humanoid.WalkSpeed = v49
            end

            if a0.Humanoid.JumpHeight ~= JumpHeight then
                a0.Humanoid.JumpHeight = JumpHeight
            end

            JumpHeight = "X: " .. math.floor(a0.Root.Position.X)
            v49 = "Z: " .. math.floor(a0.Root.Position.Z)
            if a0.HUD.XCoordinate.Text ~= JumpHeight then
                a0.HUD.XCoordinate.Text = JumpHeight
            end

            if a0.HUD.ZCoordinate.Text ~= v49 then
                a0.HUD.ZCoordinate.Text = v49
            end
        end

        if a0.Character then
            if a0.Character:GetAttribute("Running") then
                if not a0.CinematicActive then
                    if not a0.RunView then
                        a0.RunView = true
                        local v50 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        TweenService:Create(a0.Camera, v50, {FieldOfView = 90}):Play()
                        local v51 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        TweenService:Create(a0.Humanoid, v51, {CameraOffset = Vector3.new(0, 0.5, 0)}):Play()
                        -- branch continues at 240
                    end

                    -- branch continues at 188
                end

                -- branch continues at 188
            end
        else
            if a0.RunView then
                a0.RunView = false
                local v52 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                TweenService:Create(a0.Camera, v52, {FieldOfView = 70}):Play()
                local v53 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                TweenService:Create(a0.Humanoid, v53, {CameraOffset = Vector3.new(0, 0.5, 0.15000000596046448)}):Play()
            end
        end

        if a0.Character:GetAttribute("Flooded") then
            local v54 = time()
            local Y = a0.Camera.CFrame.LookVector.Y
            local v55 = v54 - v46
            if 0.1 <= v55 then
                if v47 ~= nil then
                    local v56 = math.abs(Y - v47)
                    if 0.02 > v56 then
                        -- jump to 288
                    end
                end

                v46 = v54
                v47 = Y
                UnreliableRemoteEvent:FireServer("FloodPitch", Y)
            end

            if not a0.UnderwaterView then
                a0.UnderwaterView = true
                if not a0.UnderwaterCC then
                    local Lighting = game:GetService("Lighting")
                    v54 = Instance.new("ColorCorrectionEffect")
                    v54.Name = "UnderwaterFilter"
                    v54.Parent = Lighting
                    a0.UnderwaterCC = v54
                    v54 = Instance.new("BlurEffect")
                    v54.Name = "UnderwaterBlur"
                    v54.Size = 0
                    v54.Parent = Lighting
                    a0.UnderwaterBlur = v54
                end

                local v57 = TweenInfo.new(0.6)
                local v58 = {
                    Brightness = -0.05,
                    Contrast = -0.1,
                    Saturation = -0.2,
                    TintColor = Color3.fromRGB(125, 180, 218)
                }
                TweenService:Create(a0.UnderwaterCC, v57, v58):Play()
                local v59 = TweenInfo.new(0.6)
                TweenService:Create(a0.UnderwaterBlur, v59, {Size = 8}):Play()
                -- branch continues at 447
            end
        else
            if a0.UnderwaterView then
                a0.UnderwaterView = false
                v47 = nil
                if a0.UnderwaterCC then
                    local v60 = TweenInfo.new(0.6)
                    local v61 = {
                        Brightness = 0,
                        Contrast = 0,
                        Saturation = 0,
                        TintColor = Color3.fromRGB(255, 255, 255)
                    }
                    TweenService:Create(a0.UnderwaterCC, v60, v61):Play()
                end

                if a0.UnderwaterBlur then
                    local v62 = TweenInfo.new(0.6)
                    TweenService:Create(a0.UnderwaterBlur, v62, {Size = 0}):Play()
                end
            end
        end

        if a0.Character:GetAttribute("Crouch") then
            if not a0.CrouchAnim then
                a0.CrouchAnim = a0:LoadAnimation(Animations.Crouch)
                a0.CrouchAnim:Play()
            end

            if not a0.CrouchView then
                a0.CrouchView = true
                local v63 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                TweenService:Create(a0.Humanoid, v63, {CameraOffset = Vector3.new(0, -0.5, 0)}):Play()
                -- branch continues at 554
            end
        else
            if a0.CrouchAnim then
                a0.CrouchAnim:Stop()
                a0.CrouchAnim = nil
            end

            if a0.CrouchView then
                a0.CrouchView = false
                local v64 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                TweenService:Create(a0.Humanoid, v64, {CameraOffset = Vector3.new(0, 0.5, 0.15000000596046448)}):Play()
            end
        end

        if not a0.Character:GetAttribute("Ragdolled") and not a0.CinematicActive then
            a0:UpdateCamera(a0)
        end

        if a0.ViewingPlayer then
            if a0.Camera.CameraSubject ~= a0.ViewingPlayer then
                a0.Camera.CameraSubject = a0.ViewingPlayer
            end

            if a0.Player.CameraMode ~= Enum.CameraMode.Classic then
                a0.Player.CameraMode = Enum.CameraMode.Classic
            end

            if a0.Player.CameraMinZoomDistance ~= 5 then
                a0.Player.CameraMinZoomDistance = 5
            end

            if a0.Player.CameraMaxZoomDistance ~= 20 then
                a0.Player.CameraMaxZoomDistance = 20
                -- branch continues at 698
            end
        else
            if a0.Camera.CameraSubject ~= a0.Humanoid then
                a0.Camera.CameraSubject = a0.Humanoid
            end

            if a0.Player.CameraMode ~= Enum.CameraMode.LockFirstPerson then
                a0.Player.CameraMode = Enum.CameraMode.LockFirstPerson
            end

            if a0.Player.CameraMinZoomDistance ~= 0.5 then
                a0.Player.CameraMinZoomDistance = 0.5
            end

            if a0.Player.CameraMaxZoomDistance ~= 0.5 then
                a0.Player.CameraMaxZoomDistance = 0.5
            end
        end

        local v65 = a0.Player:GetAttribute("Safezone")
        local v66 = a0.Player:GetAttribute("PVPShield")
        local Safezone = a0.HUD:FindFirstChild("Safezone")
        if Safezone then
            if v65 then
                if Safezone.Text ~= "SAFE ZONE" then
                    Safezone.Text = "SAFE ZONE"
                    Safezone.TextColor3 = Color3.fromRGB(125, 255, 105)
                end

                if Safezone.Label.Visible then
                    Safezone.Label.Visible = false
                end

                if not Safezone.Visible then
                    Safezone.Visible = true
                    -- branch continues at 839
                end
            else
                if v66 then
                    if os.time() < v66 then
                        if Safezone.Text ~= "PROTECTED" then
                            Safezone.Text = "PROTECTED"
                            Safezone.TextColor3 = Color3.fromRGB(255, 212, 112)
                            Safezone.Label.TextColor3 = Color3.fromRGB(255, 232, 180)
                        end

                        if not Safezone.Label.Visible then
                            Safezone.Label.Visible = true
                        end

                        local v67 = "Leaving safezone " .. _G.Utl.timeFormat(v66 - os.time())
                        if Safezone.Label.Text ~= v67 then
                            Safezone.Label.Text = v67
                        end

                        if not Safezone.Visible then
                            Safezone.Visible = true
                            -- branch continues at 839
                        end

                        -- branch continues at 833
                    end
                else
                    if Safezone.Visible then
                        Safezone.Visible = false
                    end
                end
            end
        end

        local v68 = time() - v48
        if 0.33 < v68 then
            v48 = time()
            if a0.Root then
                if not a0.StorageBase then
                    if UserInputService.GamepadEnabled then
                        a0.HUD.ClaimStorage.Text = "Press DPAD Left to Claim Storage."
                    else
                        a0.HUD.ClaimStorage.Text = "Press C to Claim Storage."
                    end

                    Safezone = {workspace.Storages}
                    v66 = workspace:FindFirstChild("SafezoneUnits")
                    if v66 then
                        table.insert(Safezone, v66)
                    end

                    local v69 = {
                        Origin = a0.Root.Position,
                        Dir = a0.Root.CFrame.LookVector * 6,
                        Whitelist = Safezone
                    }
                    v65 = _G.Utl.Raycast(v69)
                    local v70 = nil
                    if v65 then
                        Safezone = v65.Instance
                        while Safezone do
                            if Safezone == workspace then
                                break
                            end

                            if Safezone:IsA("Model") then
                                if Safezone.Parent == workspace.Storages or Safezone.Parent == v66 then
                                    v70 = Safezone
                                    break
                                end
                            end

                            Safezone = Safezone.Parent
                        end
                    end

                    v66 = v70
                    if v66 then
                        v66 = false
                        if v70.Name == "Room" then
                            local v76 = not v70:GetAttribute("Opened") and not v70:GetAttribute("Owner") and not v70:GetAttribute("Locked") and not v70:GetAttribute("DoorBusy") and not v70:GetAttribute("Unclaiming") and not v70:GetAttribute("ReservedForBase")
                        end
                    end

                    if v66 then
                        if a0.TouchEnabled then
                            v65 = ContextActionService:GetButton("Claim")
                            v65.Visible = true
                        else
                            a0.HUD.ClaimStorage.Visible = true
                        end

                        a0.StorageHover = v70
                        -- jump to 1240 (out of range)
                    end

                    if a0.TouchEnabled then
                        local v77 = ContextActionService:GetButton("Claim")
                        v77.Visible = false
                    end

                    a0.StorageHover = nil
                    a0.HUD.ClaimStorage.Visible = false
                    -- branch continues at 1069
                end
            else
                if a0.Root and a0.StorageBase then
                    a0.HUD.ClaimStorage.Visible = false
                    a0.StorageHover = nil
                    if a0.TouchEnabled then
                        local v78 = ContextActionService:GetButton("Claim")
                        v78.Visible = false
                    end

                    local v79 = OverlapParams.new()
                    v79.FilterType = Enum.RaycastFilterType.Include
                    local v80 = {a0.Root}
                    v79.FilterDescendantsInstances = v80
                    v79.MaxParts = 1
                    local StorageBase = a0.StorageBase
                    local v82 = StorageBase and StorageBase:FindFirstChild("Basement")
                    local v84 = StorageBase and StorageBase:FindFirstChild("Contents")
                    local v85 = nil
                    if v82 then
                        v85 = v82:FindFirstChild("BoundingBox")
                    else
                        if v84 then
                            v85 = v84:FindFirstChild("BoundingBox")
                        end
                    end

                    if v85 then
                        v84 = workspace:GetPartBoundsInBox(v85.CFrame, v85.Size, v79)
                        v82 = false
                        for k3, k4 in pairs(v84) do
                            v82 = true
                            break
                        end

                        if v82 and not a0.Player:GetAttribute("InBase") then
                            a0.Player:SetAttribute("InBase", true)
                            a0.HUD.BaseEdit.Visible = true
                        else
                            if not v82 and a0.Player:GetAttribute("InBase") then
                                a0:NotInBase()
                            else
                                if not v82 and a0.HUD.BaseEdit.Visible then
                                    a0.HUD.BaseEdit.Visible = false
                                end
                            end
                        end
                    end
                end
            end
        end

        if a0.EditObject then
            local v89 = nil
            if a0.ClassicBuildActive then
                local v90 = a0:GetClassicBuildAim()
                if v90 then
                    v89 = a0:CalcPlacementCFrame(v90.Position)
                    -- branch continues at 1322
                end
            else
                if a0.ModernMobile and a0.ModernMobile:IsActive() then
                    v89 = a0:GetBuildObjectCFrame()
                else
                    if a0.TouchEnabled then
                        v89 = a0:CalcPlacementCFrame(a0:GetMobileAim(nil, false).Position)
                    else
                        v89 = a0:CalcPlacementCFrame(a0.Mouse.Hit.Position)
                    end
                end
            end

            if v89 then
                a0.EditObject:PivotTo(v89)
                if a0.BuildCameraActive then
                    if not a0.ClassicBuildActive then
                        a0:UpdateBuildGizmo(v89)
                        a0:RefreshBuildValidation(false)
                        -- branch continues at 1458
                    end

                    -- branch continues at 1458
                end

                -- branch continues at 1458
            end
        else
            if a0.EditingBase then
                if a0.BuildCameraActive then
                    if not a0.Painting then
                        if not (a0.ClassicController and a0.ClassicController:BlocksWorld()) then
                            if not (a0.ClassicMobile and a0.ClassicMobile:BlocksWorld()) then
                                if a0.ModernController then
                                    if not a0.ModernController:BlocksWorld() then
                                        -- jump to 1406
                                    end

                                    -- branch continues at 1406
                                end
                            end
                        end

                        a0:ClearBuildObjectHover()
                    end
                end
            end
        end

        local v91 = false
        if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
            v91 = a0.Player.PlayerGui:GetAttribute("ControllerBackpackActive") == true
        end

        local v92 = nil
        if a0.UpdatingMouse then
            if v91 then
                v92 = a0:GetAim()
                UnreliableRemoteEvent:FireServer("UpdateMouse", v92)
            else
                if a0.TouchEnabled then
                    local v93 = a0:GetMobileAim(nil, false)
                    UnreliableRemoteEvent:FireServer("UpdateMouse", v93)
                else
                    UnreliableRemoteEvent:FireServer("UpdateMouse", a0.Mouse.Hit)
                end
            end
        end

        if a0.ReportingAim and a0.Mouse then
            local v94 = time() - (a0.LastAimReport or 0)
            if 0.03 < v94 then
                a0.LastAimReport = time()
                if v91 then
                    local v95 = v92
                    if not v95 then
                        local v96 = a0:GetAim()
                        if v96 then
                            -- jump to 1583
                        end

                        -- branch continues at 1583
                    end
                end

                local v98
                if not (a0.TouchEnabled and a0:GetMobileAim(nil, false)) then
                    v98 = a0.Mouse.Hit
                end

                if v98 then
                    UnreliableRemoteEvent:FireServer("ReportAim", v98.Position)
                end
            end
        end

    end)
    local Events1 = a0.HUD.Events
    local EventsInfo = a0.HUD.EventsInfo

    local function updateEvents() --[[ Upvalues: Events1 (copy), Events (upvalue), v18 (upvalue), EventsInfo (copy) ]]
        local v99 = Events1:GetChildren()
        for k5, k6 in pairs(v99) do
            if k6:IsA("ImageLabel") and k6.Name ~= "Sample" and not Events:FindFirstChild(k6.Name) then
                k6:Destroy()
            end
        end

        local v103 = Events:GetChildren()
        for k7, k8 in pairs(v103) do
            if not Events1:FindFirstChild(k8.Name) then
                local v108 = v18[k8.Name]
                if v108 then
                    local v109 = Events1.Sample:Clone()
                    v109.Image = v108.Icon
                    v109.Name = k8.Name
                    v109.Visible = true
                    v109.Parent = Events1
                    v109.MouseEnter:Connect(function() --[[ Upvalues: EventsInfo (upvalue), v108 (copy) ]]
                        EventsInfo.EventLabel.Text = v108.EventLabelText
                        EventsInfo.EventLabel.TextColor3 = v108.EventLabelTextColor
                        EventsInfo.EventLabel.UIStroke.Color = v108.EventLabelStrokeColor
                        EventsInfo.DescLabel.Text = v108.Desc
                        EventsInfo.Visible = true
                    end)
                    v109.MouseLeave:Connect(function() --[[ Upvalues: EventsInfo (upvalue) ]]
                        EventsInfo.Visible = false
                    end)
                end
            end
        end
    end

    updateEvents()
    Events.ChildAdded:Connect(updateEvents)
    Events.ChildRemoved:Connect(updateEvents)
    if MarketplaceService:UserOwnsGamePassAsync(a0.Player.UserId, 245559423) then
        a0:ActivateClock()
    end
end

getBobbing.SetUp = SetUp

local function UpdateData(a0, a1)
    a0.Data = a1
    a0:CandyCornChanged(a1.CandyCorn)
    if a0.CustomBackpack then
        a0.CustomBackpack:SetCursorPreference(a1.BackpackCursorMode)
    end

    if a0.DesktopCatalogue then
        a0.DesktopCatalogue:Refresh()
    end
end

getBobbing.UpdateData = UpdateData

local function UpdateData2(a0, a1) --[[ Upvalues: v10 (copy) ]]
    if a1.Type == "ItemDelta" then
        local Data = a0.Data
        local v110
        if not (typeof(a0.Data.Items) == "table" and a0.Data.Items) then
            v110 = {}
        end

        Data.Items = v110
        if typeof(a1.Item) == "string" then
            if a1.Item ~= "" then
                if a1.Removed == true then
                    a0.Data.Items[a1.Item] = nil
                    return
                end

                if typeof(a1.Data) == "table" then
                    a0.Data.Items[a1.Item] = a1.Data
                end
            end
        end

        return
    end

    if a1.Type == "ItemBatchDelta" then
        local Data1 = a0.Data
        local v111
        if not (typeof(a0.Data.Items) == "table" and a0.Data.Items) then
            v111 = {}
        end

        Data1.Items = v111
        if typeof(a1.Deltas) == "table" then
            for k9, k10 in ipairs(a1.Deltas) do
                if typeof(k10) == "table" then
                    if typeof(k10.Item) == "string" then
                        if k10.Item ~= "" then
                            if k10.Removed == true then
                                a0.Data.Items[k10.Item] = nil
                            else
                                if typeof(k10.Data) == "table" then
                                    a0.Data.Items[k10.Item] = k10.Data
                                end
                            end
                        end
                    end
                end
            end
        end

        return
    end

    a0.Data[a1.Type] = a1.Data
    if a1.Type == "CandyCorn" then
        a0:CandyCornChanged(a1.Data)
    end

    if a1.Type == "CandyCorn" or a1.Type == "Skins" then
        if a0.ShopArgs and a0.ShopArgs[2] == "Pumpkin X" then
            a0:UpdateShopGui()
        end
    end

    if a0.DesktopCatalogue then
        if a1.Type == "BaseItems" or a1.Type == "Money" or a1.Type == "UnlockedObjects" or a1.Type == "CurrentSkins" then
            a0.DesktopCatalogue:Refresh()
        end
    end

    if a1.Type == "Skins" or a1.Type == "CurrentSkins" then
        if a0.HUD.Skins.Visible then
            a0:UpdateSkins(a0.SkinItem, false)
            return
        end
    end

    if a1.Type == "Achievements" and a0.HUD.Achievements.Visible then
        a0:UpdateAchievements()
        return
    end

    if a1.Type == "ExtraBank" or a1.Type == "Bank" then
        if a0.HUD.Bank.Visible then
            a0:UpdateBank()
            a0:InitBank()
            return
        end
    end

    if a1.Type == "LikeBonus" then
        a0.HUD.LikeButton.Visible = false
        a0.HUD.LikeReward.Visible = false
        return
    end

    if a1.Type == "BaseItems" and a0.HUD.BaseObjects.Visible then
        a0:UpdateBaseObjects(a0.CurrentBaseObjects)
        return
    end

    if a1.Type == "ShopFormat" then
        if a0.ShopGui then
            a0:UpdateShopGui()
            return
        end

        if a0.HUD.Bank.Visible then
            a0:UpdateBank()
            return
            -- branch continues at 495
        end
    end

    if a1.Type == "Keybinds" then
        a0:UpdateKeybinds()
        return
    end

    if a1.Type == "MobileButtonPos" then
        a0:UpdateMobileButtons()
        return
    end

    if a1.Type == "Hotbar" and a0.CustomBackpack then
        a0.CustomBackpack:SetSavedHotbar(a1.Data)
        return
    end

    if a1.Type == "BackpackCursorMode" and a0.CustomBackpack then
        a0.CustomBackpack:SetCursorPreference(a1.Data)
        return
    end

    if a1.Type == "DailyReward" then
        a0:UpdateDailyRewards()
        return
    end

    if a1.Type == "HoldToSprint" then
        a0:UpdateSprintToggle()
        return
    end

    if a1.Type == "HideArm" then
        a0:UpdateHideArm()
        return
    end

    if a1.Type == "TradeRequests" then
        a0:UpdateTradeRequests()
        return
    end

    if a1.Type == "BuildSystem" then
        a0:UpdateBuildSystem()
        return
    end

    if a1.Type == "BaseUnitSize" or a1.Type == "UnitSize2Unlocked" or a1.Type == "BaseBasement" or a1.Type == "ExtraStorageGamepass" or a1.Type == "ExtraStorageUpgrade" or a1.Type == "ExtraStorageCap" or a1.Type == "StorageCapacitySplitMigrated" then
        a0:UpdateStorageCapacity()
        return
    end

    if a1.Type == "GamepassGrants" then
        a0:UpdateStorageCapacity()
        if v10.HasGrant(a1.Data, 245559423) then
            a0:ActivateClock()
        end
    end
end

getBobbing.UpdateData2 = UpdateData2

local function UpdateSprintToggle(a0)
    if a0.Data.HoldToSprint then
        a0.HUD.Settings.Main.SprintToggle.Text = "Sprint: Hold"
        return
    end

    a0.HUD.Settings.Main.SprintToggle.Text = "Sprint: Toggle"
end

getBobbing.UpdateSprintToggle = UpdateSprintToggle

local function UpdateHideArm(a0)
    if a0.Data.HideArm then
        a0.HUD.Settings.Main.HideArm.Text = "Arms: Hidden"
        return
    end

    a0.HUD.Settings.Main.HideArm.Text = "Arms: Shown"
end

getBobbing.UpdateHideArm = UpdateHideArm

local function UpdateTradeRequests(a0)
    if a0.Data.TradeRequests ~= false then
        a0.HUD.Settings.Main.TradeRequests.Text = "Trade Requests: On"
        return
    end

    a0.HUD.Settings.Main.TradeRequests.Text = "Trade Requests: Off"
end

getBobbing.UpdateTradeRequests = UpdateTradeRequests

local function UpdateBuildSystem(a0)
    local v115 = a0:IsClassicBuildSystem()
    local BuildSystem = a0.HUD.Settings.Main:FindFirstChild("BuildSystem")
    if BuildSystem then
        local v116
        if v115 then
            v116 = "Building: Classic"
        else
            v116 = "Building: Modern"
        end

        BuildSystem.Text = v116
    end

    local v117 = a0.BuildGui and a0.BuildGui:FindFirstChild("BuildSystemToggle")
    if v117 then
        local v118
        if v115 then
            v118 = "System: Classic"
        else
            v118 = "System: Modern"
        end

        v117.Text = v118
    end
end

getBobbing.UpdateBuildSystem = UpdateBuildSystem

local function SetBuildSystem(a0, a1, a2) --[[ Upvalues: GuiService (copy), RemoteEvent (copy) ]]
    if a0.BuildSystemSwitching then
        return false
    end

    local v119 = a1
    if v119 ~= "Classic" then
        if v119 ~= "Modern" then
            local v120
            if a0:IsClassicBuildSystem() then
                v120 = "Modern"
            else
                v120 = "Classic"
            end

            v119 = v120
        end
    end

    local v121
    if a0:IsClassicBuildSystem() then
        v121 = "Classic"
    else
        v121 = "Modern"
    end

    if v119 == v121 then
        a0:UpdateBuildSystem()
        return true
    end

    local v122 = nil
    if a2 then
        if not a0.BuildCameraActive or a0.BuildModeKind ~= "Objects" or a0.Painting then
            return false
        end

        a0.BuildSystemSwitching = true
        a0:SetDeleteAllConfirmation(false)
        a0:EndBuildTouchGizmoDrag()
        a0:EndBuildTransformHold()
        a0:EndDirectBuildDrag()
        a0.BuildGizmoDragging = nil
        a0:DeleteEditObject()
        a0:SetDeletingObjects(false)
        GuiService.SelectedObject = nil
        v122 = a0:EndBuildMode(true)
    end

    a0.Data.BuildSystem = v119
    a0:UpdateBuildSystem()
    RemoteEvent:FireServer("ChangeBuildSystem", v119)
    if a2 then
        v121 = a0:BeginBuildMode("Objects", v122)
        a0.BuildSystemSwitching = nil
        if v121 then
            if v119 == "Classic" then
                if a0.EditingBase then
                    if a0.CurrentSubCategory == "Favorites" or a0.CurrentSubCategory == "Recent" then
                        a0.CurrentSubCategory = "All"
                    end

                    a0:UpdateSubCategories(a0.CurrentBaseObjects)
                    a0:UpdateBaseObjects(a0.CurrentBaseObjects)
                end
            end

            a0:UpdateBuildGui()
        else
            if a0.EditingBase then
                a0:StopEditStorage()
            end
        end

        return v121 == true
    end

    return true
end

getBobbing.SetBuildSystem = SetBuildSystem

local function Activate(a0, a1) --[[ Upvalues: v10 (copy), RemoteEvent (copy), AvatarEditorService (copy), UserInputService (copy) ]]
    if typeof(a1) ~= "table" then
        return
    end

    a0.Data = a1
    a0:CandyCornChanged(a1.CandyCorn)
    if a0.CustomBackpack then
        a0.CustomBackpack:SetSavedHotbar(a1.Hotbar)
        a0.CustomBackpack:SetCursorPreference(a1.BackpackCursorMode)
    end

    a0:UpdateKeybinds()
    if v10.HasGrant(a1.GamepassGrants, 245559423) then
        a0:ActivateClock()
    end

    if a0.Activated == true then
        return
    end

    a0.Activated = true
    a0.OldMoney = 0
    a0:UpdateAchievements()
    a0:ArmorChanged(a0.Data.Armor)
    a0:HungerChanged(a0.Data.Hunger)
    a0:ThirstChanged(a0.Data.Thirst)
    a0:MoneyChanged(a0.Data.Money)
    a0:LevelChanged(a0.Data.Level)
    a0:EXPChanged(a0.Data.Level, a0.Data.EXP)
    a0:UpdateBank()
    if not a0.Data.LikeBonus then
        a0.HUD.LikeButton.Visible = true
        a0.HUD.LikeButton.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0.HUD.LikeReward.Visible = not a0.HUD.LikeReward.Visible
        end)
        a0.HUD.LikeReward.Later.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0.HUD.LikeReward.Visible = false
        end)
        a0.HUD.LikeReward.Claim.MouseButton1Click:Connect(function() --[[ Upvalues: RemoteEvent (upvalue), AvatarEditorService (upvalue) ]]
            RemoteEvent:FireServer("VerifyLikeBonus")
            AvatarEditorService:PromptSetFavorite(game.PlaceId, Enum.AvatarItemType.Asset, true)
        end)
    end

    a0.HUD.DailyRewardsButton.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0.HUD.DailyRewards.Visible = not a0.HUD.DailyRewards.Visible
    end)
    a0.HUD.DailyRewards.Close.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0.HUD.DailyRewards.Visible = false
    end)
    a0.HUD.DailyRewards.Claim.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy), RemoteEvent (upvalue) ]]
        if a0.Data.DailyReward.LastClaim == _G.Utl.GetNearestDay() then
            return
        end

        RemoteEvent:FireServer("ClaimDailyReward")
    end)
    task.spawn(function() --[[ Upvalues: a0 (copy) ]]
        while task.wait(1) do
            local DailyReward = a0.Data.DailyReward
            local v123 = _G.Utl.GetNearestDay()
            if DailyReward.LastClaim < v123 then
                a0.HUD.DailyRewards.Timer.Text = "Ready!"
                a0.HUD.DailyRewardsButton.Alert.Visible = true
            else
                if DailyReward.LastClaim == v123 then
                    local v124 = v123 + 86400 - os.time()
                    a0.HUD.DailyRewards.Timer.Text = _G.Utl.timeFormat(v124)
                    a0.HUD.DailyRewardsButton.Alert.Visible = false
                end
            end
        end

    end)
    a0:UpdateDailyRewards()
    if UserInputService.TouchEnabled then
        a0:UpdateMobileButtons()
    end
end

getBobbing.Activate = Activate

local function CharacterLoaded(a0, a1) --[[ Upvalues: UserInputService (copy), v2 (copy) ]]
    if a0.EditingBase then
        a0:StopEditStorage()
    else
        if a0.Painting then
            a0:ClosePaintFrames()
        end
    end

    a0.Character = a1
    a0.Humanoid = a1:WaitForChild("Humanoid")
    a0.Root = a1:WaitForChild("HumanoidRootPart")
    a0.Animator = a0.Humanoid:WaitForChild("Animator")
    a0.Humanoid.Died:Once(function() --[[ Upvalues: a0 (copy) ]]
        if a0.EditingBase then
            a0:StopEditStorage()
            return
        end

        if a0.Painting then
            a0:ClosePaintFrames()
        end

    end)
    a0.WalkSpeed = 12
    a0.JumpHeight = 7.2
    local v125 = UserInputService:GetFocusedTextBox()
    if v125 then
        v125:ReleaseFocus()
    end

    if a0.BankChannel then
        a0.BankChannel:Cancel()
        a0.BankChannel = nil
    end

    a0:ClearBankCons()
    a0.BankObject = nil
    a0.BankOpening = false
    a0.ClosingBank = false
    a0.HUD.Bank.Visible = false
    a0.FreeMouse = nil
    a0.Camera = workspace.CurrentCamera
    a0.Camera.CameraType = Enum.CameraType.Custom
    a0.Camera.CameraSubject = a0.Humanoid
    a0.Humanoid.CameraOffset = Vector3.new(0, 0.5, 0.15000000596046448)
    a0.HUD.DropMoney.Visible = false
    a0.Character.AttributeChanged:Connect(function(a0) --[[ Upvalues: a0 (copy) ]]
        local v126 = {"Defense", "DamageMult", "SpeedAdd"}
        local v127 = a0.HUD.Traits:GetChildren()
        for k11, k12 in pairs(v127) do
            if not _G.Utl.tabFind(v126, k12.Name) then
                if k12:IsA("ImageLabel") then
                    if a0.Character:GetAttribute(k12.Name) then
                        k12.Visible = true
                    else
                        k12.Visible = false
                    end
                end
            end
        end

        if a0 == "DamageMult" then
            local v131 = a0.Character:GetAttribute("DamageMult")
            if 0 < v131 then
                local v132 = math.round(v131 * 100)
                a0.HUD.Traits.DamageMult.Val.Text = v132 .. "%"
                a0.HUD.Traits.DamageMult.Visible = true
                return
            end

            a0.HUD.Traits.DamageMult.Visible = false
            return
        end

        if a0 == "SpeedAdd" then
            local v133 = a0.Character:GetAttribute("SpeedAdd")
            if 0 < v133 then
                a0.HUD.Traits.SpeedAdd.Val.Text = "+" .. v133
                a0.HUD.Traits.SpeedAdd.Visible = true
                return
            end

            a0.HUD.Traits.SpeedAdd.Visible = false
            return
        end

        if a0 == "Defense" then
            local v134 = a0.Character:GetAttribute("Defense")
            if 0 < v134 then
                local v135 = math.round(v134 * 100)
                a0.HUD.Traits.Defense.Val.Text = v135 .. "%"
                a0.HUD.Traits.Defense.Visible = true
                return
            end

            a0.HUD.Traits.Defense.Visible = false
        end

    end)
    local v136 = a0.Character:GetChildren()
    for k13, k14 in pairs(v136) do
        if k14:IsA("Accessory") then
            local v141 = k14.Handle:FindFirstChildWhichIsA("WrapLayer")
            if v141 then
                v141.Enabled = false
            end
        end
    end

    local Buffs = a1:WaitForChild("Buffs")
    task.spawn(function() --[[ Upvalues: Buffs (copy), a1 (copy), a0 (copy), v2 (upvalue) ]]
        local t3 = {SpeedAdd = {}, DamageMult = {}, Defense = {}}
        while Buffs.Parent == a1 do
            task.wait(1)
            if a0.Humanoid.Health <= 0 then
                break
            end

            local v142 = Buffs:GetChildren()
            for k15, k16 in pairs(v142) do
                local v146 = v2[k16.Name]
                if v146 then
                    if os.time() <= k16.Value then
                        if v146.SpeedAdd then
                            local v147 = {v146.SpeedAdd, k16.Value}
                            t3.SpeedAdd[k16.Name] = v147
                        end

                        if v146.DamageMult then
                            local v148 = {v146.DamageMult, k16.Value}
                            t3.DamageMult[k16.Name] = v148
                        end

                        if v146.Defense then
                            local v149 = {v146.Defense, k16.Value}
                            t3.Defense[k16.Name] = v149
                        end
                    end
                end
            end

            local v150 = a0.HUD.Traits:GetChildren()
            local v154, v155
            for k17, k18 in pairs(v150) do
                if t3[k18.Name] then
                    local v156 = k18.Timers:GetChildren()
                    for k19, k20 in pairs(v156) do
                        v155 = k20.Name
                        if v155 ~= "Sample" then
                            local v161 = k20:IsA("TextLabel")
                            if v161 then
                                local v163 = t3[k18.Name]
                                k20:Destroy()
                                local v164 = v163[k20.Name] or k20:Destroy()
                            end
                        end
                    end
                end
            end

            for k21, k22 in pairs(t3) do
                local Timers = a0.HUD.Traits[k21].Timers
                for k23, k24 in pairs(k22) do
                    local v171 = Timers:FindFirstChild(k23)
                    if not v171 then
                        v171 = Timers.Sample:Clone()
                        v171.Name = k23
                        local v172 = math.round(k24[2] - os.time())
                        v171.Text = "+" .. k24[1] .. " (" .. v172 .. "s)"
                        v171.Parent = Timers
                        v171.Visible = true
                    end

                    local v173 = math.round(k24[2] - os.time())
                    v171.Text = "+" .. k24[1] .. " (" .. v173 .. "s)"
                end
            end
        end

        local v174 = a0.HUD.Traits:GetChildren()
        for k25, k26 in pairs(v174) do
            if t3[k26.Name] then
                local v178 = k26.Timers:GetChildren()
                for k27, k28 in pairs(v178) do
                    if k28.Name ~= "Sample" and k28:IsA("TextLabel") then
                        k28:Destroy()
                    end
                end
            end
        end

    end)
end

getBobbing.CharacterLoaded = CharacterLoaded

local function LoadAnimation(a0, a1)
    local v182 = a0.Animator:LoadAnimation(a1)
    return v182
end

getBobbing.LoadAnimation = LoadAnimation

local function Attributes(a0, a1)
    a0.WalkSpeed = a1.WalkSpeed
    a0.JumpHeight = a1.JumpHeight
end

getBobbing.Attributes = Attributes

local function EnableState(a0, a1)
    if not a0.Humanoid then
        return
    end

    a0.Humanoid:SetStateEnabled(a1.State, a1.Bool)
end

getBobbing.EnableState = EnableState

local function Effects(a0, a1)
    local v183 = a1.EffectDist or 150
    if a1.Pos and v183 < (a0.Root.Position - a1.Pos).Magnitude then
        return
    end

    if a1.Origin then
        if typeof(a1.Origin) == "Vector3" then
            if v183 < (a0.Root.Position - a1.Origin).Magnitude then
                return
                -- branch continues at 56
            end
        else
            if v183 < (a0.Root.Position - a1.Origin.Position).Magnitude then
                return
            end
        end
    end

    local v184 = _G.Utl.FX[a1.Effect]
    v184(a1)
end

getBobbing.Effects = Effects

local function Sound(a0, a1)
    _G.Utl.PlaySound(a1)
end

getBobbing.Sound = Sound

local function UpdateCamera(a0, a1) --[[ Upvalues: UserInputService (copy) ]]
    local v185 = UserInputService:GetMouseDelta()
    local Velocity = a0.Root.Velocity
    local v186 = a0.Springs.recoil:update(a1)
    if not (a0.ClassicController and a0.ClassicController:BlocksWorld()) then
        if not (a0.ClassicMobile and a0.ClassicMobile:BlocksWorld()) then
            if a0.ModernController then
                if not a0.ModernController:BlocksWorld() then
                    -- jump to 49
                end

                -- branch continues at 49
            end
        end
    end

    return
    local Camera = a0.Camera
    local v187 = math.rad(v186.X)
    local v188 = math.rad(v186.Y)
    Camera.CFrame = Camera.CFrame * CFrame.Angles(v187, v188, math.rad(v186.Z))
end

getBobbing.UpdateCamera = UpdateCamera

local function GetAim(a0, a1) --[[ Upvalues: UserInputService (copy) ]]
    local CurrentCamera = workspace.CurrentCamera
    local v189
    if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad and a0.Player.PlayerGui:GetAttribute("ControllerBackpackActive") then
        local v190 = CurrentCamera.ViewportSize * 0.5
        v189 = CurrentCamera:ViewportPointToRay(v190.X, v190.Y)
    else
        v189 = CurrentCamera:ScreenPointToRay(a0.Mouse.X, a0.Mouse.Y)
    end

    local v191 = {
        a0.Character,
        a0.EditObject,
        workspace.Map,
        workspace.Storages,
        workspace.Mobs
    }
    local v192 = {Origin = v189.Origin, Dir = v189.Direction * 500, Blacklist = v191}
    CurrentCamera = _G.Utl.Raycast(v192)
    local v193
    if CurrentCamera then
        v193 = CFrame.new(CurrentCamera.Position, v189.Origin + v189.Direction * 500)
    else
        local v194 = CFrame.new(v189.Origin, v189.Origin + v189.Direction)
        v193 = v194 * CFrame.new(0, 0, -500)
    end

    if a1 then
        return CurrentCamera
    end

    return v193
end

getBobbing.GetAim = GetAim

local function GetMobileAim(a0, a1, a2, a3)
    local CurrentCamera1 = workspace.CurrentCamera
    local v195 = nil
    local v196
    if a1 then
        if a3 == "Viewport" then
            v196 = CurrentCamera1:ViewportPointToRay(a1.X, a1.Y)
            -- jump to 69 (out of range)
        end

        v196 = CurrentCamera1:ScreenPointToRay(a1.X, a1.Y)
    else
        local v197 = v195.AbsolutePosition.X + v195.AbsoluteSize.X / 2
        v196 = CurrentCamera1:ScreenPointToRay(v197, v195.AbsolutePosition.Y + v195.AbsoluteSize.Y / 2)
    end

    local v198
    if v195 then
        if v195 == a0.HUD.MobileMouse then
            local v199 = {a0.Character, a0.EditObject}
            local v200 = {Origin = v196.Origin, Dir = v196.Direction * 500, Blacklist = v199}
            v198 = _G.Utl.Raycast(v200)
            -- jump to 176 (out of range)
        end

        local v201 = {
            a0.Character,
            a0.EditObject,
            workspace.Map,
            workspace.Storages,
            workspace.Mobs
        }
        local v202 = {Origin = v196.Origin, Dir = v196.Direction * 500, Blacklist = v201}
        v198 = _G.Utl.Raycast(v202)
    else
        local v203 = {a0.Character}
        local v204 = {Origin = v196.Origin, Dir = v196.Direction * 500, Blacklist = v203}
        v198 = _G.Utl.Raycast(v204)
    end

    local v205
    if v198 then
        v205 = CFrame.new(v198.Position, v196.Origin + v196.Direction * 500)
    else
        local v206 = CFrame.new(v196.Origin, v196.Origin + v196.Direction)
        v205 = v206 * CFrame.new(0, 0, -500)
    end

    if a2 then
        return v205, v198
    end

    return v205
end

getBobbing.GetMobileAim = GetMobileAim

local function Noti(a0, a1) --[[ Upvalues: StarterGui (copy) ]]
    StarterGui:SetCore("SendNotification", a1)
end

getBobbing.Noti = Noti

local function OpeningDoor(a0) --[[ Upvalues: TweenService (copy) ]]
    local v207 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(a0.Humanoid, v207, {CameraOffset = Vector3.new(0, 0, -0.10000000149011612)}):Play()
    task.wait(0.55)
    local v208 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(a0.Humanoid, v208, {CameraOffset = Vector3.new(0, 0.5, 0.15000000596046448)}):Play()
end

getBobbing.OpeningDoor = OpeningDoor

local function UpdateFreeMouse(a0) --[[ Upvalues: UserInputService (copy) ]]
    local v209 = true
    if a0.FreeMouse ~= true then
        if a0.ShopGui == nil or true == nil then
            if a0.SellGui == nil or true == nil then
                if a0.CraftGui == nil or true == nil then
                    if a0.GlobalShopGui == nil or true == nil then
                        local Visible = a0.HUD.Dialogue.Visible
                        if not Visible then
                            local Visible1 = a0.HUD.Bank.Visible
                            if not Visible1 then
                                local Visible2 = a0.HUD.Brewing.Visible
                                if not Visible2 then
                                    local Visible3 = a0.HUD.Shop.Visible
                                    if not Visible3 then
                                        Visible3 = UserInputService:GetFocusedTextBox() ~= nil
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if a0.HUD.Modal.Visible ~= v209 then
        a0.HUD.Modal.Visible = v209
    end
end

getBobbing.UpdateFreeMouse = UpdateFreeMouse

local function ClearDialogue(a0)
    local Dialogue = a0.HUD.Dialogue
    for k29, k30 in Dialogue.Choices:GetChildren() do
        if k30:IsA("ImageButton") and k30.Name ~= "Sample" then
            k30:Destroy()
        end
    end

    Dialogue.MainText.Text = ""
    Dialogue.NPCName.Text = ""
end

getBobbing.ClearDialogue = ClearDialogue

local function Dialogue3(a0, a1) --[[ Upvalues: RemoteEvent (copy) ]]
    a0.DialogueRenderGeneration = (a0.DialogueRenderGeneration or 0) + 1
    local DialogueRenderGeneration = a0.DialogueRenderGeneration
    a0.DialogueChoicePending = nil
    a0:ClearDialogue()
    a0:CloseShopGui()
    local NPC = a1.NPC
    local Dialogue1 = a1.Dialogue
    local Dialogue2 = a0.HUD.Dialogue
    if not NPC then
        a0:EndDialogue()
        return
    end

    Dialogue2.Visible = true
    if not a0.DialogueChannel then
        local v213 = nil
        a0.DialogueChannel = _G.Utl.Channel.new(math.huge, function() --[[ Upvalues: a0 (copy), v213 (ref) ]]
            if a0.DialogueChannel ~= v213 then
                return
            end

            a0:EndDialogue()
        end)
        a0.DialogueChannel.Duration = function() --[[ Upvalues: NPC (copy), a0 (copy) ]]
            if NPC.PrimaryPart and 12 < (a0.Root.Position - NPC.PrimaryPart.Position).Magnitude then
                a0.DialogueChannel:StopShort()
            end
        end

        a0.DialogueChannel:Start()
    end

    Dialogue2.NPCName.Text = NPC.Name
    Dialogue2.MainText.MaxVisibleGraphemes = 0
    Dialogue2.MainText.Text = a1.Dialogue.Text
    local Text = a1.Dialogue.Text
    for i2 = 1, #Text do
        if not (a0.DialogueRenderGeneration == DialogueRenderGeneration and Dialogue2.Visible) then
            return
        end

        Dialogue2.MainText.MaxVisibleGraphemes = i2
        local wait = task.wait
        wait()
    end

    if not (a0.DialogueRenderGeneration == DialogueRenderGeneration and Dialogue2.Visible) then
        return
    end

    if Dialogue1.Choices then
        for k31, k32 in pairs(Dialogue1.Choices) do
            local v219 = Dialogue2.Choices.Sample:Clone()
            v219.Name = k31
            v219.Label.Text = k31
            v219.LayoutOrder = k32.Order
            v219.Visible = true
            v219.Parent = Dialogue2.Choices
            v219.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy), DialogueRenderGeneration (copy), RemoteEvent (upvalue), k31 (copy) ]]
                if a0.DialogueRenderGeneration ~= DialogueRenderGeneration or a0.DialogueChoicePending then
                    return
                end

                a0.DialogueChoicePending = true
                RemoteEvent:FireServer("DialogueChoice", k31)
            end)
        end
    else
        task.wait(0.5)
        if a0.DialogueRenderGeneration ~= DialogueRenderGeneration then
            return
        end

        a0:EndDialogue()
    end

    if a0.DialogueRenderGeneration ~= DialogueRenderGeneration then
        return
    end

    if Dialogue1.SkillTree then
        a0:OpenSkillTree(Dialogue1.SkillTree)
    end
end

getBobbing.Dialogue = Dialogue3

local function EndDialogue(a0) --[[ Upvalues: RemoteEvent (copy) ]]
    a0.DialogueRenderGeneration = (a0.DialogueRenderGeneration or 0) + 1
    a0.DialogueChoicePending = nil
    local DialogueChannel = a0.DialogueChannel
    a0.DialogueChannel = nil
    if DialogueChannel then
        DialogueChannel:Cancel()
    end

    a0.HUD.Dialogue.Visible = false
    a0:ClearDialogue()
    RemoteEvent:FireServer("ResetDialogue")
end

getBobbing.EndDialogue = EndDialogue

local function StopDialogueChannel(a0)
    if a0.DialogueChannel then
        a0:EndDialogue()
    end
end

getBobbing.StopDialogueChannel = StopDialogueChannel

local function CloseSellGui(a0)
    if a0.SellGui then
        a0.SellGui:Destroy()
        a0.SellGui = nil
    end

    a0.ShopNPC = nil
    a0.ShopInfo = nil
    local SellChannel = a0.SellChannel
    a0.SellChannel = nil
    if SellChannel then
        SellChannel:Cancel()
    end
end

getBobbing.CloseSellGui = CloseSellGui

local function clearViewportObjects(a0)
    if not (a0 and a0:IsA("ViewportFrame")) then
        return
    end

    a0.CurrentCamera = nil
    local v220 = a0:GetChildren()
    for k33, k34 in ipairs(v220) do
        if k34.Name == "VPObject" or k34:IsA("Camera") then
            k34:Destroy()
        end
    end

    a0:SetAttribute("ViewportItem", nil)
end

local function createViewportObjects(a0, a1, a2) --[[ Upvalues: clearViewportObjects (copy), Objects (copy) ]]
    clearViewportObjects(a0)
    if typeof(a1) ~= "string" or a1 == "" then
        return
    end

    if typeof(a2) ~= "table" then
        return
    end

    if typeof(a2.ViewportOffset) ~= "CFrame" then
        return
    end

    local v224 = Objects.Tools:FindFirstChild(a1)
    if not v224 then
        return
    end

    local v225 = v224:Clone()
    v224 = nil
    if v225:IsA("Model") then
        local v227 = v225.PrimaryPart or v225:FindFirstChildWhichIsA("BasePart", true)
        if v227 then
            v224 = v227.CFrame
            -- branch continues at 72
        end
    else
        if v225:IsA("BasePart") then
            v224 = v225.CFrame
        end
    end

    if not v224 then
        v225:Destroy()
        return
    end

    v225.Name = "VPObject"
    v225.Parent = a0
    local Camera1 = Instance.new("Camera")
    Camera1.Name = "Camera"
    Camera1.CFrame = v224 * a2.ViewportOffset
    Camera1.Parent = a0
    a0.CurrentCamera = Camera1
    a0:SetAttribute("ViewportItem", a1)
end

local function OpenSellGui(a0, a1) --[[ Upvalues: v3 (copy), MarketplaceService (copy), v10 (copy), Objects (copy), v2 (copy), createViewportObjects (copy), RemoteEvent (copy) ]]
    a0:CloseSellGui()
    a0:StopDialogueChannel()
    local v228 = nil
    v228 = _G.Utl.Channel.new(math.huge, function() --[[ Upvalues: a0 (copy), v228 (ref) ]]
        if a0.SellChannel ~= v228 then
            return
        end

        a0:CloseSellGui()
    end)
    a0.SellChannel = v228
    v228.Duration = function() --[[ Upvalues: a0 (copy), v228 (ref), a1 (copy) ]]
        if a0.SellChannel ~= v228 then
            return
        end

        if not a1 or not a1.PrimaryPart or not a1:IsDescendantOf(workspace) or 12 < (a0.Root.Position - a1.PrimaryPart.Position).Magnitude then
            a0:CloseSellGui()
        end
    end

    a0.ShopInfo = v3[a1.Name]
    a0.ShopNPC = a1
    local v229 = a0.ShopInfo.Mult or 1
    local v230 = 1538562178
    if MarketplaceService:UserOwnsGamePassAsync(a0.Player.UserId, v230) or v10.HasGrant(a0.Data.GamepassGrants, 1538562178) then
        v229 = v229 + 0.5
    end

    if a0.SellChannel ~= v228 then
        return
    end

    v228:Start()
    a0.SellGui = Objects.SellGui:Clone()
    a0.SellGui.Parent = a0.Player.PlayerGui
    for k35, k36 in pairs(a0.Data.Items) do
        local v234 = v2[k35]
        if v234.SellValue and _G.Utl.tabFind(a0.ShopInfo.ToolTypes, v234.ToolType) then
            local v235 = a0.SellGui.Main.Items.Sample:Clone()
            v235.Name = k35
            v235.ItemName.Text = k35
            if 1 < k36.Quantity then
                local ItemName = v235.ItemName
                ItemName.Text = ItemName.Text .. " (x" .. k36.Quantity .. ")"
            end

            v235.SellValue.Text = "$" .. _G.Utl.addComas(tostring(math.floor(v234.SellValue * v229)))
            v235.Visible = true
            v235.Parent = a0.SellGui.Main.Items
            createViewportObjects(v235, k35, v234)
            v235.Sell.MouseButton1Click:Connect(function() --[[ Upvalues: v235 (copy), RemoteEvent (upvalue), k35 (copy), a1 (copy) ]]
                if v235:GetAttribute("Locked") then
                    return
                end

                RemoteEvent:FireServer("SellItem", k35, a1)
            end)
            v235.Lock.MouseButton1Click:Connect(function() --[[ Upvalues: v235 (copy) ]]
                if not v235:GetAttribute("Locked") then
                    v235:SetAttribute("Locked", true)
                    v235.Lock.ImageTransparency = 0
                    return
                end

                v235:SetAttribute("Locked", nil)
                v235.Lock.ImageTransparency = 0.6
            end)
        end
    end

    a0.SellGui.Main.CloseButton.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:CloseSellGui()
    end)
    local v236 = 0
    a0.SellGui.Main.SellAllButton.MouseButton1Click:Connect(function() --[[ Upvalues: v236 (ref), a0 (copy), RemoteEvent (upvalue), a1 (copy) ]]
        local v237 = time() - v236
        if v237 < 1 then
            return
        end

        v236 = time()
        local v238 = {}
        local v239 = a0.SellGui.Main.Items:GetChildren()
        for k37, k38 in pairs(v239) do
            if k38:IsA("ViewportFrame") and k38.Name ~= "Sample" and k38:GetAttribute("Locked") then
                table.insert(v238, k38.Name)
            end
        end

        RemoteEvent:FireServer("SellAllItems", a1, v238)
    end)
    a0.SellGui.Main.Gamepass.MouseButton1Click:Connect(function() --[[ Upvalues: MarketplaceService (upvalue), a0 (copy) ]]
        MarketplaceService:PromptGamePassPurchase(a0.Player, 1538562178)
    end)
end

getBobbing.OpenSellGui = OpenSellGui

local function UpdateSellGui(a0, a1) --[[ Upvalues: v2 (copy), createViewportObjects (copy), RemoteEvent (copy) ]]
    if not a0.SellGui then
        return
    end

    a0.Data.Items = a1
    local v243 = a0.SellGui.Main.Items:GetChildren()
    for k39, k40 in pairs(v243) do
        if k40:IsA("ViewportFrame") then
            if k40.Name ~= "Sample" then
                if a0.Data.Items[k40.Name] then
                    local v247 = a0.Data.Items[k40.Name]
                    k40.ItemName.Text = k40.Name
                    if 1 < v247.Quantity then
                        local ItemName1 = k40.ItemName
                        ItemName1.Text = ItemName1.Text .. " (x" .. v247.Quantity .. ")"
                        -- branch continues at 73
                    end
                else
                    k40:Destroy()
                end
            end
        end
    end

    for k41, k42 in pairs(a0.Data.Items) do
        local v251 = v2[k41]
        if v251.SellValue and _G.Utl.tabFind(a0.ShopInfo.ToolTypes, v251.ToolType) and not a0.SellGui.Main.Items:FindFirstChild(k41) then
            local v252 = a0.SellGui.Main.Items.Sample:Clone()
            v252.Name = k41
            v252.ItemName.Text = k41
            if 1 < k42.Quantity then
                local ItemName2 = v252.ItemName
                ItemName2.Text = ItemName2.Text .. " (x" .. k42.Quantity .. ")"
            end

            v252.SellValue.Text = "$" .. _G.Utl.addComas(tostring(v251.SellValue))
            v252.Visible = true
            v252.Parent = a0.SellGui.Main.Items
            createViewportObjects(v252, k41, v251)
            v252.Sell.MouseButton1Click:Connect(function() --[[ Upvalues: RemoteEvent (upvalue), k41 (copy), a0 (copy) ]]
                RemoteEvent:FireServer("SellItem", k41, a0.ShopNPC)
            end)
        end
    end
end

getBobbing.UpdateSellGui = UpdateSellGui

local function CloseShopGui(a0)
    local ShopChannel = a0.ShopChannel
    a0.ShopChannel = nil
    if ShopChannel then
        ShopChannel:Cancel()
    end

    if a0.ShopGui then
        a0.ShopGui:Destroy()
        a0.ShopGui = nil
    end

    a0.ShopNPC = nil
    a0.ShopArgs = nil
end

getBobbing.CloseShopGui = CloseShopGui

local function UpdateShopGui(a0) --[[ Upvalues: v4 (copy), v3 (copy) ]]
    if a0.ShopArgs and a0.ShopArgs[2] == "Pumpkin X" then
        local v255 = v4.Update(a0)
        return v255
    end

    if not a0.ShopGui then
        return
    end

    if not a0.ShopArgs then
        return
    end

    local v256 = a0.ShopArgs[1]
    local v257 = a0.ShopArgs[2]
    local Limit = v256:FindFirstChild("Limit")
    v256 = v3[v257]
    local v258
    if a0.ShopGui.Main.List.Visible then
        v258 = "List"
    else
        v258 = "Grid"
    end

    if v258 ~= a0.Data.ShopFormat then
        local v259 = a0.ShopGui.Main[v258]
        v259.Visible = false
        local v260 = a0.ShopGui.Main[v258]:GetChildren()
        for k43, k44 in pairs(v260) do
            if not k44:GetAttribute("noDelete") then
                k44:Destroy()
            end
        end

        a0:CreateShop()
        k43 = " Mode"
        a0.ShopGui.Main.Toggle.Text = a0.Data.ShopFormat .. k43
    end

    if not Limit then
        return
    end

    if a0.Data.ShopFormat == "List" then
        for k45, k46 in pairs(v256) do
            v258 = k46.Limit or 1
            local v267 = a0.ShopGui.Main.List:FindFirstChild(k45)
            if v267 then
                if Limit:FindFirstChild(k45) then
                    local v268 = v258 - Limit[k45].Value
                    if v258 <= Limit[k45].Value then
                        v267.Buy.Visible = false
                        v267.Stock.Text = "SOLD OUT"
                    else
                        v267.Stock.Text = v268 .. "X Stock"
                    end
                end
            end
        end

        return
    end

    for k47, k48 in pairs(v256) do
        local v272 = k48.Limit or 1
        local v273 = a0.ShopGui.Main.Grid:FindFirstChild(k47)
        if v273 then
            if Limit:FindFirstChild(k47) then
                local v276 = v272 - Limit[k47].Value
                if v272 <= Limit[k47].Value then
                    v273.Buy.Visible = false
                    v273.Req.Text = "SOLD OUT"
                    v273.Req.Visible = true
                end
            end
        end
    end
end

getBobbing.UpdateShopGui = UpdateShopGui

local function CreateShop(a0) --[[ Upvalues: v4 (copy), v3 (copy), v19 (copy), v2 (copy), createViewportObjects (copy), RemoteEvent (copy) ]]
    if a0.ShopArgs and a0.ShopArgs[2] == "Pumpkin X" then
        local v279 = v4.Render(a0)
        return v279
    end

    if not a0.ShopGui then
        return
    end

    if not a0.ShopArgs then
        return
    end

    local v280 = a0.ShopArgs[1]
    local v281 = a0.ShopArgs[2]
    local ToolTip = a0.ShopGui.ToolTip
    local Limit1 = v280:FindFirstChild("Limit")
    local v282 = v3[v281]
    if a0.Data.ShopFormat == "List" then
        for k49, k50 in pairs(v282) do
            if type(k50) == "table" then
                local v286 = nil
                if k50.Type then
                    if k50.Type == "Bait" then
                        v286 = v19[k49]
                        -- branch continues at 71
                    end
                else
                    v286 = v2[k49]
                end

                local v287 = k50.LevelReq or 0
                local v288 = a0.ShopGui.Main.List.Sample:Clone()
                v288.Name = k49
                v288.ItemName.Text = k49
                v288.Buy.Text = "$" .. _G.Utl.addComas(tostring(k50.Price))
                local v289 = k50.Type or v286.ToolType
                v288.ItemType.Text = v289
                v288.Visible = true
                v288.LayoutOrder = k50.LayoutOrder
                v288.Parent = a0.ShopGui.Main.List
                v288:SetAttribute("noDelete", nil)
                createViewportObjects(v288.ViewportFrame, k49, v286)
                if v287 <= a0.Data.Level then
                    v288.Buy.MouseButton1Click:Connect(function() --[[ Upvalues: RemoteEvent (upvalue), k49 (copy), v281 (copy), v280 (copy) ]]
                        local t4 = {k49, v281, v280}
                        RemoteEvent:FireServer("BuyItem", t4)
                    end)
                else
                    v288.Req.Text = "Level " .. v287 .. " Required"
                    v288.Req.Visible = true
                end

                if Limit1 and Limit1:FindFirstChild(k49) then
                    v287 = k50.Limit or 1
                    if v287 <= Limit1[k49].Value then
                        v288.Buy.Visible = false
                        v288.Stock.Text = "SOLD OUT"
                        -- jump to 229 (out of range)
                    end

                    v286 = v287 - Limit1[k49].Value
                    v288.Stock.Text = k50.Limit .. "X Stock"
                else
                    v288.Stock.Text = k50.Limit .. "X Stock"
                end

                v288.MouseEnter:Connect(function() --[[ Upvalues: v2 (upvalue), k49 (copy), ToolTip (copy), v288 (copy), a0 (copy) ]]
                    local v290 = v2[k49]
                    if v290 then
                        ToolTip.Position = UDim2.new(0, v288.AbsolutePosition.X, 0, a0.Mouse.Y)
                        ToolTip.Text = v290.ToolTip
                        ToolTip.Visible = true
                    end

                end)
                v288.MouseLeave:Connect(function() --[[ Upvalues: ToolTip (copy) ]]
                    ToolTip.Visible = false
                end)
            end
        end

        a0.ShopGui.Main.List.Visible = true
        return
    end

    for k51, k52 in pairs(v282) do
        if type(k52) == "table" then
            local v294 = nil
            if k52.Type then
                if k52.Type == "Bait" then
                    v294 = v19[k51]
                    -- branch continues at 287
                end
            else
                v294 = v2[k51]
            end

            local v295 = k52.LevelReq or 0
            local v296 = a0.ShopGui.Main.Grid.Sample:Clone()
            v296.Name = k51
            v296.ItemName.Text = k51
            v296.Buy.Text = "$" .. _G.Utl.addComas(tostring(k52.Price))
            v296.Visible = true
            v296.LayoutOrder = k52.LayoutOrder
            v296.Parent = a0.ShopGui.Main.Grid
            v296:SetAttribute("noDelete", nil)
            createViewportObjects(v296, k51, v294)
            if v295 <= a0.Data.Level then
                v296.Buy.MouseButton1Click:Connect(function() --[[ Upvalues: RemoteEvent (upvalue), k51 (copy), v281 (copy), v280 (copy) ]]
                    local t5 = {k51, v281, v280}
                    RemoteEvent:FireServer("BuyItem", t5)
                end)
            else
                v296.Req.Text = "Level " .. v295 .. " Required"
                v296.Req.Visible = true
            end

            if Limit1 and Limit1:FindFirstChild(k51) then
                v295 = k52.Limit or 1
                if v295 <= Limit1[k51].Value then
                    v296.Req.Text = "SOLD OUT"
                    v296.Req.Visible = true
                    v296.Buy.Visible = false
                end
            end

            v296.MouseEnter:Connect(function() --[[ Upvalues: v2 (upvalue), k51 (copy), ToolTip (copy), a0 (copy) ]]
                local v297 = v2[k51]
                if v297 then
                    ToolTip.Position = UDim2.new(0, a0.Mouse.X, 0, a0.Mouse.Y)
                    ToolTip.Text = v297.ToolTip
                    ToolTip.Visible = true
                end

            end)
            v296.MouseLeave:Connect(function() --[[ Upvalues: ToolTip (copy) ]]
                ToolTip.Visible = false
            end)
        end
    end

    a0.ShopGui.Main.Grid.Visible = true
end

getBobbing.CreateShop = CreateShop

local function OpenShopGui(a0, a1) --[[ Upvalues: ReplicatedStorage (copy), v3 (copy), RemoteEvent (copy) ]]
    local v298 = a1[2]
    a0:CloseShopGui()
    a0:CloseSellGui()
    a0:StopDialogueChannel()
    a0.ShopArgs = a1
    local v299 = nil
    v299 = _G.Utl.Channel.new(math.huge, function() --[[ Upvalues: a0 (copy), v299 (ref) ]]
        if a0.ShopChannel ~= v299 then
            return
        end

        a0:CloseShopGui()
    end)
    a0.ShopChannel = v299
    local v300 = a1[1]
    v299.Duration = function() --[[ Upvalues: v300 (copy), v299 (ref), a0 (copy) ]]
        if not (v300 and v300.PrimaryPart and v300:IsDescendantOf(workspace)) then
            v299:StopShort()
            return
        end

        if 12 < (a0.Root.Position - v300.PrimaryPart.Position).Magnitude then
            v299:StopShort()
        end
    end

    v299:Start()
    a0.ShopGui = ReplicatedStorage.Objects.ShopGui:Clone()
    a0.ShopGui.Main.Toggle.Text = a0.Data.ShopFormat .. " Mode"
    a0.ShopGui.Main.Label.Text = v3[v298] and v3[v298].DisplayName or v298
    a0.ShopGui.Parent = a0.Player.PlayerGui
    a0:CreateShop()
    a0.ShopGui.Main.Toggle.MouseButton1Click:Connect(function() --[[ Upvalues: RemoteEvent (upvalue) ]]
        RemoteEvent:FireServer("ChangeShopFormat")
    end)
    a0.ShopGui.Main.CloseButton.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:CloseShopGui()
    end)
end

getBobbing.OpenShopGui = OpenShopGui

local function CloseBank(a0)
    if a0.ClosingBank then
        return
    end

    a0.ClosingBank = true
    local BankChannel = a0.BankChannel
    local BankObject = a0.BankObject
    local BankAnim = a0.BankAnim
    a0.BankChannel = nil
    a0.BankObject = nil
    a0.BankAnim = nil
    if BankChannel then
        BankChannel:Cancel()
    end

    a0.HUD.Bank.Visible = false
    a0.BankOpening = false
    a0.HUD.Bank.InputAmount:ReleaseFocus()
    a0:ClearBankCons()
    a0.ClosingBank = false
    if BankAnim then
        BankAnim:AdjustSpeed(-1)
        if BankObject and BankObject.PrimaryPart then
            local v302 = {Sound = "SafeOpen", Speed = 1.1, Origin = BankObject.PrimaryPart}
            a0:Sound(v302)
            task.wait(0.7)
            v302 = {Sound = "SafeSpin", Pos = 11, Origin = BankObject.PrimaryPart}
            a0:Sound(v302)
        end
    end
end

getBobbing.CloseBank = CloseBank

local function CreateBankFrames(a0) --[[ Upvalues: v2 (copy), clearViewportObjects (copy), createViewportObjects (copy) ]]
    local v303
    if not (typeof(a0.Data.Bank) == "table" and a0.Data.Bank) then
        v303 = {}
    end

    local v304 = 6 + (tonumber(a0.Data.ExtraBank) or 0)
    local ShopFormat = a0.Data.ShopFormat
    local v305 = a0.HUD.Bank:FindFirstChild(ShopFormat)
    if not v305 then
        return
    end

    for i3 = 1, v304 do
        local v308 = tostring(i3)
        local v309 = v305:FindFirstChild(v308)
        if not v309 then
            v309 = v305.Sample:Clone()
            v309.Name = v308
            v309.LayoutOrder = i3
            v309.Visible = true
            v309.Parent = v305
            v309:SetAttribute("noDelete", nil)
        end

        local v310
        if not (typeof(v303[i3]) == "table" and v303[i3]) then
            v310 = {}
        end

        local v312 = typeof(v310.Item) == "string" and v310.Item or ""
        local v313 = math.max(0, tonumber(v310.Quantity) or 0)
        local v315 = ShopFormat == "List" and v309:FindFirstChild("ViewportFrame") or v309
        local v316 = v2[v312]
        if not (v312 ~= "" and v316) then
            clearViewportObjects(v315)
            v309.ItemName.Text = "NOTHING"
            if ShopFormat == "List" then
                v309.Quantity.Text = ""
                -- jump to 205 (out of range)
                -- branch continues at 205
            end
        end

        v309.ItemName.Text = v312
        if ShopFormat == "List" then
            v309.Quantity.Text = "x" .. v313
        else
            if 1 < v313 then
                v309.ItemName.Text = v312 .. " (x" .. v313 .. ")"
            end
        end

        local v319 = v315 and v315:GetAttribute("ViewportItem")
        local v321 = v315 and v315:FindFirstChild("VPObject")
        local v324 = v315 and v315:FindFirstChildWhichIsA("Camera")
        if not (v319 == v312 and v321 and v324) then
            createViewportObjects(v315, v312, v316)
        end
    end
end

getBobbing.CreateBankFrames = CreateBankFrames

local function UpdateBank(a0)
    if not (a0.HUD.Bank.Visible and a0.BankObject) then
        return
    end

    local ShopFormat1 = a0.Data.ShopFormat
    local v325
    if a0.HUD.Bank.List.Visible then
        v325 = "List"
    else
        v325 = "Grid"
    end

    a0.HUD.Bank.Toggle.Text = ShopFormat1 .. " Mode"
    if ShopFormat1 ~= v325 then
        local v326 = a0.HUD.Bank[v325]
        v326.Visible = false
        local v327 = a0.HUD.Bank[v325]:GetChildren()
        for k53, k54 in pairs(v327) do
            if not k54:GetAttribute("noDelete") then
                k54:Destroy()
            end
        end

        local v331 = a0.HUD.Bank[ShopFormat1]
        v331.Visible = true
    end

    a0:CreateBankFrames()
    a0:InitBank()
end

getBobbing.UpdateBank = UpdateBank

local function OpenBank(a0, a1, a2) --[[ Upvalues: Animations (copy) ]]
    if a0.HUD.Bank.Visible or a0.BankOpening then
        return
    end

    a0.BankOpening = true
    if a0.BankChannel then
        a0.BankChannel:Cancel()
        a0.BankChannel = nil
    end

    local ShopFormat2 = a0.Data.ShopFormat
    a0.HUD.Bank.List.Visible = ShopFormat2 == "List"
    a0.HUD.Bank.Grid.Visible = ShopFormat2 == "Grid"
    if a2 then
        a0.BankAnim = a1.AnimationController.Animator:LoadAnimation(Animations.SafeOpen)
        a0.BankAnim:Play()
        local v332 = {Sound = "SafeSpin", Pos = 11, Origin = a1.PrimaryPart}
        a0:Sound(v332)
        v332 = {Sound = "SafeOpen", Speed = 1.1, Origin = a1.PrimaryPart}
        a0:Sound(v332)
        task.wait(1.1)
        if not a0.BankOpening then
            return
        end

        a0.BankAnim:AdjustSpeed(0)
    end

    a0.BankObject = a1
    local v333 = nil
    v333 = _G.Utl.Channel.new(math.huge, function() --[[ Upvalues: a0 (copy), v333 (ref) ]]
        if a0.BankChannel ~= v333 then
            return
        end

        a0:CloseBank()
    end)
    a0.BankChannel = v333
    v333.Duration = function() --[[ Upvalues: a1 (copy), v333 (ref), a0 (copy) ]]
        if not (a1 and a1.PrimaryPart and a1:IsDescendantOf(workspace)) then
            v333:StopShort()
            return
        end

        if 20 < (a0.Root.Position - a1.PrimaryPart.Position).Magnitude then
            v333:StopShort()
        end
    end

    v333:Start()
    a0.HUD.Bank.Visible = true
    a0:UpdateBank(a1)
    a0.BankOpening = false
end

getBobbing.OpenBank = OpenBank

local function InitBank(a0) --[[ Upvalues: RemoteEvent (copy), MarketplaceService (copy) ]]
    a0:ClearBankCons()
    local v334 = {}
    local v335 = a0.HUD.Bank[a0.Data.ShopFormat]:GetChildren()
    for k55, k56 in pairs(v335) do
        if not k56:GetAttribute("noDelete") then
            local v339 = k56.Name .. "Store"
            a0.BankCons[v339] = k56.Store.MouseButton1Click:Connect(function() --[[ Upvalues: v334 (copy), k56 (copy), RemoteEvent (upvalue), a0 (copy) ]]
                local v340 = time() - (v334[k56.Name .. "Store"] or 0)
                if v340 < 0.1 then
                    return
                end

                local v341 = k56.Name .. "Store"
                v334[v341] = time()
                RemoteEvent:FireServer("StoreBank", k56.Name, a0.HUD.Bank.InputAmount.Text, a0.BankObject)
            end)
            v339 = k56.Name .. "Take"
            a0.BankCons[v339] = k56.Take.MouseButton1Click:Connect(function() --[[ Upvalues: v334 (copy), k56 (copy), RemoteEvent (upvalue), a0 (copy) ]]
                local v342 = time() - (v334[k56.Name .. "Take"] or 0)
                if v342 < 0.1 then
                    return
                end

                local v343 = k56.Name .. "Take"
                v334[v343] = time()
                RemoteEvent:FireServer("TakeBank", k56.Name, a0.HUD.Bank.InputAmount.Text, a0.BankObject)
            end)
        end
    end

    a0.BankCons.ToggleBankFormat = a0.HUD.Bank.Toggle.MouseButton1Click:Connect(function() --[[ Upvalues: RemoteEvent (upvalue) ]]
        RemoteEvent:FireServer("ChangeShopFormat")
    end)
    a0.BankCons.CloseBank = a0.HUD.Bank.CloseButton.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:CloseBank()
    end)
    a0.BankCons.ExtraBank = a0.HUD.Bank.Extra.MouseButton1Click:Connect(function() --[[ Upvalues: MarketplaceService (upvalue), a0 (copy) ]]
        MarketplaceService:PromptProductPurchase(a0.Player, 1608016814)
    end)
end

getBobbing.InitBank = InitBank

local function ClearBrewing(a0)
    for i4 = 1, 3 do
        local v346 = a0.HUD.Brewing[i4]
        if v346:FindFirstChild("VPObject") then
            v346.VPObject:Destroy()
        end

        if v346:FindFirstChild("Camera") then
            v346.Camera:Destroy()
        end
    end
end

getBobbing.ClearBrewing = ClearBrewing

local function UpdateBrewing(a0) --[[ Upvalues: createViewportObjects (copy), v2 (copy) ]]
    a0:ClearBrewing()
    local Brewing = a0.HUD.Brewing
    for k57, k58 in pairs(a0.Data.Brewing) do
        if k58 ~= "" then
            createViewportObjects(Brewing[k57], k58, v2[k58])
        end
    end
end

getBobbing.UpdateBrewing = UpdateBrewing

local function OpenBrewing(a0, a1)
    if a0.HUD.Brewing.Visible then
        return
    end

    a0.HUD.Brewing.Visible = true
    a0:UpdateBrewing(a0.Data.Brewing)
    a0.Cauldron = a1
    local v350 = nil
    v350 = _G.Utl.Channel.new(math.huge, function() --[[ Upvalues: a0 (copy), v350 (ref) ]]
        if a0.BrewChannel ~= v350 then
            return
        end

        a0:CloseBrewing()
    end)
    a0.BrewChannel = v350
    v350.Duration = function() --[[ Upvalues: a0 (copy), a1 (copy), v350 (ref) ]]
        if not (14 >= (a0.Root.Position - a1.Position).Magnitude and a1:IsDescendantOf(workspace)) then
            v350:StopShort()
        end
    end

    v350:Start()
end

getBobbing.OpenBrewing = OpenBrewing

local function CloseBrewing(a0)
    local BrewChannel = a0.BrewChannel
    a0.BrewChannel = nil
    if BrewChannel then
        BrewChannel:Cancel()
    end

    a0.HUD.Brewing.Visible = false
    a0.Cauldron = nil
end

getBobbing.CloseBrewing = CloseBrewing

local function InitBrewing(a0) --[[ Upvalues: RemoteEvent (copy) ]]
    local Brewing1 = a0.HUD.Brewing
    local v351 = 0
    Brewing1.Drop.MouseButton1Click:Connect(function() --[[ Upvalues: v351 (ref), RemoteEvent (upvalue) ]]
        local v352 = time() - v351
        if v352 < 0.5 then
            return
        end

        v351 = time()
        RemoteEvent:FireServer("BrewIngredient")
    end)
    Brewing1.CloseButton.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:CloseBrewing()
    end)
end

getBobbing.InitBrewing = InitBrewing

local function BrewingEffect(a0, a1) --[[ Upvalues: Objects (copy), TweenService (copy) ]]
    if not a0.Cauldron then
        return
    end

    local v353 = {
        Sound = "Bubbles",
        Volume = 1,
        Origin = a0.Cauldron,
        Speed = 0.95 + math.random() * 0.1
    }
    _G.Utl.PlaySound(v353)
    local v354 = Objects.Tools:FindFirstChild(a1):Clone()
    local v355 = v354
    if v354:IsA("Model") then
        v355 = v354.PrimaryPart
    end

    v355.CFrame = a0.Cauldron.CFrame * CFrame.new(0, 3.5, 0)
    v355.Parent = workspace.CurrentCamera
    local v356 = TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v357 = {CFrame = a0.Cauldron.CFrame}
    TweenService:Create(v355, v356, v357):Play()
end

getBobbing.BrewingEffect = BrewingEffect

local function ActivateClock(a0)
    if a0.WatchCon then
        return
    end

    a0.HUD.Clock.Visible = true
    local ClockTime = workspace:WaitForChild("ClockTime")

    local function clockChanged() --[[ Upvalues: ClockTime (copy), a0 (copy) ]]
        local v358 = math.floor(ClockTime.Value)
        local v359 = v358 - math.floor(v358 / 60) * 60
        a0.HUD.Clock.Text = _G.Utl.timeFormat(v358)
    end

    a0.WatchCon = ClockTime.Changed:Connect(clockChanged)
    local v360 = math.floor(ClockTime.Value)
    local v361 = v360 - math.floor(v360 / 60) * 60
    a0.HUD.Clock.Text = _G.Utl.timeFormat(v360)
end

getBobbing.ActivateClock = ActivateClock

local function ClearGuiCons(a0)
    for k59, k60 in pairs(a0.GuiCons) do
        k60:Disconnect()
        a0.GuiCons[k59] = nil
    end
end

getBobbing.ClearGuiCons = ClearGuiCons

local function CloseAchievements(a0)
    a0:ClearGuiCons()
    a0.HUD.Achievements.Visible = false
end

getBobbing.CloseAchievements = CloseAchievements

local function OpenAchievements(a0)
    if a0.HUD.Achievements.Visible then
        a0:CloseAchievements()
        return
    end

    a0.HUD.Achievements.Visible = true
end

getBobbing.OpenAchievements = OpenAchievements

local function UpdateAchievements(a0) --[[ Upvalues: v5 (copy), RemoteEvent (copy) ]]
    a0:ClearGuiCons()
    local List = a0.HUD.Achievements.List
    local v368, v369
    for k61, k62 in pairs(a0.Data.Achievements) do
        local v370 = v5[k61]
        if v370 then
            local v371 = List:FindFirstChild(k61)
            if not v371 then
                v371 = List.Sample:Clone()
                v371.Name = k61
                v371.Title.Text = k61
                v371.Task.Text = v370.Task
                v371.LayoutOrder = v370.Order
                if v370.Rewards then
                    local v372 = 1
                    v371.Rewards.Text = "Rewards: "
                    for k63, k64 in pairs(v370.Rewards) do
                        if v372 == 1 then
                            v371.Rewards.Text = "Rewards: " .. k64 .. " " .. k63
                        else
                            local Rewards = v371.Rewards
                            Rewards.Text = Rewards.Text .. ", " .. k64 .. " " .. k63
                        end

                        v372 = v372 + 1
                    end
                else
                    v371.Rewards.Text = "No Rewards"
                end

                v371.Visible = true
                v371.Parent = List
            end

            local v376 = k62.Progress / v370.AmountNeed
            if 1 < v376 then
                v376 = 1
            end

            v368 = v376
            v369 = 0
            local v377 = UDim2.new(v368, v369, 1, 0)
            v368 = "Out"
            v369 = "Quad"
            v371.Progress.Bar:TweenSize(v377, v368, v369, 0.2, true)
            v369 = math.floor
            local v378 = v369(k62.Progress)
            v368 = tostring
            local v379 = v368(v378)
            local v380 = _G.Utl.addComas(v379)
            v379 = " / "
            v378 = _G
            v378 = v378.Utl
            v378 = v378.addComas
            local v381 = v378(tostring(v370.AmountNeed))
            v371.Progress.Label.Text = v380 .. v379 .. v381
            if v370.AmountNeed <= k62.Progress then
                v371.EquipTitle.Visible = true
                v379 = "Equip"
                local v382 = k61 .. v379
                v381 = function() --[[ Upvalues: RemoteEvent (upvalue), k61 (copy) ]]
                    RemoteEvent:FireServer("EquipTitle", k61)
                end

                a0.GuiCons[v382] = v371.EquipTitle.MouseButton1Click:Connect(v381)
            end
        end
    end

    a0.GuiCons.RemoveTitle = a0.HUD.Achievements.RemoveTitle.MouseButton1Click:Connect(function() --[[ Upvalues: RemoteEvent (upvalue) ]]
        RemoteEvent:FireServer("RemoveTitle")
    end)
end

getBobbing.UpdateAchievements = UpdateAchievements

local function ChangeMouseIcon(a0, a1)
    if a1 == "Default" then
        a0.Mouse.Icon = a0.DefaultIcon
        a0.HUD.Crosshair.Visible = false
        a0.MobileButtons.Buttons.Block.Text = "Block"
        if a0.TouchEnabled then
            a0.MainContext.Block.Touch.UIButton = a0.MobileButtons.Buttons.Block
            a0.MainContext.Reload.Touch.UIButton = nil
            return
            -- branch continues at 100
        end
    end

    if a1 == "Gun" then
        a0.Mouse.Icon = "http://www.roblox.com/asset/?id=9947945465"
        if a0.TouchEnabled then
            a0.HUD.Crosshair.Visible = true
            a0.MobileButtons.Buttons.Block.Text = "Reload"
            a0.MainContext.Reload.Touch.UIButton = a0.MobileButtons.Buttons.Block
            a0.MainContext.Block.Touch.UIButton = nil
        end
    end
end

getBobbing.ChangeMouseIcon = ChangeMouseIcon

local function Recoil(a0, a1, a2)
    local Up = a1.Up
    local Side = a1.Side
    local Shake = a1.Shake
    local v383 = 1
    if a2 then
        v383 = 1.5
    end

    local v384 = Up[1] + math.random() * Up[2]
    local v385 = Side[1] + math.random() * Side[2]
    a0.Springs.recoil:shove(Vector3.new(v384, v385, Shake[1] + math.random() * Shake[2]) / v383)
end

getBobbing.Recoil = Recoil

local function UpdateMouse(a0, a1)
    a0.UpdatingMouse = a1
end

getBobbing.UpdateMouse = UpdateMouse

local function SetReportAim(a0, a1)
    local v386
    if a1 then
        v386 = true
    else
        v386 = false
    end

    a0.ReportingAim = v386
end

getBobbing.SetReportAim = SetReportAim

local function ShowAim(a0, a1)
    if type(a1) ~= "table" then
        return
    end

    if not a0.AimParts then
        a0.AimParts = {}
    end

    if not (a0.AimFolder and a0.AimFolder.Parent) then
        a0.AimFolder = Instance.new("Folder")
        a0.AimFolder.Name = "ModAimLines"
        a0.AimFolder.Parent = workspace.CurrentCamera
    end

    local v387 = {}
    for k65, k66 in pairs(a1) do
        if k66.o and k66.a then
            v387[k65] = true
            local v391 = a0.AimParts[k65]
            if not (v391 and v391.Parent) then
                v391 = Instance.new("Part")
                v391.Anchored = true
                v391.CanCollide = false
                v391.CanQuery = false
                v391.CanTouch = false
                v391.CastShadow = false
                v391.Material = Enum.Material.Neon
                v391.Color = Color3.fromRGB(255, 45, 45)
                v391.Parent = a0.AimFolder
                a0.AimParts[k65] = v391
            end

            local Magnitude = (k66.a - k66.o).Magnitude
            v391.Size = Vector3.new(0.15, 0.15, math.max(Magnitude, 0.05))
            local v392 = CFrame.new(k66.o, k66.a)
            v391.CFrame = v392 * CFrame.new(0, 0, -Magnitude / 2)
        end
    end

    for k67, k68 in pairs(a0.AimParts) do
        if not v387[k67] then
            k68:Destroy()
            a0.AimParts[k67] = nil
        end
    end
end

getBobbing.ShowAim = ShowAim

local function ClearAim(a0)
    if a0.AimParts then
        for k69, k70 in pairs(a0.AimParts) do
            k70:Destroy()
        end

        a0.AimParts = {}
    end

    if a0.AimFolder then
        a0.AimFolder:Destroy()
        a0.AimFolder = nil
    end
end

getBobbing.ClearAim = ClearAim

local function Slide(a0) --[[ Upvalues: RemoteEvent (copy), Animations (copy), TweenService (copy) ]]
    if a0.Character:GetAttribute("Fishing") then
        return
    end

    local v399 = time() - a0.SlideCD
    if v399 < 1.75 then
        return
    end

    if not a0.Root then
        return
    end

    if a0.Humanoid.Health <= 0 then
        return
    end

    if not a0.Root:FindFirstChild("RootRigAttachment") then
        return
    end

    local v400 = {workspace.Live}
    local v401 = {
        Origin = a0.Root.Position,
        Dir = a0.Root.CFrame.upVector * -3.5,
        Blacklist = v400
    }
    if not _G.Utl.Raycast(v401) then
        return
    end

    a0.Sliding = true
    RemoteEvent:FireServer("Slide")
    local v402 = {Bool = false, State = Enum.HumanoidStateType.GettingUp}
    a0:EnableState(v402)
    v402 = {Bool = false, State = Enum.HumanoidStateType.FallingDown}
    a0:EnableState(v402)
    a0.SlideCD = time()
    local v403 = {Sound = "Slide", Speed = 0.4, Pos = 0.25, Volume = 0.375, Origin = a0.Root}
    _G.Utl.PlaySound(v403)
    a0:LoadAnimation(Animations.Slide):Play()
    local v404 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(a0.Humanoid, v404, {CameraOffset = Vector3.new(0, -1.5, 0.25)}):Play()
    local v405 = 1
    local v406
    if a0.Humanoid.Health < 20 then
        v406 = v406 * 0.5
    end

    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(10000000, 0, 10000000)
    BodyVelocity.Velocity = a0.Root.CFrame.LookVector * (v406 * 2)
    BodyVelocity.Parent = a0.Root
    for i5 = 1, 10 do
        task.wait(0.05)
        v405 = v405 * 0.97
        BodyVelocity.Velocity = a0.Root.CFrame.LookVector * (v406 * 2) * v405
        BodyVelocity.MaxForce = BodyVelocity.MaxForce * 0.95
    end

    BodyVelocity:Destroy()
    a0.Sliding = false
    local v409 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(a0.Humanoid, v409, {CameraOffset = Vector3.new(0, 0.5, 0.15000000596046448)}):Play()
    task.delay(0.25, function() --[[ Upvalues: a0 (copy) ]]
        local t6 = {Bool = true, State = Enum.HumanoidStateType.GettingUp}
        a0:EnableState(t6)
        t6 = {Bool = true, State = Enum.HumanoidStateType.FallingDown}
        a0:EnableState(t6)
    end)
end

getBobbing.Slide = Slide

local function BarsVisible(a0, a1)
    a0.HUD.Hunger.Visible = a1
    a0.HUD.Thirst.Visible = a1
    a0.HUD.Armor.Visible = a1
    a0.HUD.Level.Visible = a1
end

getBobbing.BarsVisible = BarsVisible

local function EnableBackpack(a0, a1)
    if a0.CustomBackpack then
        a0.CustomBackpack:SetEnabled(a1)
    end
end

getBobbing.EnableBackpack = EnableBackpack

local function GetStorageCapacity(a0) --[[ Upvalues: v6 (copy) ]]
    local v410 = a0.StorageBase and a0.StorageBase:FindFirstChild("Contents")
    local v412 = v410 and v410:FindFirstChild("Objects")
    if not v412 then
        return 0
    end

    local v413 = v412:GetChildren()
    local v417
    for k71, k72 in ipairs(v413) do
        v410 = v6[k72.Name]
        v417 = v417 + (v410 and v410.Capacity or 1)
    end

    return v417
end

getBobbing.GetStorageCapacity = GetStorageCapacity

local function applyFactionSignIcon(a0, a1) --[[ Upvalues: Players (copy) ]]
    if a1 ~= "FactionSign" then
        return
    end

    local Icon = a0:FindFirstChild("Icon", true)
    if not (Icon and Icon:IsA("ImageLabel")) then
        return
    end

    local v419 = Players.LocalPlayer:GetAttribute("FactionIcon")
    if typeof(v419) == "string" and v419 ~= "" then
        Icon.Image = v419
        Icon.Visible = true
        return
    end

    Icon.Image = ""
    Icon.Visible = false
end

local function createViewportBaseObjects(a0, a1) --[[ Upvalues: ReplicatedStorage (copy), v6 (copy), v8 (copy), applyFactionSignIcon (copy) ]]
    local v422 = ReplicatedStorage.BaseObjects:FindFirstChild(a1) or ReplicatedStorage.BaseCustomization:FindFirstChild(a1)
    local v425 = v6[a1] or v8[a1]
    if not v422 then
        if v425.ViewportObject and ReplicatedStorage.BaseCustomization:FindFirstChild(v425.ViewportObject) then
            v422 = ReplicatedStorage.BaseCustomization:FindFirstChild(v425.ViewportObject)
        else
            return
        end
    end

    local v426 = v422:Clone()
    applyFactionSignIcon(v426, a1)
    v426.Name = "VPObject"
    v426.Parent = a0
    v422 = Instance.new("Camera")
    a0.CurrentCamera = v422
    if v426:IsA("Model") then
        v422.CFrame = v426.PrimaryPart.CFrame * v425.ViewportOffset
    else
        v422.CFrame = v426.CFrame * v425.ViewportOffset
    end

    v422.Parent = a0
end

local function ClearEditCons(a0)
    for k73, k74 in pairs(a0.EditCons) do
        k74:Disconnect()
        a0.EditCons[k73] = nil
    end
end

getBobbing.ClearEditCons = ClearEditCons
ClearEditCons = {
    ["Cube.002"] = true,
    ["Cube.003"] = true,
    ["Cube.006"] = true,
    ["Cube.007"] = true,
    ["Cube.009"] = true
}

local function GetDefaultDoorColor(a0)
    local StorageBase2 = a0.StorageBase
    local SafezoneUnits = workspace:FindFirstChild("SafezoneUnits")
    if StorageBase2 then
        if StorageBase2:GetAttribute("BaseOnly") == true then
            local v430 = Color3.fromRGB(3, 133, 177)
            return v430
        end

        if SafezoneUnits then
            if StorageBase2:IsDescendantOf(SafezoneUnits) then
                local v431 = Color3.fromRGB(3, 133, 177)
                return v431
            end
        end
    end

    local v432 = Color3.fromRGB(150, 85, 85)
    return v432
end

getBobbing.GetDefaultDoorColor = GetDefaultDoorColor

local function GetDoorColor(a0)
    local StorageBase3 = a0.StorageBase
    if StorageBase3 then
        local v433 = StorageBase3:GetAttribute("DoorColor")
        if typeof(v433) == "Color3" then
            return v433
        end
    end

    local v434 = a0:GetDefaultDoorColor()
    return v434
end

getBobbing.GetDoorColor = GetDoorColor

local function PreviewDoorColor(a0, a1) --[[ Upvalues: ClearEditCons (copy) ]]
    if typeof(a1) ~= "Color3" then
        return
    end

    local DoorColorPanel = a0.HUD.BaseCustomization:FindFirstChild("DoorColorPanel")
    if DoorColorPanel then
        DoorColorPanel.CurrentColor.BackgroundColor3 = a1
        local v436 = math.round(a1.R * 255)
        local v437 = math.round(a1.G * 255)
        DoorColorPanel.RGB.Text = string.format("RGB %d, %d, %d", v436, v437, math.round(a1.B * 255))
    end

    local v438 = a0.StorageBase and a0.StorageBase:FindFirstChild("Door")
    if v438 then
        for k75 in pairs(ClearEditCons) do
            local v442 = v438:FindFirstChild(k75)
            if v442 and v442:IsA("BasePart") then
                v442.Color = a1
            end
        end
    end
end

getBobbing.PreviewDoorColor = PreviewDoorColor

local function CloseDoorColorPicker(a0)
    local DoorColorPickerHUD = a0.DoorColorPickerHUD
    if DoorColorPickerHUD then
        a0.DoorColorPickerHUD = nil
        DoorColorPickerHUD:Destroy()
    end
end

getBobbing.CloseDoorColorPicker = CloseDoorColorPicker

local function OpenDoorColorPicker(a0) --[[ Upvalues: v15 (copy), GuiService (copy), RemoteEvent (copy) ]]
    if not a0.StorageBase then
        return
    end

    a0:CloseDoorColorPicker()
    local v443 = {
        RealTimeEventCalling = false,
        Position = UDim2.fromOffset(0, 0),
        PickerMode = v15.PICKER_MODE.CIRCLE,
        ColorSpace = v15.COLOR_SPACE.RGB
    }
    local v444 = v15.new(v443)
    local v445
    if not (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) then
        local v446 = Vector2.new(1280, 720)
    end

    local v447, v448 = GuiService:GetGuiInset()
    local v449 = v445.X - v447.X
    local v450 = math.max(1, v449 - v448.X)
    local v451 = v445.Y - v447.Y
    local v452 = Vector2.new(v450, math.max(1, v451 - v448.Y))
    local v453 = (v452.X - 24) / 238
    local v454 = math.min(v453, (v452.Y - 24) / 334)
    v448 = math.clamp(v454, 0.65, 1)
    v447 = v444.Instance:FindFirstChildWhichIsA("UIScale")
    if not v447 then
        v447 = Instance.new("UIScale")
        v447.Parent = v444.Instance
    end

    v447.Scale = v448
    local v455 = math.max(12, math.floor((v452.X - v448 * 238) / 2))
    v444.Instance.Position = UDim2.fromOffset(v455, math.max(12, math.floor((v452.Y - v448 * 334) / 2)))
    local v456 = a0:GetDoorColor()
    v444:SetColor(v456)
    a0.DoorColorPickerHUD = v444
    v444.ColorChanged:Connect(function(a0) --[[ Upvalues: a0 (copy), v444 (copy), RemoteEvent (upvalue) ]]
        if not (a0.DoorColorPickerHUD == v444 and a0.CustomizingBase and a0.StorageBase) then
            return
        end

        local v457 = math.round(a0.R * 255)
        local v458 = math.clamp(v457, 0, 255)
        local v459 = math.round(a0.G * 255)
        local v460 = math.clamp(v459, 0, 255)
        local v461 = math.round(a0.B * 255)
        a0 = Color3.fromRGB(v458, v460, math.clamp(v461, 0, 255))
        a0:PreviewDoorColor(a0)
        RemoteEvent:FireServer("ChangeBaseDoorColor", a0)
    end)
    v444.WindowClosed:Connect(function() --[[ Upvalues: a0 (copy), v444 (copy) ]]
        if a0.DoorColorPickerHUD == v444 then
            a0:CloseDoorColorPicker()
        end

    end)
end

getBobbing.OpenDoorColorPicker = OpenDoorColorPicker

local function CloseCustomizeBase(a0)
    a0.CustomizingBase = nil
    local BaseEdit = a0.HUD.BaseEdit
    local BaseCustomization = a0.HUD.BaseCustomization
    a0:CloseDoorColorPicker()
    a0:ClearEditCons()
    a0:ClearCustomObjects()
    BaseCustomization.List.Visible = true
    BaseCustomization.RemoveButton.Visible = true
    BaseCustomization.DoorColorPanel.Visible = false
    local UnitSizePanel = BaseCustomization:FindFirstChild("UnitSizePanel")
    if UnitSizePanel then
        UnitSizePanel.Visible = false
    end

    local LightsPanel = BaseCustomization:FindFirstChild("LightsPanel")
    if LightsPanel then
        LightsPanel.Visible = false
    end

    a0.PendingBaseUnitSize = nil
    a0.PendingBaseUnitDeleteCount = nil
    BaseEdit.CustomizeBase.Text = "Customize"
    BaseCustomization.Visible = false
end

getBobbing.CloseCustomizeBase = CloseCustomizeBase

local function OpenCustomizeBase(a0) --[[ Upvalues: UserInputService (copy), GuiService (copy), RemoteEvent (copy) ]]
    a0.CustomizingBase = true
    local BaseEdit1 = a0.HUD.BaseEdit
    local BaseCustomization1 = a0.HUD.BaseCustomization
    local DoorColorPanel1 = BaseCustomization1.DoorColorPanel
    local UnitSizePanel1 = BaseCustomization1:FindFirstChild("UnitSizePanel")
    local LightsPanel1 = BaseCustomization1:FindFirstChild("LightsPanel")
    a0:UpdateCustomObjects(a0.BaseCustomType)
    local v462 = BaseCustomization1.Types:GetChildren()
    for k76, k77 in pairs(v462) do
        if k77:IsA("TextButton") then
            local v466 = k77.Name .. "Clicked"
            a0.EditCons[v466] = k77.Activated:Connect(function() --[[ Upvalues: a0 (copy), k77 (copy), UserInputService (upvalue), GuiService (upvalue), DoorColorPanel1 (copy), UnitSizePanel1 (copy), LightsPanel1 (copy) ]]
                a0:CloseDoorColorPicker()
                a0.BaseCustomType = k77.Name
                a0:UpdateCustomObjects(a0.BaseCustomType)
                if UserInputService.GamepadEnabled then
                    if k77.Name == "Door" then
                        GuiService.SelectedObject = DoorColorPanel1.ChooseColor
                        return
                    end

                    if k77.Name == "Size" then
                        if UnitSizePanel1 then
                            local v467 = UnitSizePanel1:FindFirstChild("Size" .. 1)
                            if v467 and v467.Selectable then
                                GuiService.SelectedObject = v467
                                return
                            end

                            local v468 = UnitSizePanel1:FindFirstChild("Size" .. 2)
                            if v468 and v468.Selectable then
                                GuiService.SelectedObject = v468
                                return
                            end

                            local v469 = UnitSizePanel1:FindFirstChild("Size" .. 3)
                            if v469 then
                                if v469.Selectable then
                                    GuiService.SelectedObject = v469
                                    return
                                    return
                                    -- branch continues at 110
                                end

                                -- branch continues at 110
                            end
                        end
                    end

                    if k77.Name == "Lights" and LightsPanel1 and LightsPanel1.Toggle.Selectable then
                        GuiService.SelectedObject = LightsPanel1.Toggle
                    end
                end

            end)
        end
    end

    a0.EditCons.RemoveButton = BaseCustomization1.RemoveButton.Activated:Connect(function() --[[ Upvalues: a0 (copy), RemoteEvent (upvalue) ]]
        if a0.BaseCustomType ~= "Door" and a0.BaseCustomType ~= "Size" and a0.BaseCustomType ~= "Lights" then
            RemoteEvent:FireServer("RemoveBase" .. a0.BaseCustomType)
        end

    end)
    a0.EditCons.DoorChooseColor = DoorColorPanel1.ChooseColor.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        if a0.DoorColorPickerHUD then
            a0:CloseDoorColorPicker()
            return
        end

        a0:OpenDoorColorPicker()
    end)
    a0.EditCons.DoorResetColor = DoorColorPanel1.Reset.Activated:Connect(function() --[[ Upvalues: a0 (copy), RemoteEvent (upvalue) ]]
        a0:CloseDoorColorPicker()
        local v470 = a0:GetDefaultDoorColor()
        a0:PreviewDoorColor(v470)
        RemoteEvent:FireServer("ResetBaseDoorColor")
    end)
    if a0.StorageBase then
        local v471 = a0.StorageBase:GetAttributeChangedSignal("DoorColor")
        a0.EditCons.DoorColorChanged = v471:Connect(function() --[[ Upvalues: a0 (copy) ]]
            local v472 = a0:GetDoorColor()
            a0:PreviewDoorColor(v472)
        end)
    end

    if UnitSizePanel1 then
        for i6 = 1, 3 do
            local v475 = UnitSizePanel1:FindFirstChild("Size" .. i6)
            if v475 then
                local v476 = "BaseUnitSize" .. i6
                a0.EditCons[v476] = v475.Activated:Connect(function() --[[ Upvalues: a0 (copy), i6 (copy) ]]
                    a0:CancelBaseUnitResize()
                    a0:RequestBaseUnitSize(i6)
                end)
            end
        end

        a0.EditCons.BaseUnitConfirm = UnitSizePanel1.Confirm.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
            if a0.PendingBaseUnitSize then
                a0:RequestBaseUnitSize(a0.PendingBaseUnitSize, a0.PendingBaseUnitDeleteCount)
            end

        end)
        a0.EditCons.BaseUnitCancel = UnitSizePanel1.Cancel.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:CancelBaseUnitResize()
        end)
        a0:UpdateUnitSizePanel()
    end

    if LightsPanel1 then
        a0.EditCons.BaseLightsToggle = LightsPanel1.Toggle.Activated:Connect(function() --[[ Upvalues: a0 (copy), RemoteEvent (upvalue) ]]
            if not a0.StorageBase then
                return
            end

            RemoteEvent:FireServer("SetBaseLightsEnabled", not (a0.StorageBase:GetAttribute("BaseLightsEnabled") ~= false))
        end)
        a0:UpdateLightsPanel()
    end

    if a0.StorageBase then
        local v477 = a0.StorageBase:GetAttributeChangedSignal("BaseLightsEnabled")
        a0.EditCons.BaseLightsChanged = v477:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:UpdateLightsPanel()
        end)
    end

    BaseEdit1.CustomizeBase.Text = "Close Customization"
    BaseCustomization1.Visible = true
end

getBobbing.OpenCustomizeBase = OpenCustomizeBase

local function ClearCustomObjects(a0)
    local v478 = a0.HUD.BaseCustomization.List:GetChildren()
    for k78, k79 in pairs(v478) do
        if k79:IsA("ViewportFrame") and k79.Name ~= "Sample" then
            k79:Destroy()
        end
    end
end

getBobbing.ClearCustomObjects = ClearCustomObjects

local function UpdateCustomObjects(a0, a1) --[[ Upvalues: v8 (copy), createViewportBaseObjects (copy), RemoteEvent (copy) ]]
    local BaseCustomization2 = a0.HUD.BaseCustomization
    local List1 = BaseCustomization2.List
    local DoorColorPanel2 = BaseCustomization2.DoorColorPanel
    local UnitSizePanel2 = BaseCustomization2:FindFirstChild("UnitSizePanel")
    local LightsPanel2 = BaseCustomization2:FindFirstChild("LightsPanel")
    a0:ClearCustomObjects()
    if a1 == "Door" then
        List1.Visible = false
        BaseCustomization2.RemoveButton.Visible = false
        DoorColorPanel2.Visible = true
        if UnitSizePanel2 then
            UnitSizePanel2.Visible = false
        end

        if LightsPanel2 then
            LightsPanel2.Visible = false
        end

        local v484 = a0:GetDoorColor()
        a0:PreviewDoorColor(v484)
        return
    end

    if a1 == "Size" then
        a0:CloseDoorColorPicker()
        List1.Visible = false
        BaseCustomization2.RemoveButton.Visible = false
        DoorColorPanel2.Visible = false
        if LightsPanel2 then
            LightsPanel2.Visible = false
        end

        if UnitSizePanel2 then
            UnitSizePanel2.Visible = true
            a0:UpdateUnitSizePanel()
        end

        return
    end

    if a1 == "Lights" then
        a0:CloseDoorColorPicker()
        List1.Visible = false
        BaseCustomization2.RemoveButton.Visible = false
        DoorColorPanel2.Visible = false
        if UnitSizePanel2 then
            UnitSizePanel2.Visible = false
        end

        if LightsPanel2 then
            LightsPanel2.Visible = true
            a0:UpdateLightsPanel()
        end

        return
    end

    a0:CloseDoorColorPicker()
    List1.Visible = true
    BaseCustomization2.RemoveButton.Visible = true
    DoorColorPanel2.Visible = false
    if UnitSizePanel2 then
        UnitSizePanel2.Visible = false
    end

    if LightsPanel2 then
        LightsPanel2.Visible = false
    end

    for k80, k81 in pairs(v8) do
        if k81.Type == a1 then
            LightsPanel2 = List1.Sample:Clone()
            LightsPanel2.Name = k80
            LightsPanel2.Price.Text = "$" .. k81.Price
            LightsPanel2.ObjectName.Text = k80
            LightsPanel2.Visible = true
            LightsPanel2.LayoutOrder = k81.Price
            createViewportBaseObjects(LightsPanel2, k80, a1)
            LightsPanel2.Parent = List1
            LightsPanel2.Select.Activated:Connect(function() --[[ Upvalues: RemoteEvent (upvalue), a1 (copy), k80 (copy) ]]
                local v488 = "ChangeBase" .. a1
                RemoteEvent:FireServer(v488, k80)
            end)
        end
    end
end

getBobbing.UpdateCustomObjects = UpdateCustomObjects

local function GetBasePrice(a0, a1) --[[ Upvalues: v6 (copy), v8 (copy) ]]
    local v489 = 0
    for k82, k83 in pairs(a1.BaseObjects) do
        local v493
        if typeof(k83) == "table" then
            v493 = v6[k83.Object]
        else
            v493 = v6[k83]
        end

        if v493 and not v493.ItemObject then
            v489 = v489 + v493.Price
        end
    end

    if a1.BaseWall then
        if a1.BaseWall ~= "" then
            local v496 = v8[a1.BaseWall]
            if v496 then
                v489 = v489 + v496.Price
            end
        end
    end

    if a1.BaseFloor then
        if a1.BaseFloor ~= "" then
            local v499 = v8[a1.BaseFloor]
            if v499 then
                v489 = v489 + v499.Price
            end
        end
    end

    if a1.BaseBasement then
        if a1.BaseBasement ~= "" then
            local v502 = v8[a1.BaseBasement]
            if v502 then
                v489 = v489 + v502.Price
            end
        end
    end

    return v489
end

getBobbing.GetBasePrice = GetBasePrice

local function OpenBaseSlotConfirmation(a0, a1, a2) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    local v503 = a0.HUD and a0.HUD:FindFirstChild("BaseSlotConfirm")
    local v505 = v503 and v503:FindFirstChild("Panel")
    local v506 = a0.Data and a0.Data.BaseSlots
    local v507
    if a1 == "Save" then
        v507 = "Save"
    else
        if a1 == "Load" then
            v507 = "Load"
        else
            v507 = nil
        end
    end

    a1 = v507
    a2 = tonumber(a2)
    if not v503 then
        return false
    end

    if not v505 then
        return false
    end

    if not a0.InBaseSlots then
        return false
    end

    if not a1 then
        return false
    end

    if not a2 then
        return false
    end

    if a2 % 1 ~= 0 then
        return false
    end

    if a2 < 1 then
        return false
    end

    if 6 < a2 then
        return false
    end

    if not (typeof(v506) == "table" and v506[a2]) then
        return false
    end

    if not a0.BaseSlotConfirmAction then
        a0.BaseSlotConfirmPreviousSelection = GuiService.SelectedObject
    end

    a0.BaseSlotConfirmAction = a1
    a0.BaseSlotConfirmSlot = a2
    if a1 == "Save" then
        v505.Title.Text = ("OVERWRITE SLOT %d?"):format(a2)
        v505.Message.Text = ("Save your current base to Slot %d? Anything already saved in this slot will be replaced."):format(a2)
        v505.Warning.Text = "Existing save will be replaced."
        v505.Confirm.Text = "OVERWRITE"
    else
        v505.Title.Text = ("LOAD SLOT %d?"):format(a2)
        v505.Message.Text = ("Load Slot %d? Everything currently in your base will be replaced by this saved layout."):format(a2)
        v505.Warning.Text = "Unsaved changes will be lost."
        v505.Confirm.Text = "LOAD SLOT"
    end

    local v508 = UserInputService:GetFocusedTextBox()
    if v508 then
        v508:ReleaseFocus()
    end

    v503.Visible = true
    local Cancel = v505:FindFirstChild("Cancel")
    if UserInputService.GamepadEnabled and Cancel and Cancel:IsA("GuiButton") then
        GuiService.SelectedObject = Cancel
    end

    return true
end

getBobbing.OpenBaseSlotConfirmation = OpenBaseSlotConfirmation

local function CloseBaseSlotConfirmation(a0) --[[ Upvalues: GuiService (copy) ]]
    local v509 = a0.HUD and a0.HUD:FindFirstChild("BaseSlotConfirm")
    local BaseSlotConfirmPreviousSelection = a0.BaseSlotConfirmPreviousSelection
    a0.BaseSlotConfirmAction = nil
    a0.BaseSlotConfirmSlot = nil
    a0.BaseSlotConfirmPreviousSelection = nil
    if v509 then
        v509.Visible = false
    end

    if a0.BaseSlotConfirmAction ~= nil then
        if v509 then
            local SelectedObject = GuiService.SelectedObject
            if SelectedObject then
                if SelectedObject:IsDescendantOf(v509) then
                    GuiService.SelectedObject = BaseSlotConfirmPreviousSelection and BaseSlotConfirmPreviousSelection.Parent and BaseSlotConfirmPreviousSelection or nil
                end
            end
        end
    end
end

getBobbing.CloseBaseSlotConfirmation = CloseBaseSlotConfirmation

local function CloseBaseSlots(a0)
    a0.InBaseSlots = nil
    a0:ClearBaseSlots()
    a0:CloseBaseSlotConfirmation()
    a0:ClearEditCons()
    a0.HUD.BaseSlots.Visible = false
    a0.HUD.BaseEdit.BaseSaveSlots.Text = "Save Slots"
end

getBobbing.CloseBaseSlots = CloseBaseSlots

local function OpenBaseSlots(a0) --[[ Upvalues: MarketplaceService (copy), RemoteEvent (copy), UserInputService (copy) ]]
    a0:UpdateBaseSlots()
    a0.InBaseSlots = true
    a0.EditCons.ExtraSlotClicked = a0.HUD.BaseSlots.ExtraSlot.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy), MarketplaceService (upvalue) ]]
        local v512 = #a0.Data.BaseSlots
        if 6 <= v512 then
            a0:Noti({Title = "Error", Text = "Max Slots!", Duration = 2})
            return
        end

        MarketplaceService:PromptProductPurchase(a0.Player, 1872969573)
    end)
    local BaseSlotConfirm2 = a0.HUD:FindFirstChild("BaseSlotConfirm")
    local v514 = BaseSlotConfirm2 and BaseSlotConfirm2:FindFirstChild("Panel")
    if v514 then
        BaseSlotConfirm2 = v514:FindFirstChild("Confirm")
        local Cancel1 = v514:FindFirstChild("Cancel")
        if BaseSlotConfirm2 and BaseSlotConfirm2:IsA("GuiButton") then
            a0.EditCons.BaseSlotConfirmClicked = BaseSlotConfirm2.Activated:Connect(function() --[[ Upvalues: a0 (copy), RemoteEvent (upvalue) ]]
                local BaseSlotConfirmAction = a0.BaseSlotConfirmAction
                local BaseSlotConfirmSlot = a0.BaseSlotConfirmSlot
                if not (BaseSlotConfirmAction and BaseSlotConfirmSlot) then
                    return
                end

                a0:CloseBaseSlotConfirmation()
                if BaseSlotConfirmAction == "Save" then
                    RemoteEvent:FireServer("SaveBaseSlot", BaseSlotConfirmSlot, true)
                    return
                end

                RemoteEvent:FireServer("LoadBaseSlot", BaseSlotConfirmSlot, true)
            end)
        end

        if Cancel1 and Cancel1:IsA("GuiButton") then
            a0.EditCons.BaseSlotCancelClicked = Cancel1.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
                a0:CloseBaseSlotConfirmation()
            end)
        end

        a0.EditCons.BaseSlotConfirmInput = UserInputService.InputBegan:Connect(function(a0) --[[ Upvalues: a0 (copy) ]]
            if not a0.BaseSlotConfirmAction then
                return
            end

            if a0.KeyCode == Enum.KeyCode.Escape or a0.KeyCode == Enum.KeyCode.ButtonB then
                a0:CloseBaseSlotConfirmation()
            end

        end)
    end

    a0.HUD.BaseEdit.BaseSaveSlots.Text = "Close Save Slots"
    a0.HUD.BaseSlots.Visible = true
end

getBobbing.OpenBaseSlots = OpenBaseSlots

local function ClearBaseSlots(a0)
    local v515 = a0.HUD.BaseSlots.List:GetChildren()
    for k84, k85 in pairs(v515) do
        if k85:IsA("Frame") and k85.Name ~= "Sample" then
            k85:Destroy()
        end
    end
end

getBobbing.ClearBaseSlots = ClearBaseSlots

local function UpdateBaseSlots(a0) --[[ Upvalues: RemoteEvent (copy) ]]
    local List2 = a0.HUD.BaseSlots.List
    for k86, k87 in pairs(a0.Data.BaseSlots) do
        local v522 = List2:FindFirstChild(k86)
        if not v522 then
            v522 = List2.Sample:Clone()
            v522.Name = k86
            v522.SlotLabel.Text = "Slot " .. k86
            v522.Visible = true
            v522.Parent = List2
            v522.SaveButton.Activated:Connect(function() --[[ Upvalues: a0 (copy), k86 (copy) ]]
                a0:OpenBaseSlotConfirmation("Save", k86)
            end)
            v522.LoadButton.Activated:Connect(function() --[[ Upvalues: a0 (copy), k86 (copy) ]]
                a0:OpenBaseSlotConfirmation("Load", k86)
            end)
            v522.UpdateName.MouseButton1Click:Connect(function() --[[ Upvalues: v522 (ref), RemoteEvent (upvalue), k86 (copy) ]]
                RemoteEvent:FireServer("UpdateSlotName", k86, v522.SlotName.Text)
            end)
        end

        local v523 = math.floor(tonumber(k87.BaseUnitSize) or 1)
        local v524 = math.clamp(v523, 1, 3)
        local CostLabel = v522.CostLabel
        local v525 = a0:GetBasePrice(k87)
        local v526
        if v524 == 1 then
            v526 = ""
        else
            v526 = "s"
        end

        CostLabel.Text = ("Cost: $%d  |  %d Unit%s"):format(v525, v524, v526)
        if k87.SlotName ~= "" then
            v522.SlotLabel.Text = k87.SlotName
        else
            v522.SlotLabel.Text = "Slot " .. k86
        end
    end
end

getBobbing.UpdateBaseSlots = UpdateBaseSlots

local function NotInBase(a0)
    a0.Player:SetAttribute("InBase", nil)
    if a0.CustomizingBase then
        a0:CloseCustomizeBase()
    else
        a0:CloseDoorColorPicker()
    end

    local BaseEdit2 = a0.HUD.BaseEdit
    BaseEdit2.BaseObjects.Text = "Base Objects"
    BaseEdit2.CustomizeBase.Text = "Customize"
    BaseEdit2.Paint.Text = "Paint"
    BaseEdit2.BaseSaveSlots.Text = "Save Slots"
    if a0.InBaseSlots then
        a0:CloseBaseSlots()
    end

    if a0.Painting then
        a0:ClosePaintFrames()
    end

    if a0.EditingBase then
        a0:StopEditStorage()
    end

    a0.HUD.BaseEdit.Visible = false
    a0.HUD.BaseCustomization.Visible = false
    a0.HUD.BaseSlots.Visible = false
end

getBobbing.NotInBase = NotInBase

local function ClosePaintFrames(a0) --[[ Upvalues: v16 (copy) ]]
    v16.Close(a0)
end

getBobbing.ClosePaintFrames = ClosePaintFrames

local function OpenPaintFrames(a0) --[[ Upvalues: v16 (copy) ]]
    if not a0.EditingBase then
        a0:EditStorage()
        if not a0.BuildCameraActive then
            return false
        end
    end

    local v527 = v16.Open(a0)
    return v527
end

getBobbing.OpenPaintFrames = OpenPaintFrames

local function ColorPickerOff(a0) --[[ Upvalues: v16 (copy) ]]
    v16.ClosePicker(a0)
end

getBobbing.ColorPickerOff = ColorPickerOff

local function ColorPicker(a0) --[[ Upvalues: v16 (copy) ]]
    local v528 = v16.TogglePicker(a0)
    return v528
end

getBobbing.ColorPicker = ColorPicker

local function UpdateLightsPanel(a0)
    local v529 = a0.HUD and a0.HUD:FindFirstChild("BaseCustomization")
    local v531 = v529 and v529:FindFirstChild("LightsPanel")
    if not v531 then
        return
    end

    v529 = not a0.StorageBase
    if not v529 then
        v529 = a0.StorageBase:GetAttribute("BaseLightsEnabled") ~= false
    end

    local v532
    if v529 then
        v532 = "Ceiling Lights: ON"
    else
        v532 = "Ceiling Lights: OFF"
    end

    v531.Status.Text = v532
    local Status = v531.Status
    local v534
    if not (v529 and Color3.fromRGB(129, 230, 154)) then
        local v535 = Color3.fromRGB(255, 120, 120)
    end

    Status.TextColor3 = v534
    if v529 then
        v534 = "Turn Lights Off"
    else
        v534 = "Turn Lights On"
    end

    v531.Toggle.Text = v534
    local Toggle = v531.Toggle
    local v537
    if not (v529 and Color3.fromRGB(90, 45, 45)) then
        local v538 = Color3.fromRGB(46, 139, 87)
    end

    Toggle.BackgroundColor3 = v537
    v529 = a0.StorageBase ~= nil
    v531.Toggle.Interactable = v529
    v531.Toggle.Selectable = v529
    v531.Toggle.AutoButtonColor = v529
end

getBobbing.UpdateLightsPanel = UpdateLightsPanel

local function GetBaseResizeRemaining(a0)
    local StorageBase4 = a0.StorageBase
    if not StorageBase4 then
        return 0
    end

    local v539 = StorageBase4:GetAttribute("BaseResizeAvailableAt")
    if typeof(v539) ~= "number" then
        return 0
    end

    return math.max(0, v539 - workspace:GetServerTimeNow())
end

getBobbing.GetBaseResizeRemaining = GetBaseResizeRemaining

local function UpdateUnitSizePanel(a0)
    local v540 = a0.HUD and a0.HUD:FindFirstChild("BaseCustomization")
    local v542 = v540 and v540:FindFirstChild("UnitSizePanel")
    if not v542 then
        return
    end

    v540 = 1
    if a0.StorageBase then
        local v543 = a0.StorageBase:GetAttribute("BaseUnitSize")
        v540 = tonumber(v543) or 1
    end

    local v544 = math.floor(v540)
    v540 = math.clamp(v544, 1, 3)
    local CurrentSize = v542.CurrentSize
    local v545
    if v540 == 1 then
        v545 = ""
    else
        v545 = "s"
    end

    CurrentSize.Text = ("Current Size: %d Unit%s"):format(v540, v545)
    local v546 = a0:GetBaseResizeRemaining()
    if 0 < v546 then
        v542.Cooldown.Text = ("Resize available in 0:%02d"):format(math.ceil(v546))
        v542.Cooldown.TextColor3 = Color3.fromRGB(255, 203, 105)
    else
        v542.Cooldown.Text = "Ready to resize"
        v542.Cooldown.TextColor3 = Color3.fromRGB(129, 230, 154)
    end

    local ResizingBaseUnits = a0.ResizingBaseUnits
    if not ResizingBaseUnits then
        ResizingBaseUnits = a0.PendingBaseUnitSize ~= nil
    end

    for i7 = 1, 3 do
        local v549 = v542:FindFirstChild("Size" .. i7)
        if v549 then
            local v550 = i7 == v540
            local v552
            if not (v550 and Color3.fromRGB(46, 139, 87)) then
                local v553 = Color3.fromRGB(37, 44, 56)
            end

            v549.BackgroundColor3 = v552
            local StateStroke = v549:FindFirstChild("StateStroke")
            if StateStroke then
                local v555
                if not (v550 and Color3.fromRGB(67, 181, 255)) then
                    local v556 = Color3.fromRGB(210, 220, 235)
                end

                StateStroke.Color = v555
                if v550 then
                    v555 = 2.5
                else
                    v555 = 1
                end

                StateStroke.Thickness = v555
            end

            local v557 = not v550
            if v557 then
                v557 = false
                if v546 <= 0 then
                    v557 = not ResizingBaseUnits
                    if v557 then
                        v557 = a0.StorageBase ~= nil
                    end
                end
            end

            v549.Interactable = v557
            v549.AutoButtonColor = v549.Interactable
            v549.Selectable = v549.Interactable
        end
    end

    ResizingBaseUnits = a0.PendingBaseUnitSize ~= nil
    local v560 = ResizingBaseUnits and not a0.ResizingBaseUnits
    v542.Confirm.Interactable = v560
    local v562 = ResizingBaseUnits and not a0.ResizingBaseUnits
    v542.Cancel.Interactable = v562
    v542.Confirm.AutoButtonColor = v542.Confirm.Interactable
    v542.Cancel.AutoButtonColor = v542.Cancel.Interactable
    v542.Confirm.Selectable = v542.Confirm.Interactable
    v542.Cancel.Selectable = v542.Cancel.Interactable
end

getBobbing.UpdateUnitSizePanel = UpdateUnitSizePanel

local function CancelBaseUnitResize(a0)
    a0.PendingBaseUnitSize = nil
    a0.PendingBaseUnitDeleteCount = nil
    local UnitSizePanel4 = a0.HUD.BaseCustomization:FindFirstChild("UnitSizePanel")
    if UnitSizePanel4 then
        UnitSizePanel4.Warning.Visible = false
        UnitSizePanel4.Confirm.Visible = false
        UnitSizePanel4.Cancel.Visible = false
    end

    a0:UpdateUnitSizePanel()
end

getBobbing.CancelBaseUnitResize = CancelBaseUnitResize

local function RequestBaseUnitSize(a0, a1, a2) --[[ Upvalues: RemoteFunction (copy), UserInputService (copy), GuiService (copy), MarketplaceService (copy) ]]
    if not (not a0.ResizingBaseUnits and a0.StorageBase) then
        return
    end

    a1 = tonumber(a1)
    if not a1 then
        return
    end

    a0.ResizingBaseUnits = true
    a0:UpdateUnitSizePanel()
    local StorageBase5 = a0.StorageBase
    task.spawn(function() --[[ Upvalues: RemoteFunction (upvalue), a1 (ref), a2 (copy), a0 (copy), StorageBase5 (copy), UserInputService (upvalue), GuiService (upvalue), MarketplaceService (upvalue) ]]
        local v564, v565, v566, v567, v568 = pcall(function() --[[ Upvalues: RemoteFunction (upvalue), a1 (upvalue), a2 (upvalue) ]]
            local v563 = RemoteFunction:InvokeServer("ResizeBaseUnits", a1, a2)
            return v563
        end)
        a0.ResizingBaseUnits = nil
        if a0.StorageBase ~= StorageBase5 then
            a0:CancelBaseUnitResize()
            return
        end

        if not v564 then
            a0:Noti({Title = "Resize Failed", Text = "The server could not resize your base. Please try again.", Duration = 3})
            a0:UpdateUnitSizePanel()
            return
        end

        if v565 then
            a0:CancelBaseUnitResize()
            v568 = tonumber(v567) or 0
            local v569 = a1
            local v570
            if a1 == 1 then
                v570 = ""
            else
                v570 = "s"
            end

            v564 = ("Your base is now %d unit%s wide."):format(v569, v570)
            if 0 < v568 then
                local v571
                if v568 == 1 then
                    v571 = ""
                else
                    v571 = "s"
                end

                v564 = v564 .. (" %d object%s outside the kept area were deleted without a refund."):format(v568, v571)
            end

            v569 = {Title = "Base Resized", Duration = 4, Text = v564}
            a0:Noti(v569)
            return
        end

        if v566 == "CONFIRM" then
            v565 = math.max(0, math.floor(tonumber(v567) or 0))
            a0.PendingBaseUnitSize = a1
            a0.PendingBaseUnitDeleteCount = v565
            local UnitSizePanel5 = a0.HUD.BaseCustomization:FindFirstChild("UnitSizePanel")
            if UnitSizePanel5 then
                local Warning = UnitSizePanel5.Warning
                local v572 = a1
                local v573
                if a1 == 1 then
                    v573 = ""
                else
                    v573 = "s"
                end

                local v574
                if v565 == 1 then
                    v574 = ""
                else
                    v574 = "s"
                end

                Warning.Text = ("Downsizing to %d unit%s will permanently delete %d object%s outside the kept area. Deleted objects will not be refunded. This cannot be undone."):format(v572, v573, v565, v574)
                UnitSizePanel5.Warning.Visible = true
                UnitSizePanel5.Confirm.Visible = true
                UnitSizePanel5.Cancel.Visible = true
                if UserInputService.GamepadEnabled then
                    GuiService.SelectedObject = UnitSizePanel5.Cancel
                end
            end

            a0:UpdateUnitSizePanel()
            return
        end

        if v566 == "UNIT_SIZE_2_LOCKED" then
            a0:Noti({Title = "Unit Size 2 Locked", Text = "Purchase the Unit Size 2 upgrade from Builder Bob for $2,000,000.", Duration = 4})
        else
            if v566 == "GAMEPASS" then
                pcall(function() --[[ Upvalues: MarketplaceService (upvalue), a0 (upvalue) ]]
                    MarketplaceService:PromptGamePassPurchase(a0.Player, 1952937460)
                end)
                a0:Noti({Title = "Gamepass Required", Text = "The 3 Storage Unit Base gamepass is required for a 3-unit base.", Duration = 3})
            else
                local v575 = {Title = "Resize Failed", Duration = 4}
                v575.Text = tostring(v566 or "The neighboring units cannot be used right now.")
                a0:Noti(v575)
            end
        end

        a0:UpdateUnitSizePanel()
    end)
end

getBobbing.RequestBaseUnitSize = RequestBaseUnitSize

local function GetUnclaimRemaining(a0)
    local StorageBase6 = a0.StorageBase
    if not StorageBase6 then
        return 0
    end

    local v576 = StorageBase6:GetAttribute("UnclaimAvailableAt")
    if typeof(v576) ~= "number" then
        return 0
    end

    return math.max(0, v576 - workspace:GetServerTimeNow())
end

getBobbing.GetUnclaimRemaining = GetUnclaimRemaining

local function UpdateUnclaimButton(a0) --[[ Upvalues: UserInputService (copy) ]]
    local v577 = a0.HUD and a0.HUD:FindFirstChild("BaseEdit")
    local v579 = v577 and v577:FindFirstChild("UnclaimBase")
    if not v579 then
        return
    end

    local TouchEnabled = UserInputService.TouchEnabled
    if TouchEnabled then
        TouchEnabled = false
        if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
            TouchEnabled = a0.Data
            if TouchEnabled then
                TouchEnabled = a0.Data.BuildSystem == "Classic"
            end
        end
    end

    local v582 = TouchEnabled and Color3.new(0, 0, 0)
    local v586 = v582 or v579:GetAttribute("CooldownColor") or Color3.fromRGB(72, 72, 72)
    local v590 = v582 or v579:GetAttribute("ReadyColor") or Color3.fromRGB(112, 38, 38)
    local v594 = v582 or v579:GetAttribute("ConfirmColor") or Color3.fromRGB(190, 55, 55)
    if a0.UnclaimingStorage then
        v579.Text = "Unclaiming..."
        v579.BackgroundColor3 = v586
        v579.Interactable = false
        v579.AutoButtonColor = false
        return
    end

    v582 = a0:GetUnclaimRemaining()
    if 0 < v582 then
        local v595 = math.ceil(v582)
        local v596 = math.floor(v595 / 60)
        v579.Text = ("Unclaim (%d:%02d)"):format(v596, v595 % 60)
        v579.BackgroundColor3 = v586
        v579.Interactable = false
        v579.AutoButtonColor = false
        a0.UnclaimConfirmUntil = nil
        return
    end

    if a0.UnclaimConfirmUntil and os.clock() <= a0.UnclaimConfirmUntil then
        v579.Text = "Confirm Unclaim?"
        v579.BackgroundColor3 = v594
    else
        a0.UnclaimConfirmUntil = nil
        v579.Text = v579:GetAttribute("DefaultText") or "Unclaim Base"
        v579.BackgroundColor3 = v590
    end

    v579.Interactable = a0.StorageBase ~= nil
    local v598 = v579.Interactable and not TouchEnabled
    v579.AutoButtonColor = v598
end

getBobbing.UpdateUnclaimButton = UpdateUnclaimButton

local function RequestUnclaimStorage(a0) --[[ Upvalues: RemoteFunction (copy) ]]
    if not (not a0.UnclaimingStorage and a0.StorageBase) then
        return
    end

    if a0.ResizingBaseUnits then
        a0:Noti({Title = "Please Wait", Text = "Finish resizing your base before unclaiming it.", Duration = 2})
        return
    end

    local v599 = a0:GetUnclaimRemaining()
    if 0 < v599 then
        local v600 = math.ceil(v599)
        local v601 = {Title = "Unclaim Cooldown", Duration = 2}
        local v602 = math.floor(v600 / 60)
        v601.Text = ("You can unclaim this storage in %d:%02d."):format(v602, v600 % 60)
        a0:Noti(v601)
        return
    end

    if not a0.UnclaimConfirmUntil or a0.UnclaimConfirmUntil < os.clock() then
        a0.UnclaimConfirmUntil = os.clock() + 5
        a0:UpdateUnclaimButton()
        a0:Noti({Title = "Unclaim Storage", Text = "Press the button again within 5 seconds to confirm.", Duration = 3})
        return
    end

    a0.UnclaimConfirmUntil = nil
    a0.UnclaimingStorage = true
    a0:UpdateUnclaimButton()
    local StorageBase7 = a0.StorageBase
    local StorageBaseClaim = a0.StorageBaseClaim
    task.spawn(function() --[[ Upvalues: RemoteFunction (upvalue), a0 (copy), StorageBase7 (copy), StorageBaseClaim (copy) ]]
        local v604, v605, v606 = pcall(function() --[[ Upvalues: RemoteFunction (upvalue) ]]
            local v603 = RemoteFunction:InvokeServer("UnclaimStorage")
            return v603
        end)
        a0.UnclaimingStorage = nil
        if v604 then
            if v605 then
                if a0.StorageBase == StorageBase7 and a0.StorageBaseClaim == StorageBaseClaim then
                    a0:StorageUnclaimed(StorageBase7)
                end

                a0:Noti({Title = "Storage", Text = "Storage unclaimed successfully.", Duration = 3})
                return
            end
        end

        a0:UpdateUnclaimButton()
        local v607 = a0
        local v608 = {Title = "Unable to Unclaim", Duration = 3}
        local v609
        if v604 then
            v609 = v606
            if not v609 then
                v609 = "The storage could not be unclaimed."
                -- branch continues at 50
            end
        else
            v609 = "The server did not respond."
        end

        v608.Text = v609
        v607:Noti(v608)
    end)
end

getBobbing.RequestUnclaimStorage = RequestUnclaimStorage

local function StorageUnclaimed(a0, a1)
    local StorageClaimRequest = a0.StorageClaimRequest
    if StorageClaimRequest then
        if not a1 or StorageClaimRequest.Storage == a1 then
            a0.StorageClaimRequest = nil
        end
    end

    if a1 and a0.StorageBase and a1 ~= a0.StorageBase then
        return
    end

    if a1 and not a0.StorageBase and StorageClaimRequest and StorageClaimRequest.Storage ~= a1 then
        return
    end

    if a0.Painting then
        a0:ClosePaintFrames()
    end

    if a0.EditingBase then
        a0:StopEditStorage()
    end

    if a0.CustomizingBase then
        a0:CloseCustomizeBase()
    end

    if a0.InBaseSlots then
        a0:CloseBaseSlots()
    end

    a0:CloseDoorColorPicker()
    a0:EnableBackpack(true)
    a0:BarsVisible(true)
    if a0.ClaimCons then
        for k88, k89 in pairs(a0.ClaimCons) do
            k89:Disconnect()
            a0.ClaimCons[k88] = nil
        end
    end

    a0.Player:SetAttribute("InBase", nil)
    a0.StorageHover = nil
    a0.ObjectHover = nil
    if a0.HighlightHover then
        a0.HighlightHover.Parent = nil
    end

    a0.HUD.ClaimStorage.Visible = false
    a0.HUD.BaseEdit.Visible = false
    a0.HUD.BaseCustomization.Visible = false
    a0.HUD.BaseSlots.Visible = false
    a0.HUD.BaseObjects.Visible = false
    a0.HUD.BaseCoord.Visible = false
    a0.HUD.BaseCoord.Text = ""
    local BaseEdit4 = a0.HUD.BaseEdit
    BaseEdit4.BaseObjects.Text = "Base Objects"
    BaseEdit4.CustomizeBase.Text = "Customize"
    BaseEdit4.Paint.Text = "Paint"
    BaseEdit4.BaseSaveSlots.Text = "Save Slots"
    a0.StorageBase = nil
    a0.StorageBaseClaim = nil
    a0.UnclaimingStorage = nil
    a0.UnclaimConfirmUntil = nil
    a0.ResizingBaseUnits = nil
    a0.PendingBaseUnitSize = nil
    a0.PendingBaseUnitDeleteCount = nil
    a0:UpdateUnclaimButton()
end

getBobbing.StorageUnclaimed = StorageUnclaimed

local function StorageClaimed(a0, a1) --[[ Upvalues: UserInputService (copy), RunService (copy) ]]
    if typeof(a1) ~= "Instance" then
        return
    end

    local v613 = {Storage = a1}
    a0.StorageClaimRequest = v613
    local v614 = a1:FindFirstChild("Contents") or a1:WaitForChild("Contents", 5)
    if a0.StorageClaimRequest ~= v613 then
        return
    end

    local v615 = v614
    if v615 then
        local v616 = v614:FindFirstChild("Objects") or v614:WaitForChild("Objects", 5)
    end

    if a0.StorageClaimRequest ~= v613 then
        return
    end

    if not v614 or not v615 or v614.Parent ~= a1 or v615.Parent ~= v614 then
        a0.StorageClaimRequest = nil
        warn("[Storage] Claimed storage contents did not replicate in time.")
        return
    end

    local v617 = os.clock() + 5
    while a0.StorageClaimRequest == v613 and a1.Parent and a1:GetAttribute("Owner") == nil and os.clock() < v617 do
        task.wait(0.05)
    end

    if a0.StorageClaimRequest ~= v613 then
        return
    end

    a0.StorageClaimRequest = nil
    if not a1.Parent or a1:GetAttribute("Owner") ~= a0.Player.Name or v614.Parent ~= a1 or v615.Parent ~= v614 then
        return
    end

    a0.StorageBase = a1
    a0.StorageBaseClaim = v613
    a0.SearchText = ""
    a0.CurrentBaseObjects = "Furniture"
    a0.CurrentSubCategory = "All"
    a0.UnclaimingStorage = nil
    a0.UnclaimConfirmUntil = nil
    a0.ResizingBaseUnits = nil
    a0.PendingBaseUnitSize = nil
    a0.PendingBaseUnitDeleteCount = nil
    if a0.ClaimCons then
        for k90, k91 in pairs(a0.ClaimCons) do
            k91:Disconnect()
            a0.ClaimCons[k90] = nil
        end
    else
        a0.ClaimCons = {}
    end

    if not a0.BaseEditWired then
        a0.BaseEditWired = true
        local BaseEdit5 = a0.HUD.BaseEdit
        v614 = a0.HUD.BaseObjects:FindFirstChild("CollapseButton")
        if v614 then
            v614.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
                if a0.EditingBase then
                    a0:SetBaseObjectsCollapsed(not a0.BaseObjectsCollapsed)
                end

            end)
        end

        local function horizontalScrollTarget(a0) --[[ Upvalues: a0 (copy) ]]
            local v623 = a0.Player and a0.Player:FindFirstChildOfClass("PlayerGui")
            if not v623 then
                return nil
            end

            local v626, v627 = pcall(function() --[[ Upvalues: v623 (copy), a0 (copy) ]]
                local v624 = math.floor(a0.X)
                local v625 = v623:GetGuiObjectsAtPosition(v624, math.floor(a0.Y))
                return v625
            end)
            if not v626 then
                return nil
            end

            for k92, k93 in ipairs(v627) do
                v626 = k93
                while v626 do
                    if v626 == v623 then
                        break
                    end

                    if v626:IsA("ScrollingFrame") and v626.Visible and v626.ScrollingEnabled and v626.ScrollingDirection == Enum.ScrollingDirection.X then
                        return v626
                    end

                    v626 = v626.Parent
                end
            end

            return nil
        end

        UserInputService.InputChanged:Connect(function(a0) --[[ Upvalues: horizontalScrollTarget (copy), UserInputService (upvalue) ]]
            if a0.UserInputType ~= Enum.UserInputType.MouseWheel then
                return
            end

            local v631 = UserInputService:GetMouseLocation()
            local v632 = horizontalScrollTarget(v631)
            if not v632 then
                return
            end

            v631 = v632.AbsoluteCanvasSize.X - v632.AbsoluteWindowSize.X
            if v631 <= 0 then
                return
            end

            local v633 = v632.AbsoluteWindowSize.X * 0.2
            local v634 = math.max(v633, 60)
            local v635 = v632.CanvasPosition.X - a0.Position.Z * v634
            local v636 = math.clamp(v635, 0, v631)
            v632.CanvasPosition = Vector2.new(v636, v632.CanvasPosition.Y)
        end)

        local function closeAllFrames() --[[ Upvalues: a0 (copy) ]]
            if a0.EditingBase then
                a0:StopEditStorage()
                return
            end

            if a0.CustomizingBase then
                a0:CloseCustomizeBase()
                return
            end

            if a0.InBaseSlots then
                a0:CloseBaseSlots()
                return
            end

            if a0.Painting then
                a0:ClosePaintFrames()
            end
        end

        BaseEdit5.BaseObjects.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
            if not a0.EditingBase then
                if a0.EditingBase then
                    a0:StopEditStorage()
                else
                    if a0.CustomizingBase then
                        a0:CloseCustomizeBase()
                    else
                        if a0.InBaseSlots then
                            a0:CloseBaseSlots()
                        else
                            if a0.Painting then
                                a0:ClosePaintFrames()
                            end
                        end
                    end
                end

                a0:EditStorage()
                return
            end

            a0:StopEditStorage()
        end)
        BaseEdit5.CustomizeBase.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
            if not a0.CustomizingBase then
                if a0.EditingBase then
                    a0:StopEditStorage()
                else
                    if a0.CustomizingBase then
                        a0:CloseCustomizeBase()
                    else
                        if a0.InBaseSlots then
                            a0:CloseBaseSlots()
                        else
                            if a0.Painting then
                                a0:ClosePaintFrames()
                            end
                        end
                    end
                end

                a0:OpenCustomizeBase()
                return
            end

            a0:CloseCustomizeBase()
        end)
        BaseEdit5.BaseSaveSlots.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
            if not a0.InBaseSlots then
                if a0.EditingBase then
                    a0:StopEditStorage()
                else
                    if a0.CustomizingBase then
                        a0:CloseCustomizeBase()
                    else
                        if a0.InBaseSlots then
                            a0:CloseBaseSlots()
                        else
                            if a0.Painting then
                                a0:ClosePaintFrames()
                            end
                        end
                    end
                end

                a0:OpenBaseSlots()
                return
            end

            a0:CloseBaseSlots()
        end)
        BaseEdit5.Paint.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
            if not a0.Painting then
                if not a0.EditingBase then
                    if a0.EditingBase then
                        a0:StopEditStorage()
                    else
                        if a0.CustomizingBase then
                            a0:CloseCustomizeBase()
                        else
                            if a0.InBaseSlots then
                                a0:CloseBaseSlots()
                            else
                                if a0.Painting then
                                    a0:ClosePaintFrames()
                                end
                            end
                        end
                    end
                end

                a0:OpenPaintFrames()
                return
            end

            a0:ClosePaintFrames()
        end)
        local UnclaimBase1 = BaseEdit5:FindFirstChild("UnclaimBase")
        if UnclaimBase1 then
            UnclaimBase1.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
                a0:RequestUnclaimStorage()
            end)
        end
    end

    local v637 = math.floor(a1.Floor.Position.X)
    a0.HUD.BaseCoord.Text = "Base: " .. v637 .. ", " .. math.floor(a1.Floor.Position.Z)
    a0.HUD.BaseCoord.Visible = true
    local v638 = a1:GetAttributeChangedSignal("Owner")
    local v641 = v638:Connect(function() --[[ Upvalues: a0 (copy), a1 (copy) ]]
        if a0.StorageBase == a1 then
            local v640 = a1:GetAttribute("Owner")
            if v640 ~= a0.Player.Name then
                a0:StorageUnclaimed(a1)
            end
        end

    end)
    table.insert(a0.ClaimCons, v641)
    local v642 = v615.ChildAdded:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:UpdateStorageCapacity()
    end)
    table.insert(a0.ClaimCons, v642)
    local v643 = v615.ChildRemoved:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:UpdateStorageCapacity()
    end)
    table.insert(a0.ClaimCons, v643)
    local v644 = a1:GetAttributeChangedSignal("BaseUnitSize")
    local v645 = v644:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:UpdateStorageCapacity()
    end)
    table.insert(a0.ClaimCons, v645)
    local v646 = 0
    local v647 = RunService.Heartbeat:Connect(function() --[[ Upvalues: v646 (ref), a0 (copy) ]]
        if v646 <= os.clock() then
            v646 = os.clock() + 0.25
            a0:UpdateUnclaimButton()
            local UnitSizePanel6 = a0.HUD.BaseCustomization:FindFirstChild("UnitSizePanel")
            if UnitSizePanel6 and UnitSizePanel6.Visible then
                a0:UpdateUnitSizePanel()
            end
        end

    end)
    table.insert(a0.ClaimCons, v647)
    a0:UpdateUnclaimButton()
    a0:UpdateUnitSizePanel()
    a0:UpdateStorageCapacity()
end

getBobbing.StorageClaimed = StorageClaimed

local function GetStorageCapacityLimit(a0) --[[ Upvalues: v9 (copy), v10 (copy) ]]
    local Data3 = a0.Data
    if not Data3 then
        Data3 = {}
    end

    local v648 = tonumber(Data3.BaseUnitSize) or 1
    if a0.StorageBase then
        local v649 = a0.StorageBase:GetAttribute("BaseUnitSize")
        v648 = tonumber(v649) or v648
    end

    local BaseBasement = Data3.BaseBasement
    if typeof(BaseBasement) ~= "string" or true == "" then
        v650 = a0.StorageBase
        if v650 then
            v650 = a0.StorageBase:FindFirstChild("Basement") ~= nil
        end
    end

    local v651 = false
    if Data3.StorageCapacitySplitMigrated ~= true then
        v651 = Data3.ExtraStorageCap == true
    end

    local GetLimit = v9.GetLimit
    local v652 = true
    if Data3.ExtraStorageGamepass ~= true then
        local v653 = v10.HasGrant(Data3.GamepassGrants, 230541266)
    end

    return GetLimit(v648, v650, v652, Data3.ExtraStorageUpgrade == true, v651)
end

getBobbing.GetStorageCapacityLimit = GetStorageCapacityLimit

local function UpdateStorageCapacity(a0)
    local v654 = a0:GetStorageCapacityLimit()
    local v655 = tostring(a0:GetStorageCapacity())
    local v656 = "Capacity: " .. v655 .. "/" .. tostring(v654)
    local BuildGui = a0.BuildGui
    if not (BuildGui and BuildGui.Parent) then
        BuildGui = a0.Player.PlayerGui:FindFirstChild("BuildModeGui")
    end

    local v657 = BuildGui and BuildGui:FindFirstChild("Toolbar") and BuildGui.Toolbar:FindFirstChild("Buttons")
    local v658 = v657 and v657:FindFirstChild("Capacity")
    if v658 then
        v658.Text = v656
    end
end

getBobbing.UpdateStorageCapacity = UpdateStorageCapacity

local function StopEditStorage(a0) --[[ Upvalues: v16 (copy), ContextActionService (copy), RunService (copy) ]]
    if a0.Painting then
        v16.Close(a0)
    end

    local BaseEdit6 = a0.HUD.BaseEdit
    a0.CurrentFrame = nil
    a0.EditingBase = nil
    a0:EndBuildMode()
    a0:ClearBaseObjects()
    a0:ClearEditCons()
    a0:DeleteEditObject()
    a0:EnableBackpack(true)
    a0:BarsVisible(true)
    a0.ObjectHover = nil
    a0.HighlightHover.Parent = nil
    a0.DeletingObjects = false
    a0.HUD.MobileMouse.Visible = false
    a0.HUD.MobileEdits.Visible = false
    if a0.BuildMobileButtonVisibility then
        for k94, k95 in pairs(a0.BuildMobileButtonVisibility) do
            if k94 and k94.Parent then
                k94.Visible = k95
            end
        end

        a0.BuildMobileButtonVisibility = nil
    end

    local v662 = "flip"
    local v663 = {"rotate", v662, "flip2", "place", "delete", "deleteMode", "deselect"}
    for k96, k97 in ipairs(v663) do
        ContextActionService:UnbindAction(k97)
    end

    RunService:UnbindFromRenderStep("UpdateSearch")
    BaseEdit6.BaseObjects.Text = "Edit Base"
    a0.HUD.BaseObjects.Visible = false
    a0.HUD.BaseObjects.Hotkeys.Visible = false
end

getBobbing.StopEditStorage = StopEditStorage

local function SetBaseObjectsCollapsed(a0, a1, a2)
    local v667 = a0.HUD and a0.HUD:FindFirstChild("BaseObjects")
    local v669 = v667 and v667:FindFirstChild("CollapseButton")
    if not (v667 and v669) then
        return
    end

    a1 = a1 == true
    if not a2 and a0.BaseObjectsCollapsed == a1 then
        return
    end

    a0.BaseObjectsCollapsed = a1
    if a1 then
        local Search = v667:FindFirstChild("Search")
        if Search and Search:IsA("TextBox") then
            Search:ReleaseFocus()
        end

        Search = a0.BaseObjectsExpandedState
        if not Search then
            local v671 = {
                GuiVisibility = {},
                BackgroundTransparency = v667.BackgroundTransparency,
                ImageTransparency = v667.ImageTransparency
            }
            Search = v671
            local v672 = v667:GetChildren()
            for k98, k99 in ipairs(v672) do
                if k99 ~= v669 and k99:IsA("GuiObject") then
                    Search.GuiVisibility[k99] = k99.Visible
                end
            end

            a0.BaseObjectsExpandedState = Search
        end

        for k100 in pairs(Search.GuiVisibility) do
            if k100 and k100.Parent == v667 then
                k100.Visible = false
            end
        end

        v667.BackgroundTransparency = 1
        v667.ImageTransparency = 1
        v669.Text = "Show Objects \226\150\178"
        v669.Position = UDim2.new(0.5, 0, 1, -18)
    else
        local BaseObjectsExpandedState = a0.BaseObjectsExpandedState
        if BaseObjectsExpandedState then
            for k101, k102 in pairs(BaseObjectsExpandedState.GuiVisibility) do
                if k101 and k101.Parent == v667 then
                    k101.Visible = k102
                end
            end

            v667.BackgroundTransparency = BaseObjectsExpandedState.BackgroundTransparency
            v667.ImageTransparency = BaseObjectsExpandedState.ImageTransparency
            a0.BaseObjectsExpandedState = nil
        end

        v669.Text = "Hide Objects \226\150\188"
        v669.Position = UDim2.new(0.65, 0, -0.125, 0)
    end

    v669.Visible = true
    v669.Selectable = true
end

getBobbing.SetBaseObjectsCollapsed = SetBaseObjectsCollapsed
local v682 = Color3.fromRGB(42, 170, 255)

local function SetBaseObjectFrameSelected(a0, a1, a2) --[[ Upvalues: v6 (copy) ]]
    if not (a1 and a1.Parent) then
        return
    end

    if a1:GetAttribute("BuildDefaultBackgroundColor") == nil then
        a1:SetAttribute("BuildDefaultBackgroundColor", a1.BackgroundColor3)
    end

    if a1:GetAttribute("BuildDefaultBorderSize") == nil then
        a1:SetAttribute("BuildDefaultBorderSize", a1.BorderSizePixel)
    end

    a1.BorderColor3 = Color3.new(1, 1, 1)
    local v683
    if a2 then
        v683 = 3
    else
        local v684 = a1:GetAttribute("BuildDefaultBorderSize")
    end

    a1.BorderSizePixel = v683
    if a2 then
        a1.BackgroundColor3 = Color3.new(0, 0, 0)
        a1.Price.Text = "Deselect"
        a1.Price.TextColor3 = Color3.fromRGB(255, 139, 139)
        return
    end

    local v685 = a1:GetAttribute("BuildDefaultBackgroundColor")
    if typeof(v685) == "Color3" then
        a1.BackgroundColor3 = v685
    end

    v685 = v6[a1.Name]
    if not v685 then
        return
    end

    a1.Price.Text = "$" .. v685.Price
    if v685.ItemObject then
        local v687 = a0.Data and a0.Data.BaseItems and a0.Data.BaseItems[a1.Name]
        a1.Price.Text = v687 and "x" .. v687 or "NONE"
    end

    a1.Price.TextColor3 = Color3.fromRGB(172, 255, 149)
end

getBobbing.SetBaseObjectFrameSelected = SetBaseObjectFrameSelected

local function SetCurrentBaseObjectFrame(a0, a1)
    if a0.CurrentFrame and a0.CurrentFrame ~= a1 then
        a0:SetBaseObjectFrameSelected(a0.CurrentFrame, false)
    end

    a0.CurrentFrame = a1
    if a1 then
        a0:SetBaseObjectFrameSelected(a1, true)
    end
end

getBobbing.SetCurrentBaseObjectFrame = SetCurrentBaseObjectFrame

local function ClearBaseObjects(a0)
    local v690 = a0.HUD.BaseObjects.List:GetChildren()
    for k103, k104 in pairs(v690) do
        if k104:IsA("ViewportFrame") and k104.Name ~= "Sample" then
            k104:Destroy()
        end
    end
end

getBobbing.ClearBaseObjects = ClearBaseObjects

local function IsDesktopBuildCatalogue(a0) --[[ Upvalues: UserInputService (copy) ]]
    local v694 = false
    if a0.EditingBase == true then
        v694 = false
        if UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse then
            local v696 = a0.ClassicMobile and a0.ClassicMobile:IsActive()
            v694 = not v696
            if v694 then
                local v698 = a0.ModernMobile and a0.ModernMobile:IsActive()
                v694 = not v698
                if v694 then
                    local v700 = a0.ClassicController and a0.ClassicController:IsGamepad()
                    v694 = not v700
                    if v694 then
                        local v702 = a0.ModernController and a0.ModernController:IsGamepad()
                        v694 = not v702
                    end
                end
            end
        end
    end

    return v694
end

getBobbing.IsDesktopBuildCatalogue = IsDesktopBuildCatalogue

local function IsModernDesktopCatalogue(a0)
    local v703 = a0:IsDesktopBuildCatalogue()
    return v703
end

getBobbing.IsModernDesktopCatalogue = IsModernDesktopCatalogue

local function SelectDesktopCatalogueObject(a0, a1) --[[ Upvalues: GuiService (copy), v6 (copy), Preferences (copy) ]]
    local DesktopCatalogue = a0.DesktopCatalogue
    if not DesktopCatalogue or not DesktopCatalogue.Active or not a0:IsDesktopBuildCatalogue() or not a0.BuildCameraActive or a0.BuildModeKind ~= "Objects" or a0.Painting or a0.DeleteAllConfirmOpen or a0.PaintResetConfirmOpen or GuiService.MenuIsOpen or a0.BuildSystemSwitching then
        return false
    end

    local v704 = v6[a1]
    if not v704 then
        return false
    end

    if not Preferences.IsValidName(a1) then
        return false
    end

    if v704.Unlock then
        local UnlockedObjects = a0.Data.UnlockedObjects
        if not UnlockedObjects then
            UnlockedObjects = {}
        end

        if not UnlockedObjects[a1] then
            return false
        end
    end

    if a0.EditObject and not a0.EditingExistingObject and a0.EditObject.Name == a1 then
        a0:DeleteEditObject()
    else
        a0:SelectEditObject(a1, v704.Type)
    end

    DesktopCatalogue:RefreshSelection()
    return true
end

getBobbing.SelectDesktopCatalogueObject = SelectDesktopCatalogueObject

local function RefreshDesktopBuildCatalogue(a0) --[[ Upvalues: GuiService (copy), v7 (copy), UserInputService (copy) ]]
    local v705 = a0:IsDesktopBuildCatalogue()
    if v705 then
        v705 = false
        if a0.BuildCameraActive == true then
            v705 = false
            if a0.BuildModeKind == "Objects" then
                local v710 = not a0.Painting and not a0.DeleteAllConfirmOpen and not a0.PaintResetConfirmOpen and not a0.BuildSystemSwitching and not GuiService.MenuIsOpen
            end
        end
    end

    if v705 and not a0.DesktopCatalogue then
        a0:HydrateModernBuildPreferences()

        local function Select(a0) --[[ Upvalues: a0 (copy) ]]
            a0:SelectDesktopCatalogueObject(a0)
        end

        local function Favorite(a0) --[[ Upvalues: a0 (copy), GuiService (upvalue) ]]
            if a0.DesktopCatalogue and a0.DesktopCatalogue.Active and not a0.DeleteAllConfirmOpen and not a0.PaintResetConfirmOpen and not a0.BuildSystemSwitching and not GuiService.MenuIsOpen then
                a0:ToggleModernDesktopFavorite(a0)
            end
        end

        local function Collapsed(a0) --[[ Upvalues: a0 (copy) ]]
            a0.BaseObjectsCollapsed = a0
        end

        local function ClassicRotateStep() --[[ Upvalues: a0 (copy) ]]
            a0:CycleClassicDesktopRotateStep()
        end

        local function ClassicPaint() --[[ Upvalues: a0 (copy) ]]
            a0:ToggleClassicDesktopPaint()
        end

        local v711 = {
            Select = Select,
            Favorite = Favorite,
            Collapsed = Collapsed,
            ClassicRotateStep = ClassicRotateStep,
            ClassicPaint = ClassicPaint
        }
        a0.DesktopCatalogue = v7.Catalogue.Desktop.new(a0, v711)
        a0.DesktopCatalogue:SetCollapsed(a0.BaseObjectsCollapsed == true)
        a0.DesktopCatalogueCons = {}

        local function connect(a0, a1) --[[ Upvalues: a0 (copy) ]]
            local v712 = a0:Connect(a1)
            table.insert(a0.DesktopCatalogueCons, v712)
        end

        local v713 = UserInputService:GetPropertyChangedSignal("PreferredInput")
        local v714 = v713:Connect(function() --[[ Upvalues: a0 (copy) ]]
            task.defer(function() --[[ Upvalues: a0 (upvalue) ]]
                if a0.DesktopCatalogue then
                    a0:RefreshDesktopBuildCatalogue()
                end

            end)
        end)
        table.insert(a0.DesktopCatalogueCons, v714)
        local v715 = GuiService.MenuOpened:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:RefreshDesktopBuildCatalogue()
        end)
        table.insert(a0.DesktopCatalogueCons, v715)
        local v716 = GuiService.MenuClosed:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:RefreshDesktopBuildCatalogue()
        end)
        table.insert(a0.DesktopCatalogueCons, v716)
        local v717 = a0.Player.CharacterRemoving:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:DestroyDesktopBuildCatalogue()
        end)
        table.insert(a0.DesktopCatalogueCons, v717)
    end

    local DesktopCatalogue1 = a0.DesktopCatalogue
    if DesktopCatalogue1 then
        DesktopCatalogue1:SetActive(v705 == true)
        if v705 then
            a0.HUD.BaseObjects.Visible = false
            DesktopCatalogue1:RefreshSelection()
        end
    end
end

getBobbing.RefreshDesktopBuildCatalogue = RefreshDesktopBuildCatalogue

local function DestroyDesktopBuildCatalogue(a0)
    local DesktopCatalogue2 = a0.DesktopCatalogue
    a0.DesktopCatalogue = nil
    if DesktopCatalogue2 then
        DesktopCatalogue2:Destroy()
    end

    local DesktopCatalogueCons = a0.DesktopCatalogueCons
    if not DesktopCatalogueCons then
        DesktopCatalogueCons = {}
    end

    for k105, k106 in ipairs(DesktopCatalogueCons) do
        k106:Disconnect()
    end

    a0.DesktopCatalogueCons = nil
end

getBobbing.DestroyDesktopBuildCatalogue = DestroyDesktopBuildCatalogue

local function HydrateModernBuildPreferences(a0) --[[ Upvalues: Preferences (copy) ]]
    local Data5 = a0.Data
    if not Data5 then
        Data5 = {}
    end

    a0.Data = Data5
    local v721 = a0.ModernBuildFavorites or a0.Data.ModernBuildFavorites
    a0.ModernBuildFavorites = Preferences.Favorites(v721)
    local v722 = a0.ModernBuildRecents or a0.Data.ModernBuildRecents
    a0.ModernBuildRecents = Preferences.Recents(v722)
    a0.Data.ModernBuildFavorites = table.clone(a0.ModernBuildFavorites)
    a0.Data.ModernBuildRecents = table.clone(a0.ModernBuildRecents)
end

getBobbing.HydrateModernBuildPreferences = HydrateModernBuildPreferences

local function RefreshModernDesktopCataloguePreferences(a0)
    if not a0:IsModernDesktopCatalogue() then
        return
    end

    if a0.DesktopCatalogue then
        a0.DesktopCatalogue:Refresh()
        return
    end

    local v723 = a0.HUD and a0.HUD:FindFirstChild("BaseObjects")
    local v725 = v723 and v723:FindFirstChild("List")
    if not v725 then
        return
    end

    v723 = {}
    local ModernBuildRecents1 = a0.ModernBuildRecents
    if not ModernBuildRecents1 then
        ModernBuildRecents1 = {}
    end

    for k107, k108 in ipairs(ModernBuildRecents1) do
        v723[k108] = k107
    end

    local v729 = v725:GetChildren()
    for k109, k110 in ipairs(v729) do
        if k110:IsA("ViewportFrame") then
            if k110.Name ~= "Sample" then
                local ModernFavorite = k110:FindFirstChild("ModernFavorite")
                if ModernFavorite then
                    local ModernBuildFavorites2 = a0.ModernBuildFavorites
                    if ModernBuildFavorites2 then
                        ModernBuildFavorites2 = a0.ModernBuildFavorites[k110.Name] == true
                    end

                    local v733
                    if ModernBuildFavorites2 then
                        v733 = "\226\152\133"
                    else
                        v733 = "\226\152\134"
                    end

                    ModernFavorite.Text = v733
                    local v735
                    if not (ModernBuildFavorites2 and Color3.fromRGB(255, 226, 137)) then
                        local v736 = Color3.new(1, 1, 1)
                    end

                    ModernFavorite.TextColor3 = v735
                    if a0.CurrentSubCategory == "Favorites" then
                        k110.Visible = ModernBuildFavorites2
                    end
                end

                if a0.CurrentSubCategory == "Recent" then
                    k110.Visible = v723[k110.Name] ~= nil
                    k110.LayoutOrder = v723[k110.Name] or 999
                end
            end
        end
    end
end

getBobbing.RefreshModernDesktopCataloguePreferences = RefreshModernDesktopCataloguePreferences

local function ToggleModernDesktopFavorite(a0, a1) --[[ Upvalues: Preferences (copy), RemoteEvent (copy) ]]
    if not (a0:IsModernDesktopCatalogue() and Preferences.IsValidName(a1)) then
        return
    end

    a0:HydrateModernBuildPreferences()
    local v737 = table.clone(a0.ModernBuildFavorites)
    local v738 = v737[a1] ~= true
    local v739
    if v738 then
        v739 = true
    else
        v739 = nil
    end

    v737[a1] = v739
    a0.ModernBuildFavorites = v737
    a0.Data.ModernBuildFavorites = table.clone(v737)
    RemoteEvent:FireServer("ChangeModernBuildFavorite", a1, v738)
    a0:RefreshModernDesktopCataloguePreferences()
end

getBobbing.ToggleModernDesktopFavorite = ToggleModernDesktopFavorite

local function RememberModernDesktopObject(a0, a1) --[[ Upvalues: Preferences (copy), RemoteEvent (copy) ]]
    if not (a0:IsModernDesktopCatalogue() and Preferences.IsValidName(a1)) then
        return
    end

    a0:HydrateModernBuildPreferences()
    if a0.ModernBuildRecents[1] == a1 then
        return
    end

    local v740 = table.clone(a0.ModernBuildRecents)
    local v741 = table.find(v740, a1)
    if v741 then
        table.remove(v740, v741)
    end

    table.insert(v740, 1, a1)
    while Preferences.MAX_RECENTS < #v740 do
        table.remove(v740)
    end

    a0.ModernBuildRecents = v740
    a0.Data.ModernBuildRecents = table.clone(v740)
    RemoteEvent:FireServer("RememberModernBuildObject", a1)
    local v742 = a0.HUD and a0.HUD:FindFirstChild("BaseObjects")
    local v743 = v742 and v742:FindFirstChild("List")
    if a0.CurrentSubCategory == "Recent" and v743 and not v743:FindFirstChild(a1) then
        a0:UpdateBaseObjects(a0.CurrentBaseObjects, true)
        return
    end

    a0:RefreshModernDesktopCataloguePreferences()
end

getBobbing.RememberModernDesktopObject = RememberModernDesktopObject

local function UpdateSubCategories(a0, a1) --[[ Upvalues: v6 (copy) ]]
    if a0:IsDesktopBuildCatalogue() then
        return
    end

    local SubTypes = a0.HUD.BaseObjects.SubTypes
    local List5 = a0.HUD.BaseObjects.List
    local v744 = a0:IsModernDesktopCatalogue()
    if v744 then
        a0:HydrateModernBuildPreferences()
    end

    local Y1 = workspace.CurrentCamera.ViewportSize.Y
    local v745, v746, v747
    if a0.TouchEnabled then
        v745 = 0.38
        local v748 = math.round(Y1 * 0.04)
        v746 = math.clamp(v748, 22, 42)
        v747 = 14
    else
        v745 = 0.24
        local v749 = math.round(Y1 * 0.022)
        v746 = math.clamp(v749, 16, 28)
        v747 = 8
    end

    SubTypes.Size = UDim2.new(1, 0, v745, 0)
    List5.Position = UDim2.new(0, 0, v745 + 0.02, 0)
    List5.Size = UDim2.new(1, 0, 0.98 - v745, 0)
    local v750 = SubTypes:GetChildren()
    for k111, k112 in pairs(v750) do
        if k112:IsA("TextButton") and k112.Name ~= "Sample" then
            k112:Destroy()
        end
    end

    v745 = {
        Beds = 1,
        Seating = 2,
        Tables = 3,
        Storage = 4,
        Kitchen = 5,
        ["Walls & Doors"] = 6,
        Utility = 7,
        Flooring = 10,
        Plants = 11,
        Electronics = 12,
        Showcases = 13,
        Lighting = 14,
        Misc = 15,
        Turrets = 20,
        Guytraps = 21,
        Floor = 22
    }
    Y1 = {}
    List5 = {}
    for k113, k114 in pairs(v6) do
        if k114.Type == a1 and k114.SubCategory and not Y1[k114.SubCategory] then
            Y1[k114.SubCategory] = true
            table.insert(List5, k114.SubCategory)
        end
    end

    table.sort(List5, function(a0, a1) --[[ Upvalues: v745 (copy) ]]
        local v757 = v745[a0] or 999
        return v757 < (v745[a1] or 999)
    end)
    k113 = "All"
    table.insert(List5, 1, k113)
    if v744 then
        table.insert(List5, 1, "Favorites")
        local v758 = "Recent"
        table.insert(List5, 1, v758)
    end

    for k115, k116 in ipairs(List5) do
        Y1 = SubTypes.Sample:Clone()
        Y1.Name = k116
        Y1.Text = k116
        Y1.LayoutOrder = k115
        Y1.Visible = true
        Y1.TextSize = v746
        if v744 then
            Y1.Font = Enum.Font.Code
            Y1.BackgroundColor3 = Color3.new(0, 0, 0)
            Y1.BackgroundTransparency = 0.5
            Y1.BorderColor3 = Color3.new(1, 1, 1)
            Y1.BorderSizePixel = 1
        end

        Y1.UIPadding.PaddingLeft = UDim.new(0, v747)
        Y1.UIPadding.PaddingRight = UDim.new(0, v747)
        if k116 == a0.CurrentSubCategory then
            Y1.TextColor3 = Color3.fromRGB(172, 255, 149)
        else
            Y1.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        Y1.Parent = SubTypes
        local v762 = "SubCat" .. k116
        a0.EditCons[v762] = Y1.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy), k116 (copy), SubTypes (copy) ]]
            a0.CurrentSubCategory = k116
            local v763 = SubTypes:GetChildren()
            for k117, k118 in pairs(v763) do
                if k118:IsA("TextButton") then
                    if k118.Name ~= "Sample" then
                        if k118.Name == k116 then
                            k118.TextColor3 = Color3.fromRGB(172, 255, 149)
                        else
                            k118.TextColor3 = Color3.fromRGB(255, 255, 255)
                        end
                    end
                end
            end

            a0:UpdateBaseObjects(a0.CurrentBaseObjects)
        end)
    end
end

getBobbing.UpdateSubCategories = UpdateSubCategories

local function UpdateBaseObjects(a0, a1, a2) --[[ Upvalues: v6 (copy), Preferences (copy), createViewportBaseObjects (copy) ]]
    if a0:IsDesktopBuildCatalogue() then
        a0:HydrateModernBuildPreferences()
        if a0.DesktopCatalogue then
            a0.DesktopCatalogue:Refresh()
        end

        return
    end

    if a0.ModernMobile then
        if a0.ModernMobile:IsActive() then
            if a0.ModernMobile.UI.MenuOpen then
                a0.ModernMobile.UI:RefreshCatalogue()
            end

            a0.ModernMobile:RefreshPresentation()
            return
        end
    end

    if a0.ClassicMobile then
        if a0.ClassicMobile:IsActive() then
            if a0.ClassicMobile.UI.MenuOpen then
                a0.ClassicMobile.UI:RefreshCatalogue()
            end

            a0.ClassicMobile:RefreshPresentation()
            return
        end
    end

    local v767 = a0:IsModernDesktopCatalogue()
    if v767 then
        a0:HydrateModernBuildPreferences()
        a1 = a0.CurrentBaseObjects or a1
    end

    local v768 = v767
    if v768 then
        v768 = true
        if a0.CurrentSubCategory ~= "Favorites" then
            v768 = a0.CurrentSubCategory == "Recent"
        end
    end

    local v769 = {}
    if v767 then
        for k119, k120 in ipairs(a0.ModernBuildRecents) do
            v769[k120] = k119
        end
    end

    local v773 = v6
    local List6 = a0.HUD.BaseObjects.List
    local Sample = List6.Sample
    local v774 = List6:FindFirstChildOfClass("UIGridLayout")
    local v775, v776
    if a0.TouchEnabled then
        if v774 then
            v774.CellSize = UDim2.new(0.2, 0, 1, 0)
        end

        Sample.ObjectName.Size = UDim2.new(1, 0, 0.34, 0)
        Sample.Price.Size = UDim2.new(1, 0, 0.24, 0)
        v775 = 0
        v776 = 0.76
        Sample.Price.Position = UDim2.new(0, v775, v776, 0)
    else
        if v774 then
            v774.CellSize = UDim2.new(0.1, 0, 1, 0)
        end

        Sample.ObjectName.Size = UDim2.new(1, 0, 0.2, 0)
        Sample.Price.Size = UDim2.new(1, 0, 0.2, 0)
        v775 = 0
        v776 = 0.8
        Sample.Price.Position = UDim2.new(0, v775, v776, 0)
    end

    local v777 = true
    if a2 ~= true then
        v777 = v767
    end

    a2 = v777
    local v779 = a2 and a0.EditObject and not a0.EditingExistingObject and a0.EditObject.Name
    if not a2 then
        a0:DeleteEditObject()
    end

    a0:ClearBaseObjects()
    a0.CurrentFrame = nil
    for k121, k122 in pairs(v773) do
        if not (v768 and Preferences.IsValidName(k121)) then
            if not v768 then
                if k122.Type ~= a1 then
                    -- jump to 563
                end

                -- branch continues at 563
            end
        end

        if v768 then
            if a0.CurrentSubCategory == "Favorites" then
                if not a0.ModernBuildFavorites[k121] then
                    -- jump to 563
                end
            end

            if a0.CurrentSubCategory == "Recent" then
                if not v769[k121] then
                    -- jump to 563
                end

                -- branch continues at 311
            end
        else
            if a0.CurrentSubCategory then
                if a0.CurrentSubCategory ~= "All" then
                    if k122.SubCategory ~= a0.CurrentSubCategory then
                        -- jump to 563
                    end
                end
            end
        end

        Sample = string.lower(a0.SearchText or "")
        if Sample == "" or string.lower(k121) then
            if not k122.Unlock or a0.Data.UnlockedObjects[k121] then
                Sample = List6.Sample:Clone()
                Sample.Name = k121
                Sample.Price.Text = "$" .. k122.Price
                Sample.ObjectName.Text = k121
                Sample.Visible = true
                Sample.LayoutOrder = v768 and a0.CurrentSubCategory == "Recent" and v769[k121] or k122.Price
                createViewportBaseObjects(Sample, k121, k122.Type)
                Sample.Parent = List6
                if k122.ItemObject then
                    if a0.Data.BaseItems[k121] then
                        Sample.Price.Text = "x" .. a0.Data.BaseItems[k121]
                    else
                        Sample.Price.Text = "NONE"
                    end
                end

                if v767 then
                    local TextButton = Instance.new("TextButton")
                    TextButton.Name = "ModernFavorite"
                    TextButton.AnchorPoint = Vector2.new(1, 0)
                    TextButton.Position = UDim2.new(1, -4, 0.22, 0)
                    TextButton.Size = UDim2.fromOffset(28, 28)
                    TextButton.BackgroundColor3 = Color3.new(0, 0, 0)
                    TextButton.BackgroundTransparency = 0.5
                    TextButton.BorderColor3 = Color3.new(1, 1, 1)
                    TextButton.BorderSizePixel = 1
                    TextButton.Font = Enum.Font.Code
                    TextButton.TextSize = 24
                    local v785
                    if a0.ModernBuildFavorites[k121] then
                        v785 = "\226\152\133"
                    else
                        v785 = "\226\152\134"
                    end

                    TextButton.Text = v785
                    local v787
                    if not (a0.ModernBuildFavorites[k121] and Color3.fromRGB(255, 226, 137)) then
                        local v788 = Color3.new(1, 1, 1)
                    end

                    TextButton.TextColor3 = v787
                    TextButton.ZIndex = math.max(Sample.ZIndex, Sample.Select.ZIndex, Sample.ObjectName.ZIndex) + 2
                    TextButton.Active = true
                    TextButton.Selectable = false
                    TextButton.Parent = Sample
                    TextButton.Activated:Connect(function() --[[ Upvalues: a0 (copy), k121 (copy) ]]
                        a0:ToggleModernDesktopFavorite(k121)
                    end)
                end

                if v779 == k121 then
                    a0:SetCurrentBaseObjectFrame(Sample)
                end

                Sample.Select.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy), Sample (copy), k121 (copy), k122 (copy) ]]
                    local EditObject1 = a0.EditObject
                    if EditObject1 then
                        EditObject1 = not a0.EditingExistingObject
                        if EditObject1 then
                            EditObject1 = a0.CurrentFrame == Sample
                        end
                    end

                    if EditObject1 then
                        a0:DeleteEditObject()
                        return
                    end

                    a0:SelectEditObject(k121, k122.Type)
                    if a0.EditObject and not a0.EditingExistingObject then
                        a0:SetCurrentBaseObjectFrame(Sample)
                    end

                end)
            end
        end
    end
end

getBobbing.UpdateBaseObjects = UpdateBaseObjects
v682 = {0.1, 0.25, 0.5, 1, 2, 5}
local v789 = {5, 15, 30, 45, 90}
local v790 = Color3.fromRGB(42, 170, 255)
local v791 = Color3.fromRGB(0, 0, 0)
local v792 = Color3.fromRGB(82, 218, 126)
local v793 = Color3.fromRGB(255, 91, 91)

local function styleBuildButton(a0, a1, a2) --[[ Upvalues: v791 (copy) ]]
    a0.BackgroundColor3 = v791
    a0.BackgroundTransparency = 0.5
    a0.BorderColor3 = Color3.new(1, 1, 1)
    local v794
    if a1 then
        v794 = 3
    else
        v794 = 1
    end

    a0.BorderSizePixel = v794
    if a0:IsA("TextButton") then
        local v797 = a2 or Color3.new(1, 1, 1)
        a0.TextColor3 = v797
    end
end

local v798 = Enum.ContextActionPriority.High.Value + 30
local v799 = {X = Vector3.new(1, 0, 0), Y = Vector3.new(0, 1, 0), Z = Vector3.new(0, 0, 1)}
local v800 = {Vector3.new(0, 1, 0), Vector3.new(0, 0, 1)}
v800 = {Vector3.new(0, 0, 1), Vector3.new(1, 0, 0)}
v800 = {Vector3.new(1, 0, 0), Vector3.new(0, 1, 0)}
local v801 = {X = v800, Y = v800, Z = v800}

local function buildRotationCFrame(a0)
    a0 = a0 or Vector3.new(-90, 90, 0)
    local v802 = math.rad(a0.X)
    local v803 = math.rad(a0.Y)
    local v804 = CFrame.Angles(v802, v803, math.rad(a0.Z))
    return v804
end

local function buildRotationVector(a0)
    local v805, v806, v807 = a0:ToEulerAnglesXYZ()
    local v808 = math.deg(v805)
    local v809 = math.deg(v806)
    return Vector3.new(v808, v809, math.deg(v807))
end

local function rotateBuildRotationOnLocalAxis(a0, a1, a2) --[[ Upvalues: v799 (copy) ]]
    local v810 = v799[a1]
    if not v810 then
        return a0
    end

    local v811 = a0 or Vector3.new(-90, 90, 0)
    local v812 = math.rad(v811.X)
    local v813 = math.rad(v811.Y)
    local v814 = CFrame.Angles(v812, v813, math.rad(v811.Z))
    local v815, v816, v817 = (v814 * CFrame.fromAxisAngle(v810, math.rad(a2))):ToEulerAnglesXYZ()
    local v818 = math.deg(v815)
    local v819 = math.deg(v816)
    return Vector3.new(v818, v819, math.deg(v817))
end

local function projectBuildWorldPoint(a0, a1)
    local v820 = a0:WorldToViewportPoint(a1)
    if v820.Z <= 0 then
        return nil
    end

    local v821 = Vector2.new(v820.X, v820.Y)
    return v821
end

local function buildPointToSegmentDistance(a0, a1, a2)
    local v822 = a2 - a1
    local v823 = v822:Dot(v822)
    if v823 <= 0.0001 then
        return (a0 - a1).Magnitude
    end

    local v824 = (a0 - a1):Dot(v822) / v823
    return (a0 - (a1 + v822 * math.clamp(v824, 0, 1))).Magnitude
end

local function buildCross2(a0, a1)
    local v825 = a0.X * a1.Y
    return v825 - a0.Y * a1.X
end

local function buildConvexHull(a0)
    if #a0 < 3 then
        return nil
    end

    table.sort(a0, function(a0, a1)
        local v826 = true
        if a0.X >= a1.X then
            v826 = false
            if a0.X == a1.X then
                v826 = a0.Y < a1.Y
            end
        end

        return v826
    end)
    local v827 = {}
    local v831
    for k123, k124 in ipairs(a0) do
        while 2 <= #v827 do
            local v832 = v827[#v827]
            local v833 = v832 - v827[#v827 - 1]
            v832 = k124 - v827[#v827]
            local v834 = v833.X * v832.Y
            if v834 - v833.Y * v832.X > 0 then
                break
            end

            table.remove(v827)
        end

        v831 = table.insert
        v831(v827, k124)
    end

    local v835 = {}
    for i8 = #a0, 1, -1 do
        k124 = a0[i8]
        while 2 <= #v835 do
            local v838 = v835[#v835]
            local v839 = v838 - v835[#v835 - 1]
            v838 = k124 - v835[#v835]
            local v840 = v839.X * v838.Y
            if v840 - v839.Y * v838.X > 0 then
                break
            end

            table.remove(v835)
        end

        v831 = table.insert
        v831(v835, k124)
    end

    table.remove(v827)
    table.remove(v835)
    for k125, k126 in ipairs(v835) do
        table.insert(v827, k126)
    end

    return 3 <= #v827 and v827 or nil
end

local function buildPointInConvexPolygon(a0, a1)
    local v846 = false
    local v847 = false
    for k127, k128 in ipairs(a1) do
        local v851 = a1[k127 % #a1 + 1] - k128
        local v852 = a0 - k128
        local v853 = v851.X * v852.Y
        local v854 = v853 - v851.Y * v852.X
        if 0.001 < v854 then
            v846 = true
        else
            if v854 < -0.001 then
                v847 = true
            end
        end

        if v846 and v847 then
            return false
        end
    end

    return true
end

local function buildRayConvexPolygonExit(a0, a1, a2)
    local v855 = nil
    for k129, k130 in ipairs(a2) do
        local v859 = a2[k129 % #a2 + 1] - k130
        local v860 = a1.X * v859.Y
        local v861 = v860 - a1.Y * v859.X
        local v862 = math.abs(v861)
        if 0.0001 < v862 then
            v862 = k130 - a0
            local v863 = v862.X * v859.Y
            local v864 = (v863 - v862.Y * v859.X) / v861
            local v865 = v862.X * a1.Y
            local v866 = (v865 - v862.Y * a1.X) / v861
            if 0 <= v864 then
                if -0.001 <= v866 then
                    if v866 <= 1.001 then
                        if not v855 or v864 < v855 then
                            v855 = v864
                        end
                    end
                end
            end
        end
    end

    return v855
end

local function buildWorldUnitsPerPixel(a0, a1)
    local v867 = (a1 - a0.CFrame.Position):Dot(a0.CFrame.LookVector)
    if v867 <= 0 then
        return nil
    end

    local v868 = math.max(a0.ViewportSize.Y, 1)
    local v869 = 2 * v867
    return v869 * math.tan(math.rad(a0.FieldOfView) * 0.5) / v868
end

local function buildAxisSize(a0, a1)
    if a1 == "X" then
        return a0.X
    end

    if a1 == "Y" then
        return a0.Y
    end

    return a0.Z
end

local function buildAxisPerpendicularSize(a0, a1)
    if a1 == "X" then
        return math.max(a0.Y, a0.Z)
    end

    if a1 == "Y" then
        return math.max(a0.Z, a0.X)
    end

    return math.max(a0.X, a0.Y)
end

local function buildRayPlaneIntersection(a0, a1, a2, a3)
    local v870 = a0:ViewportPointToRay(a1.X, a1.Y)
    local v871 = v870.Direction:Dot(a3)
    local v872 = math.abs(v871)
    if v872 <= 0.0001 then
        return nil
    end

    v872 = (a2 - v870.Origin):Dot(a3) / v871
    if v872 <= 0 then
        return nil
    end

    return v870.Origin + v870.Direction * v872
end

local function buildSnap(a0, a1)
    if not a1 or a1 <= 0 then
        return a0
    end

    return math.round(a0 / a1) * a1
end

local function buildFormatNumber(a0)
    local v873 = math.abs(a0 - math.round(a0))
    if v873 < 0.001 then
        return tostring(math.round(a0))
    end

    local v874 = string.format("%.2f", a0)
    local v875 = v874:gsub("0+$", "")
    local v876 = v875:gsub("%.$", "")
    return v876
end

local function GetBuildReference(a0)
    if not a0.StorageBase then
        return nil, nil
    end

    local Floor = a0.StorageBase:FindFirstChild("Floor")
    local v878 = Contents4 and Contents4:FindFirstChild("BoundingBox")
    return Floor, v878
end

getBobbing.GetBuildReference = GetBuildReference

local function IsBuildGroundPart(a0, a1)
    if not (a1 and a1:IsA("BasePart")) then
        return false
    end

    local v879 = a1
    while v879 do
        if v879 == workspace then
            break
        end

        local v880 = string.lower(v879.Name)
        if string.find(v880, "floor", 1, true) or v880 == "ground" or v880 == "baseplate" or v880 == "terrain" then
            return true
        end

        v879 = v879.Parent
    end

    local v881 = a0.StorageBase and a0.StorageBase:FindFirstChild("Floor")
    if a1 == v881 then
        return true
    end

    local Map = workspace:FindFirstChild("Map")
    local v883 = Map and Map:FindFirstChild("FLOOR_OBJECTS")
    if v883 and a1:IsDescendantOf(v883) then
        return true
    end

    local v884, v885 = a0:GetBuildReference()
    if v885 and a0.StorageBase and a1:IsDescendantOf(a0.StorageBase) then
        local v886 = -v885.Size.Y * 0.5
        local v887 = math.abs(a1.CFrame.UpVector:Dot(v885.CFrame.UpVector))
        if v885.CFrame:PointToObjectSpace(a1.Position).Y <= v886 + math.max(4, a1.Size.Y) and 0.75 <= v887 then
            return true
        end
    end

    return false
end

getBobbing.IsBuildGroundPart = IsBuildGroundPart

local function ClampBuildCameraPosition(a0, a1)
    if typeof(a1) ~= "Vector3" then
        return a1
    end

    local v888, v889 = a0:GetBuildReference()
    if not v889 then
        return a1
    end

    v888 = v889.Size * 0.5
    local v890 = math.max(0, v888.X - 1.25)
    local v891 = math.max(0, v888.Y - 1.25)
    local v892 = math.max(0, v888.Z - 1.25)
    v888 = v889.CFrame:PointToObjectSpace(a1)
    local v893 = math.clamp(v888.X, -v890, v890)
    local v894 = math.clamp(v888.Y, -v891, v891)
    local v895 = Vector3.new(v893, v894, math.clamp(v888.Z, -v892, v892))
    local v896 = v889.CFrame:PointToWorldSpace(v895)
    return v896
end

getBobbing.ClampBuildCameraPosition = ClampBuildCameraPosition

local function CacheBuildSurfaceParts(a0)
    a0.BuildSurfaceParts = {}
    if not a0.StorageBase then
        return
    end

    local v897 = a0.StorageBase:FindFirstChild("Basement") or a0.StorageBase:FindFirstChild("Contents")
    local v899 = v897 and v897:FindFirstChild("Customization")
    if not v899 then
        return
    end

    local v900 = v899:GetDescendants()
    for k131, k132 in ipairs(v900) do
        if k132:IsA("BasePart") and k132.Name == "Wall" then
            a0.BuildSurfaceParts[k132] = true
        end
    end
end

getBobbing.CacheBuildSurfaceParts = CacheBuildSurfaceParts

local function DestroyBuildGrid(a0)
    if a0.BuildGrid then
        a0.BuildGrid:Destroy()
        a0.BuildGrid = nil
    end

    a0.BuildGridFloor = nil
end

getBobbing.DestroyBuildGrid = DestroyBuildGrid

local function GetBuildGridFloor(a0)
    local v904, v905 = a0:GetBuildReference()
    if not (v904 and v905) then
        return nil, v905
    end

    local v906 = a0.StorageBase and a0.StorageBase:FindFirstChild("Basement")
    if not v906 then
        return v904, v905
    end

    local BottomFloor = v906:FindFirstChild("BottomFloor")
    if not BottomFloor then
        return v904, v905
    end

    local v907 = v906:FindFirstChild("Floor") or v904
    local v908 = v907.Size.Y * 0.5
    local v909 = (workspace.CurrentCamera.CFrame.Position - v907.CFrame:PointToWorldSpace(Vector3.new(0, v908, 0))):Dot(v905.CFrame.UpVector)
    if a0.BuildGridFloor == v904 and -0.75 <= v909 then
        return v904, v905
    end

    if a0.BuildGridFloor == BottomFloor and v909 <= 0.75 then
        return BottomFloor, v905
    end

    return 0 <= v909 and v904 or BottomFloor, v905
end

getBobbing.GetBuildGridFloor = GetBuildGridFloor

local function UpdateBuildGridLabel(a0) --[[ Upvalues: buildFormatNumber (copy) ]]
    if not a0.BuildGui then
        return
    end

    local GridHeight = a0.BuildGui.TransformPanel.AxisRows:FindFirstChild("GridHeight")
    if not GridHeight then
        return
    end

    local v912 = a0:GetBuildGridFloor()
    GridHeight.Axis.Text = "GRID " .. buildFormatNumber(v912 and a0.BuildGridOffsets and a0.BuildGridOffsets[v912] or 0 or 0)
end

getBobbing.UpdateBuildGridLabel = UpdateBuildGridLabel

local function UpdateBuildGridSurface(a0)
    local BuildGrid = a0.BuildGrid
    if not (BuildGrid and BuildGrid:IsA("BasePart")) then
        return
    end

    local v915, v916 = a0:GetBuildGridFloor()
    if not (v915 and v915:IsA("BasePart") and v916) then
        return
    end

    local BuildGridOffsets = a0.BuildGridOffsets
    if not BuildGridOffsets then
        BuildGridOffsets = {}
    end

    a0.BuildGridOffsets = BuildGridOffsets
    a0.BuildGridFloor = v915
    local v917 = v915.Size.Y * 0.5
    local v918 = v915.CFrame:PointToWorldSpace(Vector3.new(0, v917, 0))
    local Y2 = v916.CFrame:PointToObjectSpace(v918).Y
    v918 = v916.Size.Y * 0.5
    local v919 = a0.BuildGridOffsets[v915] or 0
    local v920 = -v918 + 0.05 - Y2
    local v921 = math.clamp(v919, v920, v918 - 0.05 - Y2)
    a0.BuildGridOffsets[v915] = v921
    local v922 = math.max(v916.Size.X, 0.1)
    BuildGrid.Size = Vector3.new(v922, 0.02, math.max(v916.Size.Z, 0.1))
    local v923 = Y2 + v921 + 0.02
    BuildGrid.CFrame = v916.CFrame * CFrame.new(0, v923, 0)
    Y2 = BuildGrid:FindFirstChild("GridTexture")
    if Y2 and Y2:IsA("Texture") then
        local v924 = a0.BuildMoveStep or 0.5
        v918 = math.max(v924, 0.1)
        Y2.StudsPerTileU = v918
        Y2.StudsPerTileV = v918
    end

    if not (a0.BuildGridFloor ~= v915) then
        local v925 = math.abs(v921 - v919)
        if 0.001 >= v925 then
            return
        end
    end

    a0:UpdateBuildGridLabel()
end

getBobbing.UpdateBuildGridSurface = UpdateBuildGridSurface

local function AdjustBuildGridHeight(a0, a1)
    if not a0.BuildCameraActive then
        return
    end

    local v926 = a0:GetBuildGridFloor()
    if not v926 then
        return
    end

    local BuildGridOffsets1 = a0.BuildGridOffsets
    if not BuildGridOffsets1 then
        BuildGridOffsets1 = {}
    end

    a0.BuildGridOffsets = BuildGridOffsets1
    local v927 = a0.BuildGridOffsets[v926] or 0
    a0.BuildGridOffsets[v926] = v927 + (a0.BuildMoveStep or 0.5) * a1
    a0:UpdateBuildGridSurface()
    a0:UpdateBuildGridLabel()
end

getBobbing.AdjustBuildGridHeight = AdjustBuildGridHeight

local function RebuildBuildGrid(a0)
    a0:DestroyBuildGrid()
    if not (a0.BuildCameraActive and a0.BuildGridEnabled) then
        a0:UpdateBuildGridLabel()
        return
    end

    local v928, v929 = a0:GetBuildGridFloor()
    if not (v928 and v929) then
        return
    end

    local Part = Instance.new("Part")
    Part.Name = "BuildGrid"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Parent = workspace.CurrentCamera
    v928 = Instance.new("Texture")
    v928.Name = "GridTexture"
    v928.Texture = "rbxassetid://2600521419"
    v928.Face = Enum.NormalId.Top
    v928.Color3 = Color3.fromRGB(255, 255, 255)
    v928.Transparency = 0.25
    v928.Parent = Part
    a0.BuildGrid = Part
    a0:UpdateBuildGridSurface()
end

getBobbing.RebuildBuildGrid = RebuildBuildGrid

local function usingBuildController() --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    local v930 = GuiService:IsTenFootInterface()
    if not v930 then
        local GamepadEnabled = UserInputService.GamepadEnabled
        if GamepadEnabled then
            GamepadEnabled = not UserInputService.KeyboardEnabled
            if not GamepadEnabled then
                GamepadEnabled = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
            end
        end
    end

    return v930
end

local function HandleBuildObjectDPad(a0, a1, a2) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    if a0.ModernController and a0.ModernController:IsGamepad() then
        return Enum.ContextActionResult.Pass
    end

    if a0.DeleteAllConfirmOpen or a0.PaintResetConfirmOpen or GuiService.MenuIsOpen then
        return Enum.ContextActionResult.Pass
    end

    if not a0.BuildCameraActive or a0.BuildModeKind ~= "Objects" then
        return Enum.ContextActionResult.Pass
    end

    if a1 ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Sink
    end

    if UserInputService:GetFocusedTextBox() then
        return Enum.ContextActionResult.Sink
    end

    local v932 = a2 and a2.KeyCode
    if v932 == Enum.KeyCode.DPadDown then
        if a0.EditingBase then
            a0:StopEditStorage()
            -- jump to 122 (out of range)
        end

        a0:EndBuildMode()
    else
        if v932 == Enum.KeyCode.DPadRight then
            local v933
            if a0.BuildTransformMode == "Rotate" then
                v933 = "Move"
            else
                v933 = "Rotate"
            end

            a0:SetBuildTransformMode(v933)
        else
            if v932 == Enum.KeyCode.DPadLeft then
                if a0.BuildTransformMode == "Rotate" then
                    a0:CycleBuildRotateStep()
                    -- jump to 122 (out of range)
                end

                if a0.BuildTransformMode == "Move" then
                    a0:CycleBuildMoveStep()
                    -- branch continues at 122
                end
            else
                if v932 == Enum.KeyCode.DPadUp and a0.EditingBase then
                    a0:OpenPaintFrames()
                end
            end
        end
    end

    return Enum.ContextActionResult.Sink
end

getBobbing.HandleBuildObjectDPad = HandleBuildObjectDPad

local function BindBuildObjectDPad(a0) --[[ Upvalues: ContextActionService (copy), v798 (copy) ]]
    ContextActionService:UnbindAction("BaseObjectEditDPad")
    ContextActionService:BindActionAtPriority("BaseObjectEditDPad", function(a0, a1, a2) --[[ Upvalues: a0 (copy) ]]
        local v934 = a0:HandleBuildObjectDPad(a1, a2)
        return v934
    end, false, v798, Enum.KeyCode.DPadDown, Enum.KeyCode.DPadRight, Enum.KeyCode.DPadLeft, Enum.KeyCode.DPadUp)
end

getBobbing.BindBuildObjectDPad = BindBuildObjectDPad

local function UnbindBuildObjectDPad(a0) --[[ Upvalues: ContextActionService (copy) ]]
    ContextActionService:UnbindAction("BaseObjectEditDPad")
end

getBobbing.UnbindBuildObjectDPad = UnbindBuildObjectDPad

local function SetBuildGamepadNavigation(a0, a1) --[[ Upvalues: GuiService (copy), UserInputService (copy), ContextActionService (copy), GamepadService (copy) ]]
    if a0.ModernController and a0.ModernController:IsGamepad() then
        a0.BuildGamepadNavigation = false
        return
    end

    a1 = a1 == true
    if a0.BuildCameraLocked then
        local v935 = GuiService:IsTenFootInterface()
        if not v935 then
            local GamepadEnabled1 = UserInputService.GamepadEnabled
            if GamepadEnabled1 then
                GamepadEnabled1 = not UserInputService.KeyboardEnabled
                if not GamepadEnabled1 then
                    GamepadEnabled1 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
                end
            end
        end

        if v935 then
            a1 = true
        end
    end

    a0.BuildGamepadNavigation = a1
    GuiService.SelectedObject = nil
    if UserInputService.GamepadEnabled then
        pcall(function() --[[ Upvalues: ContextActionService (upvalue), a1 (ref) ]]
            ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
            ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
            if a1 then
                ContextActionService:BindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
            end

        end)
        a0.BuildGamepadActivationRemapped = true
        if a1 then
            local v936 = a0.BuildGui and a0.BuildGui:FindFirstChild("Toolbar")
            local v938 = v936 and v936:FindFirstChild("Buttons")
            local v939 = a0.HUD and a0.HUD:FindFirstChild("PaintEditBar")
            local v940
            if not (a0.Painting and v939 and v939:FindFirstChild("PaintBrush")) then
                local v942 = v938 and v938:FindFirstChild("MoveMode") or nil
            end

            if not pcall(function() --[[ Upvalues: GamepadService (upvalue), v940 (copy) ]]
                GamepadService:EnableGamepadCursor(v940)
            end) then
                pcall(function() --[[ Upvalues: GamepadService (upvalue) ]]
                    GamepadService:EnableGamepadCursor(nil)
                end)
                -- branch continues at 141
            end
        else
            if GamepadService.GamepadCursorEnabled then
                pcall(function() --[[ Upvalues: GamepadService (upvalue) ]]
                    GamepadService:DisableGamepadCursor()
                end)
            end
        end
    end

    a0:UpdateBuildGui()
end

getBobbing.SetBuildGamepadNavigation = SetBuildGamepadNavigation

local function SetBuildCameraLocked(a0, a1) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    if not a0.BuildCameraActive then
        return
    end

    local v943 = a0.BuildCameraLocked == true
    a0.BuildCameraLocked = a1 == true
    local BuildCameraLocked = a0.BuildCameraLocked
    if BuildCameraLocked then
        local v944 = GuiService:IsTenFootInterface()
        if not v944 then
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
        if not v943 then
            local v945 = a0.BuildGamepadNavigation == true
            if a0.PaintPickerPreviousGamepadNavigation ~= nil then
                v945 = a0.PaintPickerPreviousGamepadNavigation == true
            end

            a0.BuildGamepadNavigationBeforeCameraLock = v945
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
        if v943 then
            if not a0.BuildCameraLocked then
                if a0.BuildCameraLockManagedGamepadNavigation then
                    local v946 = a0.BuildGamepadNavigationBeforeCameraLock == true
                    a0.BuildGamepadNavigationBeforeCameraLock = nil
                    a0.BuildCameraLockManagedGamepadNavigation = nil
                    if a0.ColorPickerHUD then
                        a0.PaintPickerPreviousGamepadNavigation = v946
                        a0:SetBuildGamepadNavigation(true)
                    else
                        a0:SetBuildGamepadNavigation(v946)
                    end
                end
            end
        end
    end

    a0:UpdateBuildGui()
end

getBobbing.SetBuildCameraLocked = SetBuildCameraLocked

local function UpdateBuildGui(a0) --[[ Upvalues: styleBuildButton (copy), buildFormatNumber (copy), v793 (copy), GuiService (copy), UserInputService (copy) ]]
    a0:RefreshDesktopBuildCatalogue()
    local BuildGui2 = a0.BuildGui
    if not BuildGui2 then
        return
    end

    a0:UpdateBuildSystem()
    if a0.ClassicDesktop then
        a0.ClassicDesktop:Refresh()
    end

    if a0.ModernDesktop then
        a0.ModernDesktop:Refresh()
    end

    if a0.ModernMobile and a0.ModernMobile:IsActive() then
        a0:UpdateStorageCapacity()
        a0.ModernMobile:RefreshPresentation()
        return
    end

    if a0.ModernController and a0.ModernController:IsGamepad() then
        a0:UpdateStorageCapacity()
        a0.ModernController:RefreshPresentation()
        return
    end

    local BuildSystemToggle1 = BuildGui2:FindFirstChild("BuildSystemToggle")
    if BuildSystemToggle1 then
        local v947 = false
        if a0.BuildCameraActive == true then
            v947 = false
            if a0.BuildModeKind == "Objects" then
                v947 = not a0.Painting
            end
        end

        local v950 = v947 and not a0.BuildSystemSwitching
        BuildSystemToggle1.Visible = v947
        BuildSystemToggle1.Active = v950
        BuildSystemToggle1.Interactable = v950
    end

    if a0.ClassicBuildActive then
        a0:ApplyClassicBuildPresentation()
        a0:UpdateStorageCapacity()
        return
    end

    local Buttons2 = BuildGui2.Toolbar.Buttons
    local v951 = a0.BuildTransformMode ~= "Rotate"
    styleBuildButton(Buttons2.MoveMode, v951)
    styleBuildButton(Buttons2.RotateMode, not v951)
    local v952
    if a0.BuildGridEnabled then
        v952 = "Grid: On"
    else
        v952 = "Grid: Off"
    end

    Buttons2.Grid.Text = v952
    Buttons2.MoveStep.Text = "Move " .. buildFormatNumber(a0.BuildMoveStep or 0.5)
    local v953 = buildFormatNumber(a0.BuildRotateStep or 15)
    Buttons2.RotateStep.Text = "Rotate " .. v953 .. "\194\176"
    if a0.EditingExistingObject then
        v952 = "Save Move"
    else
        v952 = "Place"
    end

    Buttons2.Place.Text = "Rotate " .. v953 .. "\194\176"
    a0:UpdateBuildGridLabel()
    local DeleteMode = Buttons2:FindFirstChild("DeleteMode")
    if DeleteMode then
        local v954
        if a0.DeletingObjects then
            v954 = "Delete: On"
        else
            v954 = "Delete: Off"
        end

        DeleteMode.Text = v954
        styleBuildButton(DeleteMode, a0.DeletingObjects, a0.DeletingObjects and v793 or nil)
    end

    local PaintMode = Buttons2:FindFirstChild("PaintMode")
    if PaintMode then
        local v957 = false
        if a0.BuildModeKind == "Paint" then
            v957 = a0.Painting
        end

        local v958
        if v957 then
            v958 = "Objects"
        else
            v958 = "Paint"
        end

        PaintMode.Text = v958
        styleBuildButton(PaintMode, v957)
    end

    local ControllerHotkeys = BuildGui2:FindFirstChild("ControllerHotkeys")
    if ControllerHotkeys then
        local v959 = false
        if a0.BuildModeKind == "Objects" then
            local v960 = GuiService:IsTenFootInterface()
            if not v960 then
                local GamepadEnabled3 = UserInputService.GamepadEnabled
                if GamepadEnabled3 then
                    GamepadEnabled3 = not UserInputService.KeyboardEnabled
                    if not GamepadEnabled3 then
                        GamepadEnabled3 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
                    end
                end
            end
        end

        ControllerHotkeys.Visible = v959
        if v951 then
            v959 = "Move / Grid " .. buildFormatNumber(a0.BuildMoveStep or 0.5)
            if v959 then
                -- jump to 291
            end
        end

        local v961 = buildFormatNumber(a0.BuildRotateStep or 15)
        v959 = "Rotate " .. v961 .. "\194\176"
        local v962 = buildFormatNumber(a0.BuildRotateStep or 15)
        ControllerHotkeys.Text = "D-PAD  \226\134\147 Exit  \194\183  \226\134\146 Mode  \194\183  \226\134\144 " .. v959 .. "  \194\183  \226\134\145 Paint  \194\183  R2 Rotate " .. v962 .. "\194\176"
    end

    local CameraLock = Buttons2:FindFirstChild("CameraLock")
    if CameraLock then
        local v963
        if a0.BuildCameraLocked then
            v963 = "Cam: Locked"
        else
            v963 = "Cam: Free"
        end

        CameraLock.Text = v963
        styleBuildButton(CameraLock, a0.BuildCameraLocked)
    end

    local Title = BuildGui2.TransformPanel.Title
    if v951 then
        local v964 = buildFormatNumber(a0.BuildMoveStep or 0.5)
        local v965 = "MOVE \194\183 " .. v964 .. " STUD"
        if v965 then
            -- jump to 348
        end
    end

    local v966 = buildFormatNumber(a0.BuildRotateStep or 15)
    local v967 = "ROTATE \194\183 " .. v966 .. "\194\176"
    Title.Text = v967
    if a0.BuildModeKind == "Paint" then
        if a0.TouchEnabled then
            if a0.BuildCameraLocked then
                v967 = "CAMERA LOCKED \194\183 Tap to paint \194\183 Use Cam: Locked to unlock"
            else
                v967 = "Tap to paint \194\183 Camera arrows move \194\183 Drag to look \194\183 Pinch to zoom"
            end

            BuildGui2.Hint.Text = v967
            -- jump to 537 (out of range)
        end

        if not UserInputService.GamepadEnabled or UserInputService.KeyboardEnabled then
            if not GuiService:IsTenFootInterface() then
                -- jump to 407
            end
        end

        if a0.BuildGamepadNavigation then
            if a0.BuildCameraLocked then
                v967 = "CAMERA LOCKED \194\183 FREE CURSOR \194\183 A paint/select UI \194\183 L3 unlock \194\183 D-pad tools"
            else
                v967 = "CURSOR MODE \194\183 A paint/select UI \194\183 L3 lock camera \194\183 R3 camera \194\183 D-pad tools"
            end

            BuildGui2.Hint.Text = v967
            -- jump to 537 (out of range)
        end

        if a0.BuildCameraLocked then
            v967 = "CAMERA LOCKED \194\183 L3 unlock \194\183 R3 cursor \194\183 D-pad tools"
        else
            v967 = "CAMERA MODE \194\183 A paint \194\183 Sticks/LB-RB camera \194\183 L3 lock \194\183 R3 cursor \194\183 D-pad tools"
        end

        BuildGui2.Hint.Text = v967
        -- jump to 537 (out of range)
        if a0.BuildCameraLocked then
            v967 = "CAMERA LOCKED \194\183 Click to paint \194\183 Use Cam: Locked to unlock"
        else
            v967 = "Click to paint \194\183 RMB orbit \194\183 MMB pan \194\183 Wheel/WASD/QE camera"
        end

        BuildGui2.Hint.Text = v967
    else
        if a0.TouchEnabled then
            if a0.DeletingObjects then
                if a0.BuildCameraLocked then
                    v967 = "CAMERA LOCKED \194\183 Tap object to delete \194\183 Delete: On to stop"
                else
                    v967 = "Tap object to delete \194\183 Delete: On to stop \194\183 Drag empty space to look"
                end

                BuildGui2.Hint.Text = v967
                -- jump to 537 (out of range)
            end

            if a0.BuildCameraLocked then
                if a0.EditObject then
                    v967 = "CAMERA LOCKED \194\183 Drag object \194\183 Use transform panel to move/rotate"
                else
                    v967 = "CAMERA LOCKED \194\183 Hold object 0.4s to edit \194\183 Cam: Locked to unlock"
                end

                BuildGui2.Hint.Text = v967
                -- jump to 537 (out of range)
            end

            if a0.EditObject then
                v967 = "Drag object \194\183 Use transform panel to move/rotate \194\183 Camera arrows move"
            else
                v967 = "Hold object 0.4s to edit \194\183 Camera arrows move \194\183 Drag empty space to look"
            end

            BuildGui2.Hint.Text = v967
        else
            if not UserInputService.GamepadEnabled or UserInputService.KeyboardEnabled then
                if not GuiService:IsTenFootInterface() then
                    -- jump to 499
                end
            end

            if a0.BuildGamepadNavigation then
                if a0.BuildCameraLocked then
                    v967 = "CAMERA LOCKED \194\183 FREE CURSOR \194\183 A select/drag/handles/UI \194\183 L3 unlock"
                else
                    v967 = "CURSOR MODE \194\183 A select/drag/handles/UI \194\183 L3 lock camera \194\183 R3 camera mode"
                end

                BuildGui2.Hint.Text = v967
            else
                if a0.BuildCameraLocked then
                    v967 = "CAMERA LOCKED \194\183 A select/drag \194\183 L3 unlock \194\183 R3 cursor mode"
                else
                    v967 = "CAMERA MODE \194\183 A select/drag \194\183 Sticks move/look \194\183 LB/RB forward/back \194\183 L3 lock \194\183 R3 cursor"
                end

                BuildGui2.Hint.Text = v967
            end
        end
    end

    a0:UpdateBuildViewPanel()
    a0:UpdateStorageCapacity()
end

getBobbing.UpdateBuildGui = UpdateBuildGui

local function SetBuildTransformMode(a0, a1)
    if a1 ~= "Move" and a1 ~= "Rotate" then
        return
    end

    a0:EndBuildTouchGizmoDrag()
    a0.BuildTransformMode = a1
    a0.BuildTransformDirty = true
    a0:UpdateBuildGui()
    if a0.EditObject then
        local v968 = a0:GetBuildObjectCFrame()
        a0:UpdateBuildGizmo(v968)
    end
end

getBobbing.SetBuildTransformMode = SetBuildTransformMode

local function CycleBuildMoveStep(a0) --[[ Upvalues: v682 (copy) ]]
    local v970 = a0.BuildMoveStep or v682[3]
    local v971 = 1
    for k133, k134 in ipairs(v682) do
        local v975 = math.abs(k134 - v970)
        if v975 < 0.001 then
            v971 = k133 % #v682 + 1
            break
        end
    end

    a0.BuildMoveStep = v682[v971]
    a0:RebuildBuildGrid()
    a0:UpdateBuildGui()
end

getBobbing.CycleBuildMoveStep = CycleBuildMoveStep

local function CycleBuildRotateStep(a0) --[[ Upvalues: v789 (copy) ]]
    local v977 = a0.BuildRotateStep or v789[2]
    local v978 = 1
    for k135, k136 in ipairs(v789) do
        if k136 == v977 then
            v978 = k135 % #v789 + 1
            break
        end
    end

    a0.BuildRotateStep = v789[v978]
    a0:UpdateBuildGui()
end

getBobbing.CycleBuildRotateStep = CycleBuildRotateStep

local function RotateBuildObjectStep(a0, a1, a2) --[[ Upvalues: v799 (copy) ]]
    if not (a0.EditObject and a0.BuildObjectPosition) then
        return
    end

    local v982 = a0.BuildRotateStep or 15
    local v983 = v982 * (a2 or 1)
    local v984 = a0.BuildObjectRotation or Vector3.new(-90, 90, 0)
    local v985 = v799[a1]
    if not v985 then
        v982 = v984
    else
        local v986 = v984 or Vector3.new(-90, 90, 0)
        local v987 = math.rad(v986.X)
        local v988 = math.rad(v986.Y)
        local v989 = CFrame.Angles(v987, v988, math.rad(v986.Z))
        local v990, v991, v992 = (v989 * CFrame.fromAxisAngle(v985, math.rad(v983))):ToEulerAnglesXYZ()
        local v993 = math.deg(v990)
        local v994 = math.deg(v991)
        v982 = Vector3.new(v993, v994, math.deg(v992))
    end

    a0.BuildObjectRotation = v982
    a0:ClampBuildObjectToBounds()
    a0.BuildTransformDirty = true
end

getBobbing.RotateBuildObjectStep = RotateBuildObjectStep

local function NudgeBuildObject(a0, a1, a2) --[[ Upvalues: v799 (copy) ]]
    if not (a0.EditObject and a0.BuildObjectPosition) then
        return
    end

    if a0.BuildTransformMode == "Rotate" then
        a0:RotateBuildObjectStep(a1, a2)
        return
    end

    local v995 = (a0.BuildMoveStep or 0.5) * a2
    local BuildObjectPosition = a0.BuildObjectPosition
    local v996 = a0.StorageBase and a0.StorageBase:FindFirstChild("Floor")
    local v997 = v799[a1]
    if v996 and v997 then
        BuildObjectPosition = BuildObjectPosition + v996.CFrame:VectorToObjectSpace(v997).Unit * v995
    else
        if v997 then
            BuildObjectPosition = BuildObjectPosition + v997 * v995
        end
    end

    a0.BuildObjectPosition = BuildObjectPosition
    a0:ClampBuildObjectToBounds()
    a0.BuildTransformDirty = true
end

getBobbing.NudgeBuildObject = NudgeBuildObject

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

getBobbing.EndBuildTransformHold = EndBuildTransformHold

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
        local v998 = setmetatable({}, {__mode = "k"})
    end

    a0.BuildTransformHandledActivations = BuildTransformHolds1
    a0.BuildTransformHandledActivations[a2] = true
    if a0.BuildTransformHolds[a2] then
        return
    end

    local v999 = {Button = a1, Callback = a3}
    a0.BuildTransformHolds[a2] = v999
    a3()
    task.spawn(function() --[[ Upvalues: a0 (copy), a2 (copy), v999 (copy), a1 (copy), a3 (copy) ]]
        task.wait(0.35)
        while a0.BuildTransformHolds do
            local v1000 = a0.BuildTransformHolds[a2]
            if v1000 ~= v999 then
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
            local v1002 = a0.BuildTransformHolds[a2]
            if v1002 == v999 then
                a0.BuildTransformHolds[a2] = nil
            end
        end

    end)
end

getBobbing.BeginBuildTransformHold = BeginBuildTransformHold

local function QuarterTurnBuildObject(a0, a1) --[[ Upvalues: v799 (copy) ]]
    if not (a0.EditObject and a0.BuildObjectPosition) then
        return
    end

    if a1 ~= "Y" and a1 ~= "Z" then
        return
    end

    local v1003 = a0.BuildObjectRotation or Vector3.new(-90, 90, 0)
    local v1004 = v799[a1]
    local v1005
    if not v1004 then
        v1005 = v1003
    else
        local v1006 = v1003 or Vector3.new(-90, 90, 0)
        local v1007 = math.rad(v1006.X)
        local v1008 = math.rad(v1006.Y)
        local v1009 = CFrame.Angles(v1007, v1008, math.rad(v1006.Z))
        local v1010, v1011, v1012 = (v1009 * CFrame.fromAxisAngle(v1004, 1.5707963267948966)):ToEulerAnglesXYZ()
        local v1013 = math.deg(v1010)
        local v1014 = math.deg(v1011)
        v1005 = Vector3.new(v1013, v1014, math.deg(v1012))
    end

    a0.BuildObjectRotation = v1005
    a0:ClampBuildObjectToBounds()
    a0.BuildTransformDirty = true
end

getBobbing.QuarterTurnBuildObject = QuarterTurnBuildObject

local function GetBuildObjectCFrame(a0)
    local v1015 = a0.StorageBase and a0.StorageBase:FindFirstChild("Floor")
    if not (v1015 and a0.BuildObjectPosition) then
        local v1017
        if not (a0.EditObject and a0.EditObject:GetPivot()) then
            local v1018 = CFrame.new()
        end

        return v1017
    end

    local v1019 = a0.BuildObjectRotation or Vector3.new(-90, 90, 0)
    local v1020 = v1015.CFrame * CFrame.new(a0.BuildObjectPosition)
    local v1021 = math.rad(v1019.X)
    local v1022 = math.rad(v1019.Y)
    return v1020 * CFrame.Angles(v1021, v1022, math.rad(v1019.Z))
end

getBobbing.GetBuildObjectCFrame = GetBuildObjectCFrame

local function GetClampedBuildPosition(a0, a1, a2)
    if not a0.EditObject then
        return a1
    end

    local v1023, v1024 = a0:GetBuildReference()
    if not (v1023 and v1024) then
        return a1
    end

    local v1027 = a2 or a0.BuildObjectRotation or Vector3.new(-90, 90, 0)
    a2 = v1027
    local v1028 = v1023.CFrame * CFrame.new(a1)
    local v1029 = math.rad(a2.X)
    local v1030 = math.rad(a2.Y)
    v1027 = v1028 * CFrame.Angles(v1029, v1030, math.rad(a2.Z))
    local v1031 = a0.EditObject:GetPivot()
    local v1032 = Vector3.new(math.huge, math.huge, math.huge)
    v1029 = Vector3.new(-math.huge, -math.huge, -math.huge)
    v1030 = false
    local v1033 = a0.EditObject:GetDescendants()
    for k137, k138 in ipairs(v1033) do
        if k138:IsA("BasePart") then
            v1030 = true
            local v1037 = v1027 * v1031:ToObjectSpace(k138.CFrame)
            local v1038 = k138.Size / 2
            for i9 = -1, 1, 2 do
                for i10 = -1, 1, 2 do
                    for i11 = -1, 1, 2 do
                        local v1045 = v1038.X * i9
                        local v1046 = v1038.Y * i10
                        local v1047 = v1037 * Vector3.new(v1045, v1046, v1038.Z * i11)
                        local v1048 = v1024.CFrame:PointToObjectSpace(v1047)
                        local v1049 = math.min(v1032.X, v1048.X)
                        local v1050 = math.min(v1032.Y, v1048.Y)
                        v1032 = Vector3.new(v1049, v1050, math.min(v1032.Z, v1048.Z))
                        local v1051 = math.max(v1029.X, v1048.X)
                        local v1052 = math.max(v1029.Y, v1048.Y)
                        v1029 = Vector3.new(v1051, v1052, math.max(v1029.Z, v1048.Z))
                    end
                end
            end
        end
    end

    if not v1030 then
        return a1
    end

    local v1053 = v1024.CFrame:PointToObjectSpace(v1027.Position)
    v1031 = v1032 - v1053
    v1032 = v1029 - v1053
    local v1054 = v1024.Size / 2
    v1029 = v1054 + Vector3.new(0.094999998807907104, 0.094999998807907104, 0.094999998807907104)

    local function clampAxis(a0, a1, a2)
        if a2 < a1 then
            return (a1 + a2) / 2
        end

        return math.clamp(a0, a1, a2)
    end

    k138 = -v1029.X
    k137 = k138 - v1031.X
    k138 = v1029.X - v1032.X
    local v1055
    if k138 < k137 then
        v1055 = (k137 + k138) / 2
    else
        v1055 = math.clamp(v1053.X, k137, k138)
    end

    local v1056 = -v1029.Y
    k138 = v1056 - v1031.Y
    v1056 = v1029.Y - v1032.Y
    local v1057
    if v1056 < k138 then
        v1057 = (k138 + v1056) / 2
    else
        v1057 = math.clamp(v1053.Y, k138, v1056)
    end

    local v1058 = -v1029.Z
    v1056 = v1058 - v1031.Z
    v1058 = v1029.Z - v1032.Z
    local v1059
    if v1058 < v1056 then
        v1059 = (v1056 + v1058) / 2
    else
        v1059 = math.clamp(v1053.Z, v1056, v1058)
    end

    local v1060 = Vector3.new(v1055, v1057, v1059)
    v1053 = v1024.CFrame:PointToWorldSpace(v1060)
    local v1061 = v1023.CFrame:PointToObjectSpace(v1053)
    return v1061
end

getBobbing.GetClampedBuildPosition = GetClampedBuildPosition

local function ClampBuildObjectToBounds(a0)
    if not a0.BuildObjectPosition then
        return
    end

    a0.BuildObjectPosition = a0:GetClampedBuildPosition(a0.BuildObjectPosition, a0.BuildObjectRotation)
end

getBobbing.ClampBuildObjectToBounds = ClampBuildObjectToBounds

local function ResetBuildObjectTransform(a0)
    if not a0.EditObject then
        return
    end

    local v1062, v1063 = a0:GetBuildReference()
    if not (v1062 and v1063) then
        return
    end

    local v1064, v1065, v1066 = a0.EditObject:GetPivot():ToEulerAnglesXYZ()
    local v1067 = math.deg(v1064)
    local v1068 = math.deg(v1065)
    a0.BuildObjectRotation = Vector3.new(v1067, v1068, math.deg(v1066))
    local v1069 = a0.BuildFocus or v1063.Position
    local CurrentCamera2 = workspace.CurrentCamera
    if CurrentCamera2 then
        v1068 = CurrentCamera2.ViewportSize.X / 2
        v1064 = CurrentCamera2:ViewportPointToRay(v1068, CurrentCamera2.ViewportSize.Y / 2)
        local v1070 = {a0.EditObject, v1063}
        if a0.Character then
            table.insert(v1070, a0.Character)
        end

        if a0.BuildGrid then
            table.insert(v1070, a0.BuildGrid)
        end

        local v1071 = RaycastParams.new()
        v1071.FilterType = Enum.RaycastFilterType.Exclude
        v1071.FilterDescendantsInstances = v1070
        local v1072 = v1064.Direction * 4096
        v1070 = workspace:Raycast(v1064.Origin, v1072, v1071)
        if v1070 then
            local v1073 = v1063.CFrame:PointToObjectSpace(v1070.Position)
            local v1074 = v1063.Size / 2
            v1064 = v1074 + Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
            local v1075 = math.abs(v1073.X)
            if v1075 <= v1064.X then
                local v1076 = math.abs(v1073.Y)
                if v1076 <= v1064.Y then
                    local v1077 = math.abs(v1073.Z)
                    if v1077 <= v1064.Z then
                        v1069 = v1070.Position
                    end
                end
            end
        end
    end

    CurrentCamera2 = a0.BuildMoveStep or 0.5
    v1063 = v1062.CFrame:PointToObjectSpace(v1069)
    local X = v1063.X
    if not CurrentCamera2 or CurrentCamera2 <= 0 then
        local v1078 = X
        -- jump to 190 (out of range)
    end

    local v1079 = math.round(X / CurrentCamera2) * CurrentCamera2
    local Y3 = v1063.Y
    if not CurrentCamera2 or CurrentCamera2 <= 0 then
        X = Y3
        -- jump to 204 (out of range)
    end

    X = math.round(Y3 / CurrentCamera2) * CurrentCamera2
    local Z = v1063.Z
    if not CurrentCamera2 or CurrentCamera2 <= 0 then
        Y3 = Z
        -- jump to 218 (out of range)
    end

    Y3 = math.round(Z / CurrentCamera2) * CurrentCamera2
    a0.BuildObjectPosition = Vector3.new(v1079, X, Y3)
    local v1080 = a0:GetBuildObjectCFrame()
    a0.EditObject:PivotTo(v1080)
    v1069 = math.huge
    local v1081 = a0.EditObject:GetDescendants()
    for k139, k140 in ipairs(v1081) do
        if k140:IsA("BasePart") then
            CurrentCamera2 = k140.Size / 2
            for i12 = -1, 1, 2 do
                for i13 = -1, 1, 2 do
                    for i14 = -1, 1, 2 do
                        local v1091 = CurrentCamera2.X * i12
                        local v1092 = CurrentCamera2.Y * i13
                        v1069 = math.min(v1069, v1062.CFrame:PointToObjectSpace(k140.CFrame * Vector3.new(v1091, v1092, CurrentCamera2.Z * i14)).Y)
                    end
                end
            end
        end
    end

    if v1069 < math.huge then
        k139 = v1063.Y - v1069
        a0.BuildObjectPosition = a0.BuildObjectPosition + Vector3.new(0, k139, 0)
    end

    a0:ClampBuildObjectToBounds()
    a0.BuildTransformDirty = true
end

getBobbing.ResetBuildObjectTransform = ResetBuildObjectTransform

local function IsBuildObjectInBounds(a0, a1)
    local v1093, v1094 = a0:GetBuildReference()
    if not v1094 then
        return true
    end

    local v1095 = v1094.Size / 2
    v1093 = v1095 + Vector3.new(0.10000000149011612, 0.10000000149011612, 0.10000000149011612)
    local v1096 = a1:GetDescendants()
    for k141, k142 in ipairs(v1096) do
        if k142:IsA("BasePart") then
            local v1100 = k142.Size / 2
            for i15 = -1, 1, 2 do
                for i16 = -1, 1, 2 do
                    for i17 = -1, 1, 2 do
                        local v1107 = v1100.X * i15
                        local v1108 = v1100.Y * i16
                        local v1109 = k142.CFrame * Vector3.new(v1107, v1108, v1100.Z * i17)
                        local v1110 = v1094.CFrame:PointToObjectSpace(v1109)
                        local v1111 = math.abs(v1110.X)
                        if v1093.X < v1111 then
                            return false
                        end

                        local v1112 = math.abs(v1110.Y)
                        if v1093.Y < v1112 then
                            return false
                        end

                        local v1113 = math.abs(v1110.Z)
                        if v1093.Z < v1113 then
                            return false
                        end
                    end
                end
            end
        end
    end

    return true
end

getBobbing.IsBuildObjectInBounds = IsBuildObjectInBounds

local function HasBuildObjectAtCFrame(a0, a1)
    local v1114 = a0.StorageBase and a0.StorageBase:FindFirstChild("Floor")
    local v1115 = a0.StorageBase and a0.StorageBase:FindFirstChild("Contents")
    local v1117 = v1115 and v1115:FindFirstChild("Objects")
    if not (v1114 and v1117) then
        return false
    end

    v1115 = tostring(v1114.CFrame:Inverse() * a1)
    local v1118 = v1117:GetChildren()
    for k143, k144 in ipairs(v1118) do
        if k144 ~= a0.EditingExistingObject then
            if k144:IsA("Model") or k144:IsA("BasePart") then
                local v1122 = v1114.CFrame:Inverse()
                if tostring(v1122 * k144:GetPivot()) == v1115 then
                    return true
                end
            end
        end
    end

    return false
end

getBobbing.HasBuildObjectAtCFrame = HasBuildObjectAtCFrame

local function ValidateBuildObject(a0) --[[ Upvalues: v6 (copy) ]]
    if not a0.EditObject then
        return false, "Select an object first."
    end

    if a0.ModernMobile then
        if a0.ModernMobile:IsActive() then
            if not a0.EditingExistingObject then
                local v1123 = v6[a0.EditObject.Name]
                if not v1123 then
                    return false, "This object is unavailable."
                end

                local Data6 = a0.Data
                if not Data6 then
                    Data6 = {}
                end

                if v1123.Unlock then
                    local UnlockedObjects1 = Data6.UnlockedObjects
                    if not UnlockedObjects1 then
                        UnlockedObjects1 = {}
                    end

                    if not UnlockedObjects1[a0.EditObject.Name] then
                        return false, "Unlock this object first."
                    end
                end

                if v1123.ItemObject then
                    local BaseItems1 = Data6.BaseItems
                    if not BaseItems1 then
                        BaseItems1 = {}
                    end

                    local v1124 = tonumber(BaseItems1[a0.EditObject.Name]) or 0
                    if v1124 < 1 then
                        return false, "No more of this item in inventory."
                        -- branch continues at 95
                    end
                else
                    local v1125 = tonumber(Data6.Money) or 0
                    if v1125 < (tonumber(v1123.Price) or 0) then
                        return false, "Not enough money."
                    end
                end

                local v1126 = a0:GetStorageCapacity()
                local v1127 = v1126 + (v1123.Capacity or 1)
                if a0:GetStorageCapacityLimit() < v1127 then
                    return false, "Your base is full."
                end
            end
        end
    end

    local v1128 = a0:GetBuildObjectCFrame()
    a0.EditObject:PivotTo(v1128)
    if not a0:IsBuildObjectInBounds(a0.EditObject) then
        return false, "The object must stay inside your base."
    end

    if a0:HasBuildObjectAtCFrame(v1128) then
        return false, "Another object already uses this exact position."
    end

    return true
end

getBobbing.ValidateBuildObject = ValidateBuildObject

local function FindNearestValidBuildTransform(a0)
    if not (a0.EditObject and a0.BuildObjectPosition) then
        return false
    end

    local BuildObjectPosition1 = a0.BuildObjectPosition
    local BuildObjectRotation1 = a0.BuildObjectRotation
    local v1129 = a0.BuildMoveStep or 0.5
    local v1130 = math.max(v1129, 0.05)
    v1129 = 4
    for i18 = 1, v1129 do
        for i19 = -i18, i18 do
            for i20 = -i18, i18 do
                if math.abs(i19) ~= i18 then
                    if math.abs(i20) ~= i18 then
                        -- jump to 72
                    end
                end

                a0.BuildObjectPosition = a0:GetClampedBuildPosition(BuildObjectPosition1 + Vector3.new(i19 * v1130, 0, i20 * v1130), BuildObjectRotation1)
                a0.BuildObjectRotation = BuildObjectRotation1
                if a0:ValidateBuildObject() then
                    return true
                end
            end
        end
    end

    a0.BuildObjectPosition = BuildObjectPosition1
    a0.BuildObjectRotation = BuildObjectRotation1
    local v1136 = a0:GetBuildObjectCFrame()
    a0.EditObject:PivotTo(v1136)
    return false
end

getBobbing.FindNearestValidBuildTransform = FindNearestValidBuildTransform

local function RefreshBuildValidation(a0, a1) --[[ Upvalues: v793 (copy), v792 (copy), v791 (copy) ]]
    if not a0.EditObject then
        return
    end

    local v1137 = os.clock()
    if not a1 and not a0.BuildTransformDirty then
        local v1138 = v1137 - (a0.BuildValidationAt or 0)
        if v1138 < 0.2 then
            return
        end
    end

    a0.BuildValidationAt = v1137
    a0.BuildTransformDirty = false
    local v1139, v1140 = a0:ValidateBuildObject()
    if not v1139 then
        if not (a0.ModernMobile and a0.ModernMobile:IsActive()) then
            v1137 = false
            if a0.BuildLastValidPosition and a0.BuildLastValidRotation then
                a0.BuildObjectPosition = a0.BuildLastValidPosition
                a0.BuildObjectRotation = a0.BuildLastValidRotation
                local v1141, v1142 = a0:ValidateBuildObject()
                v1139 = v1141
                v1140 = v1142
                v1137 = v1139
                if not v1139 then
                    a0.BuildLastValidPosition = nil
                    a0.BuildLastValidRotation = nil
                end
            end

            if not v1137 and v1140 == "Another object already uses this exact position." and a0:FindNearestValidBuildTransform() then
                v1139 = true
                v1140 = nil
            end
        end
    end

    if v1139 then
        a0.BuildLastValidPosition = a0.BuildObjectPosition
        a0.BuildLastValidRotation = a0.BuildObjectRotation
    end

    a0.BuildPlacementValid = v1139
    a0.BuildInvalidReason = v1140
    local v1143 = a0.EditObject:FindFirstChildOfClass("Highlight")
    if v1143 then
        local v1146 = v1139 and Color3.fromRGB(255, 226, 137) or v793
        v1143.FillColor = v1146
        local v1149 = v1139 and Color3.fromRGB(255, 228, 120) or v793
        v1143.OutlineColor = v1149
    end

    if a0.BuildGui then
        local Place = a0.BuildGui.Toolbar.Buttons.Place
        Place.BackgroundColor3 = v791
        Place.BackgroundTransparency = 0.5
        Place.BorderColor3 = Color3.new(1, 1, 1)
        Place.BorderSizePixel = 1
        if Place:IsA("TextButton") then
            local v1154 = v1139 and v792 or v793 or Color3.new(1, 1, 1)
            Place.TextColor3 = v1154
        end
    end
end

getBobbing.RefreshBuildValidation = RefreshBuildValidation

local function AttemptPlaceBuildObject(a0)
    if not a0.EditObject then
        a0:Noti({Title = "Build Mode", Text = "Select an object to place first.", Duration = 2})
        return
    end

    local v1155 = os.clock() - (a0.BuildPlaceAt or 0)
    if v1155 < 0.2 then
        return
    end

    a0.BuildPlaceAt = os.clock()
    a0:RefreshBuildValidation(true)
    if not a0.BuildPlacementValid then
        local v1156 = {
            Title = "Can't Place",
            Duration = 2,
            Text = a0.BuildInvalidReason or "That position is not valid."
        }
        a0:Noti(v1156)
        return
    end

    local v1157 = a0:GetBuildObjectCFrame()
    a0:PlaceBaseObject(v1157, false)
end

getBobbing.AttemptPlaceBuildObject = AttemptPlaceBuildObject

local function HideBuildGizmos(a0)
    if not a0.BuildGui then
        return
    end

    local v1158 = "MoveY"
    local v1159 = {"MoveX", v1158, "MoveZ", "RotateX", "RotateY", "RotateZ"}
    for k145, k146 in ipairs(v1159) do
        local v1163 = a0.BuildGui:FindFirstChild(k146)
        if v1163 then
            v1163.Visible = false
            v1163.Adornee = nil
        end
    end
end

getBobbing.HideBuildGizmos = HideBuildGizmos

local function UpdateBuildGizmo(a0, a1)
    if a0.ModernController and a0.ModernController:IsGamepad() then
        a0:HideBuildGizmos()
        return
    end

    if a0.TouchEnabled then
        a0:EndBuildTouchGizmoDrag()
        a0:HideBuildGizmos()
        return
    end

    if not (a0.BuildCameraActive and a0.BuildGui and a0.EditObject) then
        a0:HideBuildGizmos()
        return
    end

    if not a0.BuildGizmoPart then
        local Part1 = Instance.new("Part")
        Part1.Name = "BuildGizmoAdornee"
        Part1.Anchored = true
        Part1.CanCollide = false
        Part1.CanTouch = false
        Part1.CanQuery = false
        Part1.Transparency = 1
        Part1.Parent = workspace.CurrentCamera
        a0.BuildGizmoPart = Part1
    end

    local v1164 = a0.EditObject:GetExtentsSize()
    local v1165 = math.max(v1164.X, 0.5)
    local v1166 = math.max(v1164.Y, 0.5)
    a0.BuildGizmoPart.Size = Vector3.new(v1165, v1166, math.max(v1164.Z, 0.5))
    if a0.BuildTransformMode == "Move" then
        a0.BuildGizmoPart.CFrame = CFrame.new(a1.Position)
    else
        a0.BuildGizmoPart.CFrame = a1
    end

    local v1167 = "MoveY"
    local v1168 = {"MoveX", v1167, "MoveZ", "RotateX", "RotateY", "RotateZ"}
    for k147, k148 in ipairs(v1168) do
        v1164 = a0.BuildGui:FindFirstChild(k148)
        if v1164 then
            v1164.Adornee = a0.BuildGizmoPart
            if a0.BuildTransformMode == "Move" then
                local v1172 = true
                if string.sub(k148, 1, 4) == "Move" then
                    -- jump to 192
                end
            end

            local v1173 = false
            if a0.BuildTransformMode == "Rotate" then
                v1173 = string.sub(k148, 1, 6) == "Rotate"
            end

            v1164.Visible = v1173
        end
    end
end

getBobbing.UpdateBuildGizmo = UpdateBuildGizmo

local function GetBuildTouchGizmoHit(a0, a1) --[[ Upvalues: buildConvexHull (copy), buildPointInConvexPolygon (copy), v799 (copy), buildRayConvexPolygonExit (copy), v801 (copy) ]]
    if not (typeof(a1) == "Vector2" and a0.BuildCameraActive and a0.EditObject and a0.BuildGui and a0.BuildGizmoPart) then
        return nil
    end

    local BuildTransformMode = a0.BuildTransformMode
    if BuildTransformMode ~= "Move" and BuildTransformMode ~= "Rotate" then
        return nil
    end

    local CurrentCamera3 = workspace.CurrentCamera
    local BuildGizmoPart = a0.BuildGizmoPart
    local Position1 = BuildGizmoPart.Position
    local v1174 = CurrentCamera3:WorldToViewportPoint(Position1)
    local v1175
    if v1174.Z <= 0 then
        v1175 = nil
    else
        v1175 = Vector2.new(v1174.X, v1174.Y)
    end

    local v1176 = (Position1 - CurrentCamera3.CFrame.Position):Dot(CurrentCamera3.CFrame.LookVector)
    if v1176 <= 0 then
        v1174 = nil
    else
        local v1177 = math.max(CurrentCamera3.ViewportSize.Y, 1)
        local v1178 = 2 * v1176
        v1174 = v1178 * math.tan(math.rad(CurrentCamera3.FieldOfView) * 0.5) / v1177
    end

    if not (v1175 and v1174) then
        return nil
    end

    v1176 = CurrentCamera3.ViewportSize
    local v1179 = math.min(v1176.X, v1176.Y) * 0.035
    local v1180 = math.clamp(v1179, 26, 42)
    if (a1 - v1175).Magnitude < (BuildTransformMode == "Rotate" and v1180 * 0.75 or v1180 * 0.55) then
        return nil
    end

    local v1182 = nil
    local v1183 = nil
    local v1185
    if BuildTransformMode == "Move" then
        local v1186 = {}
        local v1187 = BuildGizmoPart.Size * 0.5
        for i21 = -1, 1, 2 do
            v1185 = 1
            for i22 = -1, v1185, 2 do
                for i23 = -1, 1, 2 do
                    local v1193 = v1187.X * i21
                    local v1194 = v1187.Y * i22
                    local v1195 = CurrentCamera3:WorldToViewportPoint(BuildGizmoPart.CFrame * Vector3.new(v1193, v1194, v1187.Z * i23))
                    local v1196
                    if v1195.Z <= 0 then
                        v1196 = nil
                    else
                        v1196 = Vector2.new(v1195.X, v1195.Y)
                    end

                    if v1196 then
                        table.insert(v1186, v1196)
                    end
                end
            end
        end

        local v1197 = buildConvexHull(v1186)
        if not v1197 or buildPointInConvexPolygon(a1, v1197) then
            return nil
        end

        v1186 = math.min(v1176.X, v1176.Y)
        local v1198 = math.clamp(v1186 * 0.03, 11, 16)
        local v1199 = math.clamp(v1186 * 0.06, 20, 28)
        local v1200 = math.clamp(v1186 * 0.2, 58, 82)
        v1186 = math.max(v1174 * 48, 0.25)
        local v1201 = nil
        local v1202 = nil
        local v1203 = nil
        local v1204 = nil
        local v1205 = "Y"
        local v1206 = {"X", v1205, "Z"}
        for k149, k150 in ipairs(v1206) do
            local v1210 = v799[k150]
            local v1211 = a0.BuildGui:FindFirstChild("Move" .. k150)
            if v1211 and v1211.Visible then
                local Unit = BuildGizmoPart.CFrame:VectorToWorldSpace(v1210).Unit
                local v1212 = 1
                local v1213 = {-1, v1212}
                for k151, k152 in ipairs(v1213) do
                    local v1217 = CurrentCamera3:WorldToViewportPoint(Position1 + Unit * k152 * v1186)
                    local v1218
                    if v1217.Z <= 0 then
                        v1218 = nil
                    else
                        v1218 = Vector2.new(v1217.X, v1217.Y)
                    end

                    local v1221 = v1218 and v1218 - v1175
                    if v1221 then
                        if 3 <= v1221.Magnitude then
                            v1218 = v1221.Unit
                            local v1224 = buildRayConvexPolygonExit(v1175, v1218, v1197)
                            if v1224 then
                                local v1225 = v1175 + v1218 * (v1224 + 4)
                                local v1226 = v1175 + v1218 * (v1224 + v1200)
                                local v1227 = {
                                    Mode = "Move",
                                    Axis = k150,
                                    AxisLocal = v1210,
                                    AxisWorld = Unit,
                                    Center = Position1,
                                    ScreenDirection = v1218 * k152,
                                    PixelsPerStud = v1221.Magnitude / v1186
                                }
                                local v1228 = (a1 - v1226).Magnitude / v1199
                                if v1228 <= 1 then
                                    if not v1202 or v1228 < v1202 then
                                        v1202 = v1228
                                        v1201 = v1227
                                    end
                                end

                                local v1229 = v1226 - v1225
                                local v1230 = v1229:Dot(v1229)
                                local v1231
                                if v1230 <= 0.0001 then
                                    v1231 = (a1 - v1225).Magnitude
                                else
                                    local v1232 = (a1 - v1225):Dot(v1229) / v1230
                                    v1231 = (a1 - (v1225 + v1229 * math.clamp(v1232, 0, 1))).Magnitude
                                end

                                v1228 = v1231 / v1198
                                if v1228 <= 1 then
                                    if not v1204 or v1228 < v1204 then
                                        v1204 = v1228
                                        v1203 = v1227
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        return v1201 or v1203
    end

    for k153, k154 in pairs(v799) do
        v1176 = a0.BuildGui:FindFirstChild("Rotate" .. k153)
        if v1176 then
            if v1176.Visible then
                v1175 = v801[k153]
                local Unit1 = BuildGizmoPart.CFrame:VectorToWorldSpace(k154).Unit
                local Unit2 = BuildGizmoPart.CFrame:VectorToWorldSpace(v1175[1]).Unit
                local Unit3 = BuildGizmoPart.CFrame:VectorToWorldSpace(v1175[2]).Unit
                local Size = BuildGizmoPart.Size
                local v1236
                if k153 == "X" then
                    v1236 = math.max(Size.Y, Size.Z)
                else
                    if k153 == "Y" then
                        v1236 = math.max(Size.Z, Size.X)
                    else
                        v1236 = math.max(Size.X, Size.Y)
                    end
                end

                local v1237 = v1236 * 0.5
                v1175 = v1237 + v1174 * 20
                v1237 = nil
                v1236 = 40
                Size = 1
                for i24 = 0, v1236, Size do
                    local v1238 = 6.2831853071795862 * i24 / 40
                    local v1239 = Unit2 * math.cos(v1238)
                    local v1240 = CurrentCamera3:WorldToViewportPoint(Position1 + (v1239 + Unit3 * math.sin(v1238)) * v1175)
                    if v1240.Z <= 0 then
                        v1238 = nil
                    else
                        v1238 = Vector2.new(v1240.X, v1240.Y)
                    end

                    if v1238 then
                        if v1237 then
                            local v1241 = v1238 - v1237
                            local v1242 = v1241:Dot(v1241)
                            local v1243
                            if v1242 <= 0.0001 then
                                v1243 = (a1 - v1237).Magnitude
                            else
                                local v1244 = (a1 - v1237):Dot(v1241) / v1242
                                v1243 = (a1 - (v1237 + v1241 * math.clamp(v1244, 0, 1))).Magnitude
                            end

                            if v1243 <= v1180 then
                                if not v1183 or v1243 < v1183 then
                                    v1183 = v1243
                                    v1240 = {
                                        Mode = "Rotate",
                                        Axis = k153,
                                        AxisLocal = k154,
                                        AxisWorld = Unit1,
                                        Center = Position1
                                    }
                                    v1182 = v1240
                                end
                            end
                        end
                    end

                    v1237 = v1238
                end
            end
        end
    end

    return v1182
end

getBobbing.GetBuildTouchGizmoHit = GetBuildTouchGizmoHit

local function BeginBuildTouchGizmoDrag(a0, a1, a2)
    if a0.TouchEnabled then
        return false
    end

    if not (not a0.BuildTouchGizmo and a0.BuildCameraActive and a0.EditObject and a0.BuildObjectPosition and a2) then
        return false
    end

    local v1245 = a0:GetBuildTouchGizmoHit(a1)
    if not v1245 then
        return false
    end

    a0:EndDirectBuildDrag()
    a0.BuildDragStartPosition = nil
    a0.BuildDragStartRotation = nil
    local v1246 = {
        RawDistance = 0,
        RawAngle = 0,
        Input = a2,
        Mode = v1245.Mode,
        Axis = v1245.Axis,
        AxisLocal = v1245.AxisLocal,
        AxisWorld = v1245.AxisWorld,
        LastScreen = a1,
        StartPosition = a0.BuildObjectPosition,
        StartRotation = a0.BuildObjectRotation or Vector3.new(-90, 90, 0),
        ScreenDirection = v1245.ScreenDirection,
        PixelsPerStud = v1245.PixelsPerStud
    }
    a0.BuildTouchGizmo = v1246
    a0.BuildGizmoDragging = true
    return true
end

getBobbing.BeginBuildTouchGizmoDrag = BeginBuildTouchGizmoDrag

local function UpdateBuildTouchGizmoDrag(a0, a1, a2) --[[ Upvalues: buildRayPlaneIntersection (copy), v799 (copy) ]]
    local BuildTouchGizmo = a0.BuildTouchGizmo
    if not BuildTouchGizmo then
        return
    end

    if BuildTouchGizmo.Input ~= a1 then
        return
    end

    if not (typeof(a2) == "Vector2" and a0.EditObject and a0.BuildObjectPosition) then
        return
    end

    local LastScreen = BuildTouchGizmo.LastScreen
    BuildTouchGizmo.LastScreen = a2
    if not LastScreen then
        return
    end

    local CurrentCamera4 = workspace.CurrentCamera
    if BuildTouchGizmo.Mode == "Move" then
        local v1247 = a0.StorageBase and a0.StorageBase:FindFirstChild("Floor")
        if not v1247 then
            return
        end

        local Unit4 = BuildTouchGizmo.AxisWorld.Unit
        local Unit5 = v1247.CFrame:VectorToObjectSpace(Unit4).Unit
        v1247 = BuildTouchGizmo.ScreenDirection
        local PixelsPerStud = BuildTouchGizmo.PixelsPerStud
        local Position2 = a0:GetBuildObjectCFrame().Position
        local v1248 = CurrentCamera4:WorldToViewportPoint(Position2)
        local v1249
        if v1248.Z <= 0 then
            v1249 = nil
        else
            v1249 = Vector2.new(v1248.X, v1248.Y)
        end

        local v1250 = (Position2 - CurrentCamera4.CFrame.Position):Dot(CurrentCamera4.CFrame.LookVector)
        if v1250 <= 0 then
            v1248 = nil
        else
            local v1251 = math.max(CurrentCamera4.ViewportSize.Y, 1)
            local v1252 = 2 * v1250
            v1248 = v1252 * math.tan(math.rad(CurrentCamera4.FieldOfView) * 0.5) / v1251
        end

        if v1249 and v1248 then
            local v1253 = math.max(v1248 * 48, 0.25)
            local v1254 = CurrentCamera4:WorldToViewportPoint(Position2 + Unit4 * v1253)
            local v1255
            if v1254.Z <= 0 then
                v1255 = nil
            else
                v1255 = Vector2.new(v1254.X, v1254.Y)
            end

            local v1258 = v1255 and v1255 - v1249
            if v1258 and 3 <= v1258.Magnitude then
                v1247 = v1258.Unit
                PixelsPerStud = v1258.Magnitude / v1253
                BuildTouchGizmo.ScreenDirection = v1247
                BuildTouchGizmo.PixelsPerStud = PixelsPerStud
            end
        end

        if typeof(v1247) ~= "Vector2" or not PixelsPerStud or PixelsPerStud <= 0.0001 then
            return
        end

        BuildTouchGizmo.RawDistance = BuildTouchGizmo.RawDistance + (a2 - LastScreen):Dot(v1247) / PixelsPerStud
        local RawDistance = BuildTouchGizmo.RawDistance
        local v1259 = a0.BuildMoveStep or 0.5
        if not v1259 or v1259 <= 0 then
            local v1260 = RawDistance
            -- jump to 225 (out of range)
        end

        local v1261 = math.round(RawDistance / v1259) * v1259
        a0.BuildObjectPosition = a0:GetClampedBuildPosition(BuildTouchGizmo.StartPosition + Unit5 * v1261, a0.BuildObjectRotation)
    else
        local Position3 = a0:GetBuildObjectCFrame().Position
        local v1262 = buildRayPlaneIntersection(CurrentCamera4, LastScreen, Position3, BuildTouchGizmo.AxisWorld)
        local v1263 = buildRayPlaneIntersection(CurrentCamera4, a2, Position3, BuildTouchGizmo.AxisWorld)
        if not (v1262 and v1263) then
            return
        end

        local v1264 = v1262 - Position3
        v1262 = v1263 - Position3
        if v1264.Magnitude < 0.001 or v1262.Magnitude < 0.001 then
            return
        end

        v1264 = v1264.Unit
        v1262 = v1262.Unit
        local v1265 = v1264:Cross(v1262)
        v1263 = BuildTouchGizmo.AxisWorld:Dot(v1265)
        local v1266 = v1264:Dot(v1262)
        Position3 = math.clamp(v1266, -1, 1)
        BuildTouchGizmo.RawAngle = BuildTouchGizmo.RawAngle + math.atan2(v1263, Position3)
        local v1267 = math.deg(BuildTouchGizmo.RawAngle)
        local v1268 = a0.BuildRotateStep or 15
        if not v1268 or v1268 <= 0 then
            v1264 = v1267
            -- jump to 336 (out of range)
        end

        v1264 = math.round(v1267 / v1268) * v1268
        v1268 = BuildTouchGizmo.StartRotation
        v1263 = v799[BuildTouchGizmo.Axis]
        if not v1263 then
            v1267 = v1268
        else
            local v1269 = v1268 or Vector3.new(-90, 90, 0)
            local v1270 = math.rad(v1269.X)
            local v1271 = math.rad(v1269.Y)
            local v1272 = CFrame.Angles(v1270, v1271, math.rad(v1269.Z))
            local v1273, v1274, v1275 = (v1272 * CFrame.fromAxisAngle(v1263, math.rad(v1264))):ToEulerAnglesXYZ()
            local v1276 = math.deg(v1273)
            local v1277 = math.deg(v1274)
            v1267 = Vector3.new(v1276, v1277, math.deg(v1275))
        end

        a0.BuildObjectRotation = v1267
        a0:ClampBuildObjectToBounds()
    end

    local v1278 = a0:GetBuildObjectCFrame()
    a0.EditObject:PivotTo(v1278)
    local v1279 = a0:GetBuildObjectCFrame()
    a0:UpdateBuildGizmo(v1279)
    a0.BuildTransformDirty = true
end

getBobbing.UpdateBuildTouchGizmoDrag = UpdateBuildTouchGizmoDrag

local function EndBuildTouchGizmoDrag(a0, a1)
    local BuildTouchGizmo1 = a0.BuildTouchGizmo
    if not BuildTouchGizmo1 then
        return false
    end

    if a1 then
        if BuildTouchGizmo1.Input ~= a1 then
            return false
        end
    end

    a0.BuildTouchGizmo = nil
    a0.BuildGizmoDragging = nil
    return true
end

getBobbing.EndBuildTouchGizmoDrag = EndBuildTouchGizmoDrag

local function SetBuildView(a0, a1)
    if not a0.BuildCameraActive then
        return
    end

    local v1280, v1281 = a0:GetBuildReference()
    if not (v1280 and v1281) then
        return
    end

    a0.BuildViewPreset = a1
    a0.BuildFocus = v1281.Position
    a0.BuildDistance = math.max(v1281.Size.X, v1281.Size.Y, v1281.Size.Z) * 1.15
    if a1 == "Top" then
        a0.BuildCameraYaw = 0
        a0.BuildCameraPitch = -1.5533430342749532
    else
        if a1 == "Front" then
            a0.BuildCameraYaw = 3.1415926535897931
            a0.BuildCameraPitch = 0
        else
            if a1 == "Back" then
                a0.BuildCameraYaw = 0
                a0.BuildCameraPitch = 0
            else
                if a1 == "Left" then
                    a0.BuildCameraYaw = -1.5707963267948966
                    a0.BuildCameraPitch = 0
                else
                    if a1 == "Right" then
                        a0.BuildCameraYaw = 1.5707963267948966
                        a0.BuildCameraPitch = 0
                    else
                        a0.BuildCameraYaw = -0.69813170079773179
                        a0.BuildCameraPitch = -0.55850536063818546
                    end
                end
            end
        end
    end

    a0.BuildCameraPosition = a0:ClampBuildCameraPosition(a0.BuildFocus + (v1280.CFrame.Rotation * CFrame.fromEulerAnglesYXZ(a0.BuildCameraPitch, a0.BuildCameraYaw, 0)):VectorToWorldSpace(Vector3.new(0, 0, a0.BuildDistance)))
end

getBobbing.SetBuildView = SetBuildView

local function PanBuildCameraPixels(a0, a1)
    if a0.BuildCameraLocked then
        return
    end

    local CurrentCamera5 = workspace.CurrentCamera
    local v1282 = a0.BuildDistance or 20
    local v1283 = -CurrentCamera5.CFrame.RightVector
    local v1284 = v1283 * a1.X
    local v1285 = (v1284 + CurrentCamera5.CFrame.UpVector * a1.Y) * (math.max(v1282, 5) * 0.0022)
    local v1286 = a0.BuildCameraPosition or CurrentCamera5.CFrame.Position
    CurrentCamera5 = a0:ClampBuildCameraPosition(v1286 + v1285)
    a0.BuildCameraPosition = CurrentCamera5
    a0.BuildFocus = a0.BuildFocus + (CurrentCamera5 - v1286)
end

getBobbing.PanBuildCameraPixels = PanBuildCameraPixels

local function UpdateBuildCameraCFrame(a0)
    if not a0.BuildCameraActive then
        return
    end

    local v1287, v1288 = a0:GetBuildReference()
    if not (v1287 and v1288) then
        return
    end

    local v1289 = a0.BuildCameraPitch or -0.55850536063818546
    local v1290 = a0.BuildCameraYaw or -0.69813170079773179
    local v1291 = v1287.CFrame.Rotation * CFrame.fromEulerAnglesYXZ(v1289, v1290, 0)
    local CurrentCamera6 = workspace.CurrentCamera
    local BuildCameraPosition1 = a0.BuildCameraPosition
    if not BuildCameraPosition1 then
        BuildCameraPosition1 = a0.BuildFocus + v1291:VectorToWorldSpace(Vector3.new(0, 0, a0.BuildDistance))
    end

    BuildCameraPosition1 = a0:ClampBuildCameraPosition(BuildCameraPosition1)
    a0.BuildCameraPosition = BuildCameraPosition1
    CurrentCamera6.CameraType = Enum.CameraType.Scriptable
    CurrentCamera6.CFrame = CFrame.new(BuildCameraPosition1) * v1291
    a0.BuildFocus = BuildCameraPosition1 + CurrentCamera6.CFrame.LookVector * a0.BuildDistance
end

getBobbing.UpdateBuildCameraCFrame = UpdateBuildCameraCFrame

local function findBuildMobileCameraControls(a0)
    if not a0 then
        return nil
    end

    local v1292 = a0:FindFirstChild("MobileCameraContols") or a0:FindFirstChild("MobileCameraControls")
    return v1292
end

local function UpdateBuildViewPanel(a0) --[[ Upvalues: v791 (copy) ]]
    local BuildGui3 = a0.BuildGui
    local v1294 = BuildGui3 and BuildGui3:FindFirstChild("ViewPanel")
    if not v1294 then
        return
    end

    BuildGui3 = v1294:FindFirstChild("Title")
    local Views = v1294:FindFirstChild("Views")
    local v1295 = v1294:FindFirstChildOfClass("UIStroke")
    local CollapseButton1 = v1294:FindFirstChild("CollapseButton")
    local BuildViewPanelExpandedState = a0.BuildViewPanelExpandedState
    if not BuildViewPanelExpandedState or BuildViewPanelExpandedState.Panel ~= v1294 then
        local v1296 = {Panel = v1294, BackgroundTransparency = v1294.BackgroundTransparency}
        local v1298 = v1295 and v1295.Enabled
        v1296.StrokeEnabled = v1298
        local v1299 = BuildGui3 and BuildGui3.Visible
        v1296.TitleVisible = v1299
        local v1300 = Views and Views.Visible
        v1296.ViewsVisible = v1300
        BuildViewPanelExpandedState = v1296
        a0.BuildViewPanelExpandedState = BuildViewPanelExpandedState
    end

    local v1301 = a0.BuildViewPanelCollapsed == true
    local v1302
    if v1301 then
        v1302 = 1
    else
        v1302 = BuildViewPanelExpandedState.BackgroundTransparency
    end

    v1294.BackgroundTransparency = v1302
    if v1295 then
        local v1303 = not v1301 and BuildViewPanelExpandedState.StrokeEnabled
        v1295.Enabled = v1303
    end

    if BuildGui3 then
        local v1304 = not v1301 and BuildViewPanelExpandedState.TitleVisible
        BuildGui3.Visible = v1304
    end

    if Views then
        local v1305 = not v1301 and BuildViewPanelExpandedState.ViewsVisible
        Views.Visible = v1305
    end

    if CollapseButton1 then
        if CollapseButton1:IsA("GuiButton") then
            local v1306
            if v1301 then
                v1306 = "<"
            else
                v1306 = ">"
            end

            CollapseButton1.Text = v1306
            CollapseButton1.BackgroundColor3 = v791
            CollapseButton1.BackgroundTransparency = 0.5
            CollapseButton1.BorderColor3 = Color3.new(1, 1, 1)
            local v1307
            if v1301 then
                v1307 = 3
            else
                v1307 = 1
            end

            CollapseButton1.BorderSizePixel = v1307
            if CollapseButton1:IsA("TextButton") then
                CollapseButton1.TextColor3 = Color3.new(1, 1, 1)
            end

            CollapseButton1:SetAttribute("Collapsed", v1301)
        end
    end

    v1294:SetAttribute("Collapsed", v1301)
end

getBobbing.UpdateBuildViewPanel = UpdateBuildViewPanel

local function ToggleBuildViewPanel(a0)
    a0.BuildViewPanelCollapsed = not a0.BuildViewPanelCollapsed
    a0:UpdateBuildViewPanel()
end

getBobbing.ToggleBuildViewPanel = ToggleBuildViewPanel

local function UpdateBuildMobileCameraControlsVisibility(a0, a1)
    local BuildGui4 = a0.BuildGui
    local v1308
    if not BuildGui4 then
        v1308 = nil
    else
        local v1309 = BuildGui4:FindFirstChild("MobileCameraContols") or BuildGui4:FindFirstChild("MobileCameraControls")
    end

    if not v1308 then
        return
    end

    BuildGui4 = false
    if a1 == true then
        BuildGui4 = false
        if a0.BuildCameraActive == true then
            BuildGui4 = a0.TouchEnabled == true
        end
    end

    v1308.Visible = BuildGui4
end

getBobbing.UpdateBuildMobileCameraControlsVisibility = UpdateBuildMobileCameraControlsVisibility

local function BeginBuildMobileCameraInput(a0, a1, a2, a3) --[[ Upvalues: v791 (copy) ]]
    if not a0.BuildCameraActive or a0.BuildCameraLocked then
        return
    end

    a0:EndBuildMobileCameraInput(a1)
    local BuildMobileCameraInputs = a0.BuildMobileCameraInputs
    if not BuildMobileCameraInputs then
        BuildMobileCameraInputs = {}
    end

    a0.BuildMobileCameraInputs = BuildMobileCameraInputs
    local v1310 = {Button = a2, Direction = a3}
    a0.BuildMobileCameraInputs[a1] = v1310
    if a2 and a2.Parent then
        a2.BackgroundColor3 = v791
        a2.BackgroundTransparency = 0.5
        a2.BorderColor3 = Color3.new(1, 1, 1)
        a2.BorderSizePixel = 3
        if a2:IsA("TextButton") then
            a2.TextColor3 = Color3.new(1, 1, 1)
        end
    end

    a0.BuildViewPreset = nil
end

getBobbing.BeginBuildMobileCameraInput = BeginBuildMobileCameraInput

local function EndBuildMobileCameraInput(a0, a1) --[[ Upvalues: v791 (copy) ]]
    local BuildMobileCameraInputs1 = a0.BuildMobileCameraInputs
    local v1313 = BuildMobileCameraInputs1 and BuildMobileCameraInputs1[a1]
    if not v1313 then
        return
    end

    BuildMobileCameraInputs1[a1] = nil
    local Button = v1313.Button
    if Button and Button.Parent then
        v1313 = false
        for k155, k156 in pairs(BuildMobileCameraInputs1) do
            if k156.Button == Button then
                v1313 = true
                break
            end
        end

        if not v1313 then
            Button.BackgroundColor3 = v791
            Button.BackgroundTransparency = 0.5
            Button.BorderColor3 = Color3.new(1, 1, 1)
            Button.BorderSizePixel = 1
            if Button:IsA("TextButton") then
                Button.TextColor3 = Color3.new(1, 1, 1)
            end
        end
    end
end

getBobbing.EndBuildMobileCameraInput = EndBuildMobileCameraInput

local function ClearBuildMobileCameraInputs(a0) --[[ Upvalues: v791 (copy) ]]
    local BuildMobileCameraInputs2 = a0.BuildMobileCameraInputs
    if BuildMobileCameraInputs2 then
        for k157, k158 in pairs(BuildMobileCameraInputs2) do
            local Button1 = k158.Button
            if Button1 and Button1.Parent then
                Button1.BackgroundColor3 = v791
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

getBobbing.ClearBuildMobileCameraInputs = ClearBuildMobileCameraInputs

local function StepBuildCamera(a0, a1) --[[ Upvalues: GuiService (copy), UserInputService (copy), GamepadService (copy) ]]
    if a0.ModernMobile and a0.ModernMobile:StepCamera(a1) then
        return
    end

    if a0.ModernController and a0.ModernController:StepCamera(a1) then
        return
    end

    if not a0.BuildCameraActive or a0.DeleteAllConfirmOpen or a0.PaintResetConfirmOpen or GuiService.MenuIsOpen then
        return
    end

    local v1320, v1321 = a0:GetBuildReference()
    if not (v1320 and v1321) then
        return
    end

    local BuildPendingGamepadGrab = a0.BuildPendingGamepadGrab
    local v1322
    if BuildPendingGamepadGrab then
        a0.BuildPendingGamepadGrab = nil
        local Input = BuildPendingGamepadGrab.Input
        local v1324 = Input and Input.UserInputState
        local BuildGizmoDragging = a0.BuildGizmoDragging
        if BuildGizmoDragging then
            local v1325 = os.clock() - (a0.BuildGizmoActivatedAt or 0)
            BuildGizmoDragging = v1325 < 0.15
        end

        local BuildTransformHolds2 = a0.BuildTransformHolds
        if BuildTransformHolds2 then
            BuildTransformHolds2 = next(a0.BuildTransformHolds) ~= nil
        end

        if Input and v1324 ~= Enum.UserInputState.End and v1324 ~= Enum.UserInputState.Cancel and not BuildGizmoDragging and not BuildTransformHolds2 and not a0.Painting then
            v1322 = Input.UserInputType
            a0:ActivateBuildObjectAt(BuildPendingGamepadGrab.Position, v1322, Input)
        end
    end

    if a0.BuildDirectGamepad then
        local CurrentCamera7 = workspace.CurrentCamera
        local v1327
        if not (a0.BuildGamepadNavigation and UserInputService:GetMouseLocation()) then
            v1327 = CurrentCamera7.ViewportSize / 2
        end

        a0.BuildDirectLastScreen = v1327
    end

    if a0.BuildCameraLocked then
        a0:UpdateBuildCameraCFrame()
        if a0.BuildModeKind ~= "Paint" then
            a0:UpdateBuildGridSurface()
        end

        if a0.BuildModeKind ~= "Paint" then
            if a0.BuildDirectLastScreen then
                if a0.BuildDirectMouse or a0.BuildDirectTouch or a0.BuildDirectGamepad then
                    a0:UpdateDirectBuildDrag(a0.BuildDirectLastScreen)
                end
            end
        end

        return
    end

    local CurrentCamera8 = workspace.CurrentCamera
    local v1328 = math.max(v1321.Size.X, v1321.Size.Y, v1321.Size.Z)
    v1321 = Vector3.new()
    if not UserInputService:GetFocusedTextBox() then
    end

    local v1329 = UserInputService:GetConnectedGamepads()
    if 0 < #v1329 and not a0.BuildGamepadNavigation and not GamepadService.GamepadCursorEnabled then
        local v1330 = UserInputService:GetGamepadState(v1329[1])
        for k159, k160 in ipairs(v1330) do
            if k160.KeyCode == Enum.KeyCode.Thumbstick1 then
                local Position5 = k160.Position
                local v1334 = math.abs(Position5.X)
                if 0.15 < v1334 then
                    v1321 = v1321 + Vector3.new(Position5.X, 0, 0)
                end

                local v1335 = math.abs(Position5.Y)
                if 0.15 < v1335 then
                    v1321 = v1321 + Vector3.new(0, 0, -Position5.Y)
                    -- branch continues at 401
                end
            else
                if k160.KeyCode == Enum.KeyCode.Thumbstick2 then
                    local Position6 = k160.Position
                    local v1336 = math.abs(Position6.X)
                    if 0.15 >= v1336 then
                        local v1337 = math.abs(Position6.Y)
                        if 0.15 >= v1337 then
                            -- jump to 359
                        end
                    end

                    a0.BuildViewPreset = nil
                    local v1338 = math.abs(Position6.X)
                    if 0.15 < v1338 then
                        a0.BuildCameraYaw = a0.BuildCameraYaw - Position6.X * 2.2 * a1
                    end

                    local v1339 = math.abs(Position6.Y)
                    if 0.15 < v1339 then
                        local v1340 = a0.BuildCameraPitch + Position6.Y * 2.2 * a1
                        a0.BuildCameraPitch = math.clamp(v1340, -1.5533430342749532, 1.3089969389957472)
                    end
                end
            end
        end

        if UserInputService:IsGamepadButtonDown(v1329[1], Enum.KeyCode.ButtonR1) then
            local v1341 = a0.BuildCameraPosition or CurrentCamera8.CFrame.Position
            k160 = CurrentCamera8.CFrame.LookVector * v1328
            a0.BuildCameraPosition = v1341 + k160 * 0.8 * a1
        end

        if UserInputService:IsGamepadButtonDown(v1329[1], Enum.KeyCode.ButtonL1) then
            local v1342 = a0.BuildCameraPosition or CurrentCamera8.CFrame.Position
            k160 = CurrentCamera8.CFrame.LookVector * v1328
            a0.BuildCameraPosition = v1342 - k160 * 0.8 * a1
        end
    end

    if a0.BuildMobileCameraInputs then
        for k161, k162 in pairs(a0.BuildMobileCameraInputs) do
            v1321 = v1321 + k162.Direction
        end
    end

    if 0 < v1321.Magnitude then
        local v1347 = a0.BuildCameraPosition or CurrentCamera8.CFrame.Position
        local v1348 = CurrentCamera8.CFrame.RightVector * (1 < v1321.Magnitude and v1321.Unit or v1321).X
        local v1349 = v1348 + v1320.CFrame.UpVector * (1 < v1321.Magnitude and v1321.Unit or v1321).Y
        a0.BuildCameraPosition = v1347 + (v1349 + CurrentCamera8.CFrame.LookVector * -(1 < v1321.Magnitude and v1321.Unit or v1321).Z) * (v1328 * 0.45) * a1
    end

    a0.BuildDistance = math.clamp(a0.BuildDistance, 4, v1328 * 3)
    local v1350 = a0.BuildCameraPosition or CurrentCamera8.CFrame.Position
    a0.BuildCameraPosition = a0:ClampBuildCameraPosition(v1350)
    a0:UpdateBuildCameraCFrame()
    if a0.BuildModeKind ~= "Paint" then
        a0:UpdateBuildGridSurface()
    end

    if a0.BuildModeKind ~= "Paint" then
        if a0.BuildDirectLastScreen then
            if a0.BuildDirectMouse or a0.BuildDirectTouch or a0.BuildDirectGamepad then
                a0:UpdateDirectBuildDrag(a0.BuildDirectLastScreen)
            end
        end
    end
end

getBobbing.StepBuildCamera = StepBuildCamera

local function GetBuildPointerRay(a0, a1) --[[ Upvalues: UserInputService (copy) ]]
    if a0.ClassicBuildActive and UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse then
        return a0.Mouse.UnitRay
    end

    if a0.ClassicMobile and a0.ClassicMobile:IsActive() then
        local v1351 = a0.ClassicMobile:GetRay()
        return v1351
    end

    if a0.ClassicBuildActive then
        if a0.TouchEnabled then
            if not (a0.ClassicController and a0.ClassicController:IsGamepad()) then
                local MobileMouse = a0.HUD.MobileMouse
                local v1352 = MobileMouse.AbsolutePosition + MobileMouse.AbsoluteSize / 2
                local v1353 = workspace.CurrentCamera:ScreenPointToRay(v1352.X, v1352.Y)
                return v1353
            end
        end
    end

    local v1354 = workspace.CurrentCamera:ViewportPointToRay(a1.X, a1.Y)
    return v1354
end

getBobbing.GetBuildPointerRay = GetBuildPointerRay

local function raycastBuildBoxSurface(a0, a1, a2, a3)
    local v1355 = a1:PointToObjectSpace(a0.Origin)
    local v1356 = a1:VectorToObjectSpace(a0.Direction)
    local v1357 = a2 / 2
    local v1358 = {v1355.X, v1355.Y, v1355.Z}
    v1355 = {v1356.X, v1356.Y, v1356.Z}
    v1356 = {v1357.X, v1357.Y, v1357.Z}
    v1357 = {Vector3.new(1, 0, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, 1)}
    local v1359 = -math.huge
    local v1360 = math.huge
    local v1361 = nil
    local v1362 = nil
    for i25 = 1, 3 do
        local v1365 = v1358[i25]
        local v1366 = v1355[i25]
        local v1367 = v1356[i25]
        local v1368 = math.abs(v1366)
        if v1368 < 1e-06 then
            if v1367 < math.abs(v1365) then
                return nil
                -- branch continues at 107
            end
        else
            v1368 = (-v1367 - v1365) / v1366
            local v1369 = (v1367 - v1365) / v1366
            local v1370 = -v1357[i25]
            local v1371
            if v1369 < v1368 then
                local v1372 = v1369
                v1369 = v1368
                v1368 = v1372
                v1372 = v1371
                v1371 = v1370
                v1370 = v1372
            end

            if v1359 < v1368 then
                v1359 = v1368
                v1361 = v1370
            end

            if v1369 < v1360 then
                v1360 = v1369
                v1362 = v1371
            end

            if v1360 < v1359 then
                return nil
            end
        end
    end

    if v1360 < 0 then
        return nil
    end

    v1358 = v1359 < 0
    if not (v1358 and v1362 or v1361) or 4096 < (v1358 and v1360 or v1359) then
        return nil
    end

    local v1375 = {
        Position = a0.Origin + a0.Direction * (v1358 and v1360 or v1359),
        Normal = a1:VectorToWorldSpace(v1358 and v1362 or v1361).Unit,
        Instance = a3,
        Distance = v1358 and v1360 or v1359,
        StartedInside = v1358
    }
    return v1375
end

local function GetPlacedBuildObjectsContainer(a0)
    local v1376 = a0.StorageBase and a0.StorageBase:FindFirstChild("Contents")
    local v1378 = v1376 and v1376:FindFirstChild("Objects")
    return v1378
end

getBobbing.GetPlacedBuildObjectsContainer = GetPlacedBuildObjectsContainer

local function ResolvePlacedBuildObject(a0, a1) --[[ Upvalues: v6 (copy) ]]
    local v1379 = a0:GetPlacedBuildObjectsContainer()
    if not (v1379 and a1 and a1:IsDescendantOf(v1379)) then
        return nil
    end

    local v1380 = a1
    while v1380 do
        if v1380.Parent == v1379 then
            break
        end

        v1380 = v1380.Parent
    end

    if v1380 and v1380:IsA("Model") and v6[v1380.Name] then
        return v1380
    end

    return nil
end

getBobbing.ResolvePlacedBuildObject = ResolvePlacedBuildObject

local function GetPlacedBuildObjectAtScreenPosition(a0, a1) --[[ Upvalues: v6 (copy), raycastBuildBoxSurface (copy) ]]
    local v1381 = a0:GetPlacedBuildObjectsContainer()
    if not v1381 then
        return nil
    end

    if typeof(a1) ~= "Vector2" then
        return nil
    end

    local v1382 = a0:GetBuildPointerRay(a1)
    local v1383 = false
    if a0.ClassicBuildActive == true then
        v1383 = not a0.Painting
    end

    local function visibleObject(a0, a1) --[[ Upvalues: v1383 (copy), a0 (copy), v1382 (copy) ]]
        if not (a0 and v1383) then
            return a0
        end

        if not a1 or 500 < a1 then
            return nil
        end

        local v1384 = {workspace.CurrentCamera}
        if a0.Character then
            table.insert(v1384, a0.Character)
        end

        if a0.EditObject then
            table.insert(v1384, a0.EditObject)
        end

        local v1385 = RaycastParams.new()
        v1385.FilterType = Enum.RaycastFilterType.Exclude
        v1385.IgnoreWater = true
        for i26 = 1, 32 do
            v1385.FilterDescendantsInstances = v1384
            local v1388 = v1382.Direction * math.max(0, a1 - 0.03)
            local v1389 = workspace:Raycast(v1382.Origin, v1388, v1385)
            if not v1389 then
                return a0
            end

            local Instance = v1389.Instance
            if Instance:IsA("BasePart") then
                if 1 > Instance.Transparency then
                    if 1 > Instance.LocalTransparencyModifier then
                        -- jump to 110
                    end
                end

                table.insert(v1384, Instance)
            else
                if Instance:IsDescendantOf(a0) then
                    return a0
                end

                return nil
            end
        end

        return nil
    end

    local v1390 = RaycastParams.new()
    v1390.FilterType = Enum.RaycastFilterType.Include
    local v1391 = {v1381}
    v1390.FilterDescendantsInstances = v1391
    if v1383 then
        v1391 = {}
        local v1392 = v1381:GetDescendants()
        for k163, k164 in ipairs(v1392) do
            if k164:IsA("BasePart") and k164.CanQuery and k164.Transparency < 1 and k164.LocalTransparencyModifier < 1 then
                table.insert(v1391, k164)
            end
        end

        v1390.FilterDescendantsInstances = v1391
    end

    local v1396 = v1382.Direction * 4096
    local v1397 = workspace:Raycast(v1382.Origin, v1396, v1390)
    local v1398 = v1397 and v1397.Instance
    local v1399 = v1398
    if v1399 then
        local v1401 = v1398:IsA("BasePart")
        if v1401 then
            v1401 = false
            if v1398.Transparency < 1 then
                v1401 = false
                if v1398.LocalTransparencyModifier < 1 then
                    local v1402 = a0:ResolvePlacedBuildObject(v1398)
                end
            end
        end
    end

    if v1399 and not v1383 then
        return v1399
    end

    local v1403 = v1399 or nil
    local v1405 = v1381:GetChildren()
    local v1409
    for k165, k166 in ipairs(v1405) do
        if k166:IsA("Model") then
            if v6[k166.Name] then
                local v1414, v1415 = k166:GetBoundingBox()
                v1399 = raycastBuildBoxSurface(v1382, v1414, v1415, k166)
                if v1399 then
                    local v1416 = nil
                    v1415 = false
                    local v1417 = k166:GetDescendants()
                    for k167, k168 in ipairs(v1417) do
                        if k168:IsA("BasePart") then
                            if k168.Transparency < 1 then
                                if k168.LocalTransparencyModifier < 1 then
                                    v1415 = true
                                    if not (v1383 and k168.CanQuery) then
                                        v1414 = raycastBuildBoxSurface(v1382, k168.CFrame, k168.Size, k168)
                                        if v1414 then
                                            if not v1416 or v1414.Distance < v1416 then
                                                v1416 = v1414.Distance
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    if not v1415 and not v1383 then
                        v1416 = v1399.Distance
                    end

                    if v1416 then
                        if not v1409 or v1416 < v1409 then
                            v1403 = k166
                            v1409 = v1416
                        end
                    end
                end
            end
        end
    end

    return visibleObject(v1403, v1409)
end

getBobbing.GetPlacedBuildObjectAtScreenPosition = GetPlacedBuildObjectAtScreenPosition

local function ClearBuildObjectHover(a0)
    a0.ObjectHover = nil
    if a0.HighlightHover then
        a0.HighlightHover.Adornee = nil
        a0.HighlightHover.Parent = nil
    end
end

getBobbing.ClearBuildObjectHover = ClearBuildObjectHover

local function UpdateBuildObjectHover(a0, a1, a2)
    if not (not a0.EditObject and not a0.Painting and a0.EditingBase and a0.BuildCameraActive) then
        a0:ClearBuildObjectHover()
        return nil
    end

    local v1421 = os.clock()
    if not a2 then
        if v1421 < (a0.BuildHoverNext or 0) then
            return a0.ObjectHover
        end
    end

    a0.BuildHoverNext = v1421 + 0.06
    v1421 = a0.ClassicMobile
    local v1424 = v1421 and v1421:IsActive() and a0.DeletingObjects and v1421.DeleteStarted and v1421.DeleteTarget
    local v1425
    if v1424 then
        v1425 = a0:ResolvePlacedBuildObject(v1424)
    else
        v1425 = a0:GetPlacedBuildObjectAtScreenPosition(a1)
    end

    a0.ObjectHover = v1425
    if not v1425 then
        a0:ClearBuildObjectHover()
        return nil
    end

    v1424 = a0.DeletingObjects == true
    local HighlightHover = a0.HighlightHover
    local v1427
    if not (v1424 and Color3.fromRGB(255, 105, 105)) then
        local v1428 = Color3.fromRGB(42, 170, 255)
    end

    HighlightHover.FillColor = v1427
    HighlightHover = a0.HighlightHover
    local v1430
    if not (v1424 and Color3.fromRGB(255, 162, 162)) then
        local v1431 = Color3.fromRGB(135, 218, 255)
    end

    HighlightHover.OutlineColor = v1430
    if v1424 then
        v1430 = 0.62
    else
        v1430 = 0.82
    end

    a0.HighlightHover.FillTransparency = v1430
    a0.HighlightHover.OutlineTransparency = 0
    a0.HighlightHover.DepthMode = Enum.HighlightDepthMode.Occluded
    a0.HighlightHover.Adornee = v1425
    a0.HighlightHover.Parent = workspace.CurrentCamera
    return v1425
end

getBobbing.UpdateBuildObjectHover = UpdateBuildObjectHover

local function SelectPlacedBuildObject(a0, a1) --[[ Upvalues: v6 (copy) ]]
    a1 = a0:ResolvePlacedBuildObject(a1)
    if not a1 then
        return false
    end

    local v1432 = a0.StorageBase and a0.StorageBase:FindFirstChild("Floor")
    if not v1432 then
        return false
    end

    local v1433 = v6[a1.Name]
    if not v1433 then
        return false
    end

    a0:DeleteEditObject()
    local v1434 = a1:Clone()
    if not v1434 then
        return false
    end

    local v1435 = v1434:GetDescendants()
    for k169, k170 in ipairs(v1435) do
        if k170:IsA("Highlight") then
            k170:Destroy()
        else
            if k170:IsA("BasePart") then
                k170:SetAttribute("BuildWasCollidable", k170.CanCollide)
                k170.CanCollide = false
                k170.CanTouch = false
                k170.CanQuery = true
            end
        end
    end

    a0.DeletingObjects = false
    a0.CurrentFrame = nil
    a0.ObjectType = v1433.Type
    a0.EditingExistingObject = a1
    a0.EditExistingOriginalTransparency = {}
    local v1439 = a1:GetDescendants()
    for k171, k172 in ipairs(v1439) do
        if k172:IsA("BasePart") then
            a0.EditExistingOriginalTransparency[k172] = k172.LocalTransparencyModifier
            k172.LocalTransparencyModifier = 1
        end
    end

    a0.EditObject = v1434
    a0.EditObject.Name = a1.Name
    a0.EditObjectRotate = 0
    a0.EditObjectFlip = 0
    a0.EditObjectFlip2 = 0
    a0.breathingNum = Vector3.new(0, 0, 0)
    local Highlight = Instance.new("Highlight")
    Highlight.Name = "BuildHighlight"
    Highlight.FillTransparency = 0.5
    Highlight.FillColor = Color3.fromRGB(255, 226, 137)
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.OutlineColor = Color3.fromRGB(255, 228, 120)
    Highlight.OutlineTransparency = 0
    Highlight.Parent = a0.EditObject
    a0.EditObject.Parent = workspace.CurrentCamera
    if a0.ClassicBuildActive then
        local v1443, v1444, v1445 = a0:CalcStorageFloor().Rotation:ToObjectSpace(a1:GetPivot().Rotation):ToEulerAnglesXYZ()
        a0.EditObjectFlip2 = math.deg(v1443) + 90
        a0.EditObjectRotate = math.deg(v1444)
        a0.EditObjectFlip = math.deg(v1445)
        a0.BuildObjectPosition = nil
        a0.BuildObjectRotation = nil
        a0.Mouse.TargetFilter = a0.EditObject
        a0:ClearBuildObjectHover()
        a0:HideBuildGizmos()
        if a0.ClassicController then
            a0.ClassicController:NotifySelected(a1.Name, v1433.Type)
        end

        if a0.ClassicMobile then
            a0.ClassicMobile:NotifySelected(a1.Name, v1433.Type)
        end

        a0:RememberModernDesktopObject(a1.Name)
        a0:UpdateBuildGui()
        return true
    end

    local v1446 = a1:GetPivot()
    local v1447 = v1432.CFrame:ToObjectSpace(v1446)
    local v1448, v1449, v1450 = v1447:ToEulerAnglesXYZ()
    a0.BuildObjectPosition = v1447.Position
    local v1451 = math.deg(v1448)
    local v1452 = math.deg(v1449)
    a0.BuildObjectRotation = Vector3.new(v1451, v1452, math.deg(v1450))
    a0:ClampBuildObjectToBounds()
    a0.BuildTransformDirty = true
    local v1453 = a0:GetBuildObjectCFrame()
    a0.EditObject:PivotTo(v1453)
    a0.Mouse.TargetFilter = a0.EditObject
    a0:ClearBuildObjectHover()
    local v1454 = a0:GetBuildObjectCFrame()
    a0:UpdateBuildGizmo(v1454)
    a0:RefreshBuildValidation(true)
    if a0.ModernController then
        a0.ModernController:NotifySelected(a1.Name, v1433.Type)
    end

    if a0.ModernMobile then
        a0.ModernMobile:NotifySelected(a1.Name, v1433.Type)
    end

    a0:RememberModernDesktopObject(a1.Name)
    a0:UpdateBuildGui()
    return true
end

getBobbing.SelectPlacedBuildObject = SelectPlacedBuildObject

local function ActivateBuildObjectAt(a0, a1, a2, a3) --[[ Upvalues: RemoteEvent (copy) ]]
    if a0.EditObject then
        local v1455 = a0:BeginDirectBuildDrag(a1, a2, a3)
        return v1455
    end

    local v1456 = a0:UpdateBuildObjectHover(a1, true)
    if not v1456 then
        return false
    end

    if a0.DeletingObjects then
        if a0.ModernDesktop then
            if a0.ModernDesktop:IsActive() then
                local v1457 = a0.ModernDesktop:Delete(v1456)
                if not v1457 then
                    return false
                end

                if not v1457.queued then
                    if not v1457.ok then
                        return false
                        -- branch continues at 75
                    end

                    -- branch continues at 75
                end

                -- branch continues at 49
            end
        else
            local v1458 = os.clock() - (a0.BuildDeleteAt or 0)
            if v1458 < 0.15 then
                return false
            end

            a0.BuildDeleteAt = os.clock()
            RemoteEvent:FireServer("DeleteBaseObject", v1456)
        end

        a0:ClearBuildObjectHover()
        return true
    end

    local v1459 = a0:SelectPlacedBuildObject(v1456)
    if v1459 and a2 == Enum.UserInputType.Gamepad1 and a3 and a3.KeyCode == Enum.KeyCode.ButtonA then
        a0:BeginDirectBuildDrag(a1, a2, a3)
    end

    return v1459
end

getBobbing.ActivateBuildObjectAt = ActivateBuildObjectAt

local function BuildPointerHitsObject(a0, a1) --[[ Upvalues: raycastBuildBoxSurface (copy) ]]
    if not a0.EditObject then
        return nil
    end

    local v1460 = a0:GetBuildPointerRay(a1)
    local v1461 = nil
    local v1462 = nil
    local v1463 = false
    local v1464 = a0.EditObject:GetDescendants()
    for k173, k174 in ipairs(v1464) do
        if k174:IsA("BasePart") then
            if k174.Transparency < 1 then
                if k174.LocalTransparencyModifier < 1 then
                    v1463 = true
                    local v1468 = raycastBuildBoxSurface(v1460, k174.CFrame, k174.Size, k174)
                    if v1468 then
                        if not v1462 or v1468.Distance < v1462 then
                            v1461 = v1468
                            v1462 = v1468.Distance
                        end
                    end
                end
            end
        end
    end

    if v1461 or v1463 then
        return v1461
    end

    local v1469, v1470 = a0.EditObject:GetBoundingBox()
    return raycastBuildBoxSurface(v1460, v1469, v1470, a0.EditObject)
end

getBobbing.BuildPointerHitsObject = BuildPointerHitsObject

local function GetBuildSurfaceHit(a0, a1) --[[ Upvalues: raycastBuildBoxSurface (copy) ]]
    if not a0.StorageBase then
        return nil
    end

    local v1471 = a0:GetBuildPointerRay(a1)
    local v1472 = {a0.EditObject}
    if a0.EditingExistingObject then
        table.insert(v1472, a0.EditingExistingObject)
    end

    if a0.Character then
        table.insert(v1472, a0.Character)
    end

    if a0.BuildGrid then
        table.insert(v1472, a0.BuildGrid)
    end

    local v1473, v1474 = a0:GetBuildReference()
    if v1474 then
        table.insert(v1472, v1474)
    end

    v1473 = RaycastParams.new()
    v1473.FilterType = Enum.RaycastFilterType.Exclude
    v1473.FilterDescendantsInstances = v1472
    local v1475 = nil
    local v1476 = math.huge
    local Origin = v1471.Origin
    local Direction = v1471.Direction
    local v1477 = 4096
    for i27 = 1, 24 do
        local v1481 = workspace:Raycast(Origin, Direction * v1477, v1473)
        if not v1481 then
            break
        end

        local Instance2 = v1481.Instance
        if Instance2 and Instance2:IsA("BasePart") and Instance2:IsDescendantOf(a0.StorageBase) then
            v1475 = v1481
            v1476 = (v1481.Position - v1471.Origin).Magnitude
            break
        end

        table.insert(v1472, Instance2)
        v1473.FilterDescendantsInstances = v1472
        v1477 = v1477 - ((v1481.Position - Origin).Magnitude + 0.02)
        if v1477 <= 0 then
            break
        end

        Origin = v1481.Position + Direction * 0.02
    end

    if a0.BuildSurfaceParts then
        for k175 in pairs(a0.BuildSurfaceParts) do
            if k175 then
                if k175.Parent then
                    if k175:IsA("BasePart") then
                        if k175.Name == "Wall" then
                            if k175.Transparency < 1 then
                                v1477 = raycastBuildBoxSurface(v1471, k175.CFrame, k175.Size, k175)
                                if v1477 and v1477.Distance < v1476 then
                                    v1475 = v1477
                                    v1476 = v1477.Distance
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if v1474 then
        Direction = raycastBuildBoxSurface(v1471, v1474.CFrame, v1474.Size, v1474)
        if Direction and Direction.Distance < v1476 then
            Direction.Normal = -Direction.Normal
            v1475 = Direction
        end
    end

    return v1475
end

getBobbing.GetBuildSurfaceHit = GetBuildSurfaceHit

local function BeginDirectBuildDrag(a0, a1, a2, a3)
    if not (a0.EditObject and a0.BuildObjectPosition) then
        return false
    end

    a0.BuildGizmoDragging = nil
    a0.BuildDragStartPosition = nil
    a0.BuildDragStartRotation = nil
    local v1485 = a0:BuildPointerHitsObject(a1)
    if not v1485 then
        return false
    end

    local v1486 = a0.StorageBase and a0.StorageBase:FindFirstChild("Floor")
    if not v1486 then
        return false
    end

    local v1487 = a0:GetBuildObjectCFrame()
    a0.EditObject:PivotTo(v1487)
    a0.BuildDirectGrabBoxLocal = a0.EditObject:GetBoundingBox():PointToObjectSpace(v1485.Position)
    a0.BuildDirectLastScreen = a1
    a0.BuildDirectMouse = a2 == Enum.UserInputType.MouseButton1
    a0.BuildDirectTouch = a2 == Enum.UserInputType.Touch and a3 or nil
    a0.BuildDirectGamepad = a3 and a3.KeyCode == Enum.KeyCode.ButtonA and a3 or nil
    return true
end

getBobbing.BeginDirectBuildDrag = BeginDirectBuildDrag

local function UpdateDirectBuildDrag(a0, a1)
    if not (a0.BuildDirectGrabBoxLocal and a0.EditObject) then
        return
    end

    local v1492 = a0.StorageBase and a0.StorageBase:FindFirstChild("Floor")
    if not v1492 then
        return
    end

    local v1493 = a0:GetBuildSurfaceHit(a1)
    if not v1493 then
        return
    end

    local v1494 = a0:GetBuildObjectCFrame()
    a0.EditObject:PivotTo(v1494)
    local v1495, v1496 = a0.EditObject:GetBoundingBox()
    local v1497 = v1496 / 2
    local Unit6 = v1493.Normal.Unit
    local v1498 = v1495:VectorToWorldSpace(a0.BuildDirectGrabBoxLocal)
    local v1499 = v1498 - Unit6 * v1498:Dot(Unit6)
    local v1500 = math.abs(Unit6:Dot(v1495.RightVector))
    local v1501 = v1500 * v1497.X
    local v1502 = math.abs(Unit6:Dot(v1495.UpVector))
    local v1503 = v1501 + v1502 * v1497.Y
    local v1504 = math.abs(Unit6:Dot(v1495.LookVector))
    v1498 = v1503 + v1504 * v1497.Z
    v1497 = v1494.Position - v1495.Position
    local v1505 = v1493.Position - v1499
    local v1506 = v1492.CFrame:PointToObjectSpace(v1505 + Unit6 * (v1498 + 0.02) + v1497)
    v1498 = v1492.CFrame:VectorToObjectSpace(Unit6)
    local v1507 = math.abs(v1498.X)
    local v1508 = math.abs(v1498.Y)
    local v1509 = math.abs(v1498.Z)
    v1498 = a0.BuildMoveStep or 0.5
    if v1508 <= v1507 then
        local v1510, v1511, v1512
        if v1509 <= v1507 then
            v1510 = v1506.X
            v1512 = v1506.Y
            if not v1498 or v1498 <= 0 then
                v1511 = v1512
                -- jump to 172 (out of range)
            end

            v1511 = math.round(v1512 / v1498) * v1498
            local Z1 = v1506.Z
            if not v1498 or v1498 <= 0 then
                v1512 = Z1
                -- jump to 186 (out of range)
            end

            v1512 = math.round(Z1 / v1498) * v1498
            v1506 = Vector3.new(v1510, v1511, v1512)
            -- branch continues at 192
        end
    else
        if v1507 <= v1508 then
            local v1513, v1514
            if v1509 <= v1508 then
                v1514 = v1506.X
                if not v1498 or v1498 <= 0 then
                    v1513 = v1514
                    -- jump to 210 (out of range)
                end

                v1513 = math.round(v1514 / v1498) * v1498
                v1514 = v1506.Y
                local Z2 = v1506.Z
                if not v1498 or v1498 <= 0 then
                    local v1516 = Z2
                    -- jump to 226 (out of range)
                end

                local v1517 = math.round(Z2 / v1498) * v1498
                v1506 = Vector3.new(v1513, v1514, v1517)
                -- branch continues at 232
            end
        else
            local X1 = v1506.X
            if not v1498 or v1498 <= 0 then
                local v1518 = X1
                -- jump to 246 (out of range)
            end

            local v1519 = math.round(X1 / v1498) * v1498
            local Y4 = v1506.Y
            if not v1498 or v1498 <= 0 then
                X1 = Y4
                -- jump to 260 (out of range)
            end

            X1 = math.round(Y4 / v1498) * v1498
            v1506 = Vector3.new(v1519, X1, v1506.Z)
        end
    end

    a0.BuildObjectPosition = a0:GetClampedBuildPosition(v1506, a0.BuildObjectRotation)
    local v1520 = a0:GetBuildObjectCFrame()
    a0.EditObject:PivotTo(v1520)
    a0.BuildDirectLastScreen = a1
    a0.BuildTransformDirty = true
end

getBobbing.UpdateDirectBuildDrag = UpdateDirectBuildDrag

local function EndDirectBuildDrag(a0)
    a0.BuildPendingGamepadGrab = nil
    a0.BuildDirectMouse = nil
    a0.BuildDirectTouch = nil
    a0.BuildDirectGamepad = nil
    a0.BuildDirectGrabBoxLocal = nil
    a0.BuildDirectLastScreen = nil
    a0.BuildDirectLockedAxis = nil
    a0.BuildDirectPlanePoint = nil
    a0.BuildDirectPlaneNormal = nil
    a0.BuildDirectOffset = nil
    a0.BuildDirectStartPosition = nil
end

getBobbing.EndDirectBuildDrag = EndDirectBuildDrag

local function BeginBuildMouseCameraDrag(a0, a1) --[[ Upvalues: UserInputService (copy) ]]
    if not a0.BuildMouseOrbit and not a0.BuildMousePan then
        a0.BuildMouseBehaviorBeforeDrag = UserInputService.MouseBehavior
        a0.BuildMouseIconBeforeDrag = UserInputService.MouseIconEnabled
    end

    if a1 == "Orbit" then
        a0.BuildMouseOrbit = true
    else
        if a1 == "Pan" then
            a0.BuildMousePan = true
        else
            return false
        end
    end

    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
    return true
end

getBobbing.BeginBuildMouseCameraDrag = BeginBuildMouseCameraDrag

local function EndBuildMouseCameraDrag(a0, a1) --[[ Upvalues: UserInputService (copy) ]]
    if a1 == "Orbit" then
        a0.BuildMouseOrbit = nil
    else
        if a1 == "Pan" then
            a0.BuildMousePan = nil
        else
            a0.BuildMouseOrbit = nil
            a0.BuildMousePan = nil
        end
    end

    if a0.BuildMouseOrbit or a0.BuildMousePan then
        return
    end

    local BuildMouseBehaviorBeforeDrag = a0.BuildMouseBehaviorBeforeDrag
    local BuildMouseIconBeforeDrag = a0.BuildMouseIconBeforeDrag
    a0.BuildMouseBehaviorBeforeDrag = nil
    a0.BuildMouseIconBeforeDrag = nil
    if BuildMouseBehaviorBeforeDrag ~= nil then
        UserInputService.MouseBehavior = BuildMouseBehaviorBeforeDrag
    end

    if BuildMouseIconBeforeDrag ~= nil then
        UserInputService.MouseIconEnabled = BuildMouseIconBeforeDrag
    end
end

getBobbing.EndBuildMouseCameraDrag = EndBuildMouseCameraDrag

local function ConnectBuildInputs(a0) --[[ Upvalues: UserInputService (copy), GuiService (copy) ]]
    if a0.BuildInputCons then
        for k176, k177 in ipairs(a0.BuildInputCons) do
            k177:Disconnect()
        end
    end

    a0.BuildInputCons = {}
    a0.BuildTouches = {}
    a0.BuildTouchOrder = {}
    a0.BuildPendingTouchSelection = nil

    local function connect1(a0, a1) --[[ Upvalues: a0 (copy) ]]
        local v1524 = a0:Connect(a1)
        table.insert(a0.BuildInputCons, v1524)
    end

    local v1525 = UserInputService:GetPropertyChangedSignal("PreferredInput")
    local v1526 = v1525:Connect(function() --[[ Upvalues: a0 (copy) ]]
        if a0.BuildCameraActive then
            a0:UpdateBuildGui()
        end

    end)
    table.insert(a0.BuildInputCons, v1526)

    local function addTouch(a0, a1) --[[ Upvalues: a0 (copy) ]]
        if a0.BuildTouches[a0] then
            return
        end

        a0.BuildTouches[a0] = a1
        table.insert(a0.BuildTouchOrder, a0)
    end

    local function removeTouch(a0) --[[ Upvalues: a0 (copy) ]]
        a0.BuildTouches[a0] = nil
        for k178, k179 in ipairs(a0.BuildTouchOrder) do
            if k179 == a0 then
                table.remove(a0.BuildTouchOrder, k178)
                break
            end
        end

        a0.BuildPinchMid = nil
        a0.BuildPinchDistance = nil
    end

    local function cancelPendingTouchSelection(a0) --[[ Upvalues: a0 (copy) ]]
        local BuildPendingTouchSelection = a0.BuildPendingTouchSelection
        if not BuildPendingTouchSelection then
            return false
        end

        if a0 then
            if BuildPendingTouchSelection.Input ~= a0 then
                return false
            end
        end

        a0.BuildPendingTouchSelection = nil
        if not a0.EditObject then
            a0:ClearBuildObjectHover()
        end

        return true
    end

    local function beginPendingTouchSelection(a0, a1, a2) --[[ Upvalues: a0 (copy), removeTouch (copy) ]]
        if a0.BuildTouches[a0] then
        else
            a0.BuildTouches[a0] = a1
            table.insert(a0.BuildTouchOrder, a0)
        end

        local v1530 = {
            Input = a0,
            StartPosition = a1,
            Position = a1,
            LastCheckedPosition = a1,
            Object = a2
        }
        a0.BuildPendingTouchSelection = v1530
        task.delay(0.4, function() --[[ Upvalues: a0 (upvalue), v1530 (copy), a0 (copy), removeTouch (upvalue) ]]
            if a0.BuildPendingTouchSelection ~= v1530 then
                return
            end

            if not a0.BuildCameraActive or not a0.EditingBase or a0.BuildModeKind ~= "Objects" or a0.Painting or a0.EditObject or a0.DeletingObjects then
                local v1531 = a0
                local BuildPendingTouchSelection1 = a0.BuildPendingTouchSelection
                if BuildPendingTouchSelection1 then
                    if v1531 and BuildPendingTouchSelection1.Input ~= v1531 then
                        return
                    end

                    a0.BuildPendingTouchSelection = nil
                    if not a0.EditObject then
                        a0:ClearBuildObjectHover()
                    end
                end

                return
            end

            local UserInputState1 = a0.UserInputState
            if UserInputState1 == Enum.UserInputState.End or UserInputState1 == Enum.UserInputState.Cancel or 18 < (v1530.Position - v1530.StartPosition).Magnitude then
                local v1532 = a0
                local BuildPendingTouchSelection2 = a0.BuildPendingTouchSelection
                if BuildPendingTouchSelection2 then
                    if v1532 and BuildPendingTouchSelection2.Input ~= v1532 then
                        return
                    end

                    a0.BuildPendingTouchSelection = nil
                    if not a0.EditObject then
                        a0:ClearBuildObjectHover()
                    end
                end

                return
            end

            local v1533 = a0:GetPlacedBuildObjectAtScreenPosition(v1530.Position)
            if v1533 ~= v1530.Object then
                local v1534 = a0
                local BuildPendingTouchSelection3 = a0.BuildPendingTouchSelection
                if BuildPendingTouchSelection3 then
                    if v1534 and BuildPendingTouchSelection3.Input ~= v1534 then
                        return
                    end

                    a0.BuildPendingTouchSelection = nil
                    if not a0.EditObject then
                        a0:ClearBuildObjectHover()
                    end
                end

                return
            end

            a0.BuildPendingTouchSelection = nil
            removeTouch(a0)
            a0:SelectPlacedBuildObject(v1533)
        end)
    end

    local function pointerOverScrollingGui() --[[ Upvalues: a0 (copy), UserInputService (upvalue) ]]
        local v1536 = a0.Player and a0.Player:FindFirstChildOfClass("PlayerGui")
        if not v1536 then
            return false
        end

        local v1537 = UserInputService:GetMouseLocation()
        local v1540, v1541 = pcall(function() --[[ Upvalues: v1536 (copy), v1537 (copy) ]]
            local v1538 = math.floor(v1537.X)
            local v1539 = v1536:GetGuiObjectsAtPosition(v1538, math.floor(v1537.Y))
            return v1539
        end)
        if not v1540 then
            return false
        end

        for k180, k181 in ipairs(v1541) do
            v1540 = k181
            while v1540 do
                if v1540 == v1536 then
                    break
                end

                if v1540:IsA("ScrollingFrame") and v1540.Visible and v1540.ScrollingEnabled then
                    return true
                end

                v1540 = v1540.Parent
            end
        end

        return false
    end

    local function pointerInsideMobileCameraControls(a0) --[[ Upvalues: a0 (copy) ]]
        local BuildGui5 = a0.BuildGui
        local v1545
        if not BuildGui5 then
            v1545 = nil
        else
            local v1546 = BuildGui5:FindFirstChild("MobileCameraContols") or BuildGui5:FindFirstChild("MobileCameraControls")
        end

        if v1545 then
            if v1545.Visible then
                local AbsolutePosition2 = v1545.AbsolutePosition
                local AbsoluteSize2 = v1545.AbsoluteSize
                if AbsolutePosition2.X <= a0.X and AbsolutePosition2.Y <= a0.Y and a0.X <= AbsolutePosition2.X + AbsoluteSize2.X and a0.Y <= AbsolutePosition2.Y + AbsoluteSize2.Y then
                    return true
                end
            end
        end

        return false
    end

    local function pointerOverInteractiveGui(a0) --[[ Upvalues: a0 (copy) ]]
        local v1548 = a0.Player and a0.Player:FindFirstChildOfClass("PlayerGui")
        if not v1548 then
            return false
        end

        local v1551, v1552 = pcall(function() --[[ Upvalues: v1548 (copy), a0 (copy) ]]
            local v1549 = math.floor(a0.X)
            local v1550 = v1548:GetGuiObjectsAtPosition(v1549, math.floor(a0.Y))
            return v1550
        end)
        if not v1551 then
            return false
        end

        for k182, k183 in ipairs(v1552) do
            v1551 = k183
            while v1551 do
                if v1551 == v1548 then
                    break
                end

                if v1551:IsA("GuiObject") then
                    if v1551.Visible then
                        if v1551:IsA("GuiButton") then
                            return true
                        end

                        if v1551:IsA("TextBox") then
                            return true
                        end

                        if v1551.Active then
                            return true
                        end

                        if v1551:IsA("ScrollingFrame") then
                            if v1551.ScrollingEnabled then
                                return true
                            end
                        end
                    end
                end

                v1551 = v1551.Parent
            end
        end

        return false
    end

    local v1568 = UserInputService.InputBegan:Connect(function(a0, a1) --[[ Upvalues: a0 (copy), GuiService (upvalue), pointerInsideMobileCameraControls (copy), UserInputService (upvalue), pointerOverInteractiveGui (copy), removeTouch (copy), beginPendingTouchSelection (copy) ]]
        if a0.ModernMobile and a0.ModernMobile:IsActive() then
            return
        end

        if not a0.BuildCameraActive or GuiService.MenuIsOpen or a0.PaintResetConfirmOpen then
            return
        end

        if a0.ModernController and a0.ModernController:IsGamepad() and string.match(a0.UserInputType.Name, "^Gamepad") then
            return
        end

        if a0.DeleteAllConfirmOpen then
            if a0.KeyCode == Enum.KeyCode.Escape or a0.KeyCode == Enum.KeyCode.ButtonB then
                a0:SetDeleteAllConfirmation(false)
            end

            return
        end

        if a0.KeyCode == Enum.KeyCode.ButtonA then
            local SelectedObject1 = GuiService.SelectedObject
            local v1557 = a0.BuildTransformButtonCallbacks and a0.BuildTransformButtonCallbacks[SelectedObject1]
            if v1557 then
                a0:BeginBuildTransformHold(SelectedObject1, a0, v1557)
                return
            end
        end

        local v1558 = Vector2.new(a0.Position.X, a0.Position.Y)
        if a0.DesktopCatalogue then
            if a0.DesktopCatalogue:IsPointerOver() then
                if a0.UserInputType == Enum.UserInputType.MouseButton1 or a0.UserInputType == Enum.UserInputType.MouseButton2 or a0.UserInputType == Enum.UserInputType.MouseButton3 then
                    return
                end
            end
        end

        if a0.UserInputType == Enum.UserInputType.MouseButton1 then
            if not a1 then
                if pointerInsideMobileCameraControls(v1558) then
                    return
                end

                if not a0.Painting then
                    local v1559 = UserInputService:GetMouseLocation()
                    a0:ActivateBuildObjectAt(v1559, a0.UserInputType, a0)
                    return
                    -- branch continues at 792
                end
            end
        end

        if a0.UserInputType == Enum.UserInputType.MouseButton2 and not a0.ClassicBuildActive and not a0.BuildCameraLocked and not pointerOverInteractiveGui(v1558) then
            a0.BuildViewPreset = nil
            a0:BeginBuildMouseCameraDrag("Orbit")
            return
        end

        if a0.UserInputType == Enum.UserInputType.MouseButton3 and not a1 and not a0.BuildCameraLocked then
            a0:BeginBuildMouseCameraDrag("Pan")
            return
        end

        if a0.UserInputType == Enum.UserInputType.Touch then
            if pointerInsideMobileCameraControls(v1558) or pointerOverInteractiveGui(v1558) then
                return
            end

            local BuildPendingTouchSelection4 = a0.BuildPendingTouchSelection
            if BuildPendingTouchSelection4 and BuildPendingTouchSelection4.Input ~= a0 and a0.BuildPendingTouchSelection then
                a0.BuildPendingTouchSelection = nil
                if not a0.EditObject then
                    a0:ClearBuildObjectHover()
                end
            end

            if a0.BuildDirectTouch then
                if a0.BuildTouches[a0] then
                    -- jump to 398 (out of range)
                end

                a0.BuildTouches[a0] = v1558
                table.insert(a0.BuildTouchOrder, a0)
            else
                if not a0.Painting then
                    if #a0.BuildTouchOrder == 0 then
                        if a0.EditObject or a0.DeletingObjects then
                            if a0:ActivateBuildObjectAt(v1558, a0.UserInputType, a0) then
                                removeTouch(a0)
                                -- jump to 398 (out of range)
                            end

                            if a0.BuildTouches[a0] then
                                -- jump to 398 (out of range)
                            end

                            a0.BuildTouches[a0] = v1558
                            table.insert(a0.BuildTouchOrder, a0)
                            -- jump to 398 (out of range)
                        end

                        local v1560 = a0:UpdateBuildObjectHover(v1558, true)
                        if v1560 then
                            beginPendingTouchSelection(a0, v1558, v1560)
                            -- jump to 398 (out of range)
                        end

                        if a0.BuildTouches[a0] then
                            -- jump to 398 (out of range)
                        end

                        a0.BuildTouches[a0] = v1558
                        table.insert(a0.BuildTouchOrder, a0)
                        -- branch continues at 377
                    end
                else
                    if a1 then
                        return
                    end

                    if a0.BuildTouches[a0] then
                    else
                        a0.BuildTouches[a0] = v1558
                        table.insert(a0.BuildTouchOrder, a0)
                    end
                end
            end

            a0.BuildPinchMid = nil
            a0.BuildPinchDistance = nil
            return
        end

        if a0.KeyCode == Enum.KeyCode.ButtonA then
            if not a0.Painting then
                local v1561 = UserInputService:GetMouseLocation()
                local v1562
                if a0.BuildGamepadNavigation then
                    local v1565 = a0.Mouse and Vector2.new(a0.Mouse.X, a0.Mouse.Y) or v1561
                    v1562 = not pointerOverInteractiveGui(v1565)
                else
                    v1561 = workspace.CurrentCamera.ViewportSize / 2
                    v1562 = GuiService.SelectedObject == nil
                end

                if v1562 then
                    if a0.BuildGamepadNavigation then
                        local v1566 = {Input = a0, Position = v1561}
                        a0.BuildPendingGamepadGrab = v1566
                        return
                    end

                    a0:ActivateBuildObjectAt(v1561, a0.UserInputType, a0)
                    return
                    -- branch continues at 792
                end
            end
        end

        if a0.KeyCode == Enum.KeyCode.ButtonR2 then
            if a0.BuildModeKind == "Objects" then
                if not a0.Painting then
                    if not UserInputService:GetFocusedTextBox() then
                        a0:RotateBuildObjectStep("Y", 1)
                        return
                        -- branch continues at 792
                    end

                    -- branch continues at 792
                end

                -- branch continues at 792
            end
        end

        if a0.KeyCode == Enum.KeyCode.ButtonL3 then
            a0:SetBuildCameraLocked(not a0.BuildCameraLocked)
            return
        end

        if a0.KeyCode == Enum.KeyCode.ButtonR3 then
            if a0.Painting and a0.ColorPickerHUD then
                a0.PaintPickerPreviousGamepadNavigation = nil
            end

            a0:SetBuildGamepadNavigation(not a0.BuildGamepadNavigation)
            return
        end

        if a0.Painting then
            return
        end

        if a0.KeyCode == Enum.KeyCode.G and not UserInputService:GetFocusedTextBox() then
            a0.BuildGridEnabled = not a0.BuildGridEnabled
            a0:RebuildBuildGrid()
            a0:UpdateBuildGui()
            return
        end

        if a0.KeyCode == Enum.KeyCode.R and not UserInputService:GetFocusedTextBox() then
            a0:QuarterTurnBuildObject("Y")
            return
        end

        if a0.KeyCode == Enum.KeyCode.T and not UserInputService:GetFocusedTextBox() then
            a0:QuarterTurnBuildObject("Z")
            return
        end

        if a0.KeyCode == Enum.KeyCode.PageUp and not UserInputService:GetFocusedTextBox() then
            a0:AdjustBuildGridHeight(1)
            return
        end

        if a0.KeyCode == Enum.KeyCode.PageDown and not UserInputService:GetFocusedTextBox() then
            a0:AdjustBuildGridHeight(-1)
            return
        end

        if a0.KeyCode == Enum.KeyCode.One and not UserInputService:GetFocusedTextBox() then
            a0:SetBuildTransformMode("Move")
            return
        end

        if a0.KeyCode == Enum.KeyCode.Two and not UserInputService:GetFocusedTextBox() then
            a0:SetBuildTransformMode("Rotate")
            return
        end

        if a0.KeyCode == Enum.KeyCode.Return and not UserInputService:GetFocusedTextBox() then
            local v1567 = os.clock() - (a0.DesktopCatalogueTextReleasedAt or -math.huge)
            if 0.15 < v1567 then
                a0:AttemptPlaceBuildObject()
                return
            end
        end

        if a0.KeyCode == Enum.KeyCode.ButtonB and not a0.BuildGamepadNavigation then
            a0:DeleteEditObject()
            return
        end

        if a0.KeyCode == Enum.KeyCode.ButtonX and not a0.BuildGamepadNavigation then
            a0:SetBuildTransformMode("Move")
            return
        end

        if a0.KeyCode == Enum.KeyCode.ButtonY and not a0.BuildGamepadNavigation then
            a0:SetBuildTransformMode("Rotate")
        end

    end)
    table.insert(a0.BuildInputCons, v1568)
    local v1591 = UserInputService.InputChanged:Connect(function(a0, a1) --[[ Upvalues: a0 (copy), GuiService (upvalue), UserInputService (upvalue), pointerOverScrollingGui (copy) ]]
        if a0.ModernMobile and a0.ModernMobile:IsActive() then
            return
        end

        if a0.ModernController and a0.ModernController:IsGamepad() and string.match(a0.UserInputType.Name, "^Gamepad") then
            return
        end

        if not a0.BuildCameraActive or a0.DeleteAllConfirmOpen or a0.PaintResetConfirmOpen or GuiService.MenuIsOpen then
            return
        end

        if a0.UserInputType == Enum.UserInputType.MouseMovement then
            if a0.BuildDirectMouse then
                local v1569 = UserInputService:GetMouseLocation()
                a0:UpdateDirectBuildDrag(v1569)
            end

            if a0.BuildCameraLocked then
                return
            end

            if a0.BuildMouseOrbit then
                a0.BuildViewPreset = nil
                local v1570 = a0
                v1570.BuildCameraYaw = v1570.BuildCameraYaw - a0.Delta.X * 0.0045
                local v1571 = a0.BuildCameraPitch - a0.Delta.Y * 0.0045
                a0.BuildCameraPitch = math.clamp(v1571, -1.5533430342749532, 1.3089969389957472)
                return
            end

            if a0.BuildMousePan then
                local v1572 = Vector2.new(a0.Delta.X, a0.Delta.Y)
                a0:PanBuildCameraPixels(v1572)
                return
                -- branch continues at 496
            end
        end

        if a0.UserInputType == Enum.UserInputType.MouseWheel then
            if a1 then
                return
            end

            if pointerOverScrollingGui() then
                return
            end

            if a0.BuildCameraLocked then
                return
            end

            if a0.DesktopCatalogue then
                if a0.DesktopCatalogue:IsPointerOver() then
                    return
                end
            end

            local v1573, v1574 = a0:GetBuildReference()
            local v1576 = v1574 and math.max(v1574.Size.X, v1574.Size.Y, v1574.Size.Z) or 30
            local CurrentCamera9 = workspace.CurrentCamera
            local v1577 = a0.BuildCameraPosition or CurrentCamera9.CFrame.Position
            a0.BuildCameraPosition = v1577 + CurrentCamera9.CFrame.LookVector * a0.Position.Z * v1576 * 0.08
            return
        end

        if a0.UserInputType == Enum.UserInputType.Touch and a0.BuildPendingTouchSelection and a0.BuildPendingTouchSelection.Input == a0 then
            local BuildPendingTouchSelection5 = a0.BuildPendingTouchSelection
            local v1578 = Vector2.new(a0.Position.X, a0.Position.Y)
            BuildPendingTouchSelection5.Position = v1578
            local v1579 = false
            if 4 <= (v1578 - BuildPendingTouchSelection5.LastCheckedPosition).Magnitude then
                BuildPendingTouchSelection5.LastCheckedPosition = v1578
                local v1580 = a0:GetPlacedBuildObjectAtScreenPosition(v1578)
                v1579 = v1580 ~= BuildPendingTouchSelection5.Object
            end

            if not (18 < (v1578 - BuildPendingTouchSelection5.StartPosition).Magnitude) then
                if not v1579 then
                    return
                end
            end

            local BuildPendingTouchSelection6 = a0.BuildPendingTouchSelection
            if BuildPendingTouchSelection6 then
                if a0 and BuildPendingTouchSelection6.Input ~= a0 then
                else
                    a0.BuildPendingTouchSelection = nil
                    if not a0.EditObject then
                        a0:ClearBuildObjectHover()
                    end
                end
            end

            if a0.BuildTouches[a0] then
                a0.BuildTouches[a0] = v1578
                return
                -- branch continues at 496
            end
        end

        if a0.UserInputType == Enum.UserInputType.Touch and a0 == a0.BuildDirectTouch then
            local v1581 = Vector2.new(a0.Position.X, a0.Position.Y)
            a0:UpdateDirectBuildDrag(v1581)
            return
        end

        if a0.UserInputType == Enum.UserInputType.Touch and a0.BuildTouches[a0] then
            local v1582 = a0.BuildTouches[a0]
            local v1583 = Vector2.new(a0.Position.X, a0.Position.Y)
            a0.BuildTouches[a0] = v1583
            if a0.BuildCameraLocked then
                return
            end

            if #a0.BuildTouchOrder == 1 then
                a0.BuildViewPreset = nil
                local v1584 = v1583 - v1582
                local v1585 = a0
                v1585.BuildCameraYaw = v1585.BuildCameraYaw - v1584.X * 0.007
                local v1586 = a0.BuildCameraPitch - v1584.Y * 0.007
                a0.BuildCameraPitch = math.clamp(v1586, -1.5533430342749532, 1.3089969389957472)
                return
            end

            local v1587 = #a0.BuildTouchOrder
            if 2 <= v1587 then
                v1587 = a0.BuildTouches[a0.BuildTouchOrder[1]]
                local v1588 = a0.BuildTouches[a0.BuildTouchOrder[2]]
                if v1587 then
                    if v1588 then
                        local v1589 = (v1587 + v1588) / 2
                        local Magnitude1 = (v1587 - v1588).Magnitude
                        if a0.BuildPinchMid then
                            if a0.BuildPinchDistance then
                                a0:PanBuildCameraPixels(v1589 - a0.BuildPinchMid)
                                local CurrentCamera10 = workspace.CurrentCamera
                                local v1590 = a0.BuildCameraPosition or CurrentCamera10.CFrame.Position
                                a0.BuildCameraPosition = v1590 + CurrentCamera10.CFrame.LookVector * (Magnitude1 - a0.BuildPinchDistance) * 0.06
                            end
                        end

                        a0.BuildPinchMid = v1589
                        a0.BuildPinchDistance = Magnitude1
                    end
                end
            end
        end

    end)
    table.insert(a0.BuildInputCons, v1591)
    local v1592 = UserInputService.InputEnded:Connect(function(a0) --[[ Upvalues: a0 (copy), removeTouch (copy) ]]
        if a0.ModernMobile and a0.ModernMobile:IsActive() then
            return
        end

        if a0.ModernController and a0.ModernController:IsGamepad() and string.match(a0.UserInputType.Name, "^Gamepad") then
            return
        end

        a0:EndBuildTransformHold(a0)
        a0:EndBuildMobileCameraInput(a0)
        if a0.KeyCode == Enum.KeyCode.ButtonA then
            a0.BuildPendingGamepadGrab = nil
            if a0.BuildDirectGamepad then
                a0:EndDirectBuildDrag()
                return
                -- branch continues at 162
            end
        end

        if a0.UserInputType == Enum.UserInputType.MouseButton1 then
            a0:EndDirectBuildDrag()
            a0.BuildDragStartPosition = nil
            a0.BuildDragStartRotation = nil
            a0.BuildGizmoDragging = nil
            return
        end

        if a0.UserInputType == Enum.UserInputType.MouseButton2 then
            a0:EndBuildMouseCameraDrag("Orbit")
            return
        end

        if a0.UserInputType == Enum.UserInputType.MouseButton3 then
            a0:EndBuildMouseCameraDrag("Pan")
            return
        end

        if a0.UserInputType == Enum.UserInputType.Touch then
            local BuildPendingTouchSelection7 = a0.BuildPendingTouchSelection
            if BuildPendingTouchSelection7 then
                if a0 and BuildPendingTouchSelection7.Input ~= a0 then
                else
                    a0.BuildPendingTouchSelection = nil
                    if not a0.EditObject then
                        a0:ClearBuildObjectHover()
                    end
                end
            end

            if a0 == a0.BuildDirectTouch then
                a0:EndDirectBuildDrag()
                return
            end

            removeTouch(a0)
        end

    end)
    table.insert(a0.BuildInputCons, v1592)

    local function releaseBuildInputs() --[[ Upvalues: a0 (copy) ]]
        if a0.BuildPendingTouchSelection then
            a0.BuildPendingTouchSelection = nil
            if not a0.EditObject then
                a0:ClearBuildObjectHover()
            end
        end

        a0:EndBuildTouchGizmoDrag()
        a0:EndBuildTransformHold()
        a0:EndDirectBuildDrag()
        a0:EndBuildMouseCameraDrag()
        a0:ClearBuildMobileCameraInputs()
        a0.BuildPendingGamepadGrab = nil
        a0.BuildTouches = {}
        a0.BuildTouchOrder = {}
        a0.BuildPinchMid = nil
        a0.BuildPinchDistance = nil
    end

    local v1593 = UserInputService.WindowFocusReleased:Connect(releaseBuildInputs)
    table.insert(a0.BuildInputCons, v1593)
    local v1594 = GuiService.MenuOpened:Connect(releaseBuildInputs)
    table.insert(a0.BuildInputCons, v1594)
end

getBobbing.ConnectBuildInputs = ConnectBuildInputs

local function SetDeletingObjects(a0, a1) --[[ Upvalues: styleBuildButton (copy), v793 (copy) ]]
    a0.ClassicBuildRightMouse = nil
    a0.DeletingObjects = a1 == true
    if not a0.DeletingObjects and a0.ModernDesktop then
        a0.ModernDesktop:CancelPendingDeletes()
    end

    if a0.DeletingObjects and a0.EditObject then
        a0:DeleteEditObject()
    end

    a0:ClearBuildObjectHover()
    local BuildGui6 = a0.BuildGui
    if not (BuildGui6 and BuildGui6.Parent) then
        BuildGui6 = a0.Player.PlayerGui:FindFirstChild("BuildModeGui")
    end

    local v1596 = BuildGui6 and BuildGui6:FindFirstChild("Toolbar") and BuildGui6.Toolbar:FindFirstChild("Buttons")
    local v1597 = v1596 and v1596:FindFirstChild("DeleteMode")
    if v1597 then
        local v1598
        if a0.DeletingObjects then
            v1598 = "Delete: On"
        else
            v1598 = "Delete: Off"
        end

        v1597.Text = v1598
        styleBuildButton(v1597, a0.DeletingObjects, a0.DeletingObjects and v793 or nil)
    end

    if a0.ClassicBuildActive then
        a0:ApplyClassicBuildPresentation()
    end
end

getBobbing.SetDeletingObjects = SetDeletingObjects

local function SetDeleteAllConfirmation(a0, a1) --[[ Upvalues: v16 (copy), GuiService (copy), UserInputService (copy) ]]
    local v1601 = a0.BuildGui and a0.BuildGui:FindFirstChild("DeleteAllConfirm")
    if not v1601 then
        return false
    end

    local v1602 = false
    if a1 == true then
        v1602 = false
        if a0.BuildCameraActive == true then
            v1602 = a0.BuildModeKind == "Objects"
        end
    end

    if v1602 then
        if a0.DeleteAllConfirmOpen then
            return true
        end

        v16.HideResetConfirmation(a0)
        a0.DeleteAllPreviousSelection = GuiService.SelectedObject
        a0.DeleteAllConfirmOpen = true
        v1601.Visible = true
        a0:EndBuildTouchGizmoDrag()
        a0:EndBuildTransformHold()
        a0:EndDirectBuildDrag()
        a0:ClearBuildMobileCameraInputs()
        a0.BuildPendingTouchSelection = nil
        a0.BuildPendingGamepadGrab = nil
        a0:EndBuildMouseCameraDrag()
        local Cancel2 = v1601:FindFirstChild("Cancel", true)
        if UserInputService.GamepadEnabled then
            if Cancel2 then
                if Cancel2:IsA("GuiButton") then
                    GuiService.SelectedObject = Cancel2
                    -- branch continues at 136
                end

                -- branch continues at 136
            end

            -- branch continues at 136
        end
    else
        local DeleteAllPreviousSelection = a0.DeleteAllPreviousSelection
        a0.DeleteAllConfirmOpen = nil
        a0.DeleteAllPreviousSelection = nil
        v1601.Visible = false
        if a0.DeleteAllConfirmOpen == true then
            local SelectedObject2 = GuiService.SelectedObject
            if SelectedObject2 then
                if SelectedObject2:IsDescendantOf(v1601) then
                    GuiService.SelectedObject = DeleteAllPreviousSelection and DeleteAllPreviousSelection.Parent and DeleteAllPreviousSelection or nil
                end
            end
        end
    end

    if a0.ClassicDesktop then
        a0.ClassicDesktop:Refresh()
    end

    if a0.ModernDesktop then
        a0.ModernDesktop:Refresh()
    end

    return true
end

getBobbing.SetDeleteAllConfirmation = SetDeleteAllConfirmation

local function SetupBuildGui(a0) --[[ Upvalues: RemoteEvent (copy), v799 (copy) ]]
    if a0.BuildGuiWired and a0.BuildGui and a0.BuildGui.Parent then
        return true
    end

    local v1605 = a0.Player.PlayerGui:FindFirstChild("BuildModeGui") or a0.Player.PlayerGui:WaitForChild("BuildModeGui", 5)
    if not v1605 then
        return false
    end

    a0.BuildGui = v1605
    a0.BuildGuiWired = true
    local BuildGuiCons = a0.BuildGuiCons
    if not BuildGuiCons then
        BuildGuiCons = {}
    end

    a0.BuildGuiCons = BuildGuiCons

    local function connect2(a0, a1) --[[ Upvalues: a0 (copy) ]]
        local v1606 = a0.Activated:Connect(a1)
        table.insert(a0.BuildGuiCons, v1606)
    end

    local BuildTransformButtonCallbacks1 = a0.BuildTransformButtonCallbacks
    if not BuildTransformButtonCallbacks1 then
        local v1607 = setmetatable({}, {__mode = "k"})
    end

    a0.BuildTransformButtonCallbacks = BuildTransformButtonCallbacks1

    local function connectHold(a0, a1) --[[ Upvalues: a0 (copy) ]]
        a0.BuildTransformButtonCallbacks[a0] = a1
        local v1609 = a0.InputBegan:Connect(function(a0) --[[ Upvalues: a0 (upvalue), a0 (copy), a1 (copy) ]]
            local v1608 = true
            if a0.UserInputType ~= Enum.UserInputType.MouseButton1 then
                v1608 = true
                if a0.UserInputType ~= Enum.UserInputType.Touch then
                    v1608 = a0.KeyCode == Enum.KeyCode.ButtonA
                end
            end

            if v1608 then
                a0:BeginBuildTransformHold(a0, a0, a1)
            end

        end)
        table.insert(a0.BuildGuiCons, v1609)
        local v1610 = a0.InputEnded:Connect(function(a0) --[[ Upvalues: a0 (upvalue) ]]
            a0:EndBuildTransformHold(a0)
            task.delay(1, function() --[[ Upvalues: a0 (upvalue), a0 (copy) ]]
                local BuildTransformHandledActivations = a0.BuildTransformHandledActivations
                if BuildTransformHandledActivations then
                    BuildTransformHandledActivations[a0] = nil
                end

            end)
        end)
        table.insert(a0.BuildGuiCons, v1610)
        local v1611 = a0.Activated:Connect(function(a0) --[[ Upvalues: a0 (upvalue), a1 (copy) ]]
            local BuildTransformHandledActivations1 = a0.BuildTransformHandledActivations
            if a0 and BuildTransformHandledActivations1 and BuildTransformHandledActivations1[a0] then
                BuildTransformHandledActivations1[a0] = nil
                return
            end

            a1()
        end)
        table.insert(a0.BuildGuiCons, v1611)
    end

    local BuildSystemToggle2 = v1605:FindFirstChild("BuildSystemToggle")
    if BuildSystemToggle2 and BuildSystemToggle2:IsA("GuiButton") then
        local v1612 = BuildSystemToggle2.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:SetBuildSystem(nil, true)
        end)
        table.insert(a0.BuildGuiCons, v1612)
    end

    local Buttons4 = v1605.Toolbar.Buttons
    local v1613 = Buttons4.MoveMode.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:SetBuildTransformMode("Move")
    end)
    table.insert(a0.BuildGuiCons, v1613)
    local v1614 = Buttons4.RotateMode.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:SetBuildTransformMode("Rotate")
    end)
    table.insert(a0.BuildGuiCons, v1614)
    local v1615 = Buttons4.Place.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:AttemptPlaceBuildObject()
    end)
    table.insert(a0.BuildGuiCons, v1615)
    local v1616 = Buttons4.Cancel.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:DeleteEditObject()
    end)
    table.insert(a0.BuildGuiCons, v1616)
    local v1617 = Buttons4.Grid.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0.BuildGridEnabled = not a0.BuildGridEnabled
        a0:RebuildBuildGrid()
        a0:UpdateBuildGui()
    end)
    table.insert(a0.BuildGuiCons, v1617)
    local v1618 = Buttons4.MoveStep.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:CycleBuildMoveStep()
    end)
    table.insert(a0.BuildGuiCons, v1618)
    local v1619 = Buttons4.RotateStep.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:CycleBuildRotateStep()
    end)
    table.insert(a0.BuildGuiCons, v1619)
    local CameraLock1 = Buttons4:FindFirstChild("CameraLock")
    if CameraLock1 then
        local v1620 = CameraLock1.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:SetBuildCameraLocked(not a0.BuildCameraLocked)
        end)
        table.insert(a0.BuildGuiCons, v1620)
    end

    local PaintMode1 = Buttons4:FindFirstChild("PaintMode")
    if PaintMode1 then
        local v1621 = PaintMode1.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
            if a0.Painting then
                a0:ClosePaintFrames()
                return
            end

            if a0.EditingBase then
                a0:OpenPaintFrames()
            end

        end)
        table.insert(a0.BuildGuiCons, v1621)
    end

    local v1622 = Buttons4.DeleteMode.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:SetDeletingObjects(not a0.DeletingObjects)
    end)
    table.insert(a0.BuildGuiCons, v1622)
    local v1623 = Buttons4.DeleteAll.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:SetDeleteAllConfirmation(true)
    end)
    table.insert(a0.BuildGuiCons, v1623)
    local DeleteAllConfirm1 = v1605:FindFirstChild("DeleteAllConfirm")
    local v1625 = DeleteAllConfirm1 and DeleteAllConfirm1:FindFirstChild("Panel")
    if v1625 then
        DeleteAllConfirm1 = v1625:FindFirstChild("Confirm")
        local Cancel3 = v1625:FindFirstChild("Cancel")
        if DeleteAllConfirm1 and DeleteAllConfirm1:IsA("GuiButton") then
            local v1626 = DeleteAllConfirm1.Activated:Connect(function() --[[ Upvalues: a0 (copy), RemoteEvent (upvalue) ]]
                if not a0.DeleteAllConfirmOpen then
                    return
                end

                if a0.ClassicDesktop and a0.ClassicDesktop.Busy then
                    return
                end

                if a0.ClassicMobile and a0.ClassicMobile.Busy then
                    return
                end

                if a0.ModernDesktop and a0.ModernDesktop.Busy then
                    return
                end

                if a0.ClassicController and a0.ClassicController.Busy then
                    return
                end

                if a0.ModernController and a0.ModernController.Busy then
                    return
                end

                a0:SetDeleteAllConfirmation(false)
                a0:DeleteEditObject()
                a0:SetDeletingObjects(false)
                RemoteEvent:FireServer("DeleteAllObjects", true)
                local ClassicDesktop = a0.ClassicDesktop
                if ClassicDesktop then
                    task.defer(function() --[[ Upvalues: ClassicDesktop (copy) ]]
                        ClassicDesktop:RefreshState()
                    end)
                end

                local ClassicMobile1 = a0.ClassicMobile
                if ClassicMobile1 then
                    task.defer(function() --[[ Upvalues: ClassicMobile1 (copy) ]]
                        ClassicMobile1:RefreshState()
                    end)
                end

                local ModernDesktop = a0.ModernDesktop
                if ModernDesktop then
                    task.defer(function() --[[ Upvalues: ModernDesktop (copy) ]]
                        ModernDesktop:RefreshState()
                    end)
                end

                local ClassicController = a0.ClassicController
                if ClassicController then
                    task.defer(function() --[[ Upvalues: ClassicController (copy) ]]
                        ClassicController:RefreshState()
                    end)
                end

                local ModernController = a0.ModernController
                if ModernController then
                    task.defer(function() --[[ Upvalues: ModernController (copy) ]]
                        ModernController:RefreshState()
                    end)
                end

            end)
            table.insert(a0.BuildGuiCons, v1626)
        end

        if Cancel3 and Cancel3:IsA("GuiButton") then
            local v1627 = Cancel3.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
                a0:SetDeleteAllConfirmation(false)
            end)
            table.insert(a0.BuildGuiCons, v1627)
        end
    end

    local v1628 = Buttons4.Exit.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
        if a0.Painting then
            a0:ClosePaintFrames()
            return
        end

        if a0.EditingBase then
            a0:StopEditStorage()
        end

    end)
    table.insert(a0.BuildGuiCons, v1628)
    v1628 = "Y"
    local v1629 = {"X", v1628, "Z"}
    for k184, k185 in ipairs(v1629) do
        v1625 = v1605.TransformPanel.AxisRows[k185]
        connectHold(v1625.Minus, function() --[[ Upvalues: a0 (copy), k185 (copy) ]]
            a0:NudgeBuildObject(k185, -1)
        end)
        connectHold(v1625.Plus, function() --[[ Upvalues: a0 (copy), k185 (copy) ]]
            a0:NudgeBuildObject(k185, 1)
        end)
    end

    Buttons4 = v1605.TransformPanel.AxisRows:FindFirstChild("GridHeight")
    if Buttons4 then
        connectHold(Buttons4.Minus, function() --[[ Upvalues: a0 (copy) ]]
            a0:AdjustBuildGridHeight(-1)
        end)
        connectHold(Buttons4.Plus, function() --[[ Upvalues: a0 (copy) ]]
            a0:AdjustBuildGridHeight(1)
        end)
    end

    k185 = "Front"
    local v1633 = {"Top", k185, "Back", "Left", "Right", "Iso"}
    for k186, k187 in ipairs(v1633) do
        local v1637 = v1605.ViewPanel.Views[k187]
        local v1638 = v1637.Activated:Connect(function() --[[ Upvalues: a0 (copy), k187 (copy) ]]
            a0:SetBuildView(k187)
        end)
        table.insert(a0.BuildGuiCons, v1638)
    end

    Buttons4 = v1605.ViewPanel:FindFirstChild("CollapseButton")
    if Buttons4 and Buttons4:IsA("GuiButton") then
        local v1639 = Buttons4.Activated:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:ToggleBuildViewPanel()
        end)
        table.insert(a0.BuildGuiCons, v1639)
    end

    a0:UpdateBuildViewPanel()
    if not v1605 then
        connectHold = nil
    else
        local v1640 = v1605:FindFirstChild("MobileCameraContols") or v1605:FindFirstChild("MobileCameraControls")
    end

    if connectHold then
        connectHold.Visible = false
        for k188, k189 in pairs({Forward = Vector3.new(0, 0, -1), Back = Vector3.new(0, 0, 1), Left = Vector3.new(-1, 0, 0), Right = Vector3.new(1, 0, 0), Up = Vector3.new(0, 1, 0), Down = Vector3.new(0, -1, 0)}) do
            connect2 = connectHold:FindFirstChild(k188, true)
            if connect2 and connect2:IsA("GuiButton") then
                local v1644 = connect2.InputBegan:Connect(function(a0) --[[ Upvalues: a0 (copy), connect2 (copy), k189 (copy) ]]
                    if a0.UserInputType == Enum.UserInputType.Touch or a0.UserInputType == Enum.UserInputType.MouseButton1 then
                        a0:BeginBuildMobileCameraInput(a0, connect2, k189)
                    end

                end)
                table.insert(a0.BuildGuiCons, v1644)
                local v1645 = connect2.InputEnded:Connect(function(a0) --[[ Upvalues: a0 (copy) ]]
                    a0:EndBuildMobileCameraInput(a0)
                end)
                table.insert(a0.BuildGuiCons, v1645)
            end
        end
    end

    k187 = "MoveY"
    local v1646 = {"MoveX", k187, "MoveZ"}
    for k190, k191 in ipairs(v1646) do
        local v1650 = v1605[k191]
        local v1651 = v1650.MouseButton1Down:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:EndDirectBuildDrag()
            a0.BuildGizmoActivatedAt = os.clock()
            a0.BuildGizmoDragging = true
            a0.BuildDragStartPosition = a0.BuildObjectPosition
        end)
        table.insert(a0.BuildGuiCons, v1651)
        local v1658 = v1650.MouseDrag:Connect(function(a0, a1) --[[ Upvalues: a0 (copy) ]]
            if not (a0.EditObject and a0.BuildDragStartPosition) then
                return
            end

            local v1652 = a0.StorageBase and a0.StorageBase:FindFirstChild("Floor")
            if not v1652 then
                return
            end

            local v1653 = Vector3.FromNormalId(a0)
            local Unit7 = v1652.CFrame:VectorToObjectSpace(v1653).Unit
            local v1654 = a0.BuildMoveStep or 0.5
            if not v1654 or v1654 <= 0 then
                local v1655 = a1
                -- jump to 53 (out of range)
            end

            local v1656 = math.round(a1 / v1654) * v1654
            v1653 = Unit7 * v1656
            local v1657 = a0.BuildDragStartPosition + v1653
            a0.BuildObjectPosition = a0:GetClampedBuildPosition(v1657, a0.BuildObjectRotation)
            a0.BuildTransformDirty = true
        end)
        table.insert(a0.BuildGuiCons, v1658)
        local v1659 = v1650.MouseButton1Up:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0.BuildDragStartPosition = nil
            a0.BuildGizmoDragging = nil
        end)
        table.insert(a0.BuildGuiCons, v1659)
    end

    k191 = "RotateY"
    local v1660 = {"RotateX", k191, "RotateZ"}
    for k192, k193 in ipairs(v1660) do
        connectHold = v1605[k193]
        local v1664 = connectHold.MouseButton1Down:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:EndDirectBuildDrag()
            a0.BuildGizmoActivatedAt = os.clock()
            a0.BuildGizmoDragging = true
            a0.BuildDragStartRotation = a0.BuildObjectRotation
        end)
        table.insert(a0.BuildGuiCons, v1664)
        local v1681 = connectHold.MouseDrag:Connect(function(a0, a1) --[[ Upvalues: a0 (copy), v799 (upvalue) ]]
            if not (a0.EditObject and a0.BuildDragStartRotation) then
                return
            end

            local v1665 = math.deg(a1)
            local v1666 = a0.BuildRotateStep or 15
            if not v1666 or v1666 <= 0 then
                local v1667 = v1665
                -- jump to 30 (out of range)
            end

            local v1668 = math.round(v1665 / v1666) * v1666
            if a0 == Enum.Axis.X then
                v1665 = "X"
            else
                if a0 == Enum.Axis.Y then
                    v1665 = "Y"
                else
                    v1665 = false
                    if a0 == Enum.Axis.Z then
                        v1665 = "Z"
                    end
                end
            end

            if not v1665 then
                return
            end

            local v1669 = a0
            local BuildDragStartRotation = a0.BuildDragStartRotation
            local v1670 = v799[v1665]
            local v1671
            if not v1670 then
                v1671 = BuildDragStartRotation
            else
                local v1672 = BuildDragStartRotation or Vector3.new(-90, 90, 0)
                local v1673 = math.rad(v1672.X)
                local v1674 = math.rad(v1672.Y)
                local v1675 = CFrame.Angles(v1673, v1674, math.rad(v1672.Z))
                local v1676, v1677, v1678 = (v1675 * CFrame.fromAxisAngle(v1670, math.rad(v1668))):ToEulerAnglesXYZ()
                local v1679 = math.deg(v1676)
                local v1680 = math.deg(v1677)
                v1671 = Vector3.new(v1679, v1680, math.deg(v1678))
            end

            v1669.BuildObjectRotation = v1671
            a0:ClampBuildObjectToBounds()
            a0.BuildTransformDirty = true
        end)
        table.insert(a0.BuildGuiCons, v1681)
        local v1682 = connectHold.MouseButton1Up:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0.BuildDragStartRotation = nil
            a0.BuildGizmoDragging = nil
        end)
        table.insert(a0.BuildGuiCons, v1682)
    end

    return true
end

getBobbing.SetupBuildGui = SetupBuildGui

local function SetBuildPanelToggleHidden(a0, a1) --[[ Upvalues: GuiService (copy) ]]
    if a1 then
        if a0.BuildPanelHiddenObjects then
            return
        end

        local v1684 = a0.Player:FindFirstChildOfClass("PlayerGui")
        if not v1684 then
            return
        end

        a0.BuildPanelHiddenObjects = {}
        a0.BuildPanelVisibilityCons = {}

        local function hideToggle(a0) --[[ Upvalues: v1684 (copy), a0 (copy), GuiService (upvalue) ]]
            local Parent1 = a0.Parent
            if a0.Name ~= "Toggle" or not a0:IsA("GuiObject") or not Parent1 or Parent1.Name ~= "Panel" or Parent1.Parent ~= v1684 or a0.BuildPanelHiddenObjects[a0] ~= nil then
                return
            end

            a0.BuildPanelHiddenObjects[a0] = a0.Visible
            a0.Visible = false
            if GuiService.SelectedObject == a0 then
                GuiService.SelectedObject = nil
            end

            local v1685 = a0:GetPropertyChangedSignal("Visible")
            local v1686 = v1685:Connect(function() --[[ Upvalues: a0 (copy), a0 (upvalue) ]]
                if a0.Visible then
                    a0.BuildPanelHiddenObjects[a0] = true
                    a0.Visible = false
                end

            end)
            table.insert(a0.BuildPanelVisibilityCons, v1686)
        end

        local v1687 = v1684.DescendantAdded:Connect(hideToggle)
        table.insert(a0.BuildPanelVisibilityCons, v1687)
        local Panel3 = v1684:FindFirstChild("Panel")
        local v1689 = Panel3 and Panel3:FindFirstChild("Toggle")
        if v1689 then
            hideToggle(v1689)
            return
            -- branch continues at 95
        end
    end

    local BuildPanelVisibilityCons = a0.BuildPanelVisibilityCons
    if not BuildPanelVisibilityCons then
        BuildPanelVisibilityCons = {}
    end

    for k194, k195 in ipairs(BuildPanelVisibilityCons) do
        k195:Disconnect()
    end

    a0.BuildPanelVisibilityCons = nil
    local BuildPanelHiddenObjects = a0.BuildPanelHiddenObjects
    if not BuildPanelHiddenObjects then
        BuildPanelHiddenObjects = {}
    end

    for k196, k197 in pairs(BuildPanelHiddenObjects) do
        if k196.Parent then
            k196.Visible = k197
        end
    end

    a0.BuildPanelHiddenObjects = nil
end

getBobbing.SetBuildPanelToggleHidden = SetBuildPanelToggleHidden

local function SetBuildClutterHidden(a0, a1)
    local v1697 = "Guide"
    local v1698 = "DailyRewards"
    local t7 = {
        "GuideButton",
        "DailyRewardsButton",
        "LikeButton",
        v1697,
        v1698,
        "LikeReward",
        "Clock",
        "BaseEdit",
        "BaseCoord",
        "XCoordinate",
        "ZCoordinate"
    }
    if a1 then
        if a0.BuildHiddenGuiObjects then
            return
        end

        a0.BuildHiddenGuiObjects = {}
        for k198, k199 in ipairs(t7) do
            local v1702 = a0.HUD:FindFirstChild(k199)
            if v1702 and v1702:IsA("GuiObject") then
                a0.BuildHiddenGuiObjects[v1702] = v1702.Visible
                v1702.Visible = false
            end
        end

        a0.BuildDisabledPrompts = {}
        local v1703 = a0.StorageBase and a0.StorageBase:FindFirstChild("Contents")
        local v1705 = v1703 and v1703:FindFirstChild("DoorSwitch", true)
        if v1705 then
            local v1708 = v1705:GetDescendants()
            for k200, k201 in ipairs(v1708) do
                if k201:IsA("ProximityPrompt") then
                    a0.BuildDisabledPrompts[k201] = k201.Enabled
                    k201.Enabled = false
                end
            end

            return
            -- branch continues at 143
        end
    end

    if a0.BuildHiddenGuiObjects then
        for k202, k203 in pairs(a0.BuildHiddenGuiObjects) do
            if k202 and k202.Parent then
                k202.Visible = k203
            end
        end

        a0.BuildHiddenGuiObjects = nil
    end

    if a0.BuildDisabledPrompts then
        for k204, k205 in pairs(a0.BuildDisabledPrompts) do
            if k204 and k204.Parent then
                k204.Enabled = k205
            end
        end

        a0.BuildDisabledPrompts = nil
    end
end

getBobbing.SetBuildClutterHidden = SetBuildClutterHidden

local function IsClassicBuildSystem(a0)
    local v1718 = false
    if a0.Data ~= nil then
        v1718 = a0.Data.BuildSystem == "Classic"
    end

    return v1718
end

getBobbing.IsClassicBuildSystem = IsClassicBuildSystem

local function SetClassicDesktopBuildClutterHidden(a0, a1)
    local v1720
    if a1 then
        local ClassicDesktopBuildHiddenGuiObjects = a0.ClassicDesktopBuildHiddenGuiObjects
        if not ClassicDesktopBuildHiddenGuiObjects then
            ClassicDesktopBuildHiddenGuiObjects = {}
        end

        a0.ClassicDesktopBuildHiddenGuiObjects = ClassicDesktopBuildHiddenGuiObjects
        v1720 = "DailyRewardsButton"
        local v1721 = {"GuideButton", v1720, "LikeButton"}
        for k206, k207 in ipairs(v1721) do
            local v1726 = a0.HUD and a0.HUD:FindFirstChild(k207)
            if v1726 then
                if v1726:IsA("GuiObject") then
                    if a0.ClassicDesktopBuildHiddenGuiObjects[v1726] == nil then
                        a0.ClassicDesktopBuildHiddenGuiObjects[v1726] = v1726.Visible
                    end

                    v1726.Visible = false
                end
            end
        end

        return
    end

    if a0.ClassicDesktopBuildHiddenGuiObjects then
        for k208, k209 in pairs(a0.ClassicDesktopBuildHiddenGuiObjects) do
            if k208.Parent then
                local v1730 = true
                if k208.Name == "LikeButton" then
                    local v1731 = a0.Data and a0.Data.LikeBonus
                    v1730 = not v1731
                end

                k208.Visible = k209 and v1730
            end
        end

        a0.ClassicDesktopBuildHiddenGuiObjects = nil
    end
end

getBobbing.SetClassicDesktopBuildClutterHidden = SetClassicDesktopBuildClutterHidden

local function ApplyClassicBuildPresentation(a0) --[[ Upvalues: UserInputService (copy), GuiService (copy) ]]
    if not a0.ClassicBuildActive then
        return
    end

    local v1732 = false
    if a0.BuildCameraActive == true then
        local v1733 = a0:IsDesktopBuildCatalogue()
    end

    a0:SetClassicDesktopBuildClutterHidden(v1732)
    local BuildGui8 = a0.BuildGui
    if BuildGui8 then
        local v1734 = "TransformPanel"
        v1732 = {
            "Toolbar",
            v1734,
            "ViewPanel",
            "Hint",
            "ControllerHotkeys",
            "MobileCameraContols"
        }
        for k210, k211 in ipairs(v1732) do
            local v1738 = BuildGui8:FindFirstChild(k211)
            if v1738 and v1738:IsA("GuiObject") then
                v1738.Visible = false
            end
        end
    end

    BuildGui8 = false
    if a0.BuildModeKind == "Objects" then
        BuildGui8 = not a0.Painting
    end

    local v1739 = a0.HUD and a0.HUD:FindFirstChild("BaseObjects")
    local v1741 = v1739 and v1739:FindFirstChild("Hotkeys")
    v1739 = v1741
    if v1739 then
        local v1743 = BuildGui8 and not a0.TouchEnabled
        v1739.Visible = v1743
        local Place1 = v1739:FindFirstChild("Place")
        local Deselect = v1739:FindFirstChild("Deselect")
        if a0.ClassicBuildLabelText then
            if UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse then
                if Place1 then
                    if Place1:IsA("TextLabel") then
                        local v1744
                        if a0.DeletingObjects then
                            v1744 = "Delete: M1"
                        else
                            if a0.EditingExistingObject then
                                v1744 = "Save Move: M1"
                            else
                                if a0.EditObject then
                                    v1744 = "Place: M1"
                                else
                                    v1744 = "Select Object: M1"
                                end
                            end
                        end

                        Place1.Text = v1744
                    end
                end

                if Deselect then
                    if Deselect:IsA("TextLabel") then
                        local v1745
                        if a0.EditingExistingObject then
                            v1745 = "Cancel Move: E"
                        else
                            if a0.EditObject then
                                v1745 = "Select Existing: E"
                            else
                                v1745 = "Deselect: E"
                            end
                        end

                        Deselect.Text = v1745
                    end
                end
            end
        end

        local Delete = v1739:FindFirstChild("Delete")
        if a0.ClassicBuildLabelText then
            if Delete then
                if Delete:IsA("TextLabel") then
                    local v1746 = GuiService:IsTenFootInterface()
                    if not v1746 then
                        local GamepadEnabled4 = UserInputService.GamepadEnabled
                        if GamepadEnabled4 then
                            GamepadEnabled4 = not UserInputService.KeyboardEnabled
                            if not GamepadEnabled4 then
                                GamepadEnabled4 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
                            end
                        end
                    end

                    if v1746 then
                        Place1 = "X"
                    else
                        Place1 = "M2"
                    end

                    Delete.Text = a0.DeletingObjects and "Delete: " .. Place1 or "Delete: Disabled"
                end
            end
        end

        local DeleteMode2 = v1739:FindFirstChild("DeleteMode")
        if a0.ClassicBuildLabelText then
            if DeleteMode2 then
                if DeleteMode2:IsA("TextLabel") then
                    local v1748 = GuiService:IsTenFootInterface()
                    if not v1748 then
                        local GamepadEnabled5 = UserInputService.GamepadEnabled
                        if GamepadEnabled5 then
                            GamepadEnabled5 = not UserInputService.KeyboardEnabled
                            if not GamepadEnabled5 then
                                GamepadEnabled5 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
                            end
                        end
                    end

                    local v1749
                    if v1748 then
                        v1749 = "Y"
                    else
                        v1749 = "F"
                    end

                    local v1750
                    if a0.DeletingObjects then
                        v1750 = "On"
                    else
                        v1750 = "Off"
                    end

                    DeleteMode2.Text = "Delete Mode: " .. v1750 .. " (" .. v1749 .. ")"
                end
            end
        end
    end

    if a0.HUD then
        local MobileEdits = a0.HUD:FindFirstChild("MobileEdits")
        local v1752 = MobileEdits and MobileEdits:FindFirstChild("Delete")
        local v1754 = v1752 and v1752:FindFirstChild("ActionTitle")
        local v1755 = MobileEdits and MobileEdits:FindFirstChild("Place")
        local v1756 = v1755 and v1755:FindFirstChild("ActionTitle")
        if a0.ClassicBuildLabelText then
            if v1754 then
                local v1757
                if a0.DeletingObjects then
                    v1757 = "Delete: On"
                else
                    v1757 = "Delete: Off"
                end

                v1754.Text = v1757
            end
        end

        if a0.ClassicBuildLabelText then
            if v1756 then
                local v1758
                if a0.DeletingObjects then
                    v1758 = "Delete Target"
                else
                    v1758 = "Place"
                end

                v1756.Text = v1758
            end
        end

        local v1760 = BuildGui8 and a0.TouchEnabled
        a0.HUD.MobileEdits.Visible = v1760
        local v1761 = BuildGui8 and a0.TouchEnabled
        a0.HUD.MobileMouse.Visible = v1761
    end

    if a0.ClassicController then
        a0.ClassicController:RefreshPresentation()
    end

    if a0.ClassicMobile then
        a0.ClassicMobile:RefreshPresentation()
    end

    if a0.ClassicDesktop then
        a0.ClassicDesktop:Refresh()
    end

    a0:RefreshDesktopBuildCatalogue()
end

getBobbing.ApplyClassicBuildPresentation = ApplyClassicBuildPresentation

local function GetClassicBuildAim(a0) --[[ Upvalues: UserInputService (copy) ]]
    if a0.ClassicBuildActive and a0.EditingExistingObject and UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse then
        local UnitRay = a0.Mouse.UnitRay
        local v1762 = {workspace.CurrentCamera, a0.EditingExistingObject}
        if a0.Character then
            table.insert(v1762, a0.Character)
        end

        if a0.EditObject then
            table.insert(v1762, a0.EditObject)
        end

        local v1763 = RaycastParams.new()
        v1763.FilterType = Enum.RaycastFilterType.Exclude
        v1763.IgnoreWater = true
        for i28 = 1, 32 do
            v1763.FilterDescendantsInstances = v1762
            local v1766 = UnitRay.Direction * 500
            local v1767 = workspace:Raycast(UnitRay.Origin, v1766, v1763)
            if not v1767 then
                return nil, nil
            end

            local Instance3 = v1767.Instance
            if Instance3:IsA("BasePart") then
                if 1 > Instance3.Transparency then
                    if 1 > Instance3.LocalTransparencyModifier then
                        -- jump to 108
                    end
                end

                table.insert(v1762, Instance3)
            else
                local v1768 = CFrame.new(v1767.Position)
                return v1768, Instance3
            end
        end

        return nil, nil
    end

    if a0.ClassicMobile and a0.ClassicMobile:IsActive() then
        local v1769 = a0.ClassicMobile:GetAim()
        return v1769
    end

    if a0.ClassicController and a0.ClassicController:IsGamepad() then
        local v1770 = a0.ClassicController:GetAim()
        return v1770
    end

    if a0.TouchEnabled then
        local v1771, v1772 = a0:GetMobileAim(nil, true)
        return v1771, v1772 and v1772.Instance or nil
    end

    return a0.Mouse.Hit, a0.Mouse.Target
end

getBobbing.GetClassicBuildAim = GetClassicBuildAim

local function GetClassicBuildPointerPosition(a0) --[[ Upvalues: UserInputService (copy) ]]
    if a0.ClassicMobile and a0.ClassicMobile:IsActive() then
        return workspace.CurrentCamera.ViewportSize / 2
    end

    if a0.ClassicController and a0.ClassicController:IsGamepad() then
        return workspace.CurrentCamera.ViewportSize / 2
    end

    if a0.TouchEnabled then
        local v1774 = a0.HUD and a0.HUD:FindFirstChild("MobileMouse")
        if v1774 then
            return v1774.AbsolutePosition + v1774.AbsoluteSize / 2
        end
    end

    local v1775 = UserInputService:GetMouseLocation()
    return v1775
end

getBobbing.GetClassicBuildPointerPosition = GetClassicBuildPointerPosition

local function IsClassicBuildPointerOverGui(a0)
    if a0.DesktopCatalogue and a0.DesktopCatalogue:IsPointerOver() then
        return true
    end

    if a0.ClassicDesktop and a0.ClassicDesktop:IsPointerOver() then
        return true
    end

    local v1777 = a0.Player and a0.Player:FindFirstChildOfClass("PlayerGui")
    if not v1777 then
        return false
    end

    local v1778 = v1777:GetGuiObjectsAtPosition(a0.Mouse.X, a0.Mouse.Y)
    for k212, k213 in ipairs(v1778) do
        local v1782 = k213
        while v1782 do
            if v1782 == v1777 then
                break
            end

            if v1782:IsA("GuiObject") then
                if v1782.Visible then
                    if v1782:IsA("GuiButton") then
                        return true
                    end

                    if v1782:IsA("TextBox") then
                        return true
                    end

                    if v1782.Active then
                        return true
                    end

                    if v1782:IsA("ScrollingFrame") then
                        if v1782.ScrollingEnabled then
                            return true
                        end
                    end
                end
            end

            v1782 = v1782.Parent
        end
    end

    return false
end

getBobbing.IsClassicBuildPointerOverGui = IsClassicBuildPointerOverGui

local function ActivateClassicBuildObject(a0) --[[ Upvalues: UserInputService (copy), GuiService (copy) ]]
    if a0.ClassicDesktop and a0.ClassicDesktop.Busy then
        return false
    end

    if not a0.ClassicBuildActive or not a0.EditingBase or a0.Painting or a0.BuildModeKind ~= "Objects" or UserInputService.PreferredInput ~= Enum.PreferredInput.KeyboardAndMouse or a0.DeleteAllConfirmOpen or a0.PaintResetConfirmOpen or GuiService.MenuIsOpen or UserInputService:GetFocusedTextBox() or a0:IsClassicBuildPointerOverGui() then
        return false
    end

    if not a0.EditObject then
        if not a0.DeletingObjects then
            local v1783 = a0:GetClassicBuildPointerPosition()
            local v1784 = a0:GetPlacedBuildObjectAtScreenPosition(v1783)
            local v1787 = v1784 ~= nil and a0:SelectPlacedBuildObject(v1784) or false
            return v1787
        end
    end

    local v1788 = a0:PlaceClassicBuildObject()
    return v1788
end

getBobbing.ActivateClassicBuildObject = ActivateClassicBuildObject

local function DeleteClassicBuildTarget(a0, a1) --[[ Upvalues: RemoteEvent (copy) ]]
    if a0.ClassicController and a0.ClassicController:BlocksWorld() then
        return false
    end

    if a0.ClassicMobile and a0.ClassicMobile:BlocksWorld() then
        return false
    end

    if not a0.ClassicBuildActive or a0.BuildModeKind ~= "Objects" or a0.Painting or a0.DeletingObjects ~= true then
        return false
    end

    local v1789
    if a1 ~= nil then
        if not a0.EditingBase then
            return false
        end

        v1789 = a0:ResolvePlacedBuildObject(a1)
        if v1789 ~= a1 then
            return false
        end

        local CurrentCamera11 = workspace.CurrentCamera
        if not CurrentCamera11 then
            return false
        end

        local v1790, v1791 = v1789:GetBoundingBox()
        local v1792 = v1790:PointToObjectSpace(CurrentCamera11.CFrame.Position)
        v1790 = v1791 / 2
        local v1793 = -v1790.X
        local v1794 = math.clamp(v1792.X, v1793, v1790.X)
        local v1795 = -v1790.Y
        local v1796 = math.clamp(v1792.Y, v1795, v1790.Y)
        local v1797 = -v1790.Z
        if 500 < (v1792 - Vector3.new(v1794, v1796, math.clamp(v1792.Z, v1797, v1790.Z))).Magnitude then
            return false
            -- branch continues at 132
        end
    else
        local v1798 = a0:GetClassicBuildPointerPosition()
        v1789 = a0:GetPlacedBuildObjectAtScreenPosition(v1798)
    end

    if not v1789 then
        return false
    end

    local v1799 = os.clock() - (a0.BuildDeleteAt or 0)
    if v1799 < 0.15 then
        return false
    end

    a0.BuildDeleteAt = os.clock()
    if a0.ClassicController then
        if a0.ClassicController:IsGamepad() then
            local v1800 = a0.ClassicController:Delete(v1789)
            local v1801 = false
            if v1800 ~= nil then
                v1801 = v1800.ok == true
            end

            return v1801
        end
    end

    if a0.ClassicMobile then
        if a0.ClassicMobile:IsActive() then
            local v1802 = a0.ClassicMobile:Delete(v1789)
            local v1803 = false
            if v1802 ~= nil then
                v1803 = v1802.ok == true
            end

            return v1803
        end
    end

    if a0.ClassicDesktop then
        if a0.ClassicDesktop:IsActive() then
            local v1804 = a0.ClassicDesktop:Delete(v1789)
            local v1805 = false
            if v1804 ~= nil then
                v1805 = v1804.ok == true
            end

            return v1805
        end
    end

    RemoteEvent:FireServer("DeleteBaseObject", v1789)
    a0:ClearBuildObjectHover()
    return true
end

getBobbing.DeleteClassicBuildTarget = DeleteClassicBuildTarget

local function CanPlaceClassicBuildObject(a0) --[[ Upvalues: v6 (copy) ]]
    local EditObject2 = a0.EditObject
    if not EditObject2 then
        return false, "Choose an object from the catalogue"
    end

    local v1806 = a0:GetClassicBuildAim()
    if not v1806 then
        return false, "Aim at a surface inside your base"
    end

    local v1807 = a0:CalcPlacementCFrame(v1806.Position)
    EditObject2:PivotTo(v1807)
    if not a0:IsBuildObjectInBounds(EditObject2) then
        return false, "Keep the whole object inside your base"
    end

    local v1808 = EditObject2:GetPivot()
    if a0:HasBuildObjectAtCFrame(v1808) then
        return false, "An object already occupies this position"
    end

    if a0.EditingExistingObject then
        return true
    end

    v1806 = v6[EditObject2.Name]
    if not v1806 then
        return false, "This object is unavailable"
    end

    local Data8 = a0.Data
    if not Data8 then
        Data8 = {}
    end

    if v1806.Unlock then
        v1808 = Data8.UnlockedObjects
        if not v1808 then
            v1808 = {}
        end

        if not v1808[EditObject2.Name] then
            return false, "This object is locked"
        end
    end

    if v1806.ItemObject then
        local BaseItems2 = Data8.BaseItems
        if not BaseItems2 then
            BaseItems2 = {}
        end

        local v1809 = BaseItems2[EditObject2.Name] or 0
        if v1809 < 1 then
            return false, "No copies remaining"
        end
    end

    if not v1806.ItemObject then
        local v1810 = tonumber(Data8.Money) or 0
        if v1810 < (tonumber(v1806.Price) or 0) then
            return false, "Not enough money"
        end
    end

    local v1811 = a0:GetStorageCapacity()
    local v1812 = v1811 + (v1806.Capacity or 1)
    if a0:GetStorageCapacityLimit() < v1812 then
        return false, "Your base is full"
    end

    return true
end

getBobbing.CanPlaceClassicBuildObject = CanPlaceClassicBuildObject

local function PlaceClassicBuildObject(a0)
    if a0.ClassicController and a0.ClassicController:BlocksWorld() then
        return false
    end

    if a0.ClassicMobile and a0.ClassicMobile:BlocksWorld() then
        return false
    end

    if not a0.ClassicBuildActive or a0.Painting or a0.BuildModeKind ~= "Objects" then
        return false
    end

    if a0.DeletingObjects then
        local v1813 = a0:DeleteClassicBuildTarget()
        return v1813
    end

    local v1814, v1815 = a0:CanPlaceClassicBuildObject()
    if not v1814 then
        if a0.ClassicMobile and a0.ClassicMobile:IsActive() then
            a0.ClassicMobile.Status = v1815
        else
            local v1816 = {Title = "Can't place object", Duration = 2, Text = v1815}
            a0:Noti(v1816)
        end

        return false
    end

    local v1817 = a0:GetClassicBuildAim()
    if not v1817 then
        return false
    end

    v1814 = a0:CalcPlacementCFrame(v1817.Position)
    a0.EditObject:PivotTo(v1814)
    a0:PlaceBaseObject(v1814)
    return true
end

getBobbing.PlaceClassicBuildObject = PlaceClassicBuildObject

local function ToggleClassicDesktopPaint(a0) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    if not a0.ClassicBuildActive or not a0.BuildCameraActive or not a0:IsDesktopBuildCatalogue() or a0.BuildSystemSwitching or a0.DeleteAllConfirmOpen or a0.PaintResetConfirmOpen or GuiService.MenuIsOpen or UserInputService:GetFocusedTextBox() then
        return false
    end

    if a0.Painting then
        a0:ClosePaintFrames()
        return true
    end

    if a0.BuildModeKind ~= "Objects" then
        return false
    end

    local v1818 = a0:OpenPaintFrames()
    return v1818
end

getBobbing.ToggleClassicDesktopPaint = ToggleClassicDesktopPaint

local function GetClassicDesktopRotateStep(a0)
    local ClassicDesktopRotateStep = a0.ClassicDesktopRotateStep
    if ClassicDesktopRotateStep == 5 or ClassicDesktopRotateStep == 15 or ClassicDesktopRotateStep == 30 or ClassicDesktopRotateStep == 45 or ClassicDesktopRotateStep == 90 then
        return ClassicDesktopRotateStep
    end

    return 90
end

getBobbing.GetClassicDesktopRotateStep = GetClassicDesktopRotateStep

local function CycleClassicDesktopRotateStep(a0) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    if not a0.ClassicBuildActive or not a0.BuildCameraActive or not a0:IsDesktopBuildCatalogue() or a0.BuildModeKind ~= "Objects" or a0.Painting or a0.BuildSystemSwitching or a0.DeleteAllConfirmOpen or a0.PaintResetConfirmOpen or GuiService.MenuIsOpen or UserInputService:GetFocusedTextBox() then
        return false
    end

    local v1819 = {[5] = 15, [15] = 30, [30] = 45, [45] = 90, [90] = 5}
    a0.ClassicDesktopRotateStep = v1819[a0:GetClassicDesktopRotateStep()]
    if a0.DesktopCatalogue then
        a0.DesktopCatalogue:RefreshSelection()
    end

    return true
end

getBobbing.CycleClassicDesktopRotateStep = CycleClassicDesktopRotateStep

local function RotateClassicBuildObject(a0, a1, a2, a3)
    if not a0.EditObject then
        return
    end

    local v1822 = type(a3) == "number" and a3 == a3 and 0 < a3 and a3 <= 360 and a3 or 90
    if a1 == "Y" then
        a0.EditObjectRotate = ((a0.EditObjectRotate or 0) + (a2 and a2 < 0 and -v1822 or v1822)) % 360
        return
    end

    if a1 == "Z" then
        a0.EditObjectFlip = ((a0.EditObjectFlip or 0) + (a2 and a2 < 0 and -v1822 or v1822)) % 360
        return
    end

    if a1 == "X" then
        a0.EditObjectFlip2 = ((a0.EditObjectFlip2 or 0) + (a2 and a2 < 0 and -v1822 or v1822)) % 360
    end
end

getBobbing.RotateClassicBuildObject = RotateClassicBuildObject

local function DisconnectClassicBuildInputs(a0) --[[ Upvalues: ContextActionService (copy) ]]
    a0:SetClassicDesktopBuildClutterHidden(false)
    a0:EndClassicBuildMouseDrag()
    local ClassicDesktop1 = a0.ClassicDesktop
    a0.ClassicDesktop = nil
    if ClassicDesktop1 then
        ClassicDesktop1:Destroy()
    end

    ClassicDesktop1 = a0.ClassicMobile
    a0.ClassicMobile = nil
    if ClassicDesktop1 then
        ClassicDesktop1:Destroy()
    end

    if a0.ClassicController then
        a0.ClassicController:Destroy()
        a0.ClassicController = nil
    end

    if a0.ClassicBuildActive then
        a0.DeletingObjects = false
    end

    local ClassicBuildLabelText = a0.ClassicBuildLabelText
    if not ClassicBuildLabelText then
        ClassicBuildLabelText = {}
    end

    for k214, k215 in pairs(ClassicBuildLabelText) do
        if k214.Parent then
            k214.Text = k215
        end
    end

    a0.ClassicBuildLabelText = nil
    k215 = "flip"
    local v1828 = {
        "rotate",
        k215,
        "flip2",
        "place",
        "delete",
        "deleteMode",
        "deselect",
        "classicRotateStep",
        "classicPaint"
    }
    for k216, k217 in ipairs(v1828) do
        ContextActionService:UnbindAction(k217)
    end

    if a0.ClassicBuildCons then
        for k218, k219 in ipairs(a0.ClassicBuildCons) do
            k219:Disconnect()
        end

        a0.ClassicBuildCons = nil
    end

    if a0.ClassicBuildInputStates then
        for k220, k221 in pairs(a0.ClassicBuildInputStates) do
            if k220 and k220.Parent then
                pcall(function() --[[ Upvalues: k220 (copy), k221 (copy) ]]
                    k220.Enabled = k221
                end)
            end
        end

        a0.ClassicBuildInputStates = nil
    end

    if a0.ClassicBuildGuiVisibility then
        for k222, k223 in pairs(a0.ClassicBuildGuiVisibility) do
            if k222 and k222.Parent then
                k222.Visible = k223
            end
        end

        a0.ClassicBuildGuiVisibility = nil
    end

    if a0.BuildGui then
        k217 = "TransformPanel"
        local v1841 = {"Toolbar", k217, "ViewPanel", "Hint"}
        for k224, k225 in ipairs(v1841) do
            ClassicDesktop1 = a0.BuildGui:FindFirstChild(k225)
            if ClassicDesktop1 and ClassicDesktop1:IsA("GuiObject") then
                ClassicDesktop1.Visible = true
            end
        end
    end

    if a0.HUD then
        a0.HUD.MobileEdits.Visible = false
        a0.HUD.MobileMouse.Visible = false
        local BaseObjects4 = a0.HUD:FindFirstChild("BaseObjects")
        local v1846 = BaseObjects4 and BaseObjects4:FindFirstChild("Hotkeys")
        if v1846 then
            v1846.Visible = false
        end
    end
end

getBobbing.DisconnectClassicBuildInputs = DisconnectClassicBuildInputs

local function CanClassicBuildMouseDrag(a0) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    local v1847 = false
    if a0.ClassicBuildActive == true then
        v1847 = false
        if a0.BuildCameraActive == true then
            v1847 = not a0.BuildSystemSwitching
            if v1847 then
                v1847 = not a0.DeleteAllConfirmOpen
                if v1847 then
                    v1847 = not a0.PaintResetConfirmOpen
                    if v1847 then
                        v1847 = not GuiService.MenuIsOpen
                        if v1847 then
                            local v1848 = a0:IsDesktopBuildCatalogue()
                            if v1848 then
                                v1848 = not UserInputService:GetFocusedTextBox()
                                if v1848 then
                                    local v1850 = a0.ClassicController and a0.ClassicController:BlocksWorld()
                                    v1848 = not v1850
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return v1847
end

getBobbing.CanClassicBuildMouseDrag = CanClassicBuildMouseDrag

local function EndClassicBuildMouseDrag(a0) --[[ Upvalues: RunService (copy), UserInputService (copy) ]]
    a0.ClassicBuildRightMouse = nil
    RunService:UnbindFromRenderStep("StorageClassicDesktopMouseDrag")
    if not a0.ClassicBuildMouseDragging then
        return
    end

    a0.ClassicBuildMouseDragging = nil
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end

getBobbing.EndClassicBuildMouseDrag = EndClassicBuildMouseDrag

local function StepClassicBuildMouseDrag(a0) --[[ Upvalues: UserInputService (copy) ]]
    if not a0.ClassicBuildMouseDragging then
        return
    end

    if not (a0:CanClassicBuildMouseDrag() and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)) then
        a0:EndClassicBuildMouseDrag()
        return
    end

    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
end

getBobbing.StepClassicBuildMouseDrag = StepClassicBuildMouseDrag

local function BeginClassicBuildMouseDrag(a0) --[[ Upvalues: UserInputService (copy), RunService (copy) ]]
    a0.ClassicBuildMouseDragging = true
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
    local v1851 = Enum.RenderPriority.Camera.Value + 2
    RunService:BindToRenderStep("StorageClassicDesktopMouseDrag", v1851, function() --[[ Upvalues: a0 (copy) ]]
        a0:StepClassicBuildMouseDrag()
    end)
end

getBobbing.BeginClassicBuildMouseDrag = BeginClassicBuildMouseDrag

local function HandleClassicBuildRightMouse(a0, a1) --[[ Upvalues: UserInputService (copy) ]]
    local ClassicBuildRightMouse = a0.ClassicBuildRightMouse
    local v1854 = a0:CanClassicBuildMouseDrag() and not a0:IsClassicBuildPointerOverGui()
    local v1855 = v1854
    if v1855 then
        v1855 = false
        if a0.DeletingObjects == true then
            v1855 = false
            if a0.BuildModeKind == "Objects" then
                v1855 = not a0.Painting
            end
        end
    end

    if a1 == Enum.UserInputState.Begin then
        a0:EndClassicBuildMouseDrag()
        if v1854 then
            a0:BeginClassicBuildMouseDrag()
        end

        if v1855 then
            local v1857 = a0:GetClassicBuildPointerPosition()
            local v1858 = a0:GetPlacedBuildObjectAtScreenPosition(v1857)
            if v1858 then
                local v1859 = {
                    Travel = 0,
                    Target = v1858,
                    StartedAt = os.clock(),
                    Position = UserInputService:GetMouseLocation()
                }
                a0.ClassicBuildRightMouse = v1859
                -- branch continues at 129
            end

            -- branch continues at 129
        end
    else
        if a1 == Enum.UserInputState.End or a1 == Enum.UserInputState.Cancel then
            a0:EndClassicBuildMouseDrag()
            if a1 == Enum.UserInputState.End then
                if ClassicBuildRightMouse then
                    if v1855 then
                        local v1863 = os.clock() - ClassicBuildRightMouse.StartedAt
                        if v1863 <= 0.25 then
                            if ClassicBuildRightMouse.Travel <= 6 then
                                local v1866 = UserInputService:GetMouseLocation()
                                if (v1866 - ClassicBuildRightMouse.Position).Magnitude <= 6 then
                                    local v1869 = a0:GetClassicBuildPointerPosition()
                                    local v1870 = a0:GetPlacedBuildObjectAtScreenPosition(v1869)
                                    if v1870 == ClassicBuildRightMouse.Target then
                                        a0:DeleteClassicBuildTarget(ClassicBuildRightMouse.Target)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return Enum.ContextActionResult.Pass
end

getBobbing.HandleClassicBuildRightMouse = HandleClassicBuildRightMouse

local function ConnectClassicBuildInputs(a0) --[[ Upvalues: RemoteEvent (copy), UserInputService (copy), GuiService (copy), ContextActionService (copy), v17 (copy) ]]
    a0:DisconnectClassicBuildInputs()
    a0.ClassicBuildCons = {}
    a0.ClassicBuildInputStates = {}
    a0.ClassicBuildLabelText = {}
    local v1871 = a0.HUD and a0.HUD:FindFirstChild("MobileEdits")
    local v1872 = a0.HUD and a0.HUD:FindFirstChild("BaseObjects")
    local v1874 = v1872 and v1872:FindFirstChild("Hotkeys")
    local v1875 = "Place"
    local v1876 = {"Delete", v1875, "DeleteMode", "Deselect"}
    for k226, k227 in ipairs(v1876) do
        local v1881 = v1871 and v1871:FindFirstChild(k227)
        local v1883 = v1881 and v1881:FindFirstChild("ActionTitle")
        if v1883 then
            a0.ClassicBuildLabelText[v1883] = v1883.Text
        end

        local v1885 = v1874 and v1874:FindFirstChild(k227)
        if v1885 and v1885:IsA("TextLabel") then
            a0.ClassicBuildLabelText[v1885] = v1885.Text
        end
    end

    k227 = "Action2"
    local v1886 = {"Action", k227, "Block", "Reload"}
    for k228, k229 in ipairs(v1886) do
        local v1891 = a0.MainContext and a0.MainContext:FindFirstChild(k229)
        if v1891 then
            local v1892, v1893 = pcall(function() --[[ Upvalues: v1891 (copy) ]]
                return v1891.Enabled
            end)
            if v1892 then
                a0.ClassicBuildInputStates[v1891] = v1893
                v1891.Enabled = false
            end
        end
    end

    RemoteEvent:FireServer("M1U")
    RemoteEvent:FireServer("M2U", a0.TouchEnabled)
    a0.ClassicBuildGuiVisibility = {}
    if a0.BuildGui then
        k229 = "TransformPanel"
        local v1894 = {
            "Toolbar",
            k229,
            "ViewPanel",
            "Hint",
            "ControllerHotkeys",
            "MobileCameraContols"
        }
        for k230, k231 in ipairs(v1894) do
            v1871 = a0.BuildGui:FindFirstChild(k231)
            if v1871 and v1871:IsA("GuiObject") then
                a0.ClassicBuildGuiVisibility[v1871] = v1871.Visible
            end
        end
    end

    local function cancelRightClick() --[[ Upvalues: a0 (copy) ]]
        a0.ClassicBuildRightMouse = nil
    end

    local v1898 = UserInputService.InputChanged:Connect(function(a0) --[[ Upvalues: a0 (copy) ]]
        local ClassicBuildRightMouse1 = a0.ClassicBuildRightMouse
        if ClassicBuildRightMouse1 and a0.UserInputType == Enum.UserInputType.MouseMovement then
            ClassicBuildRightMouse1.Travel = ClassicBuildRightMouse1.Travel + a0.Delta.Magnitude
            if 6 < ClassicBuildRightMouse1.Travel then
                a0.ClassicBuildRightMouse = nil
            end
        end

    end)
    table.insert(a0.ClassicBuildCons, v1898)

    local function cancelRightMouse() --[[ Upvalues: a0 (copy) ]]
        a0:EndClassicBuildMouseDrag()
    end

    local v1899 = UserInputService.WindowFocusReleased:Connect(cancelRightMouse)
    table.insert(a0.ClassicBuildCons, v1899)
    local v1900 = UserInputService.TextBoxFocused:Connect(cancelRightMouse)
    table.insert(a0.ClassicBuildCons, v1900)
    local v1901 = GuiService.MenuOpened:Connect(cancelRightMouse)
    table.insert(a0.ClassicBuildCons, v1901)
    local v1902 = UserInputService:GetPropertyChangedSignal("PreferredInput")
    local v1903 = v1902:Connect(function() --[[ Upvalues: a0 (copy), UserInputService (upvalue) ]]
        a0:EndClassicBuildMouseDrag()
        if a0.EditingExistingObject and UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
            a0:DeleteEditObject()
        end

        a0:ApplyClassicBuildPresentation()
    end)
    table.insert(a0.ClassicBuildCons, v1903)

    local function handleAction1(a0, a1, a2) --[[ Upvalues: a0 (copy), UserInputService (upvalue), GuiService (upvalue) ]]
        if a0 == "delete" then
            local v1904 = a0:HandleClassicBuildRightMouse(a1)
            return v1904
        end

        if a0 == "classicPaint" then
            if a1 ~= Enum.UserInputState.Begin or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt) then
                return Enum.ContextActionResult.Pass
            end

            local v1905 = a0:ToggleClassicDesktopPaint() and Enum.ContextActionResult.Sink or Enum.ContextActionResult.Pass
            return v1905
        end

        if not a0.ClassicBuildActive or a0.Painting or a0.BuildModeKind ~= "Objects" then
            return Enum.ContextActionResult.Pass
        end

        if a0.ClassicDesktop and a0.ClassicDesktop.Busy then
            return Enum.ContextActionResult.Sink
        end

        if a0.DeleteAllConfirmOpen or a0.PaintResetConfirmOpen or GuiService.MenuIsOpen then
            return Enum.ContextActionResult.Pass
        end

        if UserInputService:GetFocusedTextBox() then
            return Enum.ContextActionResult.Pass
        end

        if not (a0.ClassicMobile and a0.ClassicMobile:IsActive()) then
            if a0.ClassicController then
                if a0.ClassicController:IsGamepad() then
                    return Enum.ContextActionResult.Pass
                end

                if not a0.ClassicController:BlocksWorld() then
                    -- jump to 162
                end

                -- branch continues at 162
            end
        end

        return Enum.ContextActionResult.Pass
        if a1 ~= Enum.UserInputState.Begin then
            return Enum.ContextActionResult.Sink
        end

        if a0 == "place" then
            if a0:IsClassicBuildPointerOverGui() then
                return Enum.ContextActionResult.Pass
            end

            local v1906 = a0.BuildGui and a0.BuildGui:FindFirstChild("BuildSystemToggle")
            if v1906 then
                if v1906.Visible then
                    local v1907 = GuiService.SelectedObject == v1906
                    if not v1907 then
                        if a2 then
                            if a2.UserInputType == Enum.UserInputType.MouseButton1 then
                                local v1908 = UserInputService:GetMouseLocation()
                                local AbsolutePosition3 = v1906.AbsolutePosition
                                local AbsoluteSize3 = v1906.AbsoluteSize
                                local v1909 = false
                                if AbsolutePosition3.X <= v1908.X then
                                    v1909 = false
                                    if AbsolutePosition3.Y <= v1908.Y then
                                        v1909 = false
                                        if v1908.X <= AbsolutePosition3.X + AbsoluteSize3.X then
                                            v1909 = v1908.Y <= AbsolutePosition3.Y + AbsoluteSize3.Y
                                        end
                                    end
                                end

                                v1907 = v1909
                            end
                        end
                    end

                    if v1907 then
                        return Enum.ContextActionResult.Pass
                    end
                end
            end

            a0:ActivateClassicBuildObject()
        else
            if a0 == "deleteMode" then
                if UserInputService:GetFocusedTextBox() then
                    return Enum.ContextActionResult.Pass
                end

                a0:SetDeletingObjects(not a0.DeletingObjects)
            else
                if a0 == "deselect" then
                    a0:DeleteEditObject()
                else
                    if a0 == "classicRotateStep" then
                        a0:CycleClassicDesktopRotateStep()
                    else
                        if a0 == "rotate" then
                            local v1910 = a0:GetClassicDesktopRotateStep()
                            a0:RotateClassicBuildObject("Y", 1, v1910)
                        else
                            if a0 == "flip" then
                                local v1911 = a0:GetClassicDesktopRotateStep()
                                a0:RotateClassicBuildObject("Z", 1, v1911)
                            else
                                if a0 == "flip2" then
                                    local v1912 = a0:GetClassicDesktopRotateStep()
                                    a0:RotateClassicBuildObject("X", 1, v1912)
                                end
                            end
                        end
                    end
                end
            end
        end

        return Enum.ContextActionResult.Sink
    end

    local v1913 = Enum.ContextActionPriority.High.Value + 50
    ContextActionService:BindActionAtPriority("place", handleAction1, false, v1913, Enum.UserInputType.MouseButton1)
    ContextActionService:BindActionAtPriority("delete", handleAction1, false, v1913, Enum.UserInputType.MouseButton2)
    ContextActionService:BindActionAtPriority("deleteMode", handleAction1, false, v1913, Enum.KeyCode.F)
    ContextActionService:BindActionAtPriority("deselect", handleAction1, false, v1913, Enum.KeyCode.E)
    ContextActionService:BindActionAtPriority("rotate", handleAction1, false, v1913, Enum.KeyCode.R)
    ContextActionService:BindActionAtPriority("flip", handleAction1, false, v1913, Enum.KeyCode.T)
    ContextActionService:BindActionAtPriority("flip2", handleAction1, false, v1913, Enum.KeyCode.Y)
    ContextActionService:BindActionAtPriority("classicRotateStep", handleAction1, false, v1913, Enum.KeyCode.G)
    local v1914 = handleAction1
    local v1915 = false
    ContextActionService:BindActionAtPriority("classicPaint", v1914, v1915, v1913, Enum.KeyCode.P)
    local v1916 = a0.HUD and a0.HUD:FindFirstChild("MobileEdits")
    if v1916 then

        local function Place3() --[[ Upvalues: a0 (copy) ]]
            a0:PlaceClassicBuildObject()
        end

        local function Delete2() --[[ Upvalues: a0 (copy) ]]
            a0:SetDeletingObjects(not a0.DeletingObjects)
        end

        local function Rotate() --[[ Upvalues: a0 (copy) ]]
            a0:RotateClassicBuildObject("Y")
        end

        local function Flip() --[[ Upvalues: a0 (copy) ]]
            a0:RotateClassicBuildObject("Z")
        end

        local function Flip2() --[[ Upvalues: a0 (copy) ]]
            a0:RotateClassicBuildObject("X")
        end

        local function Deselect1() --[[ Upvalues: a0 (copy) ]]
            a0:DeleteEditObject()
        end

        handleAction1 = {
            Place = Place3,
            Delete = Delete2,
            Rotate = Rotate,
            Flip = Flip,
            Flip2 = Flip2,
            Deselect = Deselect1
        }
        for k232, k233 in pairs(handleAction1) do
            local v1920 = v1916:FindFirstChild(k232)
            if v1920 and v1920:IsA("GuiButton") then
                local v1921 = v1920.Activated:Connect(function() --[[ Upvalues: a0 (copy), k233 (copy) ]]
                    if a0.ClassicBuildActive then
                        if not a0.Painting then
                            if a0.BuildModeKind == "Objects" then
                                if not (a0.ClassicMobile and a0.ClassicMobile:IsActive()) then
                                    k233()
                                end
                            end
                        end
                    end

                end)
                table.insert(a0.ClassicBuildCons, v1921)
            end
        end
    end

    a0.ClassicController = v17.Controller.Start(a0)
    a0.ClassicMobile = v17.Mobile.Start(a0)
    a0.ClassicDesktop = v17.Desktop.Start(a0)
    a0:ApplyClassicBuildPresentation()
end

getBobbing.ConnectClassicBuildInputs = ConnectClassicBuildInputs

local function BeginBuildMode(a0, a1, a2) --[[ Upvalues: UserInputService (copy), GuiService (copy), GamepadService (copy), RemoteEvent (copy), v7 (copy), RunService (copy) ]]
    if a0.BuildCameraActive then
        return false
    end

    if not a0:SetupBuildGui() then
        a0:Noti({Title = "Build Mode", Text = "The build interface could not be loaded.", Duration = 2})
        return false
    end

    local CurrentCamera12 = workspace.CurrentCamera
    local v1922, v1923 = a0:GetBuildReference()
    if not v1923 then
        a0:Noti({Title = "Build Mode", Text = "Your base bounds could not be found.", Duration = 2})
        return false
    end

    local v1924 = a2
    if not v1924 then
        v1924 = {
            CameraType = CurrentCamera12.CameraType,
            CameraSubject = CurrentCamera12.CameraSubject,
            CameraCFrame = CurrentCamera12.CFrame,
            FieldOfView = CurrentCamera12.FieldOfView,
            MouseBehavior = UserInputService.MouseBehavior,
            MouseIconEnabled = UserInputService.MouseIconEnabled,
            MainContextEnabled = a0.MainContext.Enabled,
            SelectedObject = GuiService.SelectedObject,
            GamepadCursorEnabled = GamepadService.GamepadCursorEnabled
        }
    end

    a0.BuildCameraSaved = v1924
    a0.BuildCameraActive = true
    a0:SetBuildPanelToggleHidden(true)
    a0.ClassicBuildActive = a0:IsClassicBuildSystem()
    a0.BuildModeKind = a1 or "Objects"
    a0.BuildTransformMode = a0.BuildTransformMode or "Move"
    a0.BuildMoveStep = a0.BuildMoveStep or 0.5
    a0.BuildRotateStep = a0.BuildRotateStep or 15
    if a0.BuildGridEnabled == nil then
        a0.BuildGridEnabled = true
    end

    a0.BuildGridOffsets = {}
    a0.BuildGridFloor = nil
    a0.BuildGui.Enabled = true
    if a0.ClassicBuildActive then
        a0.DeletingObjects = false
        a0:SetBuildClutterHidden(false)
        a0.BuildCameraLocked = false
        a0.BuildGamepadNavigation = false
        a0.BuildGamepadNavigationBeforeCameraLock = nil
        a0.BuildCameraLockManagedGamepadNavigation = nil
        a0:EndBuildTouchGizmoDrag()
        a0:EndBuildTransformHold()
        a0:ClearBuildMobileCameraInputs()
        a0:UpdateBuildMobileCameraControlsVisibility(false)
        a0:SetBuildGamepadNavigation(false)
        a0.BuildSurfaceParts = nil
        a0:DestroyBuildGrid()
        a0:HideBuildGizmos()
        v1923 = a0.BuildCameraSaved
        if v1923 then
            a0.MainContext.Enabled = v1923.MainContextEnabled
            UserInputService.MouseBehavior = v1923.MouseBehavior
            UserInputService.MouseIconEnabled = v1923.MouseIconEnabled
            CurrentCamera12.FieldOfView = v1923.FieldOfView
        else
            a0.MainContext.Enabled = true
        end

        if GamepadService.GamepadCursorEnabled then
            pcall(function() --[[ Upvalues: GamepadService (upvalue) ]]
                GamepadService:DisableGamepadCursor()
            end)
        end

        CurrentCamera12.CameraType = Enum.CameraType.Custom
        if a0.Humanoid then
            CurrentCamera12.CameraSubject = a0.Humanoid
        end

        a0:ConnectClassicBuildInputs()
        RemoteEvent:FireServer("SetBuildMode", true, a0.BuildModeKind)
        a0:UpdateBuildGui()
        return true
    end

    a0:SetBuildClutterHidden(true)
    a0.MainContext.Enabled = false
    CurrentCamera12.CameraType = Enum.CameraType.Scriptable
    CurrentCamera12.FieldOfView = 55
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true
    a0.BuildCameraLocked = false
    a0.BuildGamepadNavigation = false
    a0.BuildGamepadNavigationBeforeCameraLock = nil
    a0.BuildCameraLockManagedGamepadNavigation = nil
    a0:EndBuildTouchGizmoDrag()
    a0:EndBuildTransformHold()
    a0:ClearBuildMobileCameraInputs()
    a0:UpdateBuildMobileCameraControlsVisibility(true)
    a0:SetBuildGamepadNavigation(false)
    if a0.BuildModeKind ~= "Paint" then
        a0:CacheBuildSurfaceParts()
    end

    a0:SetBuildView("Iso")
    if a0.BuildModeKind ~= "Paint" then
        a0:RebuildBuildGrid()
    end

    a0:ConnectBuildInputs()
    a0:BindBuildObjectDPad()
    a0.ModernController = v7.Controller.Start(a0)
    a0.ModernMobile = v7.Mobile.Start(a0)
    a0.ModernDesktop = v7.Desktop.Start(a0)
    RunService:UnbindFromRenderStep("BuildCamera")
    local v1925 = Enum.RenderPriority.Camera.Value + 10
    RunService:BindToRenderStep("BuildCamera", v1925, function(a0) --[[ Upvalues: a0 (copy) ]]
        a0:StepBuildCamera(a0)
    end)
    RemoteEvent:FireServer("SetBuildMode", true, a0.BuildModeKind)
    a0:UpdateBuildGui()
    return true
end

getBobbing.BeginBuildMode = BeginBuildMode

local function SetBuildModeKind(a0, a1) --[[ Upvalues: RemoteEvent (copy) ]]
    a0:EndClassicBuildMouseDrag()
    if not a0.BuildCameraActive then
        return false
    end

    local v1926
    if a1 == "Paint" then
        v1926 = "Paint"
    else
        v1926 = "Objects"
    end

    a1 = v1926
    if a0.BuildModeKind == a1 then
        a0:UpdateBuildGui()
        return true
    end

    a0:SetDeleteAllConfirmation(false)
    a0:EndBuildTouchGizmoDrag()
    a0:EndDirectBuildDrag()
    a0.BuildPendingTouchSelection = nil
    a0:ClearBuildObjectHover()
    a0.BuildGizmoDragging = nil
    a0.BuildModeKind = a1
    if a1 == "Paint" then
        local v1928 = a0.ModernMobile and a0.ModernMobile:SuspendPreview()
        if not v1928 then
            local v1930 = a0.ModernController and a0.ModernController:SuspendPreview()
            v1928 = v1930
        end

        if not v1928 then
            a0:DeleteEditObject()
        end

        a0:SetDeletingObjects(false)
        a0:DestroyBuildGrid()
        a0.BuildSurfaceParts = nil
        a0:HideBuildGizmos()
    else
        if a0.ClassicBuildActive then
            a0:DestroyBuildGrid()
            a0.BuildSurfaceParts = nil
            a0:HideBuildGizmos()
        else
            a0:CacheBuildSurfaceParts()
            a0:RebuildBuildGrid()
        end
    end

    if a1 == "Objects" and a0.ModernMobile then
        a0.ModernMobile:ResumePreview()
    end

    if a1 == "Objects" and a0.ModernController then
        a0.ModernController:ResumePreview()
    end

    RemoteEvent:FireServer("SetBuildMode", true, a1)
    a0:UpdateBuildGui()
    return true
end

getBobbing.SetBuildModeKind = SetBuildModeKind

local function EndBuildMode(a0, a1) --[[ Upvalues: RunService (copy), RemoteEvent (copy), ContextActionService (copy), UserInputService (copy), GuiService (copy), GamepadService (copy) ]]
    if not a0.BuildCameraActive then
        return
    end

    local ModernDesktop1 = a0.ModernDesktop
    a0.ModernDesktop = nil
    if ModernDesktop1 then
        ModernDesktop1:Destroy()
    end

    ModernDesktop1 = a0.ModernMobile
    a0.ModernMobile = nil
    if ModernDesktop1 then
        ModernDesktop1:Destroy()
    end

    ModernDesktop1 = a0.ModernController
    a0.ModernController = nil
    if ModernDesktop1 then
        ModernDesktop1:Destroy()
    end

    a0:EndBuildMouseCameraDrag()
    ModernDesktop1 = a0.ClassicBuildActive == true
    a0:SetDeleteAllConfirmation(false)
    a0:UnbindBuildObjectDPad()
    a0:EndBuildTouchGizmoDrag()
    a0:EndBuildTransformHold()
    a0:ClearBuildMobileCameraInputs()
    a0:UpdateBuildMobileCameraControlsVisibility(false)
    if ModernDesktop1 then
        a0:DisconnectClassicBuildInputs()
    end

    a0.BuildCameraActive = nil
    a0:SetBuildPanelToggleHidden(false)
    if a0.DesktopCatalogue then
        a0.DesktopCatalogue:SetActive(false)
    end

    a0.ClassicBuildActive = nil
    a0.BuildModeKind = nil
    a0.BuildCameraLocked = nil
    a0.BuildGamepadNavigationBeforeCameraLock = nil
    a0.BuildCameraLockManagedGamepadNavigation = nil
    RunService:UnbindFromRenderStep("BuildCamera")
    if a0.BuildInputCons then
        for k234, k235 in ipairs(a0.BuildInputCons) do
            k235:Disconnect()
        end

        a0.BuildInputCons = nil
    end

    a0.BuildPendingTouchSelection = nil
    a0.BuildTouches = nil
    a0.BuildTouchOrder = nil
    a0.BuildMouseOrbit = nil
    a0.BuildMousePan = nil
    a0:EndDirectBuildDrag()
    a0.BuildGizmoDragging = nil
    a0:DestroyBuildGrid()
    a0.BuildGridOffsets = nil
    a0.BuildSurfaceParts = nil
    a0:HideBuildGizmos()
    if a0.BuildGizmoPart then
        a0.BuildGizmoPart:Destroy()
        a0.BuildGizmoPart = nil
    end

    if a0.BuildGui then
        a0.BuildGui.Enabled = false
    end

    a0:SetBuildClutterHidden(false)
    RemoteEvent:FireServer("SetBuildMode", false)
    if a0.BuildGamepadActivationRemapped then
        pcall(function() --[[ Upvalues: ContextActionService (upvalue) ]]
            ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
            ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
            ContextActionService:BindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
        end)
        a0.BuildGamepadActivationRemapped = nil
    end

    local BuildCameraSaved = a0.BuildCameraSaved
    if a1 then
        a0.BuildCameraSaved = nil
        a0.BuildCameraPosition = nil
        return BuildCameraSaved
    end

    local CurrentCamera13 = workspace.CurrentCamera
    if BuildCameraSaved then
        a0.MainContext.Enabled = BuildCameraSaved.MainContextEnabled
        UserInputService.MouseBehavior = BuildCameraSaved.MouseBehavior
        UserInputService.MouseIconEnabled = BuildCameraSaved.MouseIconEnabled
        CurrentCamera13.CameraType = BuildCameraSaved.CameraType
        CurrentCamera13.CameraSubject = BuildCameraSaved.CameraSubject
        if not ModernDesktop1 then
            CurrentCamera13.CFrame = BuildCameraSaved.CameraCFrame
        end

        CurrentCamera13.FieldOfView = BuildCameraSaved.FieldOfView
        if ModernDesktop1 then
            GuiService.SelectedObject = nil
        else
            GuiService.SelectedObject = BuildCameraSaved.SelectedObject
        end

        if UserInputService.GamepadEnabled then
            if not ModernDesktop1 then
                if BuildCameraSaved.GamepadCursorEnabled then
                    local SelectedObject3 = BuildCameraSaved.SelectedObject
                    if SelectedObject3 and not SelectedObject3:IsA("GuiObject") then
                        SelectedObject3 = nil
                    end

                    pcall(function() --[[ Upvalues: GamepadService (upvalue), SelectedObject3 (ref) ]]
                        GamepadService:EnableGamepadCursor(SelectedObject3)
                    end)
                    -- jump to 342 (out of range)
                end
            end

            if GamepadService.GamepadCursorEnabled then
                pcall(function() --[[ Upvalues: GamepadService (upvalue) ]]
                    GamepadService:DisableGamepadCursor()
                end)
                -- branch continues at 342
            end

            -- branch continues at 342
        end
    else
        a0.MainContext.Enabled = true
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
        CurrentCamera13.CameraType = Enum.CameraType.Custom
        if UserInputService.GamepadEnabled and GamepadService.GamepadCursorEnabled then
            pcall(function() --[[ Upvalues: GamepadService (upvalue) ]]
                GamepadService:DisableGamepadCursor()
            end)
        end
    end

    a0.BuildCameraSaved = nil
    a0.BuildCameraPosition = nil
end

getBobbing.EndBuildMode = EndBuildMode

local function EditStorage(a0) --[[ Upvalues: RunService (copy) ]]
    if not a0.Player:GetAttribute("InBase") then
        return
    end

    if a0.Humanoid and a0.Humanoid.Health <= 0 then
        return
    end

    a0.EditingBase = true
    a0.HUD.BaseEdit.BaseObjects.Text = "Close Objects"
    a0:EnableBackpack(false)
    a0.HUD.BaseObjects.Visible = true
    a0:BarsVisible(false)
    a0.HUD.BaseObjects.Search.Text = ""
    a0.HUD.BaseObjects.Hotkeys.Visible = false
    a0.SearchText = ""
    a0.CurrentSubCategory = "All"
    a0.DeletingObjects = false
    a0:UpdateSubCategories(a0.CurrentBaseObjects)
    a0:UpdateBaseObjects(a0.CurrentBaseObjects)
    a0:SetBaseObjectsCollapsed(a0.BaseObjectsCollapsed == true, true)
    a0:BeginBuildMode()
    a0:SetDeletingObjects(false)
    a0:UpdateStorageCapacity()
    if a0.TouchEnabled then
        a0.HUD.MobileMouse.Visible = true
        a0.HUD.MobileEdits.Visible = a0.ClassicBuildActive == true
        a0.BuildMobileButtonVisibility = {}
        local v1934 = a0.MobileButtons.Buttons:GetChildren()
        for k236, k237 in ipairs(v1934) do
            if k237:IsA("GuiObject") then
                a0.BuildMobileButtonVisibility[k237] = k237.Visible
                k237.Visible = false
            end
        end
    end

    local v1938 = a0.HUD.BaseObjects.Types:GetChildren()
    for k238, k239 in ipairs(v1938) do
        if k239:IsA("TextButton") then
            local v1942 = k239.Name .. "Clicked"
            a0.EditCons[v1942] = k239.Activated:Connect(function() --[[ Upvalues: a0 (copy), k239 (copy) ]]
                a0.CurrentBaseObjects = k239.Name
                a0.CurrentSubCategory = "All"
                a0:UpdateSubCategories(k239.Name)
                a0:UpdateBaseObjects(k239.Name)
            end)
        end
    end

    if a0.ClassicMobile then
        a0.ClassicMobile:RefreshPresentation()
    end

    if a0.ModernMobile then
        a0.ModernMobile:RefreshPresentation()
    end

    k239 = Enum.RenderPriority.Last.Value + 1
    local v1943 = time()
    RunService:BindToRenderStep("UpdateSearch", k239, function() --[[ Upvalues: a0 (copy), v1943 (ref) ]]
        if a0:IsDesktopBuildCatalogue() then
            return
        end

        local v1944 = time() - v1943
        if 0.1 < v1944 and a0.SearchText ~= a0.HUD.BaseObjects.Search.Text then
            v1943 = time()
            a0.SearchText = a0.HUD.BaseObjects.Search.Text
            a0:UpdateBaseObjects(a0.CurrentBaseObjects)
        end

    end)
end

getBobbing.EditStorage = EditStorage

local function DeleteEditObject(a0)
    a0:EndBuildTouchGizmoDrag()
    a0:EndDirectBuildDrag()
    a0.BuildGizmoDragging = nil
    if a0.EditObject then
        a0.EditObject:Destroy()
        a0.EditObject = nil
    end

    if a0.EditExistingOriginalTransparency then
        for k240, k241 in pairs(a0.EditExistingOriginalTransparency) do
            if k240 and k240.Parent then
                k240.LocalTransparencyModifier = k241
            end
        end
    end

    a0.EditExistingOriginalTransparency = nil
    a0.EditingExistingObject = nil
    if a0.CurrentFrame then
        a0:SetBaseObjectFrameSelected(a0.CurrentFrame, false)
        a0.CurrentFrame = nil
    end

    a0.BuildObjectPosition = nil
    a0.BuildObjectRotation = nil
    a0.BuildLastValidPosition = nil
    a0.BuildLastValidRotation = nil
    a0.BuildPlacementValid = nil
    a0.BuildInvalidReason = nil
    a0.BuildDragStartPosition = nil
    a0.BuildDragStartRotation = nil
    a0:HideBuildGizmos()
    a0.Mouse.TargetFilter = nil
    a0:ClearBuildObjectHover()
    if a0.BuildGui then
        a0:UpdateBuildGui()
    end
end

getBobbing.DeleteEditObject = DeleteEditObject

local function SelectEditObject(a0, a1, a2) --[[ Upvalues: ReplicatedStorage (copy), applyFactionSignIcon (copy) ]]
    a0:DeleteEditObject()
    if not ReplicatedStorage.BaseObjects:FindFirstChild(a1) then
        return
    end

    if a0.ClassicBuildActive then
        a0:SetDeletingObjects(false)
    end

    local v1948 = a1
    if a1 == "Turret" then
        v1948 = "Turret" .. a0.Data.CurrentSkins.Turret
    end

    a0.ObjectHover = nil
    a0.HighlightHover.Parent = nil
    a0.ObjectType = a2
    a0.EditObjectRotate = 90
    a0.EditObjectFlip = 0
    a0.EditObjectFlip2 = 0
    a0.breathingNum = Vector3.new(0, 0, 0)
    a0.EditObject = ReplicatedStorage.BaseObjects[v1948]:Clone()
    a0.EditObject.Name = a1
    applyFactionSignIcon(a0.EditObject, a1)
    local v1949 = a0.EditObject:GetDescendants()
    for k242, k243 in ipairs(v1949) do
        if k243:IsA("BasePart") then
            k243:SetAttribute("BuildWasCollidable", k243.CanCollide)
            k243.CanCollide = false
            k243.CanTouch = false
            k243.CanQuery = true
        end
    end

    local Highlight1 = Instance.new("Highlight")
    Highlight1.Name = "BuildHighlight"
    Highlight1.FillTransparency = 0.5
    Highlight1.FillColor = Color3.fromRGB(255, 226, 137)
    Highlight1.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight1.OutlineColor = Color3.fromRGB(255, 228, 120)
    Highlight1.OutlineTransparency = 0
    Highlight1.Parent = a0.EditObject
    a0.EditObject.Parent = workspace.CurrentCamera
    a0.Mouse.TargetFilter = a0.EditObject
    a0:ResetBuildObjectTransform()
    if a0.ClassicBuildActive then
        a0.BuildObjectPosition = nil
        a0.BuildObjectRotation = nil
        a0:HideBuildGizmos()
    else
        local v1953 = a0:GetBuildObjectCFrame()
        a0.EditObject:PivotTo(v1953)
        a0:UpdateBuildGizmo(v1953)
        a0:RefreshBuildValidation(true)
    end

    if a0.ClassicBuildActive then
        a0:ApplyClassicBuildPresentation()
    end

    if a0.ClassicController then
        a0.ClassicController:NotifySelected(a1, a2)
    end

    if a0.ClassicMobile then
        a0.ClassicMobile:NotifySelected(a1, a2)
    end

    if a0.ModernController then
        a0.ModernController:NotifySelected(a1, a2)
    end

    if a0.ModernMobile then
        a0.ModernMobile:NotifySelected(a1, a2)
    end

    a0:RememberModernDesktopObject(a1)
    if a0.DesktopCatalogue then
        a0.DesktopCatalogue:RefreshSelection()
    end
end

getBobbing.SelectEditObject = SelectEditObject

local function worldBoundingBox(a0, a1)
    local v1954 = a1 / 2
    local v1955 = a0:VectorToWorldSpace(Vector3.new(v1954.x, v1954.y, v1954.z))
    local v1956 = -v1954.x
    local v1957 = a0:VectorToWorldSpace(Vector3.new(v1956, v1954.y, v1954.z))
    local v1958 = -v1954.x
    local v1959 = -v1954.y
    local v1960 = a0:VectorToWorldSpace(Vector3.new(v1958, v1959, v1954.z))
    v1959 = -v1954.x
    local v1961 = -v1954.y
    local v1962 = a0:VectorToWorldSpace(Vector3.new(v1959, v1961, -v1954.z))
    local v1963 = -v1954.y
    local v1964 = a0:VectorToWorldSpace(Vector3.new(v1954.x, v1963, -v1954.z))
    local v1965 = a0:VectorToWorldSpace(Vector3.new(v1954.x, v1954.y, -v1954.z))
    local v1966 = -v1954.y
    local v1967 = a0:VectorToWorldSpace(Vector3.new(v1954.x, v1966, v1954.z))
    v1966 = -v1954.x
    local v1968 = a0:VectorToWorldSpace(Vector3.new(v1966, v1954.y, -v1954.z))
    local v1969 = math.max(v1955.x, v1957.x, v1960.x, v1962.x, v1964.x, v1965.x, v1967.x, v1968.x)
    local v1970 = math.max(v1955.y, v1957.y, v1960.y, v1962.y, v1964.y, v1965.y, v1967.y, v1968.y)
    v1954 = Vector3.new(v1969, v1970, math.max(v1955.z, v1957.z, v1960.z, v1962.z, v1964.z, v1965.z, v1967.z, v1968.z))
    local v1971 = math.min(v1955.x, v1957.x, v1960.x, v1962.x, v1964.x, v1965.x, v1967.x, v1968.x)
    local v1972 = math.min(v1955.y, v1957.y, v1960.y, v1962.y, v1964.y, v1965.y, v1967.y, v1968.y)
    return v1954 - Vector3.new(v1971, v1972, math.min(v1955.z, v1957.z, v1960.z, v1962.z, v1964.z, v1965.z, v1967.z, v1968.z))
end

local function CalcStorageFloor(a0, a1)
    local Floor10 = a0.StorageBase.Floor
    local v1973 = 0
    if a1 then
        v1973 = a1.Position.Y - Floor10.Position.Y
    end

    local Size1 = Floor10.Size
    local CFrame = Floor10.CFrame
    local Basement3 = a0.StorageBase:FindFirstChild("Basement")
    local v1975 = Basement3 and Basement3:FindFirstChild("BoundingBox")
    local v1976 = a0.StorageBase:GetAttribute("BaseUnitSize")
    local v1977 = tonumber(v1976) or 1
    if 1 < v1977 and v1975 and v1975:IsA("BasePart") then
        Basement3 = Floor10.CFrame:PointToObjectSpace(v1975.Position)
        CFrame = CFrame * CFrame.new(Basement3.X, 0, Basement3.Z)
        Size1 = Vector3.new(v1975.Size.X, Floor10.Size.Y, v1975.Size.Z)
    end

    v1975 = -Vector3.FromNormalId(Enum.NormalId.Top)
    Floor10 = v1975:Dot(Vector3.new(0, 1, 0))
    local v1980 = math.abs(Floor10) == 1 and Vector3.new(-Floor10, 0, 0) or Vector3.new(0, 1, 0)
    Floor10 = CFrame.fromAxisAngle(v1980, 1.5707963267948966) * v1975
    local v1981 = CFrame.fromAxisAngle(v1980, -1.5707963267948966) * v1975
    local unit = v1975:Cross(Floor10).unit
    local v1982 = CFrame * CFrame.new(0, v1973, 0)
    local v1983 = -v1975 * Size1 / 2
    v1980 = v1982 * CFrame.fromMatrix(v1983, Floor10, unit, v1975)
    v1975 = Vector2.new((Size1 * Floor10).magnitude, (Size1 * unit).magnitude)
    return v1980, v1975
end

getBobbing.CalcStorageFloor = CalcStorageFloor

local function CalcPlacementCFrame(a0, a1) --[[ Upvalues: worldBoundingBox (copy) ]]
    if a0.BuildCameraActive then
        if not a0.ClassicBuildActive then
            if a0.BuildObjectPosition then
                local v1984 = a0:GetBuildObjectCFrame()
                return v1984
            end

            local v1986
            if not (a0.EditObject and a0.EditObject:GetPivot()) then
                local v1987 = CFrame.new()
            end

            return v1986
        end
    end

    local EditObject3 = a0.EditObject
    if not (EditObject3 and a0.StorageBase) then
        local v1989
        if not (EditObject3 and EditObject3:GetPivot()) then
            local v1990 = CFrame.new()
        end

        return v1989
    end

    local Target = a0.Mouse.Target
    if a0.ClassicBuildActive then
        local v1991, v1992 = a0:GetClassicBuildAim()
        Target = v1992
    else
        if a0.TouchEnabled then
            local v1993, v1994 = a0:GetMobileAim(nil, true)
            if v1993 and v1994 then
                Target = v1994.Instance
            else
                Target = nil
            end
        end
    end

    local v1995, v1996
    if Target then
        if Target:IsDescendantOf(a0.StorageBase) then
            if a0.StorageBase:FindFirstChild("Basement") and Target:IsDescendantOf(a0.StorageBase.Basement) then
                local v1997, v1998 = a0:CalcStorageFloor(Target)
                v1995 = v1997
                v1996 = v1998
                -- jump to 138 (out of range)
            end

            if Target:IsDescendantOf(a0.StorageBase.Contents) then
                local v1999, v2000 = a0:CalcStorageFloor(Target)
                v1995 = v1999
                v1996 = v2000
                -- jump to 138 (out of range)
            end

            local v2001, v2002 = a0:CalcStorageFloor()
            v1995 = v2001
            v1996 = v2002
            -- branch continues at 132
        end
    else
        local v2003, v2004 = a0:CalcStorageFloor()
        v1995 = v2003
        v1996 = v2004
    end

    local v2005 = math.rad(a0.EditObjectFlip2)
    local v2006 = math.rad(a0.EditObjectRotate)
    local v2007 = CFrame.Angles(v2005, v2006, math.rad(a0.EditObjectFlip))
    Target = worldBoundingBox(v2007, EditObject3.PrimaryPart.Size)
    EditObject3 = v1995:pointToObjectSpace(a1)
    local v2008 = (v1996 - Vector2.new(Target.x, Target.z)) / 2
    local v2009 = -math.abs(v2008.x)
    v1996 = math.clamp(EditObject3.x, v2009, math.abs(v2008.x))
    v2009 = -math.abs(v2008.y)
    local v2010 = math.clamp(EditObject3.y, v2009, math.abs(v2008.y))
    local v2011 = math.sign(v1996)
    local v2012 = math.abs(v1996)
    local v2013 = v2012 - math.abs(v1996) % 0.1
    v1996 = v2011 * (v2013 + v2008.x % 0.1)
    local v2014 = math.sign(v2010)
    local v2015 = math.abs(v2010)
    v2013 = v2015 - math.abs(v2010) % 0.1
    local v2016 = v1995 * CFrame.new(v1996, v2014 * (v2013 + v2008.y % 0.1), -(Target.Y / 2))
    local v2017 = -1.5707963267948966 + math.rad(a0.EditObjectFlip2)
    local v2018 = math.rad(a0.EditObjectRotate)
    return v2016 * CFrame.Angles(v2017, v2018, math.rad(a0.EditObjectFlip))
end

getBobbing.CalcPlacementCFrame = CalcPlacementCFrame

local function PlaceBaseObject(a0, a1) --[[ Upvalues: RemoteFunction (copy), RemoteEvent (copy) ]]
    if not a0.EditObject then
        return
    end

    if typeof(a1) ~= "CFrame" then
        return
    end

    if a0.ClassicController and a0.ClassicController:IsGamepad() then
        local v2019 = a0.ClassicController:Commit(a1)
        return v2019
    end

    if a0.ClassicMobile and a0.ClassicMobile:IsActive() then
        local v2020 = a0.ClassicMobile:Commit(a1)
        return v2020
    end

    if a0.ClassicDesktop and a0.ClassicDesktop:IsActive() then
        local v2021 = a0.ClassicDesktop:Commit(a1)
        return v2021
    end

    if a0.ModernController and a0.ModernController:IsGamepad() then
        local v2022 = a0.ModernController:CommitTransaction(a1)
        return v2022
    end

    if a0.ModernDesktop and a0.ModernDesktop:IsActive() then
        local v2023 = a0.ModernDesktop:Commit(a1)
        return v2023
    end

    if a0.EditingExistingObject then
        if a0.BuildMovePending then
            return
        end

        local EditingExistingObject = a0.EditingExistingObject
        a0.BuildMovePending = true
        local v2026, v2027, v2028 = pcall(function() --[[ Upvalues: RemoteFunction (upvalue), EditingExistingObject (copy), a1 (copy) ]]
            local v2024 = {EditingExistingObject, a1}
            local v2025 = RemoteFunction:InvokeServer("MoveBaseObject", v2024)
            return v2025
        end)
        a0.BuildMovePending = nil
        local v2029 = false
        if a0.EditObject == a0.EditObject then
            v2029 = a0.EditingExistingObject == EditingExistingObject
        end

        if not v2026 or v2027 ~= true then
            if v2029 then
                local v2030 = {
                    Title = "Can't Move",
                    Duration = 2,
                    Text = v2028 or "That object could not be moved."
                }
                a0:Noti(v2030)
                if not a0.ClassicBuildActive then
                    a0:RefreshBuildValidation(true)
                end
            end

            return
        end

        if EditingExistingObject and EditingExistingObject.Parent then
            EditingExistingObject:PivotTo(a1)
        end

        if v2029 then
            a0:DeleteEditObject()
        end

        return
    end

    local v2031 = {a0.EditObject.Name, a1, false, a0.ObjectType}
    RemoteEvent:FireServer("PlaceBaseObject", v2031)
end

getBobbing.PlaceBaseObject = PlaceBaseObject

local function CheckVC(a0) --[[ Upvalues: VoiceChatService (copy) ]]
    local v2032 = false
    local v2033, v2034 = pcall(function() --[[ Upvalues: v2032 (ref), VoiceChatService (upvalue), a0 (copy) ]]
        v2032 = VoiceChatService:IsVoiceEnabledForUserIdAsync(a0.Player.UserId)
    end)
    return v2032
end

getBobbing.CheckVC = CheckVC

local function ViewPlayer(a0, a1)
    if a1 == a0.Humanoid or a1 == a0.Player then
        a0.SpectateToken = (a0.SpectateToken or 0) + 1
        a0.ViewingPlayer = nil
        return
    end

    if typeof(a1) == "Instance" and a1:IsA("Humanoid") then
        a0.SpectateToken = (a0.SpectateToken or 0) + 1
        a0.ViewingPlayer = a1
        return
    end

    if typeof(a1) == "Instance" and a1:IsA("Player") then
        local v2035 = (a0.SpectateToken or 0) + 1
        a0.SpectateToken = v2035
        task.spawn(function() --[[ Upvalues: a0 (copy), v2035 (copy), a1 (copy) ]]
            local v2036 = os.clock() + 10
            while os.clock() < v2036 do
                if a0.SpectateToken ~= v2035 then
                    return
                end

                local Character1 = a1.Character
                local v2039 = Character1 and Character1:FindFirstChildOfClass("Humanoid")
                if v2039 then
                    a0.ViewingPlayer = v2039
                    return
                end

                task.wait(0.1)
            end

        end)
    end
end

getBobbing.ViewPlayer = ViewPlayer

local function createSkinViewport(a0, a1, a2) --[[ Upvalues: Objects (copy), v2 (copy), v11 (copy) ]]
    local v2040 = Objects.Skins[a1]:FindFirstChild(a2)
    if not v2040 then
        return
    end

    local v2041 = v2[a1]
    local v2042 = v11[a1][a2]
    local v2043 = v2040:Clone()
    v2043.Name = "VPObject"
    v2043.Parent = a0
    v2040 = Instance.new("Camera")
    a0.CurrentCamera = v2040
    if v2043:IsA("Model") then
        if v2042 and v2042.ViewportOffset then
            v2040.CFrame = v2043.PrimaryPart.CFrame * v2042.ViewportOffset
            -- jump to 70 (out of range)
        end

        v2040.CFrame = v2043.PrimaryPart.CFrame * v2041.ViewportOffset
    else
        v2040.CFrame = v2043.CFrame * v2041.ViewportOffset
    end

    v2040.Parent = a0
end

local function CompressSkins(a0, a1)
    local v2044 = a0.Data.Skins[a1]
    local v2045 = {}
    for k244, k245 in pairs(v2044) do
        if v2045[k245.Skin] then
            local Skin = k245.Skin
            v2045[Skin] = v2045[Skin] + 1
        else
            v2045[k245.Skin] = 1
        end
    end

    return v2045
end

getBobbing.CompressSkins = CompressSkins
CompressSkins = {"Revolver", "SMG", "LMG", "AK47", "Shotgun", "Double Barrel Shotgun"}

local function UpdateSkins(a0, a1, a2) --[[ Upvalues: CompressSkins (copy), v11 (copy), Objects (copy), createSkinViewport (copy), RemoteEvent (copy) ]]
    local Items2 = a0.HUD.Skins.Items
    local Skins = a0.HUD.Skins.Skins
    local v2049 = Items2.List:FindFirstChild(a1)
    local v2050 = Items2.List:GetChildren()
    for k246, k247 in pairs(v2050) do
        if k247:IsA("ImageButton") then
            k247.BackgroundColor3 = Color3.fromRGB(144, 144, 144)
        end
    end

    if a2 then
        local v2054 = Skins.List:GetChildren()
        for k248, k249 in pairs(v2054) do
            if k249:IsA("ImageButton") and k249.Name ~= "Sample" then
                k249:Destroy()
            end
        end
    else
        for k250, k251 in pairs(a0.SkinCons) do
            k251:Disconnect()
            a0.SkinCons[k250] = nil
        end
    end

    if v2049 then
        v2049.BackgroundColor3 = Color3.fromRGB(255, 192, 90)
    end

    local v2061 = a0:CompressSkins(a1)
    Items2 = a1
    if _G.Utl.tabFind(CompressSkins, Items2) then
        Items2 = "Guns"
    end

    k246 = v11
    for k252, k253 in pairs(k246[Items2]) do
        local v2065 = Skins.List:FindFirstChild(k252)
        if not v2065 then
            if Objects.Skins[a1]:FindFirstChild(k252) then
                v2065 = Skins.List.Sample:Clone()
                v2065.Name = k252
                v2065.SkinName.Text = k252
                v2065.RarityLabel.Text = k253.Rarity
                v2065.RarityLabel.TextColor3 = _G.Utl.RarityInfo[k253.Rarity][1]
                v2065.BackgroundColor3 = _G.Utl.RarityInfo[k253.Rarity][1]
                v2065.LayoutOrder = _G.Utl.RarityInfo[k253.Rarity][2]
                v2065.Visible = true
                v2065.Parent = Skins.List
                createSkinViewport(v2065.ObjectFrame, a1, k252)
                -- branch continues at 348
            end
        end

        if a0.Data.CurrentSkins[a1] == k252 then
            v2065.ObjectFrame.Equipped.Visible = true
        else
            v2065.ObjectFrame.Equipped.Visible = false
        end

        if not a0.ShowAll and not v2061[k252] then
            v2065.Visible = false
        else
            v2065.Visible = true
        end

        if v2061[k252] then
            v2065.ObjectFrame.Lock.Visible = false
            v2065.ObjectFrame.Amount.Text = "x" .. v2061[k252]
            v2065.ObjectFrame.Amount.Visible = true
            v2065.ObjectFrame.Pack.Visible = false
            local v2066 = k252 .. "M1D"
            a0.SkinCons[v2066] = v2065.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy), a1 (copy), k252 (copy), RemoteEvent (upvalue) ]]
                if a0.SellingSkins then
                    a0:SellSkin(a1, tostring(k252))
                    return
                end

                RemoteEvent:FireServer("EquipSkin", a1, tostring(k252))
            end)
        else
            v2065.ObjectFrame.Lock.Visible = true
            v2065.ObjectFrame.Amount.Visible = false
            if k253.Prem then
                v2065.ObjectFrame.Lock.Image = "rbxassetid://14687163735"
            else
                if k253.Pack then
                    v2065.ObjectFrame.Lock.Visible = false
                    v2065.ObjectFrame.Amount.Visible = false
                    v2065.ObjectFrame.Pack.Visible = true
                end
            end
        end
    end
end

getBobbing.UpdateSkins = UpdateSkins

local function SellSkin(a0, a1, a2) --[[ Upvalues: CollectionService (copy), CompressSkins (copy), v11 (copy), RemoteEvent (copy) ]]
    if CollectionService:HasTag(a0.Player, "SkinSellCD") then
        return
    end

    CollectionService:AddTag(a0.Player, "SkinSellCD")
    task.delay(0.5, function() --[[ Upvalues: CollectionService (upvalue), a0 (copy) ]]
        CollectionService:RemoveTag(a0.Player, "SkinSellCD")
    end)
    local SellConfirm = a0.HUD.Skins.SellConfirm
    local v2067 = a1
    if _G.Utl.tabFind(CompressSkins, a1) then
        v2067 = "Guns"
    end

    local v2068 = v11[v2067][a2]
    local v2070 = v2068.SellPrice or v11.SellPrice[v2068.Rarity]
    local v2071 = {}

    local function disconnectCons() --[[ Upvalues: v2071 (ref) ]]
        for k254, k255 in pairs(v2071) do
            k255:Disconnect()
            v2071[k254] = nil
        end

        v2071 = nil
    end

    v2071.Yes = SellConfirm.Yes.MouseButton1Click:Connect(function() --[[ Upvalues: SellConfirm (copy), RemoteEvent (upvalue), a1 (copy), a2 (copy), v2071 (ref) ]]
        SellConfirm.Visible = false
        local v2075 = a1
        local v2076 = a2
        RemoteEvent:FireServer("SellSkin", v2075, v2076)
        for k256, k257 in pairs(v2071) do
            k257:Disconnect()
            v2071[k256] = nil
        end

        v2071 = nil
    end)
    v2071.No = SellConfirm.No.MouseButton1Click:Connect(function() --[[ Upvalues: SellConfirm (copy), v2071 (ref) ]]
        SellConfirm.Visible = false
        for k258, k259 in pairs(v2071) do
            k259:Disconnect()
            v2071[k258] = nil
        end

        v2071 = nil
    end)
    v2071.SellAll = SellConfirm.SellAll.MouseButton1Click:Connect(function() --[[ Upvalues: SellConfirm (copy), RemoteEvent (upvalue), a1 (copy), a2 (copy), v2071 (ref) ]]
        SellConfirm.Visible = false
        local v2083 = a1
        local v2084 = a2
        RemoteEvent:FireServer("SellAllSkin", v2083, v2084)
        for k260, k261 in pairs(v2071) do
            k261:Disconnect()
            v2071[k260] = nil
        end

        v2071 = nil
    end)
    SellConfirm.Label.Text = "Would you like to sell " .. a1 .. " " .. a2 .. " for $" .. v2070 .. "?"
    SellConfirm.Visible = true
end

getBobbing.SellSkin = SellSkin

local function DestroyRolling(a0)
    if a0.Spinner then
        a0.Spinner:Destroy()
        a0.Spinner = nil
    end
end

getBobbing.DestroyRolling = DestroyRolling

local function ClearRolling(a0)
    if not a0.Spinner then
        return
    end

    local Crate = a0.Spinner.Main.Crate
    local v2088 = a0.Spinner.Main.Frame.List:GetChildren()
    for k262, k263 in pairs(v2088) do
        if k263:IsA("ImageLabel") and k263.Name ~= "Sample" then
            k263:Destroy()
        end
    end

    local v2092 = Crate.ObjectFrame.WorldModel:GetChildren()
    for k264, k265 in pairs(v2092) do
        k265:Destroy()
    end
end

getBobbing.ClearRolling = ClearRolling

local function RollSkin(a0, a1) --[[ Upvalues: Objects (copy), Animations (copy), CompressSkins (copy), v11 (copy), createSkinViewport (copy), TweenService (copy), v2 (copy), RunService (copy) ]]
    if a0.Spinner then
        return
    end

    a0.Spinner = Objects.Spinner:Clone()
    local List7 = a0.Spinner.Main.Frame.List
    local Crate1 = a0.Spinner.Main.Crate
    local ResultLabel = a0.Spinner.Main.ResultLabel
    a0.Spinner.Parent = a0.Player.PlayerGui
    local v2096 = false
    local v2097 = Case:Clone()
    Case = Instance.new("Camera")
    Case.Parent = Crate1.ObjectFrame
    List7.Position = UDim2.new(0, 0, 0, 0)
    v2097.Parent = a0.Spinner.Main.Crate.ObjectFrame.WorldModel
    local v2098 = v2097.PrimaryPart.CFrame * CFrame.new(0, 5.5, -4.75)
    Case.CFrame = v2098 * CFrame.Angles(0.78539816339744828, 3.1415926535897931, 0)
    Crate1.ObjectFrame.CurrentCamera = Case
    local v2099 = v2097.AnimationController.Animator:LoadAnimation(Animations.CaseRattle)
    v2099:Play()
    local X2 = List7.Sample.AbsoluteSize.X
    local v2100 = List7.AbsoluteSize.X / 2 - X2
    local v2101 = List7.AbsoluteSize.X / 2
    local v2102 = v2101 - X2 / 2
    for k266, k267 in pairs(a1.Items) do
        local v2106
        if _G.Utl.tabFind(CompressSkins, k267.Item) then
            local Guns = v11.Guns
            v2106 = Guns[k267.Skin]
        else
            local v2107 = v11[k267.Item]
            v2106 = v2107[k267.Skin]
        end

        v2102 = List7.Sample:Clone()
        v2102.Name = tostring(k266)
        v2102.SkinName.Text = k267.Skin
        v2102.RarityLabel.Text = v2106.Rarity
        v2102.RarityLabel.TextColor3 = _G.Utl.RarityInfo[v2106.Rarity][1]
        v2102.BackgroundColor3 = _G.Utl.RarityInfo[v2106.Rarity][1]
        createSkinViewport(v2102.ObjectFrame, k267.Item, k267.Skin)
        v2102.Visible = true
        v2106 = (X2 + 5) * (k266 - 1)
        v2102.Position = UDim2.new(0, v2100 + v2106, 0, 0)
        v2102.Parent = List7
    end

    task.spawn(function() --[[ Upvalues: v2096 (ref), TweenService (upvalue), a0 (copy) ]]
        for i29 = 1, 15 do
            if v2096 then
                break
            end

            local v2110 = TweenService:GetValue(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local v2111 = (15 - i29) / 15
            local v2112 = TweenService:GetValue(v2111, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            task.wait(v2110 - v2112)
            local v2113 = {Sound = "Click", Speed = 1.2, Origin = a0.HUD}
            _G.Utl.PlaySound(v2113)
        end

    end)
    task.wait(0.1)
    local v2114 = (X2 + 5) * 12
    local v2115 = TweenInfo.new(6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local v2116 = {Position = UDim2.new(0, v2100 - v2114, 0, 0)}
    X2 = TweenService:Create(List7, v2115, v2116)
    X2:Play()
    a0.Spinner.Main.SkipButton.MouseButton1Click:Connect(function() --[[ Upvalues: X2 (copy), v2096 (ref), List7 (copy), v2100 (copy), v2114 (copy) ]]
        X2:Cancel()
        v2096 = true
        local v2117 = v2100 - v2114
        List7.Position = UDim2.new(0, v2117, 0, 0)
    end)
    local v2118 = time()
    while true do
        local v2119 = time() - v2118
        if 6 < v2119 then
            break
        end

        task.wait(0.1)
        if v2096 then
            break
        end
    end

    v2118 = a1.WinningItem
    local v2120
    if _G.Utl.tabFind(CompressSkins, v2118.Item) then
        local Guns1 = v11.Guns
        v2120 = Guns1[v2118.Skin]
    else
        local v2121 = v11[v2118.Item]
        v2120 = v2121[v2118.Skin]
    end

    local v2122 = v2[v2118.Item]
    ResultLabel.Text = v2118.Skin .. " " .. v2118.Item
    ResultLabel.TextColor3 = _G.Utl.RarityInfo[v2120.Rarity][1]
    Crate1.BackgroundColor3 = _G.Utl.RarityInfo[v2120.Rarity][1]
    Crate1.Gradient.Enabled = true
    v2099:Stop()
    v2097.AnimationController.Animator:LoadAnimation(Animations.CaseOpen):Play()
    local v2124 = v2122.CaseOffset or CFrame.new(0, 0, 0)
    local v2126 = v2122.Up or CFrame.new(0, 5.5, 0)
    local v2127 = Objects.Skins[v2118.Item]
    ResultLabel = v2127[v2118.Skin]:Clone()
    ResultLabel.PrimaryPart.Anchored = true
    ResultLabel:PivotTo(v2097.PrimaryPart.CFrame * v2124)
    ResultLabel.Parent = Crate1.ObjectFrame.WorldModel
    local v2128 = TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v2129 = {WorldPivot = ResultLabel.WorldPivot * v2126}
    TweenService:Create(ResultLabel, v2128, v2129):Play()
    local v2130 = TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v2131 = {CFrame = ResultLabel.PrimaryPart.CFrame * v2126}
    TweenService:Create(ResultLabel.PrimaryPart, v2130, v2131):Play()
    local v2132 = TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v2133 = Case.CFrame * CFrame.new(0, 1, 1)
    local v2134 = {CFrame = v2133 * CFrame.Angles(0.78539816339744828, 0, 0)}
    TweenService:Create(Case, v2132, v2134):Play()
    local v2135 = v2097:GetChildren()
    for k268, k269 in pairs(v2135) do
        if k269:IsA("BasePart") and k269.Name ~= "RootPart" then
            local v2139 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.8)
            TweenService:Create(k269, v2139, {Transparency = 1}):Play()
        end
    end

    task.wait(0.75)
    local v2141 = v2122.Spin or CFrame.Angles(0, -0.15707963267948966, 0)
    local v2142 = Enum.RenderPriority.Camera.Value + 1
    RunService:BindToRenderStep("SpinObject", v2142, function() --[[ Upvalues: ResultLabel (copy), v2141 (copy) ]]
        ResultLabel:PivotTo(ResultLabel.WorldPivot * v2141)
    end)
    task.wait(1)
    Case:Destroy()
    RunService:UnbindFromRenderStep("SpinObject")
    a0:DestroyRolling()
end

getBobbing.RollSkin = RollSkin

local function PremRollSkin10(a0, a1)
    for k270, k271 in pairs(a1) do
        k271.Prem = true
        a0:RollSkin(k271)
    end
end

getBobbing.PremRollSkin10 = PremRollSkin10

local function RollSkin10(a0, a1)
    for k272, k273 in pairs(a1) do
        a0:RollSkin(k273)
    end
end

getBobbing.RollSkin10 = RollSkin10

local function SetupSkins(a0) --[[ Upvalues: v2 (copy), createViewportObjects (copy), CompressSkins (copy), v11 (copy), Objects (copy), RemoteFunction (copy), MarketplaceService (copy), ReplicatedStorage (copy) ]]
    local Items3 = a0.HUD.Skins.Items
    local Buttons5 = a0.HUD.Skins.Buttons
    local Code = a0.HUD.Skins.Code
    local Packs = a0.HUD.Skins.Packs
    a0.SkinItem = "Knife"
    a0.ShowAll = true
    a0.SellingSkins = false
    for k274, k275 in pairs(v2.LayoutSkins) do
        local v2152 = Items3.List.Sample:Clone()
        v2152.Name = k275
        v2152.Frame.ItemName.Text = k275
        createViewportObjects(v2152.Frame.ObjectFrame, k275, v2[k275])
        v2152.Visible = true
        v2152.LayoutOrder = k274
        v2152.Parent = Items3.List
        local v2153 = 0
        if _G.Utl.tabFind(CompressSkins, k275) then
            local v2154 = v11
            for k276, k277 in pairs(v2154.Guns) do
                if Objects.Skins[k275]:FindFirstChild(k276) then
                    v2153 = v2153 + 1
                end
            end
        else
            for k278, k279 in pairs(v11[k275]) do
                v2153 = v2153 + 1
            end
        end

        local v2161 = tostring(v2153)
        v2152.Frame.Skins.Text = v2161 .. " Skins"
        v2152.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy), k275 (copy) ]]
            a0.SkinItem = k275
            a0:UpdateSkins(a0.SkinItem, true)
        end)
    end

    Buttons5.ShowAll.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy), Buttons5 (copy) ]]
        if a0.ShowAll then
            a0.ShowAll = false
            Buttons5.ShowAll.Frame.On.Visible = false
            Buttons5.ShowAll.Frame.Off.Visible = true
        else
            a0.ShowAll = true
            Buttons5.ShowAll.Frame.On.Visible = true
            Buttons5.ShowAll.Frame.Off.Visible = false
        end

        a0:UpdateSkins(a0.SkinItem, false)
    end)
    local v2162 = time()
    Buttons5.Roll.MouseButton1Click:Connect(function() --[[ Upvalues: v2162 (ref), a0 (copy), RemoteFunction (upvalue) ]]
        local v2163 = time() - v2162
        if v2163 < 0.5 then
            return
        end

        if a0.Spinner then
            return
        end

        v2162 = time()
        local v2164 = RemoteFunction:InvokeServer("RollSkin")
        if typeof(v2164) == "string" then
            local v2165 = {Title = "Error", Duration = 2, Text = v2164}
            a0:Noti(v2165)
            return
        end

        a0:RollSkin(v2164)
    end)
    Buttons5.Roll10.MouseButton1Click:Connect(function() --[[ Upvalues: v2162 (ref), a0 (copy), RemoteFunction (upvalue) ]]
        local v2166 = time() - v2162
        if v2166 < 0.5 then
            return
        end

        if a0.Spinner then
            return
        end

        v2162 = time()
        local v2167 = RemoteFunction:InvokeServer("RollSkin10")
        if typeof(v2167) == "string" then
            local v2168 = {Title = "Error", Duration = 2, Text = v2167}
            a0:Noti(v2168)
            return
        end

        for k280, k281 in pairs(v2167) do
            a0:RollSkin(k281)
        end

    end)
    Items3 = MarketplaceService:GetProductInfo(1644429004, Enum.InfoType.Product)
    local v2172 = MarketplaceService:GetProductInfo(1644430220, Enum.InfoType.Product)
    Buttons5.PremRollLabel.Text = Items3.PriceInRobux .. "R$"
    Buttons5.PremRoll10Label.Text = v2172.PriceInRobux .. "R$"
    Buttons5.PremRoll.MouseButton1Click:Connect(function() --[[ Upvalues: v2162 (ref), a0 (copy), MarketplaceService (upvalue) ]]
        local v2173 = time() - v2162
        if v2173 < 0.5 then
            return
        end

        if a0.Spinner then
            return
        end

        v2162 = time()
        MarketplaceService:PromptProductPurchase(a0.Player, 1644429004)
    end)
    Buttons5.PremRoll10.MouseButton1Click:Connect(function() --[[ Upvalues: v2162 (ref), a0 (copy), MarketplaceService (upvalue) ]]
        local v2174 = time() - v2162
        if v2174 < 0.5 then
            return
        end

        if a0.Spinner then
            return
        end

        v2162 = time()
        MarketplaceService:PromptProductPurchase(a0.Player, 1644430220)
    end)
    Buttons5.SellSkins.BackgroundColor3 = Color3.fromRGB(196, 255, 174)
    Buttons5.SellSkins.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy), Buttons5 (copy) ]]
        if a0.SellingSkins then
            a0.SellingSkins = false
            Buttons5.SellSkins.Text = "Sell Skins"
            Buttons5.SellSkins.BackgroundColor3 = Color3.fromRGB(196, 255, 174)
            a0.HUD.Skins.SellTip.Visible = false
            return
        end

        a0.SellingSkins = true
        Buttons5.SellSkins.Text = "Selling"
        Buttons5.SellSkins.BackgroundColor3 = Color3.fromRGB(255, 162, 162)
        a0.HUD.Skins.SellTip.Visible = true
    end)
    local v2175 = time()
    Code.Enter.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy), Code (copy), v2175 (ref), ReplicatedStorage (upvalue) ]]
        if a0.Spinner then
            return
        end

        local Text1 = Code.TextBox.Text
        local v2176 = time() - v2175
        if v2176 < 0.5 then
            return
        end

        if Text1 == "" then
            return
        end

        v2175 = time()
        ReplicatedStorage.Codes:FireServer(Text1)
    end)
    local v2177 = Packs:GetChildren()
    for k282, k283 in pairs(v2177) do
        k283.Info.MouseButton1Click:Connect(function() --[[ Upvalues: k283 (copy) ]]
            k283.InfoLabel.Visible = not k283.InfoLabel.Visible
        end)
        k283.Buy.MouseButton1Click:Connect(function() --[[ Upvalues: v11 (upvalue), k283 (copy), MarketplaceService (upvalue), a0 (copy) ]]
            local v2181 = v11.Packs[k283.Name]
            if v2181 then
                MarketplaceService:PromptProductPurchase(a0.Player, v2181)
            end

        end)
    end
end

getBobbing.SetupSkins = SetupSkins

local function StartCinematic(a0) --[[ Upvalues: UserInputService (copy), StarterGui (copy), ReplicatedStorage (copy), RunService (copy) ]]
    if a0.CinematicActive then
        return
    end

    a0.CinematicActive = true
    local CurrentCamera14 = workspace.CurrentCamera
    local v2182 = {
        CameraType = CurrentCamera14.CameraType,
        FieldOfView = CurrentCamera14.FieldOfView,
        MouseBehavior = UserInputService.MouseBehavior,
        MouseIconEnabled = UserInputService.MouseIconEnabled
    }
    a0.CinematicSaved = v2182
    local v2183 = a0.Character and a0.Character:FindFirstChild("HumanoidRootPart")
    if v2183 then
        a0.CinematicSaved.Anchored = v2183.Anchored
        v2183.Anchored = true
    end

    a0.CinematicHidden = {}
    local v2184 = a0.Player:FindFirstChildOfClass("PlayerGui")
    if v2184 then
        local v2185 = v2184:GetChildren()
        for k284, k285 in ipairs(v2185) do
            if k285:IsA("ScreenGui") and k285.Enabled and not k285:GetAttribute("CinematicExempt") then
                table.insert(a0.CinematicHidden, k285)
                k285.Enabled = false
            end
        end
    end

    pcall(function() --[[ Upvalues: StarterGui (upvalue) ]]
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    end)
    a0.CinematicIconsHidden = {}
    if a0.CinematicIcon then
        local v2189 = require(ReplicatedStorage.Modules.Icon)
        local v2190 = v2189.getIcons()
        for k286, k287 in pairs(v2190) do
            if k287 ~= a0.CinematicIcon and k287.isEnabled then
                k287:setEnabled(false)
                table.insert(a0.CinematicIconsHidden, k287)
            end
        end
    end

    local v2194, v2195 = CurrentCamera14.CFrame:ToEulerAnglesYXZ()
    a0.CinematicPos = CurrentCamera14.CFrame.Position
    a0.CinematicPitch = v2194
    a0.CinematicYaw = v2195
    a0.CinematicSpeed = 60
    a0.CinematicFOV = 70
    CurrentCamera14.CameraType = Enum.CameraType.Scriptable
    CurrentCamera14.FieldOfView = a0.CinematicFOV
    a0.CinematicScroll = UserInputService.InputChanged:Connect(function(a0) --[[ Upvalues: a0 (copy) ]]
        if a0.UserInputType == Enum.UserInputType.MouseWheel then
            local v2196 = a0.CinematicFOV - a0.Position.Z * 5
            a0.CinematicFOV = math.clamp(v2196, 10, 90)
        end

    end)
    a0.CinematicKey = UserInputService.InputBegan:Connect(function(a0) --[[ Upvalues: a0 (copy) ]]
        if a0.KeyCode == Enum.KeyCode.P or a0.KeyCode == Enum.KeyCode.ButtonB then
            a0:StopCinematic()
        end

    end)
    local v2197 = Enum.RenderPriority.Camera.Value + 1
    RunService:BindToRenderStep("Cinematic", v2197, function(a0) --[[ Upvalues: a0 (copy) ]]
        a0:StepCinematic(a0)
    end)
    if a0.CinematicRefresh then
        a0.CinematicRefresh()
    end
end

getBobbing.StartCinematic = StartCinematic

local function StepCinematic(a0, a1) --[[ Upvalues: UserInputService (copy) ]]
    if not a0.CinematicActive then
        return
    end

    local CurrentCamera15 = workspace.CurrentCamera
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
        UserInputService.MouseIconEnabled = false
        local v2198 = UserInputService:GetMouseDelta()
        a0.CinematicYaw = a0.CinematicYaw - v2198.X * 0.004
        local v2199 = a0.CinematicPitch - v2198.Y * 0.004
        a0.CinematicPitch = math.clamp(v2199, -1.5, 1.5)
    else
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end

    local CinematicSpeed = a0.CinematicSpeed
    local v2201 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
    local v2202 = nil
    local v2203 = UserInputService:GetConnectedGamepads()
    if 0 < #v2203 then
        v2202 = v2203[1]
    end

    if v2202 then
        local v2204 = UserInputService:GetGamepadState(v2202)
        for k288, k289 in ipairs(v2204) do
            v2203 = k289.KeyCode
            if v2203 == Enum.KeyCode.Thumbstick1 then
                local Position13 = k289.Position
                local v2208 = math.abs(Position13.X)
                if 0.15 < v2208 then
                    v2200 = v2200 + Vector3.new(Position13.X, 0, 0)
                end

                local v2209 = math.abs(Position13.Y)
                if 0.15 < v2209 then
                    v2200 = v2200 + Vector3.new(0, 0, -Position13.Y)
                    -- branch continues at 297
                end
            else
                if v2203 == Enum.KeyCode.Thumbstick2 then
                    local Position14 = k289.Position
                    local v2210 = math.abs(Position14.X)
                    if 0.15 < v2210 then
                        a0.CinematicYaw = a0.CinematicYaw - Position14.X * 2.5 * a1
                    end

                    local v2211 = math.abs(Position14.Y)
                    if 0.15 < v2211 then
                        local v2212 = a0.CinematicPitch + Position14.Y * 2.5 * a1
                        a0.CinematicPitch = math.clamp(v2212, -1.5, 1.5)
                        -- branch continues at 297
                    end
                else
                    if v2203 == Enum.KeyCode.ButtonR2 then
                        if 0.1 < k289.Position.Z then
                            v2200 = v2200 + Vector3.new(0, k289.Position.Z, 0)
                            -- branch continues at 297
                        end
                    else
                        if v2203 == Enum.KeyCode.ButtonL2 and 0.1 < k289.Position.Z then
                            local v2213 = -k289.Position.Z
                            v2200 = v2200 + Vector3.new(0, v2213, 0)
                        end
                    end
                end
            end
        end

        if UserInputService:IsGamepadButtonDown(v2202, Enum.KeyCode.ButtonR1) then
            local v2214 = a0.CinematicFOV - 40 * a1
            a0.CinematicFOV = math.clamp(v2214, 10, 90)
        end

        if UserInputService:IsGamepadButtonDown(v2202, Enum.KeyCode.ButtonL1) then
            local v2215 = a0.CinematicFOV + 40 * a1
            a0.CinematicFOV = math.clamp(v2215, 10, 90)
        end

        if UserInputService:IsGamepadButtonDown(v2202, Enum.KeyCode.ButtonL3) then
            v2201 = true
        end
    end

    if v2201 then
        CinematicSpeed = CinematicSpeed * 3
    end

    v2202 = CFrame.fromEulerAnglesYXZ(a0.CinematicPitch, a0.CinematicYaw, 0)
    if 0 < v2200.Magnitude then
        a0.CinematicPos = a0.CinematicPos + v2202:VectorToWorldSpace(1 < v2200.Magnitude and v2200.Unit or v2200) * CinematicSpeed * a1
    end

    CurrentCamera15.CFrame = CFrame.new(a0.CinematicPos) * v2202
    CurrentCamera15.FieldOfView = a0.CinematicFOV
end

getBobbing.StepCinematic = StepCinematic

local function StopCinematic(a0) --[[ Upvalues: RunService (copy), StarterGui (copy), UserInputService (copy) ]]
    if not a0.CinematicActive then
        return
    end

    a0.CinematicActive = false
    pcall(function() --[[ Upvalues: RunService (upvalue) ]]
        RunService:UnbindFromRenderStep("Cinematic")
    end)
    if a0.CinematicScroll then
        a0.CinematicScroll:Disconnect()
        a0.CinematicScroll = nil
    end

    if a0.CinematicKey then
        a0.CinematicKey:Disconnect()
        a0.CinematicKey = nil
    end

    if a0.CinematicIconsHidden then
        for k290, k291 in ipairs(a0.CinematicIconsHidden) do
            if k291 and k291.setEnabled then
                k291:setEnabled(true)
            end
        end

        a0.CinematicIconsHidden = nil
    end

    if a0.CinematicHidden then
        for k292, k293 in ipairs(a0.CinematicHidden) do
            if k293 and k293.Parent then
                k293.Enabled = true
            end
        end

        a0.CinematicHidden = nil
    end

    pcall(function() --[[ Upvalues: StarterGui (upvalue) ]]
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
    end)
    local CurrentCamera16 = workspace.CurrentCamera
    local CinematicSaved = a0.CinematicSaved
    if CinematicSaved then
        local v2224 = a0.Character and a0.Character:FindFirstChild("HumanoidRootPart")
        if v2224 and CinematicSaved.Anchored ~= nil then
            v2224.Anchored = CinematicSaved.Anchored
        end

        UserInputService.MouseBehavior = CinematicSaved.MouseBehavior
        UserInputService.MouseIconEnabled = CinematicSaved.MouseIconEnabled
        CurrentCamera16.CameraType = CinematicSaved.CameraType
        CurrentCamera16.FieldOfView = 70
        a0.RunView = false
    else
        CurrentCamera16.CameraType = Enum.CameraType.Custom
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end

    a0.CinematicSaved = nil
    if a0.CinematicRefresh then
        a0.CinematicRefresh()
    end
end

getBobbing.StopCinematic = StopCinematic

local function ToggleCinematic(a0)
    if a0.CinematicActive then
        a0:StopCinematic()
        return
    end

    a0:StartCinematic()
end

getBobbing.ToggleCinematic = ToggleCinematic

local function CreateOwnerGui(a0) --[[ Upvalues: Objects (copy), Players (copy), RemoteEvent (copy) ]]
    local v2225 = Objects.OwnerGui:Clone()
    v2225.ResetOnSpawn = false
    v2225.Parent = a0.Player.PlayerGui
    local Main = v2225.Main
    local List8 = v2225.Main.List

    local function updatePlayers() --[[ Upvalues: List8 (copy), Players (upvalue), a0 (copy), RemoteEvent (upvalue) ]]
        local v2226 = List8:GetChildren()
        for k294, k295 in pairs(v2226) do
            if k295:IsA("Frame") and k295.Name ~= "Sample" then
                k295:Destroy()
            end
        end

        local v2230 = Players:GetPlayers()
        for k296, k297 in pairs(v2230) do
            if k297 ~= a0.Player then
                local v2234 = List8.Sample:Clone()
                v2234.Name = k297.Name
                v2234.Username.Text = "@" .. k297.Name
                v2234.DisplayName.Text = k297.DisplayName
                v2234.Visible = true
                v2234.Parent = List8
                v2234.Kick.MouseButton1Click:Connect(function() --[[ Upvalues: RemoteEvent (upvalue), k297 (copy) ]]
                    RemoteEvent:FireServer("KickPlayer", k297)
                end)
            end
        end
    end

    Players.PlayerAdded:Connect(updatePlayers)
    Players.PlayerRemoving:Connect(updatePlayers)
    updatePlayers()
    Main.Close.MouseButton1Click:Connect(function() --[[ Upvalues: Main (copy), v2225 (copy) ]]
        Main.Visible = false
        v2225.Open.Text = "Open Player List"
    end)
    v2225.Open.MouseButton1Click:Connect(function() --[[ Upvalues: Main (copy), v2225 (copy) ]]
        if Main.Visible then
            Main.Visible = false
            v2225.Open.Text = "Open Player List"
            return
        end

        Main.Visible = true
        v2225.Open.Text = "Close Player List"
    end)
    a0:CreateCinematicButton()
end

getBobbing.CreateOwnerGui = CreateOwnerGui

local function CreateCinematicButton(a0) --[[ Upvalues: ReplicatedStorage (copy) ]]
    if a0.CinematicButtonMade then
        return
    end

    a0.CinematicButtonMade = true
    local v2235 = require(ReplicatedStorage.Modules.Icon)
    for k298, k299 in pairs(v2235.container) do
        k299:SetAttribute("CinematicExempt", true)
    end

    local v2239 = v2235.new()
    v2239:setLabel("Cinematic")
    a0.CinematicIcon = v2239
    v2239.selected:Connect(function() --[[ Upvalues: a0 (copy) ]]
        if not a0.CinematicActive then
            a0:StartCinematic()
        end

    end)
    v2239.deselected:Connect(function() --[[ Upvalues: a0 (copy) ]]
        if a0.CinematicActive then
            a0:StopCinematic()
        end

    end)
    a0.CinematicRefresh = function() --[[ Upvalues: a0 (copy) ]]
        if not a0.CinematicIcon then
            return
        end

        if a0.CinematicActive then
            a0.CinematicIcon:select()
            return
        end

        a0.CinematicIcon:deselect()
    end
end

getBobbing.CreateCinematicButton = CreateCinematicButton

local function SetupCraft(a0, a1, a2) --[[ Upvalues: ReplicatedStorage (copy), v13 (copy), v12 (copy), createViewportBaseObjects (copy), createSkinViewport (copy), createViewportObjects (copy), v2 (copy), RemoteEvent (copy) ]]
    local v2240 = false
    a0.CraftGui = ReplicatedStorage.Objects.Craft:Clone()
    a0.CraftGui.Parent = a0.Player.PlayerGui
    local List9 = a0.CraftGui.Main.List
    local CloseButton = a0.CraftGui.Main.CloseButton
    local v2241, v2242
    if a2 then
        v2241 = v13[a2]
        v2240 = true
        v2242 = " Exchange"
        a0.CraftGui.Main.Label.Text = a2 .. v2242
    else
        v2241 = v12
    end

    for k300, k301 in pairs(v2241) do
        local v2246 = List9.Sample:Clone()
        v2246.Name = k300
        v2246.Product.ItemName.Text = k300
        v2246.Cost.Text = "$" .. k301.Cost
        if k301.Cost == 0 then
            v2246.Cost.Text = ""
        end

        v2246.LayoutOrder = k301.Order
        if k301.BaseObject then
            createViewportBaseObjects(v2246.Product, k300)
        else
            if k301.Skin then
                createSkinViewport(v2246.Product, k301.Item, k301.Skin)
            else
                createViewportObjects(v2246.Product, k300, v2[k300])
            end
        end

        v2246.Visible = true
        v2246.Parent = List9
        if v2240 then
            v2246.Craft.Text = "Exchange"
            v2246.Recipe.TextLabel.Text = "Items:"
        end

        task.spawn(function() --[[ Upvalues: v2246 (copy), k301 (copy), createViewportObjects (upvalue), v2 (upvalue) ]]
            local List10 = v2246.Recipe.List
            for k302, k303 in pairs(k301.Recipe) do
                local v2250 = List10.Sample:Clone()
                v2250.Name = k302
                v2250.LayoutOrder = k303.Order
                v2250.ItemName.Text = k302
                v2250.Amount.Text = "x" .. k303.Amount
                createViewportObjects(v2250, k302, v2[k302])
                v2250.Visible = true
                v2250.Parent = List10
            end

        end)
        if k301.Level and a0.Data.Level < k301.Level then
            v2246.LevelReq.Text = "Level " .. k301.Level .. " Required"
            v2246.LevelReq.Visible = true
        else
            v2246.Craft.MouseButton1Click:Connect(function() --[[ Upvalues: RemoteEvent (upvalue), k300 (copy), a1 (copy), a2 (copy) ]]
                RemoteEvent:FireServer("Craft", k300, a1, a2)
            end)
        end
    end

    CloseButton.MouseButton1Click:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:CloseCraft()
    end)
end

getBobbing.SetupCraft = SetupCraft

local function CloseCraft(a0)
    if a0.CraftGui then
        a0.CraftGui:Destroy()
        a0.CraftGui = nil
    end
end

getBobbing.CloseCraft = CloseCraft

local function OpenCraft(a0, a1)
    local v2251 = a1[1]
    if a0.CraftGui then
        return
    end

    a0:SetupCraft(v2251, a1[2])
    while true do
        task.wait(0.1)
        if 15 < (a0.Root.Position - v2251.Position).Magnitude or not a0.CraftGui then
            break
        end
    end

    a0:CloseCraft()
end

getBobbing.OpenCraft = OpenCraft

local function KillLog1(a0, a1) --[[ Upvalues: TweenService (copy) ]]
    local KillLog = a0.HUD.KillLog
    local v2252 = KillLog.Sample:Clone()
    game.Debris:AddItem(v2252, 5)
    v2252.Name = "newLog"
    v2252.Text = a1[1] .. " has  <font color='rgb(255, 0, 0)'>defeated</font> " .. a1[2]
    v2252.Visible = true
    v2252.Parent = KillLog
    task.delay(2.5, function() --[[ Upvalues: TweenService (upvalue), v2252 (copy) ]]
        local v2253 = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        TweenService:Create(v2252, v2253, {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
    end)
end

getBobbing.KillLog = KillLog1

local function HatchRadar(a0) --[[ Upvalues: RunService (copy) ]]
    local Part2 = Instance.new("Part")
    Part2.Material = Enum.Material.Neon
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.Anchored = true
    Part2.Color = Color3.fromRGB(0, 255, 0)
    Part2.CFrame = a0.Root.CFrame
    Part2.Size = Vector3.new(0.5, 0.5, 2)
    Part2.Parent = workspace
    a0.RadarPart = Part2
    local v2254 = Enum.RenderPriority.Camera.Value + 1
    RunService:BindToRenderStep("RadarPart", v2254, function() --[[ Upvalues: Part2 (copy), a0 (copy) ]]
        local v2255 = a0.Root.Position + Vector3.new(0, 1.25, 0)
        local v2256 = CFrame.new(v2255, Vector3.new(-0.22499999403953552, 3.0999999046325684, 236.52499389648438))
        Part2.CFrame = v2256 * CFrame.new(0, 0, -3)
    end)
    a0.HUD.HATCHLABEL.Visible = true
end

getBobbing.HatchRadar = HatchRadar

local function HatchRadarOff(a0) --[[ Upvalues: RunService (copy) ]]
    if a0.RadarPart then
        a0.RadarPart:Destroy()
        a0.RadarPart = nil
    end

    RunService:UnbindFromRenderStep("RadarPart")
    a0.HUD.HATCHLABEL.Visible = false
end

getBobbing.HatchRadarOff = HatchRadarOff

local function UpdateGlobalShops(a0, a1)
    a0.GlobalShops = a1
    if a0.GlobalShopGui then
        a0:UpdateGlobalShop()
    end
end

getBobbing.UpdateGlobalShops = UpdateGlobalShops

local function getOrderedFrames(a0)
    local t8 = {}
    local v2257 = a0:GetChildren()
    for k304, k305 in ipairs(v2257) do
        if k305:IsA("ImageButton") and k305.Name ~= "Sample" then
            table.insert(t8, k305)
        end
    end

    table.sort(t8, function(a0, a1)
        if a0.LayoutOrder == a1.LayoutOrder then
            local v2261 = a0:GetAttribute("Price")
            return v2261 < a1:GetAttribute("Price")
        end

        return a0.LayoutOrder < a1.LayoutOrder
    end)
    return t8
end

local function CloseGlobalShopPopup(a0) --[[ Upvalues: getOrderedFrames (copy), TweenService (copy) ]]
    if not a0.GlobalShopGui then
        return
    end

    local List11 = a0.GlobalShopGui.Main.List
    local Popup = List11.Popup
    local v2262 = getOrderedFrames(List11)
    local v2263 = UDim2.new(0, 0, 0, 10)
    if Popup.Visible then
        local v2264 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v2265 = Popup.Position - UDim2.new(0, 0, 0, Popup.AbsoluteSize.Y + 10)
        local v2266 = {Position = v2265}
        TweenService:Create(Popup, v2264, v2266):Play()
        task.delay(0.25, function() --[[ Upvalues: Popup (copy) ]]
            Popup.Visible = false
        end)
        local v2267 = getOrderedFrames(List11)
        for k306, k307 in pairs(v2267) do
            k307.LayoutOrder = k306
            local v2271 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local v2272 = {Position = v2263}
            TweenService:Create(k307, v2271, v2272):Play()
            v2263 = v2263 + UDim2.new(0, 0, 0, k307.AbsoluteSize.Y + 10)
        end

        local v2273 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v2274 = {CanvasSize = v2263}
        TweenService:Create(List11, v2273, v2274):Play()
    end
end

getBobbing.CloseGlobalShopPopup = CloseGlobalShopPopup

local function GlobalShopPopup(a0, a1, a2, a3) --[[ Upvalues: getOrderedFrames (copy), v2 (copy), MarketplaceService (copy), TweenService (copy) ]]
    if not a0.GlobalShopGui then
        return
    end

    local List12 = a0.GlobalShopGui.Main.List
    a0:UpdateGlobalShop()
    local v2275 = getOrderedFrames(List12)
    local v2276 = a1.AbsoluteSize.Y + 10
    local v2277 = 0
    for i30 = 1, a2 do
        v2277 = v2277 + (v2275[i30].AbsoluteSize.Y + 10)
    end

    a1.Position = UDim2.new(0.5, 0, 0, v2275[a2].AbsoluteSize.Y)
    a1.Visible = true
    local v2280 = v2[a0.CurrentPopup]
    if v2280 then
        if v2280.ProductId then
            local v2281 = MarketplaceService:GetProductInfo(v2280.ProductId, Enum.InfoType.Product)
            local v2283 = v2281 and v2281.PriceInRobux
            if v2283 then
                a1.BuyRobux.Text = "R$" .. v2281.PriceInRobux
                -- jump to 96 (out of range)
            end

            a1.BuyRobux.Text = "R$???"
            -- branch continues at 91
        end
    else
        a1.BuyRobux.Text = "N/A"
    end

    local v2284 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v2285 = {Position = UDim2.new(0.5, 0, 0, v2277 + 10)}
    TweenService:Create(a1, v2284, v2285):Play()
    for i31 = a2 + 1, #v2275 do
        local v2288 = v2275[i31]
        v2285 = {Position = v2288.Position + UDim2.new(0, 0, 0, v2276 + 10)}
        local v2289 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(v2288, v2289, v2285):Play()
    end

    local v2290 = v2277 + v2276 + 10
    local v2291 = #v2275
    i31 = 1
    for i32 = a2 + 1, v2291, i31 do
        v2290 = v2290 + (v2275[i32].AbsoluteSize.Y + 10)
    end

    List12.CanvasSize = UDim2.new(0, 0, 0, v2290)
    v2290 = v2275[a2]
    v2275 = List12.AbsoluteWindowSize
    local AbsoluteSize4 = v2290.AbsoluteSize
    local v2292 = List12.CanvasPosition.Y + (v2290.AbsolutePosition.Y - List12.AbsolutePosition.Y)
    local v2293 = v2292 - v2275.Y / 2
    local v2294 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v2295 = {CanvasPosition = Vector2.new(List12.CanvasPosition.X, math.clamp(v2293 + AbsoluteSize4.Y / 2, 0, List12.AbsoluteCanvasSize.Y - v2275.Y))}
    TweenService:Create(List12, v2294, v2295):Play()
end

getBobbing.GlobalShopPopup = GlobalShopPopup

local function UpdateGlobalShop(a0)
    if not a0.GlobalShopGui then
        return
    end

    local v2296 = a0.GlobalShops[a0.GlobalShopGui.Name]
    if not v2296 then
        return
    end

    local List13 = a0.GlobalShopGui.Main.List
    local Popup1 = List13.Popup
    for k308, k309 in pairs(v2296) do
        if k308 ~= "Expire" then
            local v2301 = List13:FindFirstChild(k308)
            if v2301 then
                v2301.Stock.Text = "X" .. k309.Stock .. " Stock"
                if k309.Stock <= 0 then
                    v2301.Price.Text = "No Stock"
                    v2301.Price.TextColor3 = Color3.fromRGB(255, 0, 0)
                    if a0.CurrentPopup == k308 then
                        Popup1.Buy.Text = "NO STOCK"
                        Popup1.Buy.BackgroundColor3 = Color3.fromRGB(122, 122, 122)
                        -- branch continues at 128
                    end
                else
                    v2301.Price.Text = "$" .. k309.Price
                    v2301.Price.TextColor3 = Color3.fromRGB(71, 212, 63)
                    if a0.CurrentPopup == k308 then
                        Popup1.Buy.Text = "$" .. k309.Price
                        Popup1.Buy.BackgroundColor3 = Color3.fromRGB(71, 212, 63)
                    end
                end
            end
        end
    end
end

getBobbing.UpdateGlobalShop = UpdateGlobalShop

local function CloseGlobalShop(a0)
    if a0.GlobalShopGui then
        a0.GlobalShopGui:Destroy()
        a0.GlobalShopGui = nil
    end

    a0.CurrentPopup = nil
end

getBobbing.CloseGlobalShop = CloseGlobalShop

local function CreateGlobalShop(a0, a1) --[[ Upvalues: Objects (copy), Players (copy), RemoteEvent (copy), createViewportObjects (copy), v2 (copy), MarketplaceService (copy), getOrderedFrames (copy) ]]
    local v2302 = a1[1]
    local v2303 = a1[2]
    if not a0.GlobalShops[v2302] then
        return
    end

    local v2304 = a0.GlobalShops[v2302]
    local v2305 = Objects.StorageShop:Clone()
    v2305.Enabled = false
    v2305.Name = v2302
    v2305.Parent = a0.Player.PlayerGui
    local Main1 = v2305.Main
    local List14 = Main1.List
    local Popup2 = List14.Popup
    local TopBar = Main1.TopBar
    local GiftingFrame = v2305.GiftingFrame

    local function updateGiftingFrame(a0) --[[ Upvalues: GiftingFrame (copy), Players (upvalue), a0 (copy), RemoteEvent (upvalue), v2303 (copy) ]]
        local List15 = GiftingFrame.List
        GiftingFrame.Label.Text = a0
        local v2306 = List15:GetChildren()
        for k310, k311 in pairs(v2306) do
            if k311:IsA("Frame") and k311.Name ~= "Sample" then
                k311:Destroy()
            end
        end

        local v2310 = Players:GetPlayers()
        for k312, k313 in pairs(v2310) do
            if k313 ~= a0.Player then
                local v2314 = game.Players:GetUserThumbnailAsync(k313.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
                local v2315 = List15.Sample:Clone()
                v2315.Name = k313.Name
                v2315.PlayerName.Text = k313.Name
                v2315.PlayerIcon.Image = v2314
                v2315.Button.BackgroundColor3 = Color3.fromRGB(255, 226, 151)
                v2315.Button.Text = "Gift"
                v2315.Visible = true
                v2315.Parent = List15
                v2315.Button.MouseButton1Click:Connect(function() --[[ Upvalues: RemoteEvent (upvalue), k313 (copy), a0 (upvalue), a0 (copy), v2303 (upvalue) ]]
                    RemoteEvent:FireServer("UpdateGifting", k313)
                    while true do
                        task.wait(0.1)
                        if a0.Player:GetAttribute("Gifting") then
                            break
                        end
                    end

                    RemoteEvent:FireServer("GiftProduct", a0, v2303)
                end)
            end
        end
    end

    local v2316 = {"Expire", "Refresh"}
    local v2317 = 0
    a0.CurrentPopup = nil
    for k314, k315 in pairs(v2304) do
        if not table.find(v2316, k314) then
            local v2321 = List14.Sample:Clone()
            v2321.Name = k314
            v2321.Price.Text = "$" .. k315.Price
            v2321.Stock.Text = "X" .. k315.Stock .. " Stock"
            v2321.ItemName.Text = k314
            v2321.Rarity.Label.Text = k315.Rarity
            v2321.Rarity.BackgroundColor3 = _G.Utl.RarityInfo[k315.Rarity][1]
            v2321.LayoutOrder = _G.Utl.ShopRarityOrder[k315.Rarity]
            v2321.Visible = true
            v2321.Parent = List14
            v2321:SetAttribute("Price", k315.Price)
            createViewportObjects(v2321.ViewportFrame, k314, v2[k314])
            v2321.MouseButton1Click:Connect(function() --[[ Upvalues: v2317 (ref), a0 (copy), k314 (copy), Popup2 (copy), v2321 (copy), k315 (copy) ]]
                local v2322 = time() - v2317
                if v2322 < 0.52 then
                    return
                end

                v2317 = time()
                if a0.CurrentPopup and k314 == a0.CurrentPopup then
                    a0.CurrentPopup = nil
                    a0:CloseGlobalShopPopup()
                    return
                end

                if a0.CurrentPopup then
                    a0:CloseGlobalShopPopup()
                    task.wait(0.26)
                end

                a0.CurrentPopup = k314
                a0:GlobalShopPopup(Popup2, v2321.LayoutOrder, k315)
            end)
        end
    end

    Popup2.Buy.MouseButton1Click:Connect(function() --[[ Upvalues: v2317 (ref), RemoteEvent (upvalue), v2302 (copy), a0 (copy), v2303 (copy) ]]
        local v2323 = time() - v2317
        if v2323 < 0.2 then
            return
        end

        v2317 = time()
        local t9 = {v2302, a0.CurrentPopup, v2303}
        RemoteEvent:FireServer("GlobalBuy", t9)
    end)
    Popup2.BuyRobux.MouseButton1Click:Connect(function() --[[ Upvalues: v2317 (ref), v2 (upvalue), a0 (copy), MarketplaceService (upvalue) ]]
        local v2324 = time() - v2317
        if v2324 < 0.2 then
            return
        end

        v2317 = time()
        local v2325 = v2[a0.CurrentPopup]
        if not v2325 then
            return
        end

        local ProductId = v2325.ProductId
        if not ProductId then
            return
        end

        MarketplaceService:PromptProductPurchase(a0.Player, ProductId)
    end)
    Popup2.Gift.MouseButton1Click:Connect(function() --[[ Upvalues: v2317 (ref), a0 (copy), Main1 (copy), updateGiftingFrame (copy), GiftingFrame (copy) ]]
        local v2326 = time() - v2317
        if v2326 < 0.2 then
            return
        end

        v2317 = time()
        if not a0.CurrentPopup then
            return
        end

        Main1.Visible = false
        updateGiftingFrame(a0.CurrentPopup)
        GiftingFrame.Visible = true
    end)
    GiftingFrame.Close.MouseButton1Click:Connect(function() --[[ Upvalues: v2317 (ref), GiftingFrame (copy), Main1 (copy) ]]
        local v2327 = time() - v2317
        if v2327 < 0.2 then
            return
        end

        v2317 = time()
        GiftingFrame.Visible = false
        Main1.Visible = true
    end)
    TopBar.Refresh.MouseButton1Click:Connect(function() --[[ Upvalues: v2317 (ref), MarketplaceService (upvalue), a0 (copy) ]]
        local v2328 = time() - v2317
        if v2328 < 0.2 then
            return
        end

        v2317 = time()
        MarketplaceService:PromptProductPurchase(a0.Player, 3334813601)
    end)
    local v2329 = false
    TopBar.CloseButton.MouseButton1Click:Connect(function() --[[ Upvalues: v2329 (ref), a0 (copy) ]]
        v2329 = true
        a0:CloseGlobalShop()
    end)
    task.spawn(function() --[[ Upvalues: v2329 (ref), a0 (copy), v2302 (copy), TopBar (copy), v2303 (copy) ]]
        while not v2329 do
            local v2330 = a0.GlobalShops[v2302]
            local v2331 = v2330
            if v2331 then
                local v2332 = tonumber(v2330.Expire)
            end

            local v2334 = v2331 and math.max(0, v2331 - os.time()) or 0
            if 0 < v2334 then
                TopBar.NextRefresh.Text = "New shop in " .. _G.Utl.formatTimeForShop(v2334)
            else
                TopBar.NextRefresh.Text = "Refreshing shop..."
            end

            task.wait(1)
            local v2335 = v2303 and v2303:FindFirstChild("HumanoidRootPart")
            if not a0.Root or not v2335 or 14 < (a0.Root.Position - v2335.Position).Magnitude then
                v2329 = true
                a0:CloseGlobalShop()
                return
            end
        end

    end)
    k315 = 0
    local v2336 = 10
    v2316 = UDim2.new(0, 0, k315, v2336)
    v2304 = getOrderedFrames(List14)
    for k316, k317 in pairs(v2304) do
        k317.LayoutOrder = k316
        k317.Position = v2316
        v2316 = v2316 + UDim2.new(0, 0, 0, k317.AbsoluteSize.Y + 10)
    end

    List14.CanvasSize = v2316
    v2305.Enabled = true
    a0.GlobalShopGui = v2305
    a0:UpdateGlobalShop()
end

getBobbing.CreateGlobalShop = CreateGlobalShop

local function GotGifted(a0, a1)
    local v2340 = a1[2]
    local Gifted = a0.HUD.Gifted
    local v2341 = {Sound = "Gifted", Origin = a0.HUD}
    _G.Utl.PlaySound(v2341)
    local v2342 = Gifted.Sample:Clone()
    v2342.Name = v2340
    v2342.Text = "<font color='#52ff6c'>" .. a1[1] .. "</font> has gifted you <font color='#be4fff'>" .. v2340 .. "</font>"
    v2342.Visible = true
    v2342.Parent = Gifted
    game.Debris:AddItem(v2342, 2.5)
end

getBobbing.GotGifted = GotGifted

local function GlobalMessage(a0, a1) --[[ Upvalues: TweenService (copy) ]]
    local Noti1 = a0.HUD.Noti
    local v2343 = Noti1.Sample:Clone()
    v2343.TextTransparency = 1
    v2343.TextStrokeTransparency = 1
    v2343.Text = a1.Text
    v2343.Visible = true
    v2343.Parent = Noti1
    local v2344 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(v2343, v2344, {TextTransparency = 0, TextStrokeTransparency = 0}):Play()
    local v2345 = {Sound = "GlobalPing", Speed = 0.9, Origin = a0.Player}
    _G.Utl.PlaySound(v2345)
    task.wait(a1.Lasts)
    local v2346 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(v2343, v2346, {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
    game.Debris:AddItem(v2343, 1)
end

getBobbing.GlobalMessage = GlobalMessage

local function ClearTempCons(a0)
    for k318, k319 in pairs(a0.TempCons) do
        k319:Disconnect()
        a0.TempCons[k318] = nil
    end
end

getBobbing.ClearTempCons = ClearTempCons

local function ClearBankCons(a0)
    for k320, k321 in pairs(a0.BankCons) do
        k321:Disconnect()
        a0.BankCons[k320] = nil
    end
end

getBobbing.ClearBankCons = ClearBankCons

local function UpdateBaits(a0, a1) --[[ Upvalues: v19 (copy) ]]
    if not a0.TempCons.BaitButton then
        return
    end

    local Baits = a0.HUD.Baits
    local List16 = Baits.List
    local Info = Baits.Info
    local v2353 = List16:GetChildren()
    for k322, k323 in pairs(v2353) do
        local v2358 = k323:IsA("TextButton")
        if v2358 then
            v2358 = k323.Name
            if v2358 ~= "Sample" then
                k323:Destroy()
            end
        end
    end

    local v2359 = nil

    local function updateInfo(a0) --[[ Upvalues: v2359 (ref), Info (copy), v19 (upvalue), a0 (copy) ]]
        local v2360 = a0
        if v2359 and a0 == v2359 then
            v2359 = nil
            Info.Visible = false
            return
        end

        local v2361 = v19[a0]
        Info.BaitName.Text = a0
        Info.Luck.Text = v2361.Luck
        Info.Speed.Text = v2361.Speed
        v2359 = a0
        Info.Visible = true
        a0.CurrentBaitSelect = v2360
        local v2362 = a0.Character:GetAttribute("CurrentBait")
        if v2362 and a0.CurrentBaitSelect and v2362 == a0.CurrentBaitSelect then
            Info.Equip.Text = "Unequip"
            return
        end

        Info.Equip.Text = "Equip"
    end

    for k324, k325 in pairs(a1) do
        local v2366 = List16.Sample:Clone()
        v2366.Name = k324
        v2366.Text = k324 .. " (x" .. k325 .. ")"
        v2366.Visible = true
        v2366.Parent = List16
        local v2367 = k324 .. "Clicked"
        a0.TempCons[v2367] = v2366.MouseButton1Click:Connect(function() --[[ Upvalues: updateInfo (copy), k324 (copy) ]]
            updateInfo(k324)
        end)
    end

    if a0.CurrentBaitSelect then
        updateInfo(a0.CurrentBaitSelect)
    end
end

getBobbing.UpdateBaits = UpdateBaits

local function ShowBaits(a0, a1) --[[ Upvalues: UnreliableRemoteEvent (copy) ]]
    local Baits1 = a0.HUD.Baits
    local Button2 = Baits1.Button
    local Info1 = Baits1.Info
    local List17 = Baits1.List
    a0.TempCons.BaitButton = Button2.MouseButton1Click:Connect(function() --[[ Upvalues: List17 (copy), Info1 (copy), a0 (copy) ]]
        List17.Visible = not List17.Visible
        if not List17.Visible then
            Info1.Visible = false
            a0.CurrentBaitSelect = nil
        end

    end)
    a0.TempCons.EquipButton = Info1.Equip.MouseButton1Click:Connect(function() --[[ Upvalues: UnreliableRemoteEvent (upvalue), a0 (copy) ]]
        UnreliableRemoteEvent:FireServer("SelectBait", a0.CurrentBaitSelect)
    end)
    local v2368 = a0.Character:GetAttributeChangedSignal("CurrentBait")
    a0.TempCons.CurrentBaitChanged = v2368:Connect(function() --[[ Upvalues: a0 (copy), Button2 (copy) ]]
        local v2369 = a0.Character:GetAttribute("CurrentBait")
        if v2369 then
            Button2.Text = "Current Bait: " .. v2369
            return
        end

        Button2.Text = "Current Bait: None"
    end)
    a0:UpdateBaits(a1)
    Baits1.Visible = true
end

getBobbing.ShowBaits = ShowBaits

local function HideBaits(a0)
    local Baits2 = a0.HUD.Baits
    a0:ClearTempCons()
    a0.CurrentBaitSelect = nil
    Baits2.List.Visible = false
    Baits2.Visible = false
end

getBobbing.HideBaits = HideBaits

local function LevelChanged(a0, a1)
    a0.HUD.Level.LevelLabel.Text = "Level " .. a1
    a0.Data.Level = a1
end

getBobbing.LevelChanged = LevelChanged

local function EXPChanged(a0)
    local v2370 = _G.Utl.ExpCost(a0.Data.Level)
    local v2371 = a0.Data.EXP / v2370
    if v2371 < 0 then
        v2371 = 0
    else
        if 1 < v2371 then
            v2371 = 1
        end
    end

    local v2372 = UDim2.new(v2371, 0, 1, 0)
    a0.HUD.Level.Bar:TweenSize(v2372, "Out", "Linear", 0.25, true)
    local v2373 = math.floor(a0.Data.EXP)
    a0.HUD.Level.AmountLabel.Text = v2373 .. "/" .. v2370
    if _G.Utl.MaxLevel <= a0.Data.Level then
        local v2374 = UDim2.new(1, 0, 1, 0)
        a0.HUD.Level.Bar:TweenSize(v2374, "Out", "Linear", 0.05, true)
        a0.HUD.Level.AmountLabel.Text = "MAX"
    end
end

getBobbing.EXPChanged = EXPChanged

local function CandyCornChanged(a0, a1)
    local v2375 = tonumber(a1) or 0
    if v2375 == v2375 then
        if math.abs(v2375) ~= math.huge then
            -- jump to 16
        end
    end

    v2375 = 0
    v2375 = math.max(0, math.floor(v2375))
    a0.Data.CandyCorn = v2375
    local v2376 = a0.HUD and a0.HUD:FindFirstChild("Money")
    local v2378 = v2376 and v2376:FindFirstChild("CandyCorn")
    if v2378 then
        v2378.Text = _G.Utl.addComas(tostring(v2375))
    end
end

getBobbing.CandyCornChanged = CandyCornChanged

local function MoneyChanged(a0, a1) --[[ Upvalues: TweenService (copy) ]]
    local v2379 = {Sound = "Coins", Origin = a0.Player, Speed = 0.95 + math.random() * 0.1}
    _G.Utl.PlaySound(v2379)
    local v2380 = math.floor(a1 - a0.OldMoney)
    local v2381 = a0.HUD.MoneyChange:Clone()
    game.Debris:AddItem(v2381, 1.5)
    v2381.Visible = true
    local v2382
    if 0 <= v2380 then
        v2381.Text = "+" .. _G.Utl.addComas(tostring(v2380))
        local v2383 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v2384 = {Position = v2381.Position - UDim2.new(0, 0, 0.04, 0)}
        v2382 = TweenService:Create(v2381, v2383, v2384)
    else
        v2381.Text = "-" .. _G.Utl.addComas(tostring(math.abs(v2380)))
        v2381.TextColor3 = Color3.fromRGB(212, 65, 65)
        local v2385 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v2386 = {Position = v2381.Position + UDim2.new(0, 0, 0.04, 0)}
        v2382 = TweenService:Create(v2381, v2385, v2386)
    end

    v2381.Parent = a0.HUD
    v2382:Play()
    task.delay(0.5, function() --[[ Upvalues: TweenService (upvalue), v2381 (copy) ]]
        local v2387 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(v2381, v2387, {TextStrokeTransparency = 1, TextTransparency = 1}):Play()
    end)
    a0.HUD.Money.Text = "$" .. _G.Utl.addComas(tostring(math.floor(a1)))
    a0.OldMoney = a1
end

getBobbing.MoneyChanged = MoneyChanged

local function HungerChanged(a0, a1)
    local v2388 = a1 / 100
    if v2388 < 0 then
        v2388 = 0
    else
        if 1 < v2388 then
            v2388 = 1
        end
    end

    local v2389 = UDim2.new(v2388, 0, 1, 0)
    a0.HUD.Hunger.Bar:TweenSize(v2389, "Out", "Linear", 0.25, true)
    local v2390 = math.floor(a1)
    a0.HUD.Hunger.AmountLabel.Text = v2390 .. "%"
end

getBobbing.HungerChanged = HungerChanged

local function ThirstChanged(a0, a1)
    local v2391 = a1 / 100
    if v2391 < 0 then
        v2391 = 0
    else
        if 1 < v2391 then
            v2391 = 1
        end
    end

    local v2392 = UDim2.new(v2391, 0, 1, 0)
    a0.HUD.Thirst.Bar:TweenSize(v2392, "Out", "Linear", 0.25, true)
    local v2393 = math.floor(a1)
    a0.HUD.Thirst.AmountLabel.Text = v2393 .. "%"
end

getBobbing.ThirstChanged = ThirstChanged

local function ArmorChanged(a0, a1)
    local v2394 = a1 / 100
    if v2394 < 0 then
        v2394 = 0
    else
        if 1 < v2394 then
            v2394 = 1
        end
    end

    local v2395 = UDim2.new(v2394, 0, 1, 0)
    a0.HUD.Armor.Bar:TweenSize(v2395, "Out", "Linear", 0.25, true)
    local v2396 = math.floor(a1)
    a0.HUD.Armor.AmountLabel.Text = v2396 .. "%"
end

getBobbing.ArmorChanged = ArmorChanged

local function CombatLogChanged(a0, a1)
    a0.InCombat = a1 == true
    a0.HUD.InCombat.Visible = a1
end

getBobbing.CombatLogChanged = CombatLogChanged

local function RegisterSafezoneGate(a0, a1)
    if typeof(a1) ~= "Instance" then
        return
    end

    if not (a1.Name == "SZGATE" and a1:IsA("BasePart")) then
        return
    end

    local SafezoneGates = a0.SafezoneGates
    if not SafezoneGates or SafezoneGates[a1] then
        return
    end

    a1.Anchored = true
    a1.CanCollide = false
    a1.CanTouch = false
    a1.CanQuery = false
    a1.Transparency = 1
    local v2397 = {Size = a1.Size, CFrame = a1.CFrame}
    SafezoneGates[a1] = v2397
    a0.SafezoneGatesDirty = true
end

getBobbing.RegisterSafezoneGate = RegisterSafezoneGate

local function SetupSafezoneGates(a0)
    a0.SafezoneGates = {}
    a0.SafezoneGateAlpha = 0
    a0.SafezoneGatesDirty = false
    local Map1 = workspace:FindFirstChild("Map")
    local v2400 = Map1 and Map1:FindFirstChild("SAFEZONE GATES")
    if not v2400 then
        return
    end

    local v2401 = v2400:GetChildren()
    for k326, k327 in ipairs(v2401) do
        a0:RegisterSafezoneGate(k327)
    end

    v2400.ChildAdded:Connect(function(a0) --[[ Upvalues: a0 (copy) ]]
        a0:RegisterSafezoneGate(a0)
    end)
end

getBobbing.SetupSafezoneGates = SetupSafezoneGates

local function UpdateSafezoneGates(a0, a1)
    local SafezoneGates1 = a0.SafezoneGates
    if not SafezoneGates1 or next(SafezoneGates1) == nil then
        return
    end

    local v2405 = 0
    local v2406
    if a0.InCombat then
        local v2408 = a0.Player:GetAttribute("Safezone") == true
        local Map2 = workspace:FindFirstChild("Map")
        v2406 = "SafezoneDetect"
        local v2410 = Map2:FindFirstChild(v2406)
        local v2411 = Map2 and v2410
        if v2411 and a0.Root and a0.Root.Parent then
            Map2 = v2411.CFrame:PointToObjectSpace(a0.Root.Position)
            local v2412 = v2411.Size / 2
            local v2413 = false
            local v2414 = math.abs(Map2.X)
            if v2414 <= v2412.X then
                v2413 = false
                local v2415 = math.abs(Map2.Z)
                if v2415 <= v2412.Z then
                    local v2416 = math.abs(Map2.Y)
                    v2413 = v2416 <= v2412.Y + 60
                end
            end

            v2408 = v2413
        end

        if not v2408 then
            v2405 = 1
        end
    end

    local v2417 = a0.SafezoneGateAlpha or 0
    if v2417 == v2405 and not a0.SafezoneGatesDirty then
        return
    end

    a0.SafezoneGatesDirty = false
    if v2417 ~= v2405 then
        if v2405 == 1 then
            v2417 = 1
        else
            v2406 = (a1 or 0) * 8
            local v2418 = 1
            v2417 = v2417 + (v2405 - v2417) * math.min(v2406, v2418)
            local v2419 = math.abs(v2405 - v2417)
            if v2419 < 0.01 then
                v2417 = v2405
            end
        end

        a0.SafezoneGateAlpha = v2417
    end

    for k328, k329 in pairs(SafezoneGates1) do
        if not k328.Parent then
            SafezoneGates1[k328] = nil
        else
            local v2423 = k329.Size.Y * v2417
            v2405 = math.max(v2423, 0.05)
            k328.Size = Vector3.new(k329.Size.X, v2405, k329.Size.Z)
            local v2424 = (k329.Size.Y - v2405) / 2
            k328.CFrame = k329.CFrame + Vector3.new(0, v2424, 0)
            k328.Transparency = 1 - v2417
            k328.CanCollide = 0.05 < v2417
        end
    end
end

getBobbing.UpdateSafezoneGates = UpdateSafezoneGates

local function InitShop(a0) --[[ Upvalues: v20 (copy) ]]
    local Shop = a0.HUD.Shop
    for k330, k331 in pairs(v20.Money) do
        local v2428 = Shop.Money.Sample:Clone()
        v2428.Name = k330
        v2428.LayoutOrder = k331.Order or 99
        v2428.Text = "$" .. _G.Utl.addComas(tostring(k331.Money))
        v2428.Visible = true
        v2428.Parent = Shop.Money
    end

    for k332, k333 in pairs(v20.Other) do
        local v2432 = Shop.Other.Sample:Clone()
        v2432.Name = k332
        v2432.LayoutOrder = k333.Order or 99
        v2432.Text = k333.Label
        v2432.Visible = true
        v2432.Parent = Shop.Other
    end
end

getBobbing.InitShop = InitShop

local function OpenShop(a0) --[[ Upvalues: MarketplaceService (copy), v20 (copy) ]]
    a0:ClearTempCons()
    local Shop1 = a0.HUD.Shop
    local Other = Shop1.Other
    local v2433 = Shop1.Money:GetChildren()
    for k334, k335 in pairs(v2433) do
        if k335:IsA("TextButton") and k335.Name ~= "Sample" then
            local v2437 = k335.Name .. "Clicked"
            a0.TempCons[v2437] = k335.MouseButton1Click:Connect(function() --[[ Upvalues: MarketplaceService (upvalue), a0 (copy), k335 (copy) ]]
                MarketplaceService:PromptProductPurchase(a0.Player, tonumber(k335.Name))
            end)
        end
    end

    local v2438 = Other:GetChildren()
    for k336, k337 in pairs(v2438) do
        if k337:IsA("TextButton") and k337.Name ~= "Sample" then
            local v2442 = v20.Other[tonumber(k337.Name)]
            local v2443 = k337.Name .. "Clicked"
            a0.TempCons[v2443] = k337.MouseButton1Click:Connect(function() --[[ Upvalues: v2442 (copy), MarketplaceService (upvalue), a0 (copy), k337 (copy) ]]
                if v2442.Gamepass then
                    MarketplaceService:PromptGamePassPurchase(a0.Player, tonumber(k337.Name))
                    return
                end

                MarketplaceService:PromptProductPurchase(a0.Player, tonumber(k337.Name))
            end)
        end
    end

    Shop1.Visible = true
end

getBobbing.OpenShop = OpenShop

local function CloseShop(a0)
    a0:ClearTempCons()
    a0.HUD.Shop.Visible = false
end

getBobbing.CloseShop = CloseShop

local function UpdateKeybinds(a0)
    local v2444 = a0.Data and a0.Data.Keybinds
    if typeof(v2444) ~= "table" then
        return
    end

    local Main2 = a0.HUD.Keybinds.Main
    for k338, k339 in pairs(_G.Utl.DefaultBindings) do
        local v2449
        if not (typeof(v2444[k338]) == "table" and v2444[k338]) then
            v2449 = {}
        end

        local v2451 = typeof(v2449.Keyboard) == "string" and v2449.Keyboard or ""
        local v2453 = typeof(v2449.Console) == "string" and v2449.Console or ""
        local v2454 = _G.Utl.TranslateKeys[v2451] or k339.Keyboard
        local v2455 = _G.Utl.TranslateKeys[v2453] or k339.Console
        local v2456 = a0.MainContext:FindFirstChild(k338)
        if v2456 then
            local Keyboard2 = v2456:FindFirstChild("Keyboard")
            local Console2 = v2456:FindFirstChild("Console")
            if Keyboard2 then
                Keyboard2.KeyCode = v2454
            end

            if Console2 then
                Console2.KeyCode = v2455
            end
        end

        local v2457 = Main2:FindFirstChild(k338)
        if v2457 then
            v2457.Keyboard.Text = v2454.Name
            v2457.Console.Text = v2455.Name
        end
    end
end

getBobbing.UpdateKeybinds = UpdateKeybinds

local function CloseKeybinds(a0)
    if a0.KeybindChangeCon then
        a0.KeybindChangeCon:Disconnect()
        a0.KeybindChangeCon = nil
    end

    if a0.CurrentChanging then
        a0.CurrentChanging.UIStroke.Thickness = 1
        a0.CurrentChanging.UIStroke.Color = Color3.fromRGB(255, 255, 255)
        a0.CurrentChanging = nil
    end

    a0.HUD.Keybinds.Visible = false
    a0:ClearTempCons()
end

getBobbing.CloseKeybinds = CloseKeybinds

local function InitKeybinds(a0) --[[ Upvalues: UserInputService (copy), RemoteEvent (copy) ]]
    a0:ClearTempCons()
    local Main3 = a0.HUD.Keybinds.Main
    for k340, k341 in pairs(_G.Utl.DefaultBindings) do
        local v2461 = Main3:FindFirstChild(k340)
        if not v2461 then
            v2461 = Main3.Sample:Clone()
            v2461.Name = k340
            v2461.ActionName.Text = k340
            v2461.Visible = true
            v2461.Parent = Main3
        end

        local function stopBinding() --[[ Upvalues: a0 (copy) ]]
            if a0.KeybindChangeCon then
                a0.KeybindChangeCon:Disconnect()
                a0.KeybindChangeCon = nil
            end

            if a0.CurrentChanging then
                a0.CurrentChanging.UIStroke.Thickness = 1
                a0.CurrentChanging.UIStroke.Color = Color3.fromRGB(255, 255, 255)
                a0.CurrentChanging = nil
            end
        end

        if k341.Keyboard then
            local v2462 = k340 .. "Keyboard"
            a0.TempCons[v2462] = v2461.Keyboard.Activated:Connect(function() --[[ Upvalues: a0 (copy), v2461 (ref), UserInputService (upvalue), RemoteEvent (upvalue), k340 (copy) ]]
                if a0.CurrentChanging then
                    if a0.KeybindChangeCon then
                        a0.KeybindChangeCon:Disconnect()
                        a0.KeybindChangeCon = nil
                    end

                    if a0.CurrentChanging then
                        a0.CurrentChanging.UIStroke.Thickness = 1
                        a0.CurrentChanging.UIStroke.Color = Color3.fromRGB(255, 255, 255)
                        a0.CurrentChanging = nil
                    end
                end

                a0.CurrentChanging = v2461.Keyboard
                a0.CurrentChanging.UIStroke.Thickness = 3
                a0.CurrentChanging.UIStroke.Color = Color3.fromRGB(116, 202, 255)
                a0.KeybindChangeCon = UserInputService.InputBegan:Connect(function(a0) --[[ Upvalues: a0 (upvalue), RemoteEvent (upvalue), k340 (upvalue) ]]
                    local v2463 = nil
                    if _G.Utl.tabFind(_G.Utl.KeyboardBindings, a0.KeyCode) then
                        v2463 = a0.KeyCode.Name
                    else
                        if a0.UserInputType == Enum.UserInputType.MouseButton1 then
                            v2463 = Enum.KeyCode.MouseLeftButton.Name
                        else
                            if a0.UserInputType == Enum.UserInputType.MouseButton2 then
                                v2463 = Enum.KeyCode.MouseRightButton.Name
                            end
                        end
                    end

                    if not v2463 then
                        return
                    end

                    if a0.KeybindChangeCon then
                        a0.KeybindChangeCon:Disconnect()
                        a0.KeybindChangeCon = nil
                    end

                    if a0.CurrentChanging then
                        a0.CurrentChanging.UIStroke.Thickness = 1
                        a0.CurrentChanging.UIStroke.Color = Color3.fromRGB(255, 255, 255)
                        a0.CurrentChanging = nil
                    end

                    local v2464 = {Type = "Keyboard", ActionName = k340, BindName = v2463}
                    RemoteEvent:FireServer("ChangeKeybind", v2464)
                end)
            end)
        end

        if k341.Console then
            local v2465 = k340 .. "Console"
            a0.TempCons[v2465] = v2461.Console.Activated:Connect(function() --[[ Upvalues: a0 (copy), v2461 (ref), UserInputService (upvalue), RemoteEvent (upvalue), k340 (copy) ]]
                if a0.CurrentChanging then
                    if a0.KeybindChangeCon then
                        a0.KeybindChangeCon:Disconnect()
                        a0.KeybindChangeCon = nil
                    end

                    if a0.CurrentChanging then
                        a0.CurrentChanging.UIStroke.Thickness = 1
                        a0.CurrentChanging.UIStroke.Color = Color3.fromRGB(255, 255, 255)
                        a0.CurrentChanging = nil
                    end
                end

                a0.CurrentChanging = v2461.Console
                a0.CurrentChanging.UIStroke.Thickness = 3
                a0.CurrentChanging.UIStroke.Color = Color3.fromRGB(116, 202, 255)
                a0.KeybindChangeCon = UserInputService.InputBegan:Connect(function(a0) --[[ Upvalues: a0 (upvalue), RemoteEvent (upvalue), k340 (upvalue) ]]
                    if not _G.Utl.tabFind(_G.Utl.ConsoleBindings, a0.KeyCode) then
                        return
                    end

                    local Name1 = a0.KeyCode.Name
                    if a0.KeybindChangeCon then
                        a0.KeybindChangeCon:Disconnect()
                        a0.KeybindChangeCon = nil
                    end

                    if a0.CurrentChanging then
                        a0.CurrentChanging.UIStroke.Thickness = 1
                        a0.CurrentChanging.UIStroke.Color = Color3.fromRGB(255, 255, 255)
                        a0.CurrentChanging = nil
                    end

                    local v2466 = {Type = "Console", ActionName = k340, BindName = Name1}
                    RemoteEvent:FireServer("ChangeKeybind", v2466)
                end)
            end)
        end
    end

    a0:UpdateKeybinds()
end

getBobbing.InitKeybinds = InitKeybinds

local function DropMoneyGui(a0, a1) --[[ Upvalues: RemoteEvent (copy) ]]
    a0.HUD.DropMoney.Visible = a1
    if a1 then
        if not a0.DropMoneyCon then
            local v2467 = 0
            a0.DropMoneyCon = a0.HUD.DropMoney.Drop.MouseButton1Click:Connect(function() --[[ Upvalues: v2467 (ref), a0 (copy), RemoteEvent (upvalue) ]]
                local v2468 = time() - v2467
                if v2468 < 0.5 then
                    return
                end

                v2467 = time()
                local Text2 = a0.HUD.DropMoney.Text
                if not Text2 then
                    return
                end

                if Text2 then
                    RemoteEvent:FireServer("DropMoney", Text2)
                end

            end)
            return
            -- branch continues at 43
        end
    end

    if a0.DropMoneyCon then
        a0.DropMoneyCon:Disconnect()
        a0.DropMoneyCon = nil
    end
end

getBobbing.DropMoneyGui = DropMoneyGui

local function UpdateMobileButtons(a0)
    local MobileButtonPos = a0.Data.MobileButtonPos
    if not MobileButtonPos then
        return
    end

    local v2469 = a0.Player.PlayerGui.MobileButtons.Buttons:GetChildren()
    for k342, k343 in pairs(v2469) do
        if MobileButtonPos[k343.Name] then
            local v2474 = {}
            local v2475 = MobileButtonPos[k343.Name]
            for k344 in string.gmatch(v2475, "[^, ]+") do
                table.insert(v2474, tonumber(k344))
            end

            k344 = v2474[3]
            k343.Position = UDim2.new(v2474[1], v2474[2], k344, v2474[4])
        else
            k343.Position = _G.Utl.DefaultMobilePositions[k343.Name]
        end
    end
end

getBobbing.UpdateMobileButtons = UpdateMobileButtons

local function EnableSkills(a0, a1) --[[ Upvalues: v2 (copy), UserInputService (copy) ]]
    local v2479 = v2[a1]
    if not v2479.Skills then
        return
    end

    local Skills = a0.HUD.Skills
    if UserInputService.TouchEnabled then
        for k345, k346 in pairs(v2479.Skills) do
            if a0.MobileButtons.Buttons:FindFirstChild(k345) then
                local v2485 = a0.MobileButtons.Buttons[k345]
                v2485.Visible = true
                a0.MobileButtons.Buttons[k345]:SetAttribute("Skill", k346)
            end
        end

        return
    end

    local v2486 = {"Z", "ButtonX"}
    v2486 = {"X", "ButtonA"}
    local v2487 = {Skill1 = v2486, Skill2 = v2486}
    for k347, k348 in pairs(v2479.Skills) do
        local v2491 = Skills.Sample:Clone()
        v2491.Name = k348
        if UserInputService.GamepadEnabled then
            local v2492 = v2487[k347][2]
            v2491.Text = v2492 .. " - " .. k348
        else
            local v2493 = v2487[k347][1]
            v2491.Text = v2493 .. " - " .. k348
        end

        v2491.Visible = true
        v2491.Parent = Skills
        v2491:SetAttribute("Skill", k348)
        if a0.MainContext:FindFirstChild(k347) then
            a0.MainContext[k347].Keyboard.UIButton = v2491
        end
    end
end

getBobbing.EnableSkills = EnableSkills

local function DisableSkills(a0)
    a0.MobileButtons.Buttons.Skill1.Visible = false
    a0.MobileButtons.Buttons.Skill2.Visible = false
    local v2494 = a0.HUD.Skills:GetChildren()
    for k349, k350 in pairs(v2494) do
        if k350:IsA("TextButton") and k350.Name ~= "Sample" then
            k350:Destroy()
        end
    end
end

getBobbing.DisableSkills = DisableSkills

local function SkillCD(a0, a1) --[[ Upvalues: UserInputService (copy), TweenService (copy) ]]
    local v2498 = a1[1]
    local v2499 = a1[2]
    if UserInputService.TouchEnabled then
        local v2500 = a0.MobileButtons.Buttons:GetChildren()
        for k351, k352 in pairs(v2500) do
            if k352:GetAttribute("Skill") and k352:GetAttribute("Skill") == v2498 then
                local CD = k352:FindFirstChild("CD")
                CD.Visible = true
                CD.Size = UDim2.new(1, 0, 1, 0)
                local v2504 = TweenInfo.new(v2499, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                local v2505 = {Size = UDim2.new(1, 0, 0, 0)}
                TweenService:Create(CD, v2504, v2505):Play()
                task.delay(v2499, function() --[[ Upvalues: CD (copy) ]]
                    CD.Visible = false
                end)
                return
            end
        end

        return
    end

    local v2506 = a0.HUD.Skills:GetChildren()
    for k353, k354 in pairs(v2506) do
        if k354:GetAttribute("Skill") and k354:GetAttribute("Skill") == v2498 then
            local CD1 = k354:FindFirstChild("CD")
            CD1.Visible = true
            CD1.Size = UDim2.new(1, 0, 1, 0)
            local v2510 = TweenInfo.new(v2499, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            local v2511 = {Size = UDim2.new(0, 0, 1, 0)}
            TweenService:Create(CD1, v2510, v2511):Play()
            task.delay(v2499, function() --[[ Upvalues: CD1 (copy) ]]
                CD1.Visible = false
            end)
            return
        end
    end
end

getBobbing.SkillCD = SkillCD

local function UpdateDailyRewards(a0)
    local Day = a0.Data.DailyReward.Day
    local v2512 = a0.HUD.DailyRewards.Main:GetChildren()
    for k355, k356 in pairs(v2512) do
        if k356:IsA("ImageButton") then
            if tonumber(k356.Name) < Day then
                k356.Claimed.Visible = true
            else
                k356.Claimed.Visible = false
            end
        end
    end
end

getBobbing.UpdateDailyRewards = UpdateDailyRewards
return getBobbing
