# Item Information — The Storage

Notes from the Real MCP inspection of **[🎃] The Storage** (place ID `13704594433`, place version `2299`). This page summarizes the observed client data and scripts. It does not claim server-side rules that were not visible in the client source.

## Item data has several layers

An item is represented in different ways depending on the system:

| Layer | Representation | What it is for |
|---|---|---|
| Definition | `ReplicatedStorage.Modules.ToolsLib[itemName]` | Static item metadata such as type, tooltip, use time, sell value, weapon stats, and animations. |
| Player inventory | `Data.Items[itemName] = itemData` | Player-owned item counts and related data. Client updates arrive as `ItemDelta` or `ItemBatchDelta`. |
| Backpack | A live Roblox `Tool` instance | The usable/displayed copy of an item. Its attributes identify the item and, when applicable, its stack count. |
| Bank | `Data.Bank[slot] = { Item, Quantity }` | An item stack in one numbered bank slot. |
| Build inventory | `Data.BaseItems` | Buildable base objects; separate from carried Tools. |
| Hotbar layout | Saved item-name strings in numbered slots | Remembers which item name belongs in each hotbar slot; it does not grant or transfer items. |

The live Tool instance and `ToolsLib` definition are separate: the instance carries current state, while `ToolsLib` describes what that item is and how the game treats it.

## Common Tool attributes

The backpack module `ReplicatedStorage.Modules.CustomBackpack` reads these Tool attributes:

| Attribute | Observed use |
|---|---|
| `ToolName` | Canonical item name used for display and lookup. If the attribute is absent or empty, the backpack falls back to the Tool's `Name`. |
| `Quantity` | Number of copies in a stack. The backpack reads it first, then looks for a trailing name suffix like `[x12]`, and otherwise treats the stack as 1. |
| `HotbarRestored` | Backpack layout bookkeeping used when deciding whether a restored Tool should be automatically assigned to a hotbar slot. This is not an item stat. |

In a read-only audit of 17 Tools in the live Backpack, all 17 had `ToolName` and `HotbarRestored`. Sixteen had `Quantity`, including single-count items with `Quantity = 1`; the `Wallet` was the exception. The backpack floors the displayed count, treats invalid or sub-one values as 1, and only shows an `xN` badge when the result exceeds 1.

One Tool can carry additional attributes for its own behavior. The live `Double Barrel Shotgun` had `Bullets = 2` and `Quantity = 1`: `Bullets` is ammunition state, while `Quantity` counts copies of the Tool. Other items may have their own specialized state; the three common attributes above do not replace those item-specific fields.

Attributes such as `ButtonKind`, `SlotIndex`, `RenderedToolKey`, `ViewportActive`, `HasVisual`, and `CustomBackpackBound` are used by backpack UI buttons or rendered UI objects. They should not be confused with item metadata on the Tool itself.

## Tool definitions and categories

`ToolsLib` is keyed by canonical item name. Its `ToolType` categorizes entries for game systems such as shops and selling. Observed examples include `Weapon`, `Item`, `Ammo Pack`, `Food`, `Armor`, and `Loot`.

Definitions can contain category-specific values. For example, `Armor Pad` is `ToolType = "Armor"`, with `Armor = 30`, `UseTime = 1`, and `SellValue = 25`. These are definition values, not the current stack count. The live Armor Pad Tool separately carried `ToolName = "Armor Pad"` and `Quantity = 12`.

`CanBeDropped`, `Enabled`, `RequiresHandle`, and `ToolTip` are Roblox Tool properties, not entries in the Tool's Attributes panel. In the sampled live backpack, all 17 Tools had `CanBeDropped = false`; `Wallet` differed from the others by having `RequiresHandle = true`. Treat these as observations from that live sample, not a guarantee for every Tool in every game state.

## Inventory updates and quantities

The client mirrors owned items in `Data.Items`. An `ItemDelta` update names an item and either replaces its data table or removes it; `ItemBatchDelta` applies several such changes. Inventory displays use `Quantity` from that item data.

The custom backpack watches a Tool's `Name`, `ToolName`, and `Quantity` changes so its icon, label, and stack badge refresh. A Tool name such as `Armor Pad [x12]` is also a display/fallback encoding; when `Quantity` exists, that attribute takes precedence in the backpack's quantity reader.

Trading uses a different view of the same general item counts: the trade inventory is an `Items` list with entries containing `Item` and `Quantity`. The client trade UI requires an entered amount to be a positive whole number, then sends a request shaped like `{ Kind = "Item", Item = itemName, Amount = number }`. This is client-side validation; the server remains responsible for final acceptance.

## Bank and the Safe

The build-catalogue `Safe` and the `Portable Safe` are different things:

- The catalogue `Safe` is base furniture in the `Storage` subcategory, priced at `$10,000`. It is a placed base object and counts toward base build capacity (default cost is one capacity unit). It can also be used as a bank interaction target.
- `Portable Safe` is a separate Tool/game pass entry. Its tooltip says “Your own portable safe,” and its `ToolType` is `Wallet`. It is not the catalogue Safe.

The bank UI reads `Data.Bank` as numbered slots. It creates six slots plus `Data.ExtraBank`; a populated slot has an item name and quantity. The client Store/Take buttons send:

```text
RemoteEvent:FireServer(
    "StoreBank" or "TakeBank",
    slotName,
    HUD.Bank.InputAmount.Text,
    activeBankObject
)
```

The `InputAmount` box placeholder reads `Input Number Here`. The client sends its `.Text` unchanged: it does not parse it, convert it to a number, or replace an empty string with a default. The request does not include an explicit item name, so the server must derive the relevant item from other state. The client debounces each slot/action for 0.1 seconds and closes the bank UI if the player moves more than 20 studs away from the active bank object.

The indexed client source does **not** establish what an empty amount means, what item is selected for storing, what quantity bounds apply, or how malformed requests are handled. Those rules belong to server-side code that was not present in the indexed client scripts. Do not infer them from the client call format alone.

## Hotbar persistence

`SaveHotbarDelta` saves a hotbar name/layout change using data shaped like:

```text
{ Initialized = true, Changes = { ["5"] = "Components" } }
```

Clearing the saved name uses an empty string. This saves a hotbar association; by itself it does not move an item into the bank, change the item's quantity, or create an inventory item.

## Boundaries of these findings

The game index used for this inspection contained 106 decompiled scripts, but the relevant bank and inventory sources were client scripts/modules. The descriptions above separate what those scripts and the live Tool instances show from server-owned behavior that could not be verified. No bank, take, store, drop, trade, or hotbar remote was fired during this inspection.
