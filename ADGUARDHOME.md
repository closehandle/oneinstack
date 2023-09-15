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
