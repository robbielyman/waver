-- waver
--
-- assemble tracks from TAPE
-- into a song.
--
-- @alanza
-- v0.1

-- TODO: remove these before pushing!
-- softcut = {}
-- screen = {}
-- audio = {}
-- util = {}
-- include = require

include("waver/lib/includes")

function redraw()
    if not fn.dirty_screen() then return end
    page:render()
    fn.dirty_screen(false)
end

function redraw_scene()
    if not fn.dirty_scene() then return end
    scene:render()
    fn.dirty_scene(false)
    print("redrawing scene")
end

function init()
    scene.init()
    num_tracks = 4
    tracks.init()
    fn.init()
    active_track = 1
    page.init()
    counters.init()
    fn.dirty_screen(true)
    fn.dirty_scene(true)
    redraw()
    redraw_scene()
    print("init finished")
end

function enc(n,d)
    if n == 2 then  
        fn.active_track(util.clamp(fn.active_track() + d,1,num_tracks))
        fn.dirty_screen(true)
    end 
end

function key(n,z)
    if n == 2 then
        fn.toggle_playback()
        fn.dirty_scene(true)
    end
end
