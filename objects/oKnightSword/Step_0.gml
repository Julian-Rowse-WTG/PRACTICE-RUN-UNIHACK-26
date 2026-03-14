if (embedded) {
    // count down embed timer
    embedTimer -= god.gameSpeed;
    if (embedTimer <= 0) {
        // destroy platform then self
        if (instance_exists(platform)) {
            instance_destroy(platform);
        }
        instance_destroy();
        if (instance_exists(owner)) {
            owner.specialProjectile = noone;
        }
    }
    exit;
}

// move
x += speed_x * god.gameSpeed;

// flip sprite to match direction
image_xscale = facing;

// check wall collision
if (place_meeting(x + speed_x, y, parentBlocker)) {
    sword_projectile_embed();
    exit;
}

// check player collision
// check player collision
var _hit = false;
with (oPlayer) {
    if (_hit) continue;
    if (id == other.owner) continue;
    if (team == other.team && team != teams.none) continue;
    if (place_meeting(x, y, other)) {
        hit       = true;
        hitBy     = noone;
        xHit      = (other.speed_x > 0) ? other.knockback : -other.knockback;
        yHit      = -3;
        hitStun   = other.hitStun;
        damage    = other.damage;
        hitFacing = other.facing * -1;
        hitDepth  = other.depth;
        comboCount[other.owner.player] = other.owner.hardKnockEvery;
        god.shake     = true;
        god.freeze    = true;
        god.freezeDur = 3;
        _hit = true;
    }
}
if (_hit) {
    if (instance_exists(owner)) {
        owner.specialProjectile = noone;
    }
    instance_destroy();
    exit;
}