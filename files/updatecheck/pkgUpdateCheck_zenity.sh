#!/bin/sh
# FIXME this should be integrated into ONE script ... this is for testing only
# I wrote it when i
# 1. find out notify is possible
# 2. find out it's an X11 login if you putt this in ~/.login
#    => dont use .login for this, write a wmaker start script and
#       add the command to start this script, this should be called by wdm
# 3. find out zenity is installed ...  easy :P later
# alternativ write a wmaker dock to keep an eye on the update

notify=/usr/local/bin/notify-send
sleep="/bin/sleep 900"
sleeplong="/bin/sleep 3600"
updateFile=/tmp/UPDATECHECK

# not perfect but better then calling kill attempt
doubleLaunchCheck()
{
#sucks
return
   cnt=`ps ax | grep pkgUpdateCheck_zenity.sh | grep -v grep | wc -l | xargs`
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
    ps ax | grep pkgUpdateCheck_zenity.sh | grep -v grep | awk '{print $1}' | xargs kill
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
        zenity --title="Software Update" --info --text="Update file not exits!\n Check root cronjob!"
        $sleep
        continue
    fi

    AVAIL=`grep 'Number of packages to be' $updateFile`
    if [ ! "$AVAIL" != "" ]
    then
        #DEBUG zenity --title="Software Update" --info --text="There are NO updates."
        $sleep
        continue
    fi

    beep
    if zenity --title="Software Update" --question --text="There are new available package updates.\n$AVAIL"
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
