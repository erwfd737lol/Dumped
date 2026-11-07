
local function parsePath(a0)
    local v1 = string.split(a0, "/")
    for i1 = #v1, 1, -1 do
        if v1[i1] == "" then
            table.remove(v1, i1)
        end
    end

    return v1
end

local function isManifestResolved(a0, a1)
    local v4 = 0
    for k1 in pairs(a0) do
        v4 = v4 + 1
    end

    assert(v4 <= a1, v4)
    return v4 == a1
end

local function unbindNodeDescend(a0, a1) --[[ Upvalues: unbindNodeDescend (copy) ]]
    if a0.instance == nil then
        return
    end

    a0.instance = nil
    local connections = a0.connections
    if connections then
        for k2, k3 in ipairs(connections) do
            k3:Disconnect()
        end

        table.clear(connections)
    end

    if a1 and a0.alias then
        a1[a0.alias] = nil
    end

    connections = a0.children
    if connections then
        for k4, k5 in pairs(connections) do
            unbindNodeDescend(k5, a1)
        end
    end
end

local t1 = {}
t1.__index = t1

local function new(a0, a1) --[[ Upvalues: parsePath (copy), t1 (copy) ]]
    local t2 = {}
    local v15 = 1
    for k6, k7 in pairs(a0) do
        t2[k6] = parsePath(k7)
        v15 = v15 + 1
    end

    local v19 = {
        _boundFn = a1,
        _parsedManifest = t2,
        _manifestSizeTarget = v15,
        _dtorMap = {},
        _connections = {},
        _rootInstToRootNode = {},
        _rootInstToManifest = {}
    }
    return setmetatable(v19, t1)
end

t1.new = new

local function _startBoundFn(a0, a1, a2)
    local _boundFn = a0._boundFn
    local _dtorMap = a0._dtorMap
    local v20 = _dtorMap[a1]
    if v20 then
        v20()
        _dtorMap[a1] = nil
    end

    local v21 = _boundFn(a2)
    if v21 then
        _dtorMap[a1] = v21
    end
end

t1._startBoundFn = _startBoundFn

local function _stopBoundFn(a0, a1)
    local _dtorMap1 = a0._dtorMap
    local v22 = _dtorMap1[a1]
    if v22 then
        v22()
        _dtorMap1[a1] = nil
    end
end

t1._stopBoundFn = _stopBoundFn

local function bindRoot(a0, a1) --[[ Upvalues: unbindNodeDescend (copy) ]]
    debug.profilebegin("AtomicBinding:BindRoot")
    local _parsedManifest = a0._parsedManifest
    local _rootInstToRootNode = a0._rootInstToRootNode
    local _rootInstToManifest = a0._rootInstToManifest
    local _manifestSizeTarget = a0._manifestSizeTarget
    assert(_rootInstToManifest[a1] == nil)
    local v23 = {}
    _rootInstToManifest[a1] = v23
    debug.profilebegin("BuildTree")
    _rootInstToManifest = {alias = "root", instance = a1}
    if next(_parsedManifest) then
        _rootInstToManifest.children = {}
        _rootInstToManifest.connections = {}
    end

    _rootInstToRootNode[a1] = _rootInstToManifest
    for k8, k9 in pairs(_parsedManifest) do
        _rootInstToRootNode = _rootInstToManifest
        for k10, k11 in ipairs(k9) do
            local v32 = _rootInstToRootNode.children[k11]
            if not v32 then
                v32 = {}
            end

            if k10 == #k9 then
                if v32.alias ~= nil then
                    error("Multiple aliases assigned to one instance")
                end

                v32.alias = k8
            else
                local children = v32.children
                if not children then
                    children = {}
                end

                v32.children = children
                children = v32.connections
                if not children then
                    children = {}
                end

                v32.connections = children
            end

            _rootInstToRootNode.children[k11] = v32
            _rootInstToRootNode = v32
        end
    end

    debug.profileend()

    local function processNode(a0) --[[ Upvalues: v23 (copy), processNode (copy), a0 (copy), a1 (copy), unbindNodeDescend (upvalue), _manifestSizeTarget (copy) ]]
        local v33 = assert(a0.instance)
        local children1 = a0.children
        local alias = a0.alias
        local v34 = not children1
        if alias then
            v23[alias] = v33
        end

        if not v34 then

            local function processAddChild(a0) --[[ Upvalues: children1 (copy), processNode (upvalue) ]]
                local v35 = children1[a0.Name]
                if not v35 or v35.instance ~= nil then
                    return
                end

                v35.instance = a0
                processNode(v35)
            end

            local function processDeleteChild(a0) --[[ Upvalues: children1 (copy), a0 (upvalue), a1 (upvalue), unbindNodeDescend (upvalue), v23 (upvalue), v33 (copy), processNode (upvalue) ]]
                local Name = a0.Name
                local v36 = children1[Name]
                if not v36 then
                    return
                end

                if v36.instance ~= a0 then
                    return
                end

                a0:_stopBoundFn(a1)
                unbindNodeDescend(v36, v23)
                assert(v36.instance == nil)
                local v37 = v33:FindFirstChild(Name)
                if v37 then
                    local v38 = children1[v37.Name]
                    if v38 then
                        if v38.instance ~= nil then
                            return
                        end

                        v38.instance = v37
                        processNode(v38)
                    end
                end
            end

            local v39 = v33:GetChildren()
            for k12, k13 in ipairs(v39) do
                local v43 = children1[k13.Name]
                if v43 then
                    if v43.instance ~= nil then
                    else
                        v43.instance = k13
                        processNode(v43)
                    end
                end
            end

            local v44 = v33.ChildAdded:Connect(processAddChild)
            table.insert(a0.connections, v44)
            local v45 = v33.ChildRemoved:Connect(processDeleteChild)
            table.insert(a0.connections, v45)
        end

        if v34 then
            local v46 = _manifestSizeTarget
            local v47 = 0
            for k14 in pairs(v23) do
                v47 = v47 + 1
            end

            assert(v47 <= v46, v47)
            if v47 == v46 then
                a0:_startBoundFn(a1, v23)
            end
        end
    end

    debug.profilebegin("ResolveTree")
    processNode(_rootInstToManifest)
    debug.profileend()
    debug.profileend()
end

t1.bindRoot = bindRoot

local function unbindRoot(a0, a1) --[[ Upvalues: unbindNodeDescend (copy) ]]
    local _rootInstToRootNode1 = a0._rootInstToRootNode
    local _rootInstToManifest1 = a0._rootInstToManifest
    a0:_stopBoundFn(a1)
    local v51 = _rootInstToRootNode1[a1]
    if v51 then
        local v52 = assert(_rootInstToManifest1[a1])
        unbindNodeDescend(v51, v52)
        _rootInstToRootNode1[a1] = nil
    end

    _rootInstToManifest1[a1] = nil
end

t1.unbindRoot = unbindRoot

local function destroy(a0) --[[ Upvalues: unbindNodeDescend (copy) ]]
    debug.profilebegin("AtomicBinding:destroy")
    for k15, k16 in pairs(a0._dtorMap) do
        k16:destroy()
    end

    table.clear(a0._dtorMap)
    for k17, k18 in ipairs(a0._connections) do
        k18:Disconnect()
    end

    table.clear(a0._connections)
    local _rootInstToManifest2 = a0._rootInstToManifest
    for k19, k20 in pairs(a0._rootInstToRootNode) do
        local v63 = assert(_rootInstToManifest2[k19])
        unbindNodeDescend(k20, v63)
    end

    table.clear(a0._rootInstToManifest)
    table.clear(a0._rootInstToRootNode)
    debug.profileend()
end

t1.destroy = destroy
return t1
