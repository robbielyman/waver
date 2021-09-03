page = {}

function page:song_view()
    graphics:setup()
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
    local playhead = 0
    if fn.looping() then
        playhead = util.round((counters.ui.frame / counters.ui.fps) * 128/fn.length_loop() % 128)
    end
    graphics:mlrs(playhead, 0, 0, (num_tracks + 1) * waveform_height)
    graphics:teardown()
end


function page:render()
  page:song_view()
end

function page.init()
  waveform_height = 10
  waveform_pos = 10
  print("page_init finished")
end

return page
