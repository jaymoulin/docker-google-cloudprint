#!/bin/sh

usage="$(basename "$0") {-h|help|-o|open|-c|close|-u|update}

where:
    -h|help   Show this help text
    -o|open   Open printer configuration on 631 port (http://<your_device_IP>:631/admin)
    -c|close  Close printer configuration and gives URL to link to Google Cloudprint
    -u|update Update Google Cloudprint services
    -s|save   Save cups configuration files to /root/cups/
    -l|load   Load cups configuration files from /root/cups/
"

if [ -z "$CUPS_USER_ADMIN" ] || [ -z "$CUPS_USER_PASSWORD" ]; then
    echo "You must define \$CUPS_USER_ADMIN and \$CUPS_USER_PASSWORD"
    exit 2
fi

case "$1" in
help|-h) echo "$usage"
   exit
   ;;
-o|open) sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf
   getent passwd $CUPS_USER_ADMIN > /dev/null
   if [ ! $? -eq 0 ]; then
       adduser $CUPS_USER_ADMIN -S -H
   fi
   addgroup $CUPS_USER_ADMIN lpadmin
   addgroup $CUPS_USER_ADMIN root
   echo "$CUPS_USER_ADMIN:$CUPS_USER_PASSWORD" | chpasswd
   pkill -f cupsd
   ;;
-c|close) sed -i 's/Listen 0.0.0.0:631/Listen localhost:631/' /etc/cups/cupsd.conf
   deluser $CUPS_USER_ADMIN
   cloudprint -c
   # systemctl restart cloudprintd
   pkill -f cupsd
   ;;
-u|update)
    apk add cups cups-dev cups-filters --update
    pip install cloudprint[daemon] -U
  ;;
-s|save)
    mkdir -p /root/cups/
    cp -R /etc/cups/* /root/cups/
    # systemctl restart cloudprintd
    pkill -f cupsd
  ;;
-l|load)
    cp -R /root/cups/* /etc/cups/
    # systemctl restart cloudprintd
    pkill -f cupsd
  ;;
*)
  echo "$usage"
  exit 1
  ;;
esac

