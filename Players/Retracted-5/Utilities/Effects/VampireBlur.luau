-- https://lua.expert

local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local ContentProvider = game:GetService("ContentProvider")
local self = setmetatable({}, {
    __mode = "k"
})

task.spawn(function() -- line: 10
    -- upvalues: ContentProvider (copy)
    local function v2() -- line: 10
        -- upvalues: ContentProvider (copy)
        ContentProvider:PreloadAsync({
            "rbxassetid://85579784106924"
        })
    end

    pcall(v2)
end)

return function(p1) -- line: 12
    -- upvalues: RunService (copy), Debris (copy), self (copy)
    local Character, Origin = p1.Character, p1.Origin

    if not (Character and Origin and Origin.Parent) then
        return
    end

    if self[Character] then
        self[Character]()
    end

    local v3 = Character:GetAttribute("BlurDark") or Color3.fromRGB(22, 17, 24)
    local v4 = Character:GetAttribute("BlurCrimson") or Color3.fromRGB(138, 7, 22)
    local t3 = {}
    local t4 = {}

    local function add(p2, p3, p4, p5, p6) -- line: 19
        -- upvalues: t3 (copy), t4 (copy)
        local Attachment = Instance.new("Attachment")

        Attachment.Name = "VampireFlashstepAttachment"
        Attachment.Position = p3

        local ParticleEmitter = Instance.new("ParticleEmitter")

        ParticleEmitter.Name = "Flashstep_" .. p6
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
        ParticleEmitter.Color = ColorSequence.new(p4)
        ParticleEmitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, p5),
            NumberSequenceKeypoint.new(0.25, p5 * 1.05),
            NumberSequenceKeypoint.new(1, p5 * 0.8)
        })
        ParticleEmitter.Squash = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.2, 0.3),
            NumberSequenceKeypoint.new(1, 2.5)
        })
        ParticleEmitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.05),
            NumberSequenceKeypoint.new(0.2, 0.15),
            NumberSequenceKeypoint.new(1, 1)
        })
        ParticleEmitter.Parent = Attachment
        Attachment.Parent = p2
        table.insert(t4, Attachment)
        table.insert(t3, ParticleEmitter)
    end

    for _, child in ipairs(Character:GetChildren()) do
        if child:IsA("BasePart") and child ~= Origin and child.Transparency < 1 then
            local v5 = child.Name == "Head" or child.Name:find("Hand", 1, true) ~= nil
            local v7 = math.clamp(math.max(child.Size.X, child.Size.Y) * 1.15, 0.85, 2.3)

            add(child, Vector3.new(0, 0, 0), v5 and child.Color or v3, v7, child.Name)
        end
    end

    local v8 = false

    for _, child in ipairs(Character:GetChildren()) do
        if child:IsA("Accessory") then
            local Handle = child:FindFirstChild("Handle")

            if Handle and Handle:IsA("BasePart") then
                if Handle:FindFirstChild("BodyBackAttachment") then
                    v8 = true
                elseif Handle:FindFirstChild("HairAttachment") or child.Name:lower():find("hair", 1, true) then
                    add(Handle, Vector3.new(0, 0.2, 0), v3, 1.5, "Hair")
                else
                    add(Handle, Vector3.new(0, 0, 0), Handle.Color, 1, "Accessory")
                end
            end
        end
    end

    if v8 then
        for _, v9 in ipairs({ "UpperTorso", "LowerTorso", "LeftUpperLeg", "RightUpperLeg" }) do
            local v10 = Character:FindFirstChild(v9)

            if v10 then
                for _, v11 in ipairs({ -1, 1 }) do
                    add(v10, Vector3.new(v11 * v10.Size.X * 0.52, 0, v10.Size.Z * 0.55), v4, 1.35, "CapeRed")
                end

                add(v10, Vector3.new(0, 0, v10.Size.Z * 0.7), v3, 1.6, "CapeBlack")
            end
        end
    end

    local v15 = p1.StartTime or workspace:GetServerTimeNow()
    local v16 = p1.Duration or 2.5
    local v19 = math.max(0, (math.floor((workspace:GetServerTimeNow() - v15) / 0.4)))
    local connection, v20, finish

    local function finish2() -- line: 101
        -- upvalues: Character (copy), t4 (copy), connection (ref), v20 (ref), finish (ref), Debris (copy), self (copy)
        if v20 then
            return
        end

        v20 = true

        if connection then
            connection:Disconnect()
        end

        if self[Character] == finish then
            self[Character] = nil
        end

        for _, v21 in ipairs(t4) do
            Debris:AddItem(v21, 0.39)
        end
    end

    finish = finish2
    self[Character] = finish2

    local function update() -- line: 109
        -- upvalues: Character (copy), Origin (copy), t3 (copy), v16 (copy), v15 (copy), v19 (ref), finish2 (copy)
        local v22 = workspace:GetServerTimeNow() - v15
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if not Character.Parent
            or not Origin.Parent
            or not Humanoid
            or Humanoid.Health <= 0
            or v16 <= v22
            or v22 > 0.15 and not Character:GetAttribute("VampireBurst") then
            finish2()

            return
        end

        if v19 * 0.4 <= v22 then
            for _, v23 in ipairs(t3) do
                if v23.Parent then
                    v23:Emit(1)
                end
            end

            v19 = math.floor(v22 / 0.4) + 1
            _G.Utl.PlaySound({
                Sound = "WooshBurst",
                Origin = Origin,
                Speed = 1.5 + math.random() * 0.1
            })
        end
    end

    connection = RunService.RenderStepped:Connect(update)
    update()
end
