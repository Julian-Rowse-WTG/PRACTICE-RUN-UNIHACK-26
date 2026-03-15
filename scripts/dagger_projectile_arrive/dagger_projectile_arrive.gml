function dagger_projectile_arrive() {
    if (!instance_exists(owner)) {
        instance_destroy();
        exit;
    }

    // find nearest enemy
    var _nearest = noone;
    var _nearestDist = 999999;

    with (oPlayer) {
        if (id == other.owner) continue;
        if (team == other.team && other.team != teams.none) continue;
        if (currentState == states.dead) continue;
        if (currentState == states.victory) continue;
        var _dist = point_distance(x, y, other.owner.x, other.owner.y);
        if (_dist < _nearestDist) {
            _nearestDist = _dist;
            _nearest     = id;
        }
    }

    // if no valid target found just vanish
    if (_nearest == noone) {
        if (instance_exists(owner)) owner.specialProjectile = noone;
        instance_destroy();
        exit;
    }

    // teleport owner directly to nearest enemy position
    owner.x = _nearest.x;
    owner.y = _nearest.y;
    owner.xSpeed = 0;
    owner.ySpeed = 0;

    // trigger arrival — forced air attack
    with (owner) {
        subState     = attacks.side_air;
        currentState = states.attack;
        xSpeed       = facing * 3;
        ySpeed       = -2;
        frame_reset();
        squash_stretch(1.3, 0.7);
    }

    // grant invincibility frames
    owner.teleportInvincible  = owner.teleportInvincibleMax;
    owner.invincible          = true;
    owner.arrivalAttackFired  = false;

    god.shake     = true;
    god.freeze    = true;
    god.freezeDur = 3;

    owner.specialProjectile = noone;
    owner.specialCooldown   = owner.specialCooldownMax;
    instance_destroy();
}