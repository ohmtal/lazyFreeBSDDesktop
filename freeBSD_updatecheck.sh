#!/bin/sh
# ------------------------------------------------------------------------------
# Install update checker
# ------------------------------------------------------------------------------
cd `dirname "$0"`
. ./_functions.sh
. ./_dialogs.sh
# ------------------------------------------------------------------------------
_updatecheck()
{
  # update check
  mkdir -p /opt/local/
  cp -r ./files/updatecheck /opt/local
  /opt/local/updatecheck/installservice.sh nopause
  result="Update check service is installed. Check /opt/local/updatecheck/README for more informations."
  display_result "update check"
}
# ------------------------------------------------------------------------------
updateCheckWelcome()
{
  result=`cat ./files/updatecheck/README`
  messageboxYesNO "update check"
  if [ $exit_status -eq 0 ] ; then
    _updatecheck
  fi
}
# ------------------------------------------------------------------------------

# only called if standalone and not included
if [ `basename $0` == "freeBSD_updatecheck.sh" ]
then
  _root_check
  updateCheckWelcome
fi

