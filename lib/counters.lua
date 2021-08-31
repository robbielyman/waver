counters = {}

function counters.init()
    counters.ui = metro.init(counters.screenminder,1/15)
    counters.ui.frame = 1
    counters.ui:start()

    counters.transport = metro.init(counters.sceneminder,1/15)
    counters.transport.frame = 1    
    counters.transport:start()
end

function counters.screenminder()
    if counters.ui ~= nil then
        counters.ui.frame = counters.ui.frame + 1
    end
    redraw()
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
    redraw_scene()
end

return counters
