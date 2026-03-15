// --------------------------------------------------
// MODE MENU - DRAW GUI EVENT
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
// =====================
var box_w = 340;
var box_h = 400;
var box_gap = 60;

var total_pair_w = box_w * 2 + box_gap;
var pair_start_x = (gui_w - total_pair_w) * 0.5;
var box_y = (gui_h - box_h) * 0.5 - 20;

var left_bx  = pair_start_x;
var right_bx = pair_start_x + box_w + box_gap;

// --------------------------------------------------
// Box outlines
// --------------------------------------------------
draw_set_alpha(0.25);
draw_set_colour(c_white);
draw_roundrect(left_bx, box_y, left_bx + box_w, box_y + box_h, false);
if (left_locked || column_focus == 1 || final_locked)
{
    draw_roundrect(right_bx, box_y, right_bx + box_w, box_y + box_h, false);
}
draw_set_alpha(1);

// --------------------------------------------------
// FONT + ALIGNMENT
// --------------------------------------------------
draw_set_font(VT323);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var basescale = 2.0;

// Background pill behind Back hint — sized to actual text
var hint_str    = "Back: Esc / B";
var hint_scale  = 1.3;
var hint_x      = gui_w - 20;
var hint_y      = 16;
var text_w      = string_width(hint_str)  * hint_scale;
var text_h      = string_height(hint_str) * hint_scale;
var pad_x       = 20;
var pad_y       = 10;

draw_set_alpha(0.18);
draw_set_colour(c_white);
draw_roundrect(
    hint_x - text_w - pad_x,
    hint_y - pad_y,
    hint_x + pad_x,
    hint_y + text_h + pad_y,
    false
);
draw_set_alpha(1);

// Now draw the text on top
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_colour(c_red);
draw_set_alpha(0.9);
draw_text_transformed(hint_x, hint_y, hint_str, hint_scale, hint_scale, 0);
draw_set_alpha(1);
//draw_set_colour(c_white);
//draw_set_halign(fa_center);
//draw_set_valign(fa_middle);


draw_set_colour(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// --------------------------------------------------
// LEFT COLUMN ITEMS
// --------------------------------------------------
var left_cx      = left_bx + box_w * 0.5;
var left_count   = array_length(left_options);
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
        var scale     = (basescale * 1.1) + 0.015 * sin(current_time / 150);
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
        var col = make_color_rgb(255, 200, 50);
        draw_set_colour(col);
        draw_text_transformed(tx, ty, left_options[i], basescale * 1.05, basescale * 1.05, 0);
        draw_set_colour(c_white);
    }
    else
    {
        draw_set_colour(c_white);
        draw_text_transformed(tx, ty, left_options[i], basescale, basescale, 0);
    }
}

// --------------------------------------------------
// RIGHT COLUMN ITEMS
// FEATURE 3: Each option has a mode description below it.
// The description is 30% smaller (basescale * 0.7).
// Both the option text and its description are treated as
// one logical unit within the spacing — we offset the main
// text upward by half the desc height so the pair is centered
// in its slot, then draw the desc just below.
// --------------------------------------------------
if (left_locked || column_focus == 1 || final_locked)
{
    var right_cx      = right_bx + box_w * 0.5;
    var right_count   = array_length(right_options);
    var right_spacing = 150;
    var right_total_h = (right_count - 1) * right_spacing;
    var right_start_y = box_y + box_h * 0.5 - right_total_h * 0.5;

    // FEATURE 3: mode name lookup per right_options entry
    // Assumption: only Free-for-All and Juggernaut exist.
    // 1v1   -> Free-for-All
    // 1v2   -> Juggernaut  (1 vs team)
    // 1v1v1 -> Free-for-All
    // 1v3   -> Juggernaut
    // 1v1v1v1 -> Free-for-All
    function get_mode_description(_option)
    {
        if (_option == "1v1")      return "Free-for-All";
        if (_option == "1v2")      return "Juggernaut";
        if (_option == "1v1v1")    return "Free-for-All";
        if (_option == "1v3")      return "Juggernaut";
        if (_option == "1v1v1v1")  return "Free-for-All";
        return "Unknown";
    }

    // Scale for description text (30% smaller than basescale)
    var desc_scale  = basescale * 0.7;

    // How much vertical space the description takes up —
    // used to nudge the main option text upward so the
    // combined pair looks centered in its row slot.
    // We use a rough pixel estimate: desc_scale * font_height.
    // VT323 at scale 1.0 is roughly 16px tall; at desc_scale ~1.4 → ~22px.
    // We nudge the main text up by half that, and put desc just below.
    var desc_line_h = 40; // px — tweak if font size differs
    var nudge       = desc_line_h * 0.5;

    for (var j = 0; j < right_count; j++)
    {
        var rtx = right_cx;
        var rty = right_start_y + j * right_spacing;

        // Main option text sits slightly above slot center
        var main_ty = rty - nudge;
        // Description sits below the main text
        var desc_ty = rty + nudge + 4;

        var is_selected_right = (j == right_index);
        var desc_str = get_mode_description(right_options[j]);

        if (column_focus == 1 && is_selected_right)
        {
            // ACTIVE: gold + glow for main text
            var rscale     = (basescale * 1.1) + 0.015 * sin(current_time / 150);
            var rcol_outer = make_color_rgb(255, 215, 0);
            var rcol_inner = make_color_rgb(255, 210, 0);

            draw_set_alpha(0.35);
            draw_text_transformed_colour(rtx, main_ty, right_options[j], rscale * 1.05, rscale * 1.05, 0,
                rcol_inner, rcol_inner, rcol_outer, rcol_outer, 0.35);
            draw_set_alpha(1);
            draw_text_transformed_colour(rtx, main_ty, right_options[j], rscale, rscale, 0,
                rcol_outer, rcol_outer, rcol_inner, rcol_inner, 1);

            // Description text: white, smaller
            draw_set_colour(c_white);
            draw_set_alpha(0.85);
            draw_text_transformed(rtx, desc_ty, desc_str, desc_scale, desc_scale, 0);
            draw_set_alpha(1);
        }
        else
        {
            // Normal unselected main text
            draw_set_colour(c_white);
            draw_text_transformed(rtx, main_ty, right_options[j], basescale, basescale, 0);

            // Description text: white, smaller, slightly dimmer
            draw_set_alpha(0.6);
            draw_text_transformed(rtx, desc_ty, desc_str, desc_scale, desc_scale, 0);
            draw_set_alpha(1);
        }
    }
}