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
    active_page = 0
    scene.init()
    num_tracks = 4
    track_length = 5*60
    tracks.init()
    fn.init()
    active_track = 1
    page.init()
    counters.init()
    redraw_clock_id = clock.run(counters.redraw_clock)
    keys = {0,0,0}
    print("init finished")
end

function enc(n,d)
    if n == 1 then
        window_center = util.clamp(window_center + (window_length*d/32),
            0.5*window_length,5*60-0.5*window_length)
        fn.dirty_screen(true)
    end
    if n == 2 and keys[1] == 0 then
        window_length = util.clamp(window_length - 0.1*window_length*d,1,5*60)
        window_center = util.clamp(window_center, 0.5*window_length, 5*60-0.5*window_length)
        fn.dirty_screen(true)
    end
    if n == 2 and keys[1] == 1 then
        loop_start = util.clamp(loop_start + (window_length*d/64), 0, loop_end)
        for i = 1, 2 do
            softcut.loop_start(i, loop_start)
        end
    end
    if n == 3 and keys[1] == 0 and active_page == 0 then
        fn.active_track(util.clamp(fn.active_track() + d,1,num_tracks))
        fn.dirty_screen(true)
    end
    if n == 3 and keys[1] == 0 and active_page == 1 then
        local track = tracks[fn.active_track()]
        track.pan = util.clamp(track.pan + d/25,-1,1)
        softcut.pan(1, track.pan)
        softcut.pan(2, track.pan)
        fn.dirty_screen(true)
    end
    if n == 3 and keys[1] == 1 then
        loop_end = util.clamp(loop_end + (window_length*d/64), loop_start, 5*60)
        for i = 1, 2 do
            softcut.loop_end(i, loop_end)
        end
    end
end

function key(n,z)
    keys[n] = z
    if n == 2 and z == 1 then
        fn.toggle_playback()
        fn.dirty_scene(true)
    end
    if n == 3 and z == 1 then
        if active_page == 0 then
            active_page = 1
            fn.dirty_scene(true)
            fn.dirty_screen(true)
        end
        if active_page == 1 and keys[1] == 1 then
            active_page = 0
            fn.dirty_scene(true)
            fn.dirty_screen(true)
        end
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
    softcut.poll_stop_phase()
    print("byyyyeeee")
end
