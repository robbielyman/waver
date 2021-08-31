scene = { state = "normal" }

require("math")

function scene.init()
    softcut.reset()
    softcut.buffer_clear()
    audio.level_cut(1)
    for i = 1, 2 do
        softcut.level(i, 1)
        softcut.play(i, 0)
        softcut.rate(i, 1)
        softcut.loop_start(i, 0)
        softcut.loop_end(i, 30)
        softcut.loop(i, 1)
        softcut.fade_time(i, 0.02)
        softcut.level_slew_time(i, 0.01)
        softcut.rate_slew_time(i, 0.01)
        softcut.rec_level(i, 0)
        softcut.pre_level(i, 1)
        softcut.position(i, 0)
        softcut.buffer(i, i)
        softcut.enable(i, 1)
    end
    for i = 3, 6 do
        softcut.enable(i, 0)
    end
end

function scene:render()
    softcut.buffer_clear()
    for i = 1, num_tracks do
        local theta = math.pi/4 * (tracks[i].pan + 1)
        softcut.buffer_read_mono(tracks[i].file, 0, 0, -1, 1, 1, 1,
            tracks[i].level*math.cos(theta))
        softcut.buffer_read_mono(tracks[i].file, 0, 0, -1, 1, 2, 1,
            tracks[i].level*math.sin(theta))
    end
    softcut.pan(1,-1)
    softcut.pan(2,1)
    softcut.play(1,1)
    softcut.play(2,1)
    fn.dirty_scene(false)
end

return scene
