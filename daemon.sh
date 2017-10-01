#!/bin/sh
trap 'pkill -f cups && pkill -f cloudprint && exit 0' TERM INT

if [ -f /root/.cloudprintauth.json ]
then
    /usr/sbin/cupsd -f &
    cloudprint -v > /dev/stderr
else
    /usr/sbin/cupsd -f &> /dev/stderr
    PID=$!
    wait $PID
fi
EXIT_STATUS=0
