function pl_burstReversal() {
    with (oPlayer) {
        if (id == other.id) continue;
        if (team == other.team && team != teams.none) continue;
        var _dx   = x - other.x;
        var _dy   = y - other.y;
        var _dist = point_distance(0, 0, _dx, _dy);
        if (_dist == 0) {
            _dx = 1;
            _dy = 0;
        } else {
            _dx /= _dist;
            _dy /= _dist;
        }
        // scale knockback by combo hits
        var _comboMult = 1 + (comboCount[other.player] * 0.5);
        // massive base knockback — significant launch distance
        var _baseKnock = other.burstKnockback * 4;
        hit       = true;
        hitBy     = noone;
        xHit      = _dx * _baseKnock * _comboMult;
        yHit      = (-abs(_dy * _baseKnock * 0.5) - 6) * _comboMult;
        hitStun   = other.burstHitStun * _comboMult;
        damage    = other.burstDamage  * _comboMult;
        hitFacing = other.facing * -1;
        hitDepth  = other.depth;
        // always hard knockdown
        comboCount[other.player] = other.hardKnockEvery;
    }
    god.shake      = true;
    god.shakeForce = 4;
    god.shakeDur   = 12;
    god.freeze     = true;
    god.freezeDur  = 6;
}