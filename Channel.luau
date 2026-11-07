-- https://lua.expert

game:GetService("ReplicatedStorage")

local RunService = game:GetService("RunService")
local t1 = {}

t1.__index = t1

function t1.new(p1, p2, p3) -- line: 7
    -- upvalues: t1 (copy)
    return (setmetatable({
        Time = p1,
        Func = p2,
        Duration = p3,
        TimeSpot = 0,
        Cancelled = false,
        StoppedShort = false
    }, t1))
end

function t1.Start(p4) -- line: 20
    -- upvalues: RunService (copy)
    tick()

    local connection

    connection = RunService.Heartbeat:Connect(function(p5) -- line: 24
        -- upvalues: p4 (copy), connection (ref)
        p4.TimeSpot += p5

        if not (p4.StoppedShort or p4.TimeSpot >= p4.Time) then
            if p4.Duration then
                p4.Duration()
            end
        else
            connection:Disconnect()

            if not p4.Cancelled then
                local v1 = coroutine.create(function() -- line: 29
                    -- upvalues: p4 (copy)
                    local Func = p4.Func
                    local traceback = debug.traceback
                    local v2, v3 = xpcall(Func, traceback)

                    if not v2 then
                        warn("[Channel] Completion failed: " .. tostring(v3))
                    end
                end)

                coroutine.resume(v1)
            end
        end
    end)
    p4.ChannelCo = connection
end

function t1.Cancel(p6) -- line: 47
    p6.Cancelled = true
    p6.StoppedShort = true

    if p6.ChannelCo then
        p6.ChannelCo:Disconnect()
    end
end

function t1.StopShort(p7) -- line: 55
    if not (p7.StoppedShort or p7.Cancelled) then
        p7.StoppedShort = true
    end
end

function t1.Prolong(p8, p9) -- line: 61
    p8.Time += p9
end

return t1
