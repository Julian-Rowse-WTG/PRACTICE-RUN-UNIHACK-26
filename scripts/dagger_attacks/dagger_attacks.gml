function dagger_attacks() {
	//create hitboxes based on specific frames during the attack
	//and position the hitbox relative to the current weapon and attack
	var _dmg = 7 * (superMode ? superDamage : 1);
	
	switch(subState){    
	    case attacks.side_ground:
	    case attacks.side_air:
	        if(frame_check(1,0)){
	            hitbox_create(-2*facing,-16,20*facing,12,5,2*facing,-2,60,_dmg);
	        }
	    break;
    
	    case attacks.up_ground:
	    case attacks.up_air:
	        if(frame_check(1,0)){
	            hitbox_create(-10*facing,-35,18*facing,20,5,2*facing,-4,60,_dmg);
	        }        
	    break;
    
	    case attacks.down_ground:
	    case attacks.down_air:
	        if(frame_check(1,0)){
	            hitbox_create(-4*facing,-9,22*facing,18,5,3*facing,3,60,_dmg);
	        }  
	    break;
	}



}
