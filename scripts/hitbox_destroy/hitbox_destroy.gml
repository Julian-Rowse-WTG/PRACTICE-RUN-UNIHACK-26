function hitbox_destroy() {
    if (!destroy) exit;
    instance_destroy();
    // loop through ignore list and clear it
    for (i = ds_list_size(ignoreList) - 1; i >= 0; i--) {
        target = ds_list_find_value(ignoreList, i);
        ds_list_delete(ignoreList, i);
    }
    if (ds_list_size(ignoreList) == 0) {
        ds_list_destroy(ignoreList);
    }
    // only reset owner hitbox if owner still exists
    if (instance_exists(owner)) {
        owner.hitbox = -1;
    }
}