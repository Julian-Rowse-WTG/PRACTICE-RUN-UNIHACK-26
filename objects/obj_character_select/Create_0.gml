// --------------------------------------------------
// CHARACTER SELECT - CREATE EVENT
// CURSOR-BASED VERSION
// --------------------------------------------------
show_debug_message("=== CHARACTER SELECT CREATE START ===");



show_debug_message("Character select cursor sprites assigned.");

// --------------------------------------------------
// SAFETY CHECKS
// --------------------------------------------------
if (!variable_global_exists("cs_player_active"))
{
    show_debug_message("ERROR: global.cs_player_active missing. Character select expects rm_input_bind handoff.");
}

if (!variable_global_exists("cs_player_schema_type"))
{
    show_debug_message("ERROR: global.cs_player_schema_type missing.");
}

if (!variable_global_exists("cs_player_schema_id"))
{
    show_debug_message("ERROR: global.cs_player_schema_id missing.");
}

if (!variable_global_exists("cs_player_input_label"))
{
    show_debug_message("ERROR: global.cs_player_input_label missing.");
}

// --------------------------------------------------
// GUI SIZE
// --------------------------------------------------
gui_w = display_get_gui_width();
gui_h = display_get_gui_height();

show_debug_message("GUI size = " + string(gui_w) + " x " + string(gui_h));

// --------------------------------------------------
// CHARACTER PANELS / TILES
// Hardcoded rectangles because jam speed matters.
// --------------------------------------------------
panel_count = 3;

panel_w = 320;
panel_h = 520;
panel_y = 180;
panel_gap = 140;

total_w = panel_count * panel_w + (panel_count - 1) * panel_gap;
start_x = (gui_w - total_w) * 0.5;

panel_x = array_create(panel_count, 0);
panel_x[0] = start_x;
panel_x[1] = start_x + panel_w + panel_gap;
panel_x[2] = start_x + (panel_w + panel_gap) * 2;

character_names = array_create(panel_count, "");
character_names[0] = "Character 1";
character_names[1] = "Character 2";
character_names[2] = "Character 3";

// Store tile bounds explicitly for easy hover checks
tile_x1 = array_create(panel_count, 0);
tile_y1 = array_create(panel_count, 0);
tile_x2 = array_create(panel_count, 0);
tile_y2 = array_create(panel_count, 0);

for (var i = 0; i < panel_count; i++)
{
    tile_x1[i] = panel_x[i];
    tile_y1[i] = panel_y;
    tile_x2[i] = panel_x[i] + panel_w;
    tile_y2[i] = panel_y + panel_h;

    show_debug_message(
        "Tile " + string(i) +
        " bounds = (" + string(tile_x1[i]) + ", " + string(tile_y1[i]) + ")" +
        " to (" + string(tile_x2[i]) + ", " + string(tile_y2[i]) + ")"
    );
}

// --------------------------------------------------
// PLAYER SETUP
// IMPORTANT: ONLY ACTIVE PLAYERS FROM INPUT BIND
// --------------------------------------------------
max_players = 4;

player_active         = array_create(max_players, false);
player_schema_type    = array_create(max_players, "");
player_schema_id      = array_create(max_players, -1);
player_input_label    = array_create(max_players, "");

player_colour = array_create(max_players, c_white);
player_colour[0] = make_colour_rgb(255, 110, 110); // P1 red
player_colour[1] = make_colour_rgb(100, 170, 255); // P2 blue
player_colour[2] = make_colour_rgb(120, 220, 120); // P3 green
player_colour[3] = make_colour_rgb(255, 190, 70);  // P4 orange

for (var p = 0; p < max_players; p++)
{
    player_active[p]      = global.cs_player_active[p];
    player_schema_type[p] = global.cs_player_schema_type[p];
    player_schema_id[p]   = global.cs_player_schema_id[p];
    player_input_label[p] = global.cs_player_input_label[p];

    show_debug_message(
        "P" + string(p + 1) +
        " active=" + string(player_active[p]) +
        " schema_type=" + string(player_schema_type[p]) +
        " schema_id=" + string(player_schema_id[p]) +
        " label=" + string(player_input_label[p])
    );
}

// --------------------------------------------------
// CURSORS
// Each player gets a virtual cursor.
// This is NOT tied to the mouse.
// --------------------------------------------------
cursor_x = array_create(max_players, 0);
cursor_y = array_create(max_players, 0);

// Start positions: spread them a bit so they are visible.
for (var p = 0; p < max_players; p++)
{
    if (!player_active[p]) continue;

    var start_tile = clamp(p, 0, panel_count - 1);

    cursor_x[p] = (tile_x1[start_tile] + tile_x2[start_tile]) * 0.5;
    cursor_y[p] = tile_y1[start_tile] + panel_h * 0.5;

    show_debug_message("P" + string(p + 1) + " cursor start = (" + string(cursor_x[p]) + ", " + string(cursor_y[p]) + ")");
}

// --------------------------------------------------
// CURSOR MOVEMENT SETTINGS
// --------------------------------------------------
cursor_speed = 14;     // keyboard digital move per step
stick_speed  = 18;     // analog stick speed per step
stick_deadzone = 0.28; // extra safety threshold for cursor move logic

// --------------------------------------------------
// PER-PLAYER DIGITAL LATCHES
// Prevent held directions from retriggering as "pressed" every frame.
// --------------------------------------------------
left_held  = array_create(max_players, false);
right_held = array_create(max_players, false);
up_held    = array_create(max_players, false);
down_held  = array_create(max_players, false);

// --------------------------------------------------
// SELECTION STATE
// hovered_tile[p] = which tile cursor is currently over, else -1
// player_confirmed[p] = whether player has stamped a tile
// player_choice[p] = tile index they stamped
// --------------------------------------------------
hovered_tile      = array_create(max_players, -1);
player_confirmed  = array_create(max_players, false);
player_choice     = array_create(max_players, -1);

// --------------------------------------------------
// CONFIRMED BADGE POSITION
// This stores where the cursor was when confirm happened.
// --------------------------------------------------
stamp_x = array_create(max_players, 0);
stamp_y = array_create(max_players, 0);

// Hardcoded offsets inside a tile for where each player's badge sits
slot_off_x = array_create(4, 0);
slot_off_y = array_create(4, 0);

slot_off_x[0] = 95;  slot_off_y[0] = 115;
slot_off_x[1] = 225; slot_off_y[1] = 155;
slot_off_x[2] = 105; slot_off_y[2] = 265;
slot_off_x[3] = 225; slot_off_y[3] = 315;

// --------------------------------------------------
// READY TO ADVANCE FLAG
// Not implemented yet - stub only for next person.
// --------------------------------------------------
all_confirmed = false;

// --------------------------------------------------
// OPTIONAL: set deadzone for any bound pads
// This is safe because we already know the specific pad slot from input bind.
// --------------------------------------------------
for (var p = 0; p < max_players; p++)
{
    if (!player_active[p]) continue;
    if (player_schema_type[p] == "pad")
    {
        var pad = player_schema_id[p];

        if (gamepad_is_connected(pad))
        {
            gamepad_set_axis_deadzone(pad, 0.2);
            show_debug_message("Set deadzone 0.2 on pad slot " + string(pad) + " for P" + string(p + 1));
        }
        else
        {
            show_debug_message("WARNING: Assigned pad slot " + string(pad) + " for P" + string(p + 1) + " is not currently connected.");
        }
    }
}

// --------------------------------------------------
// PLAYER CURSOR SPRITES
// These replace the drawn P1/P2/P3/P4 circles.
// IMPORTANT:
// Best result is if each sprite origin is centered.
// If not, we manually center during draw.
// --------------------------------------------------
player_cursor_sprite = array_create(max_players, -1);

player_cursor_sprite[0] = spr_counter_icon_p1;
player_cursor_sprite[1] = spr_counter_icon_p2;
player_cursor_sprite[2] = spr_counter_icon_p3;
player_cursor_sprite[3] = spr_counter_icon_p4;

show_debug_message("=== CHARACTER SELECT CREATE END ===");

