#!/usr/bin/env bash
# Cycles through Waybar configs in ~/.config/waybar/configs/
# Deletes existing Waybar files (except the configs/ folder itself)
# Then copies everything from the next config folder into ~/.config/waybar/

WAYBAR_DIR="$HOME/.config/waybar"
CONFIGS_DIR="$WAYBAR_DIR/configs"
CURRENT_FILE="$WAYBAR_DIR/current_config.txt"

# get available config folders
mapfile -t configs < <(find "$CONFIGS_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)

if [ ${#configs[@]} -eq 0 ]; then
    echo "No configs found in $CONFIGS_DIR"
    exit 1
fi

# read current
if [ -f "$CURRENT_FILE" ]; then
    current=$(cat "$CURRENT_FILE")
else
    current=""
fi

# find index of current config
index=-1
for i in "${!configs[@]}"; do
    if [[ "${configs[$i]}" == "$current" ]]; then
        index=$i
        break
    fi
done

# pick next config cyclically
next_index=$(( (index + 1) % ${#configs[@]} ))
next="${configs[$next_index]}"
next_path="$CONFIGS_DIR/$next"

echo "Switching to: $next"

# ensure we're not deleting the configs folder itself
find "$WAYBAR_DIR" -mindepth 1 -maxdepth 1 ! -name "configs" ! -name "$(basename "$CURRENT_FILE")" -exec rm -rf {} +

# copy entire contents of next config into main waybar folder
cp -r "$next_path"/* "$WAYBAR_DIR/"

# update tracker
echo "$next" > "$CURRENT_FILE"

# restart waybar
pkill waybar 2>/dev/null || true
nohup waybar >/dev/null 2>&1 &

# optional desktop notification
if command -v notify-send &>/dev/null; then
    notify-send "Waybar" "Switched to config: $next"
fi

echo "Switched to Waybar config: $next"
