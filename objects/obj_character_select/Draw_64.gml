// --------------------------------------------------
// CHARACTER SELECT - DRAW GUI EVENT
// CURSOR-BASED VERSION
// --------------------------------------------------
draw_clear_alpha(make_colour_rgb(230, 230, 230), 1);

draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// --------------------------------------------------
// TITLE
// --------------------------------------------------
draw_set_colour(c_black);
draw_text(gui_w * 0.5, 70, "CHARACTER SELECT");

// --------------------------------------------------
// DRAW CHARACTER TILES
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

    if (hovered_by_anyone)
        draw_set_colour(make_colour_rgb(245, 245, 255));
    else
        draw_set_colour(c_white);

    draw_rectangle(x1, y1, x2, y2, false);

    draw_set_colour(c_black);
    draw_rectangle(x1, y1, x2, y2, true);

    draw_text((x1 + x2) * 0.5, y2 + 80, character_names[i]);
}

// --------------------------------------------------
// DRAW CURSORS
// Only draw for active players.
// Cursor remains visible even after confirm.
// --------------------------------------------------
for (var p = 0; p < max_players; p++)
{
    if (!player_active[p]) continue;

    var cx = cursor_x[p];
    var cy = cursor_y[p];

    // Cursor outer ring
    draw_set_colour(player_colour[p]);
    draw_circle(cx, cy, 18, true);

    // Cursor center
    draw_circle(cx, cy, 4, false);

    // Player label above cursor
    draw_text(cx, cy - 28, "P" + string(p + 1));
}

// --------------------------------------------------
// DRAW CONFIRMED PLAYER BADGES
// Draw at the saved cursor position from confirm time.
// Upscaled 4x.
// IMPORTANT:
// Badge stays there until back is pressed.
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

        draw_set_colour(c_black);
        draw_text(bx, by + 55, "READY");
    }
    else
    {
        show_debug_message("WARNING: Missing confirmed badge sprite for P" + string(p + 1));
    }
}

// --------------------------------------------------
// DRAW ACTIVE PLAYER INPUT LABELS
// Good debugging UI for the jam.
// --------------------------------------------------
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var info_x = 30;
var info_y = 30;
var info_gap = 26;

for (var p = 0; p < max_players; p++)
{
    if (!player_active[p]) continue;

    draw_set_colour(player_colour[p]);

    var hover_text = "none";
    if (hovered_tile[p] != -1) hover_text = character_names[hovered_tile[p]];

    var confirm_text = "NO";
    if (player_confirmed[p]) confirm_text = "YES";

    draw_text(
        info_x,
        info_y + p * info_gap,
        "P" + string(p + 1) +
        " | " + player_input_label[p] +
        " | Hover: " + hover_text +
        " | Confirmed: " + confirm_text
    );
}

// --------------------------------------------------
// INSTRUCTIONS
// Keep them broad so they match assigned schema.
// --------------------------------------------------
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(c_black);

draw_text(
    gui_w * 0.5,
    gui_h - 70,
    "Move your cursor with your assigned controls"
);

draw_text(
    gui_w * 0.5,
    gui_h - 40,
    "Confirm = Q / U / Shift / A-or-LT    |    Back = E / O / Enter / B-or-RT"
);