#!/bin/sh
#RED='\033[0;31m'
RED='\033[41m'
NOCOLOR='\033[0m'

# from freebsd-update
# Return 0 if the system is managed using pkgbase, 1 otherwise.
check_pkgbase()
{
    if [ "$BASEDIR" == "" ]; then
        BASEDIR=/
    fi

	# Packaged base requires that pkg is bootstrapped.
	if ! pkg -N -r ${BASEDIR} >/dev/null 2>/dev/null; then
		return 1
	fi
	# uname(1) is used by pkg to determine ABI, so it should exist.
	# If it comes from a package then this system uses packaged base.
	if ! pkg -r ${BASEDIR} which /usr/bin/uname >/dev/null; then
		return 1
	fi
	return 0
}

clear
printf "\nFreeBSD Update.. >> packages <<\n"
echo -e " ${RED}Be carefull!!${NOCOLOR} check if packages will be removed ... this can happen and you"
echo " should cancel the update with ctrl-c !!!!!!!"
echo ""
echo    "   If you want to prevent a package from uninstall you can lock it with:"
echo    "     pkg lock [PACKAGENAME]"
echo    "   To unlock again you can use:"
echo    "     pkg unlock [PACKAGENAME]"
echo    "   You can also list your locked packages with:"
echo    "     pkg lock -l"
printf "\n\n"
sudo pkg update
# clear old check file
if [ -f  /tmp/UPDATECHECK ]
then
    sudo rm /tmp/UPDATECHECK
fi
sudo pkg upgrade

if ! check_pkgbase; then
printf "\nFreeBSD Update.. >> system << press enter to continue\n"
read ans
sudo freebsd-update fetch
sudo freebsd-update install
fi

printf "\nFreeBSD Update.. >> FINISHED << press enter to finish script\n"
read ans

