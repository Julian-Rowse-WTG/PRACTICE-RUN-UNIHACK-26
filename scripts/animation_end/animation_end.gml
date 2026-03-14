function animation_end() {
    if (frameDuration == 0) return false;
    return currentFrame == maxFrames && frameCounter == frameDuration - 1;
}