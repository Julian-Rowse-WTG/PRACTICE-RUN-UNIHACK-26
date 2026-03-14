function pl_animation() {
    xPos = x;
    yPos = y;
    xScale = approach(xScale, 1, 0.05);
    yScale = approach(yScale, 1, 0.05);
    currentSprite = sprite;

    if (onGround) {
        if (!landed) {
            squash_stretch(1.3, 0.7);
            landed = true;
        }
    } else {
        landed = false;
    }

    switch (currentState) {
		case states.special:
		    animation_set(specialFd, specialSprite);
		    weaponSprite = sprEmpty;
		break;

        case states.normal:
            if (onGround) {
                if (!left && !right) {
                    if (down) {
                        // crouch — uses recovery sprite while crouching
                        animation_set(fd_pl_idle, recoverySprite);
                        weaponSprite = sprEmpty;
                    } else {
                        animation_set(fd_pl_idle, idleSprite);
                        weaponSprite = weaponIdle;
                    }
                } else {
                    animation_set(fd_pl_run, runSprite);
                    weaponSprite = weaponRun;
                }
            } else {
                animation_set(fd_pl_jump, jumpSprite);
                weaponSprite = weaponJump;
                if (ySpeed < 1) {
                    currentFrame = 0;
                } else {
                    currentFrame = 1;
                }
            }
            if (left) {
                facing = -1;
            } else if (right) {
                facing = 1;
            }
        break;
		
		case states.softKnock:
		    animation_set(fd_pl_tumble, hitSprite);
		    weaponSprite = sprEmpty;
		break;

		case states.victory:
		    animation_set(fd_victory, victorySprite);
		    weaponSprite = sprEmpty;
		break;
		
        case states.dash:
            animation_set(fd_pl_roll, sprPlayer_Dash_Base);
            weaponSprite = weaponDash;
        break;
		
		case states.burst:
		    animation_set(fd_pl_idle, burstSprite);
		    weaponSprite = sprEmpty;
		break;

        case states.block:
            animation_set(fd_pl_idle, blockSprite);
            weaponSprite = sprEmpty;
        break;

        case states.dead:
            animation_set(fd_pl_dead, deadSprite);
            weaponSprite = sprEmpty;
        break;

        case states.attack:
            switch (subState) {
                case attacks.side_ground:
                    animation_set(fd_side, sideSpriteG);
                    weaponSprite = sprEmpty;
                break;
                case attacks.side_air:
                    animation_set(fd_side, sideSpriteA);
                    weaponSprite = sprEmpty;
                break;
                case attacks.up_ground:
                    animation_set(fd_up, upSpriteG);
                    weaponSprite = sprEmpty;
                break;
                case attacks.up_air:
                    animation_set(fd_up, upSpriteA);
                    weaponSprite = sprEmpty;
                break;
                case attacks.down_ground:
                    animation_set(fd_down, downSpriteG);
                    weaponSprite = sprEmpty;
                break;
                case attacks.down_air:
                    animation_set(fd_down, downSpriteA);
                    weaponSprite = sprEmpty;
                break;
            }
        break;

        case states.recovery:
            animation_set(fd_pl_recovery, recoverySprite);
            weaponSprite = sprEmpty;
        break;

        case states.tumble:
            if (god.freeze) {
                // hit freeze frame
                animation_set(fd_pl_tumble, hitSprite);
                weaponSprite = sprEmpty;
            } else {
                if (onGround) {
                    // knocked down on ground
                    animation_set(fd_pl_tumble, tumbleGroundSprite);
                    weaponSprite = sprEmpty;
                } else {
                    // flying through air
                    animation_set(fd_pl_dead, tumbleAirSprite);
                    weaponSprite = sprEmpty;
                }
            }
        break;
    }
	
	// super mode afterimage
	if (superMode && currentState != states.dead) {
	    var _after      = instance_create_layer(xPos, yPos, "Effects", oAfterimage);
	    _after.sprite   = sprite;
	    _after.frame    = currentFrame;
	    _after.facing   = facing;
	    _after.xScale   = xScale;
	    _after.yScale   = yScale;
	    _after.teamCol  = team;
	}

    if (lastSprite != currentSprite) {
        frame_reset();
        lastSprite = currentSprite;
    }
}