$env.PYO3_USE_ABI3_FORWARD_COMPATIBILITY = 1
$env.EDITOR = "nvim"
$env.ANDROID_HOME = "~/.local/lib/android-sdk/"
$env.PATH ++= [
    ~/fvm/default/bin,
    ~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin,
    ~/.local/bin,
    ~/.local/lib/android-sdk/cmdline-tools/latest/bin/,
    ~/.local/lib/android-sdk/emulator/
]
