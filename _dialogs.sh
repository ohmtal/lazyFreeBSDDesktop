#!/bin/sh
# ------------------------------------------------------------------------------
# DIALOGS
# ------------------------------------------------------------------------------
. ./_functions.sh
# check dialog is available
DIALOG=""
if [ "$DIALOG" == "" ] && [ "$(_command_exists dialog )" == "1"  ] ; then
  DIALOG=dialog
fi
if [ "$DIALOG" == "" ] && [ "$(_command_exists cdialog )" == "1"  ] ; then
  DIALOG=cdialog
fi
if [ "$DIALOG" == "" ] && [ "$(_command_exists bsddialog )" == "1"  ] ; then
  DIALOG=bsddialog
fi
if [ "$DIALOG" == "" ] ; then
    clear
    printf "\n\nSorry there is no bsddialog, dialog or cdialog available!\nPlease install with:\n\tsudo pkg install dialog\n\n"
    exit 1
fi

# const
DIALOG_CANCEL=1
DIALOG_ESC=255
BACKTITLE="Tom's Lazy FreeBSD Desktop Installer"
# ------------------------------------------------------------------------------
# popup an messagebox and display the $result variable
display_result() {

  if [ "$1" == "" ] ; then
    title="info"
  else
    title=$1
  fi

  $DIALOG \
    --backtitle "$BACKTITLE" \
    --title "$title" \
    --clear \
    --msgbox "$result" 0 0

#    --no-collapse \

}
# ------------------------------------------------------------------------------
# messageboxYesNO $exit_status == 1 if "NO"
messageboxYesNO() {

  if [ "$1" == "" ] ; then
    title="confirm"
  else
    title=$1
  fi


  exec 3>&1
  $DIALOG \
    --backtitle "$BACKTITLE" \
    --title "$title" \
    --clear \
	--yes-label "YES" \
	--no-label "NO" \
    --yesno "$result" 0 0 \
    2>&1 1>&3
  exit_status=$?
  exec 3>&-
#    --no-collapse \

}
# ------------------------------------------------------------------------------
confirm_result() {

  if [ "$1" == "" ] ; then
    title="confirm"
  else
    title=$1
  fi

  exec 3>&1
  $DIALOG \
    --backtitle "$BACKTITLE" \
    --title "$title" \
    --clear \
	--yes-label "OK" \
	--no-label "Cancel" \
    --yesno "$result" 0 0 \
    2>&1 1>&3
  exit_status=$?
  exec 3>&-
#    --no-collapse \


  if [ $exit_status -eq 1 ]
  then
    echo "confirm_result canceled $exit_status"
    exit $exit_status
  fi
}
# ------------------------------------------------------------------------------
# * expect a space speparated list in variable result
# * paramater 1=  dialog title
# * paramater 2= menu title (optional)
# SET:
# $selection    what is selected , empty if cancled
# $exit_status  0=ok
menu_result() {
  if [ "$result" == "" ]
  then
    echo "ERROR menu_result need a result !!! "
    exit 0
  fi

  items=""
  for item in $result; do
      items="$items $item \"$item\" \n"
  done

  if [ "$1" == "" ] ; then
    title="Menu"
  else
    title=$1
  fi

  if [ "$2" == "" ] ; then
    menutitle="please select"
  else
    menutitle=$2
  fi

 exec 3>&1
  selection=$($DIALOG \
    --backtitle "$BACKTITLE" \
    --title "$title" \
    --clear \
    --cancel-label "Cancel" \
    --menu "$menutitle" 20 60 20 \
    $( printf "$items" ) \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-

}
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# * expect a space speparated list in variable result
# * paramater 1=  dialog title
# * paramater 2= menu title (optional)
# SET:
# $selection    what is selected , empty if cancled
# $exit_status  0=ok
radiolist_result() {
  if [ "$result" == "" ]
  then
    echo "ERROR menu_result need a result !!! "
    exit 0
  fi

  items=""
  for item in $result; do
      items="$items $item \"$item\" off\n"
  done

  if [ "$1" == "" ] ; then
    title="Menu"
  else
    title=$1
  fi

  if [ "$2" == "" ] ; then
    menutitle="please select"
  else
    menutitle=$2
  fi

 exec 3>&1
  selection=$($DIALOG \
    --backtitle "$BACKTITLE" \
    --title "$title" \
    --clear \
    --cancel-label "Cancel" \
    --radiolist "$menutitle" 20 60 20 \
    $( printf "$items" ) \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-

}
# ------------------------------------------------------------------------------
# * expect a space speparated list in variable result
# * param 1=  dialog title
# * param 2= menu title (optional)
# * param 3= default on
# SET:
# $selection    what is selected , empty if cancled
# $exit_status  0=ok
checklist_result() {
  if [ "$result" == "" ]
  then
    echo "ERROR menu_result need a result !!! "
    exit 0
  fi

  if [ "$3" == "on" ]; then
    onoff="on"
  else
    onoff="off"
  fi
  items=""
  for item in $result; do
      items="$items $item \"$item\" $onoff\n"
  done

  if [ "$1" == "" ] ; then
    title="Menu"
  else
    title=$1
  fi

  if [ "$2" == "" ] ; then
    menutitle="please select"
  else
    menutitle=$2
  fi

 exec 3>&1
  selection=$($DIALOG \
    --backtitle "$BACKTITLE" \
    --title "$title" \
    --clear \
    --cancel-label "Cancel" \
    --checklist "$menutitle" 20 60 20 \
    $( printf "$items" ) \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-

}
# ------------------------------------------------------------------------------
