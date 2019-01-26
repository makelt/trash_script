#!/bin/bash
#自动连接无线网卡,并加入一些路由

wlanInit()
{

wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf
killall dhclient
dhclient wlan0

}

wlanInit
sleep 3
wlanRoute=`ip address show wlan0 |grep inet|grep -v inet6|awk '{print $4}'`
[[ -z $wlanRoute  ]]&& echo "获取Wlan口Ip失败!" >&2 &&exit 1
wlanRoute=${wlanRoute%.*}".1"
uproute(){
for ip in `cat ./routes`;do
    #isIp=`expr index $ip '#'`
    isIp=`echo "$ip" |grep -s '\#'`
    #echo $isIp
    if [ $isIp > 0 ];then
          echo "跳过$ip"
          continue
    fi
    echo "添加${ip}到路由表中使用的网关是 $wlanRoute"
    route add -host $ip gw $wlanRoute
    sleep .2
done
}

if [ "$1" == "uproute" ];then
    uproute
    exit 0
fi

sleep 1
route del -net 0.0.0.0 gw 176.19.8.1 
sleep .2
route del -net 0.0.0.0 gw $wlanRoute
sleep .2
route add -net 0.0.0.0 gw $wlanRoute
sleep .2
#route add -net 0.0.0.0 gw 176.19.8.1 
route add default gw 176.19.8.1
uproute
