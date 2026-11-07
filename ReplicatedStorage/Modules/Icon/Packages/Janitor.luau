
local Heartbeat = game:GetService("RunService").Heartbeat

local function getPromiseReference()
    return false
end

local v1 = newproxy(true)
local v2 = getmetatable(v1)
v2.__tostring = function()
    return "IndicesReference"
end

local v3 = newproxy(true)
local v4 = getmetatable(v3)
v4.__tostring = function()
    return "LinkToInstanceIndex"
end

local v5 = {CurrentlyCleaning = true, [v1] = nil}
v5 = {["function"] = true, Promise = "cancel", RBXScriptConnection = "Disconnect"}

local function new() --[[ Upvalues: v1 (copy), v4 (copy) ]]
    local t1 = {CurrentlyCleaning = false, [v1] = nil}
    return setmetatable(t1, v4)
end

local function Is(a0) --[[ Upvalues: v4 (copy) ]]
    local v6 = false
    if type(a0) == "table" then
        local v7 = getmetatable(a0)
        v6 = v7 == v4
    end

    return v6
end

v4 = {IGNORE_MEMORY_DEBUG = true, ClassName = "Janitor", __index = v5, new = new, Is = Is}
v4.is = v4.Is

local function Add(a0, a1, a2, a3) --[[ Upvalues: v1 (copy), v5 (copy) ]]
    if a3 then
        a0:Remove(a3)
        local v8 = a0[v1]
        if not v8 then
            v8 = {}
            a0[v1] = v8
        end

        v8[a3] = a1
    end

    local v9 = typeof(a1)
    if v9 == "table" then
        local v10 = tostring(a1)
        if string.match(v10, "Promise") then
            v9 = "Promise"
        end
    end

    local v14 = a2 or v5[v9] or "Destroy"
    a2 = v14
    if type(a1) ~= "function" and not a1[a2] then
        local v15 = tostring(a1)
        local v16 = tostring(a2)
        local v17 = debug.traceback(nil, 2)
        local v18 = string.format("Object %s doesn't have method %s, are you sure you want to add it? Traceback: %s", v15, v16, v17)
        warn(v18)
    end

    local v19 = debug.traceback("")
    local v20 = {a2, v19}
    a0[a1] = v20
    return a1
end

v4.__index.Add = Add
v4.__index.Give = v4.__index.Add

local function AddPromise(a0, a1)
    local v21 = false
    if v21 then
        if not v21.is(a1) then
            local v22 = typeof(a1)
            local v23 = string.format("Invalid argument #1 to 'Janitor:AddPromise' (Promise expected, got %s (%s))", v22, tostring(a1))
            error(v23)
        end

        local v24 = a1:getStatus()
        if v24 == v21.Status.Started then
            local v25 = newproxy(false)
            local v26 = v21.new(function(a0, a1, a2) --[[ Upvalues: a1 (copy) ]]
                if a2(function() --[[ Upvalues: a1 (upvalue) ]]
                    a1:cancel()
                end) then
                    return
                end

                a0(a1)
            end)
            local v27 = a0:Add(v26, "cancel", v25)
            v27:finallyCall(a0.Remove, a0, v25)
            return v27
        end

        return a1
    end

    return a1
end

v4.__index.AddPromise = AddPromise
v4.__index.GivePromise = v4.__index.AddPromise

local function AddObject(a0, a1)
    local v28 = newproxy(false)
    local v29 = false
    if v29 then
        if v29.is(a1) then
            local v30 = a1:getStatus()
            if v30 == v29.Status.Started then
                local v31 = v29.resolve(a1)
                local v32 = a0:Add(v31, "cancel", v28)
                v32:finallyCall(a0.Remove, a0, v28)
                return v32, v28
            end

            return a1
        end
    end

    local v33 = a0:Add(a1, false, v28)
    return v33, v28
end

v4.__index.AddObject = AddObject
v4.__index.GiveObject = v4.__index.AddObject

local function Remove(a0, a1) --[[ Upvalues: v1 (copy) ]]
    local v34 = a0[v1]
    if v34 then
        local v35 = v34[a1]
        if v35 then
            local v36 = a0[v35]
            local v39 = v36 and v36[1]
            if v39 then
                if v39 == true then
                    v35()
                else
                    v36 = v35[v39]
                    if v36 then
                        v36(v35)
                    end
                end

                a0[v35] = nil
            end

            v34[a1] = nil
        end
    end

    return a0
end

v4.__index.Remove = Remove

local function Get(a0, a1) --[[ Upvalues: v1 (copy) ]]
    local v40 = a0[v1]
    if v40 then
        return v40[a1]
    end

    return nil
end

v4.__index.Get = Get

local function Cleanup(a0) --[[ Upvalues: v1 (copy) ]]
    if not a0.CurrentlyCleaning then
        a0.CurrentlyCleaning = nil
        local v41 = next
        local v42 = a0
        local v43 = nil
        for k1, k2 in v41 do
            if k1 ~= v1 then
                local v44 = type(k1)
                if v44 == "string" or v44 == "number" then
                    a0[k1] = nil
                    -- jump to 107 (out of range)
                end

                v44 = k2[1]
                local v45 = k2[2]

                local function warnUser(a0) --[[ Upvalues: v45 (copy) ]]
                    local v46 = debug.traceback("", 3)
                    local v47 = tostring(a0)
                    warn("-------- Janitor Error --------" .. "\n" .. v47 .. "\n" .. v46 .. "" .. v45)
                end

                if v44 == true then
                    local v48, v49 = pcall(k1)
                    if not v48 then
                        local v50 = debug.traceback("", 3)
                        local v51 = tostring(v49)
                        warn("-------- Janitor Error --------" .. "\n" .. v51 .. "\n" .. v50 .. "" .. v45)
                        -- branch continues at 105
                    end
                else
                    local v52 = k1[v44]
                    if v52 then
                        local v53, v54 = pcall(v52, k1)
                        local v55 = false
                        if typeof(k1) == "Instance" then
                            v55 = v52 == "Destroy"
                        end

                        if not v53 and not v55 then
                            local v56 = debug.traceback("", 3)
                            local v57 = tostring(v54)
                            warn("-------- Janitor Error --------" .. "\n" .. v57 .. "\n" .. v56 .. "" .. v45)
                        end
                    end
                end

                a0[k1] = nil
            end
        end

        v41 = a0[v1]
        if v41 then
            local v58 = next
            v43 = v41
            k1 = nil
            for k3 in v58 do
                v41[k3] = nil
            end

            a0[v1] = {}
        end

        a0.CurrentlyCleaning = false
    end
end

v4.__index.Cleanup = Cleanup
v4.__index.Clean = v4.__index.Cleanup

local function Destroy(a0)
    a0:Cleanup()
end

v4.__index.Destroy = Destroy
v4.__call = v4.__index.Cleanup
local v59 = {Connected = true}
v59.__index = v59

local function Disconnect(a0)
    if a0.Connected then
        a0.Connected = false
        a0.Connection:Disconnect()
    end
end

v59.Disconnect = Disconnect

local function __tostring(a0)
    local v60 = tostring(a0.Connected)
    return "Disconnect<" .. v60 .. ">"
end

v59.__tostring = __tostring

local function LinkToInstance(a0, a1, a2) --[[ Upvalues: v3 (copy), v59 (copy), Heartbeat (copy) ]]
    local v63 = a2 and newproxy(false) or v3
    local v64 = a1.Parent == nil
    local v65 = setmetatable({}, v59)
    local v66 = nil

    local function ChangedFunction(a0, a1) --[[ Upvalues: v65 (copy), v64 (ref), Heartbeat (upvalue), v66 (ref), a0 (copy) ]]
        if v65.Connected then
            v64 = a1 == nil
            if v64 then
                coroutine.wrap(function() --[[ Upvalues: Heartbeat (upvalue), v65 (upvalue), v66 (upvalue), a0 (upvalue), v64 (upvalue) ]]
                    Heartbeat:Wait()
                    if not v65.Connected then
                        return
                    end

                    if not v66.Connected then
                        a0:Cleanup()
                        return
                    end

                    while v64 and v66.Connected and v65.Connected do
                        Heartbeat:Wait()
                    end

                    if v65.Connected and v64 then
                        a0:Cleanup()
                    end

                end)()
            end
        end
    end

    v66 = a1.AncestryChanged:Connect(ChangedFunction)
    v65.Connection = v66
    if v64 then
        if v65.Connected then
            v64 = a1.Parent == nil
            if v64 then
                coroutine.wrap(function() --[[ Upvalues: Heartbeat (upvalue), v65 (copy), v66 (ref), a0 (copy), v64 (ref) ]]
                    Heartbeat:Wait()
                    if not v65.Connected then
                        return
                    end

                    if not v66.Connected then
                        a0:Cleanup()
                        return
                    end

                    while v64 and v66.Connected and v65.Connected do
                        Heartbeat:Wait()
                    end

                    if v65.Connected and v64 then
                        a0:Cleanup()
                    end

                end)()
            end
        end
    end

    local v67 = a0:Add(v65, "Disconnect", v63)
    return v67
end

v4.__index.LinkToInstance = LinkToInstance

local function LinkToInstances(a0, ...) --[[ Upvalues: v4 (copy) ]]
    local v68 = v4.new()
    local v69 = {...}
    for k4, k5 in ipairs(v69) do
        local v73 = a0:LinkToInstance(k5, true)
        v68:Add(v73, "Disconnect")
    end

    return v68
end

v4.__index.LinkToInstances = LinkToInstances
LinkToInstances = next
local __index = v4.__index
local v74 = nil
for k6, k7 in LinkToInstances do
    local v75 = string.lower(k6)
    local v76 = string.sub(v75, 1, 1)
    local v77 = v76 .. string.sub(k6, 2)
    v4.__index[v77] = k7
end

return v4
