// move
x += speed_x * god.gameSpeed;

// hit wall — vanish
if (place_meeting(x + speed_x, y, parentBlocker)) {
    if (instance_exists(owner)) owner.specialProjectile = noone;
    instance_destroy();
    exit;
}

// check player collision — pierces through all enemies
with (oPlayer) {
    if (id == other.owner) continue;
    if (team == other.team && other.team != teams.none) continue;
    if (currentState == states.dead) continue;
	if (currentState == states.victory) continue;
    // ignore list check
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
        // hard knockdown
        hit       = true;
        hitBy     = noone;
        xHit      = other.speed_x > 0 ? other.damage : -other.damage;
        yHit      = -3;
        hitStun   = other.hitStun;
        damage    = other.damage * (instance_exists(other.owner) && other.owner.superMode ? other.owner.superDamage : 1);
        hitFacing = other.facing * -1;
        hitDepth  = other.depth;
        // force hard knockdown
        comboCount[other.owner.player] = other.owner.hardKnockEvery;
        god.shake     = true;
        god.freeze    = true;
        god.freezeDur = 3;
    }
}