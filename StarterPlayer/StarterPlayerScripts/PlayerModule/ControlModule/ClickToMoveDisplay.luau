
local v1 = "rbxasset://textures/ui/traildot.png"
local v2 = "rbxasset://textures/ui/waypoint.png"
local v3 = false
local v4 = UDim2.new(0, 42, 0, 50)
local v5 = Vector2.new(0, 0.5)
local v6 = Vector2.new(0, 1)
local v7 = Vector2.new(0, 0.5)
local v8 = Vector2.new(0.1, 0.5)
local v9 = Vector2.new(-0.1, 0.5)
local v10 = Vector2.new(1.5, 1.5)
local v11 = RaycastParams.new()
local t1 = {}
v11.FilterType = Enum.RaycastFilterType.Exclude
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
CommonUtils = require(FlagUtil).getUserFlag("UserRaycastUpdateAPI2")
local LocalPlayer = Players.LocalPlayer

local function CreateWaypointTemplates() --[[ Upvalues: v10 (ref), v3 (ref), v1 (ref), v4 (copy), v5 (copy), v2 (ref), v7 (copy) ]]
    local Part = Instance.new("Part")
    Part.Size = Vector3.new(1, 1, 1)
    Part.Anchored = true
    Part.CanCollide = false
    Part.Name = "TrailDot"
    Part.Transparency = 1
    local ImageHandleAdornment = Instance.new("ImageHandleAdornment")
    ImageHandleAdornment.Name = "TrailDotImage"
    ImageHandleAdornment.Size = v10
    ImageHandleAdornment.SizeRelativeOffset = Vector3.new(0, 0, -0.10000000149011612)
    ImageHandleAdornment.AlwaysOnTop = v3
    ImageHandleAdornment.Image = v1
    ImageHandleAdornment.Adornee = Part
    ImageHandleAdornment.Parent = Part
    local Part1 = Instance.new("Part")
    Part1.Size = Vector3.new(2, 2, 2)
    Part1.Anchored = true
    Part1.CanCollide = false
    Part1.Name = "EndWaypoint"
    Part1.Transparency = 1
    local ImageHandleAdornment1 = Instance.new("ImageHandleAdornment")
    ImageHandleAdornment1.Name = "TrailDotImage"
    ImageHandleAdornment1.Size = v10
    ImageHandleAdornment1.SizeRelativeOffset = Vector3.new(0, 0, -0.10000000149011612)
    ImageHandleAdornment1.AlwaysOnTop = v3
    ImageHandleAdornment1.Image = v1
    ImageHandleAdornment1.Adornee = Part1
    ImageHandleAdornment1.Parent = Part1
    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Name = "EndWaypointBillboard"
    BillboardGui.Size = v4
    BillboardGui.LightInfluence = 0
    BillboardGui.SizeOffset = v5
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Adornee = Part1
    BillboardGui.Parent = Part1
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Image = v2
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.new(1, 0, 1, 0)
    ImageLabel.Parent = BillboardGui
    local Part2 = Instance.new("Part")
    Part2.Size = Vector3.new(2, 2, 2)
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.Name = "FailureWaypoint"
    Part2.Transparency = 1
    BillboardGui = Instance.new("ImageHandleAdornment")
    BillboardGui.Name = "TrailDotImage"
    BillboardGui.Size = v10
    BillboardGui.SizeRelativeOffset = Vector3.new(0, 0, -0.10000000149011612)
    BillboardGui.AlwaysOnTop = v3
    BillboardGui.Image = v1
    BillboardGui.Adornee = Part2
    BillboardGui.Parent = Part2
    BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Name = "FailureWaypointBillboard"
    BillboardGui.Size = v4
    BillboardGui.LightInfluence = 0
    BillboardGui.SizeOffset = v7
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Adornee = Part2
    BillboardGui.Parent = Part2
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0, 0, 0, 0)
    Frame.Position = UDim2.new(0.5, 0, 1, 0)
    Frame.Parent = BillboardGui
    BillboardGui = Instance.new("ImageLabel")
    BillboardGui.Image = v2
    BillboardGui.BackgroundTransparency = 1
    local v12 = -v4.X.Offset / 2
    BillboardGui.Position = UDim2.new(0, v12, 0, -v4.Y.Offset)
    BillboardGui.Size = v4
    BillboardGui.Parent = Frame
    return Part, Part1, Part2
end

local v13, v14, v15 = CreateWaypointTemplates()

local function getTrailDotParent() --[[ Upvalues: Workspace (copy) ]]
    local CurrentCamera = Workspace.CurrentCamera
    local ClickToMoveDisplay = CurrentCamera:FindFirstChild("ClickToMoveDisplay")
    if not ClickToMoveDisplay then
        ClickToMoveDisplay = Instance.new("Model")
        ClickToMoveDisplay.Name = "ClickToMoveDisplay"
        ClickToMoveDisplay.Parent = CurrentCamera
    end

    return ClickToMoveDisplay
end

local function placePathWaypoint(a0, a1) --[[ Upvalues: CommonUtils (copy), v11 (copy), Workspace (copy), LocalPlayer (copy) ]]
    if CommonUtils then
        local v16 = {Workspace.CurrentCamera, LocalPlayer.Character}
        v11.FilterDescendantsInstances = v16
        local v17 = a1 + Vector3.new(0, 2.5, 0)
        local v18 = Workspace:Raycast(v17, Vector3.new(0, -10, 0), v11)
        if v18 then
            a0.CFrame = CFrame.lookAlong(v18.Position, v18.Normal)
            local CurrentCamera1 = Workspace.CurrentCamera
            local ClickToMoveDisplay1 = CurrentCamera1:FindFirstChild("ClickToMoveDisplay")
            if not ClickToMoveDisplay1 then
                ClickToMoveDisplay1 = Instance.new("Model")
                ClickToMoveDisplay1.Name = "ClickToMoveDisplay"
                ClickToMoveDisplay1.Parent = CurrentCamera1
            end

            a0.Parent = ClickToMoveDisplay1
            return
            -- branch continues at 113
        end
    end

    local v19 = a1 + Vector3.new(0, 2.5, 0)
    local v20 = Ray.new(v19, Vector3.new(0, -10, 0))
    local v21 = {Workspace.CurrentCamera, LocalPlayer.Character}
    local v22, v23, v24 = Workspace:FindPartOnRayWithIgnoreList(v20, v21)
    if v22 then
        a0.CFrame = CFrame.new(v23, v23 + v24)
        local CurrentCamera2 = Workspace.CurrentCamera
        local ClickToMoveDisplay2 = CurrentCamera2:FindFirstChild("ClickToMoveDisplay")
        if not ClickToMoveDisplay2 then
            ClickToMoveDisplay2 = Instance.new("Model")
            ClickToMoveDisplay2.Name = "ClickToMoveDisplay"
            ClickToMoveDisplay2.Parent = CurrentCamera2
        end

        a0.Parent = ClickToMoveDisplay2
    end
end

local v25 = {}
v25.__index = v25

local function Destroy(a0)
    a0.DisplayModel:Destroy()
end

v25.Destroy = Destroy

local function NewDisplayModel(a0, a1) --[[ Upvalues: v13 (ref), placePathWaypoint (copy) ]]
    local v26 = v13:Clone()
    placePathWaypoint(v26, a1)
    return v26
end

v25.NewDisplayModel = NewDisplayModel

local function new(a0, a1) --[[ Upvalues: v25 (copy) ]]
    local v27 = setmetatable({}, v25)
    v27.DisplayModel = v27:NewDisplayModel(a0)
    v27.ClosestWayPoint = a1
    return v27
end

v25.new = new
new = {}
new.__index = new

local function Destroy1(a0)
    a0.Destroyed = true
    a0.Tween:Cancel()
    a0.DisplayModel:Destroy()
end

new.Destroy = Destroy1

local function NewDisplayModel1(a0, a1) --[[ Upvalues: v14 (ref), placePathWaypoint (copy) ]]
    local v28 = v14:Clone()
    placePathWaypoint(v28, a1)
    return v28
end

new.NewDisplayModel = NewDisplayModel1

local function CreateTween(a0) --[[ Upvalues: TweenService (copy), v6 (copy) ]]
    local v29 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true)
    local v30 = {SizeOffset = v6}
    local v31 = TweenService:Create(a0.DisplayModel.EndWaypointBillboard, v29, v30)
    v31:Play()
    return v31
end

new.CreateTween = CreateTween

local function TweenInFrom(a0, a1) --[[ Upvalues: TweenService (copy) ]]
    a0.DisplayModel.EndWaypointBillboard.StudsOffset = Vector3.new(0, (a1 - a0.DisplayModel.Position).Y, 0)
    local v32 = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local v33 = TweenService:Create(a0.DisplayModel.EndWaypointBillboard, v32, {StudsOffset = Vector3.new(0, 0, 0)})
    v33:Play()
    return v33
end

new.TweenInFrom = TweenInFrom

local function new1(a0, a1, a2) --[[ Upvalues: new (copy) ]]
    local v34 = setmetatable({}, new)
    v34.DisplayModel = v34:NewDisplayModel(a0)
    v34.Destroyed = false
    if a2 and 5 < (a2 - a0).Magnitude then
        v34.Tween = v34:TweenInFrom(a2)
        coroutine.wrap(function() --[[ Upvalues: v34 (copy) ]]
            v34.Tween.Completed:Wait()
            if not v34.Destroyed then
                v34.Tween = v34:CreateTween()
            end

        end)()
    else
        v34.Tween = v34:CreateTween()
    end

    v34.ClosestWayPoint = a1
    return v34
end

new.new = new1
new1 = {}
new1.__index = new1

local function Hide(a0)
    a0.DisplayModel.Parent = nil
end

new1.Hide = Hide

local function Destroy2(a0)
    a0.DisplayModel:Destroy()
end

new1.Destroy = Destroy2

local function NewDisplayModel2(a0, a1) --[[ Upvalues: v15 (ref), placePathWaypoint (copy), CommonUtils (copy), v11 (copy), Workspace (copy), LocalPlayer (copy) ]]
    local v35 = v15:Clone()
    placePathWaypoint(v35, a1)
    if CommonUtils then
        local v36 = {Workspace.CurrentCamera, LocalPlayer.Character}
        v11.FilterDescendantsInstances = v36
        local v37 = a1 + Vector3.new(0, 2.5, 0)
        local v38 = Workspace:Raycast(v37, Vector3.new(0, -10, 0), v11)
        if v38 then
            v35.CFrame = CFrame.lookAlong(v38.Position, v38.Normal)
            local CurrentCamera3 = Workspace.CurrentCamera
            local ClickToMoveDisplay3 = CurrentCamera3:FindFirstChild("ClickToMoveDisplay")
            if not ClickToMoveDisplay3 then
                ClickToMoveDisplay3 = Instance.new("Model")
                ClickToMoveDisplay3.Name = "ClickToMoveDisplay"
                ClickToMoveDisplay3.Parent = CurrentCamera3
            end

            v35.Parent = ClickToMoveDisplay3
            return v35
            -- branch continues at 123
        end
    end

    local v39 = a1 + Vector3.new(0, 2.5, 0)
    local v40 = Ray.new(v39, Vector3.new(0, -10, 0))
    local v41 = {Workspace.CurrentCamera, LocalPlayer.Character}
    local v42, v43, v44 = Workspace:FindPartOnRayWithIgnoreList(v40, v41)
    if v42 then
        v35.CFrame = CFrame.new(v43, v43 + v44)
        local CurrentCamera4 = Workspace.CurrentCamera
        local ClickToMoveDisplay4 = CurrentCamera4:FindFirstChild("ClickToMoveDisplay")
        if not ClickToMoveDisplay4 then
            ClickToMoveDisplay4 = Instance.new("Model")
            ClickToMoveDisplay4.Name = "ClickToMoveDisplay"
            ClickToMoveDisplay4.Parent = CurrentCamera4
        end

        v35.Parent = ClickToMoveDisplay4
    end

    return v35
end

new1.NewDisplayModel = NewDisplayModel2

local function RunFailureTween(a0) --[[ Upvalues: TweenService (copy), v8 (copy), v9 (copy), v7 (copy) ]]
    wait(0.125)
    local v45 = TweenInfo.new(0.0625, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local v46 = {SizeOffset = v8}
    local v47 = TweenService:Create(a0.DisplayModel.FailureWaypointBillboard, v45, v46)
    v47:Play()
    TweenService:Create(a0.DisplayModel.FailureWaypointBillboard.Frame, v45, {Rotation = 10}):Play()
    v47.Completed:wait()
    local v48 = {SizeOffset = v9}
    local v49 = TweenService:Create(a0.DisplayModel.FailureWaypointBillboard, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 3, true), v48)
    v49:Play()
    local v50 = TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 3, true)
    local v51 = {ImageColor3 = Color3.new(0.75, 0.75, 0.75)}
    TweenService:Create(a0.DisplayModel.FailureWaypointBillboard.Frame.ImageLabel, v50, v51):Play()
    TweenService:Create(a0.DisplayModel.FailureWaypointBillboard.Frame, v50, {Rotation = -10}):Play()
    v49.Completed:wait()
    v50 = TweenInfo.new(0.0625, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local v52 = {SizeOffset = v7}
    local v53 = TweenService:Create(a0.DisplayModel.FailureWaypointBillboard, v50, v52)
    v53:Play()
    TweenService:Create(a0.DisplayModel.FailureWaypointBillboard.Frame, v50, {Rotation = 0}):Play()
    v53.Completed:wait()
    wait(0.125)
end

new1.RunFailureTween = RunFailureTween

local function new2(a0) --[[ Upvalues: new1 (copy) ]]
    local v54 = setmetatable({}, new1)
    v54.DisplayModel = v54:NewDisplayModel(a0)
    return v54
end

new1.new = new2
local Animation = Instance.new("Animation")
Animation.AnimationId = "rbxassetid://2874840706"
local v55 = nil

local function getFailureAnimationTrack(a0) --[[ Upvalues: v55 (ref), Animation (copy) ]]
    if a0 == nil then
        return v55
    end

    v55 = a0:LoadAnimation(Animation)
    assert(v55, "")
    v55.Priority = Enum.AnimationPriority.Action
    v55.Looped = false
    return v55
end

local function findPlayerHumanoid() --[[ Upvalues: LocalPlayer (copy) ]]
    local Character = LocalPlayer.Character
    if Character then
        local v56 = Character:FindFirstChildOfClass("Humanoid")
        return v56
    end
end

local function createTrailDots(a0, a1) --[[ Upvalues: v25 (copy), new (copy) ]]
    local t2 = {}
    local v57 = 1
    for i1 = 1, #a0 - 1 do
        local v60 = false
        if i1 % 2 == 0 then
            v60 = not ((a0[i1].Position - a0[#a0].Position).Magnitude < 3)
        end

        if v60 then
            t2[v57] = v25.new(a0[i1].Position, i1)
            v57 = v57 + 1
        end
    end

    local v61 = new.new(a0[#a0].Position, #a0, a1)
    table.insert(t2, v61)
    v61 = {}
    v57 = 1
    for i2 = #t2, 1, -1 do
        v61[v57] = t2[i2]
        v57 = v57 + 1
    end

    return v61
end

local function getTrailDotScale(a0, a1)
    return a1 * (math.clamp(a0 - 10, 0, 90) / 90 * 1.5 + 1)
end

local v64 = 0

local function CreatePathDisplay(a0, a1) --[[ Upvalues: v64 (ref), createTrailDots (copy), RunService (copy), Workspace (copy), v10 (ref) ]]
    v64 = v64 + 1
    local v65 = createTrailDots(a0, a1)

    local function removePathBeforePoint(a0) --[[ Upvalues: v65 (copy) ]]
        for i3 = #v65, 1, -1 do
            local v68 = v65[i3]
            if v68.ClosestWayPoint > a0 then
                break
            end

            v68:Destroy()
            v65[i3] = nil
        end
    end

    local v69 = "ClickToMoveResizeTrail" .. v64

    local function resizeTrailDots() --[[ Upvalues: v65 (copy), RunService (upvalue), v69 (copy), Workspace (upvalue), v10 (upvalue) ]]
        if #v65 == 0 then
            RunService:UnbindFromRenderStep(v69)
            return
        end

        local p = Workspace.CurrentCamera.CFrame.p
        for i4 = 1, #v65 do
            local TrailDotImage = v65[i4].DisplayModel:FindFirstChild("TrailDotImage")
            if TrailDotImage then
                TrailDotImage.Size = v10 * (math.clamp((v65[i4].DisplayModel.Position - p).Magnitude - 10, 0, 90) / 90 * 1.5 + 1)
            end
        end
    end

    local v72 = Enum.RenderPriority.Camera.Value - 1
    RunService:BindToRenderStep(v69, v72, resizeTrailDots)

    local function removePath() --[[ Upvalues: removePathBeforePoint (copy), a0 (copy) ]]
        removePathBeforePoint(#a0)
    end

    return removePath, removePathBeforePoint
end

t1.CreatePathDisplay = CreatePathDisplay
local v73 = nil

local function DisplayFailureWaypoint(a0) --[[ Upvalues: v73 (ref), new1 (copy) ]]
    if v73 then
        v73:Hide()
    end

    local v74 = new1.new(a0)
    v73 = v74
    coroutine.wrap(function() --[[ Upvalues: v74 (ref) ]]
        v74:RunFailureTween()
        v74:Destroy()
        v74 = nil
    end)()
end

t1.DisplayFailureWaypoint = DisplayFailureWaypoint

local function CreateEndWaypoint(a0) --[[ Upvalues: new (copy) ]]
    local v75 = new.new(a0)
    return v75
end

t1.CreateEndWaypoint = CreateEndWaypoint

local function PlayFailureAnimation() --[[ Upvalues: LocalPlayer (copy), v55 (ref), Animation (copy) ]]
    local Character1 = LocalPlayer.Character
    local v76
    if Character1 then
        v76 = Character1:FindFirstChildOfClass("Humanoid")
    else
        v76 = nil
    end

    if v76 then
        if v76 == nil then
            Character1 = v55
        else
            v55 = v76:LoadAnimation(Animation)
            assert(v55, "")
            v55.Priority = Enum.AnimationPriority.Action
            v55.Looped = false
            Character1 = v55
        end

        Character1:Play()
    end
end

t1.PlayFailureAnimation = PlayFailureAnimation

local function CancelFailureAnimation() --[[ Upvalues: v55 (ref) ]]
    if v55 ~= nil and v55.IsPlaying then
        v55:Stop()
    end
end

t1.CancelFailureAnimation = CancelFailureAnimation

local function SetWaypointTexture(a0) --[[ Upvalues: v1 (ref), v13 (ref), v14 (ref), v15 (ref), CreateWaypointTemplates (copy) ]]
    v1 = a0
    local v77, v78, v79 = CreateWaypointTemplates()
    v13 = v77
    v14 = v78
    v15 = v79
end

t1.SetWaypointTexture = SetWaypointTexture

local function GetWaypointTexture() --[[ Upvalues: v1 (ref) ]]
    return v1
end

t1.GetWaypointTexture = GetWaypointTexture

local function SetWaypointRadius(a0) --[[ Upvalues: v10 (ref), v13 (ref), v14 (ref), v15 (ref), CreateWaypointTemplates (copy) ]]
    v10 = Vector2.new(a0, a0)
    local v80, v81, v82 = CreateWaypointTemplates()
    v13 = v80
    v14 = v81
    v15 = v82
end

t1.SetWaypointRadius = SetWaypointRadius

local function GetWaypointRadius() --[[ Upvalues: v10 (ref) ]]
    return v10.X
end

t1.GetWaypointRadius = GetWaypointRadius

local function SetEndWaypointTexture(a0) --[[ Upvalues: v2 (ref), v13 (ref), v14 (ref), v15 (ref), CreateWaypointTemplates (copy) ]]
    v2 = a0
    local v83, v84, v85 = CreateWaypointTemplates()
    v13 = v83
    v14 = v84
    v15 = v85
end

t1.SetEndWaypointTexture = SetEndWaypointTexture

local function GetEndWaypointTexture() --[[ Upvalues: v2 (ref) ]]
    return v2
end

t1.GetEndWaypointTexture = GetEndWaypointTexture

local function SetWaypointsAlwaysOnTop(a0) --[[ Upvalues: v3 (ref), v13 (ref), v14 (ref), v15 (ref), CreateWaypointTemplates (copy) ]]
    v3 = a0
    local v86, v87, v88 = CreateWaypointTemplates()
    v13 = v86
    v14 = v87
    v15 = v88
end

t1.SetWaypointsAlwaysOnTop = SetWaypointsAlwaysOnTop

local function GetWaypointsAlwaysOnTop() --[[ Upvalues: v3 (ref) ]]
    return v3
end

t1.GetWaypointsAlwaysOnTop = GetWaypointsAlwaysOnTop
return t1
