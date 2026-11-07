
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BadgeService = game:GetService("BadgeService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local Sounds = ReplicatedStorage.Sounds
local v1 = {
    [1] = "One",
    [2] = "Two",
    [3] = "Three",
    [4] = "Four",
    [5] = "Five",
    [6] = "Six",
    [7] = "Seven",
    [8] = "Eight",
    [9] = "Nine",
    [10] = "Ten",
    [11] = "Eleven",
    [12] = "Twelve",
    [13] = "Thirteen",
    [14] = "Fourteen",
    [15] = "Fifteen",
    [16] = "Sixteen",
    [17] = "Seventeen",
    [18] = "Eighteen"
}
v1 = {
    Action = UDim2.new(0.813, 0, 0.684, 0),
    Action2 = UDim2.new(0.822, 0, 0.898, 0),
    Block = UDim2.new(0.871, 0, 0.58, 0),
    Slide = UDim2.new(0.78, 0, 0.791, 0),
    Run = UDim2.new(0.947, 0, 0.642, 0),
    Crouch = UDim2.new(0.866, 0, 0.43, 0),
    DropItem = UDim2.new(0.952, 0, 0.43, 0),
    Skill1 = UDim2.new(0.77, 0, 0.302, 0),
    Skill2 = UDim2.new(0.854, 0, 0.302, 0),
    Reload = UDim2.new(0.784, 0, 0.444, 0)
}
ReplicatedStorage = {
    Channel = require(script.Channel),
    FX = require(script.Effects),
    MaxLevel = 999,
    SlotStrings = v1,
    DefaultMobilePositions = v1,
    TranslateKeys = {}
}
local v2 = Enum.KeyCode:GetEnumItems()
for k1, k2 in ipairs(v2) do
    ReplicatedStorage.TranslateKeys[k2.Name] = k2
end

local v6 = {
    Enum.KeyCode.Q,
    Enum.KeyCode.E,
    Enum.KeyCode.R,
    Enum.KeyCode.T,
    Enum.KeyCode.Y,
    Enum.KeyCode.U,
    Enum.KeyCode.P,
    Enum.KeyCode.F,
    Enum.KeyCode.G,
    Enum.KeyCode.J,
    Enum.KeyCode.K,
    Enum.KeyCode.L,
    Enum.KeyCode.C,
    Enum.KeyCode.V,
    Enum.KeyCode.B,
    Enum.KeyCode.N,
    Enum.KeyCode.M,
    Enum.KeyCode.MouseLeftButton,
    Enum.KeyCode.MouseRightButton,
    Enum.KeyCode.MouseMiddleButton,
    Enum.KeyCode.LeftShift,
    Enum.KeyCode.LeftControl,
    Enum.KeyCode.F1,
    Enum.KeyCode.F2,
    Enum.KeyCode.F3,
    Enum.KeyCode.F4,
    Enum.KeyCode.F5,
    Enum.KeyCode.F6,
    Enum.KeyCode.F7,
    Enum.KeyCode.F8
}
ReplicatedStorage.KeyboardBindings = v6
v6 = {
    Enum.KeyCode.ButtonL2,
    Enum.KeyCode.ButtonL3,
    Enum.KeyCode.ButtonR2,
    Enum.KeyCode.ButtonR3,
    Enum.KeyCode.DPadRight,
    Enum.KeyCode.DPadLeft,
    Enum.KeyCode.ButtonY,
    Enum.KeyCode.ButtonX,
    Enum.KeyCode.ButtonB,
    Enum.KeyCode.ButtonA
}
ReplicatedStorage.ConsoleBindings = v6
local v7 = {Keyboard = Enum.KeyCode.MouseLeftButton, Console = Enum.KeyCode.ButtonR2}
v7 = {Keyboard = Enum.KeyCode.MouseRightButton, Console = Enum.KeyCode.ButtonL2}
v7 = {Keyboard = Enum.KeyCode.F, Console = Enum.KeyCode.ButtonY}
v7 = {Keyboard = Enum.KeyCode.LeftShift, Console = Enum.KeyCode.DPadRight}
v7 = {Keyboard = Enum.KeyCode.R, Console = Enum.KeyCode.ButtonX}
v7 = {Keyboard = Enum.KeyCode.Q, Console = Enum.KeyCode.ButtonB}
v7 = {Keyboard = Enum.KeyCode.LeftControl, Console = Enum.KeyCode.DPadLeft}
v6 = {Action = v7, Action2 = v7, Block = v7, Run = v7, Reload = v7, Slide = v7, Crouch = v7}
ReplicatedStorage.DefaultBindings = v6
v6 = {"Double Barrel Shotgun", "Shotgun", "SMG", "Revolver", "LMG", "AK47"}
ReplicatedStorage.Guns = v6
local v8 = Color3.fromRGB(144, 255, 138)
local v9 = {v8, 4}
local v10 = Color3.fromRGB(114, 199, 255)
v9 = {v10, 3}
local v11 = Color3.fromRGB(255, 62, 62)
v9 = {v11, 2}
local v12 = Color3.fromRGB(255, 244, 121)
v9 = {v12, 1}
v6 = {Common = v9, Rare = v9, Epic = v9, Legendary = v9}
ReplicatedStorage.RarityInfo = v6
ReplicatedStorage.ShopRarityOrder = {Common = 1, Rare = 2, Epic = 3, Legendary = 4}

local function GetNearestDay()
    return os.time() - os.time() % 86400
end

ReplicatedStorage.GetNearestDay = GetNearestDay

local function GenerateTag() --[[ Upvalues: HttpService (copy) ]]
    return HttpService:GenerateGUID(false)
end

ReplicatedStorage.GenerateTag = GenerateTag

local function ExpCost(a0)
    return 100 + a0 * 50
end

ReplicatedStorage.ExpCost = ExpCost

local function formatTimeForShop(a0)
    local v13 = math.floor(a0 / 60)
    local v14 = string.format("%dm %ds", v13, a0 % 60)
    return v14
end

ReplicatedStorage.formatTimeForShop = formatTimeForShop

local function Roll(a0, a1)
    local v15 = 0
    local v16 = {}
    local v17 = math.random()
    if a1 then
        v17 = v17 + a1
        if 1 < v17 then
            v17 = 1
        end
    end

    for k3, k4 in pairs(a0) do
        v15 = v15 + k4.Chance
        if v17 <= v15 then
            v16 = k4
            break
        end
    end

    v17 = v16.Pool
    return v17[math.random(#v17)]
end

ReplicatedStorage.Roll = Roll

local function getTextObject(a0, a1) --[[ Upvalues: TextService (copy) ]]
    local v21 = nil
    local v22, v23 = pcall(function() --[[ Upvalues: v21 (ref), TextService (upvalue), a0 (copy), a1 (copy) ]]
        v21 = TextService:FilterStringAsync(a0, a1)
    end)
    if v22 then
        return v21
    end

    if v23 then
        print("Error generating TextFilterResult:", v23)
    end

    return false
end

ReplicatedStorage.getTextObject = getTextObject

local function getFilteredMessage(a0)
    local v24 = nil
    local v25, v26 = pcall(function() --[[ Upvalues: v24 (ref), a0 (copy) ]]
        v24 = a0:GetNonChatStringForBroadcastAsync()
    end)
    if v25 then
        return v24
    end

    if v26 then
        print("Error filtering message:", v26)
    end

    return false
end

ReplicatedStorage.getFilteredMessage = getFilteredMessage

local function GetMass(a0)
    local v29 = a0 and a0:IsA("Model")
    assert(v29, "Model argument of getMass must be a model.")
    local v30 = 0
    local v31 = a0:GetDescendants()
    for k5, k6 in pairs(v31) do
    end

    return v30
end

ReplicatedStorage.GetMass = GetMass

local function isTouchDevice() --[[ Upvalues: UserInputService (copy) ]]
    local v35 = false
    pcall(function() --[[ Upvalues: v35 (ref), UserInputService (upvalue) ]]
        v35 = UserInputService.TouchEnabled
    end)
    return v35
end

ReplicatedStorage.isTouchDevice = isTouchDevice

local function AwardBadge(a0, a1) --[[ Upvalues: BadgeService (copy) ]]
    local v37, v38 = pcall(function() --[[ Upvalues: BadgeService (upvalue), a0 (copy), a1 (copy) ]]
        local v36 = BadgeService:UserHasBadgeAsync(a0.UserId, a1)
        return v36
    end)
    if not v37 then
        return
    end

    if v38 then
        return
    end

    local v40, v41 = pcall(function() --[[ Upvalues: BadgeService (upvalue), a1 (copy) ]]
        local v39 = BadgeService:GetBadgeInfoAsync(a1)
        return v39
    end)
    if v40 then
        if v41.IsEnabled then
            local v43, v44 = pcall(function() --[[ Upvalues: BadgeService (upvalue), a0 (copy), a1 (copy) ]]
                local v42 = BadgeService:AwardBadge(a0.UserId, a1)
                return v42
            end)
            if not v43 then
                warn("Error while awarding badge:", v44)
                return
            end

            if not v44 then
                warn("Failed to award badge.")
                return
                -- branch continues at 53
            end

            -- branch continues at 53
        end
    end

    warn("Error while fetching badge info: " .. v41)
end

ReplicatedStorage.AwardBadge = AwardBadge

local function DeepCopy(a0) --[[ Upvalues: ReplicatedStorage (copy) ]]
    local t1 = {}
    local v45 = next
    local v46 = a0
    local v47 = nil
    for k7, k8 in v45 do
        if typeof(k8) == "table" then
            t1[k7] = ReplicatedStorage.DeepCopy(k8)
        else
            t1[k7] = k8
        end
    end

    return t1
end

ReplicatedStorage.DeepCopy = DeepCopy

local function FolderToTable(a0) --[[ Upvalues: ReplicatedStorage (copy) ]]
    local t2 = {}
    local v48 = next
    local v49, v50 = a0:GetChildren()
    for k9, k10 in v48 do
        if k10:IsA("Folder") then
            t2[k10.Name] = ReplicatedStorage.FolderToTable(k10)
        else
            t2[k10.Name] = k10.Value
        end
    end

    return t2
end

ReplicatedStorage.FolderToTable = FolderToTable
FolderToTable = {boolean = "Bool"}

local function TableToFolder(a0) --[[ Upvalues: ReplicatedStorage (copy), FolderToTable (copy) ]]
    local Folder = Instance.new("Folder")
    for k11, k12 in pairs(a0) do
        local v54 = typeof(k12)
        if v54 == "table" then
            local v55 = ReplicatedStorage.TableToFolder(k12)
            v55.Name = k11
            v55.Parent = Folder
        else
            if v54 ~= "table" then
                local v56 = string.sub(v54, 1, 1):upper()
                local v57 = string.sub(v54, 2)
                local v58 = v56 .. v57 .. "Value"
                local v59 = Instance.new(v58)
                v59.Name = k11
                v59.Value = k12
                v59.Parent = Folder
            end
        end
    end

    return Folder
end

ReplicatedStorage.TableToFolder = TableToFolder

local function Random(a0)
    local v60 = Random.new(a0)
    return v60
end

ReplicatedStorage.Random = Random

local function tabFind(a0, a1)
    for k13, k14 in pairs(a0) do
        if k14 == a1 then
            return k14
        end

        if k13 == a1 then
            return k13
        end
    end

    return nil
end

ReplicatedStorage.tabFind = tabFind

local function Raycast(a0)
    local v64 = RaycastParams.new()
    if a0.Whitelist then
        v64.FilterType = Enum.RaycastFilterType.Whitelist
        v64.FilterDescendantsInstances = a0.Whitelist
    else
        if a0.Blacklist then
            v64.FilterDescendantsInstances = a0.Blacklist
            v64.FilterType = Enum.RaycastFilterType.Blacklist
        end
    end

    return workspace:Raycast(a0.Origin, a0.Dir, v64)
end

ReplicatedStorage.Raycast = Raycast

local function addComas(a0)
    local v66
    if not (#a0 % 3 == 0 and a0:reverse():gsub("(%d%d%d)", "%1,"):reverse():sub(2)) then
        local v67 = a0:reverse():gsub("(%d%d%d)", "%1,"):reverse()
    end

    return v66
end

ReplicatedStorage.addComas = addComas

local function determineIfBehind(a0, a1)
    local v68 = a0.lookVector:Dot(a1.lookVector)
    if 0.33 < v68 then
        return true
    end

    return false
end

ReplicatedStorage.determineIfBehind = determineIfBehind

local function timeFormat(a0)
    if 3600 <= a0 then
        local v69 = math.floor(a0 / 3600)
        local v70 = math.floor(a0 / 60) % 60
        local v71 = string.format("%d:%02d:%02d", v69, v70, a0 % 60)
        return v71
    end

    local v72 = math.floor(a0 / 60) % 60
    local v73 = string.format("%d:%02d", v72, a0 % 60)
    return v73
end

ReplicatedStorage.timeFormat = timeFormat

local function PlaySound(a0) --[[ Upvalues: RunService (copy), Sounds (copy) ]]
    if RunService:IsServer() then
        if not a0.Return then
            if a0.PlayerOnly then
                _G.RemoteEvent:FireClient(a0.PlayerOnly, "Sound", a0)
                return
            end

            _G.RemoteEvent:FireAllClients("Sound", a0)
            return
        end
    end

    local v74 = nil
    if typeof(a0.Sound) == "string" then
        v74 = Sounds:FindFirstChild(a0.Sound)
    else
        if typeof(a0.Sound) == "Instance" and a0.Sound:IsA("Sound") then
            v74 = a0.Sound
        end
    end

    if not v74 then
        local v75 = string.format("Unable to play missing sound %s", tostring(a0.Sound))
        warn(v75)
        return
    end

    if not a0.Origin then
        return
    end

    local v76 = v74:Clone()
    local v77 = a0.Speed or a0.PlaybackSpeed or v76.PlaybackSpeed
    local v78 = a0.Pos or v76.TimePosition
    local v79 = a0.Volume or v76.Volume
    local v80 = a0.Looped or false
    v76.PlaybackSpeed = v77
    v76.TimePosition = v78
    v76.Volume = v79
    v76.Looped = v80
    v76.Parent = a0.Origin
    if a0.Return then
        return v76
    end

    if v80 then
        v79 = a0.Time
        if typeof(v79) ~= "number" or v79 <= 0 then
            local v81 = string.format("Looped sound %s needs a positive Time; using 30 seconds", v76.Name)
            warn(v81)
            v79 = 30
        end

        task.delay(v79, function() --[[ Upvalues: v76 (copy) ]]
            if v76.Parent then
                v76:Stop()
                v76:Destroy()
            end

        end)
    else
        v76.Ended:Once(function() --[[ Upvalues: v76 (copy) ]]
            v76:Destroy()
        end)
        if not v76.IsLoaded then
            task.delay(30, function() --[[ Upvalues: v76 (copy) ]]
                if v76.Parent and not v76.IsLoaded then
                    v76:Destroy()
                end

            end)
        end
    end

    v76:Play()
end

ReplicatedStorage.PlaySound = PlaySound
return ReplicatedStorage
