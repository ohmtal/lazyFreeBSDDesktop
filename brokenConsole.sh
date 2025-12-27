#!/bin/sh
# ------------------------------------------------------------------------------
# console ttys unusable from X11 fix
# ------------------------------------------------------------------------------
cd `dirname "$0"`
. ./_functions.sh
. ./_dialogs.sh

_root_check

result="\
On one of my FreeBSD machines which run a Desktop
I have the problem that, when I switch from X11 to tty
console, it looks like an old 8 bit video game. Which
make the tty's unusable. This script will add:

    kern.vty=\"vt\"
    hw.vga.textmode=1

to /bool/loader.conf.

Note: if you have enabled boot_mute this will disable the
      image shown on screen.
"
confirm_result "tty fix"

_insert_to_loader kern.vty=\"vt\"
_insert_to_loader hw.vga.textmode=1

result=`cat /boot/loader.conf`
display_result "/boot/loader.conf"
