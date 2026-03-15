// STEP EVENT

// -------------------------------------------------
// FIND FIRST CONNECTED CONTROLLER
// -------------------------------------------------
var gp = -1;

for (var pad = 0; pad < 12; pad++)
{
    if (gamepad_is_connected(pad))
    {
        gp = pad;
        break;
    }
}

if (gp != -1)
{
    show_debug_message("Controller detected in slot: " + string(gp));
}
else
{
    show_debug_message("No controller detected.");
}


// -------------------------------------------------
// KEYBOARD NAVIGATION
// -------------------------------------------------
if (keyboard_check_pressed(vk_up))
{
    selection--;
    show_debug_message("Keyboard UP pressed");
}

if (keyboard_check_pressed(vk_down))
{
    selection++;
    show_debug_message("Keyboard DOWN pressed");
}


// -------------------------------------------------
// CONTROLLER NAVIGATION
// -------------------------------------------------
if (!variable_instance_exists(id, "stick_y_held"))
{
    stick_y_held = false;
}

if (gp != -1)
{
    // D-Pad input
    if (gamepad_button_check_pressed(gp, gp_padu))
    {
        selection--;
        show_debug_message("Controller DPAD UP");
    }

    if (gamepad_button_check_pressed(gp, gp_padd))
    {
        selection++;
        show_debug_message("Controller DPAD DOWN");
    }

    // Left stick input
    var axis_v = gamepad_axis_value(gp, gp_axislv);

    if (abs(axis_v) > 0.2)
    {
        show_debug_message("Left stick Y axis value: " + string(axis_v));
    }

    var deadzone = 0.5;

    if (!stick_y_held)
    {
        if (axis_v < -deadzone)
        {
            selection--;
            stick_y_held = true;
            show_debug_message("Controller STICK UP");
        }
        else if (axis_v > deadzone)
        {
            selection++;
            stick_y_held = true;
            show_debug_message("Controller STICK DOWN");
        }
    }

    if (abs(axis_v) < 0.25)
    {
        stick_y_held = false;
    }
}
else
{
    stick_y_held = false;
}


// -------------------------------------------------
// CLAMP SELECTION
// -------------------------------------------------
selection = clamp(selection, 0, array_length(options) - 1);



// -------------------------------------------------
// ACTIVATION
// -------------------------------------------------
var activate = false;

if (keyboard_check_pressed(vk_enter))
{
    activate = true;
}

if (mouse_check_button_pressed(mb_left))
{
    activate = true;
}

if (gp != -1)
{
    if (gamepad_button_check_pressed(gp, gp_face1))
    {
        activate = true;
        show_debug_message("Controller FACE1 (A/Cross) pressed");
    }
}


// -------------------------------------------------
// EXECUTE SELECTION
// -------------------------------------------------
if (activate)
{
    show_debug_message("Menu selection activated: " + string(selection));

    switch (selection)
    {
        case 0:
            show_debug_message("Going back to main menu");
            room_goto(main_menu);
        break;
    }
}

// -------------------------------------------------
// ADJUST SETTINGS (left/right or stick)
// -------------------------------------------------

var adjust_left = keyboard_check_pressed(vk_left);
var adjust_right = keyboard_check_pressed(vk_right);

if (gp != -1)
{
    if (gamepad_button_check_pressed(gp, gp_padl)) adjust_left = true;
    if (gamepad_button_check_pressed(gp, gp_padr)) adjust_right = true;
}

var current_type = types[selection];

var should_play_ui_sfx = adjust_left || adjust_right;

if (current_type == "slider")
{
    if (adjust_left)
    {
        values[selection] -= 0.05;
    }
    if (adjust_right)
    {
        values[selection] += 0.05;
    }
    if(values[selection] < 0 || values[selection] > 1) {
        values[selection] = clamp(values[selection], 0, 1);
        should_play_ui_sfx = false;
        global.play_ui_error_sfx();
    }
    if(selection == 1) {
        audio_master_gain(values[selection]);
    }
}

if (current_type == "checkbox")
{
    if (adjust_left || adjust_right)
    {
        values[selection] = !values[selection];
        show_debug_message("Checkbox toggled: " + string(values[selection]));
        if(selection == 2) {
            global.music_enabled = values[selection];
        }
        if(selection == 3) {
            global.debug = values[selection];
        }
    }
}

if(should_play_ui_sfx) {
    global.play_ui_select_sfx();
}