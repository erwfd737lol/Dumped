
local v1 = Vector2.new(0, 0)
v1 = CFrame.fromOrientation(-0.26179938779914941, 0, 0)
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
CommonUtils = require(FlagUtil).getUserFlag("UserFixCameraFPError")
local Players = game:GetService("Players")
local CameraInput = script.Parent:WaitForChild("CameraInput")
local v2 = require(CameraInput)
local CameraUtils = script.Parent:WaitForChild("CameraUtils")
local v3 = require(CameraUtils)
local BaseCamera = script.Parent:WaitForChild("BaseCamera")
local v4 = require(BaseCamera)
local v5 = setmetatable({}, v4)
v5.__index = v5

local function new() --[[ Upvalues: v4 (copy), v5 (copy), v3 (copy) ]]
    local v6 = setmetatable(v4.new(), v5)
    v6.isFollowCamera = false
    v6.isCameraToggle = false
    v6.lastUpdate = tick()
    v6.cameraToggleSpring = v3.Spring.new(5, 0)
    return v6
end

v5.new = new

local function GetCameraToggleOffset(a0, a1) --[[ Upvalues: v2 (copy), v3 (copy) ]]
    if a0.isCameraToggle then
        local currentSubjectDistance = a0.currentSubjectDistance
        if v2.getTogglePan() then
            local v7 = v3.map(currentSubjectDistance, 0.5, a0.FIRST_PERSON_DISTANCE_THRESHOLD, 0, 1)
            a0.cameraToggleSpring.goal = math.clamp(v7, 0, 1)
        else
            a0.cameraToggleSpring.goal = 0
        end

        local v8 = v3.map(currentSubjectDistance, 0.5, 64, 0, 1)
        local v9 = a0.cameraToggleSpring:step(a1) * (math.clamp(v8, 0, 1) + 1)
        return Vector3.new(0, v9, 0)
    end

    return Vector3.new()
end

v5.GetCameraToggleOffset = GetCameraToggleOffset

local function SetCameraMovementMode(a0, a1) --[[ Upvalues: v4 (copy) ]]
    v4.SetCameraMovementMode(a0, a1)
    a0.isFollowCamera = a1 == Enum.ComputerCameraMovementMode.Follow
    a0.isCameraToggle = a1 == Enum.ComputerCameraMovementMode.CameraToggle
end

v5.SetCameraMovementMode = SetCameraMovementMode
local v10 = 0

local function Update(a0, a1) --[[ Upvalues: v1 (copy), Players (copy), v2 (copy), v10 (ref), v3 (copy), CommonUtils (copy) ]]
    local v11 = tick()
    local CurrentCamera = workspace.CurrentCamera
    local CFrame = CurrentCamera.CFrame
    local Focus = CurrentCamera.Focus
    local v12 = nil
    if a0.resetCameraAngle then
        local v13 = a0:GetHumanoidRootPart()
        if v13 then
            v12 = (v13.CFrame * v1).lookVector
        else
            v12 = v1.lookVector
        end

        a0.resetCameraAngle = false
    end

    local LocalPlayer = Players.LocalPlayer
    local v14 = a0:GetHumanoid()
    local CameraSubject = CurrentCamera.CameraSubject
    local v17 = CameraSubject and CameraSubject:IsA("VehicleSeat")
    local v20 = CameraSubject and CameraSubject:IsA("SkateboardPlatform")
    local v21 = v14
    if v21 then
        local v22 = v14:GetState()
        v21 = v22 == Enum.HumanoidStateType.Climbing
    end

    if a0.lastUpdate == nil or 1 < a1 then
        a0.lastCameraTransform = nil
    end

    local v23 = v2.getRotation(a1)
    a0:StepZoom()
    local v24 = a0:GetCameraHeight()
    if v23 ~= Vector2.new() then
        v10 = 0
        a0.lastUserPanCamera = tick()
    end

    local v25 = v11 - a0.lastUserPanCamera
    local v26 = v25 < 2
    local v27 = a0:GetSubjectPosition()
    if v27 then
        if LocalPlayer then
            if CurrentCamera then
                local v28 = a0:GetCameraToSubjectDistance()
                if v28 < 0.5 then
                    v28 = 0.5
                end

                if a0:GetIsMouseLocked() then
                    if not a0:IsInFirstPerson() then
                        local v30 = a0:CalculateNewLookCFrameFromArg(v12, v23)
                        local v31 = a0:GetMouseLockOffset()
                        if v14 then
                            v31 = v31 + v14.CameraOffset
                        end

                        local v32 = v31.X * v30.RightVector
                        local v33 = v32 + v31.Y * v30.UpVector
                        local v34 = v33 + v31.Z * v30.LookVector
                        if v3.IsFiniteVector3(v34) then
                            v27 = v27 + v34
                            -- branch continues at 371
                        end

                        -- branch continues at 180
                    end
                else
                    if not (v23 ~= Vector2.new()) then
                        if a0.lastCameraTransform then
                            local v35 = a0:IsInFirstPerson()
                            if not v17 then
                                if not v20 then
                                    if a0.isFollowCamera then
                                        if not v21 then
                                            -- jump to 321
                                        end

                                        -- branch continues at 321
                                    end
                                end
                            end

                            if a0.lastUpdate then
                                local v37
                                if v14 then
                                    if v14.Torso then
                                        if v35 then
                                            if a0.lastSubjectCFrame then
                                                if not v17 then
                                                    if not v20 then
                                                        -- jump to 371
                                                    end
                                                end

                                                if CameraSubject:IsA("BasePart") then
                                                    local v38 = -v3.GetAngleBetweenXZVectors(a0.lastSubjectCFrame.lookVector, CameraSubject.CFrame.lookVector)
                                                    if v3.IsFinite(v38) then
                                                        v23 = v23 + Vector2.new(v38, 0)
                                                    end

                                                    v10 = 0
                                                    -- jump to 371 (out of range)
                                                    -- branch continues at 371
                                                end

                                                -- branch continues at 371
                                            end
                                        end

                                        if not v26 then
                                            local lookVector = v14.Torso.CFrame.lookVector
                                            v37 = v10 + 3.839724354387525 * a1
                                            v10 = math.clamp(v37, 0, 4.3633231299858242)
                                            v37 = v10 * a1
                                            local v39 = math.clamp(v37, 0, 1)
                                            if a0:IsInFirstPerson() then
                                                if not (a0.isFollowCamera and a0.isClimbing) then
                                                    v39 = 1
                                                end
                                            end

                                            local v40 = a0:GetCameraLookVector()
                                            local v41 = v3.GetAngleBetweenXZVectors(lookVector, v40)
                                            if v3.IsFinite(v41) then
                                                local v42 = math.abs(v41)
                                                if 0.0001 < v42 then
                                                    v23 = v23 + Vector2.new(v41 * v39, 0)
                                                    -- branch continues at 371
                                                end

                                                -- branch continues at 371
                                            end

                                            -- branch continues at 371
                                        end

                                        -- branch continues at 321
                                    end

                                    -- branch continues at 321
                                end
                            else
                                if a0.isFollowCamera then
                                    if not v35 then
                                        if not v26 then
                                            local v52 = -(a0.lastCameraTransform.p - v27)
                                            local v53 = a0:GetCameraLookVector()
                                            local v54 = v3.GetAngleBetweenXZVectors(v52, v53)
                                            if v3.IsFinite(v54) then
                                                local v55 = math.abs(v54)
                                                if 0.0001 < v55 then
                                                    local v56 = math.abs(v54)
                                                    if 0.4 * a1 < v56 then
                                                        v23 = v23 + Vector2.new(v54, 0)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                if not a0.isFollowCamera then
                    Focus = CFrame.new(v27)
                    local p = Focus.p
                    local v57 = a0:CalculateNewLookVectorFromArg(v12, v23)
                    if CommonUtils then
                        local v58 = p - v28 * v57
                        CFrame = CFrame.lookAlong(v58, v57)
                        -- jump to 452 (out of range)
                    end

                    local v59 = p - v28 * v57
                    CFrame = CFrame.new(v59, p)
                else
                    local v60 = a0:CalculateNewLookVectorFromArg(v12, v23)
                    Focus = CFrame.new(v27)
                    if CommonUtils then
                        local v61 = Focus.p - v28 * v60
                        CFrame = CFrame.lookAlong(v61, v60)
                    else
                        local v62 = Focus.p - v28 * v60
                        local v63 = CFrame.new(v62, Focus.p)
                        CFrame = v63 + Vector3.new(0, v24, 0)
                    end
                end

                local v64 = a0:GetCameraToggleOffset(a1)
                Focus = Focus + v64
                CFrame = CFrame + v64
                a0.lastCameraTransform = CFrame
                a0.lastCameraFocus = Focus
                if v17 or v20 then
                    if CameraSubject:IsA("BasePart") then
                        a0.lastSubjectCFrame = CameraSubject.CFrame
                        -- jump to 479 (out of range)
                    end
                end

                a0.lastSubjectCFrame = nil
            end
        end
    end

    a0.lastUpdate = v11
    return CFrame, Focus
end

v5.Update = Update
return v5
