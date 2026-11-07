-- decompiled by Velocity decompiler v1.0.3

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local MarketplaceService = game:GetService("MarketplaceService")
local VoiceChatService = game:GetService("VoiceChatService")
local GuiService = game:GetService("GuiService")
local Animations = ReplicatedStorage:WaitForChild("Animations")
local PolicyService = game:GetService("PolicyService")
local RemoteEvent = ReplicatedStorage.Remotes:WaitForChild("RemoteEvent")
local RemoteFunction = ReplicatedStorage.Remotes:WaitForChild("RemoteFunction")
local UnreliableRemoteEvent = ReplicatedStorage.Remotes:WaitForChild("UnreliableRemoteEvent")
local v1, v2 = ReplicatedStorage:WaitForChild("ClientSetup"):InvokeServer()
local v3 = require(ReplicatedStorage.Modules.Icon)
v3.highlightKey = false
local LocalPlayer = Players.LocalPlayer
Players = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local MainContext = script.Parent:WaitForChild("MainContext")
local HUD = PlayerGui:WaitForChild("HUD")
local ModalGui = PlayerGui:WaitForChild("ModalGui")
HUD.Modal.Visible = false
ModalGui.Enabled = false
local v4 = require(v2)
v2:Destroy()
_G.Utl = v4
v2 = require(v1)
v1:Destroy()
v1 = v2.new(LocalPlayer)
v1:SetUp()
RemoteEvent.OnClientEvent:Connect(function(a0, a1) --[[ Upvalues: v1 (copy) ]]
    if v1[a0] then
        local v5 = v1[a0]
        v5(v1, a1)
    end

end)
UnreliableRemoteEvent.OnClientEvent:Connect(function(a0, a1) --[[ Upvalues: v1 (copy) ]]
    if v1[a0] then
        local v6 = v1[a0]
        v6(v1, a1)
    end

end)
RemoteFunction.OnClientInvoke = function(a0, a1) --[[ Upvalues: v1 (copy) ]]
    if v1[a0] then
        local v7 = v1[a0]
        local v8 = v7(v1, a1)
        return v8
    end
end

task.spawn(function() --[[ Upvalues: v1 (copy), LocalPlayer (copy), RemoteFunction (copy) ]]
    local v9 = os.clock() + 90
    while true do
        if v1.Activated or LocalPlayer:GetAttribute("DataLoadFailed") then
            return
        end

        local v11, v12 = pcall(function() --[[ Upvalues: RemoteFunction (upvalue) ]]
            local v10 = RemoteFunction:InvokeServer("GetInitialData")
            return v10
        end)
        if v11 then
            if typeof(v12) == "table" then
                v1:Activate(v12)
                return
            end
        end

        task.wait(1)
        if v9 <= os.clock() then
            break
        end
    end

    if not v1.Activated then
        warn("[Client] Initial player data handshake timed out")
    end

end)
v2 = v3.new()
v2:setLabel("Menu")
v2.selected:Connect(function() --[[ Upvalues: HUD (copy) ]]
    HUD.Menu.Visible = true
end)
v2.deselected:Connect(function() --[[ Upvalues: HUD (copy) ]]
    HUD.Menu.Visible = false
end)
HUD.Menu.Close.MouseButton1Click:Connect(function() --[[ Upvalues: HUD (copy), v2 (copy) ]]
    HUD.Menu.Visible = false
    v2:deselect()
end)
HUD.Menu.Main.Version.MouseButton1Click:Connect(function() --[[ Upvalues: HUD (copy), v2 (copy) ]]
    HUD.Version.Visible = true
    v2:deselect()
end)
HUD.Version.Back.MouseButton1Click:Connect(function() --[[ Upvalues: HUD (copy), v2 (copy) ]]
    HUD.Version.Visible = false
    v2:select()
    HUD.Menu.Visible = true
end)
HUD.Menu.Main.Keybinds.Activated:Connect(function() --[[ Upvalues: HUD (copy), v1 (copy), v2 (copy) ]]
    HUD.Keybinds.Visible = true
    v1:InitKeybinds()
    HUD.Version.Visible = false
    v2:deselect()
end)
HUD.Keybinds.Reset.Activated:Connect(function() --[[ Upvalues: RemoteEvent (copy) ]]
    RemoteEvent:FireServer("ResetKeybinds")
end)
HUD.Keybinds.Back.Activated:Connect(function() --[[ Upvalues: v1 (copy), v2 (copy), HUD (copy) ]]
    v1:CloseKeybinds()
    v2:select()
    HUD.Menu.Visible = true
end)
HUD.Menu.Main.Shop.MouseButton1Click:Connect(function() --[[ Upvalues: v1 (copy), HUD (copy), v2 (copy) ]]
    v1:OpenShop()
    HUD.Menu.Visible = false
    v2:deselect()
end)
local Shop = HUD:WaitForChild("Shop")
Shop:WaitForChild("Back").MouseButton1Click:Connect(function() --[[ Upvalues: v1 (copy), v2 (copy), HUD (copy) ]]
    v1:CloseShop()
    v2:select()
    HUD.Menu.Visible = true
end)
HUD.Menu.Main.Achievements.MouseButton1Click:Connect(function() --[[ Upvalues: v1 (copy), HUD (copy), v2 (copy) ]]
    v1:OpenAchievements()
    HUD.Menu.Visible = false
    v2:deselect()
end)
HUD.Achievements.Back.MouseButton1Click:Connect(function() --[[ Upvalues: v1 (copy), v2 (copy), HUD (copy) ]]
    v1:CloseAchievements()
    v2:select()
    HUD.Menu.Visible = true
end)
v3 = HUD:WaitForChild("Stats")
UnreliableRemoteEvent = HUD.Menu.Main:WaitForChild("Stats")
local Back = v3:WaitForChild("Back")
local v13 = {
    Playtime = v3.List.Playtime.Value,
    PlayerKills = v3.List.PlayerKills.Value,
    StoragesOpened = v3.List.StoragesOpened.Value,
    TotalMoneyEarned = v3.List.TotalMoneyEarned.Value,
    MobKills = v3.List.MobKills.Value
}
local v14 = nil

local function wholeNumber(a0)
    a0 = tonumber(a0) or 0
    if a0 ~= a0 then
        return 0
    end

    if math.abs(a0) == math.huge then
        return 0
    end

    return math.max(0, math.floor(a0))
end

local function formatStatNumber(a0) --[[ Upvalues: v4 (copy) ]]
    local addComas = v4.addComas
    local v15 = tonumber(a0) or 0
    if v15 == v15 then
        if math.abs(v15) ~= math.huge then
            -- jump to 21
        end
    end

    local v16 = 0
    local v17 = addComas(tostring(v16))
    return v17
end

local function formatPlaytime(a0)
    local v18 = tonumber(a0) or 0
    if v18 == v18 then
        if math.abs(v18) ~= math.huge then
            -- jump to 18
        end
    end

    a0 = 0
    local v19 = math.floor(a0 / 86400)
    local v20 = math.floor(a0 % 86400 / 3600)
    local v21 = math.floor(a0 % 3600 / 60)
    local v22 = a0 % 60
    if 0 < v19 then
        local v23 = string.format("%dd %02dh %02dm", v19, v20, v21)
        return v23
    end

    if 0 < v20 then
        local v24 = string.format("%dh %02dm %02ds", v20, v21, v22)
        return v24
    end

    local v25 = string.format("%dm %02ds", v21, v22)
    return v25
end

local v26 = os.clock()

local function updateStatsPanel() --[[ Upvalues: v1 (copy), v13 (copy), v14 (ref), v26 (ref), formatPlaytime (copy), v4 (copy) ]]
    local v27 = v1.Data and v1.Data.Stats
    if typeof(v27) ~= "table" then
        for k1, k2 in pairs(v13) do
            k2.Text = "--"
        end

        return
    end

    local v31 = tonumber(v27.Playtime) or 0
    if v31 == v31 then
        if math.abs(v31) ~= math.huge then
            -- jump to 47
        end
    end

    local v32 = 0
    if v14 ~= v32 then
        v14 = v32
        v26 = os.clock()
    end

    local v33 = v32 + math.floor(os.clock() - v26)
    v13.Playtime.Text = formatPlaytime(v33)
    local PlayerKills = v13.PlayerKills
    local addComas1 = v4.addComas
    local v34 = tonumber(v27.PlayerKills) or 0
    if v34 == v34 then
        if math.abs(v34) ~= math.huge then
            -- jump to 114
        end
    end

    local v35 = 0
    PlayerKills.Text = addComas1(tostring(v35))
    local StoragesOpened = v13.StoragesOpened
    local addComas2 = v4.addComas
    local v36 = tonumber(v27.StoragesOpened) or 0
    if v36 == v36 then
        if math.abs(v36) ~= math.huge then
            -- jump to 161
        end
    end

    v35 = 0
    StoragesOpened.Text = addComas2(tostring(v35))
    local TotalMoneyEarned = v13.TotalMoneyEarned
    local addComas3 = v4.addComas
    local v37 = tonumber(v27.TotalMoneyEarned) or 0
    if v37 == v37 then
        if math.abs(v37) ~= math.huge then
            -- jump to 209
        end
    end

    local v38 = 0
    TotalMoneyEarned.Text = "$" .. addComas3(tostring(v38))
    local MobKills = v13.MobKills
    local addComas4 = v4.addComas
    local v39 = tonumber(v27.MobKills) or 0
    if v39 == v39 then
        if math.abs(v39) ~= math.huge then
            -- jump to 257
        end
    end

    local v40 = 0
    MobKills.Text = addComas4(tostring(v40))
end

UnreliableRemoteEvent.Activated:Connect(function() --[[ Upvalues: v3 (copy), HUD (copy), v2 (copy), v14 (ref), updateStatsPanel (copy), RemoteFunction (copy), v1 (copy), GuiService (copy), Back (copy) ]]
    v3.Visible = true
    HUD.Menu.Visible = false
    v2:deselect()
    v14 = nil
    updateStatsPanel()
    task.spawn(function() --[[ Upvalues: RemoteFunction (upvalue), v1 (upvalue), v14 (upvalue), updateStatsPanel (upvalue) ]]
        local v42, v43 = pcall(function() --[[ Upvalues: RemoteFunction (upvalue) ]]
            local v41 = RemoteFunction:InvokeServer("GetStats")
            return v41
        end)
        if v42 then
            if typeof(v43) == "table" then
                local Data1 = v1.Data
                if not Data1 then
                    Data1 = {}
                end

                v1.Data = Data1
                v1.Data.Stats = v43
                v14 = nil
                updateStatsPanel()
            end
        end

    end)
    if GuiService:IsTenFootInterface() then
        GuiService.SelectedObject = Back
    end

end)
Back.Activated:Connect(function() --[[ Upvalues: v3 (copy), v2 (copy), HUD (copy) ]]
    v3.Visible = false
    v2:select()
    HUD.Menu.Visible = true
end)
task.spawn(function() --[[ Upvalues: v3 (copy), updateStatsPanel (copy) ]]
    while v3.Parent do
        task.wait(1)
        if v3.Visible then
            updateStatsPanel()
        end
    end

end)
HUD.Menu.Main.Faction.MouseButton1Click:Connect(function() --[[ Upvalues: HUD (copy), v2 (copy) ]]
    HUD.Faction.Visible = true
    v2:deselect()
end)
HUD.Faction.Back.MouseButton1Click:Connect(function() --[[ Upvalues: HUD (copy), v2 (copy) ]]
    HUD.Faction.Visible = false
    v2:select()
    HUD.Menu.Visible = true
end)
HUD.Menu.Main.Skins.MouseButton1Click:Connect(function() --[[ Upvalues: HUD (copy), v2 (copy) ]]
    HUD.Skins.Visible = true
    v2:deselect()
end)
HUD.Skins.Back.MouseButton1Click:Connect(function() --[[ Upvalues: HUD (copy), v2 (copy) ]]
    HUD.Skins.Visible = false
    v2:select()
end)
HUD.Menu.Main.Settings.MouseButton1Click:Connect(function() --[[ Upvalues: v1 (copy), HUD (copy), v2 (copy) ]]
    v1:UpdateSprintToggle()
    v1:UpdateHideArm()
    v1:UpdateTradeRequests()
    v1:UpdateBuildSystem()
    HUD.Settings.Visible = true
    HUD.Menu.Visible = false
    v2:deselect()
end)
HUD.Settings.Main.SprintToggle.MouseButton1Click:Connect(function() --[[ Upvalues: v1 (copy), RemoteEvent (copy) ]]
    v1.Data.HoldToSprint = not v1.Data.HoldToSprint
    v1:UpdateSprintToggle()
    RemoteEvent:FireServer("ChangeSprintMode")
end)
HUD.Settings.Main.HideArm.MouseButton1Click:Connect(function() --[[ Upvalues: v1 (copy), RemoteEvent (copy) ]]
    v1.Data.HideArm = not v1.Data.HideArm
    v1:UpdateHideArm()
    RemoteEvent:FireServer("ChangeHideArm")
end)
HUD.Settings.Main.TradeRequests.MouseButton1Click:Connect(function() --[[ Upvalues: v1 (copy), RemoteEvent (copy) ]]
    v1.Data.TradeRequests = v1.Data.TradeRequests == false
    v1:UpdateTradeRequests()
    RemoteEvent:FireServer("ChangeTradeRequests")
end)
HUD.Settings.Main.BuildSystem.MouseButton1Click:Connect(function() --[[ Upvalues: v1 (copy) ]]
    v1:SetBuildSystem()
end)
HUD.Settings.Main.LowGFX.MouseButton1Click:Connect(function() --[[ Upvalues: HUD (copy) ]]
    HUD.Settings.Main.LowGFX.Visible = false
    local v44 = workspace.Map:GetDescendants()
    for k3, k4 in pairs(v44) do
        if k4:IsA("Texture") then
            k4:Destroy()
        else
            if k4:IsA("Decal") then
                k4:Destroy()
            else
                if k4:IsA("BasePart") then
                    k4.Material = Enum.Material.SmoothPlastic
                end
            end
        end
    end

    local v48 = workspace.MapObjects:GetDescendants()
    for k5, k6 in pairs(v48) do
        if k6:IsA("Texture") then
            k6:Destroy()
        else
            if k6:IsA("Decal") then
                k6:Destroy()
            else
                if k6:IsA("BasePart") then
                    k6.Material = Enum.Material.SmoothPlastic
                end
            end
        end
    end

    local v52 = workspace.Storages:GetDescendants()
    for k7, k8 in pairs(v52) do
        if k8:IsA("Texture") then
            k8:Destroy()
        else
            if k8:IsA("Decal") then
                k8:Destroy()
            else
                if k8:IsA("BasePart") then
                    k8.Material = Enum.Material.SmoothPlastic
                end
            end
        end
    end

end)
HUD.Settings.Close.MouseButton1Click:Connect(function() --[[ Upvalues: HUD (copy), v2 (copy) ]]
    HUD.Settings.Visible = false
    v2:select()
    HUD.Menu.Visible = true
end)
local v56 = {}

local function controllerKeyIsDown(a0) --[[ Upvalues: UserInputService (copy) ]]
    local v57 = UserInputService:GetConnectedGamepads()
    for k9, k10 in ipairs(v57) do
        if UserInputService:IsGamepadButtonDown(k10, a0) then
            return true
        end
    end

    return false
end

local function controllerBackpackOwns(a0) --[[ Upvalues: v1 (copy) ]]
    local v61 = false
    if v1.CustomBackpack ~= nil then
        local v62 = v1.CustomBackpack:OwnsControllerKey(a0)
    end

    return v61
end

local function controllerBackpackUsesPointer() --[[ Upvalues: UserInputService (copy), PlayerGui (copy) ]]
    local v63 = false
    if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
        v63 = false
        if PlayerGui:GetAttribute("ControllerBackpackActive") == true then
            v63 = PlayerGui:GetAttribute("ControllerBackpackCursorMode") == true
        end
    end

    return v63
end

local function controllerBackpackKeepsHeldAction(a0) --[[ Upvalues: UserInputService (copy), PlayerGui (copy), v1 (copy), controllerKeyIsDown (copy) ]]
    local v64 = false
    if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
        v64 = false
        if PlayerGui:GetAttribute("ControllerBackpackActive") == true then
            v64 = PlayerGui:GetAttribute("ControllerBackpackCursorMode") == true
        end
    end

    if not v64 then
        return false
    end

    local Console = a0:FindFirstChild("Console")
    local v65 = false
    if Console ~= nil then
        local v66 = Console:IsA("InputBinding")
        if v66 then
            local v67 = false
            if v1.CustomBackpack ~= nil then
                v67 = v1.CustomBackpack:OwnsControllerKey(Console.KeyCode)
            end

            local v69 = not v67 and controllerKeyIsDown(Console.KeyCode)
        end
    end

    return v65
end

local function controllerBackpackBlocks(a0) --[[ Upvalues: UserInputService (copy), v1 (copy), v56 (copy), PlayerGui (copy), MainContext (copy), controllerKeyIsDown (copy) ]]
    if UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad then
        return false
    end

    local Console1 = a0:FindFirstChild("Console")
    if not (Console1 and Console1:IsA("InputBinding")) then
        return false
    end

    local KeyCode = Console1.KeyCode
    local v70 = false
    if v1.CustomBackpack ~= nil then
        local v71 = v1.CustomBackpack:OwnsControllerKey(KeyCode)
    end

    if v70 then
        v56[KeyCode] = true
        return true
    end

    v70 = false
    if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
        v70 = false
        if PlayerGui:GetAttribute("ControllerBackpackActive") == true then
            v70 = PlayerGui:GetAttribute("ControllerBackpackCursorMode") == true
        end
    end

    if v70 then
        if a0 == MainContext.Action or a0 == MainContext.Action2 then
            if not controllerKeyIsDown(KeyCode) then
                return true
            end
        end
    end

    return v56[KeyCode] == true
end

local function cancelControllerBackpackAction(a0) --[[ Upvalues: MainContext (copy), RemoteEvent (copy), UserInputService (copy), v1 (copy) ]]
    if a0 == MainContext.Action then
        RemoteEvent:FireServer("M1U")
        return
    end

    if a0 == MainContext.Action2 then
        RemoteEvent:FireServer("M2U", UserInputService.TouchEnabled)
        return
    end

    if a0 == MainContext.Block then
        RemoteEvent:FireServer("BlockOff")
        return
    end

    if a0 == MainContext.Run and v1.Data.HoldToSprint then
        RemoteEvent:FireServer("RunOff")
        return
    end

    if a0 == MainContext.Skill1 then
        RemoteEvent:FireServer("SkillKeyUp", "Skill1")
        return
    end

    if a0 == MainContext.Skill2 then
        RemoteEvent:FireServer("SkillKeyUp", "Skill2")
    end
end

local t1 = {}
local t2 = {}

local function updateControllerBackpackInput() --[[ Upvalues: t1 (ref), controllerKeyIsDown (copy), v56 (copy), MainContext (copy), v1 (copy), t2 (copy), cancelControllerBackpackAction (copy) ]]
    local t3 = {}
    for k11 in pairs(t1) do
        if controllerKeyIsDown(k11) then
            v56[k11] = true
        end
    end

    local v75 = MainContext:GetChildren()
    for k12, k13 in ipairs(v75) do
        local Console2 = k13:FindFirstChild("Console")
        if Console2 then
            if Console2:IsA("InputBinding") then
                local KeyCode1 = Console2.KeyCode
                local v79 = false
                if v1.CustomBackpack ~= nil then
                    local v80 = v1.CustomBackpack:OwnsControllerKey(KeyCode1)
                end

                if v79 then
                    t3[KeyCode1] = true
                    if controllerKeyIsDown(KeyCode1) then
                        v56[KeyCode1] = true
                        if not t1[KeyCode1] or t2[k13] ~= KeyCode1 then
                            cancelControllerBackpackAction(k13)
                        end
                    end
                end

                t2[k13] = KeyCode1
            end
        end
    end

    t1 = t3
end

local v81 = PlayerGui:GetAttributeChangedSignal("ControllerBackpackInputRevision")
v81:Connect(updateControllerBackpackInput)

local function watchControllerBackpackBinding(a0) --[[ Upvalues: updateControllerBackpackInput (copy) ]]
    if a0.Name == "Console" and a0:IsA("InputBinding") then
        local v82 = a0:GetPropertyChangedSignal("KeyCode")
        v82:Connect(updateControllerBackpackInput)
    end
end

local function watchControllerBackpackAction(a0) --[[ Upvalues: updateControllerBackpackInput (copy) ]]
    local v83 = a0:GetChildren()
    for k14, k15 in ipairs(v83) do
        if k15.Name == "Console" and k15:IsA("InputBinding") then
            local v87 = k15:GetPropertyChangedSignal("KeyCode")
            v87:Connect(updateControllerBackpackInput)
        end
    end

    a0.ChildAdded:Connect(function(a0) --[[ Upvalues: updateControllerBackpackInput (upvalue) ]]
        if a0.Name == "Console" and a0:IsA("InputBinding") then
            local v88 = a0:GetPropertyChangedSignal("KeyCode")
            v88:Connect(updateControllerBackpackInput)
        end

        updateControllerBackpackInput()
    end)
    updateControllerBackpackInput()
end

local v89 = MainContext:GetChildren()
for k16, k17 in ipairs(v89) do
    watchControllerBackpackAction(k17)
end

MainContext.ChildAdded:Connect(watchControllerBackpackAction)
updateControllerBackpackInput()

local function recoverControllerBackpackReleases() --[[ Upvalues: UserInputService (copy), v1 (copy), v56 (copy), controllerKeyIsDown (copy), MainContext (copy) ]]
    if UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad or v1.ClassicBuildActive then
        return
    end

    for k18 in pairs(v56) do
        if not controllerKeyIsDown(k18) then
            local v96 = MainContext:GetChildren()
            for k19, k20 in ipairs(v96) do
                local Console3 = k20:FindFirstChild("Console")
                if Console3 and Console3:IsA("InputBinding") and Console3.KeyCode == k18 and k20:IsA("InputAction") and k20.Enabled and k20.Type == Enum.InputActionType.Bool and k20:GetState() == true then
                    k20.Enabled = false
                    k20.Enabled = true
                end
            end

            v56[k18] = nil
        end
    end
end

local v100 = UserInputService:GetPropertyChangedSignal("PreferredInput")
v100:Connect(recoverControllerBackpackReleases)
RunService.Heartbeat:Connect(recoverControllerBackpackReleases)
if MainContext.Action.Keyboard.KeyCode == Enum.KeyCode.Unknown then
    MainContext.Action.Keyboard.KeyCode = Enum.KeyCode.MouseLeftButton
end

MainContext.Action.Pressed:Connect(function() --[[ Upvalues: controllerBackpackBlocks (copy), MainContext (copy), v1 (copy), Players (copy), RemoteEvent (copy), UserInputService (copy), PlayerGui (copy) ]]
    if controllerBackpackBlocks(MainContext.Action) then
        return
    end

    if v1.Painting or v1.ClassicBuildActive then
        return
    end

    local Target = Players.Target
    if v1.Painting then
        if v1.PaintMode == "ColorDropper" and Target then
            v1.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3 = Target.Color
            return
        end

        if v1.PaintMode ~= "ColorDropper" then
            if v1.PaintMode ~= "None" then
                if Target then
                    if Target:IsDescendantOf(v1.StorageBase.Contents.Objects) then
                        local v101 = {
                            v1.Mouse.Target,
                            v1.PaintMode,
                            v1.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3
                        }
                        RemoteEvent:FireServer("PaintBaseObject", v101)
                        return
                        -- branch continues at 170
                    end

                    -- branch continues at 170
                end

                -- branch continues at 170
            end

            -- branch continues at 170
        end
    end

    local v102
    if UserInputService.TouchEnabled then
        if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
            if PlayerGui:GetAttribute("ControllerBackpackActive") == true then
                -- jump to 125
            end
        end

        v102 = v1:GetMobileAim()
    else
        v102 = v1:GetAim()
    end

    RemoteEvent:FireServer("M1D", v102)
    if _G.Utl and _G.Utl.FX and _G.Utl.FX.PredictGrenade then
        _G.Utl.FX.PredictGrenade(v102)
    end

end)
MainContext.Action.Released:Connect(function() --[[ Upvalues: controllerBackpackKeepsHeldAction (copy), MainContext (copy), v1 (copy), RemoteEvent (copy) ]]
    if controllerBackpackKeepsHeldAction(MainContext.Action) then
        return
    end

    if v1.Painting then
        return
    end

    RemoteEvent:FireServer("M1U")
end)
local v103 = 0

local function resetPrimaryAction() --[[ Upvalues: v103 (ref), RemoteEvent (copy), MainContext (copy), v1 (copy) ]]
    v103 = v103 + 1
    RemoteEvent:FireServer("M1U")
    MainContext.Action.Enabled = false
    local v104 = v103
    task.defer(function() --[[ Upvalues: v104 (copy), v103 (upvalue), MainContext (upvalue), v1 (upvalue) ]]
        if v104 == v103 and MainContext.Action.Parent and not v1.ClassicBuildActive then
            MainContext.Action.Enabled = true
        end

    end)
end

LocalPlayer.CharacterRemoving:Connect(resetPrimaryAction)
LocalPlayer.CharacterAdded:Connect(resetPrimaryAction)
task.spawn(function() --[[ Upvalues: ReplicatedStorage (copy), v103 (ref), RemoteEvent (copy), MainContext (copy), v1 (copy) ]]
    local TradingRemotes = ReplicatedStorage:WaitForChild("TradingRemotes", 30)
    local v106 = TradingRemotes and TradingRemotes:FindFirstChild("Event")
    if not v106 then
        return
    end

    v106.OnClientEvent:Connect(function(a0) --[[ Upvalues: v103 (upvalue), RemoteEvent (upvalue), MainContext (upvalue), v1 (upvalue) ]]
        if a0 == "TradeEnded" then
            v103 = v103 + 1
            RemoteEvent:FireServer("M1U")
            MainContext.Action.Enabled = false
            local v107 = v103
            task.defer(function() --[[ Upvalues: v107 (copy), v103 (upvalue), MainContext (upvalue), v1 (upvalue) ]]
                if v107 == v103 and MainContext.Action.Parent and not v1.ClassicBuildActive then
                    MainContext.Action.Enabled = true
                end

            end)
        end

    end)
end)
if MainContext.Action2.Keyboard.KeyCode == Enum.KeyCode.Unknown then
    MainContext.Action2.Keyboard.KeyCode = Enum.KeyCode.MouseRightButton
end

MainContext.Action2.Pressed:Connect(function() --[[ Upvalues: controllerBackpackBlocks (copy), MainContext (copy), v1 (copy), LocalPlayer (copy), UserInputService (copy), PlayerGui (copy), RemoteEvent (copy) ]]
    if controllerBackpackBlocks(MainContext.Action2) then
        return
    end

    if v1.Painting or v1.ClassicBuildActive then
        return
    end

    local Character = LocalPlayer.Character
    local v110 = Character and Character:FindFirstChildOfClass("Tool")
    if v110 then
        if v110:GetAttribute("ToolName") == "Hallow's Revolvers" then
            local v111
            if UserInputService.TouchEnabled then
                if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
                    if PlayerGui:GetAttribute("ControllerBackpackActive") == true then
                        -- jump to 62
                    end
                end

                v111 = v1:GetMobileAim()
            else
                v111 = v1:GetAim()
            end

            RemoteEvent:FireServer("M2D", v111)
            return
        end
    end

    RemoteEvent:FireServer("M2D", UserInputService.TouchEnabled)
end)
MainContext.Action2.Released:Connect(function() --[[ Upvalues: controllerBackpackKeepsHeldAction (copy), MainContext (copy), v1 (copy), RemoteEvent (copy), UserInputService (copy) ]]
    if controllerBackpackKeepsHeldAction(MainContext.Action2) then
        return
    end

    if v1.Painting then
        return
    end

    RemoteEvent:FireServer("M2U", UserInputService.TouchEnabled)
end)
MainContext.Block.Pressed:Connect(function() --[[ Upvalues: controllerBackpackBlocks (copy), MainContext (copy), v1 (copy), RemoteEvent (copy) ]]
    if controllerBackpackBlocks(MainContext.Block) then
        return
    end

    if v1.ClassicBuildActive then
        return
    end

    RemoteEvent:FireServer("Block")
end)
MainContext.Block.Released:Connect(function() --[[ Upvalues: RemoteEvent (copy) ]]
    RemoteEvent:FireServer("BlockOff")
end)
MainContext.DropItem.Pressed:Connect(function() --[[ Upvalues: controllerBackpackBlocks (copy), MainContext (copy), RemoteEvent (copy) ]]
    if controllerBackpackBlocks(MainContext.DropItem) then
        return
    end

    RemoteEvent:FireServer("DropItem")
end)
MainContext.FreeMouse.Pressed:Connect(function() --[[ Upvalues: controllerBackpackBlocks (copy), MainContext (copy), v1 (copy) ]]
    if controllerBackpackBlocks(MainContext.FreeMouse) then
        return
    end

    v1.FreeMouse = not v1.FreeMouse
    v1:UpdateFreeMouse()
end)
MainContext.Run.Pressed:Connect(function() --[[ Upvalues: controllerBackpackBlocks (copy), MainContext (copy), v1 (copy), RemoteEvent (copy) ]]
    if controllerBackpackBlocks(MainContext.Run) then
        return
    end

    if v1.Data.HoldToSprint then
        RemoteEvent:FireServer("Run")
        return
    end

    if v1.Character:GetAttribute("Running") then
        RemoteEvent:FireServer("RunOff")
        return
    end

    RemoteEvent:FireServer("Run")
end)
MainContext.Run.Released:Connect(function() --[[ Upvalues: v1 (copy), RemoteEvent (copy) ]]
    if v1.Data.HoldToSprint then
        RemoteEvent:FireServer("RunOff")
    end

end)
MainContext.Crouch.Pressed:Connect(function() --[[ Upvalues: controllerBackpackBlocks (copy), MainContext (copy), v1 (copy), RemoteEvent (copy) ]]
    if controllerBackpackBlocks(MainContext.Crouch) then
        return
    end

    if v1.StorageHover then
        return
    end

    RemoteEvent:FireServer("Crouch")
end)
MainContext.Reload.Pressed:Connect(function() --[[ Upvalues: controllerBackpackBlocks (copy), MainContext (copy), v1 (copy), RemoteEvent (copy) ]]
    if controllerBackpackBlocks(MainContext.Reload) then
        return
    end

    if v1.ClassicBuildActive then
        return
    end

    RemoteEvent:FireServer("Reload")
end)
MainContext.Slide.Pressed:Connect(function() --[[ Upvalues: controllerBackpackBlocks (copy), MainContext (copy), v1 (copy) ]]
    if controllerBackpackBlocks(MainContext.Slide) then
        return
    end

    v1:Slide()
end)
MainContext.ClaimStorage.Pressed:Connect(function() --[[ Upvalues: controllerBackpackBlocks (copy), MainContext (copy), RemoteEvent (copy), v1 (copy) ]]
    if controllerBackpackBlocks(MainContext.ClaimStorage) then
        return
    end

    RemoteEvent:FireServer("ClaimStorage", v1.StorageHover)
end)
MainContext.Skill1.Pressed:Connect(function() --[[ Upvalues: controllerBackpackBlocks (copy), MainContext (copy), RemoteEvent (copy) ]]
    if controllerBackpackBlocks(MainContext.Skill1) then
        return
    end

    RemoteEvent:FireServer("SkillKeyDown", "Skill1")
end)
MainContext.Skill1.Released:Connect(function() --[[ Upvalues: RemoteEvent (copy) ]]
    RemoteEvent:FireServer("SkillKeyUp", "Skill1")
end)
MainContext.Skill2.Pressed:Connect(function() --[[ Upvalues: controllerBackpackBlocks (copy), MainContext (copy), RemoteEvent (copy) ]]
    if controllerBackpackBlocks(MainContext.Skill2) then
        return
    end

    RemoteEvent:FireServer("SkillKeyDown", "Skill2")
end)
MainContext.Skill2.Released:Connect(function() --[[ Upvalues: RemoteEvent (copy) ]]
    RemoteEvent:FireServer("SkillKeyUp", "Skill2")
end)
if UserInputService.TouchEnabled then
    RunService = PlayerGui:WaitForChild("MobileButtons")
    local v112 = MainContext:GetChildren()
    for k21, k22 in pairs(v112) do
        local v116 = RunService.Buttons:FindFirstChild(k22.Name)
        if v116 then
            k22.Touch.UIButton = v116
        end
    end

    RunService.Enabled = true
    HUD.Menu.Main.EditMobile.Visible = true
    HUD.Menu.Main.EditMobile.MouseButton1Click:Connect(function() --[[ Upvalues: MainContext (copy), HUD (copy), v2 (copy), RunService (copy), RemoteEvent (copy), UserInputService (copy) ]]
        MainContext.Enabled = false
        HUD.Menu.Visible = false
        v2:deselect()
        RunService.Save.Visible = true
        RunService.Reset.Visible = true
        local Reset = RunService.Reset
        local v126 = nil
        local v127 = nil
        local v128 = nil
        local v129 = false

        local function update(a0) --[[ Upvalues: v127 (ref), v126 (ref), v128 (ref) ]]
            local v130 = a0.Position - v127
            local Parent = v126.Parent
            local v131 = v128.X.Scale + v130.X / Parent.AbsoluteSize.X
            local v132 = v128.Y.Scale + v130.Y / Parent.AbsoluteSize.Y
            v126.Position = UDim2.new(v131, 0, v132, 0)
        end

        Reset = {
            Save = RunService.Save.MouseButton1Click:Connect(function() --[[ Upvalues: MainContext (upvalue), RunService (upvalue), Reset (copy), HUD (upvalue), v2 (upvalue), RemoteEvent (upvalue) ]]
            MainContext.Enabled = true
            RunService.Save.Visible = false
            RunService.Reset.Visible = false
            for k23, k24 in pairs(Reset) do
                k24:Disconnect()
                Reset[k23] = nil
            end

            HUD.Menu.Visible = true
            v2:select()
            local v120 = {}
            local v121 = RunService.Buttons:GetChildren()
            for k25, k26 in pairs(v121) do
                local v125 = {
                    k26.Position.X.Scale,
                    k26.Position.X.Offset,
                    k26.Position.Y.Scale,
                    k26.Position.Y.Offset
                }
                v120[k26.Name] = v125
            end

            RemoteEvent:FireServer("SaveMobileButtons", v120)
        end),
            Reset = RunService.Reset.MouseButton1Click:Connect(function() --[[ Upvalues: RemoteEvent (upvalue) ]]
            RemoteEvent:FireServer("ResetMobileButtons")
        end),
            InputChanged = UserInputService.InputChanged:Connect(function(a0) --[[ Upvalues: v129 (ref), v127 (ref), v126 (ref), v128 (ref) ]]
            if v129 and a0.UserInputType == Enum.UserInputType.Touch then
                local v133 = a0.Position - v127
                local Parent1 = v126.Parent
                local v134 = v128.X.Scale + v133.X / Parent1.AbsoluteSize.X
                local v135 = v128.Y.Scale + v133.Y / Parent1.AbsoluteSize.Y
                v126.Position = UDim2.new(v134, 0, v135, 0)
            end

        end)
        }
        local v136 = RunService.Buttons:GetChildren()
        for k27, k28 in pairs(v136) do
            local v140 = k28.Name .. "Began"
            Reset[v140] = k28.InputBegan:Connect(function(a0) --[[ Upvalues: v126 (ref), k28 (copy), v129 (ref), v127 (ref), v128 (ref) ]]
                if a0.UserInputType == Enum.UserInputType.Touch then
                    v126 = k28
                    v129 = true
                    v127 = a0.Position
                    v128 = v126.Position
                    a0.Changed:Connect(function() --[[ Upvalues: a0 (copy), v129 (upvalue), v126 (upvalue) ]]
                        if a0.UserInputState == Enum.UserInputState.End then
                            v129 = false
                            v126 = nil
                        end

                    end)
                end

            end)
        end

    end)
end

HUD.PVPShield.Button.MouseButton1Click:Connect(function() --[[ Upvalues: RemoteEvent (copy) ]]
    RemoteEvent:FireServer("PVPShieldOff")
end)
v1:InitBrewing()
v1:SetupSkins()
v1:InitShop()
HUD.Faction.FocusLost:Connect(function() --[[ Upvalues: RemoteEvent (copy), HUD (copy) ]]
    RemoteEvent:FireServer("ChangeFaction", HUD.Faction.Text)
end)
HUD.GuideButton.MouseButton1Click:Connect(function() --[[ Upvalues: HUD (copy) ]]
    HUD.Guide.Visible = not HUD.Guide.Visible
end)
HUD.Guide.Close.MouseButton1Click:Connect(function() --[[ Upvalues: HUD (copy) ]]
    HUD.Guide.Visible = false
end)
if game.PlaceId == 14419150323 or game.PlaceId == 14451235347 then
    if not v1:CheckVC() then
        LocalPlayer:Kick("No VC Access")
    end
end

local v141, v142 = pcall(PolicyService.GetPolicyInfoForPlayerAsync, PolicyService, LocalPlayer)
if v141 and v142 and not v142.AreAdsAllowed then
    workspace.Ads:Destroy()
end
