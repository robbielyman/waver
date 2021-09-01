scene = {} 

require("math")

function scene.init()
    softcut.reset()
    softcut.buffer_clear()
    audio.level_cut(1)
    for i = 1, 2 do
        softcut.enable(i, 1)
        softcut.level(i, 1)
        softcut.play(i, 0)
        softcut.rec(i,0)
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
    end
    for i = 3, 6 do
        softcut.enable(i, 0)
    end
    is_playing = false
end

function scene:render()
    if is_playing == true then  
        softcut.buffer_clear()
        for _, track in ipairs(tracks) do   
            local theta = math.pi/4 * (track.pan + 1)
            local left = track.level * math.cos(theta)
            local right = track.level * math.sin(theta)
            softcut.buffer_read_mono(track.file, 0, 0, 30, 1, 1, 1, left)
            softcut.buffer_read_mono(track.file, 0, 0, 30, 1, 2, 1, right)
        end
        softcut.pan(1,-1)
        softcut.pan(2,1)
    end
    softcut.play(1,is_playing and 1 or 0)
    softcut.play(2,is_playing and 1 or 0)
    fn.dirty_scene(false)
end

return scene
