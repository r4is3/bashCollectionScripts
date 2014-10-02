#!/bin/bash
# -*- coding:UTF8 -*-
    
  ## @author r4is3 : r4is3@w0rld.fr  
  ## This script check your web server log file and give you the visitor sorted by day, amount and give localization
    
IFS=$'\r\n'

## HERE YOU DEFINE VARIABLES
# YOUR WEB SERVER LOG FILE
LOGFILE="/your/web/logFile"
# DO NOT CHECK THIS NETWORK
DONTCHECK="192.168.0.*"

# check if log is not empty : 
isEmpty=`cat ${LOGFILE} | awk '{print $1}' | grep -vE ${DONTCHECK}  | wc -l`
if  [ $isEmpty -eq 0 ]
then 
	echo -e "No acces to web  server for this week\n"

# These Line perform a daily reporting
else
	for i in `cat ${LOGFILE} | awk '{print $4}' | cut -d':' -f 1 | sed 's/^\[\(.*\)\|$/\1/' | sort -u`
	do
		echo -e "############"
		echo $i
		#line=`cat logFile.log | grep $i | grep -vE ${DONTCHECK} | awk '{print $1}' | sort -n | uniq -c | sort -r`
		for j in `cat ${LOGFILE} | grep --color $i | grep -vE ${DONTCHECK} | awk '{print $1}' | sort -n | uniq -c | sort -r`
		do
			nbre=`echo $j | awk '{print $1}'`
			singlIP=`echo $j| awk '{print $2}'`
			echo -e " The host $singlIP tested Plan4 $nbre times"
			echo $singlIP
			wget -U 'Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20100101 Firefox/10.0.2' -O - http://geoiptool.com/fr/?IP=$singlIP | html2text | grep --color -E "Nom*|Adresse IP:|Pays:" | tail -n+2
			echo -e "\n"
		done
	done
fi
