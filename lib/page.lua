page = {}

function page:minimap()
    local window_end = window_start + window_length
    -- highlights minimap location of window
    local miniwindow_start  = util.linlin(0, track_length, 1, 128, window_start)
    local miniwindow_end    = util.linlin(0, track_length, 1, 128, window_end)
    graphics:mlrs(miniwindow_start, 1, miniwindow_end, 1, 2)
    -- add minimap indicator of loop start and end
    local miniloop_start    = util.linlin(0, track_length, 1, 128, loop_start)
    local miniloop_end      = util.linlin(0, track_length, 1, 128, loop_end)
    graphics:mlrs(miniloop_start, 0, 0, 2, 5)
    graphics:mlrs(miniloop_start, 2, 1, 0, 5)
    graphics:mlrs(miniloop_end, 0, 0, 2, 5)
    graphics:mlrs(miniloop_end-2, 2, 1, 0, 5)
    -- display playhead indicator on minimap
    local miniplayhead = util.linlin(0, track_length, 1, 128, playhead)
    graphics:mlrs(miniplayhead, 0, 0, 2, 15)
end

function page:track_view()
    local window_end    = window_start + window_length
    self:minimap()
    local track = tracks[fn.active_track()]
    local y_pos = 2 + 3*waveform_height
    local pixel_step = util.round(window_length)
    local pixel_start = util.round(window_start*128)
    local pixel_end = util.round(window_end*128)
    local x_pos = 1
    for j = pixel_start, pixel_end, pixel_step do
        local s = track.samples[j] or 0
        local height = util.round(math.abs(s) * 3 * waveform_height)
        graphics:mlrs(x_pos, y_pos - height, 0, 2*height, 4)
        x_pos = x_pos + 1
    end
    if scratch_track then
        x_pos = 1
        y_pos = y_pos + 2*waveform_height
        for j = pixel_start, pixel_end, pixel_step do
            local s = scratch_track.samples[j] or 0
            local height = util.round(math.abs(s) * 2 * waveform_height)
            graphics:mlrs(x_pos, y_pos - height, 0, 2 * height, 10)
            x_pos = x_pos + 1
        end
    end
    self:markers()
end

function page:song_view()
    local window_end    = window_start + window_length
    self:minimap(window_start, window_end)
    local y_pos = 2
    -- display tracks in window
    local pixel_step    = util.round(window_length)
    local pixel_start   = util.round(window_start*128)
    local pixel_end     = util.round(window_end*128)
    for i, track in ipairs(tracks) do
        local x_pos = 1
        y_pos = y_pos + waveform_height
        for j=pixel_start, pixel_end, pixel_step do
            local s = track.samples[j] or 0
            local height = util.round(math.abs(s) * waveform_height *
                (i == fn.active_track() and 2 or 1))
            graphics:mlrs(x_pos, y_pos - height, 0, 2*height, i == fn.active_track() and 10 or 4)
            x_pos = x_pos + 1
        end
    end
    self:markers()
end

function page:markers()
    -- add window indicator of loop start and end
    local windowloop_start  = util.round((loop_start - window_start) * 128/window_length)
    windowloop_start = windowloop_start == 0 and 1 or windowloop_start
    local windowloop_end    = util.round((loop_end - window_start) * 128/window_length)
    graphics:mlrs(windowloop_start, 2, 0, (num_tracks + 1)* waveform_height, 5)
    graphics:rect(windowloop_start, (num_tracks + 1)* waveform_height, 2, 2, 5)
    graphics:rect(windowloop_end-2, (num_tracks + 1)* waveform_height, 2, 2, 5)
    graphics:mlrs(windowloop_end, 2, 0, (num_tracks + 1) * waveform_height, 5)
    -- calculate playhead position in pixels
    -- and display playhead in window
    local window_playhead = util.round((playhead - window_start) * 128/window_length)
    graphics:mlrs(window_playhead, 2, 0, (num_tracks + 1) * waveform_height)
end

function page:render()
    graphics:setup()
    if active_page ==0 then
        self:song_view()
    end
    if active_page == 1 then
        self:track_view()
    end
    graphics:teardown()
end

function page.init()
    waveform_height = 10
    waveform_pos = 10
    window_length = 30
    window_start = 0
end

return page
