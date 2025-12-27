#!/bin/sh

cd `dirname "$0"`
. ./_functions.sh
. ./_dialogs.sh


_fasterboot()
{
    result="\
Welcome to FreeBSD faster boot tweaks

Some settings for a faster boot:

/boot/loader.conf:
------------------
boot_mute="YES"
autoboot_delay="-1"
beastie_disable="YES"
hw.usb.no_boot_wait=1


/etc/rc.conf:
-------------
rc_startmsgs="NO"
background_dhclient="YES"
"

messageboxYesNO "Set faster boot options?"
if [ $exit_status -eq 0 ]
then
  _apply_faster_boot
fi
}

_apply_faster_boot()
{
    # boot loader
    _loader_conf boot_mute="YES"
    _loader_conf autoboot_delay="-1"
    _loader_conf beastie_disable="YES"
    _insert_to_loader hw.usb.no_boot_wait=1

    # rc.conf
    _rc_conf rc_startmsgs="NO"
    _rc_conf background_dhclient="YES"
}

# only called if standalone and not included
if [ `basename $0` == "freeBSD_fasterboot.sh" ]
then
    _root_check
    _fasterboot
fi

