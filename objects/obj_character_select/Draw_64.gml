// --------------------------------------------------
// CHARACTER SELECT - DRAW GUI EVENT
// Layout:
//   Top    - 2 rows x 6 character selection squares
//   Middle - thick divider bar with greyed-out START (fnt_fighter)
//   Bottom - 4 side-by-side vertical player slot columns
// Fonts: VT323 for all general text, fnt_fighter for START + READY
// --------------------------------------------------
draw_clear_alpha(make_colour_rgb(30, 30, 40), 1);

draw_set_font(VT323);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// --------------------------------------------------
// TOP SECTION: 2 x 6 CHARACTER SELECTION SQUARES
// --------------------------------------------------
for (var i = 0; i < panel_count; i++)
{
    var x1 = tile_x1[i];
    var y1 = tile_y1[i];
    var x2 = tile_x2[i];
    var y2 = tile_y2[i];
    var tcx = (x1 + x2) * 0.5;
    var tcy = (y1 + y2) * 0.5;

    var is_disabled = (i >= enabled_slots);

    if (is_disabled)
    {
        // Disabled tile — dark, no hover response
        draw_set_colour(make_colour_rgb(30, 32, 44));
        draw_rectangle(x1, y1, x2, y2, false);

        draw_set_colour(make_colour_rgb(55, 58, 72));
        draw_rectangle(x1, y1, x2, y2, true);

        // "DISABLED" label
        draw_set_font(VT323);
        draw_set_colour(make_colour_rgb(75, 75, 88));
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(tcx, tcy - 20, "LOCKED");

        // XP requirement — xp_idx is always >= 0 here because is_disabled guarantees i >= enabled_slots
        var xp_idx = i - enabled_slots;
		var xp_needed = xp_requirements[xp_idx];
		var xp_string = "";
		if(xp_needed < 10000) {
			xp_string = string(xp_needed);
		} else if(xp_needed < 1000000) {
			xp_string = string(floor(xp_needed / 1000)) + "K";
		} else {
			xp_string = string(floor(xp_needed / 1000000)) + "M";
		}
        draw_text(tcx, tcy + 20, xp_string + " XP");
    }
    else
    {
        var hovered_by_anyone = false;

        for (var p = 0; p < max_players; p++)
        {
            if (!player_active[p]) continue;
            if (hovered_tile[p] == i)
            {
                hovered_by_anyone = true;
                break;
            }
        }

        // Square background
        if (hovered_by_anyone)
            draw_set_colour(make_colour_rgb(80, 100, 140));
        else
            draw_set_colour(make_colour_rgb(55, 60, 80));

        draw_rectangle(x1, y1, x2, y2, false);

        // Square border
        draw_set_colour(make_colour_rgb(100, 110, 140));
        draw_rectangle(x1, y1, x2, y2, true);

        // Character image (scaled to fit the square)
        var spr = char_sprite[i];
        if (spr != -1)
        {
            var spr_w = sprite_get_width(spr);
            var spr_h = sprite_get_height(spr);
            var scale = min((x2 - x1 - 10) / spr_w, (y2 - y1 - 10) / spr_h);
            draw_sprite_ext(spr, 0, tcx, tcy, scale, scale, 0, c_white, 1);
        }
        else
        {
            // Placeholder "?" for squares without an assigned sprite
            draw_set_font(VT323);
            draw_set_colour(make_colour_rgb(140, 145, 170));
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(tcx, tcy, "?");
        }
    }
}

// --------------------------------------------------
// MIDDLE SECTION: THICK DIVIDER BAR + START TEXT
// --------------------------------------------------
var bar_x1 = 0;
var bar_x2 = gui_w;
var bar_y1 = divider_y;
var bar_y2 = divider_y + divider_h;

// Bar background
draw_set_colour(make_colour_rgb(45, 48, 65));
draw_rectangle(bar_x1, bar_y1, bar_x2, bar_y2, false);

// Bar top/bottom border lines
draw_set_colour(make_colour_rgb(80, 85, 110));
draw_line(bar_x1, bar_y1, bar_x2, bar_y1);
draw_line(bar_x1, bar_y2, bar_x2, bar_y2);

// START text — animated yellow when all players confirmed, greyed otherwise
draw_set_font(fnt_fighter);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

if (all_confirmed)
{
    var bar_cx = gui_w * 0.5;
    var bar_cy = (bar_y1 + bar_y2) * 0.5;
    var start_scale  = 1 + 0.015 * sin(current_time / 150);
    var start_ripple = 0.5 + 0.5 * sin(current_time / 225);
    var col_outer = merge_colour(make_colour_rgb(220, 170, 0), make_colour_rgb(255, 210, 0), start_ripple);
    var col_inner = merge_colour(make_colour_rgb(255, 240, 30), make_colour_rgb(255, 255, 90), start_ripple);

    draw_set_alpha(0.35);
    draw_text_transformed_colour(
        bar_cx, bar_cy, "START",
        start_scale * 1.08, start_scale * 1.08, 0,
        col_inner, col_inner, col_outer, col_outer, 0.35
    );

    draw_set_alpha(1);
    draw_text_transformed_colour(
        bar_cx, bar_cy, "START",
        start_scale, start_scale, 0,
        col_outer, col_outer, col_inner, col_inner, 1
    );

    draw_set_colour(c_white);
    draw_set_alpha(1);
}
else
{
    draw_set_colour(make_colour_rgb(90, 90, 100));
    draw_text(gui_w * 0.5, (bar_y1 + bar_y2) * 0.5, "START");
}

// --------------------------------------------------
// BOTTOM SECTION: 4 SIDE-BY-SIDE VERTICAL PLAYER SLOTS
// --------------------------------------------------
draw_set_font(VT323);

for (var p = 0; p < 4; p++)
{
    var rx1 = slot_px[p];
    var ry1 = bottom_y;
    var rx2 = slot_px[p] + slot_w;
    var ry2 = bottom_y + slot_h;

    // Slot background
    draw_set_colour(make_colour_rgb(45, 48, 65));
    draw_rectangle(rx1, ry1, rx2, ry2, false);

    // Slot border
    draw_set_colour(make_colour_rgb(80, 85, 110));
    draw_rectangle(rx1, ry1, rx2, ry2, true);

    // Player label (VT323, player colour)
    draw_set_colour(player_colour[p]);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var rcx = (rx1 + rx2) * 0.5;
    var rcy = ry1 + 30;
    draw_text(rcx, rcy, player_labels[p]);

    // READY overlay — diagonal fnt_fighter, yellow, bold
    if (player_confirmed[p])
    {
        draw_set_font(fnt_fighter);
        draw_set_colour(c_yellow);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed(rcx, rcy, "READY", 1, 1, 20);
		draw_set_font(VT323);
    }
}

// --------------------------------------------------
// DRAW CONFIRMED PLAYER BADGES (sprite icon at stamp position)
// --------------------------------------------------
for (var p = 0; p < max_players; p++)
{
    if (!player_active[p]) continue;
    if (!player_confirmed[p]) continue;

    var spr = -1;

    switch (p)
    {
        case 0: spr = spr_counter_icon_p1; break;
        case 1: spr = spr_counter_icon_p2; break;
        case 2: spr = spr_counter_icon_p3; break;
        case 3: spr = spr_counter_icon_p4; break;
    }

    if (spr != -1)
    {
        draw_sprite_ext(spr, 0, stamp_x[p], stamp_y[p], 4, 4, 0, c_white, 1);
    }
}

// --------------------------------------------------
// DRAW CURSORS (active players only)
// --------------------------------------------------
for (var p = 0; p < max_players; p++)
{
    if (!player_active[p]) continue;

    var cx = cursor_x[p];
    var cy = cursor_y[p];

    draw_set_colour(player_colour[p]);
    draw_circle(cx, cy, 18, true);
    draw_circle(cx, cy, 4, false);

    draw_set_font(VT323);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_text(cx, cy - 28, "P" + string(p + 1));
}