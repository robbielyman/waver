page = {}

function page:song_view()
  screen.clear()
  local track = tracks[fn.active_track()]
  screen.move(0,40)
  screen.level(15)
  screen.text("active track: " .. fn.active_track())
  screen.move(0,46)
  if is_playing then    
      screen.text("playing")
  else  
      screen.text("stopped")
  end
  screen.level(4)
  local x_pos = 0
  for _, s in ipairs(track.samples) do
    local height = util.round(math.abs(s) * waveform_height)
    screen.move(x_pos, waveform_pos - height)
    screen.line_rel(0, 2 * height)
    screen.stroke()
    x_pos = x_pos + 1
  end
  screen.update()
end


function page:render()
  page:song_view()
end

function page.init()
  waveform_height = 30
  waveform_pos = 20
  print("page_init finished")
end

return page
