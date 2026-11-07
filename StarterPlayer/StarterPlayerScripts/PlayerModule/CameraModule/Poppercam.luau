
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
local v1 = require(FlagUtil)
local ZoomController = script.Parent:WaitForChild("ZoomController")
CommonUtils = require(ZoomController)
local v2 = v1.getUserFlag("UserFixCameraFPError")
v1 = {}
v1.__index = v1
local v3 = CFrame.new()

local function cframeToAxis(a0)
    local v4, v5 = a0:ToAxisAngle()
    return v4 * v5
end

local function axisToCFrame(a0) --[[ Upvalues: v3 (copy) ]]
    local Magnitude = a0.Magnitude
    if 1e-05 < Magnitude then
        local v6 = CFrame.fromAxisAngle(a0, Magnitude)
        return v6
    end

    return v3
end

local function extractRotation(a0)
    local v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18 = a0:GetComponents()
    local v19 = CFrame.new(0, 0, 0, v10, v11, v12, v13, v14, v15, v16, v17, v18)
    return v19
end

local function new() --[[ Upvalues: v1 (copy) ]]
    return setmetatable({lastCFrame = nil}, v1)
end

v1.new = new

local function Step(a0, a1, a2) --[[ Upvalues: v3 (copy) ]]
    local v20 = a0.lastCFrame or a2
    a0.lastCFrame = a2
    local Position = a2.Position
    local v21, v22, v23, v24, v25, v26, v27, v28, v29, v30, v31, v32 = a2:GetComponents()
    local v33 = CFrame.new(0, 0, 0, v24, v25, v26, v27, v28, v29, v30, v31, v32)
    local v34, v35, v36, v37, v38, v39, v40, v41, v42, v43, v44, v45 = v20:GetComponents()
    v20 = (Position - v20.p) / a1
    local v46, v47 = (v33 * CFrame.new(0, 0, 0, v37, v38, v39, v40, v41, v42, v43, v44, v45):inverse()):ToAxisAngle()
    local v48 = v46 * v47 / a1

    local function extrapolate(a0) --[[ Upvalues: v20 (copy), Position (copy), v48 (copy), v3 (upvalue), v33 (copy) ]]
        local v49 = v20 * a0
        local v50 = v49 + Position
        local v51 = v48 * a0
        local Magnitude1 = v51.Magnitude
        local v52
        if 1e-05 < Magnitude1 then
            v52 = CFrame.fromAxisAngle(v51, Magnitude1)
        else
            v52 = v3
        end

        return v52 * v33 + v50
    end

    local v53 = {extrapolate = extrapolate, posVelocity = v20, rotVelocity = v48}
    return v53
end

v1.Step = Step

local function Reset(a0)
    a0.lastCFrame = nil
end

v1.Reset = Reset
local BaseOcclusion = script.Parent:WaitForChild("BaseOcclusion")
local v54 = require(BaseOcclusion)
local v55 = setmetatable({}, v54)
v55.__index = v55

local function new1() --[[ Upvalues: v54 (copy), v55 (copy), v1 (copy) ]]
    local v56 = setmetatable(v54.new(), v55)
    v56.focusExtrapolator = v1.new()
    return v56
end

v55.new = new1

local function GetOcclusionMode(a0)
    return Enum.DevCameraOcclusionMode.Zoom
end

v55.GetOcclusionMode = GetOcclusionMode

local function Enable(a0, a1)
    a0.focusExtrapolator:Reset()
end

v55.Enable = Enable

local function Update(a0, a1, a2, a3, a4) --[[ Upvalues: v2 (copy), CommonUtils (copy) ]]
    local v57
    if v2 then
        local v58 = CFrame.lookAlong(a3.p, -a2.LookVector)
        v57 = v58 * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1)
    else
        local v59 = CFrame.new(a3.p, a2.p)
        v57 = v59 * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1)
    end

    local v60 = a0.focusExtrapolator:Step(a1, v57)
    local v61 = CommonUtils.Update(a1, v57, v60)
    local v62 = v57 * CFrame.new(0, 0, v61)
    return v62, a3
end

v55.Update = Update

local function CharacterAdded(a0, a1, a2)
end

v55.CharacterAdded = CharacterAdded

local function CharacterRemoving(a0, a1, a2)
end

v55.CharacterRemoving = CharacterRemoving

local function OnCameraSubjectChanged(a0, a1)
end

v55.OnCameraSubjectChanged = OnCameraSubjectChanged
return v55
