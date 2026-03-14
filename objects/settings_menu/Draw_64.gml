draw_set_valign(fa_middle);

for (var i = 0; i < array_length(options); i++)
{
    var row_y = menu_y + i * spacing;
    var selected = (i == selection);

    var scale = selected ? 1.08 : 1.0;
    var col = selected ? c_yellow : c_white;

    var box_left   = menu_x - btn_w * 0.5 * scale;
    var box_right  = menu_x + btn_w * 0.5 * scale;
    var box_top    = row_y - btn_h * 0.5 * scale;
    var box_bottom = row_y + btn_h * 0.5 * scale;

    var pad = 24;

    draw_set_colour(make_colour_rgb(30, 30, 30));
    draw_rectangle(box_left, box_top, box_right, box_bottom, false);

    draw_set_colour(col);
    draw_rectangle(box_left, box_top, box_right, box_bottom, true);

    // -------------------------
    // Left-side label
    // -------------------------
    draw_set_halign(fa_left);
    draw_set_colour(col);
    draw_text(box_left + pad, row_y, options[i]);

    var type = types[i];

    // -------------------------
    // Checkbox
    // -------------------------
    if (type == "checkbox")
    {
        draw_set_halign(fa_right);
        draw_text(box_right - pad, row_y, values[i] ? "ON" : "OFF");
    }

    // -------------------------
    // Slider
    // -------------------------
    if (type == "slider")
    {
        var slider_w = 150;
        var slider_h = 10;

        var slider_right = box_right - pad;
        var slider_left  = slider_right - slider_w;
        var slider_top   = row_y - slider_h * 0.5;
        var slider_bot   = row_y + slider_h * 0.5;

        var fill_w = slider_w * values[i];
        var knob_x = slider_left + fill_w;

        // bar outline
        draw_set_colour(c_white);
        draw_rectangle(slider_left, slider_top, slider_right, slider_bot, true);

        // filled portion
        draw_set_colour(col);
        draw_rectangle(slider_left, slider_top, slider_left + fill_w, slider_bot, false);

        // knob
        draw_circle(knob_x, row_y, 8, false);
    }
}