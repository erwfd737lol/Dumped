
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return function(a0) --[[ Upvalues: ReplicatedStorage (copy), RunService (copy) ]]
    local Character = a0.Character
    local VampireFangs = ReplicatedStorage.Objects:FindFirstChild("VampireFangs")
    if not (VampireFangs and Character and Character.Parent) then
        return
    end

    local v1 = a0.Origin or Character:FindFirstChild("HumanoidRootPart")
    if not (v1 and v1:IsA("BasePart") and v1.Parent) then
        return
    end

    local v2 = VampireFangs:Clone()
    v2.Name = "VampireBiteFX"
    VampireFangs = v2:FindFirstChild("UpperFang")
    local LowerFang = v2:FindFirstChild("LowerFang")
    if not (VampireFangs and LowerFang) then
        v2:Destroy()
        return
    end

    local v3 = CFrame.new(0, 0, -(a0.ForwardOffset or 6))
    local v5 = VampireFangs:GetAttribute("JawOffset") or CFrame.identity
    local v7 = LowerFang:GetAttribute("JawOffset") or CFrame.identity
    local v8 = v2:GetDescendants()
    for k1, k2 in ipairs(v8) do
        if k2:IsA("BasePart") then
            k2.Anchored = true
            k2.CanCollide = false
            k2.CanTouch = false
            k2.CanQuery = false
            k2.CastShadow = false
        end
    end

    v2.Parent = workspace.CurrentCamera
    game.Debris:AddItem(v2, 1.2)
    local v13 = a0.StartTime or workspace:GetServerTimeNow()
    local v14 = nil

    local function finish() --[[ Upvalues: v14 (ref), v2 (copy) ]]
        if v14 then
            v14:Disconnect()
        end

        v2:Destroy()
    end

    local v15 = false
    v14 = RunService.RenderStepped:Connect(function() --[[ Upvalues: v13 (copy), Character (copy), v2 (copy), v1 (copy), v14 (ref), v3 (copy), VampireFangs (copy), v5 (copy), LowerFang (copy), v7 (copy), v15 (ref), a0 (copy) ]]
        local v16 = workspace:GetServerTimeNow()
        local v17 = v16 - v13
        local v18 = Character:FindFirstChildOfClass("Humanoid")
        if 0.85 <= v17 or not v2.Parent or not Character.Parent or not v1.Parent or not v18 or v18.Health <= 0 or Character:GetAttribute("Stun") or Character:GetAttribute("Ragdoll") then
            if v14 then
                v14:Disconnect()
            end

            v2:Destroy()
            return
        end

        v18 = v1.CFrame * v3
        local v19 = (v17 - 0.28) / 0.12
        local v20 = math.clamp(v19, 0, 1)
        v20 = v20 * v20
        v19 = 1 - v20
        local v21 = v19 * 0.45 - v20 * 0.55
        local v22 = v18 * CFrame.new(0, v21, 0)
        local v23 = math.rad(v19 * -10)
        local v24 = v22 * CFrame.Angles(v23, 0, 0)
        VampireFangs.CFrame = v24 * v5
        local v25 = v19 * -0.45 + v20 * 0.55
        local v26 = v18 * CFrame.new(0, v25, 0)
        local v27 = math.rad(v19 * 10)
        v24 = v26 * CFrame.Angles(v27, 0, 0)
        LowerFang.CFrame = v24 * v7
        if 0.4 <= v17 and not v15 then
            v15 = true
            local v28 = a0.Origin or Character:FindFirstChild("HumanoidRootPart")
            if v28 and v28.Parent then
                local v29 = {
                    Sound = "VampireBite",
                    Origin = v28,
                    Speed = 1.25 + math.random() * 0.1
                }
                _G.Utl.PlaySound(v29)
            end
        end

        local v30 = (v17 - 0.54) / 0.28
        v20 = math.clamp(v30, 0, 1)
        v18 = 1 - math.clamp(v17 / 0.07, 0, 1)
        VampireFangs.Transparency = math.max(v18, v20)
        LowerFang.Transparency = math.max(v18, v20)
    end)
end
