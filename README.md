Raspberry PI - Google Cloudprint - Docker Container
=

This container allow you to configure your printer to your Google Cloudprint easily thanks to Docker.

Installation
---

```
docker run -d --privileged -v --restart=always /dev/bus/usb:/dev/bus/usb --name cloudprint -e CUPS_USER_ADMIN=admin -e CUPS_USER_PASSWORD=password -p 631:631 jaymoulin/rpi-google-cloudprint
```

You can change your admin login/password by replacing values for `CUPS_USER_ADMIN` and `CUPS_USER_PASSWORD`.

Configuration
---
First, allow administration interface to be accessed to setup your printer:
```
docker exec cloudprint configure open
```
This will allow your printer to be configured. 
Go to http://<raspberry_ip>:631 to configure it

Login/Password couple defined with `$CUPS_USER_ADMIN` `$CUPS_USER_PASSWORD` in installation command

Once configured, close admin interface to secure it up and retrieve your Google Cloudprint URL.

```
docker exec cloudprint configure close
```

It will give you a Google Link. Copy/paste this URL in your browser to claim your printer, and voila!

Updating
-----

When Google Cloudprint new version is released, you will be able to update your running version with this command:
 
```
docker exec cloudprint configure update
```

Appendixes
---

### Install RaspberryPi Docker

If you don't have Docker installed yet, you can do it easily in one line using this command
 
```
curl -sSL "https://gist.githubusercontent.com/jaymoulin/e749a189511cd965f45919f2f99e45f3/raw/054ba73080c49a0fcdbc6932e27887a31c7abce2/ARM%2520(Raspberry%2520PI)%2520Docker%2520Install" | sudo sh && sudo usermod -aG docker $USER
```

### Build Docker Image

To build this image locally 
```
docker build -t jaymoulin/rpi-google-cloudprint .
```