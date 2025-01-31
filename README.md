# nginx-mtproxy
## 此脚本基于[https://hub.docker.com/r/ellermister/nginx-mtproxy](https://hub.docker.com/r/ellermister/nginx-mtproxy)和[https://github.com/ellermister/mtproxy](https://github.com/ellermister/mtproxy)和[原脚本仓库](https://github.com/xb0or/nginx-mtproxy)修改


## 一键脚本
**使用脚本前请确认curl已安装**
```
bash <(curl -sSL "https://raw.githubusercontent.com/MatrixLau/nginx-mtproxy/main/mtp.sh")
```
或者
```
bash <(curl -sSL "https://cdn.jsdelivr.net/gh/MatrixLau/nginx-mtproxy@main/mtp.sh")
```

## 其他命令

### 白名单控制脚本（实验）

**不保证可以成功使用，推荐进入docker内修改/etc/nginx/ip_white.conf 内容**

```
bash <(curl -sSL "https://raw.githubusercontent.com/MatrixLau/nginx-mtproxy/main/mtp2.sh")
```

### 白名单清理脚本（实验）

**由上面脚本中抽离出清理的内容，配置*crontab*实现定时清理白名单**

```
curl -sSL "https://raw.githubusercontent.com/MatrixLau/nginx-mtproxy/main/mtp_auto_clean.sh" > mtp_auto_clean.sh
```
配合**CronTab** 实现定时清空IP
```
0 6 * * 2,4,6 bash /root/mtp_auto_clean.sh
```


### Stop service / 停止服务

```
docker stop nginx-mtproxy
```

### Start service / 启动服务

```
docker start nginx-mtproxy
```

### Restart service / 重启服务

```
docker restart nginx-mtproxy
```

### Delete service / 删除服务

```
docker rm nginx-mtproxy
```

### Auto Run / 开机自启

```
docker update --restart=always nginx-mtproxy
```
