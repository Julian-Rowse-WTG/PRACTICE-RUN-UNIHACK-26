function pl_burstReversal() {
    with (obj_player) {
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
        hit       = true;
        hitBy     = -1;         // no hitbox instance — burst is direct
        xHit      = _dx * other.burstKnockback;
        yHit      = -abs(_dy * other.burstKnockback * 0.5) - 2;
        hitStun   = other.burstHitStun;
        damage    = other.burstDamage;
        hitFacing = other.facing * -1;
        hitDepth  = other.depth;
        // force hard knockdown on burst hit
        comboCount[other.player] = other.hardKnockEvery;
    }
    god.shake     = true;
    god.freeze    = true;
    god.freezeDur = 3;
}