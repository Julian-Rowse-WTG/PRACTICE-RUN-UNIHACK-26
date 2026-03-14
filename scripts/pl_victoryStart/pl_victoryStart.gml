function pl_victoryStart() {
    currentState    = states.victory;
    victoryAnim     = true;
    victoryAnimDone = false;
    xSpeed          = 0;
    ySpeed          = 0;
    frame_reset();
    animation_set(fd_victory, victorySprite);
}