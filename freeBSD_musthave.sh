#!/bin/sh
cd `dirname "$0"`
. ./_functions.sh
. ./_dialogs.sh
# ------------------------------------------------------------------------------
_usermount()
{
  # allow usermount
  _insert_to_sysctl vfs.usermount=1
  # usermount in freedesktop pollkit
  polpath=/usr/local/etc/polkit-1/rules.d/
  mkdir -p $polpath
  cp ./files/10-mount.rules $polpath
}
# ------------------------------------------------------------------------------
# MUST HAVE :P
# we want dbus for X11 and fusefs for automount
must_have()
{
  $PKGINSTALL xorg
  sysrc dbus_enable="YES"
  $PKGINSTALL fusefs-exfat fusefs-sshfs
  sysrc kld_list+=fusefs

  _usermount
  _sudo

}
_sudo()
{
    # printf "\t* install sudo and enable wheel and usefull stuff for sudo\n"
    $PKGINSTALL sudo
    SUDOERS_FILE="/usr/local/etc/sudoers.d/tom-sudoers"
    echo "Defaults shell_noargs, set_home, path_info, root_sudo, ignore_dot" > $SUDOERS_FILE
    echo "%wheel ALL=(ALL:ALL) ALL" >> $SUDOERS_FILE
}
# ------------------------------------------------------------------------------
musthaveWelcome()
{
  result="\
Some \"must have\" and more settings
  * DBUS and FUSEFS will be added
  * Polkit rule for user mount
  * Install sudo, allow wheel and set to noargs
"
  confirm_result Summery
}
# ------------------------------------------------------------------------------

# only called if standalone and not included
if [ `basename $0` == "freeBSD_musthave.sh" ]
then
  _root_check
  musthaveWelcome
  must_have
fi

