
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local ContentProvider = game:GetService("ContentProvider")
local v1 = setmetatable({}, {__mode = "k"})
task.spawn(function() --[[ Upvalues: ContentProvider (copy) ]]
    pcall(function() --[[ Upvalues: ContentProvider (upvalue) ]]
        local t1 = {"rbxassetid://85579784106924"}
        ContentProvider:PreloadAsync(t1)
    end)
end)
return function(a0) --[[ Upvalues: v1 (copy), Debris (copy), RunService (copy) ]]
    local Character = a0.Character
    local Origin = a0.Origin
    if not (Character and Origin and Origin.Parent) then
        return
    end

    if v1[Character] then
        v1[Character]()
    end

    local v4 = Character:GetAttribute("BlurDark") or Color3.fromRGB(22, 17, 24)
    local v7 = Character:GetAttribute("BlurCrimson") or Color3.fromRGB(138, 7, 22)
    local v8 = {}
    local v9 = {}

    local function add(a0, a1, a2, a3, a4) --[[ Upvalues: v9 (copy), v8 (copy) ]]
        local Attachment = Instance.new("Attachment")
        Attachment.Name = "VampireFlashstepAttachment"
        Attachment.Position = a1
        local ParticleEmitter = Instance.new("ParticleEmitter")
        ParticleEmitter.Name = "Flashstep_" .. a4
        ParticleEmitter.Texture = "rbxassetid://85579784106924"
        ParticleEmitter.Enabled = false
        ParticleEmitter.Rate = 0
        ParticleEmitter.Lifetime = NumberRange.new(0.34)
        ParticleEmitter.Speed = NumberRange.new(0)
        ParticleEmitter.VelocityInheritance = 0
        ParticleEmitter.LockedToPart = false
        ParticleEmitter.Orientation = Enum.ParticleOrientation.FacingCameraWorldUp
        ParticleEmitter.Rotation = NumberRange.new(0)
        ParticleEmitter.RotSpeed = NumberRange.new(0)
        ParticleEmitter.LightEmission = 0
        ParticleEmitter.LightInfluence = 0
        ParticleEmitter.Color = ColorSequence.new(a2)
        local v10 = NumberSequenceKeypoint.new(0, a3)
        local v11 = NumberSequenceKeypoint.new(0.25, a3 * 1.05)
        local v13 = {v10, v11, NumberSequenceKeypoint.new(1, a3 * 0.8)}
        ParticleEmitter.Size = NumberSequence.new(v13)
        local v14 = NumberSequenceKeypoint.new(0, 0)
        local v15 = NumberSequenceKeypoint.new(0.2, 0.3)
        v13 = {v14, v15, NumberSequenceKeypoint.new(1, 2.5)}
        ParticleEmitter.Squash = NumberSequence.new(v13)
        local v17 = NumberSequenceKeypoint.new(0, 0.05)
        local v18 = NumberSequenceKeypoint.new(0.2, 0.15)
        v13 = {v17, v18, NumberSequenceKeypoint.new(1, 1)}
        ParticleEmitter.Transparency = NumberSequence.new(v13)
        ParticleEmitter.Parent = Attachment
        Attachment.Parent = a0
        table.insert(v9, Attachment)
        table.insert(v8, ParticleEmitter)
    end

    local v20 = Character:GetChildren()
    for k1, k2 in ipairs(v20) do
        if k2:IsA("BasePart") then
            if k2 ~= Origin then
                if k2.Transparency < 1 then
                    local v24 = true
                    if k2.Name ~= "Head" then
                        v24 = k2.Name:find("Hand", 1, true) ~= nil
                    end

                    local v25 = math.max(k2.Size.X, k2.Size.Y) * 1.15
                    local v26 = math.clamp(v25, 0.85, 2.3)
                    add(k2, Vector3.new(0, 0, 0), v24 and k2.Color or v4, v26, k2.Name)
                end
            end
        end
    end

    local v28 = false
    local v29 = Character:GetChildren()
    for k3, k4 in ipairs(v29) do
        if k4:IsA("Accessory") then
            local Handle = k4:FindFirstChild("Handle")
            if Handle then
                if Handle:IsA("BasePart") then
                    if Handle:FindFirstChild("BodyBackAttachment") then
                        v28 = true
                    else
                        if Handle:FindFirstChild("HairAttachment") or k4.Name:lower():find("hair", 1, true) then
                            add(Handle, Vector3.new(0, 0.20000000298023224, 0), v4, 1.5, "Hair")
                            -- jump to 195 (out of range)
                        end

                        add(Handle, Vector3.new(0, 0, 0), Handle.Color, 1, "Accessory")
                    end
                end
            end
        end
    end

    if v28 then
        k4 = "LowerTorso"
        local v33 = {"UpperTorso", k4, "LeftUpperLeg", "RightUpperLeg"}
        for k5, k6 in ipairs(v33) do
            local v37 = Character:FindFirstChild(k6)
            if v37 then
                local v38 = 1
                local v39 = {-1, v38}
                for k7, k8 in ipairs(v39) do
                    local v43 = k8 * v37.Size.X * 0.52
                    local v44 = Vector3.new(v43, 0, v37.Size.Z * 0.55)
                    add(v37, v44, v7, 1.35, "CapeRed")
                end

                local v45 = Vector3.new(0, 0, v37.Size.Z * 0.7)
                add(v37, v45, v4, 1.6, "CapeBlack")
            end
        end
    end

    local v47 = a0.StartTime or workspace:GetServerTimeNow()
    add = a0.Duration or 2.5
    local v48 = math.max(0, math.floor((workspace:GetServerTimeNow() - v47) / 0.4))
    local v49 = nil
    local v50 = nil

    local function finish() --[[ Upvalues: v49 (ref), v50 (ref), v1 (upvalue), Character (copy), finish (copy), v9 (copy), Debris (upvalue) ]]
        if v49 then
            return
        end

        v49 = true
        if v50 then
            v50:Disconnect()
        end

        local v51 = v1[Character]
        if v51 == finish then
            v1[Character] = nil
        end

        for k9, k10 in ipairs(v9) do
            Debris:AddItem(k10, 0.39)
        end
    end

    v1[Character] = finish

    local function update() --[[ Upvalues: v47 (copy), Character (copy), Origin (copy), add (copy), finish (copy), v48 (ref), v8 (copy) ]]
        local v55 = workspace:GetServerTimeNow()
        local v56 = v55 - v47
        local v57 = Character:FindFirstChildOfClass("Humanoid")
        if not Character.Parent then
            finish()
            return
        end

        if not Origin.Parent then
            finish()
            return
        end

        if not v57 then
            finish()
            return
        end

        if v57.Health <= 0 then
            finish()
            return
        end

        if add <= v56 then
            finish()
            return
        end

        if 0.15 < v56 then
            if not Character:GetAttribute("VampireBurst") then
                finish()
                return
            end
        end

        if v48 * 0.4 <= v56 then
            for k11, k12 in ipairs(v8) do
                if k12.Parent then
                    k12:Emit(1)
                end
            end

            v48 = math.floor(v56 / 0.4) + 1
            local v61 = {
                Sound = "WooshBurst",
                Origin = Origin,
                Speed = 1.5 + math.random() * 0.1
            }
            _G.Utl.PlaySound(v61)
        end
    end

    v50 = RunService.RenderStepped:Connect(update)
    update()
end
