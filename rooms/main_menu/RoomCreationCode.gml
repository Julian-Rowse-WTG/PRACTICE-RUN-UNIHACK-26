window_set_fullscreen(true);

audio_group_load(audiogroup_ui_sfx);

global.session = array_create(4, undefined);
global.play_ui_select_sfx = function() {
	audio_play_sound(sound_ui_select, 1, false);
};
global.play_ui_error_sfx = function() {
	audio_play_sound(sound_ui_error, 1, false);
};