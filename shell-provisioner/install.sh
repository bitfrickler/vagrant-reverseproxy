#!/bin/bash

yum check-update
yum -y update
yum -y install epel-release

yum -y install yum-utils
yum -y install wget
yum groupinstall -y 'Development Tools'

# dependencies for nginx
yum -y install perl perl-devel perl-ExtUtils-Embed libxslt libxslt-devel libxml2 libxml2-devel gd gd-devel GeoIP GeoIP-devel lua-devel pcre-devel openssl-devel

cd /tmp
wget https://nginx.org/download/nginx-1.14.0.tar.gz -O nginx.tar.gz
wget https://github.com/simpl/ngx_devel_kit/archive/v0.3.0.tar.gz -O ngx_devel_kit.tar.gz
wget https://github.com/openresty/set-misc-nginx-module/archive/v0.32.tar.gz -O set-misc-nginx-module.tar.gz
wget https://github.com/calio/form-input-nginx-module/archive/v0.12.tar.gz -O form-input-nginx-module.tar.gz
wget https://github.com/openresty/encrypted-session-nginx-module/archive/v0.08.tar.gz -O encrypted-session-nginx-module.tar.gz
wget https://github.com/openresty/lua-nginx-module/archive/v0.10.13.tar.gz -O lua-nginx-module.tar.gz
wget https://github.com/openresty/headers-more-nginx-module/archive/v0.33.tar.gz -O headers-more-nginx.tar.gz

mkdir -p nginx && tar -xzvf nginx.tar.gz --directory=nginx --strip-components=1
mkdir -p ngx_devel_kit && tar -xzvf ngx_devel_kit.tar.gz --directory=ngx_devel_kit --strip-components=1
mkdir -p set-misc-nginx-module && tar -xzvf set-misc-nginx-module.tar.gz --directory=set-misc-nginx-module --strip-components=1
mkdir -p form-input-nginx-module && tar -xzvf form-input-nginx-module.tar.gz --directory=form-input-nginx-module --strip-components=1
mkdir -p encrypted-session-nginx-module && tar -xzvf encrypted-session-nginx-module.tar.gz --directory=encrypted-session-nginx-module --strip-components=1
mkdir -p lua-nginx-module && tar -xzvf lua-nginx-module.tar.gz --directory=lua-nginx-module --strip-components=1
mkdir -p headers-more-nginx && tar -xzvf headers-more-nginx.tar.gz --directory=headers-more-nginx --strip-components=1

cd nginx

mkdir -p /var/lib/nginx/body
mkdir -p /var/cache/ngin
mkdir -p /usr/share/nginx/html
ln -s /usr/lib64/nginx/modules /usr/share/nginx/modules

./configure --add-module=../headers-more-nginx --with-cc-opt='-g -O2 -fPIE -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2' --with-ld-opt='-Wl,-Bsymbolic-functions -fPIE -pie -Wl,-z,relro -Wl,-z,now' --prefix=/usr/share/nginx --sbin-path=/usr/sbin --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-pcre-jit --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_addition_module --with-http_dav_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_sub_module --add-module=../ngx_devel_kit --add-module=../set-misc-nginx-module --add-module=../form-input-nginx-module --add-module=../encrypted-session-nginx-module --add-module=../lua-nginx-module
make -j2
make install

useradd --system --home /var/cache/nginx --shell /sbin/nologin --comment "nginx user" --user-group nginx
cp /vagrant/shell-provisioner/nginx.service /usr/lib/systemd/system/

yum -y install haproxy incron

if [ ! -e /vagrant/src/nginx/nginx.conf ]; then
    cp /etc/nginx/nginx.conf /vagrant/src/nginx/
fi

if [ ! -e /vagrant/src/haproxy/haproxy.cfg ]; then
    cp /etc/haproxy/haproxy.cfg /vagrant/src/haproxy/
fi

# if [ "$(find /vagrant/src/html -type f -printf 1 | wc -m)" -eq 1 -a "$(basename $(find /vagrant/src/html -type f))" = ".keep" ]; then
#     cp -r /usr/share/nginx/html/* /vagrant/src/html
# fi

mkdir -p /etc/ssl/private
mkdir /etc/ssl/mycerts
chmod 700 /etc/ssl/private

cp /vagrant/shell-provisioner/nginx.incron /etc/incron.d/nginx.conf
cp /vagrant/shell-provisioner/reload_nginx.sh /reload_nginx.sh && chmod +x /reload_nginx.sh

systemctl enable nginx.service
systemctl enable haproxy.service
systemctl enable incrond.service

systemctl start nginx.service
systemctl start haproxy.service
systemctl start incrond.service
