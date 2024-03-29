#!/bin/bash


path=$(dirname $0)
log="/home/pi"


sudo chmod 0777 -R /home/*
sudo chmod +x -R /etc/network/*

sudo rm "$log"/dhcp.status


sudo systemctl stop systemd-timesyncd.service
sudo systemctl disable systemd-timesyncd.service

sudo service systemd-timesyncd stop
sudo service hwclock.sh stop
sudo date --s "08:00:00"


if [ -f "/boot/dhcp-server" ]; then
	echo "cp ntp server settings"
	sudo cp "$path"/ntpserver /etc/ntp.conf
	sudo service ntp restart
elif [ -f "/boot/dhcp-client" ]; then
	echo "cp ntp client settings"
	sudo cp "$path"/ntpclient /etc/ntp.conf
	sudo service ntp restart
fi



c=570
nctries=0
dhcptries=0;

while true; do
	echo $c
	c=$(($c+1))
	sleep 1

	if [ -f "/boot/dhcp-server" ]; then

	  echo "-------------------------------------------------" >> "$log"/dhcp.status
		  echo "startup loop" >> "$log"/dhcp.status

			echo "-------------------------------------------------" >> "$log"/dhcp.status

			if sudo systemctl is-active --quiet isc-dhcp-server.service; then
				date >> "$log"/dhcp.status
				echo "dhcp is running" >> "$log"/dhcp.status
			else
				dhcptries=$(dhcptries+1)
				if [ $dhcptries -eq 10 ]; then
					echo "restarting dhcp" >> "$log"/dhcp.status
					sudo systemctl restart isc-dhcp-server  | tee -a "$log"/dhcp.status
					dhcptries=0
				fi
			fi

	if ! fping -q -c1 -t500 192.168.88.1 &>/dev/null;
		then echo "lost connection?";
		nctries=$(($nctries+1))
			if [ $nctries -eq 10 ]; then
				echo "restarting connection"
				if sudo fping -q -c4 -t1500 192.168.99.1 &>/dev/null; then
					echo "saved by the master connection"
				elif sudo fping -q -c4 -t1500 8.8.8.8 &>/dev/null; then
					echo "saved by the internet connection"
				else
					bash /home/pi/mk3/linaro/dhcp-startup-setup.sh
				fi
				nctries=0
			fi
	fi

	echo "-------------------------------------------------" >> "$log"/dhcp.status

elif [ -f "/boot/dhcp-client" ]; then

	if [ $c -eq 600 ]; then
		echo "600 loops"
		echo "-------------------------------------------------" >> "$log"/dhcp.status
		echo "time sync" >> "$log"/dhcp.status
		echo "-------------------------------------------------" >> "$log"/dhcp.status
		sudo service ntp stop
		sudo sntp -s 192.168.88.1
		sudo service ntp start
		c=0

	fi

	if ! fping -q -c1 -t500 192.168.88.1 &>/dev/null;	then
		echo "lost connection?" >> "$log"/dhcp.status
		nctries=$(($nctries+1))
			if [ $nctries -eq 10 ]; then
				echo "restarting connection">> "$log"/dhcp.status
				if sudo fping -q -c4 -t1500 192.168.99.1 &>/dev/null; then
					echo "saved by the master connection">> "$log"/dhcp.status
				elif sudo fping -q -c4 -t1500 8.8.8.8 &>/dev/null; then
					echo "saved by the internet connection">> "$log"/dhcp.status
				else
					bash /home/pi/mk3/linaro/dhcp-startup-setup.sh
				fi
				nctries=0
			fi
	fi

	if fping -q -c1 -t500 192.168.88.1 &>/dev/null; then
		echo "connection" >> "$log"/dhcp.status
		nctries=0
	fi
fi
done
