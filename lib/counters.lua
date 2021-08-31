counters = {}

function counters.init()
    counters.ui = metro.init(counters.screenminder,1/15)
    counters.ui.frame = 1
end

function counters.screenminder()
    if counters.ui ~= nil then  
        counters.ui.frame = counters.ui.frame + 1   
    end
    redraw()
end

return counters
