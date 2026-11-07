
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = require(ReplicatedStorage.Modules.BaseObjectsLib)
local t1 = {Furniture = true, Decoration = true, Traps = true}

local function IsValidName(a0) --[[ Upvalues: v1 (copy), t1 (copy) ]]
    if type(a0) ~= "string" then
        return false
    end

    local v2 = rawget(v1, a0)
    local v3 = false
    if type(v2) == "table" then
        v3 = t1[v2.Type] == true
    end

    return v3
end

local v4 = nil

local function Favorites(a0) --[[ Upvalues: v1 (copy), v4 (copy) ]]
    local t2 = {}
    if type(a0) ~= "table" then
        return t2
    end

    for k1 in pairs(v1) do
        if v4.IsValidName(k1) and a0[k1] == true then
            t2[k1] = true
        end
    end

    return t2
end

local function Recents(a0) --[[ Upvalues: v4 (copy) ]]
    local t3 = {}
    if type(a0) ~= "table" then
        return t3
    end

    local v8 = {}
    for k2 in pairs(a0) do
        local v13 = type(k2)
        if v13 == "number" then
            v13 = 1
            if v13 <= k2 then
                v13 = math.huge
                if k2 < v13 then
                    v13 = k2 % 1
                    if v13 == 0 then
                        v13 = table.insert
                        v13(v8, k2)
                    end
                end
            end
        end
    end

    table.sort(v8)
    local v14 = {}
    for k3, k4 in ipairs(v8) do
        local v18 = a0[k4]
        if v4.IsValidName(v18) and not v14[v18] then
            v14[v18] = true
            table.insert(t3, v18)
            if v4.MAX_RECENTS <= #t3 then
                break
            end
        end
    end

    return t3
end

v4 = {MAX_RECENTS = 12, IsValidName = IsValidName, Favorites = Favorites, Recents = Recents}
local t4 = {"Recent", "Favorites", "Furniture", "Decoration", "Traps"}
t4 = {
    Beds = 1,
    Seating = 2,
    Tables = 3,
    Storage = 4,
    Kitchen = 5,
    ["Walls & Doors"] = 6,
    Utility = 7,
    Flooring = 10,
    Plants = 11,
    Electronics = 12,
    Showcases = 13,
    Lighting = 14,
    Misc = 15,
    Turrets = 20,
    Guytraps = 21,
    Floor = 22
}
t4 = {
    Controller = {HideLocked = true, ValidateNames = true, CollectionOwnedOnly = true},
    ClassicTouch = {HideLocked = true, Search = true, CollectionSubcategories = true},
    ModernTouch = {
        Search = true,
        CollectionSubcategories = true,
        RecordRecents = true,
        LockedLast = true,
        NumericPrice = true
    }
    Desktop = {
        HideLocked = true,
        Search = true,
        CollectionSubcategories = true,
        RecordRecents = true,
        FirstRecent = true,
        LockedLast = true,
        NumericPrice = true
    }
}

local function Query(a0) --[[ Upvalues: t4 (copy), v4 (copy), v1 (copy), Recents (copy) ]]
    local v19 = t4[a0.Policy]
    local v20 = assert(v19, "Unknown catalogue policy")
    v19 = a0.Data
    if not v19 then
        v19 = {}
    end

    local UnlockedObjects = v19.UnlockedObjects
    if not UnlockedObjects then
        UnlockedObjects = {}
    end

    local BaseItems = v19.BaseItems
    if not BaseItems then
        BaseItems = {}
    end

    local Category = a0.Category
    local SubCategory = a0.SubCategory
    local Favorites1 = a0.Favorites
    if not Favorites1 then
        Favorites1 = {}
    end

    local t5 = {}
    local Recents1 = a0.Recents
    if not Recents1 then
        Recents1 = {}
    end

    for k5, k6 in ipairs(Recents1) do
        if v20.RecordRecents then
            if type(k6) == "table" then
                v19 = k6.Name
                if not v19 then
                    v19 = k6.name
                    if v19 then
                        -- jump to 63
                    end

                    -- branch continues at 63
                end
            end

            v19 = k6
            if type(v19) == "string" then
                if v20.FirstRecent then
                    if t5[v19] then
                        -- jump to 78
                    end
                end

                t5[v19] = k5
                -- branch continues at 78
            end
        else
            t5[k6] = k5
        end
    end

    local v24 = true
    if Category ~= "Recent" then
        v24 = Category == "Favorites"
    end

    local function categoryMatches(a0, a1) --[[ Upvalues: v20 (copy), v4 (upvalue), UnlockedObjects (copy), v24 (copy), BaseItems (copy), Category (copy), t5 (copy), Favorites1 (copy) ]]
        if type(a1) ~= "table" then
            return false
        end

        if v20.ValidateNames and not v4.IsValidName(a0) then
            return false
        end

        if v20.HideLocked and a1.Unlock and not UnlockedObjects[a0] then
            return false
        end

        if v20.CollectionOwnedOnly and v24 and a1.ItemObject then
            local v25 = tonumber(BaseItems[a0]) or 0
            if v25 <= 0 then
                return false
            end
        end

        if Category ~= "Recent" or true == nil then
            if Category ~= "Favorites" or true ~= true then
                v26 = a1.Type == Category
            end
        end

        return v26
    end

    local v27 = {"All"}
    k5 = {}
    k6 = {}
    for k7, k8 in pairs(v1) do
        if categoryMatches(k7, k8) then
            if not v24 or v20.CollectionSubcategories then
                if k8.SubCategory and not k5[k8.SubCategory] then
                    k5[k8.SubCategory] = true
                    table.insert(v27, k8.SubCategory)
                end
            end
        end
    end

    table.sort(v27, function(a0, a1) --[[ Upvalues: Recents (upvalue) ]]
        if a0 == a1 then
            return false
        end

        if a0 == "All" then
            return true
        end

        if a1 == "All" then
            return false
        end

        local v31 = Recents.SubOrder[a0] or 999
        local v32 = Recents.SubOrder[a1] or 999
        if v31 ~= v32 or true >= a1 then
            v33 = v31 < v32
        end

        return v33
    end)
    if SubCategory ~= "All" and not k5[SubCategory] then
        SubCategory = "All"
    end

    for k9, k10 in pairs(v1) do
        if categoryMatches(k9, k10) then
            if SubCategory == "All" or k10.SubCategory == SubCategory then
                if v20.Search then
                    local v37 = string.lower(k9)
                    local v38 = a0.SearchQuery or ""
                    if not string.find(v37, v38, 1, true) then
                        -- jump to 201
                    end
                end

                local v39 = {Name = k9, Info = k10}
                table.insert(k6, v39)
            end
        end
    end

    table.sort(k6, function(a0, a1) --[[ Upvalues: Category (copy), t5 (copy), v20 (copy), UnlockedObjects (copy) ]]
        if Category == "Recent" then
            local v40 = t5[a0.Name]
            return v40 < t5[a1.Name]
        end

        if v20.LockedLast then
            local v42 = a0.Info.Unlock and not UnlockedObjects[a0.Name]
            local v44 = a1.Info.Unlock and not UnlockedObjects[a1.Name]
            local v45 = not not v42
            if v45 ~= not not v44 then
                return not v42
            end
        end

        local v46 = a0.Info.Price or 0
        local v47 = a1.Info.Price or 0
        if v20.NumericPrice then
            v46 = tonumber(v46) or 0
            v47 = tonumber(v47) or 0
        end

        if v46 ~= v47 or true >= a1.Name then
            v48 = v46 < v47
        end

        return v48
    end)
    local v49 = {
        Objects = k6,
        Subcategories = v27,
        SubCategory = SubCategory,
        Collection = v24,
        RecentRank = t5
    }
    return v49
end

Recents = {Categories = t4, SubOrder = t4, Query = Query}
local v50 = {Preferences = v4, Catalogue = Recents}
Query = Recents.Categories
if game:GetService("RunService"):IsServer() then
    return v50
end

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local GamepadService = game:GetService("GamepadService")
local v51 = require(ReplicatedStorage.Modules.PaintController)

local function make(a0, a1, a2)
    local v52 = Instance.new(a0)
    for k11, k12 in pairs(a1) do
        v52[k11] = k12
    end

    v52.Parent = a2
    return v52
end

local function clear(a0)
    local v56 = a0:GetChildren()
    for k13, k14 in ipairs(v56) do
        if k14:IsA("GuiObject") then
            k14:Destroy()
        end
    end
end

local function setText(a0, a1)
    if a0.Text ~= a1 then
        a0.Text = a1
    end
end

local t6 = {
    "EditObject",
    "EditingExistingObject",
    "EditExistingOriginalTransparency",
    "ObjectType",
    "BuildObjectPosition",
    "BuildObjectRotation",
    "BuildLastValidPosition",
    "BuildLastValidRotation",
    "BuildPlacementValid",
    "BuildInvalidReason",
    "BuildTransformDirty",
    "CurrentFrame",
    "EditObjectRotate",
    "EditObjectFlip",
    "EditObjectFlip2",
    "breathingNum"
}
local v60 = {5, 15, 30, 45, 90}
local v61 = {0.1, 0.25, 0.5, 1, 2, 4}

local function loadCataloguePreferences(a0) --[[ Upvalues: v4 (copy) ]]
    local Data = a0.Data
    if not Data then
        Data = {}
    end

    a0.Data = Data
    local v62 = a0.ModernBuildFavorites or a0.Data.ModernBuildFavorites
    a0.ModernBuildFavorites = v4.Favorites(v62)
    local v63 = a0.ModernBuildRecents or a0.Data.ModernBuildRecents
    a0.ModernBuildRecents = v4.Recents(v63)
    a0.Data.ModernBuildFavorites = table.clone(a0.ModernBuildFavorites)
    a0.Data.ModernBuildRecents = table.clone(a0.ModernBuildRecents)
end

local function rememberObject(a0, a1, a2) --[[ Upvalues: v4 (copy) ]]
    if not v4.IsValidName(a2) then
        return
    end

    if a0.ModernBuildRecents[1] == a2 then
        return
    end

    local v64 = table.clone(a0.ModernBuildRecents)
    for i1 = #v64, 1, -1 do
        if v64[i1] == a2 then
            table.remove(v64, i1)
        end
    end

    table.insert(v64, 1, a2)
    while v4.MAX_RECENTS < #v64 do
        table.remove(v64)
    end

    a0.ModernBuildRecents = v64
    a0.Data.ModernBuildRecents = table.clone(v64)
    a1:FireServer("RememberModernBuildObject", a2)
end

local function saveFavorites(a0, a1, a2) --[[ Upvalues: v4 (copy) ]]
    local ModernBuildFavorites2 = a0.ModernBuildFavorites
    local v67 = v4.Favorites(a2)
    a0.ModernBuildFavorites = v67
    a0.Data.ModernBuildFavorites = table.clone(v67)
    for k15 in pairs(ModernBuildFavorites2) do
        if not v67[k15] then
            a1:FireServer("ChangeModernBuildFavorite", k15, false)
        end
    end

    for k16 in pairs(v67) do
        if not ModernBuildFavorites2[k16] then
            a1:FireServer("ChangeModernBuildFavorite", k16, true)
        end
    end
end

local function invokeBuildAction(a0, a1, a2) --[[ Upvalues: ReplicatedStorage (copy) ]]
    local v75, v76 = pcall(function() --[[ Upvalues: a2 (copy), a0 (ref), ReplicatedStorage (upvalue), a1 (copy) ]]
        if a2 then
            a0 = ReplicatedStorage.Remotes.RemoteFunction
        end

        local v74 = a0:InvokeServer("ModernBuildAction", a1)
        return v74
    end)
    if v75 then
        if type(v76) == "table" then
            -- jump to 20
        end
    end

    return {ok = false, reason = "Connection interrupted. Please try again."}
    return v76
end

local function updateHistoryCounts(a0, a1)
    if type(a1.undo) == "number" then
        a0.UndoCount = a1.undo
    end

    if type(a1.redo) == "number" then
        a0.RedoCount = a1.redo
    end
end

local function getLegacyVisibility(a0, a1)
    if a0.Hidden[a1] ~= nil then
        return a0.Hidden[a1]
    end

    return a1.Visible
end

local function saveAndHide(a0, a1)
    if not (a1 and a1:IsA("GuiObject")) then
        return
    end

    if a0.Hidden[a1] == nil then
        a0.Hidden[a1] = a1.Visible
    end

    a1.Visible = false
end

local function restoreLegacyVisibility(a0, a1)
    local Client = a0.Client
    local v77 = "TransformPanel"
    local v78 = {"Toolbar", v77, "ViewPanel", "Hint"}
    for k17, k18 in ipairs(v78) do
        local v83 = Client.BuildGui and Client.BuildGui:FindFirstChild(k18)
        if v83 and a1[k18] ~= nil then
            a0.Hidden[v83] = a1[k18]
        end
    end

    if a1.BaseObjects ~= nil then
        a0.Hidden[Client.HUD.BaseObjects] = a1.BaseObjects
    end

    a0.Hidden[Client.HUD.PaintEditBar] = false
end

local function hideLegacyPresentation(a0)
    local Client1 = a0.Client
    local v84 = "BaseEdit"
    local v85 = {"BaseObjects", v84, "PaintEditBar", "MobileEdits", "MobileMouse", "Crosshair"}
    for k19, k20 in ipairs(v85) do
        local v89 = Client1.HUD:FindFirstChild(k20)
        a0:SaveAndHide(v89)
    end

    if Client1.BuildGui then
        k20 = "TransformPanel"
        local v90 = {
            "Toolbar",
            k20,
            "ViewPanel",
            "Hint",
            "ControllerHotkeys",
            "BuildSystemToggle",
            "MobileCameraControls",
            "MobileCameraContols"
        }
        for k21, k22 in ipairs(v90) do
            local v94 = Client1.BuildGui:FindFirstChild(k22)
            a0:SaveAndHide(v94)
        end
    end

    Client1:HideBuildGizmos()
end

local function center()
    return workspace.CurrentCamera.ViewportSize / 2
end

local function copyColors(a0, a1, a2) --[[ Upvalues: copyColors (copy) ]]
    if a0:IsA("BasePart") and a1:IsA("BasePart") then
        a1.Color = a0.Color
    end

    if a2 ~= false and a0:IsA("SurfaceAppearance") and a1:IsA("SurfaceAppearance") then
        a1.Color = a0.Color
    end

    local v95 = a1:GetChildren()
    local v96 = {}
    local v97 = a0:GetChildren()
    for k23, k24 in ipairs(v97) do
        for k25, k26 in ipairs(v95) do
            if not v96[k25] and k24.Name == k26.Name and k24.ClassName == k26.ClassName then
                v96[k25] = true
                copyColors(k24, k26, a2)
                break
            end
        end
    end
end

local function createThumbnail(a0, a1, a2, a3, a4, a5, a6, a7) --[[ Upvalues: ReplicatedStorage (copy) ]]
    local BaseObjects = ReplicatedStorage:FindFirstChild("BaseObjects")
    local v108 = BaseObjects and BaseObjects:FindFirstChild(a2)
    if a2 == "Turret" then
        if BaseObjects then
            local v110 = a0.Client.Data and a0.Client.Data.CurrentSkins
            if v110 then
                local v111 = tostring(v110.Turret or "")
                local v112 = BaseObjects:FindFirstChild("Turret" .. v111)
                if v112 then
                    -- jump to 43
                end
            end

            local v113 = v108
            v108 = v113
        end
    end

    if not v108 then
        return
    end

    local v114 = 230
    local v115 = {
        Name = "Preview",
        BackgroundTransparency = 1,
        LightDirection = Vector3.new(-1, -1, -1),
        Size = a3,
        Position = a4,
        Ambient = Color3.fromRGB(195, 205, 220),
        LightColor = Color3.fromRGB(255, 248, v114)
    }
    BaseObjects = Instance.new("ViewportFrame")
    for k27, k28 in pairs(v115) do
        BaseObjects[k27] = k28
    end

    BaseObjects.Parent = a1
    if a6 then
        BaseObjects.ZIndex = a6
    end

    if a7 and a7.Active ~= nil then
        BaseObjects.Active = a7.Active
    end

    local v119 = v108:Clone()
    if a7 and a7.AllowMissingClone and not v119 then
        BaseObjects:Destroy()
        return
    end

    local v120 = v119:GetDescendants()
    for k29, k30 in ipairs(v120) do
        if k30:IsA("LuaSourceContainer") or k30:IsA("Sound") or k30:IsA("ParticleEmitter") then
            k30:Destroy()
            -- jump to 151 (out of range)
        end

        if k30:IsA("BasePart") then
            k30.Anchored = true
        end
    end

    if not v119:IsA("Model") and not v119:IsA("BasePart") then
        v119:Destroy()
        BaseObjects:Destroy()
        return
    end

    local v124 = CFrame.new()
    v119:PivotTo(v124)
    v119.Parent = BaseObjects
    v108 = v119:GetDescendants()
    if v119:IsA("BasePart") then
        table.insert(v108, v119)
    end

    v119 = {}
    local v125 = Vector3.new(math.huge, math.huge, math.huge)
    local v126 = Vector3.new(-math.huge, -math.huge, -math.huge)
    local v131, v132
    for k31, k32 in ipairs(v108) do
        v131 = "BasePart"
        local v134
        if k32:IsA(v131) then
            v134 = 0.98
            if k32.Transparency < v134 then
                k32.LocalTransparencyModifier = 0
                local v135 = 1
                v134 = 2
                for i2 = -1, v135, v134 do
                    v132 = 1
                    for i3 = -1, v132, 2 do
                        for i4 = -1, 1, 2 do
                            local v139 = k32.CFrame:PointToWorldSpace(k32.Size * Vector3.new(i2, i3, i4) * 0.5)
                            local v140 = math.min(v125.X, v139.X)
                            local v141 = math.min(v125.Y, v139.Y)
                            v125 = Vector3.new(v140, v141, math.min(v125.Z, v139.Z))
                            local v142 = math.max(v126.X, v139.X)
                            local v143 = math.max(v126.Y, v139.Y)
                            v126 = Vector3.new(v142, v143, math.max(v126.Z, v139.Z))
                            table.insert(v119, v139)
                        end
                    end
                end
            end
        end
    end

    if #v119 == 0 then
        BaseObjects:Destroy()
        return
    end

    v108 = (v125 + v126) * 0.5
    local Unit = Vector3.new(1, 0.80000001192092896, -1.2999999523162842).Unit
    v125 = CFrame.lookAt(v108, v108 - Unit)
    local v144
    if not (a7 and a7.FixedAspect) then
    end

    local Camera = Instance.new("Camera")
    for k33, k34 in pairs({FieldOfView = 38}) do
        Camera[k33] = k34
    end

    Camera.Parent = BaseObjects
    local v149 = math.tan(math.rad(Camera.FieldOfView * 0.5))
    local v150 = v149 * v144
    v144 = 0.5
    for k35, k36 in ipairs(v119) do
        local v154 = v125:PointToObjectSpace(k36)
        local v155 = math.abs(v154.X) / v150
        v144 = math.max(v144, v154.Z + math.max(v155, math.abs(v154.Y) / v149) * 1.12 + 0.1)
    end

    local v156 = v108 + Unit * v144
    Camera.CFrame = CFrame.lookAt(v156, v108)
    BaseObjects.CurrentCamera = Camera
end

local v157 = {1, 5, 15, 30, 45, 90}
local v158 = {0.1, 0.25, 0.5, 1, 2, 5}
Recents.CreateThumbnail = createThumbnail
local v159 = {}
v159.__index = v159
local v160 = Color3.fromRGB(245, 245, 245)
local v161 = Color3.fromRGB(163, 163, 163)
local v162 = Color3.fromRGB(52, 55, 61)
local v163 = Color3.fromRGB(200, 65, 64)
local v164 = Color3.fromRGB(238, 142, 64)
local v165 = Color3.fromRGB(244, 211, 99)
local v166 = Color3.fromRGB(106, 165, 99)
local v167 = Color3.fromRGB(73, 156, 168)
local v168 = Color3.fromRGB(76, 126, 195)
local v169 = Color3.fromRGB(136, 102, 187)
local v170 = Color3.fromRGB(220, 137, 179)
local v171 = Color3.fromRGB(117, 86, 64)
local v172 = Color3.fromRGB(194, 169, 133)
local v174 = {
    v160,
    v161,
    v162,
    v163,
    v164,
    v165,
    v166,
    v167,
    v168,
    v169,
    v170,
    v171,
    v172,
    Color3.fromRGB(231, 217, 191)
}
local v175 = nil

local function outline(a0) --[[ Upvalues: v175 (copy) ]]
    a0.BorderColor3 = v175.Line
    a0.BorderSizePixel = 2
    a0.BorderMode = Enum.BorderMode.Inset
end

local function label(a0, a1, a2, a3, a4, a5) --[[ Upvalues: v175 (copy) ]]
    local t7 = {
        BackgroundTransparency = 1,
        Size = a2,
        Position = a3,
        Text = a1,
        TextSize = a4 or 20,
        Font = Enum.Font.Code
    }
    local v177 = a5 or v175.Text
    t7.TextColor3 = v177
    t7.TextXAlignment = Enum.TextXAlignment.Left
    t7.TextYAlignment = Enum.TextYAlignment.Center
    t7.TextTruncate = Enum.TextTruncate.AtEnd
    local TextLabel = Instance.new("TextLabel")
    for k37, k38 in pairs(t7) do
        TextLabel[k37] = k38
    end

    TextLabel.Parent = a0
    return TextLabel
end

local function sameValues(a0, a1)
    for k39, k40 in pairs(a0) do
        if a1[k39] ~= k40 then
            return false
        end
    end

    for k41, k42 in pairs(a1) do
        if a0[k41] ~= k42 then
            return false
        end
    end

    return true
end

local function amount(a0)
    local v187 = tonumber(a0) or 0
    local v188 = math.abs(v187)
    if v188 < 0.005 then
        v187 = 0
    end

    local v189 = string.format("%.2f", v187)
    local v190 = v189:gsub("(%..-)0+$", "%1")
    return v190:gsub("%.$", "")
end

local function keyName(a0, a1) --[[ Upvalues: UserInputService (copy) ]]
    local v192, v193 = pcall(function() --[[ Upvalues: UserInputService (upvalue), a0 (copy) ]]
        local v191 = UserInputService:GetStringForKeyCode(a0)
        return v191
    end)
    if not v192 then
        return a1
    end

    if type(v193) ~= "string" or v193 == "" then
        return a1
    end

    local v194 = ({ButtonCross = "Cross", ButtonCircle = "Circle", ButtonSquare = "Square", ButtonTriangle = "Triangle", ButtonLB = "LB", ButtonRB = "RB", ButtonLT = "LT", ButtonRT = "RT", ButtonL1 = "L1", ButtonR1 = "R1", ButtonL2 = "L2", ButtonR2 = "R2", ButtonL3 = "L3", ButtonR3 = "R3", ButtonA = "A", ButtonB = "B", ButtonX = "X", ButtonY = "Y"})[v193]
    if not v194 then
        local v196 = not string.match(v193, "^Button") and v193 or a1
    end

    return v194
end

local function _button(a0, a1, a2, a3, a4, a5, a6) --[[ Upvalues: v175 (copy) ]]
    local v197 = {
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        TextSize = 20,
        Selectable = true,
        Active = true,
        Name = a2,
        Text = a3,
        Size = a4,
        Position = a5,
        BackgroundColor3 = v175.Card,
        TextColor3 = v175.Text,
        Font = Enum.Font.Code
    }
    local TextButton = Instance.new("TextButton")
    for k43, k44 in pairs(v197) do
        TextButton[k43] = k44
    end

    TextButton.Parent = a1
    TextButton.BorderColor3 = v175.Line
    TextButton.BorderSizePixel = 2
    TextButton.BorderMode = Enum.BorderMode.Inset
    local v201 = TextButton:GetAttributeChangedSignal("CurrentTab")
    v201:Connect(function() --[[ Upvalues: TextButton (copy) ]]
        local v202 = TextButton
        local v203
        if TextButton:GetAttribute("CurrentTab") then
            v203 = 3
        else
            v203 = 2
        end

        v202.BorderSizePixel = v203
    end)
    local v204 = {
        Thickness = 3,
        Transparency = 1,
        Color = v175.Accent,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        LineJoinMode = Enum.LineJoinMode.Miter
    }
    local UIStroke = Instance.new("UIStroke")
    for k45, k46 in pairs(v204) do
        UIStroke[k45] = k46
    end

    UIStroke.Parent = TextButton
    TextButton.SelectionImageObject = a0.SelectionImage
    TextButton.SelectionGained:Connect(function() --[[ Upvalues: UIStroke (copy), TextButton (copy), v175 (upvalue), a0 (copy) ]]
        UIStroke.Transparency = 0
        TextButton.BackgroundColor3 = v175.Selected
        a0.LastFocus = TextButton
        a0:_scrollTo(TextButton)
        a0:_updateFavoriteHint(TextButton)
    end)
    TextButton.SelectionLost:Connect(function() --[[ Upvalues: UIStroke (copy), TextButton (copy), v175 (upvalue) ]]
        UIStroke.Transparency = 1
        local v208 = TextButton
        local v209
        if not (TextButton:GetAttribute("CurrentTab") and v175.Selected) then
            v209 = v175.Card
        end

        v208.BackgroundColor3 = v209
    end)
    TextButton.Activated:Connect(function() --[[ Upvalues: a0 (copy), a6 (copy) ]]
        if a0.Active and not a0.Obscured and a0.MenuOpen then
            a6()
        end

    end)
    return TextButton
end

local v210 = {
    {Name = "PaintBrush", Image = "rbxassetid://104826770606433"},
    {Name = "PaintBucket", Image = "rbxassetid://122698818539369"}
}
v175 = {
    Panel = Color3.new(0, 0, 0),
    Card = Color3.new(0, 0, 0),
    Selected = Color3.new(0, 0, 0),
    Accent = Color3.new(1, 1, 1),
    Text = Color3.new(1, 1, 1),
    Muted = Color3.fromRGB(200, 200, 200),
    Danger = Color3.fromRGB(255, 139, 139),
    Line = Color3.new(1, 1, 1),
    Good = Color3.new(1, 1, 1)
}
v159._button = _button

local function _scrollTo(a0, a1)
    local Parent = a1.Parent
    if not (Parent and Parent:IsA("ScrollingFrame")) then
        return
    end

    local v211 = a1.AbsolutePosition - Parent.AbsolutePosition
    local CanvasPosition = Parent.CanvasPosition
    local Scale = a0.MenuScale.Scale
    if Parent.ScrollingDirection == Enum.ScrollingDirection.X then
        local v212
        if not (v211.X < 0 and v211.X) then
            local v213 = v211.X + a1.AbsoluteSize.X
            local v214 = math.max(0, v213 - Parent.AbsoluteSize.X)
        end

        local v215 = math.max(0, CanvasPosition.X + v212 / Scale)
        Parent.CanvasPosition = Vector2.new(v215, CanvasPosition.Y)
        return
    end

    local v216
    if not (v211.Y < 0 and v211.Y) then
        local v217 = v211.Y + a1.AbsoluteSize.Y
        local v218 = math.max(0, v217 - Parent.AbsoluteSize.Y)
    end

    Parent.CanvasPosition = Vector2.new(CanvasPosition.X, math.max(0, CanvasPosition.Y + v216 / Scale))
end

v159._scrollTo = _scrollTo

local function _glyph(a0, a1, a2, a3, a4, a5, a6) --[[ Upvalues: UserInputService (copy), label (copy), keyName (copy), v175 (copy) ]]
    local v219 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(a6, 34),
        Position = UDim2.fromOffset(a5, 0)
    }
    local Frame = Instance.new("Frame")
    for k47, k48 in pairs(v219) do
        Frame[k47] = k48
    end

    Frame.Parent = a1
    local v224, v225 = pcall(function() --[[ Upvalues: UserInputService (upvalue), a2 (copy) ]]
        local v223 = UserInputService:GetImageForKeyCode(a2)
        return v223
    end)
    if v224 and v225 ~= "" then
        local v226 = {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(30, 30),
            Position = UDim2.fromOffset(0, 2),
            Image = v225
        }
        local ImageLabel = Instance.new("ImageLabel")
        for k49, k50 in pairs(v226) do
            ImageLabel[k49] = k50
        end

        ImageLabel.Parent = Frame
    else
        local v230 = keyName(a2, a3)
        local v231 = UDim2.fromOffset(36, 30)
        local v232 = UDim2.fromOffset(0, 2)
        local v233 = label(Frame, v230, v231, v232, 14, v175.Accent)
        v233.TextXAlignment = Enum.TextXAlignment.Center
    end

    local v234 = UDim2.fromOffset(a6 - 36, 34)
    local v235 = UDim2.fromOffset(36, 0)
    return label(Frame, a4, v234, v235, 17)
end

v159._glyph = _glyph

local function _createPaintTools(a0) --[[ Upvalues: label (copy), v175 (copy), v210 (copy) ]]
    local v236 = {
        Name = "PaintTools",
        BackgroundTransparency = 1,
        Visible = false,
        Size = UDim2.fromOffset(108, 48),
        Position = UDim2.fromOffset(24, 12)
    }
    local HUD = a0.HUD
    local Frame1 = Instance.new("Frame")
    for k51, k52 in pairs(v236) do
        Frame1[k51] = k52
    end

    Frame1.Parent = HUD
    a0.PaintTools = Frame1
    v236 = {
        Name = "CurrentPaintColor",
        BackgroundTransparency = 1,
        Visible = false,
        Size = UDim2.fromOffset(360, 48),
        Position = UDim2.fromOffset(696, 12)
    }
    local HUD1 = a0.HUD
    Frame1 = Instance.new("Frame")
    for k53, k54 in pairs(v236) do
        Frame1[k53] = k54
    end

    Frame1.Parent = HUD1
    a0.PaintColorIndicator = Frame1
    local v243 = UDim2.fromOffset(294, 22)
    local v244 = label(a0.PaintColorIndicator, "CURRENT COLOUR", v243, UDim2.new(), 16, v175.Muted)
    v244.TextXAlignment = Enum.TextXAlignment.Right
    local v245 = {
        Name = "Swatch",
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Active = false,
        Selectable = false,
        Size = UDim2.fromOffset(48, 48),
        Position = UDim2.fromOffset(312, 0),
        BackgroundColor3 = v175.Text
    }
    local PaintColorIndicator = a0.PaintColorIndicator
    local Frame2 = Instance.new("Frame")
    for k55, k56 in pairs(v245) do
        Frame2[k55] = k56
    end

    Frame2.Parent = PaintColorIndicator
    a0.PaintColorSwatch = Frame2
    Frame2 = {Thickness = 2, Color = v175.Accent, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}
    local PaintColorSwatch = a0.PaintColorSwatch
    v244 = Instance.new("UIStroke")
    for k57, k58 in pairs(Frame2) do
        v244[k57] = k58
    end

    v244.Parent = PaintColorSwatch
    a0.PaintToolIcons = {}
    local v252 = a0.Client.HUD and a0.Client.HUD:FindFirstChild("PaintEditBar")
    for k59, k60 in ipairs(v210) do
        local v259 = v252 and v252:FindFirstChild(k60.Name)
        local v260 = (k59 - 1) * 60
        local v261 = {
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Active = false,
            Selectable = false,
            Name = k60.Name,
            Image = k60.Image,
            Size = UDim2.fromOffset(48, 48),
            Position = UDim2.fromOffset(v260, 0),
            BackgroundColor3 = v175.Card,
            ImageColor3 = v175.Text
        }
        local PaintTools = a0.PaintTools
        local ImageLabel1 = Instance.new("ImageLabel")
        for k61, k62 in pairs(v261) do
            ImageLabel1[k61] = k62
        end

        ImageLabel1.Parent = PaintTools
        local v265
        if v259 then
            if v259:IsA("ImageLabel") or v259:IsA("ImageButton") then
                v265 = "ImageColor3"
                k61 = "ImageTransparency"
                k62 = "ImageRectOffset"
                local v266 = {
                    "Image",
                    v265,
                    k61,
                    k62,
                    "ImageRectSize",
                    "ScaleType",
                    "SliceCenter",
                    "SliceScale",
                    "ResampleMode"
                }
                for k63, k64 in ipairs(v266) do
                    k61 = v259[k64]
                    ImageLabel1[k64] = k61
                end
            end
        end

        v261 = {
            Thickness = 1,
            Color = v175.Accent,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }
        v259 = Instance.new("UIStroke")
        for k65, k66 in pairs(v261) do
            v259[k65] = k66
        end

        v259.Parent = ImageLabel1
        a0.PaintToolIcons[k60.Name] = ImageLabel1
    end
end

v159._createPaintTools = _createPaintTools

local function _updatePaintTools(a0, a1, a2)
    local itemName = a2.itemName
    if not a0.PaintToolIcons[itemName] then
        itemName = a2.paintTool
    end

    if not a0.PaintToolIcons[itemName] then
        itemName = "PaintBrush"
    end

    a0.PaintTools.Visible = a1
    a0.PaintColorIndicator.Visible = a1
    if typeof(a2.paintColor) == "Color3" then
        a0.PaintColorSwatch.BackgroundColor3 = a2.paintColor
    end

    for k67, k68 in pairs(a0.PaintToolIcons) do
        local v276 = k67 == itemName
        k68:SetAttribute("Selected", v276)
        local v277
        if v276 then
            v277 = 3
        else
            v277 = 1
        end

        k68.UIStroke.Thickness = v277
    end

    return itemName
end

v159._updatePaintTools = _updatePaintTools

local function new(a0, a1) --[[ Upvalues: v4 (copy), v159 (copy), v175 (copy), label (copy), Query (copy) ]]
    local v278 = {
        Active = false,
        MenuOpen = false,
        MenuKind = nil,
        Category = "Furniture",
        SubCategory = "All",
        Client = a0
    }
    local v279 = a1
    if not v279 then
        v279 = {}
    end

    v278.Callbacks = v279
    v278.Memory = {}
    v278.Connections = {}
    v278.State = {}
    v278.Cards = {}
    v278.ThumbnailItems = {}
    local v280 = a0.Data and a0.Data.ModernBuildFavorites
    v278.Favorites = v4.Favorites(v280)
    local v281 = a0.Data and a0.Data.ModernBuildRecents
    v278.Recents = v4.Recents(v281)
    v278.SubButtons = {}
    v278.CategoryButtons = {}
    v278.PaletteColor = Color3.new(1, 1, 1)
    local v282 = setmetatable(v278, v159)
    local v283 = {
        Name = "ModernBuildControllerUI",
        Enabled = false,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 40,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }
    local PlayerGui = a0.Player:WaitForChild("PlayerGui")
    v278 = Instance.new("ScreenGui")
    for k69, k70 in pairs(v283) do
        v278[k69] = k70
    end

    v278.Parent = PlayerGui
    v282.Gui = v278
    v283 = {Name = "Root", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)}
    local Gui = v282.Gui
    v278 = Instance.new("Frame")
    for k71, k72 in pairs(v283) do
        v278[k71] = k72
    end

    v278.Parent = Gui
    v282.Root = v278
    v283 = {Name = "SelectionOutline", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)}
    local Gui1 = v282.Gui
    v278 = Instance.new("Frame")
    for k73, k74 in pairs(v283) do
        v278[k73] = k74
    end

    v278.Parent = Gui1
    v282.SelectionImage = v278
    v283 = {
        Name = "Aim",
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(7, 7),
        BackgroundColor3 = v175.Text
    }
    local Root = v282.Root
    v278 = Instance.new("Frame")
    for k75, k76 in pairs(v283) do
        v278[k75] = k76
    end

    v278.Parent = Root
    v282.Reticle = v278
    v278 = {Thickness = 2, Color = v175.Panel, LineJoinMode = Enum.LineJoinMode.Miter}
    local Reticle = v282.Reticle
    local UIStroke1 = Instance.new("UIStroke")
    for k77, k78 in pairs(v278) do
        UIStroke1[k77] = k78
    end

    UIStroke1.Parent = Reticle
    Reticle = {
        Name = "ModeAndCapacity",
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.04, 0.04),
        Size = UDim2.fromOffset(390, 72),
        BackgroundColor3 = v175.Panel
    }
    local Root1 = v282.Root
    v278 = Instance.new("Frame")
    for k79, k80 in pairs(Reticle) do
        v278[k79] = k80
    end

    v278.Parent = Root1
    v282.Top = v278
    v278 = v282.Top
    v278.BorderColor3 = v175.Line
    v278.BorderSizePixel = 2
    v278.BorderMode = Enum.BorderMode.Inset
    Root1 = v282.Top
    v278 = Instance.new("UIScale")
    for k81, k82 in pairs({Scale = 1}) do
        v278[k81] = k82
    end

    v278.Parent = Root1
    v282.TopScale = v278
    local v305 = UDim2.fromOffset(354, 30)
    local v306 = UDim2.fromOffset(18, 7)
    v282.ModeLabel = label(v282.Top, "MODERN  /  BUILD", v305, v306, 21, v175.Accent)
    local v307 = UDim2.fromOffset(354, 26)
    local v308 = UDim2.fromOffset(18, 38)
    v282.CapacityLabel = label(v282.Top, "", v307, v308, 17, v175.Muted)
    local v309 = 0
    local v310 = {
        Name = "BuildHints",
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 0.96, v309),
        Size = UDim2.fromOffset(1080, 140),
        BackgroundColor3 = v175.Panel
    }
    local Root2 = v282.Root
    local Frame3 = Instance.new("Frame")
    for k83, k84 in pairs(v310) do
        Frame3[k83] = k84
    end

    Frame3.Parent = Root2
    v282.HUD = Frame3
    Frame3 = v282.HUD
    Frame3.BorderColor3 = v175.Line
    Frame3.BorderSizePixel = 2
    Frame3.BorderMode = Enum.BorderMode.Inset
    Root2 = v282.HUD
    Frame3 = Instance.new("UIScale")
    for k85, k86 in pairs({Scale = 1}) do
        Frame3[k85] = k86
    end

    Frame3.Parent = Root2
    v282.HUDScale = Frame3
    local v317 = UDim2.fromOffset(610, 30)
    local v318 = UDim2.fromOffset(24, 9)
    v282.ItemLabel = label(v282.HUD, "Choose an object", v317, v318, 22)
    local v319 = UDim2.fromOffset(412, 30)
    local v320 = UDim2.fromOffset(644, 9)
    v282.AxisLabel = label(v282.HUD, "", v319, v320, 18, v175.Accent)
    v282.AxisLabel.TextXAlignment = Enum.TextXAlignment.Right
    v282:_createPaintTools()
    local v321 = UDim2.fromOffset(1032, 25)
    local v322 = UDim2.fromOffset(24, 39)
    local Muted = v175.Muted
    v282.StatusLabel = label(v282.HUD, "", v321, v322, 17, Muted)
    local v323 = {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(24, 69),
        Size = UDim2.fromOffset(1032, 34)
    }
    local HUD3 = v282.HUD
    local Frame4 = Instance.new("Frame")
    for k87, k88 in pairs(v323) do
        Frame4[k87] = k88
    end

    Frame4.Parent = HUD3
    v282.HintRow = Frame4
    Frame4 = v282.HintRow
    v282.ActionHint = v282:_glyph(Frame4, Enum.KeyCode.ButtonA, "A", "Pick object", 0, 174)
    v282.RotateHint = v282:_glyph(Frame4, Enum.KeyCode.ButtonR2, "RT", "Rotate +", 174, 174)
    v282.PrecisionHint = v282:_glyph(Frame4, Enum.KeyCode.ButtonX, "X", "Precision", 348, 170)
    v282.MenuHint = v282:_glyph(Frame4, Enum.KeyCode.ButtonY, "Y", "Catalogue", 518, 180)
    v282.CameraHint = v282:_glyph(Frame4, Enum.KeyCode.ButtonL2, "LT", "Slow camera", 698, 196)
    local v327 = 894
    local v328 = 138
    v282.BackHint = v282:_glyph(Frame4, Enum.KeyCode.ButtonB, "B", "Options", v327, v328)
    local v329 = {
        Name = "QuickAdjust",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(24, 109),
        Size = UDim2.fromOffset(1032, 46)
    }
    local HUD4 = v282.HUD
    local Frame5 = Instance.new("Frame")
    for k89, k90 in pairs(v329) do
        Frame5[k89] = k90
    end

    Frame5.Parent = HUD4
    v282.QuickAdjustRow = Frame5
    local v333 = UDim2.fromOffset(450, 42)
    v282.QuickGridHint = label(v282.QuickAdjustRow, "", v333, UDim2.new(), 16, v175.Accent)
    v282.QuickGridHint.TextWrapped = true
    v282.QuickGridHint.TextTruncate = Enum.TextTruncate.None
    v282.QuickMoveHint = v282:_glyph(v282.QuickAdjustRow, Enum.KeyCode.ButtonL3, "L3", "", 462, 282)
    local v334 = 276
    v282.FollowHint = v282:_glyph(v282.QuickAdjustRow, Enum.KeyCode.ButtonR3, "R3", "Keep here", 756, v334)
    v282.QuickMoveHint.Parent.Size = UDim2.fromOffset(282, 46)
    v282.QuickMoveHint.Size = UDim2.fromOffset(246, 22)
    local v335 = UDim2.fromOffset(246, 20)
    local v336 = UDim2.fromOffset(36, 25)
    v282.QuickMoveKeysHint = label(v282.QuickMoveHint.Parent, "", v335, v336, 15, v175.Muted)
    v282.FollowHint.Parent.Size = UDim2.fromOffset(276, 46)
    v282.FollowHint.Size = UDim2.fromOffset(240, 22)
    v282.FollowHint.TextColor3 = v175.Accent
    local v337 = UDim2.fromOffset(240, 20)
    local v338 = UDim2.fromOffset(36, 25)
    v282.QuickRotateKeysHint = label(v282.FollowHint.Parent, "", v337, v338, 15, v175.Muted)
    local v339 = UDim2.fromOffset(1032, 24)
    local v340 = UDim2.fromOffset(24, 149)
    local Muted1 = v175.Muted
    v282.SecondaryLabel = label(v282.HUD, "", v339, v340, 16, Muted1)
    local v341 = {
        Name = "MenuOverlay",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        Active = true,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new()
    }
    local Root3 = v282.Root
    local Frame6 = Instance.new("Frame")
    for k91, k92 in pairs(v341) do
        Frame6[k91] = k92
    end

    Frame6.Parent = Root3
    v282.Dimmer = Frame6
    v341 = {
        Name = "Menu",
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        SelectionGroup = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(1000, 640),
        BackgroundColor3 = v175.Panel,
        SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
        SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
        SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
        SelectionBehaviorRight = Enum.SelectionBehavior.Stop
    }
    local Dimmer = v282.Dimmer
    Frame6 = Instance.new("Frame")
    for k93, k94 in pairs(v341) do
        Frame6[k93] = k94
    end

    Frame6.Parent = Dimmer
    v282.Menu = Frame6
    Frame6 = v282.Menu
    Frame6.BorderColor3 = v175.Line
    Frame6.BorderSizePixel = 2
    Frame6.BorderMode = Enum.BorderMode.Inset
    Dimmer = v282.Menu
    Frame6 = Instance.new("UIScale")
    for k95, k96 in pairs({Scale = 1}) do
        Frame6[k95] = k96
    end

    Frame6.Parent = Dimmer
    v282.MenuScale = Frame6
    local v351 = UDim2.fromOffset(790, 34)
    local v352 = UDim2.fromOffset(26, 19)
    v282.Title = label(v282.Menu, "OBJECT CATALOGUE", v351, v352, 27)
    local v353 = UDim2.fromOffset(800, 25)
    local v354 = UDim2.fromOffset(26, 54)
    v282.Subtitle = label(v282.Menu, "Choose an object, then keep moving while you build.", v353, v354, 17, v175.Muted)
    local v355 = UDim2.fromOffset(110, 44)
    local v356 = UDim2.fromOffset(864, 24)
    v282.CloseButton = v282:_button(v282.Menu, "Close", "Close", v355, v356, function() --[[ Upvalues: v282 (copy) ]]
        if v282.Callbacks.Close then
            v282.Callbacks.Close()
            return
        end

        v282:CloseMenu()
    end)
    local v357 = UDim2.fromOffset(150, 44)
    local v358 = UDim2.fromOffset(704, 24)

    local function v359() --[[ Upvalues: v282 (copy) ]]
        if v282.Callbacks.Option then
            v282.Callbacks.Option("PaintMode")
        end
    end

    v282.PaintModeButton = v282:_button(v282.Menu, "PaintMode", "Paint mode", v357, v358, v359)
    local v360 = {
        Name = "Catalogue",
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(948, 500),
        Position = UDim2.fromOffset(26, 92)
    }
    local Menu = v282.Menu
    local Frame7 = Instance.new("Frame")
    for k97, k98 in pairs(v360) do
        Frame7[k97] = k98
    end

    Frame7.Parent = Menu
    v282.Catalogue = Frame7
    for k99, k100 in ipairs(Query) do
        local v367 = UDim2.fromOffset(180, 42)
        local v368 = (k99 - 1) * 192
        local v369 = UDim2.fromOffset(v368, 0)
        local v370 = v282:_button(v282.Catalogue, k100, k100, v367, v369, function() --[[ Upvalues: v282 (copy), k100 (copy) ]]
            v282:_selectCategory(k100)
        end)
        v282.CategoryButtons[k99] = v370
    end

    local v371 = {
        Name = "Subcategories",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        Position = UDim2.fromOffset(0, 52),
        Size = UDim2.fromOffset(948, 46),
        ScrollingDirection = Enum.ScrollingDirection.X,
        ScrollBarImageColor3 = v175.Accent,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.X
    }
    local Catalogue = v282.Catalogue
    local ScrollingFrame = Instance.new("ScrollingFrame")
    for k101, k102 in pairs(v371) do
        ScrollingFrame[k101] = k102
    end

    ScrollingFrame.Parent = Catalogue
    v282.SubList = ScrollingFrame
    ScrollingFrame = {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }
    local SubList = v282.SubList
    Frame4 = Instance.new("UIListLayout")
    for k103, k104 in pairs(ScrollingFrame) do
        Frame4[k103] = k104
    end

    Frame4.Parent = SubList
    SubList = {
        Name = "Items",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 5,
        Position = UDim2.fromOffset(0, 108),
        Size = UDim2.fromOffset(948, 388),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarImageColor3 = v175.Accent,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    }
    local Catalogue1 = v282.Catalogue
    ScrollingFrame = Instance.new("ScrollingFrame")
    for k105, k106 in pairs(SubList) do
        ScrollingFrame[k105] = k106
    end

    ScrollingFrame.Parent = Catalogue1
    v282.ItemList = ScrollingFrame
    ScrollingFrame = {
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 4)
    }
    local ItemList = v282.ItemList
    local UIPadding = Instance.new("UIPadding")
    for k107, k108 in pairs(ScrollingFrame) do
        UIPadding[k107] = k108
    end

    UIPadding.Parent = ItemList
    ScrollingFrame = {
        FillDirectionMaxCells = 4,
        CellSize = UDim2.fromOffset(225, 174),
        CellPadding = UDim2.fromOffset(10, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }
    local ItemList1 = v282.ItemList
    local UIGridLayout = Instance.new("UIGridLayout")
    for k109, k110 in pairs(ScrollingFrame) do
        UIGridLayout[k109] = k110
    end

    UIGridLayout.Parent = ItemList1
    local v387 = UDim2.fromOffset(900, 60)
    local v388 = UDim2.fromOffset(24, 190)
    local Muted2 = v175.Muted
    v282.Empty = label(v282.Catalogue, "No unlocked objects in this category.", v387, v388, 22, Muted2)
    v282.Empty.Visible = false
    local v389 = {
        Name = "Options",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 5,
        Visible = false,
        Position = UDim2.fromOffset(26, 100),
        Size = UDim2.fromOffset(948, 482),
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y
    }
    local Menu1 = v282.Menu
    local ScrollingFrame1 = Instance.new("ScrollingFrame")
    for k111, k112 in pairs(v389) do
        ScrollingFrame1[k111] = k112
    end

    ScrollingFrame1.Parent = Menu1
    v282.Options = ScrollingFrame1
    ScrollingFrame1 = {
        PaddingTop = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 5)
    }
    local Options = v282.Options
    local UIPadding1 = Instance.new("UIPadding")
    for k113, k114 in pairs(ScrollingFrame1) do
        UIPadding1[k113] = k114
    end

    UIPadding1.Parent = Options
    ScrollingFrame1 = {
        FillDirectionMaxCells = 2,
        CellSize = UDim2.fromOffset(460, 78),
        CellPadding = UDim2.fromOffset(14, 14),
        SortOrder = Enum.SortOrder.LayoutOrder
    }
    local Options1 = v282.Options
    local UIGridLayout1 = Instance.new("UIGridLayout")
    for k115, k116 in pairs(ScrollingFrame1) do
        UIGridLayout1[k115] = k116
    end

    UIGridLayout1.Parent = Options1
    Options1 = {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(26, 601),
        Size = UDim2.fromOffset(948, 30)
    }
    local Menu2 = v282.Menu
    ScrollingFrame1 = Instance.new("Frame")
    for k117, k118 in pairs(Options1) do
        ScrollingFrame1[k117] = k118
    end

    ScrollingFrame1.Parent = Menu2
    v282.MenuHints = ScrollingFrame1
    v282.MenuSelectHint = v282:_glyph(v282.MenuHints, Enum.KeyCode.ButtonA, "A", "Select", 0, 170)
    v282.MenuBackHint = v282:_glyph(v282.MenuHints, Enum.KeyCode.ButtonB, "B", "Back", 160, 200)
    v282.FavoriteHint = v282:_glyph(v282.MenuHints, Enum.KeyCode.ButtonX, "X", "Favorite", 360, 180)
    v282.CategoryLeftHint = v282:_glyph(v282.MenuHints, Enum.KeyCode.ButtonL1, "LB", "Category \226\136\146", 540, 196)
    local v402 = 744
    local v403 = 204
    v282.CategoryRightHint = v282:_glyph(v282.MenuHints, Enum.KeyCode.ButtonR1, "RB", "Category +", v402, v403)
    v282:_createPrecision()
    local v404 = {
        Name = "Palette",
        BackgroundTransparency = 1,
        Visible = false,
        Size = UDim2.fromOffset(948, 490),
        Position = UDim2.fromOffset(26, 100)
    }
    local Menu3 = v282.Menu
    local Frame8 = Instance.new("Frame")
    for k119, k120 in pairs(v404) do
        Frame8[k119] = k120
    end

    Frame8.Parent = Menu3
    v282.Palette = Frame8
    v282:_resize()
    local v408 = v282.Root:GetPropertyChangedSignal("AbsoluteSize")
    local v409 = v408:Connect(function() --[[ Upvalues: v282 (copy) ]]
        v282:_resize()
    end)
    table.insert(v282.Connections, v409)
    local v410 = v282.ItemList:GetPropertyChangedSignal("CanvasPosition")
    local v411 = v410:Connect(function() --[[ Upvalues: v282 (copy) ]]
        v282:_queueThumbnails()
    end)
    table.insert(v282.Connections, v411)
    return v282
end

v159.new = new

local function _resize(a0)
    local AbsoluteSize = a0.Root.AbsoluteSize
    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return
    end

    local MenuScale = a0.MenuScale
    if a0.MenuKind == "Precision" then
        local v412 = AbsoluteSize.X * 0.34 / 350
        local v413 = AbsoluteSize.Y * 0.9 / 640
        local v414 = math.min(v412, v413, 1.1)
        if v414 then
            -- jump to 51
        end
    end

    local v415 = AbsoluteSize.X * 0.9 / 1000
    local v416 = AbsoluteSize.Y * 0.84 / 640
    local v417 = math.min(v415, v416, 1.35)
    MenuScale.Scale = v417
    v415 = AbsoluteSize.X * 0.92 / 1080
    local v418 = AbsoluteSize.Y / 720
    a0.HUDScale.Scale = math.min(v415, v418, 1.35)
    a0.TopScale.Scale = a0.HUDScale.Scale
    a0:_queueThumbnails()
end

v159._resize = _resize

local function Owns(a0, a1)
    local v419 = false
    if a1 ~= nil then
        local v420 = a1:IsDescendantOf(a0.Gui)
    end

    return v419
end

v159.Owns = Owns

local function _remember(a0) --[[ Upvalues: GuiService (copy) ]]
    if a0.MenuKind ~= "Catalogue" then
        return
    end

    local v421 = a0.Category .. "/" .. a0.SubCategory
    local SelectedObject = GuiService.SelectedObject
    local v422 = a0.Memory[v421]
    if not v422 then
        v422 = {}
    end

    local Memory = a0.Memory
    local t8 = {}
    local v424 = a0:Owns(SelectedObject) and SelectedObject:GetAttribute("ItemName") or v422.Item
    t8.Item = v424
    t8.Scroll = a0.ItemList.CanvasPosition
    t8.SubScroll = a0.SubList.CanvasPosition
    Memory[v421] = t8
end

v159._remember = _remember

local function _selectCategory(a0, a1)
    a0:_remember()
    a0.Category = a1
    a0.SubCategory = a0.Memory[a1 .. "/SubCategory"] or "All"
    a0:RefreshCatalogue()
    if a0.Callbacks.CategoryChanged then
        a0.Callbacks.CategoryChanged(a1)
    end
end

v159._selectCategory = _selectCategory

local function _updateFavoriteHint(a0, a1) --[[ Upvalues: v175 (copy) ]]
    if not a0.FavoriteHint then
        return
    end

    local v427 = a1 and a1:GetAttribute("ItemName")
    local FavoriteHint = a0.FavoriteHint
    local v428
    if v427 and a0.Favorites[v427] then
        v428 = "Unfavorite"
    else
        v428 = "Favorite"
    end

    if FavoriteHint.Text ~= v428 then
        FavoriteHint.Text = v428
    end

    local v429
    if not (v427 and v175.Text) then
        v429 = v175.Muted
    end

    a0.FavoriteHint.TextColor3 = v429
end

v159._updateFavoriteHint = _updateFavoriteHint

local function ToggleFocusedFavorite(a0) --[[ Upvalues: GuiService (copy), v4 (copy) ]]
    if not a0.Active or a0.Obscured or not a0.MenuOpen or a0.MenuKind ~= "Catalogue" then
        return false
    end

    local SelectedObject1 = GuiService.SelectedObject
    if not SelectedObject1 or SelectedObject1.Parent ~= a0.ItemList then
        return false
    end

    local v430 = SelectedObject1:GetAttribute("ItemName")
    if not v4.IsValidName(v430) then
        return false
    end

    a0.Favorites[v430] = not a0.Favorites[v430] or nil
    if a0.Callbacks.FavoritesChanged then
        local v431 = table.clone(a0.Favorites)
        a0.Callbacks.FavoritesChanged(v431)
    end

    if a0.Category == "Favorites" then
        a0:RefreshCatalogue()
    else
        local Favorite = SelectedObject1:FindFirstChild("Favorite")
        if Favorite then
            local v432
            if a0.Favorites[v430] then
                v432 = "\226\152\133"
            else
                v432 = "\226\152\134"
            end

            if Favorite.Text ~= v432 then
                Favorite.Text = v432
            end
        end

        a0:_updateFavoriteHint(SelectedObject1)
    end

    return true
end

v159.ToggleFocusedFavorite = ToggleFocusedFavorite

local function _thumbnail(a0, a1, a2, a3) --[[ Upvalues: createThumbnail (copy) ]]
    local v433 = UDim2.new(1, -16, 0, 100)
    local v434 = UDim2.fromOffset(8, 4)
    createThumbnail(a0, a1, a2, v433, v434, 2.09)
end

v159._thumbnail = _thumbnail

local function _queueThumbnails(a0)
    a0.ThumbnailRequest = (a0.ThumbnailRequest or 0) + 1
    if not a0.Active or not a0.MenuOpen or a0.MenuKind ~= "Catalogue" then
        return
    end

    local CatalogueGeneration = a0.CatalogueGeneration
    local ThumbnailRequest = a0.ThumbnailRequest
    task.defer(function() --[[ Upvalues: a0 (copy), CatalogueGeneration (copy), ThumbnailRequest (copy) ]]

        local function current() --[[ Upvalues: a0 (upvalue), CatalogueGeneration (upvalue), ThumbnailRequest (upvalue) ]]
            local v435 = not a0.Destroyed
            if v435 then
                local Active = a0.Active
                if Active then
                    local MenuOpen = a0.MenuOpen
                    if MenuOpen then
                        MenuOpen = false
                        if a0.MenuKind == "Catalogue" then
                            MenuOpen = false
                            if a0.CatalogueGeneration == CatalogueGeneration then
                                MenuOpen = a0.ThumbnailRequest == ThumbnailRequest
                            end
                        end
                    end
                end
            end

            return v435
        end

        local v436 = not a0.Destroyed
        if v436 then
            local Active1 = a0.Active
            if Active1 then
                local MenuOpen1 = a0.MenuOpen
                if MenuOpen1 then
                    MenuOpen1 = false
                    if a0.MenuKind == "Catalogue" then
                        MenuOpen1 = false
                        if a0.CatalogueGeneration == CatalogueGeneration then
                            MenuOpen1 = a0.ThumbnailRequest == ThumbnailRequest
                        end
                    end
                end
            end
        end

        if not v436 then
            return
        end

        local Y1 = a0.ItemList.CanvasPosition.Y
        local v437 = a0.ItemList.AbsoluteSize.Y / a0.MenuScale.Scale
        local v438 = math.max(0, math.floor(Y1 / 184) - 1)
        local v439 = Y1 + v437
        local v440 = math.floor((v439 - 1) / 184) + 1
        v437 = {}
        for k121, k122 in ipairs(a0.Cards) do
            Y1 = a0.ThumbnailItems[k122]
            local v444 = math.floor((k121 - 1) / 4)
            if Y1 then
                if v438 <= v444 then
                    if v444 <= v440 then
                        if not Y1.Loaded then
                            if not Y1.Failed then
                                table.insert(v437, k122)
                                -- branch continues at 135
                            end

                            -- branch continues at 135
                        end

                        -- branch continues at 119
                    end
                else
                    if Y1.Loaded then
                        local Preview = k122:FindFirstChild("Preview")
                        if Preview then
                            Preview:Destroy()
                        end

                        Y1.Loaded = nil
                    end
                end
            end
        end

        for k123, k124 in ipairs(v437) do
            local v448 = not a0.Destroyed
            if v448 then
                local Active2 = a0.Active
                if Active2 then
                    local MenuOpen2 = a0.MenuOpen
                    if MenuOpen2 then
                        MenuOpen2 = false
                        if a0.MenuKind == "Catalogue" then
                            MenuOpen2 = false
                            if a0.CatalogueGeneration == CatalogueGeneration then
                                MenuOpen2 = a0.ThumbnailRequest == ThumbnailRequest
                            end
                        end
                    end
                end
            end

            if not v448 then
                return
            end

            v440 = a0.ThumbnailItems[k124]
            if v440 and k124.Parent and not v440.Loaded then
                v438 = pcall(function() --[[ Upvalues: a0 (upvalue), k124 (copy), v440 (copy) ]]
                    a0:_thumbnail(k124, v440.Name, v440.Info)
                end)
                if not v438 then
                    local Preview2 = k124:FindFirstChild("Preview")
                    if Preview2 then
                        Preview2:Destroy()
                    end
                end

                local v449 = v438
                if v449 then
                    v449 = k124:FindFirstChild("Preview") ~= nil
                end

                v440.Loaded = v449
                v440.Failed = not v440.Loaded
            end

            if k123 % 2 == 0 then
                task.wait()
            end
        end

    end)
end

v159._queueThumbnails = _queueThumbnails

local function RefreshCatalogue(a0) --[[ Upvalues: GuiService (copy), clear (copy), Recents (copy), Query (copy), v175 (copy), label (copy), keyName (copy) ]]
    if not (a0.MenuKind == "Catalogue" and a0.MenuOpen) then
        return
    end

    a0.CatalogueGeneration = (a0.CatalogueGeneration or 0) + 1
    if a0.RenderedCategory == a0.Category and a0.RenderedSubCategory == a0.SubCategory then
        a0:_remember()
    end

    local v450 = a0.Memory[a0.Category .. "/" .. a0.SubCategory]
    if not v450 then
        v450 = {}
    end

    if a0:Owns(GuiService.SelectedObject) then
        GuiService.SelectedObject = nil
    end

    clear(a0.SubList)
    clear(a0.ItemList)
    a0.Cards = {}
    a0.SubButtons = {}
    a0.ThumbnailItems = {}
    local Data3 = a0.Client.Data
    if not Data3 then
        Data3 = {}
    end

    local BaseItems1 = Data3.BaseItems
    if not BaseItems1 then
        BaseItems1 = {}
    end

    local v451 = {
        Policy = "Controller",
        Data = Data3,
        Category = a0.Category,
        SubCategory = a0.SubCategory,
        SearchQuery = a0.SearchQuery,
        Favorites = a0.Favorites,
        Recents = a0.Recents
    }
    local v452 = Recents.Query(v451)
    v451 = v452.Subcategories
    local Objects = v452.Objects
    a0.SubCategory = v452.SubCategory
    local Collection = v452.Collection
    a0.SubList.Visible = not Collection
    local ItemList2 = a0.ItemList
    local v453
    if Collection then
        v453 = 56
    else
        v453 = 108
    end

    ItemList2.Position = UDim2.fromOffset(0, v453)
    ItemList2 = a0.ItemList
    if Collection then
        v453 = 440
    else
        v453 = 388
    end

    ItemList2.Size = UDim2.fromOffset(948, v453)
    for k125, k126 in ipairs(Query) do
        v452 = a0.CategoryButtons[k125]
        v452:SetAttribute("CurrentTab", k126 == a0.Category)
        local v457
        if not (k126 == a0.Category and v175.Selected) then
            v457 = v175.Card
        end

        v452.BackgroundColor3 = v457
        local v458
        if not (k126 == a0.Category and v175.Accent) then
            v458 = v175.Text
        end

        v452.TextColor3 = v458
    end

    if Collection then
        local v459 = {}
        if v459 then
            -- jump to 212
        end
    end

    local v460 = v451
    for k127, k128 in ipairs(v460) do
        local v464 = math.max(90, #k128 * 11 + 24)
        local v465 = UDim2.fromOffset(v464, 37)
        local v467 = a0:_button(a0.SubList, k128, k128, v465, UDim2.new(), function() --[[ Upvalues: a0 (copy), k128 (copy) ]]
            a0:_remember()
            a0.SubCategory = k128
            local v466 = a0.Category .. "/SubCategory"
            a0.Memory[v466] = k128
            a0:RefreshCatalogue()
        end)
        v467.LayoutOrder = k127
        v467.TextSize = 17
        v467:SetAttribute("CurrentTab", k128 == a0.SubCategory)
        local v468
        if not (k128 == a0.SubCategory and v175.Selected) then
            v468 = v175.Card
        end

        v467.BackgroundColor3 = v468
        local v469
        if not (k128 == a0.SubCategory and v175.Accent) then
            v469 = v175.Text
        end

        v467.TextColor3 = v469
        table.insert(a0.SubButtons, v467)
    end

    a0.DefaultFocus = nil
    for k129, k130 in ipairs(Objects) do
        local Name = k130.Name
        local Info = k130.Info
        Collection = tonumber(BaseItems1[Name]) or 0
        v451 = not Info.ItemObject
        if not v451 then
            v451 = 0 < Collection
        end

        local v473 = UDim2.fromOffset(225, 174)
        local v474 = a0:_button(a0.ItemList, Name, "", v473, UDim2.new(), function() --[[ Upvalues: v451 (copy), a0 (copy), Name (copy), Info (copy) ]]
            if not v451 then
                local Subtitle = a0.Subtitle
                if Subtitle.Text ~= "This object needs an item in your inventory." then
                    Subtitle.Text = "This object needs an item in your inventory."
                end

                return
            end

            a0:_remember()
            if a0.Callbacks.SelectItem then
                a0.Callbacks.SelectItem(Name, Info.Type)
            end

        end)
        v474.LayoutOrder = k129
        v474:SetAttribute("ItemName", Name)
        local v475 = label
        local v476
        if a0.Favorites[Name] then
            v476 = "\226\152\133"
        else
            v476 = "\226\152\134"
        end

        local v477 = UDim2.fromOffset(32, 32)
        local v478 = UDim2.fromOffset(184, 5)
        local v479 = v475(v474, v476, v477, v478, 25)
        v479.Name = "Favorite"
        v479.ZIndex = 2
        v479.TextXAlignment = Enum.TextXAlignment.Center
        local v480 = UDim2.new(1, -20, 0, 39)
        local v481 = UDim2.fromOffset(10, 101)
        local v482 = label(v474, Name, v480, v481, 18)
        v482.TextWrapped = true
        v482.TextTruncate = Enum.TextTruncate.None
        v482 = Info.ItemObject
        if not v482 then
            local v483 = tonumber(Data3.Money) or 0
            v482 = (tonumber(Info.Price) or 0) <= v483
        end

        local v484
        if Info.ItemObject then
            if 0 < Collection then
                v484 = "Owned \195\151" .. Collection
                if v484 then
                    -- jump to 458
                end
            end

            v484 = "None owned"
        else
            v484 = "$" .. tostring(Info.Price or 0)
        end

        if not v482 then
            v484 = v484 .. " \194\183 Need funds"
        end

        v476 = label
        local v485 = UDim2.new(1, -20, 0, 24)
        local v486 = UDim2.fromOffset(10, 142)
        local v487
        if not (v451 and v482 and v175.Accent) then
            v487 = v175.Danger
        end

        v476(v474, v484, v485, v486, 17, v487)
        local v488 = {Name = Name, Info = Info}
        a0.ThumbnailItems[v474] = v488
        table.insert(a0.Cards, v474)
        if Name == v450.Item then
            a0.DefaultFocus = v474
        end
    end

    local Empty = a0.Empty
    local v489
    if a0.Category == "Recent" then
        v489 = "Objects you use will appear here."
    else
        local v490 = keyName(Enum.KeyCode.ButtonX, "X")
        v489 = "Highlight an object and press " .. v490 .. " to favorite it."
    end

    if Empty.Text ~= v489 then
        Empty.Text = v489
    end

    a0.Empty.Visible = #a0.Cards == 0
    a0.RenderedCategory = a0.Category
    a0.RenderedSubCategory = a0.SubCategory
    local DefaultFocus = a0.DefaultFocus
    if not DefaultFocus then
        DefaultFocus = a0.Cards[1]
        if not DefaultFocus then
            DefaultFocus = a0.SubButtons[1]
            if not DefaultFocus then
                DefaultFocus = a0.CategoryButtons[table.find(Query, a0.Category) or 1]
            end
        end
    end

    a0.DefaultFocus = DefaultFocus
    a0:_wireCatalogue()
    local v491 = v450.Scroll or Vector2.zero
    a0.ItemList.CanvasPosition = v491
    local v492 = v450.SubScroll or Vector2.zero
    a0.SubList.CanvasPosition = v492
    a0.LastFocus = nil
    a0:FocusDefault()
    local CatalogueGeneration1 = a0.CatalogueGeneration
    task.defer(function() --[[ Upvalues: a0 (copy), CatalogueGeneration1 (copy), GuiService (upvalue) ]]
        if not a0.Destroyed then
            if a0.MenuOpen then
                if a0.MenuKind == "Catalogue" then
                    if a0.CatalogueGeneration == CatalogueGeneration1 then
                        local SelectedObject2 = GuiService.SelectedObject
                        local v493 = a0
                        local v495
                        if not (a0:Owns(SelectedObject2) and SelectedObject2) then
                            v495 = a0.DefaultFocus
                        end

                        v493:_scrollTo(v495)
                        a0:_queueThumbnails()
                    end
                end
            end
        end

    end)
end

v159.RefreshCatalogue = RefreshCatalogue

local function _wireCatalogue(a0) --[[ Upvalues: Query (copy) ]]
    local v496 = a0.CategoryButtons[table.find(Query, a0.Category) or 1]
    local v497 = a0.SubButtons[1] or v496
    for k131, k132 in ipairs(a0.SubButtons) do
        if k132.Name == a0.SubCategory then
            v497 = k132
        end
    end

    for k133, k134 in ipairs(a0.CategoryButtons) do
        k134.NextSelectionLeft = a0.CategoryButtons[k133 - 1] or k134
        k134.NextSelectionRight = a0.CategoryButtons[k133 + 1] or k134
        k134.NextSelectionUp = a0.PaintModeButton
        local v505
        if not (a0.SubButtons[1] and v497) then
            local v507 = a0.Cards[1] or k134
        end

        k134.NextSelectionDown = v505
    end

    for k135, k136 in ipairs(a0.SubButtons) do
        k136.NextSelectionLeft = a0.SubButtons[k135 - 1] or k136
        k136.NextSelectionRight = a0.SubButtons[k135 + 1] or k136
        k136.NextSelectionUp = v496
        k136.NextSelectionDown = a0.Cards[1] or k136
    end

    for k137, k138 in ipairs(a0.Cards) do
        local v514 = (k137 - 1) % 4 + 1
        k138.NextSelectionLeft = 1 < v514 and a0.Cards[k137 - 1] or k138
        k138.NextSelectionRight = v514 < 4 and a0.Cards[k137 + 1] or k138
        k138.NextSelectionUp = a0.Cards[k137 - 4] or v497
        k138.NextSelectionDown = a0.Cards[k137 + 4] or k138
    end

    a0.PaintModeButton.NextSelectionDown = v496
    a0.PaintModeButton.NextSelectionLeft = a0.PaintModeButton
    a0.PaintModeButton.NextSelectionRight = a0.CloseButton
    a0.PaintModeButton.NextSelectionUp = a0.PaintModeButton
    a0.CloseButton.NextSelectionDown = v496
    a0.CloseButton.NextSelectionLeft = a0.PaintModeButton
    a0.CloseButton.NextSelectionRight = a0.CloseButton
    a0.CloseButton.NextSelectionUp = a0.CloseButton
end

v159._wireCatalogue = _wireCatalogue

local function _open(a0, a1) --[[ Upvalues: GuiService (copy) ]]
    if not a0.Active then
        return false
    end

    a0:_remember()
    if a0:Owns(GuiService.SelectedObject) then
        GuiService.SelectedObject = nil
    end

    a0.MenuOpen = true
    a0.MenuKind = a1
    a0.Dimmer.Visible = true
    a0.HUD.Visible = false
    a0.Top.Visible = false
    a0.Reticle.Visible = false
    a0.Catalogue.Visible = a1 == "Catalogue"
    a0.PaintModeButton.Visible = a1 == "Catalogue"
    a0.FavoriteHint.Parent.Visible = a1 == "Catalogue"
    local v519 = true
    if a1 ~= "Options" then
        v519 = true
        if a1 ~= "Steps" then
            v519 = a1 == "CameraAngles"
        end
    end

    a0.Options.Visible = v519
    a0.Palette.Visible = a1 == "Palette"
    local v520 = a1 == "Precision"
    a0.Precision.Visible = v520
    a0.PrecisionHints.Visible = v520
    a0.MenuHints.Visible = not v520
    local Menu4 = a0.Menu
    local v521
    if v520 then
        v521 = 350
    else
        v521 = 1000
    end

    Menu4.Size = UDim2.fromOffset(v521, 640)
    Menu4 = a0.Menu
    local v523
    if not (v520 and Vector2.new(1, 0.5)) then
        local v524 = Vector2.new(0.5, 0.5)
    end

    Menu4.AnchorPoint = v523
    Menu4 = a0.Menu
    local v526
    if not (v520 and UDim2.fromScale(0.975, 0.5)) then
        local v527 = UDim2.fromScale(0.5, 0.5)
    end

    Menu4.Position = v526
    Menu4 = a0.CloseButton
    local v529
    if not (v520 and UDim2.fromOffset(256, 22)) then
        local v530 = UDim2.fromOffset(864, 24)
    end

    Menu4.Position = v529
    Menu4 = a0.CloseButton
    local v532
    if not (v520 and UDim2.fromOffset(70, 36)) then
        local v533 = UDim2.fromOffset(110, 44)
    end

    Menu4.Size = v532
    if v520 then
        v532 = 16
    else
        v532 = 20
    end

    a0.CloseButton.TextSize = v532
    a0.CloseButton.Selectable = not v520
    local Title = a0.Title
    local v535
    if not (v520 and UDim2.fromOffset(24, 20)) then
        local v536 = UDim2.fromOffset(26, 19)
    end

    Title.Position = v535
    Title = a0.Title
    if v520 then
        v521 = 210
    else
        if a1 == "Catalogue" then
            v521 = 650
        else
            v521 = 790
        end
    end

    Title.Size = UDim2.fromOffset(24, 34)
    local v537
    if v520 then
        v537 = 24
    else
        v537 = 27
    end

    a0.Title.TextSize = v537
    local Subtitle1 = a0.Subtitle
    local v539
    if not (v520 and UDim2.fromOffset(24, 65)) then
        local v540 = UDim2.fromOffset(26, 54)
    end

    Subtitle1.Position = v539
    Subtitle1 = a0.Subtitle
    local v542
    if not (v520 and UDim2.fromOffset(302, 44)) then
        local v543 = UDim2.fromOffset(800, 25)
    end

    Subtitle1.Size = v542
    if v520 then
        v542 = 16
    else
        v542 = 17
    end

    a0.Subtitle.TextSize = v542
    a0.Subtitle.TextWrapped = v520
    a0.Dimmer.BackgroundTransparency = 1
    a0.Dimmer.Active = not v520
    a0.DefaultFocus = nil
    a0.LastFocus = nil
    a0.CategoryLeftHint.Parent.Visible = a1 == "Catalogue"
    a0.CategoryRightHint.Parent.Visible = a1 == "Catalogue"
    local MenuSelectHint = a0.MenuSelectHint
    if MenuSelectHint.Text ~= "Select" then
        MenuSelectHint.Text = "Select"
    end

    MenuSelectHint = a0.MenuBackHint
    local v544
    if a1 == "Steps" then
        v544 = "Precision"
    else
        if a1 == "CameraAngles" then
            v544 = "Options"
        else
            if a1 == "Palette" then
                v544 = "Paint"
            else
                v544 = "Back"
            end
        end
    end

    if MenuSelectHint.Text ~= v544 then
        MenuSelectHint.Text = v544
    end

    a0:_resize()
    return true
end

v159._open = _open

local function OpenCatalogue(a0)
    if not a0:_open("Catalogue") then
        return
    end

    local Title1 = a0.Title
    if Title1.Text ~= "OBJECT CATALOGUE" then
        Title1.Text = "OBJECT CATALOGUE"
    end

    Title1 = a0.Subtitle
    if Title1.Text ~= "Choose an object. Your camera stays where you left it." then
        Title1.Text = "Choose an object. Your camera stays where you left it."
    end

    a0:RefreshCatalogue()
end

v159.OpenCatalogue = OpenCatalogue

local function OpenOptions(a0, a1) --[[ Upvalues: clear (copy), label (copy), v175 (copy) ]]
    if not a0:_open("Options") then
        return
    end

    local Title2 = a0.Title
    local v545
    if a1 then
        v545 = "PAINT OPTIONS"
    else
        v545 = "BUILD OPTIONS"
    end

    if Title2.Text ~= v545 then
        Title2.Text = v545
    end

    Title2 = a0.Subtitle
    if Title2.Text ~= "Choose your mode, camera angle or base settings." then
        Title2.Text = "Choose your mode, camera angle or base settings."
    end

    clear(a0.Options)
    local v546 = {}
    v545 = {}
    local v547
    if a1 then
        v547 = "ObjectsMode"
    else
        v547 = "PaintMode"
    end

    local v548
    if a1 then
        v548 = "Objects mode"
    else
        v548 = "Paint mode"
    end

    local v549
    if a1 then
        v549 = "Return to selecting and placing objects"
    else
        v549 = "Brush, bucket, colour wheel and sampling"
    end

    v545[1] = v547
    v545[2] = v548
    v545[3] = v549
    v547 = {"Grid", "Toggle grid", "Show or hide the building grid"}
    v548 = {"CameraAngle", "Camera Angle", "Choose from six views of your base"}
    v549 = {"Customize", "Customize base", "Walls, floor and base upgrades"}
    local v550 = {"SaveSlots", "Save slots", "Save or load a base layout"}
    local v551 = {
        "DeleteAll",
        "Delete all objects\226\128\166",
        "Opens a confirmation before removing objects"
    }
    local v552 = {
        "SwitchClassic",
        "Building system: Classic",
        "Switch to the Classic building controls"
    }
    local v553 = {}
    local v554
    if a1 then
        v554 = "Resume painting"
    else
        v554 = "Resume building"
    end

    v553[1] = "Resume"
    v553[2] = v554
    v553[3] = "Close this menu"
    local v555 = {"Exit", "Finish building", "Return to normal controls"}
    v546[1] = v545
    v546[2] = v547
    v546[3] = v548
    v546[4] = v549
    v546[5] = v550
    v546[6] = v551
    v546[7] = v552
    v546[8] = v553
    v546[9] = v555
    if a1 then
        v550 = "ResetPaint"
        v551 = "Reset paint\226\128\166"
        v549 = {v550, v551, "Opens a confirmation before resetting colours"}
        table.insert(v546, 6, v549)
    end

    v545 = {}
    for k139, k140 in ipairs(v546) do
        local v559 = UDim2.fromOffset(460, 78)
        local v560 = a0:_button(a0.Options, k140[1], "", v559, UDim2.new(), function() --[[ Upvalues: a0 (copy), k140 (copy) ]]
            if a0.Callbacks.Option then
                a0.Callbacks.Option(k140[1])
            end

        end)
        v560.LayoutOrder = k139
        local v561 = label
        v554 = k140[2]
        local v562 = UDim2.fromOffset(424, 30)
        local v563 = UDim2.fromOffset(18, 8)
        if k140[1] == "Exit" or k140[1] == "DeleteAll" or k140[1] == "ResetPaint" then
            local Danger = v175.Danger
            if Danger then
                -- jump to 190
            end
        end

        local Text1 = v175.Text
        v561(v560, v554, v562, v563, 21, Text1)
        local v564 = UDim2.fromOffset(424, 26)
        local v565 = UDim2.fromOffset(18, 40)
        label(v560, k140[3], v564, v565, 16, v175.Muted)
        table.insert(v545, v560)
    end

    a0:_wireGrid(v545, 2)
    a0.DefaultFocus = v545[1]
    a0.Options.CanvasPosition = Vector2.zero
    a0:FocusDefault()
end

v159.OpenOptions = OpenOptions

local function OpenCameraAngles(a0) --[[ Upvalues: clear (copy) ]]
    if not a0:_open("CameraAngles") then
        return
    end

    local Title3 = a0.Title
    if Title3.Text ~= "CAMERA ANGLE" then
        Title3.Text = "CAMERA ANGLE"
    end

    Title3 = a0.Subtitle
    if Title3.Text ~= "Choose a view of your base. Back returns to options." then
        Title3.Text = "Choose a view of your base. Back returns to options."
    end

    clear(a0.Options)
    local v566 = {}
    local v567 = {"ViewTop", "Top"}
    local v568 = {"ViewFront", "Front"}
    local v569 = {"ViewBack", "Back"}
    local v570 = {"ViewLeft", "Left"}
    local v571 = {"ViewRight", "Right"}
    local v572 = {"ViewIso", "Isometric"}
    local v573 = {v567, v568, v569, v570, v571, v572}
    for k141, k142 in ipairs(v573) do
        local v577 = UDim2.fromOffset(460, 78)
        local v578 = a0:_button(a0.Options, k142[1], k142[2], v577, UDim2.new(), function() --[[ Upvalues: a0 (copy), k142 (copy) ]]
            if a0.Callbacks.Option then
                a0.Callbacks.Option(k142[1])
            end

        end)
        v578.LayoutOrder = k141
        table.insert(v566, v578)
    end

    a0:_wireGrid(v566, 2)
    a0.DefaultFocus = v566[1]
    a0.Options.CanvasPosition = Vector2.zero
    a0:FocusDefault()
end

v159.OpenCameraAngles = OpenCameraAngles

local function _createPrecision(a0) --[[ Upvalues: label (copy), v175 (copy), keyName (copy) ]]
    local v579 = {
        Name = "Precision",
        BackgroundTransparency = 1,
        Visible = false,
        Position = UDim2.fromOffset(24, 114),
        Size = UDim2.fromOffset(302, 228)
    }
    local Menu5 = a0.Menu
    local Frame9 = Instance.new("Frame")
    for k143, k144 in pairs(v579) do
        Frame9[k143] = k144
    end

    Frame9.Parent = Menu5
    a0.Precision = Frame9
    a0.ModeButtons = {}
    a0.AxisButtons = {}
    local v583 = UDim2.fromOffset(302, 22)
    label(a0.Precision, "\226\134\145 / \226\134\147  TRANSFORM", v583, UDim2.new(), 16, v175.Muted)
    v583 = "Move"
    local v584 = "Rotate"
    local v585 = {v583, v584}
    for k145, k146 in ipairs(v585) do
        local v589 = UDim2.fromOffset(145, 38)
        local v590 = (k145 - 1) * 157
        local v591 = UDim2.fromOffset(v590, 24)
        local v592 = a0:_button(a0.Precision, k146, k146, v589, v591, function() --[[ Upvalues: a0 (copy), k146 (copy) ]]
            if a0.Callbacks.Mode then
                a0.Callbacks.Mode(k146)
            end

        end)
        v592.Selectable = false
        a0.ModeButtons[k146] = v592
    end

    local v593 = UDim2.fromOffset(302, 22)
    local v594 = UDim2.fromOffset(0, 74)
    label(a0.Precision, "\226\134\144 / \226\134\146  AXIS", v593, v594, 16, v175.Muted)
    v593 = "X"
    v594 = "Y"
    local v595 = {v593, v594, "Z"}
    for k147, k148 in ipairs(v595) do
        local v599 = UDim2.fromOffset(94, 38)
        local v600 = (k147 - 1) * 104
        local v601 = UDim2.fromOffset(v600, 98)
        local v602 = a0:_button(a0.Precision, k148, k148, v599, v601, function() --[[ Upvalues: a0 (copy), k148 (copy) ]]
            if a0.Callbacks.Axis then
                a0.Callbacks.Axis(k148)
            end

        end)
        v602.Selectable = false
        a0.AxisButtons[k148] = v602
    end

    local v603 = UDim2.fromOffset(302, 30)
    local v604 = UDim2.fromOffset(0, 150)
    a0.StepLabel = label(a0.Precision, "Move increment: 1 stud", v603, v604, 18, v175.Accent)
    local v605 = keyName(Enum.KeyCode.ButtonY, "Y")
    v604 = v605 .. " \194\183 Choose increment\226\128\166"
    local v606 = UDim2.fromOffset(302, 38)
    local v607 = 190
    local v608 = UDim2.fromOffset(0, v607)

    local function v609() --[[ Upvalues: a0 (copy) ]]
        if a0.Callbacks.Steps then
            a0.Callbacks.Steps()
        end
    end

    local v610 = a0:_button(a0.Precision, "ChooseStep", v604, v606, v608, v609)
    v610.Selectable = false
    v610.TextSize = 16
    local v611 = {
        Name = "PrecisionHints",
        BackgroundTransparency = 1,
        Visible = false,
        Position = UDim2.fromOffset(24, 358),
        Size = UDim2.fromOffset(302, 266)
    }
    local Menu6 = a0.Menu
    local Frame10 = Instance.new("Frame")
    for k149, k150 in pairs(v611) do
        Frame10[k149] = k150
    end

    Frame10.Parent = Menu6
    a0.PrecisionHints = Frame10
    a0.PrecisionActionHint = a0:_glyph(a0.PrecisionHints, Enum.KeyCode.ButtonA, "A", "Place", 0, 151)
    local v615 = "Close"
    local v616 = 151
    a0:_glyph(a0.PrecisionHints, Enum.KeyCode.ButtonB, "B", v615, v616, 151)
    local v617 = {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 38),
        Size = UDim2.fromOffset(302, 34)
    }
    local PrecisionHints = a0.PrecisionHints
    v610 = Instance.new("Frame")
    for k151, k152 in pairs(v617) do
        v610[k151] = k152
    end

    v610.Parent = PrecisionHints
    k151 = "Rotate +"
    k152 = 0
    a0.PrecisionRotateHint = a0:_glyph(v610, Enum.KeyCode.ButtonR2, "RT", k151, k152, 302)
    local v621 = {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 76),
        Size = UDim2.fromOffset(302, 34)
    }
    local PrecisionHints1 = a0.PrecisionHints
    v610 = Instance.new("Frame")
    for k153, k154 in pairs(v621) do
        v610[k153] = k154
    end

    v610.Parent = PrecisionHints1
    a0:_glyph(v610, Enum.KeyCode.ButtonL1, "LB", "Nudge \226\136\146", 0, 151)
    local v625 = 151
    a0:_glyph(v610, Enum.KeyCode.ButtonR1, "RB", "Nudge +", 151, v625)
    local v626 = UDim2.fromOffset(302, 42)
    local v627 = UDim2.fromOffset(0, 114)
    local v628 = 16
    local Accent1 = v175.Accent
    a0.PrecisionGridHint = label(a0.PrecisionHints, "", v626, v627, v628, Accent1)
    a0.PrecisionGridHint.TextWrapped = true
    a0.PrecisionGridHint.TextTruncate = Enum.TextTruncate.None
    local v629 = {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 160),
        Size = UDim2.fromOffset(302, 34)
    }
    local PrecisionHints2 = a0.PrecisionHints
    v610 = Instance.new("Frame")
    for k155, k156 in pairs(v629) do
        v610[k155] = k156
    end

    v610.Parent = PrecisionHints2
    PrecisionHints2 = {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 194),
        Size = UDim2.fromOffset(302, 34)
    }
    local PrecisionHints3 = a0.PrecisionHints
    v629 = Instance.new("Frame")
    for k157, k158 in pairs(PrecisionHints2) do
        v629[k157] = k158
    end

    v629.Parent = PrecisionHints3
    a0.PrecisionMoveHint = a0:_glyph(v610, Enum.KeyCode.ButtonL3, "L3", "", 0, 302)
    a0.PrecisionMoveHint.TextSize = 15
    local v636 = UDim2.fromOffset(302, 34)
    a0.PrecisionAxisHint = label(v629, "", v636, UDim2.new(), 15, v175.Muted)
    a0.PrecisionAxisHint.TextWrapped = true
    a0.PrecisionAxisHint.TextTruncate = Enum.TextTruncate.None
    local v637 = UDim2.fromOffset(302, 38)
    local v638 = UDim2.fromOffset(0, 228)
    a0.PrecisionStatus = label(a0.PrecisionHints, "", v637, v638, 15, v175.Muted)
    a0.PrecisionStatus.TextWrapped = true
    a0.PrecisionStatus.TextTruncate = Enum.TextTruncate.None
end

v159._createPrecision = _createPrecision

local function _updatePrecision(a0, a1) --[[ Upvalues: v175 (copy), keyName (copy) ]]
    local v639 = a1.transformMode or "Move"
    local v640 = a1.axis or "Y"
    for k159, k160 in pairs(a0.ModeButtons) do
        k160:SetAttribute("CurrentTab", k159 == v639)
        local v644
        if not (k159 == v639 and v175.Selected) then
            v644 = v175.Card
        end

        k160.BackgroundColor3 = v644
        local v645
        if not (k159 == v639 and v175.Accent) then
            v645 = v175.Text
        end

        k160.TextColor3 = v645
    end

    for k161, k162 in pairs(a0.AxisButtons) do
        k162:SetAttribute("CurrentTab", k161 == v640)
        local v649
        if not (k161 == v640 and v175.Selected) then
            v649 = v175.Card
        end

        k162.BackgroundColor3 = v649
        local v650
        if not (k161 == v640 and v175.Accent) then
            v650 = v175.Text
        end

        k162.TextColor3 = v650
    end

    local v651
    if v639 == "Rotate" then
        v651 = a1.rotateStep
        if not v651 then
            v651 = 15
            -- branch continues at 100
        end
    else
        local v653 = a1.moveStep or a1.step or 1
    end

    local StepLabel = a0.StepLabel
    local v654 = tonumber(v651) or 0
    local v655 = math.abs(v654)
    if v655 < 0.005 then
        v654 = 0
    end

    local v656 = string.format("%.2f", v654)
    local v657 = v656:gsub("(%..-)0+$", "%1")
    if v639 == "Rotate" then
        v654 = "\194\176"
    else
        v654 = " studs"
    end

    local v658 = v639 .. " increment: " .. v657:gsub("%.$", "") .. v654
    if StepLabel.Text ~= v658 then
        StepLabel.Text = v658
    end

    StepLabel = a0.PrecisionActionHint
    if a1.editingExisting then
        v658 = "Save move"
    else
        v658 = "Place"
    end

    if StepLabel.Text ~= v658 then
        StepLabel.Text = v658
    end

    StepLabel = a0.PrecisionRotateHint
    local v659
    if a1.slowModifier then
        v659 = "Rotate \226\136\146"
    else
        v659 = "Rotate +"
    end

    v651 = tonumber(a1.rotateStep or 15) or 0
    local v660 = math.abs(v651)
    if v660 < 0.005 then
        v651 = 0
    end

    local v661 = string.format("%.2f", v651)
    local v662 = v661:gsub("(%..-)0+$", "%1")
    v658 = v659 .. " \194\183 " .. v640 .. " \194\183 " .. v662:gsub("%.$", "") .. "\194\176"
    if StepLabel.Text ~= v658 then
        StepLabel.Text = v658
    end

    StepLabel = a0.PrecisionAxisHint
    local v663 = keyName(Enum.KeyCode.ButtonL2, "LT")
    local v664 = "Release " .. v663 .. ": "
    v658 = "D-pad \226\134\144 / \226\134\146: axis " .. v640 .. "\n" .. (a1.slowModifier and v664 or "") .. "\226\134\145 / \226\134\147: Move / Rotate"
    if StepLabel.Text ~= v658 then
        StepLabel.Text = v658
    end

    local v665 = keyName(Enum.KeyCode.ButtonL2, "LT")
    local v666 = keyName(Enum.KeyCode.ButtonR2, "RT")
    local v667 = keyName(Enum.KeyCode.ButtonX, "X")
    local v668 = keyName(Enum.KeyCode.ButtonB, "B")
    StepLabel = v665 .. " + " .. v666 .. ": reverse rotation.\n" .. v667 .. " / " .. v668 .. ": close Precision."
    v665 = a0.PrecisionStatus
    if v665.Text ~= (a1.valid == false and a1.status and a1.status ~= "" and a1.status or StepLabel) then
        v665.Text = a1.valid == false and a1.status and a1.status ~= "" and a1.status or StepLabel
    end

    local v670
    if not (a1.valid == false and v175.Danger) then
        v670 = v175.Muted
    end

    a0.PrecisionStatus.TextColor3 = v670
    if a0.MenuKind == "Precision" then
        local Subtitle2 = a0.Subtitle
        local v671
        if not (v639 == "Rotate" and "Camera parked. Rotate around the object's " .. v640 .. " axis.") then
            v671 = "Camera parked. Move along the world's " .. v640 .. " axis."
        end

        if Subtitle2.Text ~= v671 then
            Subtitle2.Text = v671
        end
    end
end

v159._updatePrecision = _updatePrecision

local function _updateQuickAdjust(a0, a1) --[[ Upvalues: keyName (copy), v175 (copy) ]]
    local v672 = false
    if a1.quickAdjustAvailable ~= false then
        v672 = false
        if a1.mode ~= "Paint" then
            local v674 = not a1.paintMode and not a1.deleting
        end
    end

    local v675 = a1.slowModifier == true
    local v676 = tonumber(a1.gridHeight or 0) or 0
    local v677 = math.abs(v676)
    if v677 < 0.005 then
        v676 = 0
    end

    local v678 = string.format("%.2f", v676)
    local v679 = v678:gsub("(%..-)0+$", "%1")
    local v680
    if a1.gridEnabled == false then
        v680 = " (hidden)"
    else
        v680 = " studs"
    end

    local v681 = v679:gsub("%.$", "") .. v680
    local v682 = keyName(Enum.KeyCode.ButtonL2, "LT")
    v680 = "Hold " .. v682 .. " + D-pad \226\134\145 / \226\134\147"
    local v684 = a1.moveStep or a1.step or 1
    local v685 = tonumber(v684) or 0
    local v686 = math.abs(v685)
    if v686 < 0.005 then
        v685 = 0
    end

    local v687 = string.format("%.2f", v685)
    local v688 = v687:gsub("(%..-)0+$", "%1")
    local v689 = "Move step " .. v688:gsub("%.$", "")
    local v690 = tonumber(a1.rotateStep or 15) or 0
    local v691 = math.abs(v690)
    if v691 < 0.005 then
        v690 = 0
    end

    local v692 = string.format("%.2f", v690)
    local v693 = v692:gsub("(%..-)0+$", "%1")
    local v694 = "Rotate step " .. v693:gsub("%.$", "") .. "\194\176"
    if a1.quickRotateAxis == "X" or a1.quickRotateAxis == "Z" then
        local quickRotateAxis = a1.quickRotateAxis
        if quickRotateAxis then
            -- jump to 173
        end
    end

    local v695 = "Y"
    a0.QuickAdjustRow.Visible = v672
    local v696 = true
    if a1.mode ~= "Paint" then
        v696 = a1.paintMode == true
    end

    local HUD5 = a0.HUD
    local v697
    if v696 then
        v697 = 182
    else
        if v672 then
            v697 = 186
        else
            v697 = 140
        end
    end

    HUD5.Size = UDim2.fromOffset(1080, v697)
    HUD5 = a0.ItemLabel
    local v698
    if v696 then
        v698 = 152
    else
        v698 = 24
    end

    if v696 then
        v697 = 25
    else
        v697 = 9
    end

    HUD5.Position = UDim2.fromOffset(v698, v697)
    HUD5 = a0.ItemLabel
    if v696 then
        v698 = 522
    else
        v698 = 610
    end

    HUD5.Size = UDim2.fromOffset(v698, 30)
    HUD5 = a0.AxisLabel
    if v696 then
        v698 = 696
    else
        v698 = 644
    end

    if v696 then
        v697 = 36
    else
        v697 = 9
    end

    HUD5.Position = UDim2.fromOffset(v698, 30)
    HUD5 = a0.AxisLabel
    if v696 then
        v698 = 294
    else
        v698 = 412
    end

    if v696 then
        v697 = 24
    else
        v697 = 30
    end

    HUD5.Size = UDim2.fromOffset(v698, 30)
    HUD5 = a0.StatusLabel
    if v696 then
        v697 = 71
    else
        v697 = 39
    end

    HUD5.Position = UDim2.fromOffset(24, 30)
    HUD5 = a0.HintRow
    if v696 then
        v697 = 103
    else
        v697 = 69
    end

    HUD5.Position = UDim2.fromOffset(24, 30)
    HUD5 = a0.SecondaryLabel
    if v696 then
        v697 = 143
    else
        if v672 then
            v697 = 157
        else
            v697 = 109
        end
    end

    HUD5.Position = UDim2.fromOffset(24, 30)
    HUD5 = a0.QuickGridHint
    local v700 = (v675 and v682 .. " held \194\183 D-pad \226\134\145 / \226\134\147" or v680) .. "\nGrid: " .. v681
    if HUD5.Text ~= v700 then
        HUD5.Text = v700
    end

    HUD5 = a0.QuickMoveHint
    if HUD5.Text ~= (v675 and v694 or v689) then
        HUD5.Text = v675 and v694 or v689
    end

    HUD5 = a0.QuickMoveKeysHint
    local v703
    if not (v675 and "Release " .. v682 .. ": move step") then
        local v704 = keyName(Enum.KeyCode.ButtonL3, "L3")
        v703 = v682 .. " + " .. v704 .. ": rotation step"
    end

    if HUD5.Text ~= v703 then
        HUD5.Text = v703
    end

    HUD5 = a0.FollowHint
    local v705
    if not (v675 and "Rotation axis " .. v695) then
        if a1.following then
            v705 = "Keep here"
        else
            v705 = "Follow aim"
        end
    end

    if HUD5.Text ~= v705 then
        HUD5.Text = v705
    end

    HUD5 = a0.QuickRotateKeysHint
    local v706
    if not (v675 and "Release " .. v682 .. ": keep / follow") then
        local v707 = keyName(Enum.KeyCode.ButtonR3, "R3")
        v696 = tonumber(a1.rotateStep or 15) or 0
        local v708 = math.abs(v696)
        if v708 < 0.005 then
            v696 = 0
        end

        local v709 = string.format("%.2f", v696)
        local v710 = v709:gsub("(%..-)0+$", "%1")
        v706 = v682 .. " + " .. v707 .. ": axis " .. v695 .. " \194\183 " .. v710:gsub("%.$", "") .. "\194\176"
    end

    if HUD5.Text ~= v706 then
        HUD5.Text = v706
    end

    HUD5 = a0.PrecisionGridHint
    v706 = "Grid: " .. v681 .. "\n" .. v680
    if HUD5.Text ~= v706 then
        HUD5.Text = v706
    end

    HUD5 = a0.PrecisionMoveHint
    local v711
    if not (v675 and v694) then
        local v713 = a1.moveStep or a1.step or 1
        v695 = tonumber(v713) or 0
        local v714 = math.abs(v695)
        if v714 < 0.005 then
            v695 = 0
        end

        local v715 = string.format("%.2f", v695)
        local v716 = v715:gsub("(%..-)0+$", "%1")
        v697 = v716:gsub("%.$", "")
        v689 = tonumber(a1.rotateStep or 15) or 0
        local v717 = math.abs(v689)
        if v717 < 0.005 then
            v689 = 0
        end

        local v718 = string.format("%.2f", v689)
        local v719 = v718:gsub("(%..-)0+$", "%1")
        v711 = "Move " .. v697 .. " \194\183 " .. v682 .. ": rotate " .. v719:gsub("%.$", "") .. "\194\176"
    end

    if HUD5.Text ~= v711 then
        HUD5.Text = v711
    end

    local v720
    if not (a1.gridAdjusting and v175.Good) then
        v720 = v175.Accent
    end

    a0.QuickGridHint.TextColor3 = v720
    a0.PrecisionGridHint.TextColor3 = v720
    a0.PrecisionGridHint.Visible = v672
    a0.PrecisionMoveHint.Parent.Visible = v672
    a0.PrecisionAxisHint.Parent.Visible = v672
end

v159._updateQuickAdjust = _updateQuickAdjust

local function OpenPrecision(a0, a1)
    if not a0:_open("Precision") then
        return
    end

    local Title4 = a0.Title
    if Title4.Text ~= "PRECISION" then
        Title4.Text = "PRECISION"
    end

    local v722 = a1 or a0.State
    a0:Update(v722)
    a0:FocusDefault()
end

v159.OpenPrecision = OpenPrecision

local function _wireGrid(a0, a1, a2)
    for k163, k164 in ipairs(a1) do
        local v726 = (k163 - 1) % a2 + 1
        k164.NextSelectionLeft = 1 < v726 and a1[k163 - 1] or k164
        k164.NextSelectionRight = v726 < a2 and a1[k163 + 1] or k164
        local v732 = a1[k163 - a2] or a0.CloseButton
        k164.NextSelectionUp = v732
        k164.NextSelectionDown = a1[k163 + a2] or k164
    end

    local v734 = a1[1] or a0.CloseButton
    a0.CloseButton.NextSelectionDown = v734
    local v735 = a1[1] or a0.CloseButton
    a0.CloseButton.NextSelectionLeft = v735
    a0.CloseButton.NextSelectionRight = a0.CloseButton
    a0.CloseButton.NextSelectionUp = a0.CloseButton
end

v159._wireGrid = _wireGrid

local function OpenSteps(a0, a1, a2) --[[ Upvalues: keyName (copy), clear (copy), v60 (copy), v158 (copy), v175 (copy) ]]
    if type(a1) == "table" then
        local v736 = a1
        a1 = v736.transformMode or "Move"
        a2 = a1 == "Rotate" and v736.rotateStep or v736.moveStep
    end

    local v739 = a1 or a0.State.transformMode or "Move"
    a1 = v739
    if not a0:_open("Steps") then
        return
    end

    local MenuBackHint = a0.MenuBackHint
    local v740
    if a0.MenuKind == "Options" then
        v740 = "Options"
    else
        v740 = "Precision"
    end

    if MenuBackHint.Text ~= v740 then
        MenuBackHint.Text = v740
    end

    MenuBackHint = a0.Title
    if a1 == "Rotate" then
        v740 = "ROTATION INCREMENT"
    else
        v740 = "MOVEMENT INCREMENT"
    end

    if MenuBackHint.Text ~= v740 then
        MenuBackHint.Text = v740
    end

    MenuBackHint = a0.Subtitle
    local v741 = keyName(Enum.KeyCode.ButtonL3, "L3")
    local v742 = " cycles movement; "
    local v743 = keyName(Enum.KeyCode.ButtonL2, "LT")
    local v744 = keyName(Enum.KeyCode.ButtonL3, "L3")
    v740 = "While building: " .. v741 .. v742 .. v743 .. " + " .. v744 .. " cycles rotation."
    if MenuBackHint.Text ~= v740 then
        MenuBackHint.Text = v740
    end

    clear(a0.Options)
    local v747 = {}
    for k165, k166 in ipairs(a1 == "Rotate" and v60 or v158) do
        v744 = a0.Options
        local v751 = "Step" .. tostring(k166)
        local v752 = tostring(k166)
        local v753
        if a1 == "Rotate" then
            v753 = "\194\176"
        else
            v753 = " studs"
        end

        local v754 = v752 .. v753
        local v755 = UDim2.fromOffset(460, 78)
        local v756 = a0:_button(v744, v751, v754, v755, UDim2.new(), function() --[[ Upvalues: a0 (copy), k166 (copy) ]]
            if a0.Callbacks.Step then
                a0.Callbacks.Step(k166)
            end

        end)
        v756.LayoutOrder = k165
        v756:SetAttribute("CurrentTab", k166 == a2)
        local v757
        if not (k166 == a2 and v175.Selected) then
            v757 = v175.Card
        end

        v756.BackgroundColor3 = v757
        if k166 == a2 then
            a0.DefaultFocus = v756
        end

        table.insert(v747, v756)
    end

    a0:_wireGrid(v747, 2)
    local v759 = a0.DefaultFocus or v747[1]
    a0.DefaultFocus = v759
    a0.Options.CanvasPosition = Vector2.zero
    a0:FocusDefault()
end

v159.OpenSteps = OpenSteps

local function _chooseColor(a0, a1)
    a0.PaletteColor = a1
    if a0.CurrentColor then
        a0.CurrentColor.BackgroundColor3 = a1
    end

    local R = a1.R
    local G = a1.G
    local v760 = {R, G, a1.B}
    for k167, k168 in ipairs(v760) do
        if a0.ChannelLabels and a0.ChannelLabels[k167] then
            local v764 = a0.ChannelLabels[k167]
            local v765 = {"Red", "Green", "Blue"}
            local v766 = v765[k167]
            local v767 = v766 .. "  " .. tostring(math.floor(k168 * 255 + 0.5))
            if v764.Text ~= v767 then
                v764.Text = v767
            end
        end
    end

    if a0.Callbacks.Color then
        a0.Callbacks.Color(a1)
    end
end

v159._chooseColor = _chooseColor

local function OpenPalette(a0, a1, a2) --[[ Upvalues: clear (copy), v175 (copy), label (copy), v174 (copy) ]]
    if not a0:_open("Palette") then
        return
    end

    local v769 = typeof(a1) == "Color3" and a1 or a0.PaletteColor
    a0.PaletteColor = v769
    v769 = a0.Title
    if v769.Text ~= "PAINT PALETTE" then
        v769.Text = "PAINT PALETTE"
    end

    v769 = a0.Subtitle
    if v769.Text ~= "Select a colour, or fine-tune RGB values. Back returns to your paint tool." then
        v769.Text = "Select a colour, or fine-tune RGB values. Back returns to your paint tool."
    end

    clear(a0.Palette)
    local v770 = {
        Name = "CurrentColour",
        BorderSizePixel = 0,
        BackgroundColor3 = a0.PaletteColor,
        Size = UDim2.fromOffset(112, 56)
    }
    local Palette = a0.Palette
    local Frame11 = Instance.new("Frame")
    for k169, k170 in pairs(v770) do
        Frame11[k169] = k170
    end

    Frame11.Parent = Palette
    a0.CurrentColor = Frame11
    Frame11 = a0.CurrentColor
    Frame11.BorderColor3 = v175.Line
    Frame11.BorderSizePixel = 2
    Frame11.BorderMode = Enum.BorderMode.Inset
    local v774 = UDim2.fromOffset(400, 26)
    local v775 = UDim2.fromOffset(130, 1)
    label(a0.Palette, "CURRENT PAINT", v774, v775, 19)
    local v776 = UDim2.fromOffset(780, 25)
    local v777 = UDim2.fromOffset(130, 29)
    local Muted3 = v175.Muted
    label(a0.Palette, "RGB adjustments change one channel by 5 / 255.", v776, v777, 17, Muted3)
    local v778 = {}
    local v779 = {}
    local v780 = {}
    for k171, k172 in ipairs(v174) do
        local v784 = "Colour" .. k171
        local v785 = UDim2.fromOffset(125, 44)
        local v786 = (k171 - 1) % 7 * 137
        local v787 = UDim2.fromOffset(v786, math.floor((k171 - 1) / 7) * 54 + 74)
        local v788 = a0:_button(a0.Palette, v784, "", v785, v787, function() --[[ Upvalues: a0 (copy), k172 (copy) ]]
            a0:_chooseColor(k172)
        end)
        v787 = 1
        local v789 = -10
        local v790 = {
            BorderSizePixel = 0,
            Active = false,
            BackgroundColor3 = k172,
            Position = UDim2.fromOffset(5, 5),
            Size = UDim2.new(1, -10, v787, v789)
        }
        local Frame12 = Instance.new("Frame")
        for k173, k174 in pairs(v790) do
            Frame12[k173] = k174
        end

        Frame12.Parent = v788
        table.insert(v778, v788)
    end

    local v794 = UDim2.fromOffset(948, 22)
    local v795 = UDim2.fromOffset(0, 184)
    label(a0.Palette, "RECENT COLOURS", v794, v795, 16, v175.Muted)
    local v796 = a2
    if not v796 then
        local recentColors1 = a0.State.recentColors
        if not recentColors1 then
            recentColors1 = {}
        end
    end

    for k175, k176 in ipairs(v796) do
        if typeof(k176) == "Color3" and #v779 < 8 then
            local v800 = #v779 + 1
            local v801 = "Recent" .. v800
            local v802 = UDim2.fromOffset(108, 38)
            local v803 = (v800 - 1) * 120
            local v804 = UDim2.fromOffset(v803, 211)
            local v805 = a0:_button(a0.Palette, v801, "", v802, v804, function() --[[ Upvalues: a0 (copy), k176 (copy) ]]
                a0:_chooseColor(k176)
            end)
            v802 = 1
            v804 = -10
            local v806 = {
                BorderSizePixel = 0,
                Active = false,
                BackgroundColor3 = k176,
                Position = UDim2.fromOffset(5, 5),
                Size = UDim2.new(1, -10, v802, v804)
            }
            v800 = Instance.new("Frame")
            for k177, k178 in pairs(v806) do
                v800[k177] = k178
            end

            v800.Parent = v805
            table.insert(v779, v805)
        end
    end

    if #v779 == 0 then
        local v810 = UDim2.fromOffset(948, 30)
        local v811 = UDim2.fromOffset(0, 211)
        label(a0.Palette, "Colours you use will appear here.", v810, v811, 17, v175.Muted)
    end

    a0.ChannelLabels = {}
    k175 = "Red"
    k176 = "Green"
    local v812 = {k175, k176, "Blue"}
    for k179, k180 in ipairs(v812) do
        local v816 = 274 + (k179 - 1) * 64
        local v817 = UDim2.fromOffset(270, 48)
        local v818 = UDim2.fromOffset(0, v816)
        a0.ChannelLabels[k179] = label(a0.Palette, k180, v817, v818, 22)
        local v819 = -1
        v817 = 1
        local v820 = {v819, v817}
        for k181, k182 in ipairs(v820) do
            local Palette1 = a0.Palette
            local v824
            if k182 < 0 then
                v824 = "Minus"
            else
                v824 = "Plus"
            end

            local v825 = k180 .. v824
            local v826
            if k182 < 0 then
                v826 = "\226\136\146 5"
            else
                v826 = "+ 5"
            end

            local v827 = UDim2.fromOffset(306, 48)
            local v828 = 310 + (k181 - 1) * 330
            local v829 = UDim2.fromOffset(v828, v816)
            local v833 = a0:_button(Palette1, v825, v826, v827, v829, function() --[[ Upvalues: a0 (copy), k179 (copy), k182 (copy) ]]
                local PaletteColor1 = a0.PaletteColor
                local t9 = {PaletteColor1.R, PaletteColor1.G, PaletteColor1.B}
                local v830 = math.floor(t9[k179] * 255 + 0.5)
                local v831 = (v830 + k182 * 5) / 255
                t9[k179] = math.clamp(v831, 0, 1)
                local v832 = Color3.new(t9[1], t9[2], t9[3])
                a0:_chooseColor(v832)
            end)
            table.insert(v780, v833)
        end
    end

    k179 = 7
    a0:_wireGrid(v778, k179)
    for k183, k184 in ipairs(v778) do
        if 7 < k183 then
            local v839 = v779[math.min(k183 - 7, #v779)] or v780[1]
            k184.NextSelectionDown = v839
        end
    end

    for k185, k186 in ipairs(v779) do
        k186.NextSelectionLeft = v779[k185 - 1] or k186
        k186.NextSelectionRight = v779[k185 + 1] or k186
        k186.NextSelectionUp = v778[math.min(k185, 7) + 7]
        local v843
        if 4 < k185 then
            v843 = 2
        else
            v843 = 1
        end

        k186.NextSelectionDown = v780[v843]
    end

    for k187, k188 in ipairs(v780) do
        k188.NextSelectionLeft = k187 % 2 == 0 and v780[k187 - 1] or k188
        k188.NextSelectionRight = k187 % 2 == 1 and v780[k187 + 1] or k188
        local v851 = v780[k187 - 2]
        if not v851 then
            local v852
            if k187 == 1 then
                v852 = 1
            else
                v852 = #v779
            end

            v851 = v779[v852]
            if not v851 then
                if k187 == 1 then
                    v852 = 8
                else
                    v852 = 14
                end

                v851 = v778[v852]
            end
        end

        k188.NextSelectionUp = v851
        k188.NextSelectionDown = v780[k187 + 2] or k188
    end

    local R1 = a0.PaletteColor.R
    local G1 = a0.PaletteColor.G
    local v853 = {R1, G1, a0.PaletteColor.B}
    for k189, k190 in ipairs(v853) do
        local v857 = a0.ChannelLabels[k189]
        local v858 = {"Red", "Green", "Blue"}
        local v859 = v858[k189]
        local v860 = v859 .. "  " .. tostring(math.floor(k190 * 255 + 0.5))
        if v857.Text ~= v860 then
            v857.Text = v860
        end
    end

    a0.DefaultFocus = v778[1]
    a0:FocusDefault()
end

v159.OpenPalette = OpenPalette

local function ChangeCategory(a0, a1) --[[ Upvalues: Query (copy) ]]
    if not a0.MenuOpen or a0.MenuKind ~= "Catalogue" then
        return
    end

    local v861 = (table.find(Query, a0.Category) or 1) - 1 + a1
    a0:_selectCategory(Query[v861 % #Query + 1])
end

v159.ChangeCategory = ChangeCategory

local function FocusDefault(a0) --[[ Upvalues: GuiService (copy) ]]
    if not (a0.Active and not a0.Obscured and a0.MenuOpen) then
        return
    end

    if a0.MenuKind == "Precision" then
        if a0:Owns(GuiService.SelectedObject) then
            GuiService.SelectedObject = nil
        end

        return
    end

    local v862
    if not (a0.MenuKind == "Catalogue" and a0.Catalogue) then
    end

    local LastFocus = a0.LastFocus
    if LastFocus then
        if LastFocus.Parent then
            if a0:Owns(LastFocus) then
                if LastFocus ~= a0.CloseButton then
                    if LastFocus:IsDescendantOf(v862) then
                        -- jump to 67
                    end

                    -- branch continues at 67
                end
            end
        end
    end

    LastFocus = a0.DefaultFocus
    if LastFocus and LastFocus.Parent then
        GuiService.SelectedObject = LastFocus
        return
    end

    GuiService.SelectedObject = a0.CloseButton
end

v159.FocusDefault = FocusDefault

local function CloseMenu(a0) --[[ Upvalues: GuiService (copy) ]]
    a0:_remember()
    a0.ThumbnailRequest = (a0.ThumbnailRequest or 0) + 1
    for k191, k192 in pairs(a0.ThumbnailItems) do
        local Preview3 = k191:FindFirstChild("Preview")
        if Preview3 then
            Preview3:Destroy()
        end

        k192.Loaded = nil
    end

    if a0:Owns(GuiService.SelectedObject) then
        GuiService.SelectedObject = nil
    end

    a0.MenuOpen = false
    a0.MenuKind = nil
    a0.Dimmer.Visible = false
    a0.HUD.Visible = true
    a0.Top.Visible = true
    a0.Reticle.Visible = true
    a0:Update(a0.State)
end

v159.CloseMenu = CloseMenu

local function SetActive(a0, a1)
    a0.Active = a1 == true
    if not a0.Active then
        a0:CloseMenu()
    end

    a0.Gui.Enabled = a0.Active
end

v159.SetActive = SetActive

local function SetObscured(a0, a1) --[[ Upvalues: GuiService (copy) ]]
    a1 = a1 == true
    if a0.Obscured == a1 then
        return
    end

    a0.Obscured = a1
    a0.Root.Visible = not a1
    if a1 then
        if a0:Owns(GuiService.SelectedObject) then
            GuiService.SelectedObject = nil
            return
            -- branch continues at 40
        end
    end

    if a0.Active and a0.MenuOpen then
        a0:FocusDefault()
    end
end

v159.SetObscured = SetObscured

local function Update(a0, a1) --[[ Upvalues: v4 (copy), sameValues (copy), v175 (copy), keyName (copy) ]]
    local v866 = a1
    if not v866 then
        v866 = {}
    end

    a0.State = v866
    a1 = a0.State
    v866 = false
    if type(a1.favorites) == "table" and a1.favorites ~= a0.FavoritesSource then
        a0.FavoritesSource = a1.favorites
        local v867 = v4.Favorites(a1.favorites)
        v866 = not sameValues(a0.Favorites, v867)
        a0.Favorites = v867
    end

    local v868 = a1.recents or a1.recent
    if type(v868) == "table" and v868 ~= a0.RecentsSource then
        a0.RecentsSource = v868
        local v869 = v4.Recents(v868)
        v866 = not sameValues(a0.Recents, v869) or v866
        a0.Recents = v869
    end

    if v866 and a0.MenuOpen and a0.MenuKind == "Catalogue" then
        a0:RefreshCatalogue()
    end

    local v870 = a1.deleting == true
    local v871 = true
    if a1.mode ~= "Paint" then
        v871 = a1.paintMode == true
    end

    v868 = v871
    if v868 then
        v868 = a1.pickerOpen == true
    end

    v866 = a0:_updatePaintTools(v871, a1)
    local v872 = false
    if a1.itemName ~= nil then
        v872 = false
        if a1.itemName ~= "" then
            v872 = not v871
        end
    end

    local v873
    if not (v872 and a1.itemName) then
        if v871 then
            v873 = "Paint brush"
        else
            v873 = "Choose an object"
        end
    end

    if v871 then
        local v874
        if v866 == "PaintBucket" then
            v874 = "Paint bucket"
        else
            v874 = "Paint brush"
        end

        v873 = v874
    end

    if v870 then
        v873 = a1.targetName and "Delete: " .. a1.targetName or "Delete tool"
    end

    if v872 and not v870 and a1.price then
        v873 = v873 .. "  \194\183  $" .. tostring(a1.price)
    end

    local ItemLabel = a0.ItemLabel
    if ItemLabel.Text ~= v873 then
        ItemLabel.Text = v873
    end

    local v877
    if not (v870 and v175.Danger) then
        v877 = v175.Text
    end

    a0.ItemLabel.TextColor3 = v877
    local ModeLabel = a0.ModeLabel
    local v878
    if v870 then
        v878 = "DELETE"
    else
        if v871 then
            v878 = "PAINT"
        else
            v878 = "BUILD"
        end
    end

    v877 = "MODERN  /  " .. v878
    if ModeLabel.Text ~= v877 then
        ModeLabel.Text = v877
    end

    local v879
    if not (v870 and v175.Danger) then
        v879 = v175.Accent
    end

    a0.ModeLabel.TextColor3 = v879
    v873 = a1.capacityText
    if not v873 then
        if a1.maxCapacity then
            local v881 = a1.count or a1.capacity or 0
            local v882 = tostring(v881)
            v873 = "Capacity: " .. v882 .. "/" .. tostring(a1.maxCapacity)
        end
    end

    local CapacityLabel = a0.CapacityLabel
    v879 = v873 or "Free camera  \194\183  Controller"
    if CapacityLabel.Text ~= v879 then
        CapacityLabel.Text = v879
    end

    CapacityLabel = a0.AxisLabel
    if v868 then
        v879 = "CHOOSE COLOUR"
    else
        if v870 then
            v879 = "TAP TO DELETE"
        else
            if v871 then
                v879 = "AIM TO PAINT"
            else
                if v872 then
                    if a1.following then
                        v879 = "FOLLOWING AIM"
                        -- jump to 276 (out of range)
                    end

                    v879 = "PARKED"
                else
                    v879 = ""
                end
            end
        end
    end

    if CapacityLabel.Text ~= v879 then
        CapacityLabel.Text = v879
    end

    if v868 then
        v873 = "Choose a colour with the cursor. Close the wheel to resume painting."
    else
        v873 = a1.status
    end

    if not v873 or v873 == "" then
        if a1.busy then
            CapacityLabel = "Applying your change\226\128\166"
        else
            local v883 = keyName(Enum.KeyCode.ButtonA, "A")
            CapacityLabel = "Aim at an object, then tap " .. v883 .. " to delete it."
            if not (v870 and CapacityLabel) then
                local v884 = keyName(Enum.KeyCode.ButtonR2, "RT")
                local v885 = keyName(Enum.KeyCode.ButtonX, "X")
                local v886 = keyName(Enum.KeyCode.ButtonY, "Y")
                CapacityLabel = "Aim to paint. " .. v884 .. " changes tools; " .. v885 .. " samples colour; " .. v886 .. " opens the colour wheel."
                if not (v871 and CapacityLabel) then
                    if v872 then
                        if a1.following then
                            CapacityLabel = "The preview follows your aim. Tap Keep here to inspect its position."
                            -- jump to 348 (out of range)
                        end

                        CapacityLabel = "Your object stays here while you move the camera. Precision adjusts its exact position."
                    else
                        local v887 = keyName(Enum.KeyCode.ButtonA, "A")
                        CapacityLabel = "Pick an existing object with " .. v887 .. ", or open the catalogue to add one."
                    end
                end
            end
        end

        v873 = CapacityLabel
    end

    CapacityLabel = a0.StatusLabel
    if CapacityLabel.Text ~= v873 then
        CapacityLabel.Text = v873
    end

    local v888
    if not (a1.valid == false and not v871 and not v870 and v175.Danger) then
        v888 = v175.Muted
    end

    a0.StatusLabel.TextColor3 = v888
    local ActionHint = a0.ActionHint
    if v868 then
        v888 = "Choose"
    else
        if v870 then
            v888 = "Delete"
        else
            if v871 then
                v888 = "Paint"
            else
                if v872 then
                    if a1.editingExisting then
                        v888 = "Save move"
                        -- jump to 394 (out of range)
                    end

                    v888 = "Place"
                else
                    v888 = "Pick object"
                end
            end
        end
    end

    if ActionHint.Text ~= v888 then
        ActionHint.Text = v888
    end

    ActionHint = a0.RotateHint
    if v871 then
        v888 = "Tool"
    else
        if a1.slowModifier then
            v888 = "Rotate \226\136\146"
        else
            v888 = "Rotate +"
        end
    end

    if ActionHint.Text ~= v888 then
        ActionHint.Text = v888
    end

    local v889
    if v872 or v871 then
        local v891 = not v870 and not v868
    end

    a0.RotateHint.Parent.Visible = v889
    local BackHint = a0.BackHint
    if v868 then
        v889 = "Close"
    else
        if v871 then
            v889 = "Objects"
        else
            if v872 or v870 then
                v889 = "Cancel"
                -- jump to 442 (out of range)
            end

            v889 = "Options"
        end
    end

    if BackHint.Text ~= v889 then
        BackHint.Text = v889
    end

    local v893 = v872 and not v870
    a0.FollowHint.Parent.Visible = v893
    local PrecisionHint = a0.PrecisionHint
    if v871 then
        v893 = "Sample"
    else
        v893 = "Precision"
    end

    if PrecisionHint.Text ~= v893 then
        PrecisionHint.Text = v893
    end

    local v894
    if v872 or v871 then
        local v896 = not v870 and not v868
    end

    a0.PrecisionHint.Parent.Visible = v894
    local MenuHint = a0.MenuHint
    if v868 then
        v894 = "Close wheel"
    else
        if v871 then
            v894 = "Colour wheel"
        else
            v894 = "Catalogue"
        end
    end

    if MenuHint.Text ~= v894 then
        MenuHint.Text = v894
    end

    a0.CameraHint.Parent.Visible = not v868
    if a1.slowModifier and a1.quickAdjustAvailable ~= false and not v871 and not v870 then
        v873 = "D-pad \226\134\144 / \226\134\146 Rotate \226\136\146 / +     \226\134\145 / \226\134\147 Grid height"
    else
        local v897 = tostring(a1.undoCount or 0)
        local v898 = tostring(a1.redoCount or 0)
        v873 = "D-pad \226\134\144 Undo " .. v897 .. " / \226\134\146 Redo " .. v898 .. "     \226\134\147 Delete     \226\134\145 Options"
    end

    local SecondaryLabel = a0.SecondaryLabel
    local v899
    if v868 then
        v899 = "Painting, camera movement and history are paused while choosing a colour."
    else
        local v900 = keyName(Enum.KeyCode.ButtonL1, "LB")
        local v901 = keyName(Enum.KeyCode.ButtonR1, "RB")
        v899 = v873 .. "     " .. v900 .. " / " .. v901 .. " Camera down / up"
    end

    if SecondaryLabel.Text ~= v899 then
        SecondaryLabel.Text = v899
    end

    local v902
    if not (v870 and v175.Danger) then
        if not (a1.valid == false and v175.Danger) then
            local v904
            if not (v872 and v175.Accent) then
                v904 = v175.Text
            end
        end
    end

    a0.Reticle.BackgroundColor3 = v902
    local v906 = not a0.MenuOpen and not v868
    a0.Reticle.Visible = v906
    a0:_updateQuickAdjust(a1)
    a0:_updatePrecision(a1)
end

v159.Update = Update

local function Destroy(a0)
    a0:CloseMenu()
    a0.Destroyed = true
    for k193, k194 in ipairs(a0.Connections) do
        k194:Disconnect()
    end

    a0.Connections = {}
    a0.Gui:Destroy()
end

v159.Destroy = Destroy
v50.UI = v159
v159 = {}
v159.__index = v159
local v910 = Color3.fromRGB(255, 255, 255)
local v911 = Color3.fromRGB(186, 186, 186)
local v912 = Color3.fromRGB(93, 93, 93)
local v913 = Color3.fromRGB(23, 23, 23)
local v914 = Color3.fromRGB(248, 225, 194)
local v915 = Color3.fromRGB(195, 150, 102)
local v916 = Color3.fromRGB(125, 86, 58)
local v917 = Color3.fromRGB(85, 60, 47)
local v918 = Color3.fromRGB(255, 123, 123)
local v919 = Color3.fromRGB(215, 54, 54)
local v920 = Color3.fromRGB(255, 170, 75)
local v921 = Color3.fromRGB(248, 222, 88)
local v922 = Color3.fromRGB(169, 209, 133)
local v923 = Color3.fromRGB(69, 142, 87)
local v924 = Color3.fromRGB(89, 196, 183)
local v925 = Color3.fromRGB(76, 113, 206)
local v926 = Color3.fromRGB(117, 94, 172)
local v927 = Color3.fromRGB(201, 138, 210)
local v929 = {
    v910,
    v911,
    v912,
    v913,
    v914,
    v915,
    v916,
    v917,
    v918,
    v919,
    v920,
    v921,
    v922,
    v923,
    v924,
    Color3.fromRGB(87, 178, 220),
    v925,
    v926,
    v927,
    Color3.fromRGB(244, 170, 191)
}

local function rect(a0, a1, a2, a3, a4)
    local v930 = UDim2.fromOffset(a1, a2)
    a0.Position = v930
    a0.Size = UDim2.fromOffset(a3, a4)
end

local function outline1(a0, a1) --[[ Upvalues: v175 (copy) ]]
    local t10 = {
        Name = "Outline",
        Transparency = 0.25,
        Color = v175.Text,
        Thickness = a1 or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }
    local UIStroke2 = Instance.new("UIStroke")
    for k195, k196 in pairs(t10) do
        UIStroke2[k195] = k196
    end

    UIStroke2.Parent = a0
    return UIStroke2
end

local function label1(a0, a1, a2, a3) --[[ Upvalues: v175 (copy) ]]
    local t11 = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = a1,
        TextSize = a2 or 15
    }
    local v935 = a3 or v175.Text
    t11.TextColor3 = v935
    t11.Font = Enum.Font.Code
    t11.TextXAlignment = Enum.TextXAlignment.Left
    t11.TextTruncate = Enum.TextTruncate.AtEnd
    local TextLabel1 = Instance.new("TextLabel")
    for k197, k198 in pairs(t11) do
        TextLabel1[k197] = k198
    end

    TextLabel1.Parent = a0
    return TextLabel1
end

local function isPress(a0)
    local v939 = true
    if a0.UserInputType ~= Enum.UserInputType.Touch then
        v939 = a0.UserInputType == Enum.UserInputType.MouseButton1
    end

    return v939
end

local function point(a0)
    local v940 = Vector2.new(a0.Position.X, a0.Position.Y)
    return v940
end

local function selected(a0, a1) --[[ Upvalues: v175 (copy) ]]
    local v941
    if not (a1 and v175.Text) then
        v941 = v175.Panel
    end

    a0.BackgroundColor3 = v941
    if a1 then
        v941 = 0.02
    else
        v941 = 0.18
    end

    a0.BackgroundTransparency = v941
    local v942
    if not (a1 and v175.Panel) then
        v942 = v175.Text
    end

    a0.TextColor3 = v942
    local Outline = a0:FindFirstChild("Outline")
    if Outline then
        local v943
        if a1 then
            v943 = 0
        else
            v943 = 0.25
        end

        Outline.Transparency = v943
    end
end

local function colorText(a0) --[[ Upvalues: v175 (copy) ]]
    local v944 = a0.R * 0.299
    local v945 = v944 + a0.G * 0.587
    local v946 = v945 + a0.B * 0.114
    local v947
    if not (0.6 < v946 and v175.Panel) then
        v947 = v175.Text
    end

    return v947
end

local function asSet(a0)
    local t12 = {}
    if type(a0) == "table" then
        for k199, k200 in pairs(a0) do
            if type(k199) == "string" and k200 then
                t12[k199] = true
            else
                if type(k200) == "string" then
                    t12[k200] = true
                end
            end
        end
    end

    return t12
end

local function _allowed(a0, a1)
    local Active3 = a0.Active
    if Active3 then
        Active3 = not a0.Destroyed
        if Active3 then
            Active3 = not a0.State.blocked
            if Active3 then
                Active3 = true
                if a1 ~= nil then
                    Active3 = a1 == a0.MenuOpen
                end
            end
        end
    end

    return Active3
end

v175 = {
    Panel = Color3.new(0, 0, 0),
    Text = Color3.new(1, 1, 1),
    Muted = Color3.fromRGB(195, 195, 195),
    Danger = Color3.fromRGB(255, 153, 153)
}
v159._allowed = _allowed

local function _action(a0, a1)
    if a0:_allowed() and a0.Callbacks.Action then
        a0.Callbacks.Action(a1)
    end
end

v159._action = _action

local function _setting(a0, a1, a2)
    if not a0:_allowed() then
        return
    end

    a0.State[a1] = a2
    if a0.Callbacks.Setting then
        a0.Callbacks.Setting(a1, a2)
    end

    a0:Update(a0.State)
    if a0.MenuKind == "Precision" or a0.MenuKind == "Camera" then
        a0:_updateOptions()
    end
end

v159._setting = _setting

local function _button1(a0, a1, a2, a3, a4, a5) --[[ Upvalues: v175 (copy) ]]
    local v951 = {
        TextSize = 15,
        BackgroundTransparency = 0.18,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Active = true,
        Selectable = false,
        TextWrapped = true,
        Name = a2,
        Text = a3,
        Size = UDim2.fromOffset(80, 48),
        Font = Enum.Font.Code,
        TextColor3 = v175.Text,
        BackgroundColor3 = v175.Panel
    }
    local TextButton1 = Instance.new("TextButton")
    for k201, k202 in pairs(v951) do
        TextButton1[k201] = k202
    end

    TextButton1.Parent = a1
    local v955 = {
        Name = "Outline",
        Thickness = 1,
        Transparency = 0.25,
        Color = v175.Text,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }
    v951 = Instance.new("UIStroke")
    for k203, k204 in pairs(v955) do
        v951[k203] = k204
    end

    v951.Parent = TextButton1
    if a4 then
        TextButton1.Activated:Connect(function() --[[ Upvalues: a0 (copy), a5 (copy), TextButton1 (copy), a4 (copy) ]]
            if a0:_allowed(a5) and TextButton1:GetAttribute("Disabled") ~= true then
                a4()
            end

        end)
    end

    return TextButton1
end

v159._button = _button1

local function _enable(a0, a1, a2)
    a1:SetAttribute("Disabled", not a2)
    local v959
    if a2 then
        v959 = 0
    else
        v959 = 0.55
    end

    a1.TextTransparency = v959
    local Outline1 = a1:FindFirstChild("Outline")
    if Outline1 then
        local v960
        if a2 then
            v960 = 0.25
        else
            v960 = 0.7
        end

        Outline1.Transparency = v960
    end
end

v159._enable = _enable

local function new1(a0, a1) --[[ Upvalues: asSet (copy), v159 (copy), v175 (copy), label1 (copy), Query (copy), UserInputService (copy), GuiService (copy) ]]
    local v961 = {
        Active = false,
        MenuOpen = false,
        Category = "Furniture",
        SubCategory = "All",
        SearchQuery = "",
        Columns = 3,
        CardHeight = 158,
        ThumbnailRequest = 0,
        CatalogueGeneration = 0,
        Client = a0
    }
    local v962 = a1
    if not v962 then
        v962 = {}
    end

    v961.Callbacks = v962
    v961.State = {}
    v961.Connections = {}
    v961.Cards = {}
    v961.ThumbnailItems = {}
    v961.CategoryButtons = {}
    v961.OptionControls = {}
    local v963 = a0.Data and a0.Data.ModernBuildFavorites
    v961.Favorites = asSet(v963)
    v961.Recents = {}
    v961.HeightInputs = {}
    v961.ColorInputs = {}
    local v964 = setmetatable(v961, v159)
    local PlayerGui1 = a0.Player:WaitForChild("PlayerGui")
    local v965 = {
        Name = "ModernBuildMobileUI",
        Enabled = false,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 50,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }
    local ScreenGui = Instance.new("ScreenGui")
    for k205, k206 in pairs(v965) do
        ScreenGui[k205] = k206
    end

    ScreenGui.Parent = PlayerGui1
    v964.Root = ScreenGui
    v964.Root.ScreenInsets = Enum.ScreenInsets.None
    local v969 = {
        Name = "World",
        BackgroundTransparency = 1,
        Active = false,
        Size = UDim2.fromScale(1, 1)
    }
    local Root4 = v964.Root
    local Frame13 = Instance.new("Frame")
    for k207, k208 in pairs(v969) do
        Frame13[k207] = k208
    end

    Frame13.Parent = Root4
    v964.World = Frame13
    v969 = {
        Name = "Aim",
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(8, 8),
        BackgroundColor3 = v175.Text
    }
    local World = v964.World
    Frame13 = Instance.new("Frame")
    for k209, k210 in pairs(v969) do
        Frame13[k209] = k210
    end

    Frame13.Parent = World
    v964.Reticle = Frame13
    Frame13 = {Thickness = 2, Color = v175.Panel}
    local Reticle1 = v964.Reticle
    local UIStroke3 = Instance.new("UIStroke")
    for k211, k212 in pairs(Frame13) do
        UIStroke3[k211] = k212
    end

    UIStroke3.Parent = Reticle1
    Reticle1 = {
        Name = "ModernBuildMobileControls",
        Enabled = false,
        ResetOnSpawn = false,
        DisplayOrder = 51,
        ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }
    Frame13 = Instance.new("ScreenGui")
    for k213, k214 in pairs(Reticle1) do
        Frame13[k213] = k214
    end

    Frame13.Parent = PlayerGui1
    v964.ControlsGui = Frame13
    Reticle1 = {Name = "SafeArea", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)}
    local ControlsGui = v964.ControlsGui
    Frame13 = Instance.new("Frame")
    for k215, k216 in pairs(Reticle1) do
        Frame13[k215] = k216
    end

    Frame13.Parent = ControlsGui
    v964.Safe = Frame13
    Reticle1 = {Name = "Controls", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)}
    local Safe = v964.Safe
    Frame13 = Instance.new("Frame")
    for k217, k218 in pairs(Reticle1) do
        Frame13[k217] = k218
    end

    Frame13.Parent = Safe
    v964.Controls = Frame13
    Safe = v964.Controls
    Frame13 = Instance.new("Frame")
    for k219, k220 in pairs({Name = "Top", BackgroundTransparency = 1}) do
        Frame13[k219] = k220
    end

    Frame13.Parent = Safe
    v964.Top = Frame13
    v964.Build = v964:_button(v964.Top, "Build", "Build", function() --[[ Upvalues: v964 (copy) ]]
        v964:_action("build")
    end, false)
    v964.Paint = v964:_button(v964.Top, "Paint", "Paint", function() --[[ Upvalues: v964 (copy) ]]
        v964:_action("paint")
    end, false)
    v964.DeleteMode = v964:_button(v964.Top, "DeleteMode", "Delete", function() --[[ Upvalues: v964 (copy) ]]
        v964:_action("deleteMode")
    end, false)
    v964.DeleteMode.TextSize = 14
    v964.Classic = v964:_button(v964.Top, "ClassicMode", "Classic mode", function() --[[ Upvalues: v964 (copy) ]]
        v964:_action("classic")
    end, false)
    v964.Undo = v964:_button(v964.Top, "Undo", "Undo", function() --[[ Upvalues: v964 (copy) ]]
        v964:_action("undo")
    end, false)
    v964.Redo = v964:_button(v964.Top, "Redo", "Redo", function() --[[ Upvalues: v964 (copy) ]]
        v964:_action("redo")
    end, false)
    v964.Camera = v964:_button(v964.Top, "Camera", "Camera", function() --[[ Upvalues: v964 (copy) ]]
        v964:OpenCamera()
    end, false)
    local v991 = false
    v964.Done = v964:_button(v964.Top, "Done", "Done", function() --[[ Upvalues: v964 (copy) ]]
        v964:_action("done")
    end, v991)
    local v992 = {
        Name = "Selection",
        BackgroundTransparency = 0.26,
        BorderSizePixel = 0,
        BackgroundColor3 = v175.Panel
    }
    local Controls = v964.Controls
    local Frame14 = Instance.new("Frame")
    for k221, k222 in pairs(v992) do
        Frame14[k221] = k222
    end

    Frame14.Parent = Controls
    v964.Caption = Frame14
    v964.ItemLabel = label1(v964.Caption, "Free camera", 16)
    v964.StatusLabel = label1(v964.Caption, "Tap an object to select. Swipe to look.", 13, v175.Muted)
    v964.StatusLabel.TextWrapped = true
    v964.StatusLabel.TextTruncate = Enum.TextTruncate.None
    v964.StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
    local Controls1 = v964.Controls
    local Frame15 = Instance.new("Frame")
    for k223, k224 in pairs({Name = "CameraMovement", BackgroundTransparency = 1}) do
        Frame15[k223] = k224
    end

    Frame15.Parent = Controls1
    v964.Navigation = Frame15
    local v999 = nil
    k223 = false
    v964.Joystick = v964:_button(v964.Navigation, "Joystick", "", v999, k223)
    v964.Joystick.BackgroundTransparency = 0.42
    local v1000 = {CornerRadius = UDim.new(1, 0)}
    local Joystick = v964.Joystick
    PlayerGui1 = Instance.new("UICorner")
    for k225, k226 in pairs(v1000) do
        PlayerGui1[k225] = k226
    end

    PlayerGui1.Parent = Joystick
    Joystick = {
        Name = "Knob",
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(44, 44),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = v175.Text
    }
    local Joystick1 = v964.Joystick
    v1000 = Instance.new("Frame")
    for k227, k228 in pairs(Joystick) do
        v1000[k227] = k228
    end

    v1000.Parent = Joystick1
    v964.JoyKnob = v1000
    v1000 = {CornerRadius = UDim.new(1, 0)}
    local JoyKnob = v964.JoyKnob
    local UICorner = Instance.new("UICorner")
    for k229, k230 in pairs(v1000) do
        UICorner[k229] = k230
    end

    UICorner.Parent = JoyKnob
    v964.JoyLabel = label1(v964.Navigation, "MOVE CAMERA", 11, v175.Muted)
    v964.JoyLabel.TextXAlignment = Enum.TextXAlignment.Center
    v964.CameraUp = v964:_button(v964.Navigation, "CameraUp", "\226\134\145", nil, false)
    local v1010 = false
    v964.CameraDown = v964:_button(v964.Navigation, "CameraDown", "\226\134\147", nil, v1010)
    v964.CameraUp.TextSize = 25
    v964.CameraDown.TextSize = 25
    local Controls2 = v964.Controls
    local Frame16 = Instance.new("Frame")
    for k231, k232 in pairs({Name = "ObjectActions", BackgroundTransparency = 1}) do
        Frame16[k231] = k232
    end

    Frame16.Parent = Controls2
    v964.Dock = Frame16
    Controls2 = v964.Dock
    Frame16 = Instance.new("Frame")
    for k233, k234 in pairs({Name = "ContextTools", BackgroundTransparency = 1}) do
        Frame16[k233] = k234
    end

    Frame16.Parent = Controls2
    v964.Tools = Frame16
    v964.Move = v964:_button(v964.Tools, "Move", "Move", function() --[[ Upvalues: v964 (copy) ]]
        v964:_action("move")
    end, false)
    v964.Height = v964:_button(v964.Tools, "Height", "Height", function() --[[ Upvalues: v964 (copy) ]]
        v964:_action("height")
    end, false)
    v964.Rotate = v964:_button(v964.Tools, "Rotate", "Turn", function() --[[ Upvalues: v964 (copy) ]]
        v964:_action("rotate")
    end, false)
    v964.MoveHandle = v964:_button(v964.Dock, "MoveHandle", "\226\156\165  Drag to move", nil, false)
    v964.AdjustMinus = v964:_button(v964.Dock, "AdjustMinus", "\226\136\146 90\194\176", function() --[[ Upvalues: v964 (copy) ]]
        local v1017
        if v964.State.tool == "Height" then
            v1017 = "heightDown"
        else
            v1017 = "rotateLeft"
        end

        v964:_action(v1017)
    end, false)
    v964.AdjustPlus = v964:_button(v964.Dock, "AdjustPlus", "+ 90\194\176", function() --[[ Upvalues: v964 (copy) ]]
        local v1018
        if v964.State.tool == "Height" then
            v1018 = "heightUp"
        else
            v1018 = "rotateRight"
        end

        v964:_action(v1018)
    end, false)
    v964.Primary = v964:_button(v964.Dock, "Primary", "Choose object", function() --[[ Upvalues: v964 (copy) ]]
        if v964.State.mode ~= "Paint" and not v964.State.itemName then
            v964:OpenCatalogue()
            return
        end

        v964:_action("apply")
    end, false)
    v964.Primary.TextSize = 18
    v964.Cancel = v964:_button(v964.Dock, "Cancel", "Cancel", function() --[[ Upvalues: v964 (copy) ]]
        v964:_action("cancel")
    end, false)
    v964.FineTune = v964:_button(v964.Dock, "FineTune", "Fine tune", function() --[[ Upvalues: v964 (copy) ]]
        v964:OpenPrecision()
    end, false)
    v964.Duplicate = v964:_button(v964.Dock, "Duplicate", "Duplicate", function() --[[ Upvalues: v964 (copy) ]]
        v964:_action("duplicate")
    end, false)
    v964.Delete = v964:_button(v964.Dock, "Delete", "Delete", function() --[[ Upvalues: v964 (copy) ]]
        v964:_action("delete")
    end, false)
    v964.Delete.TextColor3 = v175.Danger
    v964.Brush = v964:_button(v964.Tools, "Brush", "Brush", function() --[[ Upvalues: v964 (copy) ]]
        v964:_action("brush")
    end, false)
    v964.Bucket = v964:_button(v964.Tools, "Bucket", "Bucket", function() --[[ Upvalues: v964 (copy) ]]
        v964:_action("bucket")
    end, false)
    v964.Dropper = v964:_button(v964.Tools, "Dropper", "Sample", function() --[[ Upvalues: v964 (copy) ]]
        v964:_action("dropper")
    end, false)
    v964.Color = v964:_button(v964.Dock, "Color", "Colour", function() --[[ Upvalues: v964 (copy) ]]
        v964:OpenColors()
    end, false)
    v964.PaintScope = label1(v964.Dock, "Brush \194\183 one surface", 12, v175.Muted)
    v964.PaintScope.TextWrapped = true
    v964.PaintScope.TextXAlignment = Enum.TextXAlignment.Center
    local v1019 = false
    v964.CatalogueButton = v964:_button(v964.Controls, "Objects", "Objects", function() --[[ Upvalues: v964 (copy) ]]
        v964:OpenCatalogue()
    end, v1019)
    local v1020 = {
        Name = "MenuOverlay",
        BackgroundTransparency = 0.55,
        BorderSizePixel = 0,
        Visible = false,
        Active = true,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = v175.Panel
    }
    local Safe1 = v964.Safe
    local Frame17 = Instance.new("Frame")
    for k235, k236 in pairs(v1020) do
        Frame17[k235] = k236
    end

    Frame17.Parent = Safe1
    v964.Dimmer = Frame17
    v1020 = {
        Name = "Drawer",
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        Active = true,
        BackgroundColor3 = v175.Panel
    }
    local Dimmer1 = v964.Dimmer
    Frame17 = Instance.new("Frame")
    for k237, k238 in pairs(v1020) do
        Frame17[k237] = k238
    end

    Frame17.Parent = Dimmer1
    v964.Menu = Frame17
    Frame17 = v964.Menu
    Dimmer1 = {
        Name = "Outline",
        Thickness = 1,
        Transparency = 0.25,
        Color = v175.Text,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }
    v1020 = Instance.new("UIStroke")
    for k239, k240 in pairs(Dimmer1) do
        v1020[k239] = k240
    end

    v1020.Parent = Frame17
    v964.Title = label1(v964.Menu, "Objects", 18)
    k239 = true
    v964.CloseButton = v964:_button(v964.Menu, "Close", "Back", function() --[[ Upvalues: v964 (copy) ]]
        v964:CloseMenu()
        if v964.Callbacks.Close then
            v964.Callbacks.Close()
        end

    end, k239)
    local v1030 = {
        Name = "Search",
        Text = "",
        PlaceholderText = "Search objects\226\128\166",
        TextSize = 16,
        ClearTextOnFocus = false,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        PlaceholderColor3 = v175.Muted,
        TextColor3 = v175.Text,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundColor3 = v175.Panel
    }
    local Menu7 = v964.Menu
    local TextBox = Instance.new("TextBox")
    for k241, k242 in pairs(v1030) do
        TextBox[k241] = k242
    end

    TextBox.Parent = Menu7
    v964.Search = TextBox
    TextBox = v964.Search
    Menu7 = {
        Name = "Outline",
        Thickness = 1,
        Transparency = 0.25,
        Color = v175.Text,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }
    v1030 = Instance.new("UIStroke")
    for k243, k244 in pairs(Menu7) do
        v1030[k243] = k244
    end

    v1030.Parent = TextBox
    TextBox = {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 8)}
    local Search = v964.Search
    local UIPadding2 = Instance.new("UIPadding")
    for k245, k246 in pairs(TextBox) do
        UIPadding2[k245] = k246
    end

    UIPadding2.Parent = Search
    Search = {Name = "Catalogue", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)}
    local Menu8 = v964.Menu
    TextBox = Instance.new("Frame")
    for k247, k248 in pairs(Search) do
        TextBox[k247] = k248
    end

    TextBox.Parent = Menu8
    v964.Catalogue = TextBox
    Search = {
        Name = "Categories",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollingDirection = Enum.ScrollingDirection.X,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.X
    }
    local Catalogue3 = v964.Catalogue
    TextBox = Instance.new("ScrollingFrame")
    for k249, k250 in pairs(Search) do
        TextBox[k249] = k250
    end

    TextBox.Parent = Catalogue3
    v964.CategoryList = TextBox
    TextBox = {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }
    local CategoryList = v964.CategoryList
    local UIListLayout = Instance.new("UIListLayout")
    for k251, k252 in pairs(TextBox) do
        UIListLayout[k251] = k252
    end

    UIListLayout.Parent = CategoryList
    for k253, k254 in ipairs(Query) do
        local v1052 = v964:_button(v964.CategoryList, k254, k254, function() --[[ Upvalues: v964 (copy), k254 (copy) ]]
            v964.Category = k254
            v964.SubCategory = "All"
            v964:RefreshCatalogue()
        end, true)
        local v1053 = math.max(88, #k254 * 9 + 16)
        v1052.Size = UDim2.fromOffset(v1053, 44)
        v1052.LayoutOrder = k253
        local CategoryButtons = v964.CategoryButtons
        CategoryButtons[k253] = v1052
    end

    local v1054 = {
        Name = "Subcategories",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollingDirection = Enum.ScrollingDirection.X,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.X
    }
    local Catalogue4 = v964.Catalogue
    local ScrollingFrame2 = Instance.new("ScrollingFrame")
    for k255, k256 in pairs(v1054) do
        ScrollingFrame2[k255] = k256
    end

    ScrollingFrame2.Parent = Catalogue4
    v964.SubList = ScrollingFrame2
    ScrollingFrame2 = {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }
    local SubList1 = v964.SubList
    local UIListLayout1 = Instance.new("UIListLayout")
    for k257, k258 in pairs(ScrollingFrame2) do
        UIListLayout1[k257] = k258
    end

    UIListLayout1.Parent = SubList1
    SubList1 = {
        Name = "Items",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    }
    local Catalogue5 = v964.Catalogue
    ScrollingFrame2 = Instance.new("ScrollingFrame")
    for k259, k260 in pairs(SubList1) do
        ScrollingFrame2[k259] = k260
    end

    ScrollingFrame2.Parent = Catalogue5
    v964.ItemList = ScrollingFrame2
    ScrollingFrame2 = {PaddingBottom = UDim.new(0, 8), PaddingRight = UDim.new(0, 6)}
    local ItemList3 = v964.ItemList
    local UIPadding3 = Instance.new("UIPadding")
    for k261, k262 in pairs(ScrollingFrame2) do
        UIPadding3[k261] = k262
    end

    UIPadding3.Parent = ItemList3
    ItemList3 = {
        CellSize = UDim2.fromOffset(132, 158),
        CellPadding = UDim2.fromOffset(8, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }
    local ItemList4 = v964.ItemList
    ScrollingFrame2 = Instance.new("UIGridLayout")
    for k263, k264 in pairs(ItemList3) do
        ScrollingFrame2[k263] = k264
    end

    ScrollingFrame2.Parent = ItemList4
    v964.Grid = ScrollingFrame2
    v964.Empty = label1(v964.Catalogue, "No matching objects.", 16, v175.Muted)
    v964.Empty.TextWrapped = true
    v964.Empty.TextTruncate = Enum.TextTruncate.None
    v964.Empty.TextXAlignment = Enum.TextXAlignment.Center
    local v1070 = {
        Name = "Options",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        Visible = false,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y
    }
    local Menu9 = v964.Menu
    local ScrollingFrame3 = Instance.new("ScrollingFrame")
    for k265, k266 in pairs(v1070) do
        ScrollingFrame3[k265] = k266
    end

    ScrollingFrame3.Parent = Menu9
    v964.Options = ScrollingFrame3
    ScrollingFrame3 = {Padding = UDim.new(0, 14), SortOrder = Enum.SortOrder.LayoutOrder}
    local Options3 = v964.Options
    local UIListLayout2 = Instance.new("UIListLayout")
    for k267, k268 in pairs(ScrollingFrame3) do
        UIListLayout2[k267] = k268
    end

    UIListLayout2.Parent = Options3
    ScrollingFrame3 = {PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 12)}
    local Options4 = v964.Options
    local UIPadding4 = Instance.new("UIPadding")
    for k269, k270 in pairs(ScrollingFrame3) do
        UIPadding4[k269] = k270
    end

    UIPadding4.Parent = Options4
    v964.Joystick.InputBegan:Connect(function(a0) --[[ Upvalues: v964 (copy) ]]
        if v964:_allowed(false) then
            local v1080 = true
            if a0.UserInputType ~= Enum.UserInputType.Touch then
                v1080 = a0.UserInputType == Enum.UserInputType.MouseButton1
            end

            if v1080 and not v964.JoyInput then
                v964.JoyInput = a0
                v964:_heightChanged()
                v964:_moveStick(a0)
            end
        end

    end)
    local CameraDown = v964.CameraDown
    local v1081 = -1
    local v1082 = {[v964.CameraUp] = 1, [CameraDown] = v1081}
    for k271, k272 in pairs(v1082) do
        k271.InputBegan:Connect(function(a0) --[[ Upvalues: v964 (copy), k272 (copy) ]]
            if v964:_allowed(false) then
                local v1086 = true
                if a0.UserInputType ~= Enum.UserInputType.Touch then
                    v1086 = a0.UserInputType == Enum.UserInputType.MouseButton1
                end

                if v1086 and a0.UserInputState == Enum.UserInputState.Begin and not v964.JoyInput and not v964.DragInput then
                    v964.HeightInputs[a0] = k272
                    v964:_heightChanged()
                end
            end

        end)
    end

    v964.MoveHandle.InputBegan:Connect(function(a0) --[[ Upvalues: v964 (copy), v175 (upvalue) ]]
        if v964:_allowed(false) then
            if v964.State.itemName then
                local v1087 = true
                if a0.UserInputType ~= Enum.UserInputType.Touch then
                    v1087 = a0.UserInputType == Enum.UserInputType.MouseButton1
                end

                if v1087 and not v964.DragInput then
                    v964.DragInput = a0
                    v964:_heightChanged()
                    local MoveHandle = v964.MoveHandle
                    local v1088 = v175.Text or v175.Panel
                    MoveHandle.BackgroundColor3 = v1088
                    MoveHandle.BackgroundTransparency = 0.02
                    local v1089 = v175.Panel or v175.Text
                    MoveHandle.TextColor3 = v1089
                    local Outline2 = MoveHandle:FindFirstChild("Outline")
                    if Outline2 then
                        Outline2.Transparency = 0
                    end

                    if v964.Callbacks.MoveBegin then
                        v964.Callbacks.MoveBegin(a0)
                    end
                end
            end
        end

    end)
    local v1091 = UserInputService.InputChanged:Connect(function(a0) --[[ Upvalues: v964 (copy) ]]
        local v1090 = a0.UserInputType == Enum.UserInputType.MouseMovement
        if v964.JoyInput then
            if a0 ~= v964.JoyInput then
                if v1090 then
                    if v964.JoyInput.UserInputType ~= Enum.UserInputType.MouseButton1 then
                        -- jump to 33
                    end

                    -- branch continues at 33
                end
            end

            v964:_moveStick(a0)
        end

        if v964.DragInput then
            if a0 ~= v964.DragInput then
                if v1090 then
                    if v964.DragInput.UserInputType ~= Enum.UserInputType.MouseButton1 then
                        return
                    end

                    -- branch continues at 66
                end
            end

            if v964.Callbacks.MoveChanged then
                v964.Callbacks.MoveChanged(a0)
            end
        end

    end)
    table.insert(v964.Connections, v1091)
    local v1092 = UserInputService.InputEnded:Connect(function(a0) --[[ Upvalues: v964 (copy) ]]
        if a0 == v964.JoyInput then
            v964:_stopStick()
        end

        if v964.HeightInputs[a0] then
            v964.HeightInputs[a0] = nil
            v964:_heightChanged()
        end

        if a0 == v964.DragInput then
            v964:_stopDrag(a0.UserInputState == Enum.UserInputState.Cancel)
        end

    end)
    table.insert(v964.Connections, v1092)
    local v1093 = UserInputService.WindowFocusReleased:Connect(function() --[[ Upvalues: v964 (copy) ]]
        v964:_stopInputs()
    end)
    table.insert(v964.Connections, v1093)
    local v1094 = UserInputService.TextBoxFocused:Connect(function() --[[ Upvalues: v964 (copy) ]]
        v964:_stopInputs()
    end)
    table.insert(v964.Connections, v1094)
    local v1095 = GuiService.MenuOpened:Connect(function() --[[ Upvalues: v964 (copy) ]]
        v964:_stopInputs()
    end)
    table.insert(v964.Connections, v1095)
    local v1096 = v964.Safe:GetPropertyChangedSignal("AbsoluteSize")
    local v1097 = v1096:Connect(function() --[[ Upvalues: v964 (copy) ]]
        v964:_resize()
    end)
    table.insert(v964.Connections, v1097)
    local v1098 = v964.World:GetPropertyChangedSignal("AbsoluteSize")
    local v1099 = v1098:Connect(function() --[[ Upvalues: v964 (copy) ]]
        v964:_syncAim()
    end)
    table.insert(v964.Connections, v1099)
    local v1100 = v964.World:GetPropertyChangedSignal("AbsolutePosition")
    local v1101 = v1100:Connect(function() --[[ Upvalues: v964 (copy) ]]
        v964:_syncAim()
    end)
    table.insert(v964.Connections, v1101)
    local v1102 = workspace:GetPropertyChangedSignal("CurrentCamera")
    local v1103 = v1102:Connect(function() --[[ Upvalues: v964 (copy) ]]
        v964:_bindCamera()
    end)
    table.insert(v964.Connections, v1103)
    local v1104 = v964.ItemList:GetPropertyChangedSignal("CanvasPosition")
    local v1105 = v1104:Connect(function() --[[ Upvalues: v964 (copy) ]]
        v964:_queueThumbnails()
    end)
    table.insert(v964.Connections, v1105)
    local v1106 = v964.Search:GetPropertyChangedSignal("Text")
    local v1107 = v1106:Connect(function() --[[ Upvalues: v964 (copy) ]]
        v964.SearchQuery = string.lower(v964.Search.Text)
        v964.SearchRequest = (v964.SearchRequest or 0) + 1
        local SearchRequest = v964.SearchRequest
        task.delay(0.12, function() --[[ Upvalues: v964 (upvalue), SearchRequest (copy) ]]
            if not v964.Destroyed and SearchRequest == v964.SearchRequest then
                v964:RefreshCatalogue()
            end

        end)
    end)
    table.insert(v964.Connections, v1107)
    local v1108 = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible")
    local v1109 = v1108:Connect(function() --[[ Upvalues: v964 (copy) ]]
        v964:_resize()
    end)
    table.insert(v964.Connections, v1109)
    local v1110 = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition")
    local v1111 = v1110:Connect(function() --[[ Upvalues: v964 (copy) ]]
        v964:_resize()
    end)
    table.insert(v964.Connections, v1111)
    local v1112 = v964.Search.FocusLost:Connect(function() --[[ Upvalues: v964 (copy) ]]
        v964:_resize()
    end)
    table.insert(v964.Connections, v1112)
    v964:_bindCamera()
    v964:_resize()
    v964:Update({})
    return v964
end

v159.new = new1

local function _moveStick(a0, a1)
    if not a0:_allowed(false) then
        a0:_stopStick()
        return
    end

    local v1113 = a0.Joystick.AbsolutePosition + a0.Joystick.AbsoluteSize / 2
    local v1114 = math.max(1, a0.Joystick.AbsoluteSize.X / 2 - 22)
    local v1115 = (Vector2.new(a1.Position.X, a1.Position.Y) - v1113) / v1114
    if 1 < v1115.Magnitude then
        v1115 = v1115.Unit
    end

    local v1116 = v1115.X * v1114
    a0.JoyKnob.Position = UDim2.new(0.5, v1116, 0.5, v1115.Y * v1114)
    v1114 = v1115.Magnitude
    if v1114 < 0.1 then
        v1115 = Vector2.zero
    else
        v1115 = v1115.Unit * ((v1114 - 0.1) / 0.9)
    end

    if a0.Callbacks.CameraMove then
        a0.Callbacks.CameraMove(v1115)
    end
end

v159._moveStick = _moveStick

local function _stopStick(a0)
    a0.JoyInput = nil
    a0:_heightChanged()
    a0.JoyKnob.Position = UDim2.fromScale(0.5, 0.5)
    if a0.Callbacks.CameraMove then
        a0.Callbacks.CameraMove(Vector2.zero)
    end
end

v159._stopStick = _stopStick

local function _heightChanged(a0)
    local v1117 = true
    if a0.JoyInput == nil then
        v1117 = a0.DragInput ~= nil
    end

    if v1117 then
        table.clear(a0.HeightInputs)
    end

    a0:_enable(a0.CameraUp, not v1117)
    a0:_enable(a0.CameraDown, not v1117)
    v1117 = 0
    for k273, k274 in pairs(a0.HeightInputs) do
        v1117 = v1117 + k274
    end

    if a0.Callbacks.CameraHeight then
        a0.Callbacks.CameraHeight(math.clamp(v1117, -1, 1))
    end
end

v159._heightChanged = _heightChanged

local function _stopDrag(a0, a1) --[[ Upvalues: v175 (copy) ]]
    local DragInput = a0.DragInput
    a0.DragInput = nil
    a0:_heightChanged()
    local MoveHandle1 = a0.MoveHandle
    MoveHandle1.BackgroundColor3 = v175.Panel
    MoveHandle1.BackgroundTransparency = 0.18
    MoveHandle1.TextColor3 = v175.Text
    local Outline3 = MoveHandle1:FindFirstChild("Outline")
    if Outline3 then
        Outline3.Transparency = 0.25
    end

    if DragInput then
        if a0.Callbacks.MoveEnd then
            a0.Callbacks.MoveEnd(DragInput, a1 == true)
        end
    end
end

v159._stopDrag = _stopDrag

local function _stopInputs(a0)
    a0:_stopStick()
    a0.HeightInputs = {}
    a0:_heightChanged()
    a0:_stopDrag(true)
end

v159._stopInputs = _stopInputs

local function _bindCamera(a0)
    if a0.CameraConnection then
        a0.CameraConnection:Disconnect()
    end

    a0.CameraConnection = nil
    local CurrentCamera = workspace.CurrentCamera
    if CurrentCamera then
        local v1121 = CurrentCamera:GetPropertyChangedSignal("ViewportSize")
        a0.CameraConnection = v1121:Connect(function() --[[ Upvalues: a0 (copy) ]]
            a0:_syncAim()
        end)
    end

    a0:_syncAim()
end

v159._bindCamera = _bindCamera

local function _syncAim(a0) --[[ Upvalues: GuiService (copy) ]]
    if a0.Destroyed then
        return
    end

    local CurrentCamera1 = workspace.CurrentCamera
    if not CurrentCamera1 then
        return
    end

    local v1122 = CurrentCamera1.ViewportSize / 2
    local v1123 = v1122 - GuiService:GetGuiInset()
    local v1124 = v1123 - a0.World.AbsolutePosition
    a0.Reticle.Position = UDim2.fromOffset(v1124.X, v1124.Y)
end

v159._syncAim = _syncAim

local function _resize1(a0) --[[ Upvalues: UserInputService (copy), GuiService (copy) ]]
    if a0.Destroyed then
        return
    end

    a0:_syncAim()
    local AbsoluteSize1 = a0.Safe.AbsoluteSize
    if AbsoluteSize1.X < 1 or AbsoluteSize1.Y < 1 then
        return
    end

    local v1125 = AbsoluteSize1.X <= AbsoluteSize1.Y
    local X1 = AbsoluteSize1.X
    local Y2 = AbsoluteSize1.Y
    if v1125 or true >= 336 then
        v1126 = v1125
        if v1126 then
            v1126 = true < 510
        end
    end

    a0.CompactContext = v1126
    if X1 < 520 then
        AbsoluteSize1 = 100
    else
        AbsoluteSize1 = 48
    end

    local Top = a0.Top
    local v1127 = UDim2.fromOffset(8, 8)
    Top.Position = v1127
    Top.Size = UDim2.fromOffset(X1 - 16, AbsoluteSize1)
    if AbsoluteSize1 == 100 then
        Top = (X1 - 40) / 4
        local Build = a0.Build
        local Paint = a0.Paint
        v1127 = {Build, Paint, a0.Classic, a0.Done}
        for k275, k276 in ipairs(v1127) do
            local v1131 = (k275 - 1) * (Top + 8)
            local v1132 = UDim2.fromOffset(v1131, 0)
            k276.Position = v1132
            k276.Size = UDim2.fromOffset(Top, 44)
        end

        k275 = a0.Undo
        k276 = a0.Redo
        local v1133 = {k275, k276, a0.DeleteMode, a0.Camera}
        for k277, k278 in ipairs(v1133) do
            local v1137 = (k277 - 1) * (Top + 8)
            local v1138 = UDim2.fromOffset(v1137, 52)
            k278.Position = v1138
            k278.Size = UDim2.fromOffset(Top, 44)
        end
    else
        Top = a0.Build
        local v1139 = UDim2.fromOffset(0, 0)
        Top.Position = v1139
        Top.Size = UDim2.fromOffset(52, 44)
        Top = a0.Paint
        local v1140 = UDim2.fromOffset(60, 0)
        Top.Position = v1140
        Top.Size = UDim2.fromOffset(52, 44)
        Top = a0.DeleteMode
        local v1141 = UDim2.fromOffset(120, 0)
        Top.Position = v1141
        Top.Size = UDim2.fromOffset(60, 44)
        Top = a0.Undo
        local v1142 = UDim2.fromOffset(188, 0)
        Top.Position = v1142
        Top.Size = UDim2.fromOffset(44, 44)
        Top = a0.Redo
        local v1143 = UDim2.fromOffset(240, 0)
        Top.Position = v1143
        Top.Size = UDim2.fromOffset(44, 44)
        Top = a0.Classic
        local v1144 = UDim2.fromOffset(292, 0)
        Top.Position = v1144
        Top.Size = UDim2.fromOffset(76, 44)
        Top = a0.Camera
        local v1145 = UDim2.fromOffset(X1 - 144, 0)
        Top.Position = v1145
        Top.Size = UDim2.fromOffset(72, 44)
        Top = a0.Done
        local v1146 = UDim2.fromOffset(X1 - 64, 0)
        Top.Position = v1146
        Top.Size = UDim2.fromOffset(48, 44)
    end

    local v1147
    if not (v1125 and X1 - 16) then
        local v1148 = math.min(340, math.max(240, X1 - 300))
    end

    local v1149 = v1125
    if v1149 then
        v1149 = true < 530
    end

    v1127 = a0.Caption
    local v1150
    if v1149 then
        v1150 = 44
    else
        v1150 = 56
    end

    local v1151 = UDim2.fromOffset(8, AbsoluteSize1 + 16)
    v1127.Position = v1151
    v1127.Size = UDim2.fromOffset(v1147, v1150)
    v1127 = a0.ItemLabel
    local v1152 = UDim2.fromOffset(10, 3)
    v1127.Position = v1152
    v1127.Size = UDim2.fromOffset(v1147 - 20, 22)
    v1127 = a0.StatusLabel
    if v1149 then
        v1152 = 18
    else
        v1152 = 29
    end

    local v1153 = UDim2.fromOffset(10, 25)
    v1127.Position = v1153
    v1127.Size = UDim2.fromOffset(v1147 - 20, v1152)
    a0.StatusLabel.TextWrapped = not v1149
    a0.StatusLabel.TextTruncate = v1149 and Enum.TextTruncate.AtEnd or Enum.TextTruncate.None
    v1149 = true - 8
    local v1155 = v1125 and math.min(174, math.floor(X1 * 0.46)) or 190
    local v1157 = v1125 and math.min(110, v1155 - 52) or 124
    local v1158 = v1157 + 18
    local v1159
    if v1125 then
        v1159 = 52
    else
        v1159 = 0
    end

    local Navigation = a0.Navigation
    local v1160 = v1149 - v1158 - v1159
    local v1161 = UDim2.fromOffset(8, v1160)
    Navigation.Position = v1161
    Navigation.Size = UDim2.fromOffset(v1155, v1158)
    Navigation = a0.Joystick
    local v1162 = UDim2.fromOffset(0, 0)
    Navigation.Position = v1162
    Navigation.Size = UDim2.fromOffset(v1157, v1157)
    Navigation = a0.CameraUp
    local v1163 = UDim2.fromOffset(v1157 + 8, 0)
    Navigation.Position = v1163
    Navigation.Size = UDim2.fromOffset(44, 48)
    Navigation = a0.CameraDown
    local v1164 = UDim2.fromOffset(v1157 + 8, 56)
    Navigation.Position = v1164
    Navigation.Size = UDim2.fromOffset(44, 48)
    Navigation = a0.JoyLabel
    local v1165 = UDim2.fromOffset(0, v1157 + 2)
    Navigation.Position = v1165
    Navigation.Size = UDim2.fromOffset(v1157, 16)
    local v1167 = v1125 and math.min(212, X1 - v1155 - 24) or 232
    v1167 = math.max(144, v1167)
    v1157 = v1149 - 214 - v1159
    local Dock = a0.Dock
    local v1168 = UDim2.fromOffset(X1 - v1167 - 8, v1157)
    Dock.Position = v1168
    Dock.Size = UDim2.fromOffset(v1167, 214)
    Dock = a0.Tools
    local v1169 = UDim2.fromOffset(0, 0)
    Dock.Position = v1169
    Dock.Size = UDim2.fromOffset(v1167, 44)
    v1159 = (v1167 - 12) / 3
    local v1170 = {a0.Move, a0.Height, a0.Rotate}
    local v1171 = {a0.Brush, a0.Bucket, a0.Dropper}
    local v1172 = {v1170, v1171}
    for k279, k280 in ipairs(v1172) do
        for k281, k282 in ipairs(k280) do
            local v1181 = (k281 - 1) * (v1159 + 6)
            local v1182 = UDim2.fromOffset(v1181, 0)
            k282.Position = v1182
            k282.Size = UDim2.fromOffset(v1159, 44)
        end
    end

    v1159 = (v1167 - 6) / 2
    local MoveHandle2 = a0.MoveHandle
    local v1183 = UDim2.fromOffset(0, 50)
    MoveHandle2.Position = v1183
    MoveHandle2.Size = UDim2.fromOffset(v1167, 44)
    MoveHandle2 = a0.AdjustMinus
    local v1184 = UDim2.fromOffset(0, 50)
    MoveHandle2.Position = v1184
    MoveHandle2.Size = UDim2.fromOffset(v1159, 44)
    MoveHandle2 = a0.AdjustPlus
    local v1185 = UDim2.fromOffset(v1159 + 6, 50)
    MoveHandle2.Position = v1185
    MoveHandle2.Size = UDim2.fromOffset(v1159, 44)
    MoveHandle2 = a0.Primary
    local v1186 = UDim2.fromOffset(0, 100)
    MoveHandle2.Position = v1186
    MoveHandle2.Size = UDim2.fromOffset(v1167, 56)
    MoveHandle2 = a0.Cancel
    local v1187 = UDim2.fromOffset(0, 162)
    MoveHandle2.Position = v1187
    MoveHandle2.Size = UDim2.fromOffset(v1159, 46)
    MoveHandle2 = a0.FineTune
    local v1188 = UDim2.fromOffset(v1159 + 6, 162)
    MoveHandle2.Position = v1188
    MoveHandle2.Size = UDim2.fromOffset(v1159, 46)
    MoveHandle2 = a0.Duplicate
    local v1189 = UDim2.fromOffset(0, -50)
    MoveHandle2.Position = v1189
    MoveHandle2.Size = UDim2.fromOffset(v1159, 44)
    MoveHandle2 = a0.Delete
    local v1190 = UDim2.fromOffset(v1159 + 6, -50)
    MoveHandle2.Position = v1190
    MoveHandle2.Size = UDim2.fromOffset(v1159, 44)
    v1159 = false
    if a0.State.itemName ~= nil then
        v1159 = false
        if a0.State.existing == true then
            v1159 = false
            if a0.State.mode ~= "Paint" then
                v1159 = not a0.CompactContext
            end
        end
    end

    a0.Duplicate.Visible = v1159
    a0.Delete.Visible = v1159
    local Color = a0.Color
    local v1191 = UDim2.fromOffset(0, 50)
    Color.Position = v1191
    Color.Size = UDim2.fromOffset(v1167, 44)
    Color = a0.PaintScope
    local v1192 = UDim2.fromOffset(0, 162)
    Color.Position = v1192
    Color.Size = UDim2.fromOffset(v1167, 42)
    if v1125 then
        Color = a0.CatalogueButton
        local v1193 = UDim2.fromOffset(8, v1149 - 44)
        Color.Position = v1193
        Color.Size = UDim2.fromOffset(X1 - 16, 44)
    else
        Color = v1155 + 16
        local v1194 = X1 - v1167 - 16
        v1159 = math.clamp(v1194 - Color, 80, 132)
        local CatalogueButton = a0.CatalogueButton
        local v1195 = math.floor((Color + v1194 - v1159) / 2)
        local v1196 = UDim2.fromOffset(v1195, v1149 - 48)
        CatalogueButton.Position = v1196
        CatalogueButton.Size = UDim2.fromOffset(v1159, 48)
    end

    local v1197
    if not (v1125 and X1 - 16) then
        v1197 = math.min(820, X1 - 32)
    end

    v1149 = math.min(760, true - 16)
    v1155 = UserInputService:GetFocusedTextBox()
    local OnScreenKeyboardVisible = UserInputService.OnScreenKeyboardVisible
    if OnScreenKeyboardVisible then
        OnScreenKeyboardVisible = false
        if v1155 ~= nil then
            OnScreenKeyboardVisible = v1155:IsDescendantOf(a0.Menu)
        end
    end

    if OnScreenKeyboardVisible then
        local v1199 = UserInputService.OnScreenKeyboardPosition.Y - GuiService:GetGuiInset().Y
        v1157 = v1199 - a0.Safe.AbsolutePosition.Y
        if 0 < v1157 then
            v1149 = math.min(v1149, math.max(128, v1157 - 16))
        end
    end

    local Menu10 = a0.Menu
    local v1200 = math.floor((X1 - v1197) / 2)
    local v1201
    if OnScreenKeyboardVisible then
        v1201 = 8
    else
        local v1202 = math.floor((true - v1149) / 2)
    end

    local v1203 = UDim2.fromOffset(v1200, v1201)
    Menu10.Position = v1203
    Menu10.Size = UDim2.fromOffset(v1197, v1149)
    Menu10 = a0.Title
    local v1204 = UDim2.fromOffset(12, 8)
    Menu10.Position = v1204
    Menu10.Size = UDim2.fromOffset(v1197 - 104, 44)
    Menu10 = a0.CloseButton
    local v1205 = UDim2.fromOffset(v1197 - 84, 8)
    Menu10.Position = v1205
    Menu10.Size = UDim2.fromOffset(72, 44)
    local v1206 = 560 <= v1197
    if v1206 then
        local Title5 = a0.Title
        local v1207 = UDim2.fromOffset(12, 8)
        Title5.Position = v1207
        Title5.Size = UDim2.fromOffset(120, 44)
        Title5 = a0.Search
        local v1208 = UDim2.fromOffset(140, 8)
        Title5.Position = v1208
        Title5.Size = UDim2.fromOffset(v1197 - 236, 44)
    else
        local Search1 = a0.Search
        local v1209 = UDim2.fromOffset(12, 60)
        Search1.Position = v1209
        Search1.Size = UDim2.fromOffset(v1197 - 24, 44)
    end

    if v1206 then
        X1 = 60
    else
        X1 = 112
    end

    local v1210 = OnScreenKeyboardVisible
    if v1210 then
        v1210 = v1149 < 300
    end

    local CategoryList1 = a0.CategoryList
    local v1211 = UDim2.fromOffset(12, X1)
    CategoryList1.Position = v1211
    CategoryList1.Size = UDim2.fromOffset(v1197 - 24, 48)
    CategoryList1 = a0.SubList
    local v1212 = UDim2.fromOffset(12, X1 + 54)
    CategoryList1.Position = v1212
    CategoryList1.Size = UDim2.fromOffset(v1197 - 24, 48)
    a0.CategoryList.Visible = not v1210
    local v1213 = not v1210
    if v1213 then
        v1213 = false
        if a0.Category ~= "Recent" then
            v1213 = a0.Category ~= "Favorites"
        end
    end

    a0.SubList.Visible = v1213
    local v1214
    if v1210 then
        if v1206 then
            v1214 = 60
            -- jump to 1225 (out of range)
        end

        v1214 = 112
    else
        if a0.SubList.Visible then
            v1213 = 108
        else
            v1213 = 54
        end

        v1214 = X1 + v1213
    end

    v1213 = a0.ItemList
    local v1215 = math.max(36, v1149 - v1214 - 10)
    local v1216 = UDim2.fromOffset(12, v1214)
    v1213.Position = v1216
    v1213.Size = UDim2.fromOffset(v1197 - 24, v1215)
    v1213 = a0.Empty
    local v1217 = math.max(36, v1149 - v1214 - 10)
    local v1218 = UDim2.fromOffset(24, v1214)
    v1213.Position = v1218
    v1213.Size = UDim2.fromOffset(v1197 - 48, v1217)
    local v1219 = math.max(1, math.floor((v1197 - 24) / 140))
    local v1220 = v1197 - 30
    local v1221 = (v1219 - 1) * 8
    v1210 = math.floor((v1220 - v1221) / v1219)
    if v1149 < 450 then
        v1206 = 144
    else
        v1206 = 170
    end

    if a0.CardWidth ~= v1210 or a0.CardHeight ~= v1206 then
        for k283, k284 in pairs(a0.ThumbnailItems) do
            X1 = k283:FindFirstChild("Preview")
            if X1 then
                X1:Destroy()
            end

            k284.Loaded = nil
        end
    end

    a0.CardWidth = v1210
    a0.CardHeight = v1206
    a0.Columns = v1219
    v1221 = v1206
    a0.Grid.FillDirectionMaxCells = v1219
    a0.Grid.CellSize = UDim2.fromOffset(v1210, v1221)
    for k285, k286 in ipairs(a0.Cards) do
        a0:_layoutCard(k286)
    end

    local Options5 = a0.Options
    local v1228 = math.max(48, v1149 - 76)
    local v1229 = UDim2.fromOffset(12, 64)
    Options5.Position = v1229
    Options5.Size = UDim2.fromOffset(v1197 - 24, v1228)
    a0:_layoutOptions()
    if OnScreenKeyboardVisible and v1155 ~= a0.Search and v1155:IsDescendantOf(a0.Options) then
        local v1230 = v1155.AbsolutePosition.Y - a0.Options.AbsolutePosition.Y
        v1219 = v1230 + a0.Options.CanvasPosition.Y
        a0.Options.CanvasPosition = Vector2.new(0, math.max(0, v1219 - 34))
    end

    a0:_queueThumbnails()
end

v159._resize = _resize1

local function _layoutCard(a0, a1)
    local ItemTitle = a1:FindFirstChild("ItemTitle")
    local Price = a1:FindFirstChild("Price")
    local Preview4 = a1:FindFirstChild("Preview")
    local Favorite1 = a1:FindFirstChild("Favorite")
    local v1231 = a0.CardHeight - 66
    if ItemTitle then
        local v1232 = a0.CardWidth - 16
        local v1233 = UDim2.fromOffset(8, v1231 + 2)
        ItemTitle.Position = v1233
        ItemTitle.Size = UDim2.fromOffset(v1232, 36)
    end

    if Price then
        local v1234 = a0.CardHeight - 26
        local v1235 = a0.CardWidth - 16
        local v1236 = UDim2.fromOffset(8, v1234)
        Price.Position = v1236
        Price.Size = UDim2.fromOffset(v1235, 22)
    end

    if Preview4 then
        Preview4.Size = UDim2.new(1, -12, 0, v1231)
    end

    if Favorite1 then
        local v1237 = a0.CardWidth - 46
        local v1238 = UDim2.fromOffset(v1237, 2)
        Favorite1.Position = v1238
        Favorite1.Size = UDim2.fromOffset(44, 44)
    end
end

v159._layoutCard = _layoutCard

local function _thumbnail1(a0, a1, a2) --[[ Upvalues: createThumbnail (copy) ]]
    local v1239 = UDim2.new(1, -12, 0, a0.CardHeight - 66)
    local v1240 = UDim2.fromOffset(6, 4)
    createThumbnail(a0, a1, a2, v1239, v1240, 1.5, 2)
end

v159._thumbnail = _thumbnail1

local function _queueThumbnails1(a0)
    a0.ThumbnailRequest = a0.ThumbnailRequest + 1
    if not a0:_allowed(true) or a0.MenuKind ~= "Catalogue" then
        return
    end

    local ThumbnailRequest1 = a0.ThumbnailRequest
    local CatalogueGeneration2 = a0.CatalogueGeneration
    task.defer(function() --[[ Upvalues: a0 (copy), ThumbnailRequest1 (copy), CatalogueGeneration2 (copy) ]]

        local function current1() --[[ Upvalues: a0 (upvalue), ThumbnailRequest1 (upvalue), CatalogueGeneration2 (upvalue) ]]
            local v1241 = a0:_allowed(true)
            if v1241 then
                v1241 = false
                if a0.MenuKind == "Catalogue" then
                    v1241 = false
                    if a0.ThumbnailRequest == ThumbnailRequest1 then
                        v1241 = a0.CatalogueGeneration == CatalogueGeneration2
                    end
                end
            end

            return v1241
        end

        local v1242 = a0:_allowed(true)
        if v1242 then
            v1242 = false
            if a0.MenuKind == "Catalogue" then
                v1242 = false
                if a0.ThumbnailRequest == ThumbnailRequest1 then
                    v1242 = a0.CatalogueGeneration == CatalogueGeneration2
                end
            end
        end

        if not v1242 then
            return
        end

        v1242 = a0.CardHeight + 8
        local v1243 = math.max(0, math.floor(a0.ItemList.CanvasPosition.Y / v1242) - 1)
        local Y3 = a0.ItemList.CanvasPosition.Y
        local Y4 = a0.ItemList.AbsoluteSize.Y
        local v1244 = math.floor((Y3 + Y4) / v1242) + 1
        v1242 = 0
        for k287, k288 in ipairs(a0.Cards) do
            local v1248 = a0:_allowed(true)
            if v1248 then
                v1248 = false
                if a0.MenuKind == "Catalogue" then
                    v1248 = false
                    if a0.ThumbnailRequest == ThumbnailRequest1 then
                        v1248 = a0.CatalogueGeneration == CatalogueGeneration2
                    end
                end
            end

            if not v1248 then
                return
            end

            v1248 = a0.ThumbnailItems[k288]
            local v1249 = math.floor((k287 - 1) / a0.Columns)
            if v1243 <= v1249 then
                if v1249 <= v1244 then
                    if not v1248.Loaded then
                        if not v1248.Failed then
                            local v1250 = pcall(function() --[[ Upvalues: a0 (upvalue), k288 (copy), v1248 (copy) ]]
                                a0:_thumbnail(k288, v1248.Name)
                            end)
                            local v1251 = v1250
                            if v1251 then
                                v1251 = k288:FindFirstChild("Preview") ~= nil
                            end

                            v1248.Loaded = v1251
                            v1248.Failed = not v1248.Loaded
                            if not v1250 and k288:FindFirstChild("Preview") then
                                k288.Preview:Destroy()
                            end

                            v1242 = v1242 + 1
                            if v1242 % 2 == 0 then
                                task.wait()
                                -- branch continues at 204
                            end

                            -- branch continues at 204
                        end

                        -- branch continues at 204
                    end

                    -- branch continues at 188
                end
            else
                if v1248.Loaded then
                    local Preview5 = k288:FindFirstChild("Preview")
                    if Preview5 then
                        Preview5:Destroy()
                    end

                    v1248.Loaded = nil
                end
            end
        end

    end)
end

v159._queueThumbnails = _queueThumbnails1

local function RefreshCatalogue1(a0) --[[ Upvalues: clear (copy), Recents (copy), Query (copy), v175 (copy), label1 (copy) ]]
    if not a0:_allowed(true) or a0.MenuKind ~= "Catalogue" then
        return
    end

    a0.CatalogueGeneration = a0.CatalogueGeneration + 1
    clear(a0.SubList)
    clear(a0.ItemList)
    a0.Cards = {}
    a0.ThumbnailItems = {}
    local Data5 = a0.Client.Data
    if not Data5 then
        Data5 = {}
    end

    local UnlockedObjects1 = Data5.UnlockedObjects
    if not UnlockedObjects1 then
        UnlockedObjects1 = {}
    end

    local BaseItems2 = Data5.BaseItems
    if not BaseItems2 then
        BaseItems2 = {}
    end

    local Query1 = Recents.Query
    local v1252 = {
        Policy = "ModernTouch",
        Data = Data5,
        Category = a0.Category,
        SubCategory = a0.SubCategory,
        SearchQuery = a0.SearchQuery,
        Favorites = a0.Favorites
    }
    local v1253 = a0.State.recent or a0.Recents
    v1252.Recents = v1253
    local v1254 = Query1(v1252)
    v1252 = v1254.Subcategories
    v1253 = v1254.Objects
    a0.SubCategory = v1254.SubCategory
    for k289, k290 in ipairs(Query) do
        local v1258 = a0.CategoryButtons[k289]
        local v1259 = k290 == a0.Category
        local v1260
        if not (v1259 and v175.Text) then
            v1260 = v175.Panel
        end

        v1258.BackgroundColor3 = v1260
        if v1259 then
            v1260 = 0.02
        else
            v1260 = 0.18
        end

        v1258.BackgroundTransparency = v1260
        local v1261
        if not (v1259 and v175.Panel) then
            v1261 = v175.Text
        end

        v1258.TextColor3 = v1261
        v1254 = v1258:FindFirstChild("Outline")
        if v1254 then
            local v1262
            if v1259 then
                v1262 = 0
            else
                v1262 = 0.25
            end

            v1254.Transparency = v1262
        end
    end

    for k291, k292 in ipairs(v1252) do
        local v1266 = a0:_button(a0.SubList, k292, k292, function() --[[ Upvalues: a0 (copy), k292 (copy) ]]
            a0.SubCategory = k292
            a0:RefreshCatalogue()
        end, true)
        local v1267 = math.max(64, #k292 * 9 + 20)
        v1266.Size = UDim2.fromOffset(v1267, 44)
        v1266.LayoutOrder = k291
        local v1268 = k292 == a0.SubCategory
        local v1269
        if not (v1268 and v175.Text) then
            v1269 = v175.Panel
        end

        v1266.BackgroundColor3 = v1269
        if v1268 then
            v1269 = 0.02
        else
            v1269 = 0.18
        end

        v1266.BackgroundTransparency = v1269
        local v1270
        if not (v1268 and v175.Panel) then
            v1270 = v175.Text
        end

        v1266.TextColor3 = v1270
        local Outline4 = v1266:FindFirstChild("Outline")
        if Outline4 then
            local v1271
            if v1268 then
                v1271 = 0
            else
                v1271 = 0.25
            end

            Outline4.Transparency = v1271
        end
    end

    for k293, k294 in ipairs(v1253) do
        local Name1 = k294.Name
        local Info1 = k294.Info
        v1252 = tonumber(BaseItems2[Name1]) or 0
        local v1278 = Info1.Unlock and not UnlockedObjects1[Name1]
        local v1279 = not Info1.ItemObject
        if not v1279 then
            v1279 = 0 < v1252
        end

        local ItemObject = Info1.ItemObject
        if not ItemObject then
            local v1280 = tonumber(Data5.Money) or 0
            ItemObject = (tonumber(Info1.Price) or 0) <= v1280
        end

        local v1284 = not v1278 and v1279 and ItemObject
        local v1285 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Name = Name1,
            LayoutOrder = k293
        }
        local ItemList5 = a0.ItemList
        local Frame18 = Instance.new("Frame")
        for k295, k296 in pairs(v1285) do
            Frame18[k295] = k296
        end

        Frame18.Parent = ItemList5
        Frame18:SetAttribute("ItemName", Name1)
        k295 = function() --[[ Upvalues: v1284 (copy), a0 (copy), v1278 (copy), Name1 (copy), v1279 (copy), Info1 (copy) ]]
            if not v1284 then
                local Title6 = a0.Title
                local v1290
                if not (v1278 and "Unlock " .. Name1) then
                    if not v1279 then
                        v1290 = "None owned"
                    else
                        v1290 = "Not enough money"
                    end
                end

                if Title6.Text ~= v1290 then
                    Title6.Text = v1290
                end

                return
            end

            for i5 = #a0.Recents, 1, -1 do
                local v1293 = a0.Recents[i5]
                if v1293 == Name1 then
                    table.remove(a0.Recents, i5)
                end
            end

            table.insert(a0.Recents, 1, Name1)
            local v1294 = #a0.Recents
            if 24 < v1294 then
                table.remove(a0.Recents)
            end

            a0:CloseMenu()
            if a0.Callbacks.SelectItem then
                a0.Callbacks.SelectItem(Name1, Info1.Type)
            end
        end

        k296 = true
        local v1295 = a0:_button(Frame18, "Choose", "", k295, k296)
        v1295.Size = UDim2.fromScale(1, 1)
        local v1296
        if v1284 then
            v1296 = 0.15
        else
            v1296 = 0.4
        end

        v1295.BackgroundTransparency = v1296
        local v1297
        if not (v1278 and v175.Muted) then
            v1297 = v175.Text
        end

        local v1298 = label1(Frame18, Name1, 15, v1297)
        v1298.Name = "ItemTitle"
        v1298.TextWrapped = true
        v1298.TextTruncate = Enum.TextTruncate.None
        v1298.ZIndex = 2
        if v1278 then
            v1298 = "Locked"
        else
            if Info1.ItemObject then
                if 0 < v1252 then
                    v1298 = "Owned \195\151" .. v1252
                    if v1298 then
                        -- jump to 400
                    end
                end

                v1298 = "None owned"
            else
                local v1299 = tostring(Info1.Price or 0)
                local v1300
                if not ItemObject then
                    v1300 = " \194\183 need funds"
                else
                    v1300 = ""
                end

                v1298 = "$" .. v1299 .. v1300
            end
        end

        k295 = v175
        k295 = k295.Muted
        if not (v1284 and k295) then
            k295 = v175
            k295 = k295.Danger
        end

        ItemObject = label1(Frame18, v1298, 13, k295)
        ItemObject.Name = "Price"
        ItemObject.ZIndex = 2
        k296 = a0.Favorites
        k295 = k296[Name1]
        if k295 then
            v1297 = "\226\152\133"
        else
            v1297 = "\226\152\134"
        end

        k295 = function() --[[ Upvalues: a0 (copy), Name1 (copy), Frame18 (copy) ]]
            a0.Favorites[Name1] = not a0.Favorites[Name1] or nil
            a0.State.favorites = table.clone(a0.Favorites)
            if a0.Callbacks.Setting then
                local v1301 = table.clone(a0.Favorites)
                a0.Callbacks.Setting("favorites", v1301)
            end

            if a0.Category == "Favorites" then
                a0:RefreshCatalogue()
                return
            end

            local Favorite2 = Frame18.Favorite
            local v1302
            if a0.Favorites[Name1] then
                v1302 = "\226\152\133"
            else
                v1302 = "\226\152\134"
            end

            if Favorite2.Text ~= v1302 then
                Favorite2.Text = v1302
            end
        end

        k296 = true
        local v1303 = a0:_button(Frame18, "Favorite", 13, k295, k296)
        v1303.ZIndex = 3
        v1303.TextSize = 25
        v1303.BackgroundTransparency = 0.1
        local v1304 = {Name = Name1}
        a0.ThumbnailItems[Frame18] = v1304
        table.insert(a0.Cards, Frame18)
        a0:_layoutCard(Frame18)
    end

    local Title7 = a0.Title
    local v1305 = "Objects \194\183 " .. #v1253
    if Title7.Text ~= v1305 then
        Title7.Text = v1305
    end

    Title7 = a0.Empty
    if a0.Category == "Recent" then
        v1305 = "Objects you use will appear here."
    else
        if a0.Category == "Favorites" then
            v1305 = "Tap \226\152\134 on any object to save it here."
        else
            v1305 = "No matching objects. Try another search or category."
        end
    end

    if Title7.Text ~= v1305 then
        Title7.Text = v1305
    end

    a0.Empty.Visible = #v1253 == 0
    a0.ItemList.CanvasPosition = Vector2.zero
    a0:_resize()
end

v159.RefreshCatalogue = RefreshCatalogue1

local function _section(a0, a1, a2, a3, a4) --[[ Upvalues: label1 (copy), v175 (copy) ]]
    local v1306 = a4
    local v1307 = {
        BackgroundTransparency = 1,
        Name = a1,
        Size = UDim2.new(1, 0, 0, v1306),
        LayoutOrder = a3
    }
    local Options6 = a0.Options
    local Frame19 = Instance.new("Frame")
    for k297, k298 in pairs(v1307) do
        Frame19[k297] = k298
    end

    Frame19.Parent = Options6
    local v1311 = label1(Frame19, a2, 15, v175.Muted)
    v1311.Name = "Heading"
    v1311.Size = UDim2.new(1, 0, 0, 24)
    return Frame19
end

v159._section = _section

local function _choices(a0, a1, a2, a3, a4)
    local t13 = {}
    for k299, k300 in ipairs(a3) do
        local v1315 = tostring(k300)
        local v1316 = tostring(k300)
        local v1317 = v1316 .. (a4 or "")
        local v1318 = a0:_button(a1, v1315, v1317, function() --[[ Upvalues: a0 (copy), a2 (copy), k300 (copy) ]]
            a0:_setting(a2, k300)
        end, true)
        v1318:SetAttribute("OptionValue", k300)
        v1318.LayoutOrder = k299
        table.insert(t13, v1318)
    end

    a0.OptionControls[a2] = t13
end

v159._choices = _choices

local function _layoutOptions(a0)
    if not a0.Options then
        return
    end

    local v1319 = a0.Options.AbsoluteSize.X - 6
    if v1319 < 1 then
        return
    end

    local v1320 = a0.Options:GetChildren()
    for k301, k302 in ipairs(v1320) do
        if k302:IsA("Frame") and not k302:GetAttribute("ManualLayout") then
            local v1324 = {}
            local v1325 = k302:GetChildren()
            for k303, k304 in ipairs(v1325) do
                if k304:IsA("GuiButton") then
                    table.insert(v1324, k304)
                end
            end

            table.sort(v1324, function(a0, a1)
                return a0.LayoutOrder < a1.LayoutOrder
            end)
            local v1329 = v1319 + 6
            local v1330 = v1329 / 70
            local v1331 = math.min(#v1324, math.max(1, math.floor(v1330)))
            if 0 < #v1324 then
                local v1332 = (v1319 - (v1331 - 1) * 6) / v1331
                for k305, k306 in ipairs(v1324) do
                    local v1336 = (k305 - 1) % v1331
                    local v1337 = v1336 * (v1332 + 6)
                    v1336 = math.floor((k305 - 1) / v1331) * 54 + 30
                    local v1338 = UDim2.fromOffset(v1337, v1336)
                    k306.Position = v1338
                    k306.Size = UDim2.fromOffset(v1332, 48)
                end

                k302.Size = UDim2.new(1, 0, 0, math.ceil(#v1324 / v1331) * 54 + 30)
            end
        end
    end
end

v159._layoutOptions = _layoutOptions

local function _updateOptions(a0) --[[ Upvalues: v175 (copy) ]]
    for k307, k308 in pairs(a0.OptionControls) do
        for k309, k310 in ipairs(k308) do
            local v1346 = k310:GetAttribute("OptionValue")
            local v1347 = a0.State[k307] == v1346
            local v1348
            if not (v1347 and v175.Text) then
                v1348 = v175.Panel
            end

            k310.BackgroundColor3 = v1348
            if v1347 then
                v1348 = 0.02
            else
                v1348 = 0.18
            end

            k310.BackgroundTransparency = v1348
            local v1349
            if not (v1347 and v175.Panel) then
                v1349 = v175.Text
            end

            k310.TextColor3 = v1349
            local Outline5 = k310:FindFirstChild("Outline")
            if Outline5 then
                local v1350
                if v1347 then
                    v1350 = 0
                else
                    v1350 = 0.25
                end

                Outline5.Transparency = v1350
            end

            if k310:GetAttribute("Toggle") then
                local v1351 = k310:GetAttribute("Label")
                local v1352
                if a0.State[k307] then
                    v1352 = " \194\183 On"
                else
                    v1352 = " \194\183 Off"
                end

                local v1353 = v1351 .. v1352
                if k310.Text ~= v1353 then
                    k310.Text = v1353
                end
            end
        end
    end
end

v159._updateOptions = _updateOptions

local function _open1(a0, a1)
    if not a0:_allowed() then
        return false
    end

    a0:_stopInputs()
    a0.MenuOpen = true
    a0.MenuKind = a1
    a0.Dimmer.Visible = true
    a0.Controls.Visible = false
    a0.World.Visible = false
    local Search2 = a0.Search
    a0.Catalogue.Visible = a1 == "Catalogue"
    Search2.Visible = a1 == "Catalogue"
    a0.Options.Visible = a1 ~= "Catalogue"
    a0.OptionControls = {}
    a0:_resize()
    return true
end

v159._open = _open1

local function OpenCatalogue1(a0)
    if a0:_open("Catalogue") then
        a0:RefreshCatalogue()
    end
end

v159.OpenCatalogue = OpenCatalogue1

local function OpenPrecision1(a0) --[[ Upvalues: clear (copy), v61 (copy), v157 (copy), v175 (copy) ]]
    if not a0:_open("Precision") then
        return
    end

    local Title8 = a0.Title
    if Title8.Text ~= "Fine tune" then
        Title8.Text = "Fine tune"
    end

    clear(a0.Options)
    local v1354 = {"X", "Y", "Z"}
    a0:_choices(a0:_section("Axis", "Rotation axis", 1, 84), "axis", v1354)
    a0:_choices(a0:_section("MoveStep", "Move increment \194\183 studs", 2, 84), "moveStep", v61)
    a0:_choices(a0:_section("RotateStep", "Turn increment", 3, 84), "rotateStep", v157, "\194\176")
    local v1355 = a0:_section("Nudge", "Offset selected object", 4, 84)
    local v1356 = {"X", -1}
    local v1357 = {"X", 1}
    local v1358 = {"Y", -1}
    local v1359 = {"Y", 1}
    local v1360 = {"Z", -1}
    local v1361 = {"Z", 1}
    local v1362 = {v1356, v1357, v1358, v1359, v1360, v1361}
    for k311, k312 in ipairs(v1362) do
        v1358 = k312[1]
        v1359 = k312[2]
        local v1366 = v1358 .. v1359
        local v1367
        if v1359 < 0 then
            v1367 = " \226\136\146"
        else
            v1367 = " +"
        end

        local v1368 = v1358 .. v1367
        local v1369 = a0:_button(v1355, v1366, v1368, function() --[[ Upvalues: a0 (copy), v1358 (copy), v1359 (copy) ]]
            local t14 = {axis = v1358, direction = v1359}
            a0:_setting("nudge", t14)
        end, true)
        v1369.LayoutOrder = k311
        a0:_enable(v1369, a0.State.itemName ~= nil)
    end

    if a0.State.existing then
        local v1370 = a0:_section("ObjectActions", "Selected object", 5, 84)
        local v1371 = {"duplicate", "Duplicate"}
        local v1372 = {"delete", "Delete"}
        local v1373 = {v1371, v1372}
        for k313, k314 in ipairs(v1373) do
            local v1377 = k314[1]
            local v1378 = a0:_button(v1370, v1377, k314[2], function() --[[ Upvalues: a0 (copy), v1377 (copy) ]]
                a0:CloseMenu()
                a0:_action(v1377)
            end, true)
            v1378.LayoutOrder = k313
            if v1377 == "delete" then
                v1378.TextColor3 = v175.Danger
            end
        end
    end

    local v1379 = a0:_section("Placement", "Placement helpers", 6, 138)
    local v1380 = {"snap", "Snap"}
    local v1381 = {"grid", "Grid"}
    local v1382 = {"heightLock", "Height lock"}
    local v1383 = {"aim", "Centre aim"}
    local v1384 = {v1380, v1381, v1382, v1383}
    for k315, k316 in ipairs(v1384) do
        v1382 = k316[1]
        v1383 = k316[2]
        local v1388 = a0:_button(v1379, v1382, v1383, function() --[[ Upvalues: a0 (copy), v1382 (copy) ]]
            a0:_setting(v1382, not a0.State[v1382])
        end, true)
        v1388.LayoutOrder = k315
        v1388:SetAttribute("OptionValue", true)
        v1388:SetAttribute("Toggle", true)
        v1388:SetAttribute("Label", v1383)
        local v1389 = {v1388}
        a0.OptionControls[v1382] = v1389
    end

    a0.Options.CanvasPosition = Vector2.zero
    a0:_resize()
    a0:_updateOptions()
end

v159.OpenPrecision = OpenPrecision1

local function OpenCamera(a0) --[[ Upvalues: clear (copy), label1 (copy), v175 (copy) ]]
    if not a0:_open("Camera") then
        return
    end

    local Title9 = a0.Title
    if Title9.Text ~= "Free camera" then
        Title9.Text = "Free camera"
    end

    clear(a0.Options)
    local v1390 = {"Slow", "Normal", "Fast"}
    a0:_choices(a0:_section("Speed", "Camera speed", 1, 84), "cameraSpeed", v1390)
    local v1391 = a0:_section("Presets", "Camera view", 2, 84)
    local v1392 = "Free"
    local v1393 = "Top"
    local v1394 = {v1392, v1393, "Front", "Side", "Focus", "Reset"}
    for k317, k318 in ipairs(v1394) do
        a0:_button(v1391, k318, k318, function() --[[ Upvalues: a0 (copy), k318 (copy) ]]
            a0:_setting("cameraPreset", k318)
            a0:CloseMenu()
        end, true).LayoutOrder = k317
    end

    local v1398 = a0:_section("Help", "Camera controls", 3, 122)
    local v1399 = label1(v1398, "Left stick moves across your base.\n\226\134\145 / \226\134\147 change camera height.\nSwipe the world to look around.\nObjects stay put while you look.", 15, v175.Text)
    local v1400 = UDim2.new(1, 0, 0, 94)
    v1399.Size = v1400
    v1399.Position = UDim2.fromOffset(0, 28)
    v1399.TextWrapped = true
    v1399.TextTruncate = Enum.TextTruncate.None
    v1399.TextYAlignment = Enum.TextYAlignment.Top
    a0.Options.CanvasPosition = Vector2.zero
    a0:_resize()
    a0:_updateOptions()
end

v159.OpenCamera = OpenCamera

local function _pickColor(a0, a1)
    a0.State.color = a1
    if a0.Callbacks.PickColor then
        a0.Callbacks.PickColor(a1)
    end

    a0:CloseMenu()
end

v159._pickColor = _pickColor

local function OpenColors(a0) --[[ Upvalues: clear (copy), v175 (copy), v929 (copy) ]]
    if not a0:_open("Colors") then
        return
    end

    local Title10 = a0.Title
    if Title10.Text ~= "Paint colour" then
        Title10.Text = "Paint colour"
    end

    clear(a0.Options)
    local v1401 = a0:_section("RecentColors", "Recent colours", 1, 84)
    local recentColors2 = a0.State.recentColors
    if not recentColors2 then
        recentColors2 = {}
    end

    if #recentColors2 == 0 then
        local v1402 = {}
        local v1404 = a0.State.color or Color3.new(1, 1, 1)
        v1402[1] = v1404
        recentColors2 = v1402
    end

    local function addSwatches(a0, a1) --[[ Upvalues: a0 (copy), v175 (upvalue) ]]
        for k319, k320 in ipairs(a1) do
            if typeof(k320) == "Color3" then
                local v1408 = "Color" .. k319
                local v1409 = a0:_button(a0, v1408, "", function() --[[ Upvalues: a0 (upvalue), k320 (copy) ]]
                    a0:_pickColor(k320)
                end, true)
                v1409.BackgroundColor3 = k320
                v1409.BackgroundTransparency = 0
                v1409.LayoutOrder = k319
                if typeof(a0.State.color) == "Color3" then
                    local v1410 = Vector3.new(k320.R, k320.G, k320.B)
                    if (v1410 - Vector3.new(a0.State.color.R, a0.State.color.G, a0.State.color.B)).Magnitude < 0.01 then
                        local v1411 = k320.R * 0.299
                        local v1412 = v1411 + k320.G * 0.587
                        local v1413 = v1412 + k320.B * 0.114
                        local v1414
                        if not (0.6 < v1413 and v175.Panel) then
                            v1414 = v175.Text
                        end

                        v1409.Text = "\226\156\147"
                        v1409.TextColor3 = v1414
                    end
                end
            end
        end
    end

    addSwatches(v1401, recentColors2)
    recentColors2 = a0:_section("Palette", "Colours", 2, 192)
    addSwatches(recentColors2, v929)
    local v1415 = a0:_section("Custom", "Custom colour \194\183 hex", 3, 92)
    local v1417 = a0.State.color or Color3.new(1, 1, 1)
    local v1418 = 0
    local v1419 = 48
    local v1420 = {
        Name = "Hex",
        PlaceholderText = "#FFFFFF",
        ClearTextOnFocus = false,
        TextSize = 17,
        BorderSizePixel = 0,
        Text = "#" .. v1417:ToHex(),
        Font = Enum.Font.Code,
        TextColor3 = v175.Text,
        BackgroundColor3 = v175.Panel,
        Position = UDim2.fromOffset(0, 32),
        Size = UDim2.new(0.6, -6, v1418, v1419)
    }
    v1401 = Instance.new("TextBox")
    for k321, k322 in pairs(v1420) do
        v1401[k321] = k322
    end

    v1401.Parent = v1415
    local v1424 = {
        Name = "Outline",
        Thickness = 1,
        Transparency = 0.25,
        Color = v175.Text,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }
    v1420 = Instance.new("UIStroke")
    for k323, k324 in pairs(v1424) do
        v1420[k323] = k324
    end

    v1420.Parent = v1401
    v1417 = a0:_button(v1415, "UseColor", "Use colour", function() --[[ Upvalues: v1401 (copy), a0 (copy) ]]
        local v1428 = string.match(v1401.Text, "^#?(%x%x%x%x%x%x)$")
        if v1428 then
            local v1429 = Color3.fromHex(v1428)
            a0:_pickColor(v1429)
            return
        end

        v1401.Text = ""
        v1401.PlaceholderText = "Use 6 hex digits"
    end, true)
    local v1430 = UDim2.new(0.6, 0, 0, 32)
    v1417.Position = v1430
    v1417.Size = UDim2.new(0.4, 0, 0, 48)
    v1415:SetAttribute("ManualLayout", true)
    a0.Options.CanvasPosition = Vector2.zero
    a0:_resize()
end

v159.OpenColors = OpenColors

local function CloseMenu1(a0) --[[ Upvalues: UserInputService (copy) ]]
    a0.MenuOpen = false
    a0.MenuKind = nil
    a0.ThumbnailRequest = a0.ThumbnailRequest + 1
    local v1431 = UserInputService:GetFocusedTextBox()
    if v1431 and v1431:IsDescendantOf(a0.ControlsGui) then
        v1431:ReleaseFocus()
    end

    for k325, k326 in pairs(a0.ThumbnailItems) do
        v1431 = k325:FindFirstChild("Preview")
        if v1431 then
            v1431:Destroy()
        end

        k326.Loaded = nil
    end

    a0.Dimmer.Visible = false
    a0:Update(a0.State)
end

v159.CloseMenu = CloseMenu1

local function SetActive1(a0, a1)
    a0.Active = a1 == true
    if not a0.Active then
        a0:_stopInputs()
        a0:CloseMenu()
    end

    a0:Update(a0.State)
end

v159.SetActive = SetActive1

local function Owns1(a0, a1)
    if not (a1 and a1:IsDescendantOf(a0.ControlsGui)) then
        return false
    end

    local v1435 = a1
    while v1435 do
        if v1435 == a0.ControlsGui then
            break
        end

        if v1435:IsA("GuiButton") or v1435:IsA("TextBox") or v1435:IsA("ScrollingFrame") or v1435 == a0.Dimmer or v1435 == a0.Menu then
            return true
        end

        v1435 = v1435.Parent
    end

    return false
end

v159.Owns = Owns1

local function Update1(a0, a1) --[[ Upvalues: asSet (copy), v175 (copy) ]]
    local State1 = a0.State
    if not State1 then
        State1 = {}
    end

    local v1436 = a1
    if not v1436 then
        v1436 = {}
    end

    a0.State = v1436
    a1 = a0.State
    local v1437 = a1.itemName or a1.selectionName
    a1.itemName = v1437
    if a1.existing == nil then
        a1.existing = a1.hasSelection == true
    end

    local v1438 = a1.status or a1.reason
    a1.status = v1438
    local v1440 = a1.cameraSpeed or a1.speed or "Normal"
    a1.cameraSpeed = v1440
    if a1.grid == nil then
        a1.grid = a1.showGrid == true
    end

    local v1442 = a1.moveStep or a1.increment or 1
    a1.moveStep = v1442
    a1.rotateStep = a1.rotateStep or 90
    a1.axis = a1.axis or "Y"
    local v1444 = a1.color or a1.paintColor or Color3.new(1, 1, 1)
    a1.color = v1444
    local v1445 = a1.recent or a1.recents
    a1.recent = v1445
    a1.tool = a1.tool or "Move"
    local mode = a1.mode
    if not mode then
        if a1.tool == "Paint" then
            mode = "Paint"
        else
            mode = "Build"
        end
    end

    a1.mode = mode
    if a1.favorites then
        a0.Favorites = asSet(a1.favorites)
    end

    local v1446 = a1.mode == "Paint"
    local v1447 = a1.itemName ~= nil
    local v1448 = false
    if a1.deleting == true then
        v1448 = not v1446
    end

    local v1450 = a0.Active and not a1.blocked
    if State1.blocked ~= a1.blocked and a1.blocked then
        a0:_stopInputs()
    end

    a0.Root.Enabled = v1450
    a0.ControlsGui.Enabled = v1450
    local v1451 = not a0.MenuOpen
    a0.World.Visible = v1451
    a0.Controls.Visible = not a0.MenuOpen
    a0.Reticle.Visible = a1.aim == true
    local v1452
    if not (a1.valid == false and v175.Danger) then
        v1452 = v175.Text
    end

    a0.Reticle.BackgroundColor3 = v1452
    local Build1 = a0.Build
    local v1454 = not v1446 and not v1448
    local v1455
    if not (v1454 and v175.Text) then
        v1455 = v175.Panel
    end

    Build1.BackgroundColor3 = v1455
    if v1454 then
        v1455 = 0.02
    else
        v1455 = 0.18
    end

    Build1.BackgroundTransparency = v1455
    local v1456
    if not (v1454 and v175.Panel) then
        v1456 = v175.Text
    end

    Build1.TextColor3 = v1456
    v1450 = Build1:FindFirstChild("Outline")
    if v1450 then
        local v1457
        if v1454 then
            v1457 = 0
        else
            v1457 = 0.25
        end

        v1450.Transparency = v1457
    end

    Build1 = a0.Paint
    local v1458
    if not (v1446 and v175.Text) then
        v1458 = v175.Panel
    end

    Build1.BackgroundColor3 = v1458
    if v1446 then
        v1458 = 0.02
    else
        v1458 = 0.18
    end

    Build1.BackgroundTransparency = v1458
    local v1459
    if not (v1446 and v175.Panel) then
        v1459 = v175.Text
    end

    Build1.TextColor3 = v1459
    State1 = Build1:FindFirstChild("Outline")
    if State1 then
        local v1460
        if v1446 then
            v1460 = 0
        else
            v1460 = 0.25
        end

        State1.Transparency = v1460
    end

    Build1 = a0.DeleteMode
    local v1461
    if not (v1448 and v175.Text) then
        v1461 = v175.Panel
    end

    Build1.BackgroundColor3 = v1461
    if v1448 then
        v1461 = 0.02
    else
        v1461 = 0.18
    end

    Build1.BackgroundTransparency = v1461
    local v1462
    if not (v1448 and v175.Panel) then
        v1462 = v175.Text
    end

    Build1.TextColor3 = v1462
    local Outline6 = Build1:FindFirstChild("Outline")
    if Outline6 then
        local v1463
        if v1448 then
            v1463 = 0
        else
            v1463 = 0.25
        end

        Outline6.Transparency = v1463
    end

    a0.DeleteMode.Visible = not v1446
    local v1464
    if not (v1448 and v175.Danger) then
        v1464 = v175.Panel
    end

    a0.DeleteMode.BackgroundColor3 = v1464
    local v1465
    if not (v1448 and v175.Panel) then
        v1465 = v175.Danger
    end

    a0.DeleteMode.TextColor3 = v1465
    local DeleteMode = a0.DeleteMode
    if v1448 then
        v1465 = "Delete ON"
    else
        v1465 = "Delete"
    end

    if DeleteMode.Text ~= v1465 then
        DeleteMode.Text = v1465
    end

    a0.Dock.Visible = not v1448
    local Undo = a0.Undo
    local v1466 = true
    if a1.undo ~= true then
        v1466 = false
        if type(a1.undo) == "number" then
            v1466 = 0 < a1.undo
        end
    end

    a0:_enable(Undo, v1466)
    Undo = a0.Redo
    v1466 = true
    if a1.redo ~= true then
        v1466 = false
        if type(a1.redo) == "number" then
            v1466 = 0 < a1.redo
        end
    end

    a0:_enable(Undo, v1466)
    local status1 = a1.status
    if not status1 or status1 == "" then
        local v1467
        if v1448 then
            v1467 = "Tap objects to delete. Tap Delete again to finish."
        else
            if v1446 then
                v1467 = "Tap a surface to target it. Swipe to look."
            else
                if v1447 then
                    v1467 = "Drag the Move pad. Swipe the world to look."
                else
                    v1467 = "Tap an object to select. Swipe to look."
                end
            end
        end

        status1 = v1467
    end

    local ItemLabel1 = a0.ItemLabel
    if v1448 then
        Undo = "Delete mode"
    else
        if v1446 then
            Undo = "Paint"
        else
            local v1469 = a1.itemName or "Free camera"
        end
    end

    if ItemLabel1.Text ~= Undo then
        ItemLabel1.Text = Undo
    end

    ItemLabel1 = a0.StatusLabel
    if ItemLabel1.Text ~= status1 then
        ItemLabel1.Text = status1
    end

    if v1448 or a1.valid == false then
        local Danger6 = v175.Danger
        if Danger6 then
            -- jump to 493
        end
    end

    local Muted5 = v175.Muted
    a0.StatusLabel.TextColor3 = Muted5
    a0.Tools.Visible = v1446 or v1447
    local Height = a0.Height
    local v1470 = {a0.Move, Height, a0.Rotate}
    for k327, k328 in ipairs(v1470) do
        local v1476 = v1447 and not v1446
        k328.Visible = v1476
    end

    k328 = a0.Bucket
    local v1477 = {a0.Brush, k328, a0.Dropper}
    for k329, k330 in ipairs(v1477) do
        k330.Visible = v1446
    end

    local Move = a0.Move
    local v1481 = a1.tool == "Move"
    local v1482
    if not (v1481 and v175.Text) then
        v1482 = v175.Panel
    end

    Move.BackgroundColor3 = v1482
    if v1481 then
        v1482 = 0.02
    else
        v1482 = 0.18
    end

    Move.BackgroundTransparency = v1482
    local v1483
    if not (v1481 and v175.Panel) then
        v1483 = v175.Text
    end

    Move.TextColor3 = v1483
    status1 = Move:FindFirstChild("Outline")
    if status1 then
        local v1484
        if v1481 then
            v1484 = 0
        else
            v1484 = 0.25
        end

        status1.Transparency = v1484
    end

    Move = a0.Height
    v1481 = a1.tool == "Height"
    local v1485
    if not (v1481 and v175.Text) then
        v1485 = v175.Panel
    end

    Move.BackgroundColor3 = v1485
    if v1481 then
        v1485 = 0.02
    else
        v1485 = 0.18
    end

    Move.BackgroundTransparency = v1485
    local v1486
    if not (v1481 and v175.Panel) then
        v1486 = v175.Text
    end

    Move.TextColor3 = v1486
    v1448 = Move:FindFirstChild("Outline")
    if v1448 then
        local v1487
        if v1481 then
            v1487 = 0
        else
            v1487 = 0.25
        end

        v1448.Transparency = v1487
    end

    Move = a0.Rotate
    v1481 = a1.tool == "Rotate"
    local v1488
    if not (v1481 and v175.Text) then
        v1488 = v175.Panel
    end

    Move.BackgroundColor3 = v1488
    if v1481 then
        v1488 = 0.02
    else
        v1488 = 0.18
    end

    Move.BackgroundTransparency = v1488
    local v1489
    if not (v1481 and v175.Panel) then
        v1489 = v175.Text
    end

    Move.TextColor3 = v1489
    local Outline7 = Move:FindFirstChild("Outline")
    if Outline7 then
        local v1490
        if v1481 then
            v1490 = 0
        else
            v1490 = 0.25
        end

        Outline7.Transparency = v1490
    end

    Move = a1.paintMode or "PaintBrush"
    local Brush = a0.Brush
    Outline7 = Move == "PaintBrush"
    local v1491
    if not (Outline7 and v175.Text) then
        v1491 = v175.Panel
    end

    Brush.BackgroundColor3 = v1491
    if Outline7 then
        v1491 = 0.02
    else
        v1491 = 0.18
    end

    Brush.BackgroundTransparency = v1491
    local v1492
    if not (Outline7 and v175.Panel) then
        v1492 = v175.Text
    end

    Brush.TextColor3 = v1492
    local Outline8 = Brush:FindFirstChild("Outline")
    if Outline8 then
        local v1493
        if Outline7 then
            v1493 = 0
        else
            v1493 = 0.25
        end

        Outline8.Transparency = v1493
    end

    Brush = a0.Bucket
    Outline7 = Move == "PaintBucket"
    local v1494
    if not (Outline7 and v175.Text) then
        v1494 = v175.Panel
    end

    Brush.BackgroundColor3 = v1494
    if Outline7 then
        v1494 = 0.02
    else
        v1494 = 0.18
    end

    Brush.BackgroundTransparency = v1494
    local v1495
    if not (Outline7 and v175.Panel) then
        v1495 = v175.Text
    end

    Brush.TextColor3 = v1495
    local Outline9 = Brush:FindFirstChild("Outline")
    if Outline9 then
        local v1496
        if Outline7 then
            v1496 = 0
        else
            v1496 = 0.25
        end

        Outline9.Transparency = v1496
    end

    Brush = a0.Dropper
    Outline7 = Move == "ColorDropper"
    local v1497
    if not (Outline7 and v175.Text) then
        v1497 = v175.Panel
    end

    Brush.BackgroundColor3 = v1497
    if Outline7 then
        v1497 = 0.02
    else
        v1497 = 0.18
    end

    Brush.BackgroundTransparency = v1497
    local v1498
    if not (Outline7 and v175.Panel) then
        v1498 = v175.Text
    end

    Brush.TextColor3 = v1498
    local Outline10 = Brush:FindFirstChild("Outline")
    if Outline10 then
        local v1499
        if Outline7 then
            v1499 = 0
        else
            v1499 = 0.25
        end

        Outline10.Transparency = v1499
    end

    Outline7 = v1447
    if Outline7 then
        Outline7 = not v1446
        if Outline7 then
            Outline7 = a1.tool == "Move"
        end
    end

    a0.MoveHandle.Visible = Outline7
    Outline7 = v1447
    if Outline7 then
        Outline7 = not v1446
        if Outline7 then
            Outline7 = a1.tool ~= "Move"
        end
    end

    a0.AdjustMinus.Visible = Outline7
    a0.AdjustPlus.Visible = a0.AdjustMinus.Visible
    if a1.tool == "Height" then
        local v1500 = tostring(a1.moveStep)
        if v1500 then
            -- jump to 871
        end
    end

    local v1501 = tostring(a1.rotateStep)
    local v1502 = v1501 .. "\194\176"
    v1501 = a0.AdjustMinus
    local v1503 = "\226\136\146 " .. v1502
    if v1501.Text ~= v1503 then
        v1501.Text = v1503
    end

    v1501 = a0.AdjustPlus
    v1503 = "+ " .. v1502
    if v1501.Text ~= v1503 then
        v1501.Text = v1503
    end

    v1503 = a0.FineTune
    local v1506 = v1447 and not v1446
    a0.Cancel.Visible = v1506
    v1503.Visible = not v1446
    v1502 = v1447
    if v1502 then
        v1502 = false
        if a1.existing == true then
            local v1508 = not v1446 and not a0.CompactContext
        end
    end

    a0.Duplicate.Visible = v1502
    a0.Delete.Visible = v1502
    a0.Color.Visible = v1446
    a0.PaintScope.Visible = v1446
    local PaintScope = a0.PaintScope
    local v1509
    if Move == "PaintBucket" then
        v1509 = "Bucket \194\183 whole object"
    else
        if Move == "ColorDropper" then
            v1509 = "Sample a surface colour"
        else
            v1509 = "Brush \194\183 selected surface"
        end
    end

    if PaintScope.Text ~= v1509 then
        PaintScope.Text = v1509
    end

    v1509 = a0.Color
    local Color1 = a0.Color
    local color3 = a1.color
    local v1510 = color3.R * 0.299
    local v1511 = v1510 + color3.G * 0.587
    local v1512 = v1511 + color3.B * 0.114
    local v1513
    if not (0.6 < v1512 and v175.Panel) then
        v1513 = v175.Text
    end

    a0.Color.BackgroundColor3 = a1.color
    v1509.BackgroundTransparency = 0
    Color1.TextColor3 = v1513
    local Color2 = a0.Color
    local v1514 = a1.color:ToHex()
    v1509 = "Colour  #" .. string.upper(v1514)
    if Color2.Text ~= v1509 then
        Color2.Text = v1509
    end

    if v1446 then
        if Move == "ColorDropper" then
            v1502 = "Sample colour"
            -- jump to 1022 (out of range)
        end

        v1502 = "Paint"
    else
        if not v1447 then
            v1502 = "Choose object"
        else
            if a1.existing then
                v1502 = "Apply"
            else
                v1502 = "Place"
            end
        end
    end

    Color2 = a0.Primary
    if Color2.Text ~= v1502 then
        Color2.Text = v1502
    end

    Color2 = a0.Primary
    Color2.BackgroundColor3 = v175.Panel
    Color2.BackgroundTransparency = 0.18
    Color2.TextColor3 = v175.Text
    v1502 = Color2:FindFirstChild("Outline")
    if v1502 then
        v1502.Transparency = 0.25
    end

    local Primary = a0.Primary
    local v1515 = true
    if a1.valid == false then
        local v1517 = not v1447 and not v1446
    end

    a0:_enable(Primary, v1515)
    if a0.MenuOpen then
        a0:_updateOptions()
    end
end

v159.Update = Update1

local function Destroy1(a0)
    if a0.Destroyed then
        return
    end

    a0:_stopInputs()
    a0:CloseMenu()
    a0.Destroyed = true
    for k331, k332 in ipairs(a0.Connections) do
        k332:Disconnect()
    end

    if a0.CameraConnection then
        a0.CameraConnection:Disconnect()
    end

    a0.Root:Destroy()
    a0.ControlsGui:Destroy()
end

v159.Destroy = Destroy1
v50.MobileUI = v159
v159 = {}
v159.__index = v159
local v1521 = Color3.new(1, 1, 1)
local v1522 = Color3.fromRGB(125, 125, 125)

local function label2(a0, a1, a2, a3, a4, a5) --[[ Upvalues: v1521 (copy) ]]
    local t15 = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        TextScaled = true,
        TextWrapped = false,
        Name = a1,
        Text = a2,
        Position = a3,
        Size = a4,
        Font = Enum.Font.Code,
        TextColor3 = v1521,
        TextSize = a5,
        ZIndex = a0.ZIndex + 1
    }
    local TextLabel2 = Instance.new("TextLabel")
    for k333, k334 in pairs(t15) do
        TextLabel2[k333] = k334
    end

    TextLabel2.Parent = a0
    t15 = {MinTextSize = 8, MaxTextSize = a5}
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
    for k335, k336 in pairs(t15) do
        UITextSizeConstraint[k335] = k336
    end

    UITextSizeConstraint.Parent = TextLabel2
    return TextLabel2
end

local function new2(a0, a1) --[[ Upvalues: v159 (copy), v1521 (copy), label2 (copy) ]]
    local Toolbar = assert(a0.BuildGui, "Build GUI must be ready before desktop history"):FindFirstChild("Toolbar")
    local Buttons = assert(Toolbar, "Build toolbar missing"):FindFirstChild("Buttons")
    local v1529 = assert(Buttons, "Build toolbar buttons missing")
    local v1530 = {
        Active = false,
        Busy = false,
        Blocked = false,
        Connections = {},
        Controls = {}
    }
    local v1531 = setmetatable(v1530, v159)
    v1530 = 0
    local v1532 = v1529:GetChildren()
    for k337, k338 in ipairs(v1532) do
        local v1538 = k338:IsA("GuiObject")
        local v1539
        if v1538 then
            v1539 = v1530
            local v1540 = math.max(v1539, k338.LayoutOrder)
            v1530 = v1540
        end
    end

    local v1541 = {
        Name = "ModernDesktopHistory",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        Size = UDim2.fromOffset(120, 41),
        LayoutOrder = v1530 + 10,
        ZIndex = v1529.ZIndex
    }
    local Frame20 = Instance.new("Frame")
    for k339, k340 in pairs(v1541) do
        Frame20[k339] = k340
    end

    Frame20.Parent = v1529
    v1531.Root = Frame20
    local v1545 = "Undo"
    local v1546 = "Redo"
    v1541 = {v1545, v1546}
    for k341, k342 in ipairs(v1541) do
        local v1551 = 0
        k339 = {
            Text = "",
            BackgroundTransparency = 0.5,
            BorderSizePixel = 1,
            AutoButtonColor = false,
            Active = false,
            Interactable = false,
            Selectable = false,
            Name = k342,
            BackgroundColor3 = Color3.new(0, 0, 0),
            BorderColor3 = v1521,
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.new(0.5, -2, 1, v1551)
        }
        local v1553
        if not (k341 == 1 and UDim2.fromOffset(0, 0)) then
            v1551 = 0
            local v1554 = UDim2.new(0.5, 2, 0, v1551)
        end

        k339.Position = v1553
        k339.ZIndex = v1531.Root.ZIndex + 1
        local Root5 = v1531.Root
        v1530 = Instance.new("TextButton")
        for k343, k344 in pairs(k339) do
            v1530[k343] = k344
        end

        v1530.Parent = Root5
        k344 = 3
        local v1558 = UDim2.fromOffset(3, k344)
        k344 = 1
        local v1559 = UDim2.new(k344, -6, 1, -18)
        k344 = 16
        v1529 = label2(v1530, "Title", k342, v1558, v1559, k344)
        local v1560
        if k342 == "Undo" then
            v1560 = "Ctrl+Z"
        else
            v1560 = "Ctrl+Y"
        end

        k344 = 0
        local v1561 = UDim2.new(k344, 3, 1, -15)
        k344 = UDim2.new
        local v1562 = k344(1, -6, 0, 12)
        local v1563 = label2(v1530, "Shortcut", v1560, v1561, v1562, 10)
        local v1564 = {Count = 0, Button = v1530, Title = v1529, Hint = v1563, Shortcut = v1560}
        v1531.Controls[k342] = v1564
        v1562 = function() --[[ Upvalues: v1531 (copy), k342 (copy), a1 (copy) ]]
            if v1531.Destroyed or not v1531.Active or v1531.Busy or v1531.Blocked or v1531.Controls[k342].Count <= 0 then
                return
            end

            a1(k342)
        end

        local v1565 = v1530.Activated:Connect(v1562)
        table.insert(v1531.Connections, v1565)
    end

    v1531:Update(false, 0, 0, false)
    return v1531
end

v159.new = new2

local function Update2(a0, a1, a2, a3, a4, a5) --[[ Upvalues: v1521 (copy), v1522 (copy) ]]
    if a0.Destroyed then
        return
    end

    a0.Active = a1 == true
    a0.Busy = a4 == true
    a0.Blocked = a5 == true
    a0.Root.Visible = a0.Active
    for k345, k346 in pairs(a0.Controls) do
        k346.Count = math.max(0, tonumber(k345 == "Undo" and a2 or a3) or 0)
        local Active5 = a0.Active
        if Active5 then
            Active5 = not a0.Blocked
            if Active5 then
                Active5 = 0 < k346.Count
            end
        end

        k346.Button.Active = Active5
        k346.Button.Interactable = Active5
        k346.Button.AutoButtonColor = Active5
        k346.Button.BorderColor3 = Active5 and v1521 or v1522
        local v1573
        if Active5 then
            v1573 = 0
        else
            v1573 = 0.55
        end

        k346.Title.TextTransparency = v1573
        if Active5 then
            v1573 = 0.1
        else
            v1573 = 0.6
        end

        k346.Hint.TextTransparency = v1573
    end
end

v159.Update = Update2

local function Destroy2(a0)
    if a0.Destroyed then
        return
    end

    a0.Destroyed = true
    a0.Active = false
    for k347, k348 in ipairs(a0.Connections) do
        k348:Disconnect()
    end

    table.clear(a0.Connections)
    a0.Root:Destroy()
end

v159.Destroy = Destroy2
v50.DesktopUI = v159
v1521 = {}
v1521.__index = v1521
v1522 = Enum.ContextActionPriority.High.Value + 110
local v1577 = {"Y", "X", "Z"}
local v1578 = setmetatable({}, {__mode = "k"})
v1521.PendingControlRestores = v1578
local v1579 = {
    Enum.KeyCode.ButtonA,
    Enum.KeyCode.ButtonB,
    Enum.KeyCode.ButtonX,
    Enum.KeyCode.ButtonY,
    Enum.KeyCode.ButtonL1,
    Enum.KeyCode.ButtonR1,
    Enum.KeyCode.ButtonL2,
    Enum.KeyCode.ButtonR2,
    Enum.KeyCode.DPadLeft,
    Enum.KeyCode.DPadRight,
    Enum.KeyCode.DPadUp,
    Enum.KeyCode.DPadDown,
    Enum.KeyCode.ButtonL3,
    Enum.KeyCode.ButtonR3
}

local function preferredGamepad() --[[ Upvalues: UserInputService (copy) ]]
    local GamepadEnabled = UserInputService.GamepadEnabled
    if GamepadEnabled then
        GamepadEnabled = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
    end

    return GamepadEnabled
end

local function releaseCursorActivation() --[[ Upvalues: ContextActionService (copy) ]]
    pcall(function() --[[ Upvalues: ContextActionService (upvalue) ]]
        ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
        ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
    end)
end

local function isDirection(a0)
    local v1580 = true
    if a0 ~= Enum.KeyCode.DPadLeft then
        v1580 = true
        if a0 ~= Enum.KeyCode.DPadRight then
            v1580 = true
            if a0 ~= Enum.KeyCode.DPadUp then
                v1580 = a0 == Enum.KeyCode.DPadDown
            end
        end
    end

    return v1580
end

local function deadzone(a0)
    local Magnitude = a0.Magnitude
    if Magnitude <= 0.15 then
        return Vector2.zero
    end

    return a0.Unit * math.min(1, (Magnitude - 0.15) / 0.85)
end

local function IsGamepad(a0)
    local v1581 = false
    if a0.Active == true then
        v1581 = not a0.Destroyed
    end

    return v1581
end

v1521.IsGamepad = IsGamepad

local function PickerOpen(a0)
    return a0.Client.ColorPickerHUD ~= nil
end

v1521.PickerOpen = PickerOpen

local function ExternalBlocked(a0) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    local Client2 = a0.Client
    local MenuIsOpen = GuiService.MenuIsOpen
    if not MenuIsOpen then
        MenuIsOpen = true
        if a0.WindowUnfocused ~= true then
            MenuIsOpen = true
            if UserInputService:GetFocusedTextBox() == nil then
                MenuIsOpen = true
                if Client2.DeleteAllConfirmOpen ~= true then
                    MenuIsOpen = true
                    if Client2.PaintResetConfirmOpen ~= true then
                        MenuIsOpen = true
                        if Client2.ColorPickerHUD == nil then
                            MenuIsOpen = a0.ExternalMenu ~= nil
                        end
                    end
                end
            end
        end
    end

    return MenuIsOpen
end

v1521.ExternalBlocked = ExternalBlocked

local function BlocksWorld(a0)
    if a0:IsGamepad() then
        local MenuOpen3 = a0.UI.MenuOpen
        if not MenuOpen3 then
            local v1582 = a0:ExternalBlocked()
            if v1582 then
                -- jump to 16
            end

            -- branch continues at 16
        end
    end

    local v1583 = false
    return v1583
end

v1521.BlocksWorld = BlocksWorld

local function GetPad(a0) --[[ Upvalues: UserInputService (copy) ]]
    return UserInputService:GetConnectedGamepads()[1]
end

v1521.GetPad = GetPad

local function CancelHeldInputs(a0) --[[ Upvalues: v1579 (copy), UserInputService (copy) ]]
    a0.RepeatDirection = nil
    a0.RepeatAt = nil
    a0:StopGridAdjustment(false)
    a0:StopQuickRotation(false)
    local RequireRelease = a0.RequireRelease
    if not RequireRelease then
        RequireRelease = {}
    end

    a0.RequireRelease = RequireRelease
    local v1584 = a0:GetPad()
    if v1584 then
        for k349, k350 in ipairs(v1579) do
            if UserInputService:IsGamepadButtonDown(v1584, k350) then
                a0.RequireRelease[k350] = true
            else
                a0.RequireRelease[k350] = nil
                a0.HeldKeys[k350] = nil
            end
        end

        local v1589 = UserInputService:GetGamepadState(v1584)
        for k351, k352 in ipairs(v1589) do
            if k352.KeyCode == Enum.KeyCode.Thumbstick1 or k352.KeyCode == Enum.KeyCode.Thumbstick2 then
                if 0.15 < Vector2.new(k352.Position.X, k352.Position.Y).Magnitude then
                    a0.RequireRelease[k352.KeyCode] = true
                else
                    a0.RequireRelease[k352.KeyCode] = nil
                end
            end
        end

        return
    end

    local HeldKeys = a0.HeldKeys
    if not HeldKeys then
        HeldKeys = {}
    end

    for k353 in pairs(HeldKeys) do
        a0.RequireRelease[k353] = true
    end
end

v1521.CancelHeldInputs = CancelHeldInputs

local function SyncOwnership(a0) --[[ Upvalues: GuiService (copy), UserInputService (copy), ContextActionService (copy), GamepadService (copy) ]]
    if not a0:IsGamepad() then
        return
    end

    local v1596 = a0:BlocksWorld()
    if v1596 ~= a0.WasBlocked then
        a0:CancelHeldInputs()
        a0.WasBlocked = v1596
    end

    if a0.UI.SetObscured then
        local MenuIsOpen1 = GuiService.MenuIsOpen
        if not MenuIsOpen1 then
            MenuIsOpen1 = true
            if a0.WindowUnfocused ~= true then
                MenuIsOpen1 = true
                if a0.ExternalMenu == nil then
                    MenuIsOpen1 = true
                    if a0.Client.DeleteAllConfirmOpen ~= true then
                        MenuIsOpen1 = true
                        if a0.Client.PaintResetConfirmOpen ~= true then
                            MenuIsOpen1 = false
                            if UserInputService:GetFocusedTextBox() ~= nil then
                                MenuIsOpen1 = not a0:PickerOpen()
                            end
                        end
                    end
                end
            end
        end

        a0.UI:SetObscured(MenuIsOpen1)
    end

    if GuiService.MenuIsOpen then
        return
    end

    local v1597 = a0:PickerOpen()
    if not v1597 then
        v1597 = a0.ExternalMenu ~= nil
    end

    a0.Client.BuildGamepadNavigation = v1597
    if not v1597 then
        pcall(function() --[[ Upvalues: ContextActionService (upvalue) ]]
            ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
            ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
        end)
        if GamepadService.GamepadCursorEnabled then
            GamepadService:DisableGamepadCursor()
        end
    end

    if not v1596 or a0.UI.MenuKind == "Precision" then
        GuiService.SelectedObject = nil
    end

    UserInputService.MouseBehavior = v1597 and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
    UserInputService.MouseIconEnabled = v1597
    a0.Client.Player:Move(Vector3.new(0, 0, 0), false)
    if a0.Client.Humanoid then
        a0.Client.Humanoid.Jump = false
    end
end

v1521.SyncOwnership = SyncOwnership
v1521.Center = center

local function RememberObject(a0, a1) --[[ Upvalues: rememberObject (copy) ]]
    rememberObject(a0.Client, a0.Remote, a1)
end

v1521.RememberObject = RememberObject

local function SetFavorites(a0, a1) --[[ Upvalues: saveFavorites (copy) ]]
    if not a0:IsGamepad() then
        return
    end

    if type(a1) ~= "table" then
        return
    end

    saveFavorites(a0.Client, a0.Remote, a1)
    a0:RefreshPresentation()
end

v1521.SetFavorites = SetFavorites

local function NotifySelected(a0, a1, a2)
    if not a0:IsGamepad() then
        return
    end

    a0.Client:SetDeletingObjects(false)
    a0.Following = true
    a0.FollowCamera = nil
    a0.GrabOffset = Vector3.new(0, 0, 0)
    a0.Status = nil
    a0.StatusUntil = nil
    a0:RememberObject(a1)
    a0.LastObjectType = a2
end

v1521.NotifySelected = NotifySelected

local function SetFollowing(a0, a1, a2)
    local v1598 = false
    if a1 == true then
        v1598 = a0.Client.EditObject ~= nil
    end

    a0.Following = v1598
    a0.Client:EndDirectBuildDrag()
    if not a0.Following then
        return
    end

    local v1599 = a0:Center()
    local v1600 = a0.Client:BuildPointerHitsObject(v1599)
    if a2 and v1600 or nil then
        a0.GrabOffset = a0.Client.EditObject:GetBoundingBox():PointToObjectSpace((a2 and v1600 or nil).Position)
        a0.FollowCamera = workspace.CurrentCamera.CFrame
        return
    end

    a0.GrabOffset = Vector3.new(0, 0, 0)
    a0.FollowCamera = nil
end

v1521.SetFollowing = SetFollowing

local function ChooseItem(a0, a1, a2) --[[ Upvalues: v51 (copy) ]]
    if not a0:IsGamepad() or a0.Busy then
        return
    end

    if a0.Client.Painting then
        v51.Close(a0.Client)
    end

    a0:CloseMenu()
    a0.Client:SetDeletingObjects(false)
    a0.Client:SelectEditObject(a1, a2)
    a0:RefreshPresentation()
end

v1521.ChooseItem = ChooseItem

local function Request(a0, a1) --[[ Upvalues: invokeBuildAction (copy) ]]
    if not a0:IsGamepad() or a0.Busy then
        return {ok = false, reason = "Wait for the current change to finish."}
    end

    a0.Busy = true
    a0:RefreshPresentation()
    local v1601 = invokeBuildAction(a0.RemoteFunction, a1)
    a0.Busy = false
    if a0.Destroyed then
        return v1601
    end

    if type(v1601.undo) == "number" then
        a0.UndoCount = v1601.undo
    end

    if type(v1601.redo) == "number" then
        a0.RedoCount = v1601.redo
    end

    if a1.action ~= "State" then
        local v1602
        if not v1601.ok then
            v1602 = v1601.reason
            if not v1602 then
                v1602 = "The change could not be saved."
                -- branch continues at 67
            end
        else
            v1602 = nil
        end

        a0.Status = v1602
        local v1604 = a0.Status and os.clock() + 3 or nil
        a0.StatusUntil = v1604
    end

    a0:RefreshPresentation()
    if a0.NeedsStateRefresh then
        a0.NeedsStateRefresh = nil
        task.defer(function() --[[ Upvalues: a0 (copy) ]]
            a0:RefreshState()
        end)
    end

    return v1601
end

v1521.Request = Request

local function RefreshState(a0)
    if not a0:IsGamepad() then
        return
    end

    if a0.Busy then
        a0.NeedsStateRefresh = true
        return
    end

    local v1605 = a0:Request({action = "State"})
    return v1605
end

v1521.RefreshState = RefreshState

local function Delete(a0, a1)
    if not a0:IsGamepad() or a0.Busy or a0:BlocksWorld() then
        return
    end

    local ActivationEpoch = a0.ActivationEpoch
    local v1606 = {action = "Delete", object = a1}
    local v1607 = a0:Request(v1606)
    if v1607.ok and a0:IsGamepad() and a0.ActivationEpoch == ActivationEpoch then
        a0.Client:ClearBuildObjectHover()
        a0.AimTarget = nil
    end

    return v1607
end

v1521.Delete = Delete

local function CommitTransaction(a0, a1)
    local Client3 = a0.Client
    local Precision = a0.Precision
    if Precision then
        Precision = a0.UI.MenuKind == "Precision"
    end

    if not a0:IsGamepad() then
        return
    end

    if a0.Busy then
        return
    end

    if a0:ExternalBlocked() then
        return
    end

    if not a0.UI.MenuOpen or Precision then
        if Client3.Painting then
            return
        end

        if not Client3.EditObject then
            return
        end

        if typeof(a1) == "CFrame" then
            -- jump to 46
        end
    end

    return
    local EditObject = Client3.EditObject
    local EditingExistingObject = Client3.EditingExistingObject
    local ActivationEpoch1 = a0.ActivationEpoch
    local v1608 = {}
    local v1609
    if EditingExistingObject then
        v1609 = "Move"
    else
        v1609 = "Place"
    end

    v1608.action = v1609
    v1608.name = EditObject.Name
    v1608.object = EditingExistingObject
    v1608.cframe = a1
    Precision = a0:Request(v1608)
    if not a0:IsGamepad() or a0.ActivationEpoch ~= ActivationEpoch1 then
        return Precision
    end

    if Precision.ok then
        if EditingExistingObject then
            if EditingExistingObject.Parent then
                EditingExistingObject:PivotTo(a1)
            end

            if Client3.EditObject == EditObject and Client3.EditingExistingObject == EditingExistingObject then
                Client3:DeleteEditObject()
            end
        end
    end

    return Precision
end

v1521.CommitTransaction = CommitTransaction

local function History(a0, a1)
    if a1 == "Undo" or a1 == "Redo" then
        if not a0:IsGamepad() then
            return
        end

        if a0.Busy then
            return
        end

        if not a0:BlocksWorld() then
            -- jump to 18
        end
    end

    return
    if a1 == "Undo" then
        local v1610 = a0.UndoCount or 0
        if v1610 <= 0 then
            return
        end
    end

    if a1 == "Redo" then
        local v1611 = a0.RedoCount or 0
        if v1611 <= 0 then
            return
        end
    end

    local Client4 = a0.Client
    a0:SetFollowing(false)
    local EditObject1 = Client4.EditObject
    local EditingExistingObject1 = Client4.EditingExistingObject
    local SuspendedPreview = a0.SuspendedPreview
    local ActivationEpoch2 = a0.ActivationEpoch
    local v1612 = {action = a1}
    local v1613 = a0:Request(v1612)
    if v1613.ok then
        if a0:IsGamepad() then
            if a0.ActivationEpoch == ActivationEpoch2 then
                if EditingExistingObject1 and Client4.EditObject == EditObject1 and Client4.EditingExistingObject == EditingExistingObject1 then
                    Client4:DeleteEditObject()
                end

                if SuspendedPreview then
                    if SuspendedPreview.EditingExistingObject then
                        if a0.SuspendedPreview == SuspendedPreview then
                            if SuspendedPreview.EditObject then
                                SuspendedPreview.EditObject:Destroy()
                            end

                            a0.SuspendedPreview = nil
                        end
                    end
                end

                Client4:ClearBuildObjectHover()
                if Client4.EditObject then
                    Client4:RefreshBuildValidation(true)
                end

                Client4:UpdateStorageCapacity()
            end
        end
    end

    return v1613
end

v1521.History = History

local function ToggleColourPicker(a0) --[[ Upvalues: v51 (copy) ]]
    if not a0:IsGamepad() or not a0.Client.Painting or a0.Busy then
        return
    end

    v51.ControllerPicker(a0.Client)
    a0:SyncOwnership()
    a0:RefreshPresentation()
end

v1521.ToggleColourPicker = ToggleColourPicker

local function GetPaintTool(a0)
    local PaintMode = a0.Client.PaintMode
    if PaintMode == "ColorDropper" then
        PaintMode = a0.Client.PaintReturnMode
    end

    if PaintMode == "PaintBucket" then
        return "PaintBucket"
    end

    return "PaintBrush"
end

v1521.GetPaintTool = GetPaintTool

local function CyclePaintTool(a0) --[[ Upvalues: v51 (copy) ]]
    if not a0:IsGamepad() or not a0.Client.Painting or a0.Busy or a0:BlocksWorld() then
        return
    end

    local v1614
    if a0:GetPaintTool() == "PaintBrush" then
        v1614 = "PaintBucket"
    else
        v1614 = "PaintBrush"
    end

    v51.ControllerTool(a0.Client, v1614)
    a0.Client.PaintReturnMode = nil
    a0.Status = nil
    a0.StatusUntil = nil
end

v1521.CyclePaintTool = CyclePaintTool

local function SamplePaintColor(a0) --[[ Upvalues: v51 (copy) ]]
    if not a0:IsGamepad() or not a0.Client.Painting or a0.Busy or a0:BlocksWorld() then
        return
    end

    local v1615 = v51.ControllerSample(a0.Client)
    local v1616
    if v1615 then
        v1616 = "Colour sampled"
    else
        v1616 = "Aim at a paintable surface to sample its colour."
    end

    a0.Status = v1616
    a0.StatusUntil = os.clock() + 1.5
    return v1615
end

v1521.SamplePaintColor = SamplePaintColor

local function CloseMenu2(a0) --[[ Upvalues: GuiService (copy) ]]
    a0:CancelHeldInputs()
    a0.UI:CloseMenu()
    a0.Precision = false
    a0.StepsMode = nil
    a0.StepsReturn = nil
    GuiService.SelectedObject = nil
    a0:SyncOwnership()
end

v1521.CloseMenu = CloseMenu2

local function OpenCatalogue2(a0)
    if not a0:IsGamepad() then
        return
    end

    a0:CancelHeldInputs()
    a0.Precision = false
    a0.UI:OpenCatalogue()
    a0:SyncOwnership()
end

v1521.OpenCatalogue = OpenCatalogue2

local function OpenOptions1(a0)
    a0:CancelHeldInputs()
    a0.Precision = false
    a0.UI:OpenOptions(a0.Client.Painting == true)
    a0:SyncOwnership()
end

v1521.OpenOptions = OpenOptions1

local function OpenPrecision2(a0)
    if not a0.Client.EditObject or a0.Client.Painting or a0:ExternalBlocked() then
        a0.Status = "Choose an object to adjust"
        return
    end

    a0:CancelHeldInputs()
    a0:SetFollowing(false)
    a0.Precision = true
    local v1617 = a0:PresentationState()
    a0.UI:OpenPrecision(v1617)
    a0:SyncOwnership()
end

v1521.OpenPrecision = OpenPrecision2

local function SetPrecisionMode(a0, a1)
    if not a0.Precision then
        return
    end

    if a1 ~= "Move" then
        if a1 ~= "Rotate" then
            return
        end
    end

    a0.RepeatDirection = nil
    a0.RepeatAt = nil
    a0.Client:SetBuildTransformMode(a1)
    a0:RefreshPresentation()
end

v1521.SetPrecisionMode = SetPrecisionMode

local function SetAxis(a0, a1)
    if a1 ~= "X" and a1 ~= "Y" and a1 ~= "Z" then
        return
    end

    a0.RepeatDirection = nil
    a0.RepeatAt = nil
    a0.Axis = a1
    a0:RefreshPresentation()
end

v1521.SetAxis = SetAxis

local function Nudge(a0, a1)
    if not a0.Precision or a0.UI.MenuKind ~= "Precision" or a0:ExternalBlocked() then
        return
    end

    local Axis = a0.Axis
    local v1618
    if a1 < 0 then
        v1618 = -1
    else
        v1618 = 1
    end

    a0.Client:NudgeBuildObject(Axis, v1618)
    a0.Client:RefreshBuildValidation(true)
    a0.Status = nil
    a0:RefreshPresentation()
end

v1521.Nudge = Nudge

local function OpenSteps1(a0, a1)
    if not a0:IsGamepad() or not a0:QuickAdjustAvailable() or a0:ExternalBlocked() then
        return
    end

    local Precision1 = a0.Precision
    if Precision1 then
        Precision1 = a0.UI.MenuKind == "Precision"
    end

    if not Precision1 and not (a0.UI.MenuKind == "Options") then
        return
    end

    local v1621 = a1 or a0.Client.BuildTransformMode or "Move"
    a1 = v1621
    if a1 ~= "Move" and a1 ~= "Rotate" then
        return
    end

    a0:CancelHeldInputs()
    a0.StepsMode = a1
    local v1622
    if Precision1 then
        v1622 = "Precision"
    else
        v1622 = "Options"
    end

    a0.StepsReturn = v1622
    local v1623
    if not (a1 == "Rotate" and a0.Client.BuildRotateStep) then
        v1623 = a0.Client.BuildMoveStep
    end

    a0.UI:OpenSteps(a1, v1623)
    a0:SyncOwnership()
end

v1521.OpenSteps = OpenSteps1

local function ReturnFromSteps(a0)
    a0.StepsMode = nil
    a0.StepsReturn = nil
    if a0.StepsReturn == "Options" then
        a0:OpenOptions()
        return
    end

    a0:OpenPrecision()
end

v1521.ReturnFromSteps = ReturnFromSteps

local function SetStep(a0, a1) --[[ Upvalues: v60 (copy), v158 (copy) ]]
    if not a0:IsGamepad() or a0.UI.MenuKind ~= "Steps" or a0:ExternalBlocked() then
        return
    end

    local v1624 = a0.StepsMode == "Rotate"
    if not table.find(v1624 and v60 or v158, a1) then
        return
    end

    if v1624 then
        a0.Client.BuildRotateStep = a1
    else
        a0.Client.BuildMoveStep = a1
        a0.Client:RebuildBuildGrid()
    end

    a0:ReturnFromSteps()
end

v1521.SetStep = SetStep

local function QuickAdjustAvailable(a0)
    local v1627 = not a0.Client.Painting
    if v1627 then
        v1627 = false
        if a0.Client.BuildModeKind ~= "Paint" then
            v1627 = not a0.Client.DeletingObjects
        end
    end

    return v1627
end

v1521.QuickAdjustAvailable = QuickAdjustAvailable

local function StopGridAdjustment(a0, a1)
    local GridAdjustKey = a0.GridAdjustKey
    if a1 and GridAdjustKey and a0.HeldKeys[GridAdjustKey] then
        a0.RequireRelease[GridAdjustKey] = true
    end

    a0.GridAdjustDirection = nil
    a0.GridAdjustKey = nil
    a0.GridRepeatAt = nil
end

v1521.StopGridAdjustment = StopGridAdjustment

local function StopQuickRotation(a0, a1)
    local QuickRotateKey = a0.QuickRotateKey
    if a1 and QuickRotateKey and a0.HeldKeys[QuickRotateKey] then
        a0.RequireRelease[QuickRotateKey] = true
    end

    a0.QuickRotateDirection = nil
    a0.QuickRotateKey = nil
    a0.QuickRotateRepeatAt = nil
end

v1521.StopQuickRotation = StopQuickRotation

local function CycleQuickRotateAxis(a0) --[[ Upvalues: v1577 (copy) ]]
    if not a0:IsGamepad() or not a0:QuickAdjustAvailable() or a0:ExternalBlocked() or a0.Precision or a0.UI.MenuOpen then
        return
    end

    a0:StopQuickRotation(true)
    a0.QuickRotateAxis = v1577[(table.find(v1577, a0.QuickRotateAxis) or 1) % #v1577 + 1]
    a0.QuickRotateAxisNoticeUntil = os.clock() + 1.6
    a0.Status = nil
    a0:RefreshPresentation()
end

v1521.CycleQuickRotateAxis = CycleQuickRotateAxis

local function QuickRotate(a0, a1, a2)
    local v1628 = false
    if a2 == true then
        v1628 = a0.Precision
        if v1628 then
            v1628 = a0.UI.MenuKind == "Precision"
        end
    end

    if not a0:IsGamepad() then
        return false
    end

    if not a0:QuickAdjustAvailable() then
        return false
    end

    if a0:ExternalBlocked() then
        return false
    end

    if a0.Precision or a0.UI.MenuOpen then
        if not v1628 then
            return false
        end
    end

    local Client5 = a0.Client
    if not (Client5.EditObject and Client5.BuildObjectPosition) then
        a0.Status = "Choose an object to rotate"
        return false
    end

    if v1628 then
        a0.RepeatDirection = nil
        a0.RepeatAt = nil
        local Axis1 = a0.Axis
        local v1629
        if a1 < 0 then
            v1629 = -1
        else
            v1629 = 1
        end

        Client5:RotateBuildObjectStep(Axis1, v1629)
        Client5:RefreshBuildValidation(true)
        a0.Status = nil
        a0:RefreshPresentation()
        return true
    end

    v1628 = Client5.BuildObjectRotation or Vector3.new(-90, 90, 0)
    local v1630 = Client5.BuildRotateStep or 15
    local v1631
    if a1 < 0 then
        v1631 = -1
    else
        v1631 = 1
    end

    local v1632 = v1630 * v1631
    v1630 = a0.QuickRotateAxis or "Y"
    local v1633 = math.rad(v1632)
    local v1640 = CFrame.Angles(v1630 == "X" and v1633 or 0, v1630 == "Y" and v1633 or 0, v1630 == "Z" and v1633 or 0)
    local v1641 = math.rad(v1628.X)
    local v1642 = math.rad(v1628.Y)
    local v1643, v1644, v1645 = (v1640 * CFrame.Angles(v1641, v1642, math.rad(v1628.Z))):ToEulerAnglesXYZ()
    local v1646 = math.deg(v1643)
    local v1647 = math.deg(v1644)
    Client5.BuildObjectRotation = Vector3.new(v1646, v1647, math.deg(v1645))
    Client5:ClampBuildObjectToBounds()
    Client5.BuildTransformDirty = true
    Client5:RefreshBuildValidation(true)
    a0.Status = nil
    a0:RefreshPresentation()
    return true
end

v1521.QuickRotate = QuickRotate

local function AdjustGrid(a0, a1)
    if not a0:IsGamepad() then
        return false
    end

    if not a0:QuickAdjustAvailable() then
        return false
    end

    if a0:ExternalBlocked() then
        return false
    end

    if a0.UI.MenuOpen then
        if a0.UI.MenuKind ~= "Precision" then
            return false
        end
    end

    local Client6 = a0.Client
    if type(Client6.AdjustBuildGridHeight) ~= "function" then
        return false
    end

    if Client6.BuildGridEnabled == false then
        Client6.BuildGridEnabled = true
        if type(Client6.RebuildBuildGrid) == "function" then
            Client6:RebuildBuildGrid()
        end
    end

    Client6:AdjustBuildGridHeight(a1)
    a0.Status = nil
    return true
end

v1521.AdjustGrid = AdjustGrid

local function CycleStep(a0, a1) --[[ Upvalues: v60 (copy), v158 (copy) ]]
    if not a0:IsGamepad() then
        return
    end

    if not a0:QuickAdjustAvailable() then
        return
    end

    if a0:ExternalBlocked() then
        return
    end

    if a0.UI.MenuOpen then
        if a0.UI.MenuKind ~= "Precision" then
            return
        end
    end

    local Client7 = a0.Client
    local v1648 = a1 == "Rotate"
    local v1651
    if v1648 then
        v1651 = Client7.BuildRotateStep
        if not v1651 then
            v1651 = 15
            -- branch continues at 46
        end
    else
        v1651 = Client7.BuildMoveStep or 0.5
    end

    local v1652 = table.find(v1648 and v60 or v158, v1651) or 0
    local v1653 = (v1648 and v60 or v158)[v1652 % #(v1648 and v60 or v158) + 1]
    if v1648 then
        Client7.BuildRotateStep = v1653
    else
        Client7.BuildMoveStep = v1653
        if type(Client7.RebuildBuildGrid) == "function" then
            Client7:RebuildBuildGrid()
        end
    end

    a0.Status = nil
    a0:RefreshPresentation()
end

v1521.CycleStep = CycleStep

local function OpenPalette1(a0)
    a0:ToggleColourPicker()
end

v1521.OpenPalette = OpenPalette1

local function ChooseColor(a0, a1) --[[ Upvalues: v51 (copy) ]]
    if not (typeof(a1) == "Color3" and a0.Client.Painting) then
        return
    end

    v51.ControllerSetColor(a0.Client, a1)
    local ModernPaintColors = a0.Client.ModernPaintColors
    if not ModernPaintColors then
        ModernPaintColors = {}
    end

    a0.Client.ModernPaintColors = ModernPaintColors
    for i6 = #ModernPaintColors, 1, -1 do
        if ModernPaintColors[i6] == a1 then
            table.remove(ModernPaintColors, i6)
        end
    end

    table.insert(ModernPaintColors, 1, a1)
    while 8 < #ModernPaintColors do
        table.remove(ModernPaintColors)
    end

    a0:RefreshPresentation()
end

v1521.ChooseColor = ChooseColor

local function SuspendPreview(a0) --[[ Upvalues: t6 (copy) ]]
    local Client8 = a0.Client
    if not (a0:IsGamepad() and Client8.EditObject) then
        return false
    end

    a0:SetFollowing(false)
    a0:CloseMenu()
    local v1656 = {}
    for k354, k355 in ipairs(t6) do
        v1656[k355] = Client8[k355]
        Client8[k355] = nil
    end

    v1656.EditObject.Parent = nil
    local EditExistingOriginalTransparency = v1656.EditExistingOriginalTransparency
    if not EditExistingOriginalTransparency then
        EditExistingOriginalTransparency = {}
    end

    for k356, k357 in pairs(EditExistingOriginalTransparency) do
        if k356.Parent then
            k356.LocalTransparencyModifier = k357
        end
    end

    Client8.Mouse.TargetFilter = nil
    Client8:HideBuildGizmos()
    a0.SuspendedPreview = v1656
    return true
end

v1521.SuspendPreview = SuspendPreview

local function ResumePreview(a0) --[[ Upvalues: copyColors (copy), t6 (copy) ]]
    local SuspendedPreview1 = a0.SuspendedPreview
    local Client9 = a0.Client
    if not SuspendedPreview1 or Client9.BuildModeKind == "Paint" then
        return
    end

    a0.SuspendedPreview = nil
    if Client9.EditObject then
        Client9:DeleteEditObject()
    end

    if SuspendedPreview1.EditingExistingObject and not SuspendedPreview1.EditingExistingObject.Parent then
        SuspendedPreview1.EditObject:Destroy()
        return
    end

    if SuspendedPreview1.EditingExistingObject then
        copyColors(SuspendedPreview1.EditingExistingObject, SuspendedPreview1.EditObject, false)
    end

    for k358, k359 in ipairs(t6) do
        Client9[k359] = SuspendedPreview1[k359]
    end

    local EditExistingOriginalTransparency1 = Client9.EditExistingOriginalTransparency
    if not EditExistingOriginalTransparency1 then
        EditExistingOriginalTransparency1 = {}
    end

    for k360 in pairs(EditExistingOriginalTransparency1) do
        if k360.Parent then
            k360.LocalTransparencyModifier = 1
        end
    end

    Client9.EditObject.Parent = workspace.CurrentCamera
    local v1669 = Client9:GetBuildObjectCFrame()
    Client9.EditObject:PivotTo(v1669)
    Client9.Mouse.TargetFilter = Client9.EditObject
    a0.Following = false
    a0.Status = "Object restored where you left it"
    local v1670 = Client9:GetBuildObjectCFrame()
    Client9:UpdateBuildGizmo(v1670)
end

v1521.ResumePreview = ResumePreview

local function Exit(a0)
    if a0.Client.EditingBase then
        a0.Client:StopEditStorage()
        return
    end

    if a0.Client.Painting then
        a0.Client:ClosePaintFrames()
        return
    end

    a0.Client:EndBuildMode()
end

v1521.Exit = Exit

local function OpenLegacyPanel(a0, a1) --[[ Upvalues: v51 (copy), ContextActionService (copy), GuiService (copy), GamepadService (copy), UserInputService (copy), v1522 (copy) ]]
    local Client10 = a0.Client
    local t16 = {
        Base = Client10.StorageBase,
        CameraPosition = Client10.BuildCameraPosition,
        CameraYaw = Client10.BuildCameraYaw,
        CameraPitch = Client10.BuildCameraPitch,
        Focus = Client10.BuildFocus,
        Distance = Client10.BuildDistance
    }
    if Client10.Painting then
        v51.Close(Client10)
    end

    if a0:SuspendPreview() then
        t16.Preview = a0.SuspendedPreview
        t16.Preview.CurrentFrame = nil
        a0.SuspendedPreview = nil
    end

    local function discardPreview() --[[ Upvalues: t16 (copy) ]]
        local Preview6 = t16.Preview
        if not Preview6 then
            return
        end

        t16.Preview = nil
        if Preview6.EditObject then
            Preview6.EditObject:Destroy()
        end
    end

    a0:Exit()
    if Client10.ModernReturnCleanup then
        Client10.ModernReturnCleanup(false)
    end

    if a1 == "Customize" then
        Client10:OpenCustomizeBase()
    else
        Client10:OpenBaseSlots()
    end

    local v1671
    if not (a1 == "Customize" and Client10.HUD.BaseCustomization) then
        v1671 = Client10.HUD.BaseSlots
    end

    if not (v1671 and v1671.Visible) then
        local Preview7 = t16.Preview
        if not Preview7 then
            return
        end

        t16.Preview = nil
        if Preview7.EditObject then
            Preview7.EditObject:Destroy()
        end

        return
    end

    Client10.MainContext.Enabled = false
    local v1672 = {}
    local v1673 = false
    local Enabled = Client10.MainContext.Enabled

    local function cleanup(a0) --[[ Upvalues: v1673 (ref), v1672 (copy), ContextActionService (upvalue), Client10 (copy), Enabled (copy), GuiService (upvalue), GamepadService (upvalue), t16 (copy) ]]
        if v1673 then
            return
        end

        v1673 = true
        for k361, k362 in ipairs(v1672) do
            k362:Disconnect()
        end

        ContextActionService:UnbindAction("ModernBuildExternalBack")
        Client10.ModernReturnCleanup = nil
        Client10.MainContext.Enabled = Enabled
        GuiService.SelectedObject = nil
        if GamepadService.GamepadCursorEnabled then
            GamepadService:DisableGamepadCursor()
        end

        task.defer(function() --[[ Upvalues: a0 (copy), Client10 (upvalue), t16 (upvalue) ]]
            if a0 then
                if Client10.Player:GetAttribute("InBase") then
                    if Client10.Humanoid then
                        if 0 < Client10.Humanoid.Health then
                            if not Client10.EditingBase then
                                if not Client10.CustomizingBase then
                                    if not Client10.InBaseSlots then
                                        if not Client10.Painting then
                                            Client10:EditStorage()
                                            local ModernController8 = Client10.ModernController
                                            if ModernController8 and Client10.StorageBase == t16.Base then
                                                ModernController8:CloseMenu()
                                                ModernController8.SuspendedPreview = t16.Preview
                                                t16.Preview = nil
                                                ModernController8:ResumePreview()
                                                Client10.BuildCameraPosition = t16.CameraPosition
                                                Client10.BuildCameraYaw = t16.CameraYaw
                                                Client10.BuildCameraPitch = t16.CameraPitch
                                                Client10.BuildFocus = t16.Focus
                                                Client10.BuildDistance = t16.Distance
                                                Client10:UpdateBuildCameraCFrame()
                                                ModernController8:RefreshPresentation()
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            local Preview8 = t16.Preview
            if not Preview8 then
                return
            end

            t16.Preview = nil
            if Preview8.EditObject then
                Preview8.EditObject:Destroy()
            end

        end)
    end

    Client10.ModernReturnCleanup = cleanup
    local v1677 = v1671:GetPropertyChangedSignal("Visible")
    local v1678 = v1677:Connect(function() --[[ Upvalues: v1671 (copy), cleanup (copy) ]]
        if not v1671.Visible then
            cleanup(true)
        end

    end)
    table.insert(v1672, v1678)
    local v1679 = Client10.Player.CharacterRemoving:Connect(function() --[[ Upvalues: cleanup (copy) ]]
        cleanup(false)
    end)
    table.insert(v1672, v1679)
    ContextActionService:BindActionAtPriority("ModernBuildExternalBack", function(a0, a1) --[[ Upvalues: GuiService (upvalue), UserInputService (upvalue), a1 (copy), Client10 (copy) ]]
        if GuiService.MenuIsOpen then
            return Enum.ContextActionResult.Pass
        end

        if a1 == Enum.UserInputState.Begin then
            if UserInputService:GetFocusedTextBox() then
                UserInputService:GetFocusedTextBox():ReleaseFocus()
            else
                if a1 == "Customize" then
                    Client10:CloseCustomizeBase()
                else
                    if Client10.BaseSlotConfirmAction then
                        Client10:CloseBaseSlotConfirmation()
                    else
                        Client10:CloseBaseSlots()
                    end
                end
            end
        end

        return Enum.ContextActionResult.Sink
    end, false, v1522, Enum.KeyCode.ButtonB)
    local v1680 = v1671:FindFirstChildWhichIsA("GuiButton", true)
    GamepadService:EnableGamepadCursor(v1680)
end

v1521.OpenLegacyPanel = OpenLegacyPanel

local function Option(a0, a1) --[[ Upvalues: v51 (copy) ]]
    if not a0:IsGamepad() or a0.Busy then
        return
    end

    local Client11 = a0.Client
    if a1 == "CameraAngle" then
        a0:CancelHeldInputs()
        a0.Precision = false
        a0.UI:OpenCameraAngles()
        a0:SyncOwnership()
        return
    end

    if a1 == "PaintMode" or a1 == "ObjectsMode" then
        a0:CloseMenu()
        if a1 == "PaintMode" then
            Client11:SetDeletingObjects(false)
            if not Client11.Painting then
                Client11:OpenPaintFrames()
                -- branch continues at 63
            end
        else
            if Client11.Painting then
                v51.Close(Client11)
            end
        end

        a0.Status = nil
        a0.StatusUntil = nil
        a0:SyncOwnership()
        a0:RefreshPresentation()
        return
    end

    if a1 == "Catalogue" then
        a0:OpenCatalogue()
        return
    end

    if a1 == "ColourPicker" then
        a0:OpenPalette()
        return
    end

    if a1 == "MoveSteps" or a1 == "RotateSteps" then
        local v1681
        if a1 == "RotateSteps" then
            v1681 = "Rotate"
        else
            v1681 = "Move"
        end

        a0:OpenSteps(v1681)
        return
    end

    a0:CloseMenu()
    if a1 == "Resume" then
        return
    end

    if a1 == "Exit" then
        a0:Exit()
        return
    end

    if a1 == "SwitchClassic" then
        if Client11.Painting then
            v51.Close(Client11)
        end

        Client11:SetBuildSystem("Classic", true)
        return
    end

    if a1 == "Customize" or a1 == "SaveSlots" then
        a0:OpenLegacyPanel(a1)
        return
    end

    if a1 == "Brush" or a1 == "Bucket" or a1 == "Dropper" then
        if not Client11.Painting then
            Client11:OpenPaintFrames()
        end

        if Client11.Painting then
            v51.ControllerTool(Client11, ({Brush = "PaintBrush", Bucket = "PaintBucket", Dropper = "ColorDropper"})[a1])
            -- jump to 269 (out of range)
            -- branch continues at 269
        end
    end

    if a1 == "Objects" then
        if Client11.Painting then
            v51.Close(Client11)
            -- branch continues at 269
        end
    else
        if a1 == "Delete" then
            if Client11.Painting then
                v51.Close(Client11)
            end

            a0:SetFollowing(false)
            Client11:SetDeletingObjects(not Client11.DeletingObjects)
        else
            if a1 == "Grid" then
                Client11.BuildGridEnabled = not Client11.BuildGridEnabled
                Client11:RebuildBuildGrid()
            else
                if a1 == "GridUp" or a1 == "GridDown" then
                    local v1682
                    if a1 == "GridUp" then
                        v1682 = 1
                    else
                        v1682 = -1
                    end

                    Client11:AdjustBuildGridHeight(v1682)
                    -- jump to 269 (out of range)
                end

                if a1 == "DeleteAll" then
                    if Client11.Painting then
                        v51.Close(Client11)
                    end

                    Client11:SetDeleteAllConfirmation(true)
                else
                    if a1 == "ResetPaint" then
                        v51.ShowResetConfirmation(Client11)
                    else
                        local v1683 = ({ViewTop = "Top", ViewFront = "Front", ViewBack = "Back", ViewLeft = "Left", ViewRight = "Right", ViewIso = "Iso", ViewSide = "Right", ViewReset = "Iso"})[a1]
                        if v1683 then
                            Client11:SetBuildView(v1683)
                        end
                    end
                end
            end
        end
    end

    a0:SyncOwnership()
    a0:RefreshPresentation()
end

v1521.Option = Option

local function Commit(a0, a1)
    local v1684 = false
    if a1 == true then
        v1684 = a0.Precision
        if v1684 then
            v1684 = a0.UI.MenuKind == "Precision"
        end
    end

    if not a0:IsGamepad() then
        return
    end

    if a0.Busy then
        return
    end

    if a0:ExternalBlocked() then
        return
    end

    if a0.Precision or a0.UI.MenuOpen then
        if not v1684 then
            return
        end
    end

    if not a0.Client.EditObject then
        return
    end

    if a0.Committing then
        return
    end

    a0.Committing = true
    local v1685, v1686 = pcall(function() --[[ Upvalues: a0 (copy) ]]
        a0.Client:AttemptPlaceBuildObject()
    end)
    a0.Committing = false
    if not v1685 then
        warn("Modern building could not commit: " .. tostring(v1686))
    end

    if not a0.Client.EditObject then
        a0.Following = false
        if v1684 and a0:IsGamepad() and a0.Precision and a0.UI.MenuKind == "Precision" then
            a0:CloseMenu()
        end
    end

    a0:RefreshPresentation()
end

v1521.Commit = Commit

local function Primary1(a0) --[[ Upvalues: v51 (copy) ]]
    if not a0:IsGamepad() or a0.Busy or a0:BlocksWorld() then
        return
    end

    local Client12 = a0.Client
    if Client12.Painting then
        v51.ControllerApply(Client12)
        return
    end

    if Client12.DeletingObjects then
        local v1687 = a0:Center()
        local v1688 = Client12:GetPlacedBuildObjectAtScreenPosition(v1687)
        if v1688 then
            a0:Delete(v1688)
            return
            -- branch continues at 73
        end
    end

    if Client12.EditObject then
        a0:Commit()
        return
    end

    local v1689 = a0:Center()
    local v1690 = Client12:GetPlacedBuildObjectAtScreenPosition(v1689)
    if v1690 and Client12:SelectPlacedBuildObject(v1690) then
        a0:SetFollowing(true, true)
        return
    end

    a0.Status = "Aim at an object, or press Y for the catalogue"
end

v1521.Primary = Primary1

local function Back(a0) --[[ Upvalues: v51 (copy) ]]
    local Client13 = a0.Client
    if Client13.DeleteAllConfirmOpen then
        Client13:SetDeleteAllConfirmation(false)
    else
        if Client13.PaintResetConfirmOpen then
            v51.HideResetConfirmation(Client13)
        else
            if Client13.ColorPickerHUD then
                v51.ControllerClosePicker(Client13)
            else
                if a0.UI.MenuKind == "Steps" then
                    a0:ReturnFromSteps()
                else
                    if a0.UI.MenuKind == "CameraAngles" then
                        a0:OpenOptions()
                    else
                        if a0.UI.MenuOpen then
                            a0:CloseMenu()
                        else
                            if Client13.EditObject then
                                a0:SetFollowing(false)
                                Client13:DeleteEditObject()
                            else
                                if Client13.Painting then
                                    v51.Close(Client13)
                                else
                                    if Client13.DeletingObjects then
                                        Client13:SetDeletingObjects(false)
                                    else
                                        a0:OpenOptions()
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    a0.Status = nil
    a0:SyncOwnership()
    a0:RefreshPresentation()
end

v1521.Back = Back

local function HandleInput(a0, a1, a2, a3) --[[ Upvalues: GuiService (copy), UserInputService (copy), v51 (copy) ]]
    if not a0:IsGamepad() then
        return Enum.ContextActionResult.Pass
    end

    local KeyCode = a3.KeyCode
    local v1691 = a2 == Enum.UserInputState.Begin
    local v1692 = true
    if a2 ~= Enum.UserInputState.End then
        v1692 = a2 == Enum.UserInputState.Cancel
    end

    local v1693 = a0.HeldKeys[KeyCode]
    if v1691 then
        a0.HeldKeys[KeyCode] = true
    end

    if v1692 then
        a0.HeldKeys[KeyCode] = nil
        a0.RequireRelease[KeyCode] = nil
        if KeyCode == Enum.KeyCode.ButtonL1 or KeyCode == Enum.KeyCode.ButtonR1 then
            a0.RepeatDirection = nil
            a0.RepeatAt = nil
        end

        if KeyCode == Enum.KeyCode.ButtonL2 or KeyCode == a0.GridAdjustKey then
            a0:StopGridAdjustment(true)
        end

        if KeyCode == Enum.KeyCode.ButtonL2 or KeyCode == a0.QuickRotateKey then
            a0:StopQuickRotation(true)
        end
    end

    if KeyCode == Enum.KeyCode.ButtonA then
        if a0.MenuPrimary then
            if v1692 then
                a0.MenuPrimary = nil
            end

            return Enum.ContextActionResult.Pass
        end
    end

    if GuiService.MenuIsOpen then
        if KeyCode == Enum.KeyCode.ButtonA and v1691 and not a0.RequireRelease[KeyCode] then
            a0.MenuPrimary = true
        end

        return Enum.ContextActionResult.Pass
    end

    if a0.WindowUnfocused then
        return Enum.ContextActionResult.Sink
    end

    if UserInputService:GetFocusedTextBox() then
        if not a0:PickerOpen() then
            if v1691 and KeyCode == Enum.KeyCode.ButtonB then
                UserInputService:GetFocusedTextBox():ReleaseFocus()
            end

            return Enum.ContextActionResult.Sink
        end
    end

    if a0.RequireRelease[KeyCode] and not v1692 then
        return Enum.ContextActionResult.Sink
    end

    if a0:PickerOpen() then
        if KeyCode == Enum.KeyCode.ButtonL2 or KeyCode == Enum.KeyCode.ButtonR2 or KeyCode == Enum.KeyCode.ButtonX then
            return Enum.ContextActionResult.Sink
        end

        if KeyCode == Enum.KeyCode.ButtonY or KeyCode == Enum.KeyCode.ButtonB then
            if v1691 and not v1693 then
                v51.ControllerClosePicker(a0.Client)
                a0:SyncOwnership()
                a0:RefreshPresentation()
            end

            return Enum.ContextActionResult.Sink
        end

        if KeyCode == Enum.KeyCode.ButtonA and v1691 then
            a0.MenuPrimary = true
        end

        return Enum.ContextActionResult.Pass
    end

    if a0:ExternalBlocked() then
        if v1691 and KeyCode == Enum.KeyCode.ButtonB then
            a0:Back()
            return Enum.ContextActionResult.Sink
        end

        if KeyCode ~= Enum.KeyCode.ButtonA then
            local v1694 = true
            if KeyCode ~= Enum.KeyCode.DPadLeft then
                v1694 = true
                if KeyCode ~= Enum.KeyCode.DPadRight then
                    v1694 = true
                    if KeyCode ~= Enum.KeyCode.DPadUp then
                        v1694 = KeyCode == Enum.KeyCode.DPadDown
                    end
                end
            end

            if not v1694 then
                -- jump to 272
            end
        end

        if KeyCode == Enum.KeyCode.ButtonA and v1691 then
            a0.MenuPrimary = true
        end

        return Enum.ContextActionResult.Pass
        return Enum.ContextActionResult.Sink
    end

    if a0.UI.MenuOpen then
        if a0.UI.MenuKind ~= "Precision" then
            if KeyCode ~= Enum.KeyCode.ButtonA then
                local v1695 = true
                if KeyCode ~= Enum.KeyCode.DPadLeft then
                    v1695 = true
                    if KeyCode ~= Enum.KeyCode.DPadRight then
                        v1695 = true
                        if KeyCode ~= Enum.KeyCode.DPadUp then
                            v1695 = KeyCode == Enum.KeyCode.DPadDown
                        end
                    end
                end

                if not v1695 then
                    -- jump to 323
                end
            end

            if KeyCode == Enum.KeyCode.ButtonA and v1691 then
                a0.MenuPrimary = true
            end

            return Enum.ContextActionResult.Pass
            if v1691 then
                if not v1693 then
                    if KeyCode == Enum.KeyCode.ButtonB then
                        a0:Back()
                    else
                        if KeyCode == Enum.KeyCode.ButtonY then
                            a0:CloseMenu()
                        else
                            if a0.UI.MenuKind == "Catalogue" and KeyCode == Enum.KeyCode.ButtonX then
                                a0.UI:ToggleFocusedFavorite()
                            else
                                if a0.UI.MenuKind == "Catalogue" and KeyCode == Enum.KeyCode.ButtonL1 then
                                    a0.UI:ChangeCategory(-1)
                                else
                                    if a0.UI.MenuKind == "Catalogue" and KeyCode == Enum.KeyCode.ButtonR1 then
                                        a0.UI:ChangeCategory(1)
                                    end
                                end
                            end
                        end
                    end
                end
            end

            return Enum.ContextActionResult.Sink
        end
    end

    if not v1691 or v1693 then
        return Enum.ContextActionResult.Sink
    end

    if not a0:QuickAdjustAvailable() then
        a0:StopGridAdjustment(true)
        a0:StopQuickRotation(true)
    end

    if a0:QuickAdjustAvailable() then
        if KeyCode == Enum.KeyCode.ButtonR3 then
            if a0.HeldKeys[Enum.KeyCode.ButtonL2] or a0.RequireRelease[Enum.KeyCode.ButtonL2] then
                if not a0.RequireRelease[Enum.KeyCode.ButtonL2] and not v1693 then
                    a0:CycleQuickRotateAxis()
                end

                return Enum.ContextActionResult.Sink
            end
        end

        if KeyCode == Enum.KeyCode.ButtonL3 then
            if not a0.RequireRelease[Enum.KeyCode.ButtonL2] then
                if not v1693 then
                    local v1696
                    if a0.HeldKeys[Enum.KeyCode.ButtonL2] then
                        v1696 = "Rotate"
                    else
                        v1696 = "Move"
                    end

                    a0:CycleStep(v1696)
                end
            end

            return Enum.ContextActionResult.Sink
        end

        if KeyCode == Enum.KeyCode.ButtonR3 then
            if not v1693 and not a0.Precision then
                local v1697 = not a0.Following
                a0:SetFollowing(v1697, true)
            end

            a0:RefreshPresentation()
            return Enum.ContextActionResult.Sink
        end

        if KeyCode == Enum.KeyCode.DPadUp or KeyCode == Enum.KeyCode.DPadDown then
            if a0.HeldKeys[Enum.KeyCode.ButtonL2] or a0.RequireRelease[Enum.KeyCode.ButtonL2] then
                if not a0.RequireRelease[Enum.KeyCode.ButtonL2] then
                    if not v1693 then
                        a0:StopGridAdjustment(true)
                        a0:StopQuickRotation(true)
                        if KeyCode == Enum.KeyCode.DPadUp then
                            v1692 = 1
                        else
                            v1692 = -1
                        end

                        if a0:AdjustGrid(v1692) then
                            a0.GridAdjustDirection = v1692
                            a0.GridAdjustKey = KeyCode
                            a0.GridRepeatAt = os.clock() + 0.35
                        end
                    end
                end

                a0:RefreshPresentation()
                return Enum.ContextActionResult.Sink
            end
        end

        if not a0.Precision then
            if KeyCode == Enum.KeyCode.DPadLeft or KeyCode == Enum.KeyCode.DPadRight then
                if a0.HeldKeys[Enum.KeyCode.ButtonL2] or a0.RequireRelease[Enum.KeyCode.ButtonL2] then
                    if not a0.RequireRelease[Enum.KeyCode.ButtonL2] then
                        if not v1693 then
                            a0:StopGridAdjustment(true)
                            a0:StopQuickRotation(true)
                            if KeyCode == Enum.KeyCode.DPadLeft then
                                v1691 = -1
                            else
                                v1691 = 1
                            end

                            if a0:QuickRotate(v1691) then
                                a0.QuickRotateDirection = v1691
                                a0.QuickRotateKey = KeyCode
                                a0.QuickRotateRepeatAt = os.clock() + 0.35
                            end
                        end
                    end

                    a0:RefreshPresentation()
                    return Enum.ContextActionResult.Sink
                end
            end
        end
    end

    if KeyCode == Enum.KeyCode.ButtonB then
        a0:Back()
    else
        if a0.Precision then
            if KeyCode == Enum.KeyCode.ButtonX then
                a0:CloseMenu()
                -- jump to 924 (out of range)
            end

            if KeyCode == Enum.KeyCode.ButtonY then
                a0:OpenSteps()
                -- jump to 924 (out of range)
            end

            if KeyCode == Enum.KeyCode.ButtonR2 then
                if not a0.RequireRelease[Enum.KeyCode.ButtonL2] then
                    local v1698
                    if a0.HeldKeys[Enum.KeyCode.ButtonL2] then
                        v1698 = -1
                    else
                        v1698 = 1
                    end

                    a0:QuickRotate(v1698, true)
                    -- jump to 924 (out of range)
                    -- branch continues at 924
                end
            end

            if KeyCode == Enum.KeyCode.ButtonA then
                a0:Commit(true)
                -- jump to 924 (out of range)
            end

            if KeyCode == Enum.KeyCode.DPadUp or KeyCode == Enum.KeyCode.DPadDown then
                local v1699
                if a0.Client.BuildTransformMode == "Rotate" then
                    v1699 = "Move"
                else
                    v1699 = "Rotate"
                end

                a0:SetPrecisionMode(v1699)
                -- jump to 924 (out of range)
            end

            if KeyCode == Enum.KeyCode.DPadLeft or KeyCode == Enum.KeyCode.DPadRight then
                v1693 = {"X", "Y", "Z"}
                local v1700
                if KeyCode == Enum.KeyCode.DPadLeft then
                    v1700 = -1
                else
                    v1700 = 1
                end

                a0:SetAxis(v1693[((table.find(v1693, a0.Axis) or 2) - 1 + v1700) % 3 + 1])
                -- jump to 924 (out of range)
            end

            if KeyCode ~= Enum.KeyCode.ButtonL1 then
                if KeyCode ~= Enum.KeyCode.ButtonR1 then
                    -- jump to 924
                end
            end

            local v1701
            if KeyCode == Enum.KeyCode.ButtonL1 then
                v1701 = -1
            else
                v1701 = 1
            end

            a0.RepeatDirection = v1701
            a0.RepeatAt = os.clock() + 0.35
            a0:Nudge(a0.RepeatDirection)
        else
            if KeyCode == Enum.KeyCode.ButtonA then
                a0:Primary()
            else
                if KeyCode == Enum.KeyCode.ButtonR2 then
                    if a0.Client.Painting then
                        a0:CyclePaintTool()
                        -- jump to 924 (out of range)
                    end

                    local v1702
                    if not a0.RequireRelease[Enum.KeyCode.ButtonL2] then
                        a0:StopQuickRotation(true)
                        if a0.HeldKeys[Enum.KeyCode.ButtonL2] then
                            v1702 = -1
                        else
                            v1702 = 1
                        end

                        a0:QuickRotate(true)
                        -- branch continues at 924
                    end
                else
                    if KeyCode == Enum.KeyCode.ButtonX then
                        if a0.Client.Painting then
                            a0:SamplePaintColor()
                            -- jump to 924 (out of range)
                        end

                        a0:OpenPrecision()
                    else
                        if KeyCode == Enum.KeyCode.ButtonY then
                            if a0.Client.Painting then
                                a0:ToggleColourPicker()
                                -- jump to 924 (out of range)
                            end

                            a0:OpenCatalogue()
                        else
                            if KeyCode == Enum.KeyCode.DPadUp then
                                a0:OpenOptions()
                            else
                                if KeyCode == Enum.KeyCode.DPadLeft then
                                    a0:History("Undo")
                                else
                                    if KeyCode == Enum.KeyCode.DPadRight then
                                        a0:History("Redo")
                                    else
                                        if KeyCode == Enum.KeyCode.DPadDown then
                                            a0:Option("Delete")
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

    a0:RefreshPresentation()
    return Enum.ContextActionResult.Sink
end

v1521.HandleInput = HandleInput
v1521.GetLegacyVisibility = getLegacyVisibility

local function RestoreLegacyVisibility(a0, a1) --[[ Upvalues: restoreLegacyVisibility (copy) ]]
    if not (a0:IsGamepad() and a1) then
        return
    end

    restoreLegacyVisibility(a0, a1)
end

v1521.RestoreLegacyVisibility = RestoreLegacyVisibility
v1521.SaveAndHide = saveAndHide

local function PresentationState(a0) --[[ Upvalues: v1 (copy) ]]
    local Client14 = a0.Client
    local EditObject2 = Client14.EditObject
    local v1705 = EditObject2 and v1[EditObject2.Name]
    local v1706 = Client14.BuildGui and Client14.BuildGui:FindFirstChild("Toolbar")
    local v1708 = v1706 and v1706:FindFirstChild("Buttons")
    local v1709 = v1708 and v1708:FindFirstChild("Capacity")
    local v1712 = type(Client14.GetBuildGridFloor) == "function" and Client14:GetBuildGridFloor() or nil
    local v1715 = a0.Status or Client14.BuildInvalidReason
    if not v1715 and Client14.BuildPlacementValid ~= false and not a0.Precision and not a0.UI.MenuOpen and a0:QuickAdjustAvailable() then
        local v1716 = a0.QuickRotateAxisNoticeUntil or 0
        if os.clock() < v1716 then
            v1715 = "Rotation axis: " .. (a0.QuickRotateAxis or "Y")
        end
    end

    local v1717 = {}
    local v1718
    if Client14.Painting then
        v1718 = "Paint"
    else
        v1718 = "Objects"
    end

    v1717.mode = v1718
    local v1719
    if not (EditObject2 and EditObject2.Name) then
        local v1720 = Client14.Painting and Client14.PaintMode
    end

    v1717.itemName = v1719
    v1717.deleting = Client14.DeletingObjects == true
    local v1721 = Client14.ObjectHover and Client14.ObjectHover.Name
    v1717.targetName = v1721
    v1721 = false
    if a0.Following == true then
        v1721 = EditObject2 ~= nil
    end

    v1717.following = v1721
    v1717.editingExisting = Client14.EditingExistingObject ~= nil
    local v1723 = v1709 and v1709.Text
    v1717.capacityText = v1723
    local v1724 = v1705 and v1705.Price
    v1717.price = v1724
    v1717.moveStep = Client14.BuildMoveStep or 0.5
    v1717.rotateStep = Client14.BuildRotateStep or 15
    v1717.quickRotateAxis = a0.QuickRotateAxis or "Y"
    local v1725 = false
    if a0.HeldKeys[Enum.KeyCode.ButtonL2] == true then
        v1725 = not a0.RequireRelease[Enum.KeyCode.ButtonL2]
    end

    v1717.slowModifier = v1725
    v1717.gridHeight = v1712 and Client14.BuildGridOffsets and Client14.BuildGridOffsets[v1712] or 0
    v1717.gridEnabled = Client14.BuildGridEnabled == true
    v1717.gridAdjusting = a0.GridAdjustDirection or false
    v1717.quickAdjustAvailable = a0:QuickAdjustAvailable()
    v1717.axis = a0.Axis
    v1717.transformMode = Client14.BuildTransformMode or "Move"
    v1717.valid = Client14.BuildPlacementValid
    v1717.status = v1715
    local ModernBuildRecents2 = Client14.ModernBuildRecents
    if not ModernBuildRecents2 then
        ModernBuildRecents2 = {}
    end

    v1717.recents = ModernBuildRecents2
    ModernBuildRecents2 = Client14.ModernBuildFavorites
    if not ModernBuildRecents2 then
        ModernBuildRecents2 = {}
    end

    v1717.favorites = ModernBuildRecents2
    v1717.undoCount = a0.UndoCount or 0
    v1717.redoCount = a0.RedoCount or 0
    v1717.busy = a0.Busy == true
    v1717.paintTool = a0:GetPaintTool()
    v1717.paintMode = Client14.PaintMode
    v1717.pickerOpen = a0:PickerOpen()
    v1717.paintColor = Client14.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3
    return v1717
end

v1521.PresentationState = PresentationState

local function RefreshPresentation(a0) --[[ Upvalues: hideLegacyPresentation (copy) ]]
    if not a0:IsGamepad() then
        return
    end

    hideLegacyPresentation(a0)
    local v1726 = a0:PresentationState()
    a0.UI:Update(v1726)
    local v1727 = not a0:BlocksWorld()
    local HUD6 = a0.UI.HUD
    local v1728 = v1727
    if not v1728 then
        local v1732 = a0:PickerOpen() and not a0.UI.Obscured
    end

    HUD6.Visible = v1728
    a0.UI.Reticle.Visible = v1727
end

v1521.RefreshPresentation = RefreshPresentation

local function Step(a0, a1)
    if not a0:IsGamepad() then
        return
    end

    local Client15 = a0.Client
    if a0.StatusUntil and a0.StatusUntil <= os.clock() then
        a0.Status = nil
        a0.StatusUntil = nil
    end

    if not Client15.BuildCameraActive or Client15.ClassicBuildActive then
        a0:Destroy()
        return
    end

    a0:SyncOwnership()
    if a0.GridAdjustDirection then
        local GridAdjustKey1 = a0.GridAdjustKey
        if a0:QuickAdjustAvailable() then
            if not a0:ExternalBlocked() then
                if not a0.UI.MenuOpen or a0.UI.MenuKind == "Precision" then
                    if a0.HeldKeys[Enum.KeyCode.ButtonL2] then
                        if a0.HeldKeys[GridAdjustKey1] then
                            if not a0.RequireRelease[Enum.KeyCode.ButtonL2] then
                                if not a0.RequireRelease[GridAdjustKey1] then
                                    -- jump to 92
                                end
                            end
                        end
                    end
                end
            end
        end

        a0:StopGridAdjustment(true)
    end

    if a0.QuickRotateDirection then
        local QuickRotateKey1 = a0.QuickRotateKey
        if not a0:QuickAdjustAvailable() or a0:ExternalBlocked() or a0.UI.MenuOpen or a0.Precision or not a0.HeldKeys[Enum.KeyCode.ButtonL2] or not a0.HeldKeys[QuickRotateKey1] or a0.RequireRelease[Enum.KeyCode.ButtonL2] or a0.RequireRelease[QuickRotateKey1] then
            a0:StopQuickRotation(true)
            -- jump to 195 (out of range)
        end

        if a0.QuickRotateRepeatAt <= os.clock() then
            a0.QuickRotateRepeatAt = os.clock() + 0.12
            if not a0:QuickRotate(a0.QuickRotateDirection) then
                a0:StopQuickRotation(true)
            end
        end
    end

    if a0.Precision and a0.UI.MenuKind == "Precision" and not a0:ExternalBlocked() and a0.RepeatDirection and a0.RepeatAt <= os.clock() then
        a0.RepeatAt = os.clock() + 0.12
        a0:Nudge(a0.RepeatDirection)
    end

    if not a0:BlocksWorld() then
        if Client15.EditObject then
            if not Client15.Painting then
                local CFrame = workspace.CurrentCamera.CFrame
                if a0.Following and CFrame ~= a0.FollowCamera then
                    Client15.BuildDirectGrabBoxLocal = a0.GrabOffset or Vector3.new(0, 0, 0)
                    local v1733 = a0:Center()
                    Client15:UpdateDirectBuildDrag(v1733)
                    a0.FollowCamera = CFrame
                end

                Client15:RefreshBuildValidation(false)
                -- branch continues at 276
            end
        else
            if not Client15.Painting then
                local v1734 = a0:Center()
                Client15:UpdateBuildObjectHover(v1734)
            end
        end
    end

    a0.RefreshElapsed = (a0.RefreshElapsed or 0) + a1
    if 0.08 <= a0.RefreshElapsed then
        a0.RefreshElapsed = 0
        a0:RefreshPresentation()
    end
end

v1521.Step = Step

local function StepCamera(a0, a1) --[[ Upvalues: UserInputService (copy) ]]
    if not a0:IsGamepad() then
        return false
    end

    a0:SyncOwnership()
    local Client16 = a0.Client
    local v1735, v1736 = Client16:GetBuildReference()
    if not (v1735 and v1736) then
        a0:Step(a1)
        return true
    end

    local v1737 = a0:GetPad()
    if not a0:BlocksWorld() and v1737 then
        local zero2 = Vector2.zero
        local zero3 = Vector2.zero
        local v1738 = UserInputService:GetGamepadState(v1737)
        for k363, k364 in ipairs(v1738) do
            local KeyCode1 = k364.KeyCode
            if KeyCode1 == Enum.KeyCode.Thumbstick1 or KeyCode1 == Enum.KeyCode.Thumbstick2 then
                local v1742 = Vector2.new(k364.Position.X, k364.Position.Y)
                local Magnitude1 = v1742.Magnitude
                local v1743
                if Magnitude1 <= 0.15 then
                    v1743 = Vector2.zero
                else
                    v1743 = v1742.Unit * math.min(1, (Magnitude1 - 0.15) / 0.85)
                end

                if v1743.Magnitude == 0 then
                    a0.RequireRelease[KeyCode1] = nil
                end

                if not a0.RequireRelease[KeyCode1] then
                    if KeyCode1 == Enum.KeyCode.Thumbstick1 then
                        zero2 = v1743
                    else
                        zero3 = v1743
                    end
                end
            end
        end

        local function down(a0) --[[ Upvalues: UserInputService (upvalue), v1737 (copy), a0 (copy) ]]
            if not UserInputService:IsGamepadButtonDown(v1737, a0) then
                a0.RequireRelease[a0] = nil
                return false
            end

            return not a0.RequireRelease[a0]
        end

        local ButtonL2 = Enum.KeyCode.ButtonL2
        local v1744
        if not UserInputService:IsGamepadButtonDown(v1737, ButtonL2) then
            a0.RequireRelease[ButtonL2] = nil
            v1744 = false
        else
            v1744 = not a0.RequireRelease[ButtonL2]
        end

        local ButtonR1 = Enum.KeyCode.ButtonR1
        local v1745
        if not UserInputService:IsGamepadButtonDown(v1737, ButtonR1) then
            a0.RequireRelease[ButtonR1] = nil
            v1745 = false
        else
            v1745 = not a0.RequireRelease[ButtonR1]
        end

        local v1746
        if v1745 then
            v1746 = 1
        else
            v1746 = 0
        end

        local ButtonL1 = Enum.KeyCode.ButtonL1
        if not UserInputService:IsGamepadButtonDown(v1737, ButtonL1) then
            a0.RequireRelease[ButtonL1] = nil
            ButtonR1 = false
        else
            ButtonR1 = not a0.RequireRelease[ButtonL1]
        end

        if ButtonR1 then
            v1745 = 1
        else
            v1745 = 0
        end

        ButtonL2 = v1746 - v1745
        down = math.clamp(a1, 0, 0.1)
        if 0 < zero3.Magnitude then
            Client16.BuildViewPreset = nil
            v1745 = Client16.BuildCameraYaw or 0
            local v1747 = zero3.X * 2.2
            local v1748
            if v1744 then
                v1748 = 0.3
            else
                v1748 = 1
            end

            Client16.BuildCameraYaw = v1745 - v1747 * v1748 * down
            local v1749 = Client16.BuildCameraPitch or 0
            v1748 = zero3.Y * 2.2
            local v1750
            if v1744 then
                v1750 = 0.3
            else
                v1750 = 1
            end

            v1745 = v1749 + v1748 * v1750 * down
            Client16.BuildCameraPitch = math.clamp(v1745, -1.5533430342749532, 1.3089969389957472)
        end

        local v1751 = Client16.BuildCameraYaw or 0
        zero3 = v1735.CFrame.Rotation * CFrame.Angles(0, v1751, 0)
        local v1752 = zero3.RightVector * zero2.X
        local v1753 = v1752 + zero3.LookVector * zero2.Y
        local v1754 = v1753 + v1735.CFrame.UpVector * ButtonL2
        if 1 < v1754.Magnitude then
            v1754 = v1754.Unit
        end

        local v1755 = Client16.BuildCameraPosition or workspace.CurrentCamera.CFrame.Position
        local v1756
        if v1744 then
            v1756 = 0.25
        else
            v1756 = 1
        end

        Client16.BuildCameraPosition = Client16:ClampBuildCameraPosition(v1755 + v1754 * 24 * v1756 * down)
        Client16:UpdateBuildCameraCFrame()
        if Client16.BuildModeKind ~= "Paint" then
            Client16:UpdateBuildGridSurface()
        end
    end

    a0:Step(a1)
    return true
end

v1521.StepCamera = StepCamera

local function SetActive2(a0, a1) --[[ Upvalues: GuiService (copy), UserInputService (copy), ContextActionService (copy), v1578 (copy), v1522 (copy), v1579 (copy), v51 (copy), GamepadService (copy) ]]
    local v1757 = false
    if a1 == true then
        v1757 = false
        if a0.Client.BuildCameraActive == true then
            v1757 = not a0.Client.ClassicBuildActive
        end
    end

    a1 = v1757
    if a0.Destroyed or a1 == a0.Active then
        return
    end

    a0.ActivationEpoch = (a0.ActivationEpoch or 0) + 1
    local Client17 = a0.Client
    local v1758
    if a1 then
        if Client17.ModernMobile and Client17.ModernMobile:IsActive() then
            Client17.ModernMobile:SetActive(false)
        end

        a0.Active = true
        a0.SavedContext = Client17.MainContext.Enabled
        a0.SavedAutoSelect = GuiService.AutoSelectGuiEnabled
        a0.SavedFreeMouse = Client17.FreeMouse
        a0.SavedMouseBehavior = UserInputService.MouseBehavior
        a0.SavedMouseIcon = UserInputService.MouseIconEnabled
        a0.SavedCameraLock = Client17.BuildCameraLocked
        Client17.BuildCameraLocked = false
        Client17.MainContext.Enabled = false
        Client17.FreeMouse = false
        Client17:EndBuildTouchGizmoDrag()
        Client17:EndBuildTransformHold()
        Client17:EndDirectBuildDrag()
        Client17:EndBuildMouseCameraDrag()
        pcall(function() --[[ Upvalues: ContextActionService (upvalue) ]]
            ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
            ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
        end)
        GuiService.AutoSelectGuiEnabled = false
        GuiService.SelectedObject = nil
        v1758 = "M2U"
        local v1759 = {"M1U", v1758, "BlockOff", "RunOff"}
        for k365, k366 in ipairs(v1759) do
            a0.Remote:FireServer(k366)
        end

        if a0.Controls then
            local v1763 = v1578[a0.Controls]
            if v1763 then
                v1763.Connection:Disconnect()
                v1578[a0.Controls] = nil
                a0.DisabledControls = true
            else
                if a0.Controls.controlsEnabled ~= false then
                    a0.Controls:Disable()
                    a0.DisabledControls = true
                end
            end
        end

        local v1765 = table.unpack(v1579)
        ContextActionService:BindActionAtPriority("ModernBuildControllerActions", function(...) --[[ Upvalues: a0 (copy) ]]
            local v1764 = a0:HandleInput(...)
            return v1764
        end, false, v1522, v1765)
        a0.Following = false
        a0.UI:SetActive(true)
        a0:CancelHeldInputs()
        a0:SyncOwnership()
        a0:RefreshPresentation()
        if not Client17.EditObject and not Client17.Painting then
            a0:OpenCatalogue()
        end

        task.defer(function() --[[ Upvalues: a0 (copy) ]]
            a0:RefreshState()
        end)
        return
    end

    if a0:PickerOpen() then
        v51.ControllerClosePicker(Client17)
    end

    a0:CancelHeldInputs()
    a0.UI:CloseMenu()
    a0.Precision = false
    a0.Following = false
    a0.MenuPrimary = nil
    a0.StepsMode = nil
    a0.StepsReturn = nil
    a0.Active = false
    ContextActionService:UnbindAction("ModernBuildControllerActions")
    pcall(function() --[[ Upvalues: ContextActionService (upvalue) ]]
        ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
        ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
    end)
    Client17:EndDirectBuildDrag()
    GuiService.SelectedObject = nil
    if GamepadService.GamepadCursorEnabled then
        GamepadService:DisableGamepadCursor()
    end

    Client17.BuildGamepadNavigation = false
    GuiService.AutoSelectGuiEnabled = a0.SavedAutoSelect
    Client17.MainContext.Enabled = a0.SavedContext
    Client17.FreeMouse = a0.SavedFreeMouse
    Client17.BuildCameraLocked = a0.SavedCameraLock
    local SavedMouseIcon = a0.SavedMouseIcon
    UserInputService.MouseBehavior = a0.SavedMouseBehavior
    UserInputService.MouseIconEnabled = SavedMouseIcon
    for k367, k368 in pairs(a0.Hidden) do
        if k367.Parent then
            k367.Visible = k368
        end
    end

    a0.Hidden = {}
    a0.UI:SetActive(false)
    if Client17.Painting then
        Client17.HUD.PaintEditBar.Visible = true
        Client17.HUD.BaseObjects.Visible = false
        Client17.BuildGui.Toolbar.Visible = Client17.PaintIntegrated == true
        Client17.BuildGui.TransformPanel.Visible = false
        Client17.BuildGui.ViewPanel.Visible = true
        Client17.BuildGui.Hint.Visible = not Client17.TouchEnabled
    end

    if a0.DisabledControls then
        a0.DisabledControls = nil
        local Controls3 = a0.Controls
        if GuiService.MenuIsOpen then
            local v1769 = {}
            v1578[Controls3] = v1769
            v1769.Connection = GuiService.MenuClosed:Once(function() --[[ Upvalues: v1578 (upvalue), Controls3 (copy), v1769 (copy) ]]
                local v1770 = v1578[Controls3]
                if v1770 == v1769 then
                    v1578[Controls3] = nil
                    Controls3:Enable()
                end

            end)
        else
            Controls3:Enable()
        end
    end

    if Client17.BuildCameraActive then
        Client17:UpdateBuildGui()
        if Client17.EditObject then
            local v1771 = Client17:GetBuildObjectCFrame()
            Client17:UpdateBuildGizmo(v1771)
        end
    end
end

v1521.SetActive = SetActive2

local function Destroy3(a0)
    if a0.Destroyed then
        return
    end

    if a0.Active then
        a0:SetActive(false)
    end

    a0.Destroyed = true
    if a0.SuspendedPreview then
        local SuspendedPreview2 = a0.SuspendedPreview
        local EditExistingOriginalTransparency2 = SuspendedPreview2.EditExistingOriginalTransparency
        if not EditExistingOriginalTransparency2 then
            EditExistingOriginalTransparency2 = {}
        end

        for k369, k370 in pairs(EditExistingOriginalTransparency2) do
            if k369.Parent then
                k369.LocalTransparencyModifier = k370
            end
        end

        if SuspendedPreview2.EditObject then
            SuspendedPreview2.EditObject:Destroy()
        end

        a0.SuspendedPreview = nil
    end

    for k371, k372 in ipairs(a0.Connections) do
        k372:Disconnect()
    end

    a0.Connections = {}
    a0.UI:Destroy()
end

v1521.Destroy = Destroy3
local UI = v50.UI

local function Start(a0) --[[ Upvalues: loadCataloguePreferences (copy), v1521 (copy), ReplicatedStorage (copy), UI (copy), UserInputService (copy), GuiService (copy) ]]
    loadCataloguePreferences(a0)
    local v1779 = {
        Active = false,
        Axis = "Y",
        QuickRotateAxis = "Y",
        UndoCount = 0,
        RedoCount = 0,
        Client = a0,
        Connections = {},
        Hidden = {},
        HeldKeys = {},
        RequireRelease = {}
    }
    local v1780 = setmetatable(v1779, v1521)
    v1780.Remote = ReplicatedStorage.Remotes.RemoteEvent
    v1780.RemoteFunction = ReplicatedStorage.Remotes.RemoteFunction
    local PlayerScripts = a0.Player:FindFirstChild("PlayerScripts")
    local v1782 = PlayerScripts and PlayerScripts:FindFirstChild("PlayerModule")
    if v1782 then
        local v1784, v1785 = pcall(function() --[[ Upvalues: v1782 (copy) ]]
            local v1783 = require(v1782):GetControls()
            return v1783
        end)
        if v1784 then
            v1780.Controls = v1785
        end
    end

    local function SelectItem(a0, a1) --[[ Upvalues: v1780 (copy) ]]
        v1780:ChooseItem(a0, a1)
    end

    local function Close() --[[ Upvalues: v1780 (copy) ]]
        v1780:Back()
    end

    local function Option1(a0) --[[ Upvalues: v1780 (copy) ]]
        v1780:Option(a0)
    end

    local function Mode(a0) --[[ Upvalues: v1780 (copy) ]]
        v1780:SetPrecisionMode(a0)
    end

    local function Axis2(a0) --[[ Upvalues: v1780 (copy) ]]
        v1780:SetAxis(a0)
    end

    local function Nudge1(a0) --[[ Upvalues: v1780 (copy) ]]
        v1780:Nudge(a0)
    end

    local function Steps() --[[ Upvalues: v1780 (copy) ]]
        v1780:OpenSteps()
    end

    local function Step1(a0) --[[ Upvalues: v1780 (copy) ]]
        v1780:SetStep(a0)
    end

    local function Commit1() --[[ Upvalues: v1780 (copy) ]]
        v1780:Commit(true)
    end

    local function Color3(a0) --[[ Upvalues: v1780 (copy) ]]
        v1780:ChooseColor(a0)
    end

    local function FavoritesChanged(a0) --[[ Upvalues: v1780 (copy) ]]
        v1780:SetFavorites(a0)
    end

    local v1786 = {
        SelectItem = SelectItem,
        Close = Close,
        Option = Option1,
        Mode = Mode,
        Axis = Axis2,
        Nudge = Nudge1,
        Steps = Steps,
        Step = Step1,
        Commit = Commit1,
        Color = Color3,
        FavoritesChanged = FavoritesChanged
    }
    v1780.UI = UI.new(a0, v1786)

    local function connect(a0, a1) --[[ Upvalues: v1780 (copy) ]]
        local v1787 = a0:Connect(a1)
        table.insert(v1780.Connections, v1787)
    end

    local function syncDevice() --[[ Upvalues: v1780 (copy), UserInputService (upvalue) ]]
        local GamepadEnabled1 = UserInputService.GamepadEnabled
        if GamepadEnabled1 then
            GamepadEnabled1 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
        end

        v1780:SetActive(GamepadEnabled1)
    end

    local v1788 = UserInputService:GetPropertyChangedSignal("PreferredInput")
    local v1789 = v1788:Connect(syncDevice)
    table.insert(v1780.Connections, v1789)
    local v1790 = UserInputService.GamepadConnected:Connect(syncDevice)
    table.insert(v1780.Connections, v1790)
    local v1791 = UserInputService.GamepadDisconnected:Connect(function() --[[ Upvalues: v1780 (copy), UserInputService (upvalue) ]]
        v1780:CancelHeldInputs()
        local GamepadEnabled2 = UserInputService.GamepadEnabled
        if GamepadEnabled2 then
            GamepadEnabled2 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
        end

        v1780:SetActive(GamepadEnabled2)
    end)
    table.insert(v1780.Connections, v1791)
    local v1792 = GuiService.MenuOpened:Connect(function() --[[ Upvalues: v1780 (copy) ]]
        if v1780:IsGamepad() then
            v1780:CancelHeldInputs()
            v1780:SyncOwnership()
        end

    end)
    table.insert(v1780.Connections, v1792)
    local v1793 = GuiService.MenuClosed:Connect(function() --[[ Upvalues: v1780 (copy) ]]
        if v1780:IsGamepad() then
            v1780:CancelHeldInputs()
            v1780:SyncOwnership()
            if v1780.UI.MenuOpen then
                v1780.UI:FocusDefault()
            end
        end

    end)
    table.insert(v1780.Connections, v1793)
    local v1794 = UserInputService.WindowFocusReleased:Connect(function() --[[ Upvalues: v1780 (copy) ]]
        v1780.WindowUnfocused = true
        if v1780:IsGamepad() then
            v1780:CancelHeldInputs()
            v1780:SetFollowing(false)
        end

    end)
    table.insert(v1780.Connections, v1794)
    local v1795 = UserInputService.WindowFocused:Connect(function() --[[ Upvalues: v1780 (copy) ]]
        v1780.WindowUnfocused = false
        if v1780:IsGamepad() then
            v1780:CancelHeldInputs()
            v1780:SyncOwnership()
        end

    end)
    table.insert(v1780.Connections, v1795)
    local v1796 = UserInputService.TextBoxFocused:Connect(function() --[[ Upvalues: v1780 (copy) ]]
        if v1780:IsGamepad() then
            v1780:CancelHeldInputs()
            v1780:SyncOwnership()
        end

    end)
    table.insert(v1780.Connections, v1796)
    local v1797 = UserInputService.TextBoxFocusReleased:Connect(function() --[[ Upvalues: v1780 (copy) ]]
        if v1780:IsGamepad() then
            v1780:CancelHeldInputs()
            v1780:SyncOwnership()
        end

    end)
    table.insert(v1780.Connections, v1797)
    local v1798 = a0.Player.CharacterRemoving:Connect(function() --[[ Upvalues: v1780 (copy) ]]
        v1780:Destroy()
    end)
    table.insert(v1780.Connections, v1798)
    local GamepadEnabled3 = UserInputService.GamepadEnabled
    if GamepadEnabled3 then
        GamepadEnabled3 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
    end

    v1780:SetActive(GamepadEnabled3)
    return v1780
end

v1521.Start = Start
v50.Controller = v1521
v158 = {}
v158.__index = v158
UI = {Slow = 7, Normal = 24, Fast = 48}

local function position(a0)
    local v1799 = Vector2.new(a0.Position.X, a0.Position.Y)
    return v1799
end

local function snap(a0, a1)
    return math.round(a0 / a1) * a1
end

local function preferredTouch(a0) --[[ Upvalues: UserInputService (copy) ]]
    local TouchEnabled = UserInputService.TouchEnabled
    if TouchEnabled then
        TouchEnabled = false
        if UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad then
            TouchEnabled = true
            if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
                TouchEnabled = a0.Active
                if TouchEnabled then
                    TouchEnabled = true
                    if UserInputService:GetFocusedTextBox() == nil then
                        TouchEnabled = a0.KeyboardOwned
                    end
                end
            end
        end
    end

    return TouchEnabled
end

local function IsActive(a0)
    local v1800 = false
    if a0.Active == true then
        v1800 = not a0.Destroyed
    end

    return v1800
end

v158.IsActive = IsActive

local function ExternalBlocked1(a0) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    local Client18 = a0.Client
    local WindowUnfocused = a0.WindowUnfocused
    if not WindowUnfocused then
        local MenuIsOpen2 = GuiService.MenuIsOpen
        if not MenuIsOpen2 then
            MenuIsOpen2 = true
            if UserInputService:GetFocusedTextBox() == nil then
                MenuIsOpen2 = true
                if Client18.ColorPickerHUD == nil then
                    MenuIsOpen2 = true
                    if Client18.PaintResetConfirmOpen ~= true then
                        MenuIsOpen2 = Client18.DeleteAllConfirmOpen == true
                    end
                end
            end
        end
    end

    return WindowUnfocused
end

v158.ExternalBlocked = ExternalBlocked1

local function BlocksWorld1(a0)
    if a0:IsActive() then
        local Busy = a0.Busy
        if not Busy then
            local MenuOpen4 = a0.UI.MenuOpen
            if not MenuOpen4 then
                local v1801 = a0:ExternalBlocked()
                if v1801 then
                    -- jump to 19
                end

                -- branch continues at 19
            end

            -- branch continues at 19
        end
    end

    local v1802 = false
    return v1802
end

v158.BlocksWorld = BlocksWorld1
v158.Center = center

local function GetAimPosition(a0)
    local v1804 = a0.Aim and a0:Center() or a0.PaintPosition
    return v1804
end

v158.GetAimPosition = GetAimPosition
v158.GetPaintPosition = v158.GetAimPosition

local function CancelInputs(a0)
    a0.WorldTouch = nil
    a0.WorldStart = nil
    a0.WorldLast = nil
    a0.WorldTravel = 0
    a0.WorldTime = nil
    a0.CameraMove = Vector2.zero
    a0.CameraHeight = 0
    a0:MoveEnd(nil, true)
end

v158.CancelInputs = CancelInputs

local function SyncOwnership1(a0)
    if not a0:IsActive() then
        return
    end

    local v1805 = a0:BlocksWorld()
    if v1805 ~= a0.WasBlocked then
        a0:CancelInputs()
        a0.WasBlocked = v1805
    end

    a0.Client.MainContext.Enabled = false
    a0.Client.Player:Move(Vector3.new(0, 0, 0), false)
    if a0.Client.Humanoid then
        a0.Client.Humanoid.Jump = false
    end
end

v158.SyncOwnership = SyncOwnership1

local function Request1(a0, a1) --[[ Upvalues: invokeBuildAction (copy) ]]
    if not a0:IsActive() or a0.Busy then
        return {ok = false, reason = "Wait for the current change to finish."}
    end

    a0.Busy = true
    a0:CancelInputs()
    a0:RefreshPresentation()
    local v1806 = invokeBuildAction(nil, a1, true)
    a0.Busy = false
    if type(v1806.undo) == "number" then
        a0.UndoCount = v1806.undo
    end

    if type(v1806.redo) == "number" then
        a0.RedoCount = v1806.redo
    end

    if not v1806.ok then
        a0.Status = v1806.reason or "The change could not be saved."
    end

    if not a0.Destroyed then
        a0:RefreshPresentation()
    end

    return v1806
end

v158.Request = Request1

local function ValidatePreview(a0, a1)
    local Client19 = a0.Client
    if not Client19.EditObject then
        return false, "Choose an object first."
    end

    local v1807 = os.clock()
    if not a1 and a0.ValidatedObject == Client19.EditObject and a0.ValidatedPosition == Client19.BuildObjectPosition and a0.ValidatedRotation == Client19.BuildObjectRotation then
        local v1808 = v1807 - (a0.ValidatedAt or 0)
        if v1808 < 0.2 then
            return Client19.BuildPlacementValid, Client19.BuildInvalidReason
        end
    end

    local v1809, v1810 = Client19:ValidateBuildObject()
    a0.ValidatedObject = Client19.EditObject
    a0.ValidatedPosition = Client19.BuildObjectPosition
    a0.ValidatedRotation = Client19.BuildObjectRotation
    a0.ValidatedAt = v1807
    Client19.BuildPlacementValid = v1809
    Client19.BuildInvalidReason = v1810
    Client19.BuildTransformDirty = false
    v1807 = Client19.EditObject:FindFirstChildOfClass("Highlight")
    if v1807 then
        local v1812
        if not (v1809 and Color3.fromRGB(255, 226, 137)) then
            local v1813 = Color3.fromRGB(255, 105, 105)
        end

        v1807.FillColor = v1812
        v1807.OutlineColor = v1807.FillColor
    end

    return v1809, v1810
end

v158.ValidatePreview = ValidatePreview

local function RememberObject1(a0, a1) --[[ Upvalues: rememberObject (copy), ReplicatedStorage (copy) ]]
    rememberObject(a0.Client, ReplicatedStorage.Remotes.RemoteEvent, a1)
end

v158.RememberObject = RememberObject1

local function SaveFavorites(a0, a1) --[[ Upvalues: saveFavorites (copy), ReplicatedStorage (copy) ]]
    saveFavorites(a0.Client, ReplicatedStorage.Remotes.RemoteEvent, a1)
end

v158.SaveFavorites = SaveFavorites

local function NotifySelected1(a0, a1, a2)
    if not a0:IsActive() then
        return
    end

    a0:CancelInputs()
    a0.Client:SetDeletingObjects(false)
    a0.Tool = "Move"
    a0.Status = nil
    a0.DuplicateOf = nil
    a0.Client.BuildTransformMode = "Move"
    a0.LastObjectType = a2
    a0.SelectedPosition = a0.Client.BuildObjectPosition
    a0.SelectedRotation = a0.Client.BuildObjectRotation
    a0:RememberObject(a1)
    a0:ValidatePreview()
    a0:RefreshPresentation()
end

v158.NotifySelected = NotifySelected1

local function ChooseItem1(a0, a1, a2) --[[ Upvalues: v1 (copy), v51 (copy) ]]
    if not (a0:IsActive() and not a0.Busy and v1[a1]) then
        return
    end

    if a0.Client.Painting then
        v51.Close(a0.Client)
    end

    a0.UI:CloseMenu()
    local v1815 = a2 or v1[a1].Type
    a0.Client:SelectEditObject(a1, v1815)
    a0:NotifySelected(a1, a2)
    a0:RefreshPresentation()
end

v158.ChooseItem = ChooseItem1

local function WorldBegin(a0, a1, a2)
    if not a0:IsActive() or a1.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    if a2 or a0:BlocksWorld() or a0.WorldTouch or a0.Drag then
        return
    end

    local v1816 = Vector2.new(a1.Position.X, a1.Position.Y)
    local v1817 = a0.Client.Player.PlayerGui:GetGuiObjectsAtPosition(v1816.X, v1816.Y)
    for k373, k374 in ipairs(v1817) do
        if a0.UI:Owns(k374) then
            return
        end
    end

    a0.WorldTouch = a1
    a0.WorldStart = v1816
    a0.WorldLast = v1816
    a0.WorldTravel = 0
    a0.WorldTime = os.clock()
end

v158.WorldBegin = WorldBegin

local function WorldChanged(a0, a1)
    if a1 ~= a0.WorldTouch then
        return
    end

    if a0:BlocksWorld() then
        a0:CancelInputs()
        return
    end

    local v1821 = Vector2.new(a1.Position.X, a1.Position.Y)
    local v1822 = v1821 - a0.WorldLast
    a0.WorldLast = v1821
    a0.WorldTravel = math.max(a0.WorldTravel, (v1821 - a0.WorldStart).Magnitude)
    if a0.WorldTravel < 9 then
        return
    end

    v1821 = a0.Client
    v1821.BuildViewPreset = nil
    local v1823 = v1821.BuildCameraYaw or 0
    v1821.BuildCameraYaw = v1823 - v1822.X * 0.005
    local v1824 = v1821.BuildCameraPitch or 0
    v1823 = v1824 - v1822.Y * 0.005
    v1821.BuildCameraPitch = math.clamp(v1823, -1.5533430342749532, 1.3089969389957472)
    a0.Status = nil
end

v158.WorldChanged = WorldChanged

local function WorldEnd(a0, a1) --[[ Upvalues: GuiService (copy), v51 (copy), v1 (copy) ]]
    if a1 ~= a0.WorldTouch then
        return
    end

    local v1825 = Vector2.new(a1.Position.X, a1.Position.Y)
    local v1826 = not a0:BlocksWorld()
    if v1826 then
        v1826 = false
        if a0.WorldTravel < 9 then
            v1826 = false
            if (v1825 - a0.WorldStart).Magnitude < 9 then
                local v1827 = os.clock() - a0.WorldTime
                v1826 = v1827 < 0.45
            end
        end
    end

    a0.WorldTouch = nil
    a0.WorldStart = nil
    a0.WorldLast = nil
    if not v1826 then
        return
    end

    v1826 = v1825 - GuiService:GetInsetArea(Enum.ScreenInsets.DeviceSafeInsets).Min
    v1825 = a0.Client
    if v1825.Painting then
        a0.PaintPosition = v1826
        v51.MobileHover(v1825, v1826)
        local v1828
        if v1825.ModernPaintTarget then
            v1828 = "Target selected \194\183 tap Paint to apply"
        else
            v1828 = "Tap a paintable surface"
        end

        a0.Status = v1828
    else
        if v1825.DeletingObjects then
            local v1829 = v1825:GetPlacedBuildObjectAtScreenPosition(v1826)
            a0:Delete(v1829)
        else
            if not v1825.EditObject then
                local v1830 = v1825:GetPlacedBuildObjectAtScreenPosition(v1826)
                if v1830 then
                    if v1825:SelectPlacedBuildObject(v1830) then
                        a0:NotifySelected(v1830.Name, v1[v1830.Name].Type)
                        -- branch continues at 136
                    end

                    -- branch continues at 136
                end
            else
                a0.Status = "Use Move to adjust, or Apply / Cancel before selecting another object"
            end
        end
    end

    a0:RefreshPresentation()
end

v158.WorldEnd = WorldEnd

local function MoveBegin(a0, a1)
    if not a0:IsActive() or a0:BlocksWorld() or not a0.Client.EditObject or a0.Client.Painting then
        return
    end

    a0.WorldTouch = nil
    local Client20 = a0.Client
    local CurrentCamera2 = workspace.CurrentCamera
    local v1831 = CurrentCamera2:WorldToViewportPoint(Client20:GetBuildObjectCFrame().Position)
    local v1832 = math.max(v1831.Z, 2)
    local v1833 = {
        input = a1,
        start = Vector2.new(a1.Position.X, a1.Position.Y),
        position = Client20.BuildObjectPosition,
        rotation = Client20.BuildObjectRotation,
        projected = Vector2.new(v1831.X, v1831.Y)
    }
    local v1834 = v1832 * 2 * math.tan(math.rad(CurrentCamera2.FieldOfView / 2))
    v1833.scale = v1834 / math.max(CurrentCamera2.ViewportSize.Y, 1)
    v1833.yaw = Client20.BuildCameraYaw or 0
    v1833.tool = a0.Tool
    v1833.camera = CurrentCamera2.CFrame
    a0.Drag = v1833
    a0.Status = nil
end

v158.MoveBegin = MoveBegin

local function MoveChanged(a0, a1)
    local Drag = a0.Drag
    local Client21 = a0.Client
    if not Drag or Drag.input ~= a1 or not Client21.EditObject or a0:BlocksWorld() then
        return
    end

    local v1835 = Vector2.new(a1.Position.X, a1.Position.Y)
    local v1836 = v1835 - Drag.start
    local v1837 = Client21:GetBuildReference()
    if not v1837 then
        return
    end

    local position1 = Drag.position
    if Drag.tool == "Rotate" then
        local v1838 = v1836.X * 0.5
        if a0.Snap then
            local v1839 = Client21.BuildRotateStep or 15
            v1838 = math.round(v1838 / v1839) * v1839
        end

        local Axis3 = a0.Axis
        local rotation = Drag.rotation
        local v1840 = math.rad(v1838)
        local v1847 = CFrame.Angles(Axis3 == "X" and v1840 or 0, Axis3 == "Y" and v1840 or 0, Axis3 == "Z" and v1840 or 0)
        local v1848 = math.rad(rotation.X)
        local v1849 = math.rad(rotation.Y)
        local v1850, v1851, v1852 = (v1847 * CFrame.Angles(v1848, v1849, math.rad(rotation.Z))):ToEulerAnglesXYZ()
        local v1853 = math.deg(v1850)
        local v1854 = math.deg(v1851)
        Client21.BuildObjectRotation = Vector3.new(v1853, v1854, math.deg(v1852))
    else
        if Drag.tool == "Height" then
            local v1855 = -v1836.Y
            local v1856 = v1855 * Drag.scale
            if a0.Snap then
                local v1857 = Client21.BuildMoveStep or 0.5
                v1856 = math.round(v1856 / v1857) * v1857
            end

            position1 = position1 + Vector3.new(0, v1856, 0)
        else
            local v1858 = CFrame.Angles(0, Drag.yaw, 0)
            local v1859 = v1858.RightVector * v1836.X
            local v1860 = v1859 - v1858.LookVector * v1836.Y
            position1 = position1 + v1860 * Drag.scale
            if not a0.HeightLock then
                local v1862 = Client21:GetBuildSurfaceHit(Drag.projected + v1836)
                if v1862 then
                    local v1863 = Client21:GetBuildObjectCFrame()
                    local v1864, v1865 = Client21.EditObject:GetBoundingBox()
                    local Unit1 = v1862.Normal.Unit
                    local v1866 = v1865 / 2
                    local v1867 = math.abs(Unit1:Dot(v1864.RightVector))
                    local v1868 = v1867 * v1866.X
                    local v1869 = math.abs(Unit1:Dot(v1864.UpVector))
                    local v1870 = v1868 + v1869 * v1866.Y
                    local v1871 = math.abs(Unit1:Dot(v1864.LookVector))
                    v1865 = v1870 + v1871 * v1866.Z
                    local v1872 = v1862.Position + Unit1 * (v1865 + 0.02)
                    local v1873 = v1872 + v1863.Position
                    position1 = v1837.CFrame:PointToObjectSpace(v1873 - v1864.Position)
                end
            end

            if a0.Snap then
                local v1874 = Client21.BuildMoveStep or 0.5
                local v1875 = math.round(position1.X / v1874) * v1874
                position1 = Vector3.new(v1875, a0.HeightLock and Drag.position.Y or position1.Y, math.round(position1.Z / v1874) * v1874)
            end
        end
    end

    Client21.BuildObjectPosition = Client21:GetClampedBuildPosition(position1, Client21.BuildObjectRotation)
    a0:ValidatePreview()
    a0:RefreshPresentation()
end

v158.MoveChanged = MoveChanged

local function MoveEnd(a0, a1, a2)
    local Drag1 = a0.Drag
    if not Drag1 then
        return
    end

    if a1 then
        if Drag1.input ~= a1 then
            return
        end
    end

    a0.Drag = nil
    if a0.Client.EditObject then
        a0:ValidatePreview()
    end
end

v158.MoveEnd = MoveEnd

local function Commit2(a0) --[[ Upvalues: v51 (copy) ]]
    local Client22 = a0.Client
    if Client22.Painting then
        local MobileApply = v51.MobileApply
        local v1878 = a0.Aim and a0:Center() or nil
        local v1879 = MobileApply(Client22, v1878)
        if v1879 then
            local v1880
            if v1879.ok then
                if Client22.PaintMode == "ColorDropper" then
                    v1880 = "Color sampled"
                else
                    v1880 = "Paint applied \194\183 Undo available"
                end

                a0.Status = v1880
                -- branch continues at 37
            end
        else
            if v1879 then
                a0.Status = v1879.reason
            end
        end

        a0:RefreshPresentation()
        return
    end

    local v1881, v1882 = a0:ValidatePreview(true)
    if not v1881 then
        a0.Status = v1882
        a0:RefreshPresentation()
        return
    end

    local EditingExistingObject2 = Client22.EditingExistingObject
    local EditObject3 = Client22.EditObject
    local v1883 = {}
    local v1884
    if EditingExistingObject2 then
        v1884 = "Move"
    else
        v1884 = "Place"
    end

    v1883.action = v1884
    v1883.name = EditObject3.Name
    v1883.cframe = Client22:GetBuildObjectCFrame()
    v1883.object = EditingExistingObject2
    v1883.duplicateOf = a0.DuplicateOf
    v1882 = a0:Request(v1883)
    if a0.Destroyed then
        return
    end

    if v1882.ok then
        if EditingExistingObject2 then
            Client22:DeleteEditObject()
            a0.Status = "Move saved \194\183 Undo available"
        else
            v1883 = Client22.BuildMoveStep or 0.5
            Client22.BuildObjectPosition = Client22.BuildObjectPosition + Vector3.new(v1883, 0, 0)
            Client22.BuildObjectPosition = Client22:GetClampedBuildPosition(Client22.BuildObjectPosition, Client22.BuildObjectRotation)
            a0:ValidatePreview()
            a0.Status = "Placed \194\183 move the next copy, or Cancel"
        end
    end

    a0:RefreshPresentation()
end

v158.Commit = Commit2

local function Delete1(a0, a1)
    local Client23 = a0.Client
    if not a1 then
        local v1885
        if Client23.DeletingObjects then
            v1885 = "Tap a placed object to delete it"
        else
            v1885 = "Tap an existing object to select it first"
        end

        a0.Status = v1885
        return
    end

    local EditObject4 = Client23.EditObject
    local v1886 = {action = "Delete", object = a1}
    local v1887 = a0:Request(v1886)
    if v1887.ok then
        if not a0.Destroyed then
            if Client23.EditObject == EditObject4 and Client23.EditingExistingObject == a1 then
                Client23:DeleteEditObject()
            end

            local v1888
            if Client23.DeletingObjects then
                v1888 = "Deleted \194\183 tap another object, or Undo."
            else
                v1888 = "Object deleted \194\183 Undo available"
            end

            a0.Status = v1888
        end
    end

    return v1887
end

v158.Delete = Delete1

local function Duplicate(a0) --[[ Upvalues: copyColors (copy) ]]
    local Client24 = a0.Client
    if not Client24.EditObject or Client24.Painting then
        a0.Status = "Select an object to duplicate"
        return
    end

    local Name3 = Client24.EditObject.Name
    local ObjectType = Client24.ObjectType
    local BuildObjectPosition = Client24.BuildObjectPosition
    local BuildObjectRotation = Client24.BuildObjectRotation
    local v1889 = Client24.EditingExistingObject or a0.DuplicateOf
    local v1890 = Client24.EditObject:Clone()
    Client24:SelectEditObject(Name3, ObjectType)
    if Client24.EditObject then
        copyColors(v1890, Client24.EditObject)
        local v1891 = Client24.BuildMoveStep or 0.5
        Client24.BuildObjectPosition = BuildObjectPosition + Vector3.new(v1891, 0, 0)
        Client24.BuildObjectRotation = BuildObjectRotation
        a0.DuplicateOf = v1889
        a0:ValidatePreview()
        a0.Status = "Duplicate preview \194\183 Apply purchases a new copy"
    end

    v1890:Destroy()
end

v158.Duplicate = Duplicate

local function History1(a0, a1) --[[ Upvalues: v51 (copy) ]]
    local Client25 = a0.Client
    local v1892 = {action = a1}
    if a0:Request(v1892).ok then
        if not a0.Destroyed then
            if Client25.EditingExistingObject then
                Client25:DeleteEditObject()
            end

            if a0.SuspendedPreview and a0.SuspendedPreview.EditingExistingObject then
                a0:DiscardSuspended()
            end

            local v1893
            if a1 == "Undo" then
                v1893 = "Change undone"
            else
                v1893 = "Change redone"
            end

            a0.Status = v1893
            if Client25.Painting and v51.MobileRefresh then
                v51.MobileRefresh(Client25)
            end

            a0:RefreshPresentation()
        end
    end
end

v158.History = History1

local function RememberColor(a0, a1)
    if typeof(a1) ~= "Color3" then
        return
    end

    local ModernPaintColors1 = a0.Client.ModernPaintColors
    if not ModernPaintColors1 then
        ModernPaintColors1 = {}
    end

    a0.Client.ModernPaintColors = ModernPaintColors1
    for i7 = #ModernPaintColors1, 1, -1 do
        if ModernPaintColors1[i7] == a1 then
            table.remove(ModernPaintColors1, i7)
        end
    end

    table.insert(ModernPaintColors1, 1, a1)
    while 12 < #ModernPaintColors1 do
        table.remove(ModernPaintColors1)
    end
end

v158.RememberColor = RememberColor

local function ChooseColor1(a0, a1) --[[ Upvalues: v51 (copy) ]]
    if not (typeof(a1) == "Color3" and a0.Client.Painting) then
        return
    end

    v51.ControllerSetColor(a0.Client, a1)
    a0:RememberColor(a1)
    if v51.MobileRefresh then
        v51.MobileRefresh(a0.Client)
    end

    a0:RefreshPresentation()
end

v158.ChooseColor = ChooseColor1

local function Action(a0, a1) --[[ Upvalues: v51 (copy) ]]
    if not a0:IsActive() or a0.Busy or a0:ExternalBlocked() then
        return
    end

    local Client26 = a0.Client
    if a1 == "apply" then
        a0:Commit()
    else
        if a1 == "cancel" then
            if Client26.Painting then
                a0.PaintPosition = nil
                v51.MobileHover(Client26, nil)
            else
                a0:CancelInputs()
                Client26:SetDeletingObjects(false)
                Client26:DeleteEditObject()
                a0.DuplicateOf = nil
            end

            a0.Status = nil
        else
            if a1 == "build" then
                Client26:SetDeletingObjects(false)
                if Client26.Painting then
                    v51.Close(Client26)
                end

                a0.Status = nil
            else
                if a1 == "paint" then
                    Client26:SetDeletingObjects(false)
                    if not Client26.Painting then
                        v51.Open(Client26)
                        -- branch continues at 355
                    end
                else
                    if a1 == "deleteMode" then
                        if Client26.Painting then
                            return
                        end

                        a0:CancelInputs()
                        a0.UI:CloseMenu()
                        Client26:SetDeletingObjects(not Client26.DeletingObjects)
                        a0.DuplicateOf = nil
                        a0.Status = nil
                    else
                        if a1 == "classic" then
                            a0:CancelInputs()
                            a0.UI:CloseMenu()
                            if Client26.Painting then
                                v51.Close(Client26)
                            end

                            if Client26.BuildCameraActive then
                                Client26:SetBuildSystem("Classic", true)
                                return
                            end

                            if Client26:SetBuildSystem("Classic") then
                                Client26:EditStorage()
                            end

                            return
                        end

                        if a1 == "move" or a1 == "height" or a1 == "rotate" then
                            a0:MoveEnd(nil, true)
                            local v1896
                            if a1 == "move" then
                                v1896 = "Move"
                            else
                                if a1 == "height" then
                                    v1896 = "Height"
                                else
                                    v1896 = "Rotate"
                                end
                            end

                            a0.Tool = v1896
                            if a0.Tool == "Rotate" then
                                v1896 = "Rotate"
                            else
                                v1896 = "Move"
                            end

                            Client26.BuildTransformMode = v1896
                            -- jump to 355 (out of range)
                        end

                        if a1 == "duplicate" then
                            a0:Duplicate()
                        else
                            if a1 == "delete" then
                                a0:Delete(Client26.EditingExistingObject)
                            else
                                if a1 == "undo" then
                                    a0:History("Undo")
                                else
                                    if a1 == "redo" then
                                        a0:History("Redo")
                                    else
                                        if a1 == "done" then
                                            if Client26.EditingBase then
                                                Client26:StopEditStorage()
                                                return
                                            end

                                            if Client26.Painting then
                                                Client26:ClosePaintFrames()
                                                return
                                            end

                                            Client26:EndBuildMode()
                                            return
                                        end

                                        if a1 == "brush" or a1 == "bucket" or a1 == "dropper" then
                                            local v1897
                                            if a1 == "brush" then
                                                v1897 = "PaintBrush"
                                            else
                                                if a1 == "bucket" then
                                                    v1897 = "PaintBucket"
                                                else
                                                    v1897 = "ColorDropper"
                                                end
                                            end

                                            v51.ControllerTool(Client26, v1897)
                                            if v51.MobileRefresh then
                                                v51.MobileRefresh(Client26)
                                                -- jump to 355 (out of range)
                                                -- branch continues at 355
                                            end
                                        end

                                        if a1 == "rotateLeft" or a1 == "rotateRight" then
                                            local v1898
                                            if a1 == "rotateLeft" then
                                                v1898 = -1
                                            else
                                                v1898 = 1
                                            end

                                            a0:Rotate(v1898)
                                            -- jump to 355 (out of range)
                                        end

                                        if a1 == "heightUp" or a1 == "heightDown" then
                                            if Client26.EditObject then
                                                local BuildObjectPosition1 = Client26.BuildObjectPosition
                                                local v1899 = Client26.BuildMoveStep or 0.5
                                                local v1900
                                                if a1 == "heightUp" then
                                                    v1900 = 1
                                                else
                                                    v1900 = -1
                                                end

                                                local v1901 = v1899 * v1900
                                                Client26.BuildObjectPosition = BuildObjectPosition1 + Vector3.new(0, v1901, 0)
                                                Client26:ClampBuildObjectToBounds()
                                                a0:ValidatePreview()
                                                a0.Status = nil
                                                -- jump to 355 (out of range)
                                                -- branch continues at 355
                                            end
                                        end

                                        if a1 == "focus" then
                                            a0:FocusObject()
                                        else
                                            if a1 == "reset" then
                                                Client26:SetBuildView("Iso")
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
    end

    a0:RefreshPresentation()
end

v158.Action = Action

local function Rotate(a0, a1)
    local Client27 = a0.Client
    if not Client27.EditObject then
        a0.Status = "Choose an object to rotate"
        return
    end

    local BuildObjectRotation1 = Client27.BuildObjectRotation
    local v1902 = math.rad((Client27.BuildRotateStep or 90) * a1)
    local v1910 = CFrame.Angles((a0.Tool == "Rotate" and a0.Axis or "Y") == "X" and v1902 or 0, (a0.Tool == "Rotate" and a0.Axis or "Y") == "Y" and v1902 or 0, (a0.Tool == "Rotate" and a0.Axis or "Y") == "Z" and v1902 or 0)
    local v1911 = math.rad(BuildObjectRotation1.X)
    local v1912 = math.rad(BuildObjectRotation1.Y)
    local v1913, v1914, v1915 = (v1910 * CFrame.Angles(v1911, v1912, math.rad(BuildObjectRotation1.Z))):ToEulerAnglesXYZ()
    local v1916 = math.deg(v1913)
    local v1917 = math.deg(v1914)
    Client27.BuildObjectRotation = Vector3.new(v1916, v1917, math.deg(v1915))
    Client27:ClampBuildObjectToBounds()
    a0:ValidatePreview()
    a0.Status = nil
end

v158.Rotate = Rotate

local function FocusObject(a0)
    local Client28 = a0.Client
    if not Client28.EditObject then
        a0.Status = "Select an object to focus"
        return
    end

    local v1918, v1919 = Client28.EditObject:GetBoundingBox()
    local v1920 = v1919.Magnitude * 1.5
    local v1921 = math.max(v1920, 8)
    Client28.BuildDistance = v1921
    Client28.BuildCameraPosition = Client28:ClampBuildCameraPosition(v1918.Position - workspace.CurrentCamera.CFrame.LookVector * v1921)
    Client28:UpdateBuildCameraCFrame()
end

v158.FocusObject = FocusObject

local function Setting(a0, a1, a2) --[[ Upvalues: v61 (copy), v157 (copy), UI (copy), v4 (copy) ]]
    if not a0:IsActive() or a0.Busy then
        return
    end

    local Client29 = a0.Client
    a0:MoveEnd(nil, true)
    if a1 == "axis" then
        if a2 ~= "X" then
            if a2 ~= "Y" then
                if a2 ~= "Z" then
                    -- jump to 28
                end
            end
        end

        a0.Axis = a2
    else
        if a1 == "moveStep" and table.find(v61, a2) then
            Client29.BuildMoveStep = a2
            Client29:RebuildBuildGrid()
        else
            if a1 == "rotateStep" and table.find(v157, a2) then
                Client29.BuildRotateStep = a2
                Client29.ModernMobileRotateStep = a2
            else
                if a1 == "snap" then
                    a0.Snap = a2 == true
                else
                    if a1 == "grid" then
                        Client29.BuildGridEnabled = a2 == true
                        Client29:RebuildBuildGrid()
                    else
                        if a1 == "heightLock" then
                            a0.HeightLock = a2 == true
                        else
                            if a1 == "aim" then
                                a0.Aim = a2 == true
                            else
                                if a1 == "cameraSpeed" and UI[a2] then
                                    a0.CameraSpeed = a2
                                else
                                    if a1 == "cameraSpeed" then
                                        if type(a2) == "number" then
                                            local v1923 = {7, 12, 24, 48, 72}
                                            local v1924
                                            if table.find(v1923, a2) then
                                                if a2 <= 12 then
                                                    v1924 = "Slow"
                                                else
                                                    if 48 <= a2 then
                                                        v1924 = "Fast"
                                                    else
                                                        v1924 = "Normal"
                                                    end
                                                end

                                                a0.CameraSpeed = v1924
                                                -- branch continues at 144
                                            end

                                            -- branch continues at 144
                                        end
                                    else
                                        if a1 == "cameraPreset" then
                                            if a2 == "Focus" then
                                                a0:FocusObject()
                                                -- jump to 271 (out of range)
                                            end

                                            if a2 == "Free" then
                                                Client29.BuildViewPreset = nil
                                                -- jump to 271 (out of range)
                                            end

                                            if a2 == "Reset" then
                                                Client29:SetBuildView("Iso")
                                                -- jump to 271 (out of range)
                                            end

                                            if a2 ~= "Top" then
                                                if a2 ~= "Front" then
                                                    if a2 ~= "Side" then
                                                        -- jump to 271
                                                    end
                                                end
                                            end

                                            local v1925
                                            if a2 == "Side" then
                                                v1925 = "Right"
                                            else
                                                v1925 = a2
                                            end

                                            Client29:SetBuildView(v1925)
                                        else
                                            if a1 == "favorites" then
                                                if type(a2) == "string" then
                                                    if v4.IsValidName(a2) then
                                                        local v1926 = table.clone(Client29.ModernBuildFavorites)
                                                        v1926[a2] = not v1926[a2] or nil
                                                        a0:SaveFavorites(v1926)
                                                        -- branch continues at 215
                                                    end

                                                    -- branch continues at 215
                                                end
                                            else
                                                if a1 == "favorites" then
                                                    if type(a2) == "table" then
                                                        a0:SaveFavorites(a2)
                                                        -- branch continues at 230
                                                    end
                                                else
                                                    if a1 == "nudge" then
                                                        if type(a2) == "table" then
                                                            if Client29.EditObject then
                                                                if a2.axis == "X" or a2.axis == "Y" or a2.axis == "Z" then
                                                                    local axis = a2.axis
                                                                    local v1927
                                                                    if a2.direction == -1 then
                                                                        v1927 = -1
                                                                    else
                                                                        v1927 = 1
                                                                    end

                                                                    Client29:NudgeBuildObject(axis, v1927)
                                                                    a0:ValidatePreview()
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
                        end
                    end
                end
            end
        end
    end

    a0.Status = nil
    a0:RefreshPresentation()
end

v158.Setting = Setting

local function SuspendPreview1(a0) --[[ Upvalues: t6 (copy) ]]
    local Client30 = a0.Client
    if not (a0:IsActive() and Client30.EditObject) then
        return false
    end

    a0:CancelInputs()
    a0.UI:CloseMenu()
    if a0.SuspendedPreview then
        a0:DiscardSuspended()
    end

    local v1928 = {DuplicateOf = a0.DuplicateOf, Tool = a0.Tool}
    for k375, k376 in ipairs(t6) do
        v1928[k376] = Client30[k376]
        Client30[k376] = nil
    end

    v1928.EditObject.Parent = nil
    local EditExistingOriginalTransparency3 = v1928.EditExistingOriginalTransparency
    if not EditExistingOriginalTransparency3 then
        EditExistingOriginalTransparency3 = {}
    end

    for k377, k378 in pairs(EditExistingOriginalTransparency3) do
        if k377.Parent then
            k377.LocalTransparencyModifier = k378
        end
    end

    Client30.Mouse.TargetFilter = nil
    Client30:HideBuildGizmos()
    a0.SuspendedPreview = v1928
    return true
end

v158.SuspendPreview = SuspendPreview1

local function ResumePreview1(a0) --[[ Upvalues: copyColors (copy), t6 (copy) ]]
    local SuspendedPreview3 = a0.SuspendedPreview
    local Client31 = a0.Client
    if not SuspendedPreview3 or Client31.BuildModeKind == "Paint" then
        return
    end

    a0.SuspendedPreview = nil
    if Client31.EditObject then
        Client31:DeleteEditObject()
    end

    if SuspendedPreview3.EditingExistingObject and not SuspendedPreview3.EditingExistingObject.Parent then
        SuspendedPreview3.EditObject:Destroy()
        return
    end

    if SuspendedPreview3.EditingExistingObject then
        copyColors(SuspendedPreview3.EditingExistingObject, SuspendedPreview3.EditObject)
    end

    for k379, k380 in ipairs(t6) do
        Client31[k380] = SuspendedPreview3[k380]
    end

    local EditExistingOriginalTransparency4 = Client31.EditExistingOriginalTransparency
    if not EditExistingOriginalTransparency4 then
        EditExistingOriginalTransparency4 = {}
    end

    for k381 in pairs(EditExistingOriginalTransparency4) do
        if k381.Parent then
            k381.LocalTransparencyModifier = 1
        end
    end

    Client31.EditObject.Parent = workspace.CurrentCamera
    Client31.Mouse.TargetFilter = Client31.EditObject
    a0.DuplicateOf = SuspendedPreview3.DuplicateOf
    a0.Tool = SuspendedPreview3.Tool or "Move"
    a0:ValidatePreview()
    a0.Status = "Object restored where you left it"
    a0.PaintPosition = nil
end

v158.ResumePreview = ResumePreview1

local function DiscardSuspended(a0)
    local SuspendedPreview4 = a0.SuspendedPreview
    if not SuspendedPreview4 then
        return
    end

    a0.SuspendedPreview = nil
    local EditExistingOriginalTransparency5 = SuspendedPreview4.EditExistingOriginalTransparency
    if not EditExistingOriginalTransparency5 then
        EditExistingOriginalTransparency5 = {}
    end

    for k382, k383 in pairs(EditExistingOriginalTransparency5) do
        if k382.Parent then
            k382.LocalTransparencyModifier = k383
        end
    end

    if SuspendedPreview4.EditObject then
        SuspendedPreview4.EditObject:Destroy()
    end
end

v158.DiscardSuspended = DiscardSuspended
v158.GetLegacyVisibility = getLegacyVisibility

local function RestoreLegacyVisibility1(a0, a1) --[[ Upvalues: restoreLegacyVisibility (copy) ]]
    if not (a0:IsActive() and a1) then
        return
    end

    restoreLegacyVisibility(a0, a1)
end

v158.RestoreLegacyVisibility = RestoreLegacyVisibility1
v158.SaveAndHide = saveAndHide

local function PresentationState1(a0) --[[ Upvalues: GuiService (copy) ]]
    local Client32 = a0.Client
    local BuildPlacementValid = Client32.BuildPlacementValid
    if Client32.Painting then
        BuildPlacementValid = Client32.ModernPaintTarget ~= nil
    end

    local v1944
    if not Client32.Painting and Client32.EditObject and BuildPlacementValid == false then
        v1944 = Client32.BuildInvalidReason or v1944
    end

    local v1945 = {}
    local v1946 = Client32.EditObject and Client32.EditObject.Name
    v1945.itemName = v1946
    v1945.existing = Client32.EditingExistingObject ~= nil
    local WindowUnfocused1 = a0.WindowUnfocused
    if not WindowUnfocused1 then
        local MenuIsOpen3 = GuiService.MenuIsOpen
        if not MenuIsOpen3 then
            MenuIsOpen3 = true
            if Client32.ColorPickerHUD == nil then
                MenuIsOpen3 = true
                if Client32.PaintResetConfirmOpen ~= true then
                    MenuIsOpen3 = Client32.DeleteAllConfirmOpen == true
                end
            end
        end
    end

    v1945.blocked = WindowUnfocused1
    if Client32.Painting then
        WindowUnfocused1 = "Paint"
    else
        WindowUnfocused1 = "Build"
    end

    v1945.mode = WindowUnfocused1
    v1945.valid = BuildPlacementValid
    v1945.deleting = Client32.DeletingObjects == true
    local v1947
    if a0.Busy then
        v1947 = "Saving\226\128\166"
    else
        v1947 = v1944
    end

    v1945.status = v1947
    v1945.tool = a0.Tool
    v1945.moveStep = Client32.BuildMoveStep or 0.5
    v1945.rotateStep = Client32.BuildRotateStep or 90
    v1945.axis = a0.Axis
    v1945.color = Client32.HUD.PaintEditBar.ColorPicker.CurrentColor.BackgroundColor3
    v1945.paintMode = Client32.PaintMode or "PaintBrush"
    v1945.undo = a0.UndoCount
    v1945.redo = a0.RedoCount
    v1945.cameraSpeed = a0.CameraSpeed
    v1945.snap = a0.Snap
    v1945.grid = Client32.BuildGridEnabled == true
    v1945.heightLock = a0.HeightLock
    v1945.aim = a0.Aim
    v1947 = Client32.ModernBuildRecents
    if not v1947 then
        v1947 = {}
    end

    v1945.recent = v1947
    v1947 = Client32.ModernPaintColors
    if not v1947 then
        v1947 = {}
    end

    v1945.recentColors = v1947
    v1947 = Client32.ModernBuildFavorites
    if not v1947 then
        v1947 = {}
    end

    v1945.favorites = v1947
    return v1945
end

v158.PresentationState = PresentationState1

local function RefreshPresentation1(a0) --[[ Upvalues: hideLegacyPresentation (copy) ]]
    if not a0:IsActive() or a0.Refreshing then
        return
    end

    a0.Refreshing = true
    hideLegacyPresentation(a0)
    local v1948 = a0:PresentationState()
    a0.UI:Update(v1948)
    a0.Refreshing = false
end

v158.RefreshPresentation = RefreshPresentation1

local function StepCamera1(a0, a1) --[[ Upvalues: UI (copy), v51 (copy) ]]
    if not a0:IsActive() then
        return false
    end

    local Client33 = a0.Client
    if not Client33.BuildCameraActive or Client33.ClassicBuildActive then
        a0:Destroy()
        return false
    end

    a0:SyncOwnership()
    local v1949, v1950 = Client33:GetBuildReference()
    if v1949 and v1950 and not a0:BlocksWorld() then
        local CameraMove = a0.CameraMove
        local v1951 = Client33.BuildCameraYaw or 0
        local v1952 = v1949.CFrame.Rotation * CFrame.Angles(0, v1951, 0)
        local v1953 = v1952.RightVector * CameraMove.X
        local v1954 = v1953 - v1952.LookVector * CameraMove.Y
        local v1955 = v1954 + v1949.CFrame.UpVector * a0.CameraHeight
        if 1 < v1955.Magnitude then
            v1955 = v1955.Unit
        end

        if 0 < v1955.Magnitude then
            Client33.BuildViewPreset = nil
            local v1956 = Client33.BuildCameraPosition or workspace.CurrentCamera.CFrame.Position
            local v1957 = v1955 * UI[a0.CameraSpeed]
            Client33.BuildCameraPosition = Client33:ClampBuildCameraPosition(v1956 + v1957 * math.clamp(a1, 0, 0.1))
        end

        Client33:UpdateBuildCameraCFrame()
        if Client33.Painting then
            if a0.Aim then
                if (a0.NextPaintAim or 0) <= os.clock() then
                    a0.NextPaintAim = os.clock() + 0.08
                    local v1958 = a0:Center()
                    v51.MobileHover(Client33, v1958)
                    -- branch continues at 304
                end

                -- branch continues at 304
            end
        else
            if Client33.EditObject then
                if a0.Aim then
                    if not Client33.EditingExistingObject then
                        if not a0.Drag then
                            local v1965 = a0:Center()
                            local v1966 = Client33:GetBuildSurfaceHit(v1965)
                            if v1966 then
                                v1952 = Client33:GetBuildObjectCFrame()
                                local v1967, v1968 = Client33.EditObject:GetBoundingBox()
                                local Unit2 = v1966.Normal.Unit
                                local v1969 = v1968 / 2
                                local v1970 = math.abs(Unit2:Dot(v1967.RightVector))
                                local v1971 = v1970 * v1969.X
                                local v1972 = math.abs(Unit2:Dot(v1967.UpVector))
                                local v1973 = v1971 + v1972 * v1969.Y
                                local v1974 = math.abs(Unit2:Dot(v1967.LookVector))
                                local v1975 = v1966.Position + Unit2 * (v1973 + v1974 * v1969.Z + 0.02)
                                v1974 = v1975 + v1952.Position
                                local v1976 = v1949.CFrame:PointToObjectSpace(v1974 - v1967.Position)
                                if a0.HeightLock then
                                    v1976 = Vector3.new(v1976.X, Client33.BuildObjectPosition.Y, v1976.Z)
                                end

                                if a0.Snap then
                                    Unit2 = Client33.BuildMoveStep or 0.5
                                    local v1977 = math.round(v1976.X / Unit2) * Unit2
                                    v1976 = Vector3.new(v1977, v1976.Y, math.round(v1976.Z / Unit2) * Unit2)
                                end

                                Client33.BuildObjectPosition = Client33:GetClampedBuildPosition(v1976, Client33.BuildObjectRotation)
                            end
                        end
                    end
                end

                a0:ValidatePreview()
            end
        end

        if Client33.BuildModeKind ~= "Paint" then
            Client33:UpdateBuildGridSurface()
        end
    end

    a0.Elapsed = (a0.Elapsed or 0) + a1
    if 0.08 <= a0.Elapsed then
        a0.Elapsed = 0
        a0:RefreshPresentation()
    end

    return true
end

v158.StepCamera = StepCamera1
local PendingControlRestores = v50.Controller.PendingControlRestores

local function SetActive3(a0, a1) --[[ Upvalues: UserInputService (copy), PendingControlRestores (copy), ReplicatedStorage (copy), GuiService (copy) ]]
    local Client34 = a0.Client
    local v1978 = false
    if a1 == true then
        v1978 = false
        if Client34.BuildCameraActive == true then
            v1978 = not Client34.ClassicBuildActive
        end
    end

    a1 = v1978
    if a0.Destroyed or a1 == a0.Active then
        return
    end

    local v1979
    if a1 then
        if Client34.ModernController and Client34.ModernController:IsGamepad() then
            Client34.ModernController:SetActive(false)
        end

        a0.Active = true
        a0.SavedRotateStep = Client34.BuildRotateStep
        Client34.BuildRotateStep = Client34.ModernMobileRotateStep or 90
        a0.SavedContext = Client34.MainContext.Enabled
        a0.SavedFreeMouse = Client34.FreeMouse
        a0.SavedCameraLock = Client34.BuildCameraLocked
        a0.SavedMouseBehavior = UserInputService.MouseBehavior
        a0.SavedMouseIcon = UserInputService.MouseIconEnabled
        Client34.MainContext.Enabled = false
        Client34.FreeMouse = false
        Client34.BuildCameraLocked = false
        Client34:EndBuildTouchGizmoDrag()
        Client34:EndBuildTransformHold()
        Client34:EndDirectBuildDrag()
        Client34:EndBuildMouseCameraDrag()
        Client34:ClearBuildMobileCameraInputs()
        Client34:SetDeletingObjects(false)
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
        if a0.Controls then
            local v1980 = PendingControlRestores[a0.Controls]
            if v1980 then
                v1980.Connection:Disconnect()
                PendingControlRestores[a0.Controls] = nil
                a0.DisabledControls = true
            else
                if a0.Controls.controlsEnabled ~= false then
                    a0.Controls:Disable()
                    a0.DisabledControls = true
                end
            end
        end

        v1979 = "M2U"
        local v1981 = {"M1U", v1979, "BlockOff", "RunOff"}
        for k384, k385 in ipairs(v1981) do
            ReplicatedStorage.Remotes.RemoteEvent:FireServer(k385)
        end

        a0:CancelInputs()
        a0.UI:SetActive(true)
        a0:SyncOwnership()
        a0:RefreshPresentation()
        task.defer(function() --[[ Upvalues: a0 (copy) ]]
            if a0:IsActive() then
                a0:Request({action = "State"})
            end

        end)
        return
    end

    a0:CancelInputs()
    a0.UI:CloseMenu()
    a0.Active = false
    a0.UI:SetActive(false)
    Client34:SetDeletingObjects(false)
    Client34.BuildRotateStep = a0.SavedRotateStep
    Client34.MainContext.Enabled = a0.SavedContext
    Client34.FreeMouse = a0.SavedFreeMouse
    Client34.BuildCameraLocked = a0.SavedCameraLock
    local SavedMouseIcon1 = a0.SavedMouseIcon
    UserInputService.MouseBehavior = a0.SavedMouseBehavior
    UserInputService.MouseIconEnabled = SavedMouseIcon1
    for k386, k387 in pairs(a0.Hidden) do
        if k386.Parent then
            k386.Visible = k387
        end
    end

    a0.Hidden = {}
    if a0.DisabledControls then
        a0.DisabledControls = nil
        local Controls4 = a0.Controls
        if Client34.ModernController and Client34.ModernController:IsGamepad() then
            Client34.ModernController.DisabledControls = true
        else
            if GuiService.MenuIsOpen then
                local MenuIsOpen4 = GuiService.MenuIsOpen
                MenuIsOpen4 = {Connection = GuiService.MenuClosed:Once(function() --[[ Upvalues: PendingControlRestores (upvalue), Controls4 (copy), MenuIsOpen4 (copy) ]]
                    local v1988 = PendingControlRestores[Controls4]
                    if v1988 == MenuIsOpen4 then
                        PendingControlRestores[Controls4] = nil
                        Controls4:Enable()
                    end

                end)}
                PendingControlRestores[Controls4] = MenuIsOpen4
            else
                Controls4:Enable()
            end
        end
    end

    if Client34.BuildCameraActive then
        Client34:UpdateBuildGui()
    end

    if Client34.ModernController and Client34.ModernController:IsGamepad() then
        Client34.MainContext.Enabled = false
        Client34.ModernController:RefreshPresentation()
    end
end

v158.SetActive = SetActive3

local function Destroy4(a0)
    if a0.Destroyed then
        return
    end

    if a0.Active then
        a0:SetActive(false)
    end

    a0.Destroyed = true
    a0:DiscardSuspended()
    for k388, k389 in ipairs(a0.Connections) do
        k389:Disconnect()
    end

    a0.UI:Destroy()
end

v158.Destroy = Destroy4
local MobileUI = v50.MobileUI

local function Start1(a0) --[[ Upvalues: loadCataloguePreferences (copy), v158 (copy), MobileUI (copy), UserInputService (copy), GuiService (copy) ]]
    loadCataloguePreferences(a0)
    local v1992 = {
        Active = false,
        Tool = "Move",
        Axis = "Y",
        CameraHeight = 0,
        CameraSpeed = "Normal",
        HeightLock = true,
        Snap = true,
        Aim = false,
        UndoCount = 0,
        RedoCount = 0,
        Client = a0,
        Connections = {},
        Hidden = {},
        CameraMove = Vector2.zero
    }
    local v1993 = setmetatable(v1992, v158)
    a0.ModernMobile = v1993
    local PlayerScripts1 = a0.Player:FindFirstChild("PlayerScripts")
    local v1995 = PlayerScripts1 and PlayerScripts1:FindFirstChild("PlayerModule")
    if v1995 then
        local v1997, v1998 = pcall(function() --[[ Upvalues: v1995 (copy) ]]
            local v1996 = require(v1995):GetControls()
            return v1996
        end)
        if v1997 then
            v1993.Controls = v1998
        end
    end

    local function Action1(a0) --[[ Upvalues: v1993 (copy) ]]
        v1993:Action(a0)
    end

    local function SelectItem1(a0, a1) --[[ Upvalues: v1993 (copy) ]]
        v1993:ChooseItem(a0, a1)
    end

    local function Setting1(a0, a1) --[[ Upvalues: v1993 (copy) ]]
        v1993:Setting(a0, a1)
    end

    local function CameraMove1(a0) --[[ Upvalues: v1993 (copy) ]]
        if v1993:IsActive() and not v1993:BlocksWorld() then
            v1993.CameraMove = a0
        end
    end

    local function CameraHeight(a0) --[[ Upvalues: v1993 (copy) ]]
        if v1993:IsActive() and not v1993:BlocksWorld() then
            v1993.CameraHeight = a0
        end
    end

    local function MoveBegin1(a0) --[[ Upvalues: v1993 (copy) ]]
        v1993:MoveBegin(a0)
    end

    local function MoveChanged1(a0) --[[ Upvalues: v1993 (copy) ]]
        v1993:MoveChanged(a0)
    end

    local function MoveEnd1(a0, a1) --[[ Upvalues: v1993 (copy) ]]
        v1993:MoveEnd(a0, a1)
    end

    local function PickColor(a0) --[[ Upvalues: v1993 (copy) ]]
        v1993:ChooseColor(a0)
    end

    local function Close1() --[[ Upvalues: v1993 (copy) ]]
        v1993.UI:CloseMenu()
        v1993:CancelInputs()
        v1993:RefreshPresentation()
    end

    local v1999 = {
        Action = Action1,
        SelectItem = SelectItem1,
        Setting = Setting1,
        CameraMove = CameraMove1,
        CameraHeight = CameraHeight,
        MoveBegin = MoveBegin1,
        MoveChanged = MoveChanged1,
        MoveEnd = MoveEnd1,
        PickColor = PickColor,
        Close = Close1
    }
    v1993.UI = MobileUI.new(a0, v1999)

    local function connect1(a0, a1) --[[ Upvalues: v1993 (copy) ]]
        local v2000 = a0:Connect(a1)
        table.insert(v1993.Connections, v2000)
    end

    local v2003 = UserInputService.InputBegan:Connect(function(a0, a1) --[[ Upvalues: v1993 (copy), UserInputService (upvalue) ]]
        if v1993:IsActive() then
            if v1993.KeyboardOwned then
                if not UserInputService:GetFocusedTextBox() then
                    if a0.UserInputType == Enum.UserInputType.MouseButton1 or a0.UserInputType == Enum.UserInputType.MouseButton2 then
                        v1993.KeyboardOwned = false
                        local v2001 = v1993
                        local v2002 = v1993
                        local TouchEnabled1 = UserInputService.TouchEnabled
                        if TouchEnabled1 then
                            TouchEnabled1 = false
                            if UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad then
                                TouchEnabled1 = true
                                if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
                                    TouchEnabled1 = v2002.Active
                                    if TouchEnabled1 then
                                        TouchEnabled1 = true
                                        if UserInputService:GetFocusedTextBox() == nil then
                                            TouchEnabled1 = v2002.KeyboardOwned
                                        end
                                    end
                                end
                            end
                        end

                        v2001:SetActive(TouchEnabled1)
                    end
                end
            end
        end

        if v1993:IsActive() then
            if a0.KeyCode == Enum.KeyCode.Escape then
                if not UserInputService:GetFocusedTextBox() then
                    if v1993.UI.MenuOpen then
                        v1993.UI:CloseMenu()
                    else
                        v1993:Action("cancel")
                    end
                end
            end
        end

        v1993:WorldBegin(a0, a1)
    end)
    table.insert(v1993.Connections, v2003)
    local v2004 = UserInputService.InputChanged:Connect(function(a0) --[[ Upvalues: v1993 (copy) ]]
        v1993:WorldChanged(a0)
    end)
    table.insert(v1993.Connections, v2004)
    local v2005 = UserInputService.InputEnded:Connect(function(a0) --[[ Upvalues: v1993 (copy) ]]
        v1993:WorldEnd(a0)
    end)
    table.insert(v1993.Connections, v2005)
    local v2006 = UserInputService:GetPropertyChangedSignal("PreferredInput")
    local v2009 = v2006:Connect(function() --[[ Upvalues: v1993 (copy), UserInputService (upvalue) ]]
        local v2007 = v1993
        local v2008 = v1993
        local TouchEnabled2 = UserInputService.TouchEnabled
        if TouchEnabled2 then
            TouchEnabled2 = false
            if UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad then
                TouchEnabled2 = true
                if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
                    TouchEnabled2 = v2008.Active
                    if TouchEnabled2 then
                        TouchEnabled2 = true
                        if UserInputService:GetFocusedTextBox() == nil then
                            TouchEnabled2 = v2008.KeyboardOwned
                        end
                    end
                end
            end
        end

        v2007:SetActive(TouchEnabled2)
    end)
    table.insert(v1993.Connections, v2009)
    local v2010 = UserInputService.TextBoxFocused:Connect(function() --[[ Upvalues: v1993 (copy) ]]
        v1993.KeyboardOwned = v1993:IsActive()
        v1993:CancelInputs()
    end)
    table.insert(v1993.Connections, v2010)
    local v2013 = UserInputService.TextBoxFocusReleased:Connect(function() --[[ Upvalues: v1993 (copy), UserInputService (upvalue) ]]
        task.defer(function() --[[ Upvalues: v1993 (upvalue), UserInputService (upvalue) ]]
            if not v1993.Destroyed then
                local v2011 = v1993
                local v2012 = v1993
                local TouchEnabled3 = UserInputService.TouchEnabled
                if TouchEnabled3 then
                    TouchEnabled3 = false
                    if UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad then
                        TouchEnabled3 = true
                        if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
                            TouchEnabled3 = v2012.Active
                            if TouchEnabled3 then
                                TouchEnabled3 = true
                                if UserInputService:GetFocusedTextBox() == nil then
                                    TouchEnabled3 = v2012.KeyboardOwned
                                end
                            end
                        end
                    end
                end

                v2011:SetActive(TouchEnabled3)
            end

        end)
    end)
    table.insert(v1993.Connections, v2013)
    local v2014 = GuiService.MenuOpened:Connect(function() --[[ Upvalues: v1993 (copy) ]]
        v1993:CancelInputs()
    end)
    table.insert(v1993.Connections, v2014)
    local v2015 = GuiService.MenuClosed:Connect(function() --[[ Upvalues: v1993 (copy) ]]
        v1993:CancelInputs()
    end)
    table.insert(v1993.Connections, v2015)
    local v2016 = UserInputService.WindowFocusReleased:Connect(function() --[[ Upvalues: v1993 (copy) ]]
        v1993.WindowUnfocused = true
        v1993:CancelInputs()
    end)
    table.insert(v1993.Connections, v2016)
    local v2017 = UserInputService.WindowFocused:Connect(function() --[[ Upvalues: v1993 (copy) ]]
        v1993.WindowUnfocused = false
        v1993:CancelInputs()
    end)
    table.insert(v1993.Connections, v2017)
    local v2018 = a0.Player.CharacterRemoving:Connect(function() --[[ Upvalues: v1993 (copy) ]]
        v1993:Destroy()
    end)
    table.insert(v1993.Connections, v2018)
    local TouchEnabled4 = UserInputService.TouchEnabled
    if TouchEnabled4 then
        TouchEnabled4 = false
        if UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad then
            TouchEnabled4 = true
            if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
                TouchEnabled4 = v1993.Active
                if TouchEnabled4 then
                    TouchEnabled4 = true
                    if UserInputService:GetFocusedTextBox() == nil then
                        TouchEnabled4 = v1993.KeyboardOwned
                    end
                end
            end
        end
    end

    v1993:SetActive(TouchEnabled4)
    return v1993
end

v158.Start = Start1
v50.Mobile = v158
saveAndHide = {}
saveAndHide.__index = saveAndHide

local function IsActive1(a0) --[[ Upvalues: UserInputService (copy) ]]
    local Client35 = a0.Client
    local v2019 = not a0.Destroyed
    if v2019 then
        v2019 = false
        if Client35.BuildCameraActive == true then
            v2019 = not Client35.ClassicBuildActive
            if v2019 then
                v2019 = false
                if UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse then
                    local v2021 = Client35.ModernMobile and Client35.ModernMobile:IsActive()
                    v2019 = not v2021
                    if v2019 then
                        local v2023 = Client35.ModernController and Client35.ModernController:IsGamepad()
                        v2019 = not v2023
                    end
                end
            end
        end
    end

    return v2019
end

saveAndHide.IsActive = IsActive1

local function Blocked(a0) --[[ Upvalues: GuiService (copy), UserInputService (copy) ]]
    local Client36 = a0.Client
    local WindowUnfocused2 = a0.WindowUnfocused
    if not WindowUnfocused2 then
        local MenuIsOpen6 = GuiService.MenuIsOpen
        if not MenuIsOpen6 then
            MenuIsOpen6 = true
            if UserInputService:GetFocusedTextBox() == nil then
                local v2024 = Client36.DeleteAllConfirmOpen or Client36.PaintResetConfirmOpen or Client36.BuildSystemSwitching
            end
        end
    end

    return WindowUnfocused2
end

saveAndHide.Blocked = Blocked

local function Refresh(a0)
    if a0.Destroyed then
        return
    end

    if a0.DeleteStorage and not a0:CanDeleteFrom(a0.DeleteStorage) then
        a0:CancelPendingDeletes()
    end

    local v2025 = a0:IsActive()
    local v2028 = v2025 and not a0.WasActive
    a0.WasActive = v2025
    if not v2025 then
        table.clear(a0.HistoryKeysDown)
        table.clear(a0.HistoryControlHeld)
    end

    local UI1 = a0.UI
    local UndoCount = a0.UndoCount
    local RedoCount = a0.RedoCount
    local Busy1 = a0.Busy
    if not Busy1 then
        Busy1 = a0.DeleteQueue ~= nil
    end

    local v2029 = a0:Blocked()
    UI1:Update(v2025, UndoCount, RedoCount, Busy1, v2029)
    if v2028 then
        task.defer(function() --[[ Upvalues: a0 (copy) ]]
            if not a0:IsActive() then
                return
            end

            local Client37 = a0.Client
            if Client37.EditingBase and not Client37.Painting then
                Client37:UpdateSubCategories(Client37.CurrentBaseObjects)
                Client37:UpdateBaseObjects(Client37.CurrentBaseObjects, true)
            end

            a0:RefreshState()
        end)
    end
end

saveAndHide.Refresh = Refresh

local function Request2(a0, a1) --[[ Upvalues: invokeBuildAction (copy) ]]
    if not a0:IsActive() or a0.Busy then
        return {ok = false, reason = "Wait for the current change to finish."}
    end

    if a1.action ~= "State" and a1.action ~= "Delete" then
        a0:CancelPendingDeletes()
    end

    a0.Busy = true
    local Client38 = a0.Client
    Client38:EndBuildTransformHold()
    Client38:EndDirectBuildDrag()
    a0:Refresh()
    local v2030 = invokeBuildAction(nil, a1, true)
    if a1.action ~= "State" then
        a0.NextDeleteAt = os.clock() + 0.08
    end

    a0.Busy = false
    if a0.Destroyed then
        return v2030
    end

    if type(v2030.undo) == "number" then
        a0.UndoCount = v2030.undo
    end

    if type(v2030.redo) == "number" then
        a0.RedoCount = v2030.redo
    end

    if not v2030.ok and a1.action ~= "State" then
        local v2031 = {
            Title = "Build Mode",
            Duration = 3,
            Text = v2030.reason or "The change could not be saved."
        }
        Client38:Noti(v2031)
    end

    a0:Refresh()
    if a0.NeedsStateRefresh then
        a0.NeedsStateRefresh = nil
        task.defer(function() --[[ Upvalues: a0 (copy) ]]
            a0:RefreshState()
        end)
    end

    return v2030
end

saveAndHide.Request = Request2

local function RefreshState1(a0)
    if not a0:IsActive() then
        return
    end

    if a0.Busy then
        a0.NeedsStateRefresh = true
        return
    end

    a0:Request({action = "State"})
end

saveAndHide.RefreshState = RefreshState1

local function Commit3(a0, a1)
    if not a0:IsActive() or a0.Busy or a0:Blocked() then
        return
    end

    local Client39 = a0.Client
    if Client39.Painting then
        return
    end

    if not Client39.EditObject then
        return
    end

    if typeof(a1) ~= "CFrame" then
        return
    end

    local EditObject6 = Client39.EditObject
    local EditingExistingObject4 = Client39.EditingExistingObject
    local v2032 = {}
    local v2033
    if EditingExistingObject4 then
        v2033 = "Move"
    else
        v2033 = "Place"
    end

    v2032.action = v2033
    v2032.name = EditObject6.Name
    v2032.object = EditingExistingObject4
    v2032.cframe = a1
    local v2034 = a0:Request(v2032)
    if a0.Destroyed then
        return v2034
    end

    if v2034.ok then
        if EditingExistingObject4 then
            if EditingExistingObject4.Parent then
                EditingExistingObject4:PivotTo(a1)
            end

            if Client39.EditObject == EditObject6 then
                if Client39.EditingExistingObject == EditingExistingObject4 then
                    Client39:DeleteEditObject()
                    return v2034
                    -- branch continues at 91
                end

                -- branch continues at 91
            end
        end
    end

    if Client39.EditObject == EditObject6 then
        Client39:RefreshBuildValidation(true)
    end

    return v2034
end

saveAndHide.Commit = Commit3

local function CanDeleteFrom(a0, a1)
    local Client40 = a0.Client
    local v2035 = false
    if a1 ~= nil then
        v2035 = false
        if Client40.StorageBase == a1 then
            local v2037 = a0:IsActive()
            if v2037 then
                v2037 = not a0:Blocked()
                if v2037 then
                    v2037 = Client40.EditingBase
                    if v2037 then
                        v2037 = false
                        if Client40.BuildModeKind == "Objects" then
                            v2037 = false
                            if Client40.DeletingObjects == true then
                                local v2039 = not Client40.Painting and not Client40.EditObject
                            end
                        end
                    end
                end
            end
        end
    end

    return v2035
end

saveAndHide.CanDeleteFrom = CanDeleteFrom

local function CancelPendingDeletes(a0)
    a0.DeleteQueue = nil
    a0.DeleteTargets = nil
    a0.DeleteStorage = nil
end

saveAndHide.CancelPendingDeletes = CancelPendingDeletes

local function Delete2(a0, a1)
    local Client41 = a0.Client
    local StorageBase = Client41.StorageBase
    if not a1 or not a0:CanDeleteFrom(StorageBase) or Client41:ResolvePlacedBuildObject(a1) ~= a1 then
        return {ok = false}
    end

    if a0.DeleteStorage and a0.DeleteStorage ~= StorageBase then
        a0:CancelPendingDeletes()
    end

    a0.DeleteStorage = StorageBase
    local DeleteTargets = a0.DeleteTargets
    if not DeleteTargets then
        local v2040 = setmetatable({}, {__mode = "k"})
    end

    a0.DeleteTargets = DeleteTargets
    if a0.DeleteTargets[a1] then
        return {queued = true}
    end

    a0.DeleteTargets[a1] = true
    local DeleteQueue = a0.DeleteQueue
    if DeleteQueue then
        table.insert(DeleteQueue, a1)
        return {queued = true}
    end

    local v2041 = {a1}
    DeleteQueue = v2041
    a0.DeleteQueue = DeleteQueue
    local DeleteTargets1 = a0.DeleteTargets
    task.defer(function() --[[ Upvalues: a0 (copy), DeleteQueue (ref), StorageBase (copy), Client41 (copy), DeleteTargets1 (copy) ]]
        while a0.DeleteQueue == DeleteQueue do
            local v2042 = #DeleteQueue
            if 0 >= v2042 then
                break
            end

            if not a0:CanDeleteFrom(StorageBase) then
                a0:CancelPendingDeletes()
                break
            end

            if not a0.Busy then
                if os.clock() >= (a0.NextDeleteAt or 0) then
                    -- jump to 43
                end
            end

            task.wait()
        end

        if a0.DeleteQueue == DeleteQueue then
            a0.DeleteQueue = nil
            a0:Refresh()
        end

    end)
    a0:Refresh()
    return {queued = true}
end

saveAndHide.Delete = Delete2

local function History2(a0, a1)
    if a1 == "Undo" or a1 == "Redo" then
        if not a0:IsActive() then
            return
        end

        if a0.Busy then
            return
        end

        if not a0:Blocked() then
            -- jump to 18
        end
    end

    return
    if a1 ~= "Undo" or a0.UndoCount > 0 then
        if a1 == "Redo" then
            if a0.RedoCount > 0 then
                -- jump to 33
            end

            -- branch continues at 33
        end
    end

    return
    local Client42 = a0.Client
    local EditObject7 = Client42.EditObject
    local EditingExistingObject5 = Client42.EditingExistingObject
    local v2043 = {action = a1}
    local v2044 = a0:Request(v2043)
    if v2044.ok then
        if not a0.Destroyed then
            if EditObject7 and Client42.EditObject == EditObject7 and Client42.EditingExistingObject == EditingExistingObject5 then
                Client42:DeleteEditObject()
            end

            Client42:ClearBuildObjectHover()
            if Client42.EditObject then
                Client42:RefreshBuildValidation(true)
            end

            Client42:UpdateStorageCapacity()
        end
    end

    return v2044
end

saveAndHide.History = History2

local function HistoryInput(a0, a1, a2) --[[ Upvalues: UserInputService (copy) ]]
    local KeyCode2 = a1.KeyCode
    if KeyCode2 == Enum.KeyCode.LeftControl or KeyCode2 == Enum.KeyCode.RightControl then
        local HistoryControlHeld = a0.HistoryControlHeld
        local v2047 = a2 and a0:IsActive() and not a0:Blocked() or nil
        HistoryControlHeld[KeyCode2] = v2047
        return
    end

    if KeyCode2 ~= Enum.KeyCode.Z and KeyCode2 ~= Enum.KeyCode.Y then
        return
    end

    if a2 then
        a0.HistoryKeysDown[KeyCode2] = true
    else
        local v2048 = a0.HistoryKeysDown[KeyCode2]
        a0.HistoryKeysDown[KeyCode2] = nil
        if v2048 then
            return
        end
    end

    if not a0:IsActive() or a0:Blocked() then
        return
    end

    local v2051 = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
    if not v2051 then
        return
    end

    if not a2 and not a0.HistoryControlHeld[Enum.KeyCode.LeftControl] and not a0.HistoryControlHeld[Enum.KeyCode.RightControl] then
        return
    end

    local v2054 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
    if KeyCode2 == Enum.KeyCode.Y or v2054 then
        local v2055 = "Redo"
        -- jump to 116 (out of range)
    end

    local v2056 = "Undo"
    a0:History(v2056)
end

saveAndHide.HistoryInput = HistoryInput

local function Destroy5(a0)
    if a0.Destroyed then
        return
    end

    a0:CancelPendingDeletes()
    a0.Destroyed = true
    for k390, k391 in ipairs(a0.Connections) do
        k391:Disconnect()
    end

    a0.UI:Destroy()
end

saveAndHide.Destroy = Destroy5
local DesktopUI = v50.DesktopUI

local function Start2(a0) --[[ Upvalues: saveAndHide (copy), DesktopUI (copy), UserInputService (copy), GuiService (copy) ]]
    local v2060 = {
        UndoCount = 0,
        RedoCount = 0,
        Client = a0,
        Connections = {},
        HistoryKeysDown = {},
        HistoryControlHeld = {}
    }
    local v2061 = setmetatable(v2060, saveAndHide)
    v2061.UI = DesktopUI.new(a0, function(a0) --[[ Upvalues: v2061 (copy) ]]
        v2061:History(a0)
    end)

    local function connect2(a0, a1) --[[ Upvalues: v2061 (copy) ]]
        local v2062 = a0:Connect(a1)
        table.insert(v2061.Connections, v2062)
    end

    local v2063 = UserInputService.InputBegan:Connect(function(a0) --[[ Upvalues: v2061 (copy) ]]
        v2061:HistoryInput(a0, true)
    end)
    table.insert(v2061.Connections, v2063)
    local v2064 = UserInputService.InputEnded:Connect(function(a0) --[[ Upvalues: v2061 (copy) ]]
        v2061:HistoryInput(a0, false)
    end)
    table.insert(v2061.Connections, v2064)
    local v2065 = UserInputService:GetPropertyChangedSignal("PreferredInput")
    local v2066 = v2065:Connect(function() --[[ Upvalues: v2061 (copy) ]]
        task.defer(function() --[[ Upvalues: v2061 (upvalue) ]]
            if v2061.Destroyed then
                return
            end

            v2061:Refresh()
        end)
    end)
    table.insert(v2061.Connections, v2066)
    local v2067 = UserInputService.TextBoxFocused:Connect(function() --[[ Upvalues: v2061 (copy) ]]
        v2061:Refresh()
    end)
    table.insert(v2061.Connections, v2067)
    local v2068 = UserInputService.TextBoxFocusReleased:Connect(function() --[[ Upvalues: v2061 (copy) ]]
        task.defer(function() --[[ Upvalues: v2061 (upvalue) ]]
            v2061:Refresh()
        end)
    end)
    table.insert(v2061.Connections, v2068)
    local v2069 = GuiService.MenuOpened:Connect(function() --[[ Upvalues: v2061 (copy) ]]
        v2061:Refresh()
    end)
    table.insert(v2061.Connections, v2069)
    local v2070 = GuiService.MenuClosed:Connect(function() --[[ Upvalues: v2061 (copy) ]]
        v2061:Refresh()
    end)
    table.insert(v2061.Connections, v2070)
    local v2071 = UserInputService.WindowFocusReleased:Connect(function() --[[ Upvalues: v2061 (copy) ]]
        v2061.WindowUnfocused = true
        table.clear(v2061.HistoryKeysDown)
        table.clear(v2061.HistoryControlHeld)
        v2061:Refresh()
    end)
    table.insert(v2061.Connections, v2071)
    local v2072 = UserInputService.WindowFocused:Connect(function() --[[ Upvalues: v2061 (copy) ]]
        v2061.WindowUnfocused = false
        v2061:Refresh()
    end)
    table.insert(v2061.Connections, v2072)
    local v2073 = a0.Player.CharacterRemoving:Connect(function() --[[ Upvalues: v2061 (copy) ]]
        v2061:Destroy()
    end)
    table.insert(v2061.Connections, v2073)
    v2061:Refresh()
    return v2061
end

saveAndHide.Start = Start2
v50.Desktop = saveAndHide
getLegacyVisibility = {}
getLegacyVisibility.__index = getLegacyVisibility
v157 = {
    Panel = Color3.new(0, 0, 0),
    Text = Color3.new(1, 1, 1),
    Muted = Color3.fromRGB(190, 195, 190),
    Accent = Color3.fromRGB(157, 230, 163),
    Danger = Color3.fromRGB(255, 153, 153)
}

local function rect1(a0, a1, a2, a3, a4)
    local v2074 = UDim2.fromOffset(a1, a2)
    a0.Position = v2074
    a0.Size = UDim2.fromOffset(a3, a4)
end

local function outline2(a0) --[[ Upvalues: v157 (copy) ]]
    local t17 = {
        Name = "Outline",
        Thickness = 1,
        Transparency = 0.55,
        Color = v157.Text,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }
    local UIStroke4 = Instance.new("UIStroke")
    for k392, k393 in pairs(t17) do
        UIStroke4[k392] = k393
    end

    UIStroke4.Parent = a0
    return UIStroke4
end

local function label3(a0, a1, a2, a3, a4) --[[ Upvalues: v157 (copy) ]]
    local t18 = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Active = false,
        Name = a1,
        Text = a2
    }
    local v2079 = a4 or v157.Text
    t18.TextColor3 = v2079
    t18.TextSize = a3 or 14
    t18.Font = Enum.Font.Code
    t18.TextXAlignment = Enum.TextXAlignment.Left
    t18.TextTruncate = Enum.TextTruncate.AtEnd
    local TextLabel3 = Instance.new("TextLabel")
    for k394, k395 in pairs(t18) do
        TextLabel3[k394] = k395
    end

    TextLabel3.Parent = a0
    return TextLabel3
end

local function asSet1(a0)
    local t19 = {}
    if type(a0) == "table" then
        for k396, k397 in pairs(a0) do
            if type(k396) == "string" and k397 then
                t19[k396] = true
            else
                if type(k397) == "string" then
                    t19[k397] = true
                end
            end
        end
    end

    return t19
end

local function inside(a0, a1)
    local AbsolutePosition = a0.AbsolutePosition
    local AbsoluteSize2 = a0.AbsoluteSize
    local Visible = a0.Visible
    if Visible then
        Visible = false
        if AbsolutePosition.X <= a1.X then
            Visible = false
            if AbsolutePosition.Y <= a1.Y then
                Visible = false
                if a1.X < AbsolutePosition.X + AbsoluteSize2.X then
                    Visible = a1.Y < AbsolutePosition.Y + AbsoluteSize2.Y
                end
            end
        end
    end

    return Visible
end

local function _allowed1(a0)
    local v2087 = a0.Active and not a0.Destroyed
    return v2087
end

getLegacyVisibility._allowed = _allowed1

local function _styleButton(a0, a1) --[[ Upvalues: v157 (copy) ]]
    local v2088 = a1:GetAttribute("Selected") == true
    local v2089 = a1:GetAttribute("Hover") == true
    local v2091
    if not (v2088 and Color3.fromRGB(21, 51, 28)) then
        v2091 = v157.Panel
    end

    a1.BackgroundColor3 = v2091
    if v2088 then
        v2091 = 0.04
    else
        if v2089 then
            v2091 = 0.03
        else
            v2091 = 0.32
        end
    end

    a1.BackgroundTransparency = v2091
    local Outline11 = a1:FindFirstChild("Outline")
    if Outline11 then
        local v2092
        if not (v2088 and v157.Accent) then
            v2092 = v157.Text
        end

        Outline11.Color = v2092
        if v2088 then
            v2092 = 0
        else
            if v2089 then
                v2092 = 0.15
            else
                v2092 = 0.55
            end
        end

        Outline11.Transparency = v2092
    end
end

getLegacyVisibility._styleButton = _styleButton

local function _button2(a0, a1, a2, a3, a4) --[[ Upvalues: v157 (copy) ]]
    local v2093 = {
        TextSize = 13,
        BackgroundTransparency = 0.32,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Active = true,
        Selectable = false,
        Name = a2,
        Text = a3,
        Font = Enum.Font.Code,
        TextColor3 = v157.Text,
        BackgroundColor3 = v157.Panel
    }
    local TextButton2 = Instance.new("TextButton")
    for k398, k399 in pairs(v2093) do
        TextButton2[k398] = k399
    end

    TextButton2.Parent = a1
    local v2097 = {
        Name = "Outline",
        Thickness = 1,
        Transparency = 0.55,
        Color = v157.Text,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }
    v2093 = Instance.new("UIStroke")
    for k400, k401 in pairs(v2097) do
        v2093[k400] = k401
    end

    v2093.Parent = TextButton2
    TextButton2.MouseEnter:Connect(function() --[[ Upvalues: TextButton2 (copy), a0 (copy) ]]
        TextButton2:SetAttribute("Hover", true)
        a0:_styleButton(TextButton2)
    end)
    TextButton2.MouseLeave:Connect(function() --[[ Upvalues: TextButton2 (copy), a0 (copy) ]]
        TextButton2:SetAttribute("Hover", false)
        a0:_styleButton(TextButton2)
    end)
    TextButton2.Activated:Connect(function() --[[ Upvalues: a0 (copy), a4 (copy) ]]
        if a0:_allowed() and a4 then
            a4()
        end

    end)
    return TextButton2
end

getLegacyVisibility._button = _button2

local function new3(a0, a1) --[[ Upvalues: getLegacyVisibility (copy), v157 (copy), label3 (copy), Query (copy) ]]
    local v2101 = {
        Active = false,
        Collapsed = false,
        Destroyed = false,
        Category = "Furniture",
        SubCategory = "All",
        SearchQuery = "",
        ThumbnailRequest = 0,
        Generation = 0,
        Columns = 3,
        CardWidth = 138,
        CardHeight = 132,
        Client = a0
    }
    local v2102 = a1
    if not v2102 then
        v2102 = {}
    end

    v2101.Callbacks = v2102
    v2101.Connections = {}
    v2101.CategoryButtons = {}
    v2101.Cards = {}
    v2101.ThumbnailItems = {}
    v2101.ScrollMemory = {}
    v2101.CategoryMemory = {}
    local v2103 = setmetatable(v2101, getLegacyVisibility)
    local v2104 = {
        Name = "DesktopBuildCatalogue",
        Enabled = false,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 34,
        ScreenInsets = Enum.ScreenInsets.None,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }
    local PlayerGui2 = a0.Player:WaitForChild("PlayerGui")
    v2101 = Instance.new("ScreenGui")
    for k402, k403 in pairs(v2104) do
        v2101[k402] = k403
    end

    v2101.Parent = PlayerGui2
    v2103.Root = v2101
    v2104 = {
        Name = "ViewportBounds",
        BackgroundTransparency = 1,
        Active = false,
        Size = UDim2.fromScale(1, 1)
    }
    local Root6 = v2103.Root
    v2101 = Instance.new("Frame")
    for k404, k405 in pairs(v2104) do
        v2101[k404] = k405
    end

    v2101.Parent = Root6
    v2103.Bounds = v2101
    v2104 = {
        Name = "Panel",
        BackgroundTransparency = 0.12,
        BorderSizePixel = 0,
        Active = true,
        BackgroundColor3 = v157.Panel
    }
    local Bounds = v2103.Bounds
    v2101 = Instance.new("Frame")
    for k406, k407 in pairs(v2104) do
        v2101[k406] = k407
    end

    v2101.Parent = Bounds
    v2103.Panel = v2101
    v2101 = v2103.Panel
    Bounds = {
        Name = "Outline",
        Thickness = 1,
        Transparency = 0.55,
        Color = v157.Text,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }
    v2104 = Instance.new("UIStroke")
    for k408, k409 in pairs(Bounds) do
        v2104[k408] = k409
    end

    v2104.Parent = v2101
    v2103.Title = label3(v2103.Panel, "Title", "OBJECTS", 18)
    v2103.Count = label3(v2103.Panel, "Count", "", 12, v157.Muted)
    v2103.CollapseButton = v2103:_button(v2103.Panel, "Collapse", "Hide  >", function() --[[ Upvalues: v2103 (copy) ]]
        v2103:SetCollapsed(true)
    end)
    v2103.OpenButton = v2103:_button(v2103.Bounds, "OpenObjects", "<  Objects", function() --[[ Upvalues: v2103 (copy) ]]
        v2103:SetCollapsed(false)
    end)
    v2103.OpenButton.Visible = false
    local v2117 = {
        Name = "Search",
        Text = "",
        PlaceholderText = "Search furniture\226\128\166",
        TextSize = 14,
        ClearTextOnFocus = false,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        PlaceholderColor3 = v157.Muted,
        TextColor3 = v157.Text,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundColor3 = v157.Panel
    }
    local Panel5 = v2103.Panel
    local TextBox1 = Instance.new("TextBox")
    for k410, k411 in pairs(v2117) do
        TextBox1[k410] = k411
    end

    TextBox1.Parent = Panel5
    v2103.Search = TextBox1
    TextBox1 = v2103.Search
    Panel5 = {
        Name = "Outline",
        Thickness = 1,
        Transparency = 0.55,
        Color = v157.Text,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }
    v2117 = Instance.new("UIStroke")
    for k412, k413 in pairs(Panel5) do
        v2117[k412] = k413
    end

    v2117.Parent = TextBox1
    TextBox1 = {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 36)}
    local Search3 = v2103.Search
    local UIPadding5 = Instance.new("UIPadding")
    for k414, k415 in pairs(TextBox1) do
        UIPadding5[k414] = k415
    end

    UIPadding5.Parent = Search3
    v2103.ClearSearch = v2103:_button(v2103.Panel, "ClearSearch", "\195\151", function() --[[ Upvalues: v2103 (copy) ]]
        v2103.Search.Text = ""
    end)
    v2103.ClearSearch.TextSize = 20
    v2103.ClearSearch.ZIndex = 2
    v2103.ClearSearch.Visible = false
    local Panel6 = v2103.Panel
    local Frame21 = Instance.new("Frame")
    for k416, k417 in pairs({Name = "Categories", BackgroundTransparency = 1}) do
        Frame21[k416] = k417
    end

    Frame21.Parent = Panel6
    v2103.CategoryList = Frame21
    for k418, k419 in ipairs(Query) do
        local v2135 = v2103:_button(v2103.CategoryList, k419, k419, function() --[[ Upvalues: v2103 (copy), k419 (copy) ]]
            v2103:_rememberScroll()
            v2103.CategoryMemory[v2103.Category] = v2103.SubCategory
            v2103.Category = k419
            v2103.SubCategory = v2103.CategoryMemory[k419] or "All"
            v2103:Refresh()
        end)
        v2135.TextScaled = true
        local UITextSizeConstraint1 = Instance.new("UITextSizeConstraint")
        for k420, k421 in pairs({MinTextSize = 10, MaxTextSize = 13}) do
            UITextSizeConstraint1[k420] = k421
        end

        UITextSizeConstraint1.Parent = v2135
        local v2139 = {PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4)}
        local UIPadding6 = Instance.new("UIPadding")
        for k422, k423 in pairs(v2139) do
            UIPadding6[k422] = k423
        end

        UIPadding6.Parent = v2135
        v2139 = v2103.CategoryButtons
        v2139[k418] = v2135
    end

    local v2143 = {
        Name = "Subcategories",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollingDirection = Enum.ScrollingDirection.X,
        ScrollBarImageColor3 = v157.Muted,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.None,
        ElasticBehavior = Enum.ElasticBehavior.Never
    }
    local Panel7 = v2103.Panel
    local ScrollingFrame4 = Instance.new("ScrollingFrame")
    for k424, k425 in pairs(v2143) do
        ScrollingFrame4[k424] = k425
    end

    ScrollingFrame4.Parent = Panel7
    v2103.SubList = ScrollingFrame4
    v2143 = {
        Name = "Items",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 5,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarImageColor3 = v157.Muted,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.None,
        ElasticBehavior = Enum.ElasticBehavior.Never
    }
    local Panel8 = v2103.Panel
    ScrollingFrame4 = Instance.new("ScrollingFrame")
    for k426, k427 in pairs(v2143) do
        ScrollingFrame4[k426] = k427
    end

    ScrollingFrame4.Parent = Panel8
    v2103.ItemList = ScrollingFrame4
    v2103.Empty = label3(v2103.Panel, "Empty", "", 14, v157.Muted)
    v2103.Empty.TextWrapped = true
    v2103.Empty.TextTruncate = Enum.TextTruncate.None
    v2103.Empty.TextXAlignment = Enum.TextXAlignment.Center
    v2103.Selection = label3(v2103.Panel, "Selection", "Choose an object to build", 12, v157.Muted)
    v2103.ClassicRotateStep = v2103:_button(v2103.Bounds, "ClassicRotateStep", "", function() --[[ Upvalues: v2103 (copy) ]]
        if v2103.Client.ClassicBuildActive and v2103.Callbacks.ClassicRotateStep then
            v2103.Callbacks.ClassicRotateStep()
            v2103:RefreshSelection()
        end

    end)
    v2103.ClassicPaint = v2103:_button(v2103.Bounds, "ClassicPaint", "Paint  [P]", function() --[[ Upvalues: v2103 (copy) ]]
        if v2103.Client.ClassicBuildActive and v2103.Callbacks.ClassicPaint then
            v2103.Callbacks.ClassicPaint()
        end

    end)
    v2103.ClassicPaint.TextSize = 16
    v2103.ClassicPaint.Visible = false
    v2103.ClassicRotateStep.TextSize = 16
    v2103.ClassicRotateStep.Visible = false
    v2103.ClassicHints = label3(v2103.Bounds, "ClassicShortcuts", "", 16, v157.Text)
    v2103.ClassicHints.TextWrapped = true
    v2103.ClassicHints.TextTruncate = Enum.TextTruncate.None
    v2103.ClassicHints.TextYAlignment = Enum.TextYAlignment.Bottom
    v2103.ClassicHints.TextStrokeTransparency = 0.15
    v2103.ClassicHints.Visible = false
    local v2150 = v2103.Bounds:GetPropertyChangedSignal("AbsoluteSize")
    local v2151 = v2150:Connect(function() --[[ Upvalues: v2103 (copy) ]]
        v2103:_resize()
    end)
    table.insert(v2103.Connections, v2151)
    local v2152 = v2103.ItemList:GetPropertyChangedSignal("CanvasPosition")
    local v2153 = v2152:Connect(function() --[[ Upvalues: v2103 (copy) ]]
        if not v2103.RestoringScroll then
            v2103:_rememberScroll()
        end

        v2103:_queueThumbnails()
    end)
    table.insert(v2103.Connections, v2153)
    local v2154 = v2103.Search:GetPropertyChangedSignal("Text")
    local v2155 = v2154:Connect(function() --[[ Upvalues: v2103 (copy) ]]
        v2103:_rememberScroll()
        v2103.SearchQuery = string.lower(v2103.Search.Text)
        v2103.ClearSearch.Visible = v2103.Search.Text ~= ""
        v2103.SearchRequest = (v2103.SearchRequest or 0) + 1
        local SearchRequest1 = v2103.SearchRequest
        task.delay(0.12, function() --[[ Upvalues: v2103 (upvalue), SearchRequest1 (copy) ]]
            if not v2103.Destroyed and SearchRequest1 == v2103.SearchRequest then
                v2103:Refresh()
            end

        end)
    end)
    table.insert(v2103.Connections, v2155)
    local v2156 = v2103.Search.FocusLost:Connect(function() --[[ Upvalues: v2103 (copy) ]]
        v2103.Client.DesktopCatalogueTextReleasedAt = os.clock()
    end)
    table.insert(v2103.Connections, v2156)
    v2103:_resize()
    return v2103
end

getLegacyVisibility.new = new3

local function _key(a0)
    local v2157 = #a0.Category
    local v2158 = #a0.SubCategory
    return v2157 .. ":" .. a0.Category .. v2158 .. ":" .. a0.SubCategory .. a0.SearchQuery
end

getLegacyVisibility._key = _key

local function _rememberScroll(a0)
    if a0.RenderedKey and not a0.RestoringScroll then
        a0.ScrollMemory[a0.RenderedKey] = a0.ItemList.CanvasPosition.Y
    end
end

getLegacyVisibility._rememberScroll = _rememberScroll

local function _resize2(a0)
    if a0.Destroyed then
        return
    end

    local AbsoluteSize3 = a0.Bounds.AbsoluteSize
    if AbsoluteSize3.X < 1 or AbsoluteSize3.Y < 1 then
        return
    end

    local v2159 = math.floor(AbsoluteSize3.X * 0.305)
    local v2160 = math.clamp(v2159, 340, 470)
    local v2161 = math.min(v2160, AbsoluteSize3.X - 32)
    v2160 = math.floor(AbsoluteSize3.X * 0.1) + 16
    local v2162 = math.floor(AbsoluteSize3.Y * 0.145) + 140
    local v2163 = math.max(220, AbsoluteSize3.Y - v2162 - 16)
    if AbsoluteSize3.Y - 8 < v2162 + v2163 then
        v2162 = math.max(56, AbsoluteSize3.Y - v2163 - 8)
    end

    local v2164 = math.max(8, AbsoluteSize3.X - v2160 - v2161)
    local Panel9 = a0.Panel
    local v2165 = UDim2.fromOffset(v2164, v2162)
    Panel9.Position = v2165
    Panel9.Size = UDim2.fromOffset(v2161, v2163)
    Panel9 = a0.OpenButton
    local v2166 = UDim2.fromOffset(v2164 + v2161 - 112, v2162)
    Panel9.Position = v2166
    Panel9.Size = UDim2.fromOffset(112, 34)
    Panel9 = a0.Title
    local v2167 = UDim2.fromOffset(12, 8)
    Panel9.Position = v2167
    Panel9.Size = UDim2.fromOffset(v2161 - 164, 27)
    Panel9 = a0.Count
    local v2168 = UDim2.fromOffset(v2161 - 159, 10)
    Panel9.Position = v2168
    Panel9.Size = UDim2.fromOffset(57, 24)
    Panel9 = a0.CollapseButton
    local v2169 = UDim2.fromOffset(v2161 - 88, 8)
    Panel9.Position = v2169
    Panel9.Size = UDim2.fromOffset(76, 28)
    Panel9 = a0.Search
    local v2170 = UDim2.fromOffset(12, 44)
    Panel9.Position = v2170
    Panel9.Size = UDim2.fromOffset(v2161 - 24, 34)
    Panel9 = a0.ClearSearch
    local v2171 = UDim2.fromOffset(v2161 - 43, 47)
    Panel9.Position = v2171
    Panel9.Size = UDim2.fromOffset(28, 28)
    Panel9 = a0.CategoryList
    local v2172 = UDim2.fromOffset(12, 88)
    local v2173 = v2161 - 24
    local v2174 = UDim2.fromOffset(v2173, 30)
    Panel9.Position = v2172
    Panel9.Size = v2174
    v2162 = (v2161 - 24 - 20) / 5
    for k428, k429 in ipairs(a0.CategoryButtons) do
        local v2178 = (k428 - 1) * (v2162 + 5)
        local v2179 = UDim2.fromOffset(v2178, 0)
        k429.Position = v2179
        k429.Size = UDim2.fromOffset(v2162, 30)
    end

    local SubList2 = a0.SubList
    local v2180 = UDim2.fromOffset(12, 128)
    SubList2.Position = v2180
    SubList2.Size = UDim2.fromOffset(v2161 - 24, 33)
    SubList2 = a0.ItemList
    local v2181 = math.max(20, v2163 - 202)
    local v2182 = UDim2.fromOffset(12, 170)
    SubList2.Position = v2182
    SubList2.Size = UDim2.fromOffset(v2161 - 24, v2181)
    SubList2 = a0.Empty
    local v2183 = math.max(40, v2163 - 232)
    local v2184 = UDim2.fromOffset(28, 180)
    SubList2.Position = v2184
    SubList2.Size = UDim2.fromOffset(v2161 - 56, v2183)
    SubList2 = a0.Selection
    local v2185 = UDim2.fromOffset(12, v2163 - 26)
    SubList2.Position = v2185
    SubList2.Size = UDim2.fromOffset(v2161 - 24, 20)
    v2163 = math.max(180, math.min(600, v2164 - 36))
    local ClassicHints = a0.ClassicHints
    local v2186 = AbsoluteSize3.Y - 132
    local v2187 = UDim2.fromOffset(20, v2186)
    ClassicHints.Position = v2187
    ClassicHints.Size = UDim2.fromOffset(v2163, 68)
    ClassicHints = a0.ClassicRotateStep
    v2186 = AbsoluteSize3.Y - 174
    local v2188 = math.min(270, v2163)
    local v2189 = UDim2.fromOffset(20, v2186)
    ClassicHints.Position = v2189
    ClassicHints.Size = UDim2.fromOffset(v2188, 34)
    ClassicHints = a0.ClassicPaint
    v2186 = AbsoluteSize3.Y - 216
    local v2190 = math.min(270, v2163)
    local v2191 = UDim2.fromOffset(20, v2186)
    ClassicHints.Position = v2191
    ClassicHints.Size = UDim2.fromOffset(v2190, 34)
    if 380 <= v2161 then
        ClassicHints = 3
    else
        ClassicHints = 2
    end

    a0.Columns = ClassicHints
    v2191 = v2161 - 24 - 10
    local v2192 = (a0.Columns - 1) * 8
    v2190 = v2191 - v2192
    v2191 = a0.Columns
    a0.CardWidth = math.floor(v2190 / v2191)
    a0.CardHeight = 132
    if a0.CardWidth ~= a0.CardWidth then
        a0:_releaseThumbnails()
    end

    a0.RestoringScroll = true
    for k430, k431 in ipairs(a0.Cards) do
        a0:_layoutCard(k431, k430)
    end

    local v2196 = #a0.Cards
    local v2197 = math.ceil(v2196 / a0.Columns)
    local v2198 = math.max(0, v2197 * (a0.CardHeight + 8) - 8)
    a0.ItemList.CanvasSize = UDim2.fromOffset(0, v2198)
    v2162 = math.max(0, v2198 - a0.ItemList.Size.Y.Offset)
    a0.ItemList.CanvasPosition = Vector2.new(0, math.clamp(a0.RenderedKey and a0.ScrollMemory[a0.RenderedKey] or 0 or 0, 0, v2162))
    a0.RestoringScroll = false
    a0:_queueThumbnails()
end

getLegacyVisibility._resize = _resize2

local function _layoutCard1(a0, a1, a2)
    local v2200 = (a2 - 1) % a0.Columns
    local v2201 = math.floor((a2 - 1) / a0.Columns)
    local v2202 = v2200 * (a0.CardWidth + 8) + 1
    local v2203 = v2201 * (a0.CardHeight + 8) + 1
    local v2204 = UDim2.fromOffset(v2202, v2203)
    a1.Position = v2204
    a1.Size = UDim2.fromOffset(a0.CardWidth, a0.CardHeight)
    v2202 = a1.ItemTitle
    v2203 = a0.CardWidth - 14
    local v2205 = UDim2.fromOffset(7, 76)
    v2202.Position = v2205
    v2202.Size = UDim2.fromOffset(v2203, 34)
    v2202 = a1.Price
    v2203 = a0.CardWidth - 14
    local v2206 = UDim2.fromOffset(7, 111)
    v2202.Position = v2206
    v2202.Size = UDim2.fromOffset(v2203, 17)
    v2202 = a1.Favorite
    v2203 = a0.CardWidth - 30
    local v2207 = UDim2.fromOffset(v2203, 4)
    v2202.Position = v2207
    v2202.Size = UDim2.fromOffset(26, 26)
    local Preview9 = a1:FindFirstChild("Preview")
    if Preview9 then
        local v2208 = a0.CardWidth - 12
        Preview9.Size = UDim2.fromOffset(v2208, 72)
    end
end

getLegacyVisibility._layoutCard = _layoutCard1

local function _thumbnail2(a0, a1, a2) --[[ Upvalues: Recents (copy) ]]
    local v2209 = a0.CardWidth - 12
    local v2210 = UDim2.fromOffset(v2209, 72)
    local v2211 = UDim2.fromOffset(6, 3)
    local t20 = {Active = false, AllowMissingClone = true}
    t20.FixedAspect = math.max(0.1, (a0.CardWidth - 12) / 72)
    Recents.CreateThumbnail(a0, a1, a2, v2210, v2211, nil, 2, t20)
end

getLegacyVisibility._thumbnail = _thumbnail2

local function _releaseThumbnails(a0)
    a0.ThumbnailRequest = a0.ThumbnailRequest + 1
    for k432, k433 in pairs(a0.ThumbnailItems) do
        local Preview10 = k432:FindFirstChild("Preview")
        if Preview10 then
            Preview10:Destroy()
        end

        k433.Loaded = nil
    end
end

getLegacyVisibility._releaseThumbnails = _releaseThumbnails

local function _queueThumbnails2(a0)
    a0.ThumbnailRequest = a0.ThumbnailRequest + 1
    if not a0:_allowed() or a0.Collapsed then
        return
    end

    local ThumbnailRequest2 = a0.ThumbnailRequest
    local Generation = a0.Generation
    task.defer(function() --[[ Upvalues: a0 (copy), ThumbnailRequest2 (copy), Generation (copy) ]]

        local function current2() --[[ Upvalues: a0 (upvalue), ThumbnailRequest2 (upvalue), Generation (upvalue) ]]
            local v2215 = a0:_allowed()
            if v2215 then
                v2215 = not a0.Collapsed
                if v2215 then
                    v2215 = false
                    if a0.ThumbnailRequest == ThumbnailRequest2 then
                        v2215 = a0.Generation == Generation
                    end
                end
            end

            return v2215
        end

        local v2216 = a0:_allowed()
        if v2216 then
            v2216 = not a0.Collapsed
            if v2216 then
                v2216 = false
                if a0.ThumbnailRequest == ThumbnailRequest2 then
                    v2216 = a0.Generation == Generation
                end
            end
        end

        if not v2216 then
            return
        end

        v2216 = a0.CardHeight + 8
        local v2217 = math.max(0, math.floor(a0.ItemList.CanvasPosition.Y / v2216) - 1)
        local Y7 = a0.ItemList.CanvasPosition.Y
        local Y8 = a0.ItemList.AbsoluteSize.Y
        local v2218 = math.floor((Y7 + Y8) / v2216) + 1
        v2216 = 0
        for k434, k435 in ipairs(a0.Cards) do
            local v2222 = math.floor((k434 - 1) / a0.Columns)
            local v2223 = a0.ThumbnailItems[k435]
            if v2223.Loaded then
                if v2222 < v2217 or v2218 < v2222 then
                    local Preview11 = k435:FindFirstChild("Preview")
                    if Preview11 then
                        Preview11:Destroy()
                    end

                    v2223.Loaded = nil
                end
            end
        end

        for k436, k437 in ipairs(a0.Cards) do
            local v2227 = a0:_allowed()
            if v2227 then
                v2227 = not a0.Collapsed
                if v2227 then
                    v2227 = false
                    if a0.ThumbnailRequest == ThumbnailRequest2 then
                        v2227 = a0.Generation == Generation
                    end
                end
            end

            if not v2227 then
                return
            end

            v2227 = math.floor((k436 - 1) / a0.Columns)
            local v2228 = a0.ThumbnailItems[k437]
            if v2217 <= v2227 and v2227 <= v2218 and not v2228.Loaded and not v2228.Failed then
                local v2229 = pcall(function() --[[ Upvalues: a0 (upvalue), k437 (copy), v2228 (copy) ]]
                    a0:_thumbnail(k437, v2228.Name)
                end)
                local v2230 = v2229
                if v2230 then
                    v2230 = k437:FindFirstChild("Preview") ~= nil
                end

                v2228.Loaded = v2230
                v2228.Failed = not v2228.Loaded
                if not v2229 and k437:FindFirstChild("Preview") then
                    k437.Preview:Destroy()
                end

                v2216 = v2216 + 1
                if v2216 % 2 == 0 then
                    task.wait()
                end
            end
        end

    end)
end

getLegacyVisibility._queueThumbnails = _queueThumbnails2

local function Refresh1(a0) --[[ Upvalues: clear (copy), asSet1 (copy), Recents (copy), Query (copy), label3 (copy), v157 (copy) ]]
    if a0.Destroyed then
        return
    end

    a0.Dirty = true
    if not a0.Active or a0.Collapsed then
        return
    end

    a0:_rememberScroll()
    a0.Generation = a0.Generation + 1
    a0.ThumbnailRequest = a0.ThumbnailRequest + 1
    a0.RestoringScroll = true
    clear(a0.SubList)
    clear(a0.ItemList)
    a0.Cards = {}
    a0.ThumbnailItems = {}
    a0.HoverName = nil
    local Data6 = a0.Client.Data
    if not Data6 then
        Data6 = {}
    end

    local UnlockedObjects2 = Data6.UnlockedObjects
    if not UnlockedObjects2 then
        UnlockedObjects2 = {}
    end

    local BaseItems3 = Data6.BaseItems
    if not BaseItems3 then
        BaseItems3 = {}
    end

    local v2231 = a0.Client.ModernBuildFavorites or Data6.ModernBuildFavorites
    local v2232 = asSet1(v2231)
    local Query2 = Recents.Query
    local v2233 = {
        Policy = "Desktop",
        Data = Data6,
        Category = a0.Category,
        SubCategory = a0.SubCategory,
        SearchQuery = a0.SearchQuery,
        Favorites = v2232
    }
    local ModernBuildRecents3 = a0.Client.ModernBuildRecents
    if not ModernBuildRecents3 then
        ModernBuildRecents3 = Data6.ModernBuildRecents
        if not ModernBuildRecents3 then
            ModernBuildRecents3 = {}
        end
    end

    v2233.Recents = ModernBuildRecents3
    local v2234 = Query2(v2233)
    v2233 = v2234.Subcategories
    ModernBuildRecents3 = v2234.Objects
    a0.SubCategory = v2234.SubCategory
    local v2238
    for k438, k439 in ipairs(Query) do
        v2234 = a0.CategoryButtons[k438]
        v2234:SetAttribute("Selected", k439 == a0.Category)
        v2238 = v2234
        a0:_styleButton(v2238)
    end

    local v2239 = 1
    local v2240 = 0
    local v2241 = 0
    for k440, k441 in ipairs(v2233) do
        local v2245 = a0:_button(a0.SubList, k441, k441, function() --[[ Upvalues: a0 (copy), k441 (copy) ]]
            a0:_rememberScroll()
            a0.SubCategory = k441
            a0.CategoryMemory[a0.Category] = k441
            a0:Refresh()
        end)
        local v2246 = math.max(44, #k441 * 8 + 18)
        local v2247 = UDim2.fromOffset(v2239, 1)
        v2245.Position = v2247
        v2245.Size = UDim2.fromOffset(v2246, 26)
        v2245:SetAttribute("Selected", k441 == a0.SubCategory)
        a0:_styleButton(v2245)
        if k441 == a0.SubCategory then
            v2240 = v2239
            v2241 = v2246
        end

        v2239 = v2239 + (v2246 + 6)
    end

    a0.SubList.CanvasSize = UDim2.fromOffset(v2239, 0)
    local Offset = a0.SubList.Size.X.Offset
    local v2248 = v2240 + v2241 - Offset
    k441 = 0
    local v2249 = math.clamp(v2248, k441, math.max(0, v2239 - Offset))
    v2248 = 0
    a0.SubList.CanvasPosition = Vector2.new(v2249, v2248)
    for k442, k443 in ipairs(ModernBuildRecents3) do
        local Name5 = k443.Name
        local Info2 = k443.Info
        v2241 = tonumber(BaseItems3[Name5]) or 0
        local v2256 = Info2.Unlock and not UnlockedObjects2[Name5]
        v2239 = not Info2.ItemObject
        if not v2239 then
            v2239 = 0 < v2241
        end

        Offset = Info2.ItemObject
        if not Offset then
            local v2257 = tonumber(Data6.Money) or 0
            Offset = (tonumber(Info2.Price) or 0) <= v2257
        end

        local v2258 = {BackgroundTransparency = 1, BorderSizePixel = 0, Name = Name5}
        local ItemList6 = a0.ItemList
        local Frame22 = Instance.new("Frame")
        for k444, k445 in pairs(v2258) do
            Frame22[k444] = k445
        end

        Frame22.Parent = ItemList6
        Frame22:SetAttribute("ItemName", Name5)
        k444 = function() --[[ Upvalues: a0 (copy), Name5 (copy), Info2 (copy) ]]
            if a0.Callbacks.Select then
                a0.Callbacks.Select(Name5, Info2.Type)
            end

            a0:RefreshSelection()
        end

        local v2262 = a0:_button(Frame22, "Choose", "", k444)
        v2262.Size = UDim2.fromScale(1, 1)
        k444 = v157
        k444 = k444.Muted
        if not (v2256 and k444) then
            k444 = v157
            k444 = k444.Text
        end

        local v2263 = label3(Frame22, "ItemTitle", Name5, 12, k444)
        v2263.TextWrapped = true
        v2263.TextTruncate = Enum.TextTruncate.AtEnd
        v2263.ZIndex = 2
        if v2256 then
            v2263 = "Locked"
        else
            if Info2.ItemObject then
                if 0 < v2241 then
                    v2263 = "Owned \195\151" .. v2241
                    if v2263 then
                        -- jump to 411
                    end
                end

                v2263 = "None owned"
            else
                local v2264 = tostring(Info2.Price or 0)
                local v2265
                if not Offset then
                    v2265 = " \194\183 short"
                else
                    v2265 = ""
                end

                v2263 = "$" .. v2264 .. v2265
            end
        end

        k444 = 11
        if not (not v2256 and v2239 and Offset) then
            k445 = v157
            k445 = k445.Danger
            if k445 then
                -- jump to 426
            end
        end

        k445 = v157
        k445 = k445.Muted
        v2241 = label3(Frame22, "Price", v2263, k444, k445)
        v2241.ZIndex = 2
        k444 = v2232[Name5]
        local v2266
        if k444 then
            v2266 = "\226\152\133"
        else
            v2266 = "\226\152\134"
        end

        k444 = function() --[[ Upvalues: a0 (copy), Name5 (copy) ]]
            local Generation1 = a0.Generation
            if a0.Callbacks.Favorite then
                a0.Callbacks.Favorite(Name5)
            end

            if a0.Generation == Generation1 then
                a0:Refresh()
            end
        end

        local v2267 = a0:_button(Frame22, "Favorite", v2266, k444)
        v2267.ZIndex = 3
        v2267.TextSize = 22
        local v2268
        if not (v2232[Name5] and v157.Accent) then
            v2268 = v157.Text
        end

        v2267.TextColor3 = v2268
        Frame22.MouseEnter:Connect(function() --[[ Upvalues: a0 (copy), Name5 (copy) ]]
            a0.HoverName = Name5
            a0:_updateFooter()
        end)
        Frame22.MouseLeave:Connect(function() --[[ Upvalues: a0 (copy), Name5 (copy) ]]
            if a0.HoverName == Name5 then
                a0.HoverName = nil
                a0:_updateFooter()
            end

        end)
        local v2269 = {Name = Name5}
        a0.ThumbnailItems[Frame22] = v2269
        table.insert(a0.Cards, Frame22)
        a0:_layoutCard(Frame22, k442)
    end

    a0.Count.Text = tostring(#ModernBuildRecents3)
    local v2270 = string.lower(a0.Category)
    a0.Search.PlaceholderText = "Search " .. v2270 .. "\226\128\166"
    local v2271
    if a0.SearchQuery ~= "" then
        v2271 = "No matching objects.\nTry another search or category."
    else
        if a0.Category == "Recent" then
            v2271 = "Objects you choose will appear here."
        else
            if a0.Category == "Favorites" then
                v2271 = "Click \226\152\134 on an object to save it here."
            else
                v2271 = "No objects in this category."
            end
        end
    end

    a0.Empty.Text = v2271
    a0.Empty.Visible = #ModernBuildRecents3 == 0
    local v2272 = a0:_key()
    a0.RenderedKey = v2272
    a0.Dirty = false
    a0.SelectionSignature = nil
    a0.RestoringScroll = false
    a0:_resize()
    a0:RefreshSelection()
end

getLegacyVisibility.Refresh = Refresh1

local function _updateFooter(a0) --[[ Upvalues: v157 (copy) ]]
    local EditObject8 = a0.Client.EditObject
    local HoverName = a0.HoverName
    if not HoverName then
        if EditObject8 then
            local v2273
            if a0.Client.EditingExistingObject then
                v2273 = "Editing \194\183 "
            else
                v2273 = "Selected \194\183 "
            end

            HoverName = v2273 .. EditObject8.Name
            if HoverName then
                -- jump to 23
            end
        end

        HoverName = "Choose an object to build"
    end

    a0.Selection.Text = HoverName
    local v2274
    if not (a0.HoverName and v157.Text) then
        local v2275
        if not (EditObject8 and v157.Accent) then
            v2275 = v157.Muted
        end
    end

    a0.Selection.TextColor3 = v2274
end

getLegacyVisibility._updateFooter = _updateFooter

local function RefreshSelection(a0)
    if a0.Destroyed then
        return
    end

    local EditObject9 = a0.Client.EditObject
    local v2279 = a0.Client.GetClassicDesktopRotateStep and a0.Client:GetClassicDesktopRotateStep() or 90
    local v2281 = tostring(EditObject9 and EditObject9.Name or "")
    local v2282 = tostring(a0.Client.EditingExistingObject ~= nil)
    local v2283 = tostring(a0.Client.ClassicBuildActive == true)
    local v2284 = tostring(a0.Client.DeletingObjects == true)
    local v2285 = v2281 .. ":" .. v2282 .. ":" .. v2283 .. ":" .. v2284 .. ":" .. tostring(v2279)
    if a0.SelectionSignature == v2285 then
        return
    end

    a0.SelectionSignature = v2285
    for k446, k447 in ipairs(a0.Cards) do
        v2285 = k447.Choose
        local v2289 = k447.Name == (EditObject9 and not a0.Client.EditingExistingObject and EditObject9.Name or nil)
        if v2285:GetAttribute("Selected") ~= v2289 then
            v2285:SetAttribute("Selected", v2289)
            a0:_styleButton(v2285)
        end
    end

    a0:_updateFooter()
    a0.ClassicHints.Visible = a0.Client.ClassicBuildActive == true
    a0.ClassicRotateStep.Visible = a0.Client.ClassicBuildActive == true
    a0.ClassicPaint.Visible = a0.Client.ClassicBuildActive == true
    a0.ClassicRotateStep.Text = "Rotation step: " .. v2279 .. "\194\176  [G]"
    local v2290 = a0.Client.DeletingObjects == true
    local v2291
    if v2290 then
        v2291 = "Delete"
    else
        if a0.Client.EditingExistingObject then
            v2291 = "Save move"
        else
            if EditObject9 then
                v2291 = "Place"
            else
                v2291 = "Select object"
            end
        end
    end

    if a0.Client.EditingExistingObject then
        EditObject9 = "Cancel move"
    else
        EditObject9 = "Deselect"
    end

    local v2292
    if v2290 then
        v2292 = "On"
    else
        v2292 = "Off"
    end

    local v2293
    if v2290 then
        v2293 = "   Right click  Delete"
    else
        v2293 = ""
    end

    a0.ClassicHints.Text = "R / T / Y  Rotate " .. v2279 .. "\194\176   E  " .. EditObject9 .. "\nF  Delete mode: " .. v2292 .. "   Left click  " .. v2291 .. "\nHold right mouse  Look around" .. v2293
end

getLegacyVisibility.RefreshSelection = RefreshSelection

local function SetActive4(a0, a1) --[[ Upvalues: UserInputService (copy) ]]
    if a0.Destroyed then
        return
    end

    a1 = a1 == true
    if a0.Active == a1 then
        return
    end

    a0:_rememberScroll()
    a0.Active = a1
    a0.Root.Enabled = a1
    if a1 then
        a0:_resize()
        a0:Refresh()
        a0:RefreshSelection()
        return
    end

    local v2294 = UserInputService:GetFocusedTextBox()
    if v2294 == a0.Search then
        a0.Search:ReleaseFocus()
    end

    a0:_releaseThumbnails()
end

getLegacyVisibility.SetActive = SetActive4

local function SetCollapsed(a0, a1) --[[ Upvalues: UserInputService (copy) ]]
    if a0.Destroyed then
        return
    end

    a1 = a1 == true
    if a0.Collapsed == a1 then
        return
    end

    a0:_rememberScroll()
    a0.Collapsed = a1
    a0.Panel.Visible = not a1
    a0.OpenButton.Visible = a1
    if a1 then
        local v2295 = UserInputService:GetFocusedTextBox()
        if v2295 == a0.Search then
            a0.Search:ReleaseFocus()
        end

        a0:_releaseThumbnails()
    else
        a0:Refresh()
    end

    if a0.Callbacks.Collapsed then
        a0.Callbacks.Collapsed(a1)
    end
end

getLegacyVisibility.SetCollapsed = SetCollapsed

local function IsPointerOver(a0, a1) --[[ Upvalues: UserInputService (copy) ]]
    if not (a0:_allowed() and a0.Root.Enabled) then
        return false
    end

    local v2298 = a1 or UserInputService:GetMouseLocation()
    local v2299 = v2298 + a0.Root.AbsolutePosition
    local AbsolutePosition1 = (a0.Collapsed and a0.OpenButton or a0.Panel).AbsolutePosition
    local AbsoluteSize4 = (a0.Collapsed and a0.OpenButton or a0.Panel).AbsoluteSize
    v2298 = (a0.Collapsed and a0.OpenButton or a0.Panel).Visible
    if v2298 then
        v2298 = false
        if AbsolutePosition1.X <= v2299.X then
            v2298 = false
            if AbsolutePosition1.Y <= v2299.Y then
                v2298 = false
                if v2299.X < AbsolutePosition1.X + AbsoluteSize4.X then
                    v2298 = v2299.Y < AbsolutePosition1.Y + AbsoluteSize4.Y
                end
            end
        end
    end

    if not v2298 then
        local ClassicRotateStep = a0.ClassicRotateStep
        AbsolutePosition1 = ClassicRotateStep.AbsolutePosition
        AbsoluteSize4 = ClassicRotateStep.AbsoluteSize
        v2298 = ClassicRotateStep.Visible
        if v2298 then
            v2298 = false
            if AbsolutePosition1.X <= v2299.X then
                v2298 = false
                if AbsolutePosition1.Y <= v2299.Y then
                    v2298 = false
                    if v2299.X < AbsolutePosition1.X + AbsoluteSize4.X then
                        v2298 = v2299.Y < AbsolutePosition1.Y + AbsoluteSize4.Y
                    end
                end
            end
        end

        if not v2298 then
            ClassicRotateStep = a0.ClassicPaint
            AbsolutePosition1 = ClassicRotateStep.AbsolutePosition
            AbsoluteSize4 = ClassicRotateStep.AbsoluteSize
            v2298 = ClassicRotateStep.Visible
            if v2298 then
                v2298 = false
                if AbsolutePosition1.X <= v2299.X then
                    v2298 = false
                    if AbsolutePosition1.Y <= v2299.Y then
                        v2298 = false
                        if v2299.X < AbsolutePosition1.X + AbsoluteSize4.X then
                            v2298 = v2299.Y < AbsolutePosition1.Y + AbsoluteSize4.Y
                        end
                    end
                end
            end
        end
    end

    return v2298
end

getLegacyVisibility.IsPointerOver = IsPointerOver

local function Destroy6(a0)
    if a0.Destroyed then
        return
    end

    a0:SetActive(false)
    a0.Destroyed = true
    a0.Generation = a0.Generation + 1
    for k448, k449 in ipairs(a0.Connections) do
        k449:Disconnect()
    end

    table.clear(a0.Connections)
    a0.Root:Destroy()
    table.clear(a0.Cards)
    table.clear(a0.ThumbnailItems)
end

getLegacyVisibility.Destroy = Destroy6
Recents.Desktop = getLegacyVisibility
return v50
