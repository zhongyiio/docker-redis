
ARG IMAGE_ARG_IMAGE_TAG

FROM redis:${IMAGE_ARG_IMAGE_TAG:-3.0.6} as base



FROM scratch

ARG IMAGE_ARG_ALPINE_MIRROR
ARG IMAGE_ARG_VERSION

COPY --from=base / /

COPY --chown=1000:1000 docker /

RUN set -ex \
  && echo "/entrypoint.sh" \
  && cat /entrypoint.sh \
  && chmod 755 /entrypoint.sh \
  && if [ -f /etc/alpine-release ] && [[ $(cat /etc/alpine-release | awk -F. '{print $1"."$2}') == "3.3" ]]; then echo "http://${IMAGE_ARG_ALPINE_MIRROR:-dl-cdn.alpinelinux.org}/alpine/edge/community/" >> /etc/apk/repositories; fi \
  && if [ -f /etc/alpine-release ]; then \
       echo IMAGE_ARG_ALPINE_MIRROR ${IMAGE_ARG_ALPINE_MIRROR}; \
       echo /etc/apk/repositories; cat /etc/apk/repositories; \
       sed -E -i "s#[0-9a-z-]+\.alpinelinux\.org#${IMAGE_ARG_ALPINE_MIRROR:-dl-cdn.alpinelinux.org}#g" /etc/apk/repositories; \
       echo /etc/apk/repositories; cat /etc/apk/repositories; \
       apk upgrade --update; \
       apk add --no-cache shadow sudo; \
       rm -rf /tmp/* /var/cache/apk/*; \
     fi \
  && usermod -u 1000  redis \
  && groupmod -g 1000 redis \
  && chown -hR redis:redis /data

ENV REDIS_VERSION ${IMAGE_ARG_VERSION:-3.0.6}
VOLUME /data
WORKDIR /data

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 6379
CMD ["redis-server"]
