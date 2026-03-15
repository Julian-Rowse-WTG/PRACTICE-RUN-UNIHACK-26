// --------------------------------------------------
// JUGGERNAUT SELECT - STEP EVENT (REWRITE)
// --------------------------------------------------
// INTERACTION MODEL:
//   - Move your cursor over any player's tile
//   - Press ANY of your action buttons (confirm OR back)
//   - That player is now the juggernaut (stolen from whoever had it)
//   - Press your confirm button over the START bar to begin
//     (only works if a juggernaut has been assigned)
// --------------------------------------------------

anim_timer++;

// --------------------------------------------------
// FADE-OUT TRANSITION — go to rm_game once fully black
// --------------------------------------------------
if (transitioning) {
    fade_alpha = min(1.0, fade_alpha + (1.0 / fade_duration));
    if (fade_alpha >= 1.0) {
        show_debug_message("Transitioning to level. Juggernaut = P" + string(juggernaut_player + 1));
        room_goto(rm_cutscreen);
    }
    exit;
}

var any_start_pressed = false;
hovering_over_start_button = false;

// --------------------------------------------------
// PER-PLAYER INPUT LOOP
// --------------------------------------------------
for (var p = 0; p < max_players; p++) {
    if (!player_active[p]) continue;

    var schema_type = player_schema_type[p];
    var schema_id   = player_schema_id[p];

    var left_down_now  = false;
    var right_down_now = false;
    var up_down_now    = false;
    var down_down_now  = false;

    var any_action_pressed = false; // ANY button press → claim juggernaut on hovered tile
    var confirm_pressed    = false; // Confirm only → used for START bar
    var any_held           = false; // For cursor visual feedback

    // --------------------------------------------------
    // KB SCHEMA 1 — WASD
    // Action buttons: Q (back) or E (confirm)
    // --------------------------------------------------
    if (schema_type == "kb1") {
        left_down_now  = keyboard_check(ord("A"));
        right_down_now = keyboard_check(ord("D"));
        up_down_now    = keyboard_check(ord("W"));
        down_down_now  = keyboard_check(ord("S"));

        var _back_p    = keyboard_check_pressed(ord("Q"));
        var _confirm_p = keyboard_check_pressed(ord("E"));

        any_action_pressed = _back_p || _confirm_p;
        confirm_pressed    = _confirm_p;
        any_held           = keyboard_check(ord("Q")) || keyboard_check(ord("E"));
    }

    // --------------------------------------------------
    // KB SCHEMA 2 — IJKL
    // Action buttons: U (back) or O (confirm)
    // --------------------------------------------------
    else if (schema_type == "kb2") {
        left_down_now  = keyboard_check(ord("J"));
        right_down_now = keyboard_check(ord("L"));
        up_down_now    = keyboard_check(ord("I"));
        down_down_now  = keyboard_check(ord("K"));

        var _back_p    = keyboard_check_pressed(ord("U"));
        var _confirm_p = keyboard_check_pressed(ord("O"));

        any_action_pressed = _back_p || _confirm_p;
        confirm_pressed    = _confirm_p;
        any_held           = keyboard_check(ord("U")) || keyboard_check(ord("O"));
    }

    // --------------------------------------------------
    // KB SCHEMA 3 — Arrow keys
    // Action buttons: Shift (back) or Enter (confirm)
    // --------------------------------------------------
    else if (schema_type == "kb3") {
        left_down_now  = keyboard_check(vk_left);
        right_down_now = keyboard_check(vk_right);
        up_down_now    = keyboard_check(vk_up);
        down_down_now  = keyboard_check(vk_down);

        var _back_p    = keyboard_check_pressed(vk_shift);
        var _confirm_p = keyboard_check_pressed(vk_enter);

        any_action_pressed = _back_p || _confirm_p;
        confirm_pressed    = _confirm_p;
        any_held           = keyboard_check(vk_shift) || keyboard_check(vk_enter);
    }

    // --------------------------------------------------
    // GAMEPAD
    // Action buttons: A (gp_face1) OR B (gp_face2) — any face button claims
    // --------------------------------------------------
    else if (schema_type == "pad") {
        var pad = schema_id;

        if (gamepad_is_connected(pad)) {
            var ax = gamepad_axis_value(pad, gp_axislh);
            var ay = gamepad_axis_value(pad, gp_axislv);

            left_down_now  = (ax <= -stick_deadzone) || gamepad_button_check(pad, gp_padl);
            right_down_now = (ax >=  stick_deadzone) || gamepad_button_check(pad, gp_padr);
            up_down_now    = (ay <= -stick_deadzone) || gamepad_button_check(pad, gp_padu);
            down_down_now  = (ay >=  stick_deadzone) || gamepad_button_check(pad, gp_padd);

            var _face1_p = gamepad_button_check_pressed(pad, gp_face1); // A
            var _face2_p = gamepad_button_check_pressed(pad, gp_face2); // B

            any_action_pressed = _face1_p || _face2_p;
            confirm_pressed    = _face1_p; // A button confirms START
            any_held           = gamepad_button_check(pad, gp_face1) || gamepad_button_check(pad, gp_face2);

            // Analog continuous cursor movement
            if (abs(ax) >= stick_deadzone) cursor_x[p] += ax * stick_speed;
            if (abs(ay) >= stick_deadzone) cursor_y[p] += ay * stick_speed;
        }
        else {
            show_debug_message("WARNING: P" + string(p + 1) + " pad " + string(pad) + " disconnected.");
        }
    }

    // --------------------------------------------------
    // DIGITAL MOVEMENT (keyboard / dpad)
    // --------------------------------------------------
    if (left_down_now)  cursor_x[p] -= cursor_speed;
    if (right_down_now) cursor_x[p] += cursor_speed;
    if (up_down_now)    cursor_y[p] -= cursor_speed;
    if (down_down_now)  cursor_y[p] += cursor_speed;

    left_held[p]   = left_down_now;
    right_held[p]  = right_down_now;
    up_held[p]     = up_down_now;
    down_held[p]   = down_down_now;
    cursor_held[p] = any_held;

    // Clamp cursor to screen
    cursor_x[p] = clamp(cursor_x[p], 10, gui_w - 10);
    cursor_y[p] = clamp(cursor_y[p], 10, gui_h - 10);

    // --------------------------------------------------
    // HOVER DETECTION — which tile (if any) is this cursor over?
    // --------------------------------------------------
    hovered_tile[p] = -1;
    for (var i = 0; i < max_players; i++) {
        if (cursor_x[p] >= tile_x1[i] && cursor_x[p] <= tile_x2[i] &&
            cursor_y[p] >= tile_y1[i] && cursor_y[p] <= tile_y2[i]) {
            hovered_tile[p] = i;
            show_debug_message("P" + string(p + 1) + " hovering tile " + string(i) + " (P" + string(i + 1) + ")");
            break;
        }
    }

    // --------------------------------------------------
    // JUGGERNAUT CLAIM
    // If this player pressed any action button AND their cursor
    // is hovering a tile → that tile's player becomes the juggernaut.
    // No hover = no claim (prevents accidental triggers off-tile).
    // --------------------------------------------------
    if (any_action_pressed && hovered_tile[p] != -1) {
        var target_tile = hovered_tile[p];

        if (juggernaut_player == target_tile) {
            // Pressing on the current juggernaut's tile → release the role
            juggernaut_player = -1;
            global.play_ui_error_sfx();
            show_debug_message(
                "P" + string(p + 1) + " released juggernaut (was P" + string(target_tile + 1) + ")"
            );
        } else {
            // Claim/steal — assign the hovered tile's player as juggernaut
            var prev = juggernaut_player;
            juggernaut_player = target_tile;
            global.play_ui_select_sfx();
            show_debug_message(
                "P" + string(p + 1) + " set P" + string(target_tile + 1) + " as juggernaut" +
                (prev != -1 ? " (stolen from P" + string(prev + 1) + ")" : "")
            );
        }

        // Don't also trigger the START bar on this same frame
        // (action was consumed by juggernaut assignment)
        confirm_pressed = false;
    }

    // --------------------------------------------------
    // START BAR — confirm button pressed while cursor
    // is over the bottom bar.
    // Only activates if a juggernaut has been assigned.
    // --------------------------------------------------
    if (any_action_pressed &&
        cursor_y[p] >= divider_y &&
        cursor_y[p] <= divider_y + divider_h) {
        any_start_pressed = true;
        show_debug_message("P" + string(p + 1) + " pressed confirm over START bar.");
    }
    if(cursor_y[p] >= divider_y && cursor_y[p] <= divider_y + divider_h) {
        hovering_over_start_button = true;
    }
}

// --------------------------------------------------
// COMMIT START — write globals, assign teams, begin fade
// --------------------------------------------------
if (any_start_pressed) {
    if (juggernaut_player != -1) {

        global.juggernaut_player = juggernaut_player;
        show_debug_message("global.juggernaut_player set to P" + string(juggernaut_player + 1));

        // Juggernaut = team red (solo), everyone else = team blue
        for (var _p = 0; _p < max_players; _p++) {
            if (!player_active[_p]) continue;

            if (_p == juggernaut_player) {
                global.session[_p].team = teams.blue;
                show_debug_message("P" + string(_p + 1) + " → juggernaut team (blue)");
            } else {
                global.session[_p].team = teams.red;
                show_debug_message("P" + string(_p + 1) + " → challenger team (red)");
            }
			
			
        }
		
		// --- Mark juggernaut in session struct ---
		for (var _p = 0; _p < max_players; _p++) {
		    if (!player_active[_p]) continue;
		    global.session[_p].isJuggernaut = (_p == juggernaut_player);
		    show_debug_message(
		        "P" + string(_p + 1) + " isJuggernaut = " + string(global.session[_p].isJuggernaut)
		    );
		}

        global.play_ui_select_sfx();
        transitioning = true;
        fade_alpha    = 0.0;

        // Fade BGM out
        if (instance_exists(obj_bgm_controller)) {
            with (obj_bgm_controller) {
                if (current_sound != -1 && audio_is_playing(current_sound)) {
                    audio_sound_gain(current_sound, 0, (other.fade_duration / room_speed) * 1000);
                }
            }
        }

    } else {
        // No juggernaut yet — reject with error sound
        global.play_ui_error_sfx();
        show_debug_message("START pressed but no juggernaut assigned yet.");
    }
}