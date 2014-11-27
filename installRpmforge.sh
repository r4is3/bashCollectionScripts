#!/bin/bash
# -*- coding:UTF8 -*-

## INstall and enable yum priorities
yum install -y yum-priorities
sed -i 's/0/1/' /etc/yum/pluginconf.d/priorities.conf

## add priority  for each repository
sed -i '/\[[a-z*]*\]/ a\priority=1' /etc/yum.repos.d/CentOS-Base.repo
cd /tmp/
wget http://apt.sw.be/redhat/el5/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm
rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
rpm -K rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm
rpm -i rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm
yum check-update
