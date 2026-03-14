function animation_counter() {
    if (!ds_exists(frameData, ds_type_list)) exit;
    maxFrames     = sprite_get_number(sprite) - 1;
    frameDuration = ds_list_find_value(frameData, currentFrame);
    if (is_undefined(frameDuration) || frameDuration <= 0) frameDuration = 1;
    frameCounter += frameSpeed * god.gameSpeed;
    if (frameCounter >= frameDuration) {
        // don't advance past last frame if in victory state
        if (currentState == states.victory && currentFrame >= maxFrames) {
            frameCounter = frameDuration - 1; // hold at last frame
            exit;
        }
        currentFrame += 1 * god.gameSpeed;
        frameCounter  = 0;
    }
    if (currentFrame > maxFrames) {
        frame_reset();
    }
}