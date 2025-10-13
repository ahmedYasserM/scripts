#!/bin/bash

IMAGE_DIR="$HOME/pictures/wallpapers"
CURRENT_BACKGROUND_LINK="$HOME/pictures/wallpapers/current"

mapfile -d '' -t IMAGES < <(find "$IMAGE_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -print0 | sort -z)

if [[ ${#IMAGES[@]} -eq 0 ]]; then
  notify-send "Wallpaper Script" "No images found in $IMAGE_DIR" -t 3000
  exit 1
fi

SELECTED_IMAGE=$(sxiv -t -o "${IMAGES[@]}")
if [[ -z "$SELECTED_IMAGE" ]]; then
  notify-send "Wallpaper Script" "Selection cancelled or no image marked. Exiting." -t 3000
  exit 0
fi

SELECTED_IMAGE=$(echo "$SELECTED_IMAGE" | xargs)
ln -nsf "$SELECTED_IMAGE" "$CURRENT_BACKGROUND_LINK"

pkill -x swaybg

setsid uwsm app -- swaybg -i "$CURRENT_BACKGROUND_LINK" -m fill >/dev/null 2>&1 &
notify-send "Wallpaper Set" "Background updated to:\n$(basename "$SELECTED_IMAGE")" -t 3000
