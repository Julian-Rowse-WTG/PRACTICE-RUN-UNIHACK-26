// Cutscreen step event
if (cs_phase == 0) {
    // HOLD phase: count down the 2-second hold and animate dots
    dot_timer++;
    if (dot_timer >= 20) {
        dot_timer = 0;
        dot_count = (dot_count + 1) mod 4;
    }

    hold_timer--;
    if (hold_timer <= 0) {
        // Switch to rm_game; this object persists and runs the fade-in there
        cs_phase = 1;
        room_goto(rm_game);
    }
} else if (cs_phase == 1) {
    // FADE_IN phase: fade the black overlay out, then clean up
    fade_in_alpha = max(0.0, fade_in_alpha - fade_in_speed);
    if (fade_in_alpha <= 0) {
        instance_destroy();
    }
}