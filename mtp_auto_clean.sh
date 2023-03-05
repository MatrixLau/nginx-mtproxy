#获取容器id
ID=$(docker ps -f name=nginx-mtproxy --quiet)
#获取在宿主机的绝对目录
list=$(docker inspect --format='{{.GraphDriver.Data.MergedDir}}' $ID)/etc/nginx/ip_white.conf
#清空IP白名单
cat /dev/null > $list
#重启服务
docker restart nginx-mtproxy






