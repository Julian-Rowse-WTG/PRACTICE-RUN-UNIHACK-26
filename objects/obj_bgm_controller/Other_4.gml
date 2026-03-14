// Check if the music category needs to change when entering a new room
var _now_is_game = (room == rm_game);

if (room == rm_cutscreen) {
    // No BGM during the cutscreen - stop any remaining sound immediately
    if (current_sound != -1) {
        if (audio_is_playing(current_sound)) {
            audio_stop_sound(current_sound);
        }
        current_sound = -1;
    }
    is_fading = false;
    bgm_muted = true;
} else if (room == rm_game) {
    // Entering game room: unmute and wait for the cutscreen fade-in to finish
    // before starting game music (1 second = room_speed steps).
    bgm_muted         = false;
    music_start_delay = room_speed;
    current_sound     = -1;
    is_fading         = false;
    last_room_is_game = true;
} else if (_now_is_game != last_room_is_game && !is_fading && current_sound != -1) {
    is_fading  = true;
    fade_timer = fade_duration;
    audio_sound_gain(current_sound, 0, (fade_duration / room_speed) * 1000);  // fade to silence over fade_duration steps
}
