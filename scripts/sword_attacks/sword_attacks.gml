function sword_attacks() {
    var _dmg = 8 * (superMode ? superDamage : 1);

    switch (subState) {
        case attacks.side_ground:
        case attacks.side_air:
            if (frame_check(1, 0)) {
                hitbox_create(-2*facing, -16, 26*facing, 14, 6, 3*facing, -2, 60, _dmg);
            }
        break;
        case attacks.up_ground:
        case attacks.up_air:
            if (frame_check(1, 0)) {
                hitbox_create(-2*facing, -32, 20*facing, 22, 6, 3*facing, -4, 60, _dmg);
            }
        break;
        case attacks.down_ground:
        case attacks.down_air:
            if (frame_check(1, 0)) {
                hitbox_create(-10*facing, -12, 18*facing, 26, 6, 3*facing, 3, 60, _dmg);
            }
        break;
    }
}