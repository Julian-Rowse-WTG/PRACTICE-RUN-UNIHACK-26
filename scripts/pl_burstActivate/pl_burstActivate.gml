function pl_burstActivate() {
    if (burstCharges <= 0) exit;
    burstCharges--;
    burstWindow = 0;
    lastState = currentState;
    currentState = states.burst;
    frame_reset();
    // reversal — being hit or knocked down
    if (lastState == states.tumble) {
        pl_burstReversal();
    // super — attacking or neutral
    } else {
        pl_burstSuper();
    }
}