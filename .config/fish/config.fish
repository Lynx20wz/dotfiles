if status is-interactive
    # Commands to run in interactive sessions can go here
end

# == Aliases ==

# commands
alias clr="clear"
alias gcl="git clone"
alias fr="fvm flutter run"
alias frr="fvm flutter run --release"
alias ur="uv run ."
alias hypr-exit="hyprctl dispatch 'hl.dsp.exit()'"
alias venv="source ./.venv/bin/activate.fish"
alias ymd="yandex-music-downloader --token y0__wgBELL0t6ADGN74BiCRs4bPGFsQtJ70bhDua8EJu3-QDakMIs1F --skip-existing --embed-cover --quality 2 --path-pattern '#album-artist - #title'"
alias fonts-reload="fc-cache -fv"

# package manager
alias pac="sudo pacman -S"
alias pacs="sudo pacman -Ss"

alias yai="yay -S --needed --noconfirm"
alias yas="yay -Ss"
alias yau="yay -Suy --noconfirm"
alias yar="yay -Rns"
alias yarc="yay -Ycc"

# programs
alias zed="zeditor"
alias ff="fastfetch"
alias lg="lazygit"
alias rm="trash"
alias ls="lsd"
alias cat="bat"

# == Functions ==
function gaw -d "Get active window information with delay"
    sleep 1
    hyprctl activewindow
end

function hypr-reload -a program -d "Reload program with hyprctl"
    killall $program 2> /dev/null
    hyprctl eval "hl.exec_cmd(\"$program\")" > /dev/null
    echo "Reloaded $program"
end

function zd -a path -d "Find path using zoxide and open in file manager"
    set dir (zoxide query -- $path 2>/dev/null)
    if test $status -eq 0
        nohup dolphin "$dir" &>/dev/null & disown $last_pid
        exit
    end
end

set -g fish_greeting (uptime -p)
starship init fish | source
zoxide init fish | source

# Pi
fish_add_path "/home/lynx/.local/share/pi-node/node-v22.23.2-linux-x64/bin"
