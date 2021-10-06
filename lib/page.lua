page = {}

function page:minimap()
    local window_end = window_start + window_length
    -- highlights minimap location of window
    local miniwindow_start  = util.linlin(0, track_length, 1, 128, window_start)
    local miniwindow_end    = util.linlin(0, track_length, 1, 128, window_end)
    graphics:mls(miniwindow_start, 1, miniwindow_end, 1, 2)
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

local function drawsamples(track, start, finish, step, center, scale, brightness)
    local x_pos = 1
    for j = start,finish,step do
        local weight = j % 1
        local index = j - weight
        local s = track.samples[index] or 0
        local t = track.samples[index + 1] or 0
        local preheight = s*(1-weight) + t*weight
        local height = util.round(math.abs(preheight) * scale)
        graphics:mlrs(x_pos,center - height, 0, 2*height, brightness)
        x_pos = x_pos + 1
    end
end

function page:track_view()
    local window_end    = window_start + window_length
    self:minimap()
    drawsamples(tracks[fn.active_track()], window_start*128, window_end*128, window_length, 2 + 1.5*waveform_height, 1.5*waveform_height, fn.scratch_track_active() and 4 or 10)
    if scratch_track then
        drawsamples(scratch_track, window_start*128, window_end*128, window_length, 2 + 4 * waveform_height, waveform_height, fn.scratch_track_active() and 10 or 4)
    end
    self:barlines()
    self:markers()
    graphics:text(1,60,"TRACK")
    local track = tracks[fn.active_track()]
    graphics:text(30,60,"l " .. track.id .. ": " .. string.format("%.2f", track.level))
    graphics:text(65,60, "p: " .. string.format("%.2f",track.pan))
    graphics:text(95,60, "s l: " .. string.format("%.2f",scratch_track.level))
end

function page:song_view()
    local window_end    = window_start + window_length
    self:minimap()
    local y_pos = 2
    -- display tracks in window
    for i, track in ipairs(tracks) do
        drawsamples(track, window_start*128, window_end*128, window_length, 2 + i*waveform_height, waveform_height, i == fn.active_track() and 10 or 4 )
    end
    self:barlines()
    self:markers()
    graphics:text(1,60,"SONG")
end

-- linearly map [a,b] to [x,y] without clamping outside range
-- does not check for divide-by-zero errors
local function unsafelinlin(in_a, in_b, out_x, out_y, input)
    return (out_y - out_x)/(in_b - in_a)*(input - in_a) + out_x
end

function page:markers()
    -- add window indicator of loop start and end
    local windowloop_start  = unsafelinlin(0, window_length, 1, 128, loop_start - window_start)
    local windowloop_end    = unsafelinlin(0, window_length, 1, 128, loop_end - window_start)
    graphics:mlrs(windowloop_start, 2, 0, (num_tracks + 1)* waveform_height, fn.looping() and 5 or 1)
    graphics:rect(windowloop_start, (num_tracks + 1)* waveform_height, 2, 2, fn.looping() and 5 or 1)
    graphics:rect(windowloop_end-2, (num_tracks + 1)* waveform_height, 2, 2, fn.looping() and 5 or 1)
    graphics:mlrs(windowloop_end, 2, 0, (num_tracks + 1) * waveform_height, fn.looping() and 5 or 1)
    -- calculate playhead position in pixels
    -- and display playhead in window
    local window_playhead = unsafelinlin(0, window_length, 1, 128, playhead - window_start)
    graphics:mlrs(window_playhead, 2, 0, (num_tracks + 1) * waveform_height)
end

function page:barlines()
    local interval  = 60/params:get("tempo")
    local beats     = params:get("beats")
    local max_beats = 6*params:get("tempo") + beats
    for i = beats,maxbeats do
        local window_beat = unsafelinlin(0, window_length, 1, 128, interval * (i - beats) - window_start)
        graphics:mlrs(window_beat, 2, 0, 5, 1)
        if i % beats == 0 then
            graphics:text(window_beat + 1, 4, i / beats, 1)
        end
    end
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
