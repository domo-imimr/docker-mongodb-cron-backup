#!/bin/sh
set -e
backup_files_count=$(ls -1 "$DESTINATION_PATH" | grep -c "^[0-9]\{2\}_[0-9]\{2\}_[0-9]\{4\}-[0-9]\{2\}:[0-9]\{2\}.gz")
if ( [ "$backup_files_count" -gt 14 ] )
then
    oldest_backup=$(ls -1t "$DESTINATION_PATH" | grep "^[0-9]\{2\}_[0-9]\{2\}_[0-9]\{4\}-[0-9]\{2\}:[0-9]\{2\}.gz" | tail -n 1)
    rm "$DESTINATION_PATH/$oldest_backup"
fi