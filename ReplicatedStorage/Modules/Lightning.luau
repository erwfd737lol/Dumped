-- https://lua.expert

local clock = os.clock
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Terrain = Workspace.Terrain
local Part = Instance.new("Part")

Part.TopSurface = 0
Part.BottomSurface = 0
Part.Anchored = true
Part.CanCollide = false
Part.Locked = true
Part.CastShadow = false
Part.CanTouch = false
Part.CanQuery = false
Part.Shape = "Cylinder"
Part.Name = "BoltPart"
Part.Material = Enum.Material.Neon
Part.Color = Color3.new(1, 1, 1)
Part.Transparency = 1

local v1 = require(script.Parent.PartCache:WaitForChild("PartCache")).new(Part, 1000)

v1:SetCacheParent(Terrain)

local function CubicBezier(p1, p2, p3, p4, p5) -- line: 34
    return p2 * (1 - p1) ^ 3 + p3 * 3 * p1 * (1 - p1) ^ 2 + p4 * 3 * (1 - p1) * p1 ^ 2 + p5 * p1 ^ 3
end

local function DiscretePulse(p6, p7, p8, p9, p10, p11, p12) -- line: 41
    return (math.clamp(p9 / (2 * p10) - math.abs((p6 - p7 * p8 + 0.5 * p9) / p10), p11, p12))
end

local function ExtrudeCenter(p13) -- line: 45
    return (math.exp(-5000 * (p13 - 0.5) ^ 10))
end

local function NoiseBetween(p14, p15, p16, p17, p18) -- line: 49
    return p17 + (p18 - p17) * (math.noise(p14, p15, p16) + 0.5)
end

local v6 = CFrame.lookAt(Vector3.new(), (Vector3.new(1, 0, 0))):inverse()
local t1 = {}
local t2 = {
    __type = "LightningBolt"
}

t2.__index = t2

function t2.new(p19, p20, p21) -- line: 70
    -- upvalues: clock (copy), v1 (copy), CubicBezier (copy), DiscretePulse (copy), ExtrudeCenter (copy), t1 (copy), t2 (copy)
    local self = setmetatable({}, t2)

    p21 = p21 or 30
    self.Enabled = true
    self.Attachment0 = p19
    self.Attachment1 = p20
    self.CurveSize0 = 0
    self.CurveSize1 = 0
    self.MinRadius = 0
    self.MaxRadius = 2.4
    self.Frequency = 1
    self.AnimationSpeed = 7
    self.Thickness = 1
    self.MinThicknessMultiplier = 0.2
    self.MaxThicknessMultiplier = 1
    self.MinTransparency = 0
    self.MaxTransparency = 1
    self.PulseSpeed = 2
    self.PulseLength = 1E+06
    self.FadeLength = 0.2
    self.ContractFrom = 0.5
    self.Color = Color3.new(1, 1, 1)
    self.ColorOffsetSpeed = 3
    self.SpaceCurveFunction = CubicBezier
    self.OpacityProfileFunction = DiscretePulse
    self.RadialProfileFunction = ExtrudeCenter
    self._Parts = {}

    for i = 1, p21 do
        self._Parts[i] = v1:GetPart()
    end

    self._PartsHidden = false
    self._DisabledTransparency = 1
    self._StartT = clock()
    self._RanNum = math.random() * 100
    self._RefIndex = #t1 + 1
    t1[self._RefIndex] = self

    return self
end

function t2:Destroy() -- line: 155
    -- upvalues: v1 (copy), t1 (copy)
    t1[self._RefIndex] = nil

    for i = 1, #self._Parts do
        v1:ReturnPart(self._Parts[i])
    end
end

function t2:DestroyDissipate(p24, p25) -- line: 166
    -- upvalues: clock (copy), RunService (copy)
    local v9 = p25
    local v10 = p24 or 0.2

    v9 = p25 or 0.5

    local v11 = clock()
    local MinTransparency, ContractFrom = self.MinTransparency, self.ContractFrom
    local v12 = self.ContractFrom + 1 / (#self._Parts * self.FadeLength)
    local MaxRadius, MinThicknessMultiplier = self.MaxRadius, self.MinThicknessMultiplier
    local connection

    connection = RunService.Heartbeat:Connect(function() -- line: 176
        -- upvalues: v10 (copy), v9 (ref), self (copy), v11 (copy), MinTransparency (copy), ContractFrom (copy), v12 (copy), MaxRadius (copy), MinThicknessMultiplier (copy), connection (ref), clock (copy)
        local v13 = clock() - v11

        self.MinThicknessMultiplier = MinThicknessMultiplier + (-2 - MinThicknessMultiplier) * v13 / v10

        if v13 < v10 * 0.4 then
            local v14 = v13 / (v10 * 0.4)

            self.MinTransparency = MinTransparency + (ContractFrom - MinTransparency) * v14
        elseif v13 < v10 then
            local v15 = (v13 - v10 * 0.4) / (v10 * 0.6)

            self.MinTransparency = ContractFrom + (v12 - ContractFrom) * v15
            self.MaxRadius = MaxRadius * (1 + v9 * v15)
            self.MinRadius += (self.MaxRadius - self.MinRadius) * v15
        else
            if clock() - self._StartT < (self.PulseLength + 1) / self.PulseSpeed then
                self:Destroy()
            end

            connection:Disconnect()
            connection = nil
        end
    end)
end

function t2:_UpdateGeometry(p27, p28, p29, p30, p31, p32) -- line: 204
    -- upvalues: v6 (copy)
    local v16 = 1 - self.MaxTransparency
    local v17 = 1 - self.MinTransparency
    local v18 = self.OpacityProfileFunction(p28, p29, self.PulseSpeed, self.PulseLength, self.FadeLength, v16, v17)
    local v19 = self.Thickness * p30 * v18

    if not (v19 > 0) or not v18 then
        v18 = 0
    end

    local v20 = 1 - self.ContractFrom
    local v21 = #self._Parts

    if v20 < v18 then
        p27.Size = Vector3.new((p32 - p31).Magnitude, v19, v19)
        p27.CFrame = CFrame.lookAt((p31 + p32) * 0.5, p32) * v6
        p27.Transparency = 1 - v18
    elseif v20 - 1 / (v21 * self.FadeLength) < v18 then
        local v22 = (1 - (v18 - (v20 - 1 / (v21 * self.FadeLength))) * v21 * self.FadeLength) * (if p28 < p29 * self.PulseSpeed - 0.5 * self.PulseLength then 1 else -1)

        p27.Size = Vector3.new((1 - math.abs(v22)) * (p32 - p31).Magnitude, v19, v19)
        p27.CFrame = CFrame.lookAt(p31 + (p32 - p31) * (math.max(0, v22) + (1 - math.abs(v22)) * 0.5), p32) * v6
        p27.Transparency = 1 - v18
    else
        p27.Transparency = 1
    end
end

function t2:_UpdateColor(p34, p35, p36) -- line: 250
    if typeof(self.Color) == "Color3" then
        p34.Color = self.Color
    else
        local v24 = (self._RanNum + p35 - p36 * self.ColorOffsetSpeed) % 1
        local Keypoints = self.Color.Keypoints

        for i = 1, #Keypoints - 1 do
            if Keypoints[i].Time < v24 and v24 < Keypoints[i + 1].Time then
                p34.Color = Keypoints[i].Value:lerp(Keypoints[i + 1].Value, (v24 - Keypoints[i].Time) / (Keypoints[i + 1].Time - Keypoints[i].Time))

                return
            end
        end
    end
end

function t2:_Disable() -- line: 268
    self.Enabled = false

    for _, v25 in ipairs(self._Parts) do
        v25.Transparency = self._DisabledTransparency
    end
end

RunService.Heartbeat:Connect(function() -- line: 275
    -- upvalues: clock (copy), t1 (copy)
    debug.profilebegin("LightningBolt")

    for _, v26 in pairs(t1) do
        if v26.Enabled == true then
            v26._PartsHidden = false

            local MinRadius, MaxRadius, _Parts = v26.MinRadius, v26.MaxRadius, v26._Parts
            local v27 = #_Parts
            local _RanNum, AnimationSpeed, Frequency, MinThicknessMultiplier = v26._RanNum, v26.AnimationSpeed, v26.Frequency, v26.MinThicknessMultiplier
            local MaxThicknessMultiplier = v26.MaxThicknessMultiplier
            local v28 = clock() - v26._StartT
            local SpaceCurveFunction, RadialProfileFunction = v26.SpaceCurveFunction, v26.RadialProfileFunction
            local v29 = (v26.PulseLength + 1) / v26.PulseSpeed
            local Attachment0, Attachment1, CurveSize0, CurveSize1 = v26.Attachment0, v26.Attachment1, v26.CurveSize0, v26.CurveSize1
            local WorldPosition = Attachment0.WorldPosition
            local v30 = Attachment0.WorldPosition + Attachment0.WorldAxis * CurveSize0
            local v31 = Attachment1.WorldPosition - Attachment1.WorldAxis * CurveSize1
            local WorldPosition2 = Attachment1.WorldPosition
            local v32 = SpaceCurveFunction(0, WorldPosition, v30, v31, WorldPosition2)

            if v28 < v29 then
                local v33 = v32

                for i = 1, v27 do
                    local v34 = _Parts[i]
                    local v35 = i / v27
                    local v36 = AnimationSpeed * -v28 + Frequency * 10 * v35 - 0.2 + _RanNum * 4
                    local v37 = 5 * (AnimationSpeed * 0.01 * -v28 / 10 + Frequency * v35) + _RanNum * 4
                    local v38 = 5 * v36
                    local v39 = 1 * v37
                    local v40 = 0 + 0.6283185307179586 * (math.noise(v38, 1.5, v39) + 0.5)
                    local v41 = 0.5 * v36
                    local v42 = 0.1 * v37
                    local v43 = v40 + (0 + 5.654866776461628 * (math.noise(v41, 1.5, v42) + 0.5))
                    local v44 = (MinRadius + (MaxRadius - MinRadius) * (math.noise(3.4, v37, v36) + 0.5)) * RadialProfileFunction(v35)
                    local v45 = MinThicknessMultiplier + (MaxThicknessMultiplier - MinThicknessMultiplier) * (math.noise(2.3, v37, v36) + 0.5)
                    local v46 = SpaceCurveFunction(v35, WorldPosition, v30, v31, WorldPosition2)
                    local v47 = i == v27
                    local Position = if not v47 then (CFrame.new(v33, v46) * CFrame.Angles(0, 0, v43) * CFrame.Angles(math.acos((math.clamp(6.123233995736766E-17 + 0.9999999999999999 * (math.noise(v37, v36, 2.7) + 0.5), -1, 1))), 0, 0) * CFrame.new(0, 0, -v44)).Position else nil

                    v33 = v46

                    local v51 = if v47 or not Position then v46 else Position

                    v26:_UpdateGeometry(v34, v35, v28, v45, v32, v51)
                    v26:_UpdateColor(v34, v35, v28)
                    v32 = v51
                end
            else
                v26:Destroy()
            end
        elseif v26._PartsHidden == false then
            v26._PartsHidden = true
            v26:_Disable()
        end
    end

    debug.profileend()
end)

return t2
