#!/bin/sh
# ------------------------------------------------------------------------------
# Version 0.251106
# Special for xfce4 setup with lightdm and xfce4 skeleton
# FIXME skeleton is too late, user is usually added in bsdinstall
# ------------------------------------------------------------------------------
musthave="xorg sudo"
basic="mc bash btop smartmontools links wget screen"
fusefsExtras="fusefs-afuse fusefs-ext2 fusefs-lkl fusefs-ntfs fusefs-smbnetfs fusefs-sshfs fusefs-ufs"
windos="wine wine-proton dosbox"
graphic="krita gimp ristretto"
multimedia="mplayer ffmpeg dsbmixer"
extras="plank zenity xarchiver"
kate="kate"
internet="firefox thunderbird"
games="gnome-mahjongg quadrapassel"
xfce="xfce xfce4-whiskermenu-plugin xfce4-pulseaudio-plugin xfce4-goodies"
lightdm="lightdm lightdm-gtk-greeter"

cd `dirname "$0"`
. ./_functions.sh
. ./_dialogs.sh
# . ./freeBSD_current.sh
. ./freeBSD_musthave.sh
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
select_packages()
{
  HEIGHT=25
  WIDTH=78


  exec 3>&1
  selection=$($DIALOG \
    --backtitle "$BACKTITLE" \
    --title "Xfce4 Packages" \
    --clear \
    --cancel-label "Cancel" \
    --checklist "Please additional select:" $HEIGHT $WIDTH 20 \
        basic "$basic" on\
        fusefsExtras "$fusefsExtras" off\
        windos "$windos" off\
        graphic "$graphic" on\
        multimedia "$multimedia" on\
        extras "$extras" on\
        kate "$kate" on\
        internet "$internet" on\
        games "$games" off\
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  clear
  if  [ $exit_status -ne 0 ]
  then
    echo "select_packages canceled $exit_status"
    exit $exit_status
  fi

  for id in $selection
  do
        eval "p=\$$id"
        packages="$packages $p"
  done
  displaymanager="lightdm"
  packages=$( echo "$packages" | xargs)
  packages="$musthave $xfce $lightdm $packages"
}

# ------------------------------------------------------------------------------
# some packages to install :D
install_packages()
{
  for pkg in $packages; do
      # echo "INSTALL $pkg...."
      $PKGINSTALL "$pkg"
  done
  # add skel and opt files :
  sh _freeBSDPrepareOPT.sh
  # add lightdm
  sysrc lightdm_enable="YES"
}
# ------------------------------------------------------------------------------
summery()
{
  result="\
We are ready. Last chance to cancel ;)

* $displaymanager will be installed as display manager
* Following Packages will be installed, if possible:
$packages
"
  confirm_result Summery
}
# ------------------------------------------------------------------------------

_root_check
select_packages
summery
install_packages
