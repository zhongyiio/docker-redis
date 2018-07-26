FROM scratch

COPY --from=redis:3.0.6 / /

RUN set -ex \
  && usermod -u 1000  redis \
  && groupmod -g 1000 redis \
  && chown -hR redis:redis /data

ENV REDIS_VERSION 3.0.6
VOLUME /data
WORKDIR /data

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 6379
CMD ["redis-server"]