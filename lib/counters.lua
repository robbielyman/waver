counters = {}

function counters.init()
    counters.ui = metro.init(counters.screenminder,1/15)
    counters.ui.frame = 1
    counters.fps = 15
    counters.ui:start()

    counters.transport = metro.init(counters.sceneminder,1/5)
    counters.transport.frame = 1
    counters.transport:start()
end

function counters.screenminder()
    if counters.ui ~= nil then
        counters.ui.frame = counters.ui.frame + 1
    end
    fn.dirty_screen(true)
end

function counters.sceneminder()
    if counters.transport ~= nil then
        counters.transport.frame = counters.transport.frame + 1
    end
    for _, track in ipairs(tracks) do
        if track.waiting_for_samples and callback_inactive then
            track:buffer_render()
        end
    end
end

function counters.redraw_clock()
  while true do
    if fn.dirty_screen() then
      redraw()
      fn.dirty_screen(false)
    end
    if fn.dirty_scene() then
      redraw_scene()
      fn.dirty_scene(false)
    end
    clock.sleep(1 / counters.fps)
  end
end

return counters
