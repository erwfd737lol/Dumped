
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animations = ReplicatedStorage.Animations
local t1 = {Common = 100, Rare = 1000, Epic = 10000, Legendary = 50000}
local t2 = {
    ["Painted Red"] = {Rarity = "Common"},
    ["Painted Blue"] = {Rarity = "Common"},
    ["Painted Yellow"] = {Rarity = "Common"},
    ["Painted Orange"] = {Rarity = "Common"},
    ["Painted Green"] = {Rarity = "Common"},
    ["Painted Pink"] = {Rarity = "Common"},
    ["Painted Purple"] = {Rarity = "Common"},
    Damaged = {Rarity = "Common"},
    Earth = {Rarity = "Common"},
    ["Rusted Red"] = {Rarity = "Rare"},
    Checkered = {Rarity = "Rare"},
    ["Green Camo"] = {Rarity = "Rare"},
    ["Grey Camo"] = {Rarity = "Rare"},
    ["Orange Crush"] = {Rarity = "Rare"},
    ["Purple Vibe"] = {Rarity = "Rare", Prem = true, Effect = "PurpleVibe"},
    Royal = {Rarity = "Epic"},
    Agent = {Rarity = "Epic"},
    ["Fallen Agent"] = {Rarity = "Epic"},
    ["Hot Pink"] = {Rarity = "Epic"},
    Glacier = {Rarity = "Legendary", Effect = "GlacierBullet"},
    ["Crimson Red"] = {Rarity = "Legendary", Effect = "CrimsonBullet"},
    Golden = {Rarity = "Legendary", Effect = "GoldenBullet"},
    Nebula = {Rarity = "Legendary", Effect = "NebulaBullet"},
    Menace = {Rarity = "Legendary", Effect = "MenaceBullet"},
    ["Green Thumb"] = {Rarity = "Legendary", Effect = "GreenThumb"},
    Flame = {Rarity = "Legendary", Effect = "FlameBullet"},
    Danger = {Rarity = "Legendary", Pack = true, Effect = "Danger"},
    Meow = {Rarity = "Legendary", Pack = true, Effect = "MeowBullet", SellPrice = 20000},
    ["Halloween 2023"] = {Rarity = "Legendary", Effect = "Halloween", SellPrice = 15000},
    ["Halloween 2026"] = {Rarity = "Legendary", Effect = "Halloween", SellPrice = 15000},
    ["Summer 2026"] = {Rarity = "Legendary", Effect = "Summer2026", SellPrice = 15000},
    Banana = {Rarity = "Common"},
    ["Red Spider"] = {Rarity = "Epic"},
    ["Black Spider"] = {Rarity = "Legendary", Effect = "BlackSpiderBullet"},
    Rainbow = {Rarity = "Rare"},
    Heart = {Rarity = "Epic"},
    Khongumu = {Rarity = "Common"}
}
local v1 = CFrame.new(-2.25, 0.7, 0.5)
local v2 = {
    Rarity = "Legendary",
    AnimFolder = Animations.Karambit,
    ViewportOffset = v1 * CFrame.Angles(0.52359877559829882, -1.5707963267948966, 0)
}
local v3 = CFrame.new(-1.75, 0.2, 1.1)
v2 = {
    Rarity = "Legendary",
    ViewportOffset = v3 * CFrame.Angles(0.78539816339744828, -1.5707963267948966, 0)
}
local v4 = CFrame.new(-2.25, 0.7, 0.5)
v2 = {
    Rarity = "Legendary",
    AnimFolder = Animations.Karambit,
    ViewportOffset = v4 * CFrame.Angles(0.52359877559829882, -1.5707963267948966, 0)
}
local v5 = CFrame.new(-2.25, 0.7, 0.5)
v2 = {
    Rarity = "Legendary",
    Prem = true,
    AnimFolder = Animations.Karambit,
    ViewportOffset = v5 * CFrame.Angles(0.52359877559829882, -1.5707963267948966, 0)
}
local v6 = CFrame.new(-2, 0.3, 1.5)
v2 = {
    Rarity = "Legendary",
    Prem = true,
    ViewportOffset = v6 * CFrame.Angles(0.78539816339744828, -1.5707963267948966, 0)
}
local v7 = CFrame.new(-2.25, 0.7, 0.5)
v2 = {
    Rarity = "Legendary",
    AnimFolder = Animations.Karambit,
    ViewportOffset = v7 * CFrame.Angles(0.52359877559829882, -1.5707963267948966, 0)
}
local v8 = CFrame.new(-2.25, 0.7, 0.5)
v2 = {
    Rarity = "Legendary",
    AnimFolder = Animations.Karambit,
    ViewportOffset = v8 * CFrame.Angles(0.52359877559829882, -1.5707963267948966, 0)
}
local v9 = CFrame.new(-2.25, 0.7, 0.5)
v2 = {
    Rarity = "Legendary",
    Pack = true,
    AnimFolder = Animations.Karambit,
    ViewportOffset = v9 * CFrame.Angles(0.52359877559829882, -1.5707963267948966, 0)
}
local v10 = CFrame.new(-2, 0.15, 1.2)
v2 = {
    Rarity = "Legendary",
    ViewportOffset = v10 * CFrame.Angles(0.78539816339744828, -1.5707963267948966, 0)
}
local v11 = CFrame.new(-2, 0.15, 1.2)
v2 = {
    Rarity = "Legendary",
    ViewportOffset = v11 * CFrame.Angles(0.78539816339744828, -1.5707963267948966, 0)
}
local v12 = CFrame.new(-1.9, 0.2, 1.2)
v2 = {
    Rarity = "Legendary",
    ViewportOffset = v12 * CFrame.Angles(0.78539816339744828, -1.5707963267948966, 0)
}
local v13 = CFrame.new(-1.9, 0.2, 1.2)
v2 = {
    Rarity = "Legendary",
    ViewportOffset = v13 * CFrame.Angles(0.78539816339744828, -1.5707963267948966, 0)
}
local v14 = CFrame.new(-1.75, 0.2, 1)
v2 = {
    Rarity = "Legendary",
    ViewportOffset = v14 * CFrame.Angles(0.78539816339744828, -1.5707963267948966, 0)
}
local v15 = CFrame.new(-1.75, 0.2, 1)
v2 = {
    Rarity = "Legendary",
    ViewportOffset = v15 * CFrame.Angles(0.78539816339744828, -1.5707963267948966, 0)
}
local v16 = CFrame.new(-2.15, 0, 1)
v2 = {
    Rarity = "Legendary",
    SellPrice = 0,
    ViewportOffset = v16 * CFrame.Angles(0.78539816339744828, -1.5707963267948966, 0)
}
local v17 = CFrame.new(-2, 0.3, 1.5)
v2 = {
    Rarity = "Legendary",
    AnimFolder = Animations.MegalodonKnife,
    ViewportOffset = v17 * CFrame.Angles(0.78539816339744828, -1.5707963267948966, 0)
}
t2 = {
    ["Pumpkin Karambit"] = v2,
    Inferno = v2,
    ["Neon Karambit"] = v2,
    ["Mystic Karambit"] = v2,
    ["Pink Tanto"] = v2,
    ["Verdant Karambit"] = v2,
    ["Banana Karambit"] = v2,
    ["Danger Karambit"] = v2,
    ["Golden Cross"] = v2,
    ["White Cross"] = v2,
    Toxic = v2,
    Violent = v2,
    Glacier = v2,
    Void = v2,
    ["Green Dagger"] = v2,
    Megalodon = v2
}
local t3 = {
    ["Painted Pink"] = {Rarity = "Common"},
    ["Painted Red"] = {Rarity = "Common"},
    ["Painted Orange"] = {Rarity = "Common"},
    ["Painted Blue"] = {Rarity = "Common"},
    ["Painted Purple"] = {Rarity = "Common"},
    ["Painted Green"] = {Rarity = "Common"},
    ["Painted Yellow"] = {Rarity = "Common"},
    ["Red Sentry"] = {Rarity = "Rare"},
    ["Green Sentry"] = {Rarity = "Rare"},
    ["Pink Sentry"] = {Rarity = "Rare"}
}
local v18 = {
    SellPrice = t1,
    Packs = {Danger = 1647311433, Meow = 1875336233},
    Guns = t2,
    Knife = t2,
    Revolver = {},
    SMG = {},
    AK47 = {},
    LMG = {},
    Shotgun = {},
    ["Double Barrel Shotgun"] = {},
    Turret = t3
}
return v18
