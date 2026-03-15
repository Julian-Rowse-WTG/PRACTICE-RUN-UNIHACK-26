function pl_create() {
    event_inherited();
	_specialFire = function() {}; // no-op default
	victoryAnim     = false;
	victoryAnimDone = false;
	victorySprite   = sprEmpty;
	fd_victory      = fd_victory; // overridden per character
	isSolo          = false; // true if this player is outnumbered alone
	soloSuperLocked = false; // true when super is permanently locked on
    landed = 0;
	player    = 0;
	inputType = inputType.keyboard;
	inputSlot = 0;
	team      = teams.none;
    // buttons
    up        = false;
    down      = false;
    left      = false;
    right     = false;
    leftHold  = left;
    rightHold = right;
    upHold    = up;
    downHold  = down;
    jump      = false;
    jumpHold  = false;
    attack    = false;
    attackHold = false;
    dash      = false;
    dashHold  = false;
    block     = false;
    blockHold = false;
    special      = false;
    specialHold  = false;
    mash      = false;
    superJump = false;
	_tapLeft  = 0;
	_tapRight = 0;
	_tapUp    = 0;
	_tapDown  = 0;
	blocking = false;
	angle    = 0;
	// special
	specialProjectileObject = noone;
	specialCooldown    = 0;
	specialCooldownMax = 300; // overridden per character
	specialProjectile  = noone; // tracks active projectile
	specialSprite      = sprEmpty;

	teleportInvincible    = 0;
	teleportInvincibleMax = 5;
	arrivalAttackFired    = false;
	specialProjectileObject = noone;

	// burst sprite
	burstSprite        = sprEmpty;
	specialFired = false;
	// combo tracking — one counter per possible attacker slot (4 max)
	comboCount      = array_create(4, 0);   // hits received per attacker
	comboTimer      = array_create(4, 0);   // timeout per attacker
	comboTimeoutMax = 120;                  // overridden per character
	hardKnockEvery  = 3;                    // hard knockdown on every Nth hit
	// soft knockdown
	softHitStun     = 0;                    // current soft hitstun counter
	softKnockXScale = 0.4;                  // fraction of xHit applied on soft hit
	softKnockYScale = 0.2;                  // fraction of yHit applied on soft hit
	softHitStunScale = 0.35;               // fraction of hitStun applied on soft hit
    // states
    currentState = states.normal;
    lastState    = currentState;
    subState     = states.normal;
    // movement
    mSpeed        = 2;
    mSpeedDefault = mSpeed;
    aSpeed        = 0.5;
    aSpeedDefault = aSpeed;
    cSpeed        = 1;
    tSpeed        = 20;
    jPower        = -8;
    facing        = 1;
    gSpeedDefault = gSpeed;
    dashDur       = 10;
    dashDurMax    = 10;
    recoverDur    = 20;
    airDash       = true;
	frameData = -1;	
	blockReduction = 0.5; // blocks reduce damage by 50%, tune as needed
    // fighting
    hbox_init();
    hpMax     = 1;
    hp        = hpMax;
    stunDur   = 0;
    knockBack = false;
    // attack
    attackType = attacks.side_ground;
	_attacks = function() {}; // no-op default
    // hit
    hit   = false;
    hitBy = -1;
    // frame data
    pl_frameData();
    // draw
    animation_create();
    // safe sprite defaults — children override these in their own Create
    idleSprite  = sprEmpty;
    runSprite   = sprEmpty;
    jumpSprite  = sprEmpty;
    weaponIdle  = sprEmpty;
    weaponRun   = sprEmpty;
    weaponJump  = sprEmpty;
    weaponDash  = sprEmpty;
    weaponSprite = sprEmpty;
    sideSpriteG = sprEmpty;
    sideSpriteA = sprEmpty;
    upSpriteG   = sprEmpty;
    upSpriteA   = sprEmpty;
    downSpriteG = sprEmpty;
    downSpriteA = sprEmpty;
	blockSprite        = sprEmpty;
	recoverySprite     = sprEmpty;
	hitSprite          = sprEmpty;
	tumbleGroundSprite = sprEmpty;
	tumbleAirSprite    = sprEmpty;
	deadSprite         = sprEmpty;
	burstSprite = sprEmpty;
    fd_side     = fd_pl_idle;
    fd_up       = fd_pl_idle;
    fd_down     = fd_pl_idle;
	specialFd          = fd_pl_idle; // frame data for cast anim, overridden per character
    canCharge   = false;
	// burst
	burstMax        = 3;        // default, overridden per character
	burstCharges    = burstMax;
	burstDamage     = 2;        // small fixed damage on reversal
	burstKnockback  = 4;        // outward knockback force
	burstHitStun    = 20;
	burstWindow     = 0;        // input leniency timer
	burstWindowMax = 15;
	superMode       = false;
	superDamage     = 1.5;      // default multiplier, overridden per character
	burstSprite     = sprEmpty;
	// block
	blockReduction  = 0.5;	
    // sounds — overridden per character; axe and any unknown default to knight sounds
    sfx_attack  = sound_knight_attack;
    sfx_hit     = sound_knight_is_hit;
    sfx_special = sound_knight_ultimate_attack;
    // destroy
    destroy = false;
}