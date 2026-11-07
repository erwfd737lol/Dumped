
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local ConnectionUtil = CommonUtils:WaitForChild("ConnectionUtil")
local v1 = require(ConnectionUtil)
local CharacterUtil = CommonUtils:WaitForChild("CharacterUtil")
local v2 = require(CharacterUtil)
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
CommonUtils = require(FlagUtil).getUserFlag("UserAllowAbilityControls")
local v3 = nil
if CommonUtils then
    local AvatarAbilitiesInterface = script.Parent:WaitForChild("AvatarAbilitiesInterface")
    v3 = require(AvatarAbilitiesInterface)
end

local v4 = {
    "rbxasset://textures/ui/Input/JumpButtonRegular.png",
    "rbxasset://textures/ui/Input/JumpButtonPressed.png"
}
local BaseCharacterController = script.Parent:WaitForChild("BaseCharacterController")
local v5 = require(BaseCharacterController)
local v6 = setmetatable({}, v5)
v6.__index = v6

local function new() --[[ Upvalues: v5 (copy), v6 (copy), v1 (copy) ]]
    local v7 = setmetatable(v5.new(), v6)
    v7.parentUIFrame = nil
    v7.jumpButton = nil
    v7.externallyEnabled = false
    v7.isJumping = false
    v7._active = false
    v7._connectionUtil = v1.new()
    return v7
end

v6.new = new

local function _reset(a0) --[[ Upvalues: CommonUtils (copy), v3 (ref), v4 (copy) ]]
    a0.isJumping = false
    a0.touchObject = nil
    if a0.jumpButton then
        if CommonUtils and v3.isEnabled() then
            a0.jumpButton.Image = v4[1]
            return
        end

        a0.jumpButton.ImageRectOffset = Vector2.new(1, 146)
    end
end

v6._reset = _reset

local function EnableButton(a0, a1) --[[ Upvalues: GuiService (copy) ]]
    if a1 == a0._active then
        return
    end

    if a1 then
        if not a0.jumpButton then
            a0:Create()
        end

        a0.jumpButton.Visible = true
        local v8 = a0.jumpButton.InputEnded:Connect(function(a0) --[[ Upvalues: a0 (copy) ]]
            if a0 == a0.touchObject then
                a0:_reset()
            end

        end)
        a0._connectionUtil:trackConnection("JUMP_INPUT_ENDED", v8)
        local v9 = GuiService.MenuOpened:Connect(function() --[[ Upvalues: a0 (copy) ]]
            if a0.touchObject then
                a0:_reset()
            end

        end)
        a0._connectionUtil:trackConnection("MENU_OPENED", v9)
    else
        if a0.jumpButton then
            a0.jumpButton.Visible = false
        end

        a0._connectionUtil:disconnect("JUMP_INPUT_ENDED")
        a0._connectionUtil:disconnect("MENU_OPENED")
    end

    a0:_reset()
    a0._active = a1
end

v6.EnableButton = EnableButton

local function UpdateEnabled(a0) --[[ Upvalues: v2 (copy) ]]
    local v10 = v2.getChild("Humanoid", "Humanoid")
    if v10 then
        if a0.externallyEnabled then
            if not v10.UseJumpPower or 0 >= v10.JumpPower then
                if not v10.UseJumpPower then
                    if 0 >= v10.JumpHeight then
                        -- jump to 40
                    end

                    -- branch continues at 40
                end
            end

            if v10:GetStateEnabled(Enum.HumanoidStateType.Jumping) then
                a0:EnableButton(true)
                return
            end
        end
    end

    a0:EnableButton(false)
end

v6.UpdateEnabled = UpdateEnabled

local function _setupConfigurations(a0) --[[ Upvalues: v2 (copy) ]]

    local function update() --[[ Upvalues: a0 (copy) ]]
        a0:UpdateEnabled()
    end

    local v16 = v2.onChild("Humanoid", "Humanoid", function(a0) --[[ Upvalues: a0 (copy), update (copy) ]]
        a0:UpdateEnabled()
        a0:_reset()
        local v11 = a0:GetPropertyChangedSignal("JumpPower")
        local v12 = v11:Connect(update)
        a0._connectionUtil:trackConnection("HUMANOID_JUMP_POWER", v12)
        local v13 = a0:GetPropertyChangedSignal("JumpHeight")
        local v14 = v13:Connect(update)
        a0._connectionUtil:trackConnection("HUMANOID_JUMP_HEIGHT", v14)
        local v15 = a0.StateEnabledChanged:Connect(function(a0, a1) --[[ Upvalues: a0 (upvalue) ]]
            if a0 == Enum.HumanoidStateType.Jumping and a1 ~= a0._active then
                a0:UpdateEnabled()
            end

        end)
        a0._connectionUtil:trackConnection("HUMANOID_STATE_ENABLED_CHANGED", v15)
    end)
    a0._connectionUtil:trackConnection("HUMANOID", v16)
end

v6._setupConfigurations = _setupConfigurations

local function Enable(a0, a1, a2)
    if a2 then
        a0.parentUIFrame = a2
    end

    if a0.externallyEnabled == a1 then
        return
    end

    a0.externallyEnabled = a1
    a0:UpdateEnabled()
    if a1 then
        a0:_setupConfigurations()
        return
    end

    a0._connectionUtil:disconnectAll()
end

v6.Enable = Enable

local function Create(a0) --[[ Upvalues: CommonUtils (copy), v3 (ref), v4 (copy) ]]
    if not a0.parentUIFrame then
        return
    end

    if a0.jumpButton then
        a0.jumpButton:Destroy()
        a0.jumpButton = nil
    end

    if a0.absoluteSizeChangedConn then
        a0.absoluteSizeChangedConn:Disconnect()
        a0.absoluteSizeChangedConn = nil
    end

    if CommonUtils and a0.avatarAbilitiesEnabledChangedConn then
        a0.avatarAbilitiesEnabledChangedConn:Disconnect()
        a0.avatarAbilitiesEnabledChangedConn = nil
    end

    a0.jumpButton = Instance.new("ImageButton")
    a0.jumpButton.Name = "JumpButton"
    a0.jumpButton.Visible = false
    a0.jumpButton.BackgroundTransparency = 1
    if CommonUtils and v3.isEnabled() then
        a0.jumpButton.Image = v4[1]
    else
        a0.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
        a0.jumpButton.ImageRectOffset = Vector2.new(1, 146)
        a0.jumpButton.ImageRectSize = Vector2.new(144, 144)
    end

    local function ResizeJumpButton() --[[ Upvalues: a0 (copy), CommonUtils (upvalue), v3 (upvalue), v4 (upvalue) ]]
        local v17 = math.min(a0.parentUIFrame.AbsoluteSize.x, a0.parentUIFrame.AbsoluteSize.y)
        local v18 = v17 <= 500
        if CommonUtils then
            if v3.isEnabled() then
                if v18 then
                    v17 = 72
                else
                    v17 = 120
                end

                local v19
                if v18 then
                    v19 = 64
                else
                    v19 = 100
                end

                local v20
                if v18 then
                    v20 = 64
                else
                    v20 = 112
                end

                local v21 = -v17 - v19
                v19 = -v17 - v20
                a0.jumpButton.Image = v4[1]
                a0.jumpButton.ImageRectOffset = Vector2.new(0, 0)
                a0.jumpButton.ImageRectSize = Vector2.new(0, 0)
                a0.jumpButton.Size = UDim2.new(0, v17, 0, v17)
                a0.jumpButton.Position = UDim2.new(1, v21, 1, v19)
                return
            end
        end

        local v22
        if v18 then
            v22 = 70
        else
            v22 = 120
        end

        if CommonUtils then
            a0.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
            a0.jumpButton.ImageRectOffset = Vector2.new(1, 146)
            a0.jumpButton.ImageRectSize = Vector2.new(144, 144)
        end

        a0.jumpButton.Size = UDim2.new(0, v22, 0, v22)
        local jumpButton = a0.jumpButton
        local v23 = -(v22 * 1.5 - 10)
        local v24 = UDim2.new(1, v23, 1, -v22 - 20)
        if not (v18 and v24) then
            v23 = -(v22 * 1.5 - 10)
            local v25 = UDim2.new(1, v23, 1, -v22 * 1.75)
        end

        jumpButton.Position = v24
    end

    ResizeJumpButton()
    local v26 = a0.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize")
    a0.absoluteSizeChangedConn = v26:Connect(ResizeJumpButton)
    if CommonUtils then
        a0.avatarAbilitiesEnabledChangedConn = v3.GetEnabledChangedSignal():Connect(ResizeJumpButton)
    end

    a0.touchObject = nil
    a0.jumpButton.InputBegan:connect(function(a0) --[[ Upvalues: a0 (copy), CommonUtils (upvalue), v3 (upvalue), v4 (upvalue) ]]
        if a0.touchObject or a0.UserInputType ~= Enum.UserInputType.Touch or a0.UserInputState ~= Enum.UserInputState.Begin then
            return
        end

        a0.touchObject = a0
        if CommonUtils and v3.isEnabled() then
            a0.jumpButton.Image = v4[2]
        else
            a0.jumpButton.ImageRectOffset = Vector2.new(146, 146)
        end

        a0.isJumping = true
    end)
    a0.jumpButton.Parent = a0.parentUIFrame
end

v6.Create = Create
return v6
