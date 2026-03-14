function dagger_projectile_arrive() {
    if (!instance_exists(owner)) {
        instance_destroy();
        exit;
    }

    // teleport owner to projectile position
	// offset away from wall so demon doesn't clip into it
	var _offset = sprite_get_width(owner.sprite_index) * 0.5 + 2;
	owner.x = x - (owner.facing * _offset);
	owner.y = y;
    // grant invincibility frames
    owner.teleportInvincible  = owner.teleportInvincibleMax;
    owner.invincible          = true;
    owner.arrivalAttackFired  = false;

    // trigger arrival attack — reuses side attack hitbox
	with (owner) {
	    subState     = attacks.side_ground;
	    currentState = states.attack;
	    frame_reset();
	    squash_stretch(1.3, 0.7);
	}

    // screen shake
    god.shake     = true;
    god.freeze    = true;
    god.freezeDur = 3;

    // clean up projectile
    owner.specialProjectile = noone;
    owner.specialCooldown   = owner.specialCooldownMax;
    instance_destroy();
}