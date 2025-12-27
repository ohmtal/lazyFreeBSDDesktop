#!/bin/sh
notify=/usr/local/bin/notify-send
sleep="/bin/sleep 900"
sleeplong="/bin/sleep 3600"
updateFile=/tmp/UPDATECHECK

# TODO: Check for dangerous: "Installed packages to be REMOVED"

# not perfect but better then calling kill attempt
doubleLaunchCheck()
{
# sucks
return
   cnt=`ps ax | grep pkgUpdateCheck.sh | grep -v grep | wc -l | xargs`
   # ps ax | grep pkgUpdateCheck.sh | grep -v grep | wc -l
   # no idea why it's cnt == 2 but should be 1 !?!?!?!?
   # echo "$cnt"
   if [ $cnt -gt 2 ]
   then
    echo "another instance is running ... exit"
    exit 0
   fi
}

killMe()
{
    ps ax | grep pkgUpdateCheck.sh | grep -v grep | awk '{print $1}' | xargs kill
}


#DEBUG: sleep="/bin/sleep 60"
#DEBUG echo "pkg update check with param:$1" >> /tmp/pkgUpdateCheck.log

if [  "$1" == "stop" ]
then
    killMe
    exit 0
fi

# doubleLaunchCheck

while true
do
    if [ ! -f $updateFile ]
    then
        $notify "Software Update" "Update file not exits!\n Check root cronjob!"
        $sleep
        continue
    fi

    AVAIL=`grep 'Number of packages to be' $updateFile`
    if [ ! "$AVAIL" != "" ]
    then
        #DEBUG  $notify "Software Update" "No updates available\n$AVAIL"
        $sleep
        continue
    fi

    beep
    DOSTART=`$notify "Software Update" "There are new available package updates.\n$AVAIL" --icon software-update-available --action start="Start updater" -w -t 60000`
    if [ "$DOSTART" == "start" ]
    then
        if [ -f /opt/local/updatecheck/updateFreeBSD.sh ]
        then
            xterm -bg Maroon -fg white -e /opt/local/updatecheck/updateFreeBSD.sh
        else
            xterm -bg Maroon -fg white -e "sudo pkg upgrade"
        fi
    fi
    $sleeplong
done
