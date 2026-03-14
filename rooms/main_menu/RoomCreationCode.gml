window_set_fullscreen(true);

global.play_ui_select_sfx = function() {
		audio_play_sound(sound_ui_select, 1, false);
};
global.play_ui_error_sfx = function() {
		audio_play_sound(sound_ui_error, 1, false);
};