#!/bin/sh
cd `dirname "$0"`
. ./include/_functions.sh
. ./include/_dialogs.sh
# ------------------------------------------------------------------------------
set_current_repos()
{
result=\
"This will set FreeBSD package installer \
to install latest packages instead of quaterly. \
It will also upgrade packages if updates available. \
If you are on GhostBSD or not on a RELEASE Version choose \"NO\". \
I tested on FreeBSD 15.0 RELEASE and latest also does NOT work. \
If the configfile exits it will be skipped. \
"
messageboxYesNO "Set current repos"
if [ $exit_status -eq 0 ]
then
  execute_set_current_repos $1
fi
}
# ------------------------------------------------------------------------------
# use current not quaterly
# if file exits and param1 is not "force" it will be skipped
execute_set_current_repos()
{
  RCONF=/usr/local/etc/pkg/repos/FreeBSD.conf
  if [ ! -f $RCONF ] || [ "$1" == "force" ]
  then
    mkdir -p /usr/local/etc/pkg/repos
    echo 'FreeBSD: {' > $RCONF
    echo '  url: "pkg+http://pkg.FreeBSD.org/${ABI}/latest"' >> $RCONF
    echo '}' >> $RCONF
    pkg update -f
    pkg upgrade -y
  fi
}
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

# only called if standalone and not included
if [ `basename $0` == "freeBSD_current.sh" ]
then
  _root_check
  set_current_repos $1
fi
