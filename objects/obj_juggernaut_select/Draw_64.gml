// --------------------------------------------------
// JUGGERNAUT SELECT - DRAW GUI EVENT
// --------------------------------------------------

draw_set_alpha(1);
draw_clear_alpha(make_colour_rgb(18, 18, 28), 1);

// Shared pulse values (reused for multiple effects)
var _pulse      = 0.5 + 0.5 * sin(anim_timer / 28.0);
var _pulse_fast = 0.5 + 0.5 * sin(anim_timer / 14.0);

// --------------------------------------------------
// TITLE TEXT
// --------------------------------------------------
draw_set_font(fnt_fighter);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_text_transformed(gui_w * 0.5, 18, "CHOOSE YOUR JUGGERNAUT", 1.0, 1.0, 0);

// Subtitle / instruction
draw_set_font(VT323);
draw_set_colour(make_colour_rgb(180, 160, 255));
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text(gui_w * 0.5, 700, "Claim the Juggernaut role - only one allowed!");

// --------------------------------------------------
// PLAYER TILES
// --------------------------------------------------
for (var i = 0; i < max_players; i++) {
    var x1  = tile_x1[i];
    var y1  = tile_y1[i];
    var x2  = tile_x2[i];
    var y2  = tile_y2[i];
    var tcx = (x1 + x2) * 0.5;
    var tcy = (y1 + y2) * 0.5;
    var rounding = 18; // rounded corner radius

    var is_juggernaut = (i == juggernaut_player);

    // Check if any player's cursor is hovering this tile
    var hover_alpha = 0.0;
    for (var p = 0; p < max_players; p++) {
        if (!player_active[p]) continue;
        if (hovered_tile[p] == i) {
            hover_alpha = 1.0;
            break;
        }
    }

    // ---- Glow behind tile for juggernaut ----
    if (is_juggernaut) {
        var glow_expand = 8 + _pulse * 10;
        var glow_col    = merge_colour(make_colour_rgb(180, 60, 0), make_colour_rgb(255, 130, 0), _pulse);
        draw_set_alpha(0.30 + _pulse * 0.25);
        draw_set_colour(glow_col);
        draw_roundrect_ext(
            x1 - glow_expand, y1 - glow_expand,
            x2 + glow_expand, y2 + glow_expand,
            rounding + glow_expand * 0.5, rounding + glow_expand * 0.5,
            false
        );
        draw_set_alpha(1.0);
    }

    // ---- Tile background ----
    if (is_juggernaut) {
        // Rich dark-red base for juggernaut
        var bg_col = merge_colour(make_colour_rgb(80, 22, 8), make_colour_rgb(100, 35, 10), _pulse * 0.4);
        draw_set_colour(bg_col);
    } else if (hover_alpha > 0) {
        draw_set_colour(make_colour_rgb(60, 68, 95));
    } else {
        draw_set_colour(make_colour_rgb(40, 45, 65));
    }
    draw_set_alpha(1.0);
    draw_roundrect_ext(x1, y1, x2, y2, rounding, rounding, false);

    // ---- Tile border ----
    if (is_juggernaut) {
        var border_col = merge_colour(make_colour_rgb(200, 100, 0), make_colour_rgb(255, 200, 30), _pulse);
        draw_set_colour(border_col);
        draw_set_alpha(1.0);
        // Draw multiple inset borders for a thick glow-ring effect
        for (var _b = 0; _b < 3; _b++) {
            draw_set_alpha(0.6 - _b * 0.18);
            draw_roundrect_ext(x1 + _b, y1 + _b, x2 - _b, y2 - _b, rounding, rounding, true);
        }
        draw_set_alpha(1.0);
    } else {
        var border_col_normal = (hover_alpha > 0)
            ? make_colour_rgb(120, 135, 190)
            : make_colour_rgb(70, 78, 108);
        draw_set_colour(border_col_normal);
        draw_roundrect_ext(x1, y1, x2, y2, rounding, rounding, true);
    }

    // ---- Character sprite ----
    var spr = player_sprite[i];
    if (spr != -1) {
        var spr_w   = sprite_get_width(spr);
        var spr_h   = sprite_get_height(spr);
        var max_sw  = (x2 - x1) - 20;
        var max_sh  = tile_h * 0.52;
        var _scale  = min(max_sw / spr_w, max_sh / spr_h);
        var spr_y   = y1 + tile_h * 0.8; // lower half of tile
        draw_set_alpha(1.0);
        draw_sprite_ext(spr, 0, tcx, spr_y, _scale, _scale, 0, c_white, 1.0);
    }

    // ---- JUGGERNAUT crown + label ----
    if (is_juggernaut) {
        // Crude crown using triangles — pure GML primitives
        var crown_cx = tcx;
        var crown_y  = y1 + 28;
        var crown_w  = 36;
        var crown_h  = 20;
        var crown_col = merge_colour(make_colour_rgb(220, 160, 0), make_colour_rgb(255, 230, 60), _pulse);

        draw_set_colour(crown_col);
        draw_set_alpha(1.0);

        // Crown base bar
        draw_rectangle(crown_cx - crown_w, crown_y + crown_h * 0.4,
                        crown_cx + crown_w, crown_y + crown_h, false);

        // Three crown points (triangles via primitives)
        draw_triangle(
            crown_cx - crown_w,       crown_y + crown_h * 0.4,
            crown_cx - crown_w * 0.6, crown_y - crown_h * 0.4,
            crown_cx - crown_w * 0.2, crown_y + crown_h * 0.4,
            false
        );
        draw_triangle(
            crown_cx - crown_w * 0.15, crown_y + crown_h * 0.4,
            crown_cx,                  crown_y - crown_h * 0.8,
            crown_cx + crown_w * 0.15, crown_y + crown_h * 0.4,
            false
        );
        draw_triangle(
            crown_cx + crown_w * 0.2,  crown_y + crown_h * 0.4,
            crown_cx + crown_w * 0.6,  crown_y - crown_h * 0.4,
            crown_cx + crown_w,        crown_y + crown_h * 0.4,
            false
        );

        // "JUGGERNAUT" label — pulsing gold
        var jug_col = merge_colour(make_colour_rgb(230, 140, 0), make_colour_rgb(255, 220, 50), _pulse);
        draw_set_font(fnt_fighter);
        draw_set_colour(jug_col);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var label_scale = 0.85 + _pulse * 0.08;
        draw_text_transformed(tcx, y1 + 82, "JUGGERNAUT", label_scale, label_scale, 0);
    } else {
        // "CHALLENGER" label for non-juggernaut tiles
        draw_set_font(VT323);
        draw_set_colour(make_colour_rgb(140, 150, 185));
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(tcx, y1 + 80, "CHALLENGER");
    }

    // ---- Player name / number ----
    draw_set_font(VT323);
    draw_set_colour(player_colour[i]);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(tcx, y2 - 22, "PLAYER " + string(i + 1));
}

// --------------------------------------------------
// DIVIDER / START BAR
// --------------------------------------------------
var bar_x1 = 0;
var bar_x2 = gui_w;
var bar_y1 = divider_y;
var bar_y2 = divider_y + divider_h;

draw_set_alpha(1.0);
if(juggernaut_player != -1 && hovering_over_start_button) {
    draw_set_colour(make_colour_rgb(70, 75, 110));
} else {
    draw_set_colour(make_colour_rgb(45, 48, 65));
}
draw_rectangle(bar_x1, bar_y1, bar_x2, bar_y2, false);

draw_set_colour(make_colour_rgb(65, 70, 95));
draw_line(bar_x1, bar_y1, bar_x2, bar_y1);
draw_line(bar_x1, bar_y2, bar_x2, bar_y2);

draw_set_font(fnt_fighter);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

if (juggernaut_player != -1) {
    // Pulsing gold START
    var start_scale  = 1.3 + 0.04 * sin(anim_timer / 22.0);
    var start_ripple = 0.5 + 0.5 * sin(anim_timer / 30.0);
    var col_a = merge_colour(make_colour_rgb(220, 170, 0),  make_colour_rgb(255, 210, 0),  start_ripple);
    var col_b = merge_colour(make_colour_rgb(255, 240, 30), make_colour_rgb(255, 255, 90), start_ripple);

    // Shadow pass
    draw_set_alpha(0.3);
    draw_text_transformed_colour(
        gui_w * 0.5, (bar_y1 + bar_y2) * 0.5,
        "START",
        start_scale * 1.08, start_scale * 1.08, 0,
        col_b, col_b, col_a, col_a, 0.3
    );
    draw_set_alpha(1.0);
    draw_text_transformed_colour(
        gui_w * 0.5, (bar_y1 + bar_y2) * 0.5,
        "START",
        start_scale, start_scale, 0,
        col_a, col_a, col_b, col_b, 1.0
    );
} else {
    // Greyed out — no juggernaut yet
    draw_set_colour(make_colour_rgb(85, 88, 100));
    draw_set_alpha(1.0);
    draw_text_transformed(gui_w * 0.5, (bar_y1 + bar_y2) * 0.5, "START", 1.2, 1.2, 0);
}

draw_set_alpha(1.0);

// --------------------------------------------------
// DRAW CURSORS
// --------------------------------------------------
for (var p = 0; p < max_players; p++) {
    if (!player_active[p]) continue;

    var cx = cursor_x[p];
    var cy = cursor_y[p];
    var cc = player_colour[p];

    // Outer ring
    draw_set_colour(cc);
    draw_set_alpha(0.5);
    draw_circle(cx, cy, 20 - cursor_held[p] * 4, true);

    // Filled dot
    draw_set_alpha(1.0);
    draw_circle(cx, cy, 6, false);

    // Player label above cursor
    draw_set_font(VT323);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(cc);
    draw_set_alpha(1.0);
    draw_text(cx, cy - 28, "P" + string(p + 1));
}

// --------------------------------------------------
// FADE-TO-BLACK OVERLAY
// --------------------------------------------------
if (transitioning && fade_alpha > 0) {
    draw_set_alpha(fade_alpha);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, gui_w, gui_h, false);

    // Loading text
    draw_set_font(fnt_fighter);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_set_alpha(min(1.0, fade_alpha * 2.0));
    draw_text_transformed(gui_w * 0.5, gui_h * 0.5, "LOADING", 1.2, 1.2, 0);

    // Spinner
    var _cx   = gui_w * 0.5;
    var _cy   = gui_h * 0.5 + 80;
    var _r    = 22;
    var _time = current_time / 5.0;
    for (var i = 0; i < 8; i++) {
        var _angle     = _time + i * 45;
        var _seg_alpha = (i + 1) / 8.0 * min(1.0, fade_alpha * 2.0);
        draw_set_alpha(_seg_alpha);
        draw_set_colour(c_white);
        var _x1 = _cx + lengthdir_x(_r * 0.45, _angle);
        var _y1 = _cy + lengthdir_y(_r * 0.45, _angle);
        var _x2 = _cx + lengthdir_x(_r, _angle);
        var _y2 = _cy + lengthdir_y(_r, _angle);
        draw_line_width(_x1, _y1, _x2, _y2, 3);
    }

    draw_set_alpha(1.0);
    draw_set_colour(c_white);
}