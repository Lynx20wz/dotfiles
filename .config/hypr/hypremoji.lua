hl.bind("SUPER + period", hl.dsp.exec_cmd("hypremoji"))

hl.window_rule( {
    name = "hypremoji",
    match = {title = "^HyprEmoji$"},

    float = true,
    move = {"(cursor_x-(window_w*0.1))", "(cursor_y-(window_h*0.09))"}
})
