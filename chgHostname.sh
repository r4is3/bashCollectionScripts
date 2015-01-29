#!/bin/bash
# -*- coding:UTF8 -*-

## @author : r4is3 / r4is3@w0rld.fr
## 2015 and ever

## This is usefull is case you have virtual servers templates and you want users ca change hostname.
## To do that please edit sudoers : 
## echo -e "ALL ALL=(ALL) NOPASSWD:/etc/chgHostname" >> /etc/sudoers
    
echo -e "Please enter the new hostname : "
read hostName
hostname ${hostName}
hostname
## Change hostname and configure dhcp client to send it when requests IP
echo -e "send host-name ${hostName};" >> /etc/dhcp/dhclient-eth0.conf
echo -e "DHCP_HOSTNAME=${hostName}" >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo -e "HOSTNAME=${hostName}\nDHCP_HOSTNAME=${hostName}" >> /etc/sysconfig/network
## Hard way to change hostname
echo ${hostName} > /proc/sys/kernel/hostname 
## Remove this script to avoid security breach
rm -rvf $0 >> /root/logHostname
## Remove line in sudoers to avoid security beach
sed -i '/chgHostname/d' /etc/sudoers
## Easiest way to apply when you're user :)
reboot

