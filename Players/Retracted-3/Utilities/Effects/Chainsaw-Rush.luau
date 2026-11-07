-- https://lua.expert

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local v1 = Color3.fromRGB(125, 225, 255)
local self = setmetatable({}, {
    __mode = "k"
})

local function highlightFor(p1, p2) -- line: 11
    -- upvalues: v1 (copy)
    local Highlight = Instance.new("Highlight")

    Highlight.Name = p2
    Highlight.Adornee = p1
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.FillColor = v1
    Highlight.OutlineColor = v1
    Highlight.FillTransparency = 0.1
    Highlight.OutlineTransparency = 0
    Highlight.Parent = p1

    return Highlight
end

local function stop(p3) -- line: 24
    if p3.connection then
        p3.connection:Disconnect()
        p3.connection = nil
    end

    if p3.highlight then
        p3.highlight:Destroy()
        p3.highlight = nil
    end
end

local function bodyParts(p4) -- line: 35
    local t3 = {}

    for _, child in ipairs(p4:GetChildren()) do
        if not child:IsA("BasePart") or child.Name == "HumanoidRootPart" then
            if child:IsA("Accessory") then
                local Handle = child:FindFirstChild("Handle")

                if Handle and Handle:IsA("BasePart") and Handle.Transparency < 1 then
                    table.insert(t3, Handle)
                end
            end
        elseif child.Transparency < 1 then
            table.insert(t3, child)
        elseif child:IsA("Accessory") then
            local Handle = child:FindFirstChild("Handle")

            if Handle and Handle:IsA("BasePart") and Handle.Transparency < 1 then
                table.insert(t3, Handle)
            end
        end
    end

    return t3
end

local function stamp(p5) -- line: 50
    -- upvalues: TweenService (copy), Debris (copy), v1 (copy)
    local Model = Instance.new("Model")

    Model.Name = "ChainsawRushAfterimage"

    for _, v3 in ipairs(p5) do
        if v3.Parent then
            local clone = v3:Clone()

            if clone then
                for _, descendant in ipairs(clone:GetDescendants()) do
                    if descendant:IsA("DataModelMesh") then
                        if descendant:IsA("SpecialMesh") then
                            descendant.TextureId = ""
                        end
                    elseif not descendant:IsA("Bone") and not descendant:IsA("FaceControls") then
                        descendant:Destroy()
                    end
                end

                if clone:IsA("MeshPart") then
                    clone.TextureID = ""
                end

                clone.Anchored = true
                clone.CanCollide = false
                clone.CanTouch = false
                clone.CanQuery = false
                clone.CastShadow = false
                clone.Material = Enum.Material.Neon
                clone.MaterialVariant = ""
                clone.Color = v1
                clone.Transparency = 0.99
                clone.LocalTransparencyModifier = 0
                clone.CFrame = v3.CFrame
                clone.Parent = Model
            end
        end
    end

    if #Model:GetChildren() == 0 then
        Model:Destroy()
    else
        local Humanoid = Instance.new("Humanoid")

        Humanoid.Name = "Humanoid"
        Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
        Humanoid.NameDisplayDistance = 0
        Humanoid.HealthDisplayDistance = 0
        Humanoid.BreakJointsOnDeath = false
        Humanoid.RequiresNeck = false
        Humanoid.EvaluateStateMachine = false
        Humanoid.AutoRotate = false
        Humanoid.Parent = Model

        local Highlight = Instance.new("Highlight")

        Highlight.Name = "ChainsawRushSilhouette"
        Highlight.Adornee = Model
        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        Highlight.FillColor = v1
        Highlight.OutlineColor = v1
        Highlight.FillTransparency = 0.1
        Highlight.OutlineTransparency = 0
        Highlight.Parent = Model
        Model.Parent = workspace.CurrentCamera or workspace
        TweenService:Create(Highlight, TweenInfo.new(0.4, Enum.EasingStyle.Linear), {
            FillTransparency = 1,
            OutlineTransparency = 1
        }):Play()
        Debris:AddItem(Model, 0.4)
    end
end

return function(p6) -- line: 104
    -- upvalues: RunService (copy), v1 (copy), self (copy), bodyParts (copy), stamp (copy)
    local Character, CastId = p6.Character, p6.CastId

    if Character and CastId then
        local v4 = self[Character]

        if p6.Phase == "Cancel" then
            if v4 and v4.id == CastId then
                if v4.connection then
                    v4.connection:Disconnect()
                    v4.connection = nil
                end

                if v4.highlight then
                    v4.highlight:Destroy()
                    v4.highlight = nil
                end

                v4.phase = "Cancel"
            end
        elseif p6.Phase == "Charge" or p6.Phase == "Rush" then
            local v5 = p6.Origin or Character:FindFirstChild("HumanoidRootPart")
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")

            if Character.Parent and v5 and v5.Parent and Humanoid and not (Humanoid.Health <= 0) then
                local v6 = p6.StartTime or workspace:GetServerTimeNow()
                local Duration = p6.Duration

                if not Duration then
                    Duration = if p6.Phase == "Charge" then 0.5 else 0.15
                end

                local v8 = math.max(0, workspace:GetServerTimeNow() - v6)

                if v4 then
                    if v4.id == CastId then
                        if v4.phase == "Cancel" or v4.phase == "Rush" or p6.Phase == "Charge" then
                            return
                        end
                    elseif v6 <= v4.started then
                        return
                    end

                    if v4.connection then
                        v4.connection:Disconnect()
                        v4.connection = nil
                    end

                    if v4.highlight then
                        v4.highlight:Destroy()
                        v4.highlight = nil
                    end
                end

                local t4 = {
                    id = CastId,
                    started = v6,
                    phase = p6.Phase
                }

                self[Character] = t4

                if not (Duration <= v8) then
                    local function invalid() -- line: 135
                        -- upvalues: Character (copy), Humanoid (copy), t4 (copy), v5 (copy), self (copy)
                        local v9

                        if self[Character] == t4 then
                            v9 = not Character.Parent

                            if not v9 then
                                v9 = not v5.Parent

                                if not v9 then
                                    v9 = Humanoid.Health <= 0 or Character:GetAttribute("Stun") or Character:GetAttribute("Ragdoll")
                                end
                            end
                        else
                            v9 = true
                        end

                        return v9
                    end

                    local v10

                    if p6.Phase == "Charge" then
                        local Highlight = Instance.new("Highlight")

                        Highlight.Name = "ChainsawRushCharge"
                        Highlight.Adornee = Character
                        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                        Highlight.FillColor = v1
                        Highlight.OutlineColor = v1
                        Highlight.FillTransparency = 0.1
                        Highlight.OutlineTransparency = 0
                        Highlight.Parent = Character
                        t4.highlight = Highlight
                    else
                        v10 = bodyParts(Character)
                    end

                    local v11 = v8
                    local Duration2 = Duration

                    local function update() -- line: 146
                        -- upvalues: Character (copy), Humanoid (copy), t4 (copy), v10 (ref), v11 (ref), Duration2 (copy), v5 (copy), v6 (copy), self (copy), stamp (copy)
                        local v14 = math.max(0, workspace:GetServerTimeNow() - v6)
                        local v15

                        if self[Character] == t4 then
                            v15 = not Character.Parent

                            if not v15 then
                                v15 = not v5.Parent

                                if not v15 then
                                    v15 = Humanoid.Health <= 0 or Character:GetAttribute("Stun") or Character:GetAttribute("Ragdoll")
                                end
                            end
                        else
                            v15 = true
                        end

                        if v15 or Duration2 <= v14 then
                            if t4.connection then
                                t4.connection:Disconnect()
                                t4.connection = nil
                            end

                            if t4.highlight then
                                t4.highlight:Destroy()
                                t4.highlight = nil
                            end
                        elseif t4.highlight then
                            local v17 = math.clamp(v14 / Duration2, 0, 1)

                            t4.highlight.FillTransparency = v17 * 0.9 + 0.1
                            t4.highlight.OutlineTransparency = v17
                        elseif v11 <= v14 then
                            stamp(v10)
                            v11 = v14 + 0.03
                        end
                    end

                    t4.connection = RunService.RenderStepped:Connect(update)
                    update()
                    task.delay(math.max(0, Duration - v8) + 0.05, function() -- line: 162
                        -- upvalues: t4 (copy)
                        if t4.connection then
                            t4.connection:Disconnect()
                            t4.connection = nil
                        end

                        if t4.highlight then
                            t4.highlight:Destroy()
                            t4.highlight = nil
                        end
                    end)
                end
            end
        end
    end
end
