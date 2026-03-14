function pl_blockState() {
    // lock movement while blocking
    xSpeed = approach(xSpeed, 0, aSpeed * god.gameSpeed);
    
    // exit block when down is released
    if (!block) {
        blocking = false;
        state_reset();
    }
}