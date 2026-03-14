// --------------------------------------------------
// INPUT BIND ROOM - CREATE EVENT
// --------------------------------------------------
show_debug_message("=== INPUT BIND CREATE START ===");

// --------------------------------------------------
// STARTUP INPUT LOCK
// Prevent accidental binding from the button used
// to enter this room.
// 60 frames = about 1 second at 60 FPS
// --------------------------------------------------
startup_lock_frames = 60;

// How many players max?
max_players = 4;

// How many special-input confirmations required?
required_special_count = 3;

// --------------------------------------------------
// PLAYER ASSIGNMENT STATE
// --------------------------------------------------
// player_assigned[p]      = true/false
// player_schema_type[p]   = "kb1", "kb2", "kb3", "pad"
// player_schema_id[p]     = keyboard option number OR gamepad slot
// player_confirm_count[p] = 0..3
// player_special_held[p]  = gate to avoid repeated counting
// --------------------------------------------------
player_assigned      = array_create(max_players, false);
player_schema_type   = array_create(max_players, "");
player_schema_id     = array_create(max_players, -1);
player_confirm_count = array_create(max_players, 0);
player_special_held  = array_create(max_players, false);

// Number of players currently claimed
assigned_count = 0;

// --------------------------------------------------
// KEYBOARD SCHEMA CLAIM FLAGS
// --------------------------------------------------
kb_claimed = array_create(3, false); // [0]=kb1, [1]=kb2, [2]=kb3

// --------------------------------------------------
// GAMEPAD CLAIM FLAGS
// We support up to 12 slots, matching your earlier pattern.
// pad_claimed[pad] = true if already assigned to a player
// --------------------------------------------------
pad_claimed = array_create(12, false);

// --------------------------------------------------
// UI LAYOUT
// --------------------------------------------------
gui_w = display_get_gui_width();
gui_h = display_get_gui_height();

title_y = 80;
player_box_w = 420;
player_box_h = 130;
player_box_gap = 24;
player_box_x = (gui_w - player_box_w) * 0.5;
player_box_start_y = 180;

show_debug_message("GUI size = " + string(gui_w) + " x " + string(gui_h));
show_debug_message("=== INPUT BIND CREATE END ===");

// --------------------------------------------------
// GLOBAL HANDOFF DATA FOR CHARACTER SELECT
// This is the authoritative payload exported by rm_input_bind
// and consumed by rm_character_select.
// --------------------------------------------------
global.cs_player_count = 0;

// Whether character select slot i is active / used
global.cs_player_active = array_create(max_players, false);

// Human-readable schema type:
// "kb1", "kb2", "kb3", "pad"
global.cs_player_schema_type = array_create(max_players, "");

// Schema identifier:
// kb1 -> 1
// kb2 -> 2
// kb3 -> 3
// pad -> gamepad slot index
global.cs_player_schema_id = array_create(max_players, -1);

// Number of confirms achieved in bind room
global.cs_player_confirm_count = array_create(max_players, 0);

// Optional convenience label for UI/debug
global.cs_player_input_label = array_create(max_players, "");
