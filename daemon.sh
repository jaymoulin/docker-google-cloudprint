#!/bin/sh

if [ -f /var/lib/cloudprintd/authfile.json ]
then
    /usr/sbin/cupsd -f &
    /usr/sbin/cloudprintd -a /var/lib/cloudprintd/authfile.json
else
    /usr/sbin/cupsd -f
fi