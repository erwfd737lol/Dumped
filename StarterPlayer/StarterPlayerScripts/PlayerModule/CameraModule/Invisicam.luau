
local Players = game:GetService("Players")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
CommonUtils = require(FlagUtil).getUserFlag("UserRaycastUpdateAPI2")
local v1 = {
    LIMBS = 2,
    MOVEMENT = 3,
    CORNERS = 4,
    CIRCLE1 = 5,
    CIRCLE2 = 6,
    LIMBMOVE = 7,
    SMART_CIRCLE = 8,
    CHAR_OUTLINE = 9
}
local v2 = {
    Head = true,
    ["Left Arm"] = true,
    ["Right Arm"] = true,
    ["Left Leg"] = true,
    ["Right Leg"] = true,
    LeftLowerArm = true,
    RightLowerArm = true,
    LeftUpperLeg = true,
    RightUpperLeg = true
}
local v3 = {
    Vector3.new(1, 1, -1),
    Vector3.new(1, -1, -1),
    Vector3.new(-1, -1, -1),
    Vector3.new(-1, 1, -1)
}
local v4 = RaycastParams.new()
v4.FilterType = Enum.RaycastFilterType.Exclude
local v5 = RaycastParams.new()
v5.FilterType = Enum.RaycastFilterType.Include

local function AssertTypes(a0, ...)
    local t1 = {}
    local v6 = ""
    local v7 = {...}
    for k1, k2 in pairs(v7) do
        t1[k2] = true
        local v11
        if v6 == "" then
            v11 = ""
        else
            v11 = " or "
        end

        v6 = v6 .. v11 .. k2
    end

    local v12 = type(a0)
    assert(t1[v12], v6 .. " type expected, got: " .. v12)
end

local function Det3x3(a0, a1, a2, a3, a4, a5, a6, a7, a8)
    local v13 = a0 * (a4 * a8 - a5 * a7)
    local v14 = v13 - a1 * (a3 * a8 - a5 * a6)
    return v14 + a2 * (a3 * a7 - a4 * a6)
end

local function RayIntersection(a0, a1, a2, a3)
    local v15 = a1:Cross(a3)
    local v16 = a2.X - a0.X
    local v17 = a2.Y - a0.Y
    local v18 = a2.Z - a0.Z
    local v19 = -a3.X
    local Y = a1.Y
    local v20 = -a3.Y
    local Y1 = v15.Y
    local Z = a1.Z
    local v21 = -a3.Z
    local Z1 = v15.Z
    local v22 = a1.X * (v20 * Z1 - Y1 * v21)
    local v23 = v22 - v19 * (Y * Z1 - Y1 * Z)
    local v24 = v23 + v15.X * (Y * v21 - v20 * Z)
    if v24 == 0 then
        return Vector3.new(0, 0, 0)
    end

    local v25 = -a3.X
    v20 = -a3.Y
    local Y2 = v15.Y
    Z = -a3.Z
    local Z2 = v15.Z
    v23 = v16 * (v20 * Z2 - Y2 * Z)
    Z1 = v23 - v25 * (v17 * Z2 - Y2 * v18)
    local v26 = (Z1 + v15.X * (v17 * Z - v20 * v18)) / v24
    Y2 = a1.Y
    Z = v15.Y
    Z2 = a1.Z
    Z1 = v15.Z
    local v27 = a1.X * (v17 * Z1 - Z * v18)
    local v28 = v27 - v16 * (Y2 * Z1 - Z * Z2)
    local v29 = (v28 + v15.X * (Y2 * v18 - v17 * Z2)) / v24
    v24 = a0 + v26 * a1
    v26 = a2 + v29 * a3
    v29 = v24 + (v26 - v24) * 0.5
    if (v26 - v24).Magnitude < 0.25 then
        return v29
    end

    return Vector3.new(0, 0, 0)
end

local BaseOcclusion = script.Parent:WaitForChild("BaseOcclusion")
local v30 = require(BaseOcclusion)
local v31 = setmetatable({}, v30)
v31.__index = v31

local function new() --[[ Upvalues: v30 (copy), v31 (copy), v1 (copy) ]]
    local v32 = setmetatable(v30.new(), v31)
    v32.char = nil
    v32.humanoidRootPart = nil
    v32.torsoPart = nil
    v32.headPart = nil
    v32.childAddedConn = nil
    v32.childRemovedConn = nil
    v32.behaviors = {}
    v32.behaviors[v1.LIMBS] = v32.LimbBehavior
    v32.behaviors[v1.MOVEMENT] = v32.MoveBehavior
    v32.behaviors[v1.CORNERS] = v32.CornerBehavior
    v32.behaviors[v1.CIRCLE1] = v32.CircleBehavior
    v32.behaviors[v1.CIRCLE2] = v32.CircleBehavior
    v32.behaviors[v1.LIMBMOVE] = v32.LimbMoveBehavior
    v32.behaviors[v1.SMART_CIRCLE] = v32.SmartCircleBehavior
    v32.behaviors[v1.CHAR_OUTLINE] = v32.CharacterOutlineBehavior
    v32.mode = v1.SMART_CIRCLE
    v32.behaviorFunction = v32.SmartCircleBehavior
    v32.savedHits = {}
    v32.trackedLimbs = {}
    v32.camera = game.Workspace.CurrentCamera
    v32.enabled = false
    return v32
end

v31.new = new

local function Enable(a0, a1)
    a0.enabled = a1
    if not a1 then
        a0:Cleanup()
    end
end

v31.Enable = Enable

local function GetOcclusionMode(a0)
    return Enum.DevCameraOcclusionMode.Invisicam
end

v31.GetOcclusionMode = GetOcclusionMode

local function LimbBehavior(a0, a1)
    for k3, k4 in pairs(a0.trackedLimbs) do
        local v36 = #a1 + 1
        a1[v36] = k3.Position
    end
end

v31.LimbBehavior = LimbBehavior

local function MoveBehavior(a0, a1)
    for i1 = 1, 3 do
        local Velocity = a0.humanoidRootPart.Velocity
        local v39 = Vector3.new(Velocity.X, 0, Velocity.Z).Magnitude / 2
        Velocity = (i1 - 1) * a0.humanoidRootPart.CFrame.lookVector * v39
        local v40 = #a1 + 1
        a1[v40] = a0.humanoidRootPart.Position + Velocity
    end
end

v31.MoveBehavior = MoveBehavior

local function CornerBehavior(a0, a1) --[[ Upvalues: v3 (copy) ]]
    local CFrame = a0.humanoidRootPart.CFrame
    local Position = CFrame.Position
    local v41 = CFrame - Position
    CFrame = a0.char:GetExtentsSize() / 2
    a1[#a1 + 1] = Position
    for i2 = 1, #v3 do
        local v44 = #a1 + 1
        a1[v44] = Position + v41 * (CFrame * v3[i2])
    end
end

v31.CornerBehavior = CornerBehavior

local function CircleBehavior(a0, a1) --[[ Upvalues: v1 (copy) ]]
    local v45
    if a0.mode == v1.CIRCLE1 then
        v45 = a0.humanoidRootPart.CFrame
    else
        local CoordinateFrame = a0.camera.CoordinateFrame
        local v46 = CoordinateFrame - CoordinateFrame.Position
        v45 = v46 + a0.humanoidRootPart.Position
    end

    local v47 = #a1 + 1
    a1[v47] = v45.Position
    v47 = 9
    for i3 = 0, v47 do
        local v49 = 0.62831853071795862 * i3
        local v50 = math.cos(v49)
        local v51 = math.sin(v49)
        local v52 = Vector3.new(v50, v51, 0) * 3
        local v53 = #a1 + 1
        a1[v53] = v45 * v52
    end
end

v31.CircleBehavior = CircleBehavior

local function LimbMoveBehavior(a0, a1)
    a0:LimbBehavior(a1)
    a0:MoveBehavior(a1)
end

v31.LimbMoveBehavior = LimbMoveBehavior

local function CharacterOutlineBehavior(a0, a1) --[[ Upvalues: CommonUtils (copy), v5 (copy) ]]
    local unit = a0.torsoPart.CFrame.upVector.unit
    local unit1 = a0.torsoPart.CFrame.rightVector.unit
    local v54 = #a1 + 1
    a1[v54] = a0.torsoPart.CFrame.p
    v54 = #a1 + 1
    a1[v54] = a0.torsoPart.CFrame.p + unit
    v54 = #a1 + 1
    a1[v54] = a0.torsoPart.CFrame.p - unit
    v54 = #a1 + 1
    a1[v54] = a0.torsoPart.CFrame.p + unit1
    v54 = #a1 + 1
    a1[v54] = a0.torsoPart.CFrame.p - unit1
    if a0.headPart then
        local v55 = #a1 + 1
        a1[v55] = a0.headPart.CFrame.p
    end

    local v56 = CFrame.new(Vector3.new(0, 0, 0), Vector3.new(a0.camera.CoordinateFrame.lookVector.X, 0, a0.camera.CoordinateFrame.lookVector.Z))
    local v57
    if not (a0.torsoPart and a0.torsoPart.Position) then
        v57 = a0.humanoidRootPart.Position
    end

    local v58 = {a0.torsoPart}
    if a0.headPart then
        local v59 = #v58 + 1
        v58[v59] = a0.headPart
    end

    for i4 = 1, 24 do
        local v62 = 6.2831853071795862 * i4 / 24
        local v63 = math.cos(v62)
        local v64 = math.sin(v62)
        local v65 = v56 * (Vector3.new(v63, v64, 0) * 3)
        local v66 = math.max(v65.Y, -2.25)
        v65 = Vector3.new(v65.X, v66, v65.Z)
        if CommonUtils then
            v5.FilterDescendantsInstances = v58
            local v67 = -3 * v65
            v62 = game.Workspace:Raycast(v57 + v65, v67, v5)
            if v62 then
                local Position2 = v62.Position
                local v68 = #a1 + 1
                a1[v68] = Position2 + 0.2 * (v57 - Position2).unit
                -- branch continues at 229
            end
        else
            local v69 = Ray.new(v57 + v65, -3 * v65)
            local v70, v71 = game.Workspace:FindPartOnRayWithWhitelist(v69, v58, false)
            if v70 then
                local v72 = #a1 + 1
                a1[v72] = v71 + 0.2 * (v57 - v71).unit
            end
        end
    end
end

v31.CharacterOutlineBehavior = CharacterOutlineBehavior

local function SmartCircleBehavior(a0, a1) --[[ Upvalues: CommonUtils (copy), v4 (copy), RayIntersection (copy) ]]
    local unit2 = a0.torsoPart.CFrame.upVector.unit
    local unit3 = a0.torsoPart.CFrame.rightVector.unit
    local v73 = #a1 + 1
    a1[v73] = a0.torsoPart.CFrame.p
    v73 = #a1 + 1
    a1[v73] = a0.torsoPart.CFrame.p + unit2
    v73 = #a1 + 1
    a1[v73] = a0.torsoPart.CFrame.p - unit2
    v73 = #a1 + 1
    a1[v73] = a0.torsoPart.CFrame.p + unit3
    v73 = #a1 + 1
    a1[v73] = a0.torsoPart.CFrame.p - unit3
    if a0.headPart then
        local v74 = #a1 + 1
        a1[v74] = a0.headPart.CFrame.p
    end

    unit3 = a0.camera.CFrame - a0.camera.CFrame.p
    local v75
    if not (a0.torsoPart and a0.torsoPart.Position) then
        v75 = a0.humanoidRootPart.Position
    end

    unit2 = Vector3.new(0, 0.5, 0) + v75
    local v76 = 24
    v75 = 1
    for i5 = 1, v76, v75 do
        local v77 = 0.26179938779914941 * i5 - 1.5707963267948966
        local v78 = math.cos(v77)
        local v79 = math.sin(v77)
        v77 = unit2 + unit3 * (Vector3.new(v78, v79, 0) * 2.5)
        local v80 = v77 - a0.camera.CFrame.p
        if CommonUtils then
            v78 = {a0.char}
            v4.FilterDescendantsInstances = v78
            local v81 = game.Workspace:Raycast(unit2, v77 - unit2, v4)
            local v82 = v77
            if v81 then
                local Normal = v81.Normal
                local v83 = v81.Position + 0.1 * Normal.unit
                local v84 = v83 - unit2
                local unit4 = v84:Cross(v80).unit:Cross(Normal).unit
                local v85 = v84.unit:Dot(-unit4)
                if v85 < v84.unit:Dot((v83 - a0.camera.CFrame.p).unit) then
                    v82 = RayIntersection(v83, unit4, v77, v80)
                    if 0 < v82.Magnitude then
                        v81 = game.Workspace:Raycast(v83, v82 - v83, v4)
                        if v81 then
                            v82 = v81.Position + 0.1 * v81.Normal.Unit
                            -- jump to 247 (out of range)
                            -- branch continues at 247
                        end
                    end

                    v82 = v83
                else
                    v82 = v83
                end

                v81 = game.Workspace:Raycast(unit2, v82 - unit2, v4)
                if v81 then
                    v82 = v81.Position - 0.1 * (v82 - unit2).unit
                end
            end

            a1[#a1 + 1] = v82
        else
            local v86 = Ray.new(unit2, v77 - unit2)
            local v87 = {a0.char}
            local v88, v89, v90 = game.Workspace:FindPartOnRayWithIgnoreList(v86, v87, false, false)
            v86 = v77
            if v88 then
                v87 = v89 + 0.1 * v90.unit
                local v91 = v87 - unit2
                local unit5 = v91:Cross(v80).unit:Cross(v90).unit
                local v92 = v91.unit:Dot(-unit5)
                if v92 < v91.unit:Dot((v87 - a0.camera.CFrame.p).unit) then
                    v86 = RayIntersection(v87, unit5, v77, v80)
                    if 0 < v86.Magnitude then
                        local v93 = Ray.new(v87, v86 - v87)
                        local v94 = {a0.char}
                        local v95, v96, v97 = game.Workspace:FindPartOnRayWithIgnoreList(v93, v94, false, false)
                        if v95 then
                            v86 = v96 + 0.1 * v97.unit
                            -- jump to 390 (out of range)
                            -- branch continues at 390
                        end
                    end

                    v86 = v87
                else
                    v86 = v87
                end

                local v98 = Ray.new(unit2, v86 - unit2)
                local v99 = {a0.char}
                local v100, v101, v102 = game.Workspace:FindPartOnRayWithIgnoreList(v98, v99, false, false)
                if v100 then
                    v86 = v101 - 0.1 * (v86 - unit2).unit
                end
            end

            a1[#a1 + 1] = v86
        end
    end
end

v31.SmartCircleBehavior = SmartCircleBehavior

local function CheckTorsoReference(a0)
    if a0.char then
        a0.torsoPart = a0.char:FindFirstChild("Torso")
        if not a0.torsoPart then
            a0.torsoPart = a0.char:FindFirstChild("UpperTorso")
            if not a0.torsoPart then
                a0.torsoPart = a0.char:FindFirstChild("HumanoidRootPart")
            end
        end

        a0.headPart = a0.char:FindFirstChild("Head")
    end
end

v31.CheckTorsoReference = CheckTorsoReference

local function CharacterAdded(a0, a1, a2) --[[ Upvalues: Players (copy), v2 (copy) ]]
    if a2 ~= Players.LocalPlayer then
        return
    end

    if a0.childAddedConn then
        a0.childAddedConn:Disconnect()
        a0.childAddedConn = nil
    end

    if a0.childRemovedConn then
        a0.childRemovedConn:Disconnect()
        a0.childRemovedConn = nil
    end

    a0.char = a1
    a0.trackedLimbs = {}

    local function childAdded(a0) --[[ Upvalues: v2 (upvalue), a0 (copy) ]]
        if a0:IsA("BasePart") then
            if v2[a0.Name] then
                a0.trackedLimbs[a0] = true
            end

            if a0.Name == "Torso" or a0.Name == "UpperTorso" then
                a0.torsoPart = a0
            end

            if a0.Name == "Head" then
                a0.headPart = a0
            end
        end
    end

    local function childRemoved(a0) --[[ Upvalues: a0 (copy) ]]
        a0.trackedLimbs[a0] = nil
        a0:CheckTorsoReference()
    end

    a0.childAddedConn = a1.ChildAdded:Connect(childAdded)
    a0.childRemovedConn = a1.ChildRemoved:Connect(childRemoved)
    local v103 = a0.char:GetChildren()
    for k5, k6 in pairs(v103) do
        if k6:IsA("BasePart") then
            if v2[k6.Name] then
                a0.trackedLimbs[k6] = true
            end

            if k6.Name == "Torso" or k6.Name == "UpperTorso" then
                a0.torsoPart = k6
            end

            if k6.Name == "Head" then
                a0.headPart = k6
            end
        end
    end
end

v31.CharacterAdded = CharacterAdded

local function SetMode(a0, a1) --[[ Upvalues: AssertTypes (copy), v1 (copy) ]]
    AssertTypes(a1, "number")
    for k7, k8 in pairs(v1) do
        if k8 == a1 then
            a0.mode = a1
            a0.behaviorFunction = a0.behaviors[a0.mode]
            return
        end
    end

    error("Invalid mode number")
end

v31.SetMode = SetMode

local function GetObscuredParts(a0)
    return a0.savedHits
end

v31.GetObscuredParts = GetObscuredParts

local function Cleanup(a0)
    for k9, k10 in pairs(a0.savedHits) do
        k9.LocalTransparencyModifier = k10
    end
end

v31.Cleanup = Cleanup

local function Update(a0, a1, a2, a3)
    if not (a0.enabled and a0.char) then
        return a2, a3
    end

    a0.camera = game.Workspace.CurrentCamera
    if not a0.humanoidRootPart then
        local v113 = a0.char:FindFirstChildOfClass("Humanoid")
        if v113 and v113.RootPart then
            a0.humanoidRootPart = v113.RootPart
        else
            a0.humanoidRootPart = a0.char:FindFirstChild("HumanoidRootPart")
            if not a0.humanoidRootPart then
                return a2, a3
            end
        end

        local v114 = nil
        v114 = a0.humanoidRootPart.AncestryChanged:Connect(function(a0, a1) --[[ Upvalues: a0 (copy), v114 (ref) ]]
            if a0 == a0.humanoidRootPart and not a1 then
                a0.humanoidRootPart = nil
                if v114 and v114.Connected then
                    v114:Disconnect()
                    v114 = nil
                end
            end

        end)
    end

    if not a0.torsoPart then
        a0:CheckTorsoReference()
        if not a0.torsoPart then
            return a2, a3
        end
    end

    local v115 = {}
    a0.behaviorFunction(a0, v115)
    local v116 = {}
    local v117 = {a0.char}

    local function add(a0) --[[ Upvalues: v116 (copy), a0 (copy) ]]
        v116[a0] = true
        if not a0.savedHits[a0] then
            a0.savedHits[a0] = a0.LocalTransparencyModifier
        end
    end

    local v118 = 0
    local t2 = {}
    local v119 = 0.75
    local v120 = 0.75
    local v123 = {
        a0.headPart and a0.headPart.CFrame.p or v115[1],
        a0.torsoPart and a0.torsoPart.CFrame.p or v115[2]
    }
    local v124 = a0.camera:GetPartsObscuringTarget(v123, v117)
    for i6 = 1, #v124 do
        local v128 = v124[i6]
        v118 = v118 + 1
        t2[v128] = true
        local v129 = v128:GetChildren()
        for k11, k12 in pairs(v129) do
            if k12:IsA("Decal") or k12:IsA("Texture") then
                v118 = v118 + 1
                break
            end
        end
    end

    if 0 < v118 then
        local v133 = 0.375 / v118 + 0.375
        v119 = math.pow(v133, 1 / v118)
        v133 = 0.25 / v118 + 0.25
        i6 = 1 / v118
        v120 = math.pow(v133, i6)
    end

    local v134 = v117
    v124 = a0.camera:GetPartsObscuringTarget(v115, v134)
    v118 = {}
    for i7 = 1, #v124 do
        v117 = v124[i7]
        v118[v117] = t2[v117] and v119 or v120
        if v117.Transparency < v118[v117] then
            v116[v117] = true
            if not a0.savedHits[v117] then
                a0.savedHits[v117] = v117.LocalTransparencyModifier
            end
        end

        local v138 = v117:GetChildren()
        for k13, k14 in pairs(v138) do
            if k14:IsA("Decal") or k14:IsA("Texture") then
                if k14.Transparency < v118[v117] then
                    v118[k14] = v118[v117]
                    v116[k14] = true
                    if not a0.savedHits[k14] then
                        a0.savedHits[k14] = k14.LocalTransparencyModifier
                    end
                end
            end
        end
    end

    for k15, k16 in pairs(a0.savedHits) do
        if v116[k15] then
            local v145 = v118[k15] - k15.Transparency
            local v146 = v145 / (1 - k15.Transparency)
            k15.LocalTransparencyModifier = k15.Transparency < 1 and v146 or 0
        else
            k15.LocalTransparencyModifier = k16
            a0.savedHits[k15] = nil
        end
    end

    return a2, a3
end

v31.Update = Update
return v31
