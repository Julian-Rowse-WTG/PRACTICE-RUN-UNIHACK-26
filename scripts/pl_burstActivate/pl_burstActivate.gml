function pl_burstActivate() {
    if (burstCharges <= 0) exit;
    burstCharges--;
    burstWindow = 0;

    // reset all combo counters on burst
    for (var _i = 0; _i < 4; _i++) {
        comboCount[_i] = 0;
        comboTimer[_i] = 0;
    }

    // force out of any knockdown state
	audio_play_sound(sound_burst,10,false);
    hit        = false;
    hitStun    = 0;
    softHitStun = 0;
    invincible  = true;
    teleportInvincible = teleportInvincibleMax;

    lastState    = currentState;
    currentState = states.burst;
    frame_reset();

    if (isSolo || lastState == states.tumble || lastState == states.softKnock) {
        ySpeed = jPower * 1.5;
        xSpeed = 0;
        squash_stretch(0.7, 1.3);
        pl_burstReversal();
    } else {
        ySpeed = jPower * 0.8;
        squash_stretch(0.7, 1.3);
        pl_burstSuper();
    }
}