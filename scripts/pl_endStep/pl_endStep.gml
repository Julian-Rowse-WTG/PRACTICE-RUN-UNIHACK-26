function pl_endStep() {
    event_inherited();

    // tick combo timers and reset expired ones
    for (var _i = 0; _i < 4; _i++) {
        if (comboTimer[_i] > 0) {
            comboTimer[_i] -= god.gameSpeed;
            if (comboTimer[_i] <= 0) {
                comboTimer[_i] = 0;
                comboCount[_i] = 0;
            }
        }
    }

    // tick soft hitstun
    if (softHitStun > 0) {
        softHitStun -= god.gameSpeed;
        if (softHitStun <= 0) {
            softHitStun = 0;
            if (currentState == states.softKnock) {
                state_reset();
            }
        }
    }

    switch (currentState) {
        case states.normal:
            pl_normalState();
        break;
        case states.attack:
            pl_attackState();
        break;
        case states.dash:
            pl_dashState();
        break;
        case states.recovery:
            pl_recoveryState();
        break;
        case states.tumble:
            pl_tumbleState();
        break;
        case states.block:
            pl_blockState();
        break;
        case states.burst:
            pl_burstState();
        break;
        case states.softKnock:
            pl_softKnockState();
        break;
    }

// hit handling
if (hit) {
    // safety check — burst reversal hits don't use hitBy
    var _attackerSlot = -1;
    var _isSuper      = false;
    if (hitBy != -1 && instance_exists(hitBy) && instance_exists(hitBy.owner)) {
        _attackerSlot = hitBy.owner.player;
        _isSuper      = hitBy.owner.superMode;
    }

    if (blocking) {
        if (_attackerSlot != -1) {
            comboCount[_attackerSlot] = 0;
            comboTimer[_attackerSlot] = 0;
        }
        var _reduction = blockReduction;
        if (superMode) _reduction = min(_reduction * 2, 0.9);
        hp -= floor(damage * _reduction);
        hp  = max(hp, 0);
        god.shake     = true;
        god.freeze    = true;
        god.freezeDur = 2;
        hit = false;
    } else {
        if (_attackerSlot != -1) {
            comboCount[_attackerSlot]++;
            comboTimer[_attackerSlot] = comboTimeoutMax;
        }
        var _hardKnock = (_isSuper || (_attackerSlot != -1 && comboCount[_attackerSlot] % hardKnockEvery == 0));

        if (_hardKnock) {
            superMode    = false;
            squash_stretch(1.5, 1.5);
            weaponSprite  = sprEmpty;
            god.shake     = true;
            god.freeze    = true;
            y--;
            xSpeed        = xHit;
            ySpeed        = yHit;
            facing        = hitFacing;
            depth         = hitDepth;
            hitStun       = hitStun;
            currentState  = states.tumble;
            hp -= damage;
            hp  = max(hp, 0);
        } else {
            softHitStun  = floor(hitStun * softHitStunScale);
            xSpeed       = xHit * softKnockXScale * facing * -1;
            ySpeed       = yHit * softKnockYScale;
            god.shake    = true;
            god.freeze   = true;
            god.freezeDur = 2;
            currentState = states.softKnock;
            hp -= damage;
            hp  = max(hp, 0);
        }
        hit = false;
    }
}

    hbox_update();
    pl_animation();
    pl_destroy();
}