// --------------------------------------------------
// MODE MENU - DRAW GUI EVENT
// --------------------------------------------------

// --------------------------------------------------
// BACKGROUND
// --------------------------------------------------
draw_clear(c_ltgray);

// --------------------------------------------------
// STARTUP LOCK MESSAGE
// --------------------------------------------------
if (startup_lock_frames > 0)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_black);
    draw_text(gui_w * 0.5, gui_h * 0.12, "Loading menu input...");
}

// --------------------------------------------------
// BOXES
// --------------------------------------------------
draw_set_color(c_black);
draw_roundrect(left_box_x, left_box_y, left_box_x + left_box_w, left_box_y + left_box_h, false);

if (left_locked || column_focus == 1 || final_locked)
{
    draw_roundrect(right_box_x, right_box_y, right_box_x + right_box_w, right_box_y + right_box_h, false);
}

// --------------------------------------------------
// TEXT DRAW SETUP
// --------------------------------------------------
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// If you have a custom font, uncomment this:
// draw_set_font(fnt_fighter);

// --------------------------------------------------
// LEFT MENU ITEMS
// --------------------------------------------------
var left_center_x = left_box_x + left_box_w * 0.5;
var left_start_y  = left_box_y + 125;
var left_gap      = 85;

for (var i = 0; i < array_length(left_options); i++)
{
    var tx = left_center_x;
    var ty = left_start_y + i * left_gap;

    var scale = 1.0;

    if (column_focus == 0 && i == left_index)
    {
        scale = 1.18;
    }
    else if ((left_locked || column_focus == 1 || final_locked) && i == left_index)
    {
        scale = 1.08;
    }

    draw_set_color(c_white);
    draw_text_transformed(tx, ty, left_options[i], scale, scale, 0);

    if ((left_locked || column_focus == 1 || final_locked) && i == left_index)
    {
        var arrow_x = left_box_x + 55;
        var arrow_y = ty;

        if (sprite_exists(arrow_sprite))
        {
            draw_sprite_ext(arrow_sprite, 0, arrow_x, arrow_y, 1, 1, 0, c_white, 1);
        }
        else
        {
            draw_text(arrow_x, arrow_y, ">");
        }
    }
}

// --------------------------------------------------
// RIGHT MENU ITEMS
// --------------------------------------------------
if (left_locked || column_focus == 1 || final_locked)
{
    var right_center_x = right_box_x + right_box_w * 0.5;
    var right_start_y  = right_box_y + 140;
    var right_gap      = 90;

    for (var j = 0; j < array_length(right_options); j++)
    {
        var rtx = right_center_x;
        var rty = right_start_y + j * right_gap;

        var rscale = 1.0;

        if (column_focus == 1 && j == right_index)
        {
            rscale = 1.16;
        }

        draw_set_color(c_white);
        draw_text_transformed(rtx, rty, right_options[j], rscale, rscale, 0);
    }
}

// --------------------------------------------------
// DEBUG / STATUS TEXT
// Keep this during jam development.
// --------------------------------------------------
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_black);

var dbg_x = 40;
var dbg_y = gui_h - 120;

draw_text(dbg_x, dbg_y + 0,  "column_focus: " + string(column_focus));
draw_text(dbg_x, dbg_y + 20, "left_index: " + string(left_index));
draw_text(dbg_x, dbg_y + 40, "right_index: " + string(right_index));
draw_text(dbg_x, dbg_y + 60, "player_count: " + string(selected_player_count));
draw_text(dbg_x, dbg_y + 80, "selected_mode: " + string(selected_mode));