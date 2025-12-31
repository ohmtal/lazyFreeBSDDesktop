#!/bin/sh

cd `dirname "$0"`
#include
. ../include/_functions.sh

clear
_root_check

echo "================================================================="
echo "Settings for Lenovo ThinkPad x260"
echo "================================================================="


sh thinkpad.sh

echo "\t setup headphone hack"
_insert_to_loader \#\ Headphones\ x260
_insert_to_loader hint.hdaa.0.nid21.config=\"as=1\ seq=15\"

