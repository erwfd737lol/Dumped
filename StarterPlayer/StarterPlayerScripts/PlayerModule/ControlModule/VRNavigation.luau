
local VRService = game:GetService("VRService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local ContextActionService = game:GetService("ContextActionService")
local StarterGui = game:GetService("StarterGui")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
local v1 = require(FlagUtil)
FlagUtil = nil
CommonUtils = Players.LocalPlayer
Players = RaycastParams.new()
Players.FilterType = Enum.RaycastFilterType.Exclude
local v2 = v1.getUserFlag("UserRaycastUpdateAPI2")

local function IsFinite(a0)
    local v3 = false
    if a0 == a0 then
        v3 = false
        if a0 ~= math.huge then
            v3 = a0 ~= -math.huge
        end
    end

    return v3
end

local function IsFiniteVector3(a0)
    local x = a0.x
    local v4 = false
    if x == x then
        v4 = false
        if x ~= math.huge then
            v4 = x ~= -math.huge
        end
    end

    if v4 then
        x = a0.y
        v4 = false
        if x == x then
            v4 = false
            if x ~= math.huge then
                v4 = x ~= -math.huge
            end
        end

        if v4 then
            x = a0.z
            v4 = false
            if x == x then
                v4 = false
                if x ~= math.huge then
                    v4 = x ~= -math.huge
                end
            end
        end
    end

    return v4
end

local BindableEvent = Instance.new("BindableEvent")
BindableEvent.Name = "MovementUpdate"
BindableEvent.Parent = script
coroutine.wrap(function() --[[ Upvalues: FlagUtil (ref) ]]
    local PathDisplay = script.Parent:WaitForChild("PathDisplay")
    if PathDisplay then
        FlagUtil = require(PathDisplay)
    end

end)()
local BaseCharacterController = script.Parent:WaitForChild("BaseCharacterController")
local v5 = require(BaseCharacterController)
local v6 = setmetatable({}, v5)
v6.__index = v6

local function new(a0) --[[ Upvalues: v5 (copy), v6 (copy) ]]
    local v7 = setmetatable(v5.new(), v6)
    v7.CONTROL_ACTION_PRIORITY = a0
    v7.navigationRequestedConn = nil
    v7.heartbeatConn = nil
    v7.currentDestination = nil
    v7.currentPath = nil
    v7.currentPoints = nil
    v7.currentPointIdx = 0
    v7.expectedTimeToNextPoint = 0
    v7.timeReachedLastPoint = tick()
    v7.moving = false
    v7.isJumpBound = false
    v7.moveLatch = false
    v7.userCFrameEnabledConn = nil
    return v7
end

v6.new = new

local function SetLaserPointerMode(a0, a1) --[[ Upvalues: StarterGui (copy) ]]
    pcall(function() --[[ Upvalues: StarterGui (upvalue), a1 (copy) ]]
        StarterGui:SetCore("VRLaserPointerMode", a1)
    end)
end

v6.SetLaserPointerMode = SetLaserPointerMode

local function GetLocalHumanoid(a0) --[[ Upvalues: CommonUtils (copy) ]]
    local Character = CommonUtils.Character
    if not Character then
        return
    end

    local v8 = Character:GetChildren()
    for k1, k2 in pairs(v8) do
        if k2:IsA("Humanoid") then
            return k2
        end
    end

    return nil
end

v6.GetLocalHumanoid = GetLocalHumanoid

local function HasBothHandControllers(a0) --[[ Upvalues: VRService (copy) ]]
    local v14 = VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) and VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
    return v14
end

v6.HasBothHandControllers = HasBothHandControllers

local function HasAnyHandControllers(a0) --[[ Upvalues: VRService (copy) ]]
    local v17 = VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) or VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
    return v17
end

v6.HasAnyHandControllers = HasAnyHandControllers

local function IsMobileVR(a0) --[[ Upvalues: UserInputService (copy) ]]
    return UserInputService.TouchEnabled
end

v6.IsMobileVR = IsMobileVR

local function HasGamepad(a0) --[[ Upvalues: UserInputService (copy) ]]
    return UserInputService.GamepadEnabled
end

v6.HasGamepad = HasGamepad

local function ShouldUseNavigationLaser(a0)
    if a0:IsMobileVR() then
        return true
    end

    if a0:HasBothHandControllers() then
        return false
    end

    if not a0:HasAnyHandControllers() then
        return not a0:HasGamepad()
    end

    return true
end

v6.ShouldUseNavigationLaser = ShouldUseNavigationLaser

local function StartFollowingPath(a0, a1) --[[ Upvalues: BindableEvent (copy) ]]
    currentPath = a1
    currentPoints = currentPath:GetPointCoordinates()
    currentPointIdx = 1
    moving = true
    timeReachedLastPoint = tick()
    local v18 = a0:GetLocalHumanoid()
    if v18 then
        if v18.Torso then
            local v21 = #currentPoints
            if 1 <= v21 then
                local v22 = currentPoints[1]
                expectedTimeToNextPoint = (v22 - v18.Torso.Position).magnitude / v18.WalkSpeed
            end
        end
    end

    BindableEvent:Fire("targetPoint", a0.currentDestination)
end

v6.StartFollowingPath = StartFollowingPath

local function GoToPoint(a0, a1) --[[ Upvalues: BindableEvent (copy) ]]
    currentPath = true
    local v23 = {a1}
    currentPoints = v23
    currentPointIdx = 1
    moving = true
    local v24 = a0:GetLocalHumanoid()
    local v25 = (v24.Torso.Position - a1).magnitude / v24.WalkSpeed
    timeReachedLastPoint = tick()
    expectedTimeToNextPoint = v25
    BindableEvent:Fire("targetPoint", a1)
end

v6.GoToPoint = GoToPoint

local function StopFollowingPath(a0)
    currentPath = nil
    currentPoints = nil
    currentPointIdx = 0
    moving = false
    a0.moveVector = Vector3.new(0, 0, 0)
end

v6.StopFollowingPath = StopFollowingPath

local function TryComputePath(a0, a1, a2) --[[ Upvalues: PathfindingService (copy) ]]
    local v26 = 0
    local v27 = nil
    while not v27 do
        if v26 >= 5 then
            break
        end

        v27 = PathfindingService:ComputeSmoothPathAsync(a1, a2, 200)
        v26 = v26 + 1
        if v27.Status == Enum.PathStatus.ClosestNoPath or v27.Status == Enum.PathStatus.ClosestOutOfRange then
            v27 = nil
            return v27
        end

        if v27 and v27.Status == Enum.PathStatus.FailStartNotEmpty then
            a1 = a1 + (a2 - a1).Unit
            v27 = nil
        end

        if v27 and v27.Status == Enum.PathStatus.FailFinishNotEmpty then
            a2 = a2 + Vector3.new(0, 1, 0)
            v27 = nil
        end
    end

    return v27
end

v6.TryComputePath = TryComputePath

local function OnNavigationRequest(a0, a1, a2) --[[ Upvalues: FlagUtil (ref) ]]
    local Position = a1.Position
    local currentDestination = a0.currentDestination
    local x1 = Position.x
    local v28 = false
    if x1 == x1 then
        v28 = false
        if x1 ~= math.huge then
            v28 = x1 ~= -math.huge
        end
    end

    if v28 then
        x1 = Position.y
        v28 = false
        if x1 == x1 then
            v28 = false
            if x1 ~= math.huge then
                v28 = x1 ~= -math.huge
            end
        end

        if v28 then
            x1 = Position.z
            v28 = false
            if x1 == x1 then
                v28 = false
                if x1 ~= math.huge then
                    v28 = x1 ~= -math.huge
                end
            end
        end
    end

    if not v28 then
        return
    end

    a0.currentDestination = Position
    Position = a0:GetLocalHumanoid()
    if not (Position and Position.Torso) then
        return
    end

    local Position1 = Position.Torso.Position
    if (a0.currentDestination - Position1).magnitude < 12 then
        a0:GoToPoint(a0.currentDestination)
        return
    end

    if not currentDestination or 4 < (a0.currentDestination - currentDestination).magnitude then
        local v29 = a0:TryComputePath(Position1, a0.currentDestination)
        if v29 then
            a0:StartFollowingPath(v29)
            if FlagUtil then
                FlagUtil.setCurrentPoints(a0.currentPoints)
                FlagUtil.renderPath()
                return
                -- branch continues at 143
            end
        end

        a0:StopFollowingPath()
        if FlagUtil then
            FlagUtil.clearRenderedPath()
            return
            -- branch continues at 143
        end
    end

    if moving then
        local v30 = #currentPoints
        a0.currentPoints[v30] = a0.currentDestination
        return
    end

    a0:GoToPoint(a0.currentDestination)
end

v6.OnNavigationRequest = OnNavigationRequest

local function OnJumpAction(a0, a1, a2, a3)
    if a2 == Enum.UserInputState.Begin then
        a0.isJumping = true
    end

    return Enum.ContextActionResult.Sink
end

v6.OnJumpAction = OnJumpAction

local function BindJumpAction(a0, a1) --[[ Upvalues: ContextActionService (copy) ]]
    if a1 then
        if not a0.isJumpBound then
            a0.isJumpBound = true
            ContextActionService:BindActionAtPriority("VRJumpAction", function() --[[ Upvalues: a0 (copy) ]]
                local v31 = a0:OnJumpAction()
                return v31
            end, false, a0.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonA)
            return
            -- branch continues at 33
        end
    end

    if a0.isJumpBound then
        a0.isJumpBound = false
        ContextActionService:UnbindAction("VRJumpAction")
    end
end

v6.BindJumpAction = BindJumpAction

local function ControlCharacterGamepad(a0, a1, a2, a3) --[[ Upvalues: FlagUtil (ref), BindableEvent (copy) ]]
    if a3.KeyCode ~= Enum.KeyCode.Thumbstick1 then
        return
    end

    if a2 == Enum.UserInputState.Cancel then
        a0.moveVector = Vector3.new(0, 0, 0)
        return
    end

    if a2 ~= Enum.UserInputState.End then
        a0:StopFollowingPath()
        if FlagUtil then
            FlagUtil.clearRenderedPath()
        end

        if a0:ShouldUseNavigationLaser() then
            a0:BindJumpAction(true)
            a0:SetLaserPointerMode("Hidden")
        end

        if 0.22 < a3.Position.magnitude then
            a0.moveVector = Vector3.new(a3.Position.X, 0, -a3.Position.Y)
            if 0 < a0.moveVector.magnitude then
                a0.moveVector = a0.moveVector.unit * math.min(1, a3.Position.magnitude)
            end

            a0.moveLatch = true
            -- branch continues at 126
        end
    else
        a0.moveVector = Vector3.new(0, 0, 0)
        if a0:ShouldUseNavigationLaser() then
            a0:BindJumpAction(false)
            a0:SetLaserPointerMode("Navigation")
        end

        if a0.moveLatch then
            a0.moveLatch = false
            BindableEvent:Fire("offtrack")
        end
    end

    return Enum.ContextActionResult.Sink
end

v6.ControlCharacterGamepad = ControlCharacterGamepad

local function OnHeartbeat(a0, a1) --[[ Upvalues: FlagUtil (ref), v2 (copy), Players (copy), BindableEvent (copy) ]]
    local moveVector = a0.moveVector
    local v32 = a0:GetLocalHumanoid()
    if not (v32 and v32.Torso) then
        return
    end

    if a0.moving then
        if a0.currentPoints then
            local Position2 = v32.Torso.Position
            local v33 = (currentPoints[1] - Position2) * Vector3.new(1, 0, 1)
            local magnitude = v33.magnitude
            local v34 = v33 / magnitude
            if magnitude < 1 then
                v33 = 0
                local v35 = currentPoints[1]
                for k3, k4 in pairs(currentPoints) do
                    if k3 ~= 1 then
                        v35 = k4
                        v33 = v33 + (k4 - v35).magnitude / v32.WalkSpeed
                    end
                end

                table.remove(currentPoints, 1)
                currentPointIdx = currentPointIdx + 1
                if #currentPoints == 0 then
                    a0:StopFollowingPath()
                    if FlagUtil then
                        FlagUtil.clearRenderedPath()
                    end

                    return
                end

                if FlagUtil then
                    FlagUtil.setCurrentPoints(currentPoints)
                    FlagUtil.renderPath()
                end

                expectedTimeToNextPoint = (currentPoints[1] - Position2).magnitude / v32.WalkSpeed
                timeReachedLastPoint = tick()
            else
                if v2 then
                    local v39 = {game.Players.LocalPlayer.Character, workspace.CurrentCamera}
                    Players.FilterDescendantsInstances = v39
                    local v40 = Position2 - Vector3.new(0, 1, 0)
                    local v41 = workspace:Raycast(v40, v34 * 3, Players)
                    if v41 then
                        local v42 = v41.Position + v34 * 0.5
                        local v43 = v42 + Vector3.new(0, 100, 0)
                        local v44 = workspace:Raycast(v43, Vector3.new(0, -100, 0), Players).Position.Y - Position2.Y
                        if v44 < 6 then
                            if -2 < v44 then
                                v32.Jump = true
                                -- branch continues at 244
                            end

                            -- branch continues at 244
                        end

                        -- branch continues at 244
                    end
                else
                    local v45 = {game.Players.LocalPlayer.Character, workspace.CurrentCamera}
                    local v46 = Position2 - Vector3.new(0, 1, 0)
                    local v47 = Ray.new(v46, v34 * 3)
                    local v48, v49, v50 = workspace:FindPartOnRayWithIgnoreList(v47, v45)
                    if v48 then
                        local v57 = v49 + v34 * 0.5
                        local v58 = v57 + Vector3.new(0, 100, 0)
                        local v59 = Ray.new(v58, Vector3.new(0, -100, 0))
                        local v60, v61, v62 = workspace:FindPartOnRayWithIgnoreList(v59, v45)
                        v62 = v61.Y - Position2.Y
                        if v62 < 6 and -2 < v62 then
                            v32.Jump = true
                        end
                    end
                end

                local v63 = tick() - timeReachedLastPoint
                if expectedTimeToNextPoint + 2 < v63 then
                    a0:StopFollowingPath()
                    if FlagUtil then
                        FlagUtil.clearRenderedPath()
                    end

                    BindableEvent:Fire("offtrack")
                end

                moveVector = a0.moveVector:Lerp(v34, a1 * 10)
            end
        end
    end

    local x2 = moveVector.x
    local v64 = false
    if x2 == x2 then
        v64 = false
        if x2 ~= math.huge then
            v64 = x2 ~= -math.huge
        end
    end

    if v64 then
        x2 = moveVector.y
        v64 = false
        if x2 == x2 then
            v64 = false
            if x2 ~= math.huge then
                v64 = x2 ~= -math.huge
            end
        end

        if v64 then
            x2 = moveVector.z
            v64 = false
            if x2 == x2 then
                v64 = false
                if x2 ~= math.huge then
                    v64 = x2 ~= -math.huge
                end
            end
        end
    end

    if v64 then
        a0.moveVector = moveVector
    end
end

v6.OnHeartbeat = OnHeartbeat

local function OnUserCFrameEnabled(a0)
    if a0:ShouldUseNavigationLaser() then
        a0:BindJumpAction(false)
        a0:SetLaserPointerMode("Navigation")
        return
    end

    a0:BindJumpAction(true)
    a0:SetLaserPointerMode("Hidden")
end

v6.OnUserCFrameEnabled = OnUserCFrameEnabled

local function Enable(a0, a1) --[[ Upvalues: VRService (copy), RunService (copy), ContextActionService (copy) ]]
    a0.moveVector = Vector3.new(0, 0, 0)
    a0.isJumping = false
    if a1 then
        a0.navigationRequestedConn = VRService.NavigationRequested:Connect(function(a0, a1) --[[ Upvalues: a0 (copy) ]]
            a0:OnNavigationRequest(a0, a1)
        end)
        a0.heartbeatConn = RunService.Heartbeat:Connect(function(a0) --[[ Upvalues: a0 (copy) ]]
            a0:OnHeartbeat(a0)
        end)
        ContextActionService:BindAction("MoveThumbstick", function(a0, a1, a2) --[[ Upvalues: a0 (copy) ]]
            local v65 = a0:ControlCharacterGamepad(a0, a1, a2)
            return v65
        end, false, a0.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Thumbstick1)
        ContextActionService:BindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
        a0.userCFrameEnabledConn = VRService.UserCFrameEnabled:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:OnUserCFrameEnabled()
        end)
        a0:OnUserCFrameEnabled()
        VRService:SetTouchpadMode(Enum.VRTouchpad.Left, Enum.VRTouchpadMode.VirtualThumbstick)
        VRService:SetTouchpadMode(Enum.VRTouchpad.Right, Enum.VRTouchpadMode.ABXY)
        a0.enabled = true
        return
    end

    a0:StopFollowingPath()
    ContextActionService:UnbindAction("MoveThumbstick")
    ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
    a0:BindJumpAction(false)
    a0:SetLaserPointerMode("Disabled")
    if a0.navigationRequestedConn then
        a0.navigationRequestedConn:Disconnect()
        a0.navigationRequestedConn = nil
    end

    if a0.heartbeatConn then
        a0.heartbeatConn:Disconnect()
        a0.heartbeatConn = nil
    end

    if a0.userCFrameEnabledConn then
        a0.userCFrameEnabledConn:Disconnect()
        a0.userCFrameEnabledConn = nil
    end

    a0.enabled = false
end

v6.Enable = Enable
return v6
