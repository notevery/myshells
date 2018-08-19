#!/bin/bash
# Program:
#     当新建了一个本地虚拟机，来设置静态ip
# History:
# 2018/08/18 leaderjs First release


# 把需要的脚本加入到path中
PATH=/bin:/sbin:/usr/bin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 把需要的脚本都复制到~/bin下
#cp ./*.sh ~/bin/


#grep -E "IPADDR|BOOTPROTO|ONBOOT"  /etc/sysconfig/network-scripts/ifcfg-${ifname}

# 取dhcp分配的ip和子网掩码
myip24="$(ip a | grep 192.168 | awk '{print $2}')"
myip=$(echo ${myip24%/*})
mynetmask=$(echo ${myip24#*/})

# 取route信息第一行
mynetall=$(ip route | sed -n '1p;1q')

# 取到网关
mygateway=$(echo ${mynetall} | awk '{print $3}')

# 取到网卡名
ifname=$(echo ${mynetall} | awk '{print $5}')

# 网卡配置文件
netconf=$(find /etc/ -name "*${ifname}")
echo "i find $netconf"

# 修改网卡信息,第一个参数网卡的配置文件
changeNet(){
    echo "开始修改网卡信息: $1";
    cat <<EOF
################################################################################
##                                                                            ##
##                           开始修改网卡信息                                 ##
                          $1                                                
################################################################################
EOF
    sed -i 's/BOOTPROTO=dhcp/BOOTPROTO=static/g' $1
    sed -i 's/ONBOOT=no/ONBOOT=yes/g' $1
    #判断有没有静态ip
       sleep 0.5
    if grep -q IPADDR $1;then
        echo "1、you have static ip already"
    else
        echo -e "IPADDR=${myip}" >> $1
        echo "ip配置成功"
    fi
    #判断有没有子网掩码
       sleep 0.5
    if grep -q NETMASK $1;then
        echo "2、you have NETMASK already"
    else
        echo -e "NETMASK=${mynetmask}" >> $1
        echo "netmask配置成功"
    fi
    #判断有没有网管
       sleep 0.5 
    if grep -q GATEWAY $1;then
        echo "3、you have GATEWAY already"
    else
        echo -e "GATEWAY=${mygateway}" >> $1
        echo "gateway配置成功"
    fi
    #判断有没有dns
       sleep 0.5
    if grep -q DNS $1;then
        echo "4、you have DNS already"
    else
        echo -e "DNS1=${mygateway}" >> $1
        echo "dns配置成功"
    fi
    cat <<EOF
################################################################################
##                                                                            ##
##                           网卡信息修改成功                                 ##
                          $1                                                
################################################################################
EOF

    cat $1
}


changeNet $netconf
exit 0

