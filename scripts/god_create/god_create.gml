function god_create() {
    enum_init();
    // screen shake
    shake      = false;
    shakeDur   = 5;
    shakeForce = 1;
    // freeze/hitstop
    gameSpeed  = 1;
    freeze     = false;
    freezeDur  = 5;
    // debug
    showBox = false;
    // session — populated by the character select room before entering a match
    // each entry is a struct: { active, inputType, inputSlot, weaponClass, team }
    session = array_create(4, undefined);
    session_init_test();
}