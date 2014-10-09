#!/bin/bash
# -*- coding:UTF8 -*-
    

function checkBasics()
{
## Check Prerequisities
aptitude update && aptitude -y install build-essential
}
## Create user who will run app
function createUser()
{
	groupadd --system ghost
	adduser --quiet --system --shell /bin/sh --ingroup ghost --disabled-password --home /var/www ghost
}

function nodeInstall()
{	
## Provide install of nodejs from latest sources
	aptitude update && aptitude install -y build-essential
	cd /tmp
	wget -O - http://nodejs.org/dist/v0.10.31/node-v0.10.31.tar.gz | tar xvvzf -
	cd node-v0.10.31/
	./configure && make && make install
	if which node
	then
		chmod 755 `which node`
		chmod 755 `which npm`
		echo -e 'Nodejs correctly installed'
	else
		echo -e 'A problem occured, please check manually'
		exit 1
	fi
}

function ghostInstall()
{
## this is installation of Ghost with node package manager
## There is installation of init script and configuration 
	if [ -d /var/www ]
	then 
		cd /var/www
	else 
		mkdir -p /var/www && cd /var/www
	fi
	npm update
	npm install --production ghost
	# config ghost to provide https url for admin section : 
	#mv /var/www/node_modules/ghost/config.js /var/www/node_modules/ghost/config.js.orig
	sed -i '/mail: {},/ i\ forceAdminSSL: true,' /var/www/node_modules/ghost/config.js
	chown -R ghost:ghost /var/www/*
	## install init script
	wget --no-check-certificate -O /etc/init.d/ghost https://raw.githubusercontent.com/r4is3/bashCollectionScripts/master/ghost
	nodePath=`which node`
	echo -e "PATH POUR NODE : $nodePath"
	nodeRoot="/var/www/node_modules/ghost/"
	echo -e "PATH POUR GHOST : $nodeRoot"
	sed -i "/^GHOST_ROOT/ c\GHOST_ROOT=$nodeRoot" /etc/init.d/ghost
	sed -i "/^DAEMON=/ c\DAEMON=$nodePath" /etc/init.d/ghost
	chmod 755 /etc/init.d/ghost
	update-rc.d ghost defaults
	echo -e "Ok, you can try to start ghost with /etc/init.d/ghost start"
}

function installReverseProxy()
{	
## This function proceed installation of nginx, host config file 
## Now it prompts for domain name 
#### /!\ Change prompt to pass arg in parameter /!\ ####
	aptitude install -y nginx
	rm /etc/nginx/sites-enabled/*
	wget --no-check-certificate -O /etc/nginx/sites-enabled/ghost https://raw.githubusercontent.com/r4is3/bashCollectionScripts/master/nginxGhost
	echo -e 'Please enter your domain name'
	read domainName
	sed -i "/server_name/ c\server_name $domainName" /etc/nginx/sites-enabled/ghost
	echo -e	"Reverse proxy is now install, please visite : ${domainName}/ghost"

}

function rollback()
{
## Rollback to state before install
## rm files, directory and users

	etc/init.d/ghost stop && /etc/init.d/nginx stop
	deluser ghost && rm -rf /var/www/ && rm -rf /usr/local/bin/{node,npm} && rm -rf /etc/init.d/ghost && aptitude remove --purge nginx
}


checkBasics
createUser
nodeInstall
ghostInstall
installReverseProxy
