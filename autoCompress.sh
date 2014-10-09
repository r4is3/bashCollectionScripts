#!/bin/bash
# -*- coding:UTF8 -*-
    
## This script monitor a directory and when a file come in, make a gzip of it
## launch with at now or nohup \o/
## edit cron with something like that : 
## @reboot nice -n 19 /backup/script/gzipDump.sh yourFile2compress

# look recurcively into directory and gzip after typical file system message
inotifywait  -mr -e MOVED_TO --format '%w%f' $1 |
while read fichier
do 
	echo $fichier
	zip ${fichier}
done

