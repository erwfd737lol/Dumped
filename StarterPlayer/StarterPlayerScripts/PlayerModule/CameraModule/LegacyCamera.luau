
local v1 = Vector2.new()
local CameraUtils = script.Parent:WaitForChild("CameraUtils")
local v2 = require(CameraUtils)
local CameraInput = script.Parent:WaitForChild("CameraInput")
local v3 = require(CameraInput)
local Players = game:GetService("Players")
local BaseCamera = script.Parent:WaitForChild("BaseCamera")
local v4 = require(BaseCamera)
local v5 = setmetatable({}, v4)
v5.__index = v5

local function new() --[[ Upvalues: v4 (copy), v5 (copy) ]]
    local v6 = setmetatable(v4.new(), v5)
    v6.cameraType = Enum.CameraType.Fixed
    v6.lastUpdate = tick()
    v6.lastDistanceToSubject = nil
    return v6
end

v5.new = new

local function GetModuleName(a0)
    return "LegacyCamera"
end

v5.GetModuleName = GetModuleName

local function SetCameraToSubjectDistance(a0, a1) --[[ Upvalues: v4 (copy) ]]
    local v7 = v4.SetCameraToSubjectDistance(a0, a1)
    return v7
end

v5.SetCameraToSubjectDistance = SetCameraToSubjectDistance

local function Update(a0, a1) --[[ Upvalues: Players (copy), v3 (copy) ]]
    if not a0.cameraType then
        return nil, nil
    end

    local v8 = tick()
    local v9 = v8 - a0.lastUpdate
    local CurrentCamera = workspace.CurrentCamera
    local CFrame = CurrentCamera.CFrame
    local Focus = CurrentCamera.Focus
    local LocalPlayer = Players.LocalPlayer
    local v10 = v3.getRotation(a1)
    if a0.lastUpdate == nil or 1 < v9 then
        a0.lastDistanceToSubject = nil
    end

    v9 = a0:GetSubjectPosition()
    if a0.cameraType == Enum.CameraType.Fixed then
        if v9 then
            if LocalPlayer then
                if CurrentCamera then
                    local v11 = a0:GetCameraToSubjectDistance()
                    local v12 = a0:CalculateNewLookVectorFromArg(nil, v10)
                    Focus = CurrentCamera.Focus
                    CFrame = CFrame.new(CurrentCamera.CFrame.p, CurrentCamera.CFrame.p + v11 * v12)
                    -- branch continues at 227
                end

                -- branch continues at 227
            end

            -- branch continues at 227
        end
    else
        if a0.cameraType == Enum.CameraType.Attach then
            local v13 = a0:GetSubjectCFrame()
            local v14 = CurrentCamera.CFrame:ToEulerAnglesYXZ()
            local v15, v16 = v13:ToEulerAnglesYXZ()
            local v17 = v14 - v10.Y
            v14 = math.clamp(v17, -1.3962634015954636, 1.3962634015954636)
            local v18 = CFrame.new(v13.p)
            Focus = v18 * CFrame.fromEulerAnglesYXZ(v14, v16, 0)
            local v19 = a0:StepZoom()
            CFrame = Focus * CFrame.new(0, 0, v19)
        else
            if a0.cameraType ~= Enum.CameraType.Watch then
                return CurrentCamera.CFrame, CurrentCamera.Focus
            end

            if v9 then
                if LocalPlayer then
                    if CurrentCamera then
                        local v20 = nil
                        if v9 == CurrentCamera.CFrame.p then
                            warn("Camera cannot watch subject in same position as itself")
                            return CurrentCamera.CFrame, CurrentCamera.Focus
                        end

                        local v21 = a0:GetHumanoid()
                        if v21 then
                            if v21.RootPart then
                                local v24 = v9 - CurrentCamera.CFrame.p
                                v20 = v24.unit
                                if a0.lastDistanceToSubject and a0.lastDistanceToSubject == a0:GetCameraToSubjectDistance() then
                                    a0:SetCameraToSubjectDistance(v24.magnitude)
                                end
                            end
                        end

                        local v25 = a0:GetCameraToSubjectDistance()
                        local v26 = a0:CalculateNewLookVectorFromArg(v20, v10)
                        Focus = CFrame.new(v9)
                        local v27 = v9 - v25 * v26
                        CFrame = CFrame.new(v27, v9)
                        a0.lastDistanceToSubject = v25
                    end
                end
            end
        end
    end

    a0.lastUpdate = v8
    return CFrame, Focus
end

v5.Update = Update
return v5
