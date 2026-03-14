// BGM categories
bgm_menu = [BGM_Knight, BGM_woodlands_battle];
bgm_game = [BGM_Flame, BGM_touhou_inspired_sketch];

// Fade state
fade_duration = room_speed * 3;  // 3 seconds in steps
is_fading = false;
fade_timer = 0;

// Track which category is currently playing
last_room_is_game = (room == rm_game);

// Sound handle (invalid until audio group has loaded)
current_sound = -1;

// Load the BGM audio group; playback will begin in the Step event once it is ready
if (!audio_group_is_loaded(audiogroup_BGM)) {
    audio_group_load(audiogroup_BGM);
}

// Silence flag (true while in rm_cutscreen — no BGM should play there)
bgm_muted = false;

// Steps remaining before starting music after entering rm_game (allows fade-in to complete first)
music_start_delay = 0;

// without this, the audio tracks are determinister (irandom() is a prng)
randomize();