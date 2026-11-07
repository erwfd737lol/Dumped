
local Value = Enum.ContextActionPriority.High.Value
local t1 = {0.10999999999999999, 0.30000000000000004, 0.4, 0.5, 0.6, 0.7, 0.75}
local v1 = #t1
local v2 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
local v3 = require(FlagUtil)
CommonUtils = v3.getUserFlag("UserAllowAbilityControls")
local v4 = v3.getUserFlag("UserAllowAbilityControlsBonus")
local v6, v7 = pcall(function()
    local v5 = UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
    return v5
end)
local v8 = v6 and v7
v6 = nil
if CommonUtils then
    local AvatarAbilitiesInterface = script.Parent:WaitForChild("AvatarAbilitiesInterface")
    v6 = require(AvatarAbilitiesInterface)
end

Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local LocalPlayer = Players.LocalPlayer
local v9 = Players.LocalPlayer or LocalPlayer
local BaseCharacterController = script.Parent:WaitForChild("BaseCharacterController")
v3 = require(BaseCharacterController)
Players = setmetatable({}, v3)
Players.__index = Players

local function new() --[[ Upvalues: v3 (copy), Players (copy) ]]
    local v10 = setmetatable(v3.new(), Players)
    v10.moveTouchObject = nil
    v10.moveTouchLockedIn = false
    v10.moveTouchFirstChanged = false
    v10.moveTouchStartPosition = nil
    v10.startImage = nil
    v10.endImage = nil
    v10.middleImages = {}
    v10.startImageFadeTween = nil
    v10.endImageFadeTween = nil
    v10.middleImageFadeTweens = {}
    v10.isFirstTouch = true
    v10.thumbstickFrame = nil
    v10.onRenderSteppedConn = nil
    v10.fadeInAndOutBalance = 0.5
    v10.fadeInAndOutHalfDuration = 0.3
    v10.hasFadedBackgroundInPortrait = false
    v10.hasFadedBackgroundInLandscape = false
    v10.tweenInAlphaStart = nil
    v10.tweenOutAlphaStart = nil
    return v10
end

Players.new = new

local function GetIsJumping(a0)
    a0.isJumping = false
    return a0.isJumping
end

Players.GetIsJumping = GetIsJumping

local function Enable(a0, a1, a2)
    if a1 == nil then
        return false
    end

    local v11
    if a1 then
        v11 = true
    else
        v11 = false
    end

    a1 = v11
    if a0.enabled == a1 then
        return true
    end

    if a1 then
        if not a0.thumbstickFrame then
            a0:Create(a2)
        end

        a0:BindContextActions()
    else
        a0:UnbindContextActions()
        a0:OnInputEnded()
    end

    a0.enabled = a1
    a0.thumbstickFrame.Visible = a1
    return nil
end

Players.Enable = Enable

local function OnInputEnded(a0)
    a0.moveTouchObject = nil
    a0.moveVector = Vector3.new(0, 0, 0)
    a0:FadeThumbstick(false)
end

Players.OnInputEnded = OnInputEnded

local function FadeThumbstick(a0, a1) --[[ Upvalues: TweenService (copy), v2 (copy), t1 (copy) ]]
    if not a1 and a0.moveTouchObject then
        return
    end

    if a0.isFirstTouch then
        return
    end

    if a0.startImageFadeTween then
        a0.startImageFadeTween:Cancel()
    end

    if a0.endImageFadeTween then
        a0.endImageFadeTween:Cancel()
    end

    for i1 = 1, #a0.middleImages do
        if a0.middleImageFadeTweens[i1] then
            a0.middleImageFadeTweens[i1]:Cancel()
        end
    end

    if a1 then
        a0.startImageFadeTween = TweenService:Create(a0.startImage, v2, {ImageTransparency = 0})
        a0.startImageFadeTween:Play()
        a0.endImageFadeTween = TweenService:Create(a0.endImage, v2, {ImageTransparency = 0.2})
        a0.endImageFadeTween:Play()
        local v14 = #a0.middleImages
        local v15 = 1
        -- [85] unhandled FORNPREP
        local v16 = a0.middleImages[1]
        local t2 = {ImageTransparency = t1[1]}
        a0.middleImageFadeTweens[1] = TweenService:Create(v16, v2, t2)
        a0.middleImageFadeTweens[1]:Play()
        -- [110] unhandled FORNLOOP
        return
    end

    a0.startImageFadeTween = TweenService:Create(a0.startImage, v2, {ImageTransparency = 1})
    a0.startImageFadeTween:Play()
    a0.endImageFadeTween = TweenService:Create(a0.endImage, v2, {ImageTransparency = 1})
    a0.endImageFadeTween:Play()
    for i2 = 1, #a0.middleImages do
        local v19 = a0.middleImages[i2]
        a0.middleImageFadeTweens[i2] = TweenService:Create(v19, v2, {ImageTransparency = 1})
        a0.middleImageFadeTweens[i2]:Play()
    end
end

Players.FadeThumbstick = FadeThumbstick

local function FadeThumbstickFrame(a0, a1, a2)
    a0.fadeInAndOutHalfDuration = a1 * 0.5
    a0.fadeInAndOutBalance = a2
    a0.tweenInAlphaStart = tick()
end

Players.FadeThumbstickFrame = FadeThumbstickFrame

local function InputInFrame(a0, a1)
    local AbsolutePosition = a0.thumbstickFrame.AbsolutePosition
    local v20 = AbsolutePosition + a0.thumbstickFrame.AbsoluteSize
    local Position = a1.Position
    if AbsolutePosition.X <= Position.X and AbsolutePosition.Y <= Position.Y and Position.X <= v20.X and Position.Y <= v20.Y then
        return true
    end

    return false
end

Players.InputInFrame = InputInFrame

local function DoFadeInBackground(a0) --[[ Upvalues: v9 (ref) ]]
    local v21 = v9:FindFirstChildOfClass("PlayerGui")
    local v22 = false
    if v21 then
        if v21.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or v21.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight then
            v22 = a0.hasFadedBackgroundInLandscape
            a0.hasFadedBackgroundInLandscape = true
            -- jump to 37 (out of range)
        end

        if v21.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then
            v22 = a0.hasFadedBackgroundInPortrait
            a0.hasFadedBackgroundInPortrait = true
        end
    end

    if not v22 then
        a0.fadeInAndOutHalfDuration = 0.3
        a0.fadeInAndOutBalance = 0.5
        a0.tweenInAlphaStart = tick()
    end
end

Players.DoFadeInBackground = DoFadeInBackground

local function DoMove(a0, a1)
    local v23 = a1
    if v23.Magnitude < a0.radiusOfDeadZone then
        v23 = Vector3.new(0, 0, 0)
    else
        local v24 = a0.radiusOfMaxSpeed - v23.Magnitude
        v23 = v23.Unit * (1 - math.max(0, v24 / a0.radiusOfMaxSpeed))
        v23 = Vector3.new(v23.X, 0, v23.Y)
    end

    a0.moveVector = v23
end

Players.DoMove = DoMove

local function LayoutMiddleImages(a0, a1, a2) --[[ Upvalues: v1 (copy) ]]
    local v25 = a0.thumbstickSize / 2
    local v26 = v25 + a0.middleSize
    v25 = a2 - a1
    local v27 = v25.Magnitude - a0.thumbstickRingSize / 2
    local v28 = v27 - a0.middleSize
    v27 = v25.Unit
    v25 = a0.middleSpacing * v1
    local middleSpacing = a0.middleSpacing
    if v25 < v28 then
        middleSpacing = v28 / v1
    end

    for i3 = 1, v1 do
        v25 = a0.middleImages[i3]
        local v31 = v26 + middleSpacing * (i3 - 2)
        local v32 = v26 + middleSpacing * (i3 - 1)
        if v31 < v28 then
            local v33 = a2 - v27 * v32
            local v34 = 1 - (v32 - v28) / middleSpacing
            local v35 = math.clamp(v34, 0, 1)
            v25.Visible = true
            v25.Position = UDim2.new(0, v33.X, 0, v33.Y)
            local v36 = a0.middleSize * v35
            v25.Size = UDim2.new(0, v36, 0, a0.middleSize * v35)
        else
            v25.Visible = false
        end
    end
end

Players.LayoutMiddleImages = LayoutMiddleImages

local function MoveStick(a0, a1)
    local v37 = Vector2.new(a0.moveTouchStartPosition.X, a0.moveTouchStartPosition.Y)
    local v38 = v37 - a0.thumbstickFrame.AbsolutePosition
    local v39 = Vector2.new(a1.X, a1.Y)
    v37 = v39 - a0.thumbstickFrame.AbsolutePosition
    a0.endImage.Position = UDim2.new(0, v37.X, 0, v37.Y)
    a0:LayoutMiddleImages(v38, v37)
end

Players.MoveStick = MoveStick

local function BindContextActions(a0) --[[ Upvalues: TweenService (copy), ContextActionService (copy), Value (copy), UserInputService (copy) ]]

    local function inputBegan(a0) --[[ Upvalues: a0 (copy), TweenService (upvalue) ]]
        if a0.moveTouchObject then
            return Enum.ContextActionResult.Pass
        end

        if not a0:InputInFrame(a0) then
            return Enum.ContextActionResult.Pass
        end

        if a0.isFirstTouch then
            a0.isFirstTouch = false
            local v40 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
            local v41 = {Size = UDim2.new(0, 0, 0, 0)}
            TweenService:Create(a0.startImage, v40, v41):Play()
            v41 = {
                Size = UDim2.new(0, a0.thumbstickSize, 0, a0.thumbstickSize),
                ImageColor3 = Color3.new(0, 0, 0)
            }
            TweenService:Create(a0.endImage, v40, v41):Play()
        end

        a0.moveTouchLockedIn = false
        a0.moveTouchObject = a0
        a0.moveTouchStartPosition = a0.Position
        a0.moveTouchFirstChanged = true
        a0:DoFadeInBackground()
        return Enum.ContextActionResult.Pass
    end

    local function inputChanged(a0) --[[ Upvalues: a0 (copy) ]]
        if a0 == a0.moveTouchObject then
            if a0.moveTouchFirstChanged then
                a0.moveTouchFirstChanged = false
                local v42 = a0.Position.X - a0.thumbstickFrame.AbsolutePosition.X
                local v43 = Vector2.new(v42, a0.Position.Y - a0.thumbstickFrame.AbsolutePosition.Y)
                a0.startImage.Visible = true
                a0.startImage.Position = UDim2.new(0, v43.X, 0, v43.Y)
                a0.endImage.Visible = true
                a0.endImage.Position = a0.startImage.Position
                a0:FadeThumbstick(true)
                a0:MoveStick(a0.Position)
            end

            a0.moveTouchLockedIn = true
            local v44 = a0.Position.X - a0.moveTouchStartPosition.X
            local v45 = Vector2.new(v44, a0.Position.Y - a0.moveTouchStartPosition.Y)
            local v46 = math.abs(v45.X)
            if 0 >= v46 then
                local v47 = math.abs(v45.Y)
                if 0 >= v47 then
                    -- jump to 150
                end
            end

            a0:DoMove(v45)
            a0:MoveStick(a0.Position)
            return Enum.ContextActionResult.Sink
        end

        return Enum.ContextActionResult.Pass
    end

    local function inputEnded(a0) --[[ Upvalues: a0 (copy) ]]
        if a0 == a0.moveTouchObject then
            a0:OnInputEnded()
            if a0.moveTouchLockedIn then
                return Enum.ContextActionResult.Sink
            end
        end

        return Enum.ContextActionResult.Pass
    end

    local function handleInput(a0, a1, a2) --[[ Upvalues: inputBegan (copy), a0 (copy) ]]
        if a1 == Enum.UserInputState.Begin then
            return inputBegan(a2)
        end

        if a1 == Enum.UserInputState.Change then
            if a2 == a0.moveTouchObject then
                return Enum.ContextActionResult.Sink
            end

            return Enum.ContextActionResult.Pass
        end

        if a1 == Enum.UserInputState.End then
            if a2 == a0.moveTouchObject then
                a0:OnInputEnded()
                if a0.moveTouchLockedIn then
                    return Enum.ContextActionResult.Sink
                end
            end

            return Enum.ContextActionResult.Pass
        end

        if a1 == Enum.UserInputState.Cancel then
            a0:OnInputEnded()
        end
    end

    ContextActionService:BindActionAtPriority("DynamicThumbstickAction", handleInput, false, Value, Enum.UserInputType.Touch)
    a0.TouchMovedCon = UserInputService.TouchMoved:Connect(function(a0, a1) --[[ Upvalues: inputChanged (copy) ]]
        inputChanged(a0)
    end)
end

Players.BindContextActions = BindContextActions

local function UnbindContextActions(a0) --[[ Upvalues: ContextActionService (copy) ]]
    ContextActionService:UnbindAction("DynamicThumbstickAction")
    if a0.TouchMovedCon then
        a0.TouchMovedCon:Disconnect()
    end
end

Players.UnbindContextActions = UnbindContextActions

local function Create(a0, a1) --[[ Upvalues: CommonUtils (copy), v8 (ref), v1 (copy), t1 (copy), v4 (copy), v6 (ref), RunService (copy), UserInputService (copy), GuiService (copy), v9 (ref) ]]
    if a0.thumbstickFrame then
        a0.thumbstickFrame:Destroy()
        a0.thumbstickFrame = nil
        if a0.onRenderSteppedConn then
            a0.onRenderSteppedConn:Disconnect()
            a0.onRenderSteppedConn = nil
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

    local v48
    if v8 then
        v48 = 100
    else
        v48 = 0
    end

    local function layoutThumbstickFrame(a0) --[[ Upvalues: a0 (copy), v48 (copy) ]]
        if a0 then
            a0.thumbstickFrame.Size = UDim2.new(1, v48, 0.4, v48)
            local v49 = -v48
            a0.thumbstickFrame.Position = UDim2.new(0, v49, 0.6, 0)
            return
        end

        a0.thumbstickFrame.Size = UDim2.new(0.4, v48, 0.66666666666666663, v48)
        local v50 = -v48
        a0.thumbstickFrame.Position = UDim2.new(0, v50, 0.33333333333333331, 0)
    end

    a0.thumbstickFrame = Instance.new("Frame")
    a0.thumbstickFrame.BorderSizePixel = 0
    a0.thumbstickFrame.Name = "DynamicThumbstickFrame"
    a0.thumbstickFrame.Visible = false
    a0.thumbstickFrame.BackgroundTransparency = 1
    a0.thumbstickFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    a0.thumbstickFrame.Active = false
    a0.thumbstickFrame.Size = UDim2.new(0.4, v48, 0.66666666666666663, v48)
    a0.thumbstickFrame.Position = UDim2.new(0, -v48, 0.33333333333333331, 0)
    a0.startImage = Instance.new("ImageLabel")
    a0.startImage.Name = "ThumbstickStart"
    a0.startImage.Visible = true
    a0.startImage.BackgroundTransparency = 1
    a0.startImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
    a0.startImage.ImageRectOffset = Vector2.new(1, 1)
    a0.startImage.ImageRectSize = Vector2.new(144, 144)
    a0.startImage.ImageColor3 = Color3.new(0, 0, 0)
    a0.startImage.AnchorPoint = Vector2.new(0.5, 0.5)
    a0.startImage.ZIndex = 10
    a0.startImage.Parent = a0.thumbstickFrame
    a0.endImage = Instance.new("ImageLabel")
    a0.endImage.Name = "ThumbstickEnd"
    a0.endImage.Visible = true
    a0.endImage.BackgroundTransparency = 1
    a0.endImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
    a0.endImage.ImageRectOffset = Vector2.new(1, 1)
    a0.endImage.ImageRectSize = Vector2.new(144, 144)
    a0.endImage.AnchorPoint = Vector2.new(0.5, 0.5)
    a0.endImage.ZIndex = 10
    a0.endImage.Parent = a0.thumbstickFrame
    for i4 = 1, v1 do
        a0.middleImages[i4] = Instance.new("ImageLabel")
        local v53 = a0.middleImages[i4]
        v53.Name = "ThumbstickMiddle"
        v53 = a0.middleImages[i4]
        v53.Visible = false
        v53 = a0.middleImages[i4]
        v53.BackgroundTransparency = 1
        v53 = a0.middleImages[i4]
        v53.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
        v53 = a0.middleImages[i4]
        v53.ImageRectOffset = Vector2.new(1, 1)
        v53 = a0.middleImages[i4]
        v53.ImageRectSize = Vector2.new(144, 144)
        v53 = a0.middleImages[i4]
        v53.ImageTransparency = t1[i4]
        v53 = a0.middleImages[i4]
        v53.AnchorPoint = Vector2.new(0.5, 0.5)
        v53 = a0.middleImages[i4]
        v53.ZIndex = 9
        v53 = a0.middleImages[i4]
        v53.Parent = a0.thumbstickFrame
    end

    local function ResizeThumbstick() --[[ Upvalues: a1 (copy), CommonUtils (upvalue), v4 (upvalue), v6 (upvalue), a0 (copy), v48 (copy) ]]
        local AbsoluteSize = a1.AbsoluteSize
        local v54 = math.min(AbsoluteSize.X, AbsoluteSize.Y)
        local v55 = 500 < v54
        if CommonUtils then
            if v55 then
                AbsoluteSize = 2
            else
                AbsoluteSize = 1
            end

            if v4 and v6.isEnabled() and v55 then
                AbsoluteSize = 1.6216216216216217
            end

            a0.thumbstickSize = 45 * AbsoluteSize
            a0.thumbstickRingSize = 20 * AbsoluteSize
            a0.middleSize = 10 * AbsoluteSize
            a0.middleSpacing = 14 * AbsoluteSize
            a0.radiusOfDeadZone = 2 * AbsoluteSize
            a0.radiusOfMaxSpeed = 20 * AbsoluteSize
            local v56 = 74 * AbsoluteSize
            if v6.isEnabled() then
                if v55 then
                    AbsoluteSize = 100
                else
                    AbsoluteSize = 64
                end

                local v57
                if v55 then
                    v57 = 112
                else
                    v57 = 64
                end

                local v58 = v56 * 0.5 + v48 + AbsoluteSize
                local v59 = -v56 * 0.5
                a0.startImage.Position = UDim2.new(0, v58, 1, v59 - v48 - v57)
                a0.startImage.Size = UDim2.new(0, v56, 0, v56)
                -- jump to 244 (out of range)
            end

            local v60 = a0.thumbstickRingSize * 3.3
            local v61 = v60 + v48
            local v62 = -a0.thumbstickRingSize * 2.8
            a0.startImage.Position = UDim2.new(0, v61, 1, v62 - v48)
            a0.startImage.Size = UDim2.new(0, v56, 0, v56)
        else
            if v55 then
                a0.thumbstickSize = 90
                a0.thumbstickRingSize = 40
                a0.middleSize = 20
                a0.middleSpacing = 28
                a0.radiusOfDeadZone = 4
                a0.radiusOfMaxSpeed = 40
            else
                a0.thumbstickSize = 45
                a0.thumbstickRingSize = 20
                a0.middleSize = 10
                a0.middleSpacing = 14
                a0.radiusOfDeadZone = 2
                a0.radiusOfMaxSpeed = 20
            end

            local v63 = a0.thumbstickRingSize * 3.3
            local v64 = v63 + v48
            local v65 = -a0.thumbstickRingSize * 2.8
            a0.startImage.Position = UDim2.new(0, v64, 1, v65 - v48)
            v64 = a0.thumbstickRingSize * 3.7
            a0.startImage.Size = UDim2.new(0, v64, 0, a0.thumbstickRingSize * 3.7)
        end

        a0.endImage.Position = a0.startImage.Position
        local v66 = a0.thumbstickSize * 0.8
        a0.endImage.Size = UDim2.new(0, v66, 0, a0.thumbstickSize * 0.8)
    end

    ResizeThumbstick()
    local v67 = a1:GetPropertyChangedSignal("AbsoluteSize")
    a0.absoluteSizeChangedConn = v67:Connect(ResizeThumbstick)
    if CommonUtils then
        a0.avatarAbilitiesEnabledChangedConn = v6.GetEnabledChangedSignal():Connect(ResizeThumbstick)
    end

    local v68 = nil

    local function onCurrentCameraChanged() --[[ Upvalues: v68 (ref), layoutThumbstickFrame (copy) ]]
        if v68 then
            v68:Disconnect()
            v68 = nil
        end

        local CurrentCamera = workspace.CurrentCamera
        if CurrentCamera then

            local function onViewportSizeChanged() --[[ Upvalues: CurrentCamera (copy), layoutThumbstickFrame (upvalue) ]]
                local ViewportSize = CurrentCamera.ViewportSize
                layoutThumbstickFrame(ViewportSize.X < ViewportSize.Y)
            end

            local v69 = CurrentCamera:GetPropertyChangedSignal("ViewportSize")
            v68 = v69:Connect(onViewportSizeChanged)
            local ViewportSize1 = CurrentCamera.ViewportSize
            layoutThumbstickFrame(ViewportSize1.X < ViewportSize1.Y)
        end
    end

    local v70 = workspace:GetPropertyChangedSignal("CurrentCamera")
    v70:Connect(onCurrentCameraChanged)
    if workspace.CurrentCamera then
        onCurrentCameraChanged()
    end

    a0.moveTouchStartPosition = nil
    a0.startImageFadeTween = nil
    a0.endImageFadeTween = nil
    a0.middleImageFadeTweens = {}
    a0.onRenderSteppedConn = RunService.RenderStepped:Connect(function() --[[ Upvalues: a0 (copy) ]]
        if a0.tweenInAlphaStart ~= nil then
            local v71 = tick() - a0.tweenInAlphaStart
            local v72 = a0.fadeInAndOutHalfDuration * 2
            local v73 = v72 * a0.fadeInAndOutBalance
            a0.thumbstickFrame.BackgroundTransparency = 1 - math.min(v71 / v73, 1) * 0.35
            if v73 < v71 then
                a0.tweenOutAlphaStart = tick()
                a0.tweenInAlphaStart = nil
                return
                -- branch continues at 95
            end
        end

        if a0.tweenOutAlphaStart ~= nil then
            local v74 = tick() - a0.tweenOutAlphaStart
            local v75 = a0.fadeInAndOutHalfDuration * 2
            local v76 = a0.fadeInAndOutHalfDuration * 2
            local v77 = v75 - v76 * a0.fadeInAndOutBalance
            a0.thumbstickFrame.BackgroundTransparency = math.min(v74 / v77, 1) * 0.35 + 0.65
            if v77 < v74 then
                a0.tweenOutAlphaStart = nil
            end
        end

    end)
    a0.onTouchEndedConn = UserInputService.TouchEnded:connect(function(a0) --[[ Upvalues: a0 (copy) ]]
        if a0 == a0.moveTouchObject then
            a0:OnInputEnded()
        end

    end)
    GuiService.MenuOpened:connect(function() --[[ Upvalues: a0 (copy) ]]
        if a0.moveTouchObject then
            a0:OnInputEnded()
        end

    end)
    local v78 = v9:FindFirstChildOfClass("PlayerGui")
    while not v78 do
        v9.ChildAdded:wait()
        v78 = v9:FindFirstChildOfClass("PlayerGui")
    end

    onCurrentCameraChanged = true
    if v78.CurrentScreenOrientation ~= Enum.ScreenOrientation.LandscapeLeft then
        onCurrentCameraChanged = v78.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight
    end

    local function longShowBackground() --[[ Upvalues: a0 (copy) ]]
        a0.fadeInAndOutHalfDuration = 2.5
        a0.fadeInAndOutBalance = 0.05
        a0.tweenInAlphaStart = tick()
    end

    local v79 = v78:GetPropertyChangedSignal("CurrentScreenOrientation")
    local v80 = nil
    v80 = v79:Connect(function() --[[ Upvalues: onCurrentCameraChanged (copy), v78 (ref), v80 (ref), a0 (copy) ]]
        if not onCurrentCameraChanged or v78.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait then
            if not onCurrentCameraChanged then
                if v78.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then
                    return
                end

                -- branch continues at 49
            end
        end

        v80:disconnect()
        a0.fadeInAndOutHalfDuration = 2.5
        a0.fadeInAndOutBalance = 0.05
        a0.tweenInAlphaStart = tick()
        if onCurrentCameraChanged then
            a0.hasFadedBackgroundInPortrait = true
            return
        end

        a0.hasFadedBackgroundInLandscape = true
    end)
    a0.thumbstickFrame.Parent = a1
    if game:IsLoaded() then
        a0.fadeInAndOutHalfDuration = 2.5
        a0.fadeInAndOutBalance = 0.05
        a0.tweenInAlphaStart = tick()
    else
        coroutine.wrap(function() --[[ Upvalues: a0 (copy) ]]
            game.Loaded:Wait()
            a0.fadeInAndOutHalfDuration = 2.5
            a0.fadeInAndOutBalance = 0.05
            a0.tweenInAlphaStart = tick()
        end)()
    end
end

Players.Create = Create
return Players
