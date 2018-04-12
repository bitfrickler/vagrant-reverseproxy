#!/bin/bash

systemctl stop nginx.service

rm -r /etc/nginx
#cp -r /vagrant/src/nginx/* /etc/nginx/
ln -s /vagrant/src/nginx /etc/nginx
chmod -R 755 /etc/nginx

systemctl start nginx.service