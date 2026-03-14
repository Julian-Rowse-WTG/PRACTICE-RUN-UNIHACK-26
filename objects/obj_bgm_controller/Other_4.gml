// Check if the music category needs to change when entering a new room
var _now_is_game = (room == rm_game);

if (_now_is_game != last_room_is_game && !is_fading) {
    is_fading = true;
    fade_timer = fade_duration;
    audio_sound_gain(current_sound, 0, (fade_duration / room_speed) * 1000);  // fade to silence over fade_duration steps
}
