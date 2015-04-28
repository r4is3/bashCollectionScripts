#!/bin/bash

# This script check some hardware parametre of server and display info as csv


IFS=$'\r\n'
NAME=$(hostname)
# Number of CPU
j=0
for i in $(grep processor /proc/cpuinfo);do let j++;done
NBRCPU=$j
# Frequency
FREQUENCY=$(grep 'model name' /proc/cpuinfo | uniq | awk '{print  $9}')
var=`grep MemTotal /proc/meminfo | awk '{print $2}'`
# Amount of RAM
RAM=$(( ${var%% *} / 1048576))
# Disk size and space available
HDSIZE=$(fdisk -l | grep Dis[quesk] | awk '{print $3}')
HDLIVE=$(df | grep '^/dev/[hs]d' | awk '{s+=$2} END {print s/1048576}')
# displaying info
echo -e "$NAME;$NBRCPU cpu;$FREQUENCY;$RAM Go; $HDSIZE Go;$HDLIVE Go"
