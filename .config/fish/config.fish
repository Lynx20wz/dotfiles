if status is-interactive
    # Commands to run in interactive sessions can go here
end

# == Aliases ==

# commands
alias clr="clear"
alias gcl="git clone"
alias fr="fvm flutter run"
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

function hypr-reload -a program -d "Reload program with hyprctl"
    killall $program 2> /dev/null
    hyprctl eval "hl.exec_cmd(\"$program\")" > /dev/null
    echo "Reloaded $program"
end

set -g fish_greeting (uptime -p)
starship init fish | source
zoxide init fish | source

# Pi
fish_add_path "/home/lynx/.local/share/pi-node/node-v22.23.2-linux-x64/bin"
