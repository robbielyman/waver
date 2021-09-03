fn = {}

function fn.init()
    print("functions_init finished")
end

function fn.dirty_screen(bool)
    if bool == nil then return screen_dirty end
    screen_dirty = bool
    return screen_dirty
end

function fn.dirty_scene(bool)
    if bool == nil then return scene_dirty end
    scene_dirty = bool
    return scene_dirty
end

function fn.active_track(track)
    if track == nil then return active_track end
    active_track = track
    return active_track
end

function fn.toggle_playback()
    if is_playing == true then  
        is_playing = false 
    else    
        is_playing = true
    end
end

function fn.looping(bool)
    if bool == nil then return is_looping end
    is_looping = bool
    return is_looping
end

function fn.length_loop(length)
    if length == nil then return loop_length end
    loop_length = length
    return loop_length
end

function rerun()
  norns.script.load(norns.state.script)
end

function r()
    rerun()
end

return fn
