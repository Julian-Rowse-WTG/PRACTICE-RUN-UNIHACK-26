options = ["PLAY", "SETTINGS", "QUIT"];
selection = 0;

if window_get_caption() != ""
{
    window_set_caption("The Last Raiders");
}

menu_x = (display_get_gui_width()) * 0.5;
menu_y = (display_get_gui_height()) * 0.65;
spacing = 80; 