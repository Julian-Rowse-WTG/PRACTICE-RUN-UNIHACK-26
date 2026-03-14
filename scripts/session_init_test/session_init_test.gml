function session_init_test() {
    // player 0 — solo red team
    session[0] = {
        active     : true,
        inputType  : inputType.gamepad,
        inputSlot  : 0,
        weaponClass: oKnight,
        team       : teams.red
    };
    // player 1 — blue team
    session[1] = {
        active     : true,
        inputType  : inputType.gamepad,
        inputSlot  : 1,
        weaponClass: oDemon,
        team       : teams.red
    };
    // player 2 — blue team (making it 2v1)
    session[2] = {
        active     : false,
        inputType  : inputType.keyboard,
        inputSlot  : 0,
        weaponClass: oDemon,
        team       : teams.blue
    };
    session[3] = {
        active     : false,
        inputType  : inputType.keyboard,
        inputSlot  : 2,
        weaponClass: oDemon,
        team       : teams.red
    };
}