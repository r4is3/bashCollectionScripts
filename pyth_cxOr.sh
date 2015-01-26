#!/bin/bash
# -*- coding:UTF8 -*-
    
#########################################################################################
##											#
#	This script proceed python2.7 install on RHEL-like (including CentOS)		#
#	It install some libraries usefull for prod, see documention for details		#
#	@author r4is3@w0rld.fr        								#
##											#
#########################################################################################


function PyVers()
## This is usefull ti check which version to recompile
{
	vers=$(python -V 2>&1)
	echo $vers | awk '{print $2}'
}



# Lib for compress support and ssl in python2.7 beware installing BEFORE compiling Python 2.7
yum -y install zlib zlib-devel openssl openssl-devel

cd /tmp
# Please check if wget is installed
# Download source

echo -e "Does you system have python 2.7 already installed?"
read answer
case $answer in
	[y/Y]*)
		version=`PyVers`
		;;
	[n/N]*)
		version='2.7.2'
		;;
	*)
		echo -e "Your answer is not clear, please run this script again"
		exit 1
		;;
esac
version=`PyVers`
echo -e "OK, you're about to [re]compile python-${version}"
wget --no-check-certificate -O - https://www.python.org/ftp/python/${version}/Python-${version}.tgz | tar xvvzf -
#wget -O - http://www.python.org/ftp/python/2.7.2/Python-2.7.2.tgz | tar xvvzf - 
cd Python-${version} 
./configure --with-zlib=/usr/include --with-ssl && make && make install

echo -e "\npython ${version} [re]compiled, next step is a PIP SHOW\n"
sleep 5

# Then we want to install pip

## THIS IS OLDER WAY
#wget --no-check-certificate -O - https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz | tar xvvzf -
#cd setuptools-1.4.2

# new way : 
wget --no-check-certificate  https://bootstrap.pypa.io/ez_setup.py

if python2.7 ez_setup.py;
then
	curl https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py | python2.7 -
else
	echo -e 'please check your python install and/or install log\n'
fi

## Install cxOracle
## to do check glic version : ldd --version | head -n1 | grep -o -e '[[:digit:]]{1}\.[[:digit:]]{1,2}'
##	/!\ BEWARE THIS THIS DOES NOT CHECK GLIBC VERSION /!\ ##
##	/!\ IF IT'S TO OLD CX_ORACLE WON'T WORK		  /!\ ##
##

echo -e "Enter user who runs oracle instant client : "
read user

# This this line does not work replace with the 2 lines folowing
#$(grep -E 'ORACLE_HOME=' `cat /etc/passwd | grep oracle | cut -d':' -f 6`/.bashrc)
## Test environnement variable to export in order to processed installation successfully
if [[ -z $(grep -E 'ORACLE_HOME=' `cat /etc/passwd | grep $user | cut -d':' -f 6`/.bashrc)  ]]
then 
	$(grep -E 'DBCLIENT_HOME=' `cat /etc/passwd | grep $user | cut -d':' -f 6`/.bashrc)
#	export LD_LIBRARY_PATH=$DBCLIENT_HOME
	echo "Setting this env variable : $(grep -E 'DBCLIENT_HOME=' `cat /etc/passwd | grep $user | cut -d':' -f 6`/.bashrc)"
	export ORACLE_HOME=$DBCLIENT_HOME
else 
	$(grep -E 'ORACLE_HOME=' `cat /etc/passwd | grep $user | cut -d':' -f 6`/.bashrc)
	echo "Setting This env variable : $(grep -E 'ORACLE_HOME=' `cat /etc/passwd | grep $user | cut -d':' -f 6`/.bashrc)"
	export LD_LIBRARY_PATH=$ORACLE_HOME/lib
	echo $ORACLE_HOME
	export $ORACLE_HOME
fi

# Install module
pip install cx_Oracle
chmod -R 755 /usr/local/lib/python2.7/site-packages/
su -c 'sed -i "/ORACLE_HOME=/ a\export LD_LIBRARY_PATH=\${ORACLE_HOME}/lib" ~/.bashrc' $user
#su -c 'sed -i "/DBCLIENT_HOME=/ a\export LD_LIBRARY_PATH=\${DBCLIENT_HOME}" ~/.bashrc' $user

echo "FINISHED, CONGRATULATIONS!"
