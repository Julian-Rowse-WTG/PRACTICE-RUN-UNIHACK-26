function team_asymmetry_check() {
    // count players per team
    var _redCount  = 0;
    var _blueCount = 0;

    with (oPlayer) {
        if (team == teams.red)  _redCount++;
        if (team == teams.blue) _blueCount++;
    }

    // only apply if exactly two teams and counts differ
    if (_redCount == 0 || _blueCount == 0) exit;
    if (_redCount == _blueCount) exit;

    // find the solo team
    var _soloTeam  = (_redCount < _blueCount) ? teams.red : teams.blue;
    var _largCount = max(_redCount, _blueCount);
    var _smallCount = min(_redCount, _blueCount);
    var _diff      = _largCount - _smallCount;

    with (oPlayer) {
        if (team == _soloTeam) {
            isSolo          = true;
            soloSuperLocked = true;
            superMode       = true;
            // bonus bursts on top of character burstMax
            burstMax     += _diff;
            burstCharges += _diff;
			hpMax *= max(1.5, _diff/1.5)
			hp *= max(1.5, _diff/1.5)
        }
    }
}