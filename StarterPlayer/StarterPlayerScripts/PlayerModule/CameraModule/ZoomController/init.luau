
local Popper = script:WaitForChild("Popper")
local v1 = require(Popper)
Popper = math.clamp
local LocalPlayer = game:GetService("Players").LocalPlayer
assert(LocalPlayer)
local v2 = nil
local v3 = nil

local function updateBounds() --[[ Upvalues: v2 (ref), LocalPlayer (copy), v3 (ref) ]]
    v2 = LocalPlayer.CameraMinZoomDistance
    v3 = LocalPlayer.CameraMaxZoomDistance
end

v2 = LocalPlayer.CameraMinZoomDistance
v3 = LocalPlayer.CameraMaxZoomDistance
local v4 = LocalPlayer:GetPropertyChangedSignal("CameraMinZoomDistance")
v4:Connect(updateBounds)
local v5 = LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance")
v5:Connect(updateBounds)
LocalPlayer = {}
LocalPlayer.__index = LocalPlayer

local function new(a0, a1, a2, a3) --[[ Upvalues: Popper (copy), LocalPlayer (copy) ]]
    a1 = Popper(a1, a2, a3)
    local v6 = {v = 0, freq = a0, x = a1, minValue = a2, maxValue = a3, goal = a1}
    return setmetatable(v6, LocalPlayer)
end

LocalPlayer.new = new
local exp = math.exp

local function Step(a0, a1) --[[ Upvalues: exp (copy) ]]
    local v7 = a0.freq * 2 * 3.1415926535897931
    local v8 = a0.v
    local minValue = a0.minValue
    local maxValue = a0.maxValue
    local goal = a0.goal
    local v9 = goal - a0.x
    local v10 = v7 * a1
    local v11 = exp(-v10)
    local v12 = goal + (v8 * a1 - v9 * (v10 + 1)) * v11
    goal = ((v9 * v7 - v8) * v10 + v8) * v11
    if v12 < minValue then
        v12 = minValue
        goal = 0
    else
        if maxValue < v12 then
            v12 = maxValue
            goal = 0
        end
    end

    a0.x = v12
    a0.v = goal
    return v12
end

LocalPlayer.Step = Step
local v13 = LocalPlayer.new(4.5, 12.5, 0.5, v3)

local function stepTargetZoom(a0, a1, a2, a3) --[[ Upvalues: Popper (copy) ]]
    local v14 = a0 + a1 * (a0 * 0.0375 + 1)
    a0 = Popper(v14, a2, a3)
    if a0 < 1 then
        a0 = a1 <= 0 and a2 or 1
    end

    return a0
end

local v17 = 0
local max = math.max
local min = math.min

local function Update(a0, a1, a2) --[[ Upvalues: v13 (copy), v17 (ref), v2 (ref), v3 (ref), Popper (copy), max (copy), v1 (copy), min (copy) ]]
    local v18 = math.huge
    if 1 < v13.goal then
        local x = v13.x
        local goal1 = v13.goal
        local v19 = v17
        local v20 = v2
        local v21 = goal1 + v19 * (goal1 * 0.0375 + 1)
        goal1 = Popper(v21, v20, v3)
        if goal1 < 1 then
            goal1 = v19 <= 0 and v20 or 1
        end

        local v24 = max(x, goal1)
        goal1 = a1 * CFrame.new(0, 0, 0.5)
        v18 = v1(goal1, v24 - 0.5, a2) + 0.5
    end

    v13.minValue = 0.5
    v13.maxValue = min(v3, v18)
    local v25 = v13:Step(a0)
    return v25
end

local function GetZoomRadius() --[[ Upvalues: v13 (copy) ]]
    return v13.x
end

local function SetZoomParameters(a0, a1) --[[ Upvalues: v13 (copy), v17 (ref) ]]
    v13.goal = a0
    v17 = a1
end

local function ReleaseSpring() --[[ Upvalues: v13 (copy) ]]
    v13.x = v13.goal
    v13.v = 0
end

local v26 = {
    Update = Update,
    GetZoomRadius = GetZoomRadius,
    SetZoomParameters = SetZoomParameters,
    ReleaseSpring = ReleaseSpring
}
return v26
