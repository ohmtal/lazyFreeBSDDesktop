#!/bin/sh


cd `dirname "$0"`
#include
. ./_functions.sh

clear
_root_check

echo "================================================================="
echo "Settings for my Lenovo IdeaPad S10-3"
echo "================================================================="

# intel graphics this rocks:
pkg install xf86-video-intel
sysrc kld_list+=i915kms

# sh thinkpad.sh

echo "Headphone fix did not work!"
# echo "\t setup headphone hack"
# _insert_to_loader \#\ Headphones\ S10-3
# _insert_to_loader hint.hdaa.0.nid33.config=\"as=1\ seq=15\"





