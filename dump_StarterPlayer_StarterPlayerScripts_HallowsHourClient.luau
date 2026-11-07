-- decompiled by Velocity decompiler v1.0.3

local Players = game:GetService("Players")
local v1 = script:GetAttribute("GhostTexture")
local LocalPlayer = Players.LocalPlayer
Players = workspace:WaitForChild("Events")
if type(v1) ~= "string" or v1 == "" then
    warn("Hallow's Hour: HallowsHourClient.GhostTexture must contain the uploaded ghost image asset ID.")
    return
end

local v2 = nil
local v3 = nil
local v4 = {}
local v5 = 0

local function stop() --[[ Upvalues: v5 (ref), v3 (ref), v4 (copy), v2 (ref) ]]
    v5 = v5 + 1
    v3 = nil
    local v6 = v4
    local v7 = nil
    local v8 = nil
    for k1, k2 in v6 do
        k2.Enabled = false
        k2:Clear()
    end

    table.clear(v4)
    if v2 then
        v2:Destroy()
        v2 = nil
    end
end

local function viewerPosition() --[[ Upvalues: LocalPlayer (copy) ]]
    local Character = LocalPlayer.Character
    local v10 = Character and Character:FindFirstChild("HumanoidRootPart")
    if v10 then
        return v10.Position
    end

    local CurrentCamera = workspace.CurrentCamera
    return CurrentCamera and CurrentCamera.CFrame.Position or nil
end

local function start(a0) --[[ Upvalues: v3 (ref), stop (copy), v5 (ref), v2 (ref), v1 (copy), v4 (copy), Players (copy), LocalPlayer (copy) ]]
    if v3 == a0 then
        return
    end

    stop()
    v3 = a0
    local v12 = v5
    local Folder = Instance.new("Folder")
    Folder.Name = "HallowsHourGhosts"
    v2 = Folder
    local v13 = {}
    for i1 = 0, 3 do
        local Part = Instance.new("Part")
        Part.Name = "GhostVolume" .. i1
        Part.Size = Vector3.new(120, 10, 120)
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanTouch = false
        Part.CanQuery = false
        Part.CastShadow = false
        Part.Transparency = 1
        Part.Parent = Folder
        table.insert(v13, Part)
        local ParticleEmitter = Instance.new("ParticleEmitter")
        ParticleEmitter.Name = "FlyingGhosts"
        ParticleEmitter.Texture = v1
        ParticleEmitter.Enabled = false
        ParticleEmitter.Rate = 0.7
        ParticleEmitter.Lifetime = NumberRange.new(10, 14)
        ParticleEmitter.Speed = NumberRange.new(5, 9)
        ParticleEmitter.Drag = 0.05
        ParticleEmitter.Acceleration = Vector3.new(0, 0.11999999731779099, 0)
        ParticleEmitter.EmissionDirection = Enum.NormalId.Front
        ParticleEmitter.SpreadAngle = Vector2.new(18, 5)
        ParticleEmitter.Orientation = Enum.ParticleOrientation.FacingCamera
        ParticleEmitter.LockedToPart = false
        ParticleEmitter.VelocityInheritance = 0
        ParticleEmitter.Rotation = NumberRange.new(-10, 10)
        ParticleEmitter.RotSpeed = NumberRange.new(-3, 3)
        ParticleEmitter.LightEmission = 0.35
        ParticleEmitter.LightInfluence = 0
        local v16 = Color3.fromRGB(207, 255, 226)
        local v17 = Color3.fromRGB(157, 221, 187)
        ParticleEmitter.Color = ColorSequence.new(v16, v17)
        local v18 = NumberSequenceKeypoint.new(0, 3.5, 0.6)
        local v19 = NumberSequenceKeypoint.new(0.3, 5.5, 1.2)
        local v20 = NumberSequenceKeypoint.new(0.8, 6, 1.3)
        v16 = {v18, v19, v20, NumberSequenceKeypoint.new(1, 7, 1.4)}
        ParticleEmitter.Size = NumberSequence.new(v16)
        local v22 = NumberSequenceKeypoint.new(0, 1)
        local v23 = NumberSequenceKeypoint.new(0.12, 0.27)
        local v24 = NumberSequenceKeypoint.new(0.7, 0.4)
        v16 = {v22, v23, v24, NumberSequenceKeypoint.new(1, 1)}
        ParticleEmitter.Transparency = NumberSequence.new(v16)
        ParticleEmitter.Parent = Part
        table.insert(v4, ParticleEmitter)
    end

    Folder.Parent = workspace
    local v26 = nil
    local v27 = false
    task.spawn(function() --[[ Upvalues: v12 (copy), v5 (upvalue), a0 (copy), Players (upvalue), LocalPlayer (upvalue), v26 (ref), v4 (upvalue), v27 (ref), v13 (copy), stop (upvalue) ]]
        while v12 == v5 and a0.Parent == Players do
            local v28 = a0:GetAttribute("EndsAt")
            if type(v28) == "number" then
                -- branch continues at 31
            end

            if v28 <= type(v28) then
                break
            end

            local Character1 = LocalPlayer.Character
            local v30 = Character1 and Character1:FindFirstChild("HumanoidRootPart")
            if v30 then
                v28 = v30.Position
            else
                local CurrentCamera1 = workspace.CurrentCamera
            end

            local v32, v33
            if v28 then
                Character1 = v26
                if Character1 then
                    Character1 = true
                    if 100 >= (v28 - v26).Magnitude then
                        v32 = v26
                        v32 = v32.Y
                        local v34 = math.abs(v28.Y - v32)
                        Character1 = 30 < v34
                    end
                end

                if Character1 then
                    v30 = v4
                    local v35 = nil
                    local v36 = nil
                    for k3, k4 in v30 do
                        k4:Clear()
                    end

                    v27 = false
                end

                v30 = v13
                local v37 = nil
                local v38 = nil
                for k5, k6 in v30 do
                    local v39 = CFrame.new(v28 + Vector3.new(0, 6, 0))
                    local v40 = (k5 - 1) * 3.1415926535897931 / 2
                    k6.CFrame = v39 * CFrame.Angles(0, v40, 0)
                end

                if not v27 then
                    local v41 = v4
                    v37 = nil
                    v38 = nil
                    for k7, k8 in v41 do
                        k8.Enabled = true
                        k8:Emit(3)
                    end

                    v27 = true
                end

                v26 = v28
            end

            task.wait(0.5)
        end

        if v12 == v5 then
            stop()
        end

    end)
end

local function refresh() --[[ Upvalues: Players (copy), start (copy), stop (copy) ]]
    local v42 = Players:FindFirstChild("Hallow's Hour")
    if v42 then
        local v43 = v42:GetAttribute("EndsAt")
        if type(v43) ~= "number" or workspace:GetServerTimeNow() < v43 then
            start(v42)
            return
        end
    end

    stop()
end

Players.ChildAdded:Connect(function(a0) --[[ Upvalues: refresh (copy) ]]
    if a0.Name == "Hallow's Hour" then
        refresh()
    end

end)
Players.ChildRemoved:Connect(function(a0) --[[ Upvalues: v3 (ref), refresh (copy) ]]
    if a0 == v3 then
        refresh()
    end

end)
script.Destroying:Connect(stop)
refresh()
