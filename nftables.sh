#!/bin/bash

# 关闭防火墙
service firewalld stop && systemctl disable firewalld

# 修改内存参数，开启端口转发
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i '/^net.ipv4.ip_forward=0/'d /etc/sysctl.conf
sed -n '/^net.ipv4.ip_forward=1/'p /etc/sysctl.conf | grep -q "net.ipv4.ip_forward=1"
if [ $? -ne 0 ]; then
    echo -e "net.ipv4.ip_forward=1" >> /etc/sysctl.conf && sysctl -p
fi

# 安装nftables
apt install -y nftables

# 下载可执行文件
systemctl stop nat && wget -O /usr/local/bin/nat http://cdn.arloor.com/tool/dnat && chmod +x /usr/local/bin/nat

# 创建系统服务
mkdir /opt/nat
touch /opt/nat/env

cat > /lib/systemd/system/nat.service <<EOF
[Unit]
Description=dnat-service
After=network-online.target
Wants=network-online.target

[Service]
WorkingDirectory=/opt/nat
EnvironmentFile=/opt/nat/env
ExecStart=/usr/local/bin/nat /etc/nat.conf
LimitNOFILE=100000
Restart=always
RestartSec=60

[Install]
WantedBy=multi-user.target
EOF

# 设置开机启动，并启动该服务
systemctl daemon-reload && systemctl enable nat && systemctl start nat.service