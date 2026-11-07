-- https://lua.expert

local t1 = {}
local self = setmetatable({}, {
    __mode = "k"
})

local function rootPart(p1) -- line: 5
    if p1:IsA("BasePart") then
        return p1
    end

    return if p1:IsA("Model") then p1.PrimaryPart else nil
end

local function attachment(p2, p3, p4) -- line: 11
    if not p2 then
        return nil
    end

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "ToolRig_" .. p3
    Attachment.CFrame = p4
    Attachment:SetAttribute("ToolRigOwned", true)
    Attachment.Parent = p2

    return Attachment
end

local function copyMetadata(p5, p6) -- line: 21
    for v2, v3 in pairs(p5:GetAttributes()) do
        p6:SetAttribute(v2, v3)
    end

    for _, v4 in ipairs(p5:GetTags()) do
        p6:AddTag(v4)
    end
end

function t1.Convert(p7) -- line: 28
    -- upvalues: copyMetadata (copy)
    local t4 = {
        animation = 0,
        rigid = 0,
        unbound = 0
    }

    for _, descendant in ipairs(p7:GetDescendants()) do
        if descendant:IsA("Motor6D") then
            local Part0, Part1 = descendant.Part0, descendant.Part1
            local identity, identity2 = CFrame.identity, CFrame.identity

            if descendant:IsA("JointInstance") then
                identity = descendant.C0
                identity2 = descendant.C1
            elseif Part0 and Part1 then
                identity = Part0.CFrame:ToObjectSpace(Part1.CFrame)
            end

            local AnimationConstraint = Instance.new("AnimationConstraint")

            AnimationConstraint.Name = descendant.Name
            copyMetadata(descendant, AnimationConstraint)
            AnimationConstraint:SetAttribute("ToolRigOriginalClass", descendant.ClassName)
            AnimationConstraint:SetAttribute("ToolRigC0", identity)
            AnimationConstraint:SetAttribute("ToolRigC1", identity2)
            AnimationConstraint:SetAttribute("ToolRigEnabled", descendant.Enabled)

            local v5 = descendant.Name .. "_0"
            local Attachment

            if Part0 then
                Attachment = Instance.new("Attachment")
                Attachment.Name = "ToolRig_" .. v5
                Attachment.CFrame = identity
                Attachment:SetAttribute("ToolRigOwned", true)
                Attachment.Parent = Part0
            end

            AnimationConstraint.Attachment0 = Attachment

            local v6 = descendant.Name .. "_1"
            local Attachment2

            if Part1 then
                Attachment2 = Instance.new("Attachment")
                Attachment2.Name = "ToolRig_" .. v6
                Attachment2.CFrame = identity2
                Attachment2:SetAttribute("ToolRigOwned", true)
                Attachment2.Parent = Part1
            end

            AnimationConstraint.Attachment1 = Attachment2

            local Enabled = descendant.Enabled and Part0 ~= nil and Part1 ~= nil

            AnimationConstraint.Enabled = Enabled
            AnimationConstraint.IsKinematic = true
            AnimationConstraint.Transform = descendant.Transform
            t4.animation += 1

            if not Part0 or not Part1 then
                t4.unbound += 1
            end

            for _, child in ipairs(descendant:GetChildren()) do
                child.Parent = AnimationConstraint
            end

            AnimationConstraint.Parent = descendant.Parent
            descendant:Destroy()
        elseif descendant:IsA("Weld") or descendant:IsA("WeldConstraint") then
            local Part0, Part1 = descendant.Part0, descendant.Part1
            local identity, identity2 = CFrame.identity, CFrame.identity

            if descendant:IsA("JointInstance") then
                identity = descendant.C0
                identity2 = descendant.C1
            elseif Part0 and Part1 then
                identity = Part0.CFrame:ToObjectSpace(Part1.CFrame)
            end

            local RigidConstraint = Instance.new("RigidConstraint")

            RigidConstraint.Name = descendant.Name
            copyMetadata(descendant, RigidConstraint)
            RigidConstraint:SetAttribute("ToolRigOriginalClass", descendant.ClassName)
            RigidConstraint:SetAttribute("ToolRigC0", identity)
            RigidConstraint:SetAttribute("ToolRigC1", identity2)
            RigidConstraint:SetAttribute("ToolRigEnabled", descendant.Enabled)

            local v7 = descendant.Name .. "_0"
            local Attachment

            if Part0 then
                Attachment = Instance.new("Attachment")
                Attachment.Name = "ToolRig_" .. v7
                Attachment.CFrame = identity
                Attachment:SetAttribute("ToolRigOwned", true)
                Attachment.Parent = Part0
            end

            RigidConstraint.Attachment0 = Attachment

            local v8 = descendant.Name .. "_1"
            local Attachment2

            if Part1 then
                Attachment2 = Instance.new("Attachment")
                Attachment2.Name = "ToolRig_" .. v8
                Attachment2.CFrame = identity2
                Attachment2:SetAttribute("ToolRigOwned", true)
                Attachment2.Parent = Part1
            end

            RigidConstraint.Attachment1 = Attachment2

            local Enabled = descendant.Enabled and Part0 ~= nil and Part1 ~= nil

            RigidConstraint.Enabled = Enabled
            t4.rigid += 1

            if not Part0 or not Part1 then
                t4.unbound += 1
            end

            for _, child in ipairs(descendant:GetChildren()) do
                child.Parent = RigidConstraint
            end

            RigidConstraint.Parent = descendant.Parent
            descendant:Destroy()
        end
    end

    return t4
end

function t1.Unbind(p8) -- line: 66
    -- upvalues: self (copy)
    local v9 = self[p8]

    if not v9 then
        return
    end

    self[p8] = nil

    for _, v10 in ipairs(v9.connections) do
        v10:Disconnect()
    end

    if v9.grip.Parent then
        v9.grip.Enabled = false
        v9.grip.Attachment0 = nil
    end

    if v9.handAttachment.Parent then
        v9.handAttachment:Destroy()
    end
end

t1.Cleanup = t1.Unbind

local function bind(p9, p10, p11, p12, p13) -- line: 80
    -- upvalues: t1 (copy), self (copy), copyMetadata (copy)
    t1.Unbind(p9)

    local v11 = if p9:IsA("BasePart") then p9 elseif p9:IsA("Model") then p9.PrimaryPart else nil
    local v12 = assert(v11, "ToolRig requires a BasePart or Model with a PrimaryPart")
    local v14 = assert(v12:FindFirstChild("Grip"), "ToolRig: missing root Grip on " .. p9.Name)
    local v15 = v14

    assert(v14:IsA("AnimationConstraint") or v14:IsA("RigidConstraint"), "ToolRig: migrate tool attachments before binding " .. p9.Name)

    local v18 = (if typeof(p11) == "string" then p10:FindFirstChild(p11) else p11) or p10:FindFirstChild(v14:GetAttribute("WeldTo") or "RightHand")

    assert(v18 and v18:IsA("BasePart"), "ToolRig: missing tool hand for " .. p9.Name)
    assert(v18:IsDescendantOf(p10), "ToolRig: hand must belong to the character")

    local ToolRigC0 = v14:GetAttribute("ToolRigC0")

    assert(typeof(ToolRigC0) == "CFrame", "ToolRig: missing authored hand offset on " .. p9.Name)
    p12 = p12 or ToolRigC0
    assert(typeof(p12) == "CFrame", "ToolRig: hand offset must be a CFrame")

    local v27 = assert(v14.Attachment1, "ToolRig: missing tool attachment on " .. p9.Name)

    assert(v27.Parent == v12, "ToolRig: Grip Attachment1 must be on the tool root")

    if p13 and not v14:IsA("RigidConstraint") then
        local RigidConstraint = Instance.new("RigidConstraint")

        RigidConstraint.Name = v14.Name
        copyMetadata(v14, RigidConstraint)
        RigidConstraint.Attachment1 = v27
        RigidConstraint.Enabled = false

        for _, child in ipairs(v14:GetChildren()) do
            child.Parent = RigidConstraint
        end

        RigidConstraint.Parent = v14.Parent
        v14:Destroy()
        v14 = RigidConstraint
        v15 = RigidConstraint
    end

    local Attachment

    if v18 then
        Attachment = Instance.new("Attachment")
        Attachment.Name = "ToolRig_Grip_0"
        Attachment.CFrame = p12
        Attachment:SetAttribute("ToolRigOwned", true)
        Attachment.Parent = v18
    end

    local Transform = v14:IsA("AnimationConstraint") and v14.Transform or CFrame.identity
    local v29 = Attachment.WorldCFrame * Transform * v27.CFrame:Inverse()

    if p9:IsA("Model") then
        p9:PivotTo(v29 * v12.CFrame:Inverse() * p9:GetPivot())
    else
        v12.CFrame = v29
    end

    v14.Attachment0 = Attachment

    if v14:IsA("AnimationConstraint") then
        v14.IsKinematic = true
    end

    v14.Enabled = true

    local t5 = {
        tool = nil,
        grip = v14,
        handAttachment = Attachment,
        connections = {}
    }

    self[p9] = t5

    local function cleanup() -- line: 119
        -- upvalues: p9 (copy), t5 (copy), t1 (copy), self (copy)
        if self[p9] == t5 then
            t1.Unbind(p9)
        end
    end

    local t6 = {}

    for _, descendant in ipairs(p9:GetDescendants()) do
        if descendant:IsA("AnimationConstraint") then
            t6[descendant] = {
                enabled = descendant.Enabled,
                kinematic = descendant.IsKinematic
            }
        end
    end

    local Humanoid = p10:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        local connections = t5.connections
        local Died = Humanoid.Died
        local Attachment2 = Attachment

        table.insert(connections, Died:Connect(function() -- line: 131
            -- upvalues: p9 (copy), v15 (ref), t5 (copy), t6 (copy), Attachment2 (copy), self (copy)
            task.defer(function() -- line: 134
                -- upvalues: p9 (copy), v15 (ref), t5 (copy), t6 (copy), Attachment2 (copy), self (copy)
                if self[p9] == t5 and p9.Parent and v15.Parent and v15.Attachment0 == Attachment2 then
                    for v31, v32 in pairs(t6) do
                        if v31.Parent and v31:IsDescendantOf(p9) then
                            v31.IsKinematic = v32.kinematic
                            v31.Enabled = v32.enabled
                        end
                    end
                end
            end)
        end))
    end

    table.insert(t5.connections, p9.Destroying:Connect(cleanup))
    table.insert(t5.connections, v18.Destroying:Connect(cleanup))

    local function observeTool() -- line: 147
        -- upvalues: p9 (copy), p10 (copy), t5 (copy), t1 (copy), self (copy)
        local Tool = p9:FindFirstAncestorOfClass("Tool")

        if Tool and t5.tool ~= Tool then
            t5.tool = Tool
            table.insert(t5.connections, Tool.Unequipped:Connect(function() -- line: 151
                -- upvalues: Tool (copy), p9 (copy), p10 (copy), t5 (copy), t1 (copy), self (copy)
                if t5.tool == Tool and p9:FindFirstAncestorOfClass("Tool") == Tool and Tool.Parent ~= p10 and self[p9] == t5 then
                    t1.Unbind(p9)
                end
            end))
        end
    end

    observeTool()
    table.insert(t5.connections, p9.AncestryChanged:Connect(function() -- line: 162
        -- upvalues: p9 (copy), p10 (copy), t5 (copy), observeTool (copy), t1 (copy), self (copy)
        if self[p9] == t5 then
            if p9.Parent ~= nil then
                observeTool()

                if t5.tool and (not p9:IsDescendantOf(t5.tool) or t5.tool.Parent ~= p10) and self[p9] == t5 then
                    t1.Unbind(p9)
                end
            elseif self[p9] == t5 then
                t1.Unbind(p9)
            end
        end
    end))

    return v15
end

function t1.Bind(p14, p15, p16, p17) -- line: 178
    -- upvalues: bind (copy)
    return (bind(p14, p15, p16, p17, false))
end

function t1.BindRigid(p18, p19, p20, p21) -- line: 183
    -- upvalues: bind (copy)
    return (bind(p18, p19, p20, p21, true))
end

return t1
