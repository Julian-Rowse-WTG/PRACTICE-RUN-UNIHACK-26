// --------------------------------------------------
// MODE MENU - DRAW GUI EVENT
// Styled to match main_menu: jungle bg, dark overlay,
// VT323 font, gold selected item with glow + ripple.
// --------------------------------------------------

// =====================
// LAYER 1: Background sprite
// =====================
draw_sprite_stretched(spr_background_jungle, 0, 0, 0, display_get_gui_width(), display_get_gui_height());

// =====================
// LAYER 2: Translucent dark overlay
// =====================
draw_set_alpha(0.65);
draw_set_colour(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);
draw_set_colour(c_white);

// =====================
// LAYER 3: Menu layout
// Two equal-size boxes, centered horizontally as a pair.
// =====================

// Box dimensions
var box_w = 340;
var box_h = 400;
var box_gap = 60; // gap between the two boxes

// Center the pair horizontally
var total_pair_w = box_w * 2 + box_gap;
var pair_start_x = (gui_w - total_pair_w) * 0.5;

// Center vertically (nudged slightly above center for visual weight)
var box_y = (gui_h - box_h) * 0.5 - 20;

var left_bx  = pair_start_x;
var right_bx = pair_start_x + box_w + box_gap;

// --------------------------------------------------
// Draw box outlines (subtle white, low alpha)
// Left box always visible; right box only when reachable.
// --------------------------------------------------
draw_set_alpha(0.25);
draw_set_colour(c_white);

var BORDER_RADIUS = 30;

draw_roundrect_ext(left_bx, box_y, left_bx + box_w, box_y + box_h, BORDER_RADIUS, BORDER_RADIUS, false);
if (left_locked || column_focus == 1 || final_locked)
{
    draw_roundrect_ext(right_bx, box_y, right_bx + box_w, box_y + box_h, BORDER_RADIUS, BORDER_RADIUS, false);
}
draw_set_alpha(1);

// --------------------------------------------------
// FONT + ALIGNMENT
// --------------------------------------------------
draw_set_font(VT323);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var basescale = 2.0; // bigger than main menu's 1.7 since options are short strings

// --------------------------------------------------
// LEFT COLUMN ITEMS
// Vertically centered inside box, evenly spaced.
// --------------------------------------------------
var left_cx   = left_bx + box_w * 0.5;
var left_count = array_length(left_options);
var left_spacing = 90;
var left_total_h = (left_count - 1) * left_spacing;
var left_start_y = box_y + box_h * 0.5 - left_total_h * 0.5;

for (var i = 0; i < left_count; i++)
{
    var tx = left_cx;
    var ty = left_start_y + i * left_spacing;

    var is_selected_left = (i == left_index);

    if (column_focus == 0 && is_selected_left)
    {
        // ACTIVE gold + glow (matches main_menu selected style)
        var scale = (basescale * 1.1) + 0.015 * sin(current_time / 150);
        var col_outer = make_color_rgb(255, 215, 0);
        var col_inner = make_color_rgb(255, 210, 0);

        draw_set_alpha(0.35);
        draw_text_transformed_colour(tx, ty, left_options[i], scale * 1.05, scale * 1.05, 0,
            col_inner, col_inner, col_outer, col_outer, 0.35);
        draw_set_alpha(1);

        draw_text_transformed_colour(tx, ty, left_options[i], scale, scale, 0,
            col_outer, col_outer, col_inner, col_inner, 1);

        draw_set_colour(c_white);
        draw_set_alpha(1);
    }
    else if ((left_locked || column_focus == 1 || final_locked) && is_selected_left)
    {
        // LOCKED/CONFIRMED: still highlighted gold but smaller, static (no ripple)
        var col = make_color_rgb(255, 200, 50);
        draw_set_colour(col);
        draw_text_transformed(tx, ty, left_options[i], basescale * 1.05, basescale * 1.05, 0);
        draw_set_colour(c_white);
    }
    else
    {
        // Normal unselected
        draw_set_colour(c_white);
        draw_text_transformed(tx, ty, left_options[i], basescale, basescale, 0);
    }
}

// --------------------------------------------------
// RIGHT COLUMN ITEMS
// Only shown once left is locked.
// --------------------------------------------------
if (left_locked || column_focus == 1 || final_locked)
{
    var right_cx     = right_bx + box_w * 0.5;
    var right_count  = array_length(right_options);
    var right_spacing = 90;
    var right_total_h = (right_count - 1) * right_spacing;
    var right_start_y = box_y + box_h * 0.5 - right_total_h * 0.5;

    for (var j = 0; j < right_count; j++)
    {
        var rtx = right_cx;
        var rty = right_start_y + j * right_spacing;

        var is_selected_right = (j == right_index);

        if (column_focus == 1 && is_selected_right)
        {
            // ACTIVE gold + glow
            var rscale = (basescale * 1.1) + 0.015 * sin(current_time / 150);
            var rcol_outer = make_color_rgb(255, 215, 0);
            var rcol_inner = make_color_rgb(255, 210, 0);

            draw_set_alpha(0.35);
            draw_text_transformed_colour(rtx, rty, right_options[j], rscale * 1.05, rscale * 1.05, 0,
                rcol_inner, rcol_inner, rcol_outer, rcol_outer, 0.35);
            draw_set_alpha(1);

            draw_text_transformed_colour(rtx, rty, right_options[j], rscale, rscale, 0,
                rcol_outer, rcol_outer, rcol_inner, rcol_inner, 1);

            draw_set_colour(c_white);
            draw_set_alpha(1);
        }
        else
        {
            draw_set_colour(c_white);
            draw_text_transformed(rtx, rty, right_options[j], basescale, basescale, 0);
        }
    }
}