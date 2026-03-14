// BGM categories
bgm_menu = [BGM_Knight, BGM_Woodlands_Battle];
bgm_game = [BGM_Flame, BGM_Touhou_Inspired_Sketch];

// Fade state
fade_duration = room_speed * 3;  // 3 seconds in steps
is_fading = false;
fade_timer = 0;

// Track which category is currently playing
last_room_is_game = (room == rm_game);

// Start playing a random track for the current room
var _category = last_room_is_game ? bgm_game : bgm_menu;
if (array_length(_category) > 0) {
    var _idx = irandom(array_length(_category) - 1);
    current_sound = audio_play_sound(_category[_idx], 1, false);
}