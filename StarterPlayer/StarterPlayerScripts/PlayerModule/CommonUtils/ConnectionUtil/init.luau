
local t1 = {}
t1.__index = t1

local function new() --[[ Upvalues: t1 (copy) ]]
    local v1 = setmetatable({}, t1)
    v1._connections = {}
    return v1
end

t1.new = new

local function trackConnection(a0, a1, a2)
    if a0._connections[a1] then
        a0._connections[a1]()
    end

    a0._connections[a1] = function() --[[ Upvalues: a2 (copy) ]]
        a2:Disconnect()
    end
end

t1.trackConnection = trackConnection

local function trackBoundFunction(a0, a1, a2)
    if a0._connections[a1] then
        a0._connections[a1]()
    end

    a0._connections[a1] = a2
end

t1.trackBoundFunction = trackBoundFunction

local function disconnect(a0, a1)
    if a0._connections[a1] then
        a0._connections[a1]()
        a0._connections[a1] = nil
    end
end

t1.disconnect = disconnect

local function disconnectAll(a0)
    for k1, k2 in pairs(a0._connections) do
        k2()
    end

    a0._connections = {}
end

t1.disconnectAll = disconnectAll
return t1
