
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local v1 = Color3.fromRGB(125, 225, 255)
local v2 = setmetatable({}, {__mode = "k"})

local function highlightFor(a0, a1) --[[ Upvalues: v1 (copy) ]]
    local Highlight = Instance.new("Highlight")
    Highlight.Name = a1
    Highlight.Adornee = a0
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.FillColor = v1
    Highlight.OutlineColor = v1
    Highlight.FillTransparency = 0.1
    Highlight.OutlineTransparency = 0
    Highlight.Parent = a0
    return Highlight
end

local function stop(a0)
    if a0.connection then
        a0.connection:Disconnect()
        a0.connection = nil
    end

    if a0.highlight then
        a0.highlight:Destroy()
        a0.highlight = nil
    end
end

local function bodyParts(a0)
    local t1 = {}
    local v3 = a0:GetChildren()
    for k1, k2 in ipairs(v3) do
        if k2:IsA("BasePart") and k2.Name ~= "HumanoidRootPart" and k2.Transparency < 1 then
            table.insert(t1, k2)
        else
            if k2:IsA("Accessory") then
                local Handle1 = k2:FindFirstChild("Handle")
                if Handle1 and Handle1:IsA("BasePart") and Handle1.Transparency < 1 then
                    table.insert(t1, Handle1)
                end
            end
        end
    end

    return t1
end

local function stamp(a0) --[[ Upvalues: v1 (copy), TweenService (copy), Debris (copy) ]]
    local Model = Instance.new("Model")
    Model.Name = "ChainsawRushAfterimage"
    for k3, k4 in ipairs(a0) do
        if k4.Parent then
            local v11 = k4:Clone()
            if v11 then
                local v12 = v11:GetDescendants()
                for k5, k6 in ipairs(v12) do
                    if k6:IsA("DataModelMesh") then
                        if k6:IsA("SpecialMesh") then
                            k6.TextureId = ""
                            -- branch continues at 61
                        end
                    else
                        if not k6:IsA("Bone") and not k6:IsA("FaceControls") then
                            k6:Destroy()
                        end
                    end
                end

                if v11:IsA("MeshPart") then
                    v11.TextureID = ""
                end

                v11.Anchored = true
                v11.CanCollide = false
                v11.CanTouch = false
                v11.CanQuery = false
                v11.CastShadow = false
                v11.Material = Enum.Material.Neon
                v11.MaterialVariant = ""
                v11.Color = v1
                v11.Transparency = 0.99
                v11.LocalTransparencyModifier = 0
                v11.CFrame = k4.CFrame
                v11.Parent = Model
            end
        end
    end

    if #Model:GetChildren() == 0 then
        Model:Destroy()
        return
    end

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
    local Highlight1 = Instance.new("Highlight")
    Highlight1.Name = "ChainsawRushSilhouette"
    Highlight1.Adornee = Model
    Highlight1.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight1.FillColor = v1
    Highlight1.OutlineColor = v1
    Highlight1.FillTransparency = 0.1
    Highlight1.OutlineTransparency = 0
    Highlight1.Parent = Model
    local v17 = workspace.CurrentCamera or workspace
    Model.Parent = v17
    local v18 = TweenInfo.new(0.4, Enum.EasingStyle.Linear)
    TweenService:Create(Highlight1, v18, {FillTransparency = 1, OutlineTransparency = 1}):Play()
    Debris:AddItem(Model, 0.4)
end

return function(a0) --[[ Upvalues: v2 (copy), v1 (copy), bodyParts (copy), stamp (copy), RunService (copy) ]]
    local Character = a0.Character
    local CastId = a0.CastId
    if not (Character and CastId) then
        return
    end

    local v19 = v2[Character]
    if a0.Phase == "Cancel" then
        if v19 then
            if v19.id == CastId then
                if v19.connection then
                    v19.connection:Disconnect()
                    v19.connection = nil
                end

                if v19.highlight then
                    v19.highlight:Destroy()
                    v19.highlight = nil
                end

                v19.phase = "Cancel"
            end
        end

        return
    end

    if a0.Phase ~= "Charge" and a0.Phase ~= "Rush" then
        return
    end

    local v20 = a0.Origin or Character:FindFirstChild("HumanoidRootPart")
    local v21 = Character:FindFirstChildOfClass("Humanoid")
    if not Character.Parent or not v20 or not v20.Parent or not v21 or v21.Health <= 0 then
        return
    end

    local v23 = a0.StartTime or workspace:GetServerTimeNow()
    local Duration = a0.Duration
    if not Duration then
        if a0.Phase == "Charge" then
            Duration = 0.5
        else
            Duration = 0.15
        end
    end

    local v24 = math.max(0, workspace:GetServerTimeNow() - v23)
    if v19 then
        if v19.id == CastId then
            if v19.phase == "Cancel" then
                return
            end

            if v19.phase == "Rush" then
                return
            end

            if a0.Phase == "Charge" then
                return
                -- branch continues at 138
            end
        else
            if v23 <= v19.started then
                return
            end
        end

        if v19.connection then
            v19.connection:Disconnect()
            v19.connection = nil
        end

        if v19.highlight then
            v19.highlight:Destroy()
            v19.highlight = nil
        end
    end

    v19 = {id = CastId, started = v23, phase = a0.Phase}
    v2[Character] = v19
    if Duration <= v24 then
        return
    end

    local function invalid() --[[ Upvalues: v2 (upvalue), Character (copy), v19 (copy), v20 (copy), v21 (copy) ]]
        local v25 = true
        local v26 = v2[Character]
        if v26 == v19 then
            v25 = not Character.Parent
            if not v25 then
                v25 = not v20.Parent
                if not v25 then
                    v25 = true
                    if v21.Health > 0 then
                        local v30 = Character:GetAttribute("Stun") or Character:GetAttribute("Ragdoll")
                    end
                end
            end
        end

        return v25
    end

    local v31 = nil
    if a0.Phase == "Charge" then
        local Highlight2 = Instance.new("Highlight")
        Highlight2.Name = "ChainsawRushCharge"
        Highlight2.Adornee = Character
        Highlight2.DepthMode = Enum.HighlightDepthMode.Occluded
        Highlight2.FillColor = v1
        Highlight2.OutlineColor = v1
        Highlight2.FillTransparency = 0.1
        Highlight2.OutlineTransparency = 0
        Highlight2.Parent = Character
        v19.highlight = Highlight2
    else
        v31 = bodyParts(Character)
    end

    local v32 = v24

    local function update() --[[ Upvalues: v23 (copy), v2 (upvalue), Character (copy), v19 (copy), v20 (copy), v21 (copy), Duration (copy), v32 (ref), stamp (upvalue), v31 (ref) ]]
        local v33 = workspace:GetServerTimeNow()
        local v34 = math.max(0, v33 - v23)
        local v35 = true
        local v36 = v2[Character]
        if v36 == v19 then
            v35 = not Character.Parent
            if not v35 then
                v35 = not v20.Parent
                if not v35 then
                    v35 = true
                    if v21.Health > 0 then
                        local v40 = Character:GetAttribute("Stun") or Character:GetAttribute("Ragdoll")
                    end
                end
            end
        end

        if v35 or Duration <= v34 then
            local v41 = v19
            if v41.connection then
                v41.connection:Disconnect()
                v41.connection = nil
            end

            if v41.highlight then
                v41.highlight:Destroy()
                v41.highlight = nil
            end

            return
        end

        if v19.highlight then
            v36 = v34 / Duration
            local v42 = math.clamp(v36, 0, 1)
            v19.highlight.FillTransparency = v42 * 0.9 + 0.1
            v19.highlight.OutlineTransparency = v42
            return
        end

        if v32 <= v34 then
            stamp(v31)
            v32 = v34 + 0.03
        end
    end

    v19.connection = RunService.RenderStepped:Connect(update)
    update()
    local v43 = math.max(0, Duration - v24) + 0.05
    task.delay(v43, function() --[[ Upvalues: v19 (copy) ]]
        local v44 = v19
        if v44.connection then
            v44.connection:Disconnect()
            v44.connection = nil
        end

        if v44.highlight then
            v44.highlight:Destroy()
            v44.highlight = nil
        end

    end)
end
