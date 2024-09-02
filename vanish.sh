#!/bin/bash

log="/tmp/vanish.log"
chmod 777 $log

loging(){
    current_time=$(date +"%Y-%m-%d %H:%M:%S");
    echo "[*] "$current_time ": " $1 >> $log
    echo "[*] "$current_time ": " $1
}

stop_gost(){
    pid=`ps -ef | grep gost | grep -v grep | awk '{print $2}'`
    if [ ! -z "$pid" ]; then
        kill -9 $pid
    fi
    loging "stop GOST ..."
}

mix_proxy(){
    nohup /bin/gost -L "red://:12345?sniffing=true&tproxy=true" -L "redu://:12345?ttl=30s" -F $proxy_add?so_mark=100 >> $log 2>&1 &

    # ipv4
    ip rule add fwmark 1 lookup 100
    ip route add local default dev lo table 100

    iptables -t mangle -N DIVERT
    iptables -t mangle -A DIVERT -j MARK --set-mark 1
    iptables -t mangle -A DIVERT -j ACCEPT
    iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT

    iptables -t mangle -N GOST
    iptables -t mangle -A GOST -p tcp -d 127.0.0.0/8 -j RETURN
    iptables -t mangle -A GOST -p tcp -d 10.0.0.0/8 -j RETURN
    iptables -t mangle -A GOST -p tcp -d 172.16.0.0/12 -j RETURN
    iptables -t mangle -A GOST -p tcp -d 192.168.0.0/16 -j RETURN
    iptables -t mangle -A GOST -p tcp -d 255.255.255.255/32 -j RETURN
    iptables -t mangle -A GOST -p tcp -m mark --mark 100 -j RETURN 
    iptables -t mangle -A GOST -p tcp -j TPROXY --tproxy-mark 0x1/0x1 --on-port 12345 
    iptables -t mangle -A PREROUTING -p tcp -j GOST

    # Only for local mode
    iptables -t mangle -N GOST_LOCAL
    iptables -t mangle -A GOST_LOCAL -p tcp -d 127.0.0.0/8 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p tcp -d 10.0.0.0/8 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p tcp -d 172.16.0.0/12 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p tcp -d 192.168.0.0/16 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p tcp -d 255.255.255.255/32 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p tcp -d 192.168.0.0/16 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p tcp -m mark --mark 100 -j RETURN 
    iptables -t mangle -A GOST_LOCAL -p tcp -j MARK --set-mark 1
    iptables -t mangle -A OUTPUT -p tcp -j GOST_LOCAL

    # ipv6
    ip -6 rule add fwmark 1 lookup 100
    ip -6 route add local default dev lo table 100

    ip6tables -t mangle -N DIVERT
    ip6tables -t mangle -A DIVERT -j MARK --set-mark 1
    ip6tables -t mangle -A DIVERT -j ACCEPT
    ip6tables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT

    ip6tables -t mangle -N GOST
    ip6tables -t mangle -A GOST -p tcp -d ::/128 -j RETURN
    ip6tables -t mangle -A GOST -p tcp -d ::1/128 -j RETURN
    ip6tables -t mangle -A GOST -p tcp -d fe80::/10 -j RETURN
    ip6tables -t mangle -A GOST -p tcp -d ff00::/8 -j RETURN
    ip6tables -t mangle -A GOST -p tcp -m mark --mark 100 -j RETURN 
    ip6tables -t mangle -A GOST -p tcp -j TPROXY --tproxy-mark 0x1/0x1 --on-port 12345 
    ip6tables -t mangle -A PREROUTING -p tcp -j GOST

    # Only for local mode
    ip6tables -t mangle -N GOST_LOCAL
    ip6tables -t mangle -A GOST_LOCAL -p tcp -d ::/128 -j RETURN
    ip6tables -t mangle -A GOST_LOCAL -p tcp -d ::1/128 -j RETURN
    ip6tables -t mangle -A GOST_LOCAL -p tcp -d fe80::/10 -j RETURN
    ip6tables -t mangle -A GOST_LOCAL -p tcp -d ff00::/8 -j RETURN
    ip6tables -t mangle -A GOST_LOCAL -p tcp -m mark --mark 100 -j RETURN 
    ip6tables -t mangle -A GOST_LOCAL -p tcp -j MARK --set-mark 1
    ip6tables -t mangle -A OUTPUT -p tcp -j GOST_LOCAL



    # ipv4
    # ip rule add fwmark 1 lookup 100
    # ip route add local default dev lo table 100

    # iptables -t mangle -N GOST
    iptables -t mangle -A GOST -p udp -d 127.0.0.0/8 -j RETURN
    iptables -t mangle -A GOST -p udp -d 10.0.0.0/8 -j RETURN
    iptables -t mangle -A GOST -p udp -d 172.16.0.0/12 -j RETURN
    iptables -t mangle -A GOST -p udp -d 192.168.0.0/16 -j RETURN
    iptables -t mangle -A GOST -p udp -d 255.255.255.255/32 -j RETURN
    iptables -t mangle -A GOST -p udp -m mark --mark 100 -j RETURN 
    iptables -t mangle -A GOST -p udp -j TPROXY --tproxy-mark 0x1/0x1 --on-port 12345 
    iptables -t mangle -A PREROUTING -p udp -j GOST

    # Only for local mode
    # iptables -t mangle -N GOST_LOCAL
    iptables -t mangle -A GOST_LOCAL -p udp -d 127.0.0.0/8 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p udp -d 10.0.0.0/8 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p udp -d 172.16.0.0/12 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p udp -d 192.168.0.0/16 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p udp -d 255.255.255.255/32 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p udp -m mark --mark 100 -j RETURN 
    iptables -t mangle -A GOST_LOCAL -p udp -j MARK --set-mark 1
    iptables -t mangle -A OUTPUT -p udp -j GOST_LOCAL

    # ipv6
    # ip -6 rule add fwmark 1 lookup 100
    # ip -6 route add local default dev lo table 100

    # ip6tables -t mangle -N GOST
    ip6tables -t mangle -A GOST -p udp -d ::/128 -j RETURN
    ip6tables -t mangle -A GOST -p udp -d ::1/128 -j RETURN
    ip6tables -t mangle -A GOST -p udp -d fe80::/10 -j RETURN
    ip6tables -t mangle -A GOST -p udp -d ff00::/8 -j RETURN
    ip6tables -t mangle -A GOST -p udp -m mark --mark 100 -j RETURN 
    ip6tables -t mangle -A GOST -p udp -j TPROXY --tproxy-mark 0x1/0x1 --on-port 12345 
    ip6tables -t mangle -A PREROUTING -p udp -j GOST

    # Only for local mode
    # ip6tables -t mangle -N GOST_LOCAL
    ip6tables -t mangle -A GOST_LOCAL -p udp -d ::/128 -j RETURN
    ip6tables -t mangle -A GOST_LOCAL -p udp -d ::1/128 -j RETURN
    ip6tables -t mangle -A GOST_LOCAL -p udp -d fe80::/10 -j RETURN
    ip6tables -t mangle -A GOST_LOCAL -p udp -d ff00::/8 -j RETURN
    ip6tables -t mangle -A GOST_LOCAL -p udp -m mark --mark 100 -j RETURN 
    ip6tables -t mangle -A GOST_LOCAL -p udp -j MARK --set-mark 1
    ip6tables -t mangle -A OUTPUT -p udp -j GOST_LOCAL

    loging "mix mode ..."
}

# 测试功能
tcp_inner(){
    nohup /bin/gost -L "red://:12346?sniffing=true&tproxy=true" -F $inner_proxy_add?so_mark=100 >> $log 2>&1 &
    iptables -t mangle -A GOST -p tcp -d $route -j TPROXY --tproxy-mark 0x1/0x1 --on-ip 127.0.0.1 --on-port 12346

    loging "inner mode ..."
}

tcp_proxy(){
    nohup /bin/gost -L "red://:12345?sniffing=true&tproxy=true" -F $proxy_add?so_mark=100 >> $log 2>&1 &

    # ipv4
    ip rule add fwmark 1 lookup 100
    ip route add local default dev lo table 100

    iptables -t mangle -N DIVERT
    iptables -t mangle -A DIVERT -j MARK --set-mark 1
    iptables -t mangle -A DIVERT -j ACCEPT
    iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT

    iptables -t mangle -N GOST
    iptables -t mangle -A GOST -p tcp -d 127.0.0.0/8 -j RETURN
    iptables -t mangle -A GOST -p tcp -d 10.0.0.0/8 -j RETURN
    iptables -t mangle -A GOST -p tcp -d 172.16.0.0/12 -j RETURN
    iptables -t mangle -A GOST -p tcp -d 192.168.0.0/16 -j RETURN
    iptables -t mangle -A GOST -p tcp -d 255.255.255.255/32 -j RETURN
    iptables -t mangle -A GOST -p tcp -m mark --mark 100 -j RETURN 
    iptables -t mangle -A GOST -p tcp -j TPROXY --tproxy-mark 0x1/0x1 --on-port 12345 
    iptables -t mangle -A PREROUTING -p tcp -j GOST

    # Only for local mode
    iptables -t mangle -N GOST_LOCAL
    iptables -t mangle -A GOST_LOCAL -p tcp -d 127.0.0.0/8 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p tcp -d 10.0.0.0/8 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p tcp -d 172.16.0.0/12 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p tcp -d 192.168.0.0/16 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p tcp -d 255.255.255.255/32 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p tcp -d 192.168.0.0/16 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p tcp -m mark --mark 100 -j RETURN 
    iptables -t mangle -A GOST_LOCAL -p tcp -j MARK --set-mark 1
    iptables -t mangle -A OUTPUT -p tcp -j GOST_LOCAL

    # ipv6
    ip -6 rule add fwmark 1 lookup 100
    ip -6 route add local default dev lo table 100

    ip6tables -t mangle -N DIVERT
    ip6tables -t mangle -A DIVERT -j MARK --set-mark 1
    ip6tables -t mangle -A DIVERT -j ACCEPT
    ip6tables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT

    ip6tables -t mangle -N GOST
    ip6tables -t mangle -A GOST -p tcp -d ::/128 -j RETURN
    ip6tables -t mangle -A GOST -p tcp -d ::1/128 -j RETURN
    ip6tables -t mangle -A GOST -p tcp -d fe80::/10 -j RETURN
    ip6tables -t mangle -A GOST -p tcp -d ff00::/8 -j RETURN
    ip6tables -t mangle -A GOST -p tcp -m mark --mark 100 -j RETURN 
    ip6tables -t mangle -A GOST -p tcp -j TPROXY --tproxy-mark 0x1/0x1 --on-port 12345 
    ip6tables -t mangle -A PREROUTING -p tcp -j GOST

    # Only for local mode
    ip6tables -t mangle -N GOST_LOCAL
    ip6tables -t mangle -A GOST_LOCAL -p tcp -d ::/128 -j RETURN
    ip6tables -t mangle -A GOST_LOCAL -p tcp -d ::1/128 -j RETURN
    ip6tables -t mangle -A GOST_LOCAL -p tcp -d fe80::/10 -j RETURN
    ip6tables -t mangle -A GOST_LOCAL -p tcp -d ff00::/8 -j RETURN
    ip6tables -t mangle -A GOST_LOCAL -p tcp -m mark --mark 100 -j RETURN 
    ip6tables -t mangle -A GOST_LOCAL -p tcp -j MARK --set-mark 1
    ip6tables -t mangle -A OUTPUT -p tcp -j GOST_LOCAL

    loging "tcp mode ..."
}

udp_proxy(){
    nohup /bin/gost -L "redu://:12345?ttl=30s" -F $proxy_add?so_mark=100 >> $log 2>&1 &

    # ipv4
    ip rule add fwmark 1 lookup 100
    ip route add local default dev lo table 100

    iptables -t mangle -N GOST
    iptables -t mangle -A GOST -p udp -d 127.0.0.0/8 -j RETURN
    iptables -t mangle -A GOST -p udp -d 10.0.0.0/8 -j RETURN
    iptables -t mangle -A GOST -p udp -d 172.16.0.0/12 -j RETURN
    iptables -t mangle -A GOST -p udp -d 192.168.0.0/16 -j RETURN
    iptables -t mangle -A GOST -p udp -d 255.255.255.255/32 -j RETURN
    iptables -t mangle -A GOST -p udp -m mark --mark 100 -j RETURN 
    iptables -t mangle -A GOST -p udp -j TPROXY --tproxy-mark 0x1/0x1 --on-port 12345 
    iptables -t mangle -A PREROUTING -p udp -j GOST

    # Only for local mode
    iptables -t mangle -N GOST_LOCAL
    iptables -t mangle -A GOST_LOCAL -p udp -d 127.0.0.0/8 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p udp -d 10.0.0.0/8 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p udp -d 172.16.0.0/12 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p udp -d 192.168.0.0/16 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p udp -d 255.255.255.255/32 -j RETURN
    iptables -t mangle -A GOST_LOCAL -p udp -m mark --mark 100 -j RETURN 
    iptables -t mangle -A GOST_LOCAL -p udp -j MARK --set-mark 1
    iptables -t mangle -A OUTPUT -p udp -j GOST_LOCAL

    # ipv6
    ip -6 rule add fwmark 1 lookup 100
    ip -6 route add local default dev lo table 100

    ip6tables -t mangle -N GOST
    ip6tables -t mangle -A GOST -p udp -d ::/128 -j RETURN
    ip6tables -t mangle -A GOST -p udp -d ::1/128 -j RETURN
    ip6tables -t mangle -A GOST -p udp -d fe80::/10 -j RETURN
    ip6tables -t mangle -A GOST -p udp -d ff00::/8 -j RETURN
    ip6tables -t mangle -A GOST -p udp -m mark --mark 100 -j RETURN 
    ip6tables -t mangle -A GOST -p udp -j TPROXY --tproxy-mark 0x1/0x1 --on-port 12345 
    ip6tables -t mangle -A PREROUTING -p udp -j GOST

    # Only for local mode
    ip6tables -t mangle -N GOST_LOCAL
    ip6tables -t mangle -A GOST_LOCAL -p udp -d ::/128 -j RETURN
    ip6tables -t mangle -A GOST_LOCAL -p udp -d ::1/128 -j RETURN
    ip6tables -t mangle -A GOST_LOCAL -p udp -d fe80::/10 -j RETURN
    ip6tables -t mangle -A GOST_LOCAL -p udp -d ff00::/8 -j RETURN
    ip6tables -t mangle -A GOST_LOCAL -p udp -m mark --mark 100 -j RETURN 
    ip6tables -t mangle -A GOST_LOCAL -p udp -j MARK --set-mark 1
    ip6tables -t mangle -A OUTPUT -p udp -j GOST_LOCAL

    loging "udp mode ..."
}

del_rule_tool(){
    ids=`iptables -t mangle -nL $1 --line-numbers | grep $2 | awk '{print $1}'`
    if [ ! -z "$ids" ]; then
        id_array=(${ids//\\n/ })
        length=${#id_array[@]}
    	for ((i=$length-1;i>=0;i--))
    	do
            iptables -t mangle -D $1 ${id_array[$i]}
    	done
        iptables -t mangle -F $2
        iptables -t mangle -X $2
    fi
}
del_rule_tool_v6(){
    ids=`ip6tables -t mangle -nL $1 --line-numbers | grep $2 | awk '{print $1}'`
    if [ ! -z "$ids" ]; then
        id_array=(${ids//\\n/ })
        length=${#id_array[@]}
    	for ((i=$length-1;i>=0;i--))
    	do
            ip6tables -t mangle -D $1 ${id_array[$i]}
    	done
        ip6tables -t mangle -F $2
        ip6tables -t mangle -X $2
    fi
}

del_rule(){
    del_rule_tool PREROUTING DIVERT
    del_rule_tool PREROUTING GOST
    del_rule_tool OUTPUT GOST_LOCAL
    del_rule_tool_v6 PREROUTING DIVERT
    del_rule_tool_v6 PREROUTING GOST
    del_rule_tool_v6 OUTPUT GOST_LOCAL

    rule=`ip rule list table 100`
    if [ ! -z "$rule" ]; then
        ip rule delete fwmark 1 lookup 100
        ip route delete local 0.0.0.0/0 dev lo table 100
    fi
    rule=`ip -6 rule list table 100`
    if [ ! -z "$rule" ]; then
        ip -6 rule delete fwmark 1 lookup 100
        ip -6 route delete local ::/0 dev lo table 100
    fi
    loging "del rule ..."
}

del_log(){
    rm -f $log
}

if [ -z "$1" ]; then
    echo "[*] Usage
    mix    : TCP + UDP 代理
    tcp    : TCP 代理
    udp    : UDP 代理
    inner  : 内网代理
    off    : 关闭代理
    clean  : 清空日志
    "
    exit 0
fi

if [ "$2" ]; then
    proxy_add=$2
    if [ "$1" = "mix" ]; then
        stop_gost
        mix_proxy
        exit 0
    fi
    if [ "$1" = "tcp" ]; then
        stop_gost
        tcp_proxy
        exit 0
    fi
    if [ "$1" = "udp" ]; then
        stop_gost
        udp_proxy
        exit 0
    fi

fi

if [ "$1" = "inner" ]; then
    inner_proxy_add=$2
    route=$3
    tcp_inner
    exit 0
fi

if [ "$1" = "off" ]; then
    stop_gost
    del_rule
    exit 0
fi
if [ "$1" = "clean" ]; then
    del_log
    exit 0
fi
