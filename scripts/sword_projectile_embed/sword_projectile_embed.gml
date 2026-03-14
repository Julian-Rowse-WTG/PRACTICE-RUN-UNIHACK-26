function sword_projectile_embed() {
    embedded   = true;
    embedTimer = platformDur;
    image_index = 1; // frame 1 = embedded sprite
    image_speed = 0;
	speed_x    = 0;

    // spawn invisible parentBlocker at projectile position
    platform = instance_create_layer(x, y, "Instances", parentBlocker);
    platform.image_xscale = sprite_get_width(sprSword_Projectile) / sprite_get_width(platform.sprite_index);
    platform.visible = false;

    if (instance_exists(owner)) {
        owner.specialProjectile = noone;
        owner.specialCooldown   = owner.specialCooldownMax;
    }
}