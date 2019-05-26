#!/bin/sh
trap 'pkill -f cups && pkill -f cloudprint && exit 0' TERM INT

sed -Ei 's/LogLevel .+/LogLevel debug2/' /etc/cups/cupsd.conf
/usr/sbin/cupsd -f &
PID=$!
for f in error_log access_log page_log; do
    touch /var/log/cups/${f}
    tail -f /var/log/cups/${f} &
done
if [ -f /root/.cloudprintauth.json ]; then
    cloudprint -v 2>&1
    sleep 3
else
    wait $PID
fi
EXIT_STATUS=0
