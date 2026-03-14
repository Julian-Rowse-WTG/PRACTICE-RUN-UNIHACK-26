event_inherited();
// stats
hpMax           = 100;
hp              = hpMax;
canCharge       = false;
block_reduction = 0.4;  // slightly worse block than knight
burstMax        = 2;    // more bursts to compensate for low hp
burstCharges    = burstMax;
superDamage     = 1.75; // hits harder in super
burstDamage     = 2;
burstKnockback  = 4;
burstHitStun    = 20;
comboTimeoutMax = 90;   // 1.5 seconds — faster, more aggressive
hardKnockEvery  = 5;
// special
specialProjectileObject = oDemonOrb;
specialPlatformDur      = 180; // 3 seconds before projectile vanishes if not arrived
specialCooldownMax = 240;       // 4 seconds — faster cooldown than knight
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
teleportInvincibleMax = 5;
arrivalAttackFired  = false;

// attacks function
_attacks = dagger_attacks;
// frame data
fd_side = fd_dagger_side;
fd_up   = fd_dagger_up;
fd_down = fd_dagger_down;
specialFd = fd_dagger_special;
fd_victory    = fd_dagger_victory;