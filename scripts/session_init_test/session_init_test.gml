function session_init_test() {
    // player 0 — keyboard slot 0, sword
    session[0] = {
        active     : true,
        inputType  : inputType.keyboard,
        inputSlot  : 0,
        weaponClass: oKnight,
        team       : teams.red
    };
    // player 1 — keyboard slot 1, dagger
    session[1] = {
        active     : true,
        inputType  : inputType.keyboard,
        inputSlot  : 1,
        weaponClass: oDemon,
        team       : teams.blue
    };
    // player 2 — gamepad slot 0, axe
    session[2] = {
        active     : true,
        inputType  : inputType.gamepad,
        inputSlot  : 0,
        weaponClass: oKnight,
        team       : teams.green
    };
    // player 3 — gamepad slot 1, spear
    session[3] = {
        active     : true,
        inputType  : inputType.gamepad,
        inputSlot  : 1,
        weaponClass: oKnight,
        team       : teams.yellow
    };
}