/// @description camera
// screen shake
if (shake) {
    shakeDur--;
    if (shakeDur <= 0) {
        shakeDur   = 5;
        shakeForce = 1; // reset to default after shake ends
        shake      = false;
    }
    var _curW = __view_get(e__VW.WView, 0);
    var _curH = __view_get(e__VW.HView, 0);
    // clamp shake offset strictly within room
    var _maxX = max(0, room_width  - _curW);
    var _maxY = max(0, room_height - _curH);
    var _newX = clamp(choose(-shakeForce, shakeForce),     -_maxX, _maxX);
    var _newY = clamp(choose(-shakeForce, shakeForce),     -_maxY, _maxY);
    var _newA = choose(-shakeForce * 0.5, shakeForce * 0.5);
    __view_set(e__VW.XView, 0, clamp(_newX, 0, _maxX));
    __view_set(e__VW.YView, 0, clamp(_newY, 0, _maxY));
    __view_set(e__VW.Angle, 0, _newA);
} else if (!deathCinematic && victory == victoryState.none) {
    __view_set(e__VW.XView, 0, approach(__view_get(e__VW.XView, 0), 0, 0.3));
    __view_set(e__VW.YView, 0, approach(__view_get(e__VW.YView, 0), 0, 0.3));
    __view_set(e__VW.Angle, 0, approach(__view_get(e__VW.Angle, 0), 0, 0.5));
}

// freeze/hitstop
if (freeze) {
    gameSpeed = 0;
    freezeDur--;
    if (freezeDur <= 0) {
        freezeDur = 5;
        gameSpeed = 1;
        freeze    = false;
    }
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
            gameSpeed      = 1;
            __view_set(e__VW.WView, 0, camDefaultW);
            __view_set(e__VW.HView, 0, camDefaultH);
            if (instance_exists(deathTarget)) {
                deathTarget.destroy = true;
            }
            deathTarget = noone;
        } else if (instance_exists(deathTarget)) {
            var _targetW = camDefaultW / deathZoomAmount;
            var _targetH = camDefaultH / deathZoomAmount;
            var _targetX = deathTarget.x - _targetW * 0.5;
            var _targetY = deathTarget.y - _targetH * 0.5;
            _targetX = clamp(_targetX, 0, room_width  - _targetW);
            _targetY = clamp(_targetY, 0, room_height - _targetH);
            var _curW = __view_get(e__VW.WView, 0);
            var _curH = __view_get(e__VW.HView, 0);
            __view_set(e__VW.WView, 0, lerp(_curW, _targetW, 0.1));
            __view_set(e__VW.HView, 0, lerp(_curH, _targetH, 0.1));
            __view_set(e__VW.XView, 0, _targetX);
            __view_set(e__VW.YView, 0, _targetY);
        }
    }
}