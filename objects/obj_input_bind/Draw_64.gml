// --------------------------------------------------
// INPUT BIND ROOM - DRAW GUI EVENT
// --------------------------------------------------
draw_clear_alpha(make_colour_rgb(20, 20, 30), 1);

draw_set_font(VT323);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var cx = gui_w * 0.5;

// =====================================================
// TITLE BAR
// =====================================================
draw_set_colour(make_colour_rgb(255, 220, 60));
draw_text_transformed(cx, 44, "CONTROL SETUP", 2.4, 2.4, 0);

draw_set_colour(make_colour_rgb(160, 160, 180));
draw_text_transformed(cx, 105, "Move any input to claim a slot. Confirm 3 times to ready up.", 1.15, 1.15, 0);

// =====================================================
// STARTUP LOCK
// =====================================================
if (startup_lock_frames > 0)
{
    draw_set_colour(make_colour_rgb(120, 120, 140));
    draw_text_transformed(cx, gui_h * 0.5, "Please wait...", 1.5, 1.5, 0);
    exit;
}

// =====================================================
// PLAYER BOXES — 2x2 GRID LAYOUT
// Boxes shrunk 60% in width.
// Original player_box_w = 1000 -> now 400
// Original player_box_h = 140  -> now 112 (shrunk ~20%)
// =====================================================
var box_w     = 400;
var box_h     = 112;
var box_gap_x = 30;
var box_gap_y = 16;

// Total 2-col grid width: 2 boxes + 1 gap
var grid_w  = box_w * 2 + box_gap_x;
var grid_x1 = cx - grid_w * 0.5;    // left column X
var grid_x2 = grid_x1 + box_w + box_gap_x; // right column X
var grid_y1 = 148;                   // top row Y
var grid_y2 = grid_y1 + box_h + box_gap_y; // bottom row Y

// Map player index -> (col, row)
// P0=top-left, P1=top-right, P2=bottom-left, P3=bottom-right
var box_col = [0, 1, 0, 1];
var box_row = [0, 0, 1, 1];

for (var p = 0; p < max_players; p++)
{
    var bx1 = (box_col[p] == 0) ? grid_x1 : grid_x2;
    var by1 = (box_row[p] == 0) ? grid_y1 : grid_y2;
    var bx2 = bx1 + box_w;
    var by2 = by1 + box_h;
    var bmx = (bx1 + bx2) * 0.5; // box mid X

    // ---- Background colour by state ----
    var bg_col = make_colour_rgb(35, 35, 50);
    if (player_assigned[p])
    {
        if (player_confirm_count[p] >= required_special_count)
            bg_col = make_colour_rgb(20, 90, 45);
        else
            bg_col = make_colour_rgb(35, 55, 95);
    }

    draw_set_colour(bg_col);
    draw_rectangle(bx1, by1, bx2, by2, false);

    var border_col = make_colour_rgb(80, 80, 110);
    if (player_assigned[p] && player_confirm_count[p] >= required_special_count)
        border_col = make_colour_rgb(60, 220, 100);
    else if (player_assigned[p])
        border_col = make_colour_rgb(80, 140, 220);

    draw_set_colour(border_col);
    draw_rectangle(bx1, by1, bx2, by2, true);

    draw_set_halign(fa_left);

    // P# label — sits in top-left of box
    draw_set_colour(make_colour_rgb(255, 220, 60));
    draw_text_transformed(bx1 + 12, by1 + 20, "P" + string(p + 1), 1.4, 1.4, 0);

    if (!player_assigned[p])
    {
        draw_set_colour(make_colour_rgb(110, 110, 130));
        draw_text_transformed(bx1 + 60, by1 + 20, "Waiting for input...", 0.95, 0.95, 0);
        draw_set_colour(make_colour_rgb(70, 70, 90));
        draw_text_transformed(bx1 + 60, by1 + 50, "Move stick, D-pad, or key", 0.85, 0.85, 0);
        draw_text_transformed(bx1 + 60, by1 + 74, "Then confirm 3 times", 0.78, 0.78, 0);
    }
    else
    {
        var schema_label = "";
        var confirm_hint = "";

        if      (player_schema_type[p] == "kb1") { schema_label = "WASD + Q/E";           confirm_hint = "Confirm: Q + E"; }
        else if (player_schema_type[p] == "kb2") { schema_label = "IJKL + U/O";           confirm_hint = "Confirm: U + O"; }
        else if (player_schema_type[p] == "kb3") { schema_label = "Arrows + Shift/Enter"; confirm_hint = "Confirm: Shift+Enter"; }
        else if (player_schema_type[p] == "pad") { schema_label = "Controller " + string(player_schema_id[p]); confirm_hint = "Confirm: X + Y"; }

        // Input scheme name
        draw_set_colour(make_colour_rgb(120, 200, 255));
        draw_text_transformed(bx1 + 60, by1 + 20, schema_label, 1.0, 1.0, 0);

        // Progress dots — row below scheme name
        var dot_r   = 7;
        var dot_gap = 20;
        var dots_x  = bx1 + 60;
        var dots_y  = by1 + 54;

        for (var d = 0; d < required_special_count; d++)
        {
            var dx = dots_x + d * (dot_r * 2 + dot_gap * 0.4);

            if (d < player_confirm_count[p])
                draw_set_colour(make_colour_rgb(80, 240, 120));
            else
                draw_set_colour(make_colour_rgb(50, 50, 70));

            draw_circle(dx, dots_y, dot_r, false);
            draw_set_colour(make_colour_rgb(160, 160, 200));
            draw_circle(dx, dots_y, dot_r, true);
        }

        // READY or Confirm hint — same vertical position, right of dots
        // "READY" is 60% smaller than the old 1.5 scale -> 0.6 scale
        var hint_x = dots_x + required_special_count * (dot_r * 2 + dot_gap * 0.4) + 14;
        
        if (player_confirm_count[p] >= required_special_count)
        {
            draw_set_colour(make_colour_rgb(30, 200, 90));
            draw_text_transformed(hint_x, dots_y, "READY", 0.6, 0.6, 0);
        }
        else
        {
            draw_set_colour(make_colour_rgb(200, 170, 70));
            draw_text_transformed(hint_x, dots_y, confirm_hint, 0.75, 0.75, 0);
        }
    }

    draw_set_halign(fa_center);
}

// =====================================================
// REFERENCE PANEL  (bottom of screen)
// Shrunk 20% from previous version.
// Two columns: left=keyboard, right=controller
// "Arrows -> Shift +" on one line, "Enter" indented below
// =====================================================

var ref_lh     = 27;                  // line height (was 34, shrunk ~20%)
var panel_w    = 787;                 // was 984, shrunk ~20%
var panel_x1   = cx - (panel_w * 0.5);
var panel_x2   = cx + (panel_w * 0.5);
var panel_rows = 5;
var panel_h    = ref_lh * panel_rows + 20;
var ref_y      = gui_h - panel_h - 20;

// Panel background + border
draw_set_colour(make_colour_rgb(25, 25, 38));
draw_rectangle(panel_x1, ref_y - 29, panel_x2, ref_y + panel_h, false);
draw_set_colour(make_colour_rgb(60, 60, 90));
draw_rectangle(panel_x1, ref_y - 29, panel_x2, ref_y + panel_h, true);

// Column positions — scaled with panel
var col_l = panel_x1 + 22;           // keyboard column
var col_r = panel_x1 + 352;          // controller column

draw_set_halign(fa_left);

// --- Headers ---
draw_set_colour(make_colour_rgb(255, 220, 60));
draw_text_transformed(col_l, ref_y,            "KEYBOARD",   0.8, 0.8, 0);
draw_text_transformed(col_r, ref_y,            "CONTROLLER", 0.8, 0.8, 0);

// --- Keyboard rows ---
draw_set_colour(make_colour_rgb(140, 140, 160));
draw_text_transformed(col_l, ref_y + ref_lh,       "WASD     ->  Q + E",    0.76, 0.76, 0);
draw_text_transformed(col_l, ref_y + ref_lh * 2,   "IJKL     ->  U + O",    0.76, 0.76, 0);

// Arrows line split: "Shift +" on line 3, "Enter" indented on line 4
draw_text_transformed(col_l, ref_y + ref_lh * 3,       "Arrows   ->  Shift +",      0.76, 0.76, 0);
draw_text_transformed(col_l + 160, ref_y + ref_lh * 3.8, "Enter",                   0.76, 0.76, 0);

// --- Controller rows ---
draw_set_colour(make_colour_rgb(140, 140, 160));
draw_text_transformed(col_r, ref_y + ref_lh,       "Move stick or D-pad to join", 0.76, 0.76, 0);
draw_text_transformed(col_r, ref_y + ref_lh * 2,   "Confirm: press X + Y",        0.76, 0.76, 0);

// --- Back button hint (red) ---
draw_set_colour(make_colour_rgb(220, 80, 80));
draw_text_transformed(col_r, ref_y + ref_lh * 3.8, "Back:  B  /  ESC",     0.76, 0.76, 0);

draw_set_halign(fa_center);