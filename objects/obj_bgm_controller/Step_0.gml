if (is_fading) {
    // Count down the fade timer
    fade_timer--;
    if (fade_timer <= 0) {
        // Fade complete - stop old sound and start a new track for the current category
        if (audio_is_playing(current_sound)) {
            audio_stop_sound(current_sound);
        }
        is_fading = false;
        last_room_is_game = (room == rm_game);
        var _category = last_room_is_game ? bgm_game : bgm_menu;
        if (array_length(_category) > 0) {
            var _idx = irandom(array_length(_category) - 1);
            current_sound = audio_play_sound(_category[_idx], 1, false);
        }
    }
} else {
    // If the current track has finished, play a new random one from the same category
    if (!audio_is_playing(current_sound)) {
        var _category = last_room_is_game ? bgm_game : bgm_menu;
        if (array_length(_category) > 0) {
            var _idx = irandom(array_length(_category) - 1);
            current_sound = audio_play_sound(_category[_idx], 1, false);
        }
    }
}
