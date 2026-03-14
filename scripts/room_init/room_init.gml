function room_init() {
    // collect all spawnpoints in the room into an array
    var _spawns = [];
    var _inst   = instance_find(oSpawnpoint, 0);
    with (oSpawnpoint) {
        array_push(_spawns, id);
    }

    var _spawnIndex = 0;

    for (var _i = 0; _i < 4; _i++) {
        var _data = god.session[_i];

        // skip inactive slots
        if (_data == undefined || !_data.active) continue;

        // no spawnpoint available for this player
        if (_spawnIndex >= array_length(_spawns)) {
            show_debug_message("room_init: not enough spawnpoints for player " + string(_i));
            continue;
        }

        var _spawn = _spawns[_spawnIndex];
        _spawnIndex++;

        // spawn the correct child object at the spawnpoint position
        var _pl = instance_create_layer(
            _spawn.x,
            _spawn.y,
            "Instances",
            _data.weaponClass
        );

        // assign player index and input config
        _pl.player     = _i;
        _pl.inputType  = _data.inputType;
        _pl.inputSlot  = _data.inputSlot;
        _pl.team       = _data.team;

        // mark spawnpoint as taken
        _spawn.taken = true;
    }
	team_asymmetry_check();
}