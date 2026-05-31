$env.PROMPT_COMMAND = { || starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)' }

$env.config.show_banner = false
$env.config.buffer_editor = "zeditor"

# commands
alias gcl = git clone
alias clr = clear
alias fr = flutter run
alias hypr-exit = hyprctl dispatch exit
alias venv = overlay use ./.venv/bin/activate.nu
alias ymi = yandex-music-downloader --token y0__wgBELL0t6ADGN74BiCLq7uoFzCGyOWGCPGEwxdCeI_UfNk_BTX2gjhKI7ph --skip-existing --embed-cover --quality 2 --path-pattern "#album-artist - #title"
alias ts = trans :ru
alias grub-update = sudo grub-mkconfig -o /boot/grub/grub.cfg

# package manager
alias pac = sudo pacman -S
alias pacs = sudo pacman -Ss

alias yai = yay -S --needed --noconfirm
alias yas = yay -Ss
alias yau = yay -Suy --noconfirm
alias yar = yay -Rns
alias yarc = yay -Ycc

# programs
alias zed = zeditor
alias ff = fastfetch
alias lg = lazygit
alias rm = trash

# paths
alias conf! = cd ~/.config
alias df! = cd ~/documents/dotfiles
alias games! = cd /run/media/lynx20wz/games

alias prog! = cd ~/documents/programming
alias rust! = cd ~/documents/programming/rust
alias py! = cd ~/documents/programming/python
alias dart! = cd ~/documents/programming/dart

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

def hypr-exec [command: string] {
    ^hyprctl dispatch $command
}

def reload-waybar [] {
    ^killall waybar
    hyprctl dispatch hl.dsp.exec_cmd("waybar")
}

def exists [file] {
    if ($file | path exists) {
        echo $"✅ ($file) exists"
    } else {
        echo $"❌ ($file) doesn't exist"
    }
}

# [Hyprland] Get info about active window with delay
def gaw [delay: duration = 1sec]: nothing -> string {
    sleep $delay;
    hyprctl activewindow
}

# Move file/folder to dotfiles and create symlink
def mdf [
    source: path  # Source path
    --force (-f) = false # Force overwrite existing files
] {
    let source_path = ($source | path expand)

    if not ($source_path | path exists) {
        error make {
            msg: $"File/Directory does not exist!: ($source_path)"
        }
    }

    let home_config = ("~/.config" | path expand)
    let in_dot_config = ($source_path | str starts-with $home_config)

    let target_name = if $in_dot_config {
        let relative_to_config = ($source_path | str substring ($home_config | str length)..)
        $".config($relative_to_config)"
    } else {
        let item_name = ($source_path | path parse | get stem)
        let item_ext = ($source_path | path parse | get extension)
        if $item_ext != "" {
            $"($item_name).($item_ext)"
        } else {
            $item_name
        }
    }

    let real_dotfiles_dir = ("~/documents/dotfiles" | path expand)
    let target_path = ($real_dotfiles_dir | path join $target_name)

    let target_parent = ($target_path | path dirname)
    if not ($target_parent | path exists) {
        mkdir $target_parent
    }

    if ($target_path | path exists) and (not $force) {
        error make {
            msg: $"File already exists in dotfiles: ($target_name)"
            label: {
                text: "Use --force to overwrite"
                span: (metadata $source).span
            }
        }
    }

    if ($target_path | path exists) and $force {
        rm -rf $target_path
    }

    let dotfiles_symlink = ("~/.dotfiles" | path expand)

    if not ($dotfiles_symlink | path exists) {
        ln -s $real_dotfiles_dir ~/.dotfiles
    }

    mv $source_path $target_path
    ln -s ($dotfiles_symlink | path join $target_name) $source_path

    {
        original: $target_path
        symlink: $source_path
        name: $target_name
    }
}

def zed-ext [link: string, --force (-f)] {
    let target = $"($env.HOME)/.dotfiles/.config/zed/ext/"
    if ($target | path exists) and (not $force) {
        error make {
            msg: $"Directory already exists in ($target)"
            label: {
                text: "Use --force to overwrite"
                span: (metadata $link).span
            }
        }
    }

    if ($target | path exists) and $force {
        rm -rf $target
    }

    mkdir $target
    echo $target

    let tmp_file = (mktemp)
    curl -sL $"($link)/archive/refs/heads/main.zip" -o $tmp_file

    unzip -q $tmp_file -d $target

    rm $tmp_file

    echo $"✅ ($link | path parse | get stem) has been installed"
}

# check https://github.com/TheThingILearn/SDK-Emulator

# Flutter in zed with hot reload.
def fz [] {
    fvm flutter run --pid-file /tmp/flutter.pid;
    hotreload
}

def hotreload [] {
    let watch_dir = pwd
    ^find $watch_dir -type f | entr -r bash -c "kill -s 10 $(cat /tmp/flutter.pid)"
}

def adb-screen-off-timeout [timeout: int] {
    let timeout = $timeout * 1000
    adb shell settings put system screen_off_timeout
}

# Move a file or directory to a target, preserving the filename and creating a symlink in the original location.
def mvl [path: string, target: string] {
    let filename = ($path | path basename)
    let dest = if ($target | path type) == "dir" { ($target | path join $filename) } else { $target }

    mv $path $dest
    if $env.LAST_EXIT_CODE != 0 { return }

    ln -s ($dest | path expand) $path
}

def convert-m4a-to-ogg [path: string] {
    let path = ($path | path expand)

    if ($path | path type) == "dir" {
        ls $path | where type == "file" and ($it.name | str ends-with ".m4a") | each { |f|
            let f = ($f | path parse)
            let out = ($f.path | str replace -r '\.m4a$' '.ogg')
            ffmpeg -i $f.path -c:a libvorbis -q:a 6 -c:v libtheora -q:v 10 -map_metadata 0 $out -y
        }
    } else if ($path | path type) == "file" {
        let out = ($path | str replace -r '\.m4a$' '.ogg')
        ffmpeg -i $path -c:a libvorbis -q:a 6 -c:v libtheora -q:v 10 -map_metadata 0 $out -y
    } else {
        print $"(ansi red)Ошибка: '($path)' не является файлом или папкой"
    }
}


source ~/.local/share/nushell/scripts/custom-completions/git/git-completions.nu

source ~/documents/dotfiles/.config/nushell/zoxide.nu

uptime -p
