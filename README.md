# Kiri Shell

*霧 (pronounced きり, kee-ree) — mist/fog*

A frosted glass-themed utilitarian desktop shell built for Hyprland.

## Dependencies
User dependencies:
* Hyprland 0.57 (Lua config)
* Qt 6.12
* Quickshell 0.3.2

Additional dev dependencies:
* CMake
* Clang
* `qt6-shadertools`

## Installation

Clone the repo, and add [reload.sh](/reload.sh) to Hyprland's autostart:

```lua
hl.on("hyprland.start", function()
    hl.exec_cmd("/path/to/kiri/reload.sh")
end)
```

For the launcher, add a bind to the IPC call:

```lua
hl.bind("SUPER + R", hl.dsp.exec_cmd("/path/to/kiri/ipc.sh launcher open"))
```