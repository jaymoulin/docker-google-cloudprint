FROM sdhibit/rpi-raspbian

MAINTAINER Jay MOULIN <jaymoulin@gmail.com>

RUN apt-get update && apt-get install wget -y --force-yes && \
	wget -O - https://davesteele.github.io/key-366150CE.pub.txt | apt-key add - && \
	echo "deb http://davesteele.github.io/cloudprint-service/repo cloudprint-jessie main" > /etc/apt/sources.list.d/cloudprint.list && \
	apt-get update && \ 
	apt-get install cloudprint-service -y && apt-get remove wget -y && apt-get clean && apt-get autoremove -y

EXPOSE 631

RUN sed -r -i 's/(Order allow\,deny)/\1\n  Allow all/' /etc/cups/cupsd.conf && \
	echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf

ADD configure /usr/bin/configure
ADD daemon.sh /root/daemon.sh
RUN chmod +x /usr/bin/configure
RUN chmod +x /root/daemon.sh

CMD ["/root/daemon.sh"]
