#!/bin/bash
echo "开始安装爱影CMS最新版本"
rm -f iycms.zip
wget --no-check-certificate "https://www.iycms.com/api/v1/download/cms/latest?os=1&kind=arm64" -O iycms.zip
echo "解压文件"
unzip -o -q iycms.zip -d /home/iycms
rm -f iycms.zip
echo "开始安装系统服务"

echo "[Unit]
Description=iycms service
Documentation=https://www.iycms.com

[Service]
Type=simple
Restart=always
User=root
WorkingDirectory=/home/iycms/
ExecStart=/home/iycms/cms
RestartSec=1
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=iycms

[Install]
WantedBy=multi-user.target">/etc/systemd/system/iycms.service
echo 'if $programname == "iycms" then /home/iycms/stdout.log
& stop'>/etc/rsyslog.d/iycms.conf
touch /home/iycms/stdout.log
chcon -t var_log_t /home/iycms/stdout.log
systemctl daemon-reload
systemctl restart rsyslog
systemctl enable iycms
systemctl restart iycms
rm -f ./iycms.sh
systemctl stop firewalld
systemctl disable firewalld
echo "安装完成"