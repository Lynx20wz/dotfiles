local pipWidth = 700
local pipHeight = pipWidth / 1.7784


hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({

    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name              = "firefox-pip",
    match             = { class = "^firefox$", title = "^Picture-in-Picture$" },

    float             = true,
    pin               = true,
    size              = { pipWidth, pipHeight },
    move              = { "monitor_w-" .. pipWidth, "monitor_h-" .. pipHeight },
    keep_aspect_ratio = true,
})

hl.window_rule({
    name  = "audio window",
    match = { class = "org.pulseaudio.pavucontrol" },

    float = true,
    size  = { pipWidth, pipHeight },
    move  = { "monitor_w-" .. pipWidth, 30 },
})
