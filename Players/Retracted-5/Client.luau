-- https://lua.expert

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
local SpringModule = require(ReplicatedStorage.Modules.SpringModule)
local ToolsLib = require(ReplicatedStorage.Modules.ToolsLib)
local ShopLib = require(ReplicatedStorage.Modules.ShopLib)
local PumpkinXShopUI = require(ReplicatedStorage.Modules.PumpkinXShopUI)
local Achievements = require(ReplicatedStorage.Modules.Achievements)
local BaseObjectsLib = require(ReplicatedStorage.Modules.BaseObjectsLib)
local ModernBuild = require(ReplicatedStorage.Modules.ModernBuild)
local Preferences = ModernBuild.Preferences
local BaseCustomLib = require(ReplicatedStorage.Modules.BaseCustomLib)
local BaseCapacityLib = require(ReplicatedStorage.Modules.BaseCapacityLib)
local GamepassLib = require(ReplicatedStorage.Modules.GamepassLib)
local SkinsLib = require(ReplicatedStorage.Modules.SkinsLib)
local CraftLib = require(ReplicatedStorage.Modules.CraftLib)
local ExchangeLib = require(ReplicatedStorage.Modules.ExchangeLib)
local CustomBackpack = require(ReplicatedStorage.Modules.CustomBackpack)
local ColorPicker = require(ReplicatedStorage.Modules.ColorPicker)
local PaintController = require(ReplicatedStorage.Modules.PaintController)
local ClassicBuild = require(ReplicatedStorage.Modules.ClassicBuild)
local Events = require(ReplicatedStorage.Modules.Events)
local BaitsLib = require(ReplicatedStorage.Modules.BaitsLib)
local ProductLib = require(ReplicatedStorage.Modules.ProductLib)
local RemoteEvent, RemoteFunction, UnreliableRemoteEvent = ReplicatedStorage.Remotes.RemoteEvent, ReplicatedStorage.Remotes.RemoteFunction, ReplicatedStorage.Remotes.UnreliableRemoteEvent
local Animations, Objects, _ = ReplicatedStorage.Animations, ReplicatedStorage.Objects, ReplicatedStorage.ShopRemote
local Events2 = workspace.Events

local function getBobbing(p1, p2, p3) -- line: 45
    return math.sin(tick() * p1 * p2) * p3
end

local t1 = {}

t1.__index = t1

function t1.new(p4) -- line: 52
    -- upvalues: t1 (copy)
    return (setmetatable({
        Player = p4,
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
    }, t1))
end

function t1.SetUp(p5) -- line: 70
    -- upvalues: RunService (copy), UserInputService (copy), TweenService (copy), ContextActionService (copy), MarketplaceService (copy), SpringModule (copy), CustomBackpack (copy), ClassicBuild (copy), Events (copy), RemoteEvent (copy), UnreliableRemoteEvent (copy), Animations (copy), Events2 (copy)
    p5.HUD = p5.Player.PlayerGui:WaitForChild("HUD")
    p5.CustomBackpack = CustomBackpack.new(p5.Player, p5.HUD, RemoteEvent)
    p5.MobileButtons = p5.Player.PlayerGui:WaitForChild("MobileButtons")

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Stats = game:GetService("Stats")
    local Player = p5.Player
    local ServerRegion = p5.HUD:FindFirstChild("ServerRegion")

    if ServerRegion then
        ServerRegion.RichText = true

        local function escapeRich(p6) -- line: 83
            return (p6:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
        end

        local function getPingMs() -- line: 89
            -- upvalues: Stats (copy), Player (copy)
            local function v2() -- line: 90
                -- upvalues: Stats (copy)
                return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            end

            local ok, result = pcall(v2)

            if ok and type(result) == "number" and result > 0 then
                return (math.floor(result + 0.5))
            end

            local function v4() -- line: 96
                -- upvalues: Player (copy)
                return Player:GetNetworkPing() * 1000
            end

            local ok2, result2 = pcall(v4)

            return if ok2 and type(result2) == "number" and result2 > 0 then math.floor(result2 + 0.5) else nil
        end

        local function renderRegion() -- line: 104
            -- upvalues: ReplicatedStorage (copy), ServerRegion (copy), getPingMs (copy)
            if ServerRegion.Parent then
                local ServerRegion2 = ReplicatedStorage:GetAttribute("ServerRegion")

                if type(ServerRegion2) ~= "string" or ServerRegion2 == "" then
                    ServerRegion2 = "Locating..."
                end

                local v6 = getPingMs()

                if v6 then
                    local v7 = if v6 <= 100 then "4ADE80" elseif v6 <= 200 then "FBBF24" else "F87171"

                    ServerRegion.Text = ServerRegion2:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "  •  " .. string.format("<font color=\"#%s\">%d ms</font>", v7, v6)
                else
                    ServerRegion.Text = ServerRegion2:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                end
            end
        end

        renderRegion()
        ReplicatedStorage:GetAttributeChangedSignal("ServerRegion"):Connect(renderRegion)
        task.spawn(function() -- line: 129
            -- upvalues: ServerRegion (copy), renderRegion (copy)
            while ServerRegion.Parent do
                renderRegion()
                task.wait(1)
            end
        end)
    end

    p5.MainContext = p5.Player.PlayerScripts:WaitForChild("MainContext")
    p5.Mouse = p5.Player:GetMouse()
    p5.TouchEnabled = _G.Utl.isTouchDevice()
    p5.ClassicMobileLauncher = ClassicBuild.Mobile.InstallLauncher(p5)
    p5.RunView = false
    p5.DefaultIcon = "rbxassetid://14500597267"
    p5.BaseStorage = nil
    p5.SlideCD = 0
    p5.EditObjectRotate = 0
    p5.EditObjectFlip = 0
    p5.EditObjectFlip2 = 0
    p5.DeletingObjects = false
    p5.CrouchView = false
    p5.BaseCustomType = "Wall"
    p5.Mouse.Icon = p5.DefaultIcon
    p5.HighlightHover = Instance.new("Highlight")
    p5.HighlightHover.FillTransparency = 0.5
    p5.HighlightHover.FillColor = Color3.fromRGB(255, 224, 224)
    p5.HighlightHover.OutlineColor = Color3.fromRGB(255, 162, 162)
    p5.HighlightHover.OutlineTransparency = 0
    p5.HighlightHover.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    p5.Player.CharacterAdded:Connect(function(p7) -- line: 161
        -- upvalues: p5 (copy)
        p5:CharacterLoaded(p7)
    end)

    if p5.Player.Character then
        p5:CharacterLoaded(p5.Player.Character)
    end

    p5.Springs = {}
    p5.Springs.recoil = SpringModule.create()
    p5.ClientButtons = {}

    local function getModel(p8) -- line: 180
        -- upvalues: p5 (copy)
        local Objects = p5.StorageBase.Contents.Objects

        if not p8:IsDescendantOf(p5.StorageBase.Contents.Objects) then
            Objects = p5.House
        end

        local v8 = p8

        for _ = 1, 5 do
            v8 = v8.Parent

            if v8 and v8.Parent == Objects then
                return v8
            end
        end

        return nil
    end

    if p5.TouchEnabled then
        local function handleAction(p9, p10, _) -- line: 202
            -- upvalues: p5 (copy), RemoteEvent (copy)
            if p9 == "Claim" and p10 == Enum.UserInputState.Begin and p5.StorageHover then
                RemoteEvent:FireServer("ClaimStorage", p5.StorageHover)
            end
        end

        ContextActionService:BindAction("Claim", handleAction, true)
        ContextActionService:SetTitle("Claim", "Claim")

        local Claim = ContextActionService:GetButton("Claim")

        Claim.ActionTitle.TextScaled = true
        Claim.Position = UDim2.new(-0.7, 0, -0.25, 0)
        Claim.Size = UDim2.new(0.2, 0, 0.2, 0)

        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint.AspectRatio = 1
        UIAspectRatioConstraint.Parent = Claim
        UserInputService.TouchTapInWorld:Connect(function(p12, p13) -- line: 218
            -- upvalues: p5 (copy), RemoteEvent (copy)
            if not p13 and not p5.Painting and p5.Painting then
                local _, Viewport = p5:GetMobileAim(p12, true, "Viewport")
                local Instance = if Viewport then Viewport.Instance else nil

                if p5.PaintMode == "ColorDropper" and Instance then
                    local Color = Instance.Color

                    p5.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3 = Color
                elseif p5.PaintMode ~= "ColorDropper" and p5.PaintMode ~= "None" and Instance and Instance:IsDescendantOf(p5.StorageBase.Contents.Objects) then
                    local BackgroundColor3 = p5.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3

                    RemoteEvent:FireServer("PaintBaseObject", {
                        Instance,
                        p5.PaintMode,
                        BackgroundColor3
                    })
                end
            end
        end)
    end

    local t3 = {
        "RightUpperArm",
        "RightLowerArm",
        "RightHand",
        "LeftUpperArm",
        "LeftLowerArm",
        "LeftHand"
    }

    RunService:UnbindFromRenderStep("StorageFPSArmVisibility")
    RunService:BindToRenderStep("StorageFPSArmVisibility", Enum.RenderPriority.Camera.Value + 1, function() -- line: 241
        -- upvalues: p5 (copy), t3 (copy)
        local Character = p5.Character

        if Character then
            local v10 = if not p5.BuildCameraActive and (not p5.Data or not p5.Data.HideArm) then 0 else 1

            for _, v11 in ipairs(t3) do
                local v12 = Character:FindFirstChild(v11)

                if v12 and v12:IsA("BasePart") and v12.LocalTransparencyModifier ~= v10 then
                    v12.LocalTransparencyModifier = v10
                end
            end
        end
    end)
    p5:SetupSafezoneGates()

    local n1 = 0
    local Y
    local n2 = 0

    RunService.RenderStepped:Connect(function(p14) -- line: 262
        -- upvalues: p5 (copy), n1 (ref), Y (ref), n2 (ref), UserInputService (copy), TweenService (copy), ContextActionService (copy), UnreliableRemoteEvent (copy), Animations (copy)
        p5:UpdateFreeMouse()
        p5:UpdateSafezoneGates(p14)

        if p5.Humanoid then
            local WalkSpeed, JumpHeight = p5.WalkSpeed, p5.JumpHeight

            if p5.Sliding then
                JumpHeight = 0
            end

            if p5.Humanoid.Health < 20 then
                WalkSpeed *= 0.5
                JumpHeight = 0
            end

            if p5.Humanoid.WalkSpeed ~= WalkSpeed then
                p5.Humanoid.WalkSpeed = WalkSpeed
            end

            if p5.Humanoid.JumpHeight ~= JumpHeight then
                p5.Humanoid.JumpHeight = JumpHeight
            end

            local v13 = "X: " .. math.floor(p5.Root.Position.X)
            local v14 = "Z: " .. math.floor(p5.Root.Position.Z)

            if p5.HUD.XCoordinate.Text ~= v13 then
                p5.HUD.XCoordinate.Text = v13
            end

            if p5.HUD.ZCoordinate.Text ~= v14 then
                p5.HUD.ZCoordinate.Text = v14
            end
        end

        if p5.Character and p5.Character:GetAttribute("Running") and not p5.CinematicActive then
            if not p5.RunView then
                p5.RunView = true
                TweenService:Create(p5.Camera, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    FieldOfView = 90
                }):Play()
                TweenService:Create(p5.Humanoid, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    CameraOffset = Vector3.new(0, 0.5, 0)
                }):Play()
            end
        elseif p5.RunView then
            p5.RunView = false
            TweenService:Create(p5.Camera, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                FieldOfView = 70
            }):Play()
            TweenService:Create(p5.Humanoid, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                CameraOffset = Vector3.new(0, 0.5, 0.15)
            }):Play()
        end

        if p5.Character:GetAttribute("Flooded") then
            local v15 = time()
            local Y2 = p5.Camera.CFrame.LookVector.Y

            if v15 - n1 >= 0.1 and (Y == nil or math.abs(Y2 - Y) >= 0.02) then
                n1 = v15
                Y = Y2
                UnreliableRemoteEvent:FireServer("FloodPitch", Y2)
            end

            if not p5.UnderwaterView then
                p5.UnderwaterView = true

                if not p5.UnderwaterCC then
                    local Lighting = game:GetService("Lighting")
                    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

                    ColorCorrectionEffect.Name = "UnderwaterFilter"
                    ColorCorrectionEffect.Parent = Lighting
                    p5.UnderwaterCC = ColorCorrectionEffect

                    local BlurEffect = Instance.new("BlurEffect")

                    BlurEffect.Name = "UnderwaterBlur"
                    BlurEffect.Size = 0
                    BlurEffect.Parent = Lighting
                    p5.UnderwaterBlur = BlurEffect
                end

                TweenService:Create(p5.UnderwaterCC, TweenInfo.new(0.6), {
                    Brightness = -0.05,
                    Contrast = -0.1,
                    Saturation = -0.2,
                    TintColor = Color3.fromRGB(125, 180, 218)
                }):Play()
                TweenService:Create(p5.UnderwaterBlur, TweenInfo.new(0.6), {
                    Size = 8
                }):Play()
            end
        elseif p5.UnderwaterView then
            p5.UnderwaterView = false
            Y = nil

            if p5.UnderwaterCC then
                TweenService:Create(p5.UnderwaterCC, TweenInfo.new(0.6), {
                    Brightness = 0,
                    Contrast = 0,
                    Saturation = 0,
                    TintColor = Color3.fromRGB(255, 255, 255)
                }):Play()
            end

            if p5.UnderwaterBlur then
                TweenService:Create(p5.UnderwaterBlur, TweenInfo.new(0.6), {
                    Size = 0
                }):Play()
            end
        end

        if p5.Character:GetAttribute("Crouch") then
            if not p5.CrouchAnim then
                p5.CrouchAnim = p5:LoadAnimation(Animations.Crouch)
                p5.CrouchAnim:Play()
            end

            if not p5.CrouchView then
                p5.CrouchView = true
                TweenService:Create(p5.Humanoid, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    CameraOffset = Vector3.new(0, -0.5, 0)
                }):Play()
            end
        else
            if p5.CrouchAnim then
                p5.CrouchAnim:Stop()
                p5.CrouchAnim = nil
            end

            if p5.CrouchView then
                p5.CrouchView = false
                TweenService:Create(p5.Humanoid, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    CameraOffset = Vector3.new(0, 0.5, 0.15)
                }):Play()
            end
        end

        if not p5.Character:GetAttribute("Ragdolled") and not p5.CinematicActive then
            p5:UpdateCamera(p14)
        end

        if p5.ViewingPlayer then
            if p5.Camera.CameraSubject ~= p5.ViewingPlayer then
                p5.Camera.CameraSubject = p5.ViewingPlayer
            end

            if p5.Player.CameraMode ~= Enum.CameraMode.Classic then
                p5.Player.CameraMode = Enum.CameraMode.Classic
            end

            if p5.Player.CameraMinZoomDistance ~= 5 then
                p5.Player.CameraMinZoomDistance = 5
            end

            if p5.Player.CameraMaxZoomDistance ~= 20 then
                p5.Player.CameraMaxZoomDistance = 20
            end
        else
            if p5.Camera.CameraSubject ~= p5.Humanoid then
                p5.Camera.CameraSubject = p5.Humanoid
            end

            if p5.Player.CameraMode ~= Enum.CameraMode.LockFirstPerson then
                p5.Player.CameraMode = Enum.CameraMode.LockFirstPerson
            end

            if p5.Player.CameraMinZoomDistance ~= 0.5 then
                p5.Player.CameraMinZoomDistance = 0.5
            end

            if p5.Player.CameraMaxZoomDistance ~= 0.5 then
                p5.Player.CameraMaxZoomDistance = 0.5
            end
        end

        local Safezone = p5.Player:GetAttribute("Safezone")
        local PVPShield = p5.Player:GetAttribute("PVPShield")
        local Safezone2 = p5.HUD:FindFirstChild("Safezone")

        if Safezone2 then
            if Safezone then
                if Safezone2.Text ~= "SAFE ZONE" then
                    Safezone2.Text = "SAFE ZONE"
                    Safezone2.TextColor3 = Color3.fromRGB(125, 255, 105)
                end

                if Safezone2.Label.Visible then
                    Safezone2.Label.Visible = false
                end

                if not Safezone2.Visible then
                    Safezone2.Visible = true
                end
            elseif PVPShield and os.time() < PVPShield then
                if Safezone2.Text ~= "PROTECTED" then
                    Safezone2.Text = "PROTECTED"
                    Safezone2.TextColor3 = Color3.fromRGB(255, 212, 112)
                    Safezone2.Label.TextColor3 = Color3.fromRGB(255, 232, 180)
                end

                if not Safezone2.Label.Visible then
                    Safezone2.Label.Visible = true
                end

                local v17 = "Leaving safezone " .. _G.Utl.timeFormat(PVPShield - os.time())

                if Safezone2.Label.Text ~= v17 then
                    Safezone2.Label.Text = v17
                end

                if not Safezone2.Visible then
                    Safezone2.Visible = true
                end
            elseif Safezone2.Visible then
                Safezone2.Visible = false
            end
        end

        if time() - n2 > 0.33 then
            n2 = time()

            if not p5.Root or p5.StorageBase then
                if p5.Root and p5.StorageBase then
                    p5.HUD.ClaimStorage.Visible = false
                    p5.StorageHover = nil

                    if p5.TouchEnabled then
                        ContextActionService:GetButton("Claim").Visible = false
                    end

                    local v19 = OverlapParams.new()

                    v19.FilterType = Enum.RaycastFilterType.Include
                    v19.FilterDescendantsInstances = { p5.Root }
                    v19.MaxParts = 1

                    local StorageBase = p5.StorageBase
                    local Basement2 = StorageBase and StorageBase:FindFirstChild("Basement")
                    local Contents2 = StorageBase and StorageBase:FindFirstChild("Contents")
                    local BoundingBox = if Basement2 then Basement2:FindFirstChild("BoundingBox") elseif Contents2 then Contents2:FindFirstChild("BoundingBox") else nil

                    if BoundingBox then
                        local PartBoundsInBox = workspace:GetPartBoundsInBox(BoundingBox.CFrame, BoundingBox.Size, v19)
                        local v21 = false

                        for _, _ in pairs(PartBoundsInBox) do
                            v21 = true
                            break
                        end

                        if not v21 or p5.Player:GetAttribute("InBase") then
                            local InBase = if not v21 then p5.Player:GetAttribute("InBase") else nil

                            if v21 or not InBase then
                                if not v21 and p5.HUD.BaseEdit.Visible then
                                    p5.HUD.BaseEdit.Visible = false
                                end
                            else
                                p5:NotInBase()
                            end
                        else
                            p5.Player:SetAttribute("InBase", true)
                            p5.HUD.BaseEdit.Visible = true
                        end
                    end
                end
            else
                if UserInputService.GamepadEnabled then
                    p5.HUD.ClaimStorage.Text = "Press DPAD Left to Claim Storage."
                else
                    p5.HUD.ClaimStorage.Text = "Press C to Claim Storage."
                end

                local t4 = {
                    workspace.Storages
                }
                local SafezoneUnits = workspace:FindFirstChild("SafezoneUnits")

                if SafezoneUnits then
                    table.insert(t4, SafezoneUnits)
                end

                local v22 = _G.Utl.Raycast({
                    Origin = p5.Root.Position,
                    Dir = p5.Root.CFrame.LookVector * 6,
                    Whitelist = t4
                })
                local v23

                if v22 then
                    v23 = v22.Instance

                    while true do
                        if not v23 or v23 == workspace then
                            v23 = nil
                        elseif not v23:IsA("Model") or v23.Parent ~= workspace.Storages and v23.Parent ~= SafezoneUnits then
                            v23 = v23.Parent
                            continue
                        end

                        break
                    end
                end

                if v23 and v23.Name == "Room" and not v23:GetAttribute("Opened") and not v23:GetAttribute("Owner") and not v23:GetAttribute("Locked") and not v23:GetAttribute("DoorBusy") and not v23:GetAttribute("Unclaiming") and not v23:GetAttribute("ReservedForBase") then
                    if p5.TouchEnabled then
                        ContextActionService:GetButton("Claim").Visible = true
                    else
                        p5.HUD.ClaimStorage.Visible = true
                    end

                    p5.StorageHover = v23
                else
                    if p5.TouchEnabled then
                        ContextActionService:GetButton("Claim").Visible = false
                    end

                    p5.StorageHover = nil
                    p5.HUD.ClaimStorage.Visible = false
                end
            end
        end

        local _ = p5.Mouse.Target

        if p5.EditObject then
            local v24

            if p5.ClassicBuildActive then
                local ClassicBuildAim = p5:GetClassicBuildAim()

                if ClassicBuildAim then
                    v24 = p5:CalcPlacementCFrame(ClassicBuildAim.Position)
                end
            else
                v24 = if p5.ModernMobile and p5.ModernMobile:IsActive() then p5:GetBuildObjectCFrame() elseif p5.TouchEnabled then p5:CalcPlacementCFrame(p5:GetMobileAim(nil, false).Position) else p5:CalcPlacementCFrame(p5.Mouse.Hit.Position)
            end

            if v24 then
                p5.EditObject:PivotTo(v24)

                if p5.BuildCameraActive and not p5.ClassicBuildActive then
                    p5:UpdateBuildGizmo(v24)
                    p5:RefreshBuildValidation(false)
                end
            end
        elseif p5.EditingBase and p5.BuildCameraActive and not p5.Painting then
            if not (p5.ClassicController and p5.ClassicController:BlocksWorld()) and (not p5.ClassicMobile or not p5.ClassicMobile:BlocksWorld()) and (not p5.ModernController or not p5.ModernController:BlocksWorld()) then
                if p5.ClassicBuildActive then
                    p5:UpdateBuildObjectHover(p5:GetClassicBuildPointerPosition())
                elseif not p5.TouchEnabled then
                    local MouseLocation = UserInputService:GetMouseLocation()
                    local LastInputType = UserInputService:GetLastInputType()

                    if string.match(LastInputType.Name, "^Gamepad") and not p5.BuildGamepadNavigation then
                        MouseLocation = workspace.CurrentCamera.ViewportSize / 2
                    end

                    p5:UpdateBuildObjectHover(MouseLocation)
                end
            else
                p5:ClearBuildObjectHover()
            end
        end

        local v25 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad and p5.Player.PlayerGui:GetAttribute("ControllerBackpackActive") == true
        local Aim

        if p5.UpdatingMouse then
            if v25 then
                Aim = p5:GetAim()
                UnreliableRemoteEvent:FireServer("UpdateMouse", Aim)
            elseif p5.TouchEnabled then
                UnreliableRemoteEvent:FireServer("UpdateMouse", (p5:GetMobileAim(nil, false)))
            else
                UnreliableRemoteEvent:FireServer("UpdateMouse", p5.Mouse.Hit)
            end
        end

        if not (p5.ReportingAim and p5.Mouse and time() - (p5.LastAimReport or 0) > 0.03) then
            return
        end

        p5.LastAimReport = time()

        local Aim2 = if v25 then Aim or p5:GetAim() or p5.TouchEnabled and p5:GetMobileAim(nil, false) or p5.Mouse.Hit else p5.TouchEnabled and p5:GetMobileAim(nil, false) or p5.Mouse.Hit

        if Aim2 then
            UnreliableRemoteEvent:FireServer("ReportAim", Aim2.Position)
        end
    end)

    local Events3, EventsInfo = p5.HUD.Events, p5.HUD.EventsInfo

    local function updateEvents() -- line: 597
        -- upvalues: Events3 (copy), EventsInfo (copy), Events (copy), Events2 (copy)
        for _, child in pairs(Events3:GetChildren()) do
            if child:IsA("ImageLabel") and child.Name ~= "Sample" and not Events2:FindFirstChild(child.Name) then
                child:Destroy()
            end
        end

        for _, child in pairs(Events2:GetChildren()) do
            if not Events3:FindFirstChild(child.Name) then
                local v26 = Events[child.Name]

                if v26 then
                    local clone = Events3.Sample:Clone()

                    clone.Image = v26.Icon
                    clone.Name = child.Name
                    clone.Visible = true
                    clone.Parent = Events3
                    clone.MouseEnter:Connect(function() -- line: 614
                        -- upvalues: v26 (copy), EventsInfo (copy)
                        EventsInfo.EventLabel.Text = v26.EventLabelText
                        EventsInfo.EventLabel.TextColor3 = v26.EventLabelTextColor
                        EventsInfo.EventLabel.UIStroke.Color = v26.EventLabelStrokeColor
                        EventsInfo.DescLabel.Text = v26.Desc
                        EventsInfo.Visible = true
                    end)
                    clone.MouseLeave:Connect(function() -- line: 625
                        -- upvalues: EventsInfo (copy)
                        EventsInfo.Visible = false
                    end)
                end
            end
        end
    end

    updateEvents()
    Events2.ChildAdded:Connect(updateEvents)
    Events2.ChildRemoved:Connect(updateEvents)

    if MarketplaceService:UserOwnsGamePassAsync(p5.Player.UserId, 245559423) then
        p5:ActivateClock()
    end
end

function t1.UpdateData(p15, p16) -- line: 642
    p15.Data = p16
    p15:CandyCornChanged(p16.CandyCorn)

    if p15.CustomBackpack then
        p15.CustomBackpack:SetCursorPreference(p16.BackpackCursorMode)
    end

    if p15.DesktopCatalogue then
        p15.DesktopCatalogue:Refresh()
    end
end

function t1.UpdateData2(p17, p18) -- line: 651
    -- upvalues: GamepassLib (copy)
    if p18.Type == "ItemDelta" then
        p17.Data.Items = typeof(p17.Data.Items) == "table" and p17.Data.Items or {}

        if typeof(p18.Item) == "string" and p18.Item ~= "" then
            if p18.Removed == true then
                p17.Data.Items[p18.Item] = nil
            elseif typeof(p18.Data) == "table" then
                p17.Data.Items[p18.Item] = p18.Data
            end
        end
    elseif p18.Type == "ItemBatchDelta" then
        p17.Data.Items = typeof(p17.Data.Items) == "table" and p17.Data.Items or {}

        if typeof(p18.Deltas) == "table" then
            for _, v27 in ipairs(p18.Deltas) do
                if typeof(v27) == "table" and typeof(v27.Item) == "string" and v27.Item ~= "" then
                    if v27.Removed == true then
                        p17.Data.Items[v27.Item] = nil
                    elseif typeof(v27.Data) == "table" then
                        p17.Data.Items[v27.Item] = v27.Data
                    end
                end
            end
        end
    else
        p17.Data[p18.Type] = p18.Data

        if p18.Type == "CandyCorn" then
            p17:CandyCornChanged(p18.Data)
        end

        if (p18.Type == "CandyCorn" or p18.Type == "Skins") and p17.ShopArgs and p17.ShopArgs[2] == "Pumpkin X" then
            p17:UpdateShopGui()
        end

        if p17.DesktopCatalogue and (p18.Type == "BaseItems" or p18.Type == "Money" or p18.Type == "UnlockedObjects" or p18.Type == "CurrentSkins") then
            p17.DesktopCatalogue:Refresh()
        end

        if (p18.Type == "Skins" or p18.Type == "CurrentSkins") and p17.HUD.Skins.Visible then
            p17:UpdateSkins(p17.SkinItem, false)
        elseif p18.Type == "Achievements" and p17.HUD.Achievements.Visible then
            p17:UpdateAchievements()
        elseif (p18.Type == "ExtraBank" or p18.Type == "Bank") and p17.HUD.Bank.Visible then
            p17:UpdateBank()
            p17:InitBank()
        elseif p18.Type == "LikeBonus" then
            p17.HUD.LikeButton.Visible = false
            p17.HUD.LikeReward.Visible = false
        elseif p18.Type == "BaseItems" and p17.HUD.BaseObjects.Visible then
            p17:UpdateBaseObjects(p17.CurrentBaseObjects)
        elseif p18.Type == "ShopFormat" then
            if p17.ShopGui then
                p17:UpdateShopGui()
            elseif p17.HUD.Bank.Visible then
                p17:UpdateBank()
            end
        else
            if p18.Type == "Keybinds" then
                p17:UpdateKeybinds()

                return
            end

            if p18.Type == "MobileButtonPos" then
                p17:UpdateMobileButtons()

                return
            end

            if p18.Type == "Hotbar" and p17.CustomBackpack then
                p17.CustomBackpack:SetSavedHotbar(p18.Data)

                return
            end

            if p18.Type == "BackpackCursorMode" and p17.CustomBackpack then
                p17.CustomBackpack:SetCursorPreference(p18.Data)

                return
            end

            if p18.Type == "DailyReward" then
                p17:UpdateDailyRewards()

                return
            end

            if p18.Type == "HoldToSprint" then
                p17:UpdateSprintToggle()

                return
            end

            if p18.Type == "HideArm" then
                p17:UpdateHideArm()
            elseif p18.Type == "TradeRequests" then
                p17:UpdateTradeRequests()
            elseif p18.Type == "BuildSystem" then
                p17:UpdateBuildSystem()
            elseif p18.Type == "BaseUnitSize"
                or p18.Type == "UnitSize2Unlocked"
                or p18.Type == "BaseBasement"
                or p18.Type == "ExtraStorageGamepass"
                or p18.Type == "ExtraStorageUpgrade"
                or p18.Type == "ExtraStorageCap"
                or p18.Type == "StorageCapacitySplitMigrated" then
                p17:UpdateStorageCapacity()
            else
                if p18.Type ~= "GamepassGrants" then
                    return
                end

                p17:UpdateStorageCapacity()

                if not GamepassLib.HasGrant(p18.Data, 245559423) then
                    return
                end

                p17:ActivateClock()
            end
        end
    end
end

function t1.UpdateSprintToggle(p19) -- line: 743
    if p19.Data.HoldToSprint then
        p19.HUD.Settings.Main.SprintToggle.Text = "Sprint: Hold"
    else
        p19.HUD.Settings.Main.SprintToggle.Text = "Sprint: Toggle"
    end
end

function t1.UpdateHideArm(p20) -- line: 751
    if p20.Data.HideArm then
        p20.HUD.Settings.Main.HideArm.Text = "Arms: Hidden"
    else
        p20.HUD.Settings.Main.HideArm.Text = "Arms: Shown"
    end
end

function t1.UpdateTradeRequests(p21) -- line: 759
    if p21.Data.TradeRequests == false then
        p21.HUD.Settings.Main.TradeRequests.Text = "Trade Requests: Off"
    else
        p21.HUD.Settings.Main.TradeRequests.Text = "Trade Requests: On"
    end
end

function t1.UpdateBuildSystem(p22) -- line: 767
    local v28 = p22:IsClassicBuildSystem()
    local BuildSystem = p22.HUD.Settings.Main:FindFirstChild("BuildSystem")

    if BuildSystem then
        BuildSystem.Text = v28 and "Building: Classic" or "Building: Modern"
    end

    local v29 = p22.BuildGui and p22.BuildGui:FindFirstChild("BuildSystemToggle")

    if v29 then
        v29.Text = v28 and "System: Classic" or "System: Modern"
    end
end

function t1.SetBuildSystem(p23, p24, p25) -- line: 779
    -- upvalues: GuiService (copy), RemoteEvent (copy)
    if p23.BuildSystemSwitching then
        return false
    end

    local v30 = if p24 == "Classic" or p24 == "Modern" then p24 elseif p23:IsClassicBuildSystem() then "Modern" else "Classic"

    if v30 == (if p23:IsClassicBuildSystem() then "Classic" else "Modern") then
        p23:UpdateBuildSystem()

        return true
    end

    local v31

    if p25 then
        if not p23.BuildCameraActive or p23.BuildModeKind ~= "Objects" or p23.Painting then
            return false
        end

        p23.BuildSystemSwitching = true
        p23:SetDeleteAllConfirmation(false)
        p23:EndBuildTouchGizmoDrag()
        p23:EndBuildTransformHold()
        p23:EndDirectBuildDrag()
        p23.BuildGizmoDragging = nil
        p23:DeleteEditObject()
        p23:SetDeletingObjects(false)
        GuiService.SelectedObject = nil
        v31 = p23:EndBuildMode(true)
    end

    p23.Data.BuildSystem = v30
    p23:UpdateBuildSystem()
    RemoteEvent:FireServer("ChangeBuildSystem", v30)

    if not p25 then
        return true
    end

    local v32 = p23:BeginBuildMode("Objects", v31)

    p23.BuildSystemSwitching = nil

    if v32 then
        if v30 == "Classic" and p23.EditingBase then
            if p23.CurrentSubCategory == "Favorites" or p23.CurrentSubCategory == "Recent" then
                p23.CurrentSubCategory = "All"
            end

            p23:UpdateSubCategories(p23.CurrentBaseObjects)
            p23:UpdateBaseObjects(p23.CurrentBaseObjects)
        end

        p23:UpdateBuildGui()
    elseif p23.EditingBase then
        p23:StopEditStorage()
    end

    return v32 == true
end

function t1.Activate(p26, p27) -- line: 834
    -- upvalues: UserInputService (copy), AvatarEditorService (copy), GamepassLib (copy), RemoteEvent (copy)
    if typeof(p27) ~= "table" then
        return
    end

    local v33 = p26.Activated == true

    p26.Data = p27
    p26:CandyCornChanged(p27.CandyCorn)

    if p26.CustomBackpack then
        p26.CustomBackpack:SetSavedHotbar(p27.Hotbar)
        p26.CustomBackpack:SetCursorPreference(p27.BackpackCursorMode)
    end

    p26:UpdateKeybinds()

    if GamepassLib.HasGrant(p27.GamepassGrants, 245559423) then
        p26:ActivateClock()
    end

    if v33 then
        return
    end

    p26.Activated = true
    p26.OldMoney = 0
    p26:UpdateAchievements()
    p26:ArmorChanged(p26.Data.Armor)
    p26:HungerChanged(p26.Data.Hunger)
    p26:ThirstChanged(p26.Data.Thirst)
    p26:MoneyChanged(p26.Data.Money)
    p26:LevelChanged(p26.Data.Level)
    p26:EXPChanged(p26.Data.Level, p26.Data.EXP)
    p26:UpdateBank()

    if not p26.Data.LikeBonus then
        p26.HUD.LikeButton.Visible = true
        p26.HUD.LikeButton.MouseButton1Click:Connect(function() -- line: 865
            -- upvalues: p26 (copy)
            p26.HUD.LikeReward.Visible = not p26.HUD.LikeReward.Visible
        end)
        p26.HUD.LikeReward.Later.MouseButton1Click:Connect(function() -- line: 869
            -- upvalues: p26 (copy)
            p26.HUD.LikeReward.Visible = false
        end)
        p26.HUD.LikeReward.Claim.MouseButton1Click:Connect(function() -- line: 873
            -- upvalues: AvatarEditorService (copy), RemoteEvent (copy)
            RemoteEvent:FireServer("VerifyLikeBonus")
            AvatarEditorService:PromptSetFavorite(game.PlaceId, Enum.AvatarItemType.Asset, true)
        end)
    end

    p26.HUD.DailyRewardsButton.MouseButton1Click:Connect(function() -- line: 880
        -- upvalues: p26 (copy)
        p26.HUD.DailyRewards.Visible = not p26.HUD.DailyRewards.Visible
    end)
    p26.HUD.DailyRewards.Close.MouseButton1Click:Connect(function() -- line: 884
        -- upvalues: p26 (copy)
        p26.HUD.DailyRewards.Visible = false
    end)
    p26.HUD.DailyRewards.Claim.MouseButton1Click:Connect(function() -- line: 888
        -- upvalues: p26 (copy), RemoteEvent (copy)
        local DailyReward = p26.Data.DailyReward
        local v34 = _G.Utl.GetNearestDay()

        if DailyReward.LastClaim ~= v34 then
            RemoteEvent:FireServer("ClaimDailyReward")
        end
    end)
    task.spawn(function() -- line: 897
        -- upvalues: p26 (copy)
        while task.wait(1) do
            local DailyReward = p26.Data.DailyReward
            local v35 = _G.Utl.GetNearestDay()

            if DailyReward.LastClaim < v35 then
                p26.HUD.DailyRewards.Timer.Text = "Ready!"
                p26.HUD.DailyRewardsButton.Alert.Visible = true
            elseif DailyReward.LastClaim == v35 then
                local v36 = v35 + 86400 - os.time()

                p26.HUD.DailyRewards.Timer.Text = _G.Utl.timeFormat(v36)
                p26.HUD.DailyRewardsButton.Alert.Visible = false
            end
        end
    end)
    p26:UpdateDailyRewards()

    if UserInputService.TouchEnabled then
        p26:UpdateMobileButtons()
    end
end

function t1.CharacterLoaded(p28, p29) -- line: 919
    -- upvalues: UserInputService (copy), ToolsLib (copy)
    if p28.EditingBase then
        p28:StopEditStorage()
    elseif p28.Painting then
        p28:ClosePaintFrames()
    end

    p28.Character = p29
    p28.Humanoid = p29:WaitForChild("Humanoid")
    p28.Root = p29:WaitForChild("HumanoidRootPart")
    p28.Animator = p28.Humanoid:WaitForChild("Animator")
    p28.Humanoid.Died:Once(function() -- line: 929
        -- upvalues: p28 (copy)
        if p28.EditingBase then
            p28:StopEditStorage()
        elseif p28.Painting then
            p28:ClosePaintFrames()
        end
    end)
    p28.WalkSpeed = 12
    p28.JumpHeight = 7.2

    local FocusedTextBox = UserInputService:GetFocusedTextBox()

    if FocusedTextBox then
        FocusedTextBox:ReleaseFocus()
    end

    if p28.BankChannel then
        p28.BankChannel:Cancel()
        p28.BankChannel = nil
    end

    p28:ClearBankCons()
    p28.BankObject = nil
    p28.BankOpening = false
    p28.ClosingBank = false
    p28.HUD.Bank.Visible = false
    p28.FreeMouse = nil
    p28.Camera = workspace.CurrentCamera
    p28.Camera.CameraType = Enum.CameraType.Custom
    p28.Camera.CameraSubject = p28.Humanoid
    p28.Humanoid.CameraOffset = Vector3.new(0, 0.5, 0.15)
    p28.HUD.DropMoney.Visible = false
    p28.Character.AttributeChanged:Connect(function(p30) -- line: 954
        -- upvalues: p28 (copy)
        local t5 = {
            "Defense",
            "DamageMult",
            "SpeedAdd"
        }
        local Traits = p28.HUD.Traits

        for _, child in pairs(Traits:GetChildren()) do
            if not _G.Utl.tabFind(t5, child.Name) and child:IsA("ImageLabel") then
                if p28.Character:GetAttribute(child.Name) then
                    child.Visible = true
                else
                    child.Visible = false
                end
            end
        end

        if p30 == "DamageMult" then
            local DamageMult = p28.Character:GetAttribute("DamageMult")

            if DamageMult > 0 then
                local v38 = math.round(DamageMult * 100)

                p28.HUD.Traits.DamageMult.Val.Text = v38 .. "%"
                p28.HUD.Traits.DamageMult.Visible = true
            else
                p28.HUD.Traits.DamageMult.Visible = false
            end
        elseif p30 == "SpeedAdd" then
            local SpeedAdd = p28.Character:GetAttribute("SpeedAdd")

            if SpeedAdd > 0 then
                p28.HUD.Traits.SpeedAdd.Val.Text = "+" .. SpeedAdd
                p28.HUD.Traits.SpeedAdd.Visible = true
            else
                p28.HUD.Traits.SpeedAdd.Visible = false
            end
        elseif p30 == "Defense" then
            local Defense = p28.Character:GetAttribute("Defense")

            if Defense > 0 then
                local v40 = math.round(Defense * 100)

                p28.HUD.Traits.Defense.Val.Text = v40 .. "%"
                p28.HUD.Traits.Defense.Visible = true
            else
                p28.HUD.Traits.Defense.Visible = false
            end
        end
    end)

    local _ = {
        "RightUpperArm",
        "RightLowerArm",
        "RightHand",
        "LeftUpperArm",
        "LeftLowerArm",
        "LeftHand"
    }

    for _, child in pairs(p28.Character:GetChildren()) do
        if child:IsA("Accessory") then
            local WrapLayer = child.Handle:FindFirstChildWhichIsA("WrapLayer")

            if WrapLayer then
                WrapLayer.Enabled = false
            end
        end
    end

    local Buffs = p29:WaitForChild("Buffs")

    task.spawn(function() -- line: 1010
        -- upvalues: p28 (copy), p29 (copy), Buffs (copy), ToolsLib (copy)
        local t6 = {
            SpeedAdd = {},
            DamageMult = {},
            Defense = {}
        }

        while Buffs.Parent == p29 do
            task.wait(1)

            if p28.Humanoid.Health <= 0 then
                break
            end

            for _, child in pairs(Buffs:GetChildren()) do
                local v41 = ToolsLib[child.Name]

                if v41 and child.Value >= os.time() then
                    if v41.SpeedAdd then
                        t6.SpeedAdd[child.Name] = {
                            v41.SpeedAdd,
                            child.Value
                        }
                    end

                    if v41.DamageMult then
                        t6.DamageMult[child.Name] = {
                            v41.DamageMult,
                            child.Value
                        }
                    end

                    if v41.Defense then
                        t6.Defense[child.Name] = {
                            v41.Defense,
                            child.Value
                        }
                    end
                end
            end

            for _, child in pairs(p28.HUD.Traits:GetChildren()) do
                if t6[child.Name] then
                    local Timers = child.Timers

                    for _, child2 in pairs(Timers:GetChildren()) do
                        if child2.Name ~= "Sample" and child2:IsA("TextLabel") and not t6[child.Name][child2.Name] then
                            child2:Destroy()
                        end
                    end
                end
            end

            for v42, v43 in pairs(t6) do
                local Timers = p28.HUD.Traits[v42].Timers

                for v44, v45 in pairs(v43) do
                    local v46 = Timers:FindFirstChild(v44)

                    if not v46 then
                        v46 = Timers.Sample:Clone()
                        v46.Name = v44
                        v46.Text = "+" .. v45[1] .. " (" .. math.round(v45[2] - os.time()) .. "s)"
                        v46.Parent = Timers
                        v46.Visible = true
                    end

                    v46.Text = "+" .. v45[1] .. " (" .. math.round(v45[2] - os.time()) .. "s)"
                end
            end
        end

        for _, child in pairs(p28.HUD.Traits:GetChildren()) do
            if t6[child.Name] then
                local Timers = child.Timers

                for _, child in pairs(Timers:GetChildren()) do
                    if child.Name ~= "Sample" and child:IsA("TextLabel") then
                        child:Destroy()
                    end
                end
            end
        end
    end)
end

function t1.LoadAnimation(p31, p32) -- line: 1080
    return p31.Animator:LoadAnimation(p32)
end

function t1.Attributes(p33, p34) -- line: 1084
    p33.WalkSpeed = p34.WalkSpeed
    p33.JumpHeight = p34.JumpHeight
end

function t1.EnableState(p35, p36) -- line: 1089
    if p35.Humanoid then
        p35.Humanoid:SetStateEnabled(p36.State, p36.Bool)
    end
end

function t1.Effects(p37, p38) -- line: 1094
    local v51 = p38.EffectDist or 150

    if not (p38.Pos and v51 < (p37.Root.Position - p38.Pos).Magnitude) then
        if p38.Origin then
            if typeof(p38.Origin) == "Vector3" then
                if v51 < (p37.Root.Position - p38.Origin).Magnitude then
                    return
                end
            elseif v51 < (p37.Root.Position - p38.Origin.Position).Magnitude then
                return
            end
        end

        _G.Utl.FX[p38.Effect](p38)
    end
end

function t1.Sound(_, p40) -- line: 1109
    _G.Utl.PlaySound(p40)
end

function t1.UpdateCamera(p41, p42) -- line: 1113
    -- upvalues: UserInputService (copy)
    UserInputService:GetMouseDelta()

    local _ = p41.Root.Velocity
    local v52 = p41.Springs.recoil:update(p42)

    if p41.ClassicController and p41.ClassicController:BlocksWorld() or p41.ClassicMobile and p41.ClassicMobile:BlocksWorld() or p41.ModernController and p41.ModernController:BlocksWorld() then
        return
    end

    local Camera = p41.Camera

    Camera.CFrame = Camera.CFrame * CFrame.Angles(math.rad(v52.X), math.rad(v52.Y), (math.rad(v52.Z)))
end

function t1.GetAim(p43, p44) -- line: 1145
    -- upvalues: UserInputService (copy)
    local CurrentCamera = workspace.CurrentCamera
    local v55

    if UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad or not p43.Player.PlayerGui:GetAttribute("ControllerBackpackActive") then
        v55 = CurrentCamera:ScreenPointToRay(p43.Mouse.X, p43.Mouse.Y)
    else
        local v56 = CurrentCamera.ViewportSize * 0.5

        v55 = CurrentCamera:ViewportPointToRay(v56.X, v56.Y)
    end

    local v57 = _G.Utl.Raycast({
        Origin = v55.Origin,
        Dir = v55.Direction * 500,
        Blacklist = {
            p43.Character,
            p43.EditObject,
            workspace.Map,
            workspace.Storages,
            workspace.Mobs
        }
    })
    local v58 = if v57 then CFrame.new(v57.Position, v55.Origin + v55.Direction * 500) else CFrame.new(v55.Origin, v55.Origin + v55.Direction) * CFrame.new(0, 0, -500)

    if p44 then
        return v57
    end

    return v58
end

function t1.GetMobileAim(p45, p46, p47, p48) -- line: 1171
    local CurrentCamera = workspace.CurrentCamera
    local MobileMouse, v59

    if p46 then
        MobileMouse = nil
        v59 = if p48 == "Viewport" then CurrentCamera:ViewportPointToRay(p46.X, p46.Y) else CurrentCamera:ScreenPointToRay(p46.X, p46.Y)
    else
        MobileMouse = p45.HUD.MobileMouse

        if p45.HUD.Crosshair.Visible then
            MobileMouse = p45.HUD.Crosshair
        end

        v59 = CurrentCamera:ScreenPointToRay(MobileMouse.AbsolutePosition.X + MobileMouse.AbsoluteSize.X / 2, MobileMouse.AbsolutePosition.Y + MobileMouse.AbsoluteSize.Y / 2)
    end

    local v60 = if not MobileMouse then _G.Utl.Raycast({
        Origin = v59.Origin,
        Dir = v59.Direction * 500,
        Blacklist = { p45.Character }
    })
        elseif MobileMouse == p45.HUD.MobileMouse then _G.Utl.Raycast({
            Origin = v59.Origin,
            Dir = v59.Direction * 500,
            Blacklist = {
                p45.Character,
                p45.EditObject
            }
        })
        else _G.Utl.Raycast({
            Origin = v59.Origin,
            Dir = v59.Direction * 500,
            Blacklist = {
                p45.Character,
                p45.EditObject,
                workspace.Map,
                workspace.Storages,
                workspace.Mobs
            }
        })
    local v61 = if v60 then CFrame.new(v60.Position, v59.Origin + v59.Direction * 500) else CFrame.new(v59.Origin, v59.Origin + v59.Direction) * CFrame.new(0, 0, -500)

    if p47 then
        return v61, v60
    end

    return v61
end

function t1.Noti(_, p50) -- line: 1318
    -- upvalues: StarterGui (copy)
    StarterGui:SetCore("SendNotification", p50)
end

function t1.OpeningDoor(p51) -- line: 1322
    -- upvalues: TweenService (copy)
    TweenService:Create(p51.Humanoid, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        CameraOffset = Vector3.new(0, 0, -0.1)
    }):Play()
    task.wait(0.55)
    TweenService:Create(p51.Humanoid, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        CameraOffset = Vector3.new(0, 0.5, 0.15)
    }):Play()
end

function t1.UpdateFreeMouse(p52) -- line: 1332
    -- upvalues: UserInputService (copy)
    local Visible = p52.FreeMouse == true
        or p52.ShopGui ~= nil and p52.ShopGui.Parent ~= nil
        or p52.SellGui ~= nil and p52.SellGui.Parent ~= nil
        or p52.CraftGui ~= nil and p52.CraftGui.Parent ~= nil
        or p52.GlobalShopGui ~= nil and p52.GlobalShopGui.Parent ~= nil
        or p52.HUD.Dialogue.Visible
        or p52.HUD.Bank.Visible
        or p52.HUD.Brewing.Visible
        or p52.HUD.Shop.Visible
        or UserInputService:GetFocusedTextBox() ~= nil

    if p52.HUD.Modal.Visible ~= Visible then
        p52.HUD.Modal.Visible = Visible
    end
end

function t1.ClearDialogue(p53) -- line: 1348
    local Dialogue = p53.HUD.Dialogue

    for _, child in Dialogue.Choices:GetChildren() do
        if child:IsA("ImageButton") and child.Name ~= "Sample" then
            child:Destroy()
        end
    end

    Dialogue.MainText.Text = ""
    Dialogue.NPCName.Text = ""
end

function t1.Dialogue(p54, p55) -- line: 1359
    -- upvalues: RemoteEvent (copy)
    p54.DialogueRenderGeneration = (p54.DialogueRenderGeneration or 0) + 1

    local DialogueRenderGeneration = p54.DialogueRenderGeneration

    p54.DialogueChoicePending = nil
    p54:ClearDialogue()
    p54:CloseShopGui()

    local NPC, Dialogue = p55.NPC, p55.Dialogue
    local Dialogue2 = p54.HUD.Dialogue

    if not NPC then
        p54:EndDialogue()

        return
    end

    Dialogue2.Visible = true

    if not p54.DialogueChannel then
        local v62

        v62 = _G.Utl.Channel.new(1e999, function() -- line: 1376
            -- upvalues: p54 (copy), v62 (ref)
            if p54.DialogueChannel == v62 then
                p54:EndDialogue()
            end
        end)
        p54.DialogueChannel = v62

        p54.DialogueChannel.Duration = function() -- line: 1382
            -- upvalues: p54 (copy), NPC (copy)
            if NPC.PrimaryPart and (p54.Root.Position - NPC.PrimaryPart.Position).Magnitude > 12 then
                p54.DialogueChannel:StopShort()
            end
        end

        p54.DialogueChannel:Start()
    end

    Dialogue2.NPCName.Text = NPC.Name
    Dialogue2.MainText.MaxVisibleGraphemes = 0
    Dialogue2.MainText.Text = p55.Dialogue.Text

    for i = 1, #p55.Dialogue.Text do
        if p54.DialogueRenderGeneration ~= DialogueRenderGeneration or not Dialogue2.Visible then
            return
        end

        Dialogue2.MainText.MaxVisibleGraphemes = i
        task.wait()
    end

    if p54.DialogueRenderGeneration == DialogueRenderGeneration and Dialogue2.Visible then
        if Dialogue.Choices then
            for v63, v64 in pairs(Dialogue.Choices) do
                local clone = Dialogue2.Choices.Sample:Clone()

                clone.Name = v63
                clone.Label.Text = v63
                clone.LayoutOrder = v64.Order
                clone.Visible = true
                clone.Parent = Dialogue2.Choices
                clone.MouseButton1Click:Connect(function() -- line: 1417
                    -- upvalues: p54 (copy), DialogueRenderGeneration (copy), v63 (copy), RemoteEvent (copy)
                    if p54.DialogueRenderGeneration ~= DialogueRenderGeneration or p54.DialogueChoicePending then
                        return
                    end

                    p54.DialogueChoicePending = true
                    RemoteEvent:FireServer("DialogueChoice", v63)
                end)
            end
        else
            task.wait(0.5)

            if p54.DialogueRenderGeneration ~= DialogueRenderGeneration then
                return
            end

            p54:EndDialogue()
        end

        if p54.DialogueRenderGeneration == DialogueRenderGeneration and Dialogue.SkillTree then
            p54:OpenSkillTree(Dialogue.SkillTree)
        end
    end
end

function t1.EndDialogue(p56) -- line: 1439
    -- upvalues: RemoteEvent (copy)
    p56.DialogueRenderGeneration = (p56.DialogueRenderGeneration or 0) + 1
    p56.DialogueChoicePending = nil

    local DialogueChannel = p56.DialogueChannel

    p56.DialogueChannel = nil

    if DialogueChannel then
        DialogueChannel:Cancel()
    end

    p56.HUD.Dialogue.Visible = false
    p56:ClearDialogue()
    RemoteEvent:FireServer("ResetDialogue")
end

function t1.StopDialogueChannel(p57) -- line: 1451
    if p57.DialogueChannel then
        p57:EndDialogue()
    end
end

function t1.CloseSellGui(p58) -- line: 1457
    if p58.SellGui then
        p58.SellGui:Destroy()
        p58.SellGui = nil
    end

    p58.ShopNPC = nil
    p58.ShopInfo = nil

    local SellChannel = p58.SellChannel

    p58.SellChannel = nil

    if SellChannel then
        SellChannel:Cancel()
    end
end

local function clearViewportObjects(p59) -- line: 1469
    if not (p59 and p59:IsA("ViewportFrame")) then
        return
    end

    p59.CurrentCamera = nil

    for _, child in ipairs(p59:GetChildren()) do
        if child.Name == "VPObject" or child:IsA("Camera") then
            child:Destroy()
        end
    end

    p59:SetAttribute("ViewportItem", nil)
end

local function createViewportObjects(p60, p61, p62) -- line: 1481
    -- upvalues: Objects (copy), clearViewportObjects (copy)
    clearViewportObjects(p60)

    if typeof(p61) ~= "string" or p61 == "" then
        return
    end

    local v65 = typeof(p62) == "table"
    local v66 = if v65 then typeof(p62.ViewportOffset) == "CFrame" else nil

    if v65 and v66 then
        local v67 = Objects.Tools:FindFirstChild(p61)

        if v67 then
            local clone = v67:Clone()
            local CFrame

            if clone:IsA("Model") then
                local v68 = clone.PrimaryPart or clone:FindFirstChildWhichIsA("BasePart", true)

                if v68 then
                    CFrame = v68.CFrame
                end
            elseif clone:IsA("BasePart") then
                CFrame = clone.CFrame
            end

            if CFrame then
                clone.Name = "VPObject"
                clone.Parent = p60

                local Camera = Instance.new("Camera")

                Camera.Name = "Camera"
                Camera.CFrame = CFrame * p62.ViewportOffset
                Camera.Parent = p60
                p60.CurrentCamera = Camera
                p60:SetAttribute("ViewportItem", p61)
            else
                clone:Destroy()
            end
        end
    end
end

function t1.OpenSellGui(p63, p64) -- line: 1515
    -- upvalues: MarketplaceService (copy), ToolsLib (copy), ShopLib (copy), GamepassLib (copy), RemoteEvent (copy), Objects (copy), createViewportObjects (copy)
    p63:CloseSellGui()
    p63:StopDialogueChannel()

    local v69

    v69 = _G.Utl.Channel.new(1e999, function() -- line: 1520
        -- upvalues: p63 (copy), v69 (ref)
        if p63.SellChannel == v69 then
            p63:CloseSellGui()
        end
    end)
    p63.SellChannel = v69

    v69.Duration = function() -- line: 1526
        -- upvalues: p63 (copy), p64 (copy), v69 (ref)
        if p63.SellChannel == v69 and (not p64 or not p64.PrimaryPart or not p64:IsDescendantOf(workspace) or (p63.Root.Position - p64.PrimaryPart.Position).Magnitude > 12) then
            p63:CloseSellGui()
        end
    end

    p63.ShopInfo = ShopLib[p64.Name]
    p63.ShopNPC = p64

    local v71 = p63.ShopInfo.Mult or 1

    if MarketplaceService:UserOwnsGamePassAsync(p63.Player.UserId, 1538562178) or GamepassLib.HasGrant(p63.Data.GamepassGrants, 1538562178) then
        v71 += 0.5
    end

    if p63.SellChannel ~= v69 then
        return
    end

    v69:Start()
    p63.SellGui = Objects.SellGui:Clone()
    p63.SellGui.Parent = p63.Player.PlayerGui

    for v72, v73 in pairs(p63.Data.Items) do
        local v74 = ToolsLib[v72]

        if v74.SellValue and _G.Utl.tabFind(p63.ShopInfo.ToolTypes, v74.ToolType) then
            local clone = p63.SellGui.Main.Items.Sample:Clone()

            clone.Name = v72
            clone.ItemName.Text = v72

            if v73.Quantity > 1 then
                clone.ItemName.Text ..= " (x" .. v73.Quantity .. ")"
            end

            clone.SellValue.Text = "$" .. _G.Utl.addComas((tostring((math.floor(v74.SellValue * v71)))))
            clone.Visible = true
            clone.Parent = p63.SellGui.Main.Items
            createViewportObjects(clone, v72, v74)
            clone.Sell.MouseButton1Click:Connect(function() -- line: 1567
                -- upvalues: p64 (copy), v72 (copy), clone (copy), RemoteEvent (copy)
                if not clone:GetAttribute("Locked") then
                    RemoteEvent:FireServer("SellItem", v72, p64)
                end
            end)
            clone.Lock.MouseButton1Click:Connect(function() -- line: 1572
                -- upvalues: clone (copy)
                if clone:GetAttribute("Locked") then
                    clone:SetAttribute("Locked", nil)
                    clone.Lock.ImageTransparency = 0.6
                else
                    clone:SetAttribute("Locked", true)
                    clone.Lock.ImageTransparency = 0
                end
            end)
        end
    end

    p63.SellGui.Main.CloseButton.MouseButton1Click:Connect(function() -- line: 1583
        -- upvalues: p63 (copy)
        p63:CloseSellGui()
    end)

    local n3 = 0

    p63.SellGui.Main.SellAllButton.MouseButton1Click:Connect(function() -- line: 1588
        -- upvalues: p63 (copy), p64 (copy), n3 (ref), RemoteEvent (copy)
        if time() - n3 < 1 then
            return
        end

        n3 = time()

        local t7 = {}

        for _, child in pairs(p63.SellGui.Main.Items:GetChildren()) do
            if child:IsA("ViewportFrame") and child.Name ~= "Sample" and child:GetAttribute("Locked") then
                table.insert(t7, child.Name)
            end
        end

        RemoteEvent:FireServer("SellAllItems", p64, t7)
    end)
    p63.SellGui.Main.Gamepass.MouseButton1Click:Connect(function() -- line: 1602
        -- upvalues: p63 (copy), MarketplaceService (copy)
        MarketplaceService:PromptGamePassPurchase(p63.Player, 1538562178)
    end)
end

function t1.UpdateSellGui(p65, p66) -- line: 1607
    -- upvalues: ToolsLib (copy), RemoteEvent (copy), createViewportObjects (copy)
    if p65.SellGui then
        p65.Data.Items = p66

        for _, child in pairs(p65.SellGui.Main.Items:GetChildren()) do
            if child:IsA("ViewportFrame") and child.Name ~= "Sample" then
                if p65.Data.Items[child.Name] then
                    local v77 = p65.Data.Items[child.Name]

                    child.ItemName.Text = child.Name

                    if v77.Quantity > 1 then
                        child.ItemName.Text ..= " (x" .. v77.Quantity .. ")"
                    end
                else
                    child:Destroy()
                end
            end
        end

        for v78, v79 in pairs(p65.Data.Items) do
            local v80 = ToolsLib[v78]

            if v80.SellValue and _G.Utl.tabFind(p65.ShopInfo.ToolTypes, v80.ToolType) and not p65.SellGui.Main.Items:FindFirstChild(v78) then
                local clone = p65.SellGui.Main.Items.Sample:Clone()

                clone.Name = v78
                clone.ItemName.Text = v78

                if v79.Quantity > 1 then
                    clone.ItemName.Text ..= " (x" .. v79.Quantity .. ")"
                end

                clone.SellValue.Text = "$" .. _G.Utl.addComas((tostring(v80.SellValue)))
                clone.Visible = true
                clone.Parent = p65.SellGui.Main.Items
                createViewportObjects(clone, v78, v80)
                clone.Sell.MouseButton1Click:Connect(function() -- line: 1643
                    -- upvalues: p65 (copy), v78 (copy), RemoteEvent (copy)
                    RemoteEvent:FireServer("SellItem", v78, p65.ShopNPC)
                end)
            end
        end
    end
end

function t1.CloseShopGui(p67) -- line: 1650
    local ShopChannel = p67.ShopChannel

    p67.ShopChannel = nil

    if ShopChannel then
        ShopChannel:Cancel()
    end

    if p67.ShopGui then
        p67.ShopGui:Destroy()
        p67.ShopGui = nil
    end

    p67.ShopNPC = nil
    p67.ShopArgs = nil
end

function t1.UpdateShopGui(p68) -- line: 1662
    -- upvalues: ShopLib (copy), PumpkinXShopUI (copy)
    if p68.ShopArgs and p68.ShopArgs[2] == "Pumpkin X" then
        return PumpkinXShopUI.Update(p68)
    end

    if not (p68.ShopGui and p68.ShopArgs) then
        return
    end

    local v81 = p68.ShopArgs[1]
    local v82 = p68.ShopArgs[2]
    local Limit = v81:FindFirstChild("Limit")
    local v83 = ShopLib[v82]
    local v84 = if p68.ShopGui.Main.List.Visible then "List" else "Grid"

    if v84 ~= p68.Data.ShopFormat then
        p68.ShopGui.Main[v84].Visible = false

        for _, child in pairs(p68.ShopGui.Main[v84]:GetChildren()) do
            if not child:GetAttribute("noDelete") then
                child:Destroy()
            end
        end

        p68:CreateShop()
        p68.ShopGui.Main.Toggle.Text = p68.Data.ShopFormat .. " Mode"
    end

    if Limit then
        if p68.Data.ShopFormat == "List" then
            for v85, v86 in pairs(v83) do
                local v87 = v86.Limit or 1
                local v88 = p68.ShopGui.Main.List:FindFirstChild(v85)

                if v88 and Limit:FindFirstChild(v85) then
                    local v89 = v87 - Limit[v85].Value

                    if v87 <= Limit[v85].Value then
                        v88.Buy.Visible = false
                        v88.Stock.Text = "SOLD OUT"
                    else
                        v88.Stock.Text = v89 .. "X Stock"
                    end
                end
            end
        else
            for v90, v91 in pairs(v83) do
                local v92 = v91.Limit or 1
                local v93 = p68.ShopGui.Main.Grid:FindFirstChild(v90)

                if v93 and Limit:FindFirstChild(v90) then
                    local _ = v92 - Limit[v90].Value

                    if v92 <= Limit[v90].Value then
                        v93.Buy.Visible = false
                        v93.Req.Text = "SOLD OUT"
                        v93.Req.Visible = true
                    end
                end
            end
        end
    end
end

function t1.CreateShop(p69) -- line: 1727
    -- upvalues: ToolsLib (copy), ShopLib (copy), PumpkinXShopUI (copy), BaitsLib (copy), RemoteEvent (copy), createViewportObjects (copy)
    if p69.ShopArgs and p69.ShopArgs[2] == "Pumpkin X" then
        return PumpkinXShopUI.Render(p69)
    end

    if not (p69.ShopGui and p69.ShopArgs) then
        return
    end

    local v94 = p69.ShopArgs[1]
    local v95 = p69.ShopArgs[2]
    local ToolTip = p69.ShopGui.ToolTip
    local Limit = v94:FindFirstChild("Limit")
    local ShopFormat = p69.Data.ShopFormat
    local v96 = ShopLib[v95]

    if ShopFormat == "List" then
        for v97, v98 in pairs(v96) do
            if type(v98) == "table" then
                local v99 = if not v98.Type then ToolsLib[v97] elseif v98.Type == "Bait" then BaitsLib[v97] else nil
                local v100 = v98.LevelReq or 0
                local clone = p69.ShopGui.Main.List.Sample:Clone()

                clone.Name = v97
                clone.ItemName.Text = v97
                clone.Buy.Text = "$" .. _G.Utl.addComas((tostring(v98.Price)))
                clone.ItemType.Text = v98.Type or v99.ToolType
                clone.Visible = true
                clone.LayoutOrder = v98.LayoutOrder
                clone.Parent = p69.ShopGui.Main.List
                clone:SetAttribute("noDelete", nil)
                createViewportObjects(clone.ViewportFrame, v97, v99)

                if v100 <= p69.Data.Level then
                    clone.Buy.MouseButton1Click:Connect(function() -- line: 1767
                        -- upvalues: v94 (copy), v95 (copy), v97 (copy), RemoteEvent (copy)
                        RemoteEvent:FireServer("BuyItem", {
                            v97,
                            v95,
                            v94
                        })
                    end)
                else
                    clone.Req.Text = "Level " .. v100 .. " Required"
                    clone.Req.Visible = true
                end

                if Limit and Limit:FindFirstChild(v97) then
                    local v101 = v98.Limit or 1

                    if v101 <= Limit[v97].Value then
                        clone.Buy.Visible = false
                        clone.Stock.Text = "SOLD OUT"
                    else
                        local _ = v101 - Limit[v97].Value

                        clone.Stock.Text = v98.Limit .. "X Stock"
                    end
                else
                    clone.Stock.Text = v98.Limit .. "X Stock"
                end

                clone.MouseEnter:Connect(function() -- line: 1788
                    -- upvalues: p69 (copy), ToolTip (copy), clone (copy), v97 (copy), ToolsLib (copy)
                    local v102 = ToolsLib[v97]

                    if not v102 then
                        return
                    end

                    ToolTip.Position = UDim2.new(0, clone.AbsolutePosition.X, 0, p69.Mouse.Y)
                    ToolTip.Text = v102.ToolTip
                    ToolTip.Visible = true
                end)
                clone.MouseLeave:Connect(function() -- line: 1798
                    -- upvalues: ToolTip (copy)
                    ToolTip.Visible = false
                end)
            end
        end

        p69.ShopGui.Main.List.Visible = true
    else
        for v103, v104 in pairs(v96) do
            if type(v104) == "table" then
                local v105 = if not v104.Type then ToolsLib[v103] elseif v104.Type == "Bait" then BaitsLib[v103] else nil
                local v106 = v104.LevelReq or 0
                local clone = p69.ShopGui.Main.Grid.Sample:Clone()

                clone.Name = v103
                clone.ItemName.Text = v103
                clone.Buy.Text = "$" .. _G.Utl.addComas((tostring(v104.Price)))
                clone.Visible = true
                clone.LayoutOrder = v104.LayoutOrder
                clone.Parent = p69.ShopGui.Main.Grid
                clone:SetAttribute("noDelete", nil)
                createViewportObjects(clone, v103, v105)

                if v106 <= p69.Data.Level then
                    clone.Buy.MouseButton1Click:Connect(function() -- line: 1827
                        -- upvalues: v94 (copy), v95 (copy), v103 (copy), RemoteEvent (copy)
                        RemoteEvent:FireServer("BuyItem", {
                            v103,
                            v95,
                            v94
                        })
                    end)
                else
                    clone.Req.Text = "Level " .. v106 .. " Required"
                    clone.Req.Visible = true
                end

                if Limit and Limit:FindFirstChild(v103) and (v104.Limit or 1) <= Limit[v103].Value then
                    clone.Req.Text = "SOLD OUT"
                    clone.Req.Visible = true
                    clone.Buy.Visible = false
                end

                clone.MouseEnter:Connect(function() -- line: 1844
                    -- upvalues: p69 (copy), ToolTip (copy), v103 (copy), ToolsLib (copy)
                    local v107 = ToolsLib[v103]

                    if not v107 then
                        return
                    end

                    ToolTip.Position = UDim2.new(0, p69.Mouse.X, 0, p69.Mouse.Y)
                    ToolTip.Text = v107.ToolTip
                    ToolTip.Visible = true
                end)
                clone.MouseLeave:Connect(function() -- line: 1854
                    -- upvalues: ToolTip (copy)
                    ToolTip.Visible = false
                end)
            end
        end

        p69.ShopGui.Main.Grid.Visible = true
    end
end

function t1.OpenShopGui(p70, p71) -- line: 1862
    -- upvalues: ReplicatedStorage (copy), ShopLib (copy), RemoteEvent (copy)
    local v108 = p71[1]
    local v109 = p71[2]

    p70:CloseShopGui()
    p70:CloseSellGui()
    p70:StopDialogueChannel()
    p70.ShopArgs = p71

    local v110

    v110 = _G.Utl.Channel.new(1e999, function() -- line: 1872
        -- upvalues: p70 (copy), v110 (ref)
        if p70.ShopChannel == v110 then
            p70:CloseShopGui()
        end
    end)
    p70.ShopChannel = v110

    v110.Duration = function() -- line: 1878
        -- upvalues: p70 (copy), v108 (copy), v110 (ref)
        if not v108 or not v108.PrimaryPart or not v108:IsDescendantOf(workspace) or (p70.Root.Position - v108.PrimaryPart.Position).Magnitude > 12 then
            v110:StopShort()
        end
    end

    v110:Start()
    p70.ShopGui = ReplicatedStorage.Objects.ShopGui:Clone()
    p70.ShopGui.Main.Toggle.Text = p70.Data.ShopFormat .. " Mode"

    local Label = p70.ShopGui.Main.Label

    v109 = ShopLib[v109] and ShopLib[v109].DisplayName or v109
    Label.Text = v109
    p70.ShopGui.Parent = p70.Player.PlayerGui
    p70:CreateShop()
    p70.ShopGui.Main.Toggle.MouseButton1Click:Connect(function() -- line: 1897
        -- upvalues: RemoteEvent (copy)
        RemoteEvent:FireServer("ChangeShopFormat")
    end)
    p70.ShopGui.Main.CloseButton.MouseButton1Click:Connect(function() -- line: 1901
        -- upvalues: p70 (copy)
        p70:CloseShopGui()
    end)
end

function t1.CloseBank(p72) -- line: 1906
    if p72.ClosingBank then
        return
    end

    p72.ClosingBank = true

    local BankChannel, BankObject, BankAnim = p72.BankChannel, p72.BankObject, p72.BankAnim

    p72.BankChannel = nil
    p72.BankObject = nil
    p72.BankAnim = nil

    if BankChannel then
        BankChannel:Cancel()
    end

    p72.HUD.Bank.Visible = false
    p72.BankOpening = false
    p72.HUD.Bank.InputAmount:ReleaseFocus()
    p72:ClearBankCons()
    p72.ClosingBank = false

    if BankAnim then
        BankAnim:AdjustSpeed(-1)

        if BankObject and BankObject.PrimaryPart then
            p72:Sound({
                Sound = "SafeOpen",
                Speed = 1.1,
                Origin = BankObject.PrimaryPart
            })
            task.wait(0.7)
            p72:Sound({
                Sound = "SafeSpin",
                Pos = 11,
                Origin = BankObject.PrimaryPart
            })
        end
    end
end

function t1.CreateBankFrames(p73) -- line: 1931
    -- upvalues: ToolsLib (copy), clearViewportObjects (copy), createViewportObjects (copy)
    local Bank2 = typeof(p73.Data.Bank) == "table" and p73.Data.Bank or {}
    local v112 = 6 + (tonumber(p73.Data.ExtraBank) or 0)
    local ShopFormat = p73.Data.ShopFormat
    local v113 = p73.HUD.Bank:FindFirstChild(ShopFormat)

    if v113 then
        for i = 1, v112 do
            local v114 = tostring(i)
            local v115 = v113:FindFirstChild(v114)

            if not v115 then
                v115 = v113.Sample:Clone()
                v115.Name = v114
                v115.LayoutOrder = i
                v115.Visible = true
                v115.Parent = v113
                v115:SetAttribute("noDelete", nil)
            end

            local v117 = typeof(Bank2[i]) == "table"
            local v118 = if v117 then Bank2[i] else nil
            local v119 = if not v117 or not v118 then {} else v118
            local v120 = typeof(v119.Item) == "string"
            local Item2 = if v120 then v119.Item else nil
            local v121 = if not v120 or not Item2 then "" else Item2
            local v123 = math.max(0, tonumber(v119.Quantity) or 0)
            local v124 = ShopFormat == "List"
            local ViewportFrame = if v124 then v115:FindFirstChild("ViewportFrame") else nil
            local v125 = if not v124 or not ViewportFrame then v115 else ViewportFrame
            local v126 = ToolsLib[v121]
            local v127 = true

            if v121 == "" then
            elseif v126 then
                v115.ItemName.Text = v121

                if ShopFormat == "List" then
                    v115.Quantity.Text = "x" .. v123
                elseif v123 > 1 then
                    v115.ItemName.Text = v121 .. " (x" .. v123 .. ")"
                end

                v127 = false
            end

            if v127 then
                clearViewportObjects(v125)
                v115.ItemName.Text = "NOTHING"

                if ShopFormat == "List" then
                    v115.Quantity.Text = ""
                end
            else
                local ViewportItem = v125 and v125:GetAttribute("ViewportItem")
                local VPObject = v125 and v125:FindFirstChild("VPObject")
                local Camera = v125 and v125:FindFirstChildWhichIsA("Camera")

                if ViewportItem ~= v121 or not VPObject or not Camera then
                    createViewportObjects(v125, v121, v126)
                end
            end
        end
    end
end

function t1.UpdateBank(p74) -- line: 1981
    if not (p74.HUD.Bank.Visible and p74.BankObject) then
        return
    end

    local ShopFormat = p74.Data.ShopFormat
    local v128 = if p74.HUD.Bank.List.Visible then "List" else "Grid"

    p74.HUD.Bank.Toggle.Text = ShopFormat .. " Mode"

    if ShopFormat ~= v128 then
        p74.HUD.Bank[v128].Visible = false

        for _, child in pairs(p74.HUD.Bank[v128]:GetChildren()) do
            if not child:GetAttribute("noDelete") then
                child:Destroy()
            end
        end

        p74.HUD.Bank[ShopFormat].Visible = true
    end

    p74:CreateBankFrames()
    p74:InitBank()
end

function t1.OpenBank(p75, p76, p77) -- line: 2009
    -- upvalues: Animations (copy)
    if p75.HUD.Bank.Visible or p75.BankOpening then
        return
    end

    p75.BankOpening = true

    if p75.BankChannel then
        p75.BankChannel:Cancel()
        p75.BankChannel = nil
    end

    local ShopFormat = p75.Data.ShopFormat

    p75.HUD.Bank.List.Visible = ShopFormat == "List"
    p75.HUD.Bank.Grid.Visible = ShopFormat == "Grid"

    if p77 then
        p75.BankAnim = p76.AnimationController.Animator:LoadAnimation(Animations.SafeOpen)
        p75.BankAnim:Play()
        p75:Sound({
            Sound = "SafeSpin",
            Pos = 11,
            Origin = p76.PrimaryPart
        })
        p75:Sound({
            Sound = "SafeOpen",
            Speed = 1.1,
            Origin = p76.PrimaryPart
        })
        task.wait(1.1)

        if not p75.BankOpening then
            return
        end

        p75.BankAnim:AdjustSpeed(0)
    end

    p75.BankObject = p76

    local v129

    v129 = _G.Utl.Channel.new(1e999, function() -- line: 2030
        -- upvalues: p75 (copy), v129 (ref)
        if p75.BankChannel == v129 then
            p75:CloseBank()
        end
    end)
    p75.BankChannel = v129

    v129.Duration = function() -- line: 2036
        -- upvalues: p75 (copy), p76 (copy), v129 (ref)
        if not p76 or not p76.PrimaryPart or not p76:IsDescendantOf(workspace) or (p75.Root.Position - p76.PrimaryPart.Position).Magnitude > 20 then
            v129:StopShort()
        end
    end

    v129:Start()
    p75.HUD.Bank.Visible = true
    p75:UpdateBank(p76)
    p75.BankOpening = false
end

function t1.InitBank(p78) -- line: 2053
    -- upvalues: MarketplaceService (copy), RemoteEvent (copy)
    p78:ClearBankCons()

    local ShopFormat = p78.Data.ShopFormat
    local t8 = {}

    for _, child in pairs(p78.HUD.Bank[ShopFormat]:GetChildren()) do
        if not child:GetAttribute("noDelete") then
            local Store, Take = child.Store, child.Take

            p78.BankCons[child.Name .. "Store"] = Store.MouseButton1Click:Connect(function() -- line: 2064
                -- upvalues: p78 (copy), t8 (copy), child (copy), RemoteEvent (copy)
                if not (time() - (t8[child.Name .. "Store"] or 0) < 0.1) then
                    t8[child.Name .. "Store"] = time()
                    RemoteEvent:FireServer("StoreBank", child.Name, p78.HUD.Bank.InputAmount.Text, p78.BankObject)
                end
            end)
            p78.BankCons[child.Name .. "Take"] = Take.MouseButton1Click:Connect(function() -- line: 2070
                -- upvalues: p78 (copy), t8 (copy), child (copy), RemoteEvent (copy)
                if not (time() - (t8[child.Name .. "Take"] or 0) < 0.1) then
                    t8[child.Name .. "Take"] = time()
                    RemoteEvent:FireServer("TakeBank", child.Name, p78.HUD.Bank.InputAmount.Text, p78.BankObject)
                end
            end)
        end
    end

    p78.BankCons.ToggleBankFormat = p78.HUD.Bank.Toggle.MouseButton1Click:Connect(function() -- line: 2077
        -- upvalues: RemoteEvent (copy)
        RemoteEvent:FireServer("ChangeShopFormat")
    end)
    p78.BankCons.CloseBank = p78.HUD.Bank.CloseButton.MouseButton1Click:Connect(function() -- line: 2081
        -- upvalues: p78 (copy)
        p78:CloseBank()
    end)
    p78.BankCons.ExtraBank = p78.HUD.Bank.Extra.MouseButton1Click:Connect(function() -- line: 2085
        -- upvalues: p78 (copy), MarketplaceService (copy)
        MarketplaceService:PromptProductPurchase(p78.Player, 1608016814)
    end)
end

function t1.ClearBrewing(p79) -- line: 2090
    local Brewing = p79.HUD.Brewing

    for i = 1, 3 do
        local v132 = Brewing[i]

        if v132:FindFirstChild("VPObject") then
            v132.VPObject:Destroy()
        end

        if v132:FindFirstChild("Camera") then
            v132.Camera:Destroy()
        end
    end
end

function t1.UpdateBrewing(p80) -- line: 2104
    -- upvalues: ToolsLib (copy), createViewportObjects (copy)
    p80:ClearBrewing()

    local Brewing = p80.HUD.Brewing

    for v133, v134 in pairs(p80.Data.Brewing) do
        local v135 = Brewing[v133]

        if v134 ~= "" then
            createViewportObjects(v135, v134, ToolsLib[v134])
        end
    end
end

function t1.OpenBrewing(p81, p82) -- line: 2119
    if p81.HUD.Brewing.Visible then
        return
    end

    p81.HUD.Brewing.Visible = true
    p81:UpdateBrewing(p81.Data.Brewing)
    p81.Cauldron = p82

    local v136

    v136 = _G.Utl.Channel.new(1e999, function() -- line: 2126
        -- upvalues: p81 (copy), v136 (ref)
        if p81.BrewChannel == v136 then
            p81:CloseBrewing()
        end
    end)
    p81.BrewChannel = v136

    v136.Duration = function() -- line: 2132
        -- upvalues: p81 (copy), p82 (copy), v136 (ref)
        if (p81.Root.Position - p82.Position).Magnitude > 14 or not p82:IsDescendantOf(workspace) then
            v136:StopShort()
        end
    end

    v136:Start()
end

function t1.CloseBrewing(p83) -- line: 2141
    local BrewChannel = p83.BrewChannel

    p83.BrewChannel = nil

    if BrewChannel then
        BrewChannel:Cancel()
    end

    p83.HUD.Brewing.Visible = false
    p83.Cauldron = nil
end

function t1.InitBrewing(p84) -- line: 2149
    -- upvalues: RemoteEvent (copy)
    local Brewing = p84.HUD.Brewing
    local n4 = 0

    Brewing.Drop.MouseButton1Click:Connect(function() -- line: 2152
        -- upvalues: n4 (ref), RemoteEvent (copy)
        if not (time() - n4 < 0.5) then
            n4 = time()
            RemoteEvent:FireServer("BrewIngredient")
        end
    end)
    Brewing.CloseButton.MouseButton1Click:Connect(function() -- line: 2158
        -- upvalues: p84 (copy)
        p84:CloseBrewing()
    end)
end

function t1.BrewingEffect(p85, p86) -- line: 2163
    -- upvalues: TweenService (copy), Objects (copy)
    if p85.Cauldron then
        _G.Utl.PlaySound({
            Sound = "Bubbles",
            Volume = 1,
            Origin = p85.Cauldron,
            Speed = 0.95 + math.random() * 0.1
        })

        local clone = Objects.Tools:FindFirstChild(p86):Clone()

        if clone:IsA("Model") then
            clone = clone.PrimaryPart
        end

        clone.CFrame = p85.Cauldron.CFrame * CFrame.new(0, 3.5, 0)
        clone.Parent = workspace.CurrentCamera
        TweenService:Create(clone, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CFrame = p85.Cauldron.CFrame
        }):Play()
    end
end

function t1.ActivateClock(p87) -- line: 2179
    if p87.WatchCon then
        return
    end

    p87.HUD.Clock.Visible = true

    local ClockTime = workspace:WaitForChild("ClockTime")

    local function clockChanged() -- line: 2183
        -- upvalues: p87 (copy), ClockTime (copy)
        local v138 = math.floor(ClockTime.Value)
        local _ = v138 - math.floor(v138 / 60) * 60

        p87.HUD.Clock.Text = _G.Utl.timeFormat(v138)
    end

    p87.WatchCon = ClockTime.Changed:Connect(clockChanged)

    local v140 = math.floor(ClockTime.Value)
    local _ = v140 - math.floor(v140 / 60) * 60

    p87.HUD.Clock.Text = _G.Utl.timeFormat(v140)
end

function t1.ClearGuiCons(p88) -- line: 2194
    for v142, v143 in pairs(p88.GuiCons) do
        v143:Disconnect()
        p88.GuiCons[v142] = nil
    end
end

function t1.CloseAchievements(p89) -- line: 2201
    p89:ClearGuiCons()
    p89.HUD.Achievements.Visible = false
end

function t1.OpenAchievements(p90) -- line: 2206
    if p90.HUD.Achievements.Visible then
        p90:CloseAchievements()
    else
        p90.HUD.Achievements.Visible = true
    end
end

function t1.UpdateAchievements(p91) -- line: 2215
    -- upvalues: Achievements (copy), RemoteEvent (copy)
    p91:ClearGuiCons()

    local List = p91.HUD.Achievements.List

    for v144, v145 in pairs(p91.Data.Achievements) do
        local v146 = Achievements[v144]

        if v146 then
            local v147 = List:FindFirstChild(v144)

            if not v147 then
                v147 = List.Sample:Clone()
                v147.Name = v144
                v147.Title.Text = v144
                v147.Task.Text = v146.Task
                v147.LayoutOrder = v146.Order

                if v146.Rewards then
                    v147.Rewards.Text = "Rewards: "

                    local n5 = 1

                    for v148, v149 in pairs(v146.Rewards) do
                        if n5 == 1 then
                            v147.Rewards.Text = "Rewards: " .. v149 .. " " .. v148
                        else
                            v147.Rewards.Text ..= ", " .. v149 .. " " .. v148
                        end

                        n5 += 1
                    end
                else
                    v147.Rewards.Text = "No Rewards"
                end

                v147.Visible = true
                v147.Parent = List
            end

            local v150 = v145.Progress / v146.AmountNeed

            if v150 > 1 then
                v150 = 1
            end

            v147.Progress.Bar:TweenSize(UDim2.new(v150, 0, 1, 0), "Out", "Quad", 0.2, true)
            v147.Progress.Label.Text = _G.Utl.addComas((tostring((math.floor(v145.Progress))))) .. " / " .. _G.Utl.addComas((tostring(v146.AmountNeed)))

            if v145.Progress >= v146.AmountNeed then
                v147.EquipTitle.Visible = true
                p91.GuiCons[v144 .. "Equip"] = v147.EquipTitle.MouseButton1Click:Connect(function() -- line: 2254
                    -- upvalues: v144 (copy), RemoteEvent (copy)
                    RemoteEvent:FireServer("EquipTitle", v144)
                end)
            end
        end
    end

    p91.GuiCons.RemoveTitle = p91.HUD.Achievements.RemoveTitle.MouseButton1Click:Connect(function() -- line: 2260
        -- upvalues: RemoteEvent (copy)
        RemoteEvent:FireServer("RemoveTitle")
    end)
end

function t1.ChangeMouseIcon(p92, p93) -- line: 2265
    if p93 == "Default" then
        p92.Mouse.Icon = p92.DefaultIcon
        p92.HUD.Crosshair.Visible = false
        p92.MobileButtons.Buttons.Block.Text = "Block"

        if p92.TouchEnabled then
            p92.MainContext.Block.Touch.UIButton = p92.MobileButtons.Buttons.Block
            p92.MainContext.Reload.Touch.UIButton = nil
        end
    elseif p93 == "Gun" then
        p92.Mouse.Icon = "http://www.roblox.com/asset/?id=9947945465"

        if p92.TouchEnabled then
            p92.HUD.Crosshair.Visible = true
            p92.MobileButtons.Buttons.Block.Text = "Reload"
            p92.MainContext.Reload.Touch.UIButton = p92.MobileButtons.Buttons.Block
            p92.MainContext.Block.Touch.UIButton = nil
        end
    end
end

function t1.Recoil(p94, p95, p96) -- line: 2285
    local Up, Side, Shake = p95.Up, p95.Side, p95.Shake
    local v154 = if p96 then 1.5 else 1

    p94.Springs.recoil:shove(Vector3.new(Up[1] + math.random() * Up[2], Side[1] + math.random() * Side[2], Shake[1] + math.random() * Shake[2]) / v154)
end

function t1.UpdateMouse(p97, p98) -- line: 2298
    p97.UpdatingMouse = p98
end

function t1.SetReportAim(p99, p100) -- line: 2302
    p99.ReportingAim = not not p100
end

function t1.ShowAim(p101, p102) -- line: 2306
    if type(p102) ~= "table" then
        return
    end

    if not p101.AimParts then
        p101.AimParts = {}
    end

    if not (p101.AimFolder and p101.AimFolder.Parent) then
        p101.AimFolder = Instance.new("Folder")
        p101.AimFolder.Name = "ModAimLines"
        p101.AimFolder.Parent = workspace.CurrentCamera
    end

    local t9 = {}

    for v158, v159 in pairs(p102) do
        if v159.o and v159.a then
            t9[v158] = true

            local v160 = p101.AimParts[v158]

            if not (v160 and v160.Parent) then
                v160 = Instance.new("Part")
                v160.Anchored = true
                v160.CanCollide = false
                v160.CanQuery = false
                v160.CanTouch = false
                v160.CastShadow = false
                v160.Material = Enum.Material.Neon
                v160.Color = Color3.fromRGB(255, 45, 45)
                v160.Parent = p101.AimFolder
                p101.AimParts[v158] = v160
            end

            local Magnitude = (v159.a - v159.o).Magnitude

            v160.Size = Vector3.new(0.15, 0.15, (math.max(Magnitude, 0.05)))
            v160.CFrame = CFrame.new(v159.o, v159.a) * CFrame.new(0, 0, -Magnitude / 2)
        end
    end

    for v162, v163 in pairs(p101.AimParts) do
        if not t9[v162] then
            v163:Destroy()
            p101.AimParts[v162] = nil
        end
    end
end

function t1.ClearAim(p103) -- line: 2344
    if p103.AimParts then
        for _, v164 in pairs(p103.AimParts) do
            v164:Destroy()
        end

        p103.AimParts = {}
    end

    if p103.AimFolder then
        p103.AimFolder:Destroy()
        p103.AimFolder = nil
    end
end

function t1.Slide(p104) -- line: 2357
    -- upvalues: TweenService (copy), RemoteEvent (copy), Animations (copy)
    if p104.Character:GetAttribute("Fishing")
        or time() - p104.SlideCD < 1.75
        or not p104.Root
        or p104.Humanoid.Health <= 0
        or not p104.Root:FindFirstChild("RootRigAttachment")
        or not _G.Utl.Raycast({
            Origin = p104.Root.Position,
            Dir = p104.Root.CFrame.upVector * -3.5,
            Blacklist = { workspace.Live }
        }) then
        return
    end

    p104.Sliding = true
    RemoteEvent:FireServer("Slide")
    p104:EnableState({
        Bool = false,
        State = Enum.HumanoidStateType.GettingUp
    })
    p104:EnableState({
        Bool = false,
        State = Enum.HumanoidStateType.FallingDown
    })
    p104.SlideCD = time()
    _G.Utl.PlaySound({
        Sound = "Slide",
        Speed = 0.4,
        Pos = 0.25,
        Volume = 0.375,
        Origin = p104.Root
    })
    p104:LoadAnimation(Animations.Slide):Play()
    TweenService:Create(p104.Humanoid, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        CameraOffset = Vector3.new(0, -1.5, 0.25)
    }):Play()

    local WalkSpeed = p104.WalkSpeed

    if p104.Humanoid.Health < 20 then
        WalkSpeed *= 0.5
    end

    local BodyVelocity = Instance.new("BodyVelocity")

    BodyVelocity.MaxForce = Vector3.new(1E+07, 0, 1E+07)
    BodyVelocity.Velocity = p104.Root.CFrame.LookVector * (WalkSpeed * 2)
    BodyVelocity.Parent = p104.Root

    local n6 = 1

    for _ = 1, 10 do
        task.wait(0.05)
        n6 *= 0.97
        BodyVelocity.Velocity = p104.Root.CFrame.LookVector * (WalkSpeed * 2) * n6
        BodyVelocity.MaxForce *= 0.95
    end

    BodyVelocity:Destroy()
    p104.Sliding = false
    TweenService:Create(p104.Humanoid, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        CameraOffset = Vector3.new(0, 0.5, 0.15)
    }):Play()
    task.delay(0.25, function() -- line: 2404
        -- upvalues: p104 (copy)
        p104:EnableState({
            Bool = true,
            State = Enum.HumanoidStateType.GettingUp
        })
        p104:EnableState({
            Bool = true,
            State = Enum.HumanoidStateType.FallingDown
        })
    end)
end

function t1.BarsVisible(p105, p106) -- line: 2410
    p105.HUD.Hunger.Visible = p106
    p105.HUD.Thirst.Visible = p106
    p105.HUD.Armor.Visible = p106
    p105.HUD.Level.Visible = p106
end

function t1.EnableBackpack(p107, p108) -- line: 2417
    if p107.CustomBackpack then
        p107.CustomBackpack:SetEnabled(p108)
    end
end

function t1.GetStorageCapacity(p109) -- line: 2423
    -- upvalues: BaseObjectsLib (copy)
    local v165 = p109.StorageBase and p109.StorageBase:FindFirstChild("Contents")
    local Objects = v165 and v165:FindFirstChild("Objects")

    if not Objects then
        return 0
    end

    local n7 = 0

    for _, child in ipairs(Objects:GetChildren()) do
        local v166 = BaseObjectsLib[child.Name]

        n7 += v166 and v166.Capacity or 1
    end

    return n7
end

local function applyFactionSignIcon(p110, p111) -- line: 2435
    -- upvalues: Players (copy)
    if p111 == "FactionSign" then
        local v167 = p110:FindFirstChild("Icon", true)

        if v167 and v167:IsA("ImageLabel") then
            local FactionIcon = Players.LocalPlayer:GetAttribute("FactionIcon")

            if typeof(FactionIcon) ~= "string" or FactionIcon == "" then
                v167.Image = ""
                v167.Visible = false
            else
                v167.Image = FactionIcon
                v167.Visible = true
            end
        end
    end
end

local function createViewportBaseObjects(p112, p113) -- line: 2449
    -- upvalues: ReplicatedStorage (copy), BaseObjectsLib (copy), BaseCustomLib (copy), applyFactionSignIcon (copy)
    local v168 = ReplicatedStorage.BaseObjects:FindFirstChild(p113) or ReplicatedStorage.BaseCustomization:FindFirstChild(p113)
    local v169 = BaseObjectsLib[p113] or BaseCustomLib[p113]

    if not v168 then
        if not (v169.ViewportObject and ReplicatedStorage.BaseCustomization:FindFirstChild(v169.ViewportObject)) then
            return
        end

        v168 = ReplicatedStorage.BaseCustomization:FindFirstChild(v169.ViewportObject)
    end

    local clone = v168:Clone()

    applyFactionSignIcon(clone, p113)
    clone.Name = "VPObject"
    clone.Parent = p112

    local Camera = Instance.new("Camera")

    p112.CurrentCamera = Camera

    if clone:IsA("Model") then
        Camera.CFrame = clone.PrimaryPart.CFrame * v169.ViewportOffset
    else
        Camera.CFrame = clone.CFrame * v169.ViewportOffset
    end

    Camera.Parent = p112
end

function t1.ClearEditCons(p114) -- line: 2477
    for v170, v171 in pairs(p114.EditCons) do
        v171:Disconnect()
        p114.EditCons[v170] = nil
    end
end

local t10 = {
    ["Cube.002"] = true,
    ["Cube.003"] = true,
    ["Cube.006"] = true,
    ["Cube.007"] = true,
    ["Cube.009"] = true
}

function t1.GetDefaultDoorColor(p115) -- line: 2492
    local StorageBase = p115.StorageBase
    local SafezoneUnits = workspace:FindFirstChild("SafezoneUnits")

    if StorageBase and (StorageBase:GetAttribute("BaseOnly") == true or SafezoneUnits and StorageBase:IsDescendantOf(SafezoneUnits)) then
        return Color3.fromRGB(3, 133, 177)
    end

    return Color3.fromRGB(150, 85, 85)
end

function t1.GetDoorColor(p116) -- line: 2503
    local StorageBase = p116.StorageBase
    local DoorColor, v172

    if StorageBase then
        DoorColor = StorageBase:GetAttribute("DoorColor")
        v172 = typeof(DoorColor) == "Color3"
    end

    if not StorageBase or not v172 then
        return p116:GetDefaultDoorColor()
    end

    return DoorColor
end

function t1.PreviewDoorColor(p117, p118) -- line: 2514
    -- upvalues: t10 (copy)
    if typeof(p118) ~= "Color3" then
        return
    end

    local DoorColorPanel = p117.HUD.BaseCustomization:FindFirstChild("DoorColorPanel")

    if DoorColorPanel then
        DoorColorPanel.CurrentColor.BackgroundColor3 = p118
        DoorColorPanel.RGB.Text = string.format("RGB %d, %d, %d", math.round(p118.R * 255), math.round(p118.G * 255), (math.round(p118.B * 255)))
    end

    local v178 = p117.StorageBase and p117.StorageBase:FindFirstChild("Door")

    if v178 then
        for v179 in pairs(t10) do
            local v180 = v178:FindFirstChild(v179)

            if v180 and v180:IsA("BasePart") then
                v180.Color = p118
            end
        end
    end
end

function t1.CloseDoorColorPicker(p119) -- line: 2538
    local DoorColorPickerHUD = p119.DoorColorPickerHUD

    if DoorColorPickerHUD then
        p119.DoorColorPickerHUD = nil
        DoorColorPickerHUD:Destroy()
    end
end

function t1.OpenDoorColorPicker(p120) -- line: 2546
    -- upvalues: GuiService (copy), ColorPicker (copy), RemoteEvent (copy)
    if p120.StorageBase then
        p120:CloseDoorColorPicker()

        local v181 = ColorPicker.new({
            RealTimeEventCalling = false,
            Position = UDim2.fromOffset(0, 0),
            PickerMode = ColorPicker.PICKER_MODE.CIRCLE,
            ColorSpace = ColorPicker.COLOR_SPACE.RGB
        })
        local ViewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
        local GuiInset, GuiInset2 = GuiService:GetGuiInset()
        local v185 = Vector2.new(math.max(1, ViewportSize.X - GuiInset.X - GuiInset2.X), (math.max(1, ViewportSize.Y - GuiInset.Y - GuiInset2.Y)))
        local v189 = math.clamp(math.min((v185.X - 24) / 238, (v185.Y - 24) / 334), 0.65, 1)
        local UIScale = v181.Instance:FindFirstChildWhichIsA("UIScale")

        if not UIScale then
            UIScale = Instance.new("UIScale")
            UIScale.Parent = v181.Instance
        end

        UIScale.Scale = v189
        v181.Instance.Position = UDim2.fromOffset(math.max(12, (math.floor((v185.X - v189 * 238) / 2))), (math.max(12, (math.floor((v185.Y - v189 * 334) / 2)))))
        v181:SetColor(p120:GetDoorColor())
        p120.DoorColorPickerHUD = v181
        v181.ColorChanged:Connect(function(p121) -- line: 2576
            -- upvalues: p120 (copy), v181 (copy), RemoteEvent (copy)
            if p120.DoorColorPickerHUD == v181 and p120.CustomizingBase and p120.StorageBase then
                local v203 = Color3.fromRGB(math.clamp(math.round(p121.R * 255), 0, 255), math.clamp(math.round(p121.G * 255), 0, 255), (math.clamp(math.round(p121.B * 255), 0, 255)))

                p120:PreviewDoorColor(v203)
                RemoteEvent:FireServer("ChangeBaseDoorColor", v203)
            end
        end)
        v181.WindowClosed:Connect(function() -- line: 2586
            -- upvalues: p120 (copy), v181 (copy)
            if p120.DoorColorPickerHUD == v181 then
                p120:CloseDoorColorPicker()
            end
        end)
    end
end

function t1.CloseCustomizeBase(p122) -- line: 2593
    p122.CustomizingBase = nil

    local BaseEdit, BaseCustomization = p122.HUD.BaseEdit, p122.HUD.BaseCustomization

    p122:CloseDoorColorPicker()
    p122:ClearEditCons()
    p122:ClearCustomObjects()
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

    p122.PendingBaseUnitSize = nil
    p122.PendingBaseUnitDeleteCount = nil
    BaseEdit.CustomizeBase.Text = "Customize"
    BaseCustomization.Visible = false
end

function t1.OpenCustomizeBase(p123) -- line: 2618
    -- upvalues: UserInputService (copy), GuiService (copy), RemoteEvent (copy)
    p123.CustomizingBase = true

    local BaseEdit, BaseCustomization = p123.HUD.BaseEdit, p123.HUD.BaseCustomization
    local DoorColorPanel = BaseCustomization.DoorColorPanel
    local UnitSizePanel = BaseCustomization:FindFirstChild("UnitSizePanel")
    local LightsPanel = BaseCustomization:FindFirstChild("LightsPanel")

    p123:UpdateCustomObjects(p123.BaseCustomType)

    for _, child in pairs(BaseCustomization.Types:GetChildren()) do
        if child:IsA("TextButton") then
            p123.EditCons[child.Name .. "Clicked"] = child.Activated:Connect(function() -- line: 2629
                -- upvalues: p123 (copy), DoorColorPanel (copy), UnitSizePanel (copy), LightsPanel (copy), child (copy), UserInputService (copy), GuiService (copy)
                p123:CloseDoorColorPicker()
                p123.BaseCustomType = child.Name
                p123:UpdateCustomObjects(p123.BaseCustomType)

                if UserInputService.GamepadEnabled then
                    if child.Name == "Door" then
                        GuiService.SelectedObject = DoorColorPanel.ChooseColor
                    elseif child.Name ~= "Size" or not UnitSizePanel then
                        if child.Name == "Lights" and LightsPanel and LightsPanel.Toggle.Selectable then
                            GuiService.SelectedObject = LightsPanel.Toggle
                        end
                    else
                        local v205 = UnitSizePanel:FindFirstChild("Size" .. 1)

                        if v205 and v205.Selectable then
                            GuiService.SelectedObject = v205
                        else
                            local v206 = UnitSizePanel:FindFirstChild("Size" .. 2)

                            if v206 and v206.Selectable then
                                GuiService.SelectedObject = v206
                            else
                                local v207 = UnitSizePanel:FindFirstChild("Size" .. 3)

                                if v207 and v207.Selectable then
                                    GuiService.SelectedObject = v207
                                end
                            end
                        end
                    end
                end
            end)
        end
    end

    p123.EditCons.RemoveButton = BaseCustomization.RemoveButton.Activated:Connect(function() -- line: 2652
        -- upvalues: p123 (copy), RemoteEvent (copy)
        if p123.BaseCustomType ~= "Door" and p123.BaseCustomType ~= "Size" and p123.BaseCustomType ~= "Lights" then
            RemoteEvent:FireServer("RemoveBase" .. p123.BaseCustomType)
        end
    end)
    p123.EditCons.DoorChooseColor = DoorColorPanel.ChooseColor.Activated:Connect(function() -- line: 2659
        -- upvalues: p123 (copy)
        if p123.DoorColorPickerHUD then
            p123:CloseDoorColorPicker()
        else
            p123:OpenDoorColorPicker()
        end
    end)
    p123.EditCons.DoorResetColor = DoorColorPanel.Reset.Activated:Connect(function() -- line: 2666
        -- upvalues: p123 (copy), RemoteEvent (copy)
        p123:CloseDoorColorPicker()
        p123:PreviewDoorColor(p123:GetDefaultDoorColor())
        RemoteEvent:FireServer("ResetBaseDoorColor")
    end)

    if p123.StorageBase then
        p123.EditCons.DoorColorChanged = p123.StorageBase:GetAttributeChangedSignal("DoorColor"):Connect(function() -- line: 2672
            -- upvalues: p123 (copy)
            p123:PreviewDoorColor(p123:GetDoorColor())
        end)
    end

    if UnitSizePanel then
        for i = 1, 3 do
            local v208 = UnitSizePanel:FindFirstChild("Size" .. i)

            if v208 then
                p123.EditCons["BaseUnitSize" .. i] = v208.Activated:Connect(function() -- line: 2680
                    -- upvalues: p123 (copy), i (copy)
                    p123:CancelBaseUnitResize()
                    p123:RequestBaseUnitSize(i)
                end)
            end
        end

        p123.EditCons.BaseUnitConfirm = UnitSizePanel.Confirm.Activated:Connect(function() -- line: 2686
            -- upvalues: p123 (copy)
            if p123.PendingBaseUnitSize then
                p123:RequestBaseUnitSize(p123.PendingBaseUnitSize, p123.PendingBaseUnitDeleteCount)
            end
        end)
        p123.EditCons.BaseUnitCancel = UnitSizePanel.Cancel.Activated:Connect(function() -- line: 2691
            -- upvalues: p123 (copy)
            p123:CancelBaseUnitResize()
        end)
        p123:UpdateUnitSizePanel()
    end

    if LightsPanel then
        p123.EditCons.BaseLightsToggle = LightsPanel.Toggle.Activated:Connect(function() -- line: 2697
            -- upvalues: p123 (copy), RemoteEvent (copy)
            if p123.StorageBase then
                RemoteEvent:FireServer("SetBaseLightsEnabled", not (p123.StorageBase:GetAttribute("BaseLightsEnabled") ~= false))
            end
        end)
        p123:UpdateLightsPanel()
    end

    if p123.StorageBase then
        p123.EditCons.BaseLightsChanged = p123.StorageBase:GetAttributeChangedSignal("BaseLightsEnabled"):Connect(function() -- line: 2705
            -- upvalues: p123 (copy)
            p123:UpdateLightsPanel()
        end)
    end

    BaseEdit.CustomizeBase.Text = "Close Customization"
    BaseCustomization.Visible = true
end

function t1.ClearCustomObjects(p124) -- line: 2714
    local List = p124.HUD.BaseCustomization.List

    for _, child in pairs(List:GetChildren()) do
        if child:IsA("ViewportFrame") and child.Name ~= "Sample" then
            child:Destroy()
        end
    end
end

function t1.UpdateCustomObjects(p125, p126) -- line: 2723
    -- upvalues: BaseCustomLib (copy), RemoteEvent (copy), createViewportBaseObjects (copy)
    local BaseCustomization = p125.HUD.BaseCustomization
    local List, DoorColorPanel = BaseCustomization.List, BaseCustomization.DoorColorPanel
    local UnitSizePanel = BaseCustomization:FindFirstChild("UnitSizePanel")
    local LightsPanel = BaseCustomization:FindFirstChild("LightsPanel")

    p125:ClearCustomObjects()

    if p126 == "Door" then
        List.Visible = false
        BaseCustomization.RemoveButton.Visible = false
        DoorColorPanel.Visible = true

        if UnitSizePanel then
            UnitSizePanel.Visible = false
        end

        if LightsPanel then
            LightsPanel.Visible = false
        end

        p125:PreviewDoorColor(p125:GetDoorColor())
    else
        p125:CloseDoorColorPicker()

        if p126 == "Size" then
            List.Visible = false
            BaseCustomization.RemoveButton.Visible = false
            DoorColorPanel.Visible = false

            if LightsPanel then
                LightsPanel.Visible = false
            end

            if UnitSizePanel then
                UnitSizePanel.Visible = true
                p125:UpdateUnitSizePanel()
            end
        elseif p126 == "Lights" then
            List.Visible = false
            BaseCustomization.RemoveButton.Visible = false
            DoorColorPanel.Visible = false

            if UnitSizePanel then
                UnitSizePanel.Visible = false
            end

            if LightsPanel then
                LightsPanel.Visible = true
                p125:UpdateLightsPanel()
            end
        else
            List.Visible = true
            BaseCustomization.RemoveButton.Visible = true
            DoorColorPanel.Visible = false

            if UnitSizePanel then
                UnitSizePanel.Visible = false
            end

            if LightsPanel then
                LightsPanel.Visible = false
            end

            for v211, v212 in pairs(BaseCustomLib) do
                if v212.Type == p126 then
                    local clone = List.Sample:Clone()

                    clone.Name = v211
                    clone.Price.Text = "$" .. v212.Price
                    clone.ObjectName.Text = v211
                    clone.Visible = true
                    clone.LayoutOrder = v212.Price
                    createViewportBaseObjects(clone, v211, p126)
                    clone.Parent = List
                    clone.Select.Activated:Connect(function() -- line: 2781
                        -- upvalues: p126 (copy), v211 (copy), RemoteEvent (copy)
                        RemoteEvent:FireServer("ChangeBase" .. p126, v211)
                    end)
                end
            end
        end
    end
end

function t1.GetBasePrice(_, p128) -- line: 2788
    -- upvalues: BaseObjectsLib (copy), BaseCustomLib (copy)
    local n8 = 0

    for _, v214 in pairs(p128.BaseObjects) do
        local v215 = if typeof(v214) == "table" then BaseObjectsLib[v214.Object] else BaseObjectsLib[v214]

        if v215 and not v215.ItemObject then
            n8 += v215.Price
        end
    end

    if p128.BaseWall and p128.BaseWall ~= "" then
        local v216 = BaseCustomLib[p128.BaseWall]

        if v216 then
            n8 += v216.Price
        end
    end

    if p128.BaseFloor and p128.BaseFloor ~= "" then
        local v217 = BaseCustomLib[p128.BaseFloor]

        if v217 then
            n8 += v217.Price
        end
    end

    if p128.BaseBasement and p128.BaseBasement ~= "" then
        local v218 = BaseCustomLib[p128.BaseBasement]

        if v218 then
            n8 += v218.Price
        end
    end

    return n8
end

function t1.OpenBaseSlotConfirmation(p129, p130, p131) -- line: 2825
    -- upvalues: UserInputService (copy), GuiService (copy)
    local v219 = p129.HUD and p129.HUD:FindFirstChild("BaseSlotConfirm")
    local Panel = v219 and v219:FindFirstChild("Panel")
    local v220 = p129.Data and p129.Data.BaseSlots
    local v221 = if p130 == "Save" then "Save" elseif p130 == "Load" then "Load" else nil
    local v222 = tonumber(p131)
    local v223 = true

    if not v219
        or not Panel
        or not p129.InBaseSlots
        or not v221
        or not v222
        or v222 % 1 ~= 0
        or v222 < 1
        or v222 > 6 then
    elseif typeof(v220) == "table" and v220[v222] then
        if not p129.BaseSlotConfirmAction then
            p129.BaseSlotConfirmPreviousSelection = GuiService.SelectedObject
        end

        v223 = false
    end

    if v223 then
        return false
    end

    p129.BaseSlotConfirmAction = v221
    p129.BaseSlotConfirmSlot = v222

    if v221 == "Save" then
        Panel.Title.Text = ("OVERWRITE SLOT %d?"):format(v222)
        Panel.Message.Text = ("Save your current base to Slot %d? Anything already saved in this slot will be replaced."):format(v222)
        Panel.Warning.Text = "Existing save will be replaced."
        Panel.Confirm.Text = "OVERWRITE"
    else
        Panel.Title.Text = ("LOAD SLOT %d?"):format(v222)
        Panel.Message.Text = ("Load Slot %d? Everything currently in your base will be replaced by this saved layout."):format(v222)
        Panel.Warning.Text = "Unsaved changes will be lost."
        Panel.Confirm.Text = "LOAD SLOT"
    end

    local FocusedTextBox = UserInputService:GetFocusedTextBox()

    if FocusedTextBox then
        FocusedTextBox:ReleaseFocus()
    end

    v219.Visible = true

    local Cancel = Panel:FindFirstChild("Cancel")

    if UserInputService.GamepadEnabled and Cancel and Cancel:IsA("GuiButton") then
        GuiService.SelectedObject = Cancel
    end

    return true
end

function t1.CloseBaseSlotConfirmation(p132) -- line: 2864
    -- upvalues: GuiService (copy)
    local v224 = p132.HUD and p132.HUD:FindFirstChild("BaseSlotConfirm")
    local v225 = p132.BaseSlotConfirmAction ~= nil
    local BaseSlotConfirmPreviousSelection = p132.BaseSlotConfirmPreviousSelection

    p132.BaseSlotConfirmAction = nil
    p132.BaseSlotConfirmSlot = nil
    p132.BaseSlotConfirmPreviousSelection = nil

    if v224 then
        v224.Visible = false
    end

    local GuiService2, BaseSlotConfirmPreviousSelection2

    if v225 and v224 then
        local SelectedObject = GuiService.SelectedObject

        if SelectedObject and SelectedObject:IsDescendantOf(v224) then
            GuiService2 = GuiService

            if BaseSlotConfirmPreviousSelection and BaseSlotConfirmPreviousSelection.Parent then
                BaseSlotConfirmPreviousSelection2 = BaseSlotConfirmPreviousSelection
            end

            GuiService2.SelectedObject = BaseSlotConfirmPreviousSelection2
        end
    end
end

function t1.CloseBaseSlots(p133) -- line: 2880
    p133.InBaseSlots = nil
    p133:ClearBaseSlots()
    p133:CloseBaseSlotConfirmation()
    p133:ClearEditCons()
    p133.HUD.BaseSlots.Visible = false
    p133.HUD.BaseEdit.BaseSaveSlots.Text = "Save Slots"
end

function t1.OpenBaseSlots(p134) -- line: 2889
    -- upvalues: UserInputService (copy), MarketplaceService (copy), RemoteEvent (copy)
    p134:UpdateBaseSlots()
    p134.InBaseSlots = true
    p134.EditCons.ExtraSlotClicked = p134.HUD.BaseSlots.ExtraSlot.MouseButton1Click:Connect(function() -- line: 2892
        -- upvalues: p134 (copy), MarketplaceService (copy)
        if #p134.Data.BaseSlots >= 6 then
            p134:Noti({
                Title = "Error",
                Text = "Max Slots!",
                Duration = 2
            })
        else
            MarketplaceService:PromptProductPurchase(p134.Player, 1872969573)
        end
    end)

    local BaseSlotConfirm = p134.HUD:FindFirstChild("BaseSlotConfirm")
    local Panel = BaseSlotConfirm and BaseSlotConfirm:FindFirstChild("Panel")

    if Panel then
        local Confirm = Panel:FindFirstChild("Confirm")
        local Cancel = Panel:FindFirstChild("Cancel")

        if Confirm and Confirm:IsA("GuiButton") then
            p134.EditCons.BaseSlotConfirmClicked = Confirm.Activated:Connect(function() -- line: 2906
                -- upvalues: p134 (copy), RemoteEvent (copy)
                local BaseSlotConfirmAction, BaseSlotConfirmSlot = p134.BaseSlotConfirmAction, p134.BaseSlotConfirmSlot

                if BaseSlotConfirmAction and BaseSlotConfirmSlot then
                    p134:CloseBaseSlotConfirmation()

                    if BaseSlotConfirmAction == "Save" then
                        RemoteEvent:FireServer("SaveBaseSlot", BaseSlotConfirmSlot, true)
                    else
                        RemoteEvent:FireServer("LoadBaseSlot", BaseSlotConfirmSlot, true)
                    end
                end
            end)
        end

        if Cancel and Cancel:IsA("GuiButton") then
            p134.EditCons.BaseSlotCancelClicked = Cancel.Activated:Connect(function() -- line: 2919
                -- upvalues: p134 (copy)
                p134:CloseBaseSlotConfirmation()
            end)
        end

        p134.EditCons.BaseSlotConfirmInput = UserInputService.InputBegan:Connect(function(p135) -- line: 2923
            -- upvalues: p134 (copy)
            if p134.BaseSlotConfirmAction and (p135.KeyCode == Enum.KeyCode.Escape or p135.KeyCode == Enum.KeyCode.ButtonB) then
                p134:CloseBaseSlotConfirmation()
            end
        end)
    end

    p134.HUD.BaseEdit.BaseSaveSlots.Text = "Close Save Slots"
    p134.HUD.BaseSlots.Visible = true
end

function t1.ClearBaseSlots(p136) -- line: 2935
    local List = p136.HUD.BaseSlots.List

    for _, child in pairs(List:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "Sample" then
            child:Destroy()
        end
    end
end

function t1.UpdateBaseSlots(p137) -- line: 2946
    -- upvalues: RemoteEvent (copy)
    local BaseSlots = p137.Data.BaseSlots
    local List = p137.HUD.BaseSlots.List

    for v226, v227 in pairs(BaseSlots) do
        local v228 = List:FindFirstChild(v226)

        if not v228 then
            v228 = List.Sample:Clone()
            v228.Name = v226
            v228.SlotLabel.Text = "Slot " .. v226
            v228.Visible = true
            v228.Parent = List
            v228.SaveButton.Activated:Connect(function() -- line: 2959
                -- upvalues: p137 (copy), v226 (copy)
                p137:OpenBaseSlotConfirmation("Save", v226)
            end)
            v228.LoadButton.Activated:Connect(function() -- line: 2963
                -- upvalues: p137 (copy), v226 (copy)
                p137:OpenBaseSlotConfirmation("Load", v226)
            end)
            v228.UpdateName.MouseButton1Click:Connect(function() -- line: 2967
                -- upvalues: v226 (copy), v228 (ref), RemoteEvent (copy)
                RemoteEvent:FireServer("UpdateSlotName", v226, v228.SlotName.Text)
            end)
        end

        local v231 = math.clamp(math.floor(tonumber(v227.BaseUnitSize) or 1), 1, 3)

        v228.CostLabel.Text = ("Cost: $%d  |  %d Unit%s"):format(p137:GetBasePrice(v227), v231, v231 == 1 and "" or "s")

        if v227.SlotName == "" then
            v228.SlotLabel.Text = "Slot " .. v226
        else
            v228.SlotLabel.Text = v227.SlotName
        end
    end
end

function t1.NotInBase(p138) -- line: 2983
    p138.Player:SetAttribute("InBase", nil)

    if p138.CustomizingBase then
        p138:CloseCustomizeBase()
    else
        p138:CloseDoorColorPicker()
    end

    local BaseEdit = p138.HUD.BaseEdit

    BaseEdit.BaseObjects.Text = "Base Objects"
    BaseEdit.CustomizeBase.Text = "Customize"
    BaseEdit.Paint.Text = "Paint"
    BaseEdit.BaseSaveSlots.Text = "Save Slots"

    if p138.InBaseSlots then
        p138:CloseBaseSlots()
    end

    if p138.Painting then
        p138:ClosePaintFrames()
    end

    if p138.EditingBase then
        p138:StopEditStorage()
    end

    p138.HUD.BaseEdit.Visible = false
    p138.HUD.BaseCustomization.Visible = false
    p138.HUD.BaseSlots.Visible = false
end

function t1.ClosePaintFrames(p139) -- line: 3010
    -- upvalues: PaintController (copy)
    PaintController.Close(p139)
end

function t1.OpenPaintFrames(p140) -- line: 3034
    -- upvalues: PaintController (copy)
    local EditingBase = p140.EditingBase
    local BuildCameraActive

    if not EditingBase then
        p140:EditStorage()
        BuildCameraActive = p140.BuildCameraActive
    end

    if EditingBase or BuildCameraActive then
        return PaintController.Open(p140)
    end

    return false
end

function t1.ColorPickerOff(p141) -- line: 3141
    -- upvalues: PaintController (copy)
    PaintController.ClosePicker(p141)
end

function t1.ColorPicker(p142) -- line: 3152
    -- upvalues: PaintController (copy)
    return PaintController.TogglePicker(p142)
end

function t1.UpdateLightsPanel(p143) -- line: 3165
    local v232 = p143.HUD and p143.HUD:FindFirstChild("BaseCustomization")
    local LightsPanel = v232 and v232:FindFirstChild("LightsPanel")

    if not LightsPanel then
        return
    end

    local v233 = not p143.StorageBase or p143.StorageBase:GetAttribute("BaseLightsEnabled") ~= false

    LightsPanel.Status.Text = v233 and "Ceiling Lights: ON" or "Ceiling Lights: OFF"
    LightsPanel.Status.TextColor3 = v233 and Color3.fromRGB(129, 230, 154) or Color3.fromRGB(255, 120, 120)
    LightsPanel.Toggle.Text = v233 and "Turn Lights Off" or "Turn Lights On"
    LightsPanel.Toggle.BackgroundColor3 = v233 and Color3.fromRGB(90, 45, 45) or Color3.fromRGB(46, 139, 87)

    local v234 = p143.StorageBase ~= nil

    LightsPanel.Toggle.Interactable = v234
    LightsPanel.Toggle.Selectable = v234
    LightsPanel.Toggle.AutoButtonColor = v234
end

function t1.GetBaseResizeRemaining(p144) -- line: 3187
    local StorageBase = p144.StorageBase

    if not StorageBase then
        return 0
    end

    local BaseResizeAvailableAt = StorageBase:GetAttribute("BaseResizeAvailableAt")

    if typeof(BaseResizeAvailableAt) ~= "number" then
        return 0
    end

    return (math.max(0, BaseResizeAvailableAt - workspace:GetServerTimeNow()))
end

function t1.UpdateUnitSizePanel(p145) -- line: 3195
    local v236 = p145.HUD and p145.HUD:FindFirstChild("BaseCustomization")
    local UnitSizePanel = v236 and v236:FindFirstChild("UnitSizePanel")

    if not UnitSizePanel then
        return
    end

    local v239 = math.clamp(math.floor(p145.StorageBase and tonumber(p145.StorageBase:GetAttribute("BaseUnitSize")) or 1), 1, 3)

    UnitSizePanel.CurrentSize.Text = ("Current Size: %d Unit%s"):format(v239, v239 == 1 and "" or "s")

    local BaseResizeRemaining = p145:GetBaseResizeRemaining()

    if BaseResizeRemaining > 0 then
        UnitSizePanel.Cooldown.Text = ("Resize available in 0:%02d"):format((math.ceil(BaseResizeRemaining)))
        UnitSizePanel.Cooldown.TextColor3 = Color3.fromRGB(255, 203, 105)
    else
        UnitSizePanel.Cooldown.Text = "Ready to resize"
        UnitSizePanel.Cooldown.TextColor3 = Color3.fromRGB(129, 230, 154)
    end

    local v240 = p145.ResizingBaseUnits or p145.PendingBaseUnitSize ~= nil

    for i = 1, 3 do
        local v241 = UnitSizePanel:FindFirstChild("Size" .. i)

        if v241 then
            local v242 = i == v239
            local v243 = if v242 then Color3.fromRGB(46, 139, 87) else nil

            if not v242 or not v243 then
                v241.BackgroundColor3 = Color3.fromRGB(37, 44, 56)
            else
                v241.BackgroundColor3 = v243
            end

            local StateStroke = v241:FindFirstChild("StateStroke")

            if StateStroke then
                StateStroke.Color = v242 and Color3.fromRGB(67, 181, 255) or Color3.fromRGB(210, 220, 235)
                StateStroke.Thickness = v242 and 2.5 or 1
            end

            local v244 = not v242 and BaseResizeRemaining <= 0 and not v240 and p145.StorageBase ~= nil

            v241.Interactable = v244
            v241.AutoButtonColor = v241.Interactable
            v241.Selectable = v241.Interactable
        end
    end

    local v245 = p145.PendingBaseUnitSize ~= nil

    UnitSizePanel.Confirm.Interactable = v245 and not p145.ResizingBaseUnits
    UnitSizePanel.Cancel.Interactable = v245 and not p145.ResizingBaseUnits
    UnitSizePanel.Confirm.AutoButtonColor = UnitSizePanel.Confirm.Interactable
    UnitSizePanel.Cancel.AutoButtonColor = UnitSizePanel.Cancel.Interactable
    UnitSizePanel.Confirm.Selectable = UnitSizePanel.Confirm.Interactable
    UnitSizePanel.Cancel.Selectable = UnitSizePanel.Cancel.Interactable
end

function t1.CancelBaseUnitResize(p146) -- line: 3238
    p146.PendingBaseUnitSize = nil
    p146.PendingBaseUnitDeleteCount = nil

    local UnitSizePanel = p146.HUD.BaseCustomization:FindFirstChild("UnitSizePanel")

    if UnitSizePanel then
        UnitSizePanel.Warning.Visible = false
        UnitSizePanel.Confirm.Visible = false
        UnitSizePanel.Cancel.Visible = false
    end

    p146:UpdateUnitSizePanel()
end

function t1.RequestBaseUnitSize(p147, p148, p149) -- line: 3250
    -- upvalues: UserInputService (copy), GuiService (copy), MarketplaceService (copy), RemoteFunction (copy)
    local v246 = p148

    if not p147.ResizingBaseUnits and p147.StorageBase then
        local v247 = tonumber(p148)

        v246 = v247

        if not v247 then
            return
        end

        local StorageBase = p147.StorageBase

        p147.ResizingBaseUnits = true
        p147:UpdateUnitSizePanel()
        task.spawn(function() -- line: 3257
            -- upvalues: v246 (ref), p147 (copy), p149 (copy), StorageBase (copy), UserInputService (copy), GuiService (copy), MarketplaceService (copy), RemoteFunction (copy)
            local function v248() -- line: 3258
                -- upvalues: v246 (ref), p149 (copy), RemoteFunction (copy)
                return RemoteFunction:InvokeServer("ResizeBaseUnits", v246, p149)
            end

            local v249, v250, v251, v252 = pcall(v248)

            p147.ResizingBaseUnits = nil

            if p147.StorageBase ~= StorageBase then
                p147:CancelBaseUnitResize()

                return
            end

            if not v249 then
                p147:Noti({
                    Title = "Resize Failed",
                    Text = "The server could not resize your base. Please try again.",
                    Duration = 3
                })
                p147:UpdateUnitSizePanel()

                return
            end

            if v250 then
                p147:CancelBaseUnitResize()

                local v253 = tonumber(v252) or 0
                local v255 = ("Your base is now %d unit%s wide."):format(v246, if v246 == 1 then "" else "s")

                if v253 > 0 then
                    v255 ..= (" %d object%s outside the kept area were deleted without a refund."):format(v253, if v253 == 1 then "" else "s")
                end

                p147:Noti({
                    Title = "Base Resized",
                    Duration = 4,
                    Text = v255
                })
            else
                if v251 == "CONFIRM" then
                    local v258 = math.max(0, (math.floor(tonumber(v252) or 0)))

                    p147.PendingBaseUnitSize = v246
                    p147.PendingBaseUnitDeleteCount = v258

                    local UnitSizePanel = p147.HUD.BaseCustomization:FindFirstChild("UnitSizePanel")

                    if UnitSizePanel then
                        UnitSizePanel.Warning.Text = ("Downsizing to %d unit%s will permanently delete %d object%s outside the kept area. Deleted objects will not be refunded. This cannot be undone."):format(v246, v246 == 1 and "" or "s", v258, v258 == 1 and "" or "s")
                        UnitSizePanel.Warning.Visible = true
                        UnitSizePanel.Confirm.Visible = true
                        UnitSizePanel.Cancel.Visible = true

                        if UserInputService.GamepadEnabled then
                            GuiService.SelectedObject = UnitSizePanel.Cancel
                        end
                    end
                elseif v251 == "UNIT_SIZE_2_LOCKED" then
                    p147:Noti({
                        Title = "Unit Size 2 Locked",
                        Text = "Purchase the Unit Size 2 upgrade from Builder Bob for $2,000,000.",
                        Duration = 4
                    })
                elseif v251 == "GAMEPASS" then
                    local function v260() -- line: 3302
                        -- upvalues: p147 (copy), MarketplaceService (copy)
                        MarketplaceService:PromptGamePassPurchase(p147.Player, 1952937460)
                    end

                    pcall(v260)
                    p147:Noti({
                        Title = "Gamepass Required",
                        Text = "The 3 Storage Unit Base gamepass is required for a 3-unit base.",
                        Duration = 3
                    })
                else
                    p147:Noti({
                        Title = "Resize Failed",
                        Duration = 4,
                        Text = tostring(v251 or "The neighboring units cannot be used right now.")
                    })
                end

                p147:UpdateUnitSizePanel()
            end
        end)
    end
end

function t1.GetUnclaimRemaining(p150) -- line: 3313
    local StorageBase = p150.StorageBase

    if not StorageBase then
        return 0
    end

    local UnclaimAvailableAt = StorageBase:GetAttribute("UnclaimAvailableAt")

    if typeof(UnclaimAvailableAt) ~= "number" then
        return 0
    end

    return (math.max(0, UnclaimAvailableAt - workspace:GetServerTimeNow()))
end

function t1.UpdateUnclaimButton(p151) -- line: 3321
    -- upvalues: UserInputService (copy)
    local v263 = p151.HUD and p151.HUD:FindFirstChild("BaseEdit")
    local UnclaimBase = v263 and v263:FindFirstChild("UnclaimBase")

    if not UnclaimBase then
        return
    end

    local TouchEnabled = UserInputService.TouchEnabled and UserInputService.PreferredInput == Enum.PreferredInput.Touch and p151.Data and p151.Data.BuildSystem == "Classic"
    local v264 = TouchEnabled and Color3.new(0, 0, 0)
    local v265, v266

    if v264 then
        v266 = v264
        v265 = v264
    else
        v265 = UnclaimBase:GetAttribute("CooldownColor") or Color3.fromRGB(72, 72, 72)
        v266 = UnclaimBase:GetAttribute("ReadyColor") or Color3.fromRGB(112, 38, 38)
        v264 = UnclaimBase:GetAttribute("ConfirmColor") or Color3.fromRGB(190, 55, 55)
    end

    if p151.UnclaimingStorage then
        UnclaimBase.Text = "Unclaiming..."
        UnclaimBase.BackgroundColor3 = v265
        UnclaimBase.Interactable = false
        UnclaimBase.AutoButtonColor = false
    else
        local UnclaimRemaining = p151:GetUnclaimRemaining()

        if UnclaimRemaining > 0 then
            local v267 = math.ceil(UnclaimRemaining)

            UnclaimBase.Text = ("Unclaim (%d:%02d)"):format(math.floor(v267 / 60), v267 % 60)
            UnclaimBase.BackgroundColor3 = v265
            UnclaimBase.Interactable = false
            UnclaimBase.AutoButtonColor = false
            p151.UnclaimConfirmUntil = nil
        else
            if not (p151.UnclaimConfirmUntil and os.clock() <= p151.UnclaimConfirmUntil) then
                p151.UnclaimConfirmUntil = nil
                UnclaimBase.Text = UnclaimBase:GetAttribute("DefaultText") or "Unclaim Base"
                UnclaimBase.BackgroundColor3 = v266
            else
                UnclaimBase.Text = "Confirm Unclaim?"
                UnclaimBase.BackgroundColor3 = v264
            end

            UnclaimBase.Interactable = p151.StorageBase ~= nil
            UnclaimBase.AutoButtonColor = UnclaimBase.Interactable and not TouchEnabled
        end
    end
end

function t1.RequestUnclaimStorage(p152) -- line: 3364
    -- upvalues: RemoteFunction (copy)
    if p152.UnclaimingStorage or not p152.StorageBase then
        return
    end

    if p152.ResizingBaseUnits then
        p152:Noti({
            Title = "Please Wait",
            Text = "Finish resizing your base before unclaiming it.",
            Duration = 2
        })
    else
        local UnclaimRemaining = p152:GetUnclaimRemaining()

        if UnclaimRemaining > 0 then
            local v269 = math.ceil(UnclaimRemaining)

            p152:Noti({
                Title = "Unclaim Cooldown",
                Duration = 2,
                Text = ("You can unclaim this storage in %d:%02d."):format(math.floor(v269 / 60), v269 % 60)
            })
        elseif not p152.UnclaimConfirmUntil or os.clock() > p152.UnclaimConfirmUntil then
            p152.UnclaimConfirmUntil = os.clock() + 5
            p152:UpdateUnclaimButton()
            p152:Noti({
                Title = "Unclaim Storage",
                Text = "Press the button again within 5 seconds to confirm.",
                Duration = 3
            })
        else
            p152.UnclaimConfirmUntil = nil
            p152.UnclaimingStorage = true
            p152:UpdateUnclaimButton()

            local StorageBase, StorageBaseClaim = p152.StorageBase, p152.StorageBaseClaim

            task.spawn(function() -- line: 3399
                -- upvalues: p152 (copy), StorageBase (copy), StorageBaseClaim (copy), RemoteFunction (copy)
                local function v271() -- line: 3400
                    -- upvalues: RemoteFunction (copy)
                    return RemoteFunction:InvokeServer("UnclaimStorage")
                end

                local v272, v273, v274 = pcall(v271)

                p152.UnclaimingStorage = nil

                if v272 and v273 then
                    if p152.StorageBase == StorageBase and p152.StorageBaseClaim == StorageBaseClaim then
                        p152:StorageUnclaimed(StorageBase)
                    end

                    p152:Noti({
                        Title = "Storage",
                        Text = "Storage unclaimed successfully.",
                        Duration = 3
                    })
                else
                    p152:UpdateUnclaimButton()
                    p152:Noti({
                        Title = "Unable to Unclaim",
                        Duration = 3,
                        Text = if v272 then v274 or "The storage could not be unclaimed." else "The server did not respond."
                    })
                end
            end)
        end
    end
end

function t1.StorageUnclaimed(p153, p154) -- line: 3420
    local StorageClaimRequest = p153.StorageClaimRequest

    if StorageClaimRequest and (not p154 or StorageClaimRequest.Storage == p154) then
        p153.StorageClaimRequest = nil
    end

    if p154 and (p153.StorageBase and p154 ~= p153.StorageBase or not p153.StorageBase and StorageClaimRequest and StorageClaimRequest.Storage ~= p154) then
        return
    end

    if p153.Painting then
        p153:ClosePaintFrames()
    end

    if p153.EditingBase then
        p153:StopEditStorage()
    end

    if p153.CustomizingBase then
        p153:CloseCustomizeBase()
    end

    if p153.InBaseSlots then
        p153:CloseBaseSlots()
    end

    p153:CloseDoorColorPicker()
    p153:EnableBackpack(true)
    p153:BarsVisible(true)

    if p153.ClaimCons then
        for v275, v276 in pairs(p153.ClaimCons) do
            v276:Disconnect()
            p153.ClaimCons[v275] = nil
        end
    end

    p153.Player:SetAttribute("InBase", nil)
    p153.StorageHover = nil
    p153.ObjectHover = nil

    if p153.HighlightHover then
        p153.HighlightHover.Parent = nil
    end

    p153.HUD.ClaimStorage.Visible = false
    p153.HUD.BaseEdit.Visible = false
    p153.HUD.BaseCustomization.Visible = false
    p153.HUD.BaseSlots.Visible = false
    p153.HUD.BaseObjects.Visible = false
    p153.HUD.BaseCoord.Visible = false
    p153.HUD.BaseCoord.Text = ""

    local BaseEdit = p153.HUD.BaseEdit

    BaseEdit.BaseObjects.Text = "Base Objects"
    BaseEdit.CustomizeBase.Text = "Customize"
    BaseEdit.Paint.Text = "Paint"
    BaseEdit.BaseSaveSlots.Text = "Save Slots"
    p153.StorageBase = nil
    p153.StorageBaseClaim = nil
    p153.UnclaimingStorage = nil
    p153.UnclaimConfirmUntil = nil
    p153.ResizingBaseUnits = nil
    p153.PendingBaseUnitSize = nil
    p153.PendingBaseUnitDeleteCount = nil
    p153:UpdateUnclaimButton()
end

function t1.StorageClaimed(p155, p156) -- line: 3471
    -- upvalues: RunService (copy), UserInputService (copy)
    if typeof(p156) ~= "Instance" then
        return
    end

    local t14 = {
        Storage = p156
    }

    p155.StorageClaimRequest = t14

    local v277 = p156:FindFirstChild("Contents") or p156:WaitForChild("Contents", 5)

    if p155.StorageClaimRequest == t14 then
        local v278 = v277 and (v277:FindFirstChild("Objects") or v277:WaitForChild("Objects", 5))

        if p155.StorageClaimRequest == t14 then
            if v277 and v278 and v277.Parent == p156 and v278.Parent == v277 then
                local v279 = os.clock() + 5

                while p155.StorageClaimRequest == t14 and p156.Parent and p156:GetAttribute("Owner") == nil and os.clock() < v279 do
                    task.wait(0.05)
                end

                if p155.StorageClaimRequest == t14 then
                    p155.StorageClaimRequest = nil

                    if p156.Parent and p156:GetAttribute("Owner") == p155.Player.Name and v277.Parent == p156 and v278.Parent == v277 then
                        p155.StorageBase = p156
                        p155.StorageBaseClaim = t14
                        p155.SearchText = ""
                        p155.CurrentBaseObjects = "Furniture"
                        p155.CurrentSubCategory = "All"
                        p155.UnclaimingStorage = nil
                        p155.UnclaimConfirmUntil = nil
                        p155.ResizingBaseUnits = nil
                        p155.PendingBaseUnitSize = nil
                        p155.PendingBaseUnitDeleteCount = nil

                        if p155.ClaimCons then
                            for v280, v281 in pairs(p155.ClaimCons) do
                                v281:Disconnect()
                                p155.ClaimCons[v280] = nil
                            end
                        else
                            p155.ClaimCons = {}
                        end

                        if not p155.BaseEditWired then
                            p155.BaseEditWired = true

                            local BaseEdit = p155.HUD.BaseEdit
                            local CollapseButton = p155.HUD.BaseObjects:FindFirstChild("CollapseButton")

                            if CollapseButton then
                                CollapseButton.Activated:Connect(function() -- line: 3520
                                    -- upvalues: p155 (copy)
                                    if p155.EditingBase then
                                        p155:SetBaseObjectsCollapsed(not p155.BaseObjectsCollapsed)
                                    end
                                end)
                            end

                            local function horizontalScrollTarget(p157) -- line: 3527
                                -- upvalues: p155 (copy)
                                local v282 = p155.Player and p155.Player:FindFirstChildOfClass("PlayerGui")

                                if v282 then
                                    local function v283() -- line: 3530
                                        -- upvalues: p157 (copy), v282 (copy)
                                        return v282:GetGuiObjectsAtPosition(math.floor(p157.X), (math.floor(p157.Y)))
                                    end

                                    local ok, result = pcall(v283)

                                    if ok then
                                        for _, v285 in ipairs(result) do
                                            local v286 = v285

                                            while v286 and v286 ~= v282 do
                                                if v286:IsA("ScrollingFrame") and v286.Visible and v286.ScrollingEnabled and v286.ScrollingDirection == Enum.ScrollingDirection.X then
                                                    return v286
                                                end

                                                v286 = v286.Parent
                                            end
                                        end
                                    end
                                end

                                return nil
                            end

                            UserInputService.InputChanged:Connect(function(p158) -- line: 3554
                                -- upvalues: horizontalScrollTarget (copy), UserInputService (copy)
                                if p158.UserInputType ~= Enum.UserInputType.MouseWheel then
                                    return
                                end

                                local v287 = horizontalScrollTarget(UserInputService:GetMouseLocation())

                                if v287 then
                                    local v288 = v287.AbsoluteCanvasSize.X - v287.AbsoluteWindowSize.X

                                    if not (v288 <= 0) then
                                        local v290 = math.max(v287.AbsoluteWindowSize.X * 0.2, 60)

                                        v287.CanvasPosition = Vector2.new(math.clamp(v287.CanvasPosition.X - p158.Position.Z * v290, 0, v288), v287.CanvasPosition.Y)
                                    end
                                end
                            end)

                            local function closeAllFrames() -- line: 3567
                                -- upvalues: p155 (copy)
                                if p155.EditingBase then
                                    p155:StopEditStorage()
                                elseif p155.CustomizingBase then
                                    p155:CloseCustomizeBase()
                                elseif p155.InBaseSlots then
                                    p155:CloseBaseSlots()
                                elseif p155.Painting then
                                    p155:ClosePaintFrames()
                                end
                            end

                            BaseEdit.BaseObjects.Activated:Connect(function() -- line: 3579
                                -- upvalues: p155 (copy)
                                if p155.EditingBase then
                                    p155:StopEditStorage()
                                else
                                    if p155.EditingBase then
                                        p155:StopEditStorage()
                                    elseif p155.CustomizingBase then
                                        p155:CloseCustomizeBase()
                                    elseif p155.InBaseSlots then
                                        p155:CloseBaseSlots()
                                    elseif p155.Painting then
                                        p155:ClosePaintFrames()
                                    end

                                    p155:EditStorage()
                                end
                            end)
                            BaseEdit.CustomizeBase.Activated:Connect(function() -- line: 3588
                                -- upvalues: p155 (copy)
                                if p155.CustomizingBase then
                                    p155:CloseCustomizeBase()
                                else
                                    if p155.EditingBase then
                                        p155:StopEditStorage()
                                    elseif p155.CustomizingBase then
                                        p155:CloseCustomizeBase()
                                    elseif p155.InBaseSlots then
                                        p155:CloseBaseSlots()
                                    elseif p155.Painting then
                                        p155:ClosePaintFrames()
                                    end

                                    p155:OpenCustomizeBase()
                                end
                            end)
                            BaseEdit.BaseSaveSlots.Activated:Connect(function() -- line: 3597
                                -- upvalues: p155 (copy)
                                if p155.InBaseSlots then
                                    p155:CloseBaseSlots()
                                else
                                    if p155.EditingBase then
                                        p155:StopEditStorage()
                                    elseif p155.CustomizingBase then
                                        p155:CloseCustomizeBase()
                                    elseif p155.InBaseSlots then
                                        p155:CloseBaseSlots()
                                    elseif p155.Painting then
                                        p155:ClosePaintFrames()
                                    end

                                    p155:OpenBaseSlots()
                                end
                            end)
                            BaseEdit.Paint.Activated:Connect(function() -- line: 3606
                                -- upvalues: p155 (copy)
                                if p155.Painting then
                                    p155:ClosePaintFrames()
                                else
                                    if not p155.EditingBase then
                                        if p155.EditingBase then
                                            p155:StopEditStorage()
                                        elseif p155.CustomizingBase then
                                            p155:CloseCustomizeBase()
                                        elseif p155.InBaseSlots then
                                            p155:CloseBaseSlots()
                                        elseif p155.Painting then
                                            p155:ClosePaintFrames()
                                        end
                                    end

                                    p155:OpenPaintFrames()
                                end
                            end)

                            local UnclaimBase = BaseEdit:FindFirstChild("UnclaimBase")

                            if UnclaimBase then
                                UnclaimBase.Activated:Connect(function() -- line: 3617
                                    -- upvalues: p155 (copy)
                                    p155:RequestUnclaimStorage()
                                end)
                            end
                        end

                        p155.HUD.BaseCoord.Text = "Base: " .. math.floor(p156.Floor.Position.X) .. ", " .. math.floor(p156.Floor.Position.Z)
                        p155.HUD.BaseCoord.Visible = true
                        table.insert(p155.ClaimCons, p156:GetAttributeChangedSignal("Owner"):Connect(function() -- line: 3626
                            -- upvalues: p155 (copy), p156 (copy)
                            if p155.StorageBase == p156 and p156:GetAttribute("Owner") ~= p155.Player.Name then
                                p155:StorageUnclaimed(p156)
                            end
                        end))
                        table.insert(p155.ClaimCons, v278.ChildAdded:Connect(function() -- line: 3631
                            -- upvalues: p155 (copy)
                            p155:UpdateStorageCapacity()
                        end))
                        table.insert(p155.ClaimCons, v278.ChildRemoved:Connect(function() -- line: 3634
                            -- upvalues: p155 (copy)
                            p155:UpdateStorageCapacity()
                        end))
                        table.insert(p155.ClaimCons, p156:GetAttributeChangedSignal("BaseUnitSize"):Connect(function() -- line: 3637
                            -- upvalues: p155 (copy)
                            p155:UpdateStorageCapacity()
                        end))

                        local n9 = 0

                        table.insert(p155.ClaimCons, RunService.Heartbeat:Connect(function() -- line: 3641
                            -- upvalues: p155 (copy), n9 (ref)
                            if not (os.clock() >= n9) then
                                return
                            end

                            n9 = os.clock() + 0.25
                            p155:UpdateUnclaimButton()

                            local UnitSizePanel = p155.HUD.BaseCustomization:FindFirstChild("UnitSizePanel")

                            if UnitSizePanel and UnitSizePanel.Visible then
                                p155:UpdateUnitSizePanel()
                            end
                        end))
                        p155:UpdateUnclaimButton()
                        p155:UpdateUnitSizePanel()
                        p155:UpdateStorageCapacity()
                    end
                end
            else
                p155.StorageClaimRequest = nil
                warn("[Storage] Claimed storage contents did not replicate in time.")
            end
        end
    end
end

function t1.GetStorageCapacityLimit(p159) -- line: 3656
    -- upvalues: BaseCapacityLib (copy), GamepassLib (copy)
    local v298 = p159.Data or {}
    local v299 = tonumber(v298.BaseUnitSize) or 1

    if p159.StorageBase then
        v299 = tonumber(p159.StorageBase:GetAttribute("BaseUnitSize")) or v299
    end

    local BaseBasement = v298.BaseBasement
    local v300 = typeof(BaseBasement) == "string" and BaseBasement ~= "" or p159.StorageBase and p159.StorageBase:FindFirstChild("Basement") ~= nil
    local v301 = v298.StorageCapacitySplitMigrated ~= true and v298.ExtraStorageCap == true

    return (BaseCapacityLib.GetLimit(v299, v300, v298.ExtraStorageGamepass == true or GamepassLib.HasGrant(v298.GamepassGrants, 230541266), v298.ExtraStorageUpgrade == true, v301))
end

function t1.UpdateStorageCapacity(p160) -- line: 3678
    local StorageCapacityLimit = p160:GetStorageCapacityLimit()
    local v302 = "Capacity: " .. tostring((p160:GetStorageCapacity())) .. "/" .. tostring(StorageCapacityLimit)
    local BuildGui = p160.BuildGui

    if not (BuildGui and BuildGui.Parent) then
        BuildGui = p160.Player.PlayerGui:FindFirstChild("BuildModeGui")
    end

    BuildGui = BuildGui and BuildGui:FindFirstChild("Toolbar") and BuildGui.Toolbar:FindFirstChild("Buttons")

    local Capacity = BuildGui and BuildGui:FindFirstChild("Capacity")

    if Capacity then
        Capacity.Text = v302
    end
end

function t1.StopEditStorage(p161) -- line: 3693
    -- upvalues: RunService (copy), ContextActionService (copy), PaintController (copy)
    if p161.Painting then
        PaintController.Close(p161)
    end

    local BaseEdit = p161.HUD.BaseEdit

    p161.CurrentFrame = nil
    p161.EditingBase = nil
    p161:EndBuildMode()
    p161:ClearBaseObjects()
    p161:ClearEditCons()
    p161:DeleteEditObject()
    p161:EnableBackpack(true)
    p161:BarsVisible(true)
    p161.ObjectHover = nil
    p161.HighlightHover.Parent = nil
    p161.DeletingObjects = false
    p161.HUD.MobileMouse.Visible = false
    p161.HUD.MobileEdits.Visible = false

    if p161.BuildMobileButtonVisibility then
        for v303, v304 in pairs(p161.BuildMobileButtonVisibility) do
            if v303 and v303.Parent then
                v303.Visible = v304
            end
        end

        p161.BuildMobileButtonVisibility = nil
    end

    for _, v305 in ipairs({ "rotate", "flip", "flip2", "place", "delete", "deleteMode", "deselect" }) do
        ContextActionService:UnbindAction(v305)
    end

    RunService:UnbindFromRenderStep("UpdateSearch")
    BaseEdit.BaseObjects.Text = "Edit Base"
    p161.HUD.BaseObjects.Visible = false
    p161.HUD.BaseObjects.Hotkeys.Visible = false
end

function t1.SetBaseObjectsCollapsed(p162, p163, p164) -- line: 3728
    local v306 = p162.HUD and p162.HUD:FindFirstChild("BaseObjects")
    local v307, v308, v309

    if v306 then
        v307 = v306:FindFirstChild("CollapseButton")

        if v307 then
            v308 = p163 == true
            v309 = false
        else
            v309 = true
        end
    else
        v307 = v306
        v309 = true
    end

    if v309 or not p164 and p162.BaseObjectsCollapsed == v308 then
        return
    end

    p162.BaseObjectsCollapsed = v308

    if v308 then
        local Search = v306:FindFirstChild("Search")

        if Search and Search:IsA("TextBox") then
            Search:ReleaseFocus()
        end

        local BaseObjectsExpandedState = p162.BaseObjectsExpandedState

        if not BaseObjectsExpandedState then
            BaseObjectsExpandedState = {
                GuiVisibility = {},
                BackgroundTransparency = v306.BackgroundTransparency,
                ImageTransparency = v306.ImageTransparency
            }

            for _, child in ipairs(v306:GetChildren()) do
                if child ~= v307 and child:IsA("GuiObject") then
                    BaseObjectsExpandedState.GuiVisibility[child] = child.Visible
                end
            end

            p162.BaseObjectsExpandedState = BaseObjectsExpandedState
        end

        for v310 in pairs(BaseObjectsExpandedState.GuiVisibility) do
            if v310 and v310.Parent == v306 then
                v310.Visible = false
            end
        end

        v306.BackgroundTransparency = 1
        v306.ImageTransparency = 1
        v307.Text = "Show Objects ▲"
        v307.Position = UDim2.new(0.5, 0, 1, -18)
    else
        local BaseObjectsExpandedState = p162.BaseObjectsExpandedState

        if BaseObjectsExpandedState then
            for v311, v312 in pairs(BaseObjectsExpandedState.GuiVisibility) do
                if v311 and v311.Parent == v306 then
                    v311.Visible = v312
                end
            end

            v306.BackgroundTransparency = BaseObjectsExpandedState.BackgroundTransparency
            v306.ImageTransparency = BaseObjectsExpandedState.ImageTransparency
            p162.BaseObjectsExpandedState = nil
        end

        v307.Text = "Hide Objects ▼"
        v307.Position = UDim2.new(0.65, 0, -0.125, 0)
    end

    v307.Visible = true
    v307.Selectable = true
end

Color3.fromRGB(42, 170, 255)

function t1.SetBaseObjectFrameSelected(p165, p166, p167) -- line: 3780
    -- upvalues: BaseObjectsLib (copy)
    if not (p166 and p166.Parent) then
        return
    end

    if p166:GetAttribute("BuildDefaultBackgroundColor") == nil then
        p166:SetAttribute("BuildDefaultBackgroundColor", p166.BackgroundColor3)
    end

    if p166:GetAttribute("BuildDefaultBorderSize") == nil then
        p166:SetAttribute("BuildDefaultBorderSize", p166.BorderSizePixel)
    end

    p166.BorderColor3 = Color3.new(1, 1, 1)

    if p167 then
        p166.BorderSizePixel = 3
        p166.BackgroundColor3 = Color3.new(0, 0, 0)
        p166.Price.Text = "Deselect"
        p166.Price.TextColor3 = Color3.fromRGB(255, 139, 139)
    else
        p166.BorderSizePixel = p166:GetAttribute("BuildDefaultBorderSize")

        local BuildDefaultBackgroundColor = p166:GetAttribute("BuildDefaultBackgroundColor")

        if typeof(BuildDefaultBackgroundColor) == "Color3" then
            p166.BackgroundColor3 = BuildDefaultBackgroundColor
        end

        local v313 = BaseObjectsLib[p166.Name]

        if v313 then
            p166.Price.Text = "$" .. v313.Price

            if v313.ItemObject then
                local Data = p165.Data

                if Data then
                    Data = p165.Data.BaseItems

                    if Data then
                        Data = p165.Data.BaseItems[p166.Name]
                        p166.Price.Text = Data and "x" .. Data or "NONE"
                    else
                        p166.Price.Text = "NONE"
                    end
                else
                    p166.Price.Text = "NONE"
                end
            end

            p166.Price.TextColor3 = Color3.fromRGB(172, 255, 149)
        end
    end
end

function t1.SetCurrentBaseObjectFrame(p168, p169) -- line: 3813
    if p168.CurrentFrame and p168.CurrentFrame ~= p169 then
        p168:SetBaseObjectFrameSelected(p168.CurrentFrame, false)
    end

    p168.CurrentFrame = p169

    if p169 then
        p168:SetBaseObjectFrameSelected(p169, true)
    end
end

function t1.ClearBaseObjects(p170) -- line: 3823
    local List = p170.HUD.BaseObjects.List

    for _, child in pairs(List:GetChildren()) do
        if child:IsA("ViewportFrame") and child.Name ~= "Sample" then
            child:Destroy()
        end
    end
end

function t1.IsDesktopBuildCatalogue(p171) -- line: 3835
    -- upvalues: UserInputService (copy)
    if p171.EditingBase ~= true or UserInputService.PreferredInput ~= Enum.PreferredInput.KeyboardAndMouse then
        return false
    end

    return not (p171.ClassicMobile and p171.ClassicMobile:IsActive()) and not (p171.ModernMobile and p171.ModernMobile:IsActive()) and not (p171.ClassicController and p171.ClassicController:IsGamepad()) and not (p171.ModernController and p171.ModernController:IsGamepad())
end

function t1.IsModernDesktopCatalogue(p172) -- line: 3843
    return p172:IsDesktopBuildCatalogue()
end

function t1.SelectDesktopCatalogueObject(p173, p174) -- line: 3848
    -- upvalues: GuiService (copy), BaseObjectsLib (copy), Preferences (copy)
    local DesktopCatalogue = p173.DesktopCatalogue

    if not DesktopCatalogue
        or not DesktopCatalogue.Active
        or not p173:IsDesktopBuildCatalogue()
        or not p173.BuildCameraActive
        or p173.BuildModeKind ~= "Objects"
        or p173.Painting
        or p173.DeleteAllConfirmOpen
        or p173.PaintResetConfirmOpen
        or GuiService.MenuIsOpen
        or p173.BuildSystemSwitching then
        return false
    end

    local v314 = BaseObjectsLib[p174]

    if not (v314 and Preferences.IsValidName(p174)) or v314.Unlock and not (p173.Data.UnlockedObjects or {})[p174] then
        return false
    end

    if p173.EditObject and not p173.EditingExistingObject and p173.EditObject.Name == p174 then
        p173:DeleteEditObject()
    else
        p173:SelectEditObject(p174, v314.Type)
    end

    DesktopCatalogue:RefreshSelection()

    return true
end

function t1.RefreshDesktopBuildCatalogue(p175) -- line: 3866
    -- upvalues: UserInputService (copy), GuiService (copy), ModernBuild (copy)
    local v315 = p175:IsDesktopBuildCatalogue() and p175.BuildCameraActive == true and p175.BuildModeKind == "Objects" and not p175.Painting and not p175.DeleteAllConfirmOpen and not p175.PaintResetConfirmOpen and not p175.BuildSystemSwitching and not GuiService.MenuIsOpen
    local DesktopCatalogue, v316

    if v315 and not p175.DesktopCatalogue then
        p175:HydrateModernBuildPreferences()
        p175.DesktopCatalogue = ModernBuild.Catalogue.Desktop.new(p175, {
            Select = function(p176) -- Select | line: 3874
                -- upvalues: p175 (copy)
                p175:SelectDesktopCatalogueObject(p176)
            end,
            Favorite = function(p177) -- Favorite | line: 3875
                -- upvalues: p175 (copy), GuiService (copy)
                if p175.DesktopCatalogue and p175.DesktopCatalogue.Active and not p175.DeleteAllConfirmOpen and not p175.PaintResetConfirmOpen and not p175.BuildSystemSwitching and not GuiService.MenuIsOpen then
                    p175:ToggleModernDesktopFavorite(p177)
                end
            end,
            Collapsed = function(p178) -- Collapsed | line: 3882
                -- upvalues: p175 (copy)
                p175.BaseObjectsCollapsed = p178
            end,
            ClassicRotateStep = function() -- ClassicRotateStep | line: 3883
                -- upvalues: p175 (copy)
                p175:CycleClassicDesktopRotateStep()
            end,
            ClassicPaint = function() -- ClassicPaint | line: 3884
                -- upvalues: p175 (copy)
                p175:ToggleClassicDesktopPaint()
            end
        })
        DesktopCatalogue = p175.DesktopCatalogue
        v316 = p175.BaseObjectsCollapsed == true
        DesktopCatalogue:SetCollapsed(v316)
        p175.DesktopCatalogueCons = {}

        local function connect(p179, p180) -- line: 3888
            -- upvalues: p175 (copy)
            table.insert(p175.DesktopCatalogueCons, p179:Connect(p180))
        end

        local PreferredInput = UserInputService:GetPropertyChangedSignal("PreferredInput")

        local function v317() -- line: 3891
            -- upvalues: p175 (copy)
            task.defer(function() -- line: 3893
                -- upvalues: p175 (copy)
                if p175.DesktopCatalogue then
                    p175:RefreshDesktopBuildCatalogue()
                end
            end)
        end

        table.insert(p175.DesktopCatalogueCons, PreferredInput:Connect(v317))

        local MenuOpened = GuiService.MenuOpened

        local function v318() -- line: 3897
            -- upvalues: p175 (copy)
            p175:RefreshDesktopBuildCatalogue()
        end

        table.insert(p175.DesktopCatalogueCons, MenuOpened:Connect(v318))

        local MenuClosed = GuiService.MenuClosed

        local function v319() -- line: 3898
            -- upvalues: p175 (copy)
            p175:RefreshDesktopBuildCatalogue()
        end

        table.insert(p175.DesktopCatalogueCons, MenuClosed:Connect(v319))

        local CharacterRemoving = p175.Player.CharacterRemoving

        local function v320() -- line: 3899
            -- upvalues: p175 (copy)
            p175:DestroyDesktopBuildCatalogue()
        end

        table.insert(p175.DesktopCatalogueCons, CharacterRemoving:Connect(v320))
    end

    local DesktopCatalogue2 = p175.DesktopCatalogue

    if DesktopCatalogue2 then
        DesktopCatalogue2:SetActive(v315 == true)

        if v315 then
            p175.HUD.BaseObjects.Visible = false
            DesktopCatalogue2:RefreshSelection()
        end
    end
end

function t1.DestroyDesktopBuildCatalogue(p181) -- line: 3911
    local DesktopCatalogue = p181.DesktopCatalogue

    p181.DesktopCatalogue = nil

    if DesktopCatalogue then
        DesktopCatalogue:Destroy()
    end

    for _, v321 in ipairs(p181.DesktopCatalogueCons or {}) do
        v321:Disconnect()
    end

    p181.DesktopCatalogueCons = nil
end

function t1.HydrateModernBuildPreferences(p182) -- line: 3919
    -- upvalues: Preferences (copy)
    p182.Data = p182.Data or {}
    p182.ModernBuildFavorites = Preferences.Favorites(p182.ModernBuildFavorites or p182.Data.ModernBuildFavorites)
    p182.ModernBuildRecents = Preferences.Recents(p182.ModernBuildRecents or p182.Data.ModernBuildRecents)
    p182.Data.ModernBuildFavorites = table.clone(p182.ModernBuildFavorites)
    p182.Data.ModernBuildRecents = table.clone(p182.ModernBuildRecents)
end

function t1.RefreshModernDesktopCataloguePreferences(p183) -- line: 3927
    if p183:IsModernDesktopCatalogue() then
        if p183.DesktopCatalogue then
            p183.DesktopCatalogue:Refresh()
        else
            local v322 = p183.HUD and p183.HUD:FindFirstChild("BaseObjects")
            local List = v322 and v322:FindFirstChild("List")

            if List then
                local t16 = {}

                for v323, v324 in ipairs(p183.ModernBuildRecents or {}) do
                    t16[v324] = v323
                end

                for _, child in ipairs(List:GetChildren()) do
                    if child:IsA("ViewportFrame") and child.Name ~= "Sample" then
                        local ModernFavorite = child:FindFirstChild("ModernFavorite")

                        if ModernFavorite then
                            local v325 = p183.ModernBuildFavorites and p183.ModernBuildFavorites[child.Name] == true

                            ModernFavorite.Text = v325 and "★" or "☆"
                            ModernFavorite.TextColor3 = v325 and Color3.fromRGB(255, 226, 137) or Color3.new(1, 1, 1)

                            if p183.CurrentSubCategory == "Favorites" then
                                child.Visible = v325
                            end
                        end

                        if p183.CurrentSubCategory == "Recent" then
                            child.Visible = t16[child.Name] ~= nil
                            child.LayoutOrder = t16[child.Name] or 999
                        end
                    end
                end
            end
        end
    end
end

function t1.ToggleModernDesktopFavorite(p184, p185) -- line: 3952
    -- upvalues: Preferences (copy), RemoteEvent (copy)
    if not (p184:IsModernDesktopCatalogue() and Preferences.IsValidName(p185)) then
        return
    end

    p184:HydrateModernBuildPreferences()

    local v326 = table.clone(p184.ModernBuildFavorites)
    local v327 = v326[p185] ~= true

    if v327 then
        v326[p185] = true
    else
        v326[p185] = nil
    end

    local Data = p184.Data
    local v328 = table.clone(v326)

    p184.ModernBuildFavorites = v326
    Data.ModernBuildFavorites = v328
    RemoteEvent:FireServer("ChangeModernBuildFavorite", p185, v327)
    p184:RefreshModernDesktopCataloguePreferences()
end

function t1.RememberModernDesktopObject(p186, p187) -- line: 3964
    -- upvalues: Preferences (copy), RemoteEvent (copy)
    if not p186:IsModernDesktopCatalogue() or not Preferences.IsValidName(p187) then
        return
    end

    p186:HydrateModernBuildPreferences()

    if p186.ModernBuildRecents[1] ~= p187 then
        local v329 = table.clone(p186.ModernBuildRecents)
        local v330 = table.find(v329, p187)

        if v330 then
            table.remove(v329, v330)
        end

        table.insert(v329, 1, p187)

        while #v329 > Preferences.MAX_RECENTS do
            table.remove(v329)
        end

        local Data = p186.Data
        local v331 = table.clone(v329)

        p186.ModernBuildRecents = v329
        Data.ModernBuildRecents = v331
        RemoteEvent:FireServer("RememberModernBuildObject", p187)

        local v332 = p186.HUD and p186.HUD:FindFirstChild("BaseObjects")
        local List = v332 and v332:FindFirstChild("List")

        if p186.CurrentSubCategory == "Recent" and List and not List:FindFirstChild(p187) then
            p186:UpdateBaseObjects(p186.CurrentBaseObjects, true)
        else
            p186:RefreshModernDesktopCataloguePreferences()
        end
    end
end

function t1.UpdateSubCategories(p188, p189) -- line: 3984
    -- upvalues: BaseObjectsLib (copy)
    if p188:IsDesktopBuildCatalogue() then
        return
    end

    local SubTypes, List = p188.HUD.BaseObjects.SubTypes, p188.HUD.BaseObjects.List
    local v333 = p188:IsModernDesktopCatalogue()

    if v333 then
        p188:HydrateModernBuildPreferences()
    end

    local Y = workspace.CurrentCamera.ViewportSize.Y
    local v334, v335, v336

    if p188.TouchEnabled then
        v334 = 0.38
        v335 = math.clamp(math.round(Y * 0.04), 22, 42)
        v336 = 14
    else
        v334 = 0.24
        v335 = math.clamp(math.round(Y * 0.022), 16, 28)
        v336 = 8
    end

    SubTypes.Size = UDim2.new(1, 0, v334, 0)
    List.Position = UDim2.new(0, 0, v334 + 0.02, 0)
    List.Size = UDim2.new(1, 0, 0.98 - v334, 0)

    for _, child in pairs(SubTypes:GetChildren()) do
        if child:IsA("TextButton") and child.Name ~= "Sample" then
            child:Destroy()
        end
    end

    local t17 = {
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
    local t18 = {}
    local t19 = {}

    for _, v341 in pairs(BaseObjectsLib) do
        if v341.Type == p189 and v341.SubCategory and not t18[v341.SubCategory] then
            t18[v341.SubCategory] = true
            table.insert(t19, v341.SubCategory)
        end
    end

    table.sort(t19, function(p190, p191) -- line: 4027
        -- upvalues: t17 (copy)
        return (t17[p190] or 999) < (t17[p191] or 999)
    end)
    table.insert(t19, 1, "All")

    if v333 then
        table.insert(t19, 1, "Favorites")
        table.insert(t19, 1, "Recent")
    end

    for v342, v343 in ipairs(t19) do
        local clone = SubTypes.Sample:Clone()

        clone.Name = v343
        clone.Text = v343
        clone.LayoutOrder = v342
        clone.Visible = true
        clone.TextSize = v335

        if v333 then
            clone.Font = Enum.Font.Code
            clone.BackgroundColor3 = Color3.new(0, 0, 0)
            clone.BackgroundTransparency = 0.5
            clone.BorderColor3 = Color3.new(1, 1, 1)
            clone.BorderSizePixel = 1
        end

        clone.UIPadding.PaddingLeft = UDim.new(0, v336)
        clone.UIPadding.PaddingRight = UDim.new(0, v336)

        if v343 == p188.CurrentSubCategory then
            clone.TextColor3 = Color3.fromRGB(172, 255, 149)
        else
            clone.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        clone.Parent = SubTypes
        p188.EditCons["SubCat" .. v343] = clone.MouseButton1Click:Connect(function() -- line: 4059
            -- upvalues: p188 (copy), SubTypes (copy), v343 (copy)
            p188.CurrentSubCategory = v343

            for _, child in pairs(SubTypes:GetChildren()) do
                if child:IsA("TextButton") and child.Name ~= "Sample" then
                    if child.Name == v343 then
                        child.TextColor3 = Color3.fromRGB(172, 255, 149)
                    else
                        child.TextColor3 = Color3.fromRGB(255, 255, 255)
                    end
                end
            end

            p188:UpdateBaseObjects(p188.CurrentBaseObjects)
        end)
    end
end

function t1.UpdateBaseObjects(p192, p193, p194) -- line: 4075
    -- upvalues: BaseObjectsLib (copy), Preferences (copy), createViewportBaseObjects (copy)
    if p192:IsDesktopBuildCatalogue() then
        p192:HydrateModernBuildPreferences()

        if p192.DesktopCatalogue then
            p192.DesktopCatalogue:Refresh()
        end
    elseif p192.ModernMobile and p192.ModernMobile:IsActive() then
        if p192.ModernMobile.UI.MenuOpen then
            p192.ModernMobile.UI:RefreshCatalogue()
        end

        p192.ModernMobile:RefreshPresentation()
    elseif p192.ClassicMobile and p192.ClassicMobile:IsActive() then
        if p192.ClassicMobile.UI.MenuOpen then
            p192.ClassicMobile.UI:RefreshCatalogue()
        end

        p192.ClassicMobile:RefreshPresentation()
    else
        local v344 = p192:IsModernDesktopCatalogue()
        local v345, v346

        if v344 then
            p192:HydrateModernBuildPreferences()
            v346 = p192.CurrentBaseObjects or p193
            v345 = p192.CurrentSubCategory == "Favorites" or p192.CurrentSubCategory == "Recent"
        else
            v345 = v344
            v346 = p193
        end

        local t20 = {}

        if v344 then
            for v347, v348 in ipairs(p192.ModernBuildRecents) do
                t20[v348] = v347
            end
        end

        local List = p192.HUD.BaseObjects.List
        local Sample = List.Sample
        local UIGridLayout = List:FindFirstChildOfClass("UIGridLayout")

        if p192.TouchEnabled then
            if UIGridLayout then
                UIGridLayout.CellSize = UDim2.new(0.2, 0, 1, 0)
            end

            Sample.ObjectName.Size = UDim2.new(1, 0, 0.34, 0)
            Sample.Price.Size = UDim2.new(1, 0, 0.24, 0)
            Sample.Price.Position = UDim2.new(0, 0, 0.76, 0)
        else
            if UIGridLayout then
                UIGridLayout.CellSize = UDim2.new(0.1, 0, 1, 0)
            end

            Sample.ObjectName.Size = UDim2.new(1, 0, 0.2, 0)
            Sample.Price.Size = UDim2.new(1, 0, 0.2, 0)
            Sample.Price.Position = UDim2.new(0, 0, 0.8, 0)
        end

        local v349 = p194 == true or v344

        if v349 then
            v349 = p192.EditObject and not p192.EditingExistingObject and p192.EditObject.Name
        else
            p192:DeleteEditObject()
        end

        p192:ClearBaseObjects()
        p192.CurrentFrame = nil

        for v350, v351 in pairs(BaseObjectsLib) do
            if v345 then
                if Preferences.IsValidName(v350) then
                    if p192.CurrentSubCategory == "Favorites" then
                        if p192.ModernBuildFavorites[v350] then
                            if p192.CurrentSubCategory == "Recent" then
                                if t20[v350] then
                                    local v352 = string.lower(p192.SearchText or "")

                                    if v352 == "" or string.find(string.lower(v350), v352, 1, true) then
                                        if v351.Unlock then
                                            if p192.Data.UnlockedObjects[v350] then
                                                local clone = List.Sample:Clone()

                                                clone.Name = v350
                                                clone.Price.Text = "$" .. v351.Price
                                                clone.ObjectName.Text = v350
                                                clone.Visible = true
                                                clone.LayoutOrder = p192.CurrentSubCategory == "Recent" and t20[v350] or v351.Price
                                                createViewportBaseObjects(clone, v350, v351.Type)
                                                clone.Parent = List

                                                if v351.ItemObject then
                                                    if p192.Data.BaseItems[v350] then
                                                        clone.Price.Text = "x" .. p192.Data.BaseItems[v350]
                                                    else
                                                        clone.Price.Text = "NONE"
                                                    end
                                                end

                                                if v344 then
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
                                                    TextButton.Text = p192.ModernBuildFavorites[v350] and "★" or "☆"
                                                    TextButton.TextColor3 = p192.ModernBuildFavorites[v350] and Color3.fromRGB(255, 226, 137) or Color3.new(1, 1, 1)
                                                    TextButton.ZIndex = math.max(clone.ZIndex, clone.Select.ZIndex, clone.ObjectName.ZIndex) + 2
                                                    TextButton.Active = true
                                                    TextButton.Selectable = false
                                                    TextButton.Parent = clone
                                                    TextButton.Activated:Connect(function() -- line: 4174
                                                        -- upvalues: p192 (copy), v350 (copy)
                                                        p192:ToggleModernDesktopFavorite(v350)
                                                    end)
                                                end

                                                if v349 == v350 then
                                                    p192:SetCurrentBaseObjectFrame(clone)
                                                end

                                                clone.Select.MouseButton1Click:Connect(function() -- line: 4178
                                                    -- upvalues: p192 (copy), clone (copy), v350 (copy), v351 (copy)
                                                    if p192.EditObject and not p192.EditingExistingObject and p192.CurrentFrame == clone then
                                                        p192:DeleteEditObject()
                                                    else
                                                        p192:SelectEditObject(v350, v351.Type)

                                                        if p192.EditObject and not p192.EditingExistingObject then
                                                            p192:SetCurrentBaseObjectFrame(clone)
                                                        end
                                                    end
                                                end)
                                            end
                                        else
                                            local clone = List.Sample:Clone()

                                            clone.Name = v350
                                            clone.Price.Text = "$" .. v351.Price
                                            clone.ObjectName.Text = v350
                                            clone.Visible = true
                                            clone.LayoutOrder = p192.CurrentSubCategory == "Recent" and t20[v350] or v351.Price
                                            createViewportBaseObjects(clone, v350, v351.Type)
                                            clone.Parent = List

                                            if v351.ItemObject then
                                                if p192.Data.BaseItems[v350] then
                                                    clone.Price.Text = "x" .. p192.Data.BaseItems[v350]
                                                else
                                                    clone.Price.Text = "NONE"
                                                end
                                            end

                                            if v344 then
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
                                                TextButton.Text = p192.ModernBuildFavorites[v350] and "★" or "☆"
                                                TextButton.TextColor3 = p192.ModernBuildFavorites[v350] and Color3.fromRGB(255, 226, 137) or Color3.new(1, 1, 1)
                                                TextButton.ZIndex = math.max(clone.ZIndex, clone.Select.ZIndex, clone.ObjectName.ZIndex) + 2
                                                TextButton.Active = true
                                                TextButton.Selectable = false
                                                TextButton.Parent = clone
                                                TextButton.Activated:Connect(function() -- line: 4174
                                                    -- upvalues: p192 (copy), v350 (copy)
                                                    p192:ToggleModernDesktopFavorite(v350)
                                                end)
                                            end

                                            if v349 == v350 then
                                                p192:SetCurrentBaseObjectFrame(clone)
                                            end

                                            clone.Select.MouseButton1Click:Connect(function() -- line: 4178
                                                -- upvalues: p192 (copy), v350 (copy), v351 (copy), clone (copy)
                                                if p192.EditObject and not p192.EditingExistingObject and p192.CurrentFrame == clone then
                                                    p192:DeleteEditObject()
                                                else
                                                    p192:SelectEditObject(v350, v351.Type)

                                                    if p192.EditObject and not p192.EditingExistingObject then
                                                        p192:SetCurrentBaseObjectFrame(clone)
                                                    end
                                                end
                                            end)
                                        end
                                    end
                                end
                            else
                                local v353 = string.lower(p192.SearchText or "")

                                if v353 == "" or string.find(string.lower(v350), v353, 1, true) then
                                    if v351.Unlock then
                                        if p192.Data.UnlockedObjects[v350] then
                                            local clone = List.Sample:Clone()

                                            clone.Name = v350
                                            clone.Price.Text = "$" .. v351.Price
                                            clone.ObjectName.Text = v350
                                            clone.Visible = true
                                            clone.LayoutOrder = p192.CurrentSubCategory == "Recent" and t20[v350] or v351.Price
                                            createViewportBaseObjects(clone, v350, v351.Type)
                                            clone.Parent = List

                                            if v351.ItemObject then
                                                if p192.Data.BaseItems[v350] then
                                                    clone.Price.Text = "x" .. p192.Data.BaseItems[v350]
                                                else
                                                    clone.Price.Text = "NONE"
                                                end
                                            end

                                            if v344 then
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
                                                TextButton.Text = p192.ModernBuildFavorites[v350] and "★" or "☆"
                                                TextButton.TextColor3 = p192.ModernBuildFavorites[v350] and Color3.fromRGB(255, 226, 137) or Color3.new(1, 1, 1)
                                                TextButton.ZIndex = math.max(clone.ZIndex, clone.Select.ZIndex, clone.ObjectName.ZIndex) + 2
                                                TextButton.Active = true
                                                TextButton.Selectable = false
                                                TextButton.Parent = clone
                                                TextButton.Activated:Connect(function() -- line: 4174
                                                    -- upvalues: p192 (copy), v350 (copy)
                                                    p192:ToggleModernDesktopFavorite(v350)
                                                end)
                                            end

                                            if v349 == v350 then
                                                p192:SetCurrentBaseObjectFrame(clone)
                                            end

                                            clone.Select.MouseButton1Click:Connect(function() -- line: 4178
                                                -- upvalues: p192 (copy), v350 (copy), v351 (copy), clone (copy)
                                                if p192.EditObject and not p192.EditingExistingObject and p192.CurrentFrame == clone then
                                                    p192:DeleteEditObject()
                                                else
                                                    p192:SelectEditObject(v350, v351.Type)

                                                    if p192.EditObject and not p192.EditingExistingObject then
                                                        p192:SetCurrentBaseObjectFrame(clone)
                                                    end
                                                end
                                            end)
                                        end
                                    else
                                        local clone = List.Sample:Clone()

                                        clone.Name = v350
                                        clone.Price.Text = "$" .. v351.Price
                                        clone.ObjectName.Text = v350
                                        clone.Visible = true
                                        clone.LayoutOrder = p192.CurrentSubCategory == "Recent" and t20[v350] or v351.Price
                                        createViewportBaseObjects(clone, v350, v351.Type)
                                        clone.Parent = List

                                        if v351.ItemObject then
                                            if p192.Data.BaseItems[v350] then
                                                clone.Price.Text = "x" .. p192.Data.BaseItems[v350]
                                            else
                                                clone.Price.Text = "NONE"
                                            end
                                        end

                                        if v344 then
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
                                            TextButton.Text = p192.ModernBuildFavorites[v350] and "★" or "☆"
                                            TextButton.TextColor3 = p192.ModernBuildFavorites[v350] and Color3.fromRGB(255, 226, 137) or Color3.new(1, 1, 1)
                                            TextButton.ZIndex = math.max(clone.ZIndex, clone.Select.ZIndex, clone.ObjectName.ZIndex) + 2
                                            TextButton.Active = true
                                            TextButton.Selectable = false
                                            TextButton.Parent = clone
                                            TextButton.Activated:Connect(function() -- line: 4174
                                                -- upvalues: p192 (copy), v350 (copy)
                                                p192:ToggleModernDesktopFavorite(v350)
                                            end)
                                        end

                                        if v349 == v350 then
                                            p192:SetCurrentBaseObjectFrame(clone)
                                        end

                                        clone.Select.MouseButton1Click:Connect(function() -- line: 4178
                                            -- upvalues: p192 (copy), v350 (copy), v351 (copy), clone (copy)
                                            if p192.EditObject and not p192.EditingExistingObject and p192.CurrentFrame == clone then
                                                p192:DeleteEditObject()
                                            else
                                                p192:SelectEditObject(v350, v351.Type)

                                                if p192.EditObject and not p192.EditingExistingObject then
                                                    p192:SetCurrentBaseObjectFrame(clone)
                                                end
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    elseif p192.CurrentSubCategory == "Recent" then
                        if t20[v350] then
                            local v354 = string.lower(p192.SearchText or "")

                            if v354 == "" or string.find(string.lower(v350), v354, 1, true) then
                                if v351.Unlock then
                                    if p192.Data.UnlockedObjects[v350] then
                                        local clone = List.Sample:Clone()

                                        clone.Name = v350
                                        clone.Price.Text = "$" .. v351.Price
                                        clone.ObjectName.Text = v350
                                        clone.Visible = true
                                        clone.LayoutOrder = p192.CurrentSubCategory == "Recent" and t20[v350] or v351.Price
                                        createViewportBaseObjects(clone, v350, v351.Type)
                                        clone.Parent = List

                                        if v351.ItemObject then
                                            if p192.Data.BaseItems[v350] then
                                                clone.Price.Text = "x" .. p192.Data.BaseItems[v350]
                                            else
                                                clone.Price.Text = "NONE"
                                            end
                                        end

                                        if v344 then
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
                                            TextButton.Text = p192.ModernBuildFavorites[v350] and "★" or "☆"
                                            TextButton.TextColor3 = p192.ModernBuildFavorites[v350] and Color3.fromRGB(255, 226, 137) or Color3.new(1, 1, 1)
                                            TextButton.ZIndex = math.max(clone.ZIndex, clone.Select.ZIndex, clone.ObjectName.ZIndex) + 2
                                            TextButton.Active = true
                                            TextButton.Selectable = false
                                            TextButton.Parent = clone
                                            TextButton.Activated:Connect(function() -- line: 4174
                                                -- upvalues: p192 (copy), v350 (copy)
                                                p192:ToggleModernDesktopFavorite(v350)
                                            end)
                                        end

                                        if v349 == v350 then
                                            p192:SetCurrentBaseObjectFrame(clone)
                                        end

                                        clone.Select.MouseButton1Click:Connect(function() -- line: 4178
                                            -- upvalues: p192 (copy), v350 (copy), v351 (copy), clone (copy)
                                            if p192.EditObject and not p192.EditingExistingObject and p192.CurrentFrame == clone then
                                                p192:DeleteEditObject()
                                            else
                                                p192:SelectEditObject(v350, v351.Type)

                                                if p192.EditObject and not p192.EditingExistingObject then
                                                    p192:SetCurrentBaseObjectFrame(clone)
                                                end
                                            end
                                        end)
                                    end
                                else
                                    local clone = List.Sample:Clone()

                                    clone.Name = v350
                                    clone.Price.Text = "$" .. v351.Price
                                    clone.ObjectName.Text = v350
                                    clone.Visible = true
                                    clone.LayoutOrder = p192.CurrentSubCategory == "Recent" and t20[v350] or v351.Price
                                    createViewportBaseObjects(clone, v350, v351.Type)
                                    clone.Parent = List

                                    if v351.ItemObject then
                                        if p192.Data.BaseItems[v350] then
                                            clone.Price.Text = "x" .. p192.Data.BaseItems[v350]
                                        else
                                            clone.Price.Text = "NONE"
                                        end
                                    end

                                    if v344 then
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
                                        TextButton.Text = p192.ModernBuildFavorites[v350] and "★" or "☆"
                                        TextButton.TextColor3 = p192.ModernBuildFavorites[v350] and Color3.fromRGB(255, 226, 137) or Color3.new(1, 1, 1)
                                        TextButton.ZIndex = math.max(clone.ZIndex, clone.Select.ZIndex, clone.ObjectName.ZIndex) + 2
                                        TextButton.Active = true
                                        TextButton.Selectable = false
                                        TextButton.Parent = clone
                                        TextButton.Activated:Connect(function() -- line: 4174
                                            -- upvalues: p192 (copy), v350 (copy)
                                            p192:ToggleModernDesktopFavorite(v350)
                                        end)
                                    end

                                    if v349 == v350 then
                                        p192:SetCurrentBaseObjectFrame(clone)
                                    end

                                    clone.Select.MouseButton1Click:Connect(function() -- line: 4178
                                        -- upvalues: p192 (copy), v350 (copy), v351 (copy), clone (copy)
                                        if p192.EditObject and not p192.EditingExistingObject and p192.CurrentFrame == clone then
                                            p192:DeleteEditObject()
                                        else
                                            p192:SelectEditObject(v350, v351.Type)

                                            if p192.EditObject and not p192.EditingExistingObject then
                                                p192:SetCurrentBaseObjectFrame(clone)
                                            end
                                        end
                                    end)
                                end
                            end
                        end
                    else
                        local v355 = string.lower(p192.SearchText or "")

                        if v355 == "" or string.find(string.lower(v350), v355, 1, true) then
                            if v351.Unlock then
                                if p192.Data.UnlockedObjects[v350] then
                                    local clone = List.Sample:Clone()

                                    clone.Name = v350
                                    clone.Price.Text = "$" .. v351.Price
                                    clone.ObjectName.Text = v350
                                    clone.Visible = true
                                    clone.LayoutOrder = p192.CurrentSubCategory == "Recent" and t20[v350] or v351.Price
                                    createViewportBaseObjects(clone, v350, v351.Type)
                                    clone.Parent = List

                                    if v351.ItemObject then
                                        if p192.Data.BaseItems[v350] then
                                            clone.Price.Text = "x" .. p192.Data.BaseItems[v350]
                                        else
                                            clone.Price.Text = "NONE"
                                        end
                                    end

                                    if v344 then
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
                                        TextButton.Text = p192.ModernBuildFavorites[v350] and "★" or "☆"
                                        TextButton.TextColor3 = p192.ModernBuildFavorites[v350] and Color3.fromRGB(255, 226, 137) or Color3.new(1, 1, 1)
                                        TextButton.ZIndex = math.max(clone.ZIndex, clone.Select.ZIndex, clone.ObjectName.ZIndex) + 2
                                        TextButton.Active = true
                                        TextButton.Selectable = false
                                        TextButton.Parent = clone
                                        TextButton.Activated:Connect(function() -- line: 4174
                                            -- upvalues: p192 (copy), v350 (copy)
                                            p192:ToggleModernDesktopFavorite(v350)
                                        end)
                                    end

                                    if v349 == v350 then
                                        p192:SetCurrentBaseObjectFrame(clone)
                                    end

                                    clone.Select.MouseButton1Click:Connect(function() -- line: 4178
                                        -- upvalues: p192 (copy), v350 (copy), v351 (copy), clone (copy)
                                        if p192.EditObject and not p192.EditingExistingObject and p192.CurrentFrame == clone then
                                            p192:DeleteEditObject()
                                        else
                                            p192:SelectEditObject(v350, v351.Type)

                                            if p192.EditObject and not p192.EditingExistingObject then
                                                p192:SetCurrentBaseObjectFrame(clone)
                                            end
                                        end
                                    end)
                                end
                            else
                                local clone = List.Sample:Clone()

                                clone.Name = v350
                                clone.Price.Text = "$" .. v351.Price
                                clone.ObjectName.Text = v350
                                clone.Visible = true
                                clone.LayoutOrder = p192.CurrentSubCategory == "Recent" and t20[v350] or v351.Price
                                createViewportBaseObjects(clone, v350, v351.Type)
                                clone.Parent = List

                                if v351.ItemObject then
                                    if p192.Data.BaseItems[v350] then
                                        clone.Price.Text = "x" .. p192.Data.BaseItems[v350]
                                    else
                                        clone.Price.Text = "NONE"
                                    end
                                end

                                if v344 then
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
                                    TextButton.Text = p192.ModernBuildFavorites[v350] and "★" or "☆"
                                    TextButton.TextColor3 = p192.ModernBuildFavorites[v350] and Color3.fromRGB(255, 226, 137) or Color3.new(1, 1, 1)
                                    TextButton.ZIndex = math.max(clone.ZIndex, clone.Select.ZIndex, clone.ObjectName.ZIndex) + 2
                                    TextButton.Active = true
                                    TextButton.Selectable = false
                                    TextButton.Parent = clone
                                    TextButton.Activated:Connect(function() -- line: 4174
                                        -- upvalues: p192 (copy), v350 (copy)
                                        p192:ToggleModernDesktopFavorite(v350)
                                    end)
                                end

                                if v349 == v350 then
                                    p192:SetCurrentBaseObjectFrame(clone)
                                end

                                clone.Select.MouseButton1Click:Connect(function() -- line: 4178
                                    -- upvalues: p192 (copy), v350 (copy), v351 (copy), clone (copy)
                                    if p192.EditObject and not p192.EditingExistingObject and p192.CurrentFrame == clone then
                                        p192:DeleteEditObject()
                                    else
                                        p192:SelectEditObject(v350, v351.Type)

                                        if p192.EditObject and not p192.EditingExistingObject then
                                            p192:SetCurrentBaseObjectFrame(clone)
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end
            elseif v351.Type == v346 then
                if p192.CurrentSubCategory then
                    if p192.CurrentSubCategory == "All" or v351.SubCategory == p192.CurrentSubCategory then
                        local v356 = string.lower(p192.SearchText or "")

                        if v356 == "" or string.find(string.lower(v350), v356, 1, true) then
                            if v351.Unlock then
                                if p192.Data.UnlockedObjects[v350] then
                                    local clone = List.Sample:Clone()

                                    clone.Name = v350
                                    clone.Price.Text = "$" .. v351.Price
                                    clone.ObjectName.Text = v350
                                    clone.Visible = true
                                    clone.LayoutOrder = v351.Price
                                    createViewportBaseObjects(clone, v350, v351.Type)
                                    clone.Parent = List

                                    if v351.ItemObject then
                                        if p192.Data.BaseItems[v350] then
                                            clone.Price.Text = "x" .. p192.Data.BaseItems[v350]
                                        else
                                            clone.Price.Text = "NONE"
                                        end
                                    end

                                    if v344 then
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
                                        TextButton.Text = p192.ModernBuildFavorites[v350] and "★" or "☆"
                                        TextButton.TextColor3 = p192.ModernBuildFavorites[v350] and Color3.fromRGB(255, 226, 137) or Color3.new(1, 1, 1)
                                        TextButton.ZIndex = math.max(clone.ZIndex, clone.Select.ZIndex, clone.ObjectName.ZIndex) + 2
                                        TextButton.Active = true
                                        TextButton.Selectable = false
                                        TextButton.Parent = clone
                                        TextButton.Activated:Connect(function() -- line: 4174
                                            -- upvalues: p192 (copy), v350 (copy)
                                            p192:ToggleModernDesktopFavorite(v350)
                                        end)
                                    end

                                    if v349 == v350 then
                                        p192:SetCurrentBaseObjectFrame(clone)
                                    end

                                    clone.Select.MouseButton1Click:Connect(function() -- line: 4178
                                        -- upvalues: p192 (copy), v350 (copy), v351 (copy), clone (copy)
                                        if p192.EditObject and not p192.EditingExistingObject and p192.CurrentFrame == clone then
                                            p192:DeleteEditObject()
                                        else
                                            p192:SelectEditObject(v350, v351.Type)

                                            if p192.EditObject and not p192.EditingExistingObject then
                                                p192:SetCurrentBaseObjectFrame(clone)
                                            end
                                        end
                                    end)
                                end
                            else
                                local clone = List.Sample:Clone()

                                clone.Name = v350
                                clone.Price.Text = "$" .. v351.Price
                                clone.ObjectName.Text = v350
                                clone.Visible = true
                                clone.LayoutOrder = v351.Price
                                createViewportBaseObjects(clone, v350, v351.Type)
                                clone.Parent = List

                                if v351.ItemObject then
                                    if p192.Data.BaseItems[v350] then
                                        clone.Price.Text = "x" .. p192.Data.BaseItems[v350]
                                    else
                                        clone.Price.Text = "NONE"
                                    end
                                end

                                if v344 then
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
                                    TextButton.Text = p192.ModernBuildFavorites[v350] and "★" or "☆"
                                    TextButton.TextColor3 = p192.ModernBuildFavorites[v350] and Color3.fromRGB(255, 226, 137) or Color3.new(1, 1, 1)
                                    TextButton.ZIndex = math.max(clone.ZIndex, clone.Select.ZIndex, clone.ObjectName.ZIndex) + 2
                                    TextButton.Active = true
                                    TextButton.Selectable = false
                                    TextButton.Parent = clone
                                    TextButton.Activated:Connect(function() -- line: 4174
                                        -- upvalues: p192 (copy), v350 (copy)
                                        p192:ToggleModernDesktopFavorite(v350)
                                    end)
                                end

                                if v349 == v350 then
                                    p192:SetCurrentBaseObjectFrame(clone)
                                end

                                clone.Select.MouseButton1Click:Connect(function() -- line: 4178
                                    -- upvalues: p192 (copy), v350 (copy), v351 (copy), clone (copy)
                                    if p192.EditObject and not p192.EditingExistingObject and p192.CurrentFrame == clone then
                                        p192:DeleteEditObject()
                                    else
                                        p192:SelectEditObject(v350, v351.Type)

                                        if p192.EditObject and not p192.EditingExistingObject then
                                            p192:SetCurrentBaseObjectFrame(clone)
                                        end
                                    end
                                end)
                            end
                        end
                    end
                else
                    local v357 = string.lower(p192.SearchText or "")

                    if v357 == "" or string.find(string.lower(v350), v357, 1, true) then
                        if v351.Unlock then
                            if p192.Data.UnlockedObjects[v350] then
                                local clone = List.Sample:Clone()

                                clone.Name = v350
                                clone.Price.Text = "$" .. v351.Price
                                clone.ObjectName.Text = v350
                                clone.Visible = true
                                clone.LayoutOrder = v351.Price
                                createViewportBaseObjects(clone, v350, v351.Type)
                                clone.Parent = List

                                if v351.ItemObject then
                                    if p192.Data.BaseItems[v350] then
                                        clone.Price.Text = "x" .. p192.Data.BaseItems[v350]
                                    else
                                        clone.Price.Text = "NONE"
                                    end
                                end

                                if v344 then
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
                                    TextButton.Text = p192.ModernBuildFavorites[v350] and "★" or "☆"
                                    TextButton.TextColor3 = p192.ModernBuildFavorites[v350] and Color3.fromRGB(255, 226, 137) or Color3.new(1, 1, 1)
                                    TextButton.ZIndex = math.max(clone.ZIndex, clone.Select.ZIndex, clone.ObjectName.ZIndex) + 2
                                    TextButton.Active = true
                                    TextButton.Selectable = false
                                    TextButton.Parent = clone
                                    TextButton.Activated:Connect(function() -- line: 4174
                                        -- upvalues: p192 (copy), v350 (copy)
                                        p192:ToggleModernDesktopFavorite(v350)
                                    end)
                                end

                                if v349 == v350 then
                                    p192:SetCurrentBaseObjectFrame(clone)
                                end

                                clone.Select.MouseButton1Click:Connect(function() -- line: 4178
                                    -- upvalues: p192 (copy), v350 (copy), v351 (copy), clone (copy)
                                    if p192.EditObject and not p192.EditingExistingObject and p192.CurrentFrame == clone then
                                        p192:DeleteEditObject()
                                    else
                                        p192:SelectEditObject(v350, v351.Type)

                                        if p192.EditObject and not p192.EditingExistingObject then
                                            p192:SetCurrentBaseObjectFrame(clone)
                                        end
                                    end
                                end)
                            end
                        else
                            local clone = List.Sample:Clone()

                            clone.Name = v350
                            clone.Price.Text = "$" .. v351.Price
                            clone.ObjectName.Text = v350
                            clone.Visible = true
                            clone.LayoutOrder = v351.Price
                            createViewportBaseObjects(clone, v350, v351.Type)
                            clone.Parent = List

                            if v351.ItemObject then
                                if p192.Data.BaseItems[v350] then
                                    clone.Price.Text = "x" .. p192.Data.BaseItems[v350]
                                else
                                    clone.Price.Text = "NONE"
                                end
                            end

                            if v344 then
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
                                TextButton.Text = p192.ModernBuildFavorites[v350] and "★" or "☆"
                                TextButton.TextColor3 = p192.ModernBuildFavorites[v350] and Color3.fromRGB(255, 226, 137) or Color3.new(1, 1, 1)
                                TextButton.ZIndex = math.max(clone.ZIndex, clone.Select.ZIndex, clone.ObjectName.ZIndex) + 2
                                TextButton.Active = true
                                TextButton.Selectable = false
                                TextButton.Parent = clone
                                TextButton.Activated:Connect(function() -- line: 4174
                                    -- upvalues: p192 (copy), v350 (copy)
                                    p192:ToggleModernDesktopFavorite(v350)
                                end)
                            end

                            if v349 == v350 then
                                p192:SetCurrentBaseObjectFrame(clone)
                            end

                            clone.Select.MouseButton1Click:Connect(function() -- line: 4178
                                -- upvalues: p192 (copy), v350 (copy), v351 (copy), clone (copy)
                                if p192.EditObject and not p192.EditingExistingObject and p192.CurrentFrame == clone then
                                    p192:DeleteEditObject()
                                else
                                    p192:SelectEditObject(v350, v351.Type)

                                    if p192.EditObject and not p192.EditingExistingObject then
                                        p192:SetCurrentBaseObjectFrame(clone)
                                    end
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end

local t21 = {
    0.1, 0.25, 0.5, 1, 2, 5
}
local t22 = {
    5, 15, 30, 45, 90
}

Color3.fromRGB(42, 170, 255)

local v358 = Color3.fromRGB(0, 0, 0)
local v359 = Color3.fromRGB(82, 218, 126)
local v360 = Color3.fromRGB(255, 91, 91)

local function styleBuildButton(p195, p196, p197) -- line: 4204
    -- upvalues: v358 (copy)
    p195.BackgroundColor3 = v358
    p195.BackgroundTransparency = 0.5
    p195.BorderColor3 = Color3.new(1, 1, 1)
    p195.BorderSizePixel = p196 and 3 or 1

    if p195:IsA("TextButton") then
        p195.TextColor3 = p197 or Color3.new(1, 1, 1)
    end
end

local v361 = Enum.ContextActionPriority.High.Value + 30
local t23 = {
    X = Vector3.new(1, 0, 0),
    Y = Vector3.new(0, 1, 0),
    Z = Vector3.new(0, 0, 1)
}
local t24 = {
    X = { Vector3.new(0, 1, 0), (Vector3.new(0, 0, 1)) },
    Y = { Vector3.new(0, 0, 1), (Vector3.new(1, 0, 0)) },
    Z = { Vector3.new(1, 0, 0), (Vector3.new(0, 1, 0)) }
}

local function buildRotationCFrame(p198) -- line: 4231
    p198 = p198 or Vector3.new(-90, 90, 0)

    return CFrame.Angles(math.rad(p198.X), math.rad(p198.Y), (math.rad(p198.Z)))
end

local function buildRotationVector(p199) -- line: 4240
    local v365, v366, v367 = p199:ToEulerAnglesXYZ()

    return (Vector3.new(math.deg(v365), math.deg(v366), (math.deg(v367))))
end

local function rotateBuildRotationOnLocalAxis(p200, p201, p202) -- line: 4245
    -- upvalues: t23 (copy)
    local v371 = t23[p201]

    if not v371 then
        return p200
    end

    p200 = p200 or Vector3.new(-90, 90, 0)

    local v375, v376, v377 = (CFrame.Angles(math.rad(p200.X), math.rad(p200.Y), (math.rad(p200.Z))) * CFrame.fromAxisAngle(v371, (math.rad(p202)))):ToEulerAnglesXYZ()

    return (Vector3.new(math.deg(v375), math.deg(v376), (math.deg(v377))))
end

local function projectBuildWorldPoint(p203, p204) -- line: 4254
    local v381 = p203:WorldToViewportPoint(p204)

    if v381.Z <= 0 then
        return nil
    end

    return Vector2.new(v381.X, v381.Y)
end

local function buildPointToSegmentDistance(p205, p206, p207) -- line: 4260
    local v382 = p207 - p206
    local v383 = v382:Dot(v382)

    if v383 <= 1E-04 then
        return (p205 - p206).Magnitude
    end

    return (p205 - (p206 + v382 * math.clamp((p205 - p206):Dot(v382) / v383, 0, 1))).Magnitude
end

local function buildCross2(p208, p209) -- line: 4270
    return p208.X * p209.Y - p208.Y * p209.X
end

local function buildConvexHull(p210) -- line: 4274
    if #p210 < 3 then
        return nil
    end

    table.sort(p210, function(p211, p212) -- line: 4276
        if p211.X < p212.X then
            return true
        end

        if p211.X == p212.X then
            return p211.Y < p212.Y
        end

        return false
    end)

    local t25 = {}

    for _, v385 in ipairs(p210) do
        while true do
            local v386 = #t25 >= 2
            local v387

            if v386 then
                local v388 = t25[#t25] - t25[#t25 - 1]
                local v389 = v385 - t25[#t25]

                v387 = v388.X * v389.Y - v388.Y * v389.X <= 0
            end

            if v386 and v387 then
                table.remove(t25)
                continue
            end

            table.insert(t25, v385)
            break
        end
    end

    local t26 = {}

    for i = #p210, 1, -1 do
        local v390 = p210[i]

        while true do
            if #t26 >= 2 then
                local v391 = t26[#t26] - t26[#t26 - 1]
                local v392 = v390 - t26[#t26]

                if v391.X * v392.Y - v391.Y * v392.X <= 0 then
                    table.remove(t26)
                    continue
                end
            end

            break
        end

        table.insert(t26, v390)
    end

    table.remove(t25)
    table.remove(t26)

    for _, v393 in ipairs(t26) do
        table.insert(t25, v393)
    end

    if not (#t25 >= 3) or not t25 then
        t25 = nil
    end

    return t25
end

local function buildPointInConvexPolygon(p213, p214) -- line: 4314
    local v394 = false
    local v395 = false

    for v396, v397 in ipairs(p214) do
        local v398 = p214[v396 % #p214 + 1] - v397
        local v399 = p213 - v397
        local v400 = v398.X * v399.Y - v398.Y * v399.X

        if v400 > 0.001 then
            v394 = true
        elseif v400 < -0.001 then
            v395 = true
        end

        if v394 and v395 then
            return false
        end
    end

    return true
end

local function buildRayConvexPolygonExit(p215, p216, p217) -- line: 4330
    local v401

    for v402, v403 in ipairs(p217) do
        local v404 = p217[v402 % #p217 + 1] - v403
        local v405 = p216.X * v404.Y - p216.Y * v404.X

        if math.abs(v405) > 1E-04 then
            local v406 = v403 - p215
            local v407 = (v406.X * v404.Y - v406.Y * v404.X) / v405
            local v408 = (v406.X * p216.Y - v406.Y * p216.X) / v405

            if v407 >= 0 and v408 >= -0.001 and v408 <= 1.001 and (not v401 or v407 < v401) then
                v401 = v407
            end
        end
    end

    return v401
end

local function buildWorldUnitsPerPixel(p218, p219) -- line: 4351
    local v409 = (p219 - p218.CFrame.Position):Dot(p218.CFrame.LookVector)

    if v409 <= 0 then
        return nil
    end

    local v410 = math.max(p218.ViewportSize.Y, 1)

    return 2 * v409 * math.tan(math.rad(p218.FieldOfView) * 0.5) / v410
end

local function buildAxisSize(p220, p221) -- line: 4358
    if p221 == "X" then
        return p220.X
    end

    if p221 == "Y" then
        return p220.Y
    end

    return p220.Z
end

local function buildAxisPerpendicularSize(p222, p223) -- line: 4364
    if p223 == "X" then
        return (math.max(p222.Y, p222.Z))
    end

    if p223 == "Y" then
        return (math.max(p222.Z, p222.X))
    end

    return (math.max(p222.X, p222.Y))
end

local function buildRayPlaneIntersection(p224, p225, p226, p227) -- line: 4370
    local v413 = p224:ViewportPointToRay(p225.X, p225.Y)
    local v414 = v413.Direction:Dot(p227)

    if math.abs(v414) <= 1E-04 then
        return nil
    end

    local v415 = (p226 - v413.Origin):Dot(p227) / v414

    return if not (v415 <= 0) then v413.Origin + v413.Direction * v415 else nil
end

local function buildSnap(p228, p229) -- line: 4379
    if not p229 or p229 <= 0 then
        return p228
    end

    return math.round(p228 / p229) * p229
end

local function buildFormatNumber(p230) -- line: 4384
    if math.abs(p230 - math.round(p230)) < 0.001 then
        return (tostring((math.round(p230))))
    end

    return string.format("%.2f", p230):gsub("0+$", ""):gsub("%.$", "")
end

function t1.GetBuildReference(p231) -- line: 4391
    if not p231.StorageBase then
        return nil, nil
    end

    local Floor = p231.StorageBase:FindFirstChild("Floor")
    local Contents = p231.StorageBase:FindFirstChild("Contents")

    if p231.StorageBase:FindFirstChild("Basement") then
        Contents = p231.StorageBase.Basement
    end

    return Floor, Contents and Contents:FindFirstChild("BoundingBox")
end

function t1.IsBuildGroundPart(p232, p233) -- line: 4402
    if p233 and p233:IsA("BasePart") then
        local v419 = p233

        while true do
            local StorageBase

            if not v419 or v419 == workspace then
                StorageBase = p232.StorageBase and p232.StorageBase:FindFirstChild("Floor")
            else
                local v420 = string.lower(v419.Name)

                if string.find(v420, "floor", 1, true) or v420 == "ground" or v420 == "baseplate" or v420 == "terrain" then
                    break
                end

                v419 = v419.Parent
                continue
            end

            if p233 == StorageBase then
                return true
            end

            local Map = workspace:FindFirstChild("Map")
            local FLOOR_OBJECTS = Map and Map:FindFirstChild("FLOOR_OBJECTS")

            if FLOOR_OBJECTS and p233:IsDescendantOf(FLOOR_OBJECTS) then
                return true
            end

            local _, BuildReference = p232:GetBuildReference()

            if BuildReference and p232.StorageBase and p233:IsDescendantOf(p232.StorageBase) then
                local v422 = BuildReference.CFrame:PointToObjectSpace(p233.Position).Y <= -BuildReference.Size.Y * 0.5 + math.max(4, p233.Size.Y)
                local v424 = math.abs((p233.CFrame.UpVector:Dot(BuildReference.CFrame.UpVector))) >= 0.75

                if v422 and v424 then
                    return true
                end
            end

            return false
        end

        return true
    end

    return false
end

function t1.ClampBuildCameraPosition(p234, p235) -- line: 4440
    if typeof(p235) ~= "Vector3" then
        return p235
    end

    local _, BuildReference = p234:GetBuildReference()

    if not BuildReference then
        return p235
    end

    local v425 = BuildReference.Size * 0.5
    local v427 = math.max(0, v425.X - 1.25)
    local v429 = math.max(0, v425.Y - 1.25)
    local v431 = math.max(0, v425.Z - 1.25)
    local v432 = BuildReference.CFrame:PointToObjectSpace(p235)
    local v439 = Vector3.new(math.clamp(v432.X, -v427, v427), math.clamp(v432.Y, -v429, v429), (math.clamp(v432.Z, -v431, v431)))

    return BuildReference.CFrame:PointToWorldSpace(v439)
end

function t1.CacheBuildSurfaceParts(p236) -- line: 4461
    p236.BuildSurfaceParts = {}

    if p236.StorageBase then
        local v440 = p236.StorageBase:FindFirstChild("Basement") or p236.StorageBase:FindFirstChild("Contents")
        local Customization = v440 and v440:FindFirstChild("Customization")

        if Customization then
            for _, descendant in ipairs(Customization:GetDescendants()) do
                if descendant:IsA("BasePart") and descendant.Name == "Wall" then
                    p236.BuildSurfaceParts[descendant] = true
                end
            end
        end
    end
end

function t1.DestroyBuildGrid(p237) -- line: 4476
    if p237.BuildGrid then
        p237.BuildGrid:Destroy()
        p237.BuildGrid = nil
    end

    p237.BuildGridFloor = nil
end

function t1.GetBuildGridFloor(p238) -- line: 4484
    local BuildReference, BuildReference2 = p238:GetBuildReference()

    if not (BuildReference and BuildReference2) then
        return nil, BuildReference2
    end

    local v441 = p238.StorageBase and p238.StorageBase:FindFirstChild("Basement")

    if not v441 then
        return BuildReference, BuildReference2
    end

    local BottomFloor = v441:FindFirstChild("BottomFloor")

    if not BottomFloor then
        return BuildReference, BuildReference2
    end

    local v442 = v441:FindFirstChild("Floor") or BuildReference
    local v444 = v442.CFrame:PointToWorldSpace((Vector3.new(0, v442.Size.Y * 0.5, 0)))
    local UpVector = BuildReference2.CFrame.UpVector
    local v445 = (workspace.CurrentCamera.CFrame.Position - v444):Dot(UpVector)

    if p238.BuildGridFloor == BuildReference and v445 >= -0.75 then
        return BuildReference, BuildReference2
    end

    if p238.BuildGridFloor == BottomFloor and v445 <= 0.75 then
        return BottomFloor, BuildReference2
    end

    if v445 >= 0 and BuildReference then
        BottomFloor = BuildReference
    end

    return BottomFloor, BuildReference2
end

function t1.UpdateBuildGridLabel(p239) -- line: 4511
    -- upvalues: buildFormatNumber (copy)
    if p239.BuildGui then
        local GridHeight = p239.BuildGui.TransformPanel.AxisRows:FindFirstChild("GridHeight")

        if GridHeight then
            local BuildGridFloor = p239:GetBuildGridFloor()
            local v446, v447

            if BuildGridFloor and p239.BuildGridOffsets then
                local v448 = p239.BuildGridOffsets[BuildGridFloor]

                if v448 then
                    v446 = v448
                    v447 = true
                else
                    v447 = false
                end
            else
                v447 = false
            end

            if not v447 then
                v446 = 0
            end

            GridHeight.Axis.Text = "GRID " .. buildFormatNumber(v446 or 0)
        end
    end
end

function t1.UpdateBuildGridSurface(p240) -- line: 4520
    local BuildGrid = p240.BuildGrid

    if BuildGrid and BuildGrid:IsA("BasePart") then
        local BuildGridFloor, BuildGridFloor2 = p240:GetBuildGridFloor()

        if BuildGridFloor and BuildGridFloor:IsA("BasePart") and BuildGridFloor2 then
            p240.BuildGridOffsets = p240.BuildGridOffsets or {}

            local v449 = p240.BuildGridFloor ~= BuildGridFloor

            p240.BuildGridFloor = BuildGridFloor

            local v451 = BuildGridFloor.CFrame:PointToWorldSpace((Vector3.new(0, BuildGridFloor.Size.Y * 0.5, 0)))
            local Y = BuildGridFloor2.CFrame:PointToObjectSpace(v451).Y
            local v452 = BuildGridFloor2.Size.Y * 0.5
            local v453 = p240.BuildGridOffsets[BuildGridFloor] or 0
            local v456 = math.clamp(v453, -v452 + 0.05 - Y, v452 - 0.05 - Y)

            p240.BuildGridOffsets[BuildGridFloor] = v456
            BuildGrid.Size = Vector3.new(math.max(BuildGridFloor2.Size.X, 0.1), 0.02, (math.max(BuildGridFloor2.Size.Z, 0.1)))
            BuildGrid.CFrame = BuildGridFloor2.CFrame * CFrame.new(0, Y + v456 + 0.02, 0)

            local GridTexture = BuildGrid:FindFirstChild("GridTexture")

            if GridTexture and GridTexture:IsA("Texture") then
                local v460 = math.max(p240.BuildMoveStep or 0.5, 0.1)

                GridTexture.StudsPerTileU = v460
                GridTexture.StudsPerTileV = v460
            end

            local v461 = if not v449 then math.abs(v456 - v453) > 0.001 else nil

            if v449 or v461 then
                p240:UpdateBuildGridLabel()
            end
        end
    end
end

function t1.AdjustBuildGridHeight(p241, p242) -- line: 4549
    if p241.BuildCameraActive then
        local BuildGridFloor = p241:GetBuildGridFloor()

        if BuildGridFloor then
            p241.BuildGridOffsets = p241.BuildGridOffsets or {}
            p241.BuildGridOffsets[BuildGridFloor] = (p241.BuildGridOffsets[BuildGridFloor] or 0) + (p241.BuildMoveStep or 0.5) * p242
            p241:UpdateBuildGridSurface()
            p241:UpdateBuildGridLabel()
        end
    end
end

function t1.RebuildBuildGrid(p243) -- line: 4560
    p243:DestroyBuildGrid()

    if not (p243.BuildCameraActive and p243.BuildGridEnabled) then
        p243:UpdateBuildGridLabel()
    else
        local BuildGridFloor, BuildGridFloor2 = p243:GetBuildGridFloor()

        if BuildGridFloor and BuildGridFloor2 then
            local Part = Instance.new("Part")

            Part.Name = "BuildGrid"
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanTouch = false
            Part.CanQuery = false
            Part.CastShadow = false
            Part.Transparency = 1
            Part.Parent = workspace.CurrentCamera

            local Texture = Instance.new("Texture")

            Texture.Name = "GridTexture"
            Texture.Texture = "rbxassetid://2600521419"
            Texture.Face = Enum.NormalId.Top
            Texture.Color3 = Color3.fromRGB(255, 255, 255)
            Texture.Transparency = 0.25
            Texture.Parent = Part
            p243.BuildGrid = Part
            p243:UpdateBuildGridSurface()
        end
    end
end

local function usingBuildController() -- line: 4591
    -- upvalues: UserInputService (copy), GuiService (copy)
    return GuiService:IsTenFootInterface() or UserInputService.GamepadEnabled and (not UserInputService.KeyboardEnabled or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)
end

function t1.HandleBuildObjectDPad(p244, p245, p246) -- line: 4599
    -- upvalues: UserInputService (copy), GuiService (copy)
    if p244.ModernController and p244.ModernController:IsGamepad()
        or p244.DeleteAllConfirmOpen
        or p244.PaintResetConfirmOpen
        or GuiService.MenuIsOpen
        or not p244.BuildCameraActive
        or p244.BuildModeKind ~= "Objects" then
        return Enum.ContextActionResult.Pass
    end

    if p245 == Enum.UserInputState.Begin and not UserInputService:GetFocusedTextBox() then
        local v463 = p246 and p246.KeyCode

        if v463 == Enum.KeyCode.DPadDown then
            if p244.EditingBase then
                p244:StopEditStorage()
            else
                p244:EndBuildMode()
            end
        elseif v463 == Enum.KeyCode.DPadRight then
            p244:SetBuildTransformMode(p244.BuildTransformMode == "Rotate" and "Move" or "Rotate")
        elseif v463 == Enum.KeyCode.DPadLeft then
            if p244.BuildTransformMode == "Rotate" then
                p244:CycleBuildRotateStep()
            elseif p244.BuildTransformMode == "Move" then
                p244:CycleBuildMoveStep()
            end
        elseif v463 == Enum.KeyCode.DPadUp and p244.EditingBase then
            p244:OpenPaintFrames()
        end
    end

    return Enum.ContextActionResult.Sink
end

function t1.BindBuildObjectDPad(p247) -- line: 4639
    -- upvalues: ContextActionService (copy), v361 (copy)
    ContextActionService:UnbindAction("BaseObjectEditDPad")
    ContextActionService:BindActionAtPriority("BaseObjectEditDPad", function(_, p249, p250) -- line: 4643
        -- upvalues: p247 (copy)
        return p247:HandleBuildObjectDPad(p249, p250)
    end, false, v361, Enum.KeyCode.DPadDown, Enum.KeyCode.DPadRight, Enum.KeyCode.DPadLeft, Enum.KeyCode.DPadUp)
end

function t1.UnbindBuildObjectDPad(_) -- line: 4655
    -- upvalues: ContextActionService (copy)
    ContextActionService:UnbindAction("BaseObjectEditDPad")
end

function t1.SetBuildGamepadNavigation(p252, p253) -- line: 4659
    -- upvalues: UserInputService (copy), ContextActionService (copy), GuiService (copy), GamepadService (copy)
    local v465 = p253

    if p252.ModernController and p252.ModernController:IsGamepad() then
        p252.BuildGamepadNavigation = false

        return
    end

    local v466 = false

    if p253 == true then
        v465 = true
        v466 = true
    else
        v465 = false
    end

    if p252.BuildCameraLocked and (GuiService:IsTenFootInterface() or UserInputService.GamepadEnabled and (not UserInputService.KeyboardEnabled or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)) then
        v465 = true
        p252.BuildGamepadNavigation = true
    else
        p252.BuildGamepadNavigation = v466
    end

    GuiService.SelectedObject = nil

    if UserInputService.GamepadEnabled then
        local function v467() -- line: 4677
            -- upvalues: v465 (ref), ContextActionService (copy)
            ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
            ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)

            if v465 then
                ContextActionService:BindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
            end
        end

        pcall(v467)
        p252.BuildGamepadActivationRemapped = true

        if v465 then
            local v468 = p252.BuildGui and p252.BuildGui:FindFirstChild("Toolbar")
            local Buttons = v468 and v468:FindFirstChild("Buttons")
            local v469 = p252.HUD and p252.HUD:FindFirstChild("PaintEditBar")
            local v470, v471

            if p252.Painting and v469 then
                local PaintBrush = v469:FindFirstChild("PaintBrush")

                if PaintBrush then
                    v470 = PaintBrush
                    v471 = true
                else
                    v471 = false
                end
            else
                v471 = false
            end

            if not v471 then
                local MoveMode = if Buttons then Buttons:FindFirstChild("MoveMode") else nil

                v470 = if not Buttons or not MoveMode then nil else MoveMode
            end

            local function v472() -- line: 4692
                -- upvalues: v470 (ref), GamepadService (copy)
                GamepadService:EnableGamepadCursor(v470)
            end

            if not pcall(v472) then
                local function v473() -- line: 4696
                    -- upvalues: GamepadService (copy)
                    GamepadService:EnableGamepadCursor(nil)
                end

                pcall(v473)
            end
        elseif GamepadService.GamepadCursorEnabled then
            local function v474() -- line: 4701
                -- upvalues: GamepadService (copy)
                GamepadService:DisableGamepadCursor()
            end

            pcall(v474)
        end
    end

    p252:UpdateBuildGui()
end

function t1.SetBuildCameraLocked(p254, p255) -- line: 4710
    -- upvalues: UserInputService (copy), GuiService (copy)
    if p254.BuildCameraActive then
        local v475 = p254.BuildCameraLocked == true

        p254.BuildCameraLocked = p255 == true

        local BuildCameraLocked = p254.BuildCameraLocked and (GuiService:IsTenFootInterface() or UserInputService.GamepadEnabled and (not UserInputService.KeyboardEnabled or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad))

        if BuildCameraLocked and not v475 then
            local v476 = p254.BuildGamepadNavigation == true

            if p254.PaintPickerPreviousGamepadNavigation ~= nil then
                v476 = p254.PaintPickerPreviousGamepadNavigation == true
            end

            p254.BuildGamepadNavigationBeforeCameraLock = v476
            p254.BuildCameraLockManagedGamepadNavigation = true
        end

        if p254.BuildCameraLocked then
            p254:ClearBuildMobileCameraInputs()
            p254:EndBuildMouseCameraDrag()
            p254.BuildPinchMid = nil
            p254.BuildPinchDistance = nil
        end

        if BuildCameraLocked then
            p254:SetBuildGamepadNavigation(true)
        elseif v475 and not p254.BuildCameraLocked and p254.BuildCameraLockManagedGamepadNavigation then
            local v477 = p254.BuildGamepadNavigationBeforeCameraLock == true

            p254.BuildGamepadNavigationBeforeCameraLock = nil
            p254.BuildCameraLockManagedGamepadNavigation = nil

            if p254.ColorPickerHUD then
                p254.PaintPickerPreviousGamepadNavigation = v477
                p254:SetBuildGamepadNavigation(true)
            else
                p254:SetBuildGamepadNavigation(v477)
            end
        end

        p254:UpdateBuildGui()
    end
end

function t1.UpdateBuildGui(p256) -- line: 4753
    -- upvalues: UserInputService (copy), GuiService (copy), v360 (copy), styleBuildButton (copy), buildFormatNumber (copy)
    p256:RefreshDesktopBuildCatalogue()

    local BuildGui = p256.BuildGui

    if not BuildGui then
        return
    end

    p256:UpdateBuildSystem()

    if p256.ClassicDesktop then
        p256.ClassicDesktop:Refresh()
    end

    if p256.ModernDesktop then
        p256.ModernDesktop:Refresh()
    end

    if p256.ModernMobile and p256.ModernMobile:IsActive() then
        p256:UpdateStorageCapacity()
        p256.ModernMobile:RefreshPresentation()
    elseif p256.ModernController and p256.ModernController:IsGamepad() then
        p256:UpdateStorageCapacity()
        p256.ModernController:RefreshPresentation()
    else
        local BuildSystemToggle = BuildGui:FindFirstChild("BuildSystemToggle")

        if BuildSystemToggle then
            local v478 = p256.BuildCameraActive == true and p256.BuildModeKind == "Objects" and not p256.Painting
            local v479 = v478 and not p256.BuildSystemSwitching

            BuildSystemToggle.Visible = v478
            BuildSystemToggle.Active = v479
            BuildSystemToggle.Interactable = v479
        end

        if p256.ClassicBuildActive then
            p256:ApplyClassicBuildPresentation()
        else
            local Buttons = BuildGui.Toolbar.Buttons
            local v480 = p256.BuildTransformMode ~= "Rotate"

            styleBuildButton(Buttons.MoveMode, v480)
            styleBuildButton(Buttons.RotateMode, not v480)
            Buttons.Grid.Text = p256.BuildGridEnabled and "Grid: On" or "Grid: Off"
            Buttons.MoveStep.Text = "Move " .. buildFormatNumber(p256.BuildMoveStep or 0.5)
            Buttons.RotateStep.Text = "Rotate " .. buildFormatNumber(p256.BuildRotateStep or 15) .. "°"
            Buttons.Place.Text = p256.EditingExistingObject and "Save Move" or "Place"
            p256:UpdateBuildGridLabel()

            local DeleteMode = Buttons:FindFirstChild("DeleteMode")

            if DeleteMode then
                DeleteMode.Text = p256.DeletingObjects and "Delete: On" or "Delete: Off"
                styleBuildButton(DeleteMode, p256.DeletingObjects, p256.DeletingObjects and v360 or nil)
            end

            local PaintMode = Buttons:FindFirstChild("PaintMode")

            if PaintMode then
                local v482 = p256.BuildModeKind == "Paint" and p256.Painting

                PaintMode.Text = v482 and "Objects" or "Paint"
                styleBuildButton(PaintMode, v482)
            end

            local ControllerHotkeys = BuildGui:FindFirstChild("ControllerHotkeys")

            if ControllerHotkeys then
                if p256.BuildModeKind == "Objects" then
                    ControllerHotkeys.Visible = GuiService:IsTenFootInterface() or UserInputService.GamepadEnabled and (not UserInputService.KeyboardEnabled or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)
                else
                    ControllerHotkeys.Visible = false
                end

                local v483 = if v480 then "Move / Grid " .. buildFormatNumber(p256.BuildMoveStep or 0.5) else nil

                if not v480 or not v483 then
                    v483 = "Rotate " .. buildFormatNumber(p256.BuildRotateStep or 15) .. "°"
                end

                ControllerHotkeys.Text = "D-PAD  ↓ Exit  ·  → Mode  ·  ← " .. v483 .. "  ·  ↑ Paint  ·  R2 Rotate " .. buildFormatNumber(p256.BuildRotateStep or 15) .. "°"
            end

            local CameraLock = Buttons:FindFirstChild("CameraLock")

            if CameraLock then
                CameraLock.Text = p256.BuildCameraLocked and "Cam: Locked" or "Cam: Free"
                styleBuildButton(CameraLock, p256.BuildCameraLocked)
            end

            BuildGui.TransformPanel.Title.Text = v480 and "MOVE · " .. buildFormatNumber(p256.BuildMoveStep or 0.5) .. " STUD" or "ROTATE · " .. buildFormatNumber(p256.BuildRotateStep or 15) .. "°"

            if p256.BuildModeKind == "Paint" then
                if p256.TouchEnabled then
                    BuildGui.Hint.Text = p256.BuildCameraLocked and "CAMERA LOCKED · Tap to paint · Use Cam: Locked to unlock" or "Tap to paint · Camera arrows move · Drag to look · Pinch to zoom"
                elseif (not UserInputService.GamepadEnabled or UserInputService.KeyboardEnabled) and not GuiService:IsTenFootInterface() then
                    BuildGui.Hint.Text = p256.BuildCameraLocked and "CAMERA LOCKED · Click to paint · Use Cam: Locked to unlock" or "Click to paint · RMB orbit · MMB pan · Wheel/WASD/QE camera"
                elseif p256.BuildGamepadNavigation then
                    BuildGui.Hint.Text = p256.BuildCameraLocked and "CAMERA LOCKED · FREE CURSOR · A paint/select UI · L3 unlock · D-pad tools" or "CURSOR MODE · A paint/select UI · L3 lock camera · R3 camera · D-pad tools"
                else
                    BuildGui.Hint.Text = p256.BuildCameraLocked and "CAMERA LOCKED · L3 unlock · R3 cursor · D-pad tools" or "CAMERA MODE · A paint · Sticks/LB-RB camera · L3 lock · R3 cursor · D-pad tools"
                end
            elseif p256.TouchEnabled then
                if p256.DeletingObjects then
                    BuildGui.Hint.Text = p256.BuildCameraLocked and "CAMERA LOCKED · Tap object to delete · Delete: On to stop" or "Tap object to delete · Delete: On to stop · Drag empty space to look"
                elseif p256.BuildCameraLocked then
                    BuildGui.Hint.Text = p256.EditObject and "CAMERA LOCKED · Drag object · Use transform panel to move/rotate" or "CAMERA LOCKED · Hold object 0.4s to edit · Cam: Locked to unlock"
                else
                    BuildGui.Hint.Text = p256.EditObject and "Drag object · Use transform panel to move/rotate · Camera arrows move" or "Hold object 0.4s to edit · Camera arrows move · Drag empty space to look"
                end
            elseif (not UserInputService.GamepadEnabled or UserInputService.KeyboardEnabled) and not GuiService:IsTenFootInterface() then
                if p256.DeletingObjects then
                    BuildGui.Hint.Text = p256.BuildCameraLocked and "CAMERA LOCKED · Click object to delete · Delete: On to stop" or "Click object to delete · Delete: On to stop · RMB look · WASD/QE camera"
                elseif p256.BuildCameraLocked then
                    BuildGui.Hint.Text = p256.EditObject and "CAMERA LOCKED · Drag object · Transform panel · Enter to place/save" or "CAMERA LOCKED · Click object to edit · Use Cam: Locked to unlock"
                else
                    BuildGui.Hint.Text = p256.EditObject and "LMB drag + RMB look · MMB pan · Wheel forward/back · WASD/QE camera" or "Hover + click an object to edit · RMB look · MMB pan · WASD/QE camera"
                end
            elseif p256.BuildGamepadNavigation then
                BuildGui.Hint.Text = p256.BuildCameraLocked and "CAMERA LOCKED · FREE CURSOR · A select/drag/handles/UI · L3 unlock" or "CURSOR MODE · A select/drag/handles/UI · L3 lock camera · R3 camera mode"
            else
                BuildGui.Hint.Text = p256.BuildCameraLocked and "CAMERA LOCKED · A select/drag · L3 unlock · R3 cursor mode" or "CAMERA MODE · A select/drag · Sticks move/look · LB/RB forward/back · L3 lock · R3 cursor"
            end

            p256:UpdateBuildViewPanel()
        end

        p256:UpdateStorageCapacity()
    end
end

function t1.SetBuildTransformMode(p257, p258) -- line: 4886
    if p258 ~= "Move" and p258 ~= "Rotate" then
        return
    end

    p257:EndBuildTouchGizmoDrag()
    p257.BuildTransformMode = p258
    p257.BuildTransformDirty = true
    p257:UpdateBuildGui()

    if p257.EditObject then
        p257:UpdateBuildGizmo(p257:GetBuildObjectCFrame())
    end
end

function t1.CycleBuildMoveStep(p259) -- line: 4897
    -- upvalues: t21 (copy)
    local v484 = p259.BuildMoveStep or t21[3]
    local n10 = 1

    for v485, v486 in ipairs(t21) do
        if math.abs(v486 - v484) < 0.001 then
            n10 = v485 % #t21 + 1
            break
        end
    end

    p259.BuildMoveStep = t21[n10]
    p259:RebuildBuildGrid()
    p259:UpdateBuildGui()
end

function t1.CycleBuildRotateStep(p260) -- line: 4911
    -- upvalues: t22 (copy)
    local v488 = p260.BuildRotateStep or t22[2]
    local n11 = 1

    for v489, v490 in ipairs(t22) do
        if v490 == v488 then
            n11 = v489 % #t22 + 1
            break
        end
    end

    p260.BuildRotateStep = t22[n11]
    p260:UpdateBuildGui()
end

function t1.RotateBuildObjectStep(p261, p262, p263) -- line: 4924
    -- upvalues: t23 (copy)
    if not (p261.EditObject and p261.BuildObjectPosition) then
        return
    end

    local v491 = (p261.BuildRotateStep or 15) * (p263 or 1)
    local v492 = p261.BuildObjectRotation or Vector3.new(-90, 90, 0)
    local v493 = t23[p262]

    if v493 then
        local v494 = v492 or Vector3.new(-90, 90, 0)
        local v497, v498, v499 = (CFrame.Angles(math.rad(v494.X), math.rad(v494.Y), (math.rad(v494.Z))) * CFrame.fromAxisAngle(v493, (math.rad(v491)))):ToEulerAnglesXYZ()

        v492 = Vector3.new(math.deg(v497), math.deg(v498), (math.deg(v499)))
    end

    p261.BuildObjectRotation = v492
    p261:ClampBuildObjectToBounds()
    p261.BuildTransformDirty = true
end

function t1.NudgeBuildObject(p264, p265, p266) -- line: 4936
    -- upvalues: t23 (copy)
    if not p264.EditObject or not p264.BuildObjectPosition then
        return
    end

    if p264.BuildTransformMode == "Rotate" then
        p264:RotateBuildObjectStep(p265, p266)
    else
        local v503 = (p264.BuildMoveStep or 0.5) * p266
        local BuildObjectPosition = p264.BuildObjectPosition
        local v504 = p264.StorageBase and p264.StorageBase:FindFirstChild("Floor")
        local v505 = t23[p265]

        if not v504 or not v505 then
            if v505 then
                BuildObjectPosition += v505 * v503
            end
        else
            BuildObjectPosition += v504.CFrame:VectorToObjectSpace(v505).Unit * v503
        end

        p264.BuildObjectPosition = BuildObjectPosition
        p264:ClampBuildObjectToBounds()
        p264.BuildTransformDirty = true
    end
end

function t1.EndBuildTransformHold(p267, p268) -- line: 4960
    local BuildTransformHolds = p267.BuildTransformHolds

    if p268 then
        if BuildTransformHolds then
            BuildTransformHolds[p268] = nil
        end
    else
        p267.BuildTransformHolds = {}
        p267.BuildTransformHandledActivations = setmetatable({}, {
            __mode = "k"
        })
    end
end

function t1.BeginBuildTransformHold(p269, p270, p271, p272) -- line: 4970
    if not p269.BuildCameraActive or not p271 or typeof(p272) ~= "function" then
        return
    end

    p269.BuildTransformHolds = p269.BuildTransformHolds or {}
    p269.BuildTransformHandledActivations = p269.BuildTransformHandledActivations or setmetatable({}, {
        __mode = "k"
    })
    p269.BuildTransformHandledActivations[p271] = true

    if p269.BuildTransformHolds[p271] then
        return
    end

    local t31 = {
        Button = p270,
        Callback = p272
    }

    p269.BuildTransformHolds[p271] = t31
    p272()
    task.spawn(function() -- line: 4985
        -- upvalues: p269 (copy), p270 (copy), p271 (copy), p272 (copy), t31 (copy)
        task.wait(0.35)

        while p269.BuildTransformHolds and p269.BuildTransformHolds[p271] == t31 and p269.BuildCameraActive and p269.BuildGui and p269.BuildGui.Enabled and p270.Parent and p271.UserInputState ~= Enum.UserInputState.End do
            if p271.UserInputState == Enum.UserInputState.Cancel then
                break
            end

            p272()
            task.wait(0.08)
        end

        if p269.BuildTransformHolds and p269.BuildTransformHolds[p271] == t31 then
            p269.BuildTransformHolds[p271] = nil
        end
    end)
end

function t1.QuarterTurnBuildObject(p273, p274) -- line: 5010
    -- upvalues: t23 (copy)
    if not (p273.EditObject and p273.BuildObjectPosition and (p274 == "Y" or p274 == "Z")) then
        return
    end

    local v507 = p273.BuildObjectRotation or Vector3.new(-90, 90, 0)
    local v508 = t23[p274]

    if v508 then
        local v509 = v507 or Vector3.new(-90, 90, 0)
        local v512, v513, v514 = (CFrame.Angles(math.rad(v509.X), math.rad(v509.Y), (math.rad(v509.Z))) * CFrame.fromAxisAngle(v508, 1.5707963267948966)):ToEulerAnglesXYZ()

        v507 = Vector3.new(math.deg(v512), math.deg(v513), (math.deg(v514)))
    end

    p273.BuildObjectRotation = v507
    p273:ClampBuildObjectToBounds()
    p273.BuildTransformDirty = true
end

function t1.GetBuildObjectCFrame(p275) -- line: 5022
    local v518 = p275.StorageBase and p275.StorageBase:FindFirstChild("Floor")

    if v518 and p275.BuildObjectPosition then
        local v519 = p275.BuildObjectRotation or Vector3.new(-90, 90, 0)

        return v518.CFrame * CFrame.new(p275.BuildObjectPosition) * CFrame.Angles(math.rad(v519.X), math.rad(v519.Y), (math.rad(v519.Z)))
    end

    return p275.EditObject and p275.EditObject:GetPivot() or CFrame.new()
end

function t1.GetClampedBuildPosition(p276, p277, p278) -- line: 5033
    if not p276.EditObject then
        return p277
    end

    local BuildReference, BuildReference2 = p276:GetBuildReference()

    if not (BuildReference and BuildReference2) then
        return p277
    end

    p278 = p278 or p276.BuildObjectRotation or Vector3.new(-90, 90, 0)

    local v527 = BuildReference.CFrame * CFrame.new(p277) * CFrame.Angles(math.rad(p278.X), math.rad(p278.Y), (math.rad(p278.Z)))
    local Pivot = p276.EditObject:GetPivot()
    local v528 = Vector3.new(1e999, 1e999, 1e999)
    local v529 = Vector3.new((-1e999), (-1e999), (-1e999))
    local v530 = false

    for _, descendant in ipairs(p276.EditObject:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local v531 = v527 * Pivot:ToObjectSpace(descendant.CFrame)
            local v532 = descendant.Size / 2

            v530 = true

            for i = -1, 1, 2 do
                for j = -1, 1, 2 do
                    for k = -1, 1, 2 do
                        local v536 = v531 * Vector3.new(v532.X * i, v532.Y * j, v532.Z * k)
                        local v537 = BuildReference2.CFrame:PointToObjectSpace(v536)

                        v528 = Vector3.new(math.min(v528.X, v537.X), math.min(v528.Y, v537.Y), (math.min(v528.Z, v537.Z)))
                        v529 = Vector3.new(math.max(v529.X, v537.X), math.max(v529.Y, v537.Y), (math.max(v529.Z, v537.Z)))
                    end
                end

                v530 = true
            end
        end
    end

    if not v530 then
        return p277
    end

    local v544 = BuildReference2.CFrame:PointToObjectSpace(v527.Position)
    local v545 = v528 - v544
    local v546 = v529 - v544
    local v547 = BuildReference2.Size / 2 + Vector3.new(0.095, 0.095, 0.095)

    local function clampAxis(p279, p280, p281) -- line: 5080
        if p281 < p280 then
            return (p280 + p281) / 2
        end

        return (math.clamp(p279, p280, p281))
    end

    local X2 = v544.X
    local v548 = -v547.X - v545.X
    local v549 = v547.X - v546.X
    local v550 = if v549 < v548 then (v548 + v549) / 2 else math.clamp(X2, v548, v549)
    local Y2 = v544.Y
    local v551 = -v547.Y - v545.Y
    local v552 = v547.Y - v546.Y
    local v553 = if v552 < v551 then (v551 + v552) / 2 else math.clamp(Y2, v551, v552)
    local Z2 = v544.Z
    local v554 = -v547.Z - v545.Z
    local v555 = v547.Z - v546.Z
    local v557 = Vector3.new(v550, v553, if v555 < v554 then (v554 + v555) / 2 else math.clamp(Z2, v554, v555))
    local v558 = BuildReference2.CFrame:PointToWorldSpace(v557)

    return BuildReference.CFrame:PointToObjectSpace(v558)
end

function t1.ClampBuildObjectToBounds(p282) -- line: 5093
    if p282.BuildObjectPosition then
        p282.BuildObjectPosition = p282:GetClampedBuildPosition(p282.BuildObjectPosition, p282.BuildObjectRotation)
    end
end

function t1.ResetBuildObjectTransform(p283) -- line: 5101
    if p283.EditObject then
        local BuildReference, BuildReference2 = p283:GetBuildReference()

        if BuildReference and BuildReference2 then
            local v559, v560, v561 = p283.EditObject:GetPivot():ToEulerAnglesXYZ()

            p283.BuildObjectRotation = Vector3.new(math.deg(v559), math.deg(v560), (math.deg(v561)))

            local v565 = p283.BuildFocus or BuildReference2.Position
            local CurrentCamera = workspace.CurrentCamera
            local v566 = v565

            if CurrentCamera then
                local v567 = CurrentCamera:ViewportPointToRay(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
                local t32 = {
                    p283.EditObject,
                    BuildReference2
                }

                if p283.Character then
                    table.insert(t32, p283.Character)
                end

                if p283.BuildGrid then
                    table.insert(t32, p283.BuildGrid)
                end

                local v568 = RaycastParams.new()

                v568.FilterType = Enum.RaycastFilterType.Exclude
                v568.FilterDescendantsInstances = t32

                local v569 = workspace:Raycast(v567.Origin, v567.Direction * 4096, v568)

                if v569 then
                    local v570 = BuildReference2.CFrame:PointToObjectSpace(v569.Position)
                    local v571 = BuildReference2.Size / 2 + Vector3.new(0.05, 0.05, 0.05)

                    if math.abs(v570.X) <= v571.X and math.abs(v570.Y) <= v571.Y and math.abs(v570.Z) <= v571.Z then
                        v566 = v569.Position
                    end
                end
            end

            local v572 = p283.BuildMoveStep or 0.5
            local v573 = BuildReference.CFrame:PointToObjectSpace(v566)
            local X = v573.X

            if v572 and not (v572 <= 0) then
                X = math.round(X / v572) * v572
            end

            local Y = v573.Y

            if v572 and not (v572 <= 0) then
                Y = math.round(Y / v572) * v572
            end

            local Z = v573.Z

            if v572 and not (v572 <= 0) then
                Z = math.round(Z / v572) * v572
            end

            p283.BuildObjectPosition = Vector3.new(X, Y, Z)
            p283.EditObject:PivotTo(p283:GetBuildObjectCFrame())

            local n12 = 1e999

            for _, descendant in ipairs(p283.EditObject:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    local v577 = descendant.Size / 2

                    for i = -1, 1, 2 do
                        for j = -1, 1, 2 do
                            for k = -1, 1, 2 do
                                local v581 = descendant.CFrame * Vector3.new(v577.X * i, v577.Y * j, v577.Z * k)

                                n12 = math.min(n12, BuildReference.CFrame:PointToObjectSpace(v581).Y)
                            end
                        end
                    end
                end
            end

            if n12 < 1e999 then
                p283.BuildObjectPosition = p283.BuildObjectPosition + Vector3.new(0, v573.Y - n12, 0)
            end

            p283:ClampBuildObjectToBounds()
            p283.BuildTransformDirty = true
        end
    end
end

function t1.IsBuildObjectInBounds(p284, p285) -- line: 5167
    local _, BuildReference = p284:GetBuildReference()

    if BuildReference then
        local v583 = BuildReference.Size / 2 + Vector3.new(0.1, 0.1, 0.1)

        for _, descendant in ipairs(p285:GetDescendants()) do
            if descendant:IsA("BasePart") then
                local v584 = descendant.Size / 2

                for i = -1, 1, 2 do
                    for j = -1, 1, 2 do
                        for k = -1, 1, 2 do
                            local v588 = descendant.CFrame * Vector3.new(v584.X * i, v584.Y * j, v584.Z * k)
                            local v589 = BuildReference.CFrame:PointToObjectSpace(v588)

                            if math.abs(v589.X) > v583.X or math.abs(v589.Y) > v583.Y or math.abs(v589.Z) > v583.Z then
                                return false
                            end
                        end
                    end
                end
            end
        end
    end

    return true
end

function t1.HasBuildObjectAtCFrame(p286, p287) -- line: 5190
    local v590 = p286.StorageBase and p286.StorageBase:FindFirstChild("Floor")
    local v591 = p286.StorageBase and p286.StorageBase:FindFirstChild("Contents")
    local Objects = v591 and v591:FindFirstChild("Objects")

    if v590 and Objects then
        local v593 = tostring(v590.CFrame:Inverse() * p287)

        for _, child in ipairs(Objects:GetChildren()) do
            if child ~= p286.EditingExistingObject and (child:IsA("Model") or child:IsA("BasePart")) and tostring(v590.CFrame:Inverse() * child:GetPivot()) == v593 then
                return true
            end
        end

        return false
    end

    return false
end

function t1.ValidateBuildObject(p288) -- line: 5208
    -- upvalues: BaseObjectsLib (copy)
    if not p288.EditObject then
        return false, "Select an object first."
    end

    if p288.ModernMobile and p288.ModernMobile:IsActive() and not p288.EditingExistingObject then
        local v595 = BaseObjectsLib[p288.EditObject.Name]

        if not v595 then
            return false, "This object is unavailable."
        end

        local v596 = p288.Data or {}

        if v595.Unlock and not (v596.UnlockedObjects or {})[p288.EditObject.Name] then
            return false, "Unlock this object first."
        end

        if v595.ItemObject then
            if (tonumber((v596.BaseItems or {})[p288.EditObject.Name]) or 0) < 1 then
                return false, "No more of this item in inventory."
            end
        elseif (tonumber(v596.Money) or 0) < (tonumber(v595.Price) or 0) then
            return false, "Not enough money."
        end

        if p288:GetStorageCapacity() + (v595.Capacity or 1) > p288:GetStorageCapacityLimit() then
            return false, "Your base is full."
        end
    end

    local BuildObjectCFrame = p288:GetBuildObjectCFrame()

    p288.EditObject:PivotTo(BuildObjectCFrame)

    if not p288:IsBuildObjectInBounds(p288.EditObject) then
        return false, "The object must stay inside your base."
    end

    if p288:HasBuildObjectAtCFrame(BuildObjectCFrame) then
        return false, "Another object already uses this exact position."
    end

    return true
end

function t1.FindNearestValidBuildTransform(p289) -- line: 5231
    if not p289.EditObject or not p289.BuildObjectPosition then
        return false
    end

    local BuildObjectPosition, BuildObjectRotation = p289.BuildObjectPosition, p289.BuildObjectRotation
    local v600 = math.max(p289.BuildMoveStep or 0.5, 0.05)

    for i = 1, 4 do
        for j = -i, i do
            for k = -i, i do
                if math.abs(j) == i or math.abs(k) == i then
                    p289.BuildObjectPosition = p289:GetClampedBuildPosition(BuildObjectPosition + Vector3.new(j * v600, 0, k * v600), BuildObjectRotation)
                    p289.BuildObjectRotation = BuildObjectRotation

                    if p289:ValidateBuildObject() then
                        return true
                    end
                end
            end
        end
    end

    p289.BuildObjectPosition = BuildObjectPosition
    p289.BuildObjectRotation = BuildObjectRotation
    p289.EditObject:PivotTo(p289:GetBuildObjectCFrame())

    return false
end

function t1.RefreshBuildValidation(p290, p291) -- line: 5259
    -- upvalues: v358 (copy), v359 (copy), v360 (copy)
    if p290.EditObject then
        local elapsed = os.clock()

        if not p291 and not p290.BuildTransformDirty and elapsed - (p290.BuildValidationAt or 0) < 0.2 then
            return
        end

        p290.BuildValidationAt = elapsed
        p290.BuildTransformDirty = false

        local v603, v604 = p290:ValidateBuildObject()
        local v605 = v604
        local v606 = v603

        if not v603 and (not p290.ModernMobile or not p290.ModernMobile:IsActive()) then
            local v607

            if p290.BuildLastValidPosition and p290.BuildLastValidRotation then
                p290.BuildObjectPosition = p290.BuildLastValidPosition
                p290.BuildObjectRotation = p290.BuildLastValidRotation
                v607, v605 = p290:ValidateBuildObject()
                v606 = v607

                if not v607 then
                    p290.BuildLastValidPosition = nil
                    p290.BuildLastValidRotation = nil
                end
            else
                v607 = false
            end

            if not v607 and v605 == "Another object already uses this exact position." and p290:FindNearestValidBuildTransform() then
                v606 = true
                v605 = nil
            end
        end

        if v606 then
            p290.BuildLastValidPosition = p290.BuildObjectPosition
            p290.BuildLastValidRotation = p290.BuildObjectRotation
        end

        p290.BuildPlacementValid = v606
        p290.BuildInvalidReason = v605

        local Highlight = p290.EditObject:FindFirstChildOfClass("Highlight")

        if Highlight then
            Highlight.FillColor = v606 and Color3.fromRGB(255, 226, 137) or v360

            local v608 = if v606 then Color3.fromRGB(255, 228, 120) else nil

            Highlight.OutlineColor = if not v606 or not v608 then v360 else v608
        end

        if not p290.BuildGui then
            return
        end

        local Place = p290.BuildGui.Toolbar.Buttons.Place
        local v609 = v606 and v359 or v360

        Place.BackgroundColor3 = v358
        Place.BackgroundTransparency = 0.5
        Place.BorderColor3 = Color3.new(1, 1, 1)
        Place.BorderSizePixel = 1

        if Place:IsA("TextButton") then
            Place.TextColor3 = v609 or Color3.new(1, 1, 1)
        end
    end
end

function t1.AttemptPlaceBuildObject(p292) -- line: 5303
    if not p292.EditObject then
        p292:Noti({
            Title = "Build Mode",
            Text = "Select an object to place first.",
            Duration = 2
        })

        return
    end

    if not (os.clock() - (p292.BuildPlaceAt or 0) < 0.2) then
        p292.BuildPlaceAt = os.clock()
        p292:RefreshBuildValidation(true)

        local BuildPlacementValid, BuildInvalidReason = p292.BuildPlacementValid, p292.BuildInvalidReason

        if BuildPlacementValid then
            p292:PlaceBaseObject(p292:GetBuildObjectCFrame(), false)
        else
            p292:Noti({
                Title = "Can't Place",
                Duration = 2,
                Text = BuildInvalidReason or "That position is not valid."
            })
        end
    end
end

function t1.HideBuildGizmos(p293) -- line: 5319
    if p293.BuildGui then
        for _, v610 in ipairs({ "MoveX", "MoveY", "MoveZ", "RotateX", "RotateY", "RotateZ" }) do
            local v611 = p293.BuildGui:FindFirstChild(v610)

            if v611 then
                v611.Visible = false
                v611.Adornee = nil
            end
        end
    end
end

function t1.UpdateBuildGizmo(p294, p295) -- line: 5330
    if not (p294.ModernController and p294.ModernController:IsGamepad()) then
        if p294.TouchEnabled then
            p294:EndBuildTouchGizmoDrag()
        elseif p294.BuildCameraActive and p294.BuildGui and p294.EditObject then
            if not p294.BuildGizmoPart then
                local Part = Instance.new("Part")

                Part.Name = "BuildGizmoAdornee"
                Part.Anchored = true
                Part.CanCollide = false
                Part.CanTouch = false
                Part.CanQuery = false
                Part.Transparency = 1
                Part.Parent = workspace.CurrentCamera
                p294.BuildGizmoPart = Part
            end

            local ExtentsSize = p294.EditObject:GetExtentsSize()

            p294.BuildGizmoPart.Size = Vector3.new(math.max(ExtentsSize.X, 0.5), math.max(ExtentsSize.Y, 0.5), (math.max(ExtentsSize.Z, 0.5)))

            if p294.BuildTransformMode == "Move" then
                p294.BuildGizmoPart.CFrame = CFrame.new(p295.Position)
            else
                p294.BuildGizmoPart.CFrame = p295
            end

            for _, v615 in ipairs({ "MoveX", "MoveY", "MoveZ", "RotateX", "RotateY", "RotateZ" }) do
                local v616 = p294.BuildGui:FindFirstChild(v615)

                if v616 then
                    v616.Adornee = p294.BuildGizmoPart

                    if p294.BuildTransformMode == "Move" and string.sub(v615, 1, 4) == "Move" then
                        v616.Visible = true
                    elseif p294.BuildTransformMode == "Rotate" then
                        v616.Visible = string.sub(v615, 1, 6) == "Rotate"
                    else
                        v616.Visible = false
                    end
                end
            end

            return
        end
    end

    p294:HideBuildGizmos()
end

function t1.GetBuildTouchGizmoHit(p296, p297) -- line: 5374
    -- upvalues: t23 (copy), t24 (copy), buildConvexHull (copy), buildPointInConvexPolygon (copy), buildRayConvexPolygonExit (copy)
    if typeof(p297) ~= "Vector2" or not p296.BuildCameraActive or not p296.EditObject or not p296.BuildGui or not p296.BuildGizmoPart then
        return nil
    end

    local BuildTransformMode = p296.BuildTransformMode

    if BuildTransformMode ~= "Move" and BuildTransformMode ~= "Rotate" then
        return nil
    end

    local CurrentCamera = workspace.CurrentCamera
    local BuildGizmoPart = p296.BuildGizmoPart
    local BuildGizmoPartPosition = BuildGizmoPart.Position
    local v617 = CurrentCamera:WorldToViewportPoint(BuildGizmoPartPosition)
    local v618 = if v617.Z <= 0 then nil else Vector2.new(v617.X, v617.Y)
    local v619 = (BuildGizmoPartPosition - CurrentCamera.CFrame.Position):Dot(CurrentCamera.CFrame.LookVector)
    local v620

    if not (v619 <= 0) then
        local v621 = math.max(CurrentCamera.ViewportSize.Y, 1)

        v620 = 2 * v619 * math.tan(math.rad(CurrentCamera.FieldOfView) * 0.5) / v621
    end

    if not (v618 and v620) then
        return nil
    end

    local ViewportSize = CurrentCamera.ViewportSize
    local v625 = math.clamp(math.min(ViewportSize.X, ViewportSize.Y) * 0.035, 26, 42)

    if (BuildTransformMode == "Rotate" and v625 * 0.75 or v625 * 0.55) > (p297 - v618).Magnitude then
        return nil
    end

    if BuildTransformMode == "Move" then
        local t33 = {}
        local v626 = BuildGizmoPart.Size * 0.5

        for i = -1, 1, 2 do
            for j = -1, 1, 2 do
                for k = -1, 1, 2 do
                    local v630 = CurrentCamera:WorldToViewportPoint(BuildGizmoPart.CFrame * Vector3.new(v626.X * i, v626.Y * j, v626.Z * k))
                    local v631 = if v630.Z <= 0 then nil else Vector2.new(v630.X, v630.Y)

                    if v631 then
                        table.insert(t33, v631)
                    end
                end
            end
        end

        local v632 = buildConvexHull(t33)

        if not v632 or buildPointInConvexPolygon(p297, v632) then
            return nil
        end

        local v633 = math.min(ViewportSize.X, ViewportSize.Y)
        local v635 = math.clamp(v633 * 0.03, 11, 16)
        local v637 = math.clamp(v633 * 0.06, 20, 28)
        local v639 = math.clamp(v633 * 0.2, 58, 82)
        local v641 = math.max(v620 * 48, 0.25)
        local v642, v643, v644, v645

        for _, v646 in ipairs({ "X", "Y", "Z" }) do
            local v647 = t23[v646]
            local v648 = p296.BuildGui:FindFirstChild("Move" .. v646)

            if v648 and v648.Visible then
                local Unit = BuildGizmoPart.CFrame:VectorToWorldSpace(v647).Unit

                for _, v653 in ipairs({ -1, 1 }) do
                    local v654 = CurrentCamera:WorldToViewportPoint(BuildGizmoPartPosition + Unit * v653 * v641)
                    local v655 = if v654.Z <= 0 then nil else Vector2.new(v654.X, v654.Y)
                    local v656 = v655 and v655 - v618

                    if v656 and v656.Magnitude >= 3 then
                        local Unit2 = v656.Unit
                        local v657 = buildRayConvexPolygonExit(v618, Unit2, v632)

                        if v657 then
                            local v658 = v618 + Unit2 * (v657 + 4)
                            local v659 = v618 + Unit2 * (v657 + v639)
                            local t34 = {
                                Mode = "Move",
                                Axis = v646,
                                AxisLocal = v647,
                                AxisWorld = Unit,
                                Center = BuildGizmoPartPosition,
                                ScreenDirection = Unit2 * v653,
                                PixelsPerStud = v656.Magnitude / v641
                            }
                            local v660 = (p297 - v659).Magnitude / v637

                            if v660 <= 1 and (not v643 or v660 < v643) then
                                v643 = v660
                                v642 = t34
                            end

                            local v661 = v659 - v658
                            local v662 = v661:Dot(v661)
                            local v664 = (if v662 <= 1E-04 then (p297 - v658).Magnitude else (p297 - (v658 + v661 * math.clamp((p297 - v658):Dot(v661) / v662, 0, 1))).Magnitude) / v635

                            if v664 <= 1 and (not v645 or v664 < v645) then
                                v645 = v664
                                v644 = t34
                            end
                        end
                    end
                end
            end
        end

        return v642 or v644
    end

    local v665, v666

    for v667, v668 in pairs(t23) do
        local v669 = p296.BuildGui:FindFirstChild("Rotate" .. v667)

        if v669 and v669.Visible then
            local v670 = t24[v667]
            local Unit = BuildGizmoPart.CFrame:VectorToWorldSpace(v668).Unit
            local Unit2 = BuildGizmoPart.CFrame:VectorToWorldSpace(v670[1]).Unit
            local Unit3 = BuildGizmoPart.CFrame:VectorToWorldSpace(v670[2]).Unit
            local Size = BuildGizmoPart.Size
            local v671 = if v667 == "X" then math.max(Size.Y, Size.Z) elseif v667 == "Y" then math.max(Size.Z, Size.X) else math.max(Size.X, Size.Y)
            local v672 = v671 * 0.5 + v620 * 20
            local v673

            for n = 0, 40 do
                local v674 = 6.283185307179586 * n / 40
                local v675 = CurrentCamera:WorldToViewportPoint(BuildGizmoPartPosition + (Unit2 * math.cos(v674) + Unit3 * math.sin(v674)) * v672)
                local v676 = if v675.Z <= 0 then nil else Vector2.new(v675.X, v675.Y)
                local v677 = v666
                local v678 = v665

                if v676 and v673 then
                    local v679 = v676 - v673
                    local v680 = v679:Dot(v679)
                    local Magnitude = if v680 <= 1E-04 then (p297 - v673).Magnitude else (p297 - (v673 + v679 * math.clamp((p297 - v673):Dot(v679) / v680, 0, 1))).Magnitude

                    if Magnitude <= v625 and (not v666 or Magnitude < v666) then
                        v677 = Magnitude
                        v678 = {
                            Mode = "Rotate",
                            Axis = v667,
                            AxisLocal = v668,
                            AxisWorld = Unit,
                            Center = BuildGizmoPartPosition
                        }
                    end
                end

                v673 = v676
                v665 = v678
                v666 = v677
            end
        end
    end

    return v665
end

function t1.BeginBuildTouchGizmoDrag(p298, p299, p300) -- line: 5539
    if p298.TouchEnabled
        or p298.BuildTouchGizmo
        or not p298.BuildCameraActive
        or not p298.EditObject
        or not p298.BuildObjectPosition
        or not p300 then
        return false
    end

    local BuildTouchGizmoHit = p298:GetBuildTouchGizmoHit(p299)

    if not BuildTouchGizmoHit then
        return false
    end

    p298:EndDirectBuildDrag()
    p298.BuildDragStartPosition = nil
    p298.BuildDragStartRotation = nil
    p298.BuildTouchGizmo = {
        RawDistance = 0,
        RawAngle = 0,
        Input = p300,
        Mode = BuildTouchGizmoHit.Mode,
        Axis = BuildTouchGizmoHit.Axis,
        AxisLocal = BuildTouchGizmoHit.AxisLocal,
        AxisWorld = BuildTouchGizmoHit.AxisWorld,
        LastScreen = p299,
        StartPosition = p298.BuildObjectPosition,
        StartRotation = p298.BuildObjectRotation or Vector3.new(-90, 90, 0),
        ScreenDirection = BuildTouchGizmoHit.ScreenDirection,
        PixelsPerStud = BuildTouchGizmoHit.PixelsPerStud
    }
    p298.BuildGizmoDragging = true

    return true
end

function t1.UpdateBuildTouchGizmoDrag(p301, p302, p303) -- line: 5573
    -- upvalues: t23 (copy), buildRayPlaneIntersection (copy)
    local BuildTouchGizmo = p301.BuildTouchGizmo

    if not BuildTouchGizmo or BuildTouchGizmo.Input ~= p302 or typeof(p303) ~= "Vector2" or not p301.EditObject or not p301.BuildObjectPosition then
        return
    end

    local LastScreen = BuildTouchGizmo.LastScreen

    BuildTouchGizmo.LastScreen = p303

    if not LastScreen then
        return
    end

    local CurrentCamera = workspace.CurrentCamera

    if BuildTouchGizmo.Mode == "Move" then
        local v683 = p301.StorageBase and p301.StorageBase:FindFirstChild("Floor")

        if not v683 then
            return
        end

        local Unit = BuildTouchGizmo.AxisWorld.Unit
        local Unit2 = v683.CFrame:VectorToObjectSpace(Unit).Unit
        local ScreenDirection, PixelsPerStud = BuildTouchGizmo.ScreenDirection, BuildTouchGizmo.PixelsPerStud
        local Position = p301:GetBuildObjectCFrame().Position
        local v684 = CurrentCamera:WorldToViewportPoint(Position)
        local v685 = if v684.Z <= 0 then nil else Vector2.new(v684.X, v684.Y)
        local v686 = (Position - CurrentCamera.CFrame.Position):Dot(CurrentCamera.CFrame.LookVector)
        local v687

        if not (v686 <= 0) then
            local v688 = math.max(CurrentCamera.ViewportSize.Y, 1)

            v687 = 2 * v686 * math.tan(math.rad(CurrentCamera.FieldOfView) * 0.5) / v688
        end

        local Unit3 = ScreenDirection
        local v691 = PixelsPerStud

        if v685 and v687 then
            local v693 = math.max(v687 * 48, 0.25)
            local v694 = CurrentCamera:WorldToViewportPoint(Position + Unit * v693)
            local v695 = if v694.Z <= 0 then nil else Vector2.new(v694.X, v694.Y)
            local v696 = v695 and v695 - v685

            if v696 and v696.Magnitude >= 3 then
                Unit3 = v696.Unit
                v691 = v696.Magnitude / v693
                BuildTouchGizmo.ScreenDirection = Unit3
                BuildTouchGizmo.PixelsPerStud = v691
            end
        end

        if typeof(Unit3) ~= "Vector2" or not v691 or v691 <= 1E-04 then
            return
        end

        local v697 = p303 - LastScreen

        BuildTouchGizmo.RawDistance += v697:Dot(Unit3) / v691

        local RawDistance = BuildTouchGizmo.RawDistance
        local v698 = p301.BuildMoveStep or 0.5

        if v698 and not (v698 <= 0) then
            RawDistance = math.round(RawDistance / v698) * v698
        end

        p301.BuildObjectPosition = p301:GetClampedBuildPosition(BuildTouchGizmo.StartPosition + Unit2 * RawDistance, p301.BuildObjectRotation)
    else
        local Position = p301:GetBuildObjectCFrame().Position
        local v700 = buildRayPlaneIntersection(CurrentCamera, LastScreen, Position, BuildTouchGizmo.AxisWorld)
        local v701 = buildRayPlaneIntersection(CurrentCamera, p303, Position, BuildTouchGizmo.AxisWorld)

        if not v700 or not v701 then
            return
        end

        local v702 = v700 - Position
        local v703 = v701 - Position

        if v702.Magnitude < 0.001 or v703.Magnitude < 0.001 then
            return
        end

        local Unit = v702.Unit
        local Unit2 = v703.Unit
        local v704 = BuildTouchGizmo.AxisWorld:Dot(Unit:Cross(Unit2))
        local v706 = math.clamp(Unit:Dot(Unit2), -1, 1)

        BuildTouchGizmo.RawAngle += math.atan2(v704, v706)

        local v707 = math.deg(BuildTouchGizmo.RawAngle)
        local v708 = p301.BuildRotateStep or 15

        if v708 and not (v708 <= 0) then
            v707 = math.round(v707 / v708) * v708
        end

        local StartRotation = BuildTouchGizmo.StartRotation
        local v710 = t23[BuildTouchGizmo.Axis]

        if v710 then
            local v711 = StartRotation or Vector3.new(-90, 90, 0)
            local v714, v715, v716 = (CFrame.Angles(math.rad(v711.X), math.rad(v711.Y), (math.rad(v711.Z))) * CFrame.fromAxisAngle(v710, (math.rad(v707)))):ToEulerAnglesXYZ()

            StartRotation = Vector3.new(math.deg(v714), math.deg(v715), (math.deg(v716)))
        end

        p301.BuildObjectRotation = StartRotation
        p301:ClampBuildObjectToBounds()
    end

    p301.EditObject:PivotTo(p301:GetBuildObjectCFrame())
    p301:UpdateBuildGizmo(p301:GetBuildObjectCFrame())
    p301.BuildTransformDirty = true
end

function t1.EndBuildTouchGizmoDrag(p304, p305) -- line: 5668
    local BuildTouchGizmo = p304.BuildTouchGizmo

    if not BuildTouchGizmo or p305 and BuildTouchGizmo.Input ~= p305 then
        return false
    end

    p304.BuildTouchGizmo = nil
    p304.BuildGizmoDragging = nil

    return true
end

function t1.SetBuildView(p306, p307) -- line: 5676
    if p306.BuildCameraActive then
        local BuildReference, BuildReference2 = p306:GetBuildReference()

        if BuildReference and BuildReference2 then
            p306.BuildViewPreset = p307
            p306.BuildFocus = BuildReference2.Position
            p306.BuildDistance = math.max(BuildReference2.Size.X, BuildReference2.Size.Y, BuildReference2.Size.Z) * 1.15

            if p307 == "Top" then
                p306.BuildCameraYaw = 0
                p306.BuildCameraPitch = -1.5533430342749532
            elseif p307 == "Front" then
                p306.BuildCameraYaw = 3.141592653589793
                p306.BuildCameraPitch = 0
            elseif p307 == "Back" then
                p306.BuildCameraYaw = 0
                p306.BuildCameraPitch = 0
            elseif p307 == "Left" then
                p306.BuildCameraYaw = -1.5707963267948966
                p306.BuildCameraPitch = 0
            elseif p307 == "Right" then
                p306.BuildCameraYaw = 1.5707963267948966
                p306.BuildCameraPitch = 0
            else
                p306.BuildCameraYaw = -0.6981317007977318
                p306.BuildCameraPitch = -0.5585053606381855
            end

            local v720 = BuildReference.CFrame.Rotation * CFrame.fromEulerAnglesYXZ(p306.BuildCameraPitch, p306.BuildCameraYaw, 0)

            p306.BuildCameraPosition = p306:ClampBuildCameraPosition(p306.BuildFocus + v720:VectorToWorldSpace((Vector3.new(0, 0, p306.BuildDistance))))
        end
    end
end

function t1.PanBuildCameraPixels(p308, p309) -- line: 5713
    if p308.BuildCameraLocked then
        return
    end

    local CurrentCamera = workspace.CurrentCamera
    local v722 = math.max(p308.BuildDistance or 20, 5) * 0.0022
    local v723 = (-CurrentCamera.CFrame.RightVector * p309.X + CurrentCamera.CFrame.UpVector * p309.Y) * v722
    local v724 = p308.BuildCameraPosition or CurrentCamera.CFrame.Position
    local v725 = p308:ClampBuildCameraPosition(v724 + v723)

    p308.BuildCameraPosition = v725
    p308.BuildFocus += v725 - v724
end

function t1.UpdateBuildCameraCFrame(p310) -- line: 5724
    if p310.BuildCameraActive then
        local BuildReference, BuildReference2 = p310:GetBuildReference()

        if BuildReference and BuildReference2 then
            local v726 = BuildReference.CFrame.Rotation * CFrame.fromEulerAnglesYXZ(p310.BuildCameraPitch or -0.5585053606381855, p310.BuildCameraYaw or -0.6981317007977318, 0)
            local CurrentCamera = workspace.CurrentCamera
            local BuildCameraPosition = p310.BuildCameraPosition

            if not BuildCameraPosition then
                BuildCameraPosition = p310.BuildFocus + v726:VectorToWorldSpace((Vector3.new(0, 0, p310.BuildDistance)))
            end

            local v727 = p310:ClampBuildCameraPosition(BuildCameraPosition)

            p310.BuildCameraPosition = v727
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            CurrentCamera.CFrame = CFrame.new(v727) * v726
            p310.BuildFocus = v727 + CurrentCamera.CFrame.LookVector * p310.BuildDistance
        end
    end
end

local function findBuildMobileCameraControls(p311) -- line: 5743
    return if p311 then p311:FindFirstChild("MobileCameraContols") or p311:FindFirstChild("MobileCameraControls") else nil
end

function t1.UpdateBuildViewPanel(p312) -- line: 5749
    -- upvalues: v358 (copy)
    local BuildGui = p312.BuildGui
    local ViewPanel = BuildGui and BuildGui:FindFirstChild("ViewPanel")

    if not ViewPanel then
        return
    end

    local Title = ViewPanel:FindFirstChild("Title")
    local Views = ViewPanel:FindFirstChild("Views")
    local UIStroke = ViewPanel:FindFirstChildOfClass("UIStroke")
    local CollapseButton = ViewPanel:FindFirstChild("CollapseButton")
    local BuildViewPanelExpandedState = p312.BuildViewPanelExpandedState

    if not BuildViewPanelExpandedState or BuildViewPanelExpandedState.Panel ~= ViewPanel then
        BuildViewPanelExpandedState = {
            Panel = ViewPanel
        }
        BuildViewPanelExpandedState.BackgroundTransparency = ViewPanel.BackgroundTransparency
        BuildViewPanelExpandedState.StrokeEnabled = UIStroke and UIStroke.Enabled
        BuildViewPanelExpandedState.TitleVisible = Title and Title.Visible
        BuildViewPanelExpandedState.ViewsVisible = Views and Views.Visible
        p312.BuildViewPanelExpandedState = BuildViewPanelExpandedState
    end

    local v728 = p312.BuildViewPanelCollapsed == true

    if v728 then
        ViewPanel.BackgroundTransparency = 1
    else
        ViewPanel.BackgroundTransparency = BuildViewPanelExpandedState.BackgroundTransparency
    end

    if UIStroke then
        UIStroke.Enabled = not v728 and BuildViewPanelExpandedState.StrokeEnabled
    end

    if Title then
        Title.Visible = not v728 and BuildViewPanelExpandedState.TitleVisible
    end

    if Views then
        Views.Visible = not v728 and BuildViewPanelExpandedState.ViewsVisible
    end

    if CollapseButton and CollapseButton:IsA("GuiButton") then
        CollapseButton.Text = v728 and "<" or ">"
        CollapseButton.BackgroundColor3 = v358
        CollapseButton.BackgroundTransparency = 0.5
        CollapseButton.BorderColor3 = Color3.new(1, 1, 1)
        CollapseButton.BorderSizePixel = v728 and 3 or 1

        if CollapseButton:IsA("TextButton") then
            CollapseButton.TextColor3 = Color3.new(1, 1, 1)
        end

        CollapseButton:SetAttribute("Collapsed", v728)
    end

    ViewPanel:SetAttribute("Collapsed", v728)
end

function t1.ToggleBuildViewPanel(p313) -- line: 5789
    p313.BuildViewPanelCollapsed = not p313.BuildViewPanelCollapsed
    p313:UpdateBuildViewPanel()
end

function t1.UpdateBuildMobileCameraControlsVisibility(p314, p315) -- line: 5794
    local BuildGui = p314.BuildGui
    local v729 = if BuildGui then BuildGui:FindFirstChild("MobileCameraContols") or BuildGui:FindFirstChild("MobileCameraControls") else nil

    if v729 then
        if p315 == true and p314.BuildCameraActive == true then
            v729.Visible = p314.TouchEnabled == true
        else
            v729.Visible = false
        end
    end
end

function t1.BeginBuildMobileCameraInput(p316, p317, p318, p319) -- line: 5802
    -- upvalues: v358 (copy)
    local v730

    if not p316.BuildCameraActive or p316.BuildCameraLocked then
        return
    else
        p316:EndBuildMobileCameraInput(p317)
        v730 = p316.BuildMobileCameraInputs or {}
    end

    p316.BuildMobileCameraInputs = v730
    p316.BuildMobileCameraInputs[p317] = {
        Button = p318,
        Direction = p319
    }

    if p318 and p318.Parent then
        p318.BackgroundColor3 = v358
        p318.BackgroundTransparency = 0.5
        p318.BorderColor3 = Color3.new(1, 1, 1)
        p318.BorderSizePixel = 3

        if p318:IsA("TextButton") then
            p318.TextColor3 = Color3.new(1, 1, 1)
        end
    end

    p316.BuildViewPreset = nil
end

function t1.EndBuildMobileCameraInput(p320, p321) -- line: 5816
    -- upvalues: v358 (copy)
    local BuildMobileCameraInputs = p320.BuildMobileCameraInputs
    local v732 = BuildMobileCameraInputs and BuildMobileCameraInputs[p321]

    if not v732 then
        return
    end

    BuildMobileCameraInputs[p321] = nil

    local Button = v732.Button

    if Button and Button.Parent then
        local v733 = false

        for _, v734 in pairs(BuildMobileCameraInputs) do
            if v734.Button == Button then
                v733 = true
                break
            end
        end

        if not v733 then
            Button.BackgroundColor3 = v358
            Button.BackgroundTransparency = 0.5
            Button.BorderColor3 = Color3.new(1, 1, 1)
            Button.BorderSizePixel = 1

            if Button:IsA("TextButton") then
                Button.TextColor3 = Color3.new(1, 1, 1)
            end
        end
    end
end

function t1.ClearBuildMobileCameraInputs(p322) -- line: 5837
    -- upvalues: v358 (copy)
    local BuildMobileCameraInputs = p322.BuildMobileCameraInputs

    if BuildMobileCameraInputs then
        for _, v735 in pairs(BuildMobileCameraInputs) do
            local Button = v735.Button

            if Button and Button.Parent then
                Button.BackgroundColor3 = v358
                Button.BackgroundTransparency = 0.5
                Button.BorderColor3 = Color3.new(1, 1, 1)
                Button.BorderSizePixel = 1

                if Button:IsA("TextButton") then
                    Button.TextColor3 = Color3.new(1, 1, 1)
                end
            end
        end
    end

    p322.BuildMobileCameraInputs = {}
end

function t1.StepBuildCamera(p323, p324) -- line: 5850
    -- upvalues: UserInputService (copy), GuiService (copy), GamepadService (copy)
    if (not p323.ModernMobile or not p323.ModernMobile:StepCamera(p324)) and (not p323.ModernController or not p323.ModernController:StepCamera(p324)) and p323.BuildCameraActive and not p323.DeleteAllConfirmOpen and not p323.PaintResetConfirmOpen and not GuiService.MenuIsOpen then
        local BuildReference, BuildReference2 = p323:GetBuildReference()
        local v736 = false
        local v737 = false
        local v738 = false
        local v739 = false
        local v740 = false

        if BuildReference then
            v736 = true
        else
            v740 = true
        end

        if v736 then
            if BuildReference2 then
                v737 = true
            else
                v740 = true
            end
        end

        v736 = false

        local BuildPendingGamepadGrab

        if v737 then
            BuildPendingGamepadGrab = p323.BuildPendingGamepadGrab

            if BuildPendingGamepadGrab then
                v736 = true
            else
                v740 = false
            end
        end

        v737 = false

        local Input, v741

        if v736 then
            p323.BuildPendingGamepadGrab = nil
            Input = BuildPendingGamepadGrab.Input

            if Input then
                v737 = true
            else
                v741 = Input
                v738 = true
            end
        end

        v736 = false

        if v737 then
            v741 = Input.UserInputState
            v738 = true
        end

        v737 = false

        local v742

        if v738 then
            local BuildGizmoDragging = p323.BuildGizmoDragging

            if BuildGizmoDragging then
                v737 = true
            else
                v742 = BuildGizmoDragging
                v736 = true
            end
        end

        v738 = false

        if v737 then
            if os.clock() - (p323.BuildGizmoActivatedAt or 0) < 0.15 then
                v739 = true
            else
                v738 = true
            end
        end

        v737 = false

        if v738 then
            v742 = false
            v736 = true
        end

        v738 = false

        if v739 then
            v742 = true
            v736 = true
        end

        v739 = false

        local v743

        if v736 then
            local BuildTransformHolds = p323.BuildTransformHolds

            if BuildTransformHolds then
                v739 = true
            else
                v743 = BuildTransformHolds
                v738 = true
            end
        end

        v736 = false

        if v739 then
            if next(p323.BuildTransformHolds) ~= nil then
                v736 = true
            else
                v737 = true
            end
        end

        if v736 then
            v743 = true
            v738 = true
        end

        if v737 then
            v743 = false
            v738 = true
        end

        v737 = false

        if v738 then
            if Input then
                v737 = true
            else
                v740 = false
            end
        end

        v738 = false

        if v737 then
            if v741 == Enum.UserInputState.End then
                v740 = false
            else
                v738 = true
            end
        end

        v737 = false

        if v738 then
            if v741 == Enum.UserInputState.Cancel then
                v740 = false
            else
                v737 = true
            end
        end

        v738 = false

        if v737 then
            if v742 then
                v740 = false
            else
                v738 = true
            end
        end

        v737 = false

        if v738 then
            if v743 then
                v740 = false
            else
                v737 = true
            end
        end

        v738 = false

        if v737 then
            if p323.Painting then
                v740 = false
            else
                v738 = true
            end
        end

        if v738 then
            v740 = false
            p323:ActivateBuildObjectAt(BuildPendingGamepadGrab.Position, Input.UserInputType, Input)
        end

        if v740 then
            return
        end

        if p323.BuildDirectGamepad then
            local CurrentCamera = workspace.CurrentCamera

            p323.BuildDirectLastScreen = p323.BuildGamepadNavigation and UserInputService:GetMouseLocation() or CurrentCamera.ViewportSize / 2
        end

        if not p323.BuildCameraLocked then
            local CurrentCamera = workspace.CurrentCamera
            local v744 = math.max(BuildReference2.Size.X, BuildReference2.Size.Y, BuildReference2.Size.Z)
            local v745 = Vector3.new()
            local v746

            if UserInputService:GetFocusedTextBox() then
                v746 = v745
            else
                local v747 = if UserInputService:IsKeyDown(Enum.KeyCode.W) then v745 + Vector3.new(0, 0, -1) else v745

                v746 = if UserInputService:IsKeyDown(Enum.KeyCode.S) then v747 + Vector3.new(0, 0, 1) else v747

                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    v746 += Vector3.new(-1, 0, 0)
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    v746 += Vector3.new(1, 0, 0)
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                    v746 += Vector3.new(0, -1, 0)
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                    v746 += Vector3.new(0, 1, 0)
                end
            end

            local ConnectedGamepads = UserInputService:GetConnectedGamepads()

            if #ConnectedGamepads > 0 and not (p323.BuildGamepadNavigation or GamepadService.GamepadCursorEnabled) then
                for _, v748 in ipairs(UserInputService:GetGamepadState(ConnectedGamepads[1])) do
                    if v748.KeyCode == Enum.KeyCode.Thumbstick1 then
                        local Position = v748.Position

                        if math.abs(Position.X) > 0.15 then
                            v746 += Vector3.new(Position.X, 0, 0)
                        end

                        if math.abs(Position.Y) > 0.15 then
                            v746 += Vector3.new(0, 0, -Position.Y)
                        end
                    elseif v748.KeyCode == Enum.KeyCode.Thumbstick2 then
                        local Position = v748.Position

                        if math.abs(Position.X) > 0.15 or math.abs(Position.Y) > 0.15 then
                            p323.BuildViewPreset = nil
                        end

                        if math.abs(Position.X) > 0.15 then
                            p323.BuildCameraYaw -= Position.X * 2.2 * p324
                        end

                        if math.abs(Position.Y) > 0.15 then
                            p323.BuildCameraPitch = math.clamp(p323.BuildCameraPitch + Position.Y * 2.2 * p324, -1.5533430342749532, 1.3089969389957472)
                        end
                    end
                end

                if UserInputService:IsGamepadButtonDown(ConnectedGamepads[1], Enum.KeyCode.ButtonR1) then
                    p323.BuildCameraPosition = (p323.BuildCameraPosition or CurrentCamera.CFrame.Position) + CurrentCamera.CFrame.LookVector * v744 * 0.8 * p324
                end

                if UserInputService:IsGamepadButtonDown(ConnectedGamepads[1], Enum.KeyCode.ButtonL1) then
                    p323.BuildCameraPosition = (p323.BuildCameraPosition or CurrentCamera.CFrame.Position) - CurrentCamera.CFrame.LookVector * v744 * 0.8 * p324
                end
            end

            local v751 = v746

            if p323.BuildMobileCameraInputs then
                local v752 = v746

                for _, v753 in pairs(p323.BuildMobileCameraInputs) do
                    v752 += v753.Direction
                    v751 = v752
                end
            end

            if v751.Magnitude > 0 then
                local v754 = v751.Magnitude > 1 and v751.Unit or v751
                local LookVector, RightVector = CurrentCamera.CFrame.LookVector, CurrentCamera.CFrame.RightVector
                local UpVector = BuildReference.CFrame.UpVector
                local v755 = v744 * 0.45

                p323.BuildCameraPosition = (p323.BuildCameraPosition or CurrentCamera.CFrame.Position) + (RightVector * v754.X + UpVector * v754.Y + LookVector * -v754.Z) * v755 * p324
            end

            p323.BuildDistance = math.clamp(p323.BuildDistance, 4, v744 * 3)
            p323.BuildCameraPosition = p323:ClampBuildCameraPosition(p323.BuildCameraPosition or CurrentCamera.CFrame.Position)
        end

        p323:UpdateBuildCameraCFrame()

        if p323.BuildModeKind ~= "Paint" then
            p323:UpdateBuildGridSurface()
        end

        if p323.BuildModeKind ~= "Paint" and p323.BuildDirectLastScreen and (p323.BuildDirectMouse or p323.BuildDirectTouch or p323.BuildDirectGamepad) then
            p323:UpdateDirectBuildDrag(p323.BuildDirectLastScreen)
        end
    end
end

function t1.GetBuildPointerRay(p325, p326) -- line: 5972
    -- upvalues: UserInputService (copy)
    if p325.ClassicBuildActive and UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse then
        return p325.Mouse.UnitRay
    end

    if p325.ClassicMobile and p325.ClassicMobile:IsActive() then
        return p325.ClassicMobile:GetRay()
    end

    if not p325.ClassicBuildActive or not p325.TouchEnabled or p325.ClassicController and p325.ClassicController:IsGamepad() then
        return workspace.CurrentCamera:ViewportPointToRay(p326.X, p326.Y)
    end

    local MobileMouse = p325.HUD.MobileMouse
    local v757 = MobileMouse.AbsolutePosition + MobileMouse.AbsoluteSize / 2

    return workspace.CurrentCamera:ScreenPointToRay(v757.X, v757.Y)
end

local function raycastBuildBoxSurface(p327, p328, p329, p330) -- line: 5987
    local v758 = p328:PointToObjectSpace(p327.Origin)
    local v759 = p328:VectorToObjectSpace(p327.Direction)
    local v760 = p329 / 2
    local t36 = {
        v758.X,
        v758.Y,
        v758.Z
    }
    local t37 = {
        v759.X,
        v759.Y,
        v759.Z
    }
    local t38 = {
        v760.X,
        v760.Y,
        v760.Z
    }
    local t39 = {
        (Vector3.new(1, 0, 0)),
        (Vector3.new(0, 1, 0)),
        (Vector3.new(0, 0, 1))
    }
    local n13 = (-1e999)
    local n14 = 1e999
    local v761, v762

    for i = 1, 3 do
        local v763 = t36[i]
        local v764 = t37[i]
        local v765 = t38[i]

        if math.abs(v764) < 1E-06 then
            if v765 < math.abs(v763) then
                return nil
            end
        else
            local v766 = (-v765 - v763) / v764
            local v767 = (v765 - v763) / v764
            local v768 = -t39[i]
            local v769 = t39[i]

            if not (v767 < v766) then
                v767, v766, v769, v768 = v766, v767, v768, v769
            end

            if n13 < v767 then
                v761 = v769
                n13 = v767
            end

            if v766 < n14 then
                v762 = v768
                n14 = v766
            end

            if n14 < n13 then
                return nil
            end
        end
    end

    if n14 < 0 then
        return nil
    end

    local v770 = n13 < 0

    if v770 and n14 then
        n13 = n14
    end

    if v770 and v762 then
        v761 = v762
    end

    return if v761 and not (n13 > 4096) then {
        Position = p327.Origin + p327.Direction * n13,
        Normal = p328:VectorToWorldSpace(v761).Unit,
        Instance = p330,
        Distance = n13,
        StartedInside = v770
    } else nil
end

function t1.GetPlacedBuildObjectsContainer(p331) -- line: 6045
    local v771 = p331.StorageBase and p331.StorageBase:FindFirstChild("Contents")

    return v771 and v771:FindFirstChild("Objects")
end

function t1.ResolvePlacedBuildObject(p332, p333) -- line: 6050
    -- upvalues: BaseObjectsLib (copy)
    local PlacedBuildObjectsContainer = p332:GetPlacedBuildObjectsContainer()

    if PlacedBuildObjectsContainer and p333 and p333:IsDescendantOf(PlacedBuildObjectsContainer) then
        local v772 = p333

        while v772 and v772.Parent ~= PlacedBuildObjectsContainer do
            v772 = v772.Parent
        end

        return if v772 and v772:IsA("Model") and BaseObjectsLib[v772.Name] then v772 else nil
    end

    return nil
end

function t1.GetPlacedBuildObjectAtScreenPosition(p334, p335) -- line: 6059
    -- upvalues: BaseObjectsLib (copy), raycastBuildBoxSurface (copy)
    local PlacedBuildObjectsContainer = p334:GetPlacedBuildObjectsContainer()

    if not PlacedBuildObjectsContainer or typeof(p335) ~= "Vector2" then
        return nil
    end

    local BuildPointerRay = p334:GetBuildPointerRay(p335)
    local v773 = p334.ClassicBuildActive == true and not p334.Painting

    local function visibleObject(p336, p337) -- line: 6064
        -- upvalues: p334 (copy), BuildPointerRay (copy), v773 (copy)
        if not (p336 and v773) then
            return p336
        end

        local t40

        if not p337 or p337 > 500 then
            return nil
        else
            t40 = {
                workspace.CurrentCamera
            }

            if p334.Character then
                table.insert(t40, p334.Character)
            end
        end

        if p334.EditObject then
            table.insert(t40, p334.EditObject)
        end

        local v775 = RaycastParams.new()

        v775.FilterType = Enum.RaycastFilterType.Exclude
        v775.IgnoreWater = true

        for _ = 1, 32 do
            v775.FilterDescendantsInstances = t40

            local v777 = workspace:Raycast(BuildPointerRay.Origin, BuildPointerRay.Direction * math.max(0, p337 - 0.03), v775)

            if not v777 then
                return p336
            end

            local Instance = v777.Instance

            if not (Instance:IsA("BasePart") and (Instance.Transparency >= 1 or Instance.LocalTransparencyModifier >= 1)) then
                return if Instance:IsDescendantOf(p336) then p336 else nil
            end

            table.insert(t40, Instance)
        end

        return nil
    end

    local v778 = RaycastParams.new()

    v778.FilterType = Enum.RaycastFilterType.Include
    v778.FilterDescendantsInstances = { PlacedBuildObjectsContainer }

    if v773 then
        local t41 = {}

        for _, descendant in ipairs(PlacedBuildObjectsContainer:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant.CanQuery and descendant.Transparency < 1 and descendant.LocalTransparencyModifier < 1 then
                table.insert(t41, descendant)
            end
        end

        v778.FilterDescendantsInstances = t41
    end

    local v779 = workspace:Raycast(BuildPointerRay.Origin, BuildPointerRay.Direction * 4096, v778)
    local v780 = v779 and v779.Instance
    local BasePart = v780

    if v780 then
        BasePart = v780:IsA("BasePart")

        if BasePart then
            BasePart = v780.Transparency < 1 and v780.LocalTransparencyModifier < 1 and p334:ResolvePlacedBuildObject(v780)
        end
    end

    if BasePart and not v773 then
        return BasePart
    end

    local v781 = BasePart or nil
    local Distance = BasePart and v779.Distance or nil

    for _, child in ipairs(PlacedBuildObjectsContainer:GetChildren()) do
        if child:IsA("Model") and BaseObjectsLib[child.Name] then
            local BoundingBox, BoundingBox2 = child:GetBoundingBox()
            local v782 = raycastBuildBoxSurface(BuildPointerRay, BoundingBox, BoundingBox2, child)

            if v782 then
                local v783 = false
                local Distance2

                for _, descendant in ipairs(child:GetDescendants()) do
                    if descendant:IsA("BasePart") and descendant.Transparency < 1 and descendant.LocalTransparencyModifier < 1 then
                        if not v773 or not descendant.CanQuery then
                            local v785 = raycastBuildBoxSurface(BuildPointerRay, descendant.CFrame, descendant.Size, descendant)

                            if v785 and (not Distance2 or v785.Distance < Distance2) then
                                Distance2 = v785.Distance
                            end
                        end

                        v783 = true
                    end
                end

                if not (v783 or v773) then
                    Distance2 = v782.Distance
                end

                if Distance2 and (not Distance or Distance2 < Distance) then
                    Distance = Distance2
                    v781 = child
                end
            end
        end
    end

    return (visibleObject(v781, Distance))
end

function t1.ClearBuildObjectHover(p338) -- line: 6151
    p338.ObjectHover = nil

    if p338.HighlightHover then
        p338.HighlightHover.Adornee = nil
        p338.HighlightHover.Parent = nil
    end
end

function t1.UpdateBuildObjectHover(p339, p340, p341) -- line: 6159
    if not p339.EditObject and not p339.Painting and p339.EditingBase and p339.BuildCameraActive then
        local elapsed = os.clock()

        if not p341 and elapsed < (p339.BuildHoverNext or 0) then
            return p339.ObjectHover
        end

        p339.BuildHoverNext = elapsed + 0.06

        local ClassicMobile = p339.ClassicMobile
        local v786 = ClassicMobile and ClassicMobile:IsActive() and p339.DeletingObjects and ClassicMobile.DeleteStarted and ClassicMobile.DeleteTarget
        local v787 = if v786 then p339:ResolvePlacedBuildObject(v786) else p339:GetPlacedBuildObjectAtScreenPosition(p340)

        p339.ObjectHover = v787

        if not v787 then
            p339:ClearBuildObjectHover()

            return nil
        end

        local v788 = p339.DeletingObjects == true

        p339.HighlightHover.FillColor = v788 and Color3.fromRGB(255, 105, 105) or Color3.fromRGB(42, 170, 255)
        p339.HighlightHover.OutlineColor = v788 and Color3.fromRGB(255, 162, 162) or Color3.fromRGB(135, 218, 255)
        p339.HighlightHover.FillTransparency = v788 and 0.62 or 0.82
        p339.HighlightHover.OutlineTransparency = 0
        p339.HighlightHover.DepthMode = Enum.HighlightDepthMode.Occluded
        p339.HighlightHover.Adornee = v787
        p339.HighlightHover.Parent = workspace.CurrentCamera

        return v787
    end

    p339:ClearBuildObjectHover()

    return nil
end

function t1.SelectPlacedBuildObject(p342, p343) -- line: 6194
    -- upvalues: BaseObjectsLib (copy)
    local v789 = p342:ResolvePlacedBuildObject(p343)

    if not v789 then
        return false
    end

    local v790 = p342.StorageBase and p342.StorageBase:FindFirstChild("Floor")

    if not v790 then
        return false
    end

    local v791 = BaseObjectsLib[v789.Name]

    if not v791 then
        return false
    end

    p342:DeleteEditObject()

    local clone = v789:Clone()

    if not clone then
        return false
    end

    for _, descendant in ipairs(clone:GetDescendants()) do
        if descendant:IsA("Highlight") then
            descendant:Destroy()
        elseif descendant:IsA("BasePart") then
            descendant:SetAttribute("BuildWasCollidable", descendant.CanCollide)
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = true
        end
    end

    p342.DeletingObjects = false
    p342.CurrentFrame = nil
    p342.ObjectType = v791.Type
    p342.EditingExistingObject = v789
    p342.EditExistingOriginalTransparency = {}

    for _, descendant in ipairs(v789:GetDescendants()) do
        if descendant:IsA("BasePart") then
            p342.EditExistingOriginalTransparency[descendant] = descendant.LocalTransparencyModifier
            descendant.LocalTransparencyModifier = 1
        end
    end

    p342.EditObject = clone
    p342.EditObject.Name = v789.Name
    p342.EditObjectRotate = 0
    p342.EditObjectFlip = 0
    p342.EditObjectFlip2 = 0
    p342.breathingNum = Vector3.new(0, 0, 0)

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "BuildHighlight"
    Highlight.FillTransparency = 0.5
    Highlight.FillColor = Color3.fromRGB(255, 226, 137)
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.OutlineColor = Color3.fromRGB(255, 228, 120)
    Highlight.OutlineTransparency = 0
    Highlight.Parent = p342.EditObject
    p342.EditObject.Parent = workspace.CurrentCamera

    if p342.ClassicBuildActive then
        local v792, v793, v794 = p342:CalcStorageFloor().Rotation:ToObjectSpace(v789:GetPivot().Rotation):ToEulerAnglesXYZ()

        p342.EditObjectFlip2 = math.deg(v792) + 90
        p342.EditObjectRotate = math.deg(v793)
        p342.EditObjectFlip = math.deg(v794)
        p342.BuildObjectPosition = nil
        p342.BuildObjectRotation = nil
        p342.Mouse.TargetFilter = p342.EditObject
        p342:ClearBuildObjectHover()
        p342:HideBuildGizmos()

        if p342.ClassicController then
            p342.ClassicController:NotifySelected(v789.Name, v791.Type)
        end

        if p342.ClassicMobile then
            p342.ClassicMobile:NotifySelected(v789.Name, v791.Type)
        end
    else
        local v795 = v790.CFrame:ToObjectSpace(v789:GetPivot())
        local v796, v797, v798 = v795:ToEulerAnglesXYZ()

        p342.BuildObjectPosition = v795.Position
        p342.BuildObjectRotation = Vector3.new(math.deg(v796), math.deg(v797), (math.deg(v798)))
        p342:ClampBuildObjectToBounds()
        p342.BuildTransformDirty = true
        p342.EditObject:PivotTo(p342:GetBuildObjectCFrame())
        p342.Mouse.TargetFilter = p342.EditObject
        p342:ClearBuildObjectHover()
        p342:UpdateBuildGizmo(p342:GetBuildObjectCFrame())
        p342:RefreshBuildValidation(true)

        if p342.ModernController then
            p342.ModernController:NotifySelected(v789.Name, v791.Type)
        end

        if p342.ModernMobile then
            p342.ModernMobile:NotifySelected(v789.Name, v791.Type)
        end
    end

    p342:RememberModernDesktopObject(v789.Name)
    p342:UpdateBuildGui()

    return true
end

function t1.ActivateBuildObjectAt(p344, p345, p346, p347) -- line: 6282
    -- upvalues: RemoteEvent (copy)
    if p344.EditObject then
        return p344:BeginDirectBuildDrag(p345, p346, p347)
    end

    local v802 = p344:UpdateBuildObjectHover(p345, true)

    if not v802 then
        return false
    end

    if p344.DeletingObjects then
        if not (p344.ModernDesktop and p344.ModernDesktop:IsActive()) then
            if os.clock() - (p344.BuildDeleteAt or 0) < 0.15 then
                return false
            end

            p344.BuildDeleteAt = os.clock()
            RemoteEvent:FireServer("DeleteBaseObject", v802)
        else
            local v803 = p344.ModernDesktop:Delete(v802)

            if not (v803 and (v803.queued or v803.ok)) then
                return false
            end
        end

        p344:ClearBuildObjectHover()

        return true
    end

    local v804 = p344:SelectPlacedBuildObject(v802)

    if v804 and p346 == Enum.UserInputType.Gamepad1 and p347 and p347.KeyCode == Enum.KeyCode.ButtonA then
        p344:BeginDirectBuildDrag(p345, p346, p347)
    end

    return v804
end

function t1.BuildPointerHitsObject(p348, p349) -- line: 6311
    -- upvalues: raycastBuildBoxSurface (copy)
    if not p348.EditObject then
        return nil
    end

    local BuildPointerRay = p348:GetBuildPointerRay(p349)
    local v805, Distance
    local v806 = false

    for _, descendant in ipairs(p348.EditObject:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 and descendant.LocalTransparencyModifier < 1 then
            local v807 = raycastBuildBoxSurface(BuildPointerRay, descendant.CFrame, descendant.Size, descendant)

            if v807 and (not Distance or v807.Distance < Distance) then
                v805 = v807
                Distance = v807.Distance
            end

            v806 = true
        end
    end

    if v805 or v806 then
        return v805
    end

    local BoundingBox, BoundingBox2 = p348.EditObject:GetBoundingBox()

    return (raycastBuildBoxSurface(BuildPointerRay, BoundingBox, BoundingBox2, p348.EditObject))
end

function t1.GetBuildSurfaceHit(p350, p351) -- line: 6342
    -- upvalues: raycastBuildBoxSurface (copy)
    if not p350.StorageBase then
        return nil
    end

    local BuildPointerRay = p350:GetBuildPointerRay(p351)
    local t42 = {
        p350.EditObject
    }

    if p350.EditingExistingObject then
        table.insert(t42, p350.EditingExistingObject)
    end

    if p350.Character then
        table.insert(t42, p350.Character)
    end

    if p350.BuildGrid then
        table.insert(t42, p350.BuildGrid)
    end

    local _, BuildReference = p350:GetBuildReference()

    if BuildReference then
        table.insert(t42, BuildReference)
    end

    local v808 = RaycastParams.new()

    v808.FilterType = Enum.RaycastFilterType.Exclude
    v808.FilterDescendantsInstances = t42

    local v809, Direction = BuildPointerRay.Origin, BuildPointerRay.Direction
    local n15 = 4096
    local n16 = 1e999
    local v810

    for _ = 1, 24 do
        v810 = workspace:Raycast(v809, Direction * n15, v808)

        if not v810 then
            v810 = nil
            n16 = 1e999
            break
        end

        local Instance = v810.Instance

        if Instance and Instance:IsA("BasePart") and Instance:IsDescendantOf(p350.StorageBase) then
            n16 = (v810.Position - BuildPointerRay.Origin).Magnitude
            break
        end

        table.insert(t42, Instance)
        v808.FilterDescendantsInstances = t42
        n15 -= (v810.Position - v809).Magnitude + 0.02

        if n15 <= 0 then
            v810 = nil
            n16 = 1e999
            break
        end

        v809 = v810.Position + Direction * 0.02
        v810 = nil
    end

    if p350.BuildSurfaceParts then
        for v813 in pairs(p350.BuildSurfaceParts) do
            if v813 and v813.Parent and v813:IsA("BasePart") and v813.Name == "Wall" and v813.Transparency < 1 then
                local v814 = raycastBuildBoxSurface(BuildPointerRay, v813.CFrame, v813.Size, v813)

                if v814 and v814.Distance < n16 then
                    v810 = v814
                    n16 = v814.Distance
                end
            end
        end
    end

    local v815 = v810

    if BuildReference then
        v815 = raycastBuildBoxSurface(BuildPointerRay, BuildReference.CFrame, BuildReference.Size, BuildReference)

        if v815 and v815.Distance < n16 then
            v815.Normal = -v815.Normal
        else
            v815 = v810
        end
    end

    return v815
end

function t1.BeginDirectBuildDrag(p352, p353, p354, p355) -- line: 6416
    if not (p352.EditObject and p352.BuildObjectPosition) then
        return false
    end

    p352.BuildGizmoDragging = nil
    p352.BuildDragStartPosition = nil
    p352.BuildDragStartRotation = nil

    local v816 = p352:BuildPointerHitsObject(p353)

    if not v816 or not (p352.StorageBase and p352.StorageBase:FindFirstChild("Floor")) then
        return false
    end

    local BuildObjectCFrame = p352:GetBuildObjectCFrame()

    p352.EditObject:PivotTo(BuildObjectCFrame)
    p352.BuildDirectGrabBoxLocal = p352.EditObject:GetBoundingBox():PointToObjectSpace(v816.Position)
    p352.BuildDirectLastScreen = p353
    p352.BuildDirectMouse = p354 == Enum.UserInputType.MouseButton1

    if p354 ~= Enum.UserInputType.Touch or not p355 then
        p352.BuildDirectTouch = nil
    else
        p352.BuildDirectTouch = p355
    end

    if p355 and p355.KeyCode == Enum.KeyCode.ButtonA then
        p352.BuildDirectGamepad = p355
    else
        p352.BuildDirectGamepad = nil
    end

    return true
end

function t1.UpdateDirectBuildDrag(p356, p357) -- line: 6446
    if not (p356.BuildDirectGrabBoxLocal and p356.EditObject) then
        return
    end

    local v817 = p356.StorageBase and p356.StorageBase:FindFirstChild("Floor")

    if not v817 then
        return
    end

    local BuildSurfaceHit = p356:GetBuildSurfaceHit(p357)
    local v818 = false
    local v819 = false
    local v820 = false
    local v821 = false
    local v822 = false
    local v823 = false

    if BuildSurfaceHit then
        v818 = true
    else
        v823 = true
    end

    local v824, v825, v826, v827, v828

    if v818 then
        local BuildObjectCFrame = p356:GetBuildObjectCFrame()

        p356.EditObject:PivotTo(BuildObjectCFrame)

        local BoundingBox, BoundingBox2 = p356.EditObject:GetBoundingBox()
        local v829 = BoundingBox2 / 2
        local Unit = BuildSurfaceHit.Normal.Unit
        local v830 = BoundingBox:VectorToWorldSpace(p356.BuildDirectGrabBoxLocal)
        local v831 = v830 - Unit * v830:Dot(Unit)
        local v837 = math.abs((Unit:Dot(BoundingBox.RightVector))) * v829.X + math.abs((Unit:Dot(BoundingBox.UpVector))) * v829.Y + math.abs((Unit:Dot(BoundingBox.LookVector))) * v829.Z
        local v838 = BuildObjectCFrame.Position - BoundingBox.Position
        local v839 = BuildSurfaceHit.Position - v831 + Unit * (v837 + 0.02) + v838

        v824 = v817.CFrame:PointToObjectSpace(v839)

        local v840 = v817.CFrame:VectorToObjectSpace(Unit)

        v825 = math.abs(v840.X)
        v826 = math.abs(v840.Y)
        v827 = math.abs(v840.Z)
        v828 = p356.BuildMoveStep or 0.5

        if v826 <= v825 then
            v819 = true
        else
            v820 = true
        end
    end

    v818 = false

    if v819 then
        if v827 <= v825 then
            v818 = true
        else
            v820 = true
        end
    end

    v819 = false

    if v820 then
        if v825 <= v826 then
            v819 = true
        else
            v821 = true
        end
    end

    v820 = false

    if v819 then
        if v827 <= v826 then
            v820 = true
        else
            v821 = true
        end
    end

    v819 = false

    local X

    if v821 then
        X = v824.X

        if v828 then
            v819 = true
        else
            v822 = true
        end
    end

    v821 = false

    if v819 then
        if v828 <= 0 then
            v822 = true
        else
            v821 = true
        end
    end

    v819 = false

    local v841

    if v821 then
        v841 = math.round(X / v828) * v828
        v819 = true
    end

    v821 = false

    if v822 then
        v841 = X
        v819 = true
    end

    v822 = false

    local Y

    if v819 then
        Y = v824.Y

        if v828 then
            v821 = true
        else
            v822 = true
        end
    end

    v819 = false

    if v821 then
        if v828 <= 0 then
            v822 = true
        else
            v819 = true
        end
    end

    v821 = false

    local v843

    if v819 then
        v843 = math.round(Y / v828) * v828
        v821 = true
    end

    v819 = false

    if v822 then
        v843 = Y
        v821 = true
    end

    local v845

    if v821 then
        v845 = Vector3.new(v841, v843, v824.Z)
        v823 = false
    end

    v821 = false

    local X2

    if v820 then
        X2 = v824.X

        if v828 then
            v821 = true
        else
            v819 = true
        end
    end

    v820 = false

    if v821 then
        if v828 <= 0 then
            v819 = true
        else
            v820 = true
        end
    end

    v821 = false

    local v846

    if v820 then
        v846 = math.round(X2 / v828) * v828
        v821 = true
    end

    v820 = false

    if v819 then
        v846 = X2
        v821 = true
    end

    v819 = false

    local Y2, Z

    if v821 then
        Y2 = v824.Y
        Z = v824.Z

        if v828 then
            v820 = true
        else
            v819 = true
        end
    end

    v821 = false

    if v820 then
        if v828 <= 0 then
            v819 = true
        else
            v821 = true
        end
    end

    v820 = false

    local v848

    if v821 then
        v848 = math.round(Z / v828) * v828
        v820 = true
    end

    v821 = false

    if v819 then
        v848 = Z
        v820 = true
    end

    if v820 then
        v845 = Vector3.new(v846, Y2, v848)
        v823 = false
    end

    v820 = false

    local X3, Y3

    if v818 then
        X3 = v824.X
        Y3 = v824.Y

        if v828 then
            v820 = true
        else
            v821 = true
        end
    end

    v818 = false

    if v820 then
        if v828 <= 0 then
            v821 = true
        else
            v818 = true
        end
    end

    v820 = false

    local v850

    if v818 then
        v850 = math.round(Y3 / v828) * v828
        v820 = true
    end

    v818 = false

    if v821 then
        v850 = Y3
        v820 = true
    end

    v821 = false

    local Z2

    if v820 then
        Z2 = v824.Z

        if v828 then
            v818 = true
        else
            v821 = true
        end
    end

    v820 = false

    if v818 then
        if v828 <= 0 then
            v821 = true
        else
            v820 = true
        end
    end

    v818 = false

    local v852

    if v820 then
        v852 = math.round(Z2 / v828) * v828
        v818 = true
    end

    if v821 then
        v852 = Z2
        v818 = true
    end

    if v818 then
        v845 = Vector3.new(X3, v850, v852)
        v823 = false
    end

    if not v823 then
        p356.BuildObjectPosition = p356:GetClampedBuildPosition(v845, p356.BuildObjectRotation)
        p356.EditObject:PivotTo(p356:GetBuildObjectCFrame())
        p356.BuildDirectLastScreen = p357
        p356.BuildTransformDirty = true
    end
end

function t1.EndDirectBuildDrag(p358) -- line: 6489
    p358.BuildPendingGamepadGrab = nil
    p358.BuildDirectMouse = nil
    p358.BuildDirectTouch = nil
    p358.BuildDirectGamepad = nil
    p358.BuildDirectGrabBoxLocal = nil
    p358.BuildDirectLastScreen = nil
    p358.BuildDirectLockedAxis = nil
    p358.BuildDirectPlanePoint = nil
    p358.BuildDirectPlaneNormal = nil
    p358.BuildDirectOffset = nil
    p358.BuildDirectStartPosition = nil
end

function t1.BeginBuildMouseCameraDrag(p359, p360) -- line: 6503
    -- upvalues: UserInputService (copy)
    if not p359.BuildMouseOrbit and not p359.BuildMousePan then
        p359.BuildMouseBehaviorBeforeDrag = UserInputService.MouseBehavior
        p359.BuildMouseIconBeforeDrag = UserInputService.MouseIconEnabled
    end

    if p360 == "Orbit" then
        p359.BuildMouseOrbit = true
    else
        if p360 ~= "Pan" then
            return false
        end

        p359.BuildMousePan = true
    end

    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition

    return true
end

function t1.EndBuildMouseCameraDrag(p361, p362) -- line: 6519
    -- upvalues: UserInputService (copy)
    if p362 == "Orbit" then
        p361.BuildMouseOrbit = nil
    else
        if p362 ~= "Pan" then
            p361.BuildMouseOrbit = nil
        end

        p361.BuildMousePan = nil
    end

    if p361.BuildMouseOrbit or p361.BuildMousePan then
        return
    end

    local BuildMouseBehaviorBeforeDrag, BuildMouseIconBeforeDrag = p361.BuildMouseBehaviorBeforeDrag, p361.BuildMouseIconBeforeDrag

    p361.BuildMouseBehaviorBeforeDrag = nil
    p361.BuildMouseIconBeforeDrag = nil

    if BuildMouseBehaviorBeforeDrag ~= nil then
        UserInputService.MouseBehavior = BuildMouseBehaviorBeforeDrag
    end

    if BuildMouseIconBeforeDrag ~= nil then
        UserInputService.MouseIconEnabled = BuildMouseIconBeforeDrag
    end
end

function t1.ConnectBuildInputs(p363) -- line: 6542
    -- upvalues: UserInputService (copy), GuiService (copy)
    if p363.BuildInputCons then
        for _, v854 in ipairs(p363.BuildInputCons) do
            v854:Disconnect()
        end
    end

    p363.BuildInputCons = {}
    p363.BuildTouches = {}
    p363.BuildTouchOrder = {}
    p363.BuildPendingTouchSelection = nil

    local function connect(p364, p365) -- line: 6550
        -- upvalues: p363 (copy)
        local connection = p364:Connect(p365)

        table.insert(p363.BuildInputCons, connection)
    end

    local connection = UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 6554
        -- upvalues: p363 (copy)
        if p363.BuildCameraActive then
            p363:UpdateBuildGui()
        end
    end)

    table.insert(p363.BuildInputCons, connection)

    local function addTouch(p366, p367) -- line: 6557
        -- upvalues: p363 (copy)
        if p363.BuildTouches[p366] then
            return
        end

        p363.BuildTouches[p366] = p367
        table.insert(p363.BuildTouchOrder, p366)
    end

    local function removeTouch(p368) -- line: 6562
        -- upvalues: p363 (copy)
        p363.BuildTouches[p368] = nil

        for v855, v856 in ipairs(p363.BuildTouchOrder) do
            if v856 == p368 then
                table.remove(p363.BuildTouchOrder, v855)
                break
            end
        end

        p363.BuildPinchMid = nil
        p363.BuildPinchDistance = nil
    end

    local function cancelPendingTouchSelection(p369) -- line: 6573
        -- upvalues: p363 (copy)
        local BuildPendingTouchSelection = p363.BuildPendingTouchSelection

        if not BuildPendingTouchSelection or p369 and BuildPendingTouchSelection.Input ~= p369 then
            return false
        end

        p363.BuildPendingTouchSelection = nil

        if not p363.EditObject then
            p363:ClearBuildObjectHover()
        end

        return true
    end

    local function beginPendingTouchSelection(p370, p371, p372) -- line: 6580
        -- upvalues: p363 (copy), removeTouch (copy)
        if not p363.BuildTouches[p370] then
            p363.BuildTouches[p370] = p371
            table.insert(p363.BuildTouchOrder, p370)
        end

        local t43 = {
            Input = p370,
            StartPosition = p371,
            Position = p371,
            LastCheckedPosition = p371,
            Object = p372
        }

        p363.BuildPendingTouchSelection = t43
        task.delay(0.4, function() -- line: 6590
            -- upvalues: p370 (copy), t43 (copy), p363 (copy), removeTouch (copy)
            if p363.BuildPendingTouchSelection ~= t43 then
                return
            end

            if p363.BuildCameraActive and p363.EditingBase and p363.BuildModeKind == "Objects" and not p363.Painting and not p363.EditObject and not p363.DeletingObjects then
                local UserInputState = p370.UserInputState

                if UserInputState ~= Enum.UserInputState.End and UserInputState ~= Enum.UserInputState.Cancel and not ((t43.Position - t43.StartPosition).Magnitude > 18) then
                    local PlacedBuildObjectAtScreenPosition = p363:GetPlacedBuildObjectAtScreenPosition(t43.Position)

                    if PlacedBuildObjectAtScreenPosition == t43.Object then
                        p363.BuildPendingTouchSelection = nil
                        removeTouch(p370)
                        p363:SelectPlacedBuildObject(PlacedBuildObjectAtScreenPosition)
                    else
                        local BuildPendingTouchSelection = p363.BuildPendingTouchSelection

                        if BuildPendingTouchSelection then
                            if p370 and BuildPendingTouchSelection.Input ~= p370 then
                                return
                            end

                            p363.BuildPendingTouchSelection = nil

                            if not p363.EditObject then
                                p363:ClearBuildObjectHover()
                            end
                        end
                    end
                else
                    local BuildPendingTouchSelection = p363.BuildPendingTouchSelection

                    if BuildPendingTouchSelection then
                        if p370 and BuildPendingTouchSelection.Input ~= p370 then
                            return
                        end

                        p363.BuildPendingTouchSelection = nil

                        if not p363.EditObject then
                            p363:ClearBuildObjectHover()
                        end
                    end
                end
            else
                local BuildPendingTouchSelection = p363.BuildPendingTouchSelection

                if BuildPendingTouchSelection then
                    if p370 and BuildPendingTouchSelection.Input ~= p370 then
                        return
                    end

                    p363.BuildPendingTouchSelection = nil

                    if not p363.EditObject then
                        p363:ClearBuildObjectHover()
                    end
                end
            end
        end)
    end

    local function pointerOverScrollingGui() -- line: 6620
        -- upvalues: p363 (copy), UserInputService (copy)
        local v857 = p363.Player and p363.Player:FindFirstChildOfClass("PlayerGui")

        if v857 then
            local MouseLocation = UserInputService:GetMouseLocation()

            local function v858() -- line: 6624
                -- upvalues: v857 (copy), MouseLocation (copy)
                return v857:GetGuiObjectsAtPosition(math.floor(MouseLocation.X), (math.floor(MouseLocation.Y)))
            end

            local ok, result = pcall(v858)

            if ok then
                for _, v860 in ipairs(result) do
                    local v861 = v860

                    while v861 and v861 ~= v857 do
                        if v861:IsA("ScrollingFrame") and v861.Visible and v861.ScrollingEnabled then
                            return true
                        end

                        v861 = v861.Parent
                    end
                end
            end
        end

        return false
    end

    local function pointerInsideMobileCameraControls(p373) -- line: 6646
        -- upvalues: p363 (copy)
        local BuildGui = p363.BuildGui
        local v862 = if BuildGui then BuildGui:FindFirstChild("MobileCameraContols") or BuildGui:FindFirstChild("MobileCameraControls") else nil

        if v862 and v862.Visible then
            local AbsolutePosition, AbsoluteSize = v862.AbsolutePosition, v862.AbsoluteSize

            if p373.X >= AbsolutePosition.X and p373.Y >= AbsolutePosition.Y and p373.X <= AbsolutePosition.X + AbsoluteSize.X and p373.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
                return true
            end
        end

        return false
    end

    local function pointerOverInteractiveGui(p374) -- line: 6661
        -- upvalues: p363 (copy)
        local v863 = p363.Player and p363.Player:FindFirstChildOfClass("PlayerGui")

        if v863 then
            local function v864() -- line: 6664
                -- upvalues: p374 (copy), v863 (copy)
                return v863:GetGuiObjectsAtPosition(math.floor(p374.X), (math.floor(p374.Y)))
            end

            local ok, result = pcall(v864)

            if ok then
                for _, v866 in ipairs(result) do
                    local v867 = v866

                    while v867 and v867 ~= v863 do
                        if v867:IsA("GuiObject") and v867.Visible and (v867:IsA("GuiButton") or v867:IsA("TextBox") or v867.Active or v867:IsA("ScrollingFrame") and v867.ScrollingEnabled) then
                            return true
                        end

                        v867 = v867.Parent
                    end
                end
            end
        end

        return false
    end

    local connection2 = UserInputService.InputBegan:Connect(function(p375, p376) -- line: 6694
        -- upvalues: p363 (copy), removeTouch (copy), beginPendingTouchSelection (copy), pointerInsideMobileCameraControls (copy), pointerOverInteractiveGui (copy), UserInputService (copy), GuiService (copy)
        if p363.ModernMobile and p363.ModernMobile:IsActive() or not p363.BuildCameraActive or GuiService.MenuIsOpen or p363.PaintResetConfirmOpen or p363.ModernController and p363.ModernController:IsGamepad() and string.match(p375.UserInputType.Name, "^Gamepad") then
            return
        end

        if p363.DeleteAllConfirmOpen then
            if p375.KeyCode == Enum.KeyCode.Escape or p375.KeyCode == Enum.KeyCode.ButtonB then
                p363:SetDeleteAllConfirmation(false)
            end
        else
            if p375.KeyCode == Enum.KeyCode.ButtonA then
                local SelectedObject = GuiService.SelectedObject
                local v868 = p363.BuildTransformButtonCallbacks and p363.BuildTransformButtonCallbacks[SelectedObject]

                if v868 then
                    p363:BeginBuildTransformHold(SelectedObject, p375, v868)

                    return
                end
            end

            local v869 = Vector2.new(p375.Position.X, p375.Position.Y)

            if p363.DesktopCatalogue and p363.DesktopCatalogue:IsPointerOver() and (p375.UserInputType == Enum.UserInputType.MouseButton1 or p375.UserInputType == Enum.UserInputType.MouseButton2 or p375.UserInputType == Enum.UserInputType.MouseButton3) then
                return
            end

            if p375.UserInputType ~= Enum.UserInputType.MouseButton1 or p376 then
                if p375.UserInputType == Enum.UserInputType.MouseButton2 and not p363.ClassicBuildActive and not p363.BuildCameraLocked and not pointerOverInteractiveGui(v869) then
                    p363.BuildViewPreset = nil
                    p363:BeginBuildMouseCameraDrag("Orbit")
                elseif p375.UserInputType == Enum.UserInputType.MouseButton3 and not p376 and not p363.BuildCameraLocked then
                    p363:BeginBuildMouseCameraDrag("Pan")
                elseif p375.UserInputType == Enum.UserInputType.Touch then
                    if not (pointerInsideMobileCameraControls(v869) or pointerOverInteractiveGui(v869)) then
                        local BuildPendingTouchSelection = p363.BuildPendingTouchSelection

                        if BuildPendingTouchSelection and BuildPendingTouchSelection.Input ~= p375 and p363.BuildPendingTouchSelection then
                            p363.BuildPendingTouchSelection = nil

                            if not p363.EditObject then
                                p363:ClearBuildObjectHover()
                            end
                        end

                        if p363.BuildDirectTouch then
                            if not p363.BuildTouches[p375] then
                                p363.BuildTouches[p375] = v869
                                table.insert(p363.BuildTouchOrder, p375)
                            end
                        elseif p363.Painting or #p363.BuildTouchOrder ~= 0 then
                            if p376 then
                                return
                            end

                            if not p363.BuildTouches[p375] then
                                p363.BuildTouches[p375] = v869
                                table.insert(p363.BuildTouchOrder, p375)
                            end
                        elseif p363.EditObject or p363.DeletingObjects then
                            if p363:ActivateBuildObjectAt(v869, p375.UserInputType, p375) then
                                removeTouch(p375)
                            elseif not p363.BuildTouches[p375] then
                                p363.BuildTouches[p375] = v869
                                table.insert(p363.BuildTouchOrder, p375)
                            end
                        else
                            local v870 = p363:UpdateBuildObjectHover(v869, true)

                            if v870 then
                                beginPendingTouchSelection(p375, v869, v870)
                            elseif not p363.BuildTouches[p375] then
                                p363.BuildTouches[p375] = v869
                                table.insert(p363.BuildTouchOrder, p375)
                            end
                        end

                        p363.BuildPinchMid = nil
                        p363.BuildPinchDistance = nil
                    end
                else
                    local MouseLocation, v871

                    if p375.KeyCode ~= Enum.KeyCode.ButtonA or p363.Painting then
                        if p375.KeyCode == Enum.KeyCode.ButtonR2 then
                            if p363.BuildModeKind == "Objects" and not p363.Painting and not UserInputService:GetFocusedTextBox() then
                                p363:RotateBuildObjectStep("Y", 1)
                            end
                        else
                            if p375.KeyCode == Enum.KeyCode.ButtonL3 then
                                p363:SetBuildCameraLocked(not p363.BuildCameraLocked)

                                return
                            end

                            if p375.KeyCode == Enum.KeyCode.ButtonR3 then
                                if p363.Painting and p363.ColorPickerHUD then
                                    p363.PaintPickerPreviousGamepadNavigation = nil
                                end

                                p363:SetBuildGamepadNavigation(not p363.BuildGamepadNavigation)

                                return
                            end

                            if p363.Painting then
                                return
                            end

                            if p375.KeyCode == Enum.KeyCode.G and not UserInputService:GetFocusedTextBox() then
                                p363.BuildGridEnabled = not p363.BuildGridEnabled
                                p363:RebuildBuildGrid()
                                p363:UpdateBuildGui()

                                return
                            end

                            if p375.KeyCode == Enum.KeyCode.R and not UserInputService:GetFocusedTextBox() then
                                p363:QuarterTurnBuildObject("Y")

                                return
                            end

                            if p375.KeyCode == Enum.KeyCode.T and not UserInputService:GetFocusedTextBox() then
                                p363:QuarterTurnBuildObject("Z")

                                return
                            end

                            if p375.KeyCode == Enum.KeyCode.PageUp and not UserInputService:GetFocusedTextBox() then
                                p363:AdjustBuildGridHeight(1)

                                return
                            end

                            if p375.KeyCode == Enum.KeyCode.PageDown and not UserInputService:GetFocusedTextBox() then
                                p363:AdjustBuildGridHeight(-1)

                                return
                            end

                            if p375.KeyCode == Enum.KeyCode.One and not UserInputService:GetFocusedTextBox() then
                                p363:SetBuildTransformMode("Move")

                                return
                            end

                            if p375.KeyCode == Enum.KeyCode.Two and not UserInputService:GetFocusedTextBox() then
                                p363:SetBuildTransformMode("Rotate")
                            elseif p375.KeyCode == Enum.KeyCode.Return and not UserInputService:GetFocusedTextBox() and os.clock() - (p363.DesktopCatalogueTextReleasedAt or (-1e999)) > 0.15 then
                                p363:AttemptPlaceBuildObject()
                            elseif p375.KeyCode == Enum.KeyCode.ButtonB and not p363.BuildGamepadNavigation then
                                p363:DeleteEditObject()
                            elseif p375.KeyCode == Enum.KeyCode.ButtonX and not p363.BuildGamepadNavigation then
                                p363:SetBuildTransformMode("Move")
                            else
                                if p375.KeyCode ~= Enum.KeyCode.ButtonY or p363.BuildGamepadNavigation then
                                    return
                                end

                                p363:SetBuildTransformMode("Rotate")
                            end
                        end
                    else
                        MouseLocation = UserInputService:GetMouseLocation()

                        if p363.BuildGamepadNavigation then
                            v871 = not pointerOverInteractiveGui(p363.Mouse and Vector2.new(p363.Mouse.X, p363.Mouse.Y) or MouseLocation)
                        else
                            MouseLocation = workspace.CurrentCamera.ViewportSize / 2
                            v871 = GuiService.SelectedObject == nil
                        end

                        if v871 then
                            if p363.BuildGamepadNavigation then
                                p363.BuildPendingGamepadGrab = {
                                    Input = p375,
                                    Position = MouseLocation
                                }
                            else
                                p363:ActivateBuildObjectAt(MouseLocation, p375.UserInputType, p375)
                            end
                        end
                    end
                end
            else
                if pointerInsideMobileCameraControls(v869) then
                    return
                end

                if not p363.Painting then
                    p363:ActivateBuildObjectAt(UserInputService:GetMouseLocation(), p375.UserInputType, p375)
                end
            end
        end
    end)

    table.insert(p363.BuildInputCons, connection2)

    local connection3 = UserInputService.InputChanged:Connect(function(p377, p378) -- line: 6851
        -- upvalues: p363 (copy), pointerOverScrollingGui (copy), UserInputService (copy), GuiService (copy)
        if p363.ModernMobile and p363.ModernMobile:IsActive() or p363.ModernController and p363.ModernController:IsGamepad() and string.match(p377.UserInputType.Name, "^Gamepad") then
            return
        end

        if p363.BuildCameraActive and not p363.DeleteAllConfirmOpen and not p363.PaintResetConfirmOpen and not GuiService.MenuIsOpen then
            if p377.UserInputType == Enum.UserInputType.MouseMovement then
                if p363.BuildDirectMouse then
                    p363:UpdateDirectBuildDrag(UserInputService:GetMouseLocation())
                end

                if p363.BuildCameraLocked then
                    return
                end

                if p363.BuildMouseOrbit then
                    p363.BuildViewPreset = nil
                    p363.BuildCameraYaw -= p377.Delta.X * 0.0045
                    p363.BuildCameraPitch = math.clamp(p363.BuildCameraPitch - p377.Delta.Y * 0.0045, -1.5533430342749532, 1.3089969389957472)
                elseif p363.BuildMousePan then
                    p363:PanBuildCameraPixels(Vector2.new(p377.Delta.X, p377.Delta.Y))
                end
            elseif p377.UserInputType == Enum.UserInputType.MouseWheel then
                if not (p378 or pointerOverScrollingGui() or p363.BuildCameraLocked or p363.DesktopCatalogue and p363.DesktopCatalogue:IsPointerOver()) then
                    local _, BuildReference = p363:GetBuildReference()
                    local v875 = BuildReference and math.max(BuildReference.Size.X, BuildReference.Size.Y, BuildReference.Size.Z) or 30
                    local CurrentCamera = workspace.CurrentCamera

                    p363.BuildCameraPosition = (p363.BuildCameraPosition or CurrentCamera.CFrame.Position) + CurrentCamera.CFrame.LookVector * p377.Position.Z * v875 * 0.08
                end
            elseif p377.UserInputType == Enum.UserInputType.Touch and p363.BuildPendingTouchSelection and p363.BuildPendingTouchSelection.Input == p377 then
                local BuildPendingTouchSelection = p363.BuildPendingTouchSelection
                local v876 = Vector2.new(p377.Position.X, p377.Position.Y)

                BuildPendingTouchSelection.Position = v876

                local v877 = (v876 - BuildPendingTouchSelection.StartPosition).Magnitude > 18
                local v878 = false

                if (v876 - BuildPendingTouchSelection.LastCheckedPosition).Magnitude >= 4 then
                    BuildPendingTouchSelection.LastCheckedPosition = v876
                    v878 = p363:GetPlacedBuildObjectAtScreenPosition(v876) ~= BuildPendingTouchSelection.Object
                end

                if v877 or v878 then
                    local BuildPendingTouchSelection = p363.BuildPendingTouchSelection

                    if BuildPendingTouchSelection and (not p377 or BuildPendingTouchSelection.Input == p377) then
                        p363.BuildPendingTouchSelection = nil

                        if not p363.EditObject then
                            p363:ClearBuildObjectHover()
                        end
                    end

                    if p363.BuildTouches[p377] then
                        p363.BuildTouches[p377] = v876
                    end
                end
            elseif p377.UserInputType == Enum.UserInputType.Touch and p377 == p363.BuildDirectTouch then
                p363:UpdateDirectBuildDrag(Vector2.new(p377.Position.X, p377.Position.Y))
            elseif p377.UserInputType == Enum.UserInputType.Touch and p363.BuildTouches[p377] then
                local v879 = p363.BuildTouches[p377]
                local v880 = Vector2.new(p377.Position.X, p377.Position.Y)

                p363.BuildTouches[p377] = v880

                if p363.BuildCameraLocked then
                    return
                end

                if #p363.BuildTouchOrder == 1 then
                    p363.BuildViewPreset = nil

                    local v881 = v880 - v879

                    p363.BuildCameraYaw -= v881.X * 0.007
                    p363.BuildCameraPitch = math.clamp(p363.BuildCameraPitch - v881.Y * 0.007, -1.5533430342749532, 1.3089969389957472)
                else
                    local v883, Magnitude

                    if #p363.BuildTouchOrder >= 2 then
                        local v884 = p363.BuildTouches[p363.BuildTouchOrder[1]]
                        local v885 = p363.BuildTouches[p363.BuildTouchOrder[2]]

                        if v884 and v885 then
                            v883 = (v884 + v885) / 2
                            Magnitude = (v884 - v885).Magnitude

                            if p363.BuildPinchMid and p363.BuildPinchDistance then
                                p363:PanBuildCameraPixels(v883 - p363.BuildPinchMid)

                                local CurrentCamera = workspace.CurrentCamera

                                p363.BuildCameraPosition = (p363.BuildCameraPosition or CurrentCamera.CFrame.Position) + CurrentCamera.CFrame.LookVector * (Magnitude - p363.BuildPinchDistance) * 0.06
                            end

                            p363.BuildPinchMid = v883
                            p363.BuildPinchDistance = Magnitude
                        end
                    end
                end
            end
        end
    end)

    table.insert(p363.BuildInputCons, connection3)

    local connection4 = UserInputService.InputEnded:Connect(function(p379) -- line: 6929
        -- upvalues: p363 (copy), removeTouch (copy)
        if p363.ModernMobile and p363.ModernMobile:IsActive() or p363.ModernController and p363.ModernController:IsGamepad() and string.match(p379.UserInputType.Name, "^Gamepad") then
            return
        end

        p363:EndBuildTransformHold(p379)
        p363:EndBuildMobileCameraInput(p379)

        if p379.KeyCode == Enum.KeyCode.ButtonA then
            p363.BuildPendingGamepadGrab = nil

            if p363.BuildDirectGamepad then
                p363:EndDirectBuildDrag()
            end
        elseif p379.UserInputType == Enum.UserInputType.MouseButton1 then
            p363:EndDirectBuildDrag()
            p363.BuildDragStartPosition = nil
            p363.BuildDragStartRotation = nil
            p363.BuildGizmoDragging = nil
        elseif p379.UserInputType == Enum.UserInputType.MouseButton2 then
            p363:EndBuildMouseCameraDrag("Orbit")
        elseif p379.UserInputType == Enum.UserInputType.MouseButton3 then
            p363:EndBuildMouseCameraDrag("Pan")
        elseif p379.UserInputType == Enum.UserInputType.Touch then
            local BuildPendingTouchSelection = p363.BuildPendingTouchSelection

            if BuildPendingTouchSelection and (not p379 or BuildPendingTouchSelection.Input == p379) then
                p363.BuildPendingTouchSelection = nil

                if not p363.EditObject then
                    p363:ClearBuildObjectHover()
                end
            end

            if p379 == p363.BuildDirectTouch then
                p363:EndDirectBuildDrag()
            else
                removeTouch(p379)
            end
        end
    end)

    table.insert(p363.BuildInputCons, connection4)

    local function releaseBuildInputs() -- line: 6958
        -- upvalues: p363 (copy)
        if p363.BuildPendingTouchSelection then
            p363.BuildPendingTouchSelection = nil

            if not p363.EditObject then
                p363:ClearBuildObjectHover()
            end
        end

        p363:EndBuildTouchGizmoDrag()
        p363:EndBuildTransformHold()
        p363:EndDirectBuildDrag()
        p363:EndBuildMouseCameraDrag()
        p363:ClearBuildMobileCameraInputs()
        p363.BuildPendingGamepadGrab = nil
        p363.BuildTouches = {}
        p363.BuildTouchOrder = {}
        p363.BuildPinchMid = nil
        p363.BuildPinchDistance = nil
    end

    local connection5 = UserInputService.WindowFocusReleased:Connect(releaseBuildInputs)

    table.insert(p363.BuildInputCons, connection5)

    local connection6 = GuiService.MenuOpened:Connect(releaseBuildInputs)

    table.insert(p363.BuildInputCons, connection6)
end

function t1.SetDeletingObjects(p380, p381) -- line: 6975
    -- upvalues: v360 (copy), styleBuildButton (copy)
    p380.ClassicBuildRightMouse = nil
    p380.DeletingObjects = p381 == true

    if not p380.DeletingObjects and p380.ModernDesktop then
        p380.ModernDesktop:CancelPendingDeletes()
    end

    if p380.DeletingObjects and p380.EditObject then
        p380:DeleteEditObject()
    end

    p380:ClearBuildObjectHover()

    local BuildGui = p380.BuildGui

    if not (BuildGui and BuildGui.Parent) then
        BuildGui = p380.Player.PlayerGui:FindFirstChild("BuildModeGui")
    end

    BuildGui = BuildGui and BuildGui:FindFirstChild("Toolbar") and BuildGui.Toolbar:FindFirstChild("Buttons")

    local DeleteMode = BuildGui and BuildGui:FindFirstChild("DeleteMode")

    if DeleteMode then
        DeleteMode.Text = p380.DeletingObjects and "Delete: On" or "Delete: Off"
        styleBuildButton(DeleteMode, p380.DeletingObjects, p380.DeletingObjects and v360 or nil)
    end

    if p380.ClassicBuildActive then
        p380:ApplyClassicBuildPresentation()
    end
end

function t1.SetDeleteAllConfirmation(p382, p383) -- line: 6999
    -- upvalues: UserInputService (copy), GuiService (copy), PaintController (copy)
    local v888 = p382.BuildGui and p382.BuildGui:FindFirstChild("DeleteAllConfirm")

    if not v888 then
        return false
    end

    if p383 == true and p382.BuildCameraActive == true and p382.BuildModeKind == "Objects" then
        if p382.DeleteAllConfirmOpen then
            return true
        end

        PaintController.HideResetConfirmation(p382)
        p382.DeleteAllPreviousSelection = GuiService.SelectedObject
        p382.DeleteAllConfirmOpen = true
        v888.Visible = true
        p382:EndBuildTouchGizmoDrag()
        p382:EndBuildTransformHold()
        p382:EndDirectBuildDrag()
        p382:ClearBuildMobileCameraInputs()
        p382.BuildPendingTouchSelection = nil
        p382.BuildPendingGamepadGrab = nil
        p382:EndBuildMouseCameraDrag()

        local v889 = v888:FindFirstChild("Cancel", true)

        if UserInputService.GamepadEnabled and v889 and v889:IsA("GuiButton") then
            GuiService.SelectedObject = v889
        end
    else
        local v890 = p382.DeleteAllConfirmOpen == true
        local DeleteAllPreviousSelection = p382.DeleteAllPreviousSelection

        p382.DeleteAllConfirmOpen = nil
        p382.DeleteAllPreviousSelection = nil
        v888.Visible = false

        local GuiService2, DeleteAllPreviousSelection2

        if v890 then
            local SelectedObject = GuiService.SelectedObject

            if SelectedObject and SelectedObject:IsDescendantOf(v888) then
                GuiService2 = GuiService

                if DeleteAllPreviousSelection and DeleteAllPreviousSelection.Parent then
                    DeleteAllPreviousSelection2 = DeleteAllPreviousSelection
                end

                GuiService2.SelectedObject = DeleteAllPreviousSelection2
            end
        end
    end

    if p382.ClassicDesktop then
        p382.ClassicDesktop:Refresh()
    end

    if p382.ModernDesktop then
        p382.ModernDesktop:Refresh()
    end

    return true
end

function t1.SetupBuildGui(p384) -- line: 7041
    -- upvalues: RemoteEvent (copy), t23 (copy)
    if p384.BuildGuiWired and p384.BuildGui and p384.BuildGui.Parent then
        return true
    end

    local v891 = p384.Player.PlayerGui:FindFirstChild("BuildModeGui") or p384.Player.PlayerGui:WaitForChild("BuildModeGui", 5)

    if not v891 then
        return false
    end

    p384.BuildGui = v891
    p384.BuildGuiWired = true
    p384.BuildGuiCons = p384.BuildGuiCons or {}

    local function connect(p385, p386) -- line: 7048
        -- upvalues: p384 (copy)
        table.insert(p384.BuildGuiCons, p385.Activated:Connect(p386))
    end

    p384.BuildTransformButtonCallbacks = p384.BuildTransformButtonCallbacks or setmetatable({}, {
        __mode = "k"
    })

    local function connectHold(p387, p388) -- line: 7053
        -- upvalues: p384 (copy)
        p384.BuildTransformButtonCallbacks[p387] = p388
        table.insert(p384.BuildGuiCons, p387.InputBegan:Connect(function(p389) -- line: 7055
            -- upvalues: p387 (copy), p388 (copy), p384 (copy)
            if p389.UserInputType == Enum.UserInputType.MouseButton1 or p389.UserInputType == Enum.UserInputType.Touch or p389.KeyCode == Enum.KeyCode.ButtonA then
                p384:BeginBuildTransformHold(p387, p389, p388)
            end
        end))
        table.insert(p384.BuildGuiCons, p387.InputEnded:Connect(function(p390) -- line: 7063
            -- upvalues: p384 (copy)
            p384:EndBuildTransformHold(p390)
            task.delay(1, function() -- line: 7065
                -- upvalues: p390 (copy), p384 (copy)
                local BuildTransformHandledActivations = p384.BuildTransformHandledActivations

                if BuildTransformHandledActivations then
                    BuildTransformHandledActivations[p390] = nil
                end
            end)
        end))
        table.insert(p384.BuildGuiCons, p387.Activated:Connect(function(p391) -- line: 7070
            -- upvalues: p388 (copy), p384 (copy)
            local BuildTransformHandledActivations = p384.BuildTransformHandledActivations

            if p391 and BuildTransformHandledActivations and BuildTransformHandledActivations[p391] then
                BuildTransformHandledActivations[p391] = nil
            else
                p388()
            end
        end))
    end

    local BuildSystemToggle = v891:FindFirstChild("BuildSystemToggle")

    if BuildSystemToggle and BuildSystemToggle:IsA("GuiButton") then
        local function v895() -- line: 7081
            -- upvalues: p384 (copy)
            p384:SetBuildSystem(nil, true)
        end

        table.insert(p384.BuildGuiCons, BuildSystemToggle.Activated:Connect(v895))
    end

    local Buttons = v891.Toolbar.Buttons
    local MoveMode = Buttons.MoveMode

    local function v896() -- line: 7086
        -- upvalues: p384 (copy)
        p384:SetBuildTransformMode("Move")
    end

    table.insert(p384.BuildGuiCons, MoveMode.Activated:Connect(v896))

    local RotateMode = Buttons.RotateMode

    local function v897() -- line: 7087
        -- upvalues: p384 (copy)
        p384:SetBuildTransformMode("Rotate")
    end

    table.insert(p384.BuildGuiCons, RotateMode.Activated:Connect(v897))

    local Place = Buttons.Place

    local function v898() -- line: 7088
        -- upvalues: p384 (copy)
        p384:AttemptPlaceBuildObject()
    end

    table.insert(p384.BuildGuiCons, Place.Activated:Connect(v898))

    local Cancel = Buttons.Cancel

    local function v899() -- line: 7089
        -- upvalues: p384 (copy)
        p384:DeleteEditObject()
    end

    table.insert(p384.BuildGuiCons, Cancel.Activated:Connect(v899))

    local Grid = Buttons.Grid

    local function v900() -- line: 7090
        -- upvalues: p384 (copy)
        p384.BuildGridEnabled = not p384.BuildGridEnabled
        p384:RebuildBuildGrid()
        p384:UpdateBuildGui()
    end

    table.insert(p384.BuildGuiCons, Grid.Activated:Connect(v900))

    local MoveStep = Buttons.MoveStep

    local function v901() -- line: 7095
        -- upvalues: p384 (copy)
        p384:CycleBuildMoveStep()
    end

    table.insert(p384.BuildGuiCons, MoveStep.Activated:Connect(v901))

    local RotateStep = Buttons.RotateStep

    local function v902() -- line: 7096
        -- upvalues: p384 (copy)
        p384:CycleBuildRotateStep()
    end

    table.insert(p384.BuildGuiCons, RotateStep.Activated:Connect(v902))

    local CameraLock = Buttons:FindFirstChild("CameraLock")

    if CameraLock then
        local function v903() -- line: 7099
            -- upvalues: p384 (copy)
            p384:SetBuildCameraLocked(not p384.BuildCameraLocked)
        end

        table.insert(p384.BuildGuiCons, CameraLock.Activated:Connect(v903))
    end

    local PaintMode = Buttons:FindFirstChild("PaintMode")

    if PaintMode then
        local function v904() -- line: 7105
            -- upvalues: p384 (copy)
            if p384.Painting then
                p384:ClosePaintFrames()
            elseif p384.EditingBase then
                p384:OpenPaintFrames()
            end
        end

        table.insert(p384.BuildGuiCons, PaintMode.Activated:Connect(v904))
    end

    local DeleteMode = Buttons.DeleteMode

    local function v905() -- line: 7113
        -- upvalues: p384 (copy)
        p384:SetDeletingObjects(not p384.DeletingObjects)
    end

    table.insert(p384.BuildGuiCons, DeleteMode.Activated:Connect(v905))

    local DeleteAll = Buttons.DeleteAll

    local function v906() -- line: 7116
        -- upvalues: p384 (copy)
        p384:SetDeleteAllConfirmation(true)
    end

    table.insert(p384.BuildGuiCons, DeleteAll.Activated:Connect(v906))

    local DeleteAllConfirm = v891:FindFirstChild("DeleteAllConfirm")
    local Panel = DeleteAllConfirm and DeleteAllConfirm:FindFirstChild("Panel")

    if Panel then
        local Confirm = Panel:FindFirstChild("Confirm")
        local Cancel = Panel:FindFirstChild("Cancel")

        if Confirm and Confirm:IsA("GuiButton") then
            local function v907() -- line: 7125
                -- upvalues: p384 (copy), RemoteEvent (copy)
                if not p384.DeleteAllConfirmOpen
                    or p384.ClassicDesktop and p384.ClassicDesktop.Busy
                    or p384.ClassicMobile and p384.ClassicMobile.Busy
                    or p384.ModernDesktop and p384.ModernDesktop.Busy
                    or p384.ClassicController and p384.ClassicController.Busy
                    or p384.ModernController and p384.ModernController.Busy then
                    return
                end

                p384:SetDeleteAllConfirmation(false)
                p384:DeleteEditObject()
                p384:SetDeletingObjects(false)
                RemoteEvent:FireServer("DeleteAllObjects", true)

                local ClassicDesktop = p384.ClassicDesktop

                if ClassicDesktop then
                    task.defer(function() -- line: 7137
                        -- upvalues: ClassicDesktop (copy)
                        ClassicDesktop:RefreshState()
                    end)
                end

                local ClassicMobile = p384.ClassicMobile

                if ClassicMobile then
                    task.defer(function() -- line: 7139
                        -- upvalues: ClassicMobile (copy)
                        ClassicMobile:RefreshState()
                    end)
                end

                local ModernDesktop = p384.ModernDesktop

                if ModernDesktop then
                    task.defer(function() -- line: 7141
                        -- upvalues: ModernDesktop (copy)
                        ModernDesktop:RefreshState()
                    end)
                end

                local ClassicController = p384.ClassicController

                if ClassicController then
                    task.defer(function() -- line: 7143
                        -- upvalues: ClassicController (copy)
                        ClassicController:RefreshState()
                    end)
                end

                local ModernController = p384.ModernController

                if ModernController then
                    task.defer(function() -- line: 7145
                        -- upvalues: ModernController (copy)
                        ModernController:RefreshState()
                    end)
                end
            end

            table.insert(p384.BuildGuiCons, Confirm.Activated:Connect(v907))
        end

        if Cancel and Cancel:IsA("GuiButton") then
            local function v908() -- line: 7149
                -- upvalues: p384 (copy)
                p384:SetDeleteAllConfirmation(false)
            end

            table.insert(p384.BuildGuiCons, Cancel.Activated:Connect(v908))
        end
    end

    local Exit = Buttons.Exit

    local function v909() -- line: 7154
        -- upvalues: p384 (copy)
        if p384.Painting then
            p384:ClosePaintFrames()
        elseif p384.EditingBase then
            p384:StopEditStorage()
        end
    end

    table.insert(p384.BuildGuiCons, Exit.Activated:Connect(v909))

    for _, v910 in ipairs({ "X", "Y", "Z" }) do
        local v911 = v891.TransformPanel.AxisRows[v910]

        connectHold(v911.Minus, function() -- line: 7163
            -- upvalues: p384 (copy), v910 (copy)
            p384:NudgeBuildObject(v910, -1)
        end)
        connectHold(v911.Plus, function() -- line: 7164
            -- upvalues: p384 (copy), v910 (copy)
            p384:NudgeBuildObject(v910, 1)
        end)
    end

    local GridHeight = v891.TransformPanel.AxisRows:FindFirstChild("GridHeight")

    if GridHeight then
        connectHold(GridHeight.Minus, function() -- line: 7168
            -- upvalues: p384 (copy)
            p384:AdjustBuildGridHeight(-1)
        end)
        connectHold(GridHeight.Plus, function() -- line: 7169
            -- upvalues: p384 (copy)
            p384:AdjustBuildGridHeight(1)
        end)
    end

    for _, v912 in ipairs({ "Top", "Front", "Back", "Left", "Right", "Iso" }) do
        local v913 = v891.ViewPanel.Views[v912]

        local function v914() -- line: 7172
            -- upvalues: p384 (copy), v912 (copy)
            p384:SetBuildView(v912)
        end

        table.insert(p384.BuildGuiCons, v913.Activated:Connect(v914))
    end

    local CollapseButton = v891.ViewPanel:FindFirstChild("CollapseButton")

    if CollapseButton and CollapseButton:IsA("GuiButton") then
        local function v915() -- line: 7176
            -- upvalues: p384 (copy)
            p384:ToggleBuildViewPanel()
        end

        table.insert(p384.BuildGuiCons, CollapseButton.Activated:Connect(v915))
    end

    p384:UpdateBuildViewPanel()

    local t46 = {
        Forward = Vector3.new(0, 0, -1),
        Back = Vector3.new(0, 0, 1),
        Left = Vector3.new(-1, 0, 0),
        Right = Vector3.new(1, 0, 0),
        Up = Vector3.new(0, 1, 0),
        Down = Vector3.new(0, -1, 0)
    }
    local v916 = v891:FindFirstChild("MobileCameraContols") or v891:FindFirstChild("MobileCameraControls")

    if v916 then
        v916.Visible = false

        for v917, v918 in pairs(t46) do
            local v919 = v916:FindFirstChild(v917, true)

            if v919 and v919:IsA("GuiButton") then
                table.insert(p384.BuildGuiCons, v919.InputBegan:Connect(function(p392) -- line: 7198
                    -- upvalues: p384 (copy), v919 (copy), v918 (copy)
                    if p392.UserInputType == Enum.UserInputType.Touch or p392.UserInputType == Enum.UserInputType.MouseButton1 then
                        p384:BeginBuildMobileCameraInput(p392, v919, v918)
                    end
                end))
                table.insert(p384.BuildGuiCons, v919.InputEnded:Connect(function(p393) -- line: 7205
                    -- upvalues: p384 (copy)
                    p384:EndBuildMobileCameraInput(p393)
                end))
            end
        end
    end

    for _, v922 in ipairs({ "MoveX", "MoveY", "MoveZ" }) do
        local v923 = v891[v922]

        table.insert(p384.BuildGuiCons, v923.MouseButton1Down:Connect(function() -- line: 7214
            -- upvalues: p384 (copy)
            p384:EndDirectBuildDrag()
            p384.BuildGizmoActivatedAt = os.clock()
            p384.BuildGizmoDragging = true
            p384.BuildDragStartPosition = p384.BuildObjectPosition
        end))
        table.insert(p384.BuildGuiCons, v923.MouseDrag:Connect(function(p394, p395) -- line: 7220
            -- upvalues: p384 (copy)
            if not (p384.EditObject and p384.BuildDragStartPosition) then
                return
            end

            local v926 = p384.StorageBase and p384.StorageBase:FindFirstChild("Floor")

            if not v926 then
                return
            end

            local v927 = Vector3.FromNormalId(p394)
            local Unit = v926.CFrame:VectorToObjectSpace(v927).Unit
            local v928 = p384.BuildMoveStep or 0.5
            local v929 = if not v928 or v928 <= 0 then p395 else math.round(p395 / v928) * v928
            local v931 = Unit * v929

            p384.BuildObjectPosition = p384:GetClampedBuildPosition(p384.BuildDragStartPosition + v931, p384.BuildObjectRotation)
            p384.BuildTransformDirty = true
        end))
        table.insert(p384.BuildGuiCons, v923.MouseButton1Up:Connect(function() -- line: 7233
            -- upvalues: p384 (copy)
            p384.BuildDragStartPosition = nil
            p384.BuildGizmoDragging = nil
        end))
    end

    for _, v933 in ipairs({ "RotateX", "RotateY", "RotateZ" }) do
        local v934 = v891[v933]

        table.insert(p384.BuildGuiCons, v934.MouseButton1Down:Connect(function() -- line: 7240
            -- upvalues: p384 (copy)
            p384:EndDirectBuildDrag()
            p384.BuildGizmoActivatedAt = os.clock()
            p384.BuildGizmoDragging = true
            p384.BuildDragStartRotation = p384.BuildObjectRotation
        end))
        table.insert(p384.BuildGuiCons, v934.MouseDrag:Connect(function(p396, p397) -- line: 7246
            -- upvalues: p384 (copy), t23 (copy)
            if p384.EditObject and p384.BuildDragStartRotation then
                local v937 = math.deg(p397)
                local v938 = p384.BuildRotateStep or 15

                if v938 and not (v938 <= 0) then
                    v937 = math.round(v937 / v938) * v938
                end

                local v940 = if p396 == Enum.Axis.X then "X" elseif p396 == Enum.Axis.Y then "Y" else p396 == Enum.Axis.Z and "Z"

                if not v940 then
                    return
                end

                local BuildDragStartRotation = p384.BuildDragStartRotation
                local v941 = t23[v940]

                if v941 then
                    local v942 = BuildDragStartRotation or Vector3.new(-90, 90, 0)
                    local v945, v946, v947 = (CFrame.Angles(math.rad(v942.X), math.rad(v942.Y), (math.rad(v942.Z))) * CFrame.fromAxisAngle(v941, (math.rad(v937)))):ToEulerAnglesXYZ()

                    BuildDragStartRotation = Vector3.new(math.deg(v945), math.deg(v946), (math.deg(v947)))
                end

                p384.BuildObjectRotation = BuildDragStartRotation
                p384:ClampBuildObjectToBounds()
                p384.BuildTransformDirty = true
            end
        end))
        table.insert(p384.BuildGuiCons, v934.MouseButton1Up:Connect(function() -- line: 7261
            -- upvalues: p384 (copy)
            p384.BuildDragStartRotation = nil
            p384.BuildGizmoDragging = nil
        end))
    end

    return true
end

function t1.SetBuildPanelToggleHidden(p398, p399) -- line: 7269
    -- upvalues: GuiService (copy)
    if p399 then
        if p398.BuildPanelHiddenObjects then
            return
        end

        local PlayerGui = p398.Player:FindFirstChildOfClass("PlayerGui")

        if not PlayerGui then
            return
        end

        p398.BuildPanelHiddenObjects = {}
        p398.BuildPanelVisibilityCons = {}

        local function hideToggle(p400) -- line: 7276
            -- upvalues: p398 (copy), PlayerGui (copy), GuiService (copy)
            local Parent = p400.Parent

            if p400.Name ~= "Toggle"
                or not p400:IsA("GuiObject")
                or not Parent
                or Parent.Name ~= "Panel"
                or Parent.Parent ~= PlayerGui
                or p398.BuildPanelHiddenObjects[p400] ~= nil then
                return
            end

            p398.BuildPanelHiddenObjects[p400] = p400.Visible
            p400.Visible = false

            if GuiService.SelectedObject == p400 then
                GuiService.SelectedObject = nil
            end

            table.insert(p398.BuildPanelVisibilityCons, p400:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 7284
                -- upvalues: p400 (copy), p398 (copy)
                if p400.Visible then
                    p398.BuildPanelHiddenObjects[p400] = true
                    p400.Visible = false
                end
            end))
        end

        table.insert(p398.BuildPanelVisibilityCons, PlayerGui.DescendantAdded:Connect(hideToggle))

        local Panel = PlayerGui:FindFirstChild("Panel")
        local Toggle = Panel and Panel:FindFirstChild("Toggle")

        if Toggle then
            hideToggle(Toggle)
        end
    else
        for _, v953 in ipairs(p398.BuildPanelVisibilityCons or {}) do
            v953:Disconnect()
        end

        p398.BuildPanelVisibilityCons = nil

        for v954, v955 in pairs(p398.BuildPanelHiddenObjects or {}) do
            if v954.Parent then
                v954.Visible = v955
            end
        end

        p398.BuildPanelHiddenObjects = nil
    end
end

function t1.SetBuildClutterHidden(p401, p402) -- line: 7305
    local t47 = {
        "GuideButton",
        "DailyRewardsButton",
        "LikeButton",
        "Guide",
        "DailyRewards",
        "LikeReward",
        "Clock",
        "BaseEdit",
        "BaseCoord",
        "XCoordinate",
        "ZCoordinate"
    }

    if p402 then
        if p401.BuildHiddenGuiObjects then
            return
        end

        p401.BuildHiddenGuiObjects = {}

        for _, v956 in ipairs(t47) do
            local v957 = p401.HUD:FindFirstChild(v956)

            if v957 and v957:IsA("GuiObject") then
                p401.BuildHiddenGuiObjects[v957] = v957.Visible
                v957.Visible = false
            end
        end

        p401.BuildDisabledPrompts = {}

        local v958 = p401.StorageBase and p401.StorageBase:FindFirstChild("Contents")
        local v959 = v958 and v958:FindFirstChild("DoorSwitch", true)

        if v959 then
            for _, descendant in ipairs(v959:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then
                    p401.BuildDisabledPrompts[descendant] = descendant.Enabled
                    descendant.Enabled = false
                end
            end
        end
    else
        if p401.BuildHiddenGuiObjects then
            for v960, v961 in pairs(p401.BuildHiddenGuiObjects) do
                if v960 and v960.Parent then
                    v960.Visible = v961
                end
            end

            p401.BuildHiddenGuiObjects = nil
        end

        if p401.BuildDisabledPrompts then
            for v962, v963 in pairs(p401.BuildDisabledPrompts) do
                if v962 and v962.Parent then
                    v962.Enabled = v963
                end
            end

            p401.BuildDisabledPrompts = nil
        end
    end
end

function t1.IsClassicBuildSystem(p403) -- line: 7362
    return p403.Data ~= nil and p403.Data.BuildSystem == "Classic"
end

function t1.SetClassicDesktopBuildClutterHidden(p404, p405) -- line: 7366
    if p405 then
        p404.ClassicDesktopBuildHiddenGuiObjects = p404.ClassicDesktopBuildHiddenGuiObjects or {}

        for _, v964 in ipairs({ "GuideButton", "DailyRewardsButton", "LikeButton" }) do
            local v965 = p404.HUD and p404.HUD:FindFirstChild(v964)

            if v965 and v965:IsA("GuiObject") then
                if p404.ClassicDesktopBuildHiddenGuiObjects[v965] == nil then
                    p404.ClassicDesktopBuildHiddenGuiObjects[v965] = v965.Visible
                end

                v965.Visible = false
            end
        end
    elseif p404.ClassicDesktopBuildHiddenGuiObjects then
        for v966, v967 in pairs(p404.ClassicDesktopBuildHiddenGuiObjects) do
            if v966.Parent then
                local v968 = v966.Name ~= "LikeButton" or not (p404.Data and p404.Data.LikeBonus)

                v966.Visible = v967 and v968
            end
        end

        p404.ClassicDesktopBuildHiddenGuiObjects = nil
    end
end

function t1.ApplyClassicBuildPresentation(p406) -- line: 7389
    -- upvalues: UserInputService (copy), GuiService (copy)
    if p406.ClassicBuildActive then
        p406:SetClassicDesktopBuildClutterHidden(p406.BuildCameraActive == true and p406:IsDesktopBuildCatalogue())

        local BuildGui = p406.BuildGui

        if BuildGui then
            for _, v969 in ipairs({ "Toolbar", "TransformPanel", "ViewPanel", "Hint", "ControllerHotkeys", "MobileCameraContols" }) do
                local v970 = BuildGui:FindFirstChild(v969)

                if v970 and v970:IsA("GuiObject") then
                    v970.Visible = false
                end
            end
        end

        local v971 = p406.BuildModeKind == "Objects" and not p406.Painting
        local v972 = p406.HUD and p406.HUD:FindFirstChild("BaseObjects")
        local Hotkeys = v972 and v972:FindFirstChild("Hotkeys")

        if Hotkeys then
            Hotkeys.Visible = v971 and not p406.TouchEnabled

            local Place = Hotkeys:FindFirstChild("Place")
            local Deselect = Hotkeys:FindFirstChild("Deselect")

            if p406.ClassicBuildLabelText and UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse then
                if Place and Place:IsA("TextLabel") then
                    if p406.DeletingObjects then
                        Place.Text = "Delete: M1"
                    elseif p406.EditingExistingObject then
                        Place.Text = "Save Move: M1"
                    elseif p406.EditObject then
                        Place.Text = "Place: M1"
                    else
                        Place.Text = "Select Object: M1"
                    end
                end

                if Deselect and Deselect:IsA("TextLabel") then
                    if p406.EditingExistingObject then
                        Deselect.Text = "Cancel Move: E"
                    elseif p406.EditObject then
                        Deselect.Text = "Select Existing: E"
                    else
                        Deselect.Text = "Deselect: E"
                    end
                end
            end

            local Delete = Hotkeys:FindFirstChild("Delete")

            if p406.ClassicBuildLabelText and Delete and Delete:IsA("TextLabel") then
                local v973 = (GuiService:IsTenFootInterface() or UserInputService.GamepadEnabled and (not UserInputService.KeyboardEnabled or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)) and "X" or "M2"

                Delete.Text = p406.DeletingObjects and "Delete: " .. v973 or "Delete: Disabled"
            end

            local DeleteMode = Hotkeys:FindFirstChild("DeleteMode")

            if p406.ClassicBuildLabelText and DeleteMode and DeleteMode:IsA("TextLabel") then
                local v974 = (GuiService:IsTenFootInterface() or UserInputService.GamepadEnabled and (not UserInputService.KeyboardEnabled or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)) and "Y" or "F"

                DeleteMode.Text = "Delete Mode: " .. (p406.DeletingObjects and "On" or "Off") .. " (" .. v974 .. ")"
            end
        end

        if p406.HUD then
            local MobileEdits = p406.HUD:FindFirstChild("MobileEdits")
            local Delete = MobileEdits and MobileEdits:FindFirstChild("Delete")
            local ActionTitle = Delete and Delete:FindFirstChild("ActionTitle")
            local Place = MobileEdits and MobileEdits:FindFirstChild("Place")
            local ActionTitle2 = Place and Place:FindFirstChild("ActionTitle")

            if p406.ClassicBuildLabelText and ActionTitle then
                ActionTitle.Text = p406.DeletingObjects and "Delete: On" or "Delete: Off"
            end

            if p406.ClassicBuildLabelText and ActionTitle2 then
                ActionTitle2.Text = p406.DeletingObjects and "Delete Target" or "Place"
            end

            p406.HUD.MobileEdits.Visible = v971 and p406.TouchEnabled
            p406.HUD.MobileMouse.Visible = v971 and p406.TouchEnabled
        end

        if p406.ClassicController then
            p406.ClassicController:RefreshPresentation()
        end

        if p406.ClassicMobile then
            p406.ClassicMobile:RefreshPresentation()
        end

        if p406.ClassicDesktop then
            p406.ClassicDesktop:Refresh()
        end

        p406:RefreshDesktopBuildCatalogue()
    end
end

function t1.GetClassicBuildAim(p407) -- line: 7448
    -- upvalues: UserInputService (copy)
    if p407.ClassicBuildActive and p407.EditingExistingObject and UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse then
        local UnitRay = p407.Mouse.UnitRay
        local t48 = {
            workspace.CurrentCamera,
            p407.EditingExistingObject
        }

        if p407.Character then
            table.insert(t48, p407.Character)
        end

        if p407.EditObject then
            table.insert(t48, p407.EditObject)
        end

        local v975 = RaycastParams.new()

        v975.FilterType = Enum.RaycastFilterType.Exclude
        v975.IgnoreWater = true

        for _ = 1, 32 do
            v975.FilterDescendantsInstances = t48

            local v976 = workspace:Raycast(UnitRay.Origin, UnitRay.Direction * 500, v975)

            if not v976 then
                return nil, nil
            end

            local Instance = v976.Instance

            if not (Instance:IsA("BasePart") and (Instance.Transparency >= 1 or Instance.LocalTransparencyModifier >= 1)) then
                return CFrame.new(v976.Position), Instance
            end

            table.insert(t48, Instance)
        end

        return nil, nil
    end

    if p407.ClassicMobile and p407.ClassicMobile:IsActive() then
        return p407.ClassicMobile:GetAim()
    end

    if p407.ClassicController and p407.ClassicController:IsGamepad() then
        return p407.ClassicController:GetAim()
    end

    if not p407.TouchEnabled then
        return p407.Mouse.Hit, p407.Mouse.Target
    end

    local MobileAim, MobileAim2 = p407:GetMobileAim(nil, true)

    return MobileAim, MobileAim2 and MobileAim2.Instance or nil
end

function t1.GetClassicBuildPointerPosition(p408) -- line: 7482
    -- upvalues: UserInputService (copy)
    if p408.ClassicMobile and p408.ClassicMobile:IsActive() or p408.ClassicController and p408.ClassicController:IsGamepad() then
        return workspace.CurrentCamera.ViewportSize / 2
    end

    if p408.TouchEnabled then
        local v977 = p408.HUD and p408.HUD:FindFirstChild("MobileMouse")

        if v977 then
            return v977.AbsolutePosition + v977.AbsoluteSize / 2
        end
    end

    return UserInputService:GetMouseLocation()
end

function t1.IsClassicBuildPointerOverGui(p409) -- line: 7496
    if p409.DesktopCatalogue and p409.DesktopCatalogue:IsPointerOver() or p409.ClassicDesktop and p409.ClassicDesktop:IsPointerOver() then
        return true
    end

    local v978 = p409.Player and p409.Player:FindFirstChildOfClass("PlayerGui")

    if v978 then
        for _, v979 in ipairs(v978:GetGuiObjectsAtPosition(p409.Mouse.X, p409.Mouse.Y)) do
            local v980 = v979

            while v980 and v980 ~= v978 do
                if v980:IsA("GuiObject") and v980.Visible and (v980:IsA("GuiButton") or v980:IsA("TextBox") or v980.Active or v980:IsA("ScrollingFrame") and v980.ScrollingEnabled) then
                    return true
                end

                v980 = v980.Parent
            end
        end
    end

    return false
end

function t1.ActivateClassicBuildObject(p410) -- line: 7516
    -- upvalues: UserInputService (copy), GuiService (copy)
    if p410.ClassicDesktop and p410.ClassicDesktop.Busy
        or not p410.ClassicBuildActive
        or not p410.EditingBase
        or p410.Painting
        or p410.BuildModeKind ~= "Objects"
        or UserInputService.PreferredInput ~= Enum.PreferredInput.KeyboardAndMouse
        or p410.DeleteAllConfirmOpen
        or p410.PaintResetConfirmOpen
        or GuiService.MenuIsOpen
        or UserInputService:GetFocusedTextBox()
        or p410:IsClassicBuildPointerOverGui() then
        return false
    end

    if p410.EditObject or p410.DeletingObjects then
        return p410:PlaceClassicBuildObject()
    end

    local PlacedBuildObjectAtScreenPosition = p410:GetPlacedBuildObjectAtScreenPosition(p410:GetClassicBuildPointerPosition())

    return PlacedBuildObjectAtScreenPosition ~= nil and p410:SelectPlacedBuildObject(PlacedBuildObjectAtScreenPosition) or false
end

function t1.DeleteClassicBuildTarget(p411, p412) -- line: 7529
    -- upvalues: RemoteEvent (copy)
    if p411.ClassicController and p411.ClassicController:BlocksWorld()
        or p411.ClassicMobile and p411.ClassicMobile:BlocksWorld()
        or not p411.ClassicBuildActive
        or p411.BuildModeKind ~= "Objects"
        or p411.Painting
        or p411.DeletingObjects ~= true then
        return false
    end

    local v981 = p412 == nil
    local v982, v983, PlacedBuildObjectAtScreenPosition

    if v981 then
        PlacedBuildObjectAtScreenPosition = p411:GetPlacedBuildObjectAtScreenPosition(p411:GetClassicBuildPointerPosition())
    else
        if not p411.EditingBase then
            return false
        end

        v982 = p411:ResolvePlacedBuildObject(p412)

        if v982 ~= p412 then
            return false
        end

        local CurrentCamera = workspace.CurrentCamera

        if not CurrentCamera then
            return false
        end

        local BoundingBox, BoundingBox2 = v982:GetBoundingBox()
        local v984 = BoundingBox:PointToObjectSpace(CurrentCamera.CFrame.Position)
        local v985 = BoundingBox2 / 2

        v983 = (v984 - Vector3.new(math.clamp(v984.X, -v985.X, v985.X), math.clamp(v984.Y, -v985.Y, v985.Y), (math.clamp(v984.Z, -v985.Z, v985.Z)))).Magnitude > 500
    end

    if (v981 or v983) and not v981 then
        return false
    end

    if not v981 then
        PlacedBuildObjectAtScreenPosition = v982
    end

    if not PlacedBuildObjectAtScreenPosition or os.clock() - (p411.BuildDeleteAt or 0) < 0.15 then
        return false
    end

    p411.BuildDeleteAt = os.clock()

    if p411.ClassicController and p411.ClassicController:IsGamepad() then
        local v992 = p411.ClassicController:Delete(PlacedBuildObjectAtScreenPosition)

        return v992 ~= nil and v992.ok == true
    end

    if p411.ClassicMobile and p411.ClassicMobile:IsActive() then
        local v993 = p411.ClassicMobile:Delete(PlacedBuildObjectAtScreenPosition)

        return v993 ~= nil and v993.ok == true
    end

    if p411.ClassicDesktop and p411.ClassicDesktop:IsActive() then
        local v994 = p411.ClassicDesktop:Delete(PlacedBuildObjectAtScreenPosition)

        return v994 ~= nil and v994.ok == true
    end

    RemoteEvent:FireServer("DeleteBaseObject", PlacedBuildObjectAtScreenPosition)
    p411:ClearBuildObjectHover()

    return true
end

function t1.CanPlaceClassicBuildObject(p413) -- line: 7575
    -- upvalues: BaseObjectsLib (copy)
    local EditObject = p413.EditObject

    if not EditObject then
        return false, "Choose an object from the catalogue"
    end

    local ClassicBuildAim = p413:GetClassicBuildAim()

    if not ClassicBuildAim then
        return false, "Aim at a surface inside your base"
    end

    EditObject:PivotTo(p413:CalcPlacementCFrame(ClassicBuildAim.Position))

    if not p413:IsBuildObjectInBounds(EditObject) then
        return false, "Keep the whole object inside your base"
    end

    if p413:HasBuildObjectAtCFrame(EditObject:GetPivot()) then
        return false, "An object already occupies this position"
    end

    if not p413.EditingExistingObject then
        local v995 = BaseObjectsLib[EditObject.Name]

        if not v995 then
            return false, "This object is unavailable"
        end

        local v996 = p413.Data or {}

        if v995.Unlock and not (v996.UnlockedObjects or {})[EditObject.Name] then
            return false, "This object is locked"
        end

        if v995.ItemObject and ((v996.BaseItems or {})[EditObject.Name] or 0) < 1 then
            return false, "No copies remaining"
        end

        local ItemObject = v995.ItemObject
        local v997 = if not ItemObject then (tonumber(v996.Money) or 0) < (tonumber(v995.Price) or 0) else nil

        if not ItemObject and v997 then
            return false, "Not enough money"
        end

        if p413:GetStorageCapacity() + (v995.Capacity or 1) > p413:GetStorageCapacityLimit() then
            return false, "Your base is full"
        end
    end

    return true
end

function t1.PlaceClassicBuildObject(p414) -- line: 7594
    if p414.ClassicController and p414.ClassicController:BlocksWorld() or p414.ClassicMobile and p414.ClassicMobile:BlocksWorld() or not p414.ClassicBuildActive or p414.Painting or p414.BuildModeKind ~= "Objects" then
        return false
    end

    if p414.DeletingObjects then
        return p414:DeleteClassicBuildTarget()
    end

    local v999, v1000 = p414:CanPlaceClassicBuildObject()

    if not v999 then
        if p414.ClassicMobile and p414.ClassicMobile:IsActive() then
            p414.ClassicMobile.Status = v1000
        else
            p414:Noti({
                Title = "Can't place object",
                Duration = 2,
                Text = v1000
            })
        end

        return false
    end

    local ClassicBuildAim = p414:GetClassicBuildAim()

    if not ClassicBuildAim then
        return false
    end

    local v1001 = p414:CalcPlacementCFrame(ClassicBuildAim.Position)

    p414.EditObject:PivotTo(v1001)
    p414:PlaceBaseObject(v1001)

    return true
end

function t1.ToggleClassicDesktopPaint(p415) -- line: 7616
    -- upvalues: UserInputService (copy), GuiService (copy)
    if not p415.ClassicBuildActive
        or not p415.BuildCameraActive
        or not p415:IsDesktopBuildCatalogue()
        or p415.BuildSystemSwitching
        or p415.DeleteAllConfirmOpen
        or p415.PaintResetConfirmOpen
        or GuiService.MenuIsOpen
        or UserInputService:GetFocusedTextBox() then
        return false
    end

    if p415.Painting then
        p415:ClosePaintFrames()

        return true
    end

    if p415.BuildModeKind == "Objects" then
        return p415:OpenPaintFrames()
    end

    return false
end

function t1.GetClassicDesktopRotateStep(p416) -- line: 7629
    local ClassicDesktopRotateStep = p416.ClassicDesktopRotateStep

    if ClassicDesktopRotateStep ~= 5 and ClassicDesktopRotateStep ~= 15 and ClassicDesktopRotateStep ~= 30 and ClassicDesktopRotateStep ~= 45 and ClassicDesktopRotateStep ~= 90 then
        return 90
    end

    return ClassicDesktopRotateStep
end

function t1.CycleClassicDesktopRotateStep(p417) -- line: 7635
    -- upvalues: UserInputService (copy), GuiService (copy)
    local v1002

    if not p417.ClassicBuildActive or not p417.BuildCameraActive or not p417:IsDesktopBuildCatalogue() or p417.BuildModeKind ~= "Objects" then
        v1002 = true

        return not v1002
    end

    if p417.Painting
        or p417.BuildSystemSwitching
        or p417.DeleteAllConfirmOpen
        or p417.PaintResetConfirmOpen
        or GuiService.MenuIsOpen
        or UserInputService:GetFocusedTextBox() then
        v1002 = true
    else
        p417.ClassicDesktopRotateStep = ({
            [5] = 15,
            [15] = 30,
            [30] = 45,
            [45] = 90,
            [90] = 5
        })[p417:GetClassicDesktopRotateStep()]

        if p417.DesktopCatalogue then
            p417.DesktopCatalogue:RefreshSelection()
        end

        v1002 = false
    end

    return not v1002
end

function t1.RotateClassicBuildObject(p418, p419, p420, p421) -- line: 7646
    if p418.EditObject then
        local v1003 = if type(p421) == "number" and p421 == p421 and p421 > 0 and p421 <= 360 and p421 then p421 else 90
        local v1004, v1005

        if p420 and p420 < 0 then
            local v1006 = -v1003

            if v1006 then
                v1004 = v1006
                v1005 = true
            else
                v1005 = false
            end
        else
            v1005 = false
        end

        if not v1005 then
            v1004 = v1003
        end

        if p419 == "Y" then
            p418.EditObjectRotate = ((p418.EditObjectRotate or 0) + v1004) % 360
        elseif p419 == "Z" then
            p418.EditObjectFlip = ((p418.EditObjectFlip or 0) + v1004) % 360
        elseif p419 == "X" then
            p418.EditObjectFlip2 = ((p418.EditObjectFlip2 or 0) + v1004) % 360
        end
    end
end

function t1.DisconnectClassicBuildInputs(p422) -- line: 7659
    -- upvalues: ContextActionService (copy)
    p422:SetClassicDesktopBuildClutterHidden(false)
    p422:EndClassicBuildMouseDrag()

    local ClassicDesktop = p422.ClassicDesktop

    p422.ClassicDesktop = nil

    if ClassicDesktop then
        ClassicDesktop:Destroy()
    end

    local ClassicMobile = p422.ClassicMobile

    p422.ClassicMobile = nil

    if ClassicMobile then
        ClassicMobile:Destroy()
    end

    if p422.ClassicController then
        p422.ClassicController:Destroy()
        p422.ClassicController = nil
    end

    if p422.ClassicBuildActive then
        p422.DeletingObjects = false
    end

    for v1007, v1008 in pairs(p422.ClassicBuildLabelText or {}) do
        if v1007.Parent then
            v1007.Text = v1008
        end
    end

    p422.ClassicBuildLabelText = nil

    for _, v1009 in ipairs({
            "rotate",
            "flip",
            "flip2",
            "place",
            "delete",
            "deleteMode",
            "deselect",
            "classicRotateStep",
            "classicPaint"
        }) do
        ContextActionService:UnbindAction(v1009)
    end

    if p422.ClassicBuildCons then
        for _, v1010 in ipairs(p422.ClassicBuildCons) do
            v1010:Disconnect()
        end

        p422.ClassicBuildCons = nil
    end

    if p422.ClassicBuildInputStates then
        for v1011, v1012 in pairs(p422.ClassicBuildInputStates) do
            if v1011 and v1011.Parent then
                local function v1013() -- line: 7689
                    -- upvalues: v1011 (copy), v1012 (copy)
                    v1011.Enabled = v1012
                end

                pcall(v1013)
            end
        end

        p422.ClassicBuildInputStates = nil
    end

    if p422.ClassicBuildGuiVisibility then
        for v1014, v1015 in pairs(p422.ClassicBuildGuiVisibility) do
            if v1014 and v1014.Parent then
                v1014.Visible = v1015
            end
        end

        p422.ClassicBuildGuiVisibility = nil
    end

    if p422.BuildGui then
        for _, v1016 in ipairs({ "Toolbar", "TransformPanel", "ViewPanel", "Hint" }) do
            local v1017 = p422.BuildGui:FindFirstChild(v1016)

            if v1017 and v1017:IsA("GuiObject") then
                v1017.Visible = true
            end
        end
    end

    if p422.HUD then
        p422.HUD.MobileEdits.Visible = false
        p422.HUD.MobileMouse.Visible = false

        local BaseObjects = p422.HUD:FindFirstChild("BaseObjects")
        local Hotkeys = BaseObjects and BaseObjects:FindFirstChild("Hotkeys")

        if Hotkeys then
            Hotkeys.Visible = false
        end
    end
end

function t1.CanClassicBuildMouseDrag(p423) -- line: 7719
    -- upvalues: UserInputService (copy), GuiService (copy)
    local v1018, v1019

    if p423.ClassicBuildActive == true and p423.BuildCameraActive == true then
        local v1020 = not p423.BuildSystemSwitching

        if v1020 then
            local v1021 = not p423.DeleteAllConfirmOpen

            if v1021 then
                local v1022 = not p423.PaintResetConfirmOpen

                if v1022 then
                    local v1023 = not GuiService.MenuIsOpen

                    if v1023 then
                        local v1024 = p423:IsDesktopBuildCatalogue()

                        if v1024 then
                            local v1025 = not UserInputService:GetFocusedTextBox()

                            if v1025 then
                                v1018 = p423.ClassicController and p423.ClassicController:BlocksWorld()
                                v1019 = not v1018
                            else
                                v1019 = v1025
                            end
                        else
                            v1019 = v1024
                        end
                    else
                        v1019 = v1023
                    end
                else
                    v1019 = v1022
                end
            else
                v1019 = v1021
            end
        else
            v1019 = v1020
        end
    else
        v1019 = false
    end

    return v1019
end

function t1.EndClassicBuildMouseDrag(p424) -- line: 7727
    -- upvalues: RunService (copy), UserInputService (copy)
    p424.ClassicBuildRightMouse = nil
    RunService:UnbindFromRenderStep("StorageClassicDesktopMouseDrag")

    if p424.ClassicBuildMouseDragging then
        p424.ClassicBuildMouseDragging = nil
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
end

function t1.StepClassicBuildMouseDrag(p425) -- line: 7737
    -- upvalues: UserInputService (copy)
    if p425.ClassicBuildMouseDragging then
        if not (p425:CanClassicBuildMouseDrag() and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)) then
            p425:EndClassicBuildMouseDrag()
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
        end
    end
end

function t1.BeginClassicBuildMouseDrag(p426) -- line: 7748
    -- upvalues: RunService (copy), UserInputService (copy)
    p426.ClassicBuildMouseDragging = true
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
    RunService:BindToRenderStep("StorageClassicDesktopMouseDrag", Enum.RenderPriority.Camera.Value + 2, function() -- line: 7751
        -- upvalues: p426 (copy)
        p426:StepClassicBuildMouseDrag()
    end)
end

function t1.HandleClassicBuildRightMouse(p427, p428) -- line: 7758
    -- upvalues: UserInputService (copy)
    local ClassicBuildRightMouse = p427.ClassicBuildRightMouse
    local v1027 = p427:CanClassicBuildMouseDrag() and not p427:IsClassicBuildPointerOverGui()
    local v1028 = v1027 and p427.DeletingObjects == true and p427.BuildModeKind == "Objects" and not p427.Painting

    if p428 == Enum.UserInputState.Begin then
        p427:EndClassicBuildMouseDrag()

        if v1027 then
            p427:BeginClassicBuildMouseDrag()
        end

        if v1028 then
            local PlacedBuildObjectAtScreenPosition = p427:GetPlacedBuildObjectAtScreenPosition(p427:GetClassicBuildPointerPosition())

            if PlacedBuildObjectAtScreenPosition then
                p427.ClassicBuildRightMouse = {
                    Travel = 0,
                    Target = PlacedBuildObjectAtScreenPosition,
                    StartedAt = os.clock(),
                    Position = UserInputService:GetMouseLocation()
                }
            end
        end
    elseif p428 == Enum.UserInputState.End or p428 == Enum.UserInputState.Cancel then
        p427:EndClassicBuildMouseDrag()

        if p428 == Enum.UserInputState.End and ClassicBuildRightMouse and v1028 and os.clock() - ClassicBuildRightMouse.StartedAt <= 0.25 and ClassicBuildRightMouse.Travel <= 6 and (UserInputService:GetMouseLocation() - ClassicBuildRightMouse.Position).Magnitude <= 6 and p427:GetPlacedBuildObjectAtScreenPosition(p427:GetClassicBuildPointerPosition()) == ClassicBuildRightMouse.Target then
            p427:DeleteClassicBuildTarget(ClassicBuildRightMouse.Target)
        end
    end

    return Enum.ContextActionResult.Pass
end

function t1.ConnectClassicBuildInputs(p429) -- line: 7785
    -- upvalues: UserInputService (copy), ContextActionService (copy), GuiService (copy), ClassicBuild (copy), RemoteEvent (copy)
    p429:DisconnectClassicBuildInputs()
    p429.ClassicBuildCons = {}
    p429.ClassicBuildInputStates = {}
    p429.ClassicBuildLabelText = {}

    local v1029 = p429.HUD and p429.HUD:FindFirstChild("MobileEdits")
    local v1030 = p429.HUD and p429.HUD:FindFirstChild("BaseObjects")
    local Hotkeys = v1030 and v1030:FindFirstChild("Hotkeys")

    for _, v1031 in ipairs({ "Delete", "Place", "DeleteMode", "Deselect" }) do
        local v1032 = v1029 and v1029:FindFirstChild(v1031)
        local ActionTitle = v1032 and v1032:FindFirstChild("ActionTitle")

        if ActionTitle then
            p429.ClassicBuildLabelText[ActionTitle] = ActionTitle.Text
        end

        local v1033 = Hotkeys and Hotkeys:FindFirstChild(v1031)

        if v1033 and v1033:IsA("TextLabel") then
            p429.ClassicBuildLabelText[v1033] = v1033.Text
        end
    end

    for _, v1034 in ipairs({ "Action", "Action2", "Block", "Reload" }) do
        local v1035 = p429.MainContext and p429.MainContext:FindFirstChild(v1034)

        if v1035 then
            local function v1036() -- line: 7803
                -- upvalues: v1035 (copy)
                return v1035.Enabled
            end

            local ok, result = pcall(v1036)

            if ok then
                p429.ClassicBuildInputStates[v1035] = result
                v1035.Enabled = false
            end
        end
    end

    RemoteEvent:FireServer("M1U")
    RemoteEvent:FireServer("M2U", p429.TouchEnabled)
    p429.ClassicBuildGuiVisibility = {}

    if p429.BuildGui then
        for _, v1037 in ipairs({ "Toolbar", "TransformPanel", "ViewPanel", "Hint", "ControllerHotkeys", "MobileCameraContols" }) do
            local v1038 = p429.BuildGui:FindFirstChild(v1037)

            if v1038 and v1038:IsA("GuiObject") then
                p429.ClassicBuildGuiVisibility[v1038] = v1038.Visible
            end
        end
    end

    local function cancelRightClick() -- line: 7823
        -- upvalues: p429 (copy)
        p429.ClassicBuildRightMouse = nil
    end

    table.insert(p429.ClassicBuildCons, UserInputService.InputChanged:Connect(function(p430) -- line: 7824
        -- upvalues: p429 (copy)
        local ClassicBuildRightMouse = p429.ClassicBuildRightMouse

        if ClassicBuildRightMouse and p430.UserInputType == Enum.UserInputType.MouseMovement then
            ClassicBuildRightMouse.Travel += p430.Delta.Magnitude

            if ClassicBuildRightMouse.Travel > 6 then
                p429.ClassicBuildRightMouse = nil
            end
        end
    end))

    local function cancelRightMouse() -- line: 7832
        -- upvalues: p429 (copy)
        p429:EndClassicBuildMouseDrag()
    end

    table.insert(p429.ClassicBuildCons, UserInputService.WindowFocusReleased:Connect(cancelRightMouse))
    table.insert(p429.ClassicBuildCons, UserInputService.TextBoxFocused:Connect(cancelRightMouse))
    table.insert(p429.ClassicBuildCons, GuiService.MenuOpened:Connect(cancelRightMouse))
    table.insert(p429.ClassicBuildCons, UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 7836
        -- upvalues: p429 (copy), UserInputService (copy)
        p429:EndClassicBuildMouseDrag()

        if p429.EditingExistingObject and UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
            p429:DeleteEditObject()
        end

        p429:ApplyClassicBuildPresentation()
    end))

    local function handleAction(p431, p432, p433) -- line: 7844
        -- upvalues: p429 (copy), UserInputService (copy), GuiService (copy)
        if p431 == "delete" then
            return p429:HandleClassicBuildRightMouse(p432)
        end

        if p431 == "classicPaint" then
            if p432 == Enum.UserInputState.Begin and not UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and not UserInputService:IsKeyDown(Enum.KeyCode.RightShift) and not UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and not UserInputService:IsKeyDown(Enum.KeyCode.RightControl) and not UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) and not UserInputService:IsKeyDown(Enum.KeyCode.RightAlt) then
                return p429:ToggleClassicDesktopPaint() and Enum.ContextActionResult.Sink or Enum.ContextActionResult.Pass
            end
        else
            if not p429.ClassicBuildActive or p429.Painting or p429.BuildModeKind ~= "Objects" then
                return Enum.ContextActionResult.Pass
            end

            if p429.ClassicDesktop and p429.ClassicDesktop.Busy then
                return Enum.ContextActionResult.Sink
            end

            if not p429.DeleteAllConfirmOpen and not p429.PaintResetConfirmOpen and not GuiService.MenuIsOpen then
                if UserInputService:GetFocusedTextBox() or p429.ClassicMobile and p429.ClassicMobile:IsActive() or p429.ClassicController and (p429.ClassicController:IsGamepad() or p429.ClassicController:BlocksWorld()) then
                    return Enum.ContextActionResult.Pass
                end

                if p432 ~= Enum.UserInputState.Begin then
                    return Enum.ContextActionResult.Sink
                end

                if p431 == "place" then
                    if p429:IsClassicBuildPointerOverGui() then
                        return Enum.ContextActionResult.Pass
                    end

                    local v1041 = p429.BuildGui and p429.BuildGui:FindFirstChild("BuildSystemToggle")

                    if v1041 and v1041.Visible then
                        local v1042 = GuiService.SelectedObject == v1041
                        local v1043
                        local v1044 = v1042

                        if v1042 then
                        elseif p433 and p433.UserInputType == Enum.UserInputType.MouseButton1 then
                            local MouseLocation = UserInputService:GetMouseLocation()
                            local AbsolutePosition, AbsoluteSize = v1041.AbsolutePosition, v1041.AbsoluteSize

                            v1043 = MouseLocation.X >= AbsolutePosition.X and MouseLocation.Y >= AbsolutePosition.Y and MouseLocation.X <= AbsolutePosition.X + AbsoluteSize.X and MouseLocation.Y <= AbsolutePosition.Y + AbsoluteSize.Y
                            v1044 = v1043
                        end

                        if v1044 then
                            return Enum.ContextActionResult.Pass
                        end
                    end

                    p429:ActivateClassicBuildObject()
                elseif p431 == "deleteMode" then
                    if UserInputService:GetFocusedTextBox() then
                        return Enum.ContextActionResult.Pass
                    end

                    p429:SetDeletingObjects(not p429.DeletingObjects)
                elseif p431 == "deselect" then
                    p429:DeleteEditObject()
                elseif p431 == "classicRotateStep" then
                    p429:CycleClassicDesktopRotateStep()
                elseif p431 == "rotate" then
                    p429:RotateClassicBuildObject("Y", 1, p429:GetClassicDesktopRotateStep())
                elseif p431 == "flip" then
                    p429:RotateClassicBuildObject("Z", 1, p429:GetClassicDesktopRotateStep())
                else
                    if p431 ~= "flip2" then
                        return Enum.ContextActionResult.Sink
                    end

                    p429:RotateClassicBuildObject("X", 1, p429:GetClassicDesktopRotateStep())
                end

                return Enum.ContextActionResult.Sink
            end
        end

        return Enum.ContextActionResult.Pass
    end

    local v1045 = Enum.ContextActionPriority.High.Value + 50

    ContextActionService:BindActionAtPriority("place", handleAction, false, v1045, Enum.UserInputType.MouseButton1)
    ContextActionService:BindActionAtPriority("delete", handleAction, false, v1045, Enum.UserInputType.MouseButton2)
    ContextActionService:BindActionAtPriority("deleteMode", handleAction, false, v1045, Enum.KeyCode.F)
    ContextActionService:BindActionAtPriority("deselect", handleAction, false, v1045, Enum.KeyCode.E)
    ContextActionService:BindActionAtPriority("rotate", handleAction, false, v1045, Enum.KeyCode.R)
    ContextActionService:BindActionAtPriority("flip", handleAction, false, v1045, Enum.KeyCode.T)
    ContextActionService:BindActionAtPriority("flip2", handleAction, false, v1045, Enum.KeyCode.Y)
    ContextActionService:BindActionAtPriority("classicRotateStep", handleAction, false, v1045, Enum.KeyCode.G)
    ContextActionService:BindActionAtPriority("classicPaint", handleAction, false, v1045, Enum.KeyCode.P)

    local v1046 = p429.HUD and p429.HUD:FindFirstChild("MobileEdits")

    if v1046 then
        local t49 = {
            Place = function() -- Place | line: 7922
                -- upvalues: p429 (copy)
                p429:PlaceClassicBuildObject()
            end,
            Delete = function() -- Delete | line: 7923
                -- upvalues: p429 (copy)
                p429:SetDeletingObjects(not p429.DeletingObjects)
            end,
            Rotate = function() -- Rotate | line: 7924
                -- upvalues: p429 (copy)
                p429:RotateClassicBuildObject("Y")
            end,
            Flip = function() -- Flip | line: 7925
                -- upvalues: p429 (copy)
                p429:RotateClassicBuildObject("Z")
            end,
            Flip2 = function() -- Flip2 | line: 7926
                -- upvalues: p429 (copy)
                p429:RotateClassicBuildObject("X")
            end,
            Deselect = function() -- Deselect | line: 7927
                -- upvalues: p429 (copy)
                p429:DeleteEditObject()
            end
        }

        for v1047, v1048 in pairs(t49) do
            local v1049 = v1046:FindFirstChild(v1047)

            if v1049 and v1049:IsA("GuiButton") then
                table.insert(p429.ClassicBuildCons, v1049.Activated:Connect(function() -- line: 7932
                    -- upvalues: p429 (copy), v1048 (copy)
                    if not (not p429.ClassicBuildActive or p429.Painting or p429.BuildModeKind ~= "Objects" or p429.ClassicMobile and p429.ClassicMobile:IsActive()) then
                        v1048()
                    end
                end))
            end
        end
    end

    p429.ClassicController = ClassicBuild.Controller.Start(p429)
    p429.ClassicMobile = ClassicBuild.Mobile.Start(p429)
    p429.ClassicDesktop = ClassicBuild.Desktop.Start(p429)
    p429:ApplyClassicBuildPresentation()
end

function t1.BeginBuildMode(p434, p435, p436) -- line: 7947
    -- upvalues: RunService (copy), UserInputService (copy), GuiService (copy), GamepadService (copy), ModernBuild (copy), RemoteEvent (copy)
    if p434.BuildCameraActive then
        return false
    end

    if not p434:SetupBuildGui() then
        p434:Noti({
            Title = "Build Mode",
            Text = "The build interface could not be loaded.",
            Duration = 2
        })

        return false
    end

    local CurrentCamera = workspace.CurrentCamera
    local _, BuildReference = p434:GetBuildReference()

    if BuildReference then
        p434.BuildCameraSaved = p436 or {
            CameraType = CurrentCamera.CameraType,
            CameraSubject = CurrentCamera.CameraSubject,
            CameraCFrame = CurrentCamera.CFrame,
            FieldOfView = CurrentCamera.FieldOfView,
            MouseBehavior = UserInputService.MouseBehavior,
            MouseIconEnabled = UserInputService.MouseIconEnabled,
            MainContextEnabled = p434.MainContext.Enabled,
            SelectedObject = GuiService.SelectedObject,
            GamepadCursorEnabled = GamepadService.GamepadCursorEnabled
        }
        p434.BuildCameraActive = true
        p434:SetBuildPanelToggleHidden(true)
        p434.ClassicBuildActive = p434:IsClassicBuildSystem()
        p434.BuildModeKind = p435 or "Objects"
        p434.BuildTransformMode = p434.BuildTransformMode or "Move"
        p434.BuildMoveStep = p434.BuildMoveStep or 0.5
        p434.BuildRotateStep = p434.BuildRotateStep or 15

        if p434.BuildGridEnabled == nil then
            p434.BuildGridEnabled = true
        end

        p434.BuildGridOffsets = {}
        p434.BuildGridFloor = nil
        p434.BuildGui.Enabled = true

        if p434.ClassicBuildActive then
            p434.DeletingObjects = false
            p434:SetBuildClutterHidden(false)
            p434.BuildCameraLocked = false
            p434.BuildGamepadNavigation = false
            p434.BuildGamepadNavigationBeforeCameraLock = nil
            p434.BuildCameraLockManagedGamepadNavigation = nil
            p434:EndBuildTouchGizmoDrag()
            p434:EndBuildTransformHold()
            p434:ClearBuildMobileCameraInputs()
            p434:UpdateBuildMobileCameraControlsVisibility(false)
            p434:SetBuildGamepadNavigation(false)
            p434.BuildSurfaceParts = nil
            p434:DestroyBuildGrid()
            p434:HideBuildGizmos()

            local BuildCameraSaved = p434.BuildCameraSaved

            if BuildCameraSaved then
                p434.MainContext.Enabled = BuildCameraSaved.MainContextEnabled
                UserInputService.MouseBehavior = BuildCameraSaved.MouseBehavior
                UserInputService.MouseIconEnabled = BuildCameraSaved.MouseIconEnabled
                CurrentCamera.FieldOfView = BuildCameraSaved.FieldOfView
            else
                p434.MainContext.Enabled = true
            end

            if GamepadService.GamepadCursorEnabled then
                local function v1051() -- line: 8006
                    -- upvalues: GamepadService (copy)
                    GamepadService:DisableGamepadCursor()
                end

                pcall(v1051)
            end

            CurrentCamera.CameraType = Enum.CameraType.Custom

            if p434.Humanoid then
                CurrentCamera.CameraSubject = p434.Humanoid
            end

            p434:ConnectClassicBuildInputs()
        else
            p434:SetBuildClutterHidden(true)
            p434.MainContext.Enabled = false
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            CurrentCamera.FieldOfView = 55
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = true
            p434.BuildCameraLocked = false
            p434.BuildGamepadNavigation = false
            p434.BuildGamepadNavigationBeforeCameraLock = nil
            p434.BuildCameraLockManagedGamepadNavigation = nil
            p434:EndBuildTouchGizmoDrag()
            p434:EndBuildTransformHold()
            p434:ClearBuildMobileCameraInputs()
            p434:UpdateBuildMobileCameraControlsVisibility(true)
            p434:SetBuildGamepadNavigation(false)

            if p434.BuildModeKind ~= "Paint" then
                p434:CacheBuildSurfaceParts()
            end

            p434:SetBuildView("Iso")

            if p434.BuildModeKind ~= "Paint" then
                p434:RebuildBuildGrid()
            end

            p434:ConnectBuildInputs()
            p434:BindBuildObjectDPad()
            p434.ModernController = ModernBuild.Controller.Start(p434)
            p434.ModernMobile = ModernBuild.Mobile.Start(p434)
            p434.ModernDesktop = ModernBuild.Desktop.Start(p434)
            RunService:UnbindFromRenderStep("BuildCamera")
            RunService:BindToRenderStep("BuildCamera", Enum.RenderPriority.Camera.Value + 10, function(p437) -- line: 8043
                -- upvalues: p434 (copy)
                p434:StepBuildCamera(p437)
            end)
        end

        RemoteEvent:FireServer("SetBuildMode", true, p434.BuildModeKind)
        p434:UpdateBuildGui()

        return true
    end

    p434:Noti({
        Title = "Build Mode",
        Text = "Your base bounds could not be found.",
        Duration = 2
    })

    return false
end

function t1.SetBuildModeKind(p438, p439) -- line: 8051
    -- upvalues: RemoteEvent (copy)
    p438:EndClassicBuildMouseDrag()

    if not p438.BuildCameraActive then
        return false
    end

    local v1053 = if p439 == "Paint" then "Paint" else "Objects"

    if p438.BuildModeKind ~= v1053 then
        p438:SetDeleteAllConfirmation(false)
        p438:EndBuildTouchGizmoDrag()
        p438:EndDirectBuildDrag()
        p438.BuildPendingTouchSelection = nil
        p438:ClearBuildObjectHover()
        p438.BuildGizmoDragging = nil
        p438.BuildModeKind = v1053

        if v1053 == "Paint" then
            if not (p438.ModernMobile and p438.ModernMobile:SuspendPreview() or p438.ModernController and p438.ModernController:SuspendPreview()) then
                p438:DeleteEditObject()
            end

            p438:SetDeletingObjects(false)
            p438:DestroyBuildGrid()
            p438.BuildSurfaceParts = nil
            p438:HideBuildGizmos()
        elseif p438.ClassicBuildActive then
            p438:DestroyBuildGrid()
            p438.BuildSurfaceParts = nil
            p438:HideBuildGizmos()
        else
            p438:CacheBuildSurfaceParts()
            p438:RebuildBuildGrid()
        end

        if v1053 == "Objects" and p438.ModernMobile then
            p438.ModernMobile:ResumePreview()
        end

        if v1053 == "Objects" and p438.ModernController then
            p438.ModernController:ResumePreview()
        end

        RemoteEvent:FireServer("SetBuildMode", true, v1053)
    end

    p438:UpdateBuildGui()

    return true
end

function t1.EndBuildMode(p440, p441) -- line: 8090
    -- upvalues: RunService (copy), UserInputService (copy), ContextActionService (copy), GuiService (copy), GamepadService (copy), RemoteEvent (copy)
    if p440.BuildCameraActive then
        local ModernDesktop = p440.ModernDesktop

        p440.ModernDesktop = nil

        if ModernDesktop then
            ModernDesktop:Destroy()
        end

        local ModernMobile = p440.ModernMobile

        p440.ModernMobile = nil

        if ModernMobile then
            ModernMobile:Destroy()
        end

        local ModernController = p440.ModernController

        p440.ModernController = nil

        if ModernController then
            ModernController:Destroy()
        end

        p440:EndBuildMouseCameraDrag()

        local v1054 = p440.ClassicBuildActive == true

        p440:SetDeleteAllConfirmation(false)
        p440:UnbindBuildObjectDPad()
        p440:EndBuildTouchGizmoDrag()
        p440:EndBuildTransformHold()
        p440:ClearBuildMobileCameraInputs()
        p440:UpdateBuildMobileCameraControlsVisibility(false)

        if v1054 then
            p440:DisconnectClassicBuildInputs()
        end

        p440.BuildCameraActive = nil
        p440:SetBuildPanelToggleHidden(false)

        if p440.DesktopCatalogue then
            p440.DesktopCatalogue:SetActive(false)
        end

        p440.ClassicBuildActive = nil
        p440.BuildModeKind = nil
        p440.BuildCameraLocked = nil
        p440.BuildGamepadNavigationBeforeCameraLock = nil
        p440.BuildCameraLockManagedGamepadNavigation = nil
        RunService:UnbindFromRenderStep("BuildCamera")

        if p440.BuildInputCons then
            for _, v1055 in ipairs(p440.BuildInputCons) do
                v1055:Disconnect()
            end

            p440.BuildInputCons = nil
        end

        p440.BuildPendingTouchSelection = nil
        p440.BuildTouches = nil
        p440.BuildTouchOrder = nil
        p440.BuildMouseOrbit = nil
        p440.BuildMousePan = nil
        p440:EndDirectBuildDrag()
        p440.BuildGizmoDragging = nil
        p440:DestroyBuildGrid()
        p440.BuildGridOffsets = nil
        p440.BuildSurfaceParts = nil
        p440:HideBuildGizmos()

        if p440.BuildGizmoPart then
            p440.BuildGizmoPart:Destroy()
            p440.BuildGizmoPart = nil
        end

        if p440.BuildGui then
            p440.BuildGui.Enabled = false
        end

        p440:SetBuildClutterHidden(false)
        RemoteEvent:FireServer("SetBuildMode", false)

        if p440.BuildGamepadActivationRemapped then
            local function v1056() -- line: 8143
                -- upvalues: ContextActionService (copy)
                ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
                ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
                ContextActionService:BindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
            end

            pcall(v1056)
            p440.BuildGamepadActivationRemapped = nil
        end

        local BuildCameraSaved = p440.BuildCameraSaved

        if p441 then
            p440.BuildCameraSaved = nil
            p440.BuildCameraPosition = nil

            return BuildCameraSaved
        end

        local CurrentCamera = workspace.CurrentCamera

        if BuildCameraSaved then
            p440.MainContext.Enabled = BuildCameraSaved.MainContextEnabled
            UserInputService.MouseBehavior = BuildCameraSaved.MouseBehavior
            UserInputService.MouseIconEnabled = BuildCameraSaved.MouseIconEnabled
            CurrentCamera.CameraType = BuildCameraSaved.CameraType
            CurrentCamera.CameraSubject = BuildCameraSaved.CameraSubject

            if not v1054 then
                CurrentCamera.CFrame = BuildCameraSaved.CameraCFrame
            end

            CurrentCamera.FieldOfView = BuildCameraSaved.FieldOfView

            if v1054 then
                GuiService.SelectedObject = nil
            else
                GuiService.SelectedObject = BuildCameraSaved.SelectedObject
            end

            if UserInputService.GamepadEnabled then
                local t50, v1057

                if v1054 then
                    v1057 = true
                elseif BuildCameraSaved.GamepadCursorEnabled then
                    local SelectedObject = BuildCameraSaved.SelectedObject

                    t50 = {}
                    t50[1] = SelectedObject

                    if SelectedObject and not SelectedObject:IsA("GuiObject") then
                        t50[1] = nil
                    end

                    v1057 = false
                else
                    v1057 = true
                end

                if v1057 then
                    if GamepadService.GamepadCursorEnabled then
                        local function v1058() -- line: 8181
                            -- upvalues: GamepadService (copy)
                            GamepadService:DisableGamepadCursor()
                        end

                        pcall(v1058)
                    end
                else
                    local v1059 = (function(p442)
                        return function() -- line: 8177
                            -- upvalues: p442 (copy), GamepadService (copy)
                            GamepadService:EnableGamepadCursor(p442[1])
                        end
                    end)(t50)

                    pcall(v1059)
                end
            end
        else
            p440.MainContext.Enabled = true
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = true
            CurrentCamera.CameraType = Enum.CameraType.Custom

            if UserInputService.GamepadEnabled and GamepadService.GamepadCursorEnabled then
                local function v1061() -- line: 8192
                    -- upvalues: GamepadService (copy)
                    GamepadService:DisableGamepadCursor()
                end

                pcall(v1061)
            end
        end

        p440.BuildCameraSaved = nil
        p440.BuildCameraPosition = nil
    end
end

function t1.EditStorage(p443) -- line: 8201
    -- upvalues: RunService (copy)
    if not p443.Player:GetAttribute("InBase") or p443.Humanoid and p443.Humanoid.Health <= 0 then
        return
    end

    local BaseEdit = p443.HUD.BaseEdit

    p443.EditingBase = true
    BaseEdit.BaseObjects.Text = "Close Objects"
    p443:EnableBackpack(false)
    p443.HUD.BaseObjects.Visible = true
    p443:BarsVisible(false)
    p443.HUD.BaseObjects.Search.Text = ""
    p443.HUD.BaseObjects.Hotkeys.Visible = false
    p443.SearchText = ""
    p443.CurrentSubCategory = "All"
    p443.DeletingObjects = false
    p443:UpdateSubCategories(p443.CurrentBaseObjects)
    p443:UpdateBaseObjects(p443.CurrentBaseObjects)
    p443:SetBaseObjectsCollapsed(p443.BaseObjectsCollapsed == true, true)
    p443:BeginBuildMode()
    p443:SetDeletingObjects(false)
    p443:UpdateStorageCapacity()

    if p443.TouchEnabled then
        p443.HUD.MobileMouse.Visible = true
        p443.HUD.MobileEdits.Visible = p443.ClassicBuildActive == true
        p443.BuildMobileButtonVisibility = {}

        for _, child in ipairs(p443.MobileButtons.Buttons:GetChildren()) do
            if child:IsA("GuiObject") then
                p443.BuildMobileButtonVisibility[child] = child.Visible
                child.Visible = false
            end
        end
    end

    for _, child in ipairs(p443.HUD.BaseObjects.Types:GetChildren()) do
        if child:IsA("TextButton") then
            p443.EditCons[child.Name .. "Clicked"] = child.Activated:Connect(function() -- line: 8238
                -- upvalues: p443 (copy), child (copy)
                p443.CurrentBaseObjects = child.Name
                p443.CurrentSubCategory = "All"
                p443:UpdateSubCategories(child.Name)
                p443:UpdateBaseObjects(child.Name)
            end)
        end
    end

    if p443.ClassicMobile then
        p443.ClassicMobile:RefreshPresentation()
    end

    if p443.ModernMobile then
        p443.ModernMobile:RefreshPresentation()
    end

    local v1063 = time()

    RunService:BindToRenderStep("UpdateSearch", Enum.RenderPriority.Last.Value + 1, function() -- line: 8250
        -- upvalues: p443 (copy), v1063 (ref)
        if p443:IsDesktopBuildCatalogue() or not (time() - v1063 > 0.1) or p443.SearchText == p443.HUD.BaseObjects.Search.Text then
            return
        end

        v1063 = time()
        p443.SearchText = p443.HUD.BaseObjects.Search.Text
        p443:UpdateBaseObjects(p443.CurrentBaseObjects)
    end)
end

function t1.DeleteEditObject(p444) -- line: 8260
    p444:EndBuildTouchGizmoDrag()
    p444:EndDirectBuildDrag()
    p444.BuildGizmoDragging = nil

    if p444.EditObject then
        p444.EditObject:Destroy()
        p444.EditObject = nil
    end

    if p444.EditExistingOriginalTransparency then
        for v1065, v1066 in pairs(p444.EditExistingOriginalTransparency) do
            if v1065 and v1065.Parent then
                v1065.LocalTransparencyModifier = v1066
            end
        end
    end

    p444.EditExistingOriginalTransparency = nil
    p444.EditingExistingObject = nil

    if p444.CurrentFrame then
        p444:SetBaseObjectFrameSelected(p444.CurrentFrame, false)
        p444.CurrentFrame = nil
    end

    p444.BuildObjectPosition = nil
    p444.BuildObjectRotation = nil
    p444.BuildLastValidPosition = nil
    p444.BuildLastValidRotation = nil
    p444.BuildPlacementValid = nil
    p444.BuildInvalidReason = nil
    p444.BuildDragStartPosition = nil
    p444.BuildDragStartRotation = nil
    p444:HideBuildGizmos()
    p444.Mouse.TargetFilter = nil
    p444:ClearBuildObjectHover()

    if p444.BuildGui then
        p444:UpdateBuildGui()
    end
end

function t1.SelectEditObject(p445, p446, p447) -- line: 8295
    -- upvalues: ReplicatedStorage (copy), applyFactionSignIcon (copy)
    p445:DeleteEditObject()

    if not ReplicatedStorage.BaseObjects:FindFirstChild(p446) then
        return
    end

    if p445.ClassicBuildActive then
        p445:SetDeletingObjects(false)
    end

    local CurrentSkins = p445.Data.CurrentSkins
    local v1067 = if p446 == "Turret" then "Turret" .. CurrentSkins.Turret else p446

    p445.ObjectHover = nil
    p445.HighlightHover.Parent = nil
    p445.ObjectType = p447
    p445.EditObjectRotate = 90
    p445.EditObjectFlip = 0
    p445.EditObjectFlip2 = 0
    p445.breathingNum = Vector3.new(0, 0, 0)
    p445.EditObject = ReplicatedStorage.BaseObjects[v1067]:Clone()
    p445.EditObject.Name = p446
    applyFactionSignIcon(p445.EditObject, p446)

    for _, descendant in ipairs(p445.EditObject:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant:SetAttribute("BuildWasCollidable", descendant.CanCollide)
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = true
        end
    end

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "BuildHighlight"
    Highlight.FillTransparency = 0.5
    Highlight.FillColor = Color3.fromRGB(255, 226, 137)
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.OutlineColor = Color3.fromRGB(255, 228, 120)
    Highlight.OutlineTransparency = 0
    Highlight.Parent = p445.EditObject
    p445.EditObject.Parent = workspace.CurrentCamera
    p445.Mouse.TargetFilter = p445.EditObject
    p445:ResetBuildObjectTransform()

    if p445.ClassicBuildActive then
        p445.BuildObjectPosition = nil
        p445.BuildObjectRotation = nil
        p445:HideBuildGizmos()
    else
        local BuildObjectCFrame = p445:GetBuildObjectCFrame()

        p445.EditObject:PivotTo(BuildObjectCFrame)
        p445:UpdateBuildGizmo(BuildObjectCFrame)
        p445:RefreshBuildValidation(true)
    end

    if p445.ClassicBuildActive then
        p445:ApplyClassicBuildPresentation()
    end

    if p445.ClassicController then
        p445.ClassicController:NotifySelected(p446, p447)
    end

    if p445.ClassicMobile then
        p445.ClassicMobile:NotifySelected(p446, p447)
    end

    if p445.ModernController then
        p445.ModernController:NotifySelected(p446, p447)
    end

    if p445.ModernMobile then
        p445.ModernMobile:NotifySelected(p446, p447)
    end

    p445:RememberModernDesktopObject(p446)

    if p445.DesktopCatalogue then
        p445.DesktopCatalogue:RefreshSelection()
    end
end

local function worldBoundingBox(p448, p449) -- line: 8354
    local v1068 = p449 / 2
    local v1069 = p448:VectorToWorldSpace((Vector3.new(v1068.x, v1068.y, v1068.z)))
    local v1071 = p448:VectorToWorldSpace((Vector3.new(-v1068.x, v1068.y, v1068.z)))
    local v1074 = p448:VectorToWorldSpace((Vector3.new(-v1068.x, -v1068.y, v1068.z)))
    local v1078 = p448:VectorToWorldSpace((Vector3.new(-v1068.x, -v1068.y, -v1068.z)))
    local v1081 = p448:VectorToWorldSpace((Vector3.new(v1068.x, -v1068.y, -v1068.z)))
    local v1083 = p448:VectorToWorldSpace((Vector3.new(v1068.x, v1068.y, -v1068.z)))
    local v1085 = p448:VectorToWorldSpace((Vector3.new(v1068.x, -v1068.y, v1068.z)))
    local v1088 = p448:VectorToWorldSpace((Vector3.new(-v1068.x, v1068.y, -v1068.z)))

    return Vector3.new(math.max(v1069.x, v1071.x, v1074.x, v1078.x, v1081.x, v1083.x, v1085.x, v1088.x), math.max(v1069.y, v1071.y, v1074.y, v1078.y, v1081.y, v1083.y, v1085.y, v1088.y), (math.max(v1069.z, v1071.z, v1074.z, v1078.z, v1081.z, v1083.z, v1085.z, v1088.z))) - Vector3.new(math.min(v1069.x, v1071.x, v1074.x, v1078.x, v1081.x, v1083.x, v1085.x, v1088.x), math.min(v1069.y, v1071.y, v1074.y, v1078.y, v1081.y, v1083.y, v1085.y, v1088.y), (math.min(v1069.z, v1071.z, v1074.z, v1078.z, v1081.z, v1083.z, v1085.z, v1088.z)))
end

function t1.CalcStorageFloor(p450, p451) -- line: 8381
    local Floor = p450.StorageBase.Floor
    local v1096 = if p451 then p451.Position.Y - Floor.Position.Y else 0
    local Size, _CFrame = Floor.Size, Floor.CFrame
    local Basement = p450.StorageBase:FindFirstChild("Basement")
    local BoundingBox = Basement and Basement:FindFirstChild("BoundingBox")

    if (tonumber(p450.StorageBase:GetAttribute("BaseUnitSize")) or 1) > 1 and BoundingBox and BoundingBox:IsA("BasePart") then
        local v1097 = Floor.CFrame:PointToObjectSpace(BoundingBox.Position)

        _CFrame *= CFrame.new(v1097.X, 0, v1097.Z)
        Size = Vector3.new(BoundingBox.Size.X, Floor.Size.Y, BoundingBox.Size.Z)
    end

    local v1098 = -Vector3.FromNormalId(Enum.NormalId.Top)
    local v1099 = v1098:Dot((Vector3.new(0, 1, 0)))
    local v1100 = if math.abs(v1099) == 1 then Vector3.new(-v1099, 0, 0) or Vector3.new(0, 1, 0) else Vector3.new(0, 1, 0)
    local v1102 = CFrame.fromAxisAngle(v1100, 1.5707963267948966) * v1098
    local _ = CFrame.fromAxisAngle(v1100, -1.5707963267948966) * v1098
    local unit = v1098:Cross(v1102).unit

    return _CFrame * CFrame.new(0, v1096, 0) * CFrame.fromMatrix(-v1098 * Size / 2, v1102, unit, v1098), (Vector2.new((Size * v1102).magnitude, (Size * unit).magnitude))
end

function t1.CalcPlacementCFrame(p452, p453) -- line: 8416
    -- upvalues: worldBoundingBox (copy)
    if not p452.BuildCameraActive or p452.ClassicBuildActive then
        local EditObject = p452.EditObject

        if not (EditObject and p452.StorageBase) then
            return EditObject and EditObject:GetPivot() or CFrame.new()
        end

        local Target = p452.Mouse.Target

        if p452.ClassicBuildActive then
            local ClassicBuildAim

            ClassicBuildAim, Target = p452:GetClassicBuildAim()
        elseif p452.TouchEnabled then
            local MobileAim, MobileAim2 = p452:GetMobileAim(nil, true)

            Target = if MobileAim and MobileAim2 then MobileAim2.Instance else nil
        end

        local v1103, v1104

        if not (Target and Target:IsDescendantOf(p452.StorageBase)) then
            v1103, v1104 = p452:CalcStorageFloor()
        elseif p452.StorageBase:FindFirstChild("Basement") and Target:IsDescendantOf(p452.StorageBase.Basement) or Target:IsDescendantOf(p452.StorageBase.Contents) then
            v1103, v1104 = p452:CalcStorageFloor(Target)
        else
            v1103, v1104 = p452:CalcStorageFloor()
        end

        local v1107 = worldBoundingBox(CFrame.Angles(math.rad(p452.EditObjectFlip2), math.rad(p452.EditObjectRotate), (math.rad(p452.EditObjectFlip))), EditObject.PrimaryPart.Size)
        local v1108 = v1103:pointToObjectSpace(p453)
        local v1109 = (v1104 - Vector2.new(v1107.x, v1107.z)) / 2
        local v1112 = math.clamp(v1108.x, -math.abs(v1109.x), (math.abs(v1109.x)))
        local v1115 = math.clamp(v1108.y, -math.abs(v1109.y), (math.abs(v1109.y)))
        local v1116 = math.sign(v1112) * (math.abs(v1112) - math.abs(v1112) % 0.1 + v1109.x % 0.1)
        local v1117 = math.sign(v1115) * (math.abs(v1115) - math.abs(v1115) % 0.1 + v1109.y % 0.1)

        return v1103 * CFrame.new(v1116, v1117, -(v1107.Y / 2)) * CFrame.Angles(-1.5707963267948966 + math.rad(p452.EditObjectFlip2), math.rad(p452.EditObjectRotate), (math.rad(p452.EditObjectFlip)))
    end

    if p452.BuildObjectPosition then
        return p452:GetBuildObjectCFrame()
    end

    return p452.EditObject and p452.EditObject:GetPivot() or CFrame.new()
end

function t1.PlaceBaseObject(p454, p455) -- line: 8474
    -- upvalues: RemoteEvent (copy), RemoteFunction (copy)
    if not p454.EditObject or typeof(p455) ~= "CFrame" then
        return
    end

    if p454.ClassicController and p454.ClassicController:IsGamepad() then
        return p454.ClassicController:Commit(p455)
    end

    if p454.ClassicMobile and p454.ClassicMobile:IsActive() then
        return p454.ClassicMobile:Commit(p455)
    end

    if p454.ClassicDesktop and p454.ClassicDesktop:IsActive() then
        return p454.ClassicDesktop:Commit(p455)
    end

    if p454.ModernController and p454.ModernController:IsGamepad() then
        return p454.ModernController:CommitTransaction(p455)
    end

    if p454.ModernDesktop and p454.ModernDesktop:IsActive() then
        return p454.ModernDesktop:Commit(p455)
    end

    if not p454.EditingExistingObject then
        RemoteEvent:FireServer("PlaceBaseObject", {
            p454.EditObject.Name,
            p455,
            false,
            p454.ObjectType
        })

        return
    end

    if not p454.BuildMovePending then
        local EditingExistingObject, EditObject = p454.EditingExistingObject, p454.EditObject

        p454.BuildMovePending = true

        local function v1121() -- line: 8495
            -- upvalues: p455 (copy), EditingExistingObject (copy), RemoteFunction (copy)
            return RemoteFunction:InvokeServer("MoveBaseObject", { EditingExistingObject, p455 })
        end

        local v1122, v1123, v1124 = pcall(v1121)

        p454.BuildMovePending = nil

        local v1125 = p454.EditObject == EditObject and p454.EditingExistingObject == EditingExistingObject

        if v1122 and v1123 == true then
            if EditingExistingObject and EditingExistingObject.Parent then
                EditingExistingObject:PivotTo(p455)
            end

            if v1125 then
                p454:DeleteEditObject()
            end
        elseif v1125 then
            p454:Noti({
                Title = "Can't Move",
                Duration = 2,
                Text = v1124 or "That object could not be moved."
            })

            if not p454.ClassicBuildActive then
                p454:RefreshBuildValidation(true)
            end
        end
    end
end

function t1.CheckVC(p456) -- line: 8516
    -- upvalues: VoiceChatService (copy)
    local v1126 = false

    local function v1127() -- line: 8518
        -- upvalues: p456 (copy), v1126 (ref), VoiceChatService (copy)
        v1126 = VoiceChatService:IsVoiceEnabledForUserIdAsync(p456.Player.UserId)
    end

    pcall(v1127)

    return v1126
end

function t1.ViewPlayer(p457, p458) -- line: 8524
    if p458 == p457.Humanoid or p458 == p457.Player then
        p457.SpectateToken = (p457.SpectateToken or 0) + 1
        p457.ViewingPlayer = nil
    elseif typeof(p458) ~= "Instance" or not p458:IsA("Humanoid") then
        if typeof(p458) == "Instance" and p458:IsA("Player") then
            local v1128 = (p457.SpectateToken or 0) + 1

            p457.SpectateToken = v1128
            task.spawn(function() -- line: 8538
                -- upvalues: p457 (copy), p458 (copy), v1128 (copy)
                local v1129 = os.clock() + 10

                while true do
                    if os.clock() < v1129 then
                        if p457.SpectateToken ~= v1128 then
                            break
                        end

                        local Character = p458.Character
                        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

                        if Humanoid then
                            p457.ViewingPlayer = Humanoid

                            return
                        end

                        task.wait(0.1)
                        continue
                    end

                    return
                end
            end)
        end
    else
        p457.SpectateToken = (p457.SpectateToken or 0) + 1
        p457.ViewingPlayer = p458
    end
end

local function createSkinViewport(p459, p460, p461) -- line: 8554
    -- upvalues: ToolsLib (copy), SkinsLib (copy), Objects (copy)
    local v1130 = Objects.Skins[p460]:FindFirstChild(p461)

    if not v1130 then
        return
    end

    local v1131 = ToolsLib[p460]
    local v1132 = SkinsLib[p460][p461]
    local clone = v1130:Clone()

    clone.Name = "VPObject"
    clone.Parent = p459

    local Camera = Instance.new("Camera")

    p459.CurrentCamera = Camera

    if clone:IsA("Model") then
        if not (v1132 and v1132.ViewportOffset) then
            Camera.CFrame = clone.PrimaryPart.CFrame * v1131.ViewportOffset
        else
            Camera.CFrame = clone.PrimaryPart.CFrame * v1132.ViewportOffset
        end
    else
        Camera.CFrame = clone.CFrame * v1131.ViewportOffset
    end

    Camera.Parent = p459
end

function t1.CompressSkins(p462, p463) -- line: 8579
    local v1133 = p462.Data.Skins[p463]
    local t51 = {}

    for _, v1134 in pairs(v1133) do
        if t51[v1134.Skin] then
            t51[v1134.Skin] += 1
        else
            t51[v1134.Skin] = 1
        end
    end

    return t51
end

local t52 = {
    "Revolver",
    "SMG",
    "LMG",
    "AK47",
    "Shotgun",
    "Double Barrel Shotgun"
}

function t1.UpdateSkins(p464, p465, p466) -- line: 8593
    -- upvalues: SkinsLib (copy), RemoteEvent (copy), Objects (copy), createSkinViewport (copy), t52 (copy)
    local Items, Skins = p464.HUD.Skins.Items, p464.HUD.Skins.Skins
    local v1135 = Items.List:FindFirstChild(p465)

    for _, child in pairs(Items.List:GetChildren()) do
        if child:IsA("ImageButton") then
            child.BackgroundColor3 = Color3.fromRGB(144, 144, 144)
        end
    end

    if p466 then
        for _, child in pairs(Skins.List:GetChildren()) do
            if child:IsA("ImageButton") and child.Name ~= "Sample" then
                child:Destroy()
            end
        end
    else
        for v1136, v1137 in pairs(p464.SkinCons) do
            v1137:Disconnect()
            p464.SkinCons[v1136] = nil
        end
    end

    if v1135 then
        v1135.BackgroundColor3 = Color3.fromRGB(255, 192, 90)
    end

    local v1138 = p464:CompressSkins(p465)
    local v1139 = if _G.Utl.tabFind(t52, p465) then "Guns" else p465

    for v1140, v1141 in pairs(SkinsLib[v1139]) do
        local v1142 = Skins.List:FindFirstChild(v1140)

        if v1142 then
            if p464.Data.CurrentSkins[p465] == v1140 then
                v1142.ObjectFrame.Equipped.Visible = true
            else
                v1142.ObjectFrame.Equipped.Visible = false
            end

            if p464.ShowAll or v1138[v1140] then
                v1142.Visible = true
            else
                v1142.Visible = false
            end

            if v1138[v1140] then
                v1142.ObjectFrame.Lock.Visible = false
                v1142.ObjectFrame.Amount.Text = "x" .. v1138[v1140]
                v1142.ObjectFrame.Amount.Visible = true
                v1142.ObjectFrame.Pack.Visible = false
                p464.SkinCons[v1140 .. "M1D"] = v1142.MouseButton1Click:Connect(function() -- line: 8662
                    -- upvalues: p464 (copy), p465 (copy), v1140 (copy), RemoteEvent (copy)
                    if p464.SellingSkins then
                        p464:SellSkin(p465, (tostring(v1140)))
                    else
                        RemoteEvent:FireServer("EquipSkin", p465, (tostring(v1140)))
                    end
                end)
            else
                v1142.ObjectFrame.Lock.Visible = true
                v1142.ObjectFrame.Amount.Visible = false

                if v1141.Prem then
                    v1142.ObjectFrame.Lock.Image = "rbxassetid://14687163735"
                elseif v1141.Pack then
                    v1142.ObjectFrame.Lock.Visible = false
                    v1142.ObjectFrame.Amount.Visible = false
                    v1142.ObjectFrame.Pack.Visible = true
                end
            end
        elseif Objects.Skins[p465]:FindFirstChild(v1140) then
            v1142 = Skins.List.Sample:Clone()
            v1142.Name = v1140
            v1142.SkinName.Text = v1140
            v1142.RarityLabel.Text = v1141.Rarity
            v1142.RarityLabel.TextColor3 = _G.Utl.RarityInfo[v1141.Rarity][1]
            v1142.BackgroundColor3 = _G.Utl.RarityInfo[v1141.Rarity][1]
            v1142.LayoutOrder = _G.Utl.RarityInfo[v1141.Rarity][2]
            v1142.Visible = true
            v1142.Parent = Skins.List
            createSkinViewport(v1142.ObjectFrame, p465, v1140)

            if p464.Data.CurrentSkins[p465] == v1140 then
                v1142.ObjectFrame.Equipped.Visible = true
            else
                v1142.ObjectFrame.Equipped.Visible = false
            end

            if p464.ShowAll or v1138[v1140] then
                v1142.Visible = true
            else
                v1142.Visible = false
            end

            if v1138[v1140] then
                v1142.ObjectFrame.Lock.Visible = false
                v1142.ObjectFrame.Amount.Text = "x" .. v1138[v1140]
                v1142.ObjectFrame.Amount.Visible = true
                v1142.ObjectFrame.Pack.Visible = false
                p464.SkinCons[v1140 .. "M1D"] = v1142.MouseButton1Click:Connect(function() -- line: 8662
                    -- upvalues: p464 (copy), p465 (copy), v1140 (copy), RemoteEvent (copy)
                    if p464.SellingSkins then
                        p464:SellSkin(p465, (tostring(v1140)))
                    else
                        RemoteEvent:FireServer("EquipSkin", p465, (tostring(v1140)))
                    end
                end)
            else
                v1142.ObjectFrame.Lock.Visible = true
                v1142.ObjectFrame.Amount.Visible = false

                if v1141.Prem then
                    v1142.ObjectFrame.Lock.Image = "rbxassetid://14687163735"
                elseif v1141.Pack then
                    v1142.ObjectFrame.Lock.Visible = false
                    v1142.ObjectFrame.Amount.Visible = false
                    v1142.ObjectFrame.Pack.Visible = true
                end
            end
        end
    end
end

function t1.SellSkin(p467, p468, p469) -- line: 8685
    -- upvalues: CollectionService (copy), SkinsLib (copy), RemoteEvent (copy), t52 (copy)
    if CollectionService:HasTag(p467.Player, "SkinSellCD") then
        return
    end

    CollectionService:AddTag(p467.Player, "SkinSellCD")
    task.delay(0.5, function() -- line: 8688
        -- upvalues: p467 (copy), CollectionService (copy)
        CollectionService:RemoveTag(p467.Player, "SkinSellCD")
    end)

    local SellConfirm = p467.HUD.Skins.SellConfirm
    local v1146 = SkinsLib[if _G.Utl.tabFind(t52, p468) then "Guns" else p468][p469]
    local Rarity = v1146.Rarity
    local v1147 = v1146.SellPrice or SkinsLib.SellPrice[Rarity]
    local t53 = {}

    local function disconnectCons() -- line: 8701
        -- upvalues: t53 (ref)
        for v1148, v1149 in pairs(t53) do
            v1149:Disconnect()

            local t54 = t53

            t54[v1148] = nil
        end

        t53 = nil
    end

    local connection = SellConfirm.Yes.MouseButton1Click:Connect(function() -- line: 8709
        -- upvalues: p468 (copy), p469 (copy), SellConfirm (copy), t53 (ref), RemoteEvent (copy)
        SellConfirm.Visible = false
        RemoteEvent:FireServer("SellSkin", p468, p469)

        for v1150, v1151 in pairs(t53) do
            v1151:Disconnect()
            t53[v1150] = nil
        end

        t53 = nil
    end)

    t53.Yes = connection

    local connection2 = SellConfirm.No.MouseButton1Click:Connect(function() -- line: 8714
        -- upvalues: SellConfirm (copy), t53 (ref)
        SellConfirm.Visible = false

        for v1152, v1153 in pairs(t53) do
            v1153:Disconnect()
            t53[v1152] = nil
        end

        t53 = nil
    end)

    t53.No = connection2

    local connection3 = SellConfirm.SellAll.MouseButton1Click:Connect(function() -- line: 8718
        -- upvalues: p468 (copy), p469 (copy), SellConfirm (copy), t53 (ref), RemoteEvent (copy)
        SellConfirm.Visible = false
        RemoteEvent:FireServer("SellAllSkin", p468, p469)

        for v1154, v1155 in pairs(t53) do
            v1155:Disconnect()
            t53[v1154] = nil
        end

        t53 = nil
    end)

    t53.SellAll = connection3
    SellConfirm.Label.Text = "Would you like to sell " .. p468 .. " " .. p469 .. " for $" .. v1147 .. "?"
    SellConfirm.Visible = true
end

function t1.DestroyRolling(p470) -- line: 8728
    if p470.Spinner then
        p470.Spinner:Destroy()
        p470.Spinner = nil
    end
end

function t1.ClearRolling(p471) -- line: 8735
    if p471.Spinner then
        local List = p471.Spinner.Main.Frame.List
        local Crate, _ = p471.Spinner.Main.Crate, p471.Spinner.Main.ResultLabel

        for _, child in pairs(List:GetChildren()) do
            if child:IsA("ImageLabel") and child.Name ~= "Sample" then
                child:Destroy()
            end
        end

        for _, child in pairs(Crate.ObjectFrame.WorldModel:GetChildren()) do
            child:Destroy()
        end
    end
end

function t1.RollSkin(p472, p473) -- line: 8752
    -- upvalues: RunService (copy), TweenService (copy), ToolsLib (copy), SkinsLib (copy), Animations (copy), Objects (copy), createSkinViewport (copy), t52 (copy)
    if p472.Spinner then
        return
    end

    p472.Spinner = Objects.Spinner:Clone()

    local List = p472.Spinner.Main.Frame.List
    local Crate, ResultLabel = p472.Spinner.Main.Crate, p472.Spinner.Main.ResultLabel

    p472.Spinner.Parent = p472.Player.PlayerGui

    local v1156 = false
    local Case = Objects.Case

    if p473.Prem then
        Case = Objects.PremCase
    end

    local clone = Case:Clone()
    local Camera = Instance.new("Camera")

    Camera.Parent = Crate.ObjectFrame
    List.Position = UDim2.new(0, 0, 0, 0)
    clone.Parent = p472.Spinner.Main.Crate.ObjectFrame.WorldModel
    Camera.CFrame = clone.PrimaryPart.CFrame * CFrame.new(0, 5.5, -4.75) * CFrame.Angles(0.7853981633974483, 3.141592653589793, 0)
    Crate.ObjectFrame.CurrentCamera = Camera

    local track = clone.AnimationController.Animator:LoadAnimation(Animations.CaseRattle)

    track:Play()

    local X = List.Sample.AbsoluteSize.X
    local v1157 = List.AbsoluteSize.X / 2 - X
    local _ = List.AbsoluteSize.X / 2 - X / 2

    for v1158, v1159 in pairs(p473.Items) do
        local v1160 = if _G.Utl.tabFind(t52, v1159.Item) then SkinsLib.Guns[v1159.Skin] else SkinsLib[v1159.Item][v1159.Skin]
        local clone = List.Sample:Clone()

        clone.Name = tostring(v1158)
        clone.SkinName.Text = v1159.Skin
        clone.RarityLabel.Text = v1160.Rarity
        clone.RarityLabel.TextColor3 = _G.Utl.RarityInfo[v1160.Rarity][1]
        clone.BackgroundColor3 = _G.Utl.RarityInfo[v1160.Rarity][1]
        createSkinViewport(clone.ObjectFrame, v1159.Item, v1159.Skin)
        clone.Visible = true

        local v1161 = (X + 5) * (v1158 - 1)

        clone.Position = UDim2.new(0, v1157 + v1161, 0, 0)
        clone.Parent = List
    end

    task.spawn(function() -- line: 8804
        -- upvalues: p472 (copy), v1156 (ref), TweenService (copy)
        for i = 1, 15 do
            if v1156 then
                break
            end

            local Value = TweenService:GetValue(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local Value2 = TweenService:GetValue((15 - i) / 15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

            task.wait(Value - Value2)
            _G.Utl.PlaySound({
                Sound = "Click",
                Speed = 1.2,
                Origin = p472.HUD
            })
        end
    end)
    task.wait(0.1)

    local v1162 = (X + 5) * 12
    local tween = TweenService:Create(List, TweenInfo.new(6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, v1157 - v1162, 0, 0)
    })

    tween:Play()
    p472.Spinner.Main.SkipButton.MouseButton1Click:Connect(function() -- line: 8820
        -- upvalues: List (copy), v1156 (ref), v1157 (copy), v1162 (copy), tween (copy)
        tween:Cancel()
        v1156 = true
        List.Position = UDim2.new(0, v1157 - v1162, 0, 0)
    end)

    local v1163 = time()

    while not (time() - v1163 > 6) do
        task.wait(0.1)

        if v1156 then
            break
        end
    end

    local WinningItem = p473.WinningItem
    local v1164 = if _G.Utl.tabFind(t52, WinningItem.Item) then SkinsLib.Guns[WinningItem.Skin] else SkinsLib[WinningItem.Item][WinningItem.Skin]
    local v1165 = ToolsLib[WinningItem.Item]

    ResultLabel.Text = WinningItem.Skin .. " " .. WinningItem.Item
    ResultLabel.TextColor3 = _G.Utl.RarityInfo[v1164.Rarity][1]
    Crate.BackgroundColor3 = _G.Utl.RarityInfo[v1164.Rarity][1]
    Crate.Gradient.Enabled = true
    track:Stop()
    clone.AnimationController.Animator:LoadAnimation(Animations.CaseOpen):Play()

    local v1166 = v1165.CaseOffset or CFrame.new(0, 0, 0)
    local v1167 = v1165.Up or CFrame.new(0, 5.5, 0)
    local clone2 = Objects.Skins[WinningItem.Item][WinningItem.Skin]:Clone()

    clone2.PrimaryPart.Anchored = true
    clone2:PivotTo(clone.PrimaryPart.CFrame * v1166)
    clone2.Parent = Crate.ObjectFrame.WorldModel
    TweenService:Create(clone2, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        WorldPivot = clone2.WorldPivot * v1167
    }):Play()
    TweenService:Create(clone2.PrimaryPart, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        CFrame = clone2.PrimaryPart.CFrame * v1167
    }):Play()
    TweenService:Create(Camera, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        CFrame = Camera.CFrame * CFrame.new(0, 1, 1) * CFrame.Angles(0.7853981633974483, 0, 0)
    }):Play()

    for _, child in pairs(clone:GetChildren()) do
        if child:IsA("BasePart") and child.Name ~= "RootPart" then
            TweenService:Create(child, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.8), {
                Transparency = 1
            }):Play()
        end
    end

    task.wait(0.75)

    local v1168 = v1165.Spin or CFrame.Angles(0, -0.15707963267948966, 0)

    RunService:BindToRenderStep("SpinObject", Enum.RenderPriority.Camera.Value + 1, function() -- line: 8876
        -- upvalues: clone2 (copy), v1168 (copy)
        clone2:PivotTo(clone2.WorldPivot * v1168)
    end)
    task.wait(1)
    Camera:Destroy()
    RunService:UnbindFromRenderStep("SpinObject")
    p472:DestroyRolling()
end

function t1.PremRollSkin10(p474, p475) -- line: 8886
    for _, v1170 in pairs(p475) do
        v1170.Prem = true
        p474:RollSkin(v1170)
    end
end

function t1.RollSkin10(p476, p477) -- line: 8893
    for _, v1171 in pairs(p477) do
        p476:RollSkin(v1171)
    end
end

function t1.SetupSkins(p478) -- line: 8899
    -- upvalues: ReplicatedStorage (copy), MarketplaceService (copy), ToolsLib (copy), SkinsLib (copy), RemoteFunction (copy), Objects (copy), createViewportObjects (copy), t52 (copy)
    local Items, Buttons, Code, Packs = p478.HUD.Skins.Items, p478.HUD.Skins.Buttons, p478.HUD.Skins.Code, p478.HUD.Skins.Packs

    p478.SkinItem = "Knife"
    p478.ShowAll = true
    p478.SellingSkins = false

    for v1172, v1173 in pairs(ToolsLib.LayoutSkins) do
        local clone = Items.List.Sample:Clone()

        clone.Name = v1173
        clone.Frame.ItemName.Text = v1173
        createViewportObjects(clone.Frame.ObjectFrame, v1173, ToolsLib[v1173])
        clone.Visible = true
        clone.LayoutOrder = v1172
        clone.Parent = Items.List

        local v1174 = 0

        if _G.Utl.tabFind(t52, v1173) then
            for v1175, _ in pairs(SkinsLib.Guns) do
                if Objects.Skins[v1173]:FindFirstChild(v1175) then
                    v1174 += 1
                end
            end
        else
            for _, _ in pairs(SkinsLib[v1173]) do
                v1174 += 1
            end
        end

        clone.Frame.Skins.Text = tostring(v1174) .. " Skins"
        clone.MouseButton1Click:Connect(function() -- line: 8931
            -- upvalues: p478 (copy), v1173 (copy)
            p478.SkinItem = v1173
            p478:UpdateSkins(p478.SkinItem, true)
        end)
    end

    Buttons.ShowAll.MouseButton1Click:Connect(function() -- line: 8937
        -- upvalues: p478 (copy), Buttons (copy)
        if p478.ShowAll then
            p478.ShowAll = false
            Buttons.ShowAll.Frame.On.Visible = false
            Buttons.ShowAll.Frame.Off.Visible = true
        else
            p478.ShowAll = true
            Buttons.ShowAll.Frame.On.Visible = true
            Buttons.ShowAll.Frame.Off.Visible = false
        end

        p478:UpdateSkins(p478.SkinItem, false)
    end)

    local v1176 = time()

    Buttons.Roll.MouseButton1Click:Connect(function() -- line: 8951
        -- upvalues: p478 (copy), v1176 (ref), RemoteFunction (copy)
        if time() - v1176 < 0.5 or p478.Spinner then
            return
        end

        v1176 = time()

        local RollSkin = RemoteFunction:InvokeServer("RollSkin")

        if typeof(RollSkin) == "string" then
            p478:Noti({
                Title = "Error",
                Duration = 2,
                Text = RollSkin
            })
        else
            p478:RollSkin(RollSkin)
        end
    end)
    Buttons.Roll10.MouseButton1Click:Connect(function() -- line: 8963
        -- upvalues: p478 (copy), v1176 (ref), RemoteFunction (copy)
        if time() - v1176 < 0.5 or p478.Spinner then
            return
        end

        v1176 = time()

        local RollSkin10 = RemoteFunction:InvokeServer("RollSkin10")

        if typeof(RollSkin10) == "string" then
            p478:Noti({
                Title = "Error",
                Duration = 2,
                Text = RollSkin10
            })
        else
            for _, v1177 in pairs(RollSkin10) do
                p478:RollSkin(v1177)
            end
        end
    end)

    local ProductInfo = MarketplaceService:GetProductInfo(1644429004, Enum.InfoType.Product)
    local ProductInfo2 = MarketplaceService:GetProductInfo(1644430220, Enum.InfoType.Product)

    Buttons.PremRollLabel.Text = ProductInfo.PriceInRobux .. "R$"
    Buttons.PremRoll10Label.Text = ProductInfo2.PriceInRobux .. "R$"
    Buttons.PremRoll.MouseButton1Click:Connect(function() -- line: 8982
        -- upvalues: p478 (copy), v1176 (ref), MarketplaceService (copy)
        if not (time() - v1176 < 0.5) and not p478.Spinner then
            v1176 = time()
            MarketplaceService:PromptProductPurchase(p478.Player, 1644429004)
        end
    end)
    Buttons.PremRoll10.MouseButton1Click:Connect(function() -- line: 8990
        -- upvalues: p478 (copy), v1176 (ref), MarketplaceService (copy)
        if not (time() - v1176 < 0.5) and not p478.Spinner then
            v1176 = time()
            MarketplaceService:PromptProductPurchase(p478.Player, 1644430220)
        end
    end)
    Buttons.SellSkins.BackgroundColor3 = Color3.fromRGB(196, 255, 174)
    Buttons.SellSkins.MouseButton1Click:Connect(function() -- line: 8999
        -- upvalues: p478 (copy), Buttons (copy)
        if p478.SellingSkins then
            p478.SellingSkins = false
            Buttons.SellSkins.Text = "Sell Skins"
            Buttons.SellSkins.BackgroundColor3 = Color3.fromRGB(196, 255, 174)
            p478.HUD.Skins.SellTip.Visible = false
        else
            p478.SellingSkins = true
            Buttons.SellSkins.Text = "Selling"
            Buttons.SellSkins.BackgroundColor3 = Color3.fromRGB(255, 162, 162)
            p478.HUD.Skins.SellTip.Visible = true
        end
    end)

    local v1178 = time()

    Code.Enter.MouseButton1Click:Connect(function() -- line: 9014
        -- upvalues: p478 (copy), Code (copy), v1178 (ref), ReplicatedStorage (copy)
        if not p478.Spinner then
            local Text = Code.TextBox.Text

            if not (time() - v1178 < 0.5) and Text ~= "" then
                v1178 = time()
                ReplicatedStorage.Codes:FireServer(Text)
            end
        end
    end)

    for _, child in pairs(Packs:GetChildren()) do
        local Buy = child.Buy

        child.Info.MouseButton1Click:Connect(function() -- line: 9026
            -- upvalues: child (copy)
            child.InfoLabel.Visible = not child.InfoLabel.Visible
        end)
        Buy.MouseButton1Click:Connect(function() -- line: 9029
            -- upvalues: p478 (copy), child (copy), MarketplaceService (copy), SkinsLib (copy)
            local v1179 = SkinsLib.Packs[child.Name]

            if v1179 then
                MarketplaceService:PromptProductPurchase(p478.Player, v1179)
            end
        end)
    end
end

function t1.StartCinematic(p479) -- line: 9038
    -- upvalues: ReplicatedStorage (copy), RunService (copy), UserInputService (copy), StarterGui (copy)
    if p479.CinematicActive then
        return
    end

    p479.CinematicActive = true

    local CurrentCamera = workspace.CurrentCamera

    p479.CinematicSaved = {
        CameraType = CurrentCamera.CameraType,
        FieldOfView = CurrentCamera.FieldOfView,
        MouseBehavior = UserInputService.MouseBehavior,
        MouseIconEnabled = UserInputService.MouseIconEnabled
    }

    local v1180 = p479.Character and p479.Character:FindFirstChild("HumanoidRootPart")

    if v1180 then
        p479.CinematicSaved.Anchored = v1180.Anchored
        v1180.Anchored = true
    end

    p479.CinematicHidden = {}

    local PlayerGui = p479.Player:FindFirstChildOfClass("PlayerGui")

    if PlayerGui then
        for _, child in ipairs(PlayerGui:GetChildren()) do
            if child:IsA("ScreenGui") and child.Enabled and not child:GetAttribute("CinematicExempt") then
                table.insert(p479.CinematicHidden, child)
                child.Enabled = false
            end
        end
    end

    local function v1181() -- line: 9067
        -- upvalues: StarterGui (copy)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    end

    pcall(v1181)
    p479.CinematicIconsHidden = {}

    if p479.CinematicIcon then
        local Icon = require(ReplicatedStorage.Modules.Icon)

        for _, v1182 in pairs(Icon.getIcons()) do
            if v1182 ~= p479.CinematicIcon and v1182.isEnabled then
                v1182:setEnabled(false)
                table.insert(p479.CinematicIconsHidden, v1182)
            end
        end
    end

    local v1183, v1184 = CurrentCamera.CFrame:ToEulerAnglesYXZ()

    p479.CinematicPos = CurrentCamera.CFrame.Position
    p479.CinematicPitch = v1183
    p479.CinematicYaw = v1184
    p479.CinematicSpeed = 60
    p479.CinematicFOV = 70
    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    CurrentCamera.FieldOfView = p479.CinematicFOV
    p479.CinematicScroll = UserInputService.InputChanged:Connect(function(p480) -- line: 9092
        -- upvalues: p479 (copy)
        if p480.UserInputType == Enum.UserInputType.MouseWheel then
            p479.CinematicFOV = math.clamp(p479.CinematicFOV - p480.Position.Z * 5, 10, 90)
        end
    end)
    p479.CinematicKey = UserInputService.InputBegan:Connect(function(p481) -- line: 9098
        -- upvalues: p479 (copy)
        if p481.KeyCode == Enum.KeyCode.P or p481.KeyCode == Enum.KeyCode.ButtonB then
            p479:StopCinematic()
        end
    end)
    RunService:BindToRenderStep("Cinematic", Enum.RenderPriority.Camera.Value + 1, function(p482) -- line: 9104
        -- upvalues: p479 (copy)
        p479:StepCinematic(p482)
    end)

    if p479.CinematicRefresh then
        p479.CinematicRefresh()
    end
end

function t1.StepCinematic(p483, p484) -- line: 9111
    -- upvalues: UserInputService (copy)
    if p483.CinematicActive then
        local CurrentCamera = workspace.CurrentCamera

        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
            UserInputService.MouseIconEnabled = false

            local MouseDelta = UserInputService:GetMouseDelta()

            p483.CinematicYaw -= MouseDelta.X * 0.004
            p483.CinematicPitch = math.clamp(p483.CinematicPitch - MouseDelta.Y * 0.004, -1.5, 1.5)
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = true
        end

        local v1188 = Vector3.new()

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            v1188 += Vector3.new(0, 0, -1)
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            v1188 += Vector3.new(0, 0, 1)
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            v1188 += Vector3.new(-1, 0, 0)
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            v1188 += Vector3.new(1, 0, 0)
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.E) then
            v1188 += Vector3.new(0, 1, 0)
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            v1188 += Vector3.new(0, -1, 0)
        end

        local CinematicSpeed = p483.CinematicSpeed
        local v1189 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
        local ConnectedGamepads = UserInputService:GetConnectedGamepads()
        local v1190 = if #ConnectedGamepads > 0 then ConnectedGamepads[1] else nil

        if v1190 then
            for _, v1191 in ipairs(UserInputService:GetGamepadState(v1190)) do
                local KeyCode = v1191.KeyCode

                if KeyCode == Enum.KeyCode.Thumbstick1 then
                    local Position = v1191.Position

                    if math.abs(Position.X) > 0.15 then
                        v1188 += Vector3.new(Position.X, 0, 0)
                    end

                    if math.abs(Position.Y) > 0.15 then
                        v1188 += Vector3.new(0, 0, -Position.Y)
                    end
                elseif KeyCode == Enum.KeyCode.Thumbstick2 then
                    local Position = v1191.Position

                    if math.abs(Position.X) > 0.15 then
                        p483.CinematicYaw -= Position.X * 2.5 * p484
                    end

                    if math.abs(Position.Y) > 0.15 then
                        p483.CinematicPitch = math.clamp(p483.CinematicPitch + Position.Y * 2.5 * p484, -1.5, 1.5)
                    end
                elseif KeyCode == Enum.KeyCode.ButtonR2 then
                    if v1191.Position.Z > 0.1 then
                        v1188 += Vector3.new(0, v1191.Position.Z, 0)
                    end
                elseif KeyCode == Enum.KeyCode.ButtonL2 and v1191.Position.Z > 0.1 then
                    v1188 += Vector3.new(0, -v1191.Position.Z, 0)
                end
            end

            if UserInputService:IsGamepadButtonDown(v1190, Enum.KeyCode.ButtonR1) then
                p483.CinematicFOV = math.clamp(p483.CinematicFOV - 40 * p484, 10, 90)
            end

            if UserInputService:IsGamepadButtonDown(v1190, Enum.KeyCode.ButtonL1) then
                p483.CinematicFOV = math.clamp(p483.CinematicFOV + 40 * p484, 10, 90)
            end

            if UserInputService:IsGamepadButtonDown(v1190, Enum.KeyCode.ButtonL3) then
                v1189 = true
            end
        end

        if v1189 then
            CinematicSpeed *= 3
        end

        local v1197 = CFrame.fromEulerAnglesYXZ(p483.CinematicPitch, p483.CinematicYaw, 0)

        if v1188.Magnitude > 0 then
            local v1198 = v1188.Magnitude > 1 and v1188.Unit or v1188

            p483.CinematicPos += v1197:VectorToWorldSpace(v1198) * CinematicSpeed * p484
        end

        CurrentCamera.CFrame = CFrame.new(p483.CinematicPos) * v1197
        CurrentCamera.FieldOfView = p483.CinematicFOV
    end
end

function t1.StopCinematic(p485) -- line: 9179
    -- upvalues: RunService (copy), UserInputService (copy), StarterGui (copy)
    if p485.CinematicActive then
        p485.CinematicActive = false

        local function v1199() -- line: 9183
            -- upvalues: RunService (copy)
            RunService:UnbindFromRenderStep("Cinematic")
        end

        pcall(v1199)

        if p485.CinematicScroll then
            p485.CinematicScroll:Disconnect()
            p485.CinematicScroll = nil
        end

        if p485.CinematicKey then
            p485.CinematicKey:Disconnect()
            p485.CinematicKey = nil
        end

        if p485.CinematicIconsHidden then
            for _, v1200 in ipairs(p485.CinematicIconsHidden) do
                if v1200 and v1200.setEnabled then
                    v1200:setEnabled(true)
                end
            end

            p485.CinematicIconsHidden = nil
        end

        if p485.CinematicHidden then
            for _, v1201 in ipairs(p485.CinematicHidden) do
                if v1201 and v1201.Parent then
                    v1201.Enabled = true
                end
            end

            p485.CinematicHidden = nil
        end

        local function v1202() -- line: 9200
            -- upvalues: StarterGui (copy)
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
        end

        pcall(v1202)

        local CurrentCamera = workspace.CurrentCamera
        local CinematicSaved = p485.CinematicSaved

        if CinematicSaved then
            local v1203 = p485.Character and p485.Character:FindFirstChild("HumanoidRootPart")

            if v1203 and CinematicSaved.Anchored ~= nil then
                v1203.Anchored = CinematicSaved.Anchored
            end

            UserInputService.MouseBehavior = CinematicSaved.MouseBehavior
            UserInputService.MouseIconEnabled = CinematicSaved.MouseIconEnabled
            CurrentCamera.CameraType = CinematicSaved.CameraType
            CurrentCamera.FieldOfView = 70
            p485.RunView = false
        else
            CurrentCamera.CameraType = Enum.CameraType.Custom
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = true
        end

        p485.CinematicSaved = nil

        if p485.CinematicRefresh then
            p485.CinematicRefresh()
        end
    end
end

function t1.ToggleCinematic(p486) -- line: 9225
    if p486.CinematicActive then
        p486:StopCinematic()
    else
        p486:StartCinematic()
    end
end

function t1.CreateOwnerGui(p487) -- line: 9233
    -- upvalues: Players (copy), RemoteEvent (copy), Objects (copy)
    local clone = Objects.OwnerGui:Clone()

    clone.ResetOnSpawn = false
    clone.Parent = p487.Player.PlayerGui

    local Main = clone.Main
    local List = clone.Main.List

    local function updatePlayers() -- line: 9240
        -- upvalues: p487 (copy), List (copy), Players (copy), RemoteEvent (copy)
        for _, child in pairs(List:GetChildren()) do
            if child:IsA("Frame") and child.Name ~= "Sample" then
                child:Destroy()
            end
        end

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= p487.Player then
                local clone = List.Sample:Clone()

                clone.Name = player.Name
                clone.Username.Text = "@" .. player.Name
                clone.DisplayName.Text = player.DisplayName
                clone.Visible = true
                clone.Parent = List
                clone.Kick.MouseButton1Click:Connect(function() -- line: 9256
                    -- upvalues: player (copy), RemoteEvent (copy)
                    RemoteEvent:FireServer("KickPlayer", player)
                end)
            end
        end
    end

    Players.PlayerAdded:Connect(updatePlayers)
    Players.PlayerRemoving:Connect(updatePlayers)
    updatePlayers()
    Main.Close.MouseButton1Click:Connect(function() -- line: 9265
        -- upvalues: clone (copy), Main (copy)
        Main.Visible = false
        clone.Open.Text = "Open Player List"
    end)
    clone.Open.MouseButton1Click:Connect(function() -- line: 9270
        -- upvalues: clone (copy), Main (copy)
        if Main.Visible then
            Main.Visible = false
            clone.Open.Text = "Open Player List"
        else
            Main.Visible = true
            clone.Open.Text = "Close Player List"
        end
    end)
    p487:CreateCinematicButton()
end

function t1.CreateCinematicButton(p488) -- line: 9283
    -- upvalues: ReplicatedStorage (copy)
    if p488.CinematicButtonMade then
        return
    end

    p488.CinematicButtonMade = true

    local Icon = require(ReplicatedStorage.Modules.Icon)

    for _, v1204 in pairs(Icon.container) do
        v1204:SetAttribute("CinematicExempt", true)
    end

    local v1205 = Icon.new()

    v1205:setLabel("Cinematic")
    p488.CinematicIcon = v1205
    v1205.selected:Connect(function() -- line: 9296
        -- upvalues: p488 (copy)
        if not p488.CinematicActive then
            p488:StartCinematic()
        end
    end)
    v1205.deselected:Connect(function() -- line: 9299
        -- upvalues: p488 (copy)
        if p488.CinematicActive then
            p488:StopCinematic()
        end
    end)

    p488.CinematicRefresh = function() -- line: 9303
        -- upvalues: p488 (copy)
        if p488.CinematicIcon then
            if p488.CinematicActive then
                p488.CinematicIcon:select()
            else
                p488.CinematicIcon:deselect()
            end
        end
    end
end

function t1.SetupCraft(p489, p490, p491) -- line: 9313
    -- upvalues: ReplicatedStorage (copy), ToolsLib (copy), CraftLib (copy), ExchangeLib (copy), RemoteEvent (copy), createViewportObjects (copy), createViewportBaseObjects (copy), createSkinViewport (copy)
    p489.CraftGui = ReplicatedStorage.Objects.Craft:Clone()
    p489.CraftGui.Parent = p489.Player.PlayerGui

    local List, CloseButton = p489.CraftGui.Main.List, p489.CraftGui.Main.CloseButton
    local v1206, v1207

    if p491 then
        v1206 = ExchangeLib[p491]
        v1207 = true
        p489.CraftGui.Main.Label.Text = p491 .. " Exchange"
    else
        v1207 = false
        v1206 = CraftLib
    end

    for v1208, v1209 in pairs(v1206) do
        local clone = List.Sample:Clone()

        clone.Name = v1208
        clone.Product.ItemName.Text = v1208
        clone.Cost.Text = "$" .. v1209.Cost

        if v1209.Cost == 0 then
            clone.Cost.Text = ""
        end

        clone.LayoutOrder = v1209.Order

        if v1209.BaseObject then
            createViewportBaseObjects(clone.Product, v1208)
        elseif v1209.Skin then
            createSkinViewport(clone.Product, v1209.Item, v1209.Skin)
        else
            createViewportObjects(clone.Product, v1208, ToolsLib[v1208])
        end

        clone.Visible = true
        clone.Parent = List

        if v1207 then
            clone.Craft.Text = "Exchange"
            clone.Recipe.TextLabel.Text = "Items:"
        end

        task.spawn(function() -- line: 9351
            -- upvalues: clone (copy), v1209 (copy), ToolsLib (copy), createViewportObjects (copy)
            local List = clone.Recipe.List

            for v1210, v1211 in pairs(v1209.Recipe) do
                local clone = List.Sample:Clone()

                clone.Name = v1210
                clone.LayoutOrder = v1211.Order
                clone.ItemName.Text = v1210
                clone.Amount.Text = "x" .. v1211.Amount
                createViewportObjects(clone, v1210, ToolsLib[v1210])
                clone.Visible = true
                clone.Parent = List
            end
        end)

        if v1209.Level and p489.Data.Level < v1209.Level then
            clone.LevelReq.Text = "Level " .. v1209.Level .. " Required"
            clone.LevelReq.Visible = true
        else
            clone.Craft.MouseButton1Click:Connect(function() -- line: 9369
                -- upvalues: p490 (copy), p491 (copy), v1208 (copy), RemoteEvent (copy)
                RemoteEvent:FireServer("Craft", v1208, p490, p491)
            end)
        end
    end

    CloseButton.MouseButton1Click:Connect(function() -- line: 9376
        -- upvalues: p489 (copy)
        p489:CloseCraft()
    end)
end

function t1.CloseCraft(p492) -- line: 9381
    if p492.CraftGui then
        p492.CraftGui:Destroy()
        p492.CraftGui = nil
    end
end

function t1.OpenCraft(p493, p494) -- line: 9388
    local v1212 = p494[1]
    local v1213 = p494[2]

    if p493.CraftGui then
        return
    end

    p493:SetupCraft(v1212, v1213)

    repeat
        task.wait(0.1)
    until (p493.Root.Position - v1212.Position).Magnitude > 15 or not p493.CraftGui

    p493:CloseCraft()
end

function t1.KillLog(p495, p496) -- line: 9400
    -- upvalues: TweenService (copy)
    local KillLog = p495.HUD.KillLog
    local v1214 = p496[1]
    local v1215 = p496[2]
    local clone = KillLog.Sample:Clone()

    game.Debris:AddItem(clone, 5)
    clone.Name = "newLog"
    clone.Text = v1214 .. " has  <font color='rgb(255, 0, 0)'>defeated</font> " .. v1215
    clone.Visible = true
    clone.Parent = KillLog
    task.delay(2.5, function() -- line: 9412
        -- upvalues: clone (copy), TweenService (copy)
        TweenService:Create(clone, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }):Play()
    end)
end

function t1.HatchRadar(p497) -- line: 9440
    -- upvalues: RunService (copy)
    local Part = Instance.new("Part")

    Part.Material = Enum.Material.Neon
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Anchored = true
    Part.Color = Color3.fromRGB(0, 255, 0)
    Part.CFrame = p497.Root.CFrame
    Part.Size = Vector3.new(0.5, 0.5, 2)
    Part.Parent = workspace
    p497.RadarPart = Part
    RunService:BindToRenderStep("RadarPart", Enum.RenderPriority.Camera.Value + 1, function() -- line: 9456
        -- upvalues: p497 (copy), Part (copy)
        Part.CFrame = CFrame.new(p497.Root.Position + Vector3.new(0, 1.25, 0), (Vector3.new(-0.225, 3.1, 236.525))) * CFrame.new(0, 0, -3)
    end)
    p497.HUD.HATCHLABEL.Visible = true
end

function t1.HatchRadarOff(p498) -- line: 9463
    -- upvalues: RunService (copy)
    if p498.RadarPart then
        p498.RadarPart:Destroy()
        p498.RadarPart = nil
    end

    RunService:UnbindFromRenderStep("RadarPart")
    p498.HUD.HATCHLABEL.Visible = false
end

function t1.UpdateGlobalShops(p499, p500) -- line: 9472
    p499.GlobalShops = p500

    if p499.GlobalShopGui then
        p499:UpdateGlobalShop()
    end
end

local function getOrderedFrames(p501) -- line: 9480
    local t58 = {}

    for _, child in ipairs(p501:GetChildren()) do
        if child:IsA("ImageButton") and child.Name ~= "Sample" then
            table.insert(t58, child)
        end
    end

    table.sort(t58, function(p502, p503) -- line: 9488
        if p502.LayoutOrder == p503.LayoutOrder then
            return p502:GetAttribute("Price") < p503:GetAttribute("Price")
        end

        return p502.LayoutOrder < p503.LayoutOrder
    end)

    return t58
end

function t1.CloseGlobalShopPopup(p504) -- line: 9498
    -- upvalues: TweenService (copy), getOrderedFrames (copy)
    if p504.GlobalShopGui then
        local List = p504.GlobalShopGui.Main.List
        local Popup = List.Popup

        getOrderedFrames(List)

        local v1217 = UDim2.new(0, 0, 0, 10)

        if not Popup.Visible then
            return
        end

        TweenService:Create(Popup, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = Popup.Position - UDim2.new(0, 0, 0, Popup.AbsoluteSize.Y + 10)
        }):Play()
        task.delay(0.25, function() -- line: 9515
            -- upvalues: Popup (copy)
            Popup.Visible = false
        end)

        local v1218 = getOrderedFrames(List)

        for v1219, v1220 in pairs(v1218) do
            v1220.LayoutOrder = v1219
            TweenService:Create(v1220, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = v1217
            }):Play()
            v1217 += UDim2.new(0, 0, 0, v1220.AbsoluteSize.Y + 10)
        end

        TweenService:Create(List, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CanvasSize = v1217
        }):Play()
    end
end

function t1.GlobalShopPopup(p505, p506, p507, _) -- line: 9537
    -- upvalues: TweenService (copy), MarketplaceService (copy), ToolsLib (copy), getOrderedFrames (copy)
    if p505.GlobalShopGui then
        local List = p505.GlobalShopGui.Main.List

        p505:UpdateGlobalShop()

        local v1221 = getOrderedFrames(List)
        local v1222 = p506.AbsoluteSize.Y + 10
        local n19 = 0

        for i = 1, p507 do
            n19 += v1221[i].AbsoluteSize.Y + 10
        end

        p506.Position = UDim2.new(0.5, 0, 0, v1221[p507].AbsoluteSize.Y)
        p506.Visible = true

        local v1223 = ToolsLib[p505.CurrentPopup]

        if v1223 and v1223.ProductId then
            local ProductInfo = MarketplaceService:GetProductInfo(v1223.ProductId, Enum.InfoType.Product)

            if ProductInfo and ProductInfo.PriceInRobux then
                p506.BuyRobux.Text = "R$" .. ProductInfo.PriceInRobux
            else
                p506.BuyRobux.Text = "R$???"
            end
        else
            p506.BuyRobux.Text = "N/A"
        end

        TweenService:Create(p506, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0, n19 + 10)
        }):Play()

        for i = p507 + 1, #v1221 do
            local v1224 = v1221[i]
            local t59 = {
                Position = v1224.Position + UDim2.new(0, 0, 0, v1222 + 10)
            }

            TweenService:Create(v1224, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t59):Play()
        end

        local v1225 = n19 + v1222 + 10

        for i = p507 + 1, #v1221 do
            v1225 += v1221[i].AbsoluteSize.Y + 10
        end

        List.CanvasSize = UDim2.new(0, 0, 0, v1225)

        local v1226 = v1221[p507]
        local AbsolutePosition = v1226.AbsolutePosition
        local AbsolutePosition2, AbsoluteWindowSize = List.AbsolutePosition, List.AbsoluteWindowSize
        local AbsoluteSize = v1226.AbsoluteSize
        local v1227 = AbsolutePosition.Y - AbsolutePosition2.Y
        local v1230 = math.clamp(List.CanvasPosition.Y + v1227 - AbsoluteWindowSize.Y / 2 + AbsoluteSize.Y / 2, 0, List.AbsoluteCanvasSize.Y - AbsoluteWindowSize.Y)

        TweenService:Create(List, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CanvasPosition = Vector2.new(List.CanvasPosition.X, v1230)
        }):Play()
    end
end

function t1.UpdateGlobalShop(p509) -- line: 9610
    if p509.GlobalShopGui then
        local v1231 = p509.GlobalShops[p509.GlobalShopGui.Name]

        if v1231 then
            local List = p509.GlobalShopGui.Main.List
            local Popup = List.Popup

            for v1232, v1233 in pairs(v1231) do
                if v1232 ~= "Expire" then
                    local v1234 = List:FindFirstChild(v1232)

                    if v1234 then
                        v1234.Stock.Text = "X" .. v1233.Stock .. " Stock"

                        if v1233.Stock <= 0 then
                            v1234.Price.Text = "No Stock"
                            v1234.Price.TextColor3 = Color3.fromRGB(255, 0, 0)

                            if p509.CurrentPopup == v1232 then
                                Popup.Buy.Text = "NO STOCK"
                                Popup.Buy.BackgroundColor3 = Color3.fromRGB(122, 122, 122)
                            end
                        else
                            v1234.Price.Text = "$" .. v1233.Price
                            v1234.Price.TextColor3 = Color3.fromRGB(71, 212, 63)

                            if p509.CurrentPopup == v1232 then
                                Popup.Buy.Text = "$" .. v1233.Price
                                Popup.Buy.BackgroundColor3 = Color3.fromRGB(71, 212, 63)
                            end
                        end
                    end
                end
            end
        end
    end
end

function t1.CloseGlobalShop(p510) -- line: 9646
    if p510.GlobalShopGui then
        p510.GlobalShopGui:Destroy()
        p510.GlobalShopGui = nil
    end

    p510.CurrentPopup = nil
end

function t1.CreateGlobalShop(p511, p512) -- line: 9655
    -- upvalues: Players (copy), MarketplaceService (copy), ToolsLib (copy), RemoteEvent (copy), Objects (copy), createViewportObjects (copy), getOrderedFrames (copy)
    local v1235 = p512[1]
    local v1236 = p512[2]

    if p511.GlobalShops[v1235] then
        local v1237 = p511.GlobalShops[v1235]
        local clone = Objects.StorageShop:Clone()

        clone.Enabled = false
        clone.Name = v1235
        clone.Parent = p511.Player.PlayerGui

        local Main = clone.Main
        local List = Main.List
        local Popup = List.Popup
        local TopBar = Main.TopBar
        local GiftingFrame = clone.GiftingFrame

        local function updateGiftingFrame(p513) -- line: 9673
            -- upvalues: p511 (copy), v1236 (copy), GiftingFrame (copy), Players (copy), RemoteEvent (copy)
            local List = GiftingFrame.List

            GiftingFrame.Label.Text = p513

            for _, child in pairs(List:GetChildren()) do
                if child:IsA("Frame") and child.Name ~= "Sample" then
                    child:Destroy()
                end
            end

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= p511.Player then
                    local UserThumbnailAsync = game.Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
                    local clone = List.Sample:Clone()

                    clone.Name = player.Name
                    clone.PlayerName.Text = player.Name
                    clone.PlayerIcon.Image = UserThumbnailAsync
                    clone.Button.BackgroundColor3 = Color3.fromRGB(255, 226, 151)
                    clone.Button.Text = "Gift"
                    clone.Visible = true
                    clone.Parent = List
                    clone.Button.MouseButton1Click:Connect(function() -- line: 9695
                        -- upvalues: p513 (copy), player (copy), p511 (copy), v1236 (copy), RemoteEvent (copy)
                        RemoteEvent:FireServer("UpdateGifting", player)

                        repeat
                            task.wait(0.1)
                        until p511.Player:GetAttribute("Gifting")

                        RemoteEvent:FireServer("GiftProduct", p513, v1236)
                    end)
                end
            end
        end

        local t60 = {
            "Expire",
            "Refresh"
        }
        local n20 = 0

        p511.CurrentPopup = nil

        for v1238, v1239 in pairs(v1237) do
            if not table.find(t60, v1238) then
                local clone = List.Sample:Clone()

                clone.Name = v1238
                clone.Price.Text = "$" .. v1239.Price
                clone.Stock.Text = "X" .. v1239.Stock .. " Stock"
                clone.ItemName.Text = v1238
                clone.Rarity.Label.Text = v1239.Rarity
                clone.Rarity.BackgroundColor3 = _G.Utl.RarityInfo[v1239.Rarity][1]
                clone.LayoutOrder = _G.Utl.ShopRarityOrder[v1239.Rarity]
                clone.Visible = true
                clone.Parent = List
                clone:SetAttribute("Price", v1239.Price)
                createViewportObjects(clone.ViewportFrame, v1238, ToolsLib[v1238])
                clone.MouseButton1Click:Connect(function() -- line: 9726
                    -- upvalues: p511 (copy), Popup (copy), n20 (ref), v1238 (copy), clone (copy), v1239 (copy)
                    if time() - n20 < 0.52 then
                        return
                    end

                    n20 = time()

                    if p511.CurrentPopup and v1238 == p511.CurrentPopup then
                        p511.CurrentPopup = nil
                        p511:CloseGlobalShopPopup()

                        return
                    end

                    if p511.CurrentPopup then
                        p511:CloseGlobalShopPopup()
                        task.wait(0.26)
                    end

                    p511.CurrentPopup = v1238
                    p511:GlobalShopPopup(Popup, clone.LayoutOrder, v1239)
                end)
            end
        end

        Popup.Buy.MouseButton1Click:Connect(function() -- line: 9745
            -- upvalues: p511 (copy), v1235 (copy), v1236 (copy), n20 (ref), RemoteEvent (copy)
            if not (time() - n20 < 0.2) then
                n20 = time()
                RemoteEvent:FireServer("GlobalBuy", {
                    v1235,
                    p511.CurrentPopup,
                    v1236
                })
            end
        end)
        Popup.BuyRobux.MouseButton1Click:Connect(function() -- line: 9751
            -- upvalues: p511 (copy), n20 (ref), MarketplaceService (copy), ToolsLib (copy)
            if time() - n20 < 0.2 then
                return
            end

            n20 = time()

            local v1240 = ToolsLib[p511.CurrentPopup]

            if v1240 then
                local ProductId = v1240.ProductId

                if ProductId then
                    MarketplaceService:PromptProductPurchase(p511.Player, ProductId)
                end
            end
        end)
        Popup.Gift.MouseButton1Click:Connect(function() -- line: 9762
            -- upvalues: p511 (copy), Main (copy), GiftingFrame (copy), updateGiftingFrame (copy), n20 (ref)
            if time() - n20 < 0.2 then
                return
            end

            n20 = time()

            if p511.CurrentPopup then
                Main.Visible = false
                updateGiftingFrame(p511.CurrentPopup)
                GiftingFrame.Visible = true
            end
        end)
        GiftingFrame.Close.MouseButton1Click:Connect(function() -- line: 9773
            -- upvalues: Main (copy), GiftingFrame (copy), n20 (ref)
            if time() - n20 < 0.2 then
                return
            end

            n20 = time()
            GiftingFrame.Visible = false
            Main.Visible = true
        end)
        TopBar.Refresh.MouseButton1Click:Connect(function() -- line: 9781
            -- upvalues: p511 (copy), n20 (ref), MarketplaceService (copy)
            if not (time() - n20 < 0.2) then
                n20 = time()
                MarketplaceService:PromptProductPurchase(p511.Player, 3334813601)
            end
        end)

        local v1241 = false

        TopBar.CloseButton.MouseButton1Click:Connect(function() -- line: 9789
            -- upvalues: p511 (copy), v1241 (ref)
            v1241 = true
            p511:CloseGlobalShop()
        end)
        task.spawn(function() -- line: 9794
            -- upvalues: p511 (copy), v1235 (copy), v1236 (copy), TopBar (copy), v1241 (ref)
            repeat
                if v1241 then
                    return
                end

                local v1242 = p511.GlobalShops[v1235]

                v1242 = v1242 and tonumber(v1242.Expire)

                local v1243 = if v1242 then math.max(0, v1242 - os.time()) else nil
                local v1245 = if not v1242 or not v1243 then 0 else v1243

                if v1245 > 0 then
                    TopBar.NextRefresh.Text = "New shop in " .. _G.Utl.formatTimeForShop(v1245)
                else
                    TopBar.NextRefresh.Text = "Refreshing shop..."
                end

                task.wait(1)

                local HumanoidRootPart = v1236 and v1236:FindFirstChild("HumanoidRootPart")
            until not p511.Root or not HumanoidRootPart or (p511.Root.Position - HumanoidRootPart.Position).Magnitude > 14

            v1241 = true
            p511:CloseGlobalShop()
        end)

        local v1246 = UDim2.new(0, 0, 0, 10)
        local v1247 = getOrderedFrames(List)

        for v1248, v1249 in pairs(v1247) do
            v1249.LayoutOrder = v1248
            v1249.Position = v1246
            v1246 += UDim2.new(0, 0, 0, v1249.AbsoluteSize.Y + 10)
        end

        List.CanvasSize = v1246
        clone.Enabled = true
        p511.GlobalShopGui = clone
        p511:UpdateGlobalShop()
    end
end

function t1.GotGifted(p514, p515) -- line: 9832
    local v1250 = p515[1]
    local v1251 = p515[2]
    local Gifted = p514.HUD.Gifted

    _G.Utl.PlaySound({
        Sound = "Gifted",
        Origin = p514.HUD
    })

    local clone = Gifted.Sample:Clone()

    clone.Name = v1251
    clone.Text = "<font color='#52ff6c'>" .. v1250 .. "</font> has gifted you <font color='#be4fff'>" .. v1251 .. "</font>"
    clone.Visible = true
    clone.Parent = Gifted
    game.Debris:AddItem(clone, 2.5)
end

function t1.GlobalMessage(p516, p517) -- line: 9846
    -- upvalues: TweenService (copy)
    local Text, Lasts = p517.Text, p517.Lasts
    local Noti = p516.HUD.Noti
    local clone = Noti.Sample:Clone()

    clone.TextTransparency = 1
    clone.TextStrokeTransparency = 1
    clone.Text = Text
    clone.Visible = true
    clone.Parent = Noti
    TweenService:Create(clone, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0,
        TextStrokeTransparency = 0
    }):Play()
    _G.Utl.PlaySound({
        Sound = "GlobalPing",
        Speed = 0.9,
        Origin = p516.Player
    })
    task.wait(Lasts)
    TweenService:Create(clone, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 1,
        TextStrokeTransparency = 1
    }):Play()
    game.Debris:AddItem(clone, 1)
end

function t1.ClearTempCons(p518) -- line: 9873
    for v1252, v1253 in pairs(p518.TempCons) do
        v1253:Disconnect()
        p518.TempCons[v1252] = nil
    end
end

function t1.ClearBankCons(p519) -- line: 9880
    for v1254, v1255 in pairs(p519.BankCons) do
        v1255:Disconnect()
        p519.BankCons[v1254] = nil
    end
end

function t1.UpdateBaits(p520, p521) -- line: 9887
    -- upvalues: BaitsLib (copy)
    if p520.TempCons.BaitButton then
        local Baits = p520.HUD.Baits
        local List, Info = Baits.List, Baits.Info

        for _, child in pairs(List:GetChildren()) do
            if child:IsA("TextButton") and child.Name ~= "Sample" then
                child:Destroy()
            end
        end

        local v1256

        local function updateInfo(p522) -- line: 9901
            -- upvalues: p520 (copy), Info (copy), v1256 (ref), BaitsLib (copy)
            if v1256 and p522 == v1256 then
                v1256 = nil
                Info.Visible = false

                return
            end

            local v1257 = BaitsLib[p522]

            Info.BaitName.Text = p522
            Info.Luck.Text = v1257.Luck
            Info.Speed.Text = v1257.Speed
            v1256 = p522
            Info.Visible = true
            p520.CurrentBaitSelect = p522

            local CurrentBait = p520.Character:GetAttribute("CurrentBait")

            if CurrentBait and p520.CurrentBaitSelect and CurrentBait == p520.CurrentBaitSelect then
                Info.Equip.Text = "Unequip"
            else
                Info.Equip.Text = "Equip"
            end
        end

        for v1258, v1259 in pairs(p521) do
            local clone = List.Sample:Clone()

            clone.Name = v1258
            clone.Text = v1258 .. " (x" .. v1259 .. ")"
            clone.Visible = true
            clone.Parent = List
            p520.TempCons[v1258 .. "Clicked"] = clone.MouseButton1Click:Connect(function() -- line: 9935
                -- upvalues: updateInfo (copy), v1258 (copy)
                updateInfo(v1258)
            end)
        end

        if p520.CurrentBaitSelect then
            updateInfo(p520.CurrentBaitSelect)
        end
    end
end

function t1.ShowBaits(p523, p524) -- line: 9945
    -- upvalues: UnreliableRemoteEvent (copy)
    local Baits = p523.HUD.Baits
    local List, Button, Info = Baits.List, Baits.Button, Baits.Info

    p523.TempCons.BaitButton = Button.MouseButton1Click:Connect(function() -- line: 9952
        -- upvalues: p523 (copy), List (copy), Info (copy)
        List.Visible = not List.Visible

        if not List.Visible then
            Info.Visible = false
            p523.CurrentBaitSelect = nil
        end
    end)
    p523.TempCons.EquipButton = Info.Equip.MouseButton1Click:Connect(function() -- line: 9960
        -- upvalues: p523 (copy), UnreliableRemoteEvent (copy)
        UnreliableRemoteEvent:FireServer("SelectBait", p523.CurrentBaitSelect)
    end)
    p523.TempCons.CurrentBaitChanged = p523.Character:GetAttributeChangedSignal("CurrentBait"):Connect(function() -- line: 9964
        -- upvalues: p523 (copy), Button (copy)
        local CurrentBait = p523.Character:GetAttribute("CurrentBait")

        if CurrentBait then
            Button.Text = "Current Bait: " .. CurrentBait
        else
            Button.Text = "Current Bait: None"
        end
    end)
    p523:UpdateBaits(p524)
    Baits.Visible = true
end

function t1.HideBaits(p525) -- line: 9978
    local Baits = p525.HUD.Baits
    local List = Baits.List

    p525:ClearTempCons()
    p525.CurrentBaitSelect = nil
    List.Visible = false
    Baits.Visible = false
end

function t1.LevelChanged(p526, p527) -- line: 9987
    p526.HUD.Level.LevelLabel.Text = "Level " .. p527
    p526.Data.Level = p527
end

function t1.EXPChanged(p528) -- line: 9992
    local v1260 = _G.Utl.ExpCost(p528.Data.Level)
    local v1261 = p528.Data.EXP / v1260

    if v1261 < 0 then
        v1261 = 0
    elseif v1261 > 1 then
        v1261 = 1
    end

    p528.HUD.Level.Bar:TweenSize(UDim2.new(v1261, 0, 1, 0), "Out", "Linear", 0.25, true)
    p528.HUD.Level.AmountLabel.Text = math.floor(p528.Data.EXP) .. "/" .. v1260

    if p528.Data.Level >= _G.Utl.MaxLevel then
        p528.HUD.Level.Bar:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Linear", 0.05, true)
        p528.HUD.Level.AmountLabel.Text = "MAX"
    end
end

function t1.CandyCornChanged(p529, p530) -- line: 10005
    local v1262 = tonumber(p530) or 0

    if v1262 ~= v1262 or math.abs(v1262) == 1e999 then
        v1262 = 0
    end

    local v1264 = math.max(0, (math.floor(v1262)))

    p529.Data.CandyCorn = v1264

    local v1265 = p529.HUD and p529.HUD:FindFirstChild("Money")
    local CandyCorn = v1265 and v1265:FindFirstChild("CandyCorn")

    if CandyCorn then
        CandyCorn.Text = _G.Utl.addComas((tostring(v1264)))
    end
end

function t1.MoneyChanged(p531, p532) -- line: 10017
    -- upvalues: TweenService (copy)
    local OldMoney = p531.OldMoney

    _G.Utl.PlaySound({
        Sound = "Coins",
        Origin = p531.Player,
        Speed = 0.95 + math.random() * 0.1
    })

    local v1267 = math.floor(p532 - OldMoney)
    local clone = p531.HUD.MoneyChange:Clone()

    game.Debris:AddItem(clone, 1.5)
    clone.Visible = true

    local v1268

    if v1267 >= 0 then
        clone.Text = "+" .. _G.Utl.addComas((tostring(v1267)))
        v1268 = TweenService:Create(clone, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = clone.Position - UDim2.new(0, 0, 0.04, 0)
        })
    else
        clone.Text = "-" .. _G.Utl.addComas((tostring((math.abs(v1267)))))
        clone.TextColor3 = Color3.fromRGB(212, 65, 65)
        v1268 = TweenService:Create(clone, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = clone.Position + UDim2.new(0, 0, 0.04, 0)
        })
    end

    clone.Parent = p531.HUD
    v1268:Play()
    task.delay(0.5, function() -- line: 10042
        -- upvalues: clone (copy), TweenService (copy)
        TweenService:Create(clone, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextStrokeTransparency = 1,
            TextTransparency = 1
        }):Play()
    end)
    p531.HUD.Money.Text = "$" .. _G.Utl.addComas((tostring((math.floor(p532)))))
    p531.OldMoney = p532
end

function t1.HungerChanged(p533, p534) -- line: 10053
    local v1271 = p534 / 100

    if v1271 < 0 then
        v1271 = 0
    elseif v1271 > 1 then
        v1271 = 1
    end

    p533.HUD.Hunger.Bar:TweenSize(UDim2.new(v1271, 0, 1, 0), "Out", "Linear", 0.25, true)
    p533.HUD.Hunger.AmountLabel.Text = math.floor(p534) .. "%"
end

function t1.ThirstChanged(p535, p536) -- line: 10060
    local v1272 = p536 / 100

    if v1272 < 0 then
        v1272 = 0
    elseif v1272 > 1 then
        v1272 = 1
    end

    p535.HUD.Thirst.Bar:TweenSize(UDim2.new(v1272, 0, 1, 0), "Out", "Linear", 0.25, true)
    p535.HUD.Thirst.AmountLabel.Text = math.floor(p536) .. "%"
end

function t1.ArmorChanged(p537, p538) -- line: 10067
    local v1273 = p538 / 100

    if v1273 < 0 then
        v1273 = 0
    elseif v1273 > 1 then
        v1273 = 1
    end

    p537.HUD.Armor.Bar:TweenSize(UDim2.new(v1273, 0, 1, 0), "Out", "Linear", 0.25, true)
    p537.HUD.Armor.AmountLabel.Text = math.floor(p538) .. "%"
end

function t1.CombatLogChanged(p539, p540) -- line: 10074
    p539.InCombat = p540 == true
    p539.HUD.InCombat.Visible = p540
end

function t1.RegisterSafezoneGate(p541, p542) -- line: 10081
    if typeof(p542) ~= "Instance" or p542.Name ~= "SZGATE" or not p542:IsA("BasePart") then
        return
    end

    local SafezoneGates = p541.SafezoneGates

    if SafezoneGates and not SafezoneGates[p542] then
        p542.Anchored = true
        p542.CanCollide = false
        p542.CanTouch = false
        p542.CanQuery = false
        p542.Transparency = 1
        SafezoneGates[p542] = {
            Size = p542.Size,
            CFrame = p542.CFrame
        }
        p541.SafezoneGatesDirty = true
    end
end

function t1.SetupSafezoneGates(p543) -- line: 10098
    p543.SafezoneGates = {}
    p543.SafezoneGateAlpha = 0
    p543.SafezoneGatesDirty = false

    local Map = workspace:FindFirstChild("Map")
    local v1274 = Map and Map:FindFirstChild("SAFEZONE GATES")

    if not v1274 then
        return
    end

    for _, child in ipairs(v1274:GetChildren()) do
        p543:RegisterSafezoneGate(child)
    end

    v1274.ChildAdded:Connect(function(p544) -- line: 10108
        -- upvalues: p543 (copy)
        p543:RegisterSafezoneGate(p544)
    end)
end

function t1.UpdateSafezoneGates(p545, p546) -- line: 10113
    local SafezoneGates = p545.SafezoneGates
    local v1275 = false
    local v1276 = false
    local v1277 = false
    local v1278 = false
    local v1279 = false
    local v1280 = false

    if SafezoneGates then
        v1275 = true
    else
        v1280 = true
    end

    if v1275 then
        if next(SafezoneGates) ~= nil then
            v1276 = true
        else
            v1280 = true
        end
    end

    v1275 = false

    local v1281

    if v1276 then
        if p545.InCombat then
            v1275 = true
        else
            v1281 = 0
            v1280 = false
        end
    end

    v1276 = false

    if v1275 then
        if p545.Player:GetAttribute("Safezone") == true then
            v1277 = true
        else
            v1276 = true
        end
    end

    v1275 = false

    local v1282

    if v1276 then
        v1282 = false
        v1275 = true
    end

    v1276 = false

    if v1277 then
        v1282 = true
        v1275 = true
    end

    v1277 = false

    local Map, v1283

    if v1275 then
        Map = workspace:FindFirstChild("Map")

        if Map then
            v1277 = true
        else
            v1283 = Map
            v1276 = true
        end
    end

    v1275 = false

    if v1277 then
        v1283 = Map:FindFirstChild("SafezoneDetect")
        v1276 = true
    end

    v1277 = false

    local v1284

    if v1276 then
        if v1283 then
            v1277 = true
        else
            v1284 = v1282
            v1275 = true
        end
    end

    v1276 = false

    if v1277 then
        if p545.Root then
            v1276 = true
        else
            v1284 = v1282
            v1275 = true
        end
    end

    v1277 = false

    if v1276 then
        if p545.Root.Parent then
            v1277 = true
        else
            v1284 = v1282
            v1275 = true
        end
    end

    v1276 = false

    local v1285, v1286, v1287

    if v1277 then
        v1285 = v1283.CFrame:PointToObjectSpace(p545.Root.Position)
        v1286 = v1283.Size / 2

        if math.abs(v1285.X) <= v1286.X then
            v1276 = true
        else
            v1287 = false
            v1278 = true
        end
    end

    v1277 = false

    if v1276 then
        if math.abs(v1285.Z) <= v1286.Z then
            v1277 = true
        else
            v1287 = false
            v1278 = true
        end
    end

    v1276 = false

    if v1277 then
        if math.abs(v1285.Y) <= v1286.Y + 60 then
            v1279 = true
        else
            v1276 = true
        end
    end

    if v1276 then
        v1287 = false
        v1278 = true
    end

    if v1279 then
        v1287 = true
        v1278 = true
    end

    v1279 = false

    if v1278 then
        v1284 = v1287
        v1275 = true
    end

    if v1275 then
        if v1284 then
            v1281 = 0
            v1280 = false
        else
            v1279 = true
        end
    end

    if v1279 then
        v1281 = 1
        v1280 = false
    end

    if v1280 then
        return
    end

    local v1288 = p545.SafezoneGateAlpha or 0

    if v1288 == v1281 and not p545.SafezoneGatesDirty then
        return
    end

    p545.SafezoneGatesDirty = false

    if v1288 ~= v1281 then
        local v1289

        if v1281 == 1 then
            v1289 = 1
        else
            v1289 = v1288 + (v1281 - v1288) * math.min((p546 or 0) * 8, 1)

            if math.abs(v1281 - v1289) < 0.01 then
                v1289 = v1281
            end
        end

        v1288 = v1289
        p545.SafezoneGateAlpha = v1289
    end

    for v1293, v1294 in pairs(SafezoneGates) do
        if v1293.Parent then
            local v1296 = math.max(v1294.Size.Y * v1288, 0.05)

            v1293.Size = Vector3.new(v1294.Size.X, v1296, v1294.Size.Z)
            v1293.CFrame = v1294.CFrame + Vector3.new(0, (v1294.Size.Y - v1296) / 2, 0)
            v1293.Transparency = 1 - v1288
            v1293.CanCollide = v1288 > 0.05
            continue
        end

        SafezoneGates[v1293] = nil
    end
end

function t1.InitShop(p547) -- line: 10159
    -- upvalues: ProductLib (copy)
    local Shop = p547.HUD.Shop

    for v1298, v1299 in pairs(ProductLib.Money) do
        local clone = Shop.Money.Sample:Clone()

        clone.Name = v1298
        clone.LayoutOrder = v1299.Order or 99
        clone.Text = "$" .. _G.Utl.addComas((tostring(v1299.Money)))
        clone.Visible = true
        clone.Parent = Shop.Money
    end

    for v1300, v1301 in pairs(ProductLib.Other) do
        local clone = Shop.Other.Sample:Clone()

        clone.Name = v1300
        clone.LayoutOrder = v1301.Order or 99
        clone.Text = v1301.Label
        clone.Visible = true
        clone.Parent = Shop.Other
    end
end

function t1.OpenShop(p548) -- line: 10181
    -- upvalues: MarketplaceService (copy), ProductLib (copy)
    p548:ClearTempCons()

    local Shop = p548.HUD.Shop
    local Money, Other = Shop.Money, Shop.Other

    for _, child in pairs(Money:GetChildren()) do
        if child:IsA("TextButton") and child.Name ~= "Sample" then
            p548.TempCons[child.Name .. "Clicked"] = child.MouseButton1Click:Connect(function() -- line: 10189
                -- upvalues: p548 (copy), child (copy), MarketplaceService (copy)
                MarketplaceService:PromptProductPurchase(p548.Player, (tonumber(child.Name)))
            end)
        end
    end

    for _, child in pairs(Other:GetChildren()) do
        if child:IsA("TextButton") and child.Name ~= "Sample" then
            local v1303 = ProductLib.Other[tonumber(child.Name)]

            p548.TempCons[child.Name .. "Clicked"] = child.MouseButton1Click:Connect(function() -- line: 10198
                -- upvalues: p548 (copy), child (copy), v1303 (copy), MarketplaceService (copy)
                if v1303.Gamepass then
                    MarketplaceService:PromptGamePassPurchase(p548.Player, (tonumber(child.Name)))
                else
                    MarketplaceService:PromptProductPurchase(p548.Player, (tonumber(child.Name)))
                end
            end)
        end
    end

    Shop.Visible = true
end

function t1.CloseShop(p549) -- line: 10211
    p549:ClearTempCons()
    p549.HUD.Shop.Visible = false
end

function t1.UpdateKeybinds(p550) -- line: 10216
    local v1305 = p550.Data and p550.Data.Keybinds

    if typeof(v1305) == "table" then
        local Main = p550.HUD.Keybinds.Main

        for v1306, v1307 in pairs(_G.Utl.DefaultBindings) do
            local v1309 = typeof(v1305[v1306]) == "table" and v1305[v1306] or {}
            local v1310 = typeof(v1309.Keyboard) == "string" and v1309.Keyboard or ""
            local v1311 = typeof(v1309.Console) == "string" and v1309.Console or ""
            local v1312 = _G.Utl.TranslateKeys[v1310] or v1307.Keyboard
            local v1313 = _G.Utl.TranslateKeys[v1311] or v1307.Console
            local v1314 = p550.MainContext:FindFirstChild(v1306)

            if v1314 then
                local Keyboard = v1314:FindFirstChild("Keyboard")
                local Console = v1314:FindFirstChild("Console")

                if Keyboard then
                    Keyboard.KeyCode = v1312
                end

                if Console then
                    Console.KeyCode = v1313
                end
            end

            local v1315 = Main:FindFirstChild(v1306)

            if v1315 then
                v1315.Keyboard.Text = v1312.Name
                v1315.Console.Text = v1313.Name
            end
        end
    end
end

function t1.CloseKeybinds(p551) -- line: 10248
    if p551.KeybindChangeCon then
        p551.KeybindChangeCon:Disconnect()
        p551.KeybindChangeCon = nil
    end

    if p551.CurrentChanging then
        p551.CurrentChanging.UIStroke.Thickness = 1
        p551.CurrentChanging.UIStroke.Color = Color3.fromRGB(255, 255, 255)
        p551.CurrentChanging = nil
    end

    p551.HUD.Keybinds.Visible = false
    p551:ClearTempCons()
end

function t1.InitKeybinds(p552) -- line: 10264
    -- upvalues: UserInputService (copy), RemoteEvent (copy)
    p552:ClearTempCons()

    local Main = p552.HUD.Keybinds.Main

    for v1316, v1317 in pairs(_G.Utl.DefaultBindings) do
        local v1318 = Main:FindFirstChild(v1316)

        if not v1318 then
            v1318 = Main.Sample:Clone()
            v1318.Name = v1316
            v1318.ActionName.Text = v1316
            v1318.Visible = true
            v1318.Parent = Main
        end

        if v1317.Keyboard then
            p552.TempCons[v1316 .. "Keyboard"] = v1318.Keyboard.Activated:Connect(function() -- line: 10291
                -- upvalues: p552 (copy), v1316 (copy), v1318 (ref), UserInputService (copy), RemoteEvent (copy)
                if p552.CurrentChanging then
                    if p552.KeybindChangeCon then
                        p552.KeybindChangeCon:Disconnect()
                        p552.KeybindChangeCon = nil
                    end

                    if p552.CurrentChanging then
                        p552.CurrentChanging.UIStroke.Thickness = 1
                        p552.CurrentChanging.UIStroke.Color = Color3.fromRGB(255, 255, 255)
                        p552.CurrentChanging = nil
                    end
                end

                p552.CurrentChanging = v1318.Keyboard
                p552.CurrentChanging.UIStroke.Thickness = 3
                p552.CurrentChanging.UIStroke.Color = Color3.fromRGB(116, 202, 255)
                p552.KeybindChangeCon = UserInputService.InputBegan:Connect(function(p553) -- line: 10299
                    -- upvalues: p552 (copy), v1316 (copy), RemoteEvent (copy)
                    local Name = if _G.Utl.tabFind(_G.Utl.KeyboardBindings, p553.KeyCode) then p553.KeyCode.Name
                        elseif p553.UserInputType == Enum.UserInputType.MouseButton1 then Enum.KeyCode.MouseLeftButton.Name
                        elseif p553.UserInputType == Enum.UserInputType.MouseButton2 then Enum.KeyCode.MouseRightButton.Name
                        else nil

                    if not Name then
                        return
                    end

                    if p552.KeybindChangeCon then
                        p552.KeybindChangeCon:Disconnect()
                        p552.KeybindChangeCon = nil
                    end

                    if p552.CurrentChanging then
                        p552.CurrentChanging.UIStroke.Thickness = 1
                        p552.CurrentChanging.UIStroke.Color = Color3.fromRGB(255, 255, 255)
                        p552.CurrentChanging = nil
                    end

                    RemoteEvent:FireServer("ChangeKeybind", {
                        Type = "Keyboard",
                        ActionName = v1316,
                        BindName = Name
                    })
                end)
            end)
        end

        if v1317.Console then
            p552.TempCons[v1316 .. "Console"] = v1318.Console.Activated:Connect(function() -- line: 10317
                -- upvalues: p552 (copy), v1316 (copy), v1318 (ref), UserInputService (copy), RemoteEvent (copy)
                if p552.CurrentChanging then
                    if p552.KeybindChangeCon then
                        p552.KeybindChangeCon:Disconnect()
                        p552.KeybindChangeCon = nil
                    end

                    if p552.CurrentChanging then
                        p552.CurrentChanging.UIStroke.Thickness = 1
                        p552.CurrentChanging.UIStroke.Color = Color3.fromRGB(255, 255, 255)
                        p552.CurrentChanging = nil
                    end
                end

                p552.CurrentChanging = v1318.Console
                p552.CurrentChanging.UIStroke.Thickness = 3
                p552.CurrentChanging.UIStroke.Color = Color3.fromRGB(116, 202, 255)
                p552.KeybindChangeCon = UserInputService.InputBegan:Connect(function(p554) -- line: 10325
                    -- upvalues: p552 (copy), v1316 (copy), RemoteEvent (copy)
                    if _G.Utl.tabFind(_G.Utl.ConsoleBindings, p554.KeyCode) then
                        local Name = p554.KeyCode.Name

                        if p552.KeybindChangeCon then
                            p552.KeybindChangeCon:Disconnect()
                            p552.KeybindChangeCon = nil
                        end

                        if p552.CurrentChanging then
                            p552.CurrentChanging.UIStroke.Thickness = 1
                            p552.CurrentChanging.UIStroke.Color = Color3.fromRGB(255, 255, 255)
                            p552.CurrentChanging = nil
                        end

                        RemoteEvent:FireServer("ChangeKeybind", {
                            Type = "Console",
                            ActionName = v1316,
                            BindName = Name
                        })
                    end
                end)
            end)
        end
    end

    p552:UpdateKeybinds()
end

function t1.DropMoneyGui(p555, p556) -- line: 10339
    -- upvalues: RemoteEvent (copy)
    p555.HUD.DropMoney.Visible = p556

    if p556 then
        if not p555.DropMoneyCon then
            local n21 = 0

            p555.DropMoneyCon = p555.HUD.DropMoney.Drop.MouseButton1Click:Connect(function() -- line: 10344
                -- upvalues: p555 (copy), n21 (ref), RemoteEvent (copy)
                if time() - n21 < 0.5 then
                    return
                end

                n21 = time()

                local Text = p555.HUD.DropMoney.Text

                if Text then
                    RemoteEvent:FireServer("DropMoney", Text)
                end
            end)
        end
    elseif p555.DropMoneyCon then
        p555.DropMoneyCon:Disconnect()
        p555.DropMoneyCon = nil
    end
end

function t1.UpdateMobileButtons(p557) -- line: 10362
    local MobileButtonPos = p557.Data.MobileButtonPos

    if MobileButtonPos then
        local MobileButtons = p557.Player.PlayerGui.MobileButtons

        for _, child in pairs(MobileButtons.Buttons:GetChildren()) do
            if MobileButtonPos[child.Name] then
                local t61 = {}

                for match in string.gmatch(MobileButtonPos[child.Name], "[^, ]+") do
                    table.insert(t61, (tonumber(match)))
                end

                child.Position = UDim2.new(t61[1], t61[2], t61[3], t61[4])
            else
                child.Position = _G.Utl.DefaultMobilePositions[child.Name]
            end
        end
    end
end

function t1.EnableSkills(p558, p559) -- line: 10382
    -- upvalues: UserInputService (copy), ToolsLib (copy)
    local v1322 = ToolsLib[p559]

    if v1322.Skills then
        local Skills = p558.HUD.Skills

        if UserInputService.TouchEnabled then
            for v1323, v1324 in pairs(v1322.Skills) do
                if p558.MobileButtons.Buttons:FindFirstChild(v1323) then
                    p558.MobileButtons.Buttons[v1323].Visible = true
                    p558.MobileButtons.Buttons[v1323]:SetAttribute("Skill", v1324)
                end
            end
        else
            local t62 = {
                Skill1 = { "Z", "ButtonX" },
                Skill2 = { "X", "ButtonA" }
            }

            for v1325, v1326 in pairs(v1322.Skills) do
                local clone = Skills.Sample:Clone()

                clone.Name = v1326

                if UserInputService.GamepadEnabled then
                    clone.Text = t62[v1325][2] .. " - " .. v1326
                else
                    clone.Text = t62[v1325][1] .. " - " .. v1326
                end

                clone.Visible = true
                clone.Parent = Skills
                clone:SetAttribute("Skill", v1326)

                if p558.MainContext:FindFirstChild(v1325) then
                    p558.MainContext[v1325].Keyboard.UIButton = clone
                end
            end
        end
    end
end

function t1.DisableSkills(p560) -- line: 10420
    local Skills = p560.HUD.Skills

    p560.MobileButtons.Buttons.Skill1.Visible = false
    p560.MobileButtons.Buttons.Skill2.Visible = false

    for _, child in pairs(Skills:GetChildren()) do
        if child:IsA("TextButton") and child.Name ~= "Sample" then
            child:Destroy()
        end
    end
end

function t1.SkillCD(p561, p562) -- line: 10433
    -- upvalues: UserInputService (copy), TweenService (copy)
    local v1327 = p562[1]
    local v1328 = p562[2]

    if UserInputService.TouchEnabled then
        for _, child in pairs(p561.MobileButtons.Buttons:GetChildren()) do
            if child:GetAttribute("Skill") and child:GetAttribute("Skill") == v1327 then
                local CD = child:FindFirstChild("CD")

                CD.Visible = true
                CD.Size = UDim2.new(1, 0, 1, 0)
                TweenService:Create(CD, TweenInfo.new(v1328, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0, 0)
                }):Play()
                task.delay(v1328, function() -- line: 10448
                    -- upvalues: CD (copy)
                    CD.Visible = false
                end)

                return
            end
        end
    else
        local Skills = p561.HUD.Skills

        for _, child in pairs(Skills:GetChildren()) do
            if child:GetAttribute("Skill") and child:GetAttribute("Skill") == v1327 then
                local CD = child:FindFirstChild("CD")

                CD.Visible = true
                CD.Size = UDim2.new(1, 0, 1, 0)
                TweenService:Create(CD, TweenInfo.new(v1328, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 0, 1, 0)
                }):Play()
                task.delay(v1328, function() -- line: 10466
                    -- upvalues: CD (copy)
                    CD.Visible = false
                end)

                return
            end
        end
    end
end

function t1.UpdateDailyRewards(p563) -- line: 10475
    local DailyRewards = p563.HUD.DailyRewards
    local Day = p563.Data.DailyReward.Day

    for _, child in pairs(DailyRewards.Main:GetChildren()) do
        if child:IsA("ImageButton") then
            if tonumber(child.Name) < Day then
                child.Claimed.Visible = true
            else
                child.Claimed.Visible = false
            end
        end
    end
end

return t1
