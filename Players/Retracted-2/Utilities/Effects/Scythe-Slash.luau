-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("TweenService")
game:GetService("Players")

local Objects, _ = ReplicatedStorage.Objects, ReplicatedStorage.Animations

return function(p1) -- line: 8
    -- upvalues: Objects (copy)
    local clone = Objects.ScytheSlash:Clone()

    clone.CFrame = p1.Origin * CFrame.new(0, 0, -2)
    clone.Parent = workspace.CurrentCamera
    _G.Utl.PlaySound({
        Sound = "Slash2",
        Pos = 0.15,
        Origin = clone,
        Speed = 1.25 + math.random() * 0.1
    })

    for _, child in pairs(clone.Slash:GetChildren()) do
        if child:GetAttribute("EmitCount") then
            child:Emit(child:GetAttribute("EmitCount"))
        end
    end

    game.Debris:AddItem(clone, 1.5)
end
