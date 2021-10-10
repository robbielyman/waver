tracks = {}

Track = {
    file = "",
    level = 1,
    pan = 0,
    id = 0,
    mute = 1,
    waiting_for_samples = -1,
    samples = {}
}

function Track:buffer_render()
    callback_inactive = false
    softcut.buffer_clear_region_channel(1, (self.waiting_for_samples - 1)*60, 60, 0, 0)
    softcut.buffer_read_mono(self.file,(self.waiting_for_samples - 1)*60,(self.waiting_for_samples - 1)*60,60,1,1,0,self.level)
    softcut.event_render(function(_,_,_,samples)
        if not callback_inactive then
            if self.waiting_for_samples == 1 then
                self.samples = samples
            else
                for i = 1, 60*128 do
                    self.samples[#self.samples + 1] = samples[i]
                end
            end
            self.waiting_for_samples = self.waiting_for_samples == 5 and -1 or self.waiting_for_samples + 1
            callback_inactive = true
        end
    end)
    softcut.render_buffer(1,(self.waiting_for_samples -1)*60 ,(self.waiting_for_samples)*60,60*128)
end

function Track:new(file, level, pan, id)
    local t = setmetatable({}, { __index = Track })
    t.file = file
    t.level = level
    t.pan = pan
    t.id = id
    t.mute = 1
    t.waiting_for_samples = 1
    return t
end

scratch_track = Track:new("", 1, 0, -1)

local working_dir = _path.dust .. "code/waver/data/active"

function tracks.init()
    fn.dirty_scene(true)
    callback_inactive = true
    for i = 1, num_tracks do
        tracks[i] = Track:new(working_dir .. "/track_" .. i .. ".wav", 1, 0, i)
    end
    scratch_track.waiting_for_samples = 0
end

function tracks.save(file)
    if not file then
        return
    end
    local filenamebase = _path.dust .. "audio/tape/" .. file
    scene:song_view()
    softcut.buffer_write_stereo(filenamebase .. ".wav", 0, -1)
    for i,track in ipairs(tracks) do
        util.os_capture("cp " .. track.file .. " " .. filenamebase .. "_track_" .. i .. ".wav")
    end
    fn.dirty_scene(true)
end

function tracks.clear_all()
    softcut.buffer_read_mono(tracks[1].file,0,0,-1,1,1,0,0)
    for _,track in ipairs(tracks) do
        softcut.buffer_write_mono(track.file, 0, -1, 1)
        track.level = 1
        track.pan = 0
        track.samples = {}
    end
    fn.dirty_scene(true)
    fn.dirty_screen(true)
end

function scratch_track:load(file)
    if file == "cancel" then
        return
    end
    self.file = file
    self.waiting_for_samples = 1
    fn.dirty_screen(true)
    fn.dirty_scene(true)
end

function scratch_track:cut()
    if self.file == "" then return end
    softcut.buffer_read_mono(self.file,0,0,-1,1,2,0,self.level)
    softcut.buffer_write_mono(working_dir .. "/cut.wav",loop_start,loop_end - loop_start,2)
    self.file = ""
    self.samples = {}
    self.level = 1
    fn.dirty_scene(true)
    location = 0
end

function scratch_track:rec()
    self.file = working_dir .. "/rec.wav"
    softcut.buffer_write_mono(self.file,0,-1,2)
    self.samples = {}
    self.waiting_for_samples = 1
    fn.dirty_scene(true)
    fn.dirty_screen(true)
end

function scratch_track:paste()
    if not util.file_exists(working_dir .. "/cut.wav") then return end
    if self.file ~= "" then
        softcut.buffer_read_mono(self.file,0,0,-1,1,2,0,self.level)
    end
    softcut.buffer_read_mono(working_dir .. "/cut.wav",0,playhead,-1,1,2,1,self.level)
    softcut.buffer_write_mono(working_dir .. "/scratch.wav",0,-1,2)
    self.file = working_dir .. "/scratch.wav"
    self.waiting_for_samples = 1
    fn.dirty_scene(true)
end

function scratch_track:reset()
    self.file = ""
    self.level = 1
    self.pan = 0
    self.samples = {}
    self.waiting_for_samples = -1
    if util.file_exists(working_dir .. "/cut.wav") then
        util.os_capture("rm " .. working_dir .. "/cut.wav")
    end
    if util.file_exists(working_dir .. "/scratch.wav") then
        util.os_capture("rm " .. working_dir .. "/scratch.wav")
    end
    fn.dirty_scene(true)
end

function scratch_track:commit()
    local track = tracks[fn.active_track()]
    last_active = fn.active_track()
    last_level = track.level
    if util.file_exists(working_dir .. "/undo.wav") then
        util.os_capture("rm " .. working_dir .. "/undo.wav")
    end
    util.os_capture("cp " .. track.file .. " " .. working_dir .. "/undo.wav")
    softcut.buffer_read_mono(track.file,0,0,-1,1,1,0,track.level)
    softcut.buffer_read_mono(self.file,0,0,-1,1,1,1,self.level)
    softcut.buffer_write_mono(track.file,0,-1,1)
    track.waiting_for_samples = 1
    track.level = 1
end

function scratch_track:undo()
    fn.active_track(last_active)
    local track = tracks[fn.active_track()]
    track.level = last_level
    if util.file_exists(working_dir .. "/undo.wav") then
        util.os_capture("cp " .. working_dir .. "/undo.wav " .. track.file)
        track.waiting_for_samples = 1
    end
end


return tracks
