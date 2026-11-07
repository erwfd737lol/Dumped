
local t1 = {}
local v1 = setmetatable({}, {__mode = "k"})

local function rootPart(a0)
    if a0:IsA("BasePart") then
        return a0
    end

    if a0:IsA("Model") then
        return a0.PrimaryPart
    end

    return nil
end

local function attachment(a0, a1, a2)
    if not a0 then
        return nil
    end

    local Attachment = Instance.new("Attachment")
    Attachment.Name = "ToolRig_" .. a1
    Attachment.CFrame = a2
    Attachment:SetAttribute("ToolRigOwned", true)
    Attachment.Parent = a0
    return Attachment
end

local function copyMetadata(a0, a1)
    local v2 = a0:GetAttributes()
    for k1, k2 in pairs(v2) do
        a1:SetAttribute(k1, k2)
    end

    local v6 = a0:GetTags()
    for k3, k4 in ipairs(v6) do
        a1:AddTag(k4)
    end
end

local function Convert(a0) --[[ Upvalues: copyMetadata (copy) ]]
    local t2 = {animation = 0, rigid = 0, unbound = 0}
    local v10 = a0:GetDescendants()
    for k5, k6 in ipairs(v10) do
        local v14 = k6:IsA("Motor6D")
        if v14 or k6:IsA("Weld") or k6:IsA("WeldConstraint") then
            local Part0 = k6.Part0
            local Part1 = k6.Part1
            local identity = CFrame.identity
            local identity1 = CFrame.identity
            if k6:IsA("JointInstance") then
                identity = k6.C0
                identity1 = k6.C1
            else
                if Part0 and Part1 then
                    identity = Part0.CFrame:ToObjectSpace(Part1.CFrame)
                end
            end

            local v15
            if v14 then
                v15 = "AnimationConstraint"
            else
                v15 = "RigidConstraint"
            end

            local v16 = Instance.new(v15)
            v16.Name = k6.Name
            copyMetadata(k6, v16)
            v16:SetAttribute("ToolRigOriginalClass", k6.ClassName)
            v16:SetAttribute("ToolRigC0", identity)
            v16:SetAttribute("ToolRigC1", identity1)
            v16:SetAttribute("ToolRigEnabled", k6.Enabled)
            local v17 = k6.Name .. "_0"
            local v18
            if not Part0 then
                v18 = nil
            else
                local Attachment1 = Instance.new("Attachment")
                Attachment1.Name = "ToolRig_" .. v17
                Attachment1.CFrame = identity
                Attachment1:SetAttribute("ToolRigOwned", true)
                Attachment1.Parent = Part0
                v18 = Attachment1
            end

            v16.Attachment0 = v18
            v17 = k6.Name .. "_1"
            if not Part1 then
                v18 = nil
            else
                identity = Instance.new("Attachment")
                identity.Name = "ToolRig_" .. v17
                identity.CFrame = identity1
                identity:SetAttribute("ToolRigOwned", true)
                identity.Parent = Part1
                v18 = identity
            end

            v16.Attachment1 = v18
            v18 = k6.Enabled
            if v18 then
                v18 = false
                if Part0 ~= nil then
                    v18 = Part1 ~= nil
                end
            end

            v16.Enabled = v18
            if v14 then
                v16.IsKinematic = true
                v16.Transform = k6.Transform
                t2.animation = t2.animation + 1
            else
                t2.rigid = t2.rigid + 1
            end

            if not (Part0 and Part1) then
                t2.unbound = t2.unbound + 1
            end

            local v19 = k6:GetChildren()
            for k7, k8 in ipairs(v19) do
                k8.Parent = v16
            end

            v16.Parent = k6.Parent
            k6:Destroy()
        end
    end

    return t2
end

t1.Convert = Convert

local function Unbind(a0) --[[ Upvalues: v1 (copy) ]]
    local v23 = v1[a0]
    if not v23 then
        return
    end

    v1[a0] = nil
    for k9, k10 in ipairs(v23.connections) do
        k10:Disconnect()
    end

    if v23.grip.Parent then
        v23.grip.Enabled = false
        v23.grip.Attachment0 = nil
    end

    if v23.handAttachment.Parent then
        v23.handAttachment:Destroy()
    end
end

t1.Unbind = Unbind
t1.Cleanup = t1.Unbind

local function bind(a0, a1, a2, a3, a4) --[[ Upvalues: t1 (copy), copyMetadata (copy), v1 (copy) ]]
    t1.Unbind(a0)
    local v27
    if a0:IsA("BasePart") then
        v27 = a0
    else
        if a0:IsA("Model") then
            v27 = a0.PrimaryPart
        else
            v27 = nil
        end
    end

    local v28 = assert(v27, "ToolRig requires a BasePart or Model with a PrimaryPart")
    local Grip = v28:FindFirstChild("Grip")
    local v29 = assert(Grip, "ToolRig: missing root Grip on " .. a0.Name)
    local v32 = v29:IsA("AnimationConstraint") or v29:IsA("RigidConstraint")
    assert(v32, "ToolRig: migrate tool attachments before binding " .. a0.Name)
    if typeof(a2) == "string" then
        a2 = a1:FindFirstChild(a2)
    end

    local v33 = a2
    if not v33 then
        local v34 = a1:FindFirstChild(v29:GetAttribute("WeldTo") or "RightHand")
    end

    a2 = v33
    local v37 = a2 and a2:IsA("BasePart")
    assert(v37, "ToolRig: missing tool hand for " .. a0.Name)
    local v38 = a2:IsDescendantOf(a1)
    assert(v38, "ToolRig: hand must belong to the character")
    local v39 = v29:GetAttribute("ToolRigC0")
    assert(typeof(v39) == "CFrame", "ToolRig: missing authored hand offset on " .. a0.Name)
    a3 = a3 or v39
    assert(typeof(a3) == "CFrame", "ToolRig: hand offset must be a CFrame")
    local v40 = assert(v29.Attachment1, "ToolRig: missing tool attachment on " .. a0.Name)
    assert(v40.Parent == v28, "ToolRig: Grip Attachment1 must be on the tool root")
    if a4 and not v29:IsA("RigidConstraint") then
        local RigidConstraint = Instance.new("RigidConstraint")
        RigidConstraint.Name = v29.Name
        copyMetadata(v29, RigidConstraint)
        RigidConstraint.Attachment1 = v40
        RigidConstraint.Enabled = false
        local v41 = v29:GetChildren()
        for k11, k12 in ipairs(v41) do
            k12.Parent = RigidConstraint
        end

        RigidConstraint.Parent = v29.Parent
        v29:Destroy()
        v29 = RigidConstraint
    end

    local v45
    if not a2 then
        v45 = nil
    else
        local Attachment2 = Instance.new("Attachment")
        Attachment2.Name = "ToolRig_Grip_0"
        Attachment2.CFrame = a3
        Attachment2:SetAttribute("ToolRigOwned", true)
        Attachment2.Parent = a2
        v45 = Attachment2
    end

    local v46 = v29:IsA("AnimationConstraint") and v29.Transform or CFrame.identity
    local v47 = v45.WorldCFrame * v46
    local v48 = v47 * v40.CFrame:Inverse()
    if a0:IsA("Model") then
        local v49 = v48 * v28.CFrame:Inverse()
        a0:PivotTo(v49 * a0:GetPivot())
    else
        v28.CFrame = v48
    end

    v29.Attachment0 = v45
    if v29:IsA("AnimationConstraint") then
        v29.IsKinematic = true
    end

    v29.Enabled = true
    v48 = {tool = nil, grip = v29, handAttachment = v45, connections = {}}
    v1[a0] = v48

    local function cleanup() --[[ Upvalues: v1 (upvalue), a0 (copy), v48 (copy), t1 (upvalue) ]]
        local v50 = v1[a0]
        if v50 == v48 then
            t1.Unbind(a0)
        end
    end

    v40 = {}
    local v51 = a0:GetDescendants()
    for k13, k14 in ipairs(v51) do
        if k14:IsA("AnimationConstraint") then
            local v55 = {enabled = k14.Enabled, kinematic = k14.IsKinematic}
            v40[k14] = v55
        end
    end

    v28 = a1:FindFirstChildOfClass("Humanoid")
    if v28 then
        local v60 = v28.Died:Connect(function() --[[ Upvalues: v1 (upvalue), a0 (copy), v48 (copy), v29 (ref), v45 (copy), v40 (copy) ]]
            task.defer(function() --[[ Upvalues: v1 (upvalue), a0 (upvalue), v48 (upvalue), v29 (upvalue), v45 (upvalue), v40 (upvalue) ]]
                local v56 = v1[a0]
                if v56 ~= v48 or not a0.Parent or not v29.Parent or v29.Attachment0 ~= v45 then
                    return
                end

                for k15, k16 in pairs(v40) do
                    if k15.Parent and k15:IsDescendantOf(a0) then
                        k15.IsKinematic = k16.kinematic
                        k15.Enabled = k16.enabled
                    end
                end

            end)
        end)
        table.insert(v48.connections, v60)
    end

    local v61 = a0.Destroying:Connect(cleanup)
    table.insert(v48.connections, v61)
    local v62 = a2.Destroying:Connect(cleanup)
    table.insert(v48.connections, v62)

    local function observeTool() --[[ Upvalues: a0 (copy), v48 (copy), a1 (copy), v1 (upvalue), t1 (upvalue) ]]
        local v63 = a0:FindFirstAncestorOfClass("Tool")
        if v63 and v48.tool ~= v63 then
            v48.tool = v63
            local v69 = v63.Unequipped:Connect(function() --[[ Upvalues: v48 (upvalue), v63 (copy), a0 (upvalue), a1 (upvalue), v1 (upvalue), t1 (upvalue) ]]
                if v48.tool == v63 then
                    local v65 = a0:FindFirstAncestorOfClass("Tool")
                    if v65 == v63 then
                        if v63.Parent ~= a1 then
                            local v68 = v1[a0]
                            if v68 == v48 then
                                t1.Unbind(a0)
                            end
                        end
                    end
                end

            end)
            table.insert(v48.connections, v69)
        end
    end

    observeTool()
    local v73 = a0.AncestryChanged:Connect(function() --[[ Upvalues: v1 (upvalue), a0 (copy), v48 (copy), t1 (upvalue), observeTool (copy), a1 (copy) ]]
        local v70 = v1[a0]
        if v70 ~= v48 then
            return
        end

        if a0.Parent == nil then
            local v71 = v1[a0]
            if v71 == v48 then
                t1.Unbind(a0)
            end

            return
        end

        observeTool()
        if v48.tool then
            if not a0:IsDescendantOf(v48.tool) or v48.tool.Parent ~= a1 then
                local v72 = v1[a0]
                if v72 == v48 then
                    t1.Unbind(a0)
                end
            end
        end

    end)
    table.insert(v48.connections, v73)
    return v29
end

local function Bind(a0, a1, a2, a3) --[[ Upvalues: bind (copy) ]]
    return bind(a0, a1, a2, a3, false)
end

t1.Bind = Bind

local function BindRigid(a0, a1, a2, a3) --[[ Upvalues: bind (copy) ]]
    return bind(a0, a1, a2, a3, true)
end

t1.BindRigid = BindRigid
return t1
