function animation_end() {
    if (!ds_exists(frameData, ds_type_list)) return false;
    var _dur = ds_list_find_value(frameData, currentFrame);
    if (is_undefined(_dur) || !is_real(_dur) || _dur <= 0) return false;
    return currentFrame == maxFrames && frameCounter >= _dur - 1;
}