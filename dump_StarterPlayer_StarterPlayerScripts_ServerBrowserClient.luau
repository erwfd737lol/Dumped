-- decompiled by Velocity decompiler v1.0.3

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HUD = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD")
local Menu = HUD:WaitForChild("Menu")
local ServerBrowser = HUD:WaitForChild("ServerBrowser")
local Main = Menu:WaitForChild("Main")
local Servers = Main:WaitForChild("Servers")
local ServerBrowserRemotes = ReplicatedStorage:WaitForChild("ServerBrowserRemotes")
ReplicatedStorage = ServerBrowserRemotes:WaitForChild("Request")
local Push = ServerBrowserRemotes:WaitForChild("Push")
local Search = ServerBrowser.Controls.Search
local RegionFilter = ServerBrowser.Controls.RegionFilter
local Refresh = ServerBrowser.Controls.Refresh
local RegionMenu = ServerBrowser.RegionMenu
local List = ServerBrowser.List
local Template = List.Template
local Status = ServerBrowser.Status
local CurrentServer = ServerBrowser.CurrentServer
local t1 = {
    Text = Color3.fromRGB(244, 247, 255),
    Muted = Color3.fromRGB(200, 197, 176),
    Accent = Color3.fromRGB(77, 197, 255),
    Green = Color3.fromRGB(75, 215, 133),
    Red = Color3.fromRGB(242, 91, 91),
    Card = Color3.fromRGB(0, 0, 0),
    CardHover = Color3.fromRGB(40, 40, 40),
    Border = Color3.fromRGB(200, 197, 176)
}
local v1 = {}
local v2 = "All Regions"
local v3 = ""
local v4 = false
local v5 = nil

local function lower(a0)
    local v6 = string.lower(tostring(a0 or ""))
    return v6
end

local function setStatus(a0, a1) --[[ Upvalues: Status (copy), t1 (copy) ]]
    Status.Text = a0
    local v7
    if not (a1 and t1.Red) then
        v7 = t1.Muted
    end

    Status.TextColor3 = v7
end

local function clearCards() --[[ Upvalues: List (copy), Template (copy) ]]
    local v8 = List:GetChildren()
    for k1, k2 in ipairs(v8) do
        if k2:IsA("Frame") and k2 ~= Template then
            k2:Destroy()
        end
    end
end

local function addHeadshot(a0, a1, a2) --[[ Upvalues: t1 (copy) ]]
    local ImageLabel = Instance.new("ImageLabel")
    local name = a1.name
    if not name then
        name = "Player" .. tostring(a2)
    end

    ImageLabel.Name = name
    ImageLabel.LayoutOrder = a2
    ImageLabel.Size = UDim2.fromOffset(40, 40)
    ImageLabel.BackgroundColor3 = t1.Card
    ImageLabel.BackgroundTransparency = 0.5
    ImageLabel.BorderColor3 = t1.Border
    ImageLabel.BorderSizePixel = 1
    ImageLabel.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=100&h=100", tonumber(a1.userId) or 0)
    ImageLabel.ZIndex = 35
    ImageLabel.Parent = a0
end

local function addPlayerOverflow(a0, a1, a2) --[[ Upvalues: t1 (copy) ]]
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "MorePlayers"
    TextLabel.LayoutOrder = a2
    TextLabel.Size = UDim2.fromOffset(40, 40)
    TextLabel.BackgroundColor3 = t1.Card
    TextLabel.BackgroundTransparency = 0.5
    TextLabel.BorderColor3 = t1.Border
    TextLabel.BorderSizePixel = 1
    TextLabel.Text = "+" .. tostring(a1)
    TextLabel.Font = Enum.Font.Code
    TextLabel.TextSize = 13
    TextLabel.TextColor3 = t1.Text
    TextLabel.ZIndex = 35
    TextLabel.Parent = a0
end

local function addEmptyPlayerLabel(a0) --[[ Upvalues: t1 (copy) ]]
    local TextLabel1 = Instance.new("TextLabel")
    TextLabel1.Name = "EmptyServer"
    TextLabel1.Size = UDim2.new(1, 0, 1, 0)
    TextLabel1.BackgroundTransparency = 1
    TextLabel1.Text = "No players yet"
    TextLabel1.Font = Enum.Font.Code
    TextLabel1.TextSize = 13
    TextLabel1.TextColor3 = t1.Muted
    TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel1.ZIndex = 35
    TextLabel1.Parent = a0
end

local function matchesFilters(a0) --[[ Upvalues: v2 (ref), Search (copy) ]]
    if v2 ~= "All Regions" then
        local v12 = tostring(a0.region)
        if v12 ~= v2 then
            return false
        end
    end

    local v13 = string.lower(tostring(Search.Text or ""))
    if v13 == "" then
        return true
    end

    local v14 = true
    local v15 = string.lower(tostring(a0.name or ""))
    if string.find(v15, v13, 1, true) == nil then
        v14 = true
        v15 = string.lower(tostring(a0.code or ""))
        if string.find(v15, v13, 1, true) == nil then
            v14 = true
            v15 = string.lower(tostring(a0.jobId or ""))
            if string.find(v15, v13, 1, true) == nil then
                v15 = string.lower(tostring(a0.region or ""))
                v14 = string.find(v15, v13, 1, true) ~= nil
            end
        end
    end

    return v14
end

local Empty = ServerBrowser.Empty

local function renderServers() --[[ Upvalues: clearCards (copy), v1 (ref), matchesFilters (copy), Template (copy), addEmptyPlayerLabel (copy), addHeadshot (copy), addPlayerOverflow (copy), v3 (ref), t1 (copy), v5 (ref), v4 (ref), renderServers (copy), Status (copy), ReplicatedStorage (copy), TweenService (copy), List (copy), Empty (copy) ]]
    clearCards()
    local v16 = 0
    local v18
    if (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 1000) < 700 then
        v18 = 4
    else
        v18 = 6
    end

    for k3, k4 in ipairs(v1) do
        if matchesFilters(k4) then
            v16 = v16 + 1
            local v22 = Template:Clone()
            v22.Name = "Server_" .. tostring(k4.code or k3)
            v22.LayoutOrder = k3
            v22.Visible = true
            v22:SetAttribute("JobId", k4.jobId)
            v22.ServerName.Text = tostring(k4.name or "Unnamed Server")
            local Code = v22.Code
            local v24 = k4.code or k4.jobId or "Unknown"
            Code.Text = tostring(v24)
            v22.Region.Text = tostring(k4.region or "Unknown")
            local v25 = tonumber(k4.playing) or 0
            local v26 = tonumber(k4.maxPlayers) or 0
            v22.Count.Text = string.format("%d / %d PLAYERS", v25, v26)
            local v27
            if not (type(k4.players) == "table" and k4.players) then
                v27 = {}
            end

            if #v27 == 0 then
                addEmptyPlayerLabel(v22.Players)
            else
                for i1 = 1, math.min(#v27, v18) do
                    addHeadshot(v22.Players, v27[i1], i1)
                end

                if v18 < #v27 then
                    i1 = #v27 - v18
                    addPlayerOverflow(v22.Players, i1, v18 + 1)
                end
            end

            v27 = v22.Join
            local v30 = false
            if 0 < v26 then
                v30 = v26 <= v25
            end

            if k4.jobId == v3 then
                v22.Accent.BackgroundColor3 = t1.Accent
                v27.Text = "CURRENT"
                v27.BackgroundColor3 = t1.Card
                v27.TextColor3 = t1.Muted
                v27.Active = false
                v27.AutoButtonColor = false
            else
                if v30 then
                    v22.Accent.BackgroundColor3 = t1.Red
                    v27.Text = "FULL"
                    v27.BackgroundColor3 = t1.Card
                    v27.TextColor3 = t1.Red
                    v27.Active = false
                    v27.AutoButtonColor = false
                else
                    if v5 == k4.jobId then
                        v27.Text = "JOINING..."
                        v27.BackgroundColor3 = t1.Card
                        v27.TextColor3 = t1.Accent
                        v27.Active = false
                        v27.AutoButtonColor = false
                    else
                        v27.BackgroundColor3 = t1.Card
                        v27.TextColor3 = t1.Green
                        v27.MouseButton1Click:Connect(function() --[[ Upvalues: v5 (upvalue), v4 (upvalue), k4 (copy), renderServers (upvalue), Status (upvalue), t1 (upvalue), ReplicatedStorage (upvalue) ]]
                            if v5 or v4 then
                                return
                            end

                            v5 = k4.jobId
                            renderServers()
                            local v31 = tostring(k4.name)
                            local v32 = "Checking " .. v31 .. "..."
                            Status.Text = v32
                            Status.TextColor3 = t1.Muted
                            task.spawn(function() --[[ Upvalues: ReplicatedStorage (upvalue), k4 (upvalue), v5 (upvalue), Status (upvalue), t1 (upvalue), renderServers (upvalue) ]]
                                local v35, v36 = pcall(function() --[[ Upvalues: ReplicatedStorage (upvalue), k4 (upvalue) ]]
                                    local v33 = {jobId = k4.jobId}
                                    local v34 = ReplicatedStorage:InvokeServer("Join", v33)
                                    return v34
                                end)
                                if not v35 then
                                    v5 = nil
                                    Status.Text = "The server switch request failed. Please try again."
                                    local v37 = t1.Red or t1.Muted
                                    Status.TextColor3 = v37
                                    renderServers()
                                    return
                                end

                                if not (type(v36) == "table" and v36.ok) then
                                    v5 = nil
                                    local v39 = type(v36) == "table" and v36.message or "The server switch failed."
                                    Status.Text = v39
                                    local v40 = t1.Red or t1.Muted
                                    Status.TextColor3 = v40
                                    renderServers()
                                    return
                                end

                                local v41 = tostring(k4.name)
                                local v42 = "Teleporting to " .. v41 .. "..."
                                Status.Text = v42
                                Status.TextColor3 = t1.Muted
                            end)
                        end)
                    end
                end
            end

            v22.MouseEnter:Connect(function() --[[ Upvalues: TweenService (upvalue), v22 (copy), t1 (upvalue) ]]
                local v43 = TweenInfo.new(0.12)
                local v44 = {BackgroundColor3 = t1.CardHover}
                TweenService:Create(v22, v43, v44):Play()
            end)
            v22.MouseLeave:Connect(function() --[[ Upvalues: TweenService (upvalue), v22 (copy), t1 (upvalue) ]]
                local v45 = TweenInfo.new(0.12)
                local v46 = {BackgroundColor3 = t1.Card}
                TweenService:Create(v22, v45, v46):Play()
            end)
            v22.Parent = List
        end
    end

    Empty.Visible = v16 == 0
    if v16 == 0 then
        if #v1 == 0 then
            Empty.Text = "No active public servers were found."
        else
            Empty.Text = "No servers match these filters."
        end
    end

    if v16 == 1 then
        k3 = ""
    else
        k3 = "s"
    end

    local v47 = string.format("%d server%s shown", v16, k3)
    Status.Text = v47
    Status.TextColor3 = t1.Muted
end

local function rebuildRegionMenu() --[[ Upvalues: RegionMenu (copy), v1 (ref), v2 (ref), t1 (copy), RegionFilter (copy), rebuildRegionMenu (copy), renderServers (copy) ]]
    local v48 = RegionMenu:GetChildren()
    for k5, k6 in ipairs(v48) do
        k6:Destroy()
        local v55 = k6:IsA("TextButton") and k6:Destroy()
    end

    local v56 = {}
    for k7, k8 in ipairs(v1) do
        local v60 = tostring(k8.region or "Unknown")
        v56[v60] = true
    end

    local v61 = {}
    for k9 in pairs(v56) do
        table.insert(v61, k9)
    end

    table.sort(v61)
    if v2 ~= "All Regions" and not v56[v2] then
        v2 = "All Regions"
    end

    v56 = {"All Regions"}
    for k10, k11 in ipairs(v61) do
        table.insert(v56, k11)
    end

    for k12, k13 in ipairs(v56) do
        v61 = Instance.new("TextButton")
        v61.Name = "Region_" .. tostring(k12)
        v61.LayoutOrder = k12
        v61.Size = UDim2.new(1, 0, 0, 32)
        v61.BackgroundColor3 = t1.Card
        v61.BackgroundTransparency = 0.5
        v61.BorderColor3 = t1.Border
        v61.BorderSizePixel = 1
        v61.Text = k13
        v61.Font = Enum.Font.Code
        v61.TextSize = 13
        local v71
        if not (k13 == v2 and t1.Accent) then
            v71 = t1.Text
        end

        v61.TextColor3 = v71
        v61.TextTruncate = Enum.TextTruncate.AtEnd
        v61.ZIndex = 61
        v61.Parent = RegionMenu
        v61.MouseButton1Click:Connect(function() --[[ Upvalues: v2 (upvalue), k13 (copy), RegionFilter (upvalue), RegionMenu (upvalue), rebuildRegionMenu (upvalue), renderServers (upvalue) ]]
            v2 = k13
            RegionFilter.Text = k13 .. "  \226\150\190"
            RegionMenu.Visible = false
            rebuildRegionMenu()
            renderServers()
        end)
    end

    RegionFilter.Text = v2 .. "  \226\150\190"
end

local function requestServers(a0) --[[ Upvalues: v4 (ref), Refresh (copy), Status (copy), t1 (copy), ReplicatedStorage (copy), ServerBrowser (copy), RegionMenu (copy), Menu (copy), v1 (ref), v3 (ref), CurrentServer (copy), rebuildRegionMenu (copy), renderServers (copy) ]]
    if v4 then
        return
    end

    v4 = true
    Refresh.Text = "..."
    Status.Text = "Finding active servers..."
    Status.TextColor3 = t1.Muted
    task.spawn(function() --[[ Upvalues: ReplicatedStorage (upvalue), v4 (upvalue), Refresh (upvalue), Status (upvalue), t1 (upvalue), ServerBrowser (upvalue), RegionMenu (upvalue), Menu (upvalue), v1 (upvalue), v3 (upvalue), CurrentServer (upvalue), rebuildRegionMenu (upvalue), renderServers (upvalue), a0 (copy) ]]
        local v73, v74 = pcall(function() --[[ Upvalues: ReplicatedStorage (upvalue) ]]
            local v72 = ReplicatedStorage:InvokeServer("List")
            return v72
        end)
        v4 = false
        Refresh.Text = "REFRESH"
        if not v73 then
            Status.Text = "Could not load servers. Please try again."
            local v75 = t1.Red or t1.Muted
            Status.TextColor3 = v75
            return
        end

        if not (type(v74) == "table" and v74.ok) then
            local v77 = type(v74) == "table" and v74.message or "Could not load servers."
            Status.Text = v77
            local v78 = t1.Red or t1.Muted
            Status.TextColor3 = v78
            if type(v74) == "table" and v74.code == "IN_COMBAT" then
                ServerBrowser.Visible = false
                RegionMenu.Visible = false
                Menu.Visible = true
            end

            return
        end

        local v79
        if not (type(v74.servers) == "table" and v74.servers) then
            v79 = {}
        end

        v1 = v79
        v3 = tostring(v74.currentJobId or "")
        local v80 = tostring(v74.currentName or "Unknown")
        CurrentServer.Text = string.format("Current server: %s  \226\128\162  %s", v80, tostring(v74.currentCode or "Unknown"))
        rebuildRegionMenu()
        renderServers()
        if a0 then
            ServerBrowser.Visible = true
            Menu.Visible = false
        end

    end)
end

local function closeBrowser() --[[ Upvalues: ServerBrowser (copy), RegionMenu (copy), Menu (copy) ]]
    ServerBrowser.Visible = false
    RegionMenu.Visible = false
    Menu.Visible = true
end

Servers.MouseButton1Click:Connect(function() --[[ Upvalues: v4 (ref), Refresh (copy), Status (copy), t1 (copy), ReplicatedStorage (copy), ServerBrowser (copy), RegionMenu (copy), Menu (copy), v1 (ref), v3 (ref), CurrentServer (copy), rebuildRegionMenu (copy), renderServers (copy) ]]
    if v4 then
        return
    end

    v4 = true
    Refresh.Text = "..."
    Status.Text = "Finding active servers..."
    Status.TextColor3 = t1.Muted
    local v81 = true
    task.spawn(function() --[[ Upvalues: ReplicatedStorage (upvalue), v4 (upvalue), Refresh (upvalue), Status (upvalue), t1 (upvalue), ServerBrowser (upvalue), RegionMenu (upvalue), Menu (upvalue), v1 (upvalue), v3 (upvalue), CurrentServer (upvalue), rebuildRegionMenu (upvalue), renderServers (upvalue), v81 (copy) ]]
        local v83, v84 = pcall(function() --[[ Upvalues: ReplicatedStorage (upvalue) ]]
            local v82 = ReplicatedStorage:InvokeServer("List")
            return v82
        end)
        v4 = false
        Refresh.Text = "REFRESH"
        if not v83 then
            Status.Text = "Could not load servers. Please try again."
            local v85 = t1.Red or t1.Muted
            Status.TextColor3 = v85
            return
        end

        if not (type(v84) == "table" and v84.ok) then
            local v87 = type(v84) == "table" and v84.message or "Could not load servers."
            Status.Text = v87
            local v88 = t1.Red or t1.Muted
            Status.TextColor3 = v88
            if type(v84) == "table" and v84.code == "IN_COMBAT" then
                ServerBrowser.Visible = false
                RegionMenu.Visible = false
                Menu.Visible = true
            end

            return
        end

        local v89
        if not (type(v84.servers) == "table" and v84.servers) then
            v89 = {}
        end

        v1 = v89
        v3 = tostring(v84.currentJobId or "")
        local v90 = tostring(v84.currentName or "Unknown")
        CurrentServer.Text = string.format("Current server: %s  \226\128\162  %s", v90, tostring(v84.currentCode or "Unknown"))
        rebuildRegionMenu()
        renderServers()
        if v81 then
            ServerBrowser.Visible = true
            Menu.Visible = false
        end

    end)
end)
ServerBrowser.Close.MouseButton1Click:Connect(closeBrowser)
Refresh.MouseButton1Click:Connect(function() --[[ Upvalues: v4 (ref), Refresh (copy), Status (copy), t1 (copy), ReplicatedStorage (copy), ServerBrowser (copy), RegionMenu (copy), Menu (copy), v1 (ref), v3 (ref), CurrentServer (copy), rebuildRegionMenu (copy), renderServers (copy) ]]
    if v4 then
        return
    end

    v4 = true
    Refresh.Text = "..."
    Status.Text = "Finding active servers..."
    Status.TextColor3 = t1.Muted
    local v91 = false
    task.spawn(function() --[[ Upvalues: ReplicatedStorage (upvalue), v4 (upvalue), Refresh (upvalue), Status (upvalue), t1 (upvalue), ServerBrowser (upvalue), RegionMenu (upvalue), Menu (upvalue), v1 (upvalue), v3 (upvalue), CurrentServer (upvalue), rebuildRegionMenu (upvalue), renderServers (upvalue), v91 (copy) ]]
        local v93, v94 = pcall(function() --[[ Upvalues: ReplicatedStorage (upvalue) ]]
            local v92 = ReplicatedStorage:InvokeServer("List")
            return v92
        end)
        v4 = false
        Refresh.Text = "REFRESH"
        if not v93 then
            Status.Text = "Could not load servers. Please try again."
            local v95 = t1.Red or t1.Muted
            Status.TextColor3 = v95
            return
        end

        if not (type(v94) == "table" and v94.ok) then
            local v97 = type(v94) == "table" and v94.message or "Could not load servers."
            Status.Text = v97
            local v98 = t1.Red or t1.Muted
            Status.TextColor3 = v98
            if type(v94) == "table" and v94.code == "IN_COMBAT" then
                ServerBrowser.Visible = false
                RegionMenu.Visible = false
                Menu.Visible = true
            end

            return
        end

        local v99
        if not (type(v94.servers) == "table" and v94.servers) then
            v99 = {}
        end

        v1 = v99
        v3 = tostring(v94.currentJobId or "")
        local v100 = tostring(v94.currentName or "Unknown")
        CurrentServer.Text = string.format("Current server: %s  \226\128\162  %s", v100, tostring(v94.currentCode or "Unknown"))
        rebuildRegionMenu()
        renderServers()
        if v91 then
            ServerBrowser.Visible = true
            Menu.Visible = false
        end

    end)
end)
RegionFilter.MouseButton1Click:Connect(function() --[[ Upvalues: RegionMenu (copy) ]]
    RegionMenu.Visible = not RegionMenu.Visible
end)
local v101 = Search:GetPropertyChangedSignal("Text")
v101:Connect(function() --[[ Upvalues: renderServers (copy) ]]
    renderServers()
end)
Push.OnClientEvent:Connect(function(a0) --[[ Upvalues: v5 (ref), v1 (ref), Status (copy), t1 (copy), renderServers (copy) ]]
    if type(a0) ~= "table" or a0.kind ~= "Error" then
        return
    end

    local v102 = v5
    v5 = nil
    if a0.code == "SERVER_FULL" and v102 then
        for k14, k15 in ipairs(v1) do
            if k15.jobId == v102 then
                k15.playing = k15.maxPlayers
                break
            end
        end
    end

    local v106 = tostring(a0.message or "The server request failed.")
    Status.Text = v106
    local v107 = t1.Red or t1.Muted
    Status.TextColor3 = v107
    renderServers()
end)
local v108 = HUD.InCombat:GetPropertyChangedSignal("Visible")
v108:Connect(function() --[[ Upvalues: HUD (copy), ServerBrowser (copy), RegionMenu (copy), Menu (copy) ]]
    if HUD.InCombat.Visible and ServerBrowser.Visible then
        ServerBrowser.Visible = false
        RegionMenu.Visible = false
        Menu.Visible = true
    end

end)
UserInputService.InputBegan:Connect(function(a0, a1) --[[ Upvalues: ServerBrowser (copy), RegionMenu (copy), Menu (copy) ]]
    if a1 then
        return
    end

    if a0.KeyCode == Enum.KeyCode.Escape and ServerBrowser.Visible then
        ServerBrowser.Visible = false
        RegionMenu.Visible = false
        Menu.Visible = true
    end

end)

local function updateResponsiveSize() --[[ Upvalues: ServerBrowser (copy) ]]
    local CurrentCamera = workspace.CurrentCamera
    if not CurrentCamera then
        return
    end

    if CurrentCamera.ViewportSize.X < 700 then
        ServerBrowser.Size = UDim2.fromScale(0.94, 0.84)
        ServerBrowser.Title.TextSize = 18
        return
    end

    ServerBrowser.Size = UDim2.fromScale(0.76, 0.78)
    ServerBrowser.Title.TextSize = 22
end

updateResponsiveSize()
if workspace.CurrentCamera then
    local v109 = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize")
    v109:Connect(updateResponsiveSize)
end

task.spawn(function() --[[ Upvalues: ServerBrowser (copy), v4 (ref), v5 (ref), Refresh (copy), Status (copy), t1 (copy), ReplicatedStorage (copy), RegionMenu (copy), Menu (copy), v1 (ref), v3 (ref), CurrentServer (copy), rebuildRegionMenu (copy), renderServers (copy) ]]
    while true do
        task.wait(20)
        if ServerBrowser.Visible then
            if not v4 then
                if not v5 then
                    if v4 then
                    else
                        v4 = true
                        Refresh.Text = "..."
                        Status.Text = "Finding active servers..."
                        Status.TextColor3 = t1.Muted
                        local v110 = false
                        task.spawn(function() --[[ Upvalues: ReplicatedStorage (upvalue), v4 (upvalue), Refresh (upvalue), Status (upvalue), t1 (upvalue), ServerBrowser (upvalue), RegionMenu (upvalue), Menu (upvalue), v1 (upvalue), v3 (upvalue), CurrentServer (upvalue), rebuildRegionMenu (upvalue), renderServers (upvalue), v110 (copy) ]]
                            local v112, v113 = pcall(function() --[[ Upvalues: ReplicatedStorage (upvalue) ]]
                                local v111 = ReplicatedStorage:InvokeServer("List")
                                return v111
                            end)
                            v4 = false
                            Refresh.Text = "REFRESH"
                            if not v112 then
                                Status.Text = "Could not load servers. Please try again."
                                local v114 = t1.Red or t1.Muted
                                Status.TextColor3 = v114
                                return
                            end

                            if not (type(v113) == "table" and v113.ok) then
                                local v116 = type(v113) == "table" and v113.message or "Could not load servers."
                                Status.Text = v116
                                local v117 = t1.Red or t1.Muted
                                Status.TextColor3 = v117
                                if type(v113) == "table" and v113.code == "IN_COMBAT" then
                                    ServerBrowser.Visible = false
                                    RegionMenu.Visible = false
                                    Menu.Visible = true
                                end

                                return
                            end

                            local v118
                            if not (type(v113.servers) == "table" and v113.servers) then
                                v118 = {}
                            end

                            v1 = v118
                            v3 = tostring(v113.currentJobId or "")
                            local v119 = tostring(v113.currentName or "Unknown")
                            CurrentServer.Text = string.format("Current server: %s  \226\128\162  %s", v119, tostring(v113.currentCode or "Unknown"))
                            rebuildRegionMenu()
                            renderServers()
                            if v110 then
                                ServerBrowser.Visible = true
                                Menu.Visible = false
                            end

                        end)
                    end
                end
            end
        end
    end

end)
