
local t1 = {["Silver Ore"] = {Amount = 1, Order = 1}, Components = {Amount = 1, Order = 2}}
local t2 = {Order = -1, Cost = 0, Recipe = t1}
t1 = {["Light Ammo"] = {Amount = 50, Order = 1}}
t2 = {Order = 1, Cost = 5, Recipe = t1}
t1 = {["Medium Ammo"] = {Amount = 50, Order = 1}}
t2 = {Order = 2, Cost = 5, Recipe = t1}
t1 = {["Shotgun Ammo"] = {Amount = 50, Order = 1}}
t2 = {Order = 3, Cost = 5, Recipe = t1}
t1 = {
    SMG = {Amount = 1, Order = 1},
    Components = {Amount = 15, Order = 2},
    Wrench = {Amount = 2, Order = 3}
}
t2 = {Order = 4, Cost = 250, Level = 15, Recipe = t1}
t1 = {
    LMG = {Amount = 4, Order = 1},
    Components = {Amount = 15, Order = 2},
    Wrench = {Amount = 10, Order = 3}
}
t2 = {Order = 5, Cost = 5000, Level = 25, BaseObject = true, Recipe = t1}
t1 = {["Coal Ore"] = {Amount = 5, Order = 1}, Components = {Amount = 6, Order = 2}}
t2 = {Order = 5, Cost = 100, Level = 15, Recipe = t1}
t1 = {["Diamond Ore"] = {Amount = 2, Order = 1}}
t2 = {Order = 6, Cost = 0, Recipe = t1}
t1 = {["Silver Ore"] = {Amount = 2, Order = 1}}
t2 = {Order = 7, Cost = 0, Recipe = t1}
t1 = {["Gold Ore"] = {Amount = 2, Order = 1}}
t2 = {Order = 7, Cost = 0, Recipe = t1}
t1 = {["Iron Ore"] = {Amount = 2, Order = 1}, ["Bronze Ore"] = {Amount = 3, Order = 1}}
t2 = {Order = 8, Cost = 0, Recipe = t1}
t1 = {["Silver Ore"] = {Amount = 2, Order = 1}, ["Bronze Ore"] = {Amount = 3, Order = 1}}
t2 = {Order = 9, Cost = 0, Recipe = t1}
t1 = {["Silver Ore"] = {Amount = 5, Order = 1}, ["Bronze Ore"] = {Amount = 5, Order = 1}}
t2 = {Order = 10, Cost = 0, Recipe = t1}
t1 = {
    Revolver = {Amount = 2, Order = 1},
    ["Hallow's Crown"] = {Amount = 2, Order = 2},
    Ectoplasm = {Amount = 100, Order = 3}
}
t2 = {Order = 11, Cost = 1000, Recipe = t1}
t1 = {
    Chainsaw = {Amount = 1, Order = 1},
    ["Hallow's Crown"] = {Amount = 1, Order = 2},
    Ectoplasm = {Amount = 50, Order = 3}
}
t2 = {Order = 12, Cost = 500, Recipe = t1}
t1 = {
    Scythe = {Amount = 1, Order = 1},
    ["Hallow's Crown"] = {Amount = 1, Order = 2},
    ["Vampire Cape Tatters"] = {Amount = 20, Order = 3}
}
t2 = {Order = 13, Cost = 500, Recipe = t1}
local t3 = {
    ["Armor Pad"] = t2,
    ["Light Ammo Pack"] = t2,
    ["Medium Ammo Pack"] = t2,
    ["Shotgun Ammo Pack"] = t2,
    LMG = t2,
    Turret = t2,
    Grenade = t2,
    Diamond = t2,
    ["Silver Bar"] = t2,
    ["Gold Bar"] = t2,
    Components = t2,
    Wrench = t2,
    Crowbar = t2,
    ["Hallow's Revolvers"] = t2,
    ["Hallow's Saw"] = t2,
    ["Hallow's Scythe"] = t2
}
return t3
