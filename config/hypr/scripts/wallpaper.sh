#!/bin/bash
set -euo pipefail

usage() {
  echo "Usage: $0 [--set <FILE> | --reload]" >&2
}

[ "${1-}" != "" ] || { usage; exit 1; }

expand_path() {
  local in="$1"
  # Expand leading ~ manually, then resolve relative paths
  if [[ "$in" == ~/* ]]; then
    in="$HOME/${in#~/}"
  fi
  if [[ "$in" != /* ]]; then
    in="$(realpath -m "$in")"
  fi
  echo "$in"
}

case "$1" in
  --set|-s)
    if [ "${2-}" = "" ]; then
      echo "Error: Missing file location for --set option." >&2
      usage; exit 1
    fi
    filepath="$(expand_path "$2")"
    if [ ! -f "$filepath" ]; then
      echo "Error: File not found: $filepath" >&2
      exit 1
    fi
    echo "Wallpaper set to $filepath."
    ln -sf "$filepath" "$HOME/.config/hypr/wallppr.png"
    # Save current wallpaper for persistence
    printf '%s' "$filepath" > "$HOME/.config/hypr/current_wallpaper"
    # Ensure daemon is running, then apply image
    if ! command -v swww >/dev/null 2>&1; then
      echo "Error: 'swww' no está instalado o no está en PATH." >&2
      echo "Instálalo (ej. Arch: sudo pacman -S swww) y reintenta." >&2
      exit 1
    fi
    # Evita conflictos si hyprpaper está activo
    if pgrep -x hyprpaper >/dev/null 2>&1; then
      echo "Detectado 'hyprpaper' en ejecución. Deteniéndolo para evitar conflictos con swww..."
      pkill -x hyprpaper || true
    fi
    # Proper swww daemon initialization
    if ! pgrep -x swww-daemon >/dev/null 2>&1; then
      swww init >/dev/null 2>&1 || (swww-daemon >/dev/null 2>&1 & disown; sleep 0.3)
      sleep 0.3  # Give daemon time to start
    fi
    # Verify daemon is working
    if ! swww query >/dev/null 2>&1; then
      echo "Error: swww daemon failed to start properly" >&2
      exit 1
    fi
    swww img "$filepath" --transition-fps 60 --transition-step 255 --transition-type any
    ;;
  --reload|-r)
    # Evita conflictos si hyprpaper está activo
    if pgrep -x hyprpaper >/dev/null 2>&1; then
      echo "Detectado 'hyprpaper' en ejecución. Deteniéndolo para evitar conflictos con swww..."
      pkill -x hyprpaper || true
    fi
    # Restart swww daemon properly
    pkill -x swww-daemon >/dev/null 2>&1 || true
    sleep 0.5
    swww init >/dev/null 2>&1 || (swww-daemon >/dev/null 2>&1 & disown; sleep 0.3)
    sleep 0.3
    
    # Restore wallpaper if available
    if [ -f "$HOME/.config/hypr/current_wallpaper" ]; then
      SAVED_WALLPAPER=$(cat "$HOME/.config/hypr/current_wallpaper")
      if [ -f "$SAVED_WALLPAPER" ]; then
        swww img "$SAVED_WALLPAPER" --transition-fps 60 --transition-step 255 --transition-type any
      fi
    fi
    
    eww reload >/dev/null 2>&1 || true
    echo "swww daemon reloaded and wallpaper restored."
    ;;
  *)
    echo "Invalid option: $1" >&2
    usage; exit 1
    ;;
esac
