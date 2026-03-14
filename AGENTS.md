# AGENTS.md

## Project Overview

**PRACTICE RUN UNIHACK 26** is a 2D local-multiplayer fighting game built in **GameMaker Studio 2** using **GML (GameMaker Language)**. It was created as a practice project for UNIHACK 26. The game supports up to 4 players, multiple weapon-based characters, and advanced combat mechanics including hitboxes, burst counters, and projectiles.

---

## How to Open & Run

1. Open **GameMaker Studio 2** on your machine.
2. Open the project file: `PRACTICE RUN UNIHACK 26.yyp`.
3. Press the **Play** button (or **Ctrl+F5** / **Cmd+Enter**) to run the game in the default (Windows) target.
4. To build for another platform (Mac, Linux, HTML5, etc.), go to **Tools → Create Executable** and select the desired target.

> There is no CLI build step. GameMaker Studio 2 is required to compile or run the project.

---

## Repository Structure

```
PRACTICE-RUN-UNIHACK-26/
├── PRACTICE RUN UNIHACK 26.yyp   # GameMaker project file (JSON)
├── fonts/                         # Font assets (VT323, fnt_fighter)
├── notes/                         # Design notes and compatibility reports
├── objects/                       # Game objects (24 total)
├── options/                       # Platform build configurations (Windows, Mac, Linux, HTML5, iOS, Android, OperaGX, tvOS, Reddit)
├── rooms/                         # Game rooms/levels (6 total)
├── scripts/                       # GML script functions (70 total)
├── sounds/                        # Audio assets — BGM and SFX
└── sprites/                       # Visual/sprite assets (75+ sprites)
```

---

## Key Game Rooms

| Room | Purpose |
|------|---------|
| `main_menu` | Title screen and main menu |
| `rm_character_select` | Character/weapon selection |
| `rm_game` | Main gameplay arena |
| `rm_input_bind` | Controller and keyboard remapping |

---

## Default Controls

| Player | Move | Jump | Attack | Special | Block |
|--------|------|------|--------|---------|-------|
| P1 (KB) | WASD | W | Q | E | Shift |
| P2 (KB) | IJKL | I | U | O | — |
| P3/P4 | Gamepad | Gamepad | Gamepad | Gamepad | Gamepad |

Controls are rebindable via the `rm_input_bind` room and managed by `obj_input_bind`.

---

## Architecture Overview

### Objects (`objects/`)

| Object | Role |
|--------|------|
| `oPlayer` | Main player character — state machine, input, physics, animation |
| `oHitbox` | Attack hitbox spawned during attack frames |
| `oHurtbox` | Vulnerable area attached to characters |
| `god` | Game/match manager — screen shake, freeze frames, match state |
| `oDemon`, `oKnight`, `oLancer`, `oJudge` | Enemy/boss characters |
| `oAfterimage` | Visual afterimage trail effect |
| `obj_menu`, `obj_mode_menu` | Menu UI objects |
| `obj_character_select` | Character selection logic |
| `obj_input_bind` | Input remapping system |
| `HUD` | Heads-up display (health bars, UI) |
| `obj_bgm_controller` | Background music manager |
| `parentPhysics` | Base physics parent for all physical objects |
| `parentJumpthru` | Platform type (pass-through from below) |
| `parentBlocker` | Solid collision blocker |

### Scripts (`scripts/`)

Scripts are organized by system. Key naming conventions:

- `pl_*` — Player logic (e.g., `pl_controller.gml`, `pl_attackState.gml`)
- `animation_*` — Animation helpers
- `hitbox_*` / `hurtbox_*` / `box_*` / `hbox_*` — Combat collision system
- `frame_*` — Attack frame data system
- `weapon_stats.gml` — Weapon definitions (Sword, Dagger, Axe, Spear)
- `*_attacks.gml` — Per-weapon attack patterns
- `__init_*` / `__view_*` — Compatibility layer (GameMaker version handling)
- `macros.gml` — Global constants
- `enum_init.gml` — Enumeration definitions

### Player State Machine

The player uses an explicit state machine. State scripts:

| State Script | Meaning |
|---|---|
| `pl_normalState.gml` | Idle, walking, running |
| `pl_attackState.gml` | Attacking |
| `pl_blockState.gml` | Blocking |
| `pl_dashState.gml` | Dashing |
| `pl_recoveryState.gml` | Recovery after a hit |
| `pl_softKnockState.gml` | Light knockback |
| `pl_tumbleState.gml` | Heavy knockback / tumbling |
| `pl_specialState.gml` | Special move |
| `pl_burstState.gml` | Burst mechanic active |
| `pl_burstReversal.gml` | Defensive burst counter |

---

## Coding Conventions (GML)

- **Naming:** Objects use `o` prefix (`oPlayer`, `oHitbox`), scripts use `snake_case`.
- **Player scripts** are prefixed with `pl_`.
- **Parent objects** are prefixed with `parent`.
- **Frame data** is managed via the `frame_*` family of scripts.
- **State transitions** go through `state_change.gml`; never set the state variable directly except at init.
- **Hitboxes** are spawned during attack frames and destroyed on frame end; avoid keeping stale hitbox references.
- **Macros and enums** are defined in `macros.gml` and `enum_init.gml` — add new constants there.

---

## Testing & Validation

GameMaker Studio 2 does not have a built-in unit test framework. Validate changes by:

1. Running the game in the IDE and walking through the affected room/feature.
2. Testing all player states that touch the changed code (attack, block, dash, burst).
3. Confirming that hitbox/hurtbox interactions still register correctly in `rm_game`.
4. Checking that menus function for character select and input rebinding if UI code was changed.

---

## Adding New Content

- **New weapon:** Add stats to `weapon_stats.gml`, create a `<weapon>_attacks.gml` file, and wire it up in `pl_attackState.gml` and `pl_frameData.gml`.
- **New character object:** Extend `parentPhysics`, reference `pl_create.gml` initialization pattern, and register in `obj_character_select`.
- **New room:** Add the `.yy` room asset and register it in `PRACTICE RUN UNIHACK 26.yyp`.
- **New sound:** Place the asset in `sounds/`, add to the appropriate audio group (`audiogroup_BGM` or `audiogroup_default`) in the `.yyp` file.

---

## Platform Support

The project is configured for the following build targets:

`Windows` · `macOS` · `Linux` · `HTML5` · `iOS` · `Android` · `OperaGX` · `tvOS` · `Reddit`

Platform-specific options live in `options/<platform>/`.
