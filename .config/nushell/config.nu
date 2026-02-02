$env.PROMPT_COMMAND = { || starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)' }

$env.config.show_banner = false
$env.config.buffer_editor = "zeditor"

# commands
alias gcl = git clone
alias clr = clear
alias hypr-exec = hyprctl dispatch exec

# package manager
alias pac = sudo pacman -S
alias pacs = sudo pacman -Ss

alias yai = yay -S --needed --noconfirm
alias yas = yay -Ss
alias yau = yay -Suy --noconfirm
alias yar = yay -Rns

# programs
alias zed = zeditor
alias ff = fastfetch
alias rgit = relagit

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

source ~/.local/share/nushell/scripts/custom-completions/git/git-completions.nu

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
