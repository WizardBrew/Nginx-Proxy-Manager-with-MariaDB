#!/bin/bash

# WizardCloud Pi — NPM Stack Automation
# Author: Parvez Mustak
# Date: 25 Sep 2025

echo "🔧 Creating Docker network..."
docker network create \
  --driver bridge \
  --subnet 10.10.10.0/24 \
  --gateway 10.10.10.1 \
  npm-net

echo "📦 Creating volumes..."
docker volume create npm-app-data
docker volume create npm-app-letsencrypt

echo "🧱 Deploying MariaDB container..."
docker run -d \
  --name npm-db \
  --network npm-net \
  --ip 10.10.10.10 \
  --restart unless-stopped \
  -e MYSQL_ROOT_PASSWORD=rootpass \
  -e MYSQL_DATABASE=npm \
  -e MYSQL_USER=npmuser \
  -e MYSQL_PASSWORD=npmuserpass \
  mariadb:10.5

echo "🚀 Deploying Nginx Proxy Manager container..."
docker run -d \
  --name npm-app \
  --network npm-net \
  --ip 10.10.10.20 \
  --restart unless-stopped \
  -p 8051:81 \
  -p 80:80 \
  -p 443:443 \
  -e DB_MYSQL_HOST=10.10.10.10 \
  -e DB_MYSQL_PORT=3306 \
  -e DB_MYSQL_USER=npmuser \
  -e DB_MYSQL_PASSWORD=npmuserpass \
  -e DB_MYSQL_NAME=npm \
  -v npm-app-data:/data \
  -v npm-app-letsencrypt:/etc/letsencrypt \
  jc21/nginx-proxy-manager:2.12.6

echo "✅ Stack deployed successfully!"
echo "🌐 Access dashboard at: http://192.168.40.20:8051"
echo "🔐 Login: admin@example.com / changeme"
