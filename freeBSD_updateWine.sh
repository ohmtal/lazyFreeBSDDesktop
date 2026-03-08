#!/bin/sh
# ------------------------------------------------------------------------------#
# install /usr/local/share/wine/pkg32.sh install wine mesa-dri to /opt/local!!
#       it's nearly 2GB and a symlink to it should also work!
#


# ------------------------------------------------------------------------------
cd `dirname "$0"`
. ./include/_functions.sh
. ./include/_dialogs.sh
. ./include/_install_i386_wine.sh

# ------------------------------------------------------------------------------
pu_execute() {
result=\
"\
This is meant to be executed on a new user it will:
* install / update wine 32 bit packages - if we have wine
"
messageboxYesNO "Install update Win32 "
if [ $exit_status -ne 0 ]
then
  exit 0
fi
}
# ------------------------------------------------------------------------------
#  users ... simply look at directories in /home and check with logins -l
pu_get_users()
{
    pu_user_dirs=`ls /home/`
    pu_users=""
    for u in $pu_user_dirs
    do
        tmplogins=`logins -l $u`
        if [ "$tmplogins" != "" ]
        then
            if [ "$pu_users" != "" ]
            then
                pu_users="$pu_users $u"
            else
                pu_users="$u"
            fi
        fi
    done
}
# ------------------------------------------------------------------------------
pu_select_user()
{
    pu_get_users
    # echo "DEBUG: USERS=$pu_users"

    result=$pu_users
    menu_result "Setup user for wine-i386" "Please select user"


  if ["$selection" = ""]; then
    return
  fi

  pu_user=$selection
  result="selected user is $pu_user, do you want to continue?"
  messageboxYesNO "Setup User"
  if [ $exit_status -eq 0 ]
  then
    pu_setup_wine_386
  fi

}

# ------------------------------------------------------------------------------
pu_setup_wine_386()
{

    if [ "`command -v wine`" == "" ]; then
        result "wine not installed, can not setup i386 pkg for user $pu_user."
        display_result "Wine"
        return
    fi

    I386_ROOT="/opt/local/share/i386-wine-pkg"
    I386_USER="/home/$pu_user/.i386-wine-pkg"
    wine386Dir=$(ls $I386_USER)
    if [ "$wine386Dir" != "" ] && [ "$1" != "force" ]
    then
        result="$I386_USER exits, do you want to continue?"
        messageboxYesNO
         if [ $exit_status -ne 0 ] ; then
            return
        fi
    fi

   rm -rf $I386_USER
   install_wine_i386
   su $pu_user -c "ln -s $I386_ROOT $I386_USER"

}

# ------------------------------------------------------------------------------

# only called if standalone and not included
if [ `basename $0` == "freeBSD_updateWine.sh" ]
then
  _root_check
  pu_execute
  pu_select_user
fi
