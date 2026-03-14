
if (embedded) {
    embedTimer -= god.gameSpeed;
    if (embedTimer <= 0) {
        if (instance_exists(owner)) {
            owner.specialProjectile = noone;
        }
        instance_destroy();
    }
    exit;
}

// move
x += speed_x * god.gameSpeed;
image_xscale = facing;

// hit wall — embed and teleport owner
if (place_meeting(x + speed_x, y, parentBlocker)) {
    dagger_projectile_arrive();
    exit;
}

// hit player — teleport owner to player position
var _hit = false;
with (oPlayer) {
    if (_hit) continue;
    if (id == other.owner) continue;
    if (team == other.team && team != teams.none) continue;
    if (place_meeting(x, y, other)) {
        _hit = true;
    }
}
if (_hit) {
    dagger_projectile_arrive();
}