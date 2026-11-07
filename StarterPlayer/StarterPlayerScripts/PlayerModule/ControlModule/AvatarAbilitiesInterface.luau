
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = CommonUtils:WaitForChild("FlagUtil")
if require(FlagUtil).getUserFlag("UserAllowAbilityControls") then
    local Players = game:GetService("Players")
    local v1 = nil
    local v2 = nil
    local BindableEvent = Instance.new("BindableEvent")
    local v3 = false
    local v4 = nil

    local function characterAdded(a0) --[[ Upvalues: v1 (ref), v2 (ref), v4 (ref), BindableEvent (copy) ]]
        v1 = nil
        v2 = nil
        if v4 then
            v4:Disconnect()
            v4 = nil
        end

        if a0 then
            v1 = a0:FindFirstChild("AbilityManagerActor")
            v2 = a0:FindFirstChildOfClass("Humanoid")
            while not v2 do
                a0.ChildAdded:wait()
                v2 = a0:FindFirstChildOfClass("Humanoid")
            end

            BindableEvent:Fire()
            local v5 = v2:GetPropertyChangedSignal("EvaluateStateMachine")
            v4 = v5:Connect(function() --[[ Upvalues: BindableEvent (upvalue) ]]
                BindableEvent:Fire()
            end)
        end
    end

    local function lazyInit() --[[ Upvalues: v3 (ref), Players (copy), characterAdded (copy) ]]
        if v3 then
            return
        end

        v3 = true
        local LocalPlayer = Players.LocalPlayer
        if LocalPlayer then
            LocalPlayer.characterAdded:Connect(characterAdded)
            if LocalPlayer.Character then
                characterAdded(LocalPlayer.Character)
            end
        end
    end

    local function isEnabled() --[[ Upvalues: v3 (ref), Players (copy), characterAdded (copy), v1 (ref), v2 (ref) ]]
        if v3 then
        else
            v3 = true
            local LocalPlayer1 = Players.LocalPlayer
            if LocalPlayer1 then
                LocalPlayer1.characterAdded:Connect(characterAdded)
                if LocalPlayer1.Character then
                    characterAdded(LocalPlayer1.Character)
                end
            end
        end

        local v6 = false
        if v1 ~= nil then
            local v8 = v2 and not v2.EvaluateStateMachine
        end

        return v6
    end

    local function GetEnabledChangedSignal() --[[ Upvalues: v3 (ref), Players (copy), characterAdded (copy), BindableEvent (copy) ]]
        if v3 then
        else
            v3 = true
            local LocalPlayer2 = Players.LocalPlayer
            if LocalPlayer2 then
                LocalPlayer2.characterAdded:Connect(characterAdded)
                if LocalPlayer2.Character then
                    characterAdded(LocalPlayer2.Character)
                end
            end
        end

        return BindableEvent.Event
    end

    local v9 = {isEnabled = isEnabled, GetEnabledChangedSignal = GetEnabledChangedSignal}
    return v9
end
