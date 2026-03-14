// --------------------------------------------------
// MODE MENU - STEP EVENT
// --------------------------------------------------

// --------------------------------------------------
// STARTUP LOCK
// Prevent accidental confirms when entering room.
// --------------------------------------------------
if (mode_menu_startup_lock_frames > 0)
{
    mode_menu_startup_lock_frames--;
    exit;
}

// --------------------------------------------------
// HELPER: rebuild right-side options from left selection
// --------------------------------------------------
function rebuild_right_options(_player_count)
{
    show_debug_message("rebuild_right_options called for player count = " + string(_player_count));

    if (_player_count == 2)
    {
        right_options = array_create(1);
        right_options[0] = "1v1";
    }
    else if (_player_count == 3)
    {
        right_options = array_create(2);
        right_options[0] = "1v2";
        right_options[1] = "1v1v1";
    }
    else if (_player_count == 4)
    {
        right_options = array_create(2);
        right_options[0] = "1v3";
        right_options[1] = "1v1v1v1";
    }
    else
    {
        // Failsafe
        show_debug_message("WARNING: unexpected player count in rebuild_right_options");
        right_options = array_create(1);
        right_options[0] = "1v1";
    }

    right_index = 0;

    show_debug_message("Right options rebuilt. Count = " + string(array_length(right_options)));
}

// --------------------------------------------------
// FIND FIRST CONNECTED CONTROLLER
// We do not hardcode controller slot 0 blindly.
// --------------------------------------------------
var gp = -1;

for (var pad = 0; pad < 12; pad++)
{
    if (gamepad_is_connected(pad))
    {
        gp = pad;
        break;
    }
}

// --------------------------------------------------
// RAW INPUT FLAGS
// --------------------------------------------------
var move_up = false;
var move_down = false;
var confirm_pressed = false;
var cancel_pressed = false;

// --------------------------------------------------
// KEYBOARD INPUT
// We support all schemas here because this menu is global.
// You explicitly wanted confirm/cancel behaviour respected.
//
// IMPORTANT:
// - kb1: Q confirm, E cancel
// - kb2: for this menu, U confirm, O cancel
// - kb3: Enter confirm, Shift cancel
//
// Also movement:
// - kb1 WASD
// - kb2 IJKL
// - kb3 arrows
// --------------------------------------------------

// Movement up
if (keyboard_check_pressed(ord("W"))) move_up = true;
if (keyboard_check_pressed(ord("I"))) move_up = true;
if (keyboard_check_pressed(vk_up))     move_up = true;

// Movement down
if (keyboard_check_pressed(ord("S"))) move_down = true;
if (keyboard_check_pressed(ord("K"))) move_down = true;
if (keyboard_check_pressed(vk_down))  move_down = true;

// Confirm
if (keyboard_check_pressed(ord("Q")))     confirm_pressed = true;
if (keyboard_check_pressed(ord("U")))     confirm_pressed = true;
if (keyboard_check_pressed(vk_enter))     confirm_pressed = true;

// Cancel
if (keyboard_check_pressed(ord("E")))     cancel_pressed = true;
if (keyboard_check_pressed(ord("O")))     cancel_pressed = true;
if (keyboard_check_pressed(vk_shift))     cancel_pressed = true;

// --------------------------------------------------
// CONTROLLER INPUT
// Support D-pad and left stick vertical movement.
// Confirm = A or LT
// Cancel  = B or RT
//
// IMPORTANT:
// We use gp_axislv for left stick vertical axis.
// Negative = up, positive = down
// --------------------------------------------------
if (gp != -1)
{
    // D-pad movement
    if (gamepad_button_check_pressed(gp, gp_padu))
    {
        move_up = true;
        show_debug_message("PAD D-PAD UP pressed on pad " + string(gp));
    }

    if (gamepad_button_check_pressed(gp, gp_padd))
    {
        move_down = true;
        show_debug_message("PAD D-PAD DOWN pressed on pad " + string(gp));
    }

    // Left stick movement with neutral reset guard
    var stick_y = gamepad_axis_value(gp, gp_axislv);

    if (!stick_y_held)
    {
        if (stick_y <= -stick_deadzone)
        {
            move_up = true;
            stick_y_held = true;
            show_debug_message("PAD STICK UP triggered on pad " + string(gp) + " axis=" + string(stick_y));
        }
        else if (stick_y >= stick_deadzone)
        {
            move_down = true;
            stick_y_held = true;
            show_debug_message("PAD STICK DOWN triggered on pad " + string(gp) + " axis=" + string(stick_y));
        }
    }
    else
    {
        if (abs(stick_y) < 0.25)
        {
            stick_y_held = false;
            show_debug_message("PAD STICK returned to neutral on pad " + string(gp));
        }
    }

    // Confirm = A or LT
    if (gamepad_button_check_pressed(gp, gp_face1) || gamepad_button_check_pressed(gp, gp_shoulderlb))
    {
        confirm_pressed = true;
        show_debug_message("PAD CONFIRM pressed on pad " + string(gp));
    }

    // Cancel = B or RT
    if (gamepad_button_check_pressed(gp, gp_face2) || gamepad_button_check_pressed(gp, gp_shoulderrb))
    {
        cancel_pressed = true;
        show_debug_message("PAD CANCEL pressed on pad " + string(gp));
    }
}

// --------------------------------------------------
// NAVIGATION
// --------------------------------------------------
if (!final_locked)
{
    if (column_focus == 0)
    {
        // LEFT COLUMN ACTIVE
        if (move_up)
        {
            left_index--;
            if (left_index < 0) left_index = array_length(left_options) - 1;
            global.play_ui_select_sfx();
            show_debug_message("LEFT MENU moved UP. left_index = " + string(left_index));
        }

        if (move_down)
        {
            left_index++;
            if (left_index >= array_length(left_options)) left_index = 0;
            global.play_ui_select_sfx();
            show_debug_message("LEFT MENU moved DOWN. left_index = " + string(left_index));
        }

        if (confirm_pressed)
        {
            left_locked = true;

            if (left_index == 0) selected_player_count = 2;
            if (left_index == 1) selected_player_count = 3;
            if (left_index == 2) selected_player_count = 4;
            
            global.play_ui_select_sfx();

            show_debug_message("LEFT MENU confirmed. selected_player_count = " + string(selected_player_count));

            rebuild_right_options(selected_player_count);
            column_focus = 1;

            show_debug_message("Focus moved to RIGHT MENU");
        }
    }
    else if (column_focus == 1)
    {
        // RIGHT COLUMN ACTIVE
        if (move_up)
        {
            right_index--;
            if (right_index < 0) right_index = array_length(right_options) - 1;
            global.play_ui_select_sfx();
            show_debug_message("RIGHT MENU moved UP. right_index = " + string(right_index));
        }

        if (move_down)
        {
            right_index++;
            if (right_index >= array_length(right_options)) right_index = 0;
            global.play_ui_select_sfx();
            show_debug_message("RIGHT MENU moved DOWN. right_index = " + string(right_index));
        }

        if (cancel_pressed)
        {
            column_focus = 0;
            left_locked = false;
            global.play_ui_error_sfx();
            show_debug_message("RIGHT MENU cancel pressed. Returning to LEFT MENU");
        }

        if (confirm_pressed)
		{
			selected_mode = right_options[right_index];
			final_locked = true;
			global.play_ui_select_sfx();

			show_debug_message("FINAL MODE CONFIRMED: " + selected_mode);
			show_debug_message("PLAYER COUNT CONFIRMED: " + string(selected_player_count));
			//show_debug_message("Placeholder behaviour: quitting game now.");
            global.selected_mode = selected_mode;
			global.selected_player_count = selected_player_count;
			room_goto(rm_input_bind);
		}
    }
}