
local t1 = {
    Type = "Death",
    Task = "Die for the First Time.",
    AmountNeed = 1,
    Order = -10,
    Rewards = {EXP = 1, Money = 1}
}
t1 = {
    Type = "OpenStorage",
    Task = "Open 100 Storages.",
    AmountNeed = 100,
    Order = 0,
    Rewards = {EXP = 750, Money = 500}
}
t1 = {
    Type = "CollectWeapon",
    Task = "Collect your first weapon!",
    AmountNeed = 1,
    Order = 1,
    Rewards = {EXP = 100, Money = 50}
}
t1 = {
    Type = "KillMob",
    Task = "Defeat 30 NPCs",
    AmountNeed = 30,
    Order = 2,
    Rewards = {EXP = 900, Money = 1500}
}
t1 = {
    Type = "KillPlayer",
    Task = "Defeat 25 Players",
    AmountNeed = 25,
    Order = 3,
    Rewards = {EXP = 1000, Money = 1000}
}
t1 = {
    Type = "Squad5",
    Task = "Meet Squad 5 (Talk to The Leader)",
    AmountNeed = 1,
    Order = 4,
    Rewards = {EXP = 80, Money = 200}
}
t1 = {
    Type = "TotalMoney",
    Task = "Have $50,000 at one time.",
    TotalAmount = true,
    AmountNeed = 50000,
    Order = 5,
    Rewards = {EXP = 4500, Money = 0}
}
t1 = {
    Type = "DonateMoney",
    Task = "Donate $1,000.",
    AmountNeed = 1000,
    Order = 6,
    Rewards = {EXP = 2500, Money = 0}
}
t1 = {
    Type = "PlaceObjects",
    Task = "Place 25 Objects in your base",
    TotalAmount = true,
    AmountNeed = 25,
    Order = 7,
    Rewards = {EXP = 500, Money = 800}
}
t1 = {
    Type = "KillAgent",
    Task = "Defeat 5 Agents",
    AmountNeed = 5,
    Order = 8,
    Rewards = {EXP = 3000, Money = 5000}
}
t1 = {
    Type = "SurviveTime",
    Task = "Survive in The Storage for 1 hour without dying or leaving. Time doesn't go up when you are in base.",
    AmountNeed = 3600,
    TotalAmount = true,
    Order = 9,
    Rewards = {EXP = 1500, Money = 3500}
}
t1 = {
    Type = "Bounty",
    Task = "Accumulate 5,000 Bounty to your name.",
    AmountNeed = 5000,
    TotalAmount = true,
    Order = 9,
    Rewards = {EXP = 2500, Money = 15000}
}
t1 = {
    Type = "Recycle",
    Task = "Recycle 2500 Empty Bottles.",
    AmountNeed = 2500,
    Order = 10,
    Rewards = {SkinPack = "Green Thumb"}
}
t1 = {
    Type = "KillPlayer",
    Task = "Defeat 1000 Players",
    AmountNeed = 1000,
    Order = 11,
    Rewards = {SkinPack = "Menace"}
}
t1 = {
    Type = "KillAlien",
    Task = "Defeat 400 Aliens",
    AmountNeed = 400,
    Order = 12,
    Rewards = {SkinPack = "Nebula"}
}
t1 = {
    Type = "KillFire",
    Task = "Defeat 200 NPCs that use Flamethrowers",
    AmountNeed = 200,
    Order = 13,
    Rewards = {SkinPack = "Flame"}
}
t1 = {
    Type = "TotalMoney",
    Task = "Have $1,000,000 at one time.",
    TotalAmount = true,
    AmountNeed = 1000000,
    Order = 14,
    Rewards = {EXP = 10000, Money = 0}
}
local t2 = {
    ["First Timer"] = t1,
    Explorer = t1,
    Fighter = t1,
    Slayer = t1,
    ["Player Slayer"] = t1,
    ["Squad 5"] = t1,
    Wealthy = t1,
    Generous = t1,
    Builder = t1,
    ["Agent Slayer"] = t1,
    Survivor = t1,
    ["Most Wanted"] = t1,
    ["Green Thumb"] = t1,
    Menace = t1,
    ["Nebula Warrior"] = t1,
    Fireborn = t1,
    Millionaire = t1
}
return t2
