#!/bin/sh
# ------------------------------------------------------------------------------
# Version 0.251009
# ------------------------------------------------------------------------------
musthave="xorg sudo"
basic="mc bash btop smartmontools links wget screen"
fusefsExtras="fusefs-afuse fusefs-ext2 fusefs-lkl fusefs-ntfs fusefs-smbnetfs fusefs-sshfs fusefs-ufs"
windos="wine wine-proton dosbox"
devel="pkgconf cmake gcc libGLU openal-soft libvorbis hidapi nasm gtk3 libunwind openjdk21-jre"
sdl="SDL sdl2 sdl3 sdl12-compat"
godot="godot godot-tools"
versioncontrol="git cvs"
xdevel="kdevelop lazarus-qt6"
graphic="krita blender gimp ristretto"
multimedia="mplayer obs-studio ffmpeg dsbmixer"
extras="kate plank zenity xarchiver"
internet="firefox thunderbird"
#  telegram-desktop
games="gnome-mahjongg quadrapassel"
kde="plasma6-plasma konsole dolphin falkon"
xfce="xfce xfce4-whiskermenu-plugin xfce4-pulseaudio-plugin xfce4-goodies"
cinnamon="cinnamon";
lxde="lxde-meta"
wmaker="windowmaker wmakerconf wmclock wmcpuload wmnetload wmsmixer wmbsdbatt wmmemload"
lightweight="geany pcmanfm links"
# geany-plugins

cd `dirname "$0"`
. ./_functions.sh
. ./_dialogs.sh
. ./freeBSD_DM_select.sh
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
select_packages()
{
  HEIGHT=25
  WIDTH=78


  exec 3>&1
  selection=$($DIALOG \
    --backtitle "$BACKTITLE" \
    --title "Toms packages" \
    --clear \
    --cancel-label "Cancel" \
    --checklist "Please select:" $HEIGHT $WIDTH 20 \
        basic "$basic" on\
        fusefsExtras "$fusefsExtras" off\
        windos "$windos" off\
        devel "$devel" off\
        sdl "$sdl" off\
        versioncontrol "$versioncontrol" off\
        xdevel "$xdevel" off\
        graphic "$graphic" on\
        multimedia "$multimedia" on\
        extras "$extras" on\
        internet "$internet" on\
        games "$games" off\
        godot "$godot" off\
        xfce "$xfce" on\
        cinnamon "$cinnamon" off\
        kde "$kde" off\
        lxde "$lxde" off\
        wmaker "$wmaker" off\
        lightweight "$lightweight" off\
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

  packages=$( echo "$packages" | xargs)
  packages="$musthave $packages"

}

# ------------------------------------------------------------------------------
# some packages to install :D
install_packages()
{
  for pkg in $packages; do
      # echo "INSTALL $pkg...."
      $PKGINSTALL "$pkg"
  done
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
select_display_manager
summery
install_packages
install_displaymanager
