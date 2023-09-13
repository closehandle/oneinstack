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
