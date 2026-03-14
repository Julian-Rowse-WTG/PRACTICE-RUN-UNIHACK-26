// Cutscreen draw GUI event
var gw = display_get_gui_width();
var gh = display_get_gui_height();

if (cs_phase == 0) {
    // HOLD phase: full black background + "LOADING..." text + spinner
    draw_set_alpha(1);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, gw, gh, false);

    // "LOADING" text
    draw_set_font(fnt_fighter);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_text_transformed(gw * 0.5, gh * 0.5, "LOADING", 1.2, 1.2, 0);

    // Spinner: 8 line segments rotating around a point below the text
    var _cx    = gw * 0.5;
    var _cy    = gh * 0.5 + 80;
    var _r     = 22;
    var _time  = current_time / 5.0;  // degrees per millisecond → smooth rotation
    draw_set_colour(c_white);
    for (var i = 0; i < 8; i++) {
        var _angle     = _time + i * 45;
        var _seg_alpha = (i + 1) / 8.0;
        draw_set_alpha(_seg_alpha);
        var _x1 = _cx + lengthdir_x(_r * 0.45, _angle);
        var _y1 = _cy + lengthdir_y(_r * 0.45, _angle);
        var _x2 = _cx + lengthdir_x(_r, _angle);
        var _y2 = _cy + lengthdir_y(_r, _angle);
        draw_line_width(_x1, _y1, _x2, _y2, 3);
    }
    draw_set_alpha(1);
} else if (cs_phase == 1) {
    // FADE_IN phase: transparent-to-black overlay fading out over rm_game
    if (fade_in_alpha > 0) {
        draw_set_alpha(fade_in_alpha);
        draw_set_colour(c_black);
        draw_rectangle(0, 0, gw, gh, false);

        // Loading text + spinner drawn on top of the black overlay so they
        // remain visible throughout the entire fade-in (fading out with the black).
        draw_set_alpha(fade_in_alpha);
        draw_set_font(fnt_fighter);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_colour(c_white);
        draw_text_transformed(gw * 0.5, gh * 0.5, "LOADING", 1.2, 1.2, 0);

        var _cx   = gw * 0.5;
        var _cy   = gh * 0.5 + 80;
        var _r    = 22;
        var _time = current_time / 5.0;
        draw_set_colour(c_white);
        for (var i = 0; i < 8; i++) {
            var _angle     = _time + i * 45;
            var _seg_alpha = (i + 1) / 8.0 * fade_in_alpha;
            draw_set_alpha(_seg_alpha);
            var _x1 = _cx + lengthdir_x(_r * 0.45, _angle);
            var _y1 = _cy + lengthdir_y(_r * 0.45, _angle);
            var _x2 = _cx + lengthdir_x(_r, _angle);
            var _y2 = _cy + lengthdir_y(_r, _angle);
            draw_line_width(_x1, _y1, _x2, _y2, 3);
        }
        draw_set_alpha(1);
        draw_set_colour(c_white);
    }
}

draw_set_colour(c_white);
draw_set_font(-1);