-- decompiled by Velocity decompiler v1.0.3

local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local v1 = nil
local v2 = nil
local v3 = nil
local v4 = {}
local t1 = {}
local t2 = {}
local t3 = {}
local v5 = 0
local v6 = false

local function disconnectAll(a0)
    for k1, k2 in ipairs(a0) do
        k2:Disconnect()
    end

    table.clear(a0)
end

local function resetCandy(a0, a1)
    if a1.revealing then
        return
    end

    local v10 = a0:GetAttribute("RevealStartedAt")
    if typeof(v10) == "number" then
        return
    end

    if a0.Parent then
        a0.CFrame = a1.rest
    end

    if a1.light and a1.light.Parent then
        a1.light.Enabled = false
    end

    if a1.shine and a1.shine.Parent then
        a1.shine.Enabled = false
    end
end

local function stopEvent() --[[ Upvalues: v3 (ref), v4 (copy), t3 (copy), resetCandy (copy), v2 (ref), v5 (ref) ]]
    if v3 then
        v3:Disconnect()
        v3 = nil
    end

    local v11 = v4
    for k3, k4 in ipairs(v11) do
        k4:Disconnect()
    end

    table.clear(v11)
    for k5, k6 in pairs(t3) do
        resetCandy(k5, k6)
    end

    table.clear(t3)
    v2 = nil
    v5 = 0
end

local function refreshCandy(a0) --[[ Upvalues: t3 (copy), resetCandy (copy) ]]
    local Candy = a0:FindFirstChild("Candy")
    for k7, k8 in pairs(t3) do
        if not Candy or k7.Parent ~= Candy then
            resetCandy(k7, k8)
            t3[k7] = nil
        end
    end

    if not Candy then
        return
    end

    local v21 = Candy:GetChildren()
    for k9, k10 in ipairs(v21) do
        if k10:IsA("BasePart") then
            local v25 = k10:GetAttribute("RestCFrame")
            local v26 = k10:GetAttribute("Phase")
            local v27 = k10:GetAttribute("SpawnedAt")
            if typeof(v25) == "CFrame" then
                if typeof(v26) == "number" then
                    if typeof(v27) == "number" then
                        local v28 = t3[k10]
                        if not v28 then
                            v28 = {}
                            t3[k10] = v28
                        end

                        v28.rest = v25
                        v28.phase = v26
                        v28.spawnedAt = v27
                        v27 = k10:FindFirstChild("CandyGlow", true)
                        local v31 = v27 and v27:IsA("PointLight") and v27 or nil
                        v28.light = v31
                        v27 = k10:FindFirstChild("CandyEffects")
                        local v32 = v27 and v27:FindFirstChild("Shine")
                        local v35 = v32 and v32:IsA("ParticleEmitter") and v32 or nil
                        v28.shine = v35
                    end
                end
            end
        end
    end
end

local function getViewPosition() --[[ Upvalues: LocalPlayer (copy) ]]
    local CurrentCamera = workspace.CurrentCamera
    if CurrentCamera then
        return CurrentCamera.CFrame.Position
    end

    local Character = LocalPlayer.Character
    local v37 = Character and Character:FindFirstChild("HumanoidRootPart")
    return v37 and v37.Position or nil
end

local v39 = nil

local function startEvent(a0) --[[ Upvalues: v6 (ref), v2 (ref), stopEvent (copy), refreshCandy (copy), v4 (copy), v1 (ref), v39 (ref), v5 (ref), v3 (ref), RunService (copy), LocalPlayer (copy), t3 (copy) ]]
    if v6 then
        return
    end

    if v2 == a0 then
        return
    end

    stopEvent()
    v2 = a0
    refreshCandy(a0)
    local v40 = a0.AncestryChanged:Connect(function() --[[ Upvalues: a0 (copy), v1 (upvalue), stopEvent (upvalue), v39 (upvalue) ]]
        if a0.Parent ~= v1 then
            stopEvent()
            task.defer(v39)
        end

    end)
    table.insert(v4, v40)
    local v41 = a0.DescendantAdded:Connect(function() --[[ Upvalues: v5 (upvalue) ]]
        v5 = 0
    end)
    table.insert(v4, v41)
    v3 = RunService.RenderStepped:Connect(function(a0) --[[ Upvalues: v2 (upvalue), a0 (copy), v1 (upvalue), stopEvent (upvalue), v5 (upvalue), refreshCandy (upvalue), LocalPlayer (upvalue), t3 (upvalue) ]]
        if v2 ~= a0 or a0.Parent ~= v1 then
            stopEvent()
            return
        end

        local v42 = workspace:GetServerTimeNow()
        local v43 = a0:GetAttribute("EndsAt")
        if typeof(v43) == "number" and v43 <= v42 then
            stopEvent()
            return
        end

        v5 = v5 - a0
        v43 = v5 <= 0
        if v43 then
            refreshCandy(a0)
            v5 = 0.25
        end

        local v44
        if v43 then
            local CurrentCamera1 = workspace.CurrentCamera
            local v45
            if CurrentCamera1 then
                v45 = CurrentCamera1.CFrame.Position
            else
                local Character1 = LocalPlayer.Character
                v44 = "HumanoidRootPart"
                local v47 = Character1:FindFirstChild(v44)
                local v48 = Character1 and v47
            end

            if v45 then
                -- jump to 83
            end
        end

        local v50 = nil
        for k11, k12 in pairs(t3) do
            if not k11.Parent then
                t3[k11] = nil
            else
                local v54 = k11:GetAttribute("RevealStartedAt")
                if typeof(v54) == "number" then
                    if not k12.revealing then
                        k12.revealStartFrame = k11.CFrame
                    end

                    k12.revealing = true
                    local v55 = k11:GetAttribute("RevealDuration")
                    local v56 = k11:GetAttribute("RevealStartSize")
                    local v57 = k11:GetAttribute("RevealTargetSize")
                    local v58 = k11:GetAttribute("RevealTargetCFrame")
                    local v60 = k12.revealStartFrame or k11:GetAttribute("RevealStartCFrame") or k12.rest
                    if typeof(v55) == "number" then
                        if 0 < v55 then
                            if typeof(v56) == "Vector3" then
                                if typeof(v57) == "Vector3" then
                                    if typeof(v58) == "CFrame" then
                                        if typeof(v60) == "CFrame" then
                                            local v61 = (v42 - v54) / v55
                                            v61 = 1 - (1 - math.clamp(v61, 0, 1)) ^ 2
                                            k11.Size = v56:Lerp(v57, v61)
                                            k11.CFrame = v60:Lerp(v58, v61)
                                            -- branch continues at 287
                                        end

                                        -- branch continues at 287
                                    end

                                    -- branch continues at 287
                                end

                                -- branch continues at 287
                            end

                            -- branch continues at 287
                        end

                        -- branch continues at 287
                    end
                else
                    if not k12.revealing then
                        local v62 = v42 - k12.spawnedAt
                        local v63 = v62 * 6.2831853071795862 / 3.5
                        local v64 = v63 + k12.phase
                        local v65 = v62 * 6.2831853071795862 / 4.8
                        v63 = v65 + k12.phase
                        local v66 = v62 * 6.2831853071795862 / 8
                        v65 = math.sin(v66 + k12.phase) * 0.20943951023931956
                        local v67 = math.sin(v63) * 0.18
                        local v68 = math.sin(v64) * 0.28
                        v67 = k12.rest + Vector3.new(v67, v68, math.cos(v63) * 0.08)
                        local v69 = math.sin(v63 + 0.6) * 0.05235987755982989
                        k11.CFrame = v67 * CFrame.Angles(v69, v65, math.sin(v63) * 0.12217304763960307)
                    end
                end

                if v43 or k12.revealing then
                    local v71 = v50 and k12.rest.Position - v50
                    local v72 = true
                    if k12.revealing ~= true then
                        v72 = false
                        if v71 ~= nil then
                            local v73 = v71:Dot(v71)
                            v72 = v73 <= 32400
                        end
                    end

                    if k12.light and k12.light.Parent and k12.light.Enabled ~= v72 then
                        k12.light.Enabled = v72
                    end

                    if k12.shine and k12.shine.Parent and k12.shine.Enabled ~= v72 then
                        k12.shine.Enabled = v72
                    end
                end
            end
        end

    end)
end

local function fn1() --[[ Upvalues: v6 (ref), v1 (ref), stopEvent (copy), startEvent (copy) ]]
    if v6 then
        return
    end

    if not v1 or v1.Parent ~= workspace then
        stopEvent()
        return
    end

    local v74 = v1:FindFirstChild("Trick or Treat")
    if v74 and v74:IsA("ObjectValue") then
        local v75 = v74:GetAttribute("EndsAt")
        if typeof(v75) ~= "number" or workspace:GetServerTimeNow() < v75 then
            startEvent(v74)
            return
        end
    end

    stopEvent()
end

local function watchEvents(a0) --[[ Upvalues: v6 (ref), v1 (ref), stopEvent (copy), t1 (copy), fn1 (ref) ]]
    if v6 then
        return
    end

    if v1 == a0 then
        return
    end

    stopEvent()
    local v76 = t1
    for k13, k14 in ipairs(v76) do
        k14:Disconnect()
    end

    table.clear(v76)
    v1 = a0
    if not a0 then
        return
    end

    local v80 = a0.ChildAdded:Connect(function(a0) --[[ Upvalues: fn1 (upvalue) ]]
        if a0.Name == "Trick or Treat" then
            fn1()
        end

    end)
    table.insert(t1, v80)
    local v81 = a0.ChildRemoved:Connect(function(a0) --[[ Upvalues: fn1 (upvalue) ]]
        if a0.Name == "Trick or Treat" then
            fn1()
        end

    end)
    table.insert(t1, v81)
    fn1()
end

local v82 = workspace.ChildAdded:Connect(function(a0) --[[ Upvalues: watchEvents (copy) ]]
    if a0.Name == "Events" then
        watchEvents(a0)
    end

end)
table.insert(t2, v82)
local v83 = workspace.ChildRemoved:Connect(function(a0) --[[ Upvalues: v1 (ref), watchEvents (copy) ]]
    if a0 == v1 then
        local Events = workspace:FindFirstChild("Events")
        watchEvents(Events)
    end

end)
table.insert(t2, v83)
local v91 = script.Destroying:Connect(function() --[[ Upvalues: v6 (ref), stopEvent (copy), t1 (copy), t2 (copy), v1 (ref) ]]
    v6 = true
    stopEvent()
    local v84 = t1
    for k15, k16 in ipairs(v84) do
        k16:Disconnect()
    end

    table.clear(v84)
    v84 = t2
    for k17, k18 in ipairs(v84) do
        k18:Disconnect()
    end

    table.clear(v84)
    v1 = nil
end)
table.insert(t2, v91)
local Events1 = workspace:FindFirstChild("Events")
watchEvents(Events1)
