local mainMod      = "SUPER"
local terminal     = "alacritty"
local fileManager  = "dolphin"
local menu         = "wofi"
local editor       = "zeditor"
local browser      = "firefox"

local hyprshutdown = hl.bind(mainMod .. " + M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hyprshutdown:set_enabled(false)


hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen())

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "m-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Mine
hl.bind("ALT + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd(terminal .. " --command btop"))

-- open apps
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("AyuGram"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("obsidian"))

-- rofi
hl.bind("ALT + Space", hl.dsp.exec_cmd("/home/lynx20wz/.config/rofi/scripts/launcher_t1"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("/home/lynx20wz/.config/rofi/scripts/powermenu_t1"))
hl.bind("ALT + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"))

-- screenshot

-- local str =
-- 'nu -c "hyprshot -m %s -sz -o \'/run/media/lynx20wz/hard/pictures/Screenshots/\' -f (date now | format date \'%Y-%m-%d %H:%M:%S Hyprshot.png\')"'

-- hl.bind("ALT + SHIFT + S", hl.dsp.exec_cmd(str:format('%Y', "region")))
-- hl.bind("ALT + SHIFT + W", hl.dsp.exec_cmd(str:format('%q', "window")))
-- hl.bind("Print", hl.dsp.exec_cmd(str:format('%q', "output")))

hl.bind("ALT + SHIFT + S",
    hl.dsp.exec_cmd(
        'nu -c "hyprshot -z -m region -o /run/media/lynx20wz/hard/pictures/Screenshots/ -f (date now | format date \'%Y-%m-%d %H:%M:%S Hyprshot.png\')"'))
hl.bind("ALT + SHIFT + W",
    hl.dsp.exec_cmd(
        'nu -c "hyprshot -z -m window -o /run/media/lynx20wz/hard/pictures/Screenshots/ -f (date now | format date \'%Y-%m-%d %H:%M:%S Hyprshot.png\')"'))
hl.bind("Print",
    hl.dsp.exec_cmd(
        'nu -c "hyprshot -z -m output -o /run/media/lynx20wz/hard/pictures/Screenshots/ -f (date now | format date \'%Y-%m-%d %H:%M:%S Hyprshot.png\')"'))

-- stop music
hl.bind("CTRL + ALT + KP_Insert", hl.dsp.exec_cmd("playerctl play-pause"))

-- output change
hl.bind("CTRL + ALT + KP_End",
    hl.dsp.exec_cmd("pactl set-default-sink alsa_output.usb-MV-SILICON_fifine_AM8_Pro_20190808-00.analog-stereo"))
hl.bind("CTRL + ALT + KP_Down", hl.dsp.exec_cmd("pactl set-default-sink alsa_output.pci-0000_0f_00.6.analog-stereo"))

-- monitoring
hl.bind("CTRL + ALT + KP_Page_Down", hl.dsp.exec_cmd("~/.local/bin/monitoring-switch toggle"))
