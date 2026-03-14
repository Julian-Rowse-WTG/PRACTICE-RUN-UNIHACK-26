function pl_burstState() {
    // hold for exactly 1 frame then release
    xSpeed = approach(xSpeed, 0, aSpeed * god.gameSpeed);
    ySpeed = 0;
    currentState = lastState;
}