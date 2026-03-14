function animation_create() {
    sprite        = sprite_index;
    idleSprite    = sprite_index;
    frameSpeed    = 1;
    frameCounter  = 0;
    currentFrame  = 0;
    frameDuration = 0;
    maxFrames     = 0;
    frameData     = 0;
    angle         = 0;
    xPos          = x;
    yPos          = y;
    xScale        = 1;
    yScale        = 1;
    currentSprite = sprite;
    lastSprite    = currentSprite;
    landed        = false;
}