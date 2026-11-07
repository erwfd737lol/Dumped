
local v2, v3 = pcall(function()
    local v1 = UserSettings():IsUserFeatureEnabled("UserExcludeNonCollidableForPathfinding")
    return v1
end)
local v4 = v2 and v3
local v6, v7 = pcall(function()
    local v5 = UserSettings():IsUserFeatureEnabled("UserClickToMoveSupportAgentCanClimb2")
    return v5
end)
v3 = v6 and v7
local UserInputService = game:GetService("UserInputService")
v6 = game:GetService("PathfindingService")
v2 = game:GetService("Players")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
CommonUtils = require(FlagUtil).getUserFlag("UserRaycastUpdateAPI2")
local v8 = true
local v9 = true
local v10 = false
local v11 = 1
local v12 = 8
local v13 = {
    [Enum.KeyCode.W] = true,
    [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true,
    [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true,
    [Enum.KeyCode.Down] = true
}
local LocalPlayer = v2.LocalPlayer
local ClickToMoveDisplay = script.Parent:WaitForChild("ClickToMoveDisplay")
local v14 = require(ClickToMoveDisplay)
local v15 = RaycastParams.new()
v15.FilterType = Enum.RaycastFilterType.Exclude
local v16 = {}
if not CommonUtils then

    local function FindCharacterAncestor(a0) --[[ Upvalues: FindCharacterAncestor (copy) ]]
        if a0 then
            local v17 = a0:FindFirstChildOfClass("Humanoid")
            if v17 then
                return a0, v17
            end

            local v18 = FindCharacterAncestor(a0.Parent)
            return v18
        end
    end

    v16.FindCharacterAncestor = FindCharacterAncestor

    local function Raycast(a0, a1, a2) --[[ Upvalues: Workspace (copy), FindCharacterAncestor (copy), Raycast (copy) ]]
        local v19 = a2
        if not v19 then
            v19 = {}
        end

        a2 = v19
        local v20, v21, v22, v23 = Workspace:FindPartOnRayWithIgnoreList(a0, a2)
        if v20 then
            if a1 then
                if v20.CanCollide == false then
                    local v24
                    if v20 then
                        local v25 = v20:FindFirstChildOfClass("Humanoid")
                        if v25 then
                            v24 = v25
                            -- jump to 38 (out of range)
                        end

                        local v26, v27 = FindCharacterAncestor(v20.Parent)
                        v24 = v27
                    else
                        v24 = nil
                    end

                    if v24 == nil then
                        table.insert(a2, v20)
                        local v28 = Raycast(a0, a1, a2)
                        return v28
                    end
                end
            end

            return v20, v21, v22, v23
        end

        return nil, nil
    end

    v16.Raycast = Raycast
end

local v29 = {}

local function findPlayerHumanoid(a0) --[[ Upvalues: v29 (copy) ]]
    local v31 = a0 and a0.Character
    if v31 then
        local v32 = v29[a0]
        if v32 and v32.Parent == v31 then
            return v32
        end

        v29[a0] = nil
        local v33 = v31:FindFirstChildOfClass("Humanoid")
        if v33 then
            v29[a0] = v33
        end

        return v33
    end
end

local v34 = nil
local v35 = nil

local function GetCharacter() --[[ Upvalues: LocalPlayer (copy) ]]
    local v37 = LocalPlayer and LocalPlayer.Character
    return v37
end

local v38 = nil
local v39 = nil

local function UpdateIgnoreTag(a0) --[[ Upvalues: v35 (ref), v38 (ref), v39 (ref), v34 (ref), LocalPlayer (copy), CollectionService (copy) ]]
    if a0 == v35 then
        return
    end

    if v38 then
        v38:Disconnect()
        v38 = nil
    end

    if v39 then
        v39:Disconnect()
        v39 = nil
    end

    v35 = a0
    local v40 = {}
    local v42 = LocalPlayer and LocalPlayer.Character
    v40[1] = v42
    v34 = v40
    if v35 ~= nil then
        local v43 = CollectionService:GetTagged(v35)
        for k1, k2 in ipairs(v43) do
            table.insert(v34, k2)
        end

        local v47 = CollectionService:GetInstanceAddedSignal(v35)
        v38 = v47:Connect(function(a0) --[[ Upvalues: v34 (upvalue) ]]
            table.insert(v34, a0)
        end)
        local v48 = CollectionService:GetInstanceRemovedSignal(v35)
        v39 = v48:Connect(function(a0) --[[ Upvalues: v34 (upvalue) ]]
            for i1 = 1, #v34 do
                if v34[i1] == a0 then
                    v34[i1] = v34[#v34]
                    table.remove(v34)
                    return
                end
            end

        end)
    end
end

local function getIgnoreList() --[[ Upvalues: v34 (ref), LocalPlayer (copy) ]]
    if v34 then
        return v34
    end

    v34 = {}
    assert(v34, "")
    local v52 = LocalPlayer and LocalPlayer.Character
    table.insert(v34, v52)
    return v34
end

local function minV(a0, a1)
    local v53 = math.min(a0.X, a1.X)
    local v54 = math.min(a0.Y, a1.Y)
    return Vector3.new(v53, v54, math.min(a0.Z, a1.Z))
end

local function maxV(a0, a1)
    local v55 = math.max(a0.X, a1.X)
    local v56 = math.max(a0.Y, a1.Y)
    return Vector3.new(v55, v56, math.max(a0.Z, a1.Z))
end

local function getCollidableExtentsSize(a0)
    if a0 == nil or a0.PrimaryPart == nil then
        return
    end

    assert(a0, "")
    assert(a0.PrimaryPart, "")
    local v57 = a0.PrimaryPart.CFrame:Inverse()
    local v58 = Vector3.new(math.huge, math.huge, math.huge)
    local v59 = Vector3.new(-math.huge, -math.huge, -math.huge)
    local v60 = a0:GetDescendants()
    for k3, k4 in pairs(v60) do
        if k4:IsA("BasePart") and k4.CanCollide then
            local v64 = v57 * k4.CFrame
            local v65 = k4.Size.X / 2
            local v66 = k4.Size.Y / 2
            local v67 = Vector3.new(v65, v66, k4.Size.Z / 2)
            v65 = {}
            local v68 = Vector3.new(v67.X, v67.Y, v67.Z)
            local v69 = Vector3.new(v67.X, v67.Y, -v67.Z)
            local v70 = -v67.Y
            local v71 = Vector3.new(v67.X, v70, v67.Z)
            local v72 = -v67.Y
            local v73 = Vector3.new(v67.X, v72, -v67.Z)
            v72 = -v67.X
            local v74 = Vector3.new(v72, v67.Y, v67.Z)
            local v75 = -v67.X
            local v76 = Vector3.new(v75, v67.Y, -v67.Z)
            local v77 = -v67.X
            local v78 = -v67.Y
            local v79 = Vector3.new(v77, v78, v67.Z)
            v78 = -v67.X
            local v80 = -v67.Y
            v65[1] = v68
            v65[2] = v69
            v65[3] = v71
            v65[4] = v73
            v65[5] = v74
            v65[6] = v76
            v65[7] = v79
            v65[8] = Vector3.new(v78, v80, -v67.Z)
            for k5, k6 in ipairs(v65) do
                v67 = v64 * k6
                v76 = v58
                local v84 = math.min(v76.X, v67.X)
                local v85 = math.min(v76.Y, v67.Y)
                v58 = Vector3.new(v84, v85, math.min(v76.Z, v67.Z))
                v76 = v59
                local v86 = math.max(v76.X, v67.X)
                local v87 = math.max(v76.Y, v67.Y)
                v59 = Vector3.new(v86, v87, math.max(v76.Z, v67.Z))
            end
        end
    end

    v57 = v59 - v58
    if v57.X < 0 or v57.Y < 0 or v57.Z < 0 then
        return nil
    end

    return v57
end

local function Pather(a0, a1, a2) --[[ Upvalues: v10 (ref), LocalPlayer (copy), v29 (copy), v11 (ref), v4 (copy), getCollidableExtentsSize (copy), v3 (copy), v6 (copy), v8 (ref), v14 (copy), v12 (ref), CommonUtils (copy), v15 (copy), v34 (ref), Workspace (copy) ]]
    local t1 = {}
    local v88, v89
    if a2 ~= nil then
        v88 = a2
        v89 = a2
    else
        v88 = v10
        v89 = true
    end

    t1.Cancelled = false
    t1.Started = false
    t1.Finished = Instance.new("BindableEvent")
    t1.PathFailed = Instance.new("BindableEvent")
    t1.PathComputing = false
    t1.PathComputed = false
    t1.OriginalTargetPoint = a0
    t1.TargetPoint = a0
    t1.TargetSurfaceNormal = a1
    t1.DiedConn = nil
    t1.SeatedConn = nil
    t1.BlockedConn = nil
    t1.TeleportedConn = nil
    t1.CurrentPoint = 0
    t1.HumanoidOffsetFromPath = Vector3.new(0, 0, 0)
    t1.CurrentWaypointPosition = nil
    t1.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
    t1.CurrentWaypointPlaneDistance = 0
    t1.CurrentWaypointNeedsJump = false
    t1.CurrentHumanoidPosition = Vector3.new(0, 0, 0)
    t1.CurrentHumanoidVelocity = 0
    t1.NextActionMoveDirection = Vector3.new(0, 0, 0)
    t1.NextActionJump = false
    t1.Timeout = 0
    local v90 = LocalPlayer
    local v92 = v90 and v90.Character
    local v93
    if v92 then
        local v94 = v29[v90]
        if v94 and v94.Parent == v92 then
            v93 = v94
            -- jump to 117 (out of range)
        end

        v29[v90] = nil
        local v95 = v92:FindFirstChildOfClass("Humanoid")
        if v95 then
            v29[v90] = v95
        end

        v93 = v95
    else
        v93 = nil
    end

    t1.Humanoid = v93
    t1.OriginPoint = nil
    t1.AgentCanFollowPath = false
    t1.DirectPath = false
    t1.DirectPathRiseFirst = false
    t1.stopTraverseFunc = nil
    t1.setPointFunc = nil
    t1.pointList = nil
    local v96 = t1.Humanoid and t1.Humanoid.RootPart
    if v96 then
        t1.OriginPoint = v96.CFrame.Position
        local v97 = 2
        v92 = 5
        local v98 = true
        local SeatPart = t1.Humanoid.SeatPart
        if SeatPart then
            if SeatPart:IsA("VehicleSeat") then
                local v101 = SeatPart:FindFirstAncestorOfClass("Model")
                local v102
                if v101 then
                    v102 = v101.PrimaryPart
                    v101.PrimaryPart = SeatPart
                    if v89 then
                        local v103 = v101:GetExtentsSize()
                        local v104 = v11 * 0.5
                        local v105 = v103.X * v103.X
                        v97 = v104 * math.sqrt(v105 + v103.Z * v103.Z)
                        v92 = v11 * v103.Y
                        v98 = false
                        t1.AgentCanFollowPath = true
                        t1.DirectPath = v89
                    end

                    v101.PrimaryPart = v102
                    -- branch continues at 290
                end

                -- branch continues at 214
            end
        else
            local v106 = nil
            if v4 then
                local v108 = LocalPlayer and LocalPlayer.Character
                if v108 ~= nil then
                    v106 = getCollidableExtentsSize(v108)
                end
            end

            if v106 == nil then
                local v110 = LocalPlayer and LocalPlayer.Character
                v106 = v110:GetExtentsSize()
            end

            assert(v106, "")
            local v111 = v11 * 0.5
            local v112 = v106.X * v106.X
            v97 = v111 * math.sqrt(v112 + v106.Z * v106.Z)
            v92 = v11 * v106.Y
            v98 = 0 < t1.Humanoid.JumpPower
            t1.AgentCanFollowPath = true
            t1.DirectPath = v88
            t1.DirectPathRiseFirst = t1.Humanoid.Sit
        end

        if v3 then
            local v113 = {
                AgentCanClimb = true,
                AgentRadius = v97,
                AgentHeight = v92,
                AgentCanJump = v98
            }
            t1.pathResult = v6:CreatePath(v113)
        else
            local v114 = {AgentRadius = v97, AgentHeight = v92, AgentCanJump = v98}
            t1.pathResult = v6:CreatePath(v114)
        end
    end

    local function Cleanup(a0) --[[ Upvalues: t1 (copy) ]]
        if t1.stopTraverseFunc then
            t1.stopTraverseFunc()
            t1.stopTraverseFunc = nil
        end

        if t1.BlockedConn then
            t1.BlockedConn:Disconnect()
            t1.BlockedConn = nil
        end

        if t1.DiedConn then
            t1.DiedConn:Disconnect()
            t1.DiedConn = nil
        end

        if t1.SeatedConn then
            t1.SeatedConn:Disconnect()
            t1.SeatedConn = nil
        end

        if t1.TeleportedConn then
            t1.TeleportedConn:Disconnect()
            t1.TeleportedConn = nil
        end

        t1.Started = false
    end

    t1.Cleanup = Cleanup

    local function Cancel(a0) --[[ Upvalues: t1 (copy) ]]
        t1.Cancelled = true
        t1:Cleanup()
    end

    t1.Cancel = Cancel

    local function IsActive(a0) --[[ Upvalues: t1 (copy) ]]
        local v116 = t1.AgentCanFollowPath and t1.Started and not t1.Cancelled
        return v116
    end

    t1.IsActive = IsActive

    local function OnPathInterrupted(a0) --[[ Upvalues: t1 (copy) ]]
        t1.Cancelled = true
        t1:OnPointReached(false)
    end

    t1.OnPathInterrupted = OnPathInterrupted

    local function ComputePath(a0) --[[ Upvalues: t1 (copy) ]]
        if t1.OriginPoint then
            if t1.PathComputed or t1.PathComputing then
                return
            end

            t1.PathComputing = true
            if t1.AgentCanFollowPath then
                if t1.DirectPath then
                    local v117 = t1
                    local v118 = {}
                    local v119 = PathWaypoint.new(t1.OriginPoint, Enum.PathWaypointAction.Walk)
                    local v120 = PathWaypoint.new(t1.TargetPoint, t1.DirectPathRiseFirst and Enum.PathWaypointAction.Jump or Enum.PathWaypointAction.Walk)
                    v118[1] = v119
                    v118[2] = v120
                    v117.pointList = v118
                    t1.PathComputed = true
                else
                    t1.pathResult:ComputeAsync(t1.OriginPoint, t1.TargetPoint)
                    t1.pointList = t1.pathResult:GetWaypoints()
                    t1.BlockedConn = t1.pathResult.Blocked:Connect(function(a0) --[[ Upvalues: t1 (upvalue) ]]
                        t1:OnPathBlocked(a0)
                    end)
                    t1.PathComputed = t1.pathResult.Status == Enum.PathStatus.Success
                end
            end

            t1.PathComputing = false
        end
    end

    t1.ComputePath = ComputePath

    local function IsValidPath(a0) --[[ Upvalues: t1 (copy) ]]
        t1:ComputePath()
        local v121 = t1.PathComputed and t1.AgentCanFollowPath
        return v121
    end

    t1.IsValidPath = IsValidPath
    t1.Recomputing = false

    local function OnPathBlocked(a0, a1) --[[ Upvalues: t1 (copy), v8 (upvalue), v14 (upvalue) ]]
        if not (t1.CurrentPoint <= a1) or t1.Recomputing then
            return
        end

        t1.Recomputing = true
        if t1.stopTraverseFunc then
            t1.stopTraverseFunc()
            t1.stopTraverseFunc = nil
        end

        t1.OriginPoint = t1.Humanoid.RootPart.CFrame.p
        t1.pathResult:ComputeAsync(t1.OriginPoint, t1.TargetPoint)
        t1.pointList = t1.pathResult:GetWaypoints()
        local v122 = #t1.pointList
        if 0 < v122 then
            t1.HumanoidOffsetFromPath = t1.pointList[1].Position - t1.OriginPoint
        end

        t1.PathComputed = t1.pathResult.Status == Enum.PathStatus.Success
        if v8 then
            local v123, v124 = v14.CreatePathDisplay(t1.pointList)
            t1.stopTraverseFunc = v123
            t1.setPointFunc = v124
        end

        if t1.PathComputed then
            t1.CurrentPoint = 1
            t1:OnPointReached(true)
        else
            t1.PathFailed:Fire()
            t1:Cleanup()
        end

        t1.Recomputing = false
    end

    t1.OnPathBlocked = OnPathBlocked

    local function OnRenderStepped(a0, a1) --[[ Upvalues: t1 (copy), v12 (upvalue) ]]
        if t1.Started and not t1.Cancelled then
            t1.Timeout = t1.Timeout + a1
            if v12 < t1.Timeout then
                t1:OnPointReached(false)
                return
            end

            t1.CurrentHumanoidPosition = t1.Humanoid.RootPart.Position + t1.HumanoidOffsetFromPath
            t1.CurrentHumanoidVelocity = t1.Humanoid.RootPart.Velocity
            while t1.Started and t1:IsCurrentWaypointReached() do
                t1:OnPointReached(true)
            end

            if t1.Started then
                t1.NextActionMoveDirection = t1.CurrentWaypointPosition - t1.CurrentHumanoidPosition
                if 1e-06 < t1.NextActionMoveDirection.Magnitude then
                    t1.NextActionMoveDirection = t1.NextActionMoveDirection.Unit
                else
                    t1.NextActionMoveDirection = Vector3.new(0, 0, 0)
                end

                if t1.CurrentWaypointNeedsJump then
                    t1.NextActionJump = true
                    t1.CurrentWaypointNeedsJump = false
                    return
                end

                t1.NextActionJump = false
            end
        end
    end

    t1.OnRenderStepped = OnRenderStepped

    local function IsCurrentWaypointReached(a0) --[[ Upvalues: t1 (copy) ]]
        local v125
        if t1.CurrentWaypointPlaneNormal ~= Vector3.new(0, 0, 0) then
            local v126 = t1.CurrentWaypointPlaneNormal:Dot(t1.CurrentHumanoidPosition)
            local v127 = v126 - t1.CurrentWaypointPlaneDistance
            v125 = v127 < math.max(1, 0.0625 * -t1.CurrentWaypointPlaneNormal:Dot(t1.CurrentHumanoidVelocity))
        else
            v125 = true
        end

        if v125 then
            t1.CurrentWaypointPosition = nil
            t1.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
            t1.CurrentWaypointPlaneDistance = 0
        end

        return v125
    end

    t1.IsCurrentWaypointReached = IsCurrentWaypointReached

    local function OnPointReached(a0, a1) --[[ Upvalues: t1 (copy) ]]
        if a1 then
            if not t1.Cancelled then
                if t1.setPointFunc then
                    t1.setPointFunc(t1.CurrentPoint)
                end

                local v128 = t1.CurrentPoint + 1
                if #t1.pointList < v128 then
                    if t1.stopTraverseFunc then
                        t1.stopTraverseFunc()
                    end

                    t1.Finished:Fire()
                    t1:Cleanup()
                    return
                end

                local v129 = t1.pointList[t1.CurrentPoint]
                local v130 = t1.pointList[v128]
                local v131 = t1.Humanoid:GetState()
                local v132 = true
                if v131 ~= Enum.HumanoidStateType.FallingDown then
                    v132 = true
                    if v131 ~= Enum.HumanoidStateType.Freefall then
                        v132 = v131 == Enum.HumanoidStateType.Jumping
                    end
                end

                if v132 then
                    v131 = v130.Action == Enum.PathWaypointAction.Jump
                    if not v131 then
                        if 1 < t1.CurrentPoint then
                            local v133 = t1.pointList[t1.CurrentPoint - 1]
                            local v134 = v129.Position - v133.Position
                            v133 = v130.Position - v129.Position
                            local v135 = Vector2.new(v134.x, v134.z).Unit:Dot(Vector2.new(v133.x, v133.z).Unit)
                            v131 = v135 < 0.996
                        end
                    end

                    if v131 then
                        t1.Humanoid.FreeFalling:Wait()
                        wait(0.1)
                    end
                end

                t1:MoveToNextWayPoint(v129, v130, v128)
                return
            end
        end

        t1.PathFailed:Fire()
        t1:Cleanup()
    end

    t1.OnPointReached = OnPointReached

    local function MoveToNextWayPoint(a0, a1, a2, a3) --[[ Upvalues: t1 (copy), v3 (upvalue) ]]
        t1.CurrentWaypointPlaneNormal = a1.Position - a2.Position
        if not v3 or a2.Label ~= "Climb" then
            t1.CurrentWaypointPlaneNormal = Vector3.new(t1.CurrentWaypointPlaneNormal.X, 0, t1.CurrentWaypointPlaneNormal.Z)
        end

        if 1e-06 < t1.CurrentWaypointPlaneNormal.Magnitude then
            t1.CurrentWaypointPlaneNormal = t1.CurrentWaypointPlaneNormal.Unit
            t1.CurrentWaypointPlaneDistance = t1.CurrentWaypointPlaneNormal:Dot(a2.Position)
        else
            t1.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
            t1.CurrentWaypointPlaneDistance = 0
        end

        t1.CurrentWaypointNeedsJump = a2.Action == Enum.PathWaypointAction.Jump
        t1.CurrentWaypointPosition = a2.Position
        t1.CurrentPoint = a3
        t1.Timeout = 0
    end

    t1.MoveToNextWayPoint = MoveToNextWayPoint

    local function Start(a0, a1) --[[ Upvalues: t1 (copy), v14 (upvalue), v8 (upvalue) ]]
        if not t1.AgentCanFollowPath then
            t1.PathFailed:Fire()
            return
        end

        if t1.Started then
            return
        end

        t1.Started = true
        v14.CancelFailureAnimation()
        if v8 then
            if a1 == nil or a1 then
                local v136, v137 = v14.CreatePathDisplay(t1.pointList, t1.OriginalTargetPoint)
                t1.stopTraverseFunc = v136
                t1.setPointFunc = v137
            end
        end

        local v138 = #t1.pointList
        if 0 < v138 then
            local v139 = t1.pointList[1].Position.Y - t1.OriginPoint.Y
            t1.HumanoidOffsetFromPath = Vector3.new(0, v139, 0)
            t1.CurrentHumanoidPosition = t1.Humanoid.RootPart.Position + t1.HumanoidOffsetFromPath
            t1.CurrentHumanoidVelocity = t1.Humanoid.RootPart.Velocity
            t1.SeatedConn = t1.Humanoid.Seated:Connect(function(a0, a1) --[[ Upvalues: t1 (upvalue) ]]
                t1:OnPathInterrupted()
            end)
            t1.DiedConn = t1.Humanoid.Died:Connect(function() --[[ Upvalues: t1 (upvalue) ]]
                t1:OnPathInterrupted()
            end)
            local v140 = t1.Humanoid.RootPart:GetPropertyChangedSignal("CFrame")
            t1.TeleportedConn = v140:Connect(function() --[[ Upvalues: t1 (upvalue) ]]
                t1:OnPathInterrupted()
            end)
            t1.CurrentPoint = 1
            t1:OnPointReached(true)
            return
        end

        t1.PathFailed:Fire()
        if t1.stopTraverseFunc then
            t1.stopTraverseFunc()
        end
    end

    t1.Start = Start
    v96 = t1.TargetPoint + t1.TargetSurfaceNormal * 1.5
    if CommonUtils then
        local v141 = v15
        local v142
        if v34 then
            v142 = v34
        else
            v34 = {}
            assert(v34, "")
            local v144 = LocalPlayer and LocalPlayer.Character
            table.insert(v34, v144)
            v142 = v34
        end

        v141.FilterDescendantsInstances = v142
        v89 = Workspace:Raycast(v96, Vector3.new(0, -50, 0), v15)
        if v89 then
            t1.TargetPoint = v89.Position
            -- branch continues at 472
        end
    else
        v88 = Ray.new(v96, Vector3.new(0, -50, 0))
        local v145 = Workspace
        local v146
        if v34 then
            v146 = v34
        else
            v34 = {}
            assert(v34, "")
            local v148 = LocalPlayer and LocalPlayer.Character
            table.insert(v34, v148)
            v146 = v34
        end

        local v149, v150 = v145:FindPartOnRayWithIgnoreList(v88, v146)
        if v149 then
            t1.TargetPoint = v150
        end
    end

    t1:ComputePath()
    return t1
end

local function CheckAlive() --[[ Upvalues: LocalPlayer (copy), v29 (copy) ]]
    local v151 = LocalPlayer
    local v153 = v151 and v151.Character
    local v154
    if v153 then
        local v155 = v29[v151]
        if v155 and v155.Parent == v153 then
            v154 = v155
            -- jump to 29 (out of range)
        end

        v29[v151] = nil
        local v156 = v153:FindFirstChildOfClass("Humanoid")
        if v156 then
            v29[v151] = v156
        end

        v154 = v156
    else
        v154 = nil
    end

    v151 = false
    if v154 ~= nil then
        v151 = 0 < v154.Health
    end

    return v151
end

local function GetEquippedTool(a0)
    if a0 ~= nil then
        local v157 = a0:GetChildren()
        for k7, k8 in pairs(v157) do
            if k8:IsA("Tool") then
                return k8
            end
        end
    end
end

local v161 = nil
local v162 = nil
local v163 = nil

local function CleanupPath() --[[ Upvalues: v161 (ref), v162 (ref), v163 (ref) ]]
    if v161 then
        v161:Cancel()
        v161 = nil
    end

    if v162 then
        v162:Disconnect()
        v162 = nil
    end

    if v163 then
        v163:Disconnect()
        v163 = nil
    end
end

local function HandleMoveTo(a0, a1, a2, a3, a4) --[[ Upvalues: v161 (ref), v162 (ref), v163 (ref), GetEquippedTool (copy), v9 (ref), v14 (copy) ]]
    if v161 then
        if v161 then
            v161:Cancel()
            v161 = nil
        end

        if v162 then
            v162:Disconnect()
            v162 = nil
        end

        if v163 then
            v163:Disconnect()
            v163 = nil
        end
    end

    v161 = a0
    a0:Start(a4)
    v162 = a0.Finished.Event:Connect(function() --[[ Upvalues: v161 (upvalue), v162 (upvalue), v163 (upvalue), a2 (copy), GetEquippedTool (upvalue), a3 (copy) ]]
        if v161 then
            v161:Cancel()
            v161 = nil
        end

        if v162 then
            v162:Disconnect()
            v162 = nil
        end

        if v163 then
            v163:Disconnect()
            v163 = nil
        end

        if a2 then
            local v165 = GetEquippedTool(a3)
            if v165 then
                v165:Activate()
            end
        end

    end)
    v163 = a0.PathFailed.Event:Connect(function() --[[ Upvalues: v161 (upvalue), v162 (upvalue), v163 (upvalue), a4 (copy), v9 (upvalue), v14 (upvalue), a1 (copy) ]]
        if v161 then
            v161:Cancel()
            v161 = nil
        end

        if v162 then
            v162:Disconnect()
            v162 = nil
        end

        if v163 then
            v163:Disconnect()
            v163 = nil
        end

        if a4 == nil or a4 then
            local v166 = v9
            if v166 then
                local v169 = v161 and v161:IsActive()
                v166 = not v169
            end

            if v166 then
                v14.PlayFailureAnimation()
            end

            v14.DisplayFailureWaypoint(a1)
        end

    end)
end

local function ShowPathFailedFeedback(a0) --[[ Upvalues: v161 (ref), v9 (ref), v14 (copy) ]]
    if v161 and v161:IsActive() then
        v161:Cancel()
    end

    if v9 then
        v14.PlayFailureAnimation()
    end

    v14.DisplayFailureWaypoint(a0)
end

local function OnTap(a0, a1, a2) --[[ Upvalues: Workspace (copy), LocalPlayer (copy), v29 (copy), CommonUtils (copy), v34 (ref), v15 (copy), StarterGui (copy), v2 (copy), v161 (ref), v162 (ref), v163 (ref), Pather (copy), HandleMoveTo (copy), v9 (ref), v14 (copy), v16 (copy), GetEquippedTool (copy) ]]
    local CurrentCamera = Workspace.CurrentCamera
    local Character10 = LocalPlayer.Character
    local v170 = LocalPlayer
    local v172 = v170 and v170.Character
    local v173
    if v172 then
        local v174 = v29[v170]
        if v174 and v174.Parent == v172 then
            v173 = v174
            -- jump to 35 (out of range)
        end

        v29[v170] = nil
        local v175 = v172:FindFirstChildOfClass("Humanoid")
        if v175 then
            v29[v170] = v175
        end

        v173 = v175
    else
        v173 = nil
    end

    local v176 = false
    if v173 ~= nil then
        v176 = 0 < v173.Health
    end

    if not v176 then
        return
    end

    if #a0 == 1 or a1 then
        if CurrentCamera then
            local v177 = CurrentCamera:ScreenPointToRay(a0[1].X, a0[1].Y)
            if CommonUtils then
                local v178 = nil
                local v179 = nil
                local v180
                if v34 then
                    v180 = v34
                else
                    v34 = {}
                    assert(v34, "")
                    local v182 = LocalPlayer and LocalPlayer.Character
                    table.insert(v34, v182)
                    v180 = v34
                end

                if not v180 then
                    v180 = {}
                end

                local v183
                while true do
                    local v184 = true
                    v15.FilterDescendantsInstances = v180
                    local v185 = v177.Direction * 1000
                    v183 = Workspace:Raycast(v177.Origin, v185, v15)
                    if v183 then
                        local Instance = v183.Instance
                        if not Instance.CanCollide then
                            while true do
                                v178 = Instance:FindFirstChildOfClass("Humanoid")
                                v179 = Instance
                                Instance = Instance.Parent
                                if v178 or not Instance then
                                    break
                                end
                            end

                            if not v178 and Instance then
                                v179 = nil
                                v184 = false
                                table.insert(v180, Instance)
                            end
                        end
                    end

                    if v184 then
                        break
                    end
                end

                if a2 then
                    if v178 then
                        if StarterGui:GetCore("AvatarContextMenuEnabled") then
                            if v2:GetPlayerFromCharacter(v178.Parent) then
                                if v161 then
                                    v161:Cancel()
                                    v161 = nil
                                end

                                if v162 then
                                    v162:Disconnect()
                                    v162 = nil
                                end

                                if v163 then
                                    v163:Disconnect()
                                    v163 = nil
                                end

                                return
                            end
                        end
                    end
                end

                if not (v183 and Character10) then
                    return
                end

                v178 = v183.Position
                if a1 then
                    v178 = a1
                    v179 = nil
                end

                if v161 then
                    v161:Cancel()
                    v161 = nil
                end

                if v162 then
                    v162:Disconnect()
                    v162 = nil
                end

                if v163 then
                    v163:Disconnect()
                    v163 = nil
                end

                local v186 = Pather(v178, v183.Normal)
                if v186:IsValidPath() then
                    HandleMoveTo(v186, v178, v179, Character10)
                    return
                end

                v186:Cleanup()
                if v161 and v161:IsActive() then
                    v161:Cancel()
                end

                if v9 then
                    v14.PlayFailureAnimation()
                end

                v14.DisplayFailureWaypoint(v178)
                return
            end

            local v187 = Ray.new(v177.Origin, v177.Direction * 1000)
            local Raycast1 = v16.Raycast
            local v188
            if v34 then
                v188 = v34
            else
                v34 = {}
                assert(v34, "")
                local v190 = LocalPlayer and LocalPlayer.Character
                table.insert(v34, v190)
                v188 = v34
            end

            local v191, v192, v193 = Raycast1(v187, true, v188)
            local v194, v195 = v16.FindCharacterAncestor(v191)
            if a2 then
                if v195 then
                    if StarterGui:GetCore("AvatarContextMenuEnabled") then
                        if v2:GetPlayerFromCharacter(v195.Parent) then
                            if v161 then
                                v161:Cancel()
                                v161 = nil
                            end

                            if v162 then
                                v162:Disconnect()
                                v162 = nil
                            end

                            if v163 then
                                v163:Disconnect()
                                v163 = nil
                            end

                            return
                        end
                    end
                end
            end

            if a1 then
                v192 = a1
                v194 = nil
            end

            if v192 then
                if Character10 then
                    if v161 then
                        v161:Cancel()
                        v161 = nil
                    end

                    if v162 then
                        v162:Disconnect()
                        v162 = nil
                    end

                    if v163 then
                        v163:Disconnect()
                        v163 = nil
                    end

                    local v196 = Pather(v192, v193)
                    if v196:IsValidPath() then
                        HandleMoveTo(v196, v192, v194, Character10)
                        return
                    end

                    v196:Cleanup()
                    if v161 and v161:IsActive() then
                        v161:Cancel()
                    end

                    if v9 then
                        v14.PlayFailureAnimation()
                    end

                    v14.DisplayFailureWaypoint(v192)
                    return
                    -- branch continues at 462
                end

                -- branch continues at 462
            end

            -- branch continues at 462
        end
    end

    if 2 <= #a0 then
        if CurrentCamera then
            local v199 = GetEquippedTool(Character10)
            if v199 then
                v199:Activate()
            end
        end
    end
end

OnTap = OnTap

local function DisconnectEvent(a0)
    if a0 then
        a0:Disconnect()
    end
end

local Keyboard = script.Parent:WaitForChild("Keyboard")
local v200 = require(Keyboard)
local v201 = setmetatable({}, v200)
v201.__index = v201

local function new(a0) --[[ Upvalues: v200 (copy), v201 (copy) ]]
    local v202 = v200.new(a0)
    local v203 = setmetatable(v202, v201)
    v203.fingerTouches = {}
    v203.numUnsunkTouches = 0
    v203.mouse2DownTime = tick()
    v203.mouse2DownPos = Vector2.new()
    v203.mouse2UpTime = tick()
    v203.keyboardMoveVector = Vector3.new(0, 0, 0)
    v203.tapConn = nil
    v203.inputBeganConn = nil
    v203.inputChangedConn = nil
    v203.inputEndedConn = nil
    v203.humanoidDiedConn = nil
    v203.characterChildAddedConn = nil
    v203.onCharacterAddedConn = nil
    v203.characterChildRemovedConn = nil
    v203.renderSteppedConn = nil
    v203.menuOpenedConnection = nil
    v203.preferredInputChangedConnection = nil
    v203.running = false
    v203.wasdEnabled = false
    return v203
end

v201.new = new

local function DisconnectEvents(a0)
    local tapConn = a0.tapConn
    if tapConn then
        tapConn:Disconnect()
    end

    tapConn = a0.inputBeganConn
    if tapConn then
        tapConn:Disconnect()
    end

    tapConn = a0.inputChangedConn
    if tapConn then
        tapConn:Disconnect()
    end

    tapConn = a0.inputEndedConn
    if tapConn then
        tapConn:Disconnect()
    end

    tapConn = a0.humanoidDiedConn
    if tapConn then
        tapConn:Disconnect()
    end

    tapConn = a0.characterChildAddedConn
    if tapConn then
        tapConn:Disconnect()
    end

    tapConn = a0.onCharacterAddedConn
    if tapConn then
        tapConn:Disconnect()
    end

    tapConn = a0.renderSteppedConn
    if tapConn then
        tapConn:Disconnect()
    end

    tapConn = a0.characterChildRemovedConn
    if tapConn then
        tapConn:Disconnect()
    end

    tapConn = a0.menuOpenedConnection
    if tapConn then
        tapConn:Disconnect()
    end

    tapConn = a0.preferredInputChangedConnection
    if tapConn then
        tapConn:Disconnect()
    end
end

v201.DisconnectEvents = DisconnectEvents

local function OnTouchBegan(a0, a1, a2)
    if a0.fingerTouches[a1] == nil and not a2 then
        a0.numUnsunkTouches = a0.numUnsunkTouches + 1
    end

    a0.fingerTouches[a1] = a2
end

v201.OnTouchBegan = OnTouchBegan

local function OnTouchChanged(a0, a1, a2)
    if a0.fingerTouches[a1] == nil then
        a0.fingerTouches[a1] = a2
        if not a2 then
            a0.numUnsunkTouches = a0.numUnsunkTouches + 1
        end
    end
end

v201.OnTouchChanged = OnTouchChanged

local function OnTouchEnded(a0, a1, a2)
    if a0.fingerTouches[a1] ~= nil and a0.fingerTouches[a1] == false then
        a0.numUnsunkTouches = a0.numUnsunkTouches - 1
    end

    a0.fingerTouches[a1] = nil
end

v201.OnTouchEnded = OnTouchEnded

local function OnPreferredInputChanged(a0) --[[ Upvalues: LocalPlayer (copy), UserInputService (copy) ]]
    local Character14 = LocalPlayer.Character
    if Character14 then
        local v204 = Character14:GetChildren()
        for k9, k10 in pairs(v204) do
            if k10:IsA("Tool") then
                k10.ManualActivationOnly = UserInputService.PreferredInput == Enum.PreferredInput.Touch
            end
        end
    end
end

v201.OnPreferredInputChanged = OnPreferredInputChanged

local function OnCharacterAdded(a0, a1) --[[ Upvalues: UserInputService (copy), v13 (copy), v161 (ref), v162 (ref), v163 (ref), v14 (copy), GuiService (copy) ]]
    a0:DisconnectEvents()
    a0.inputBeganConn = UserInputService.InputBegan:Connect(function(a0, a1) --[[ Upvalues: a0 (copy), v13 (upvalue), v161 (upvalue), v162 (upvalue), v163 (upvalue), v14 (upvalue) ]]
        if a0.UserInputType == Enum.UserInputType.Touch then
            a0:OnTouchBegan(a0, a1)
        end

        if a0.wasdEnabled then
            if a1 == false then
                if a0.UserInputType == Enum.UserInputType.Keyboard then
                    if v13[a0.KeyCode] then
                        if v161 then
                            v161:Cancel()
                            v161 = nil
                        end

                        if v162 then
                            v162:Disconnect()
                            v162 = nil
                        end

                        if v163 then
                            v163:Disconnect()
                            v163 = nil
                        end

                        v14.CancelFailureAnimation()
                    end
                end
            end
        end

        if a0.UserInputType == Enum.UserInputType.MouseButton2 then
            a0.mouse2DownTime = tick()
            a0.mouse2DownPos = a0.Position
        end

    end)
    a0.inputChangedConn = UserInputService.InputChanged:Connect(function(a0, a1) --[[ Upvalues: a0 (copy) ]]
        if a0.UserInputType == Enum.UserInputType.Touch then
            a0:OnTouchChanged(a0, a1)
        end

    end)
    a0.inputEndedConn = UserInputService.InputEnded:Connect(function(a0, a1) --[[ Upvalues: a0 (copy), v161 (upvalue) ]]
        if a0.UserInputType == Enum.UserInputType.Touch then
            a0:OnTouchEnded(a0, a1)
        end

        if a0.UserInputType == Enum.UserInputType.MouseButton2 then
            a0.mouse2UpTime = tick()
            local Position = a0.Position
            local v208 = v161
            if not v208 then
                v208 = a0.keyboardMoveVector.Magnitude <= 0
            end

            local v209 = a0.mouse2UpTime - a0.mouse2DownTime
            if v209 < 0.25 and (Position - a0.mouse2DownPos).magnitude < 5 and v208 then
                local v210 = {Position}
                OnTap(v210)
            end
        end

    end)
    a0.tapConn = UserInputService.TouchTap:Connect(function(a0, a1)
        if not a1 then
            OnTap(a0, nil, true)
        end

    end)
    a0.menuOpenedConnection = GuiService.MenuOpened:Connect(function() --[[ Upvalues: v161 (upvalue), v162 (upvalue), v163 (upvalue) ]]
        if v161 then
            v161:Cancel()
            v161 = nil
        end

        if v162 then
            v162:Disconnect()
            v162 = nil
        end

        if v163 then
            v163:Disconnect()
            v163 = nil
        end

    end)

    local function OnCharacterChildAdded(a0) --[[ Upvalues: UserInputService (upvalue), a0 (copy) ]]
        if UserInputService.PreferredInput == Enum.PreferredInput.Touch and a0:IsA("Tool") then
            a0.ManualActivationOnly = true
        end

        if a0:IsA("Humanoid") then
            local humanoidDiedConn = a0.humanoidDiedConn
            if humanoidDiedConn then
                humanoidDiedConn:Disconnect()
            end

            a0.humanoidDiedConn = a0.Died:Connect(function()
            end)
        end
    end

    a0.characterChildAddedConn = a1.ChildAdded:Connect(function(a0) --[[ Upvalues: OnCharacterChildAdded (copy) ]]
        OnCharacterChildAdded(a0)
    end)
    a0.characterChildRemovedConn = a1.ChildRemoved:Connect(function(a0) --[[ Upvalues: UserInputService (upvalue) ]]
        if UserInputService.PreferredInput == Enum.PreferredInput.Touch and a0:IsA("Tool") then
            a0.ManualActivationOnly = false
        end

    end)
    local v211 = a1:GetChildren()
    for k11, k12 in pairs(v211) do
        OnCharacterChildAdded(k12)
    end

    local v215 = UserInputService:GetPropertyChangedSignal("PreferredInput")
    a0.preferredInputChangedConnection = v215:Connect(function() --[[ Upvalues: a0 (copy) ]]
        a0:OnPreferredInputChanged()
    end)
end

v201.OnCharacterAdded = OnCharacterAdded

local function Start1(a0)
    a0:Enable(true)
end

v201.Start = Start1

local function Stop(a0)
    a0:Enable(false)
end

v201.Stop = Stop

local function CleanupPath1(a0) --[[ Upvalues: v161 (ref), v162 (ref), v163 (ref) ]]
    if v161 then
        v161:Cancel()
        v161 = nil
    end

    if v162 then
        v162:Disconnect()
        v162 = nil
    end

    if v163 then
        v163:Disconnect()
        v163 = nil
    end
end

v201.CleanupPath = CleanupPath1

local function Enable(a0, a1, a2, a3) --[[ Upvalues: LocalPlayer (copy), v161 (ref), v162 (ref), v163 (ref), UserInputService (copy), v200 (copy) ]]
    if a1 then
        if not a0.running then
            if LocalPlayer.Character then
                a0:OnCharacterAdded(LocalPlayer.Character)
            end

            a0.onCharacterAddedConn = LocalPlayer.CharacterAdded:Connect(function(a0) --[[ Upvalues: a0 (copy) ]]
                a0:OnCharacterAdded(a0)
            end)
            a0.running = true
        end

        a0.touchJumpController = a3
        if a0.touchJumpController then
            a0.touchJumpController:Enable(a0.jumpEnabled)
            -- branch continues at 125
        end
    else
        if a0.running then
            a0:DisconnectEvents()
            if v161 then
                v161:Cancel()
                v161 = nil
            end

            if v162 then
                v162:Disconnect()
                v162 = nil
            end

            if v163 then
                v163:Disconnect()
                v163 = nil
            end

            if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
                local Character16 = LocalPlayer.Character
                if Character16 then
                    local v216 = Character16:GetChildren()
                    for k13, k14 in pairs(v216) do
                        if k14:IsA("Tool") then
                            k14.ManualActivationOnly = false
                        end
                    end
                end
            end

            a0.running = false
        end

        if a0.touchJumpController and not a0.jumpEnabled then
            a0.touchJumpController:Enable(true)
        end

        a0.touchJumpController = nil
    end

    v200.Enable(a0, a1)
    a0.wasdEnabled = a1 and a2 or false
    a0.enabled = a1
end

v201.Enable = Enable

local function OnRenderStepped1(a0, a1) --[[ Upvalues: v161 (ref) ]]
    a0.isJumping = false
    if v161 then
        v161:OnRenderStepped(a1)
        if v161 then
            a0.moveVector = v161.NextActionMoveDirection
            a0.moveVectorIsCameraRelative = false
            if v161.NextActionJump then
                a0.isJumping = true
                -- jump to 44 (out of range)
                -- branch continues at 44
            end
        end

        a0.moveVector = a0.keyboardMoveVector
        a0.moveVectorIsCameraRelative = true
    else
        a0.moveVector = a0.keyboardMoveVector
        a0.moveVectorIsCameraRelative = true
    end

    if a0.jumpRequested then
        a0.isJumping = true
    end
end

v201.OnRenderStepped = OnRenderStepped1

local function UpdateMovement(a0, a1)
    if a1 == Enum.UserInputState.Cancel then
        a0.keyboardMoveVector = Vector3.new(0, 0, 0)
        return
    end

    if a0.wasdEnabled then
        local v222 = a0.leftValue + a0.rightValue
        a0.keyboardMoveVector = Vector3.new(v222, 0, a0.forwardValue + a0.backwardValue)
    end
end

v201.UpdateMovement = UpdateMovement

local function UpdateJump(a0)
end

v201.UpdateJump = UpdateJump

local function SetShowPath(a0, a1) --[[ Upvalues: v8 (ref) ]]
    v8 = a1
end

v201.SetShowPath = SetShowPath

local function GetShowPath(a0) --[[ Upvalues: v8 (ref) ]]
    return v8
end

v201.GetShowPath = GetShowPath

local function SetWaypointTexture(a0, a1) --[[ Upvalues: v14 (copy) ]]
    v14.SetWaypointTexture(a1)
end

v201.SetWaypointTexture = SetWaypointTexture

local function GetWaypointTexture(a0) --[[ Upvalues: v14 (copy) ]]
    local v223 = v14.GetWaypointTexture()
    return v223
end

v201.GetWaypointTexture = GetWaypointTexture

local function SetWaypointRadius(a0, a1) --[[ Upvalues: v14 (copy) ]]
    v14.SetWaypointRadius(a1)
end

v201.SetWaypointRadius = SetWaypointRadius

local function GetWaypointRadius(a0) --[[ Upvalues: v14 (copy) ]]
    local v224 = v14.GetWaypointRadius()
    return v224
end

v201.GetWaypointRadius = GetWaypointRadius

local function SetEndWaypointTexture(a0, a1) --[[ Upvalues: v14 (copy) ]]
    v14.SetEndWaypointTexture(a1)
end

v201.SetEndWaypointTexture = SetEndWaypointTexture

local function GetEndWaypointTexture(a0) --[[ Upvalues: v14 (copy) ]]
    local v225 = v14.GetEndWaypointTexture()
    return v225
end

v201.GetEndWaypointTexture = GetEndWaypointTexture

local function SetWaypointsAlwaysOnTop(a0, a1) --[[ Upvalues: v14 (copy) ]]
    v14.SetWaypointsAlwaysOnTop(a1)
end

v201.SetWaypointsAlwaysOnTop = SetWaypointsAlwaysOnTop

local function GetWaypointsAlwaysOnTop(a0) --[[ Upvalues: v14 (copy) ]]
    local v226 = v14.GetWaypointsAlwaysOnTop()
    return v226
end

v201.GetWaypointsAlwaysOnTop = GetWaypointsAlwaysOnTop

local function SetFailureAnimationEnabled(a0, a1) --[[ Upvalues: v9 (ref) ]]
    v9 = a1
end

v201.SetFailureAnimationEnabled = SetFailureAnimationEnabled

local function GetFailureAnimationEnabled(a0) --[[ Upvalues: v9 (ref) ]]
    return v9
end

v201.GetFailureAnimationEnabled = GetFailureAnimationEnabled

local function SetIgnoredPartsTag(a0, a1) --[[ Upvalues: UpdateIgnoreTag (copy) ]]
    UpdateIgnoreTag(a1)
end

v201.SetIgnoredPartsTag = SetIgnoredPartsTag

local function GetIgnoredPartsTag(a0) --[[ Upvalues: v35 (ref) ]]
    return v35
end

v201.GetIgnoredPartsTag = GetIgnoredPartsTag

local function SetUseDirectPath(a0, a1) --[[ Upvalues: v10 (ref) ]]
    v10 = a1
end

v201.SetUseDirectPath = SetUseDirectPath

local function GetUseDirectPath(a0) --[[ Upvalues: v10 (ref) ]]
    return v10
end

v201.GetUseDirectPath = GetUseDirectPath

local function SetAgentSizeIncreaseFactor(a0, a1) --[[ Upvalues: v11 (ref) ]]
    v11 = a1 / 100 + 1
end

v201.SetAgentSizeIncreaseFactor = SetAgentSizeIncreaseFactor

local function GetAgentSizeIncreaseFactor(a0) --[[ Upvalues: v11 (ref) ]]
    return (v11 - 1) * 100
end

v201.GetAgentSizeIncreaseFactor = GetAgentSizeIncreaseFactor

local function SetUnreachableWaypointTimeout(a0, a1) --[[ Upvalues: v12 (ref) ]]
    v12 = a1
end

v201.SetUnreachableWaypointTimeout = SetUnreachableWaypointTimeout

local function GetUnreachableWaypointTimeout(a0) --[[ Upvalues: v12 (ref) ]]
    return v12
end

v201.GetUnreachableWaypointTimeout = GetUnreachableWaypointTimeout

local function SetUserJumpEnabled(a0, a1)
    a0.jumpEnabled = a1
    if a0.touchJumpController then
        a0.touchJumpController:Enable(a1)
    end
end

v201.SetUserJumpEnabled = SetUserJumpEnabled

local function GetUserJumpEnabled(a0)
    return a0.jumpEnabled
end

v201.GetUserJumpEnabled = GetUserJumpEnabled

local function MoveTo(a0, a1, a2, a3) --[[ Upvalues: LocalPlayer (copy), Pather (copy), HandleMoveTo (copy) ]]
    local Character17 = LocalPlayer.Character
    if Character17 == nil then
        return false
    end

    local v227 = Pather(a1, Vector3.new(0, 1, 0), a3)
    if v227 and v227:IsValidPath() then
        HandleMoveTo(v227, a1, nil, Character17, a2)
        return true
    end

    return false
end

v201.MoveTo = MoveTo
return v201
