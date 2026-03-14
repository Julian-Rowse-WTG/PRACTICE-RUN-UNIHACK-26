function hud_draw() {
    var _count   = 0;
    var _players = ds_list_create();
    with (oPlayer) {
        ds_list_add(_players, id);
        _count++;
    }
    ds_list_sort(_players, true);
    if (_count == 0) {
        ds_list_destroy(_players);
        exit;
    }

    // layout constants
    var _guiW      = display_get_gui_width();
    var _barH      = 18;
    var _barPadX   = 40;
    var _barPadY   = 16;
    var _gap       = 10;
    var _totalBarW = _guiW - (_barPadX * 2);
    var _barW      = floor((_totalBarW - (_gap * (_count - 1))) / _count);

    // sub-bar layout
    var _subH      = 8;   // height of burst/cooldown row
    var _subGap    = 4;   // gap between health bar and sub row
    var _subY      = _barPadY + _barH + _subGap;

    // burst icon size
    var _iconW     = sprite_get_width(sprBurstIcon);
    var _iconH     = sprite_get_height(sprBurstIcon);
    var _iconGap   = 3;

    // cooldown bar — sits left of burst icons, right-to-left
    var _coolW     = floor(_barW * 0.35); // 35% of bar width for cooldown
    var _coolH     = _subH;

    for (var i = 0; i < _count; i++) {
        var _pl    = _players[| i];
        var _pid   = _pl.player;
        var _hp    = _pl.hp;
        var _hpMax = _pl.hpMax;
        var _ratio = clamp(_hp / _hpMax, 0, 1);
        var _ghost = clamp(ghostHp[_pid] / _hpMax, 0, 1);

        // drain ghost hp
        if (ghostHp[_pid] > _hp) {
            ghostHp[_pid] = max(ghostHp[_pid] - ghostDrainSpeed, _hp);
        } else {
            ghostHp[_pid] = _hp;
        }

        var _bx = _barPadX + (i * (_barW + _gap));
        var _by = _barPadY;

        // --- team color ---
        var _teamCol;
        switch (_pl.team) {
            case teams.red:    _teamCol = c_red;    break;
            case teams.blue:   _teamCol = c_blue;   break;
            case teams.green:  _teamCol = c_green;  break;
            case teams.yellow: _teamCol = c_yellow; break;
            default:           _teamCol = c_white;  break;
        }

        // --- health bar background ---
        draw_set_color(c_black);
        draw_rectangle(_bx, _by, _bx + _barW, _by + _barH, false);

        // --- ghost bar ---
        draw_set_color(c_white);
        draw_rectangle(_bx, _by, _bx + floor(_barW * _ghost), _by + _barH, false);

        // --- health bar ---
        var _col;
        if (_ratio > 0.5) {
            _col = merge_color(c_yellow, c_lime, (_ratio - 0.5) * 2);
        } else {
            _col = merge_color(c_red, c_yellow, _ratio * 2);
        }
        draw_set_color(_col);
        draw_rectangle(_bx, _by, _bx + floor(_barW * _ratio), _by + _barH, false);

        // --- health bar border ---
        draw_set_color(c_white);
        draw_rectangle(_bx, _by, _bx + _barW, _by + _barH, true);

        // --- player label ---
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_bx + (_barW * 0.5), _by + _barH + 10, "P" + string(_pid + 1));

        // --- hp numbers ---
        draw_set_halign(fa_right);
        draw_text(_bx + _barW - 4, _by + (_barH * 0.5), string(_hp) + "/" + string(_hpMax));
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);

        // -------------------------------------------------------
        // SUB ROW — cooldown bar (left) + burst icons (right)
        // -------------------------------------------------------
        var _burstMax    = _pl.burstMax;
        var _burstCharge = _pl.burstCharges;

        // how much width the burst icons need
        var _iconsW = (_burstMax * _iconW) + (max(_burstMax - 1, 0) * _iconGap);
        // clamp cooldown bar so icons + cooldown never exceed _barW
        var _availCool = _barW - _iconsW - _iconGap;
        _coolW = max(floor(_availCool * 0.5), 0); // use up to 50% of remaining space

        // cooldown bar — anchored to left of sub row
        var _coolX = _bx;
        var _coolRatio = 1; // always full for now, wire up later
        // background
        draw_set_color(c_black);
        draw_rectangle(_coolX, _subY, _coolX + _coolW, _subY + _coolH, false);
        // fill
        draw_set_color(_teamCol);
        draw_rectangle(_coolX, _subY, _coolX + floor(_coolW * _coolRatio), _subY + _coolH, false);
        // border
        draw_set_color(c_white);
        draw_rectangle(_coolX, _subY, _coolX + _coolW, _subY + _coolH, true);

        // burst icons — anchored to right of sub row, drawn left to right
        var _iconsStartX = _bx + _barW - _iconsW;
        for (var j = 0; j < _burstMax; j++) {
            var _ix = _iconsStartX + (j * (_iconW + _iconGap));
            var _iy = _subY + (_coolH * 0.5) - (_iconH * 0.5);
            if (j < _burstCharge) {
                // active — team color
                draw_sprite_ext(sprBurstIcon, 0, _ix, _iy, 1, 1, 0, _teamCol, 1);
            } else {
                // spent — grey
                draw_sprite_ext(sprBurstIcon, 0, _ix, _iy, 1, 1, 0, c_dkgray, 1);
            }
        }
    }
    ds_list_destroy(_players);
}
hud_draw();