#!/bin/sh
#------------------------------------------------------------------------------
# Select graphics driver
# Note:   2025-11-12
#         i may better use xconfig from GhostBSD Project
#         https://github.com/ghostbsd/xconfig/
#------------------------------------------------------------------------------
cd `dirname "$0"`
. ./include/_functions.sh
. ./include/_dialogs.sh
#------------------------------------------------------------------------------
_moveXorgConf()
{
  if [ -f /etc/X11/xorg.conf ]
  then
    datefmt=`date +"%Y%m%d_%H%M%S"`
    mv /etc/X11/xorg.conf /etc/X11/xorg.conf.$datefmt
  fi
}
#------------------------------------------------------------------------------
_reset_kld_graphic()
{
    sysrc kld_list-=i915kms
    sysrc kld_list-=amdgpu
    sysrc kld_list-=nvidia-drm
    sysrc kld_list-=nvidia-modeset
}
#------------------------------------------------------------------------------
_intel()
{
    $PKGINSTALL drm-kmod
    sysrc kld_list+=i915kms
}
#------------------------------------------------------------------------------
_amd()
{
    # newer than HD7000 ....
    $PKGINSTALL drm-kmod
    sysrc kld_list+=amdgpu
}
#------------------------------------------------------------------------------
_nvidia()
{
    $PKGINSTALL nvidia-drm-kmod
    sysrc kld_list+=nvidia-drm
    _insert_to_loader  hw.nvidiadrm.modeset=\"1\"
}
#------------------------------------------------------------------------------
_nvidia390()
{
    printf "\t* install NVIDIA 390 drivers\n"
    $PKGINSTALL_NOW nvidia-driver-390 nvidia-xconfig
    sysrc kld_list+=nvidia-modeset
    kldload nvidia-modeset
    nvidia-xconfig
}
#------------------------------------------------------------------------------
_nvidia470()
{
    printf "\t* install NVIDIA 470 drivers\n"
    $PKGINSTALL_NOW nvidia-driver-470 nvidia-xconfig
    sysrc kld_list+=nvidia-modeset
    kldload nvidia-modeset
    nvidia-xconfig
}
#------------------------------------------------------------------------------
_cleanup()
{
  _reset_kld_graphic
  _moveXorgConf
}
#------------------------------------------------------------------------------
_select_graphics()
{
  exec 3>&1
  selection=$($DIALOG \
    --backtitle "$BACKTITLE" \
    --title "Graphic Driver Selection" \
    --clear \
    --cancel-label "Cancel" \
    --menu "Please select:" 0 0 8 \
    "0" "Vesa - old graphics" \
    "1" "Intel" \
    "2" "AMD" \
    "3" "NVidia current" \
    "4" "NVidia 470" \
    "5" "NVidia 390" \
    "6" ">> skip graphic driver setup" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-

  clear
  if  [ $exit_status -ne 0 ]
  then
    echo "select_graphics canceled $exit_status"
    exit $exit_status
  fi


  case $selection in
    0 )
      clear
      echo "Vesa"
      _cleanup
      ;;
    1 )
      clear
      echo "Intel"
      _cleanup
      _intel
      ;;
    2 )
      clear
      echo "AMD"
      _cleanup
      _amd
      ;;
    3 )
      clear
      echo "NVidia"
      _cleanup
      _nvidia
      ;;
    4 )
      clear
      echo "NVidia 470"
      _cleanup
      _nvidia470
      ;;

    5 )
      clear
      echo "NVidia 390"
      _cleanup
      _nvidia390
      ;;
    6 )
      clear
      echo "nothing to do"
      ;;
  esac
}
#------------------------------------------------------------------------------
# only called if stand alone and not included!
if [ `basename $0` == "freeBSD_graphic_drivers.sh" ]
then
  _root_check
  _select_graphics
fi
