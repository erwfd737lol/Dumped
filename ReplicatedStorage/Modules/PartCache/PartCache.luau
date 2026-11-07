
local Table = script.Parent:WaitForChild("Table")
local v1 = require(Table)
Table = {}
Table.__index = Table
Table.__type = "PartCache"
local v2 = CFrame.new(0, 1000000000, 0)

local function assertwarn(a0, a1)
    if a0 == false then
        warn(a1)
    end
end

local function MakeFromTemplate(a0, a1) --[[ Upvalues: v2 (copy) ]]
    local v3 = a0:Clone()
    v3.CFrame = v2
    v3.Anchored = true
    v3.Parent = a1
    return v3
end

local function new(a0, a1, a2) --[[ Upvalues: Table (copy), v1 (copy), v2 (copy) ]]
    local v6 = a2 or workspace
    assert(0 < a1, "PrecreatedParts can not be negative!")
    if a1 ~= 0 == false then
        warn("PrecreatedParts is 0! This may have adverse effects when initially using the cache.")
    end

    if a0.Archivable == false then
        warn("The template's Archivable property has been set to false, which prevents it from being cloned. It will temporarily be set to true.")
    end

    a0.Archivable = true
    a0.Archivable = a0.Archivable
    a0 = a0:Clone()
    local v7 = {
        ExpansionSize = 10,
        Open = {},
        InUse = {},
        CurrentCacheParent = v6,
        Template = a0
    }
    setmetatable(v7, Table)
    for i1 = 1, a1 or 5 do
        local v10 = a0:Clone()
        v10.CFrame = v2
        v10.Anchored = true
        v10.Parent = v7.CurrentCacheParent
        v1.insert(v7.Open, v10)
    end

    v7.Template.Parent = nil
    return v7
end

Table.new = new

local function GetPart(a0) --[[ Upvalues: Table (copy), v1 (copy), v2 (copy) ]]
    local v11 = getmetatable(a0)
    local v12 = ("Cannot statically invoke method '%s' - It is an instance method. Call it on an instance of this class created via %s"):format("GetPart", "PartCache.new")
    assert(v11 == Table, v12)
    if #a0.Open == 0 then
        local v13 = #a0.Open
        local v14 = v13 + #a0.InUse
        local v15 = tostring(v14 + a0.ExpansionSize)
        warn("No parts available in the cache! Creating [" .. a0.ExpansionSize .. "] new part instance(s) - this amount can be edited by changing the ExpansionSize property of the PartCache instance... (This cache now contains a grand total of " .. v15 .. " parts.)")
        for i2 = 1, a0.ExpansionSize do
            v15 = a0.Template:Clone()
            v15.CFrame = v2
            v15.Anchored = true
            v15.Parent = a0.CurrentCacheParent
            v1.insert(a0.Open, v15)
        end
    end

    local v17 = a0.Open[#a0.Open]
    local v18 = #a0.Open
    a0.Open[v18] = nil
    v1.insert(a0.InUse, v17)
    return v17
end

Table.GetPart = GetPart

local function ReturnPart(a0, a1) --[[ Upvalues: Table (copy), v1 (copy), v2 (copy) ]]
    local v19 = getmetatable(a0)
    local v20 = ("Cannot statically invoke method '%s' - It is an instance method. Call it on an instance of this class created via %s"):format("ReturnPart", "PartCache.new")
    assert(v19 == Table, v20)
    local v21 = v1.indexOf(a0.InUse, a1)
    if v21 ~= nil then
        v1.remove(a0.InUse, v21)
        v1.insert(a0.Open, a1)
        a1.CFrame = v2
        a1.Anchored = true
        return
    end

    local v22 = a1:GetFullName()
    error("Attempted to return part \"" .. a1.Name .. "\" (" .. v22 .. ") to the cache, but it's not in-use! Did you call this on the wrong part?")
end

Table.ReturnPart = ReturnPart

local function SetCacheParent(a0, a1) --[[ Upvalues: Table (copy) ]]
    local v23 = getmetatable(a0)
    local v24 = ("Cannot statically invoke method '%s' - It is an instance method. Call it on an instance of this class created via %s"):format("SetCacheParent", "PartCache.new")
    assert(v23 == Table, v24)
    local v25 = a1:IsDescendantOf(workspace)
    if not v25 then
        v25 = a1 == workspace
    end

    assert(v25, "Cache parent is not a descendant of Workspace! Parts should be kept where they will remain in the visible world.")
    a0.CurrentCacheParent = a1
    local v26 = #a0.Open
    v25 = 1
    for i3 = 1, v26, v25 do
        a0.Open[i3].Parent = a1
    end

    v26 = #a0.InUse
    v25 = 1
    for i4 = 1, v26, v25 do
        a0.InUse[i4].Parent = a1
    end
end

Table.SetCacheParent = SetCacheParent

local function Expand(a0, a1) --[[ Upvalues: Table (copy), v1 (copy), v2 (copy) ]]
    local v27 = getmetatable(a0)
    local v28 = ("Cannot statically invoke method '%s' - It is an instance method. Call it on an instance of this class created via %s"):format("Expand", "PartCache.new")
    assert(v27 == Table, v28)
    if a1 == nil then
        a1 = a0.ExpansionSize
    end

    for i5 = 1, a1 do
        local v31 = a0.Template:Clone()
        v31.CFrame = v2
        v31.Anchored = true
        v31.Parent = a0.CurrentCacheParent
        v1.insert(a0.Open, v31)
    end
end

Table.Expand = Expand

local function Dispose(a0) --[[ Upvalues: Table (copy) ]]
    local v32 = getmetatable(a0)
    local v33 = ("Cannot statically invoke method '%s' - It is an instance method. Call it on an instance of this class created via %s"):format("Dispose", "PartCache.new")
    assert(v32 == Table, v33)
    for i6 = 1, #a0.Open do
        a0.Open[i6]:Destroy()
    end

    for i7 = 1, #a0.InUse do
        a0.InUse[i7]:Destroy()
    end

    a0.Template:Destroy()
    a0.Open = {}
    a0.InUse = {}
    a0.CurrentCacheParent = nil
    a0.GetPart = nil
    a0.ReturnPart = nil
    a0.SetCacheParent = nil
    a0.Expand = nil
    a0.Dispose = nil
end

Table.Dispose = Dispose
return Table
