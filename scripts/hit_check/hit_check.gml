function hit_check() {
    //hitbox
    if(hitbox != -1){
        with(hitbox){
            //collision check  
            //checking the collision from the hurtbox object
with(oHurtbox){
    if (!instance_exists(other)) continue;
    if (!instance_exists(owner)) continue;
    if(place_meeting(x,y,other) && other.owner != owner){
        with(other){
            if (!instance_exists(owner)) continue;
            for(i = 0; i < ds_list_size(ignoreList); i++){
                if(ignoreList[|i] = other.owner){
                    ignore = true;
                    break;
                }
            }
            if(!ignore && !other.owner.invincible && instance_exists(other.owner)){
                // don't hit dead players
                if (other.owner.currentState == states.dead) continue;
                other.owner.hit       = true;
                other.owner.hitBy     = id;
                other.owner.xHit      = xHit;
                other.owner.yHit      = yHit;
                other.owner.hitStun   = hitStun;
                other.owner.damage    = damage;
                other.owner.hitDepth  = depth;
                other.owner.hitFacing = owner.facing * -1;
                ds_list_add(ignoreList, other.owner);
            }
        }
    }
}
        }
    }
}