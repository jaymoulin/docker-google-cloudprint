FROM jaymoulin/rpi-python:alpine-2

MAINTAINER Jay MOULIN <jaymoulin@gmail.com>

RUN apk add --update --no-cache --virtual .build-deps g++ && \
    apk add --update --no-cache cups cups-dev cups-filters && \
    python -m ensurepip --default-pip && \
    pip install cloudprint[daemon] && \
    apk del g++ --purge .build-deps

EXPOSE 631

RUN sed -r -i 's/(Order allow\,deny)/\1\n  Allow all/' /etc/cups/cupsd.conf && \
	echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf

ADD configure /usr/bin/configure
ADD daemon.sh /root/daemon.sh

CMD ["/root/daemon.sh"]
