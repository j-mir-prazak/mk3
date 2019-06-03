#!/bin/bash

sudo chmod 0777 -R /home/*
sudo chmod +x -R /etc/network/*

log="/home/pi"

sudo systemctl stop systemd-timesyncd.service
sudo systemctl disable systemd-timesyncd.service

sudo service systemd-timesyncd stop
sudo service hwclock.sh stop
date --s "00:08:00"

c=0


while true; do
	echo $c
	c=$(($c+1))
	sleep 1

	  echo "-------------------------------------------------" >> ""$log"/dhcp.status
		  echo "startup loop" >> ""$log"/dhcp.status

	echo "-------------------------------------------------" >> ""$log"/dhcp.status

	if systemctl is-active --quiet isc-dhcp-server.service; then
		date >> ""$log"/dhcp.status
		echo "dhcp is running" >> "$log"/dhcp.status
	else
		echo "restarting dhcp" >> "$log"/dhcp.status
		sudo systemctl restart isc-dhcp-server  | tee -a "$log"/dhcp.status
	fi
	echo "-------------------------------------------------" >> ""$log"/dhcp.status

	if [ $c -eq 60 ]; then
		echo "60 loops"
		sudo ntpd -gq
		c=0
	fi
done
