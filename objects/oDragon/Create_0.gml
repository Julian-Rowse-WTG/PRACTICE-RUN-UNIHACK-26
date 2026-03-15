event_inherited();
// stats
hpMax           = 130;
hp              = hpMax;
canCharge       = false;
blockReduction  = 0.7;
burstMax        = 2;
burstCharges    = burstMax;
superDamage     = 1.3;
burstDamage     = 2;
burstKnockback  = 4;
burstHitStun    = 20;
comboTimeoutMax = 130;
hardKnockEvery  = 4;
jPower        = -10;
// special
specialCooldownMax     = 360;       // 6 seconds
specialSprite          = sprSpear_Special;
specialFd              = fd_spear_special;
specialDamage          = 10;
specialKnockback       = 6;
specialHitStun         = 35;
specialSpeed           = 7;
specialPlatformDur     = 300;
specialFired           = false;
specialProjectileObject = oSpearSpike;
// burst
burstSprite     = sprSpear_Special;
// body sprites
idleSprite         = sprSpear_Idle;
runSprite          = sprSpear_Run;
jumpSprite         = sprSpear_Jump;
blockSprite        = sprSpear_Block;
recoverySprite     = sprSpear_Recovery;
hitSprite          = sprSpear_Hit;
tumbleGroundSprite = sprSpear_Dead;
tumbleAirSprite    = sprSpear_Dead;
deadSprite         = sprSpear_Dead;

// no overlays
weaponIdle   = sprEmpty;
weaponRun    = sprEmpty;
weaponJump   = sprEmpty;
weaponDash   = sprSpear_Dash;
weaponSprite = sprEmpty;
// attack sprites
sideSpriteG = sprSpear_Attack_Side_G;
sideSpriteA = sprSpear_Attack_Side_A;
upSpriteG   = sprSpear_Attack_Up_G;
upSpriteA   = sprSpear_Attack_Up_A;
downSpriteG = sprSpear_Attack_Down_G;
downSpriteA = sprSpear_Attack_Down_A;

hurtbox.xOffset = -16 * facing;
hurtbox.yOffset = -24;
hurtbox.xScale  = 38;
hurtbox.yScale  = 15;

// attacks function
_attacks = spear_attacks;
// frame data
fd_side     = fd_spear_side;
fd_up       = fd_spear_up;
fd_down     = fd_spear_down;
// victory
victorySprite = sprSpear_Victory;
fd_victory    = fd_spear_victory;
// sounds
sfx_attack  = sound_dragon_attack;
sfx_hit     = sound_dragon_is_hit;
sfx_special = sound_dragon_ultimate_attack;

_specialFire = function() {
    var _proj          = instance_create_layer(x, y - 11, "Instances", oSpearSpike);
    _proj.owner        = id;
    _proj.team         = team;
    _proj.facing       = facing;
    _proj.speed_x      = specialSpeed * facing;
    _proj.damage       = specialDamage * (superMode ? superDamage : 1);
    _proj.launchDamage = specialDamage * 2 * (superMode ? superDamage : 1);
    _proj.launchSpeed  = -12;
    _proj.hitStun      = specialHitStun;
    _proj.embedTimer   = 120;
    specialProjectile  = _proj;
};