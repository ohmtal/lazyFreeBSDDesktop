#!/bin/sh
# ------------------------------------------------------------------------------
# FreeBSD Steam
#  W A R N I G !!!!! IMSECURE SHIT => user steam pass steam !!!!!!!
# @author XXTH
# @since 2025-11-20
# ------------------------------------------------------------------------------
# 1. enable linux
# 2. install linux-steam-utils
# 3. create user: steamuser
# 3.1 su steamuser -c ""

# Steam client:
# --
# Please note, this is an unofficial wrapper for the Steam client
# and as such it is supported on a best effort basis.
#
# Limitations:
#
# - Sandbox is disabled for the web browser component.
# - No controller input, no streaming, no VR.
# - Valve Anti-Cheat is untested.
# - Steam's container runtime (pressure-vessel) doesn't work.
#
# Additional dependencies:
# - If you use an NVIDIA card, you need to install a suitable
#   x11/linux-nvidia-libs(-xxx) port.
#
# Steam setup:
#
# 1. Set security.bsd.unprivileged_chroot and vfs.usermount sysctls to 1.
# 2. Add nullfs to kld_list, load it.
# 3. Create a dedicated FreeBSD non-wheel user account for Steam. Switch to it.
# 4. Run `/usr/local/steam-utils/bin/lsu-bootstrap` to download the Steam bootstrap executable.
# 5. Run `steam` to download updates and start Steam.
#
# For the list of tested Linux games see https://github.com/shkhln/linuxulator-steam-utils/wiki/Compatibility.
#
# Native Proton setup (optional, semi-experimental):
#
# 1. Run `sudo pkg install wine-proton libc6-shim python3`.
# 2. Run `/usr/local/wine-proton/bin/pkg32.sh install wine-proton mesa-dri`.
# 3. In Steam install the matching Proton version (appid 2348590 for 8.0, 2805730 for 9.0, etc).
#
# To enable it right click a game title in Steam, click Properties,
# click Compatibility, select "FreeBSD Wine (emulators/wine-proton)".
# ------------------------------------------------------------------------------
steam_user="steam"
steam_pass="steam"
steam_autologin=0
# ------------------------------------------------------------------------------
cd `dirname "$0"`
. ./include/_functions.sh
. ./include/_dialogs.sh
. ./freeBSD_prepare_user.sh
# ------------------------------------------------------------------------------
stream_greeting()
{
    result=\
"\
 *** Warning ***

 This script is experimental and will modifiy the system:

 * Load  linux and nullfs kernel modules
 * Set security.bsd.unprivileged_chroot and vfs.usermount sysctls to 1.
 * Add a insecure but non wheel user $steam_user with password $steam_pass

Notes:
* if you have not installed an Desktop with Xfce4 so far call
  freeBSD_xfce4_packages.sh or lazyFreeBSDDesktop.sh first!

* The $steam_user user have to be be used to run Steam.

 >>> Do you want to continue ? <<<
"
    messageboxYesNO "FreeBSD Steam installer"
    if [ $exit_status -eq 0 ] ; then
        _steam
        _steamuser
    fi
}
# ------------------------------------------------------------------------------
pu_copy_dot_steam()
{
  dot_config_dir="/home/$pu_user/.config"
  su $pu_user -c "mkdir $dot_config_dir"
  su $pu_user -c "cp -r files/steam/dot.config/* $dot_config_dir/"

  dot_local_dir="/home/$pu_user/.local"
  su $pu_user -c "mkdir $dot_local_dir"
  su $pu_user -c "cp -r files/steam/dot.local/* $dot_local_dir/"

  desktop_dir="/home/$pu_user/Desktop"
  su $pu_user -c "mkdir $desktop_dir"
  su $pu_user -c "cp -r files/steam/Desktop/* $desktop_dir/"
}

# ------------------------------------------------------------------------------
# steam user with autologin
# !!!!!!!!!! COMPLETLY INSECURE !!!!!!!!!!!!!!!
_steamuser()
{
    pw useradd $steam_user -c "Steam" -d /home/$steam_user -G video -m
    echo "$steam_pass" | pw usermod $steam_user -h 0
    # done by -G :: pw usermod $steam_user -G video
    # done by -m :: mkdir /home/$steam_user


    #EXTRA dot.config for steam !!
    pu_user=$steam_user
    pu_copy_dot_steam
    pu_setup_wine_386 force

    #FIXME pkg: Insufficient privileges to install packages
    # su $steam_user -c "/usr/local/wine-proton/bin/pkg32.sh install wine-proton mesa-dri"

    # 4. Run `/usr/local/steam-utils/bin/lsu-bootstrap` to download the Steam bootstrap executable.
    su $steam_user -c "/usr/local/steam-utils/bin/lsu-bootstrap"



    if [ $steam_autologin -eq 1 ]; then
        # FIXME add autologin ?? i guess it's not worth
        # test do i need this ?!
        # pw groupadd autologin
        # pw usermod $steam_user -G autologin

        # *** this require lightdm !!****
        # /usr/local/etc/lightdm/lightdm.conf
        # [Seat:*]
        # autologin-user=$steam_user
        # autologin-user-timeout=0
        # autologin-session=xfce

        #/usr/local/etc/pam.d/lightdm-autologin
        # auth      required pam_succeed_if.so shell notin /sbin/nologin:/usr/sbin/nologin
    fi
}
# ------------------------------------------------------------------------------
# lookup if and which version of nvidia-driver-XXX is installed
# and if found install the linux libs of it
_install_linux_nvidia()
{
    lList="340 390 470 580"
    lInstalledPackages=$( pkg info )
    for d in $lList; do
        lFound=$( pkg info  | grep "nvidia-driver-$d" )
        if [ "$lFound" != "" ]; then
            $PKGINSTALL linux-nvidia-libs-$d
        fi
    done
}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
_steam()
{
 _rc_conf linux_enable="YES"
 kldload linux
 kldload linux64
 service linux start
 $PKGINSTALL linux-steam-utils
 $PKGINSTALL wine
 $PKGINSTALL dosbox
 $PKGINSTALL wine-proton
 $PKGINSTALL libc6-shim
 $PKGINSTALL python3
 _install_linux_nvidia

 # 1. Set security.bsd.unprivileged_chroot and vfs.usermount sysctls to 1.
 _insert_to_sysctl "# steam"
 _insert_to_sysctl security.bsd.unprivileged_chroot=1
 _insert_to_sysctl vfs.usermount=1
 sysctl security.bsd.unprivileged_chroot=1
 sysctl vfs.usermount=1

 # 2. Add nullfs to kld_list, load it.
 sysrc kld_list+=nullfs
 kldload nullfs

}
# ------------------------------------------------------------------------------

# only called if standalone and not included
if [ `basename $0` == "freeBSD_steam.sh" ]
then
  _root_check
  stream_greeting

fi
