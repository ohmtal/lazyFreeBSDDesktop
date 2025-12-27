#!/bin/sh

# LazyFreeBSDDesktop
# Tested with 14.3
# @since 2025-09-??
# @author XXTH
# TODO:   rewrite to select all options then create a custom shell
#         script which does all the install and modification stuff without
#         user user interaction
#         FIXME =>  if [ "$lazyInstall" == "YES" ]; then
# TODO:   Select what is done in one gui, like
#         cur repos, fasterboot, propare user, prepare opt, update check
#
#
# 15-STABLE (2025-11-19)
#       xfce dbus problems (cant remember error message) ... maybe virtualbox ?




cd `dirname "$0"`
. ./_functions.sh
. ./_dialogs.sh
#. ./freeBSD_current.sh
. ./freeBSD_musthave.sh
. ./freeBSD_prepare_user.sh
. ./freeBSD_updatecheck.sh
. ./freeBSD_fasterboot.sh

PKGINSTALL="pkg install -y"


lazy_greeting()
{
# * I'll change the Repo to current. I like this more than the quaterly chaos.
#   if you want to reset this type: echo "" > /usr/local/etc/pkg/repos/FreeBSD.conf

    result="\
Welcome to $BACKTITLE

This script will help you to setup your FreeBSD Desktop.

* DBUS and FUSEFS will be added
* FreeBSD faster boot tweaks in /etc/rc.conf and /boot/loader.conf
* Graphic driver selection
* Package selection and install
* Install update checker
* Prepare new user with a xfce4 templates

!! W A R N I N G !! Use at your own risk!
"

    confirm_result Welcome
}


lazy_finished()
{

    result="\
We are done so far...

If you want to change the graphic you can call:
    ./freeBSD_graphic_drivers.sh

If you want to add packages you did not install
so far or change the DM (greeter) you can call:
    freeBSD_toms_packages.sh

    "

    display_result Finished

}


_boot_delay()
{
    printf "\t* changing boot delay to 2 sec.\n"
    _insert_to_loader  autoboot_delay=\"2\"
}


_update()
{
    printf "\t* update freeBSD packages\n"
    pkg update
    pkg upgrade
}

_packages()
{
    # --- set up current repos or simply update
#     set_current_repos
#     if [ $exit_status -ne 0 ]; then
#         _update
#     fi
    _update

    # calling must have sudo, polkit automount, dbus and fusefs
    must_have

    # manually select graphic driver
    sh freeBSD_graphic_drivers.sh
    _check_canceled


    result="xfce4 toms"
    menu_result "Select package list"
    sh freeBSD_"$selection"_packages.sh
    _check_canceled
}


_root_check
lazy_greeting
# we want to boot faster
_fasterboot
_packages
# add skel and opt files:
sh _freeBSDPrepareOPT.sh
pu_select_user
# add update check ?!
updateCheckWelcome
lazy_finished
