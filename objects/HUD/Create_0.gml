// ghost bar drain speed
ghostDrainSpeed = 0.3;

// per-player ghost hp tracking (max 7 players)
ghostHp = array_create(7, 0);

// initialise ghost hp to match players on creation
var _i = 0;
with(oPlayer){
    other.ghostHp[player] = hp;
    _i++;
}