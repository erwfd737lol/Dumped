
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
Players = ReplicatedStorage.Objects
local Animations = ReplicatedStorage.Animations
local v1 = require(ReplicatedStorage.Modules.Lightning)
local v2 = require(ReplicatedStorage.Modules.ToolsLib)
local LocalPlayer = game.Players.LocalPlayer

local function createBullet()
    local Part = Instance.new("Part")
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon
    Part.Color = Color3.fromRGB(255, 153, 85)
    Part.Transparency = 0.4
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Anchored = true
    Part.Size = Vector3.new(0.125, 0.125, 0.125)
    return Part
end

local t1 = {}
local v3 = script:GetChildren()
for k1, k2 in pairs(v3) do
    t1[k2.Name] = require(k2)
end

local v7 = {}
local v8 = {}

local function lookCFrame(a0, a1)
    if a1.Magnitude <= 0 then
        local v9 = CFrame.new(a0)
        return v9
    end

    a1 = a1.Unit
    local v10 = math.abs(a1.Y)
    local v11
    if 0.99 < v10 then
        v11 = Vector3.new(0, 0, 1)
    else
        v11 = Vector3.new(0, 1, 0)
    end

    local v12 = CFrame.lookAt(a0, a0 + a1, v11)
    return v12
end

local function destroyGrenade(a0) --[[ Upvalues: v7 (copy), v8 (copy) ]]
    if not (a0 and a0.alive) then
        return
    end

    a0.alive = false
    if a0.conn then
        a0.conn:Disconnect()
        a0.conn = nil
    end

    if a0.model then
        a0.model:Destroy()
        a0.model = nil
    end

    if a0.id then
        v7[a0.id] = nil
    end

    for i1 = #v8, 1, -1 do
        if v8[i1] == a0 then
            table.remove(v8, i1)
            return
        end
    end
end

local function newGrenadeVisual(a0, a1, a2) --[[ Upvalues: Players (copy), lookCFrame (copy), RunService (copy), destroyGrenade (copy) ]]
    local v15 = Players.Tools.Grenade:Clone()
    local v16 = v15:GetDescendants()
    for k3, k4 in ipairs(v16) do
        if k4:IsA("BasePart") then
            k4.Anchored = true
            k4.CanCollide = false
            k4.CanQuery = false
            k4.CanTouch = false
        end
    end

    local v20 = lookCFrame(a0, a1)
    v15:PivotTo(v20)
    v15.Parent = workspace.CurrentCamera
    local CurrentCamera = workspace.CurrentCamera
    CurrentCamera = {
        alive = true,
        model = v15,
        pos = a0,
        vel = a1,
        deadline = os.clock() + a2,
        conn = RunService.Heartbeat:Connect(function(a0) --[[ Upvalues: CurrentCamera (copy), destroyGrenade (upvalue), lookCFrame (upvalue) ]]
        if not CurrentCamera.alive then
            return
        end

        if not (CurrentCamera.model and CurrentCamera.model.Parent) then
            destroyGrenade(CurrentCamera)
            return
        end

        local v21 = CurrentCamera
        local v22 = -workspace.Gravity * a0
        v21.vel = v21.vel + Vector3.new(0, v22, 0)
        v21 = CurrentCamera
        v21.pos = v21.pos + CurrentCamera.vel * a0
        local v23 = lookCFrame(CurrentCamera.pos, CurrentCamera.vel)
        CurrentCamera.model:PivotTo(v23)
        if CurrentCamera.deadline < os.clock() then
            destroyGrenade(CurrentCamera)
        end

    end)
    }
    return CurrentCamera
end

t1.GrenadeProjectile = function(a0) --[[ Upvalues: LocalPlayer (copy), v7 (copy), newGrenadeVisual (copy) ]]
    if not a0.Id then
        return
    end

    if a0.Shooter and LocalPlayer and a0.Shooter == LocalPlayer.UserId then
        return
    end

    if v7[a0.Id] then
        return
    end

    local v24 = newGrenadeVisual(a0.Pos, a0.Vel, (a0.Fuse or 3) + 0.5)
    v24.id = a0.Id
    v7[a0.Id] = v24
end

t1.GrenadeConfirm = function(a0) --[[ Upvalues: v8 (copy), newGrenadeVisual (copy), v7 (copy) ]]
    if not a0.Id then
        return
    end

    local v25 = nil
    while true do
        local v26 = #v8
        if 0 >= v26 then
            break
        end

        local v27 = table.remove(v8, 1)
        if v27.alive then
            v25 = v27
            break
        end
    end

    if v25 then
        v25.deadline = os.clock() + (a0.Fuse or 3) + 0.5
    else
        v25 = newGrenadeVisual(a0.Pos, a0.Vel, (a0.Fuse or 3) + 0.5)
    end

    v25.id = a0.Id
    v7[a0.Id] = v25
end

t1.GrenadeClear = function(a0) --[[ Upvalues: destroyGrenade (copy), v7 (copy) ]]
    if a0.Id then
        destroyGrenade(v7[a0.Id])
    end
end

local v28 = 0
t1.PredictGrenade = function(a0) --[[ Upvalues: LocalPlayer (copy), v2 (copy), v28 (ref), newGrenadeVisual (copy), v8 (copy) ]]
    if not LocalPlayer then
        return
    end

    local Character = LocalPlayer.Character
    if not Character then
        return
    end

    if Character:GetAttribute("Stun") or Character:GetAttribute("Ragdoll") or Character:GetAttribute("Reloading") or Character:GetAttribute("Blocking") or Character:GetAttribute("Shooting") or Character:GetAttribute("Attacking") then
        return
    end

    local v29 = nil
    local v30 = nil
    local v31 = Character:GetChildren()
    for k5, k6 in ipairs(v31) do
        if k6:GetAttribute("ToolName") == "Grenade Launcher" then
            local v35 = k6:FindFirstChild("Grenade Launcher")
            local v37 = v35 and v35:FindFirstChild("Gun")
            local v38 = v37 and v37:FindFirstChild("ShootPoint")
            if v38 then
                v29 = v38
                v30 = k6
                break
            end
        end
    end

    if not v29 then
        return
    end

    local v39 = v30:GetAttribute("Bullets")
    if v39 and v39 <= 0 then
        return
    end

    v39 = v2["Grenade Launcher"]
    local v40 = os.clock() - v28
    if v40 < (v39.CD or 0.75) then
        return
    end

    v40 = nil
    if typeof(a0) == "CFrame" then
        v40 = a0.Position
    else
        if typeof(a0) == "Vector3" then
            v40 = a0
        else
            if type(a0) == "table" and a0.Position then
                v40 = a0.Position
            end
        end
    end

    if not v40 then
        return
    end

    v28 = os.clock()
    v30 = v29.WorldPosition
    v29 = Character:FindFirstChild("HumanoidRootPart")
    Character = v40 - v30
    if Character.Magnitude <= 0 then
        local v42 = v29 and v29.CFrame.LookVector or Vector3.new(0, 0, -1)
        Character = v42
    end

    Character = Character.Unit
    local v44 = v29 and v29.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    local v45 = Character * v39.ProjectileSpeed
    v29 = v45 + Vector3.new(0, v39.ProjectileArc, 0) + v44
    local v46 = v30 + Character * 2
    local v47 = newGrenadeVisual(v46, v29, 1.5)
    table.insert(v8, v47)
end

t1.GrenadeRoundsSpin = function(a0) --[[ Upvalues: TweenService (copy) ]]
    local Rounds = a0.Rounds
    if not (Rounds and Rounds.Parent) then
        return
    end

    local RoundsSpin = Rounds:FindFirstChild("RoundsSpin")
    local v50 = RoundsSpin and RoundsSpin:IsA("RigidConstraint") and RoundsSpin.Attachment0
    if not v50 then
        return
    end

    local v51 = a0.CD or 0.75
    local v52 = TweenInfo.new(v51, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    v51 = {CFrame = v50.CFrame * CFrame.Angles(0, 0, 1.1344640137963142)}
    TweenService:Create(v50, v52, v51):Play()
    local v53 = {Sound = "GrenadeCycle", Origin = Rounds}
    _G.Utl.PlaySound(v53)
end

t1.GrenadeMuzzle = function(a0) --[[ Upvalues: Players (copy) ]]
    local v54 = Players.Muzzle2:Clone()
    v54.Anchored = true
    v54.CanCollide = false
    v54.CanQuery = false
    v54.Transparency = 1
    v54.CFrame = a0.CF
    v54.Parent = workspace.CurrentCamera
    local v55 = v54.Main:GetChildren()
    for k7, k8 in ipairs(v55) do
        if k8:IsA("ParticleEmitter") then
            k8:Emit(12)
        end
    end

    game.Debris:AddItem(v54, 2)
end

t1.DamagePart = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Origin = a0.Origin
    local v59 = a0.Damage or 0
    local Armor = a0.Armor
    local Immune = a0.Immune
    local Burn = a0.Burn
    local v60 = Players.DamagePart:Clone()
    v60.Gui.Label.Text = math.floor(v59)
    if a0.Headshot then
        v60.Gui.Label.TextColor3 = Color3.fromRGB(255, 158, 74)
    else
        if Armor then
            v60.Gui.Label.TextColor3 = Color3.fromRGB(115, 121, 131)
        else
            if Immune then
                v60.Gui.Label.TextColor3 = Color3.fromRGB(134, 202, 221)
                v60.Gui.Label.Text = "Immune!"
            else
                if Burn then
                    v60.Gui.Label.TextColor3 = Color3.fromRGB(255, 76, 16)
                end
            end
        end
    end

    local v61 = -2 + math.random() * 4
    local v62 = 0.5 + math.random() * 0.5
    v60.CFrame = Origin.CFrame * CFrame.new(v61, v62, 0)
    v60.Parent = workspace.CurrentCamera
    game.Debris:AddItem(v60, 1)
    local v63 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v64 = 1.5 + math.random() * 0.5
    local v65 = {CFrame = v60.CFrame * CFrame.new(0, v64, 0)}
    TweenService:Create(v60, v63, v65):Play()
    task.wait(0.5)
    local v66 = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    TweenService:Create(v60.Gui.Label, v66, {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
end

t1.Blood = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Origin1 = a0.Origin
    local v67 = a0.Parts or 4
    local v68 = -workspace.Gravity
    local v69 = Vector3.new(0, v68, 0)
    if a0.Particle or false then
        local v70 = Players.Blood.BloodExplode:Clone()
        v70.CFrame = Origin1
        v70.Parent = workspace.CurrentCamera
        v70.Attachment.BloodDrips:Emit(75)
        v70.Attachment.BloodMist:Emit(25)
        v70.Attachment.CoreBlood:Emit(25)
        v70.Attachment.BloodSpecs:Emit(75)
        game.Debris:AddItem(v70, 2)
    end

    for i2 = 1, v67 do
        local v73 = 0.3 + math.random() * 0.4
        local v74 = -0.25 - math.random() * 0.35
        local v75 = 0.3 + math.random() * 0.4
        if math.random(1, 2) == 2 then
            v73 = -v73
        end

        if math.random(1, 3) == 2 then
            v74 = -v74
        end

        if math.random(1, 2) == 2 then
            v75 = -v75
        end

        v75 = Origin1 * CFrame.new(v73, v74, v75)
        local v76 = {workspace.Live, workspace.Mobs}
        local v77 = {
            Origin = Origin1.Position,
            Dir = CFrame.new(Origin1.Position, v75.Position).LookVector * 10,
            Blacklist = v76
        }
        local v78 = _G.Utl.Raycast(v77)
        if v78 then
            v73 = (Origin1.Position - v78.Position).Magnitude / math.random(40, 60)
            local v79 = v78.Position - Origin1.Position
            local v80 = (v79 - v69 * 0.5 * v73 * v73) / v73
            local v81 = 0.1 + math.random() * 0.4
            local v82 = Players.Blood.Blood:Clone()
            game.Debris:AddItem(v82, 3)
            v82[1].Position = Vector3.new(0, v81 / 2, 0)
            local v83 = -v81 / 2
            v82[2].Position = Vector3.new(0, v83, 0)
            v82.Anchored = false
            local v84 = CFrame.new(Origin1.Position, v75.Position)
            v82.CFrame = v84 * CFrame.new(0, 0, -0.5 - math.random() * 0.5)
            v82.Parent = workspace
            v82.AssemblyLinearVelocity = v80
            task.delay(v73, function() --[[ Upvalues: v82 (copy), Players (upvalue), v81 (copy), v78 (copy), TweenService (upvalue) ]]
                v82.Anchored = true
                v82.Transparency = 1
                local v85 = Players.Blood["splatter" .. math.random(1, 2)]:Clone()
                local v86 = v81 * (3.5 + math.random() * 0.5)
                local v87 = v81 * (3.5 + math.random() * 0.5)
                v85.Size = Vector3.new(v86, v87, 0.001)
                game.Debris:AddItem(v85, 4)
                local v88 = CFrame.new(v78.Position, v78.Position + v78.Normal)
                local v89 = math.random()
                v85.CFrame = v88 * CFrame.Angles(0, 0, v89)
                v85.Parent = workspace
                local v90 = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
                local v91 = {Size = v85.Size * Vector3.new(1.5, 1.5, 0)}
                TweenService:Create(v85, v90, v91):Play()
                local v92 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 3)
                TweenService:Create(v85.decal, v92, {Transparency = 1}):Play()
            end)
        end
    end
end

t1.BlockBreak = function(a0) --[[ Upvalues: Players (copy) ]]
    local Head = a0.Char:FindFirstChild("Head")
    local v93 = Players.StunStars:Clone()
    v93.Parent = Head
    v93:Emit(10)
    game.Debris:AddItem(v93, 1.6)
    local v94 = {Sound = "Dizzy", Pos = 2.5, Origin = Head}
    _G.Utl.PlaySound(v94)
end

local v95 = {"Sharp", "SharpBlunt", "Gun"}
t1.BlockEffect = function(a0, a1) --[[ Upvalues: Players (copy), v95 (copy), TweenService (copy) ]]
    local Origin2 = a0.Origin
    local MyWep = a0.MyWep
    local Tool = a0.Tool
    if a0.Type == "Blunt" then
        local v96 = Players.HitEffect.BluntBlock:Clone()
        v96.Parent = Origin2
        v96:Emit(1)
        game.Debris:AddItem(v96, 0.5)
        local v97 = {
            Sound = "BluntBlock",
            Origin = Origin2,
            PlaybackSpeed = 0.9 + math.random() * 0.2
        }
        _G.Utl.PlaySound(v97)
        return
    end

    if a0.Type == "Sharp" then
        if MyWep then
            if MyWep then
                if _G.Utl.tabFind(v95, MyWep.Type) then
                    -- jump to 126
                end

                -- branch continues at 126
            end
        end

        local v98 = Players.HitEffect.Sharp:Clone()
        v98.Parent = Origin2
        v98:Emit(1)
        game.Debris:AddItem(v98, 0.5)
        local v99 = {
            Sound = "SharpHitBlock",
            Pos = 0.15,
            Origin = Origin2,
            PlaybackSpeed = 1 + math.random() * 0.2
        }
        _G.Utl.PlaySound(v99)
        return
    end

    if _G.Utl.tabFind(v95, a0.Type) then
        if MyWep then
            if _G.Utl.tabFind(v95, MyWep.Type) then
                if Tool.Blade then
                    local v100 = Players.HitEffect.SharpClash:Clone()
                    v100.Parent = Tool.Blade
                    v100:Emit(1)
                    game.Debris:AddItem(v100, 0.5)
                    local v101 = Players.HitEffect.ClashLight:Clone()
                    v101.Parent = Origin2
                    local v102 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                    TweenService:Create(v101, v102, {Brightness = 0.25, Range = 8}):Play()
                    game.Debris:AddItem(v101, 0.5)
                    local v103 = {
                        Sound = "SharpBlock",
                        Origin = Tool.Blade,
                        PlaybackSpeed = 1 + math.random() * 0.2
                    }
                    _G.Utl.PlaySound(v103)
                    return
                    -- branch continues at 355
                end
            end
        end
    end

    if a0.Type == "SharpBlunt" and MyWep and not _G.Utl.tabFind(v95, MyWep.Type) then
        local v104 = Players.HitEffect.BluntBlock:Clone()
        v104.Parent = Origin2
        v104:Emit(1)
        game.Debris:AddItem(v104, 0.5)
        local v105 = {
            Sound = "BluntBlock",
            Origin = Origin2,
            PlaybackSpeed = 0.9 + math.random() * 0.2
        }
        _G.Utl.PlaySound(v105)
        local v106 = Players.HitEffect.Sharp:Clone()
        v106.Parent = Origin2
        v106:Emit(1)
        game.Debris:AddItem(v106, 0.5)
        local v107 = {
            Sound = "SharpBlock",
            Origin = Origin2,
            PlaybackSpeed = 0.9 + math.random() * 0.2
        }
        _G.Utl.PlaySound(v107)
    end
end

t1.HitEffect = function(a0) --[[ Upvalues: Players (copy) ]]
    local Origin3 = a0.Origin
    if a0.Type == "SharpBlunt" then
        local v108 = Players.HitEffect.Sharp:Clone()
        v108.Parent = Origin3
        v108:Emit(1)
        game.Debris:AddItem(v108, 1)
        local v109 = Players.HitEffect.Blunt:Clone()
        v109.Parent = Origin3
        v109:Emit(1)
        game.Debris:AddItem(v109, 1)
        local v110 = {Sound = "SharpHit", Origin = Origin3, Speed = 0.95 + math.random() * 0.1}
        _G.Utl.PlaySound(v110)
        v110 = {Sound = "BluntHit", Origin = Origin3, Speed = 0.95 + math.random() * 0.1}
        _G.Utl.PlaySound(v110)
        return
    end

    local v111 = Players.HitEffect[a0.Type]:Clone()
    v111.Parent = Origin3
    v111:Emit(1)
    game.Debris:AddItem(v111, 1)
    local v112 = {
        Sound = a0.Type .. "Hit",
        Origin = Origin3,
        Speed = 0.95 + math.random() * 0.1
    }
    _G.Utl.PlaySound(v112)
end

t1.ArmorBroke = function(a0) --[[ Upvalues: Players (copy) ]]
    local Origin4 = a0.Origin
    local v113 = {Sound = "ArmorBroke", Pos = 0.5, Origin = Origin4}
    _G.Utl.PlaySound(v113)
    local v114 = Players.ArmorShatter:Clone()
    v114.Parent = Origin4
    v114:Emit(20)
    game.Debris:AddItem(v114, 1)
end

t1.GlooperScare = function(a0) --[[ Upvalues: Animations (copy), TweenService (copy) ]]
    local Monster = a0.Monster
    local CurrentCamera1 = workspace.CurrentCamera
    CurrentCamera1.CameraType = Enum.CameraType.Scriptable
    local v115 = {Sound = "Glooper", Speed = 0.85, Origin = Monster.RootPart}
    _G.Utl.PlaySound(v115)
    Monster.AnimationController.Animator:LoadAnimation(Animations.GlooperGrab):Play()
    local v116 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v117 = Monster.RootPart.CFrame * CFrame.new(0, 1, -10)
    local v118 = {CFrame = v117 * CFrame.Angles(0, 3.1415926535897931, 0)}
    TweenService:Create(CurrentCamera1, v116, v118):Play()
end

t1.Blessing = function(a0) --[[ Upvalues: LocalPlayer (copy), ReplicatedStorage (copy), TweenService (copy) ]]
    local Origin5 = a0.Origin
    local Time = a0.Time
    local Type = a0.Type
    local t2 = {
        DamageBlessing = Color3.fromRGB(255, 39, 39),
        SpeedBlessing = Color3.fromRGB(52, 255, 49),
        DefenseBlessing = Color3.fromRGB(255, 140, 58)
    }
    if a0.Player ~= LocalPlayer then
        local v119 = ReplicatedStorage.Objects[Type]:Clone()
        v119.Parent = Origin5
        game.Debris:AddItem(v119, Time)
    end

    local Part1 = Instance.new("Part")
    game.Debris:AddItem(Part1, 0.6)
    Part1.Shape = "Ball"
    Part1.Color = t2[Type]
    Part1.Material = Enum.Material.Neon
    Part1.Transparency = 0.2
    Part1.CanCollide = false
    Part1.CanQuery = false
    Part1.Anchored = true
    Part1.Size = Vector3.new(1, 1, 1)
    Part1.CFrame = Origin5.CFrame * CFrame.new(0, 0, -1)
    Part1.Parent = workspace.CurrentCamera
    local v120 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Part1, v120, {Transparency = 0.5, Size = Vector3.new(6, 6, 6)}):Play()
end

t1.Megalodon = function(a0) --[[ Upvalues: Animations (copy), TweenService (copy) ]]
    local Monster1 = a0.Monster
    local CurrentCamera2 = workspace.CurrentCamera
    CurrentCamera2.CameraType = Enum.CameraType.Scriptable
    local v121 = Monster1:Clone()
    game.Debris:AddItem(v121, 4)
    v121.PrimaryPart.Anchored = true
    v121.PrimaryPart.CollisionGroup = "Debris"
    v121:PivotTo(Monster1.PrimaryPart.CFrame)
    v121.Parent = workspace.CurrentCamera
    local v122 = v121.PrimaryPart.CFrame * CFrame.new(0, 2, -17)
    CurrentCamera2.CFrame = v122 * CFrame.Angles(-0.20943951023931956, 3.1415926535897931, 0)
    v122 = {Sound = "MonsterScreech", Speed = 0.65, Origin = Monster1.PrimaryPart}
    _G.Utl.PlaySound(v122)
    v121.Humanoid.Animator:LoadAnimation(Animations.Megalodon.Attack):Play()
    local v123 = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v124 = v121.PrimaryPart.CFrame * CFrame.new(0, 4.5, -7)
    local v125 = {CFrame = v124 * CFrame.Angles(-0.069813170079773182, 3.1415926535897931, 0)}
    TweenService:Create(CurrentCamera2, v123, v125):Play()
    local v126 = Monster1:GetDescendants()
    for k9, k10 in pairs(v126) do
        if k10:IsA("BasePart") then
            k10.Transparency = 1
            local Transparency = k10.Transparency
            task.delay(4, function() --[[ Upvalues: k10 (copy), Transparency (copy) ]]
                k10.Transparency = Transparency
            end)
        end
    end
end

t1["Death Angel"] = function(a0) --[[ Upvalues: Animations (copy), TweenService (copy) ]]
    local Monster2 = a0.Monster
    local CurrentCamera3 = workspace.CurrentCamera
    CurrentCamera3.CameraType = Enum.CameraType.Scriptable
    local v130 = Monster2:Clone()
    game.Debris:AddItem(v130, 4)
    v130.PrimaryPart.Anchored = true
    v130.PrimaryPart.CollisionGroup = "Debris"
    v130:PivotTo(Monster2.PrimaryPart.CFrame)
    v130.Parent = workspace.CurrentCamera
    local v131 = v130.PrimaryPart.CFrame * CFrame.new(0, 1, -8)
    CurrentCamera3.CFrame = v131 * CFrame.Angles(-0.43633231299858238, 3.1415926535897931, 0)
    v131 = {Sound = "MonsterScreech", Speed = 0.9, Origin = Monster2.PrimaryPart}
    _G.Utl.PlaySound(v131)
    v130.Humanoid.Animator:LoadAnimation(Animations["Death Angel"].Attack):Play()
    local v132 = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v133 = v130.PrimaryPart.CFrame * CFrame.new(0, 3.25, -6.5)
    local v134 = {CFrame = v133 * CFrame.Angles(0, 3.1415926535897931, 0)}
    TweenService:Create(CurrentCamera3, v132, v134):Play()
    local v135 = Monster2:GetDescendants()
    for k11, k12 in pairs(v135) do
        if k12:IsA("BasePart") then
            k12.Transparency = 1
            local Transparency1 = k12.Transparency
            task.delay(4, function() --[[ Upvalues: k12 (copy), Transparency1 (copy) ]]
                k12.Transparency = Transparency1
            end)
        end
    end
end

t1.FleshExplode = function(a0)
    local t3 = {Sound = "FleshExplode", Origin = a0.Origin}
    _G.Utl.PlaySound(t3)
end

t1["Laser Beam"] = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local v139 = Players.Sphere:Clone()
    v139.Color = Color3.fromRGB(255, 0, 0)
    v139.Size = Vector3.new(0.5, 0.5, 0.5)
    local v140 = CFrame.new(a0.Origin.Position, a0.Target.Position)
    v139.CFrame = v140 * CFrame.new(0, 0, -1.5)
    v139.Parent = workspace.CurrentCamera
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = v139
    Players.LaserGather:Clone().Parent = Attachment
    task.wait(0.8)
    local v141 = {Sound = "LaserBeam", Speed = 2, Origin = v139}
    _G.Utl.PlaySound(v141)
    Attachment:Destroy()
    local v142 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v143 = {Size = Vector3.new(12, 12, 36), CFrame = v139.CFrame * CFrame.new(0, 0, -19)}
    TweenService:Create(v139, v142, v143):Play()
    task.wait(0.25)
    local v144 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v145 = {Size = Vector3.new(0, 0, 0), CFrame = v139.CFrame * CFrame.new(0, 0, 19)}
    TweenService:Create(v139, v144, v145):Play()
    game.Debris:AddItem(v139, 0.1)
end

t1["Magic Beam"] = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Origin6 = a0.Origin
    local Target = a0.Target
    local Magnitude = (Origin6.Position - Target.Position).Magnitude
    local v146 = Players.Sphere:Clone()
    v146.Color = Color3.fromRGB(34, 255, 0)
    v146.Size = Vector3.new(1.5, 1.5, 1.5)
    local v147 = CFrame.new(Origin6.Position, Target.Position)
    v146.CFrame = v147 * CFrame.new(0.75, 0.25, -1.5)
    v146.Parent = workspace.CurrentCamera
    task.wait(0.25)
    local v148 = {Sound = "MagicBeam", Speed = 1.5, Origin = v146}
    _G.Utl.PlaySound(v148)
    local v149 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v150 = {}
    v150.Size = Vector3.new(0.5, 0.5, Magnitude)
    v150.CFrame = v146.CFrame * CFrame.new(0, 0, -Magnitude / 2)
    TweenService:Create(v146, v149, v150):Play()
    task.wait(0.25)
    local v151 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v152 = {}
    v152.Size = Vector3.new(0, 0, Magnitude)
    v152.CFrame = v146.CFrame * CFrame.new(0, 0, Magnitude / 2)
    TweenService:Create(v146, v151, v152):Play()
    game.Debris:AddItem(v146, 0.5)
end

t1["Avada Kedavra"] = function(a0) --[[ Upvalues: v1 (copy), Players (copy), TweenService (copy) ]]
    local Target1 = a0.Target
    local CFrame = Target1.CFrame
    local Attachment1 = Instance.new("Attachment")
    Attachment1.Parent = a0.Origin
    Attachment1.Position = Vector3.new(0, 0.5, -1.75)
    local v153 = {Sound = "AVADAKEDAVRA", Origin = Target1}
    _G.Utl.PlaySound(v153)
    local Attachment2 = Instance.new("Attachment")
    Attachment2.Parent = Target1
    task.spawn(function() --[[ Upvalues: v1 (upvalue), Attachment1 (copy), Attachment2 (copy) ]]
        for i3 = 1, 7 do
            local v156 = v1.new(Attachment1, Attachment2, 30)
            v156.Color = Color3.fromRGB(104, 255, 70)
            local v157 = -2.5 + math.random() * 5
            v156.CurveSize0 = v157
            v156.CurveSize1 = -2.5 + math.random() * 5
            v156.PulseSpeed = 4 + math.random() * 1
            v156.PulseLength = 0.75
            v156.FadeLength = 0.1
            v156.MinRadius = 0.25
            v156.MaxRadius = 1
            v156.Frequency = 0.5
            v156.Thickness = 0.5
            v156.MinThicknessMultiplier = 0.8
            v156.MaxThicknessMultiplier = 1.2
            task.wait()
        end

    end)
    task.wait(0.25)
    Target1 = Players.Sphere:Clone()
    Target1.Color = Color3.fromRGB(104, 255, 70)
    Target1.Size = Vector3.new(0, 0, 0)
    Target1.CFrame = CFrame
    Target1.Parent = workspace.CurrentCamera
    game.Debris:AddItem(Target1, 0.5)
    local v158 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Target1, v158, {Size = Vector3.new(12, 12, 12), Transparency = 1}):Play()
    game.Debris:AddItem(Attachment1, 1.5)
    game.Debris:AddItem(Attachment2, 1.5)
end

t1.BlessingsEvent = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Char = a0.Char
    local HumanoidRootPart = Char:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then
        return
    end

    local Part2 = Instance.new("Part")
    Part2.Material = Enum.Material.Neon
    Part2.Transparency = 1
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.Color = Color3.fromRGB(255, 236, 158)
    Part2.Size = Vector3.new(1, 1, 1)
    Part2.Position = Vector3.new(HumanoidRootPart.Position.X, 55, HumanoidRootPart.Position.Z)
    Part2.Parent = workspace.CurrentCamera
    local v159 = {Sound = "MovingWind", Speed = 1.2, Origin = HumanoidRootPart}
    _G.Utl.PlaySound(v159)
    HumanoidRootPart = Players.BlessingsAura:Clone()
    HumanoidRootPart.Parent = Part2
    game.Debris:AddItem(Part2, 5)
    task.wait(1)
    HumanoidRootPart.Enabled = false
    local v160 = Players.BlessingsHighlight:Clone()
    v160.Parent = Char
    game.Debris:AddItem(v160, 8)
    local v161 = TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    TweenService:Create(v160, v161, {FillTransparency = 0.8, OutlineTransparency = 0.75}):Play()
end

t1.StaticPortal = function(a0) --[[ Upvalues: ReplicatedStorage (copy), TweenService (copy) ]]
    local v162 = ReplicatedStorage.Objects.AgentPortal:Clone()
    v162.Position = a0.Pos
    v162.Parent = workspace
    game.Debris:AddItem(v162, 4)
    local v163 = {Sound = "StaticPortal", Return = true, Origin = v162}
    local v164 = _G.Utl.PlaySound(v163)
    v164:Play()
    task.wait(0.75)
    task.delay(1.5, function() --[[ Upvalues: v162 (copy), TweenService (upvalue), v164 (copy) ]]
        v162.ParticleEmitter.Enabled = false
        local v165 = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        TweenService:Create(v164, v165, {Volume = 0}):Play()
        game.Debris:AddItem(v164, 1)
    end)
end

t1.TheStuff = function(a0) --[[ Upvalues: ReplicatedStorage (copy) ]]
    local Origin7 = a0.Origin
    local v166 = ReplicatedStorage.Objects.TheStuffAura:Clone()
    v166.Parent = Origin7
    game.Debris:AddItem(v166, a0.Time)
    local v167 = {Sound = "ManYell", Origin = Origin7, Speed = 1 + math.random() * 0.15}
    _G.Utl.PlaySound(v167)
end

t1.ChaosPotion = function(a0) --[[ Upvalues: ReplicatedStorage (copy) ]]
    local Origin8 = a0.Origin
    local Time1 = a0.Time
    if not Origin8 then
        return
    end

    local v168 = Origin8:GetChildren()
    for k13, k14 in pairs(v168) do
        if k14:IsA("ParticleEmitter") and k14:GetAttribute("ChaosPotion") then
            k14:Destroy()
        end
    end

    local v172 = ReplicatedStorage.Objects.ChaosPotion:GetChildren()
    for k15, k16 in pairs(v172) do
        if k16:IsA("ParticleEmitter") then
            local v176 = k16:Clone()
            v176:SetAttribute("ChaosPotion", true)
            v176.Parent = Origin8
            game.Debris:AddItem(v176, Time1)
        end
    end
end

t1.SpeedJuice = function(a0) --[[ Upvalues: ReplicatedStorage (copy) ]]
    local Origin9 = a0.Origin
    local v177 = ReplicatedStorage.Objects.SpeedJuiceAura:Clone()
    v177.Parent = Origin9
    game.Debris:AddItem(v177, a0.Time)
    local v178 = {Sound = "Yum", Speed = 0.9, Origin = Origin9}
    _G.Utl.PlaySound(v178)
end

t1.Darts = function(a0) --[[ Upvalues: TweenService (copy) ]]
    local Origin10 = a0.Origin
    task.spawn(function() --[[ Upvalues: Origin10 (copy) ]]
        for i4 = 1, math.random(3, 4) do
            local v181 = {Sound = "Darts", Origin = Origin10, Speed = 1 + math.random() * 0.15}
            _G.Utl.PlaySound(v181)
            task.wait(0.03 + math.random() * 0.03)
        end

    end)
    for i5 = 1, 6 do
        local Part3 = Instance.new("Part")
        Part3.Anchored = true
        Part3.CanCollide = false
        Part3.CanTouch = false
        Part3.CanQuery = false
        Part3.Material = Enum.Material.SmoothPlastic
        Part3.Color = Color3.fromRGB(0, 0, 0)
        Part3.Size = Vector3.new(0.05, 0.05, 0.7 + math.random() * 0.5)
        local v184 = -4 + math.random() * 8
        local v185 = -4 + math.random() * 8
        Part3.CFrame = Origin10.CFrame * CFrame.new(v184, v185, -1 + math.random() * 0.75)
        Part3.Parent = workspace.CurrentCamera
        game.Debris:AddItem(Part3, 1.5)
        local v186 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v187 = {CFrame = Part3.CFrame * CFrame.new(0, 0, -19 + math.random() * 1)}
        TweenService:Create(Part3, v186, v187):Play()
        task.delay(1, function() --[[ Upvalues: TweenService (upvalue), Part3 (copy) ]]
            local v188 = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            TweenService:Create(Part3, v188, {Transparency = 1}):Play()
        end)
    end
end

t1["Dimensional Slash"] = function(a0) --[[ Upvalues: Players (copy) ]]
    local v189 = Players.DimensionalSlash:Clone()
    v189.CFrame = a0.Origin * CFrame.new(0, -3, -27.5)
    v189.Parent = workspace.CurrentCamera
    local v190 = {Sound = "DimensionalSlash", Speed = 0.85, Origin = v189}
    _G.Utl.PlaySound(v190)
    local v191 = 20
    v190 = 1
    for i6 = 1, v191, v190 do
        local v192 = v189.Effect:Clone()
        v192.Position = Vector3.new(0, 0, 25 - i6 * 2.5)
        v192.Parent = v189
        v192.Particle:Emit(15)
        task.wait(0.025)
    end

    game.Debris:AddItem(v189, 2)
end

t1.BladeAnimate = function(a0) --[[ Upvalues: TweenService (copy) ]]
    local Object = a0.Object
    local v193 = TweenInfo.new(550, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true, 0)
    local v194 = TweenInfo.new(550, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true, 0)
    local v195 = {}
    local v196 = Object:GetChildren()
    for k17, k18 in pairs(v196) do
        if k18:IsA("Texture") then
            local v200 = TweenService:Create(k18, v193, {OffsetStudsU = 150})
            local v201 = TweenService:Create(k18, v194, {OffsetStudsV = 100})
            v200:Play()
            v201:Play()
            table.insert(v195, v200)
            table.insert(v195, v201)
        end
    end

    while true do
        task.wait(0.5)
        if not Object:IsDescendantOf(workspace) then
            break
        end
    end

    for k19, k20 in pairs(v195) do
        k20:Cancel()
        k20:Remove()
    end
end

t1.TurretFire = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Turret = a0.Turret
    local Dist = a0.Dist
    local Int = a0.Int
    local On = a0.On
    local Color = a0.Color
    local v205 = a0.Width or 0.125
    local v206 = {
        Volume = 0.3,
        Origin = Turret,
        Sound = a0.FireSound,
        Speed = 1.15 + math.random() * 0.2
    }
    _G.Utl.PlaySound(v206)
    local v207 = Players.MuzzleFlash:Clone()
    v207.Parent = Turret[On]
    local v208 = math.random(1, 2)
    v207:Emit(v208)
    game.Debris:AddItem(v207, 0.2)
    v207 = Players.MuzzleLight:Clone()
    v207.Parent = Turret[On]
    local v209 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(v207, v209, {Range = 3, Brightness = 0}):Play()
    game.Debris:AddItem(v207, 0.3)
    if a0.ShowTracer ~= false then
        v207 = Instance.new("Part")
        v207.CastShadow = false
        v207.Material = Enum.Material.Neon
        v207.Color = Color3.fromRGB(255, 153, 85)
        v207.Transparency = 0.4
        v207.CanCollide = false
        v207.CanQuery = false
        v207.CanTouch = false
        v207.Anchored = true
        v207.Size = Vector3.new(0.125, 0.125, 0.125)
        v207.Name = "Bullet"
        if Color then
            v207.Material = Enum.Material.Neon
            v207.Color = Color
        end

        v207.Size = Vector3.new(v205, v205, Dist)
        local v210 = CFrame.new(Turret[On].WorldPosition, Int)
        v207.CFrame = v210 * CFrame.new(0, 0, -Dist / 2)
        v207.Parent = workspace
        game.Debris:AddItem(v207, 0.3)
        local v211 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(v207, v211, {Transparency = 1}):Play()
    end
end

t1.EMPExplode = function(a0) --[[ Upvalues: Players (copy) ]]
    local v212 = Players.EMPExplode:Clone()
    v212.Position = a0.Pos
    v212.Parent = workspace.CurrentCamera
    v212.Attachment.Shock:Emit(2)
    v212.Sparks:Emit(20)
    game.Debris:AddItem(v212, 2)
    local v213 = {Sound = "EMPExplosion", Speed = 1.25, Pos = 0.1, Origin = v212}
    _G.Utl.PlaySound(v213)
end

t1.Explosion = function(a0) --[[ Upvalues: Players (copy) ]]
    local v214 = Players.Explosion:Clone()
    v214.Position = a0.Pos
    v214.Parent = workspace.CurrentCamera
    v214.Core.Shock:Emit(1)
    v214.Core.Lines:Emit(80)
    game.Debris:AddItem(v214, 2)
    local v215 = {Sound = "Explosion", Speed = 1.2, Origin = v214}
    _G.Utl.PlaySound(v215)
end

t1.Smash = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Radius = a0.Radius
    local Size = a0.Size
    local Parts = a0.Parts
    local Origin11 = a0.Origin
    local v216 = false
    for i7 = 1, Parts do
        local v219 = CFrame.new(Origin11.Position)
        local v220 = math.rad(360 / Parts * i7)
        local v221 = v219 * CFrame.Angles(0, v220, 0)
        v221 = v221 * CFrame.new(0, 0, -Radius)
        local v222 = {workspace.Map}
        local v223 = {Origin = v221.Position, Dir = v221.UpVector * -10, Whitelist = v222}
        local v224 = _G.Utl.Raycast(v223)
        if v224 then
            v221 = Instance.new("Part")
            v221.Size = Vector3.new(1, 1, 1) * Size
            local v225 = CFrame.new(v224.Position - Vector3.new(0, 2, 0))
            local v226 = math.random()
            v221.CFrame = v225 * CFrame.Angles(math.random(), math.random(), v226)
            v221.Color = v224.Instance.Color
            v221.Material = v224.Instance.Material
            v221.CanCollide = false
            v221.CanQuery = false
            v221.CanTouch = false
            v221.Anchored = true
            v221.Parent = workspace.CurrentCamera
            if not v216 then
                v216 = true
                local v227 = Players.SmokeSmash:Clone()
                v227.CFrame = CFrame.new(Origin11.Position)
                v227.Smoke.Color = ColorSequence.new(v221.Color)
                v227.Parent = workspace.CurrentCamera
                v227.Smoke:Emit(15)
                game.Debris:AddItem(v227, 2)
                local v228 = {Sound = "GroundSmash", Speed = 1.1, Origin = v227}
                _G.Utl.PlaySound(v228)
            end

            game.Debris:AddItem(v221, 2)
            local v229 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local v230 = {Position = v221.Position + Vector3.new(0, 2, 0)}
            TweenService:Create(v221, v229, v230):Play()
            task.delay(1.5, function() --[[ Upvalues: TweenService (upvalue), v221 (copy) ]]
                local v231 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local v232 = {Position = v221.Position - Vector3.new(0, 2, 0)}
                TweenService:Create(v221, v231, v232):Play()
            end)
        end
    end
end

t1.Slash = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Origin12 = a0.Origin
    local v233 = Players.Slash:Clone()
    local v234 = Origin12.CFrame * CFrame.new(0, 0, -4.5)
    v233.CFrame = v234 * CFrame.Angles(0, 0, 0.78539816339744828)
    v233.Parent = workspace.CurrentCamera
    game.Debris:AddItem(v233, 0.5)
    local v235 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(v233, v235, {Transparency = 1}):Play()
    local v236 = {Sound = "Slash", Origin = v233}
    _G.Utl.PlaySound(v236)
    local v237 = Players.Slash:Clone()
    v236 = Origin12.CFrame * CFrame.new(0, 0, -4.5)
    v237.CFrame = v236 * CFrame.Angles(0, 0, -0.78539816339744828)
    v237.Parent = workspace.CurrentCamera
    game.Debris:AddItem(v237, 0.5)
    local v238 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(v237, v238, {Transparency = 1}):Play()
end

t1.SamuraiSlash = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Origin13 = a0.Origin
    local v239 = Players.SamuraiSlash:Clone()
    local v240 = Origin13.CFrame * CFrame.new(0, 0, -4.5)
    v239.CFrame = v240 * CFrame.Angles(0, 0, 0.78539816339744828)
    v239.Parent = workspace.CurrentCamera
    game.Debris:AddItem(v239, 0.5)
    local v241 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(v239, v241, {Transparency = 1}):Play()
    local v242 = {Sound = "Slash", Origin = v239}
    _G.Utl.PlaySound(v242)
    local v243 = Players.SamuraiSlash:Clone()
    v242 = Origin13.CFrame * CFrame.new(0, 0, -4.5)
    v243.CFrame = v242 * CFrame.Angles(0, 0, -0.78539816339744828)
    v243.Parent = workspace.CurrentCamera
    game.Debris:AddItem(v243, 0.5)
    local v244 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(v243, v244, {Transparency = 1}):Play()
end

t1.Burrow = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Origin14 = a0.Origin
    local Time2 = a0.Time
    for i8 = 1, 30 do
        local v247 = -2 + math.random() * 4
        local v248 = {workspace.Map}
        local v249 = {
            Origin = (Origin14.CFrame * CFrame.new(v247, 12, -1 + math.random() * 2)).Position,
            Dir = Origin14.CFrame.UpVector * -10,
            Whitelist = v248
        }
        local v250 = _G.Utl.Raycast(v249)
        if v250 then
            local Part4 = Instance.new("Part")
            game.Debris:AddItem(Part4, 1.5)
            Part4.Color = v250.Instance.Color
            local v251 = CFrame.new(v250.Position)
            local v252 = math.random()
            Part4.CFrame = v251 * CFrame.Angles(math.random(), math.random(), v252)
            Part4.Material = v250.Instance.Material
            Part4.Anchored = true
            Part4.CanCollide = false
            Part4.CanQuery = false
            Part4.CanTouch = false
            Part4.Size = Vector3.new(1, 1, 1) * (4.5 + math.random() * 1.5)
            Part4.Parent = workspace.CurrentCamera
            local v253 = Players.Smoke:Clone()
            v253.Color = ColorSequence.new(Part4.Color)
            v253.Parent = Part4
            local v254 = math.random(1, 2)
            v253:Emit(v254)
            local v255 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local v256 = {
                Size = Vector3.new(0, 0, 0),
                Position = Part4.Position - Vector3.new(0, 1.25, 0)
            }
            TweenService:Create(Part4, v255, v256)
            local v257 = {
                Sound = "RockDropSmash",
                Origin = Part4,
                Speed = 1 + math.random() * 0.2
            }
            _G.Utl.PlaySound(v257)
        end

        task.wait(Time2 / 30)
    end
end

t1["Fish Chunk Barrage"] = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Origin15 = a0.Origin
    local v258 = Color3.fromRGB(255, 172, 116)
    local v259 = Color3.fromRGB(255, 144, 89)
    local t4 = {v258, v259, Color3.fromRGB(255, 135, 114)}
    v258 = 20
    v259 = 1
    for i9 = 1, v258, v259 do
        local v261 = Players.Sphere:Clone()
        v261.Material = Enum.Material.SmoothPlastic
        v261.Anchored = false
        v261.Color = t4[math.random(#t4)]
        local v262 = 0.5 + math.random() * 0.25
        local v263 = 0.5 + math.random() * 0.25
        v261.Size = Vector3.new(v262, v263, 2 + math.random() * 0.5)
        local v264 = -3 + math.random() * 6
        local v265 = -1 + math.random() * 2.5
        v261.CFrame = Origin15.CFrame * CFrame.new(v264, v265, -2.75 - math.random() * 0.5)
        v261.Parent = workspace.CurrentCamera
        local v266 = Origin15.CFrame.LookVector * (50 + math.random() * 30)
        local v267 = 10 + math.random() * 10
        v261.AssemblyLinearVelocity = v266 + Vector3.new(0, v267, 0)
        game.Debris:AddItem(v261, 1)
        local v268 = {Sound = "TinyWoosh", Origin = v261, Speed = 1.1 + math.random() * 0.1}
        _G.Utl.PlaySound(v268)
        local v269 = 0.25 + math.random() * 0.25
        local v270 = TweenInfo.new(v269, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.25)
        TweenService:Create(v261, v270, {Transparency = 1}):Play()
        task.wait(0.05)
    end
end

t1.GunFire = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Gun1 = a0.Gun
    local FireSound = a0.FireSound
    local Origin16 = a0.Origin
    local Dist1 = a0.Dist
    local Int1 = a0.Int
    if a0.On == 1 then
        local v271 = {Origin = Gun1, Sound = FireSound, Speed = 1.15 + math.random() * 0.2}
        _G.Utl.PlaySound(v271)
        local v272 = Players.MuzzleFlash:Clone()
        v272.Parent = Gun1.ShootPoint
        local v273 = math.random(1, 2)
        v272:Emit(v273)
        game.Debris:AddItem(v272, 0.2)
    end

    FireSound = Players.MuzzleLight:Clone()
    FireSound.Parent = Gun1.ShootPoint
    local v274 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(FireSound, v274, {Range = 3, Brightness = 0}):Play()
    game.Debris:AddItem(FireSound, 0.3)
    FireSound = Instance.new("Part")
    FireSound.CastShadow = false
    FireSound.Material = Enum.Material.Neon
    FireSound.Color = Color3.fromRGB(255, 153, 85)
    FireSound.Transparency = 0.4
    FireSound.CanCollide = false
    FireSound.CanQuery = false
    FireSound.CanTouch = false
    FireSound.Anchored = true
    FireSound.Size = Vector3.new(0.125, 0.125, 0.125)
    FireSound.Name = "Bullet"
    FireSound.Size = Vector3.new(0.125, 0.125, Dist1)
    local v275 = CFrame.new(Origin16, Int1)
    FireSound.CFrame = v275 * CFrame.new(0, 0, -Dist1 / 2)
    FireSound.Parent = workspace
    game.Debris:AddItem(FireSound, 0.3)
    local v276 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(FireSound, v276, {Transparency = 1}):Play()
end

t1.BulletDeflect = function(a0) --[[ Upvalues: TweenService (copy), Players (copy) ]]
    local Origin17 = a0.Origin
    local Int2 = a0.Int
    local Magnitude1 = (Int2 - Origin17).Magnitude
    local Part5 = Instance.new("Part")
    Part5.CastShadow = false
    Part5.Material = Enum.Material.Neon
    Part5.Color = Color3.fromRGB(255, 153, 85)
    Part5.Transparency = 0.4
    Part5.CanCollide = false
    Part5.CanQuery = false
    Part5.CanTouch = false
    Part5.Anchored = true
    Part5.Size = Vector3.new(0.125, 0.125, 0.125)
    Part5.Name = "Bullet"
    Part5.Size = Vector3.new(0.125, 0.125, Magnitude1)
    local v277 = CFrame.new(Origin17, Int2)
    Part5.CFrame = v277 * CFrame.new(0, 0, -Magnitude1 / 2)
    Part5.Parent = workspace
    game.Debris:AddItem(Part5, 0.3)
    local v278 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Part5, v278, {Transparency = 1}):Play()
    local Part6 = Instance.new("Part")
    Part6.Anchored = true
    Part6.CanCollide = false
    Part6.CanQuery = false
    Part6.CanTouch = false
    Part6.Transparency = 1
    Part6.Size = Vector3.new(0.20000000298023224, 0.20000000298023224, 0.20000000298023224)
    Part6.CFrame = CFrame.new(Origin17)
    Part6.Parent = workspace
    Magnitude1 = Players.HitEffect.Sharp:Clone()
    Magnitude1.Parent = Part6
    Magnitude1:Emit(3)
    game.Debris:AddItem(Part6, 0.6)
    local v279 = {
        Sound = "SharpHitBlock",
        Pos = 0.15,
        Origin = Part6,
        PlaybackSpeed = 1.1 + math.random() * 0.2
    }
    _G.Utl.PlaySound(v279)
end

t1.GoldenBullet = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Gun2 = a0.Gun
    local FireSound1 = a0.FireSound
    local Origin18 = a0.Origin
    local Dist2 = a0.Dist
    local Int3 = a0.Int
    if a0.On == 1 then
        local v280 = {Origin = Gun2, Sound = FireSound1, Speed = 1.15 + math.random() * 0.2}
        _G.Utl.PlaySound(v280)
        local v281 = Players.ShootEffects.GoldenMuzzle:Clone()
        v281.Parent = Gun2.ShootPoint
        v281:Emit(1)
        game.Debris:AddItem(v281, 0.2)
    end

    FireSound1 = Players.MuzzleLight:Clone()
    FireSound1.Color = Color3.fromRGB(255, 255, 103)
    FireSound1.Parent = Gun2.ShootPoint
    local v282 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(FireSound1, v282, {Range = 3, Brightness = 0}):Play()
    game.Debris:AddItem(FireSound1, 0.3)
    FireSound1 = Instance.new("Part")
    FireSound1.CastShadow = false
    FireSound1.Material = Enum.Material.Neon
    FireSound1.Color = Color3.fromRGB(255, 153, 85)
    FireSound1.Transparency = 0.4
    FireSound1.CanCollide = false
    FireSound1.CanQuery = false
    FireSound1.CanTouch = false
    FireSound1.Anchored = true
    FireSound1.Size = Vector3.new(0.125, 0.125, 0.125)
    FireSound1.Name = "Bullet"
    FireSound1.Color = Color3.fromRGB(255, 225, 73)
    FireSound1.Size = Vector3.new(0.025, 0.025, Dist2)
    local v283 = CFrame.new(Origin18, Int3)
    FireSound1.CFrame = v283 * CFrame.new(0, 0, -Dist2 / 2)
    FireSound1.Parent = workspace
    game.Debris:AddItem(FireSound1, 0.1)
end

t1.MenaceBullet = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Gun3 = a0.Gun
    local FireSound2 = a0.FireSound
    local Origin19 = a0.Origin
    local Dist3 = a0.Dist
    local Int4 = a0.Int
    if a0.On == 1 then
        local v284 = {Origin = Gun3, Sound = FireSound2, Speed = 1.15 + math.random() * 0.2}
        _G.Utl.PlaySound(v284)
        local v285 = Players.ShootEffects.MenaceMuzzle:Clone()
        v285.Parent = Gun3.ShootPoint
        v285:Emit(1)
        game.Debris:AddItem(v285, 0.2)
    end

    FireSound2 = Players.MuzzleLight:Clone()
    FireSound2.Color = Color3.fromRGB(231, 231, 231)
    FireSound2.Parent = Gun3.ShootPoint
    local v286 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(FireSound2, v286, {Range = 3, Brightness = 0}):Play()
    game.Debris:AddItem(FireSound2, 0.3)
    FireSound2 = Instance.new("Part")
    FireSound2.CastShadow = false
    FireSound2.Material = Enum.Material.Neon
    FireSound2.Color = Color3.fromRGB(255, 153, 85)
    FireSound2.Transparency = 0.4
    FireSound2.CanCollide = false
    FireSound2.CanQuery = false
    FireSound2.CanTouch = false
    FireSound2.Anchored = true
    FireSound2.Size = Vector3.new(0.125, 0.125, 0.125)
    FireSound2.Name = "Bullet"
    FireSound2.Color = Color3.fromRGB(206, 206, 206)
    FireSound2.Size = Vector3.new(0.025, 0.025, Dist3)
    local v287 = CFrame.new(Origin19, Int4)
    FireSound2.CFrame = v287 * CFrame.new(0, 0, -Dist3 / 2)
    FireSound2.Parent = workspace
    game.Debris:AddItem(FireSound2, 0.1)
end

t1.PurpleVibe = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Gun4 = a0.Gun
    local FireSound3 = a0.FireSound
    local Origin20 = a0.Origin
    local Dist4 = a0.Dist
    local Int5 = a0.Int
    if a0.On == 1 then
        local v288 = {Origin = Gun4, Sound = FireSound3, Speed = 1.15 + math.random() * 0.2}
        _G.Utl.PlaySound(v288)
        local v289 = Players.ShootEffects.PurpleVibe:Clone()
        v289.Parent = Gun4.ShootPoint
        local v290 = math.random(1, 2)
        v289:Emit(v290)
        game.Debris:AddItem(v289, 0.2)
    end

    FireSound3 = Players.MuzzleLight:Clone()
    FireSound3.Color = Color3.fromRGB(188, 134, 255)
    FireSound3.Parent = Gun4.ShootPoint
    local v291 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(FireSound3, v291, {Range = 3, Brightness = 0}):Play()
    game.Debris:AddItem(FireSound3, 0.3)
    FireSound3 = Instance.new("Part")
    FireSound3.CastShadow = false
    FireSound3.Material = Enum.Material.Neon
    FireSound3.Color = Color3.fromRGB(255, 153, 85)
    FireSound3.Transparency = 0.4
    FireSound3.CanCollide = false
    FireSound3.CanQuery = false
    FireSound3.CanTouch = false
    FireSound3.Anchored = true
    FireSound3.Size = Vector3.new(0.125, 0.125, 0.125)
    FireSound3.Name = "Bullet"
    FireSound3.Color = Color3.fromRGB(188, 134, 255)
    FireSound3.Size = Vector3.new(0.125, 0.125, Dist4)
    local v292 = CFrame.new(Origin20, Int5)
    FireSound3.CFrame = v292 * CFrame.new(0, 0, -Dist4 / 2)
    FireSound3.Parent = workspace
    game.Debris:AddItem(FireSound3, 0.3)
    local v293 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(FireSound3, v293, {Transparency = 1}):Play()
end

t1.Danger = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Gun5 = a0.Gun
    local FireSound4 = a0.FireSound
    local Origin21 = a0.Origin
    local Dist5 = a0.Dist
    local Int6 = a0.Int
    if a0.On == 1 then
        local v294 = {Origin = Gun5, Sound = FireSound4, Speed = 1.15 + math.random() * 0.2}
        _G.Utl.PlaySound(v294)
        local v295 = Players.ShootEffects.DangerMuzzle:Clone()
        v295.Parent = Gun5.ShootPoint
        v295:Emit(1)
        game.Debris:AddItem(v295, 0.2)
    end

    FireSound4 = Players.MuzzleLight:Clone()
    FireSound4.Color = Color3.fromRGB(255, 82, 82)
    FireSound4.Parent = Gun5.ShootPoint
    local v296 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(FireSound4, v296, {Range = 3, Brightness = 0}):Play()
    game.Debris:AddItem(FireSound4, 0.3)
    FireSound4 = Instance.new("Attachment")
    FireSound4.Parent = workspace.Baseplate
    FireSound4.WorldPosition = Gun5.ShootPoint.WorldPosition
    game.Debris:AddItem(FireSound4, 1)
    local Attachment3 = Instance.new("Attachment")
    Attachment3.Parent = workspace.Baseplate
    local v297 = CFrame.new(Origin21, Int6)
    Attachment3.WorldPosition = (v297 * CFrame.new(0, 0, -Dist5)).Position
    game.Debris:AddItem(Attachment3, 1)
    Int6 = Players.ShootEffects.DangerBullet:Clone()
    Int6.Attachment0 = FireSound4
    Int6.Attachment1 = Attachment3
    Int6.Parent = Gun5
    game.Debris:AddItem(Int6, 0.4)
    local v298 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Int6, v298, {Width0 = 0}):Play()
    local v299 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Int6, v299, {Width1 = 0}):Play()
end

t1.GreenThumb = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Gun6 = a0.Gun
    local FireSound5 = a0.FireSound
    local Origin22 = a0.Origin
    local Dist6 = a0.Dist
    local Int7 = a0.Int
    if a0.On == 1 then
        local v300 = {Origin = Gun6, Sound = FireSound5, Speed = 1.15 + math.random() * 0.2}
        _G.Utl.PlaySound(v300)
        local v301 = Players.ShootEffects.GreenThumbMuzzle:Clone()
        v301.Parent = Gun6.ShootPoint
        v301:Emit(1)
        game.Debris:AddItem(v301, 0.25)
    end

    FireSound5 = Players.MuzzleLight:Clone()
    FireSound5.Color = Color3.fromRGB(46, 255, 42)
    FireSound5.Parent = Gun6.ShootPoint
    local v302 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(FireSound5, v302, {Range = 3, Brightness = 0}):Play()
    game.Debris:AddItem(FireSound5, 0.3)
    FireSound5 = Instance.new("Attachment")
    FireSound5.Parent = workspace.Baseplate
    FireSound5.WorldPosition = Gun6.ShootPoint.WorldPosition
    game.Debris:AddItem(FireSound5, 1)
    local Attachment4 = Instance.new("Attachment")
    Attachment4.Parent = workspace.Baseplate
    local v303 = CFrame.new(Origin22, Int7)
    Attachment4.WorldPosition = (v303 * CFrame.new(0, 0, -Dist6)).Position
    game.Debris:AddItem(Attachment4, 1)
    Int7 = Players.ShootEffects.GreenThumbBullet:Clone()
    Int7.Attachment0 = FireSound5
    Int7.Attachment1 = Attachment4
    Int7.Parent = Gun6
    game.Debris:AddItem(Int7, 0.4)
    local v304 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Int7, v304, {Width0 = 0}):Play()
    local v305 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Int7, v305, {Width1 = 0}):Play()
end

t1.NebulaBullet = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Gun7 = a0.Gun
    local FireSound6 = a0.FireSound
    local Origin23 = a0.Origin
    local Dist7 = a0.Dist
    local Int8 = a0.Int
    if a0.On == 1 then
        local v306 = {Origin = Gun7, Sound = FireSound6, Speed = 1.15 + math.random() * 0.2}
        _G.Utl.PlaySound(v306)
        local v307 = Players.ShootEffects.NebulaMuzzle1:Clone()
        v307.Parent = Gun7.ShootPoint
        v307:Emit(2)
        game.Debris:AddItem(v307, 0.5)
        local v308 = Players.ShootEffects.NebulaMuzzle2:Clone()
        v308.Parent = Gun7.ShootPoint
        v308:Emit(2)
        game.Debris:AddItem(v308, 0.5)
        local v309 = Players.ShootEffects.NebulaMuzzle3:Clone()
        v309.Parent = Gun7.ShootPoint
        v309:Emit(2)
        game.Debris:AddItem(v309, 0.5)
    end

    FireSound6 = Players.MuzzleLight:Clone()
    FireSound6.Color = Color3.fromRGB(85, 0, 255)
    FireSound6.Parent = Gun7.ShootPoint
    local v310 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(FireSound6, v310, {Range = 3, Brightness = 0}):Play()
    game.Debris:AddItem(FireSound6, 0.3)
    FireSound6 = Instance.new("Attachment")
    FireSound6.Parent = workspace.Baseplate
    FireSound6.WorldPosition = Gun7.ShootPoint.WorldPosition
    game.Debris:AddItem(FireSound6, 1)
    local Attachment5 = Instance.new("Attachment")
    Attachment5.Parent = workspace.Baseplate
    local v311 = CFrame.new(Origin23, Int8)
    Attachment5.WorldPosition = (v311 * CFrame.new(0, 0, -Dist7)).Position
    game.Debris:AddItem(Attachment5, 1)
    Int8 = Players.ShootEffects["NebulaBullet" .. math.random(1, 2)]:Clone()
    Int8.Attachment0 = FireSound6
    Int8.Attachment1 = Attachment5
    Int8.Parent = Gun7
    game.Debris:AddItem(Int8, 0.4)
    local v312 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Int8, v312, {Width0 = 0}):Play()
    local v313 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Int8, v313, {Width1 = 0}):Play()
end

t1.CrimsonBullet = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Gun8 = a0.Gun
    local FireSound7 = a0.FireSound
    local Origin24 = a0.Origin
    local Dist8 = a0.Dist
    local Int9 = a0.Int
    if a0.On == 1 then
        local v314 = {Origin = Gun8, Sound = FireSound7, Speed = 1.15 + math.random() * 0.2}
        _G.Utl.PlaySound(v314)
        local v315 = Players.ShootEffects.CrimsonMuzzle:Clone()
        v315.Parent = Gun8.ShootPoint
        v315:Emit(1)
        game.Debris:AddItem(v315, 0.2)
    end

    local v316 = Color3.fromRGB(255, 3, 3)
    local v317 = Color3.fromRGB(158, 0, 0)
    local v318 = Color3.fromRGB(212, 106, 106)
    FireSound7 = {v316, v317, v318, Color3.fromRGB(0, 0, 0)}
    v316 = FireSound7[math.random(#FireSound7)]
    FireSound7 = Players.MuzzleLight:Clone()
    FireSound7.Color = v316
    FireSound7.Parent = Gun8.ShootPoint
    local v320 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(FireSound7, v320, {Range = 3, Brightness = 0}):Play()
    game.Debris:AddItem(FireSound7, 0.3)
    FireSound7 = Instance.new("Part")
    FireSound7.CastShadow = false
    FireSound7.Material = Enum.Material.Neon
    FireSound7.Color = Color3.fromRGB(255, 153, 85)
    FireSound7.Transparency = 0.4
    FireSound7.CanCollide = false
    FireSound7.CanQuery = false
    FireSound7.CanTouch = false
    FireSound7.Anchored = true
    FireSound7.Size = Vector3.new(0.125, 0.125, 0.125)
    FireSound7.Name = "Bullet"
    FireSound7.Color = v316
    FireSound7.Size = Vector3.new(0.05, 0.05, Dist8)
    local v321 = CFrame.new(Origin24, Int9)
    FireSound7.CFrame = v321 * CFrame.new(0, 0, -Dist8 / 2)
    FireSound7.Parent = workspace
    game.Debris:AddItem(FireSound7, 0.15)
    local v322 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v323 = {Size = FireSound7.Size * Vector3.new(0, 0, 1)}
    TweenService:Create(FireSound7, v322, v323):Play()
end

t1.GlacierBullet = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Gun9 = a0.Gun
    local FireSound8 = a0.FireSound
    local Origin25 = a0.Origin
    local Dist9 = a0.Dist
    local Int10 = a0.Int
    if a0.On == 1 then
        local v324 = {Origin = Gun9, Sound = FireSound8, Speed = 1.15 + math.random() * 0.2}
        _G.Utl.PlaySound(v324)
        local v325 = Players.ShootEffects.Glacier1:Clone()
        v325.Parent = Gun9.ShootPoint
        v325:Emit(1)
        game.Debris:AddItem(v325, 0.5)
        local v326 = Players.ShootEffects.Glacier2:Clone()
        v326.Parent = Gun9.ShootPoint
        local v327 = math.random(3, 5)
        v326:Emit(v327)
        game.Debris:AddItem(v326, 0.5)
    end

    FireSound8 = Players.MuzzleLight:Clone()
    FireSound8.Color = Color3.fromRGB(0, 195, 255)
    FireSound8.Parent = Gun9.ShootPoint
    local v328 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(FireSound8, v328, {Range = 3, Brightness = 0}):Play()
    game.Debris:AddItem(FireSound8, 0.3)
    FireSound8 = Instance.new("Attachment")
    FireSound8.Parent = workspace.Baseplate
    FireSound8.WorldPosition = Gun9.ShootPoint.WorldPosition
    game.Debris:AddItem(FireSound8, 1)
    local Attachment6 = Instance.new("Attachment")
    Attachment6.Parent = workspace.Baseplate
    local v329 = CFrame.new(Origin25, Int10)
    Attachment6.WorldPosition = (v329 * CFrame.new(0, 0, -Dist9)).Position
    game.Debris:AddItem(Attachment6, 1)
    Int10 = Players.ShootEffects.GlacierBullet:Clone()
    Int10.Attachment0 = FireSound8
    Int10.Attachment1 = Attachment6
    Int10.Parent = Gun9
    game.Debris:AddItem(Int10, 0.4)
    local v330 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Int10, v330, {Width0 = 0}):Play()
    local v331 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Int10, v331, {Width1 = 0}):Play()
end

t1.Summer2026 = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Gun10 = a0.Gun
    local FireSound9 = a0.FireSound
    local Origin26 = a0.Origin
    local Dist10 = a0.Dist
    local Int11 = a0.Int
    if a0.On == 1 then
        local v332 = {Origin = Gun10, Sound = FireSound9, Speed = 1.15 + math.random() * 0.2}
        _G.Utl.PlaySound(v332)
        local v333 = Players.ShootEffects.Glacier1:Clone()
        local v334 = Color3.fromRGB(255, 221, 102)
        local v335 = Color3.fromRGB(64, 224, 208)
        v333.Color = ColorSequence.new(v334, v335)
        v333.Parent = Gun10.ShootPoint
        v333:Emit(1)
        game.Debris:AddItem(v333, 0.5)
        local v336 = Players.ShootEffects.Glacier2:Clone()
        local v337 = Color3.fromRGB(0, 229, 255)
        local v338 = Color3.fromRGB(0, 119, 190)
        v336.Color = ColorSequence.new(v337, v338)
        v336.Parent = Gun10.ShootPoint
        local v339 = math.random(3, 5)
        v336:Emit(v339)
        game.Debris:AddItem(v336, 0.5)
    end

    FireSound9 = Players.MuzzleLight:Clone()
    FireSound9.Color = Color3.fromRGB(0, 235, 200)
    FireSound9.Parent = Gun10.ShootPoint
    local v340 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(FireSound9, v340, {Range = 3, Brightness = 0}):Play()
    game.Debris:AddItem(FireSound9, 0.3)
    FireSound9 = Instance.new("Attachment")
    FireSound9.Parent = workspace.Baseplate
    FireSound9.WorldPosition = Gun10.ShootPoint.WorldPosition
    game.Debris:AddItem(FireSound9, 1)
    local Attachment7 = Instance.new("Attachment")
    Attachment7.Parent = workspace.Baseplate
    local v341 = CFrame.new(Origin26, Int11)
    Attachment7.WorldPosition = (v341 * CFrame.new(0, 0, -Dist10)).Position
    game.Debris:AddItem(Attachment7, 1)
    Int11 = Players.ShootEffects.GlacierBullet:Clone()
    local v342 = Color3.fromRGB(255, 221, 102)
    local v343 = ColorSequenceKeypoint.new(0, v342)
    local v344 = Color3.fromRGB(64, 224, 208)
    local v345 = ColorSequenceKeypoint.new(0.5, v344)
    local v346 = Color3.fromRGB(0, 119, 190)
    local v348 = {v343, v345, ColorSequenceKeypoint.new(1, v346)}
    Int11.Color = ColorSequence.new(v348)
    Int11.Attachment0 = FireSound9
    Int11.Attachment1 = Attachment7
    Int11.Parent = Gun10
    game.Debris:AddItem(Int11, 0.4)
    local v349 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Int11, v349, {Width0 = 0}):Play()
    local v350 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Int11, v350, {Width1 = 0}):Play()
end

t1.Halloween = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Gun11 = a0.Gun
    local FireSound10 = a0.FireSound
    local Origin27 = a0.Origin
    local Dist11 = a0.Dist
    local Int12 = a0.Int
    if a0.On == 1 then
        local v351 = {Origin = Gun11, Sound = FireSound10, Speed = 1.15 + math.random() * 0.2}
        _G.Utl.PlaySound(v351)
        local v352 = Players.ShootEffects.HalloweenMuzzle1:Clone()
        v352.Parent = Gun11.ShootPoint
        v352:Emit(5)
        game.Debris:AddItem(v352, 0.5)
        local v353 = Players.ShootEffects.HalloweenMuzzle2:Clone()
        v353.Parent = Gun11.ShootPoint
        local v354 = math.random(2, 3)
        v353:Emit(v354)
        game.Debris:AddItem(v353, 0.5)
    end

    FireSound10 = Players.MuzzleLight:Clone()
    FireSound10.Color = Color3.fromRGB(255, 130, 57)
    FireSound10.Parent = Gun11.ShootPoint
    local v355 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(FireSound10, v355, {Range = 3, Brightness = 0}):Play()
    game.Debris:AddItem(FireSound10, 0.3)
    FireSound10 = Instance.new("Attachment")
    FireSound10.Parent = workspace.Baseplate
    FireSound10.WorldPosition = Gun11.ShootPoint.WorldPosition
    game.Debris:AddItem(FireSound10, 1)
    local Attachment8 = Instance.new("Attachment")
    Attachment8.Parent = workspace.Baseplate
    local v356 = CFrame.new(Origin27, Int12)
    Attachment8.WorldPosition = (v356 * CFrame.new(0, 0, -Dist11)).Position
    game.Debris:AddItem(Attachment8, 1)
    Int12 = Players.ShootEffects.GlacierBullet:Clone()
    local v357 = Color3.fromRGB(255, 100, 11)
    Int12.Color = ColorSequence.new(v357)
    Int12.Attachment0 = FireSound10
    Int12.Attachment1 = Attachment8
    Int12.Parent = Gun11
    game.Debris:AddItem(Int12, 0.4)
    local v358 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Int12, v358, {Width0 = 0}):Play()
    local v359 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Int12, v359, {Width1 = 0}):Play()
end

t1.FlameBullet = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Gun12 = a0.Gun
    local FireSound11 = a0.FireSound
    local Origin28 = a0.Origin
    local Dist12 = a0.Dist
    local Int13 = a0.Int
    if a0.On == 1 then
        local v360 = {Origin = Gun12, Sound = FireSound11, Speed = 1.15 + math.random() * 0.2}
        _G.Utl.PlaySound(v360)
        local v361 = Players.MuzzleFlash:Clone()
        v361.Parent = Gun12.ShootPoint
        local v362 = math.random(1, 2)
        v361:Emit(v362)
        game.Debris:AddItem(v361, 0.2)
    end

    FireSound11 = Players.MuzzleLight:Clone()
    FireSound11.Color = Color3.fromRGB(255, 69, 32)
    FireSound11.Parent = Gun12.ShootPoint
    local v363 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(FireSound11, v363, {Range = 3, Brightness = 0}):Play()
    game.Debris:AddItem(FireSound11, 0.3)
    FireSound11 = Instance.new("Attachment")
    FireSound11.Parent = workspace.Baseplate
    FireSound11.WorldPosition = Gun12.ShootPoint.WorldPosition
    game.Debris:AddItem(FireSound11, 1)
    local Attachment9 = Instance.new("Attachment")
    Attachment9.Parent = workspace.Baseplate
    local v364 = CFrame.new(Origin28, Int13)
    Attachment9.WorldPosition = (v364 * CFrame.new(0, 0, -Dist12)).Position
    game.Debris:AddItem(Attachment9, 1)
    Int13 = Players.ShootEffects.FlameBullet:Clone()
    Int13.Attachment0 = FireSound11
    Int13.Attachment1 = Attachment9
    Int13.Parent = Gun12
    game.Debris:AddItem(Int13, 0.4)
    local v365 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Int13, v365, {Width0 = 0}):Play()
    local v366 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Int13, v366, {Width1 = 0}):Play()
end

t1.MeowBullet = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Gun13 = a0.Gun
    local FireSound12 = a0.FireSound
    local Origin29 = a0.Origin
    local Dist13 = a0.Dist
    local Int14 = a0.Int
    if a0.On == 1 then
        local v367 = {Origin = Gun13, Sound = FireSound12, Speed = 1.15 + math.random() * 0.2}
        _G.Utl.PlaySound(v367)
        local v368 = Players.ShootEffects.HeartMuzzle:Clone()
        v368.Parent = Gun13.ShootPoint
        v368:Emit(1)
        game.Debris:AddItem(v368, 0.3)
    end

    FireSound12 = Players.MuzzleLight:Clone()
    FireSound12.Color = Color3.fromRGB(248, 144, 255)
    FireSound12.Parent = Gun13.ShootPoint
    local v369 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(FireSound12, v369, {Range = 3, Brightness = 0}):Play()
    game.Debris:AddItem(FireSound12, 0.3)
    FireSound12 = Instance.new("Attachment")
    FireSound12.Parent = workspace.Baseplate
    FireSound12.WorldPosition = Gun13.ShootPoint.WorldPosition
    game.Debris:AddItem(FireSound12, 1)
    local Attachment10 = Instance.new("Attachment")
    Attachment10.Parent = workspace.Baseplate
    local v370 = CFrame.new(Origin29, Int14)
    Attachment10.WorldPosition = (v370 * CFrame.new(0, 0, -Dist13)).Position
    game.Debris:AddItem(Attachment10, 1)
    Int14 = Players.ShootEffects.MeowBullet:Clone()
    Int14.Attachment0 = FireSound12
    Int14.Attachment1 = Attachment10
    Int14.Parent = Gun13
    game.Debris:AddItem(Int14, 0.4)
    local v371 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Int14, v371, {Width0 = 0}):Play()
    local v372 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Int14, v372, {Width1 = 0}):Play()
end

t1.BlackSpiderBullet = function(a0) --[[ Upvalues: Players (copy), TweenService (copy) ]]
    local Gun14 = a0.Gun
    local FireSound13 = a0.FireSound
    local Origin30 = a0.Origin
    local Dist14 = a0.Dist
    local Int15 = a0.Int
    if a0.On == 1 then
        local v373 = {Origin = Gun14, Sound = FireSound13, Speed = 1.15 + math.random() * 0.2}
        _G.Utl.PlaySound(v373)
        local v374 = Players.ShootEffects.MenaceMuzzle:Clone()
        local v375 = Color3.fromRGB(18, 14, 24)
        v374.Color = ColorSequence.new(v375)
        v374.Parent = Gun14.ShootPoint
        local v376 = math.random(1, 2)
        v374:Emit(v376)
        game.Debris:AddItem(v374, 0.2)
    end

    FireSound13 = Players.MuzzleLight:Clone()
    FireSound13.Color = Color3.fromRGB(120, 60, 190)
    FireSound13.Parent = Gun14.ShootPoint
    local v377 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(FireSound13, v377, {Range = 3, Brightness = 0}):Play()
    game.Debris:AddItem(FireSound13, 0.3)
    FireSound13 = Instance.new("Part")
    FireSound13.CastShadow = false
    FireSound13.Material = Enum.Material.Neon
    FireSound13.Color = Color3.fromRGB(255, 153, 85)
    FireSound13.Transparency = 0.4
    FireSound13.CanCollide = false
    FireSound13.CanQuery = false
    FireSound13.CanTouch = false
    FireSound13.Anchored = true
    FireSound13.Size = Vector3.new(0.125, 0.125, 0.125)
    FireSound13.Name = "Bullet"
    FireSound13.Color = Color3.fromRGB(12, 10, 16)
    FireSound13.Transparency = 0
    FireSound13.Size = Vector3.new(0.125, 0.125, Dist14)
    local v378 = CFrame.new(Origin30, Int15)
    FireSound13.CFrame = v378 * CFrame.new(0, 0, -Dist14 / 2)
    FireSound13.Parent = workspace
    game.Debris:AddItem(FireSound13, 0.3)
    local v379 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(FireSound13, v379, {Transparency = 1}):Play()
end

local v380 = Color3.fromRGB(255, 72, 48)
local v381 = Color3.fromRGB(255, 158, 47)
local v382 = Color3.fromRGB(255, 207, 32)
local v384 = {v380, v381, v382, Color3.fromRGB(255, 50, 14)}
t1.FlamethrowerFire = function(a0) --[[ Upvalues: Players (copy), TweenService (copy), v384 (copy) ]]
    local Origin31 = a0.Origin
    local Dist15 = a0.Dist
    local Int16 = a0.Int
    local v385 = Players.MuzzleLight:Clone()
    v385.Parent = a0.Gun.ShootPoint
    local v386 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(v385, v386, {Range = 3, Brightness = 0}):Play()
    game.Debris:AddItem(v385, 0.3)
    v385 = Vector3.new(1, 1, 1) * (4 + math.random() * 1)
    if a0.WallBang then
        v385 = Vector3.new(0.5, 0.5, 0.5)
    end

    local v387 = 0.75 + math.random() * 0.25
    local Part7 = Instance.new("Part")
    Part7.CastShadow = false
    Part7.Material = Enum.Material.Neon
    Part7.Color = Color3.fromRGB(255, 153, 85)
    Part7.Transparency = 0.4
    Part7.CanCollide = false
    Part7.CanQuery = false
    Part7.CanTouch = false
    Part7.Anchored = true
    Part7.Size = Vector3.new(0.125, 0.125, 0.125)
    Part7.Color = v384[math.random(#v384)]
    Part7.Name = "Flame"
    Part7.Size = Vector3.new(0.25, 0.25, 0.25)
    local v388 = CFrame.new(Origin31)
    local v389 = math.random()
    Part7.CFrame = v388 * CFrame.Angles(math.random(), math.random(), v389)
    Part7.Parent = workspace
    game.Debris:AddItem(Part7, v387)
    local v390 = TweenInfo.new(v387, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v391 = CFrame.new(Origin31, Int16)
    local v392 = v391 * CFrame.new(0, 0, -Dist15 / 2)
    local v393 = math.random()
    local v394 = {
        Transparency = 1,
        CFrame = v392 * CFrame.Angles(math.random(), math.random(), v393),
        Size = v385
    }
    TweenService:Create(Part7, v390, v394):Play()
end

return t1
