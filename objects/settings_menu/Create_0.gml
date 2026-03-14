// menu items
options = [
    "BACK",
    "VOLUME",
    "MUSIC",
    "INPUT DISPLAY"
];

// type per entry
types = [
    "action",
    "slider",
    "checkbox",
    "checkbox"
];

// values
values = [
    0,      // BACK unused
    0.7,    // volume slider (0..1)
    1,      // music on/off
    0,      // input display
];

selection = 0;

menu_x = display_get_gui_width() * 0.5;
menu_y = display_get_gui_height() * 0.5;

spacing = 80;

btn_w = 320;
btn_h = 60;
