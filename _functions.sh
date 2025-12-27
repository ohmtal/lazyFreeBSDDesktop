#!/bin/sh

# const
PKGINSTALL=_pkg_install_wrapper
PKGINSTALL_NOW="pkg install -y"

RED='\033[41m'
BLUE='\033[44m'
NOCOLOR='\033[0m'

#------------------------------------------------------------------------------
_pkg_install_wrapper()
{
    if [ "$lazyInstall" == "YES" ]; then
        lazy_packages="$lazy_packages $@"
    else
        printf "${BLUE}Installing:${NOCOLOR} $@\n"
        pkg install -y $@
    fi
}

lazy_install_packages()
{
  for pkg in $lazy_packages; do
    printf "${BLUE}Installing:${NOCOLOR} $pkg\n"
    $PKGINSTALL "$pkg"
  done
}
#------------------------------------------------------------------------------
# can be called after a script is called
_check_canceled()
{
last_res=$?
# echo "exitstatus is: $last_res"
if [ $last_res -ne 0 ]
then
    exit $last_res
fi

}
#------------------------------------------------------------------------------
# wait for enter
wait_for_enter()
{
    if [ "$1" == "enteronly" ]
    then
        printf "\nPress enter to continue..."
    else
        printf "\nPress enter to continue or press ctrl+C to cancel."
    fi
    read ans
}
#------------------------------------------------------------------------------
# check if user is root
_root_check()
{
    USER=`whoami`
    if [ "$USER" != "root" ]; then
        printf "\n\n\n"
        echo "!!!!!!!!!!!!!!!!!!!!!!"
        echo "Please run as root ..."
        echo "!!!!!!!!!!!!!!!!!!!!!!"
        printf "\n\n\n"
        exit 1
    fi
}
#------------------------------------------------------------------------------
# test function
_pa()
{
echo $1
}

#------------------------------------------------------------------------------
# using sysrc with /boot/loader.conf
_loader_conf()
{
    s=$1
    if [ "$s" == "" ]; then
        echo "_loader_conf missing parameter"
        return
    fi

    sysrc -f /boot/loader.conf $s
}

# using sysrc with /etc/rc.conf
_rc_conf()
{
    s=$1
    if [ "$s" == "" ]; then
        echo "_rc_conf missing parameter"
        return
    fi

    sysrc $s
}


# using sysrc with /etc/sysctl.conf
_sysctl_conf()
{
    s=$1
    if [ "$s" == "" ]; then
        echo "_sysctl_conf missing parameter"
        return
    fi

    sysrc -f /etc/sysctl.conf $s
}
#------------------------------------------------------------------------------
# insert line to boot/loader.conf if not exists
_insert_to_loader()
{
    s=$1
    if [ "$s" == "" ]; then
        echo "_insert_to_loader missing parameter"
        return
    fi

    loader=/boot/loader.conf
    found=`grep "$s" $loader`
    if [ "$found" == "" ];  then
        echo $s >> $loader
    else
        echo "found $s in $loader! skipping...."
    fi
}
#------------------------------------------------------------------------------
# inset line to sysctl
_insert_to_sysctl()
{
    s=$1
    if [ "$s" == "" ]; then
        echo "_insert_to_sysctl missing parameter"
        return
    fi

    file=/etc/sysctl.conf
    found=`grep "$s" $file`
    if [ "$found" == "" ];  then
        echo $s >> $file
    else
        echo "found $s in $file! skipping...."
    fi
}
#------------------------------------------------------------------------------
# $(_command_exists [COMMAND] )
_command_exists()
{
   if [ "`command -v $1`" = "" ]; then
        echo "0"
        return
   fi
   echo 1
}

#------------------------------------------------------------------------------
