#!/bin/sh
set -e
env >> /etc/environment

echo "$CRON_EXPRESSION \
  /usr/bin/mongodump \
  --host $MONGODB_HOST \
  --port $MONGODB_PORT \
  --db $MONGODB_DATABASE \
  --username $MONGODB_USERNAME \
  --password $MONGODB_PASSWORD \
  --authenticationDatabase $MONGODB_AUTH_DATABASE \
  --gzip \
  --archive=$DESTINATION_PATH/"$(date +"\%m_\%d_\%Y-\%H:\%M")".gz \
> /proc/1/fd/1 2>/proc/1/fd/2" > crontab

echo "$INCREMENTAL_CRON_EXPRESSION \
/incr_backup.sh;/cleanBackup.sh" >> crontab

mv crontab /etc/cron.d/crontab

chmod 0644 /etc/cron.d/crontab

/usr/bin/crontab /etc/cron.d/crontab

exec "$@"
