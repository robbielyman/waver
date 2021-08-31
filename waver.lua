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

function init()
    scene.init()
    num_tracks = 4
    tracks.init()
    fn.init()
    page.init()
    screen_dirty, scene_dirty = false, false
    active_track = 1
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
