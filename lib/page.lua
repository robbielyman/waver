page = {}

function page:song_view()
  screen.clear()
  local track = tracks[active_track]
  screen.level(4)
  local x_pos = 0
  for _, s in ipairs(track.samples) do
    local height = util.round(math.abs(s) * waveform_height)
    screen.move(util.linlin(0,128,10,120,x_pos), waveform_pos - height)
    screen.line_rel(0, 2 * height)
    screen.stroke()
    x_pos = x_pos + 1
  end
end


function page:render()
  page:song_view()
end

function page.init()
  waveform_height = 30
  waveform_pos = 35
  page:render()
end

return page
