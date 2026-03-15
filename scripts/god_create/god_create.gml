function god_create() {
    enum_init();
    // screen shake
    shake      = false;
	deathSkipZoom = false;
    shakeDur   = 5;
    shakeForce = 1;
    // freeze/hitstop
    gameSpeed  = 1;
    freeze     = false;
    freezeDur  = 5;
    // debug
    showBox = false;
    // session
    session = array_create(4, undefined);
    //session_init_test();
    // death cinematic
    deathCinematic    = false;
    deathTarget       = noone;
    deathTimer        = 0;
    deathTimerMax     = 60;
    deathSlowSpeed    = 0.2;
    deathFreezeFrames = 10;
    deathFreezeTimer  = 0;
    deathZoomAmount   = 2.5;
	camDefaultW = __view_get(e__VW.WView, 0);
	camDefaultH = __view_get(e__VW.HView, 0);
	
	// victory
	victory             = victoryState.none;
	victoryTeam         = teams.none;
	victoryDelay        = 0;
	victoryDelayMax     = 90;
	victoryFade         = 0;      // 0-1 alpha for overlay
	victoryFadeSpeed    = 0.02;
	victoryZoomDone     = false;
	victoryInputReady   = false;  // true after animation finishes
	victoryHoldTimer = 0;
}