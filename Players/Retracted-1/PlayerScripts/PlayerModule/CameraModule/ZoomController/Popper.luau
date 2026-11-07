
local Players = game:GetService("Players")
local CommonUtils = script.Parent.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
local v1 = require(FlagUtil)
local CameraWrapper = CommonUtils:WaitForChild("CameraWrapper")
local v2 = require(CameraWrapper)
local ConnectionUtil = CommonUtils:WaitForChild("ConnectionUtil")
local v3 = require(ConnectionUtil)
CommonUtils = v1.getUserFlag("UserRaycastUpdateAPI2")
local v4 = v1.getUserFlag("UserCurrentCameraUpdate2")
local v5 = v1.getUserFlag("UserPlayerConnectionMemoryLeak")
if v4 then
    v1 = v2.new()
else
    v1 = nil
end

local v6
if v4 then
    v6 = nil
else
    v6 = game.Workspace.CurrentCamera
end

if v4 then
    v1:Enable()
end

v2 = math.min
local tan = math.tan
local rad = math.rad
local new = Ray.new
local v7 = RaycastParams.new()
v7.IgnoreWater = true
v7.FilterType = Enum.RaycastFilterType.Exclude
v7.RespectCanCollide = true
local v8 = RaycastParams.new()
v8.IgnoreWater = true
v8.FilterType = Enum.RaycastFilterType.Include
local v9
if v5 then
    local v10 = v3.new()
else
    v9 = nil
end

local function getTotalTransparency(a0)
    local v11 = 1 - a0.Transparency
    return 1 - v11 * (1 - a0.LocalTransparencyModifier)
end

local function eraseFromEnd(a0, a1)
    for i1 = #a0, a1 + 1, -1 do
        a0[i1] = nil
    end
end

local v14 = nil
local v15 = nil
local v16
if v4 then

    local function updateProjection() --[[ Upvalues: v1 (copy), rad (copy), v15 (ref), tan (copy), v14 (ref) ]]
        local v17 = v1:getCamera()
        local v18 = rad(v17.FieldOfView)
        local ViewportSize = v17.ViewportSize
        v17 = ViewportSize.X / ViewportSize.Y
        v15 = tan(v18 / 2) * 2
        v14 = v17 * v15
    end

    v1:Connect("FieldOfView", updateProjection)
    v1:Connect("ViewportSize", updateProjection)
    local v19 = v1:getCamera()
    local v20 = rad(v19.FieldOfView)
    local ViewportSize1 = v19.ViewportSize
    v19 = ViewportSize1.X / ViewportSize1.Y
    v15 = tan(v20 / 2) * 2
    v14 = v19 * v15
    v16 = v1:getCamera().NearPlaneZ
    v1:Connect("NearPlaneZ", function() --[[ Upvalues: v16 (ref), v1 (copy) ]]
        v16 = v1:getCamera().NearPlaneZ
    end)
else

    local function updateProjection1() --[[ Upvalues: v6 (ref), rad (copy), v15 (ref), tan (copy), v14 (ref) ]]
        local v21 = rad(v6.FieldOfView)
        local ViewportSize2 = v6.ViewportSize
        local v22 = ViewportSize2.X / ViewportSize2.Y
        v15 = tan(v21 / 2) * 2
        v14 = v22 * v15
    end

    local v23 = v6:GetPropertyChangedSignal("FieldOfView")
    v23:Connect(updateProjection1)
    local v24 = v6:GetPropertyChangedSignal("ViewportSize")
    v24:Connect(updateProjection1)
    local v25 = rad(v6.FieldOfView)
    local ViewportSize3 = v6.ViewportSize
    local v26 = ViewportSize3.X / ViewportSize3.Y
    v15 = tan(v25 / 2) * 2
    v14 = v26 * v15
    v16 = v6.NearPlaneZ
    local v27 = v6:GetPropertyChangedSignal("NearPlaneZ")
    v27:Connect(function() --[[ Upvalues: v16 (ref), v6 (ref) ]]
        v16 = v6.NearPlaneZ
    end)
end

local v28 = {}
local v29 = {}

local function refreshIgnoreList() --[[ Upvalues: v28 (ref), v29 (copy) ]]
    local v30 = 1
    v28 = {}
    for k1, k2 in pairs(v29) do
        v28[v30] = k2
        v30 = v30 + 1
    end
end

local function playerAdded(a0) --[[ Upvalues: v29 (copy), v28 (ref), v5 (copy), v9 (copy) ]]

    local function characterAdded(a0) --[[ Upvalues: v29 (upvalue), a0 (copy), v28 (upvalue) ]]
        v29[a0] = a0
        local v34 = 1
        v28 = {}
        for k3, k4 in pairs(v29) do
            v28[v34] = k4
            v34 = v34 + 1
        end
    end

    local function characterRemoving() --[[ Upvalues: v29 (upvalue), a0 (copy), v28 (upvalue) ]]
        v29[a0] = nil
        local v38 = 1
        v28 = {}
        for k5, k6 in pairs(v29) do
            v28[v38] = k6
            v38 = v38 + 1
        end
    end

    if v5 then
        local v43 = ("%*CharacterAdded"):format(a0.UserId)
        local v44 = a0.CharacterAdded:Connect(characterAdded)
        v9:trackConnection(v43, v44)
        local v45 = ("%*CharacterRemoving"):format(a0.UserId)
        local v46 = a0.CharacterRemoving:Connect(characterRemoving)
        v9:trackConnection(v45, v46)
    else
        a0.CharacterAdded:Connect(characterAdded)
        a0.CharacterRemoving:Connect(characterRemoving)
    end

    if a0.Character then
        v29[a0] = a0.Character
        characterRemoving = 1
        v28 = {}
        for k7, k8 in pairs(v29) do
            v28[characterRemoving] = k8
            characterRemoving = characterRemoving + 1
        end
    end
end

local function playerRemoving(a0) --[[ Upvalues: v29 (copy), v28 (ref), v5 (copy), v9 (copy) ]]
    v29[a0] = nil
    local v50 = 1
    v28 = {}
    for k9, k10 in pairs(v29) do
        v28[v50] = k10
        v50 = v50 + 1
    end

    if v5 then
        v9:disconnect(("%*CharacterAdded"):format(a0.UserId))
        v9:disconnect(("%*CharacterRemoving"):format(a0.UserId))
    end
end

Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)
local v54 = Players:GetPlayers()
for k11, k12 in ipairs(v54) do
    playerAdded(k12)
end

playerRemoving = 1
v28 = {}
for k13, k14 in pairs(v29) do
    v28[playerRemoving] = k14
    playerRemoving = playerRemoving + 1
end

v29 = nil
refreshIgnoreList = nil
if v4 then
    v1:Connect("CameraSubject", function() --[[ Upvalues: v1 (copy), refreshIgnoreList (ref) ]]
        local CameraSubject = v1:getCamera().CameraSubject
        if CameraSubject and CameraSubject:IsA("Humanoid") then
            refreshIgnoreList = CameraSubject.RootPart
            return
        end

        if CameraSubject and CameraSubject:IsA("BasePart") then
            refreshIgnoreList = CameraSubject
            return
        end

        refreshIgnoreList = nil
    end)
else
    local v61 = v6:GetPropertyChangedSignal("CameraSubject")
    v61:Connect(function() --[[ Upvalues: v6 (ref), refreshIgnoreList (ref) ]]
        local CameraSubject1 = v6.CameraSubject
        if CameraSubject1:IsA("Humanoid") then
            refreshIgnoreList = CameraSubject1.RootPart
            return
        end

        if CameraSubject1:IsA("BasePart") then
            refreshIgnoreList = CameraSubject1
            return
        end

        refreshIgnoreList = nil
    end)
end

local function canOcclude(a0) --[[ Upvalues: CommonUtils (copy), v29 (ref) ]]
    local v62 = false
    local v63 = 1 - a0.Transparency
    local v64 = 1 - v63 * (1 - a0.LocalTransparencyModifier)
    if v64 < 0.25 then
        local v65
        if CommonUtils or a0.CanCollide then
            v65 = false
            if v29 ~= (a0:GetRootPart() or a0) then
                v65 = not a0:IsA("TrussPart")
            end
        end
    end

    return v62
end

local v66 = Vector2.new(0.4, 0)
local v67 = Vector2.new(-0.4, 0)
local v68 = Vector2.new(0, -0.4)
local v69 = Vector2.new(0, 0.4)
playerAdded = {v66, v67, v68, v69, Vector2.new(0, 0.2)}

local function getCollisionPoint(a0, a1) --[[ Upvalues: CommonUtils (copy), v7 (copy), v28 (ref), new (copy) ]]
    if CommonUtils then
        v7.FilterDescendantsInstances = v28
        local v71 = workspace:Raycast(a0, a1, v7)
        if v71 then
            return v71.Position, true
            -- branch continues at 67
        end
    else
        local v72 = #v28
        while true do
            local v73 = new(a0, a1)
            local v74, v75 = workspace:FindPartOnRayWithIgnoreList(v73, v28, false, true)
            if v74 then
                if v74.CanCollide then
                    local v76 = v28
                    for i2 = #v76, v72 + 1, -1 do
                        v76[i2] = nil
                    end

                    return v75, true
                end

                v28[#v28 + 1] = v74
            end

            if not v74 then
                break
            end
        end

        v74 = v28
        v75 = v72 + 1
        v73 = -1
        for i3 = #v74, v75, v73 do
            v74[i3] = nil
        end
    end

    return a0 + a1, false
end

local function queryPoint(a0, a1, a2, a3) --[[ Upvalues: v28 (ref), v16 (ref), CommonUtils (copy), v7 (copy), v29 (ref), v8 (copy), new (copy) ]]
    debug.profilebegin("queryPoint")
    local v79 = #v28
    a2 = a2 + v16
    local v80 = a0 + a1 * a2
    local v81 = math.huge
    local v82 = math.huge
    local v83 = a0
    local v84 = 0
    if CommonUtils then
        v7.FilterDescendantsInstances = v28
        while true do
            local v85 = workspace:Raycast(v83, v80 - v83, v7)
            if v85 then
                v84 = v84 + 1
                local Instance = v85.Instance
                local Position = v85.Position
                local Magnitude = (Position - a0).Magnitude
                if 64 <= v84 then
                    v82 = Magnitude
                else
                    local v86 = false
                    local v87 = 1 - Instance.Transparency
                    local v88 = 1 - v87 * (1 - Instance.LocalTransparencyModifier)
                    if v88 < 0.25 then
                        local v89
                        if CommonUtils or Instance.CanCollide then
                            v89 = false
                            if v29 ~= (Instance:GetRootPart() or Instance) then
                                v89 = not Instance:IsA("TrussPart")
                            end
                        end
                    end

                    if v86 then
                        v88 = {Instance}
                        v8.FilterDescendantsInstances = v88
                        if workspace:Raycast(v80, Position - v80, v8) then
                            local v90
                            if a3 then
                                local v91 = workspace:Raycast(a3, v80 - a3, v8)
                                if not v91 then
                                    local v92 = workspace:Raycast(v80, a3 - v80, v8)
                                    -- branch continues at 117
                                end
                            else
                                v90 = false
                            end

                            if v90 then
                                v82 = Magnitude
                                -- jump to 125 (out of range)
                            end

                            if a2 < v81 then
                                v81 = Magnitude
                                -- branch continues at 125
                            end
                        else
                            v82 = Magnitude
                        end
                    end
                end

                v7:AddToFilter(Instance)
                v83 = Position - a1 * 0.001
                if v82 >= math.huge then
                    if not Instance then
                        -- jump to 275
                    end

                    -- branch continues at 275
                end

                -- branch continues at 275
            end
        end
    else
        while true do
            local v93 = new(v83, v80 - v83)
            local v94, v95 = workspace:FindPartOnRayWithIgnoreList(v93, v28, false, true)
            v84 = v84 + 1
            if v94 then
                v93 = 64 <= v84
                local v96 = false
                local v97 = 1 - v94.Transparency
                local v98 = 1 - v97 * (1 - v94.LocalTransparencyModifier)
                if v98 < 0.25 then
                    local v99
                    if CommonUtils or v94.CanCollide then
                        v99 = false
                        if v29 ~= (v94:GetRootPart() or v94) then
                            v99 = not v94:IsA("TrussPart")
                        end
                    end
                end

                if v96 or v93 then
                    v96 = {v94}
                    local v100 = new(v80, v95 - v80)
                    local v101 = workspace:FindPartOnRayWithWhitelist(v100, v96, true)
                    local Magnitude1 = (v95 - a0).Magnitude
                    if v101 then
                        if not v93 then
                            v100 = false
                            if a3 then
                                local v102 = new(a3, v80 - a3)
                                local v104 = new(v80, a3 - v80)
                                local v105 = workspace:FindPartOnRayWithWhitelist(v104, v96, true)
                                local v106 = workspace:FindPartOnRayWithWhitelist(v102, v96, true) or v105
                                v100 = v106
                            end

                            if v100 then
                                v82 = Magnitude1
                                -- jump to 255 (out of range)
                            end

                            if a2 < v81 then
                                v81 = Magnitude1
                                -- branch continues at 255
                            end

                            -- branch continues at 254
                        end
                    else
                        v82 = Magnitude1
                    end
                end

                v28[#v28 + 1] = v94
                v83 = v95 - a1 * 0.001
            end

            if v82 < math.huge or not v94 then
                break
            end
        end

        v94 = v28
        v95 = v79 + 1
        for i4 = #v94, v95, -1 do
            v94[i4] = nil
        end
    end

    debug.profileend()
    local v108 = v81 - v16
    return v108, v82 - v16
end

local function queryViewport(a0, a1) --[[ Upvalues: v6 (ref), v4 (copy), v1 (copy), v14 (ref), v15 (ref), v16 (ref), queryPoint (copy) ]]
    debug.profilebegin("queryViewport")
    local p = a0.p
    local rightVector = a0.rightVector
    local upVector = a0.upVector
    local v109 = -a0.lookVector
    local v110
    if v4 then
        local v111 = v1:getCamera()
    else
        v110 = v6
    end

    v6 = v110
    local ViewportSize4 = v6.ViewportSize
    local v112 = math.huge
    local v113 = math.huge
    for i5 = 0, 1 do
        local v116 = rightVector * ((i5 - 0.5) * v14)
        for i6 = 0, 1 do
            local v119 = p + v16 * (v116 + upVector * ((i6 - 0.5) * v15))
            local v120 = ViewportSize4.x * i5
            local v121, v122 = queryPoint(v119, v109, a1, v6:ViewportPointToRay(v120, ViewportSize4.y * i6).Origin)
            if v122 < v112 then
                v112 = v122
            end

            if v121 < v113 then
                v113 = v121
            end
        end
    end

    debug.profileend()
    return v113, v112
end

local function testPromotion(a0, a1, a2) --[[ Upvalues: getCollisionPoint (copy), v2 (copy), queryPoint (copy), playerAdded (copy) ]]
    debug.profilebegin("testPromotion")
    local p1 = a0.p
    local rightVector1 = a0.rightVector
    local upVector1 = a0.upVector
    local v123 = -a0.lookVector
    debug.profilebegin("extrapolate")
    for i7 = 0, v2(1.25, a2.rotVelocity.magnitude + (getCollisionPoint(p1, a2.posVelocity * 1.25) - p1).Magnitude / a2.posVelocity.magnitude), 0.0625 do
        local v127 = a2.extrapolate(i7)
        local v128 = -v127.lookVector
        if a1 <= queryPoint(v127.p, v128, a1) then
            return false
        end
    end

    debug.profileend()
    debug.profilebegin("testOffsets")
    for k15, k16 in ipairs(playerAdded) do
        local v132 = rightVector1 * k16.x
        local v133 = getCollisionPoint(p1, v132 + upVector1 * k16.y)
        if queryPoint(v133, (p1 + v123 * a1 - v133).Unit, a1) == math.huge then
            return false
        end
    end

    debug.profileend()
    debug.profileend()
    return true
end

local function Popper(a0, a1, a2) --[[ Upvalues: v29 (ref), refreshIgnoreList (ref), queryViewport (copy), testPromotion (copy) ]]
    debug.profilebegin("popper")
    local v136 = refreshIgnoreList and refreshIgnoreList:GetRootPart() or refreshIgnoreList
    v29 = v136
    v136 = a1
    local v137, v138 = queryViewport(a0, a1)
    if v138 < v136 then
        v136 = v138
    end

    if v137 < v136 and testPromotion(a0, a1, a2) then
        v136 = v137
    end

    v29 = nil
    debug.profileend()
    return v136
end

return Popper
