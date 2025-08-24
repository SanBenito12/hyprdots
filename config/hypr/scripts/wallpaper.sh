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
    pgrep -x swww-daemon >/dev/null 2>&1 || swww-daemon >/dev/null 2>&1 & disown
    swww img "$filepath" --transition-fps 60 --transition-step 255 --transition-type any
    ;;
  --reload|-r)
    pkill -x swww-daemon >/dev/null 2>&1 || true
    sleep 0.5
    swww-daemon >/dev/null 2>&1 & disown
    eww reload >/dev/null 2>&1 || true
    echo "swww daemon and Eww reloaded."
    ;;
  *)
    echo "Invalid option: $1" >&2
    usage; exit 1
    ;;
esac
