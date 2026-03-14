/// @description movement
function pl_normalState() {
	mSpeed = mSpeedDefault;

	//move left and right
	if(left){
	    xSpeed = approach(xSpeed,-mSpeed,aSpeed * god.gameSpeed);
	}else if(right){
	    xSpeed = approach(xSpeed,mSpeed,aSpeed * god.gameSpeed);
	}else{
	    xSpeed = approach(xSpeed,0,aSpeed * god.gameSpeed);
	}

	//jump if you are on the ground and not holding the jump button
	if(onGround){
	    if(jump && !jumpHold){
	        ySpeed = jPower;
	        squash_stretch(0.7,1.3);
	    }
	}

	//jump code
	jump_control();
	
	// block — down + block input, only on ground
	if (block && !blockHold && onGround) {
	    blocking = true;
	    currentState = states.block;
	    frame_reset();
	    exit;
	}
// burst input detection
    if (attack && !attackHold) burstWindow = burstWindowMax;
    if (special && !specialHold) burstWindow = burstWindowMax;
    if (burstWindow > 0) burstWindow--;
    if (attack && special && burstWindow > 0) {
        pl_burstActivate();
        exit;
    }
	
	// special input
	if (special && !specialHold && specialCooldown <= 0 && specialProjectile == noone) {
	    currentState = states.special;
	    frame_reset();
	    exit;
	}

    // attack
    if (attack && !attackHold) {
        if (onGround) {
            if (up) {
                subState = attacks.up_ground;
                squash_stretch(0.7, 1.3);
            } else if (down) {
                subState = attacks.down_ground;
                squash_stretch(0.7, 1.3);
            } else {
                subState = attacks.side_ground;
                squash_stretch(1.3, 0.7);
            }
        } else {
            if (up) {
                subState = attacks.up_air;
                squash_stretch(0.7, 1.3);
            } else if (down) {
                subState = attacks.down_air;
                squash_stretch(0.7, 1.3);
            } else {
                subState = attacks.side_air;
                squash_stretch(1.3, 0.7);
            }
        }
        currentState = states.attack;
        frame_reset();
        audio_play_sound(sfx_attack, 1, false);
    }

    // dash
    if (dash && !dashHold) {
        var _dashed = false;
        if (!onGround) {
            if (!airDash) {
                dashDur = dashDurMax;
                xSpeed  = 7 * facing;
                squash_stretch(1.3, 0.7);
                currentState = states.dash;
                airDash = true;
                _dashed = true;
            }
        } else {
            dashDur = dashDurMax;
            xSpeed  = 7 * facing;
            squash_stretch(1.3, 0.7);
            currentState = states.dash;
            _dashed = true;
        }
        if (_dashed) {
            audio_play_sound(sound_dash_wind, 1, false);
        }
    }

    if (onGround) {
        airDash = false;
    }
}
