
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Objects = ReplicatedStorage.Objects
return function(a0) --[[ Upvalues: Objects (copy) ]]
    local v1 = Objects.ScytheSlash:Clone()
    v1.CFrame = a0.Origin * CFrame.new(0, 0, -2)
    v1.Parent = workspace.CurrentCamera
    local v2 = {Sound = "Slash2", Pos = 0.15, Origin = v1, Speed = 1.25 + math.random() * 0.1}
    _G.Utl.PlaySound(v2)
    local v3 = v1.Slash:GetChildren()
    for k1, k2 in pairs(v3) do
        if k2:GetAttribute("EmitCount") then
            local v7 = k2:GetAttribute("EmitCount")
            k2:Emit(v7)
        end
    end

    game.Debris:AddItem(v1, 1.5)
end
