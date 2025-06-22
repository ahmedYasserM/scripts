#!/usr/bin/sh

choice=$(printf "Shutdown\nReboot\nSuspend" | dmenu -i)

case $choice in
    Shutdown) doas poweroff ;;
    Reboot) doas reboot ;;
    Suspend) doas zzz ;;
esac
