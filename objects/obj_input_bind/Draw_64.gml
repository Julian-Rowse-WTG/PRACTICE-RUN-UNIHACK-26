// --------------------------------------------------
// INPUT BIND ROOM - DRAW GUI EVENT
// --------------------------------------------------
draw_clear_alpha(make_colour_rgb(235, 235, 235), 1);

draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// --------------------------------------------------
// SHOW STARTUP DELAY MESSAGE
// --------------------------------------------------
if (startup_lock_frames > 0)
{
    var seconds_left = ceil(startup_lock_frames / 60);

    draw_set_colour(c_black);
    draw_text(gui_w * 0.5, title_y + 80, "Preparing input binding...");
    draw_text(gui_w * 0.5, title_y + 120, "Input will unlock in " + string(seconds_left) + "...");
}
else
{
    draw_set_colour(c_black);
    draw_text(gui_w * 0.5, title_y + 80, "Press any valid controls to claim a slot. Perform your special input 3 times to confirm.");
}


// Title
draw_set_colour(c_black);
draw_text(gui_w * 0.5, title_y, "INPUT BIND / CONTROL CLAIM");

// Draw player boxes
for (var p = 0; p < max_players; p++)
{
    var x1 = player_box_x;
    var y1 = player_box_start_y + p * (player_box_h + player_box_gap);
    var x2 = x1 + player_box_w;
    var y2 = y1 + player_box_h;

    draw_set_colour(c_white);
    draw_rectangle(x1, y1, x2, y2, false);

    draw_set_colour(c_black);
    draw_rectangle(x1, y1, x2, y2, true);

    var header = "PLAYER " + string(p + 1);
    var status = "";
    var confirm_text = "";

    if (player_assigned[p])
    {
        if (player_schema_type[p] == "kb1") status = "Assigned: WASD + QE";
        else if (player_schema_type[p] == "kb2") status = "Assigned: IJKL + UO";
        else if (player_schema_type[p] == "kb3") status = "Assigned: Arrows + Shift/Enter";
        else if (player_schema_type[p] == "pad") status = "Assigned: Controller slot " + string(player_schema_id[p]);

        confirm_text = "Special confirms: " + string(player_confirm_count[p]) + " / " + string(required_special_count);
    }
    else
    {
        status = "Waiting for input...";
        confirm_text = "Not assigned yet";
    }

    draw_text((x1 + x2) * 0.5, y1 + 30, header);
    draw_text((x1 + x2) * 0.5, y1 + 65, status);
    draw_text((x1 + x2) * 0.5, y1 + 100, confirm_text);
}