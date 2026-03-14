function pl_tumbleState() {
    // burst input — only if not dead
    if (currentState != states.dead) {
        if (attack && !attackHold) burstWindow = burstWindowMax;
        if (special && !specialHold) burstWindow = burstWindowMax;
        if (burstWindow > 0) burstWindow--;
        if (attack && special && burstWindow > 0) {
            pl_burstActivate();
            exit;
        }
    }

    if (onGround) {
        xSpeed = approach(xSpeed, 0, 0.1 * god.gameSpeed);
    } else {
        xSpeed = approach(xSpeed, 0, 0.01 * god.gameSpeed);
    }

    hitStun -= god.gameSpeed;
    if (hitStun <= 0 && currentState != states.dead) {
        for (var _i = 0; _i < 4; _i++) {
            comboCount[_i] = 0;
            comboTimer[_i] = 0;
        }
        state_reset();
    }
}