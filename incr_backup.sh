#!/bin/bash

/usr/bin/mongodump \
--host $MONGODB_HOST \
--port $MONGODB_PORT \
--db local \
--username $MONGODB_USERNAME \
--password $MONGODB_PASSWORD \
--authenticationDatabase $MONGODB_AUTH_DATABASE \
-c oplog.rs \
--queryFile query.js \
-o - > $DESTINATION_PATH/"$(date +"\%m_\%d_\%Y-\%H:\%M")"/oplog.bson;
New_DATE=$(date +%s)
Old_DATE=$(cat /query.js | awk -F: '{print $5}' | cut -c 1-10)
sed -i "s|$Old_DATE|$New_DATE|g" /query.js