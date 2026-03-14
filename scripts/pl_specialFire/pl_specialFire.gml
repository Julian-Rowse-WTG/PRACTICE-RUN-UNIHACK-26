function pl_specialFire() {
    var _proj = instance_create_layer(x, y - 11, "Instances", oKnightSword);
    _proj.owner       = id;
    _proj.team        = team;
    _proj.facing      = facing;
    _proj.speed_x     = specialSpeed * facing;
    _proj.damage      = specialDamage * (superMode ? superDamage : 1);
    _proj.knockback   = specialKnockback;
    _proj.hitStun     = specialHitStun;
    _proj.platformDur = specialPlatformDur;
    specialProjectile = _proj;
}	