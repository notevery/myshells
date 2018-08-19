#!/bin/bash
cp staticNet.sh ~/bin/
#!/bin/bash
# Program:
#     用来设置静态ip, 只适合RHEL或Centos。
# 1、先检查发行版本，不支持的版本就退出
# 2、再检查是否已经配置了静态ip，配了就退出
# History:
# 2018/08/18 leaderjs First release


# 把需要的脚本加入到path中
PATH=/bin:/sbin:/usr/bin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 把需要的脚本都复制到~/bin下
cp ./*.sh ~/bin/

# 判断网卡配置文件是否存在
if [ -a /etc/sysconfig/network-scripts/ifcfg-${ifname} ]; then
    echo "这个脚本只适合redhat系列的发行版，比如centos。"
    ./Get_Dist_Name.sh
    exit 1
fi
# 取到dhcp分配的ip和子网掩码
ifname=$(echo ${mynetall} | awk '{print $5}')
# 检测是redhat系的系统还是ubuntu还是啥系统
haveStaticIp=$(cat /etc/sysconfig/network-scripts/${ifname} | grep IPADDR)
#如果配置了静态IP，就退出
if [ -n haveStaticIp ];then
    echo "You have configured the static IP."
    exit 1
fi

myip24="$(ip a | grep 192.168 | awk '{print $2}')"
myip=$(echo ${myip24%/*})
mynetmask=$(echo ${myip24#*/})

# 取route信息第一行
mynetall=$(ip route | sed -n '1p;1q')

# 取到网关
mygateway=$(echo ${mynetall} | awk '{print $3}')

# 取到网卡名
ifname=$(echo ${mynetall} | awk '{print $5}')

echo "开始修改网卡信息";

# 判断网卡配置文件是否存在
#if [ -e "/etc/sysconfig/network-scripts/ifcfg-${ifname}" ];then
#        sed -i 's/BOOTPROTO=dhcp/BOOTPROTO=static/g' /etc/sysconfig/network-scripts/ifcfg-${ifname}
#        sed -i 's/ONBOOT=no/ONBOOT=yes/g' /etc/sysconfig/network-scripts/ifcfg-${ifname}
#        echo -e "IPADDR=${myip}\\nNETMASK=${mynetmask}\\nGATEWAY=${mygateway}\\nDNS1=${mygateway}" >> /etc/sysconfig/network-scripts/ifcfg-${ifname}
#else
#   echo "this script is not suitable for your system, you should ";
#fi

