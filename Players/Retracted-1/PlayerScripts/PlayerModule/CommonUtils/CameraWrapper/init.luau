
local v1 = require(script.Parent.ConnectionUtil)
local v2 = {}
v2.__index = v2

local function new() --[[ Upvalues: v1 (copy), v2 (copy) ]]
    local t1 = {
        _enabled = false,
        _camera = game.Workspace.CurrentCamera,
        _callbacks = {},
        _connectionUtil = v1.new()
    }
    return setmetatable(t1, v2)
end

v2.new = new

local function _connectCallbacks(a0)
    a0._camera = game.Workspace.CurrentCamera
    if not a0._camera then
        return
    end

    local _callbacks = a0._callbacks
    local v3 = nil
    local v4 = nil
    for k1, k2 in _callbacks do
        local v5 = a0._camera:GetPropertyChangedSignal(k1)
        local v6 = v5:Connect(k2)
        a0._connectionUtil:trackConnection(k1, v6)
        k2()
    end
end

v2._connectCallbacks = _connectCallbacks

local function Enable(a0)
    if a0._enabled then
        return
    end

    a0._enabled = true
    local v7 = game.Workspace:GetPropertyChangedSignal("CurrentCamera")
    a0._cameraChangedConnection = v7:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:_connectCallbacks()
    end)
    a0:_connectCallbacks()
end

v2.Enable = Enable

local function Disable(a0)
    if not a0._enabled then
        return
    end

    a0._enabled = false
    if a0._cameraChangedConnection then
        a0._cameraChangedConnection:Disconnect()
        a0._cameraChangedConnection = nil
    end

    a0._connectionUtil:disconnectAll()
end

v2.Disable = Disable

local function Connect(a0, a1, a2)
    a0._callbacks[a1] = a2
    if not a0._camera then
        return
    end

    local v8 = a0._camera:GetPropertyChangedSignal(a1)
    local v9 = v8:Connect(a2)
    a0._connectionUtil:trackConnection(a1, v9)
end

v2.Connect = Connect

local function Disconnect(a0, a1)
    a0._connectionUtil:disconnect(a1)
    a0._callbacks[a1] = nil
end

v2.Disconnect = Disconnect

local function getCamera(a0)
    return a0._camera
end

v2.getCamera = getCamera
return v2
