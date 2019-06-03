#!/bin/bash

sudo chmod 0777 -R /home/*
sudo chmod +x -R /etc/network/*

path=$(dirname $0)
log="/home/pi"

sudo systemctl stop systemd-timesyncd.service
sudo systemctl disable systemd-timesyncd.service

sudo service systemd-timesyncd stop
sudo service hwclock.sh stop
sudo date --s "00:08:00"


if [ -f "/boot/dhcp-server" ]; then
	echo "cp ntp server settings"
	sudo cp "$path"/ntpserver /etc/ntp.conf
	sudo service ntp restart
elif [ -f "/boot/dhcp-client" ]; then
	echo "cp ntp client settings"
	sudo cp "$path"/ntpclient /etc/ntp.conf
	sudo service ntp restart
fi



c=0
nctries=0

while true; do
	echo $c
	c=$(($c+1))
	sleep 1

	if [ -f "/boot/dhcp-server" ]; then

	  echo "-------------------------------------------------" >> "$log"/dhcp.status
		  echo "startup loop" >> "$log"/dhcp.status

			echo "-------------------------------------------------" >> "$log"/dhcp.status

			if systemctl is-active --quiet isc-dhcp-server.service; then
				date >> "$log"/dhcp.status
				echo "dhcp is running" >> "$log"/dhcp.status
			else
				echo "restarting dhcp" >> "$log"/dhcp.status
				sudo systemctl restart isc-dhcp-server  | tee -a "$log"/dhcp.status
	fi

	echo "-------------------------------------------------" >> "$log"/dhcp.status

elif [ -f "/boot/dhcp-client" ]; then
	if [ $c -eq 60 ]; then
		echo "60 loops"
		echo "-------------------------------------------------" >> "$log"/dhcp.status
		echo "time sync" >> "$log"/dhcp.status
		echo "-------------------------------------------------" >> "$log"/dhcp.status
		sudo ntpd -gq
		c=0

		if ! ping -q -c1 -i 0.2 192.168.88.1 &>/dev/null;
			then echo "lost connection?";
			nctries=$(($nctries+1))
		fi


	fi
fi
done
