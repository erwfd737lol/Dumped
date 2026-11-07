
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = game:GetService()

local function addToReplicatedStorage() --[[ Upvalues: ReplicatedStorage (copy), v1 (copy) ]]
    if ReplicatedStorage:FindFirstChild(v1.objectName) then
        return false
    end

    local ObjectValue = Instance.new("ObjectValue")
    ObjectValue.Name = v1.objectName
    ObjectValue.Value = script.Parent
    ObjectValue.Parent = ReplicatedStorage
    return ObjectValue
end

local function getObject() --[[ Upvalues: ReplicatedStorage (copy), v1 (copy) ]]
    local v2 = ReplicatedStorage:FindFirstChild(v1.objectName)
    if v2 then
        return v2
    end

    return false
end

v1 = {
    objectName = "TopbarPlusReference",
    addToReplicatedStorage = addToReplicatedStorage,
    getObject = getObject
}
return v1
