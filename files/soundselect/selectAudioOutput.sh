#!/usr/bin/env bash
GAMEPATH=`dirname "$0"`
title="FreeBSD Audio Output Selector"
prompt="select"

# FIXME check zenity installed

# list=`dmesg | grep pcm | sort | uniq | sed 's/^/"/;s/$/"/'`
list=`dmesg | grep pcm | sort | uniq`

#---
SAVEIFS=$IFS   # Save current IFS (Internal Field Separator)
IFS=$'\n'      # Change IFS to newline char
items=($list) # split the `names` string into an array by the same name
IFS=$SAVEIFS   # Restore original IFS
#---
# for (( i=0; i<${#items[@]}; i++ )); do echo "$i: ${items[$i]}"; done



selected=$(zenity --title="$title" --text="Audio-Device" --list \
                --width=600 --height=400 \
               --column="select:" "${items[@]}")

# echo "$selected"; exit 0
if [ "$selected" == "" ]; then
    exit 0
fi

id=`echo $selected | sed -E 's/pcm(.?):.*/\1/'`
param="hw.snd.default_unit=$id"
sysctl $param

# echo "selected: $selected"
# echo "id=$id"
zenity --info --text="ID:$id selected add\n$param\nto /etc/sysctl.conf to make this permanent."


