# Faction Report

- Source: `workspace.Live.<player>.HumanoidRootPart.Faction.FactionName`
- Snapshot: from your screenshots
- Tracked: 4
- Group IDs: not stored in the `Faction` GUI, so they are unresolved below

## Summary

| # | Player | Faction | Group URL |
|---|--------|---------|-----------|
| 1 | ssee1028 | Hunger | — |
| 2 | HOTDOG123SHSHS | Crips | — |
| 3 | blackerple | Guards | — |
| 4 | psydee | Roblox | — |

## Raw data

### ssee1028
- Path: `Workspace.Live.ssee1028.HumanoidRootPart.Faction`
- `Faction` class: BillboardGui
- Children: `FactionName` (TextLabel) — `Text = "Hunger"`

### HOTDOG123SHSHS
- Path: `Workspace.Live.HOTDOG123SHSHS.HumanoidRootPart.Faction`
- `Faction` class: BillboardGui
- Children: `FactionName` (TextLabel) — `Text = "Crips"`

### blackerple
- Path: `Workspace.Live.blackerple.HumanoidRootPart.Faction`
- `Faction` class: BillboardGui
- Children: `FactionName` (TextLabel) — `Text = "Guards"`

### psydee
- Path: `Workspace.Live.psydee.HumanoidRootPart.Faction`
- `Faction` class: BillboardGui
- Children: `FactionName` (TextLabel) — `Text = "Roblox"`

---

Notes:
- `Faction` holds exactly one child, `FactionName`, on every player. No image, no attributes, no ID anywhere in the tree.
- Your own HUD at `PlayerGui.HUD.Main.Faction` is the one place a group icon can exist — that only ever gives your own faction.
- So for other players the ID has to come from name matching, which is why the URL column is empty here.