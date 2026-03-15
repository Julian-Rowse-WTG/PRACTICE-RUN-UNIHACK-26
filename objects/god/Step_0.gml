/// @description debug
//show_debug_message("gameSpeed: " + string(gameSpeed) + " | freeze: " + string(freeze) + " | freezeDur: " + string(freezeDur) + " | deathCinematic: " + string(deathCinematic));
window_set_caption(string(fps));

if(keyboard_check_pressed(ord("R"))){
    game_restart();
}

if(keyboard_check_pressed(vk_escape)){
    game_end();
}

// death cinematic
if (deathCinematic) {
    if (deathFreezeTimer > 0) {
        gameSpeed = 0;
        deathFreezeTimer--;
        if (deathFreezeTimer <= 0) {
            gameSpeed = deathSlowSpeed;
        }
    } else {
        gameSpeed = deathSlowSpeed;
        deathTimer--;
        if (deathTimer <= 0) {
            deathCinematic = false;
            deathSkipZoom  = false;
            gameSpeed      = 1;
            __view_set(e__VW.WView, 0, camDefaultW);
            __view_set(e__VW.HView, 0, camDefaultH);
            if (instance_exists(deathTarget)) {
                deathTarget.destroy = true;
            }
            deathTarget = noone;
        } else if (instance_exists(deathTarget) && !deathSkipZoom) {
            // only zoom if not the final kill
            var _targetW = camDefaultW / deathZoomAmount;
            var _targetH = camDefaultH / deathZoomAmount;
            var _targetX = deathTarget.x - _targetW * 0.5;
            var _targetY = deathTarget.y - _targetH * 0.5;
            _targetX = clamp(_targetX, 0, max(0, room_width  - _targetW));
            _targetY = clamp(_targetY, 0, max(0, room_height - _targetH));
            var _curW = __view_get(e__VW.WView, 0);
            var _curH = __view_get(e__VW.HView, 0);
            __view_set(e__VW.WView, 0, lerp(_curW, _targetW, 0.1));
            __view_set(e__VW.HView, 0, lerp(_curH, _targetH, 0.1));
            __view_set(e__VW.XView, 0, _targetX);
            __view_set(e__VW.YView, 0, _targetY);
        }
    }
}

if (victory == victoryState.none && !deathCinematic) {
    // count alive players per team
    var _alive      = array_create(5, 0); // index = teams enum value
    var _aliveTotal = 0;
    var _lastTeam   = teams.none;
    var _lastPlayer = noone;

    with (oPlayer) {
        if (currentState != states.dead) {
            _alive[team]++;
            _aliveTotal++;
            _lastTeam   = team;
            _lastPlayer = id;
        }
    }

    // count how many teams are still alive
    var _teamsAlive = 0;
    for (var _t = 0; _t < 5; _t++) {
        if (_alive[_t] > 0) _teamsAlive++;
    }

    // victory when only one team remains
    if (_aliveTotal > 0 && _teamsAlive == 1) {
        victory      = victoryState.delay;
        victoryTeam  = _lastTeam;
        victoryDelay = victoryDelayMax;
        gameSpeed    = 0;
    }
}

// victory state machine
switch (victory) {
case victoryState.delay:
    gameSpeed = 0;
    victoryDelay--;
    if (victoryDelay <= 0) {
        victory   = victoryState.zoom;
        gameSpeed = 1;
        var _vTeam = victoryTeam; // cache before entering with blocks
        // hide dead players
        with (oPlayer) {
            if (currentState == states.dead) visible = false;
        }
        // trigger victory animation on winning players
        with (oPlayer) {
            if (team == _vTeam) {
                pl_victoryStart();
            }
        }
    }
break;

case victoryState.zoom:
    var _vTeam = victoryTeam;
    var _minX  =  999999;
    var _maxX  = -999999;
    var _minY  =  999999;
    var _maxY  = -999999;
    with (oPlayer) {
        if (team == _vTeam) {
            _minX = min(_minX, x);
            _maxX = max(_maxX, x);
            _minY = min(_minY, y);
            _maxY = max(_maxY, y);
        }
    }
    var _padding = 64;
    var _targetW = max(_maxX - _minX + _padding * 2, camDefaultW * 0.4);
    var _targetH = max(_maxY - _minY + _padding * 2, camDefaultH * 0.4);
    // maintain aspect ratio
    var _aspect  = camDefaultW / camDefaultH;
    if (_targetW / _targetH > _aspect) {
        _targetH = _targetW / _aspect;
    } else {
        _targetW = _targetH * _aspect;
    }
    // clamp view size to room bounds — never exceed room size
    _targetW = clamp(_targetW, camDefaultW * 0.3, room_width);
    _targetH = clamp(_targetH, camDefaultH * 0.3, room_height);
    // re-enforce aspect ratio after clamping
    if (_targetW / _targetH > _aspect) {
        _targetH = _targetW / _aspect;
    } else {
        _targetW = _targetH * _aspect;
    }
    // clamp final size again after aspect ratio correction
    _targetW = min(_targetW, room_width);
    _targetH = min(_targetH, room_height);
    var _targetX = ((_minX + _maxX) * 0.5) - _targetW * 0.5;
    var _targetY = ((_minY + _maxY) * 0.5) - _targetH * 0.5;
    // clamp position so view never goes outside room
    _targetX = clamp(_targetX, 0, max(0, room_width  - _targetW));
    _targetY = clamp(_targetY, 0, max(0, room_height - _targetH));
    var _curW = __view_get(e__VW.WView, 0);
    var _curH = __view_get(e__VW.HView, 0);
    var _curX = __view_get(e__VW.XView, 0);
    var _curY = __view_get(e__VW.YView, 0);
    __view_set(e__VW.WView, 0, lerp(_curW, _targetW, 0.08));
    __view_set(e__VW.HView, 0, lerp(_curH, _targetH, 0.08));
    __view_set(e__VW.XView, 0, lerp(_curX, _targetX, 0.08));
    __view_set(e__VW.YView, 0, lerp(_curY, _targetY, 0.08));
    if (abs(_curW - _targetW) < 2) {
        victory         = victoryState.animate;
        victoryZoomDone = true;
    }
break;


case victoryState.animate:
    var _vTeam   = victoryTeam;
    var _allDone = true;
    with (oPlayer) {
        if (team == _vTeam) {
            if (!victoryAnimDone) _allDone = false;
        }
    }
    if (_allDone) {
        if (!variable_instance_exists(id, "victoryHoldTimer")) {
            victoryHoldTimer = 120; // 2 seconds
        }
        victoryHoldTimer--;
        if (victoryHoldTimer <= 0) {
            victory           = victoryState.display;
            victoryInputReady = false;
        }
    }
break;
case victoryState.display:
    // fade in overlay
    victoryFade = min(victoryFade + victoryFadeSpeed, 1);
    if (victoryFade >= 0.5) victoryInputReady = true;
    // check any input to proceed
    if (victoryInputReady) {
        var _proceed = false;
        // keyboard
        if (keyboard_check_pressed(vk_anykey)) _proceed = true;
        // gamepads
        for (var _g = 0; _g < 4; _g++) {
            if (gamepad_is_connected(_g)) {
                for (var _b = 0; _b <= 15; _b++) {
                    if (gamepad_button_check_pressed(_g, _b)) _proceed = true;
                }
            }
        }
        if (_proceed) {
            victory = victoryState.leave;
        }
    }
break;

case victoryState.leave:
    // clean up session and go to main menu
    global.session = array_create(4, undefined);
	//game_restart();
    room_goto(main_menu);
break;
}