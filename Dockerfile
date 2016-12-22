FROM resin/rpi-raspbian

RUN apt-get update && apt-get install wget -y --force-yes
RUN wget -O - https://davesteele.github.io/key-366150CE.pub.txt | apt-key add - 
RUN echo "deb http://davesteele.github.io/cloudprint-service/repo cloudprint-jessie main" > /etc/apt/sources.list.d/cloudprint.list
RUN apt-get update
RUN apt-get install cloudprint-service -y
RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf
RUN sed -r -i 's/(Order allow\,deny)/\1\n  Allow all/' /etc/cups/cupsd.conf
RUN echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf
# RUN useradd $CUPS_USER_ADMIN --system -G root,lpadmin --no-create-home --password $(mkpasswd $CUPS_USER_PASSWORD)

CMD ["/usr/sbin/cupsd"]
