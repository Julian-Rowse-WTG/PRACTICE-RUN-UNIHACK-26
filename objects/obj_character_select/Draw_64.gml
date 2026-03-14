// --------------------------------------------------
// CHARACTER SELECT - DRAW GUI EVENT
// Layout:
//   Top    - 2 rows x 6 character selection squares
//   Middle - thin divider bar with greyed-out START
//   Bottom - 4 player slot rectangles
// --------------------------------------------------
draw_clear_alpha(make_colour_rgb(30, 30, 40), 1);

draw_set_font(-1);
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
        var cx    = (x1 + x2) * 0.5;
        var cy    = (y1 + y2) * 0.5;
        var scale = min((x2 - x1 - 10) / spr_w, (y2 - y1 - 10) / spr_h);
        draw_sprite_ext(spr, 0, cx, cy, scale, scale, 0, c_white, 1);
    }
    else
    {
        // Placeholder "?" for squares without an assigned sprite
        draw_set_colour(make_colour_rgb(70, 75, 100));
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text((x1 + x2) * 0.5, (y1 + y2) * 0.5, "?");
    }
}

// --------------------------------------------------
// MIDDLE SECTION: THIN DIVIDER BAR + START TEXT
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

// Greyed-out START text in the center of the bar
draw_set_colour(make_colour_rgb(90, 90, 100));
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(gui_w * 0.5, (bar_y1 + bar_y2) * 0.5, "START");

// --------------------------------------------------
// BOTTOM SECTION: 4 PLAYER SLOT RECTANGLES
// --------------------------------------------------
for (var p = 0; p < 4; p++)
{
    var rx1 = slot_x;
    var ry1 = bottom_y + p * (slot_h + slot_gap);
    var rx2 = slot_x + slot_w;
    var ry2 = ry1 + slot_h;

    // Slot background
    draw_set_colour(make_colour_rgb(45, 48, 65));
    draw_rectangle(rx1, ry1, rx2, ry2, false);

    // Slot border
    draw_set_colour(make_colour_rgb(80, 85, 110));
    draw_rectangle(rx1, ry1, rx2, ry2, true);

    // Player label
    draw_set_colour(player_colour[p]);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text((rx1 + rx2) * 0.5, (ry1 + ry2) * 0.5, player_labels[p]);
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

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_text(cx, cy - 28, "P" + string(p + 1));
}

// --------------------------------------------------
// DRAW CONFIRMED PLAYER BADGES
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

    var bx = stamp_x[p];
    var by = stamp_y[p];

    if (spr != -1)
    {
        draw_sprite_ext(spr, 0, bx, by, 4, 4, 0, c_white, 1);
        draw_set_colour(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(bx, by + 55, "READY");
    }
}

// --------------------------------------------------
// DEBUG: ACTIVE PLAYER INPUT LABELS (top-left)
// --------------------------------------------------
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var info_x   = 30;
var info_y   = divider_y + divider_h + 8;
var info_gap = 26;

for (var p = 0; p < max_players; p++)
{
    if (!player_active[p]) continue;

    draw_set_colour(player_colour[p]);

    var hover_text   = "none";
    if (hovered_tile[p] != -1) hover_text = character_names[hovered_tile[p]];

    var confirm_text = (player_confirmed[p]) ? "YES" : "NO";

    draw_text(
        info_x,
        info_y + p * info_gap,
        "P" + string(p + 1) +
        " | " + player_input_label[p] +
        " | Hover: " + hover_text +
        " | Confirmed: " + confirm_text
    );
}