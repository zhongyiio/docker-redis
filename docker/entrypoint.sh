#!/bin/bash
set -e

#echo "/entrypoint.sh"
#cat /entrypoint.sh

sed -i "s/<SENTINEL_DOWN_AFTER>/${SENTINEL_DOWN_AFTER:-30000}/g" /etc/redis/sentinel.conf
sed -i "s/<SENTINEL_FAILOVER>/${SENTINEL_FAILOVER:-180000}/g" /etc/redis/sentinel.conf
sed -i "s/<SENTINEL_MASTER_HOSTORIP>/${SENTINEL_MASTER_HOSTORIP:-redis-master}/g" /etc/redis/sentinel.conf
sed -i "s/<SENTINEL_MASTER_NAME>/${SENTINEL_MASTER_NAME:-mymaster}/g" /etc/redis/sentinel.conf
sed -i "s/<SENTINEL_MASTER_PORT>/${SENTINEL_MASTER_PORT:-6379}/g" /etc/redis/sentinel.conf
sed -i "s/<SENTINEL_PORT>/${SENTINEL_PORT:-26379}/g" /etc/redis/sentinel.conf
sed -i "s/<SENTINEL_QUORUM>/${SENTINEL_QUORUM:-2}/g" /etc/redis/sentinel.conf
echo "/etc/redis/sentinel.conf"
cat /etc/redis/sentinel.conf

if [ "$1" = 'redis-server' ]; then
	chown -R redis .
	exec gosu redis "$@"
fi

exec "$@"
