#!/bin/sh

cd `dirname "$0"`
#include
. ./_functions.sh

clear
_root_check

echo "================================================================="
echo "Settings for my Lenovo ThinkPad"
echo "================================================================="
wait_for_enter

echo "\t setup cpu temp"
sysrc kld_list+=coretemp

echo "\t setup powerd"
_insert_to_loader powerd_enable=\"YES\"
_insert_to_loader powerd_flags=\"-a\ adaptive\ -b\ adaptive\"

echo "\t setup screen brightness"
sysrc kld_list+=acpi_video
sysrc kld_list+=acpi_ibm
# Help about XFCE and backlight
echo "================================================================="
echo "Note: In Xfce Powermanager does not support a brightness panel !"
echo "You can configure but the keyboard shortcuts shout work:"
echo "backlight incr 5 and backlight decr 5"
wait_for_enter enteronly


# https://forums.freebsd.org/threads/bluetooth-audio-how-to-connect-and-use-bluetooth-headphones-on-freebsd.82671/
# echo "\t setup Bluetooth ... not working as expected so far..... FIXME"
# $PKGINSTALL iwmbt-firmware virtual_oss
# sysrc kld_list+=cuse

# FIXME WLAN ?!
