#!/bin/sh
trap 'pkill -f cups && pkill -f cloudprint && exit 0' TERM INT

if [ -f /var/lib/cloudprintd/authfile.json ]
then
    /usr/sbin/cupsd -f &
    cloudprint -d -a /var/lib/cloudprintd/authfile.json &> /dev/stderr
    PID=$!
    wait $PID
else
    /usr/sbin/cupsd -f &
    PID=$!
    wait $PID
fi
EXIT_STATUS=0
