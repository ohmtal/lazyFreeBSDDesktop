#!/bin/sh

# installDesktop
#
# a lite version of lazyFreeBSDDesktop.sh
# * graphic
# * DM
# * WM


cd `dirname "$0"`
. ./include/_functions.sh
. ./include/_dialogs.sh

PKGINSTALL="pkg install -y"


__greeting()
{
    result="\
Welcome.

This script will help you to install a FreeBSD desktop enviroment.

1.) First the freeBSD pkg update is called to make sure we are up to date.
2.) select your graphic driver
3.) select the display manager you want
4.) select the window manager(s) and a selection of packages you want


"

    confirm_result Welcome
}


__finished()
{

    result="\
We are done so far...

If you want to change the graphic you can call:
    sudo sh freeBSD_graphic_drivers.sh

If you want to change the display manager you can call:
    sudo sh freeBSD_DM_select.sh

If you want to add packages you did not install
so far or change the DM (greeter) you can call:
    sudo sh freeBSD_toms_packages.sh

    "

    display_result Finished

}

_update()
{
    printf "\t* update freeBSD packages\n"
    pkg update
    pkg upgrade
}

_packages()
{
    # 1. update your system
    _update

    # 2. select graphic driver
    sh freeBSD_graphic_drivers.sh
    _check_canceled

    # 3. basic package selection
    sh freeBSD_basic_packages.sh
    _check_canceled
}


_root_check
__greeting
_packages
__finished
