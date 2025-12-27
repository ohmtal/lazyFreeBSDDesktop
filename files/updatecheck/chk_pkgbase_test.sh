#!/bin/sh



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


if check_pkgbase; then
	echo "Your FreeBSD is using packaged base :) ready for future"
else
	echo "Your FreeBSD is NOT using packaged base :) If you want to try it out take a look at: https://github.com/FreeBSDFoundation/pkgbasify"
fi


