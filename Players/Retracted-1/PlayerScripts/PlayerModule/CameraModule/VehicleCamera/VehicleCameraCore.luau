
local v1 = require(script.Parent.Parent.CameraUtils)
local v2 = require(script.Parent.VehicleCameraConfig)
local map = v1.map
local mapClamp = v1.mapClamp
local sanitizeAngle = v1.sanitizeAngle

local function getYaw(a0) --[[ Upvalues: sanitizeAngle (copy) ]]
    local v3, v4 = a0:toEulerAnglesYXZ()
    local v5 = sanitizeAngle(v4)
    return v5
end

local function getPitch(a0) --[[ Upvalues: sanitizeAngle (copy) ]]
    local v6 = a0:toEulerAnglesYXZ()
    local v7 = sanitizeAngle(v6)
    return v7
end

local function stepSpringAxis(a0, a1, a2, a3, a4) --[[ Upvalues: sanitizeAngle (copy) ]]
    local v8 = sanitizeAngle(a3 - a2)
    local v9 = math.exp(-a1 * a0)
    local v10 = v8 * (1 + a1 * a0)
    local v11 = sanitizeAngle((v10 + a4 * a0) * v9 + a2)
    local v12 = a4 * (1 - a1 * a0)
    return v11, (v12 - v8 * (a1 * a1 * a0)) * v9
end

local t1 = {}
t1.__index = t1

local function new(a0, a1, a2) --[[ Upvalues: t1 (copy) ]]
    local t2 = {fRising = a0, fFalling = a1, g = a2, p = a2, v = a2 * 0}
    return setmetatable(t2, t1)
end

t1.new = new

local function step(a0, a1)
    local g = a0.g
    local v13 = a0.v
    local v14 = 6.2831853071795862 * (0 < v13 and a0.fRising or a0.fFalling)
    local v15 = a0.p - g
    local v16 = math.exp(-v14 * a1)
    local v17 = v15 * (1 + v14 * a1)
    local v18 = (v17 + v13 * a1) * v16 + g
    local v19 = v13 * (1 - v14 * a1)
    a0.p = v18
    a0.v = (v19 - v15 * (v14 * v14 * a1)) * v16
    return v18
end

t1.step = step
step = {}
step.__index = step

local function new1(a0) --[[ Upvalues: sanitizeAngle (copy), t1 (copy), v2 (copy), step (copy) ]]
    assert(typeof(a0) == "CFrame")
    local v20, v21 = a0:toEulerAnglesYXZ()
    local v22, v23 = a0:toEulerAnglesYXZ()
    local v24 = a0:toEulerAnglesYXZ()
    local v25 = a0:toEulerAnglesYXZ()
    local v26 = {
        yawV = 0,
        pitchV = 0,
        yawG = sanitizeAngle(v21),
        yawP = sanitizeAngle(v23),
        pitchG = sanitizeAngle(v24),
        pitchP = sanitizeAngle(v25),
        fSpringYaw = t1.new(v2.yawReponseDampingRising, v2.yawResponseDampingFalling, 0),
        fSpringPitch = t1.new(v2.pitchReponseDampingRising, v2.pitchResponseDampingFalling, 0)
    }
    return setmetatable(v26, step)
end

step.new = new1

local function setGoal(a0, a1) --[[ Upvalues: sanitizeAngle (copy) ]]
    assert(typeof(a1) == "CFrame")
    local v27, v28 = a1:toEulerAnglesYXZ()
    a0.yawG = sanitizeAngle(v28)
    local v29 = a1:toEulerAnglesYXZ()
    a0.pitchG = sanitizeAngle(v29)
end

step.setGoal = setGoal

local function getCFrame(a0)
    local v30 = CFrame.fromEulerAnglesYXZ(a0.pitchP, a0.yawP, 0)
    return v30
end

step.getCFrame = getCFrame

local function step1(a0, a1, a2, a3, a4) --[[ Upvalues: mapClamp (copy), map (copy), v2 (copy), sanitizeAngle (copy) ]]
    assert(typeof(a1) == "number")
    assert(typeof(a3) == "number")
    assert(typeof(a2) == "number")
    assert(typeof(a4) == "number")
    local fSpringYaw = a0.fSpringYaw
    local fSpringPitch = a0.fSpringPitch
    local v31 = map(a4, 0, 1, a3, 0)
    local v32 = math.rad(v2.cutoffMinAngularVelYaw)
    local v33 = math.rad(v2.cutoffMaxAngularVelYaw)
    fSpringYaw.g = mapClamp(v31, v32, v33, 1, 0)
    local v34 = map(a4, 0, 1, a2, 0)
    local v35 = math.rad(v2.cutoffMinAngularVelPitch)
    local v36 = math.rad(v2.cutoffMaxAngularVelPitch)
    fSpringPitch.g = mapClamp(v34, v35, v36, 1, 0)
    v34 = 6.2831853071795862 * v2.yawStiffness
    local v37 = v34 * fSpringYaw:step(a1)
    v34 = 6.2831853071795862 * v2.pitchStiffness
    fSpringYaw = v34 * fSpringPitch:step(a1)
    fSpringYaw = fSpringYaw * map(a4, 0, 1, 1, v2.firstPersonResponseMul)
    v37 = v37 * map(a4, 0, 1, 1, v2.firstPersonResponseMul)
    local yawG = a0.yawG
    local yawV = a0.yawV
    fSpringPitch = sanitizeAngle(a0.yawP - yawG)
    local v38 = math.exp(-v37 * a1)
    local v39 = fSpringPitch * (1 + v37 * a1)
    local v40 = sanitizeAngle((v39 + yawV * a1) * v38 + yawG)
    local v41 = yawV * (1 - v37 * a1)
    a0.yawP = v40
    a0.yawV = (v41 - fSpringPitch * (v37 * v37 * a1)) * v38
    yawG = a0.pitchG
    yawV = a0.pitchV
    v37 = sanitizeAngle(a0.pitchP - yawG)
    local v42 = math.exp(-fSpringYaw * a1)
    local v43 = v37 * (1 + fSpringYaw * a1)
    local v44 = sanitizeAngle((v43 + yawV * a1) * v42 + yawG)
    local v45 = yawV * (1 - fSpringYaw * a1)
    a0.pitchP = v44
    a0.pitchV = (v45 - v37 * (fSpringYaw * fSpringYaw * a1)) * v42
    local v46 = a0:getCFrame()
    return v46
end

step.step = step1
step1 = {}
step1.__index = step1

local function new2(a0) --[[ Upvalues: step (copy), step1 (copy) ]]
    local t3 = {vrs = step.new(a0)}
    return setmetatable(t3, step1)
end

step1.new = new2

local function step2(a0, a1, a2, a3, a4)
    local v47 = a0.vrs:step(a1, a2, a3, a4)
    return v47
end

step1.step = step2

local function setTransform(a0, a1)
    a0.vrs:setGoal(a1)
end

step1.setTransform = setTransform
return step1
