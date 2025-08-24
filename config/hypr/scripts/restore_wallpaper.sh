#!/bin/bash
set -euo pipefail

# Script to restore the last set wallpaper
WALLPAPER_FILE="$HOME/.config/hypr/current_wallpaper"
DEFAULT_WALLPAPER="$HOME/.config/hypr/wallpapers/Lines.png"
SYMLINK_PATH="$HOME/.config/hypr/wallppr.png"

# Ensure swww is available and avoid conflicts with hyprpaper
if ! command -v swww >/dev/null 2>&1; then
  echo "Error: 'swww' no está instalado o no está en PATH." >&2
  exit 0
fi
if pgrep -x hyprpaper >/dev/null 2>&1; then
  echo "Detectado 'hyprpaper' en ejecución. Deteniéndolo para evitar conflictos con swww..."
  pkill -x hyprpaper || true
fi
pgrep -x swww-daemon >/dev/null 2>&1 || swww-daemon >/dev/null 2>&1 & disown

choose_and_apply() {
  local img="$1"
  ln -sf "$img" "$SYMLINK_PATH"
  printf '%s' "$img" > "$WALLPAPER_FILE"
  swww img "$img" --transition-fps 60 --transition-step 255 --transition-type any
}

# 1) Use saved wallpaper if present
if [ -f "$WALLPAPER_FILE" ]; then
  SAVED_WALLPAPER=$(cat "$WALLPAPER_FILE")
  if [ -f "$SAVED_WALLPAPER" ]; then
    echo "Restoring wallpaper: $SAVED_WALLPAPER"
    choose_and_apply "$SAVED_WALLPAPER"
    exit 0
  else
    echo "Saved wallpaper no longer exists: $SAVED_WALLPAPER"
  fi
fi

# 2) If symlink points to a valid file, use it
if [ -L "$SYMLINK_PATH" ]; then
  LINK_TARGET="$(readlink -f "$SYMLINK_PATH")"
  if [ -n "${LINK_TARGET}" ] && [ -f "$LINK_TARGET" ]; then
    echo "Restoring from symlink: $LINK_TARGET"
    choose_and_apply "$LINK_TARGET"
    exit 0
  fi
fi

# 3) Fallback to default wallpaper
echo "Using default wallpaper: $DEFAULT_WALLPAPER"
choose_and_apply "$DEFAULT_WALLPAPER"
