
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local v1 = {}
v1.__index = v1

local function new(a0, a1, a2) --[[ Upvalues: v1 (copy) ]]
    local t1 = {
        Time = a0,
        Func = a1,
        Duration = a2,
        TimeSpot = 0,
        Cancelled = false,
        StoppedShort = false
    }
    return setmetatable(t1, v1)
end

v1.new = new

local function Start(a0) --[[ Upvalues: RunService (copy) ]]
    local v2 = tick()
    local v3 = nil
    a0.ChannelCo = RunService.Heartbeat:Connect(function(a0) --[[ Upvalues: a0 (copy), v3 (ref) ]]
        a0.TimeSpot = a0.TimeSpot + a0
        if a0.StoppedShort or a0.Time <= a0.TimeSpot then
            v3:Disconnect()
            if not a0.Cancelled then
                local v6 = coroutine.create(function() --[[ Upvalues: a0 (upvalue) ]]
                    local v4, v5 = xpcall(a0.Func, debug.traceback)
                    if not v4 then
                        warn("[Channel] Completion failed: " .. tostring(v5))
                    end

                end)
                coroutine.resume(v6)
            end

            return
        end

        if a0.Duration then
            a0.Duration()
        end

    end)
end

v1.Start = Start

local function Cancel(a0)
    a0.Cancelled = true
    a0.StoppedShort = true
    if a0.ChannelCo then
        a0.ChannelCo:Disconnect()
    end
end

v1.Cancel = Cancel

local function StopShort(a0)
    if a0.StoppedShort or a0.Cancelled then
        return
    end

    a0.StoppedShort = true
end

v1.StopShort = StopShort

local function Prolong(a0, a1)
    a0.Time = a0.Time + a1
end

v1.Prolong = Prolong
return v1
