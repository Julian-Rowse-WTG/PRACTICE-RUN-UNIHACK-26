// --------------------------------------------------
// INPUT BIND ROOM - STEP EVENT
// --------------------------------------------------

// --------------------------------------------------
// STARTUP INPUT LOCK
// While this is active, do not allow an y claims or confirms.
// --------------------------------------------------
if (startup_lock_frames >  0)
{
    startup_lock_frames--;
    exit;
}

// --------------------------------------------------
// HELPER: find next unassigned player index
// --------------------------------------------------
var next_player = -1;

for (var i = 0; i < max_players; i++)
{
    if (!player_assigned[i])
    {
        next_player = i;
        break;
    }
}

// --------------------------------------------------
// KEYBOARD SCHEMA ACTIVITY CHECKS
// --------------------------------------------------
var kb1_active = false;
var kb2_active = false;
var kb3_active = false;

// KB1 = WASD + QE
if (keyboard_check(ord("W")) || keyboard_check(ord("A")) || keyboard_check(ord("S")) || keyboard_check(ord("D")) ||
    keyboard_check(ord("Q")) || keyboard_check(ord("E")))
{
    kb1_active = true;
}

// KB2 = IJKL + UO
if (keyboard_check(ord("I")) || keyboard_check(ord("J")) || keyboard_check(ord("K")) || keyboard_check(ord("L")) ||
    keyboard_check(ord("U")) || keyboard_check(ord("O")))
{
    kb2_active = true;
}

// KB3 = Arrows + Shift + Enter
if (keyboard_check(vk_up) || keyboard_check(vk_down) || keyboard_check(vk_left) || keyboard_check(vk_right) ||
    keyboard_check(vk_shift) || keyboard_check(vk_enter))
{
    kb3_active = true;
}

// --------------------------------------------------
// CLAIM KEYBOARD SCHEMAS
// --------------------------------------------------
if (next_player != -1)
{
    if (kb1_active && !kb_claimed[0])
    {
        player_assigned[next_player] = true;
        player_schema_type[next_player] = "kb1";
        player_schema_id[next_player] = 1;
        player_confirm_count[next_player] = 0;
        player_special_held[next_player] = false;

        kb_claimed[0] = true;
        assigned_count++;

        show_debug_message("Player " + string(next_player + 1) + " claimed KB1");
    }
    else if (kb2_active && !kb_claimed[1])
    {
        player_assigned[next_player] = true;
        player_schema_type[next_player] = "kb2";
        player_schema_id[next_player] = 2;
        player_confirm_count[next_player] = 0;
        player_special_held[next_player] = false;

        kb_claimed[1] = true;
        assigned_count++;

        show_debug_message("Player " + string(next_player + 1) + " claimed KB2");
    }
    else if (kb3_active && !kb_claimed[2])
    {
        player_assigned[next_player] = true;
        player_schema_type[next_player] = "kb3";
        player_schema_id[next_player] = 3;
        player_confirm_count[next_player] = 0;
        player_special_held[next_player] = false;

        kb_claimed[2] = true;
        assigned_count++;

        show_debug_message("Player " + string(next_player + 1) + " claimed KB3");
    }
}

// --------------------------------------------------
// CLAIM CONTROLLERS
// --------------------------------------------------
if (next_player != -1)
{
    var deadzone = 0.45;

    for (var pad = 0; pad < 12; pad++)
    {
        if (!gamepad_is_connected(pad)) continue;
        if (pad_claimed[pad]) continue;

        var stick_x = gamepad_axis_value(pad, gp_axislh);
        var stick_y = gamepad_axis_value(pad, gp_axislv);

        // Triggers in GameMaker are button constants, not stick axis constants.
        var lt_val = gamepad_button_value(pad, gp_shoulderlb);
        var rt_val = gamepad_button_value(pad, gp_shoulderrb);

        var pad_active = false;

        if (abs(stick_x) >= deadzone || abs(stick_y) >= deadzone)
        {
            pad_active = true;
        }

        if (gamepad_button_check(pad, gp_padu) ||
            gamepad_button_check(pad, gp_padd) ||
            gamepad_button_check(pad, gp_padl) ||
            gamepad_button_check(pad, gp_padr))
        {
            pad_active = true;
        }

        if (gamepad_button_check(pad, gp_face1) ||
            gamepad_button_check(pad, gp_face2))
        {
            pad_active = true;
        }

        if (lt_val > 0.4 || rt_val > 0.4)
        {
            pad_active = true;
        }

        if (pad_active)
        {
            show_debug_message("PAD " + string(pad)
                + " ACTIVE | LX=" + string(stick_x)
                + " LY=" + string(stick_y)
                + " LT=" + string(lt_val)
                + " RT=" + string(rt_val));

            player_assigned[next_player] = true;
            player_schema_type[next_player] = "pad";
            player_schema_id[next_player] = pad;
            player_confirm_count[next_player] = 0;
            player_special_held[next_player] = false;

            pad_claimed[pad] = true;
            assigned_count++;

            show_debug_message("Player " + string(next_player + 1) + " claimed controller slot " + string(pad));
            break;
        }
    }
}

// --------------------------------------------------
// PROCESS SPECIAL INPUT CONFIRMATIONS
// --------------------------------------------------
for (var p = 0; p < max_players; p++)
{
    if (!player_assigned[p]) continue;

    var special_now = false;

    if (player_schema_type[p] == "kb1")
    {
        special_now = keyboard_check(ord("Q")) && keyboard_check(ord("E"));
    }
    else if (player_schema_type[p] == "kb2")
    {
        special_now = keyboard_check(ord("U")) && keyboard_check(ord("O"));
    }
    else if (player_schema_type[p] == "kb3")
    {
        special_now = keyboard_check(vk_shift) && keyboard_check(vk_enter);
    }
    else if (player_schema_type[p] == "pad")
    {
        var pad = player_schema_id[p];

        if (pad != -1 && gamepad_is_connected(pad))
        {
            var a_or_lt = false;
            var b_or_rt = false;

            var lt_val = gamepad_button_value(pad, gp_shoulderlb);
            var rt_val = gamepad_button_value(pad, gp_shoulderrb);

            if (gamepad_button_check(pad, gp_face1) || lt_val > 0.4)
            {
                a_or_lt = true;
            }

            if (gamepad_button_check(pad, gp_face2) || rt_val > 0.4)
            {
                b_or_rt = true;
            }

            special_now = a_or_lt && b_or_rt;

            if (a_or_lt || b_or_rt)
            {
                show_debug_message("P" + string(p + 1)
                    + " PAD CONFIRM CHECK | A/LT=" + string(a_or_lt)
                    + " | B/RT=" + string(b_or_rt)
                    + " | LT=" + string(lt_val)
                    + " | RT=" + string(rt_val));
            }
        }
        else
        {
            special_now = false;
        }
    }

    if (special_now && !player_special_held[p])
    {
        player_special_held[p] = true;

        if (player_confirm_count[p] < required_special_count)
        {
            player_confirm_count[p]++;
            show_debug_message("Player " + string(p + 1) + " special confirm = " + string(player_confirm_count[p]));
        }
    }

    if (!special_now)
    {
        player_special_held[p] = false;
    }
}

// --------------------------------------------------
// CHECK IF ALL ASSIGNED PLAYERS ARE CONFIRMED
// --------------------------------------------------
var all_ready = true;
var assigned_players = 0;

for (var p = 0; p < max_players; p++)
{
    if (player_assigned[p])
    {
        assigned_players++;

        show_debug_message(
            "READY CHECK | Player " + string(p + 1)
            + " assigned=" + string(player_assigned[p])
            + " confirm_count=" + string(player_confirm_count[p])
            + "/" + string(required_special_count)
        );

        if (player_confirm_count[p] < required_special_count)
        {
            all_ready = false;
            show_debug_message("READY CHECK FAILED: Player " + string(p + 1) + " not fully confirmed yet");
            break;
        }
    }
}

if (assigned_players <= 0)
{
    all_ready = false;
    show_debug_message("READY CHECK FAILED: no players assigned");
}

if (all_ready)
{
    show_debug_message("ALL ASSIGNED PLAYERS CONFIRMED");
    show_debug_message("Moving to rm_character_select with " + string(assigned_players) + " player(s)");

    // --------------------------------------------------
    // PUBLISH FINAL ASSIGNED INPUT DATA TO GLOBAL
    // This is the handoff payload for rm_character_select.
    // --------------------------------------------------
    global.cs_player_count = assigned_players;

    for (var p = 0; p < max_players; p++)
    {
        global.cs_player_active[p] = player_assigned[p];
        global.cs_player_schema_type[p] = player_schema_type[p];
        global.cs_player_schema_id[p] = player_schema_id[p];
        global.cs_player_confirm_count[p] = player_confirm_count[p];

        // Build a readable input label for UI/debugging
        if (player_assigned[p])
        {
            if (player_schema_type[p] == "kb1")
            {
                global.cs_player_input_label[p] = "WASD + Q/E";
            }
            else if (player_schema_type[p] == "kb2")
            {
                global.cs_player_input_label[p] = "IJKL + U/O";
            }
            else if (player_schema_type[p] == "kb3")
            {
                global.cs_player_input_label[p] = "Arrows + Shift/Enter";
            }
            else if (player_schema_type[p] == "pad")
            {
                global.cs_player_input_label[p] = "Controller " + string(player_schema_id[p]);
            }
            else
            {
                global.cs_player_input_label[p] = "Unknown";
            }
        }
        else
        {
            global.cs_player_schema_type[p] = "";
            global.cs_player_schema_id[p] = -1;
            global.cs_player_confirm_count[p] = 0;
            global.cs_player_input_label[p] = "";
        }

        show_debug_message(
            "GLOBAL HANDOFF | P" + string(p + 1)
            + " active=" + string(global.cs_player_active[p])
            + " type=" + string(global.cs_player_schema_type[p])
            + " id=" + string(global.cs_player_schema_id[p])
            + " label=" + string(global.cs_player_input_label[p])
        );
    }

    room_goto(rm_character_select);
}