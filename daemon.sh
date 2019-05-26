#!/bin/sh
trap 'pkill -f cups && pkill -f cloudprint && exit 0' TERM INT

if [ -f /root/.cloudprintauth.json ]
then
    /usr/sbin/cupsd -f 2>&1 &
    cloudprint -v 2>&1
    sleep 3
else
    /usr/sbin/cupsd -f 2>&1 &
    PID=$!
    wait $PID
fi
EXIT_STATUS=0
