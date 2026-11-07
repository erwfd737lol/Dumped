
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
CommonUtils = require(FlagUtil).getUserFlag("UserAllowAbilityControls")
local v1 = nil
if CommonUtils then
    local AvatarAbilitiesInterface = script.Parent:WaitForChild("AvatarAbilitiesInterface")
    v1 = require(AvatarAbilitiesInterface)
end

local BaseCharacterController = script.Parent:WaitForChild("BaseCharacterController")
local v2 = require(BaseCharacterController)
local v3 = setmetatable({}, v2)
v3.__index = v3

local function new() --[[ Upvalues: v2 (copy), v3 (copy) ]]
    local v4 = setmetatable(v2.new(), v3)
    v4.isFollowStick = false
    v4.thumbstickFrame = nil
    v4.moveTouchObject = nil
    v4.onTouchMovedConn = nil
    v4.onTouchEndedConn = nil
    v4.screenPos = nil
    v4.stickImage = nil
    v4.thumbstickSize = nil
    return v4
end

v3.new = new

local function Enable(a0, a1, a2)
    if a1 == nil then
        return false
    end

    local v5
    if a1 then
        v5 = true
    else
        v5 = false
    end

    a1 = v5
    if a0.enabled == a1 then
        return true
    end

    a0.moveVector = Vector3.new(0, 0, 0)
    a0.isJumping = false
    if a1 then
        if not a0.thumbstickFrame then
            a0:Create(a2)
        end

        a0.thumbstickFrame.Visible = true
    else
        a0.thumbstickFrame.Visible = false
        a0:OnInputEnded()
    end

    a0.enabled = a1
end

v3.Enable = Enable

local function OnInputEnded(a0)
    a0.thumbstickFrame.Position = a0.screenPos
    local v6 = a0.thumbstickFrame.Size.X.Offset / 2
    local v7 = v6 - a0.thumbstickSize / 4
    local v8 = a0.thumbstickFrame.Size.Y.Offset / 2
    a0.stickImage.Position = UDim2.new(0, v7, 0, v8 - a0.thumbstickSize / 4)
    a0.moveVector = Vector3.new(0, 0, 0)
    a0.isJumping = false
    a0.thumbstickFrame.Position = a0.screenPos
    a0.moveTouchObject = nil
end

v3.OnInputEnded = OnInputEnded

local function Create(a0, a1) --[[ Upvalues: CommonUtils (copy), v1 (ref), UserInputService (copy), GuiService (copy) ]]
    if a0.thumbstickFrame then
        a0.thumbstickFrame:Destroy()
        a0.thumbstickFrame = nil
        if a0.onTouchMovedConn then
            a0.onTouchMovedConn:Disconnect()
            a0.onTouchMovedConn = nil
        end

        if a0.onTouchEndedConn then
            a0.onTouchEndedConn:Disconnect()
            a0.onTouchEndedConn = nil
        end

        if a0.absoluteSizeChangedConn then
            a0.absoluteSizeChangedConn:Disconnect()
            a0.absoluteSizeChangedConn = nil
        end

        if CommonUtils and a0.avatarAbilitiesEnabledChangedConn then
            a0.avatarAbilitiesEnabledChangedConn:Disconnect()
            a0.avatarAbilitiesEnabledChangedConn = nil
        end
    end

    a0.thumbstickFrame = Instance.new("Frame")
    a0.thumbstickFrame.Name = "ThumbstickFrame"
    a0.thumbstickFrame.Active = true
    a0.thumbstickFrame.Visible = false
    a0.thumbstickFrame.BackgroundTransparency = 1
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "OuterImage"
    ImageLabel.Image = "rbxasset://textures/ui/TouchControlsSheet.png"
    ImageLabel.ImageRectOffset = Vector2.new()
    ImageLabel.ImageRectSize = Vector2.new(220, 220)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.new(0, 0, 0, 0)
    a0.stickImage = Instance.new("ImageLabel")
    a0.stickImage.Name = "StickImage"
    a0.stickImage.Image = "rbxasset://textures/ui/TouchControlsSheet.png"
    a0.stickImage.ImageRectOffset = Vector2.new(220, 0)
    a0.stickImage.ImageRectSize = Vector2.new(111, 111)
    a0.stickImage.BackgroundTransparency = 1
    a0.stickImage.ZIndex = 2

    local function ResizeThumbstick() --[[ Upvalues: a1 (copy), CommonUtils (upvalue), v1 (upvalue), a0 (copy), ImageLabel (copy) ]]
        local v9 = math.min(a1.AbsoluteSize.X, a1.AbsoluteSize.Y)
        local v10 = v9 <= 500
        if CommonUtils then
            local v11, v13
            if v1.isEnabled() then
                if v10 then
                    v9 = 64
                else
                    v9 = 100
                end

                if v10 then
                    v11 = 64
                else
                    v11 = 112
                end

                if v10 then
                    v13 = 72
                else
                    v13 = 120
                end

                a0.thumbstickSize = v13
                a0.screenPos = UDim2.new(0, v9, 1, -a0.thumbstickSize - v11)
                -- branch continues at 59
            end
        else
            local v14
            if v10 then
                v14 = 70
            else
                v14 = 120
            end

            a0.thumbstickSize = v14
            local v15 = a0
            local v16 = a0.thumbstickSize / 2 - 10
            local v17 = UDim2.new(0, v16, 1, -a0.thumbstickSize - 20)
            if not (v10 and v17) then
                v16 = a0.thumbstickSize / 2
                local v18 = UDim2.new(0, v16, 1, -a0.thumbstickSize * 1.75)
            end

            v15.screenPos = v17
        end

        a0.thumbstickFrame.Size = UDim2.new(0, a0.thumbstickSize, 0, a0.thumbstickSize)
        a0.thumbstickFrame.Position = a0.screenPos
        ImageLabel.Size = UDim2.new(0, a0.thumbstickSize, 0, a0.thumbstickSize)
        local v19 = a0.thumbstickSize / 2
        a0.stickImage.Size = UDim2.new(0, v19, 0, a0.thumbstickSize / 2)
        local v20 = a0.thumbstickSize / 2
        v19 = v20 - a0.thumbstickSize / 4
        local v21 = a0.thumbstickSize / 2
        a0.stickImage.Position = UDim2.new(0, v19, 0, v21 - a0.thumbstickSize / 4)
    end

    ResizeThumbstick()
    local v22 = a1:GetPropertyChangedSignal("AbsoluteSize")
    a0.absoluteSizeChangedConn = v22:Connect(ResizeThumbstick)
    if CommonUtils then
        a0.avatarAbilitiesEnabledChangedConn = v1.GetEnabledChangedSignal():Connect(ResizeThumbstick)
    end

    ImageLabel.Parent = a0.thumbstickFrame
    a0.stickImage.Parent = a0.thumbstickFrame
    local v23 = nil

    local function DoMove(a0) --[[ Upvalues: a0 (copy) ]]
        local v24 = a0 / (a0.thumbstickSize / 2)
        local magnitude = v24.magnitude
        if magnitude < 0.05 then
            v24 = Vector3.new()
        else
            v24 = v24.unit * math.min(1, (magnitude - 0.05) / 0.95)
            v24 = Vector3.new(v24.X, 0, v24.Y)
        end

        a0.moveVector = v24
    end

    local function MoveStick(a0) --[[ Upvalues: v23 (ref), a0 (copy) ]]
        local v25 = a0.X - v23.X
        local v26 = Vector2.new(v25, a0.Y - v23.Y)
        v25 = v26.magnitude
        local v27 = a0.thumbstickFrame.AbsoluteSize.X / 2
        if a0.isFollowStick and v27 < v25 then
            local v28 = v26.unit * v27
            local v29 = a0.X - a0.thumbstickFrame.AbsoluteSize.X / 2
            local v30 = v29 - v28.X
            local v31 = a0.Y - a0.thumbstickFrame.AbsoluteSize.Y / 2
            a0.thumbstickFrame.Position = UDim2.new(0, v30, 0, v31 - v28.Y)
        else
            v25 = math.min(v25, v27)
            v26 = v26.unit * v25
        end

        local v32 = v26.X + a0.stickImage.AbsoluteSize.X / 2
        a0.stickImage.Position = UDim2.new(0, v32, 0, v26.Y + a0.stickImage.AbsoluteSize.Y / 2)
    end

    a0.thumbstickFrame.InputBegan:Connect(function(a0) --[[ Upvalues: a0 (copy), v23 (ref) ]]
        if a0.moveTouchObject or a0.UserInputType ~= Enum.UserInputType.Touch or a0.UserInputState ~= Enum.UserInputState.Begin then
            return
        end

        a0.moveTouchObject = a0
        local v33 = a0.Position.X - a0.thumbstickFrame.Size.X.Offset / 2
        a0.thumbstickFrame.Position = UDim2.new(0, v33, 0, a0.Position.Y - a0.thumbstickFrame.Size.Y.Offset / 2)
        local v34 = a0.thumbstickFrame.AbsolutePosition.X + a0.thumbstickFrame.AbsoluteSize.X / 2
        v23 = Vector2.new(v34, a0.thumbstickFrame.AbsolutePosition.Y + a0.thumbstickFrame.AbsoluteSize.Y / 2)
        v34 = a0.Position.X - v23.X
        local v35 = Vector2.new(v34, a0.Position.Y - v23.Y)
    end)
    a0.onTouchMovedConn = UserInputService.TouchMoved:Connect(function(a0, a1) --[[ Upvalues: a0 (copy), v23 (ref), MoveStick (copy) ]]
        if a0 == a0.moveTouchObject then
            local v36 = a0.thumbstickFrame.AbsolutePosition.X + a0.thumbstickFrame.AbsoluteSize.X / 2
            v23 = Vector2.new(v36, a0.thumbstickFrame.AbsolutePosition.Y + a0.thumbstickFrame.AbsoluteSize.Y / 2)
            v36 = a0.Position.X - v23.X
            local v37 = Vector2.new(v36, a0.Position.Y - v23.Y)
            v36 = v37 / (a0.thumbstickSize / 2)
            local magnitude1 = v36.magnitude
            if magnitude1 < 0.05 then
                v36 = Vector3.new()
            else
                v36 = v36.unit * math.min(1, (magnitude1 - 0.05) / 0.95)
                v36 = Vector3.new(v36.X, 0, v36.Y)
            end

            a0.moveVector = v36
            MoveStick(a0.Position)
        end

    end)
    a0.onTouchEndedConn = UserInputService.TouchEnded:Connect(function(a0, a1) --[[ Upvalues: a0 (copy) ]]
        if a0 == a0.moveTouchObject then
            a0:OnInputEnded()
        end

    end)
    GuiService.MenuOpened:Connect(function() --[[ Upvalues: a0 (copy) ]]
        if a0.moveTouchObject then
            a0:OnInputEnded()
        end

    end)
    a0.thumbstickFrame.Parent = a1
end

v3.Create = Create
return v3
