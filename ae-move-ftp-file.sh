#!/bin/sh

pid=$$
echo "my pid is: " $pid
pidfile="/var/run/ae-move-ftp-file.pid"

echo $pid > $pidfile

trap 'rm -f $pidfile ; exit 1' TERM INT

while [ true ]
do
    /home/zuav/src/scripts/ae-move-ftp-file.awk $1
done

exit 0
