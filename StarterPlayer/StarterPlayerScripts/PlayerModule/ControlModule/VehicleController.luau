
local ContextActionService = game:GetService("ContextActionService")
local v1 = {}
v1.__index = v1

local function new(a0) --[[ Upvalues: v1 (copy) ]]
    local v2 = setmetatable({}, v1)
    v2.CONTROL_ACTION_PRIORITY = a0
    v2.enabled = false
    v2.vehicleSeat = nil
    v2.throttle = 0
    v2.steer = 0
    v2.acceleration = 0
    v2.decceleration = 0
    v2.turningRight = 0
    v2.turningLeft = 0
    v2.vehicleMoveVector = Vector3.new(0, 0, 0)
    v2.autoPilot = {}
    v2.autoPilot.MaxSpeed = 0
    v2.autoPilot.MaxSteeringAngle = 0
    return v2
end

v1.new = new

local function BindContextActions(a0) --[[ Upvalues: ContextActionService (copy) ]]
    ContextActionService:BindActionAtPriority("throttleAccel", function(a0, a1, a2) --[[ Upvalues: a0 (copy) ]]
        a0:OnThrottleAccel(a0, a1, a2)
        return Enum.ContextActionResult.Pass
    end, false, a0.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonR2)
    ContextActionService:BindActionAtPriority("throttleDeccel", function(a0, a1, a2) --[[ Upvalues: a0 (copy) ]]
        a0:OnThrottleDeccel(a0, a1, a2)
        return Enum.ContextActionResult.Pass
    end, false, a0.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonL2)
    ContextActionService:BindActionAtPriority("arrowSteerRight", function(a0, a1, a2) --[[ Upvalues: a0 (copy) ]]
        a0:OnSteerRight(a0, a1, a2)
        return Enum.ContextActionResult.Pass
    end, false, a0.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Right)
    ContextActionService:BindActionAtPriority("arrowSteerLeft", function(a0, a1, a2) --[[ Upvalues: a0 (copy) ]]
        a0:OnSteerLeft(a0, a1, a2)
        return Enum.ContextActionResult.Pass
    end, false, a0.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Left)
end

v1.BindContextActions = BindContextActions

local function Enable(a0, a1, a2) --[[ Upvalues: ContextActionService (copy) ]]
    if a1 == a0.enabled and a2 == a0.vehicleSeat then
        return
    end

    a0.enabled = a1
    a0.vehicleMoveVector = Vector3.new(0, 0, 0)
    if a1 then
        if a2 then
            a0.vehicleSeat = a2
            a0:SetupAutoPilot()
            a0:BindContextActions()
            return
            -- branch continues at 54
        end
    end

    ContextActionService:UnbindAction("throttleAccel")
    ContextActionService:UnbindAction("throttleDeccel")
    ContextActionService:UnbindAction("arrowSteerRight")
    ContextActionService:UnbindAction("arrowSteerLeft")
    a0.vehicleSeat = nil
end

v1.Enable = Enable

local function OnThrottleAccel(a0, a1, a2, a3)
    if a2 == Enum.UserInputState.End or a2 == Enum.UserInputState.Cancel then
        a0.acceleration = 0
        -- jump to 15 (out of range)
    end

    a0.acceleration = -1
    a0.throttle = a0.acceleration + a0.decceleration
end

v1.OnThrottleAccel = OnThrottleAccel

local function OnThrottleDeccel(a0, a1, a2, a3)
    if a2 == Enum.UserInputState.End or a2 == Enum.UserInputState.Cancel then
        a0.decceleration = 0
        -- jump to 15 (out of range)
    end

    a0.decceleration = 1
    a0.throttle = a0.acceleration + a0.decceleration
end

v1.OnThrottleDeccel = OnThrottleDeccel

local function OnSteerRight(a0, a1, a2, a3)
    if a2 == Enum.UserInputState.End or a2 == Enum.UserInputState.Cancel then
        a0.turningRight = 0
        -- jump to 15 (out of range)
    end

    a0.turningRight = 1
    a0.steer = a0.turningRight + a0.turningLeft
end

v1.OnSteerRight = OnSteerRight

local function OnSteerLeft(a0, a1, a2, a3)
    if a2 == Enum.UserInputState.End or a2 == Enum.UserInputState.Cancel then
        a0.turningLeft = 0
        -- jump to 15 (out of range)
    end

    a0.turningLeft = -1
    a0.steer = a0.turningRight + a0.turningLeft
end

v1.OnSteerLeft = OnSteerLeft

local function Update(a0, a1, a2, a3)
    if a0.vehicleSeat then
        if a2 then
            a1 = a1 + Vector3.new(a0.steer, 0, a0.throttle)
            if a3 then
            end

            a0.vehicleSeat.ThrottleFloat = -a1.Z
            a0.vehicleSeat.SteerFloat = a1.X
            return a1, true
        end

        local v3 = a0.vehicleSeat.Occupant.RootPart.CFrame:VectorToObjectSpace(a1)
        a0.vehicleSeat.ThrottleFloat = a0:ComputeThrottle(v3)
        a0.vehicleSeat.SteerFloat = a0:ComputeSteer(v3)
        return Vector3.new(0, 0, 0), true
    end

    return a1, false
end

v1.Update = Update

local function ComputeThrottle(a0, a1)
    if a1 ~= Vector3.new(0, 0, 0) then
        return -a1.Z
    end

    return 0
end

v1.ComputeThrottle = ComputeThrottle

local function ComputeSteer(a0, a1)
    if a1 ~= Vector3.new(0, 0, 0) then
        local v4 = -a1.x
        return -math.atan2(v4, -a1.z) * 57.295779513082323 / a0.autoPilot.MaxSteeringAngle
    end

    return 0
end

v1.ComputeSteer = ComputeSteer

local function SetupAutoPilot(a0)
    a0.autoPilot.MaxSpeed = a0.vehicleSeat.MaxSpeed
    a0.autoPilot.MaxSteeringAngle = 35
end

v1.SetupAutoPilot = SetupAutoPilot
return v1
