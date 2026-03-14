function pl_attackState() {
	if (attack && !attackHold) burstWindow = burstWindowMax;
	if (special && !specialHold) burstWindow = burstWindowMax;
	if (burstWindow > 0) burstWindow--;
	if (attack && special && burstWindow > 0) {
	    pl_burstActivate();
	    exit;
	}

    // speed adjustments
    if (onGround) {
        xSpeed = approach(xSpeed, 0, aSpeed * god.gameSpeed);
    } else {
        xSpeed = approach(xSpeed, 0, 0.1 * god.gameSpeed);
    }
    // call this instance's attack function, defined in the child Create
    _attacks();
    // landing recovery
    recovery_set();
    // countdown hitbox duration if active
    if (dur > 0) {
        dur -= 1 * god.gameSpeed;
    } else {
        dur = 0;
    }
    // reset to normal state when attack animation ends
    if (animation_end()) {
        state_reset();
    }
}