#!/bin/sh
sleep 10
while true
do
pkg update
pkg upgrade -n > /tmp/UPDATECHECK
sleep 900
done
