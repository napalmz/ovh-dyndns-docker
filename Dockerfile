FROM alpine:latest
LABEL maintainer "NapalmZ <admin@napalmz.eu>"

ENV HOST=""
ENV LOGIN=""
ENV PASSWORD=""
ENV ENTRYPOINT="https://www.ovh.com/nic/update"
ENV NSSERVER="8.8.8.8"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk --no-cache update \
    && apk --no-cache upgrade \
    && apk add --no-cache \
        tzdata \
        curl \
        wget \
        curl \
        bash \
        zip \
        dcron \
        bind-tools \
        ca-certificates \
    && mkdir -p /srv/dyndns

COPY config/cmd.sh /srv/dyndns/cmd.sh
COPY config/entrypoint.sh /srv/dyndns/entrypoint.sh
COPY config/dynhost.sh /srv/dyndns/dynhost
COPY config/cronjob.txt /etc/cron.d/dynhost

RUN chmod +x /srv/dyndns/dynhost \
    && chmod +x /srv/dyndns/entrypoint.sh \
    && chmod +x /srv/dyndns/cmd.sh

HEALTHCHECK --interval=5s --timeout=3s CMD ps aux | grep '[c]rond' || exit 1

ENTRYPOINT ["/srv/dyndns/entrypoint.sh"]
CMD ["/srv/dyndns/cmd.sh"]
