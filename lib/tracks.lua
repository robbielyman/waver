tracks = {}

Track = {
    file = "",
    level = 1,
    pan = 0,
    id = 0,
    samples = {}
}

function Track:buffer_render()
    softcut.buffer_clear()
    softcut.buffer_read_mono(self.file,0,0,-1,1,1,0,self.level)
    softcut.event_render(function(_,_,_,samples) self.samples = samples end)
    softcut.render_buffer(1,0,-1,128)
end

function Track:new(file, level, pan, id)
    local t = {}
    setmetatable(t, self)
    t.file = file
    t.level = level
    t.pan = pan
    t.id = id
    return t
end

local working_dir = "waver/data/active"

function tracks.init()
    fn.dirty_scene(true)
    for i = 1, num_tracks do
        tracks[i] = Track:new(working_dir .. "/track_" .. i ..".wav",1,0,i)
        tracks[i]:buffer_render()
    end
    scene:render()
end

return tracks
