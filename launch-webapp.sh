#!/bin/bash

browser=$(xdg-settings get default-web-browser)

exec setsid uwsm app -- $(sed -n 's/^Exec=\([^ ]*\).*/\1/p' {~/.local,~/.nix-profile,/usr}/share/applications/$browser 2>/dev/null | head -1) $1 "${@:2}"
