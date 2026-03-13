draw_set_font(fnt_fighter);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

for (var i = 0; i < array_length(options); i++)
{
    var draw_x = menu_x;
    var draw_y = menu_y + i * spacing;

    if (i == selection)
    {
        var scale = 1 + 0.05 * sin(current_time / 150);
        draw_set_colour(c_yellow);
        draw_text_transformed(draw_x, draw_y, options[i], scale, scale, 0);
    }
    else
    {
        draw_set_colour(c_white);
        draw_text(draw_x, draw_y, options[i]);
    }
}