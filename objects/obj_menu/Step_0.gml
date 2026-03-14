 // ---------------------------------
// CONTROLLER DETECTION
// ---------------------------------
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


// ---------------------------------
// STICK LATCH INIT
// ---------------------------------
if (!variable_instance_exists(id, "stick_y_held"))
{
    stick_y_held = false;
}


// ---------------------------------
// KEYBOARD NAVIGATION
// ---------------------------------
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


// ---------------------------------
// CONTROLLER NAVIGATION
// ---------------------------------
if (gp != -1)
{
    // D-pad
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

    // Left stick
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


// ---------------------------------
// CLAMP SELECTION
// ---------------------------------
selection = clamp(selection, 0, array_length(options) - 1);


// ---------------------------------
// ACTIVATION
// ---------------------------------
var activate = false;

if (keyboard_check_pressed(vk_enter))
{
    activate = true;
    show_debug_message("Keyboard ENTER pressed");
}

if (gp != -1)
{
    if (gamepad_button_check_pressed(gp, gp_face1))
    {
        activate = true;
        show_debug_message("Controller FACE1 (A/Cross) pressed");
    }
}


// ---------------------------------
// EXECUTE SELECTION
// ---------------------------------
if (activate)
{
    show_debug_message("Menu selection activated: " + string(selection));

    switch (selection)
    {
        case 0:
            show_debug_message("Going to rm_input_bind");
            room_goto(rm_input_bind);
            break;

        case 1:
            show_debug_message("Going to rm_settings");
            room_goto(rm_settings);
            break;
    }
}