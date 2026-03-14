// =====================
// LAYER 1: Background sprite
// =====================
draw_sprite_stretched(spr_background_castle, 0, 0, 0, room_width, room_height);
// =====================
// LAYER 2: Translucent dark overlay
// =====================
draw_set_alpha(0.55); // adjust 0.0 (invisible) to 1.0 (fully black) to taste
draw_set_colour(c_black);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);
draw_set_colour(c_white);