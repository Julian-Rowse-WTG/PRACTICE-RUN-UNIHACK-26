function pl_burstState() {
    xSpeed = approach(xSpeed, 0, aSpeed * god.gameSpeed);
    // after burst flash frame, go into side attack
    if (onGround) {
        subState = attacks.side_ground;
    } else {
        subState = attacks.side_air;
    }
    currentState = states.attack;
    frame_reset();
}