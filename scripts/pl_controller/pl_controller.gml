function pl_controller() {
    // --- store previous hold states ---
    leftHold    = left;
    rightHold   = right;
    upHold      = up;
    downHold    = down;
    jumpHold    = jump;
    attackHold  = attack;
    dashHold    = dash;
    blockHold   = block;
    specialHold = special;

    // --- reset all inputs ---
    left    = false;
    right   = false;
    up      = false;
    down    = false;
    jump    = false;
    attack  = false;
    dash    = false;
    block   = false;
    special = false;

    // -------------------------------------------------------
    // KEYBOARD
    // -------------------------------------------------------
    if (inputType == inputType.keyboard) {
        switch (inputSlot) {
            case 0:
                left    = keyboard_check(ord("A"));
                right   = keyboard_check(ord("D"));
                up      = keyboard_check(ord("W"));
                down    = keyboard_check(ord("S"));
                attack  = keyboard_check(ord("Q"));
                special = keyboard_check(ord("E"));
            break;
            case 1:
                left    = keyboard_check(ord("J"));
                right   = keyboard_check(ord("L"));
                up      = keyboard_check(ord("I"));
                down    = keyboard_check(ord("K"));
                attack  = keyboard_check(ord("U"));
                special = keyboard_check(ord("O"));
            break;
            case 2:
                left    = keyboard_check(vk_left);
                right   = keyboard_check(vk_right);
                up      = keyboard_check(vk_up);
                down    = keyboard_check(vk_down);
                attack  = keyboard_check(vk_shift);
                special = keyboard_check(vk_enter);
            break;
        }
        block = down;
        jump  = up;
        dash  = _doubleTapDash();
    }

    // -------------------------------------------------------
    // GAMEPAD
    // -------------------------------------------------------
    else if (inputType == inputType.gamepad) {
        var _pad = inputSlot;

        if (gamepad_is_connected(_pad)) {
            var _axisX    = gamepad_axis_value(_pad, gp_axislh);
            var _axisY    = gamepad_axis_value(_pad, gp_axislv);
            var _deadzone = 0.25;

            // directional — stick + d-pad
            left  = gamepad_button_check(_pad, gp_padl) || (_axisX < -_deadzone);
            right = gamepad_button_check(_pad, gp_padr) || (_axisX >  _deadzone);
            up    = gamepad_button_check(_pad, gp_padu) || (_axisY < -_deadzone);
            down  = gamepad_button_check(_pad, gp_padd) || (_axisY >  _deadzone);

            // face buttons — A=Jump, X=Attack, B=Dash, Y=Special, Down=Block
            jump    = gamepad_button_check(_pad, gp_face1); // A
            attack  = gamepad_button_check(_pad, gp_face3); // X
            dash    = gamepad_button_check(_pad, gp_face2); // B
            special = gamepad_button_check(_pad, gp_face4); // Y
            block   = down;
        }
    }
}