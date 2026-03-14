    // count down lifetime
    embedTimer -= god.gameSpeed;
    if (embedTimer <= 0) {
        if (instance_exists(owner)) owner.specialProjectile = noone;
        instance_destroy();
        exit;
    }

    // move
    x += speed_x * god.gameSpeed;
    y += speed_y * god.gameSpeed;

    // wall collision
    if (place_meeting(x + speed_x, y, parentBlocker)) {
		if (!isBounced && !isVertical) {
		    speed_x  = -speed_x * 0.8;
		    facing   = -facing;
		    isBounced = true;
		    ds_list_clear(ignoreList);
		}
        else {
            // second wall hit or vertical hit wall — vanish
            if (instance_exists(owner)) owner.specialProjectile = noone;
            instance_destroy();
            exit;
        }
    }

    // vertical projectile hits ceiling
    if (isVertical && place_meeting(x, y + speed_y, parentBlocker)) {
        if (instance_exists(owner)) owner.specialProjectile = noone;
        instance_destroy();
        exit;
    }

// player collision
if (!isVertical) {
    var _hit      = false;
    var _myOwner  = owner;   // cache before with block
    var _myTeam   = team;
    var _myDmg    = damage;
    var _myHitStun = hitStun;
    var _myLaunchDmg = launchDamage;
    var _myLaunchSpd = launchSpeed;
    var _myFacing = facing;
    var _myDepth  = depth;

    with (oPlayer) {
        if (_hit) continue;
        if (id == _myOwner) continue;
        if (team == _myTeam && _myTeam != teams.none) continue;
        var _ignored = false;
        for (var _i = 0; _i < ds_list_size(other.ignoreList); _i++) {
            if (other.ignoreList[| _i] == id) {
                _ignored = true;
                break;
            }
        }
        if (_ignored) continue;
        if (place_meeting(x, y, other)) {
            ds_list_add(other.ignoreList, id);
            // soft knockdown initial hit
            hit       = true;
            hitBy     = noone;
            xHit      = 0;
            yHit      = 0;
            hitStun   = _myHitStun;
            damage    = _myDmg;
            hitFacing = _myFacing * -1;
            hitDepth  = _myDepth;
            comboCount[_myOwner.player] = 1;
            xSpeed    = 0;
            ySpeed    = 0;
            // launch vertical from projectile context after with block
            _hit = true;
            other._launchTarget = id; // store target for launch below
        }
    }

    if (_hit) {
        // now back in projectile context — safe to call launch
        spear_launch_vertical(
            _launchTarget,
            _myOwner,
            _myTeam,
            _myFacing,
            _myDepth,
            _myLaunchDmg,
            _myLaunchSpd
        );
        god.shake     = true;
        god.freeze    = true;
        god.freezeDur = 3;
        if (instance_exists(_myOwner)) _myOwner.specialProjectile = noone;
        instance_destroy();
        exit;
    }
}