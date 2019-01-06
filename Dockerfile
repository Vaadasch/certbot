FROM alpine:latest

LABEL \
Description="Docker Let's Encrypt Certbot Container for automated \
Webroot certificates generation, base on Nginx conf files" \
Version="1"

ENV EMAIL mail@example.com
ENV INSTANCE Exemple
ENV DOMAIN_1 exemple.domain.com
ENV DOMAIN_2 exemple2.domain.com
ENV PERIODICITY daily
ENV SSL_FLAG server_ssl.conf
ENV SERVER nginx

VOLUME /certs
VOLUME /sitesconf
VOLUME /challenges/.well-known/acme-challenge

WORKDIR /opt/certbot

RUN apk update && apk --no-cache upgrade && \
	apk add --no-cache certbot 

COPY wrap /wrap

CMD /bin/ash /wrap/run.sh
