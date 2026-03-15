if (god.victory != victoryState.none) exit;

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
var _gap       = 10;
var _totalBarW = _guiW - (_barPadX * 2);
var _barW      = floor((_totalBarW - (_gap * (_count - 1))) / _count);
var _labelW    = 24; // width reserved for player label on left

// sub-bar layout
var _subH    = 8;
var _subGap  = 4;
var _iconW   = sprite_get_width(sprBurstIcon);
var _iconH   = sprite_get_height(sprBurstIcon);
var _barPadY = display_get_gui_height() - _barH - _subGap - _iconH - 16;
var _subY    = _barPadY + _barH + _subGap;
var _iconGap = 3;



for (var i = 0; i < _count; i++) {
    var _pl      = _players[| i];
    var _pid     = _pl.player;
    var _hp      = _pl.hp;
    var _hpMax   = _pl.hpMax;
    var _ratio   = clamp(_hp / _hpMax, 0, 1);
    var _ghost   = clamp(ghostHp[_pid] / _hpMax, 0, 1);

    // drain ghost hp
    if (ghostHp[_pid] > _hp) {
        ghostHp[_pid] = max(ghostHp[_pid] - ghostDrainSpeed, _hp);
    } else {
        ghostHp[_pid] = _hp;
    }

    var _bx = _barPadX + (i * (_barW + _gap));
    var _by = _barPadY;

    // team color
    var _teamCol;
    switch (_pl.team) {
        case teams.red:    _teamCol = c_red;    break;
        case teams.blue:   _teamCol = c_blue;   break;
        case teams.green:  _teamCol = c_green;  break;
        case teams.yellow: _teamCol = c_yellow; break;
        default:           _teamCol = c_white;  break;
    }

    // -------------------------------------------------------
    // HEALTH BAR — team colored, with ghost bar
    // -------------------------------------------------------
	var _innerBx = _bx;
	var _innerW  = _barW;
	
    // background
    draw_set_color(c_black);
    draw_rectangle(_innerBx, _by, _innerBx + _innerW, _by + _barH, false);

    // ghost bar
    draw_set_color(c_white);
    draw_rectangle(_innerBx, _by, _innerBx + floor(_innerW * _ghost), _by + _barH, false);

    // health bar — team colored, darkens as hp drops
    var _hpCol = merge_color(c_black, _teamCol, _ratio);
    draw_set_color(_hpCol);
    draw_rectangle(_innerBx, _by, _innerBx + floor(_innerW * _ratio), _by + _barH, false);

    // border
    draw_set_color(_teamCol);
    draw_rectangle(_innerBx, _by, _innerBx + _innerW, _by + _barH, true);

    // player label — left of bar, team colored
	draw_set_color(c_white);
	draw_set_halign(fa_left);
	draw_set_valign(fa_middle);
	draw_text(_innerBx + 4, _by + (_barH * 0.5), "P" + string(_pid + 1));

    // hp numbers — right aligned inside bar
    draw_set_color(c_white);
    draw_set_halign(fa_right);
    draw_text(_innerBx + _innerW - 4, _by + (_barH * 0.5), string(_hp) + "/" + string(_hpMax));
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

// -------------------------------------------------------
        // SUB ROW — cooldown bar (left) + burst icons (right)
        // -------------------------------------------------------
        var _burstMax    = _pl.burstMax;
        var _burstCharge = _pl.burstCharges;

        // burst icons take up right side — fixed 16x16 with gap
        var _iconsW      = (_burstMax * _iconW) + (max(_burstMax - 1, 0) * _iconGap);

        // cooldown bar takes all remaining width to the left of icons
        var _coolW       = _barW - _iconsW - _iconGap;
        var _coolX       = _bx;

        // sub row height matches icon height (16px) for maximum use of space
        var _rowH  = _iconH; // 16
        var _rowY  = _barPadY + _barH + _subGap;

        // cooldown ratio
        var _coolRatio = (_pl.specialCooldownMax > 0)
            ? 1 - clamp(_pl.specialCooldown / _pl.specialCooldownMax, 0, 1)
            : 1;

        // cooldown bar background
        draw_set_color(c_black);
        draw_rectangle(_coolX, _rowY, _coolX + _coolW, _rowY + _rowH, false);

        // cooldown fill
        var _coolCol;
        if (_coolRatio >= 1) {
            _coolCol = _teamCol;
        } else {
            _coolCol = merge_color(c_dkgray, c_ltgray, _coolRatio);
        }
        draw_set_color(_coolCol);
        draw_rectangle(_coolX, _rowY, _coolX + floor(_coolW * _coolRatio), _rowY + _rowH, false);

        // cooldown border
        draw_set_color(c_white);
        draw_rectangle(_coolX, _rowY, _coolX + _coolW, _rowY + _rowH, true);

        // SP label — centered in cooldown bar, larger font
        draw_set_color(_coolRatio >= 1 ? c_black : c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_coolX + (_coolW * 0.5), _rowY + (_rowH * 0.5), "SP");

        // burst icons — right aligned, vertically centered in row
        var _iconsStartX = _bx + _barW - _iconsW;
        for (var j = 0; j < _burstMax; j++) {
            var _ix = _iconsStartX + (j * (_iconW + _iconGap));
            var _iy = _rowY + (_rowH * 0.5) - (_iconH * 0.5);
            if (j < _burstCharge) {
                var _iconCol = _pl.isSolo ? c_white : _teamCol;
                draw_sprite_ext(sprBurstIcon, 0, _ix, _iy, 1, 1, 0, _iconCol, 1);
            } else {
                draw_sprite_ext(sprBurstIcon, 0, _ix, _iy, 1, 1, 0, c_dkgray, 1);
            }
        }

    // player number above head in world space
    var _guiScaleX = display_get_gui_width()  / camera_get_view_width(view_camera[0]);
    var _guiScaleY = display_get_gui_height() / camera_get_view_height(view_camera[0]);
    var _camX      = camera_get_view_x(view_camera[0]);
    var _camY      = camera_get_view_y(view_camera[0]);
    var _screenX   = (_pl.x - _camX) * _guiScaleX;
    var _screenY   = (_pl.y - _camY - 40) * _guiScaleY;
    draw_set_color(_teamCol);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_screenX, _screenY, "P" + string(_pid + 1));
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
ds_list_destroy(_players);