// Wait until the BGM audio group has finished loading before doing anything
if (!audio_group_is_loaded(audiogroup_BGM)) {
    exit;
}

// No music while muted (e.g. in rm_cutscreen)
if (bgm_muted) {
    exit;
}

// Delay before starting music (e.g. waiting for rm_game fade-in to finish)
if (music_start_delay > 0) {
    music_start_delay--;
    exit;
}

// Start the first track once the audio group has just become ready
if (current_sound == -1) {
    var _category = last_room_is_game ? bgm_game : bgm_menu;
    if (array_length(_category) > 0) {
        var _idx = irandom(array_length(_category) - 1);
        current_sound = audio_play_sound(_category[_idx], 1, false);
    }
    exit;
}

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


if(is_fading_for_victory) {
    victory_fade_timer--;
    if (victory_fade_timer <= -5 * room_speed) { // 5s gap between end of fade and music stopping, to allow victory jingle to play before the next track starts
        is_fading_for_victory = false;
        if (audio_is_playing(current_sound)) {
            audio_stop_sound(current_sound);
        }
    } else {
        // Continue fading out towards victory
        audio_sound_gain(current_sound, 0, (victory_fade_timer / room_speed) * 1000);  // fade to silence over remaining victory_fade_timer steps
    }
}