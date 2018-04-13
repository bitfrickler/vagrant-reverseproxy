#!/bin/bash

#disable SELINUX
#setenforce 0
#sed -i 's/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/g' /etc/sysconfig/selinux

#yum -y update
yum -y install epel-release
yum -y install haproxy nginx