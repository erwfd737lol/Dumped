
local t1 = {}
t1.__index = t1

local function new() --[[ Upvalues: t1 (copy) ]]
    local v1 = setmetatable({}, t1)
    v1._currentIndex = 0
    v1.Records = {}
    return v1
end

t1.new = new

local function WriteHistory(a0, a1)
    a0._currentIndex = a0._currentIndex + 1
    if a0._currentIndex < #a0.Records then
        for i1 = a0._currentIndex + 1, #a0.Records do
            a0.Records[i1] = nil
        end
    end

    a0.Records[a0._currentIndex] = a1
end

t1.WriteHistory = WriteHistory

local function GetRecord(a0, a1)
    local v6 = a1 or a0._currentIndex
    return a0.Records[v6]
end

t1.GetRecord = GetRecord

local function IncrementHistory(a0, a1)
    if a0._currentIndex <= 1 and a1 < 0 then
        return
    end

    local v7 = a0._currentIndex + a1
    a0._currentIndex = math.clamp(v7, 1, #a0.Records)
    return a0.Records[a0._currentIndex]
end

t1.IncrementHistory = IncrementHistory

local function ClearHistory(a0)
    a0.Records = {}
    a0._currentIndex = 0
end

t1.ClearHistory = ClearHistory

local function Destroy(a0)
    a0:ClearHistory()
end

t1.Destroy = Destroy
return t1
