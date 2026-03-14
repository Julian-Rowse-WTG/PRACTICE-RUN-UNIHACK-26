// --------------------------------------------------
// INPUT BIND ROOM - CREATE EVENT
// --------------------------------------------------
show_debug_message("=== INPUT BIND CREATE START ===");

startup_lock_frames = room_speed * 0.4;
max_players = global.selected_player_count;
required_special_count = 3;
draw_set_font(VT323);

// --------------------------------------------------
// PLAYER ASSIGNMENT STATE
// --------------------------------------------------
player_assigned      = array_create(max_players, false);
player_schema_type   = array_create(max_players, "");
player_schema_id     = array_create(max_players, -1);
player_confirm_count = array_create(max_players, 0);
player_special_held  = array_create(max_players, false);

assigned_count = 0;

// --------------------------------------------------
// KEYBOARD SCHEMA CLAIM FLAGS
// --------------------------------------------------
kb_claimed = array_create(3, false);

// --------------------------------------------------
// GAMEPAD CLAIM FLAGS
// --------------------------------------------------
pad_claimed = array_create(12, false);

// --------------------------------------------------
// UI LAYOUT
// --------------------------------------------------
gui_w = display_get_gui_width();
gui_h = display_get_gui_height();

title_y = 60;
player_box_w = 1000;
player_box_h = 140;
player_box_gap = 20;
player_box_x = (gui_w - player_box_w) * 0.5;
player_box_start_y = 200;

show_debug_message("GUI size = " + string(gui_w) + " x " + string(gui_h));

// --------------------------------------------------
// GLOBAL HANDOFF DATA FOR CHARACTER SELECT
// --------------------------------------------------
global.cs_player_count = 0;
global.cs_player_active       = array_create(max_players, false);
global.cs_player_schema_type  = array_create(max_players, "");
global.cs_player_schema_id    = array_create(max_players, -1);
global.cs_player_confirm_count = array_create(max_players, 0);
global.cs_player_input_label  = array_create(max_players, "");

show_debug_message("=== INPUT BIND CREATE END ===");