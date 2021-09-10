page = {}

function page:song_view()
    graphics:setup()
    -- displays the current window as proportion of track length
    local miniwindow_start = util.round(window_start / track_length * 128)
    local miniwindow_end = util.round(window_end / track_length * 128)
    graphics:mlrs(miniwindow_start, 0, miniwindow_end, 1, 2)
    -- add minimap indicator of loop start and end
    local miniloop_start = util.round(loop_start / track_length * 128)
    local miniloop_end = util.round(loop_end / track_length * 128)
    graphics:mlrs(miniloop_start, 0, 0, 2, 5)
    graphics:mlrs(miniloop_start, 2, 1, 0, 5)
    graphics:mlrs(miniloop_end, 0, 0, 2, 5)
    graphics:mlrs(miniloop_end-2, 2, 1, 0, 5)
    local playhead = 0
    if fn.looping() then
        playhead = util.round((counters.ui.frame / counters.ui.fps) * 128/(loop_end - loop_start)% 128)
    end
    graphics:mlrs(playhead, 0, 0, (num_tracks + 1) * waveform_height)
    local y_pos = 0
    for i, track in ipairs(tracks) do
        local x_pos = 0
        y_pos = y_pos + waveform_height
        for _, s in ipairs(track.samples) do
            local height = util.round(math.abs(s) * waveform_height *
                (i == fn.active_track() and 2 or 1))
            graphics:mlrs(x_pos, y_pos - height, 0, 2*height, i == fn.active_track() and 10 or 4)
            x_pos = x_pos + 1
        end
    end
    graphics:teardown()
end


function page:render()
  page:song_view()
end

function page.init()
  waveform_height = 10
  waveform_pos = 10
  window_start = 0
  window_end = 30
end

return page
