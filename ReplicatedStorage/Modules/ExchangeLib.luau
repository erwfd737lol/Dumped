
local t1 = {["Shark Tooth"] = {Amount = 50, Order = 1}}
local t2 = {Order = 7, Cost = 0, BaseObject = true, UnlockedObject = true, Recipe = t1}
t1 = {["Megalodon Tooth"] = {Amount = 15, Order = 1}}
t2 = {Order = 8, Cost = 0, Skin = "Megalodon", Item = "Knife", Recipe = t1}
local t3 = {["Beach Chair"] = t2, ["Megalodon Knife"] = t2}
local t4 = {["Fisherman James"] = t3}
return t4
