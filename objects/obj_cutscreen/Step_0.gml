// Cutscreen step event
if (cs_phase == 0) {
    hold_timer--;
    if (hold_timer <= 0) {
        // Switch to rm_game; this object persists and runs the fade-in there
        cs_phase = 1;
        room_goto(rm_Field);
    }
} else if (cs_phase == 1) {
    // FADE_IN phase: fade the black overlay out, then clean up
    fade_in_alpha = max(0.0, fade_in_alpha - fade_in_speed);
    if (fade_in_alpha <= 0) {
        instance_destroy();
    }
}