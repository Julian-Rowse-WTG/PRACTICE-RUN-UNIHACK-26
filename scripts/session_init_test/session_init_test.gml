function session_init_test() {
    // player 0 — keyboard slot 0
    session[0] = {
        active     : true,
        inputType  : inputType.keyboard,
        inputSlot  : 0,
        weaponClass: oKnight,
        team       : teams.red
    };
    // player 1 — keyboard slot 1
    session[1] = {
        active     : true,
        inputType  : inputType.keyboard,
        inputSlot  : 1,
        weaponClass: oDemon,
        team       : teams.blue
    };
    // player 2 — gamepad slot 0
    session[2] = {
        active     : true,
        inputType  : inputType.gamepad,
        inputSlot  : 0,
        weaponClass: oDemon,
        team       : teams.green
    };
    // player 3 — gamepad slot 1
    session[3] = {
        active     : true,
        inputType  : inputType.gamepad,
        inputSlot  : 1,
        weaponClass: oKnight,
        team       : teams.yellow
    };
}