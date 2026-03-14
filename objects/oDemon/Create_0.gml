event_inherited();
hpMax       = 1;
hp          = hpMax;
canCharge   = false;
// full sprites — no overlay
idleSprite         = sprDagger_Idle;
runSprite          = sprDagger_Run;
jumpSprite         = sprDagger_Jump;
//blockSprite        = sprDagger_Block;
//recoverySprite     = sprDagger_Recovery;
//hitSprite          = sprDagger_Hit;
//tumbleGroundSprite = sprDagger_Tumble_Ground;
//tumbleAirSprite    = sprDagger_Tumble_Air;
//deadSprite         = sprDagger_Dead;
// no overlays
weaponIdle   = sprEmpty;
weaponRun    = sprEmpty;
weaponJump   = sprEmpty;
weaponDash   = sprEmpty;
weaponSprite = sprDagger_Idle;
comboTimeoutMax = 90;  // 1.5 seconds — faster, more aggressive
hardKnockEvery  = 3;
// attack sprites
sideSpriteG = sprDagger_Attack_Side_G;
sideSpriteA = sprDagger_Attack_Side_A;
upSpriteG   = sprDagger_Attack_Up_G;
upSpriteA   = sprDagger_Attack_Up_A;
downSpriteG = sprDagger_Attack_Down_G;
downSpriteA = sprDagger_Attack_Down_A;
_attacks = dagger_attacks;
fd_side = fd_dagger_side;
fd_up   = fd_dagger_up;
fd_down = fd_dagger_down;