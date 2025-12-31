#!/bin/sh

cd `dirname "$0"`
#include
. ../include/_functions.sh

clear
_root_check

echo "================================================================="
echo "Settings for my Lenovo ThinkPad e531"
echo "================================================================="

sh thinkpad.sh

echo "\t setup headphone hack"
_insert_to_loader \#\ Headphones\ e531
_insert_to_loader hint.hdaa.0.nid25.config=\"as=1\ seq=15\"





