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
        params:add_group("track " .. i,3)
        params:add_control("track_level_" .. i, "level", vol)
        params:set_action("track_level_" .. i, function(x)
            tracks[i].level = x
            local debounce = nil
            local temp = clock.run(function()
                if debounce then
                    clock.cancel(debounce)
                    debounce = nil
                end
                clock.sleep(0.5)
                fn.dirty_scene(true)
                fn.dirty_screen(true)
                print("calling dirty scene")
            end)
            debounce = temp
        end)
        params:add_control("track_pan_" .. i, "pan", controlspec.PAN)
        params:set_action("track_pan_" .. i, function(x)
            tracks[i].pan = x
            fn.dirty_scene(true)
            fn.dirty_screen(true)
        end)
        params:add_binary("track_mute_" .. i, "mute", "toggle", 0)
        params:set_action("track_mute_" .. i, function(x)
            tracks[i].mute = x == 0 and 1 or 0
            fn.dirty_scene(true)
            fn.dirty_screen(true)
        end)
    end
    params:add_control("scratch_level", "scratch track level", vol)
    params:set_action("scratch_level", function(x)
        scratch_track.level = x
        fn.dirty_scene(true)
        fn.dirty_screen(true)
    end)

    params:add_separator(" ! w a r n i n g ! ")

    params:add_trigger("clearall", "clear all tracks")
    params:set_action("clearall", function(_)
        tracks.clear_all()
    end)
end

return parameters
