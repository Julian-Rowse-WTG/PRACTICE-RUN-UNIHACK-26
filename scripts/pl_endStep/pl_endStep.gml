function pl_endStep() {
    event_inherited();

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
    }

    // hit handling
    if (hit) {
        if (blocking) {
            // calculate block reduction — doubled in super, capped at 0.9
            var _reduction = blockReduction;
            if (superMode) _reduction = min(_reduction * 2, 0.9);
            hp -= floor(damage * _reduction);
            hp  = max(hp, 0);
            // lighter hitstop on block
            god.shake     = true;
            god.freeze    = true;
            god.freezeDur = 2;
            hit = false;
        } else {
            // end super mode on full knockback hit
            superMode = false;
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
            // apply damage — multiplied in super mode if attacker is in super
            hp -= damage;
            hp  = max(hp, 0);
            hit = false;
        }
    }

    hbox_update();
    pl_animation();
    pl_destroy();
}