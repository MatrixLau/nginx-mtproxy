#!/bin/bash                                                                                                  
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin

read -e -p "请输入MTP白名单添加网页端口(默认80) :" nport
if [[ -z "${nport}" ]]; then
nport="80"
fi

read -e -p "请输入MTP链接端口(默认443) :" port
if [[ -z "${port}" ]]; then
port="443"
fi

read -e -p "请输入密码(默认随机生成) :" secret
if [[ -z "${secret}" ]]; then
secret=$(cat /proc/sys/kernel/random/uuid |sed 's/-//g')
echo -e "密码："
echo -e "$secret"
fi

read -e -p "请输入伪装域名(默认www.microsoft.com) :" domain
if [[ -z "${domain}" ]]; then
domain="www.microsoft.com"
fi

read -e -p "请输入可访问IP(1.单IP白名单 2.IP段白名单 3.不设置[默认]):" iplist
case $iplist in
    1) 
    iplist="IP"
    ;;
    2)
    iplist="IPSEG"
    ;;
    *)
    iplist="OFF"
    ;;
esac
# echo "选择了$iplist模式~"

read -rp "你需要TAG标签吗(Y/N): " chrony_install
    [[ -z ${chrony_install} ]] && chrony_install="Y"
    case $chrony_install in
    [yY][eE][sS] | [yY])
        read -e -p "请输入TAG:" tag
        if [[ -z "${tag}" ]]; then
        echo "请输入TAG"
        fi
        echo -e "正在安装依赖: Docker... "
        echo y | bash <(curl -L -s https://raw.githubusercontent.com/MatrixLau/nginx-mtproxy/main/docker.sh)
        echo -e "正在安装nginx-mtproxy... "
        docker run --name nginx-mtproxy -d -e tag="$tag" -e secret="$secret" -e domain="$domain" -e ip_white_list="$iplist" -p $nport:80 -p $port:443 ellermister/nginx-mtproxy:latest
        ;;
    *)
    #-v /etc/nginx:/etc/nginx 
echo -e "正在安装依赖: Docker... "
echo y | bash <(curl -L -s https://cdn.jsdelivr.net/gh/xb0or/nginx-mtproxy@main/docker.sh)

echo -e "正在安装nginx-mtproxy... "
docker run --name nginx-mtproxy -d -e secret="$secret" -e domain="$domain" -e ip_white_list="$iplist" -p $nport:80 -p $port:443 ellermister/nginx-mtproxy:latest
        ;;
    esac



echo -e "正在设置开机自启动... "
docker update --restart=always nginx-mtproxy
# echo -e "输入 docker logs nginx-mtproxy 获取链接信息"

    public_ip=$(curl -s http://ipv4.icanhazip.com)
    [ -z "$public_ip" ] && public_ip=$(curl -s ipinfo.io/ip --ipv4)
    domain_hex=$(xxd -pu <<< $domain | sed 's/0a//g')
    client_secret="ee${secret}${domain_hex}"
    echo -e "服务器IP：\033[31m$public_ip\033[0m"
    echo -e "服务器端口：\033[31m$port\033[0m"
    echo -e "MTProxy Secret:  \033[31m$client_secret\033[0m"
    echo -e "TG认证地址：http://${public_ip}:${nport}/add.php"
    echo -e "TG一键链接: https://t.me/proxy?server=${public_ip}&port=${port}&secret=${client_secret}"
