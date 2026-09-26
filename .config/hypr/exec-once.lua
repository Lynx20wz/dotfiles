hl.on("hyprland.start", function()
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("dunst & hyprpaper & waybar & tg-ws-proxy")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    hl.exec_cmd("obsidian & super-productivity")
    hl.exec_cmd("AyuGram & vesktop & firefox")
    hl.exec_cmd("yandex-music")
end)

-- hl.workspace_rule({ workspace = "9", on_created_empty = "AyuGram & vesktop & firefox" })
