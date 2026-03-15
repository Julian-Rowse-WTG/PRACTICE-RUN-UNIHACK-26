// --------------------------------------------------
// JUGGERNAUT SELECT - CREATE EVENT
// --------------------------------------------------
show_debug_message("=== JUGGERNAUT SELECT CREATE START ===");

gui_w = display_get_gui_width();
gui_h = display_get_gui_height();

// Safety: fall back to 3 if globals are missing
if (!variable_global_exists("selected_player_count")) {
    show_debug_message("ERROR: global.selected_player_count missing in juggernaut select!");
    max_players = 3;
} else {
    max_players = global.selected_player_count;
}

show_debug_message("Juggernaut select: max_players = " + string(max_players));

// --------------------------------------------------
// COPY PLAYER DATA FROM GLOBALS
// --------------------------------------------------
player_active      = array_create(max_players, false);
player_schema_type = array_create(max_players, "");
player_schema_id   = array_create(max_players, -1);
player_input_label = array_create(max_players, "");
player_colour      = array_create(max_players, c_white);

player_colour[0] = make_colour_rgb(255, 110, 110);  // P1 red
player_colour[1] = make_colour_rgb(100, 170, 255);  // P2 blue
player_colour[2] = make_colour_rgb(120, 220, 120);  // P3 green
player_colour[3] = make_colour_rgb(255, 190, 70);   // P4 orange

for (var p = 0; p < max_players; p++) {
    player_active[p]      = global.cs_player_active[p];
    player_schema_type[p] = global.cs_player_schema_type[p];
    player_schema_id[p]   = global.cs_player_schema_id[p];
    player_input_label[p] = global.cs_player_input_label[p];

    show_debug_message(
        "P" + string(p + 1) +
        " active=" + string(player_active[p]) +
        " schema=" + player_schema_type[p]
    );
}

// --------------------------------------------------
// CHARACTER SPRITES (passed from char select)
// Used to draw the player's chosen character on their tile
// --------------------------------------------------
player_sprite = array_create(max_players, -1);
if (variable_global_exists("cs_player_sprite")) {
    for (var p = 0; p < max_players; p++) {
        player_sprite[p] = global.cs_player_sprite[p];
        show_debug_message("P" + string(p + 1) + " sprite = " + string(player_sprite[p]));
    }
} else {
    show_debug_message("WARNING: global.cs_player_sprite not set. No character sprites will show.");
}

// --------------------------------------------------
// TILE LAYOUT
// N tiles evenly spaced horizontally, tall, centred
// --------------------------------------------------
var h_margin  = 50;   // left/right screen margin
var tile_gap  = 24;   // gap between tiles
var avail_w   = gui_w - 2 * h_margin;

tile_w = floor((avail_w - (max_players - 1) * tile_gap) / max_players);
tile_h = floor(gui_h * 0.60);

// Push tiles down a bit to leave room for title text
tile_top = 110;

tile_x1 = array_create(max_players, 0);
tile_y1 = array_create(max_players, 0);
tile_x2 = array_create(max_players, 0);
tile_y2 = array_create(max_players, 0);

for (var p = 0; p < max_players; p++) {
    tile_x1[p] = h_margin + p * (tile_w + tile_gap);
    tile_y1[p] = tile_top;
    tile_x2[p] = tile_x1[p] + tile_w;
    tile_y2[p] = tile_top + tile_h;

    show_debug_message(
        "Tile " + string(p) +
        " = (" + string(tile_x1[p]) + ", " + string(tile_y1[p]) + ")" +
        " to (" + string(tile_x2[p]) + ", " + string(tile_y2[p]) + ")"
    );
}

// --------------------------------------------------
// CURSOR SETUP
// Each active player gets a free-floating cursor
// --------------------------------------------------
cursor_x     = array_create(max_players, 0);
cursor_y     = array_create(max_players, 0);
cursor_held  = array_create(max_players, false);

// Start cursor centred on each player's own tile
for (var p = 0; p < max_players; p++) {
    cursor_x[p] = (tile_x1[p] + tile_x2[p]) * 0.5;
    cursor_y[p] = (tile_y1[p] + tile_y2[p]) * 0.5;
}

cursor_speed   = 14;
stick_speed    = 18;
stick_deadzone = 0.28;

// Digital direction latches
left_held  = array_create(max_players, false);
right_held = array_create(max_players, false);
up_held    = array_create(max_players, false);
down_held  = array_create(max_players, false);

hovered_tile = array_create(max_players, -1);

// Set pad deadzones
for (var p = 0; p < max_players; p++) {
    if (!player_active[p]) continue;
    if (player_schema_type[p] == "pad") {
        var _pad = player_schema_id[p];
        if (gamepad_is_connected(_pad)) {
            gamepad_set_axis_deadzone(_pad, 0.2);
            show_debug_message("Deadzone set on pad " + string(_pad) + " for P" + string(p + 1));
        }
    }
}

// --------------------------------------------------
// JUGGERNAUT STATE
// juggernaut_player = -1 → no one selected yet
// juggernaut_player = 0..3 → that player is the juggernaut
// --------------------------------------------------
juggernaut_player = -1;

// --------------------------------------------------
// BOTTOM DIVIDER / START BAR
// --------------------------------------------------
divider_y = tile_top + tile_h + 20;
divider_h = 58;

// --------------------------------------------------
// TRANSITION STATE
// --------------------------------------------------
transitioning = false;
fade_alpha    = 0.0;
fade_duration = room_speed; // 1 second

// Shared animation timer for pulsing/glow effects
anim_timer = 0;

hovering_over_start_button = false;

show_debug_message("=== JUGGERNAUT SELECT CREATE END ===");