// horizontal: flip xscale for direction
// vertical: rotate 90 degrees
if (isVertical) {
    draw_sprite_ext(sprSpear_Projectile, 0, x, y, 1, -1, -90, c_white, 1);
} else {
    draw_sprite_ext(sprSpear_Projectile, 0, x, y, facing, 1, 0, c_white, 1);
}