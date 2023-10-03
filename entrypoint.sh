#!/bin/sh
set -e
env >> /etc/environment
if ( [ -z "${MONGODB_USERNAME}" ] || [ -z "${MONGODB_PASSWORD}" ] );
then
  echo "$CRON_EXPRESSION \
  /usr/bin/mongodump \
  --host $MONGODB_HOST \
  --port $MONGODB_PORT \
  --db $MONGODB_DATABASE \
  --gzip \
  --archive=$DESTINATION_PATH/"'$(date +"\%m_\%d_\%Y-\%H:\%M")'".gz \
  > /proc/1/fd/1 2>/proc/1/fd/2;\
  /cleanBackup.sh" > crontab
else
  echo "$CRON_EXPRESSION \
  /usr/bin/mongodump \
  --host $MONGODB_HOST \
  --port $MONGODB_PORT \
  --db $MONGODB_DATABASE \
  --username $MONGODB_USERNAME \
  --password $MONGODB_PASSWORD \
  --authenticationDatabase $MONGODB_AUTH_DATABASE \
  --gzip \
  --archive=$DESTINATION_PATH/"'$(date +"\%m_\%d_\%Y-\%H:\%M")'".gz \
  > /proc/1/fd/1 2>/proc/1/fd/2;\
  /cleanBackup.sh" > crontab
fi

mv crontab /etc/cron.d/crontab

chmod 0644 /etc/cron.d/crontab

/usr/bin/crontab /etc/cron.d/crontab

exec "$@"
