#!/bin/bash

systemctl stop haproxy.service

rm -rf /etc/haproxy
#cp -r /vagrant/src/nginx/* /etc/nginx/
ln -s /vagrant/src/haproxy /etc/haproxy
chmod -R 755 /etc/haproxy

systemctl start haproxy.service