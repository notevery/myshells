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

mynetall=$(ip route | sed -n '1p;1q')
ifname=$(echo ${mynetall} | awk '{print $5}')
# 判断网卡配置文件是否存在
if [ ! -e "/etc/sysconfig/network-scripts/ifcfg-${ifname}" ]; then
    echo "这个脚本只适合redhat系列的发行版，比如centos。"
    ./Get_Dist_Name.sh
    exit 1
fi

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
netconf="/etc/sysconfig/network-scripts/ifcfg-${ifname}"

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
    if grep -q IPADDR $1;then
        echo "1、you have static ip already"
    else
        echo -e "\\nIPADDR=${myip}" >> $1
    fi
    #判断有没有子网掩码
    if grep -q NETMASK $1;then
        echo "2、you have NETMASK already"
    else
        echo -e "\\nNETMASK=${mynetmask}" >> $1
    fi
    #判断有没有网管
    if grep -q GATEWAY $1;then
        echo "3、you have GATEWAY already"
    else
        echo -e "\\nGATEWAY=${mygateway}" >> $1
    fi
    #判断有没有dns
    if grep -q DNS $1;then
        echo "3、you have DNS already"
    else
        echo -e "\\nDNS1=${mygateway}" >> $1
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

