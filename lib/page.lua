page = {}

function page:song_view()
    graphics:setup()
    local window_start  = window_center - 0.5*window_length
    local window_end    = window_center + 0.5*window_length
    -- highlights minimap location of window
    local miniwindow_start  = util.round(window_start / track_length * 128)
    local miniwindow_end    = util.round(window_end / track_length * 128)
    graphics:mlrs(miniwindow_start, 0, miniwindow_end, 1, 2)
    -- add minimap indicator of loop start and end
    local miniloop_start    = util.round(loop_start / track_length * 128)
    miniloop_start = miniloop_start > 1 and miniloop_start or 1
    local miniloop_end      = util.round(loop_end / track_length * 128)
    graphics:mlrs(miniloop_start, 0, 0, 2, 5)
    graphics:mlrs(miniloop_start, 2, 1, 0, 5)
    graphics:mlrs(miniloop_end, 0, 0, 2, 5)
    graphics:mlrs(miniloop_end-2, 2, 1, 0, 5)
    -- calculate playhead position in seconds
    local playhead = util.round(counters.ui.frame / counters.ui.fps)
    if fn.looping() then
        playhead = (playhead % (loop_end - loop_start)) + loop_start
    else
        playhead = playhead % track_length
    end
    -- display playhead indicator on minimap
    local miniplayhead = util.round(playhead / track_length * 128)
    graphics:mlrs(miniplayhead, 0, 0, 2, 15)
    local y_pos = 2
    -- calculate playhead position in pixels
    -- and display playhead in window
    local window_playhead = util.round((playhead - window_start) * 128/window_length)
    graphics:mlrs(window_playhead, y_pos, 0, (num_tracks + 1) * waveform_height)
    local pixel_step = util.round(window_length/5)
    for i, track in ipairs(tracks) do
        local x_pos = 1
        y_pos = y_pos + waveform_height
        if not track.waiting_for_samples then
            for j=1, 60*128, pixel_step do
                local height = util.round(math.abs(track.samples[j]) * waveform_height *
                    (i == fn.active_track() and 2 or 1))
                graphics:mlrs(x_pos, y_pos - height, 0, 2*height, i == fn.active_track() and 10 or 4)
                x_pos = x_pos + 1
            end
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
  window_length = 30
  window_center = 15
end

return page
