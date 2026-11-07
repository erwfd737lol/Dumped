
local function create(a0, a1, a2, a3, a4)
    local t1 = {}
    t1.Target = Vector3.new()
    t1.Position = Vector3.new()
    t1.Velocity = Vector3.new()
    t1.Mass = a1 or 5
    t1.Force = a2 or 50
    t1.Damping = a3 or 4
    t1.Speed = a4 or 4

    local function shove(a0, a1)
        local X = a1.X
        local Y = a1.Y
        local Z = a1.Z
        a0.Velocity = a0.Velocity + Vector3.new(X == X and X ~= math.huge and X or 0, Y == Y and Y ~= math.huge and Y or 0, Z == Z and Z ~= math.huge and Z or 0)
    end

    t1.shove = shove

    local function update(a0, a1)
        local v1 = math.min(a1, 1)
        local v2 = v1 * a0.Speed
        local v3 = math.ceil(v2 / 0.0083333333333333332)
        local v4 = math.clamp(v3, 1, 240)
        v3 = v2 / v4
        for i1 = 1, v4 do
            local v7 = (a0.Target - a0.Position) * a0.Force
            local v8 = v7 / a0.Mass
            a0.Velocity = a0.Velocity + (v8 - a0.Velocity * a0.Damping) * v3
            a0.Position = a0.Position + a0.Velocity * v3
        end

        return a0.Position
    end

    t1.update = update
    return t1
end

local t2 = {create = create}
return t2
