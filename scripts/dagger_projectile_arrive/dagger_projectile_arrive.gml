function dagger_projectile_arrive() {
    if (!instance_exists(owner)) {
        instance_destroy();
        exit;
    }

    // teleport owner to projectile position
    owner.x = x;
    owner.y = y;

    // push out of wall — step back until no collision
    var _pushDir = -owner.facing;
    var _maxPush = 32;
    var _pushed  = 0;
    while (place_meeting(owner.x, owner.y, parentBlocker) && _pushed < _maxPush) {
        owner.x += _pushDir;
        _pushed++;
    }
    // if still stuck after max push, try opposite direction
    if (place_meeting(owner.x, owner.y, parentBlocker)) {
        owner.x = x;
        _pushed = 0;
        while (place_meeting(owner.x, owner.y, parentBlocker) && _pushed < _maxPush) {
            owner.x += owner.facing;
            _pushed++;
        }
    }

    // grant invincibility frames
    owner.teleportInvincible  = owner.teleportInvincibleMax;
    owner.invincible          = true;
    owner.arrivalAttackFired  = false;

    // trigger arrival attack
    with (owner) {
        subState     = attacks.side_ground;
        currentState = states.attack;
        frame_reset();
        squash_stretch(1.3, 0.7);
    }

    god.shake     = true;
    god.freeze    = true;
    god.freezeDur = 3;

    owner.specialProjectile = noone;
    owner.specialCooldown   = owner.specialCooldownMax;
    instance_destroy();
}