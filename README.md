# oneinstack
一键安装指令
```bash
./create.sh
```

默认的容器地址
```
nginx: 192.168.88.100
php-fpm: 192.168.88.110 - 192.168.88.114
mariadb: 192.168.88.254
```

创建虚拟主机步骤
```bash
cd /etc/nginx
mkdir vhost

cp -f vhost.conf vhost/example.com.conf
nano vhost/example.com.conf
```

默认的日志存放位置
```
/data/wwwlogs
```

默认的网站数据存放位置
```
/data/wwwroot
```

默认没有发布任何端口，如需发布 80 443 这些，你需要关闭 Docker 的 iptables 修改然后自行编写规则
```bash
apt update
apt install netfilter-persistent iptables-persistent ipset-persistent -y

cp -f etc/docker/daemon.json /etc/docker/daemon.json
cp -f etc/iptables/rules.* /etc/iptables

nano /etc/iptables/rules.v4
nano /etc/iptables/rules.v6

systemctl restart docker
netfilter-persistent reload
```
通常情况下，在上述指令中的 `nano /etc/iptables/rules.v4` 步骤时，将其中的 `1.1.1.1` 修改为你的网卡 IPv4 地址即可
