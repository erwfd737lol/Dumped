# Technical Knowledge Base & Analysis: [🎃] The Storage

> **Revision 2 — suite handoff.**
> Sections 1–18 are the original reconnaissance document, preserved.
> Sections 19–31 were added during the development of the companion utility
> suite (`TheStorage.luau`, v1→v7) and record the executor environment,
> every defect found, the final architecture, the config schema, the test
> log, and the handoff gotchas. §14 now carries a correction block because
> live behaviour diverges from the documented constants.

## 1. Executive Summary

This document presents an exhaustive, evidence-based technical investigation into the Roblox experience **"[🎃] The Storage"** (PlaceId: `13704594433`, GameId: `4756005135`, Creator: `Khongumu` / Group `12369782`, Place Version: `2298`).

The investigation was performed by thoroughly analyzing:
1. The exported workspace archive (`Storage Workspace.zip` unpacked into `Extracted\scripts-The-Storage-BaconFrauder-20261107T063530Z`).
2. Live game DataModel reconnaissance via the `roblox-executor-mcp` bridge connected to client instance `e1afa657-3cf7-48a0-ad68-749e029969b5`.
3. Decompiled live client scripts and network remotes (`ClientSetup`, `RemoteEvent`, `UnreliableRemoteEvent`, `RemoteFunction`, `AdminPanel`, `ServerBrowserRemotes`, `TradingRemotes`).

### Summary of Major Discoveries
- **Core Loop & Genre**: An isometric/first-person multiplayer extraction survival and base-building game. Players claim abandoned storage units, construct bases using modular furniture/walls, scavenge/craft weapons, fight NPCs and other players, manage hunger/thirst/armor, participate in randomized server-wide events (Blackout, Blessings, Flood, Hallow's Hour, Trick or Treat), and store loot in personal storage vaults and banks.
- **Deep Combat & Weapon Arsenal**: Features 26 distinct weapons spanning Unarmed, Bladed/Blunt Melee, Kinetic Firearms, Incendiary/Explosive Ordnance, and Supernatural Boss Relics (`Hallow's Revolvers`, `Hallow's Saw`, `Hallow's Scythe`, `Dark Scythe`). Features poise/HyperArmor, combo chains, heavy attacks, realistic 3-axis spring recoil, and unique weapon skills.
- **PvP & Evasion Mechanics**: Features stamina-free dynamic sliding with hitbox lowering, active blocking with damage mitigation, combat-logging prevention via procedural `SafezoneGates` physical barriers, safezone PvP shield timers, and severe low-health movement cripples (< 20 HP).
- **Survival, Alchemy & Fishing**: Complete hunger/thirst metabolic decay system, stat-buffing potion/blessing alchemy (`SpeedAdd`, `DamageMult`, `Defense`), Witch's Cauldron brewing, and an in-depth fishing/marine-hunting system ranging from basic baiting to hunting apex `Megalodon` teeth.
- **Novel Code Protection**: The developers utilize an in-memory anti-tamper delivery pattern via `ReplicatedStorage.ClientSetup`. Client module references are delivered over a RemoteFunction invoke, required, and immediately destroyed from the DataModel (`v1:Destroy()`, `v2:Destroy()`) to thwart standard Explorer hierarchy dumpers.
- **Dual Building Engine**: Contains both a legacy `ClassicBuild` engine (grid-snapping, mouse raycasting) and a modern `ModernBuild` engine (subcategories, visual gizmo, direct dragging, transform hold, mobile touch handles), toggleable by user preferences.
- **Anti-Cheat & Guard Architecture**:
  - `KingHallowLifeGuard`: An active state-protection script that intercepts client attempts to kill or delete the Halloween event boss (`King Hallow`) via state manipulation (`Dead` state suppression).
  - `AvatarRagdollClient`: An active ragdoll/stun enforcer that suppresses `GettingUp`/`FallingDown` humanoid states and forces `Enum.HumanoidStateType.Physics` with `PlatformStand = true` while `Ragdolled` attribute is active.
  - `SafezoneGates`: Dynamic physical barriers that procedurally erect around safe zone entrances when a player is flagged `InCombat = true`, blocking them from entering the safezone to escape combat logging.
  - Movement speed and jump clamping: `WalkSpeed` strictly enforced at `12` (or halved when health `< 20`), and `JumpHeight` enforced at `7.2` (or `0` during slides).
  - Admin telemetry: Live player aim telemetry via `ReportAim` / `UpdateMouse` and moderator visual inspection line tool (`ShowAim` / `ModAimLines`).

---

## 2. Workspace Overview

### Directory Hierarchy