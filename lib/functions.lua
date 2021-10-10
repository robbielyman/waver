fn = {}

function fn.init()
    scene_dirty = true
    screen_dirty = true
    location = 0
end

function fn.dirty_screen(bool)
    if bool == nil then return screen_dirty end
    screen_dirty = bool
    return screen_dirty
end

function fn.dirty_scene(bool)
    if bool == nil then return scene_dirty end
    if bool then
        location = playhead + 0.75
    end
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
        if rec_armed then
            scene:record_arm(false)
        end
    else
        is_playing = true
    end
    for i = 1,2 do
        softcut.play(i, is_playing and 1 or 0)
    end
end

function fn.playing(bool)
    if bool == nil then return is_playing end
    is_playing = bool
    return is_playing
end

function fn.looping(bool)
    if bool == nil then return is_looping end
    is_looping = bool
    return is_looping
end

function rerun()
  norns.script.load(norns.state.script)
end

function fn.scratch_track_active(bool)
    if bool == nil then return active_scratch_track end
    active_scratch_track = bool
    return active_scratch_track
end


function r()
    rerun()
end

return fn
