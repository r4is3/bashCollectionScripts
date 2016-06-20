#!/bin/bash
# -*- coding:UTF8 -*-

## This script perform a backup database on Couchdb
HOST='127.0.0.1:5984'
LOGIN='your-db-login'
PASS='your-db-password'
DB='your-db-name'
DATE=$(date +%d%m%Y)

echo -e '$(date) Backup start'
if curl -X GET http://$LOGIN:$PASS@$HOST/$DB/_all_docs?include_docs=true >> storage/backup/backupCozyBD-$DATE.txt
  then
    echo -e 'Cozy CouchDB successfully backuped'
  else
    echo -e '$(date) Backup Failed, please check'
    ## SEND ALERT YOU WANT
fi
