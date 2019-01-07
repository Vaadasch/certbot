FROM alpine:latest

LABEL \
Description="Docker Let's Encrypt Certbot Container for automated \
Webroot certificates generation, base on Nginx conf files" \
Version="1"

ENV EMAIL 
ENV INSTANCE 
ENV SERVERNAMES 
ENV PERIODICITY daily
ENV SSL_FLAG 
ENV SERVER 

VOLUME /certs
VOLUME /sitesconf
VOLUME /challenge

WORKDIR /opt/certbot

RUN apk update && apk --no-cache upgrade && \
	apk add --no-cache certbot && \
	mkdir -p /working-challenge/.well-known && \
	ln -s /challenge /working-challenge/.well-known/acme-challenge

COPY wrap /wrap

ENTRYPOINT ["/bin/ash", "/wrap/run.sh"]
