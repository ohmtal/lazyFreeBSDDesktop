#!/bin/sh
. ./_dialogs.sh
# ------------------------------------------------------------------------------
# INSTALLING wine i386 in /opt/user !
install_wine_i386()
{
    I386_ROOT="/opt/local/share/i386-wine-pkg"
    ABI_FILE=/usr/lib32/libc.so.7

    if [ ! -f $ABI_FILE ]; then
        result "install_wine_i386 \"$ABI_FILE\" not found; exiting."
        display_result "Wine i386"
        return
    fi

    if [ ! -d "$I386_ROOT/usr/share/keys/pkg" ]; then
        mkdir -p "$I386_ROOT/usr/share/keys"
        ln -s /usr/share/keys/pkg "$I386_ROOT/usr/share/keys/pkg"
    fi
    pkg -o ABI_FILE=$ABI_FILE -o INSTALL_AS_USER=false -o RUN_SCRIPTS=false --rootdir "$I386_ROOT" install -y  wine wine-proton mesa-dri
}
