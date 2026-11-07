
local Players = game:GetService("Players")
local ConnectionUtil = script.Parent:WaitForChild("ConnectionUtil")
local v1 = require(ConnectionUtil)

local function getLocalPlayer() --[[ Upvalues: Players (copy) ]]
    return Players.LocalPlayer
end

local function onLocalPlayer(a0) --[[ Upvalues: ConnectionUtil (copy), Players (copy) ]]
    local v2 = ConnectionUtil.getLocalPlayer()
    if v2 then
        a0(v2)
    end

    local v3 = Players:GetPropertyChangedSignal("LocalPlayer")
    local v5 = v3:Connect(function() --[[ Upvalues: ConnectionUtil (upvalue) ]]
        local v4 = ConnectionUtil.getLocalPlayer()
        assert(v4)
        ConnectionUtil._getOrCreateBoundEvent("LOCAL_PLAYER"):Fire(v4)
    end)
    ConnectionUtil._connectionUtil:trackConnection("LOCAL_PLAYER", v5)
    local v6 = ConnectionUtil._getOrCreateBoundEvent("LOCAL_PLAYER").Event:Connect(a0)
    return v6
end

local function getCharacter() --[[ Upvalues: ConnectionUtil (copy) ]]
    local v7 = ConnectionUtil.getLocalPlayer()
    if not v7 then
        return nil
    end

    return v7.Character
end

local function onCharacter(a0) --[[ Upvalues: ConnectionUtil (copy) ]]
    local v10 = ConnectionUtil.onLocalPlayer(function(a0) --[[ Upvalues: ConnectionUtil (upvalue), a0 (copy) ]]
        local v8 = ConnectionUtil.getCharacter()
        if v8 then
            a0(v8)
        end

        local v9 = a0.CharacterAdded:Connect(function(a0) --[[ Upvalues: ConnectionUtil (upvalue) ]]
            assert(a0)
            ConnectionUtil._getOrCreateBoundEvent("CHARACTER_ADDED"):Fire(a0)
        end)
        ConnectionUtil._connectionUtil:trackConnection("CHARACTER_ADDED", v9)
    end)
    ConnectionUtil._connectionUtil:trackConnection("ON_LOCAL_PLAYER", v10)
    local v11 = ConnectionUtil._getOrCreateBoundEvent("CHARACTER_ADDED").Event:Connect(a0)
    return v11
end

local function getChild(a0, a1) --[[ Upvalues: ConnectionUtil (copy) ]]
    local v12 = ConnectionUtil.getCharacter()
    if not v12 then
        return nil
    end

    local v13 = v12:FindFirstChild(a0)
    if v13 and v13:IsA(a1) then
        return v13
    end

    return nil
end

local function onChild(a0, a1, a2) --[[ Upvalues: ConnectionUtil (copy) ]]
    local v16 = ConnectionUtil.onCharacter(function(a0) --[[ Upvalues: ConnectionUtil (upvalue), a0 (copy), a1 (copy), a2 (copy) ]]
        local v14 = ConnectionUtil.getChild(a0, a1)
        if v14 then
            a2(v14)
        end

        local v15 = a0.ChildAdded:Connect(function(a0) --[[ Upvalues: a0 (upvalue), a1 (upvalue), ConnectionUtil (upvalue) ]]
            if a0.Name == a0 and a0:IsA(a1) then
                ConnectionUtil._getOrCreateBoundEvent("CHARACTER_CHILD_ADDED" .. a0 .. a1):Fire(a0)
            end

        end)
        ConnectionUtil._connectionUtil:trackConnection("CHARACTER_CHILD_ADDED", v15)
    end)
    ConnectionUtil._connectionUtil:trackConnection("ON_CHARACTER", v16)
    local v17 = ConnectionUtil._getOrCreateBoundEvent("CHARACTER_CHILD_ADDED" .. a0 .. a1).Event:Connect(a2)
    return v17
end

local function _getOrCreateBoundEvent(a0) --[[ Upvalues: ConnectionUtil (copy) ]]
    if not ConnectionUtil._boundEvents[a0] then
        ConnectionUtil._boundEvents[a0] = Instance.new("BindableEvent")
    end

    return ConnectionUtil._boundEvents[a0]
end

ConnectionUtil = {
    _connectionUtil = v1.new(),
    _boundEvents = {},
    getLocalPlayer = getLocalPlayer,
    onLocalPlayer = onLocalPlayer,
    getCharacter = getCharacter,
    onCharacter = onCharacter,
    getChild = getChild,
    onChild = onChild,
    _getOrCreateBoundEvent = _getOrCreateBoundEvent
}
return ConnectionUtil
