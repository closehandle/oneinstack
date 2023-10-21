# oneinstack
LNMP in Docker

```
docker container run \
    --ip 192.168.88.? \
    --env TZ=Asia/Shanghai \
    --name adguard \
    --detach \
    --volume /etc/nginx/ssl:/etc/nginx/ssl \
    --volume adguard:/opt/adguardhome/conf \
    --network oneinstack \
    --restart always \
    --hostname adguard \
    adguard/adguardhome:latest
```

```
docker container run \
    --ip 192.168.88.? \
    --env TZ=Asia/Shanghai \
    --env MYSQL_HOST=192.168.88.254 \
    --env MYSQL_USER=? \
    --env MYSQL_PASSWORD=? \
    --env MYSQL_DATABASE=? \
    --env NEXTCLOUD_ADMIN_USER=? \
    --env NEXTCLOUD_ADMIN_PASSWORD=? \
    --env NEXTCLOUD_TRUSTED_DOMAINS=example.com \
    --env REDIS_HOST=192.168.88.250 \
    --name nextcloud \
    --detach \
    --volume nextcloud:/var/www/html \
    --network oneinstack \
    --restart always \
    --hostname nextcloud \
    nextcloud
```

```
docker container run \
    --ip 192.168.88.? \
    --env TZ=Asia/Shanghai \
    --env DATABASE_URL='mysql://user:pass@192.168.88.254:3306/dbname' \
    --env ROCKET_WORKERS=32 \
    --env ROCKET_ADDRESS=0.0.0.0 \
    --env ROCKET_PORT=8444 \
    --env ROCKET_TLS='{certs="/etc/nginx/ssl/default.crt",key="/etc/nginx/ssl/default.key"}' \
    --env DISABLE_ADMIN_TOKEN=false \
    --name vaultwarden \
    --detach \
    --volume /etc/nginx/ssl:/etc/nginx/ssl \
    --volume vaultwarden:/data \
    --network oneinstack \
    --restart always \
    --hostname vaultwarden \
    vaultwarden/server:latest
```

```
docker container run \
    --ip 192.168.88.? \
    --env TZ=Asia/Shanghai \
    --env WORDPRESS_DB_HOST=mariadb:3306 \
    --env WORDPRESS_DB_USER=? \
    --env WORDPRESS_DB_PASSWORD=? \
    --env WORDPRESS_DB_NAME=? \
    --name wordpress \
    --detach \
    --volume wordpress:/var/www/html \
    --network oneinstack \
    --restart always \
    --hostname wordpress \
    wordpress
```
