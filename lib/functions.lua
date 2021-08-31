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

return fn
