// Load the BGM audio group; playback will begin in the Step event once it is ready
window_set_fullscreen(true);
if !variable_global_exists("loadtimes") global.loadtimes = 0;

room_goto(main_menu)