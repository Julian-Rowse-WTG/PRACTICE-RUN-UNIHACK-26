var _col;
switch (teamCol) {
    case teams.red:    _col = c_red;    break;
    case teams.blue:   _col = c_blue;   break;
    case teams.green:  _col = c_green;  break;
    case teams.yellow: _col = c_yellow; break;
    default:           _col = make_color_rgb(0, 255, 255); break;
}
draw_sprite_ext(sprite, frame, x, y, xScale * facing, yScale, 0, _col, alpha);