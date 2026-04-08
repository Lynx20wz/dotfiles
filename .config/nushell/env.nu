$env.PYO3_USE_ABI3_FORWARD_COMPATIBILITY = 1
$env.EDITOR = "nvim"
$env.ANDROID_HOME = "~/.local/lib/android-sdk/"
$env.OLLAMA_MODELS = "/run/media/lynx20wz/hard/ollama/"
$env.ANDROID_AVD_HOME = "/run/media/lynx20wz/hard/avds/"
$env.PATH ++= [
    ~/fvm/default/bin,
    ~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin,
    ~/.local/bin,
    ~/.local/lib/android-sdk/cmdline-tools/latest/bin/,
    ~/.local/lib/android-sdk/emulator/
    ~/.cargo/bin/
]
zoxide init nushell | save -f /run/media/lynx20wz/Lynx20wz/documents/dotfiles/.config/nushell/zoxide.nu
