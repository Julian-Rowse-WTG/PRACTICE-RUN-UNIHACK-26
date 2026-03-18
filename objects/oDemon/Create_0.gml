event_inherited();
// stats
hpMax           = 110;
hp              = hpMax;
canCharge       = false;
block_reduction = 0.4;  // slightly worse block than knight
burstMax        = 3;    // more bursts to compensate for low hp
burstCharges    = burstMax;
superDamage     = 1.75; // hits harder in super
burstDamage     = 2;
burstKnockback  = 4;
burstHitStun    = 20;
comboTimeoutMax = 90;   // 1.5 seconds — faster, more aggressive
hardKnockEvery  = 3;
// special
specialProjectileObject = oDemonOrb;
specialPlatformDur      = 180; // 3 seconds before projectile vanishes if not arrived
specialCooldownMax = 180;       // 4 seconds — faster cooldown than knight
specialSprite      = sprDagger_Special;
specialDamage      = 10;
specialKnockback   = 4;
specialHitStun     = 25;
specialSpeed       = 10;        // faster projectile than knight
specialPlatformDur = 300;
specialFired       = false;
// burst
burstSprite = sprDagger_Special;
victorySprite = sprDagger_Victory;
// body sprites — full sprites, no overlay
idleSprite         = sprDagger_Idle;
runSprite          = sprDagger_Run;
jumpSprite         = sprDagger_Jump_Body;
blockSprite        = sprDagger_Block;
recoverySprite     = sprDagger_Recovery;
hitSprite          = sprDagger_Hit;
tumbleGroundSprite = sprDagger_Dead;
tumbleAirSprite    = sprDagger_Dead;
deadSprite         = sprDagger_Dead;
// no weapon overlays
weaponIdle   = sprDagger_Idle;
weaponRun    = sprEmpty;
weaponJump   = sprDagger_Jump;
weaponDash   = sprDagger_Idle;
weaponSprite = sprDagger_Idle;
// attack sprites
sideSpriteG = sprDagger_Attack_Side_G;
sideSpriteA = sprDagger_Attack_Side_A;
upSpriteG   = sprDagger_Attack_Up_G;
upSpriteA   = sprDagger_Attack_Up_A;
downSpriteG = sprDagger_Attack_Down_G;
downSpriteA = sprDagger_Attack_Down_A;

teleportInvincible  = 0;
teleportInvincibleMax = 30;
arrivalAttackFired  = false;

// attacks function
_attacks = dagger_attacks;
// frame data
fd_side = fd_dagger_side;
fd_up   = fd_dagger_up;
fd_down = fd_dagger_down;
specialFd = fd_dagger_special;
fd_victory    = fd_dagger_victory;
// sounds
sfx_attack  = sound_demon_attack;
sfx_hit     = sound_demon_is_hit;
sfx_special = sound_demon_ultimate_attack;

_specialFire = function() {
    // find nearest enemy
    var _nearest     = noone;
    var _nearestDist = 999999;
    with (oPlayer) {
        if (id == other.id) continue;
        if (team == other.team && other.team != teams.none) continue;
        if (currentState == states.dead) continue;
        if (currentState == states.victory) continue;
        var _dist = point_distance(x, y, other.x, other.y);
        if (_dist < _nearestDist) {
            _nearestDist = _dist;
            _nearest     = id;
        }
    }
    // no valid target — cancel and refund cooldown
    if (_nearest == noone) {
        specialCooldown = 0;
        state_reset();
        exit;
    }

    // try several positions around the target until a valid one is found
    var _destX  = _nearest.x;
    var _destY  = _nearest.y;
    var _found  = false;

    // candidate offsets to try — beside, below, above target
    var _offsets = [
        [facing * -32, 0  ],  // beside in facing direction
        [facing *  32, 0  ],  // beside opposite direction
        [facing * -32, 16 ],  // beside and down
        [facing *  32, 16 ],
        [0,            16 ],  // directly below
        [facing * -48, 0  ],  // further beside
        [facing *  48, 0  ],
        [0,            32 ],  // further below
    ];

    for (var _i = 0; _i < array_length(_offsets); _i++) {
        var _tx = _nearest.x + _offsets[_i][0];
        var _ty = _nearest.y + _offsets[_i][1];
        if (!place_meeting(_tx, _ty, parentBlocker)) {
            _destX = _tx;
            _destY = _ty;
            _found = true;
            break;
        }
    }

    // no valid position found — cancel and refund cooldown
    if (!_found) {
        specialCooldown = 0;
        state_reset();
        exit;
    }

    // teleport to valid position
    x      = _destX;
    y      = _destY;
    xSpeed = 0;
    ySpeed = 0;

    // grant invincibility
    teleportInvincible = teleportInvincibleMax;
    invincible         = true;

    // trigger arrival attack
    subState     = attacks.side_air;
    currentState = states.attack;
    xSpeed       = facing * 3;
    ySpeed       = -2;
    frame_reset();
    squash_stretch(1.3, 0.7);
    god.shake     = true;
    god.freeze    = true;
    god.freezeDur = 3;
    specialCooldown = specialCooldownMax;
};