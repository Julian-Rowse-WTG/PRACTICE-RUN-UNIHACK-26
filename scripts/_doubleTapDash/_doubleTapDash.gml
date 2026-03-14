function _doubleTapDash() {
    var _TAP_WINDOW = 10; // frames
    var _dashed = false;

    // --- LEFT ---
    if (!leftHold && left) {
        // key just pressed this frame
        if (_tapLeft > 0) {
            // second tap within window = dash
            _dashed = true;
            facing = -1;
        }
        _tapLeft = _TAP_WINDOW; // reset window on every press
    }
    if (_tapLeft > 0) _tapLeft--;

    // --- RIGHT ---
    if (!rightHold && right) {
        if (_tapRight > 0) {
            _dashed = true;
            facing = 1;
        }
        _tapRight = _TAP_WINDOW;
    }
    if (_tapRight > 0) _tapRight--;

    // --- UP ---
    if (!upHold && up) {
        if (_tapUp > 0) {
            _dashed = true;
        }
        _tapUp = _TAP_WINDOW;
    }
    if (_tapUp > 0) _tapUp--;

    // --- DOWN ---
    if (!downHold && down) {
        if (_tapDown > 0) {
            _dashed = true;
        }
        _tapDown = _TAP_WINDOW;
    }
    if (_tapDown > 0) _tapDown--;

    return _dashed;
}