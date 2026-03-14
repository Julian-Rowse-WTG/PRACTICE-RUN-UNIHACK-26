function pl_burstReversal() {
    // knock back all players not on our team
    with (oPlayer) {
        if (id == other.id) exit;
        if (team == other.team && team != teams.none) exit;
        // direction away from burst player
        var _dx = x - other.x;
        var _dy = y - other.y;
        var _dist = point_distance(0, 0, _dx, _dy);
        if (_dist == 0) {
            _dx = 1;
            _dy = 0;
        } else {
            _dx /= _dist;
            _dy /= _dist;
        }
        // apply hit data directly
        hit      = true;
        xHit     = _dx * other.burstKnockback;
        yHit     = -abs(_dy * other.burstKnockback * 0.5) - 2;
        hitStun  = other.burstHitStun;
        damage   = other.burstDamage;
        hitFacing = other.facing * -1;
        hitDepth  = other.depth;
    }
    // brief freeze/shake
    god.shake    = true;
    god.freeze   = true;
    god.freezeDur = 3;
    // exit burst state immediately after 1 frame — handled in pl_burstState()
}