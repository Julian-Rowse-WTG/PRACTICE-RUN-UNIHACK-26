function spear_launch_vertical(_target, _owner, _team, _facing, _depth, _launchDmg, _launchSpd) {
    var _superMult = (instance_exists(_owner) && _owner.superMode) ? _owner.superDamage : 1;
    var _finalDmg  = _launchDmg * _superMult;

    // spawn vertical projectile at target position
    var _vert        = instance_create_layer(_target.x, _target.y, "Instances", oSpearSpike);
    _vert.owner      = _owner;
    _vert.team       = _team;
    _vert.facing     = _facing;
    _vert.speed_x    = 0;
    _vert.speed_y    = _launchSpd;
    _vert.damage     = _finalDmg;
    _vert.hitStun    = 40;
    _vert.isVertical = true;
    _vert.isBounced  = false;
    _vert.embedTimer = 120;
    // orient sprite upward — 90 degrees, pointing up from middle-left origin
    _vert.angle      = -90;

    // apply upward hard knockdown to target
    _target.hit      = true;
    _target.hitBy    = noone;
    _target.xHit     = 0;
    _target.yHit = _launchSpd * 3.5; // stronger upward launch
    _target.hitStun  = 40;
    _target.damage   = _finalDmg;
    _target.hitFacing = _facing * -1;
    _target.hitDepth  = _depth;
    if (instance_exists(_owner)) {
        _target.comboCount[_owner.player] = _target.hardKnockEvery;
    }

    god.shake     = true;
    god.freeze    = true;
    god.freezeDur = 5;
}