    embedTimer -= god.gameSpeed;
    if (embedTimer <= 0) {
        if (instance_exists(owner)) owner.specialProjectile = noone;
        instance_destroy();
        exit;
    }

    // find/update nearest enemy target
    homeTarget = noone;
    var _nearestDist = 999999;
    with (oPlayer) {
        if (id == other.owner) continue;
        if (team == other.team && other.team != teams.none) continue;
        if (currentState == states.dead) continue;
        if (currentState == states.victory) continue;
        var _dist = point_distance(other.x, other.y, x, y);
        if (_dist < _nearestDist) {
            _nearestDist = _dist;
            homeTarget   = id;
        }
    }

    // steer toward target
    if (instance_exists(homeTarget)) {
        var _targetAngle = point_direction(x, y, homeTarget.x, homeTarget.y);
        dirAngle         = angle_difference(_targetAngle, dirAngle) > 0
            ? dirAngle + min(homeTurnSpeed * god.gameSpeed, angle_difference(_targetAngle, dirAngle))
            : dirAngle - min(homeTurnSpeed * god.gameSpeed, -angle_difference(_targetAngle, dirAngle));
    }

    // move in current direction
    x += lengthdir_x(homeSpeed * god.gameSpeed, dirAngle);
    y += lengthdir_y(homeSpeed * god.gameSpeed, dirAngle);

    // update facing for sprite flip
    facing = (cos(degtorad(dirAngle)) >= 0) ? 1 : -1;

    // player collision
    var _hit = false;
    with (oPlayer) {
        if (_hit) continue;
        if (id == other.owner) continue;
        if (team == other.team && other.team != teams.none) continue;
        if (currentState == states.dead) continue;
        if (currentState == states.victory) continue;
        if (place_meeting(x, y, other)) {
            _hit = true;
        }
    }
    if (_hit) {
        dagger_projectile_arrive();
    }