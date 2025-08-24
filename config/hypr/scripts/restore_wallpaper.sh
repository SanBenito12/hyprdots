#!/bin/bash

# Script to restore the last set wallpaper
WALLPAPER_FILE="$HOME/.config/hypr/current_wallpaper"
DEFAULT_WALLPAPER="$HOME/.config/hypr/wallpapers/Lines.png"
SYMLINK_PATH="$HOME/.config/hypr/wallppr.png"

# Check if we have a saved wallpaper
if [ -f "$WALLPAPER_FILE" ]; then
    SAVED_WALLPAPER=$(cat "$WALLPAPER_FILE")
    
    # Check if the saved wallpaper file still exists
    if [ -f "$SAVED_WALLPAPER" ]; then
        echo "Restoring wallpaper: $SAVED_WALLPAPER"
        ln -sf "$SAVED_WALLPAPER" "$SYMLINK_PATH"
        swww img "$SAVED_WALLPAPER" --transition-fps 60 --transition-step 255 --transition-type any
        exit 0
    else
        echo "Saved wallpaper no longer exists: $SAVED_WALLPAPER"
    fi
fi

# Fallback to default wallpaper
echo "Using default wallpaper: $DEFAULT_WALLPAPER"
ln -sf "$DEFAULT_WALLPAPER" "$SYMLINK_PATH"
echo "$DEFAULT_WALLPAPER" > "$WALLPAPER_FILE"
swww img "$DEFAULT_WALLPAPER" --transition-fps 60 --transition-step 255 --transition-type any