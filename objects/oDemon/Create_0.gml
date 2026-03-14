event_inherited();
// stats
hpMax           = 70;
hp              = hpMax;
canCharge       = false;
block_reduction = 0.4;  // slightly worse block than knight
burstMax        = 3;    // more bursts to compensate for low hp
burstCharges    = burstMax;
superDamage     = 1.75; // hits harder in super
burstDamage     = 5;
burstKnockback  = 4;
burstHitStun    = 20;
comboTimeoutMax = 90;   // 1.5 seconds — faster, more aggressive
hardKnockEvery  = 3;
// special
specialCooldownMax = 240;       // 4 seconds — faster cooldown than knight
specialSprite      = sprEmpty;
specialFd          = fd_dagger_special;
specialDamage      = 10;
specialKnockback   = 4;
specialHitStun     = 25;
specialSpeed       = 10;        // faster projectile than knight
specialPlatformDur = 300;
specialFired       = false;
// burst
burstSprite = sprDagger_Special;
// body sprites — full sprites, no overlay
idleSprite         = sprDagger_Idle;
runSprite          = sprDagger_Run;
jumpSprite         = sprDagger_Jump_Body;
blockSprite        = sprEmpty;
recoverySprite     = sprEmpty;
hitSprite          = sprEmpty;
tumbleGroundSprite = sprDagger_Dead;
tumbleAirSprite    = sprDagger_Dead;
deadSprite         = sprDagger_Dead;
// no weapon overlays
weaponIdle   = sprDagger_Idle;
weaponRun    = sprDagger_Run;
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
// attacks function
_attacks = dagger_attacks;
// frame data
fd_side = fd_dagger_side;
fd_up   = fd_dagger_up;
fd_down = fd_dagger_down;