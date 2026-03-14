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

        // Top/bottom colors shift over time
        //var col_outer = merge_color(make_color_rgb(220, 170, 0), make_color_rgb(255, 215, 0), ripple);
        //var col_inner = merge_color(make_color_rgb(255, 240, 30), make_color_rgb(255, 255, 90), ripple);
		var col_outer = make_color_rgb(255, 215, 0);
		var col_inner = make_color_rgb(255, 210, 0)
        // Approximate center-out glow by layering text
        draw_set_alpha(0.35);
        draw_text_transformed_colour(
            draw_x, draw_y, options[i],
            scale * 1.05, scale * 1.05, 0,
            col_inner, col_inner, col_outer, col_outer, 0.35
        );

        draw_set_alpha(1);
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