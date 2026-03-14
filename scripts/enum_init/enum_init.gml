function enum_init() {
	enum states {
	    normal,
	    wallRun,
	    dash,
	    attack,
	    dodge,
	    block,
	    burst,
	    special,
	    softKnock,
	    tumble,
	    dead,
	    recovery
	}
    enum attacks {
        side_ground,
        side_air,
        up_ground,
        up_air,
        down_ground,
        down_air
    }
    enum weapons {
        sword,
        dagger,
        spear,
        axe
    }
    enum inputType {
        keyboard,
        gamepad
    }
    enum teams {
        none,
        red,
        blue,
        green,
        yellow
    }
}