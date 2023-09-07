#!/usr/bin/env bash
cd $(dirname "$0")
apt install jq -y || exit $?

docker network create --subnet 192.168.88.0/24 oneinstack || exit $?

mkdir -p /data/wwwlogs
mkdir -p /data/wwwroot/default

./src/mariadb-10.11/create.sh || exit $?
./src/php-8.2/create.sh || exit $?
./src/nginx/create.sh || exit $?

clear
sleep 3
SUBNET=$(docker network inspect oneinstack | jq -r '.[0].IPAM.Config[0].Subnet')
NGINXIP=$(docker container inspect nginx | jq -r '.[0].NetworkSettings.Networks.oneinstack.IPAddress')
MARIADBIP=$(docker container inspect mariadb | jq -r '.[0].NetworkSettings.Networks.oneinstack.IPAddress')
echo '[+] Subnet      :' $SUBNET
echo '[+] Web Server  :' $NGINXIP
echo '[+] DB Hostname :' $MARIADBIP
echo '[+] DB Password'   $(docker container logs mariadb 2>&1 | grep 'GENERATED ROOT PASSWORD' | awk -F'GENERATED ROOT PASSWORD' '{print $2}')
echo
echo "[+] By default, docker's manipulation of iptables is disabled."
echo "[+] So, don't forget to manually configure the iptables NAT rules!"
echo "[+] iptables -t nat -A POSTROUTING -s $SUBNET -j MASQUERADE"
echo
echo '[+] The nginx ports are not exposed by default, you need to configure iptables DNAT manually.'
echo "[+] iptables -t nat -A PREROUTING -d 1.1.1.1/32 -p tcp -m tcp --dport 80 -j DNAT --to-destination $NGINXIP:80"
echo "[+] iptables -t nat -A PREROUTING -d 1.1.1.1/32 -p tcp -m tcp --dport 443 -j DNAT --to-destination $NGINXIP:443"
echo "[+] Replace 1.1.1.1 with your server's IP address"

mkdir -p /etc/docker
cp -f etc/docker/daemon.json /etc/docker/daemon.json
systemctl restart docker
exit 0
