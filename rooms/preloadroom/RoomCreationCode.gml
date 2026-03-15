// Load the BGM audio group; playback will begin in the Step event once it is ready
window_set_fullscreen(true);
if !variable_global_exists("loadtimes") global.loadtimes = 0;

room_goto(main_menu)

audio_group_load(audiogroup_ui_sfx);

global.session = array_create(4, undefined);
global.play_ui_select_sfx = function() {
	audio_play_sound(sound_ui_select, 1, false);
};
global.play_ui_error_sfx = function() {
	audio_play_sound(sound_ui_error, 1, false);
};
global.play_ui_success_sfx = function() {
	audio_play_sound(sound_ui_success, 1, false);
};

global.debug = false;

if (!audio_group_is_loaded(audiogroup_BGM)) {
    audio_group_load(audiogroup_BGM);
}

global.loadtimes++;
if (global.loadtimes <= 1) {
	room_goto(preloadroom)
}

global.level_rooms = [rm_Autumn, rm_Autumn2, rm_Field, rm_Winter];

global.arr_random = function(arr) {
	return arr[irandom(array_length(arr) - 1)];
};

global.music_enabled = true;
audio_master_gain(0.7);