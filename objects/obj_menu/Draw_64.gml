// =====================
// LAYER 1: Background sprite
// =====================
draw_sprite_stretched(spr_background_jungle, 0, 0, 0, display_get_gui_width(), display_get_gui_height());

// =====================
// LAYER 2: Translucent dark overlay
// =====================
draw_set_alpha(0.3); // adjust 0.0 (invisible) to 1.0 (fully black) to taste
draw_set_colour(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);
draw_set_colour(c_white);

// =====================
// LAYER 3: Menu text
// =====================
draw_set_font(VT323);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var basescale = 1.7;
for (var i = 0; i < array_length(options); i++) {
    var draw_x = menu_x;
    var draw_y = menu_y + i * spacing;
    if (i == selection) {
        var scale = (basescale * 1.1) + 0.015 * sin(current_time / 150);
        var ripple = 0.5 + 0.5 * sin(current_time / 225);
        var col_outer = make_color_rgb(255, 215, 0);
        var col_inner = make_color_rgb(255, 210, 0);
        // Glow layer
        draw_set_alpha(0.35);
        draw_text_transformed_colour(
            draw_x, draw_y, options[i],
            scale * 1.05, scale * 1.05, 0,
            col_inner, col_inner, col_outer, col_outer, 0.35
        );
        draw_set_alpha(1);
        // Main selected text
        draw_text_transformed_colour(
            draw_x, draw_y, options[i],
            scale, scale, 0,
            col_outer, col_outer, col_inner, col_inner, 1
        );
        draw_set_colour(c_white);
        draw_set_alpha(1);
    }
    else {
        draw_set_colour(c_white);
        draw_text_transformed(draw_x, draw_y, options[i], basescale, basescale, 0);
    }
}