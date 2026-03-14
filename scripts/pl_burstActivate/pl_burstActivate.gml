function pl_burstActivate() {
    if (burstCharges <= 0) exit;
    burstCharges--;
    burstWindow = 0;

    // reset all combo counters on burst
    for (var _i = 0; _i < 4; _i++) {
        comboCount[_i] = 0;
        comboTimer[_i] = 0;
    }

    lastState    = currentState;
    currentState = states.burst;
    frame_reset();

    // solo players always get reversal since they're permanently in super
    if (isSolo || lastState == states.tumble || lastState == states.softKnock) {
        softHitStun = 0;
        ySpeed      = jPower * 0.5;
        pl_burstReversal();
    } else {
        pl_burstSuper();
    }
}