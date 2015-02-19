#!/bin/bash
# -*- coding:UTF8 -*-
    
## Provide portknocking feature with iptables.
## Port can be changed

## This rule create a new list entry (named portknock) which contains source IP an corresponding timestamp of hos that triggered the rule (here it's just a tcp packt to port 3456)
iptables -A INPUT -p tcp --dport 3456 -m recent --set --name portknock
## This rule send matching packet to LOG file and prefix every line
iptables -A INPUT -p tcp --dport 3456 -j LOG --log-prefix="IPTABLES KNOCKING" --log-level 4
## This rule check if the source IP on the packet (tcp syn) is present on the named list for the last 60 seconds and if it is, accept connection to specified port
iptables -A INPUT -p tcp --syn --dport 22 -m recent --rcheck --seconds 60 --name portknock -j ACCEPT
## This rule log every connection to destination port 22 into log file an prefix lines
iptables -A INPUT -p tcp --dport 22 -j LOG --log-prefix="IPTABLES SSH" --log-level 4
## Finally drop every connection that are not matching previous rules
iptables -A INPUT -p tcp --syn --dport 22 -j DROP


