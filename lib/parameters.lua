parameters = {}

function parameters.init()
    params:add_separator(" ~ w a v e r ~ ")

    params:add_trigger("save", "save track")
    params:set_action("save", function(_)
        textentry.enter(tracks.save, "song", "filename")
    end)

    params:add {
        type = "number",
        id   = "tempo",
        name = "tempo",
        min  = 20,
        max  = 400,
        default = 120,
        action = function(_) fn.dirty_screen(true) end,
    }

    params:add {
        type = "number",
        id   = "beats",
        name = "beats per bar",
        min  = 1,
        max  = 16,
        default = 4,
        action = function(_) fn.dirty_screen(true) end,
    }

    local vol = controlspec.new(0, 1.25, "lin", 0, 1)
    for i = 1,num_tracks do
        params:add_control("track" .. i .. "vol", "track " .. i .. " volume", vol)
        params:set_action("track" .. i .. "vol", function(x)
            tracks[i].level = x
            fn.dirty_scene(true)
            fn.dirty_screen(true)
        end)
        params:add_control("track" .. i .. "pan", "track " .. i .. " pan", controlspec.PAN)
        params:set_action("track" .. i .. "pan", function(x)
            tracks[i].pan = x
            fn.dirty_scene(true)
            fn.dirty_screen(true)
        end)
        params:add_binary("track" .. i .."mute", "track " .. i .. " mute", "toggle", 0)
        params:set_action("track" .. i .. "mute", function(x) 
            tracks[i].mute = x == 0 and 1 or 0 
            fn.dirty_scene(true)
            fn.dirty_screen(true)
        end)
    end

    params:add_separator(" ! w a r n i n g ! ")

    params:add_trigger("clearall", "clear all tracks")
    params:set_action("clearall", function(_)
        tracks.clear_all()
    end)
end

return parameters
