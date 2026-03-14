if (victory == victoryState.display || victory == victoryState.leave) {
    var _guiW = display_get_gui_width();
    var _guiH = display_get_gui_height();

    // dark overlay
    draw_set_alpha(victoryFade * 0.6);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _guiW, _guiH, false);
    draw_set_alpha(1);

    // victory sprite — centered upper half
    var _sprW = sprite_get_width(sprVictory);
    var _sprH = sprite_get_height(sprVictory);
    var _sprX = _guiW * 0.5;
    var _sprY = _guiH * 0.35;
    draw_set_alpha(victoryFade);
    draw_sprite(sprVictory, 0, _sprX, _sprY);

    // team text — below sprite
    var _teamCol;
    var _teamText;
	switch (victoryTeam) {
	    case teams.red:
	        _teamCol  = c_red;
	        _teamText = "Red Team Wins!";
	    break;
	    case teams.blue:
	        _teamCol  = c_blue;
	        _teamText = "Blue Team Wins!";
	    break;
	    case teams.green:
	        _teamCol  = c_green;
	        _teamText = "Green Team Wins!";
	    break;
	    case teams.yellow:
	        _teamCol  = c_yellow;
	        _teamText = "Yellow Team Wins!";
	    break;
	    default:
	        _teamCol  = c_white;
	        _teamText = "Draw";
	    break;
	}
    draw_set_color(_teamCol);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(victoryFade);
    draw_text(_guiW * 0.5, _sprY + _sprH * 0.5 + 24, _teamText);

    // press any button prompt — flashes
    if (victoryInputReady) {
        var _flash = (current_time mod 800) < 400; // flashes every 0.4 sec
        if (_flash) {
            draw_set_color(c_white);
            draw_set_alpha(victoryFade);
            draw_text(_guiW * 0.5, _guiH * 0.75, "Press any button to continue");
        }
    }

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}