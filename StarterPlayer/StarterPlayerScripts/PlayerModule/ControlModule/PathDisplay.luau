
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
CommonUtils = require(FlagUtil).getUserFlag("UserRaycastUpdateAPI2")
local v1 = RaycastParams.new()
v1.FilterType = Enum.RaycastFilterType.Exclude
local v2 = {
    spacing = 8,
    image = "rbxasset://textures/Cursors/Gamepad/Pointer.png",
    imageSize = Vector2.new(2, 2)
}
local v3 = {}
local v4 = {}
local Model = Instance.new("Model")
Model.Name = "PathDisplayPoints"
local Part = Instance.new("Part")
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1
Part.Name = "PathDisplayAdornee"
Part.CFrame = CFrame.new(0, 0, 0)
Part.Parent = Model
local v5 = {}
local v6 = 30
for i1 = 1, v6 do
    local ImageHandleAdornment = Instance.new("ImageHandleAdornment")
    ImageHandleAdornment.Archivable = false
    ImageHandleAdornment.Adornee = Part
    ImageHandleAdornment.Image = v2.image
    ImageHandleAdornment.Size = v2.imageSize
    v5[i1] = ImageHandleAdornment
end

local function retrieveFromPool() --[[ Upvalues: v5 (copy), v6 (ref) ]]
    local v9 = v5[1]
    if not v9 then
        return nil
    end

    local v10 = v5[v6]
    v5[1] = v10
    v5[v6] = nil
    v6 = v6 - 1
    return v9
end

local function returnToPool(a0) --[[ Upvalues: v6 (ref), v5 (copy) ]]
    v6 = v6 + 1
    v5[v6] = a0
end

local function renderPoint(a0, a1) --[[ Upvalues: v6 (ref), v5 (copy), CommonUtils (copy), v1 (copy), Model (copy) ]]
    if v6 == 0 then
        return nil
    end

    local v11 = v5[1]
    local v12
    if not v11 then
        v12 = nil
    else
        local v13 = v5[v6]
        v5[1] = v13
        v5[v6] = nil
        v6 = v6 - 1
        v12 = v11
    end

    if CommonUtils then
        local v14 = {game.Players.LocalPlayer.Character, workspace.CurrentCamera}
        v1.FilterDescendantsInstances = v14
        local v15 = a0 + Vector3.new(0, 2, 0)
        local v16 = workspace:Raycast(v15, Vector3.new(0, -8, 0), v1)
        if not v16 then
            return nil
        end

        v12.CFrame = CFrame.lookAlong(v16.Position, v16.Normal)
        v12.Parent = Model
        return v12
    end

    local v17 = a0 + Vector3.new(0, 2, 0)
    local v18 = Ray.new(v17, Vector3.new(0, -8, 0))
    local v19 = {game.Players.LocalPlayer.Character, workspace.CurrentCamera}
    local v20, v21, v22 = workspace:FindPartOnRayWithIgnoreList(v18, v19)
    if not v20 then
        return nil
    end

    v12.CFrame = CFrame.new(v21, v21 + v22)
    v12.Parent = Model
    return v12
end

local function setCurrentPoints(a0) --[[ Upvalues: v3 (ref) ]]
    if typeof(a0) == "table" then
        v3 = a0
        return
    end

    v3 = {}
end

v2.setCurrentPoints = setCurrentPoints

local function clearRenderedPath() --[[ Upvalues: v4 (ref), v6 (ref), v5 (copy), Model (copy) ]]
    for k1, k2 in ipairs(v4) do
        k2.Parent = nil
        v6 = v6 + 1
        v5[v6] = k2
    end

    v4 = {}
    Model.Parent = nil
end

v2.clearRenderedPath = clearRenderedPath

local function renderPath() --[[ Upvalues: v2 (copy), v3 (ref), v4 (ref), renderPoint (copy), Model (copy) ]]
    v2.clearRenderedPath()
    if not v3 or #v3 == 0 then
        return
    end

    local v26 = #v3
    local v27 = v3[v26]
    local v28 = 0
    v4[1] = renderPoint(v27, true)
    if not v4[1] then
        return
    end

    while true do
        v27 = v3[v26]
        local v29 = v3[v26 - 1]
        if v26 < 2 then
            break
        end

        local v30 = v29 - v27
        local magnitude = v30.magnitude
        if magnitude < v28 then
            v28 = v28 - magnitude
            v26 = v26 - 1
        else
            local v31 = v27 + v30.unit * v28
            local v32 = renderPoint(v31, false)
            if v32 then
                v4[#v4 + 1] = v32
            end

            v28 = v28 + v2.spacing
        end
    end

    Model.Parent = workspace.CurrentCamera
end

v2.renderPath = renderPath
return v2
