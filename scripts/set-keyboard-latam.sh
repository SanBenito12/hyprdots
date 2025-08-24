#!/usr/bin/env bash
set -euo pipefail

# Sets system keyboard layout to Latin American (latam) for X11 and console.
# Safe to run multiple times.

if ! command -v localectl >/dev/null 2>&1; then
  echo "Error: 'localectl' not found. Install systemd or run manually: sudo localectl ..." >&2
  exit 1
fi

CURRENT_X11_LAYOUT=$(localectl status 2>/dev/null | awk -F: '/X11 Layout/ {gsub(/^[ \t]+/, "", $2); print $2}')
CURRENT_VC_KEYMAP=$(localectl status 2>/dev/null | awk -F: '/VC Keymap/ {gsub(/^[ \t]+/, "", $2); print $2}')

NEED_X11=${CURRENT_X11_LAYOUT:-}!=latam
NEED_VC=${CURRENT_VC_KEYMAP:-}!=latam

echo "Requested system layout: latam"
echo "Current X11 Layout: ${CURRENT_X11_LAYOUT:-unknown}"
echo "Current VC Keymap: ${CURRENT_VC_KEYMAP:-unknown}"

set -x
sudo localectl set-x11-keymap latam
sudo localectl set-keymap latam
set +x

echo "Done. You may need to log out/in for all apps to adopt the system default."

