# oneinstack
安装指令
```bash
# 初始化配置文件
./src/nginx/create.sh

# 创建并启动容器
docker compose up --pull always --detach --force-recreate
```

创建虚拟主机步骤
```bash
# 复制模板配置
cp /etc/nginx/vhost.conf /etc/nginx/vhost/example.com.conf

# 编辑配置文件
nano /etc/nginx/vhost/example.com.conf

# 重启容器
docker container restart nginx
```

默认的日志存放位置
```
/data/wwwlogs
```

默认的网站数据存放位置
```
/data/wwwroot
```
