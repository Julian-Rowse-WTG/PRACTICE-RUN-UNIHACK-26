function pl_softKnockState() {
    // slow down horizontal movement
    xSpeed = approach(xSpeed, 0, aSpeed * god.gameSpeed);

    // burst input — always reversal mid-combo
    if (attack && !attackHold) burstWindow = burstWindowMax;
    if (special && !specialHold) burstWindow = burstWindowMax;
    if (burstWindow > 0) burstWindow--;
    if (attack && special && burstWindow > 0) {
        pl_burstActivate();
        exit;
    }

    // jump out of soft knockdown
    if (onGround && jump && !jumpHold) {
        ySpeed = jPower;
        softHitStun = 0;
        squash_stretch(0.7, 1.3);
        state_reset();
        exit;
    }

    // block out of soft knockdown
    if (block && !blockHold && onGround) {
        softHitStun = 0;
        blocking = true;
        currentState = states.block;
        frame_reset();
        exit;
    }
}