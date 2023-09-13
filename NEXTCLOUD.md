```
docker container run \
    --ip 192.168.88.? \
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
