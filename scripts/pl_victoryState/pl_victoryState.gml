function pl_victoryState() {
    xSpeed = approach(xSpeed, 0, aSpeed * god.gameSpeed);
    ySpeed += gSpeed * god.gameSpeed;
    animation_set(fd_victory, victorySprite);
    weaponSprite = weaponIdle;
    // hold on last frame — don't let animation_counter loop it
    if (victoryAnimDone) {
        currentFrame = maxFrames;
        frameCounter = 0;
    }
    if (animation_end()) {
        victoryAnimDone = true;
        currentFrame    = maxFrames;
    }
}