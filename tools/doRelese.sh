#!/bin/sh
#
# create a tarball of lazyFreeBSDDesktop one level up of lazyFreeBSDDesktop's directory
# It does not check anything like permissions and is not fail safe.
# Only for internal use.
#

cd `dirname "$0"`/../../
tar -czvf lazyFreeBSDDesktop.tgz --exclude ".git" lazyFreeBSDDesktop

