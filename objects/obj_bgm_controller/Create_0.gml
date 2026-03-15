global.level_rooms = [rm_Autumn, rm_Autumn2, rm_Field, rm_Winter];

global.arr_random = function(arr) {
	return arr[irandom(array_length(arr) - 1)];
};

// BGM categories
bgm_menu = [BGM_Knight, BGM_woodlands_battle];
bgm_game = [BGM_Flame, BGM_touhou_inspired_sketch];

// Fade state
fade_duration = room_speed * 3;  // 3 seconds in steps
is_fading = false;
fade_timer = 0;

// Track which category is currently playing
last_room_is_game = array_contains(global.level_rooms, room);

// Sound handle (invalid until audio group has loaded)
current_sound = -1;

// Silence flag (true while in rm_cutscreen — no BGM should play there)
bgm_muted = false;

// Steps remaining before starting music after entering rm_game (allows fade-in to complete first)
music_start_delay = 0;

// without this, the audio tracks are deterministic (irandom() is a prng)
randomize();

is_fading_for_victory = false;
victory_fade_timer = 0;

fade_out_current_music_for_victory = function(fade_time) {
    is_fading_for_victory = true;
    victory_fade_timer = room_speed * 1; // 1s
};