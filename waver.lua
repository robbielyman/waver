-- waver
--
-- assemble tracks from TAPE
-- into a song.
--
-- @alanza
-- v0.1

-- TODO: comment these before pushing!
-- softcut = {}
-- screen = {}
-- audio = {}
-- util = {}
-- metro = {}
-- include = require
-- clock = {}

include("waver/lib/includes")

function init()
    loop_start = 0
    loop_end = 30
    scene.init()
    num_tracks = 4
    track_length = 5*60
    tracks.init()
    fn.init()
    active_track = 1
    page.init()
    counters.init()
    redraw_clock_id = clock.run(counters.redraw_clock)
    keys = {}
    print("init finished")
end

function enc(n,d)
    if n == 1 then
        window_center = util.clamp(window_center + (window_length*d/32),
            0.5*window_length,5*60-0.5*window_length)
        fn.dirty_screen(true)
    end
    if n == 2 and keys[1] == 0 then
        window_length = util.clamp(window_length - 0.1*window_length*d,5,5*60)
        window_center = util.clamp(window_center, 0.5*window_length, 5*60-0.5*window_length)
        fn.dirty_screen(true)
    end
    if n == 2 and keys[1] == 1 then
        loop_start = util.clamp(loop_start + (window_length*d/32), 0, loop_end)
    end
    if n == 3 and keys[1] == 0 then  
        fn.active_track(util.clamp(fn.active_track() + d,1,num_tracks))
        fn.dirty_screen(true)
    end
    if n == 3 and keys[1] == 1 then
        loop_end = util.clamp(loop_end + (window_length*d/32), loop_start, 5*60)
    end
end

function key(n,z)
    keys[n] = z
    if n == 2 and z == 1 then
        fn.toggle_playback()
        fn.dirty_scene(true)
    end
    fn.dirty_screen(true)
end

function redraw()
    if not fn.dirty_screen() then return end
    page:render()
    fn.dirty_screen(false)
end

function redraw_scene()
    if not fn.dirty_scene() then return end
    scene:render()
    fn.dirty_scene(false)
end

function cleanup()
    clock.cancel(redraw_clock_id)
    metro.free_all()
    print("byyyyeeee")
end
