#!/bin/bash

MENU_OPTIONS="🖼️ Set Wallpaper
🔄 Restart
🛑 Poweroff
🌙 Sleep
📥 Install Web App
🗑️ Remove Web App
🌐 Setup Wifi"

# Use fuzzel in dmenu mode to get the user's selection
# Using echo instead of printf for simplicity, since fuzzel handles newline separators well.
SELECTION=$(echo -e "$MENU_OPTIONS" | fuzzel --dmenu)

# Define the script directory (using quotes for safety)
SCRIPT_DIR="$HOME/repos/scripts"

# Check if a selection was made
if [ -z "$SELECTION" ]; then
    exit 0
fi

case "$SELECTION" in
"🖼️ Set Wallpaper")
    "$SCRIPT_DIR/set-wallpaper.sh"
    ;;

"🔄 Restart")
    systemctl reboot
    ;;

"🛑 Poweroff")
    systemctl poweroff
    ;;

"🌙 Sleep")
    systemctl suspend
    ;;

"📥 Install Web App")
    "$SCRIPT_DIR/float-kitty.sh" "$SCRIPT_DIR/install-webapp.sh"
    ;;

"🗑️ Remove Web App")
    "$SCRIPT_DIR/float-kitty.sh" "$SCRIPT_DIR/remove-webapp.sh"
    ;;
"🌐 Setup Wifi")
    kitty impala
    ;;
*)
    # Default exit case if fuzzel is cancelled or an unlisted option is chosen
    exit 0
    ;;
esac
