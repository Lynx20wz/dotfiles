hl.on("hyprland.start", function()
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("dunst & hyprpaper & waybar & tg-ws-proxy")
    hl.exec_cmd("yandex-music", { workspace = "10" })
    hl.exec_cmd("AyuGram & vesktop & firefox", { workspace = "9" })
end)

-- hl.workspace_rule({ workspace = "9", on_created_empty = "AyuGram & vesktop & firefox" })
