#!/bin/sh
# ------------------------------------------------------------------------------
# WiP!! check FIXME
# prepare users
#
#
# install /usr/local/share/wine/pkg32.sh install wine mesa-dri to /opt/local!!
#       it's nearly 2GB and a symlink to it should also work!
#


# ------------------------------------------------------------------------------
cd `dirname "$0"`
. ./_functions.sh
. ./_dialogs.sh
. ./_install_i386_wine.sh

# ------------------------------------------------------------------------------
pu_execute() {
result=\
"\
This is meant to be executed on a new user it will:
* add user to group video
* install wine 32 bit packages - if we have wine
* install the dot.config skel - it will check and ask to overwrite\
"
messageboxYesNO "Setup User"
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
    menu_result "Setup user for wine-i386, group Video and custom .config" "Please select user"


  if ["$selection" = ""]; then
    return
  fi

  pu_user=$selection
  result="selected user is $pu_user, do you want to continue?"
  messageboxYesNO "Setup User"
  if [ $exit_status -eq 0 ]
  then
    pu_set_video
    pu_copy_dot_config
    pu_setup_wine_386
  fi

}
# ------------------------------------------------------------------------------
pu_set_video()
{
     pw usermod $pu_user -G video
}

# ------------------------------------------------------------------------------
pu_copy_dot_config()
{
  dot_config_dir="/home/$pu_user/.config"
  if [ -d "$dot_config_dir" ]
  then
        result="$dot_config_dir exits, some files will be overwritten! Do you want to continue?"
        messageboxYesNO "Overwrite dot config settings for user $pu_user"
         if [ $exit_status -ne 0 ] ; then
            return
        fi
  fi
  su $pu_user -c "mkdir $dot_config_dir"
  su $pu_user -c "cp -r files/overlay/usr/share/skel/dot.config/* $dot_config_dir/"
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
if [ `basename $0` == "freeBSD_prepare_user.sh" ]
then
  _root_check
  pu_execute
  while true; do
    pu_select_user
    result="Done! Do you want to continue with another user?"
    messageboxYesNO;  if [ $exit_status -ne 0 ] ; then exit 0; fi
  done

fi
