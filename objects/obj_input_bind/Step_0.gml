// --------------------------------------------------
// INPUT BIND ROOM - STEP EVENT
// --------------------------------------------------

// --------------------------------------------------
// STARTUP INPUT LOCK
// --------------------------------------------------
if (startup_lock_frames > 0)
{
    startup_lock_frames--;
    exit;
}

// --------------------------------------------------
// BACK BUTTON: B on any connected pad OR Escape on keyboard
// Sends back to mode_menu
// --------------------------------------------------
if (keyboard_check_pressed(vk_escape))
{
    show_debug_message("BACK: Escape pressed, returning to mode_menu");
    room_goto(rm_mode_menu);
    exit;
}

for (var _pad = 0; _pad < 12; _pad++)
{
    if (!gamepad_is_connected(_pad)) continue;

    if (gamepad_button_check_pressed(_pad, gp_face2)) // B button
    {
        show_debug_message("BACK: Controller " + string(_pad) + " pressed B, returning to mode_menu");
        room_goto(rm_mode_menu);
        exit;
    }
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
// KB1 = WASD + QE  (confirm: Q+E simultaneously)
// KB2 = IJKL + UO  (confirm: U+O simultaneously)
// KB3 = Arrows + Shift/Enter  (confirm: Shift+Enter simultaneously)
// --------------------------------------------------
var kb1_active = (keyboard_check(ord("W")) || keyboard_check(ord("A")) ||
                  keyboard_check(ord("S")) || keyboard_check(ord("D")) ||
                  keyboard_check(ord("Q")) || keyboard_check(ord("E")));

var kb2_active = (keyboard_check(ord("I")) || keyboard_check(ord("J")) ||
                  keyboard_check(ord("K")) || keyboard_check(ord("L")) ||
                  keyboard_check(ord("U")) || keyboard_check(ord("O")));

var kb3_active = (keyboard_check(vk_up) || keyboard_check(vk_down) ||
                  keyboard_check(vk_left) || keyboard_check(vk_right) ||
                  keyboard_check(vk_shift) || keyboard_check(vk_enter));

// --------------------------------------------------
// CLAIM KEYBOARD SCHEMAS
// --------------------------------------------------
if (next_player != -1)
{
    if (kb1_active && !kb_claimed[0])
    {
        player_assigned[next_player]      = true;
        player_schema_type[next_player]   = "kb1";
        player_schema_id[next_player]     = 1;
        player_confirm_count[next_player] = 0;
        player_special_held[next_player]  = false;
        kb_claimed[0]  = true;
        assigned_count++;
        show_debug_message("Player " + string(next_player + 1) + " claimed KB1 (WASD+QE)");
    }
    else if (kb2_active && !kb_claimed[1])
    {
        player_assigned[next_player]      = true;
        player_schema_type[next_player]   = "kb2";
        player_schema_id[next_player]     = 2;
        player_confirm_count[next_player] = 0;
        player_special_held[next_player]  = false;
        kb_claimed[1]  = true;
        assigned_count++;
        show_debug_message("Player " + string(next_player + 1) + " claimed KB2 (IJKL+UO)");
    }
    else if (kb3_active && !kb_claimed[2])
    {
        player_assigned[next_player]      = true;
        player_schema_type[next_player]   = "kb3";
        player_schema_id[next_player]     = 3;
        player_confirm_count[next_player] = 0;
        player_special_held[next_player]  = false;
        kb_claimed[2]  = true;
        assigned_count++;
        show_debug_message("Player " + string(next_player + 1) + " claimed KB3 (Arrows+Shift/Enter)");
    }
}

// --------------------------------------------------
// CLAIM CONTROLLERS
// Action buttons are X (gp_face3) and Y (gp_face4)
// Special confirm = X + Y held simultaneously
// Movement: left stick or D-pad
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

        var pad_active = false;

        // Left stick movement
        if (abs(stick_x) >= deadzone || abs(stick_y) >= deadzone)
            pad_active = true;

        // D-pad
        if (gamepad_button_check(pad, gp_padu) || gamepad_button_check(pad, gp_padd) ||
            gamepad_button_check(pad, gp_padl) || gamepad_button_check(pad, gp_padr))
            pad_active = true;

        // X or Y pressed (action buttons used for claiming)
        if (gamepad_button_check(pad, gp_face3) || gamepad_button_check(pad, gp_face4))
            pad_active = true;

        if (pad_active)
        {
            show_debug_message("PAD " + string(pad) + " ACTIVE | LX=" + string(stick_x) + " LY=" + string(stick_y));

            player_assigned[next_player]      = true;
            player_schema_type[next_player]   = "pad";
            player_schema_id[next_player]     = pad;
            player_confirm_count[next_player] = 0;
            player_special_held[next_player]  = false;

            pad_claimed[pad] = true;
            assigned_count++;

            show_debug_message("Player " + string(next_player + 1) + " claimed controller slot " + string(pad));
            break;
        }
    }
}

// --------------------------------------------------
// PROCESS SPECIAL INPUT CONFIRMATIONS
// KB1: Q+E simultaneously
// KB2: U+O simultaneously
// KB3: Shift+Enter simultaneously
// PAD: X+Y simultaneously (gp_face3 + gp_face4)
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
            var x_held = gamepad_button_check(pad, gp_face3); // X button
            var y_held = gamepad_button_check(pad, gp_face4); // Y button

            special_now = x_held && y_held;

            if (x_held || y_held)
            {
                show_debug_message("P" + string(p + 1)
                    + " PAD CONFIRM CHECK | X=" + string(x_held)
                    + " | Y=" + string(y_held)
                    + " | special_now=" + string(special_now));
            }
        }
        else
        {
            special_now = false;
        }
    }

    // Gate so one hold = one confirm
    if (special_now && !player_special_held[p])
    {
        player_special_held[p] = true;

        if (player_confirm_count[p] < required_special_count)
        {
            player_confirm_count[p]++;
            show_debug_message("Player " + string(p + 1) + " confirm = " + string(player_confirm_count[p]) + "/" + string(required_special_count));
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
var all_ready    = true;
var assigned_players = 0;

for (var p = 0; p < max_players; p++)
{
    if (player_assigned[p])
    {
        assigned_players++;

        show_debug_message(
            "READY CHECK | P" + string(p + 1)
            + " confirms=" + string(player_confirm_count[p])
            + "/" + string(required_special_count)
        );

        if (player_confirm_count[p] < required_special_count)
        {
            all_ready = false;
        }
    }
}

if (assigned_players <= 0) all_ready = false;

if (all_ready)
{
    show_debug_message("ALL PLAYERS CONFIRMED - going to rm_character_select");

    global.cs_player_count = assigned_players;

    for (var p = 0; p < max_players; p++)
    {
        global.cs_player_active[p]        = player_assigned[p];
        global.cs_player_schema_type[p]   = player_schema_type[p];
        global.cs_player_schema_id[p]     = player_schema_id[p];
        global.cs_player_confirm_count[p] = player_confirm_count[p];

        if (player_assigned[p])
        {
            if      (player_schema_type[p] == "kb1") global.cs_player_input_label[p] = "WASD + Q/E";
            else if (player_schema_type[p] == "kb2") global.cs_player_input_label[p] = "IJKL + U/O";
            else if (player_schema_type[p] == "kb3") global.cs_player_input_label[p] = "Arrows + Shift/Enter";
            else if (player_schema_type[p] == "pad") global.cs_player_input_label[p] = "Controller " + string(player_schema_id[p]);
            else                                     global.cs_player_input_label[p] = "Unknown";
        }
        else
        {
            global.cs_player_schema_type[p]   = "";
            global.cs_player_schema_id[p]     = -1;
            global.cs_player_confirm_count[p] = 0;
            global.cs_player_input_label[p]   = "";
        }

        show_debug_message("HANDOFF | P" + string(p + 1)
            + " active=" + string(global.cs_player_active[p])
            + " type="   + string(global.cs_player_schema_type[p])
            + " id="     + string(global.cs_player_schema_id[p])
            + " label="  + string(global.cs_player_input_label[p]));
    }

    room_goto(rm_character_select);
}