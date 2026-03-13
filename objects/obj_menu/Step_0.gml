if keyboard_check_pressed(vk_up)
{
    selection--;
}

if keyboard_check_pressed(vk_down)
{
    selection++;
}

selection = clamp(selection, 0, array_length(options) - 1);

if keyboard_check_pressed(vk_enter)
{
    switch(selection)
    {
        case 0:
            room_goto(rm_game);
            break;

        case 1:
            room_goto(rm_settings);
            break;
    }
}