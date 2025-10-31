# Waybar Config Cycler (Omarchy + Hyprland)

A tiny script to cycle full Waybar configs stored in `~/.config/waybar/configs/`.  
Each folder inside `configs/` is treated as a full Waybar setup (includes scripts, icons, etc.). 

## Install (local)
### 1. Copy script:
```bash
mkdir -p ~/.local/bin
cp waybar-cycle-config.sh ~/.local/bin/
chmod +x ~/.local/bin/waybar-cycle-config.sh
```
### 2. Organize your configs:
```
~/.config/waybar/
├── config.jsonc
├── style.css
└── configs/
    ├── minimal/
    └── fancy/
```
### 3. Add keybind (Omarchy):
Add to ~/.config/hypr/bindings-custom.conf:
```
bindd = SUPER CTRL, RETURN, Cycle Waybar Config, exec, bash ~/.local/bin/waybar-cycle-config.sh
```
Then add source = ~/.config/hypr/bindings-custom.conf to ~/.config/hypr/hyprland.conf and hyprctl reload.

## Usage

Press Super + Ctrl + Enter to cycle to the next config.

## Notes

The script overwrites everything in ~/.config/waybar/ except configs/ and the internal tracker file.

Ensure notify-send is available (mako) if you want desktop notifications.
