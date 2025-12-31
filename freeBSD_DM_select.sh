#!/bin/sh
# ------------------------------------------------------------------------------
# Select displaymanager
# ------------------------------------------------------------------------------
cd `dirname "$0"`
. ./include/_functions.sh
. ./include/_dialogs.sh
# ------------------------------------------------------------------------------
select_display_manager()
{
  HEIGHT=20
  WIDTH=78


  exec 3>&1
  selection=$($DIALOG \
    --backtitle "$BACKTITLE" \
    --title "Select display manager" \
    --clear \
    --cancel-label "Cancel" \
    --radiolist "Please select:" $HEIGHT $WIDTH 20 \
        choose "Please select an display manager" on\
        sddm "Nice displaymanager and the best for KDE" off\
        lightdm "Also good displaymanager, best for xfce" off\
        wdm "lightweight displaymanager best for windowmaker" off\
        none "No display manager. I like startx ;)" off\
        keep "Keep the current display manager - if any." off\
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-

  #clear
  if  [ $exit_status -eq $DIALOG_CANCEL ] || [ $exit_status -eq $DIALOG_ESC ]
  then
    echo "select_display_manager canceled: $exit_status"
    exit $exit_status
  fi
  if [ "$selection" == "choose" ]
  then
    select_display_manager
  fi

  displaymanager=$selection
}
# ------------------------------------------------------------------------------
install_displaymanager()
{

 case $displaymanager in
    "lightdm" )
      $PKGINSTALL lightdm lightdm-gtk-greeter
      sysrc lightdm_enable="YES"
      sysrc sddm_enable="NO"
      sysrc wdm_enable="NO"
      ;;
    "sddm" )
      $PKGINSTALL sddm
      sysrc sddm_enable="YES"
      sysrc lightdm_enable="NO"
      sysrc wdm_enable="NO"
      _insert_to_sysctl net.local.stream.recvspace=65536
      _insert_to_sysctl net.local.stream.sendspace=65536
      ;;
    "wdm" )
      $PKGINSTALL wdm
      sysrc lightdm_enable="NO"
      sysrc sddm_enable="NO"
      sysrc wdm_enable="YES"
      cp files/wdm /usr/local/etc/rc.d/
      ;;
    "none" )
      sysrc lightdm_enable="NO"
      sysrc sddm_enable="NO"
      sysrc wdm_enable="NO"
  esac
}
# ------------------------------------------------------------------------------
# only called if stand alone and not included!
if [ `basename $0` == "freeBSD_DM_select.sh" ]
then
  _root_check
  select_display_manager
  install_displaymanager
fi
