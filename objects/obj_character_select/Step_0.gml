// --------------------------------------------------
// CHARACTER SELECT - STEP EVENT
// CURSOR-BASED VERSION
// --------------------------------------------------

// --------------------------------------------------
// CUTSCREEN FADE-OUT TRANSITION
// Once transitioning, advance the fade and go to rm_cutscreen when done.
// --------------------------------------------------
if (transitioning) {
    fade_alpha = min(1.0, fade_alpha + (1.0 / fade_duration));
    if (fade_alpha >= 1.0) {
        room_goto(rm_cutscreen);
    }
    exit;
}

all_confirmed = true;
var any_start_pressed = false;

// --------------------------------------------------
// PROCESS EACH PLAYER STRICTLY BY THEIR ASSIGNED SCHEMA
// --------------------------------------------------
for (var p = 0; p < max_players; p++) {
    if (!player_active[p]) continue;

    var schema_type = player_schema_type[p];
    var schema_id = player_schema_id[p];

    // ----------------------------------------------
    // INPUT STATE FOR THIS PLAYER ONLY
    // ----------------------------------------------
    var move_left = false;
    var move_right = false;
    var move_up = false;
    var move_down = false;

    var left_down_now = false;
    var right_down_now = false;
    var up_down_now = false;
    var down_down_now = false;

    var confirm_pressed = false;
    var any_button_held = false;

    // ----------------------------------------------
    // KEYBOARD SCHEMA 1 = WASD + QE
    // confirm = Q
    // back    = E
    // ----------------------------------------------
    if (schema_type == "kb1") {
        left_down_now = keyboard_check(ord("A"));
        right_down_now = keyboard_check(ord("D"));
        up_down_now = keyboard_check(ord("W"));
        down_down_now = keyboard_check(ord("S"));

        confirm_pressed = keyboard_check_pressed(ord("Q")) || keyboard_check_pressed(ord("E"));
        any_button_held = keyboard_check(ord("Q")) || keyboard_check(ord("E"));
    }

    // ----------------------------------------------
    // KEYBOARD SCHEMA 2 = IJKL + UO
    // confirm = U
    // back    = O
    // ----------------------------------------------
    else if (schema_type == "kb2") {
        left_down_now = keyboard_check(ord("J"));
        right_down_now = keyboard_check(ord("L"));
        up_down_now = keyboard_check(ord("I"));
        down_down_now = keyboard_check(ord("K"));

        confirm_pressed = keyboard_check_pressed(ord("U")) || keyboard_check_pressed(ord("O"));
        any_button_held = keyboard_check(ord("U")) || keyboard_check(ord("O"));
    }

    // ----------------------------------------------
    // KEYBOARD SCHEMA 3 = ARROWS + SHIFT/ENTER
    // confirm = Shift
    // back    = Enter
    // ----------------------------------------------
    else if (schema_type == "kb3") {
        left_down_now = keyboard_check(vk_left);
        right_down_now = keyboard_check(vk_right);
        up_down_now = keyboard_check(vk_up);
        down_down_now = keyboard_check(vk_down);

        confirm_pressed = keyboard_check_pressed(vk_shift) || keyboard_check_pressed(vk_enter);
        any_button_held = keyboard_check(vk_shift) || keyboard_check(vk_enter);
    }

    // ----------------------------------------------
    // PAD = LEFT STICK OR DPAD
    // confirm = A or LT
    // back    = B or RT
    //
    // IMPORTANT:
    // - never assume slot 0
    // - only poll this player's assigned pad slot
    // - use documented constants only
    // ----------------------------------------------
    else if (schema_type == "pad") {
        var pad = schema_id;

        if (gamepad_is_connected(pad)) {
            var ax = gamepad_axis_value(pad, gp_axislh);
            var ay = gamepad_axis_value(pad, gp_axislv);

            // Analog stick to digital intent
            var stick_left = (ax <= -stick_deadzone);
            var stick_right = (ax >= stick_deadzone);
            var stick_up = (ay <= -stick_deadzone);
            var stick_down = (ay >= stick_deadzone);

            // D-pad also counts
            var dpad_left = gamepad_button_check(pad, gp_padl);
            var dpad_right = gamepad_button_check(pad, gp_padr);
            var dpad_up = gamepad_button_check(pad, gp_padu);
            var dpad_down = gamepad_button_check(pad, gp_padd);

            left_down_now = stick_left || dpad_left;
            right_down_now = stick_right || dpad_right;
            up_down_now = stick_up || dpad_up;
            down_down_now = stick_down || dpad_down;

            // Confirm / back
            confirm_pressed =
                gamepad_button_check_pressed(pad, gp_face1) ||
                gamepad_button_check_pressed(pad, gp_shoulderlb) ||
                gamepad_button_check_pressed(pad, gp_face2) ||
                gamepad_button_check_pressed(pad, gp_shoulderrb);

            any_button_held =
                gamepad_button_check(pad, gp_face1) ||
                gamepad_button_check(pad, gp_shoulderlb) ||
                gamepad_button_check(pad, gp_face2) ||
                gamepad_button_check(pad, gp_shoulderrb);

            // Continuous analog motion for stick users
            // D-pad users still get digital stepping below.
            if (abs(ax) >= stick_deadzone) {
                cursor_x[p] += ax * stick_speed;
            }

            if (abs(ay) >= stick_deadzone) {
                cursor_y[p] += ay * stick_speed;
            }
        }
        else {
            show_debug_message("WARNING: P" + string(p + 1) + " assigned pad slot " + string(pad) + " is disconnected.");
        }
    }

    // ----------------------------------------------
    // DIGITAL HELD MOVEMENT
    // Holding a direction keeps moving every step.
    // This is what keyboard_check() is for.
    // ----------------------------------------------
    move_left = left_down_now;
    move_right = right_down_now;
    move_up = up_down_now;
    move_down = down_down_now;

    // Keep these assignments only if other code still expects them.
    // Otherwise you can delete them entirely.
    left_held[p] = left_down_now;
    right_held[p] = right_down_now;
    up_held[p] = up_down_now;
    down_held[p] = down_down_now;
    // ----------------------------------------------
    // KEYBOARD / DPAD DIGITAL MOVEMENT
    // Keep it simple and readable.
    // ----------------------------------------------
    if (move_left) cursor_x[p] -= cursor_speed;
    if (move_right) cursor_x[p] += cursor_speed;
    if (move_up) cursor_y[p] -= cursor_speed;
    if (move_down) cursor_y[p] += cursor_speed;

    cursor_held_down[p] = any_button_held;

    // ----------------------------------------------
    // CLAMP CURSOR TO SCREEN
    // ----------------------------------------------
    cursor_x[p] = clamp(cursor_x[p], 20, gui_w - 20);
    cursor_y[p] = clamp(cursor_y[p], 20, gui_h - 20);

    // ----------------------------------------------
    // HOVER DETECTION
    // Barebones rectangle hover over hardcoded character tiles.
    // Disabled tiles (index >= enabled_slots) are skipped.
    // ----------------------------------------------
    hovered_tile[p] = -1;

    for (var i = 0; i < panel_count; i++) {
        if (cursor_x[p] >= tile_x1[i] && cursor_x[p] <= tile_x2[i] &&
            cursor_y[p] >= tile_y1[i] && cursor_y[p] <= tile_y2[i]) {
            if (i >= enabled_slots) {
                if (confirm_pressed) {
                    global.play_ui_error_sfx();
                }
                break;
            }
            hovered_tile[p] = i;
            break;
        }

    }

    // ----------------------------------------------
    // CONFIRM
    // Stamp player onto hovered tile.
    // IMPORTANT:
    // We only confirm if actually hovering a tile.
    // ----------------------------------------------
    if (confirm_pressed) {
        if (hovered_tile[p] != -1) {
            if (true) { // Just have this if statement incase we need to gate this
                player_confirmed[p] = true;
                global.play_ui_select_sfx();
                stamp_x[p] = cursor_x[p];
                stamp_y[p] = cursor_y[p];

                show_debug_message(
                    "P" + string(p + 1) +
                    " confirmed at (" + string(stamp_x[p]) + ", " + string(stamp_y[p]) + ")"
                );
                player_choice[p] = hovered_tile[p];



                show_debug_message(
                    "P" + string(p + 1) +
                    " CONFIRMED tile " + string(player_choice[p]) +
                    " at stamp (" + string(stamp_x[p]) + ", " + string(stamp_y[p]) + ")"
                );
            }

        }
        else {
            show_debug_message("P" + string(p + 1) + " confirm pressed, but cursor is not hovering any tile.");
        }
    }

    // ----------------------------------------------
    // START BAR PRESS
    // When this player's cursor is over the divider bar and
    // they press confirm, flag a potential START action.
    // The actual room transition only fires if all_confirmed.
    // ----------------------------------------------
    if (confirm_pressed &&
        cursor_y[p] >= divider_y &&
        cursor_y[p] <= divider_y + divider_h) {
        any_start_pressed = true;
    }

    // ----------------------------------------------
    // ADVANCE CHECK STUB
    // Next guy can implement room transition / match boot here.
    // ----------------------------------------------
    if (!player_confirmed[p]) {
        all_confirmed = false;
    }
}

// --------------------------------------------------
// ALL CONFIRMED — START button press transitions to game
// --------------------------------------------------
if (any_start_pressed) {
    if (all_confirmed) {
        // Build session array on the god object before entering the game room.
        // Format matches session_init_test: { active, inputType, inputSlot, weaponClass, team }
        var _team_list = [teams.red, teams.blue, teams.green, teams.yellow];
        var _team_idx = 0;

        for (var _p = 0; _p < max_players; _p++) {
            if (player_active[_p]) {
                // Determine inputType and inputSlot
                var _input_type, _input_slot;
                if (player_schema_type[_p] == "pad") {
                    _input_type = inputType.gamepad;
                    _input_slot = player_schema_id[_p]; // physical gamepad slot
                } else {
                    _input_type = inputType.keyboard;
                    // kb1 → slot 0 (WASD), kb2 → slot 1 (IJKL), kb3 → slot 2 (numpad)
                    switch (player_schema_type[_p]) {
                        case "kb1": _input_slot = 0; break;
                        case "kb2": _input_slot = 1; break;
                        default:    _input_slot = 2; break; // kb3
                    }
                }

                global.session[_p] = {
                    active     : true,
                    inputType  : _input_type,
                    inputSlot  : _input_slot,
                    weaponClass: char_weapon_class[player_choice[_p]],
                    team       : _team_list[clamp(_team_idx, 0, array_length(_team_list) - 1)]
                };
                _team_idx++;
            } else {
                // Inactive slot — active: false, rest filled for struct compatibility
                global.session[_p] = {
                    active     : false,
                    inputType  : inputType.keyboard,
                    inputSlot  : 0,
                    weaponClass: oKnight,
                    team       : teams.none
                };
            }
        }

        // Kick off 1-second fade-to-black transition to rm_cutscreen.
        // Fade out BGM simultaneously over the same duration.
        global.play_ui_select_sfx();
        transitioning = true;
        fade_alpha    = 0.0;
        if (instance_exists(obj_bgm_controller)) {
            with (obj_bgm_controller) {
                if (current_sound != -1 && audio_is_playing(current_sound)) {
                    audio_sound_gain(current_sound, 0, (other.fade_duration / room_speed) * 1000);
                }
            }
        }
    } else {
        global.play_ui_error_sfx();
    }
}