
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local function round(a0)
    return math.floor(a0 + 0.5)
end

local t1 = {}
local v1 = {}
t1.__index = t1

local function new(a0, a1) --[[ Upvalues: t1 (copy) ]]
    local t2 = {vel = 0, freq = a0, goal = a1, pos = a1}
    return setmetatable(t2, t1)
end

t1.new = new

local function step(a0, a1)
    local v2 = a0.freq * 2 * 3.1415926535897931
    local goal = a0.goal
    local vel = a0.vel
    local v3 = a0.pos - goal
    local v4 = math.exp(-v2 * a1)
    local v5 = v3 * (v2 * a1 + 1)
    local v6 = (v5 + vel * a1) * v4 + goal
    local v7 = vel * (1 - v2 * a1)
    a0.pos = v6
    a0.vel = (v7 - v3 * (v2 * v2 * a1)) * v4
    return v6
end

t1.step = step
v1.Spring = t1

local function map(a0, a1, a2, a3, a4)
    local v8 = (a0 - a1) * (a4 - a3)
    return v8 / (a2 - a1) + a3
end

v1.map = map

local function mapClamp(a0, a1, a2, a3, a4)
    local v9 = (a0 - a1) * (a4 - a3)
    local v10 = v9 / (a2 - a1) + a3
    local v11 = math.min(a3, a4)
    return math.clamp(v10, v11, math.max(a3, a4))
end

v1.mapClamp = mapClamp

local function getLooseBoundingSphere(a0)
    local v12 = table.create(#a0)
    for k1, k2 in pairs(a0) do
        v12[k1] = k2.Position
    end

    local v16 = v12[1]
    local v17 = v16
    local v18 = 0
    local v22
    for k3, k4 in ipairs(v12) do
        v22 = (k4 - v16).Magnitude
        if v18 < v22 then
            v17 = k4
            v18 = v22
        end
    end

    v18 = v17
    v16 = 0
    for k5, k6 in ipairs(v12) do
        v22 = (k6 - v17).Magnitude
        if v16 < v22 then
            v18 = k6
            v16 = v22
        end
    end

    v16 = (v17 + v18) * 0.5
    local v26 = (v17 - v18).Magnitude * 0.5
    for k7, k8 in ipairs(v12) do
        local Magnitude = (k8 - v16).Magnitude
        if v26 < Magnitude then
            local v30 = (Magnitude - v26) * 0.5
            v16 = v16 + v30 * (k8 - v16).Unit
            v26 = (Magnitude + v26) * 0.5
        end
    end

    return v16, v26
end

v1.getLooseBoundingSphere = getLooseBoundingSphere

local function sanitizeAngle(a0)
    return (a0 + 3.1415926535897931) % 6.2831853071795862 - 3.1415926535897931
end

v1.sanitizeAngle = sanitizeAngle

local function Round(a0, a1)
    local v31 = 10 ^ a1
    return math.floor(a0 * v31 + 0.5) / v31
end

v1.Round = Round

local function IsFinite(a0)
    local v32 = false
    if a0 == a0 then
        v32 = false
        if a0 ~= math.huge then
            v32 = a0 ~= -math.huge
        end
    end

    return v32
end

v1.IsFinite = IsFinite

local function IsFiniteVector3(a0) --[[ Upvalues: v1 (copy) ]]
    local v36 = v1.IsFinite(a0.X) and v1.IsFinite(a0.Y) and v1.IsFinite(a0.Z)
    return v36
end

v1.IsFiniteVector3 = IsFiniteVector3

local function GetAngleBetweenXZVectors(a0, a1)
    local v37 = a1.X * a0.Z
    local v38 = v37 - a1.Z * a0.X
    local v39 = a1.X * a0.X
    return math.atan2(v38, v39 + a1.Z * a0.Z)
end

v1.GetAngleBetweenXZVectors = GetAngleBetweenXZVectors

local function RotateVectorByAngleAndRound(a0, a1, a2)
    if 0 < a0.Magnitude then
        a0 = a0.Unit
        local v40 = math.atan2(a0.Z, a0.X)
        return math.floor((math.atan2(a0.Z, a0.X) + a1) / a2 + 0.5) * a2 - v40
    end

    return 0
end

v1.RotateVectorByAngleAndRound = RotateVectorByAngleAndRound

local function SCurveTranform(a0)
    a0 = math.clamp(a0, -1, 1)
    if 0 <= a0 then
        return a0 * 0.35 / (0.35 - a0 + 1)
    end

    local v41 = -a0 * 0.8
    return -(v41 / (a0 + 0.8 + 1))
end

local function toSCurveSpace(a0)
    return (math.abs(a0) * 2 - 1) * 1.1 - 0.1
end

local function fromSCurveSpace(a0)
    return a0 / 2 + 0.5
end

local function GamepadLinearToCurve(a0)

    local function onAxis(a0)
        local v42 = 1
        if a0 < 0 then
            v42 = -1
        end

        local v43 = math.clamp((math.abs(math.abs(a0)) * 2 - 1) * 1.1 - 0.1, -1, 1)
        local v44
        if 0 <= v43 then
            v44 = v43 * 0.35 / (0.35 - v43 + 1)
        else
            local v45 = -v43 * 0.8
            v44 = -(v45 / (v43 + 0.8 + 1))
        end

        return math.clamp((v44 / 2 + 0.5) * v42, -1, 1)
    end

    local new1 = Vector2.new
    local X = a0.X
    local v46 = 1
    if X < 0 then
        v46 = -1
    end

    local v47 = math.clamp((math.abs(math.abs(X)) * 2 - 1) * 1.1 - 0.1, -1, 1)
    local v48
    if 0 <= v47 then
        v48 = v47 * 0.35 / (0.35 - v47 + 1)
    else
        local v49 = -v47 * 0.8
        v48 = -(v49 / (v47 + 0.8 + 1))
    end

    local v50 = math.clamp((v48 / 2 + 0.5) * v46, -1, 1)
    v46 = a0.Y
    local v51 = 1
    if v46 < 0 then
        v51 = -1
    end

    local v52 = math.clamp((math.abs(math.abs(v46)) * 2 - 1) * 1.1 - 0.1, -1, 1)
    local v53
    if 0 <= v52 then
        v53 = v52 * 0.35 / (0.35 - v52 + 1)
    else
        local v54 = -v52 * 0.8
        v53 = -(v54 / (v52 + 0.8 + 1))
    end

    local v55 = new1(v50, math.clamp((v53 / 2 + 0.5) * v51, -1, 1))
    return v55
end

v1.GamepadLinearToCurve = GamepadLinearToCurve

local function ConvertCameraModeEnumToStandard(a0)
    if a0 == Enum.TouchCameraMovementMode.Default then
        return Enum.ComputerCameraMovementMode.Follow
    end

    if a0 == Enum.ComputerCameraMovementMode.Default then
        return Enum.ComputerCameraMovementMode.Classic
    end

    if a0 == Enum.TouchCameraMovementMode.Classic or a0 == Enum.DevTouchCameraMovementMode.Classic or a0 == Enum.DevComputerCameraMovementMode.Classic or a0 == Enum.ComputerCameraMovementMode.Classic then
        return Enum.ComputerCameraMovementMode.Classic
    end

    if a0 == Enum.TouchCameraMovementMode.Follow or a0 == Enum.DevTouchCameraMovementMode.Follow or a0 == Enum.DevComputerCameraMovementMode.Follow or a0 == Enum.ComputerCameraMovementMode.Follow then
        return Enum.ComputerCameraMovementMode.Follow
    end

    if a0 == Enum.TouchCameraMovementMode.Orbital or a0 == Enum.DevTouchCameraMovementMode.Orbital or a0 == Enum.DevComputerCameraMovementMode.Orbital or a0 == Enum.ComputerCameraMovementMode.Orbital then
        return Enum.ComputerCameraMovementMode.Orbital
    end

    if a0 == Enum.ComputerCameraMovementMode.CameraToggle or a0 == Enum.DevComputerCameraMovementMode.CameraToggle then
        return Enum.ComputerCameraMovementMode.CameraToggle
    end

    if a0 == Enum.DevTouchCameraMovementMode.UserChoice or a0 == Enum.DevComputerCameraMovementMode.UserChoice then
        return Enum.DevComputerCameraMovementMode.UserChoice
    end

    return Enum.ComputerCameraMovementMode.Classic
end

v1.ConvertCameraModeEnumToStandard = ConvertCameraModeEnumToStandard

local function getMouse() --[[ Upvalues: Players (copy) ]]
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    local LocalPlayer1 = Players.LocalPlayer
    local v56 = Players.LocalPlayer or LocalPlayer1
    assert(v56)
    local v57 = v56:GetMouse()
    return v57
end

local v58 = ""
local v59 = nil

local function setMouseIconOverride(a0) --[[ Upvalues: Players (copy), v59 (ref), v58 (ref) ]]
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    local LocalPlayer3 = Players.LocalPlayer
    local v60 = Players.LocalPlayer or LocalPlayer3
    assert(v60)
    local v61 = v60:GetMouse()
    if v61.Icon ~= v59 then
        v58 = v61.Icon
    end

    v61.Icon = a0
    v59 = a0
end

v1.setMouseIconOverride = setMouseIconOverride

local function restoreMouseIcon() --[[ Upvalues: Players (copy), v59 (ref), v58 (ref) ]]
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    local LocalPlayer5 = Players.LocalPlayer
    local v62 = Players.LocalPlayer or LocalPlayer5
    assert(v62)
    local v63 = v62:GetMouse()
    if v63.Icon == v59 then
        v63.Icon = v58
    end

    v59 = nil
end

v1.restoreMouseIcon = restoreMouseIcon
restoreMouseIcon = Enum.MouseBehavior.Default
local v64 = nil

local function setMouseBehaviorOverride(a0) --[[ Upvalues: UserInputService (copy), v64 (ref), restoreMouseIcon (ref) ]]
    if UserInputService.MouseBehavior ~= v64 then
        restoreMouseIcon = UserInputService.MouseBehavior
    end

    UserInputService.MouseBehavior = a0
    v64 = a0
end

v1.setMouseBehaviorOverride = setMouseBehaviorOverride

local function restoreMouseBehavior() --[[ Upvalues: UserInputService (copy), v64 (ref), restoreMouseIcon (ref) ]]
    if UserInputService.MouseBehavior == v64 then
        UserInputService.MouseBehavior = restoreMouseIcon
    end

    v64 = nil
end

v1.restoreMouseBehavior = restoreMouseBehavior
restoreMouseBehavior = Enum.RotationType.MovementRelative
local v65 = nil

local function setRotationTypeOverride(a0) --[[ Upvalues: UserGameSettings (copy), v65 (ref), restoreMouseBehavior (ref) ]]
    if UserGameSettings.RotationType ~= v65 then
        restoreMouseBehavior = UserGameSettings.RotationType
    end

    UserGameSettings.RotationType = a0
    v65 = a0
end

v1.setRotationTypeOverride = setRotationTypeOverride

local function restoreRotationType() --[[ Upvalues: UserGameSettings (copy), v65 (ref), restoreMouseBehavior (ref) ]]
    if UserGameSettings.RotationType == v65 then
        UserGameSettings.RotationType = restoreMouseBehavior
    end

    v65 = nil
end

v1.restoreRotationType = restoreRotationType
return v1
