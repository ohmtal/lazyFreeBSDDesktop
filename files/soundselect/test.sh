#!/bin/sh
# stupid dialog drives me crazy :P


DIALOG="dialog"
BACKTITLE="Sound output select"
HEIGHT=20
WIDTH=60
#list=`dmesg | grep pcm | sort | uniq | sed 's/^/"/;s/$/"/'| nl -v 0`


list="1 BlaFasel\n2 Blub\n"

printf "$list"
#exit 0

#    --clear \


  exec 3>&1
  selection=$($DIALOG \
    --backtitle "$BACKTITLE" \
    --title "Select audio device" \
    --cancel-label "Cancel" \
    --menu "Please select:" $HEIGHT $WIDTH 20 \
            $list \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-

echo "EXITSTATUS IS $exit_status"


# #!/bin/sh
# tempfile="$(mktemp)"
# while true; do
#     dialog --menu 'Please select from the server list' 18 70 15 $(nl server.list) 2>"$tempfile" && break
# done
# n="$(cat "$tempfile")"
# value="$(sed -n "${n}p" server.list)"
# rm "$tempfile"
# echo "The user selected option number $n: '$value'"
