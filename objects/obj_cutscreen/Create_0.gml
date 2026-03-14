// Cutscreen create event
// cs_phase 0 = HOLD  (black screen + Loading... for 2 seconds)
// cs_phase 1 = FADE_IN (fade black overlay from opaque to transparent in rm_game, then destroy)

cs_phase      = 0;
hold_timer    = room_speed * 2;   // 2 seconds
fade_in_alpha = 1.0;              // starts fully black; decreases to 0
fade_in_speed = 1.0 / room_speed; // 1 second to fade in

gui_w = display_get_gui_width();
gui_h = display_get_gui_height();

// Loading animation state
dot_timer = 0;
dot_count = 0;  // 0-3 cycling dots appended to "LOADING"