
local v1 = {
    Apple = {Price = 10, LayoutOrder = 1, LevelReq = 0, Limit = 5},
    Banana = {Price = 10, LayoutOrder = 1, LevelReq = 0, Limit = 5}
}
v1 = {
    Revolver = {Price = 600, LayoutOrder = -1, LevelReq = 0, Limit = 4},
    AK47 = {Price = 1750, LayoutOrder = 0, LevelReq = 5, Limit = 2},
    SMG = {Price = 2300, LayoutOrder = 0, LevelReq = 15, Limit = 1},
    ["Light Ammo"] = {Price = 5, LayoutOrder = 1, LevelReq = 3, Limit = 20},
    ["Medium Ammo"] = {Price = 8, LayoutOrder = 2, LevelReq = 5, Limit = 20},
    ["Light Ammo Pack"] = {Price = 225, LayoutOrder = 3, LevelReq = 3, Limit = 8},
    ["Medium Ammo Pack"] = {Price = 400, LayoutOrder = 4, LevelReq = 5, Limit = 5},
    ["Armor Pad"] = {Price = 100, LayoutOrder = 5, LevelReq = 5, Limit = 20}
}
v1 = {
    Knife = {Price = 450, LayoutOrder = -1, LevelReq = 0, Limit = 1},
    ["Baseball Bat"] = {Price = 700, LayoutOrder = 0, LevelReq = 0, Limit = 1},
    Katana = {Price = 1250, LayoutOrder = 1, LevelReq = 7, Limit = 1},
    ["Fire Axe"] = {Price = 1400, LayoutOrder = 2, LevelReq = 10, Limit = 1}
}
v1 = {
    ["Canned Chicken"] = {Price = 80, LayoutOrder = -1, LevelReq = 0, Limit = 2},
    ["Canned Peaches"] = {Price = 120, LayoutOrder = 0, LevelReq = 5, Limit = 2},
    ["Water Bottle"] = {Price = 35, LayoutOrder = 0, LevelReq = 0, Limit = 5}
}
v1 = {
    ["Shotgun Ammo"] = {Price = 24, LayoutOrder = -1, LevelReq = 8, Limit = 15},
    ["Shotgun Ammo Pack"] = {Price = 1000, LayoutOrder = 0, LevelReq = 8, Limit = 4},
    ["Armor Pad"] = {Price = 90, LayoutOrder = 1, LevelReq = 0, Limit = 15},
    Grenade = {Price = 2000, LayoutOrder = 2, LevelReq = 15, Limit = 1},
    ["Bear Trap"] = {Price = 2000, LayoutOrder = 3, LevelReq = 15, Limit = 3}
}
v1 = {
    Grenade = {Price = 2000, LayoutOrder = 1, LevelReq = 15, Limit = 2},
    ["EMP Grenade"] = {Price = 1250, LayoutOrder = 2, LevelReq = 15, Limit = 3},
    Crowbar = {Price = 500, LayoutOrder = 3, LevelReq = 10, Limit = 5}
}
v1 = {
    ["Health Blessing"] = {Price = 1000, LayoutOrder = -1, LevelReq = 10, Limit = 3},
    ["Speed Blessing"] = {Price = 1000, LayoutOrder = 0, LevelReq = 10, Limit = 2},
    ["Defense Blessing"] = {Price = 1250, LayoutOrder = 1, LevelReq = 15, Limit = 2},
    ["Super Human Blessing"] = {Price = 2000, LayoutOrder = 2, LevelReq = 20, Limit = 1}
}
v1 = {["The Stuff"] = {Price = 750, LayoutOrder = -1, LevelReq = 8, Limit = 8}}
v1 = {
    Claymore = {Price = 1500, LayoutOrder = 0, LevelReq = 10, Limit = 3},
    ["King's Crown"] = {Price = 350, LayoutOrder = 0, LevelReq = 5, Limit = 1}
}
v1 = {Ramen = {Price = 450, LayoutOrder = 0, LevelReq = 10, Limit = 4}}
v1 = {Pickaxe = {Price = 500, LayoutOrder = 0, LevelReq = 0, Limit = 3}}
v1 = {Pizza = {Price = 50, LayoutOrder = 0, LevelReq = 10, Limit = 8}}
v1 = {
    DisplayName = "Fisherman James",
    Worm = {Price = 50, LayoutOrder = 1, LevelReq = 0, Limit = 5, Type = "Bait"},
    ["Basic Rod"] = {Price = 750, LayoutOrder = 2, LevelReq = 0, Limit = 1}
}
local v2 = {"Loot", "Key", "Fish", "Food", "Item", "Tooth"}
v1 = {ToolTypes = v2}
v2 = {"Loot", "Key", "Fish", "Food", "Item", "Tooth"}
v1 = {Mult = 0.95, ToolTypes = v2}
v2 = {"Loot", "Key", "Fish", "Food", "Item", "Tooth"}
v1 = {Mult = 1.05, ToolTypes = v2}
v2 = {"Weapon"}
v1 = {ToolTypes = v2}
v2 = {"Weapon"}
v1 = {ToolTypes = v2}
v2 = {"Fish"}
v1 = {ToolTypes = v2}
v2 = {"Tooth"}
v1 = {ToolTypes = v2}
local t1 = {
    ["Pumpkin X"] = require(script.Parent.PumpkinXShopLib),
    ["Farmer Joe"] = v1,
    ["Gunner Jayce"] = v1,
    ["Fighter Dave"] = v1,
    Dokey = v1,
    ["The Leader"] = v1,
    ["Agent 3"] = v1,
    ["Priest Jonathan"] = v1,
    Coleman = v1,
    ["King Brian"] = v1,
    Teuchi = v1,
    ["Miner Robert"] = v1,
    Bartoli = v1,
    ["James Fishing"] = v1,
    ["The Collector"] = v1,
    ["Storage Collector"] = v1,
    ["Collector Ali"] = v1,
    ["Weapon Collector Neil"] = v1,
    Rafael = v1,
    ["Sushi Chef Nori"] = v1,
    ["Fisherman James"] = v1
}
return t1
