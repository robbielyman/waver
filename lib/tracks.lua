tracks = {}

Track = {
    file = "",
    level = 1,
    pan = 0,
    id = 0,
    waiting_for_samples = -1,
    samples = {}
}

function Track:buffer_render()
    callback_inactive = false
    softcut.buffer_clear()
    softcut.buffer_read_mono(self.file,0,0,-1,1,1,0,self.level)
    softcut.event_render(function(_,_,_,samples)
        if not callback_inactive then
            print("track " .. self.id .. " got a callback for render call " .. self.waiting_for_samples)
            if self.waiting_for_samples == 1 then
                self.samples = samples
            else
                for i = 1, 60*128 do
                    self.samples[#self.samples + 1] = samples[i]
                end
            end
            self.waiting_for_samples = self.waiting_for_samples == 5 and -1 or self.waiting_for_samples + 1
            fn.dirty_scene(true)
            callback_inactive = true
        end
    end)
    softcut.render_buffer(1,(self.waiting_for_samples -1)*60 ,(self.waiting_for_samples)*60,60*128)
    fn.dirty_scene(true)
end

function scratch_track:buffer_render()
    callback_inactive = false
    softcut.event_render(function(_,_,_,samples)
        if not callback_inactive then
            print("scratch track got a callback for render call " .. self.waiting_for_samples)
            if self.waiting_for_samples == 1 then
                self.samples = samples
            else
                for i = 1, 60*128 do
                    self.samples[#self.samples + 1] = samples[i]
                end
            end
            self.waiting_for_samples = self.waiting_for_samples == 5 and -1 or self.waiting_for_samples + 1
            callback_inactive = true
            fn.dirty_screen(true)
        end
    end)
    softcut.render_buffer(2,(self.waiting_for_samples - 1)*60,(self.waiting_for_samples)*60,60*128)
end

function Track:new(file, level, pan, id)
    local t = setmetatable({}, { __index = Track })
    t.file = file
    t.level = level
    t.pan = pan
    t.id = id
    t.waiting_for_samples = 1
    return t
end

local working_dir = _path.dust .. "code/waver/data/active"

function tracks.init()
    fn.dirty_scene(true)
    callback_inactive = true
    for i = 1, num_tracks do
        tracks[i] = Track:new(working_dir .. "/track_" .. i ..".wav",1,0,i)
    end
    scratch_track = Track:new("",1,0,-1)
    scratch_track.waiting_for_samples = 0
end

function scratch_track:load(file)
    if file == "cancel" then
        return
    end
    self.file = file
    softcut.buffer_read_mono(self.file,0,0,-1,1,2,0,1)
    self.waiting_for_samples = 1
    fn.dirty_screen(true)
end

return tracks
