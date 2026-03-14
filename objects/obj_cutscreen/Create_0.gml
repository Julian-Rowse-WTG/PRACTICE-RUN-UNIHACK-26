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

// Load audio groups for selected characters
var _needKnight = false;
var _needDemon  = false;
for (var _p = 0; _p < 4; _p++) {
    var _sess = global.session[_p];
    if (!is_undefined(_sess) && _sess.active) {
        if (_sess.weaponClass == oDemon) {
            _needDemon = true;
        } else {
            _needKnight = true; // knight and axe (judge) both use knight sounds
        }
    }
}
if (_needKnight && !audio_group_is_loaded(audiogroup_knight_sfx)) {
    audio_group_load(audiogroup_knight_sfx);
}
if (_needDemon && !audio_group_is_loaded(audiogroup_demon_sfx)) {
    audio_group_load(audiogroup_demon_sfx);
}
if (!audio_group_is_loaded(audiogroup_generic_sfx)) {
    audio_group_load(audiogroup_generic_sfx);
}