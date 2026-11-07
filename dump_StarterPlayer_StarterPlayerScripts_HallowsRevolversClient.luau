-- decompiled by Velocity decompiler v1.0.3

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local ContentProvider = game:GetService("ContentProvider")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ToolsLib = Modules:WaitForChild("ToolsLib")
local v1 = require(ToolsLib)["Hallow's Revolvers"]
local Sounds = ReplicatedStorage:WaitForChild("Sounds")
local HallowsRevolvers = Sounds:WaitForChild("HallowsRevolvers")
local RevolverHeavy = HallowsRevolvers:WaitForChild("RevolverHeavy")
local RevolverHeavyCharge = HallowsRevolvers:WaitForChild("RevolverHeavyCharge")
HallowsRevolvers = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
Players = Remotes:WaitForChild("HallowsRevolversFX")
local PlayerGui = HallowsRevolvers:WaitForChild("PlayerGui")
local v2 = Color3.fromRGB(112, 221, 255)
local v3 = Color3.fromRGB(220, 254, 255)
local v4 = Color3.fromRGB(33, 151, 255)
local v5 = Color3.fromRGB(7, 18, 31)
task.spawn(function() --[[ Upvalues: RevolverHeavy (copy), RevolverHeavyCharge (copy), ReplicatedStorage (copy), ContentProvider (copy) ]]
    local Sound = Instance.new("Sound")
    local Sound1 = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://114311638830453"
    Sound1.SoundId = "rbxassetid://72489278445121"
    local v6 = {Sound, Sound1, RevolverHeavy, RevolverHeavyCharge}
    local Animations = ReplicatedStorage:WaitForChild("Animations")
    for k1, k2 in Animations:WaitForChild("HallowsRevolvers"):GetChildren() do
        table.insert(v6, k2)
    end

    pcall(function() --[[ Upvalues: ContentProvider (upvalue), v6 (copy) ]]
        ContentProvider:PreloadAsync(v6)
    end)
    Sound:Destroy()
    Sound1:Destroy()
end)
local HallowsRevolversEnergy = PlayerGui:FindFirstChild("HallowsRevolversEnergy")
if HallowsRevolversEnergy then
    HallowsRevolversEnergy:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HallowsRevolversEnergy"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = false
ScreenGui.DisplayOrder = 15
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Enabled = false
ScreenGui.Parent = PlayerGui
PlayerGui = Instance.new("Frame")
PlayerGui.Name = "ShotFlash"
PlayerGui.Size = UDim2.fromScale(1, 1)
PlayerGui.BackgroundColor3 = v2
PlayerGui.BackgroundTransparency = 1
PlayerGui.BorderSizePixel = 0
PlayerGui.Active = false
PlayerGui.ZIndex = 1
PlayerGui.Parent = ScreenGui
local Frame = Instance.new("Frame")
Frame.Name = "EnergyPanel"
Frame.AnchorPoint = Vector2.new(0.5, 1)
Frame.Position = UDim2.new(0.5, 0, 1, -172)
Frame.Size = UDim2.fromOffset(326, 65)
Frame.BackgroundTransparency = 1
Frame.Active = false
Frame.ZIndex = 3
Frame.Parent = ScreenGui
local UIScale = Instance.new("UIScale")
UIScale.Parent = Frame

local function label(a0, a1, a2, a3, a4, a5) --[[ Upvalues: v5 (copy), Frame (copy) ]]
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = a0
    TextLabel.Text = a1
    TextLabel.Position = a2
    TextLabel.Size = a3
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = Enum.Font.GothamMedium
    TextLabel.TextSize = a5
    TextLabel.TextColor3 = a4
    TextLabel.TextStrokeColor3 = v5
    TextLabel.TextStrokeTransparency = 0.5
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.ZIndex = 4
    TextLabel.Parent = Frame
    return TextLabel
end

local v10 = UDim2.fromOffset(1, 0)
local v11 = UDim2.fromOffset(220, 19)
local TextLabel1 = Instance.new("TextLabel")
TextLabel1.Name = "Title"
TextLabel1.Text = "Energy"
TextLabel1.Position = v10
TextLabel1.Size = v11
TextLabel1.BackgroundTransparency = 1
TextLabel1.Font = Enum.Font.GothamMedium
TextLabel1.TextSize = 12
TextLabel1.TextColor3 = v3
TextLabel1.TextStrokeColor3 = v5
TextLabel1.TextStrokeTransparency = 0.5
TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
TextLabel1.ZIndex = 4
TextLabel1.Parent = Frame
local v12 = UDim2.fromOffset(226, 0)
local v13 = UDim2.fromOffset(99, 19)
v10 = Instance.new("TextLabel")
v10.Name = "Amount"
v10.Text = "100 / 100"
v10.Position = v12
v10.Size = v13
v10.BackgroundTransparency = 1
v10.Font = Enum.Font.GothamMedium
v10.TextSize = 12
v10.TextColor3 = v3
v10.TextStrokeColor3 = v5
v10.TextStrokeTransparency = 0.5
v10.TextXAlignment = Enum.TextXAlignment.Left
v10.ZIndex = 4
v10.Parent = Frame
v10.TextXAlignment = Enum.TextXAlignment.Right
local v14 = UDim2.fromOffset(1, 47)
local v15 = UDim2.fromOffset(324, 17)
local TextLabel2 = Instance.new("TextLabel")
TextLabel2.Name = "Status"
TextLabel2.Text = ""
TextLabel2.Position = v14
TextLabel2.Size = v15
TextLabel2.BackgroundTransparency = 1
TextLabel2.Font = Enum.Font.GothamMedium
TextLabel2.TextSize = 10
TextLabel2.TextColor3 = v2
TextLabel2.TextStrokeColor3 = v5
TextLabel2.TextStrokeTransparency = 0.5
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.ZIndex = 4
TextLabel2.Parent = Frame
label = Instance.new("Frame")
label.Name = "EnergyBorder"
label.Position = UDim2.fromOffset(1, 22)
label.Size = UDim2.fromOffset(324, 23)
label.BackgroundColor3 = v5
label.BackgroundTransparency = 0.12
label.BorderSizePixel = 0
label.ZIndex = 3
label.Parent = Frame
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = label
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = v2
UIStroke.Thickness = 2
UIStroke.Transparency = 0.08
UIStroke.Parent = label
local Frame1 = Instance.new("Frame")
Frame1.Name = "EmptyInset"
Frame1.Position = UDim2.fromOffset(5, 5)
Frame1.Size = UDim2.new(1, -10, 1, -10)
Frame1.BackgroundColor3 = Color3.fromRGB(11, 35, 54)
Frame1.BorderSizePixel = 0
Frame1.ClipsDescendants = true
Frame1.ZIndex = 4
Frame1.Parent = label
label = Instance.new("Frame")
label.Name = "EnergyFill"
label.Size = UDim2.fromScale(1, 1)
label.BackgroundColor3 = Color3.new(1, 1, 1)
label.BorderSizePixel = 0
label.ZIndex = 5
label.Parent = Frame1
local UIGradient = Instance.new("UIGradient")
local v16 = Color3.fromRGB(21, 99, 219)
local v17 = ColorSequenceKeypoint.new(0, v16)
local v18 = ColorSequenceKeypoint.new(0.65, v4)
local v20 = {v17, v18, ColorSequenceKeypoint.new(1, v2)}
UIGradient.Color = ColorSequence.new(v20)
UIGradient.Parent = label
UIGradient = {}
local v21 = {}
v20 = HallowsRevolvers.Character
v17 = 100
v18 = 100
local v22 = 0
local v23 = 0
local v24 = -100
local v25 = {}

local function finiteVector(a0)
    local v26 = false
    if typeof(a0) == "Vector3" then
        v26 = false
        if a0.X == a0.X then
            v26 = false
            if a0.Y == a0.Y then
                v26 = false
                if a0.Z == a0.Z then
                    v26 = false
                    local v27 = math.abs(a0.X)
                    if v27 < 1000000 then
                        v26 = false
                        local v28 = math.abs(a0.Y)
                        if v28 < 1000000 then
                            local v29 = math.abs(a0.Z)
                            v26 = v29 < 1000000
                        end
                    end
                end
            end
        end
    end

    return v26
end

local function neonPart(a0, a1, a2, a3)
    local Part = Instance.new("Part")
    Part.Name = a0
    local v31 = a2 or Enum.PartType.Block
    Part.Shape = v31
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon
    Part.Color = a1
    Part.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
    Part.Transparency = 1
    Part.Parent = a3
    return Part
end

local function light(a0, a1, a2) --[[ Upvalues: v2 (copy) ]]
    local PointLight = Instance.new("PointLight")
    PointLight.Color = v2
    PointLight.Brightness = a1
    PointLight.Range = a2
    PointLight.Shadows = false
    PointLight.Parent = a0
    return PointLight
end

local function playSound(a0, a1, a2, a3, a4) --[[ Upvalues: v2 (copy), RevolverHeavy (copy), Debris (copy) ]]
    local v32 = v2
    local v33 = workspace
    local Part1 = Instance.new("Part")
    Part1.Name = "CeroSound"
    local v34 = Enum.PartType.Block or Enum.PartType.Block
    Part1.Shape = v34
    Part1.Anchored = true
    Part1.CanCollide = false
    Part1.CanTouch = false
    Part1.CanQuery = false
    Part1.CastShadow = false
    Part1.Material = Enum.Material.Neon
    Part1.Color = v32
    Part1.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
    Part1.Transparency = 1
    Part1.Parent = v33
    Part1.CFrame = CFrame.new(a0)
    Part1.Transparency = 1
    local v37 = a3 and not a2
    local v39
    if not (v37 and RevolverHeavy:Clone()) then
        local Sound2 = Instance.new("Sound")
    end

    v39:Stop()
    local v40
    if a2 then
        v40 = "CeroDryFire"
    else
        if v37 then
            v40 = "HeavyCeroBlast"
        else
            v40 = "CeroBlast"
        end
    end

    v39.Name = v40
    if not v37 then
        v39.SoundId = a1
        if a2 then
            v40 = 0.6
        else
            v40 = 0.85
        end

        v39.Volume = v40
        if a2 then
            v40 = 1
        else
            v40 = 0.92
        end

        v39.PlaybackSpeed = v40
        v39.RollOffMode = Enum.RollOffMode.InverseTapered
        if a2 then
            v40 = 5
        else
            v40 = 12
        end

        v39.RollOffMinDistance = Enum.RollOffMode.InverseTapered
        if a2 then
            v40 = 50
        else
            v40 = 170
        end

        v39.RollOffMaxDistance = Enum.RollOffMode.InverseTapered
    end

    if typeof(a4) == "number" then
        v39.PlaybackSpeed = math.clamp(a4, 0.5, 2)
    end

    v39.Parent = Part1
    if v37 then
        v39.Ended:Once(function() --[[ Upvalues: Debris (upvalue), Part1 (copy) ]]
            Debris:AddItem(Part1, 0.25)
        end)
        Debris:AddItem(Part1, 30)
    else
        Debris:AddItem(Part1, 2.8)
    end

    v39:Play()
end

local function basis(a0)
    local v41 = math.abs(a0.Y)
    local v42
    if 0.95 < v41 then
        v42 = Vector3.new(0, 0, 1)
    else
        v42 = Vector3.new(0, 1, 0)
    end

    local Unit = a0:Cross(v42).Unit
    return Unit:Cross(a0).Unit, Unit
end

local function clearCharge(a0, a1) --[[ Upvalues: v21 (copy) ]]
    local v43 = v21[a0]
    if v43 then
        if a1 == nil or v43.serial == a1 then
            if v43.soundLoaded then
                v43.soundLoaded:Disconnect()
            end

            if v43.sound then
                v43.sound:Stop()
            end

            v43.model:Destroy()
            v21[a0] = nil
        end
    end
end

local function createCharge(a0) --[[ Upvalues: finiteVector (copy), v21 (copy), Debris (copy), v3 (copy), v2 (copy), v4 (copy), RevolverHeavyCharge (copy) ]]
    local Character = a0.Character
    if not (typeof(Character) == "Instance" and Character:IsA("Model") and finiteVector(a0.Origin)) then
        return
    end

    local v44 = v21[Character]
    if v44 and v44.serial == a0.Serial then
        return
    end

    v44 = v21[Character]
    if v44 then
        if v44.soundLoaded then
            v44.soundLoaded:Disconnect()
        end

        if v44.sound then
            v44.sound:Stop()
        end

        v44.model:Destroy()
        v21[Character] = nil
    end

    local CurrentCamera = workspace.CurrentCamera
    if CurrentCamera and 450 < (CurrentCamera.CFrame.Position - a0.Origin).Magnitude then
        return
    end

    local v45 = tonumber(a0.Duration) or 0.7
    local v46 = math.clamp(v45, 0.1, 10)
    local v49 = tonumber(a0.StartedAt) or workspace:GetServerTimeNow()
    local v50 = math.max(0, workspace:GetServerTimeNow() - v49)
    if v46 + 1 < v50 then
        return
    end

    v49 = Instance.new("Model")
    v49.Name = "HallowsHeavyCharge"
    v49:SetAttribute("HallowsLocalEffect", true)
    v49.Parent = workspace
    Debris:AddItem(v49, v46 + 1.2)
    local v51 = {
        model = v49,
        owner = Character,
        serial = a0.Serial,
        started = os.clock() - v50,
        duration = v46
    }
    local v53 = finiteVector(a0.Offset) and a0.Offset or Vector3.new(0, 1, -5)
    v51.offset = v53
    v51.origin = a0.Origin
    v51.successful = a0.Successful ~= false
    local v54 = v3
    local Part2 = Instance.new("Part")
    Part2.Name = "ChargeCore"
    local v55 = Enum.PartType.Ball or Enum.PartType.Block
    Part2.Shape = v55
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanTouch = false
    Part2.CanQuery = false
    Part2.CastShadow = false
    Part2.Material = Enum.Material.Neon
    Part2.Color = v54
    Part2.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
    Part2.Transparency = 1
    Part2.Parent = v49
    v51.core = Part2
    v54 = v2
    Part2 = Instance.new("Part")
    Part2.Name = "ChargeEnergy"
    local v56 = Enum.PartType.Ball or Enum.PartType.Block
    Part2.Shape = v56
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanTouch = false
    Part2.CanQuery = false
    Part2.CastShadow = false
    Part2.Material = Enum.Material.Neon
    Part2.Color = v54
    Part2.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
    Part2.Transparency = 1
    Part2.Parent = v49
    v51.body = Part2
    v54 = v4
    Part2 = Instance.new("Part")
    Part2.Name = "PulsatingCorona"
    local v57 = Enum.PartType.Ball or Enum.PartType.Block
    Part2.Shape = v57
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanTouch = false
    Part2.CanQuery = false
    Part2.CastShadow = false
    Part2.Material = Enum.Material.Neon
    Part2.Color = v54
    Part2.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
    Part2.Transparency = 1
    Part2.Parent = v49
    v51.shell = Part2
    v54 = v2
    Part2 = Instance.new("Part")
    Part2.Name = "FormingBeam"
    local v58 = Enum.PartType.Cylinder or Enum.PartType.Block
    Part2.Shape = v58
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanTouch = false
    Part2.CanQuery = false
    Part2.CastShadow = false
    Part2.Material = Enum.Material.Neon
    Part2.Color = v54
    Part2.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
    Part2.Transparency = 1
    Part2.Parent = v49
    v51.seed = Part2
    v51.motes = {}
    v54 = v51.core
    local v59
    if v51.successful then
        v59 = 0.15
    else
        v59 = 0.02
    end

    local v60
    if v51.successful then
        v60 = 3
    else
        v60 = 1
    end

    local PointLight1 = Instance.new("PointLight")
    PointLight1.Color = v2
    PointLight1.Brightness = v59
    PointLight1.Range = v60
    PointLight1.Shadows = false
    PointLight1.Parent = v54
    v51.light = PointLight1
    if v51.successful then
        PointLight1 = 24
    else
        PointLight1 = 2
    end

    v54 = 1
    for i1 = 1, PointLight1, v54 do
        v60 = v51.motes
        local Part3 = Instance.new("Part")
        Part3.Name = "AbsorbingEnergy"
        local v63 = Enum.PartType.Ball or Enum.PartType.Block
        Part3.Shape = v63
        Part3.Anchored = true
        Part3.CanCollide = false
        Part3.CanTouch = false
        Part3.CanQuery = false
        Part3.CastShadow = false
        Part3.Material = Enum.Material.Neon
        Part3.Color = i1 % 3 == 0 and v3 or v4
        Part3.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
        Part3.Transparency = 1
        Part3.Parent = v49
        v60[i1] = Part3
    end

    v21[Character] = v51
    v49 = RevolverHeavyCharge:Clone()
    v49:Stop()
    v49.Name = "HeavyCeroCharge"
    v51.soundVolume = v49.Volume
    v49.Volume = 0
    v49.Parent = v51.core
    v51.sound = v49

    local function startSound() --[[ Upvalues: v21 (upvalue), Character (copy), v51 (copy), v49 (copy), v46 (copy) ]]
        local v64 = v21[Character]
        if v64 ~= v51 or not v49.Parent or v51.soundStarted then
            return
        end

        local v65 = math.max(0, os.clock() - v51.started)
        if v46 <= v65 then
            return
        end

        v51.soundStarted = true
        v49.TimePosition = v65 * v49.PlaybackSpeed
        v49:Play()
    end

    if v49.IsLoaded then
        if v21[Character] == v51 then
            if v49.Parent then
                if v51.soundStarted then
                    -- jump to 576 (out of range)
                end

                local v67 = math.max(0, os.clock() - v51.started)
                if v46 <= v67 then
                    -- jump to 576 (out of range)
                end

                v51.soundStarted = true
                v49.TimePosition = v67 * v49.PlaybackSpeed
                v49:Play()
                -- branch continues at 576
            end

            -- branch continues at 576
        end
    else
        v51.soundLoaded = v49.Loaded:Connect(startSound)
    end

    local v68 = math.max(0, v46 - v50)
    task.delay(v68, function() --[[ Upvalues: v49 (copy) ]]
        if v49.Parent then
            v49:Stop()
        end

    end)
end

local function updateCharge(a0, a1)
    local v69 = a1 - a0.started
    local owner = a0.owner
    local HumanoidRootPart = owner:FindFirstChild("HumanoidRootPart")
    local v70 = owner:FindFirstChildOfClass("Humanoid")
    if not a0.model.Parent or not owner.Parent or not HumanoidRootPart or not v70 or v70.Health <= 0 or owner:GetAttribute("HallowsRevolversEquipped") == false or owner:GetAttribute("Stun") or owner:GetAttribute("Ragdoll") or a0.duration + 1 < v69 then
        return false
    end

    local v71 = HumanoidRootPart.CFrame:PointToWorldSpace(a0.offset)
    local LookVector = HumanoidRootPart.CFrame.LookVector
    local v72 = math.abs(LookVector.Y)
    if 0.95 < v72 then
        HumanoidRootPart = Vector3.new(0, 0, 1)
    else
        HumanoidRootPart = Vector3.new(0, 1, 0)
    end

    local Unit1 = LookVector:Cross(HumanoidRootPart).Unit
    local Unit2 = Unit1:Cross(LookVector).Unit
    local v73 = Unit1
    local v74 = v69 / a0.duration
    local v75 = math.clamp(v74, 0, 1)
    if a0.successful then
        v74 = 1
    else
        v74 = 0.09
    end

    local v76 = math.sin(v69 * (v75 * 17 + 23))
    local v77 = (v75 ^ 0.75 * 4.8 + 0.6) * (v76 * (v75 * 0.04 + 0.07) + 1) * v74
    a0.origin = v71
    a0.core.CFrame = CFrame.new(v71)
    a0.body.CFrame = a0.core.CFrame
    a0.shell.CFrame = a0.core.CFrame
    a0.core.Size = Vector3.new(1, 1, 1) * v77 * 0.46
    a0.body.Size = Vector3.new(1, 1, 1) * v77 * 0.81
    a0.shell.Size = Vector3.new(1, 1, 1) * v77
    local v78
    if a0.successful then
        v78 = 0.03
    else
        v78 = 0.25
    end

    a0.core.Transparency = v78
    if a0.successful then
        v78 = 0.28
    else
        v78 = 0.55
    end

    a0.body.Transparency = v78
    local shell = a0.shell
    local v79
    if a0.successful then
        v79 = 0.65
    else
        v79 = 0.84
    end

    shell.Transparency = v79 + math.sin(v69 * 29) * 0.08
    local v80 = (v75 * 2.1 + 0.25) * v74
    v79 = v71 + LookVector * v80 * 0.5
    a0.seed.CFrame = CFrame.fromMatrix(v79, LookVector, Unit2, v73)
    a0.seed.Size = Vector3.new(v80, v77 * 0.54, v77 * 0.54)
    local seed = a0.seed
    if a0.successful then
        v79 = 0.46
    else
        v79 = 0.9
    end

    local v81 = math.sin(v69 * 33)
    local v82
    if a0.successful then
        v82 = 0.1
    else
        v82 = 0.05
    end

    local v83 = v81 * v82
    seed.Transparency = v80 + v83
    v83 = v75 ^ 1.5
    local v84 = v83 * 6.35 + 0.15
    if not (a0.successful and v84) then
        v84 = v75 * 0.22 + 0.02
    end

    a0.light.Brightness = v84
    local v85
    if not (a0.successful and v75 * 25 + 3) then
        v85 = v75 * 2 + 1
    end

    a0.light.Range = v85
    if a0.sound then
        local v86 = math.clamp(v69 / 0.035, 0, 1)
        v85 = (a0.duration - v69) / 0.045
        v80 = math.clamp(v85, 0, 1)
        local v88 = a0.soundVolume * (a0.successful and v75 * 0.7 + 0.3 or 0.14)
        a0.sound.Volume = v88 * v86 * v80
    end

    local motes = a0.motes
    v85 = nil
    v79 = nil
    for k3, k4 in motes do
        local v89 = v69 / (0.72 + k3 % 4 * 0.07)
        v74 = (v89 + k3 / #a0.motes) % 1
        if not (a0.successful and v74) then
            v89 = (v69 - (k3 - 1) * 0.12) / 0.35
            v74 = math.clamp(v89, 0, 1)
        end

        local v91 = (a0.successful and 5 + k3 % 5 * 0.65 or 1.25) * (1 - v74) ^ 1.3
        local v92 = k3 * 2.39996 + v74 * 1.4
        local v93 = math.sin(k3 * 1.79) * v91 * 0.65
        local v94 = Unit2 * math.cos(v92)
        local v95 = (v94 + v73 * math.sin(v92)) * v91
        k4.CFrame = CFrame.new(v71 + v95 + LookVector * v93)
        local v96 = Vector3.new(1, 1, 1) * (math.sin(v74 * 3.1415926535897931) * 0.15 + 0.07)
        local v97 = v96 * (v75 * 0.5 + 0.7)
        if a0.successful then
            v96 = 1
        else
            v96 = 0.32
        end

        k4.Size = v97 * v96
        if a0.successful then
            v95 = 0.1
        else
            v95 = 0.5
        end

        v96 = 1 - math.sin(v74 * 3.1415926535897931)
        k4.Transparency = v95 + v96 * (1 - v95)
    end

    return true
end

local function createEffect(a0) --[[ Upvalues: v21 (copy), createCharge (copy), finiteVector (copy), v20 (ref), v23 (ref), v24 (ref), playSound (copy), v1 (copy), Debris (copy), v3 (copy), v2 (copy), v4 (copy), UIGradient (copy) ]]
    if typeof(a0) ~= "table" then
        return
    end

    if a0.Kind == "HeavyCancel" then
        local Character1 = a0.Character
        local Serial = a0.Serial
        local v98 = v21[Character1]
        if v98 then
            if Serial == nil or v98.serial == Serial then
                if v98.soundLoaded then
                    v98.soundLoaded:Disconnect()
                end

                if v98.sound then
                    v98.sound:Stop()
                end

                v98.model:Destroy()
                v21[Character1] = nil
            end
        end

        return
    end

    if a0.Kind == "HeavyCharge" then
        createCharge(a0)
        return
    end

    local v99 = true
    if a0.Kind ~= "HeavyFire" then
        v99 = a0.Kind == "HeavyFail"
    end

    if v99 then
        local Character2 = a0.Character
        local Serial1 = a0.Serial
        local v100 = v21[Character2]
        if v100 then
            if Serial1 == nil or v100.serial == Serial1 then
                if v100.soundLoaded then
                    v100.soundLoaded:Disconnect()
                end

                if v100.sound then
                    v100.sound:Stop()
                end

                v100.model:Destroy()
                v21[Character2] = nil
            end
        end
    end

    if not finiteVector(a0.Origin) then
        return
    end

    local v101 = true
    if a0.Kind ~= "Fail" then
        v101 = a0.Kind == "HeavyFail"
    end

    if not v101 and a0.Kind ~= "Fire" and a0.Kind ~= "HeavyFire" then
        return
    end

    local v102 = os.clock()
    if a0.Character == v20 then
        if v101 then
            v23 = v102 + 0.8
        else
            v24 = v102
        end
    end

    local CurrentCamera1 = workspace.CurrentCamera
    if CurrentCamera1 and 450 < (CurrentCamera1.CFrame.Position - a0.Origin).Magnitude then
        return
    end

    CurrentCamera1 = a0.Direction
    if not finiteVector(CurrentCamera1) or CurrentCamera1.Magnitude < 0.01 then
        local v103 = a0.Character and a0.Character:FindFirstChild("HumanoidRootPart")
        local v105 = v103 and v103.CFrame.LookVector or Vector3.new(0, 0, -1)
        CurrentCamera1 = v105
    end

    CurrentCamera1 = CurrentCamera1.Unit
    local v106
    if not (typeof(a0.SoundId) == "string" and a0.SoundId) then
        if v101 then
            v106 = "rbxassetid://72489278445121"
        else
            v106 = "rbxassetid://114311638830453"
        end
    end

    playSound(a0.Origin, v106, v101, v99, a0.PlaybackSpeed)
    local v107
    if not (v99 and v1.HeavyBeamSize) then
        v107 = v1.BeamSize
    end

    local v109 = tonumber(a0.Length) or v107.Z
    local v110 = math.clamp(v109, 0, v107.Z)
    if not v101 and v110 < 0.05 then
        return
    end

    local Model = Instance.new("Model")
    local v111
    if v101 then
        v111 = "CeroFizzle"
    else
        if v99 then
            v111 = "HallowsHeavyCero"
        else
            v111 = "HallowsCero"
        end
    end

    Model.Name = v111
    Model:SetAttribute("HallowsLocalEffect", true)
    Model.Parent = workspace
    local v112
    if v99 then
        v112 = 0.12
    else
        v112 = 0.16
    end

    if v99 then
        local v113 = math.max(0, v1.HeavyBeamHoldTime or 2)
        if v113 then
            -- jump to 304
        end
    end

    local v114 = 0.12
    if v99 then
        local v115 = math.max(0.01, v1.HeavyBeamFadeTime or 1)
        if v115 then
            -- jump to 317
        end
    end

    local v116 = 0.45
    Debris:AddItem(Model, v112 + v114 + v116 + 0.5)
    local v117 = {
        model = Model,
        origin = a0.Origin,
        direction = CurrentCamera1,
        started = v102,
        failed = v101,
        heavy = v99,
        growTime = v112,
        holdTime = v114,
        fadeTime = v116,
        length = v110
    }
    local v119 = tonumber(a0.Width) or v107.X
    v117.width = math.clamp(v119, 0.1, v107.X)
    local v120 = math.abs(CurrentCamera1.Y)
    if 0.95 < v120 then
        v116 = Vector3.new(0, 0, 1)
    else
        v116 = Vector3.new(0, 1, 0)
    end

    local Unit3 = CurrentCamera1:Cross(v116).Unit
    v117.y = Unit3:Cross(CurrentCamera1).Unit
    v117.z = Unit3
    local v121 = v3
    local Part4 = Instance.new("Part")
    Part4.Name = "MuzzleGlow"
    local v122 = Enum.PartType.Ball or Enum.PartType.Block
    Part4.Shape = v122
    Part4.Anchored = true
    Part4.CanCollide = false
    Part4.CanTouch = false
    Part4.CanQuery = false
    Part4.CastShadow = false
    Part4.Material = Enum.Material.Neon
    Part4.Color = v121
    Part4.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
    Part4.Transparency = 1
    Part4.Parent = Model
    v117.muzzle = Part4
    v121 = v117.muzzle
    local v123
    if v101 then
        if v99 then
            v123 = 2
            -- jump to 459 (out of range)
        end

        v123 = 4
    else
        v123 = 14
    end

    Part4 = Instance.new("PointLight")
    Part4.Color = v2
    Part4.Brightness = 0
    Part4.Range = v123
    Part4.Shadows = false
    Part4.Parent = v121
    v117.muzzleLight = Part4
    if not v101 then
        v121 = v4
        Part4 = Instance.new("Part")
        Part4.Name = "BlueCorona"
        local v124 = Enum.PartType.Cylinder or Enum.PartType.Block
        Part4.Shape = v124
        Part4.Anchored = true
        Part4.CanCollide = false
        Part4.CanTouch = false
        Part4.CanQuery = false
        Part4.CastShadow = false
        Part4.Material = Enum.Material.Neon
        Part4.Color = v121
        Part4.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
        Part4.Transparency = 1
        Part4.Parent = Model
        v117.shell = Part4
        v121 = v2
        Part4 = Instance.new("Part")
        Part4.Name = "CyanEnergy"
        local v125 = Enum.PartType.Cylinder or Enum.PartType.Block
        Part4.Shape = v125
        Part4.Anchored = true
        Part4.CanCollide = false
        Part4.CanTouch = false
        Part4.CanQuery = false
        Part4.CastShadow = false
        Part4.Material = Enum.Material.Neon
        Part4.Color = v121
        Part4.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
        Part4.Transparency = 1
        Part4.Parent = Model
        v117.body = Part4
        v121 = v3
        Part4 = Instance.new("Part")
        Part4.Name = "WhiteHotCore"
        local v126 = Enum.PartType.Cylinder or Enum.PartType.Block
        Part4.Shape = v126
        Part4.Anchored = true
        Part4.CanCollide = false
        Part4.CanTouch = false
        Part4.CanQuery = false
        Part4.CastShadow = false
        Part4.Material = Enum.Material.Neon
        Part4.Color = v121
        Part4.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
        Part4.Transparency = 1
        Part4.Parent = Model
        v117.core = Part4
        v121 = v2
        Part4 = Instance.new("Part")
        Part4.Name = "LeadingGlow"
        local v127 = Enum.PartType.Ball or Enum.PartType.Block
        Part4.Shape = v127
        Part4.Anchored = true
        Part4.CanCollide = false
        Part4.CanTouch = false
        Part4.CanQuery = false
        Part4.CastShadow = false
        Part4.Material = Enum.Material.Neon
        Part4.Color = v121
        Part4.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
        Part4.Transparency = 1
        Part4.Parent = Model
        v117.tip = Part4
        Part4 = Instance.new("PointLight")
        Part4.Color = v2
        Part4.Brightness = 0
        Part4.Range = 28
        Part4.Shadows = false
        Part4.Parent = v117.body
        v117.beamLight = Part4
        v117.filaments = {}
        local v128
        if v99 then
            v128 = 5
        else
            v128 = 3
        end

        for i2 = 1, v128 do
            local filaments = v117.filaments
            local v130 = v3
            local Part5 = Instance.new("Part")
            Part5.Name = "EnergyFilament"
            local v131 = Enum.PartType.Cylinder or Enum.PartType.Block
            Part5.Shape = v131
            Part5.Anchored = true
            Part5.CanCollide = false
            Part5.CanTouch = false
            Part5.CanQuery = false
            Part5.CastShadow = false
            Part5.Material = Enum.Material.Neon
            Part5.Color = v130
            Part5.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
            Part5.Transparency = 1
            Part5.Parent = Model
            filaments[i2] = Part5
        end

        if v99 then
            v117.ring = {}
            v128 = 20
            for i3 = 1, v128 do
                local ring = v117.ring
                local v133 = v2
                local Part6 = Instance.new("Part")
                Part6.Name = "ReleaseShockRing"
                local v134 = Enum.PartType.Cylinder or Enum.PartType.Block
                Part6.Shape = v134
                Part6.Anchored = true
                Part6.CanCollide = false
                Part6.CanTouch = false
                Part6.CanQuery = false
                Part6.CastShadow = false
                Part6.Material = Enum.Material.Neon
                Part6.Color = v133
                Part6.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
                Part6.Transparency = 1
                Part6.Parent = Model
                ring[i3] = Part6
            end
        end
    end

    table.insert(UIGradient, v117)
end

local function updateEffect(a0, a1)
    local v135 = a1 - a0.started
    if not a0.model.Parent then
        return false
    end

    if a0.failed then
        local v136 = math.clamp(v135 / 0.24, 0, 1)
        local v137
        if a0.heavy then
            v137 = 0.35
        else
            v137 = 0.48
        end

        local v138 = 0.05 + v137 * math.sin(v136 * 3.1415926535897931)
        a0.muzzle.Size = Vector3.new(1, 1, 1) * v138
        a0.muzzle.CFrame = CFrame.new(a0.origin + a0.direction * v138 * 0.5)
        a0.muzzle.Transparency = v136 * 0.7 + 0.3
        local v139
        if a0.heavy then
            v139 = 0.18
        else
            v139 = 0.8
        end

        a0.muzzleLight.Brightness = (1 - v136) * v139
        return v135 < 0.24
    end

    local v140 = a0.growTime + a0.holdTime
    if v140 + a0.fadeTime <= v135 then
        return false
    end

    v140 = v135 / a0.growTime
    v140 = 1 - (1 - math.clamp(v140, 0, 1)) ^ 3
    local v141 = v135 - a0.growTime
    local v142 = v141 - a0.holdTime
    local v143 = v142 / a0.fadeTime
    local v144 = math.clamp(v143, 0, 1)
    local v145 = (1 - v144) ^ 1.65
    local v146 = math.max(0.015, a0.width * (v140 * 0.985 + 0.015) * v145)
    local v147 = math.max(0.05, a0.length * v140)
    local v148 = (v144 - 0.88) / 0.12
    local v149 = math.clamp(v148, 0, 1)
    local v150 = a0.origin + a0.direction * v147 * 0.5
    v144 = CFrame.fromMatrix(v150, a0.direction, a0.y, a0.z)
    a0.shell.CFrame = v144
    a0.body.CFrame = v144
    a0.core.CFrame = v144
    a0.shell.Size = Vector3.new(v147, v146, v146)
    a0.body.Size = Vector3.new(v147, v146 * 0.79, v146 * 0.79)
    local v151
    if a0.heavy then
        v151 = 0.46
    else
        v151 = 0.37
    end

    a0.core.Size = Vector3.new(v147, v146 * v151, v146 * v151)
    if a0.heavy then
        v151 = 0.56
    else
        v151 = 0.68
    end

    local v152
    if a0.heavy then
        v152 = 0.2
    else
        v152 = 0.27
    end

    a0.shell.Transparency = v151 + v149 * (1 - v151)
    a0.body.Transparency = v152 + v149 * (1 - v152)
    a0.core.Transparency = v149 * 0.965 + 0.035
    local v153 = math.min(v146 * 0.8, v147)
    a0.tip.Size = Vector3.new(1, 1, 1) * math.max(0.015, v153)
    a0.tip.CFrame = CFrame.new(a0.origin + a0.direction * (v147 - v153 * 0.5))
    a0.tip.Transparency = v149 * 0.74 + 0.26
    local v154
    if a0.heavy then
        v154 = 8
    else
        v154 = 2.2
    end

    local v155 = math.min(v146 * 0.32, v147, v154)
    a0.muzzle.Size = Vector3.new(1, 1, 1) * math.max(0.015, v155)
    a0.muzzle.CFrame = CFrame.new(a0.origin + a0.direction * v155 * 0.5)
    a0.muzzle.Transparency = v149 * 0.9 + 0.1
    v155 = v140 * v145 * (1 - v149)
    if a0.heavy then
        v154 = 8
    else
        v154 = 5.5
    end

    a0.beamLight.Brightness = v149 * 0.9 * v155
    local beamLight = a0.beamLight
    local v156
    if a0.heavy then
        v156 = 43
    else
        v156 = 21
    end

    beamLight.Range = 7 + v156 * math.sqrt(v155)
    local heavy = a0.heavy
    if heavy then
        v154 = 7
    else
        v154 = 3.5
    end

    a0.muzzleLight.Brightness = 7 * v155
    if a0.heavy then
        v156 = v155
        local v157 = math.sqrt(v156)
        a0.muzzleLight.Range = v157 * 25 + 5
    end

    local filaments1 = a0.filaments
    local v158 = nil
    v154 = nil
    for k5, k6 in filaments1 do
        local v159
        if a0.heavy then
            v159 = 14
        else
            v159 = 9
        end

        local v160 = v135 * v159
        local v161 = k5 * 3.1415926535897931 * 2
        v155 = v160 + v161 / #a0.filaments
        v161 = a0.y * math.cos(v155)
        v151 = (v161 + a0.z * math.sin(v155)) * v146 * 0.28
        v159 = v144.Position + v151
        k6.CFrame = CFrame.fromMatrix(v159, a0.direction, a0.y, a0.z)
        local v162 = math.max(0.015, v146 * 0.025)
        k6.Size = Vector3.new(v147, v162, math.max(0.015, v146 * 0.025))
        k6.Transparency = v149 * 0.8 + 0.2
    end

    if a0.ring then
        v149 = math.clamp(v135 / 0.36, 0, 1)
        v146 = a0.width * ((1 - (1 - v149) ^ 2) * 0.58 + 0.13)
        v145 = a0.origin + a0.direction * math.min(v147 * 0.5, 0.6)
        k6 = 1 - v149
        local v163 = k6 * 0.22
        v140 = math.min(v147, v163 + 0.015)
        local ring1 = a0.ring
        local v164 = nil
        v154 = nil
        for k7, k8 in ring1 do
            local v165 = (k7 - 1) * 3.1415926535897931 * 2
            v144 = v165 / #a0.ring
            local v166 = k7 * 3.1415926535897931 * 2
            v165 = v166 / #a0.ring
            local v167 = a0.y * math.cos(v144)
            v166 = v145 + (v167 + a0.z * math.sin(v144)) * v146
            v167 = a0.y * math.cos(v165)
            v144 = v145 + (v167 + a0.z * math.sin(v165)) * v146
            local Unit4 = (v144 - v166).Unit
            local v168 = (v166 + v144) * 0.5
            local v169 = Unit4:Cross(a0.direction)
            k8.CFrame = CFrame.fromMatrix(v168, Unit4, a0.direction, v169)
            k8.Size = Vector3.new((v144 - v166).Magnitude, v140, v140)
            k8.Transparency = v149 * 0.88 + 0.12
        end
    end

    return true
end

local v170 = Players.OnClientEvent:Connect(createEffect)
table.insert(v25, v170)
local v172 = HallowsRevolvers.CharacterAdded:Connect(function(a0) --[[ Upvalues: v20 (ref), v17 (ref), v18 (ref), v23 (ref), v22 (ref), v24 (ref) ]]
    v20 = a0
    local v171 = v20:GetAttribute("HallowsEnergy")
    v17 = tonumber(v171) or 100
    v18 = v17
    v23 = 0
    v22 = 0
    v24 = -100
end)
table.insert(v25, v172)
local v174 = HallowsRevolvers.CharacterRemoving:Connect(function(a0) --[[ Upvalues: v21 (copy), v20 (ref), ScreenGui (copy) ]]
    local v173 = v21[a0]
    if v173 then
        if v173.soundLoaded then
            v173.soundLoaded:Disconnect()
        end

        if v173.sound then
            v173.sound:Stop()
        end

        v173.model:Destroy()
        v21[a0] = nil
    end

    if v20 == a0 then
        v20 = nil
        ScreenGui.Enabled = false
    end

end)
table.insert(v25, v174)
local v203 = RunService.RenderStepped:Connect(function(a0) --[[ Upvalues: v21 (copy), updateCharge (copy), UIGradient (copy), updateEffect (copy), ScreenGui (copy), v20 (ref), v1 (copy), v18 (ref), v22 (ref), v17 (ref), label (copy), v10 (copy), Frame (copy), v23 (ref), TextLabel2 (copy), UIStroke (copy), v2 (copy), v3 (copy), PlayerGui (copy), v24 (ref), UIScale (copy) ]]
    local v175 = os.clock()
    local v176 = v21
    local v177 = nil
    local v178 = nil
    for k9, k10 in v176 do
        if not updateCharge(k10, v175) then
            local serial = k10.serial
            local v179 = v21[k9]
            if v179 then
                if serial == nil or v179.serial == serial then
                    if v179.soundLoaded then
                        v179.soundLoaded:Disconnect()
                    end

                    if v179.sound then
                        v179.sound:Stop()
                    end

                    v179.model:Destroy()
                    v21[k9] = nil
                end
            end
        end
    end

    v176 = 1
    v177 = -1
    for i4 = #UIGradient, v176, v177 do
        local v180 = UIGradient[i4]
        if not updateEffect(v180, v175) then
            v180.model:Destroy()
            table.remove(UIGradient, i4)
        end
    end

    v176 = ScreenGui
    v177 = false
    if v20 ~= nil then
        v177 = v20:GetAttribute("HallowsRevolversEquipped") == true
    end

    v176.Enabled = v177
    if not ScreenGui.Enabled then
        return
    end

    local v181 = v20:GetAttribute("HallowsMaxEnergy")
    local v182 = math.max(1, tonumber(v181) or 100)
    local v183 = v20:GetAttribute("HallowsEnergy")
    local v184 = tonumber(v183) or v182
    local v185 = math.clamp(v184, 0, v182)
    local v186 = v20:GetAttribute("HallowsEnergyCost")
    v184 = tonumber(v186) or 25
    local v187 = v20:GetAttribute("HallowsHeavyEnergyCost")
    local v190 = tonumber(v187) or v1.HeavyEnergyCost or 60
    if v18 + 0.001 < v185 then
        v22 = v175 + 0.35
    end

    v18 = v185
    local v191 = v185 - v17
    v17 = v17 + v191 * (1 - math.exp(-a0 * 13))
    local v192 = v17 / v182
    local v193 = math.clamp(v192, 0, 1)
    label.Size = UDim2.fromScale(v193, 1)
    local v194 = math.floor(v185 + 0.5)
    v10.Text = string.format("%d / %d", v194, v182)
    Frame:SetAttribute("DisplayedEnergy", v185)
    local v195 = v20:GetAttribute("HallowsNextShotAt")
    local v196 = tonumber(v195) or 0
    v182 = math.max(0, v196 - workspace:GetServerTimeNow())
    if v175 < v23 then
        TextLabel2.Text = "NOT ENOUGH ENERGY"
        TextLabel2.TextColor3 = Color3.fromRGB(255, 175, 185)
        local v197 = Color3.fromRGB(255, 175, 185)
        UIStroke.Color = v2:Lerp(v197, math.sin(v175 * 24) * 0.2 + 0.55)
    else
        if v20:GetAttribute("HallowsHeavyCharging") then
            TextLabel2.Text = "CHARGING HEAVY CERO"
            TextLabel2.TextColor3 = v3
            UIStroke.Color = v2:Lerp(v3, math.sin(v175 * 18) * 0.2 + 0.35)
        else
            if 0.05 < v182 then
                TextLabel2.Text = string.format("READY IN %.1fs", v182)
                TextLabel2.TextColor3 = v2
                UIStroke.Color = v2
            else
                if v175 < v22 then
                    TextLabel2.Text = "RECHARGING"
                    TextLabel2.TextColor3 = v3
                    UIStroke.Color = v2
                else
                    local v198 = TextLabel2
                    local v199
                    if v185 < v184 then
                        v199 = "LOW ENERGY  /  RECHARGING SOON"
                    else
                        local v200
                        if v185 < v190 then
                            v200 = "  \226\128\162  LOW"
                        else
                            v200 = ""
                        end

                        local v201 = string.format("M1 %d  /  M2 HEAVY %d ENERGY%s", v184, v190, v200)
                    end

                    v198.Text = v199
                    TextLabel2.TextColor3 = v2
                    UIStroke.Color = v2
                end
            end
        end
    end

    PlayerGui.BackgroundTransparency = 1 - math.max(0, 1 - (v175 - v24) / 0.16) ^ 2 * 0.045
    local CurrentCamera2 = workspace.CurrentCamera
    if CurrentCamera2 then
        local v202 = (CurrentCamera2.ViewportSize.X - 32) / 326
        UIScale.Scale = math.clamp(v202, 0.65, 1)
    end

end)
table.insert(v25, v203)
script.Destroying:Connect(function() --[[ Upvalues: v25 (copy), UIGradient (copy), v21 (copy), ScreenGui (copy) ]]
    local v204 = v25
    local v205 = nil
    local v206 = nil
    for k11, k12 in v204 do
        k12:Disconnect()
    end

    v204 = UIGradient
    v205 = nil
    v206 = nil
    for k13, k14 in v204 do
        k14.model:Destroy()
    end

    v204 = v21
    v205 = nil
    v206 = nil
    for k15 in v204 do
        local v207 = v21[k15]
        if v207 then
            if v207.soundLoaded then
                v207.soundLoaded:Disconnect()
            end

            if v207.sound then
                v207.sound:Stop()
            end

            v207.model:Destroy()
            v21[k15] = nil
        end
    end

    ScreenGui:Destroy()
end)
