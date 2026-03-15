function pl_specialState() {
    xSpeed = approach(xSpeed, 0, aSpeed * god.gameSpeed);
    ySpeed += gSpeed * god.gameSpeed;
    animation_set(specialFd, specialSprite);

    // fire on frame 1
    if (currentFrame == 1 && !specialFired) {
        specialFired = true;
		audio_play_sound(sfx_special, 1, false);
        pl_specialFire();
    }

    // exit state if projectile already resolved before animation ends
    if (specialFired && specialProjectile == noone && animation_end()) {
        specialFired = false;
        state_reset();
        exit;
    }

    // also exit if projectile resolved mid-cast
    if (specialFired && specialProjectile == noone && currentFrame >= 1) {
        specialFired        = false;
        specialCooldown     = specialCooldownMax;
        state_reset();
        exit;
    }

    if (animation_end()) {
        specialFired    = false;
        specialCooldown = specialCooldownMax;
        state_reset();
    }
}