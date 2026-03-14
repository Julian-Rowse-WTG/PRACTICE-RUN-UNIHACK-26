function pl_beginStep() {
	//inheret code from parent
	event_inherited();

	//check for hitboxes
	hit_check();

	//animation counter
	animation_counter();

	//player buttons
	pl_controller();

	//basic speed control for movement, etc
	speed_control();

	// tick special cooldown
	if (specialCooldown > 0) {
	    specialCooldown -= god.gameSpeed;
	    if (specialCooldown < 0) specialCooldown = 0;
	}
	
	// tick teleport invincibility
	if (teleportInvincible > 0) {
	    teleportInvincible -= god.gameSpeed;
	    if (teleportInvincible <= 0) {
	        teleportInvincible = 0;
	        invincible         = false;
	    }
	}
}
