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
