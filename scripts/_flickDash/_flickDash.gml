function _flickDash(_pad, _axisX, _axisY, _deadzone) {
    var _FLICK_HIGH = 0.85; // stick must reach this
    var _FLICK_LOW  = 0.20; // from below this threshold
    var _dashed = false;

    // horizontal flick
    if (abs(_stickXPrev) < _FLICK_LOW && abs(_axisX) >= _FLICK_HIGH) {
        _dashed = true;
        facing = (_axisX > 0) ? 1 : -1;
    }
    // vertical flick (optional — remove if you don't want up/down dash)
    if (abs(_stickYPrev) < _FLICK_LOW && abs(_axisY) >= _FLICK_HIGH) {
        _dashed = true;
    }

    // also support d-pad double-tap on gamepad
    _dashed = _dashed || _doubleTapDash();

    // store previous stick values for next frame
    _stickXPrev = _axisX;
    _stickYPrev = _axisY;

    return _dashed;
}