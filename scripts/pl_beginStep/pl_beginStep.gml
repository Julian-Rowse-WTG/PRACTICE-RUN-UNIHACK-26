function pl_beginStep() {
	show_debug_message("player " + string(player) + " | gameSpeed: " + string(god.gameSpeed) + " | frameData valid: " + string(ds_exists(frameData, ds_type_list)) + " | frameCounter: " + string(frameCounter) + " | frameDuration: " + string(frameDuration));
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
