#!/bin/sh
cd `dirname "$0"`
MYDIR=`pwd`


if [ "$1" != "DEBUG" ]
then
    if [ ! -f "/opt/local/updatecheck/installservice.sh" ]
    then
        printf "\n\n\tCan't find /opt/local/updatecheck/installservice.sh\nInstall canceled!\n\n\n"
        exit 1
    fi
    if [ "`whoami`" != "root" ]
    then
        printf "\n\n\tPlease run as root ...\n\n\n"
        exit 1
    fi
fi
clear
echo "\
---------------------------------
Service updatechecker install....
---------------------------------
This will install the service
for the updatechecker.

This will write /tmp/UPDATECHECK
every 15 minutes to check if an
update is available.

This can be used by the
pkgUpdateCheck scripts.

To disable, call:
sysrc updatechecker_enable=\"NO\"

---------------------------------
Hit ENTER to continue
"

if [ "$1" != "nopause" ]
then
    read dummy
fi

# ------------------------------------------------------------------------------
cp rc.d/updatechecker /usr/local/etc/rc.d/
sysrc updatechecker_enable="YES"
service updatechecker start
printf "\n\nfinished!\n"
