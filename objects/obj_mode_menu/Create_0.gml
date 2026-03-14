// --------------------------------------------------
// MODE MENU - CREATE EVENT
// --------------------------------------------------
show_debug_message("=== MODE MENU CREATE START ===");

// --------------------------------------------------
// OPTIONAL: assign your arrow sprite here
// Replace spr_menu_arrow with your real sprite asset
// --------------------------------------------------
arrow_sprite = spr_menu_arrow_pointer;

// --------------------------------------------------
// GUI REFERENCES
// We draw in GUI space because menus should stay stable.
// --------------------------------------------------
gui_w = display_get_gui_width();
gui_h = display_get_gui_height();

show_debug_message("MODE MENU GUI SIZE: " + string(gui_w) + " x " + string(gui_h));

// --------------------------------------------------
// LAYOUT - HARD CODED FOR JAM SPEED
// --------------------------------------------------

left_box_x = 140;
left_box_y = 170;
left_box_w = 360;
left_box_h = 430;

right_box_x = 560;
right_box_y = 160;
right_box_w = 360;
right_box_h = 410;

show_debug_message("Left box = " + string(left_box_x) + ", " + string(left_box_y));
show_debug_message("Right box = " + string(right_box_x) + ", " + string(right_box_y));

// --------------------------------------------------
// MENU DATA
// LEFT COLUMN = PLAYER COUNTS
// --------------------------------------------------
left_options = array_create(3);
left_options[0] = "2 player";
left_options[1] = "3 player";
left_options[2] = "4 player";

// --------------------------------------------------
// CURRENT LEFT SELECTION
// --------------------------------------------------
left_index = 0;

// --------------------------------------------------
// RIGHT COLUMN OPTIONS
// This gets rebuilt when left side is confirmed.
// --------------------------------------------------
right_options = array_create(0);
right_index = 0;

// --------------------------------------------------
// STATE
// column_focus = 0 means left column active
// column_focus = 1 means right column active
//
// left_locked = player-count choice is confirmed
// final_locked = final mode choice is confirmed
// --------------------------------------------------
column_focus = 0;
left_locked = false;
final_locked = false;

// --------------------------------------------------
// CHOSEN RESULTS
// Store these for later room flow
// --------------------------------------------------
selected_player_count = 2;
selected_mode = "";

// --------------------------------------------------
// INPUT REPEAT / STICK GUARD
// Very important for controller stability.
// We only trigger vertical movement once per tilt,
// then require returning to neutral.
// --------------------------------------------------
stick_y_held = false;
stick_deadzone = 0.55;

show_debug_message("stick_deadzone = " + string(stick_deadzone));

// --------------------------------------------------
// OPTIONAL STARTUP LOCK
// Prevent accidental input on room entry.
// --------------------------------------------------
startup_lock_frames = room_speed / 2; // ~0.5 sec
show_debug_message("startup_lock_frames = " + string(startup_lock_frames));

show_debug_message("=== MODE MENU CREATE END ===");