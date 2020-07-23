#!/bin/bash

set -ex -o pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get -qq update
apt-get install -yqq nginx

rm /var/www/html/*
gsutil cp gs://${bucket}/${file} /var/www/html/

cat <<EOF > /etc/nginx/nginx.conf
worker_processes auto;
user nginx;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

events {
  worker_connections 1024;
}

http {
  server {
    listen 80;
    server_name _;
    root /var/www/html;
  }
}
EOF

systemctl enable nginx.service
systemctl start nginx.service
