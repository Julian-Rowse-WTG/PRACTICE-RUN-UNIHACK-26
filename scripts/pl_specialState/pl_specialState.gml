function pl_specialState() {
    // lock movement during cast
    xSpeed = approach(xSpeed, 0, aSpeed * god.gameSpeed);
    ySpeed += gSpeed * god.gameSpeed;

    // set cast animation
    animation_set(specialFd, specialSprite);

    // fire projectile on frame 1 (second frame)
    if (currentFrame == 1 && !specialFired) {
        specialFired = true;
        audio_play_sound(sfx_special, 1, false);
        pl_specialFire();
    }

    // return to normal when animation ends
    if (animation_end()) {
        specialFired = false;
        specialCooldown = specialCooldownMax;
        state_reset();
    }
}