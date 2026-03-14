event_inherited();
// stats
hpMax       = 100;
hp          = hpMax;
canCharge   = false;
block_reduction = 0.3;
burstMax    = 2;
burstCharges = burstMax;
superDamage = 1.5;
burstSprite = sprSword_Hit;
comboTimeoutMax = 120; // 2 seconds
hardKnockEvery  = 3;
// special
specialCooldownMax = 300;       // 5 seconds
specialSprite      = sprSword_Special;
specialDamage    = 12;  // slightly stronger than a normal hit
specialKnockback = 5;
specialHitStun   = 30;
specialSpeed     = 8;
burstDamage      = 5;   // burst reversal deals light damage
specialPlatformDur = 300;       // 5 seconds at 60fps
// burst
burstSprite        = sprSword_Special; // same as special for now

// body sprites
idleSprite         = sprSword_Idle_Body;
runSprite          = sprSword_Run_Body;
jumpSprite         = sprSword_Jump_Body;
blockSprite        = sprSword_Block;
recoverySprite     = sprSword_Recovery;
hitSprite          = sprSword_Hit;
tumbleGroundSprite = sprSword_Dead;
tumbleAirSprite    = sprSword_Dead;
deadSprite         = sprSword_Dead;
// weapon overlays
weaponIdle   = sprSword_Idle;
weaponRun    = sprSword_Run;
weaponJump   = sprSword_Jump;
weaponDash   = sprSword_Dash;
weaponSprite = sprSword_Idle;
// attack sprites
sideSpriteG = sprSword_Attack_Side_G;
sideSpriteA = sprSword_Attack_Side_A;
upSpriteG   = sprSword_Attack_Up_G;
upSpriteA   = sprSword_Attack_Up_A;
downSpriteG = sprSword_Attack_Down_G;
downSpriteA = sprSword_Attack_Down_A;
// attacks function
_attacks = sword_attacks;
// frame data
specialFd = fd_sword_special;
fd_side = fd_sword_side;
fd_up   = fd_sword_up;
fd_down = fd_sword_down;