tracks = {}

Track = {
    file = "",
    level = 1,
    pan = 0,
    id = 0,
    waiting_for_samples = false,
    samples = {}
}

function Track:buffer_render()
    callback_inactive = false
    softcut.buffer_clear()
    softcut.buffer_read_mono(self.file,0,0,-1,1,1,0,self.level)
    softcut.event_render(function(_,_,_,samples) 
        if not callback_inactive then
            print("track" .. self.id .. " got a callback!")
            self.samples = samples
            self.waiting_for_samples = false
            fn.dirty_scene(true)
            callback_inactive = true
        end
    end)
    softcut.render_buffer(1,0,5*60,5*60*128)
    fn.dirty_scene(true)
end

function Track:new(file, level, pan, id)
    local t = setmetatable({}, { __index = Track })
    t.file = file
    t.level = level
    t.pan = pan
    t.id = id
    t.waiting_for_samples = true
    return t
end

local working_dir = _path.dust .. "code/waver/data/active"

function tracks.init()
    fn.dirty_scene(true)
    callback_inactive = true
    for i = 1, num_tracks do
        tracks[i] = Track:new(working_dir .. "/track_" .. i ..".wav",1,0,i)
    end
end

return tracks
