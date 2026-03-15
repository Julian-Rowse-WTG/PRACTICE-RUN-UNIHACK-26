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
var _hit     = false;
var _myOwner = owner;
var _myTeam  = team;

with (oPlayer) {
    if (_hit) continue;
    if (team == _myTeam && _myTeam != teams.none && id != _myOwner) continue;
    
    // check ignore list
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

        if (id == _myOwner) {
            // owner touched their own sword — soft knockback, cancel special state
            hit       = true;
            hitBy     = noone;
            xHit      = other.speed_x > 0 ? 3 : -3; // push away from sword direction
            yHit      = -2;
            hitStun   = 15;
            damage    = 0;  // no damage to self
            hitFacing = facing * -1;
            hitDepth  = other.depth;
            // force soft knockdown
            comboCount[_myOwner.player] = 1;
            // cancel special state
            currentState    = states.normal;
            specialFired    = false;
            specialProjectile = noone;
            specialCooldown = specialCooldownMax * 0.5; // half cooldown penalty
        } else {
            // normal enemy hit
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
        }
        _hit = true;
    }
}

if (_hit) {
    if (instance_exists(_myOwner) && id != _myOwner) {
        _myOwner.specialProjectile = noone;
    }
    instance_destroy();
    exit;
}