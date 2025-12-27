#!/bin/sh

cd `dirname "$0"`
. ./_functions.sh
. ./_install_i386_wine.sh

# ------------------------------------------------------------------------------
_root_check
cp -r files/overlay/usr/* /usr/
cp -r files/overlay/opt /
install_wine_i386


