# Nginx-Proxy-Manager-with-MariaDB
# 🧱 WizardCloud Pi — Nginx Proxy Manager Stack
Modular, reproducible deployment of Nginx Proxy Manager with MariaDB backend, custom Docker network, static IPs, and branded proxy routing.

---
# Layout- Network, Volumes, Database, and NPM Frontend
---
## 📦 Setup 1: Network

```bash
# Create custom Docker network
docker network create \
  --driver bridge \
  --subnet 10.10.10.0/24 \
  --gateway 10.10.10.1 \
  npm-net
---
# 📦 Setup 2:  Volumes
docker volume create npm-app-data
docker volume create npm-app-letsencrypt
---
# 📦 Step 3: Deploy MariaDB
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
---
# 📦 Step 4: Deploy NPM Frontend
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

---
## 🔐 Access Dashboard
# URL: http://192.168.40.20:8051
# Login: admin@example.com / changeme
# Change credentials immediately.
