page = {}

function page:song_view()
    graphics:setup()
    local y_pos = waveform_pos
    for i, track in ipairs(tracks) do
        local x_pos = 0
        for _, s in ipairs(track.samples) do
            local height = util.round(math.abs(s) * 
                (waveform_height + (i == fn.active_track() and 5 or 0)))
            graphics:mlrs(x_pos, y_pos - height, 0, 2*height, i == fn.active_track() and 8 or 4)
            x_pos = x_pos + 1
        end
        y_pos = y_pos + waveform_height + 6 and i == fn.active_track() or 1
    end
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
