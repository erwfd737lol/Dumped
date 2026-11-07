
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CameraInput = script.Parent:WaitForChild("CameraInput")
local v1 = require(CameraInput)
local CameraUI = script.Parent:WaitForChild("CameraUI")
local v2 = require(CameraUI)
local CameraUtils = script.Parent:WaitForChild("CameraUtils")
local v3 = require(CameraUtils)
v2.setCameraModeToastEnabled(false)
local v4 = false
local v5 = false
local v6 = tick()
local v7 = false
local v8 = false
return function(a0) --[[ Upvalues: v1 (copy), v4 (ref), v5 (ref), v6 (ref), v2 (copy), v7 (ref), v8 (ref), v3 (copy) ]]
    local v9 = v1.getTogglePan()
    if a0 and v9 ~= v4 then
        v5 = true
    end

    if v4 ~= v9 or tick() - v6 < v10 then
        v10 = v9
        if v10 then
            local v11 = tick() - v6
            v10 = v11 < 3
        end

        v2.setCameraModeToastOpen(v10)
        if v9 then
            v5 = false
        end

        v6 = tick()
        v4 = v9
    end

    if a0 ~= v7 then
        if a0 then
            v8 = v1.getTogglePan()
            v1.setTogglePan(true)
        else
            if not v5 then
                v1.setTogglePan(v8)
            end
        end
    end

    if a0 then
        if v1.getTogglePan() then
            v3.setMouseIconOverride("rbxasset://textures/Cursors/CrossMouseIcon.png")
            v3.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)
            v3.setRotationTypeOverride(Enum.RotationType.CameraRelative)
            -- jump to 190 (out of range)
        end

        v3.restoreMouseIcon()
        v3.restoreMouseBehavior()
        v3.setRotationTypeOverride(Enum.RotationType.CameraRelative)
    else
        if v1.getTogglePan() then
            v3.setMouseIconOverride("rbxasset://textures/Cursors/CrossMouseIcon.png")
            v3.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)
            v3.setRotationTypeOverride(Enum.RotationType.MovementRelative)
        else
            if v1.getHoldPan() then
                v3.restoreMouseIcon()
                v3.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition)
                v3.setRotationTypeOverride(Enum.RotationType.MovementRelative)
            else
                v3.restoreMouseIcon()
                v3.restoreMouseBehavior()
                v3.restoreRotationType()
            end
        end
    end

    v7 = a0
end
