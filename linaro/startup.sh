#!/bin/bash

sudo chmod 0777 -R /home/*
sudo chmod +x -R /etc/network/*
c=0
while true; do
	c=c+1
	sleep 1

	  echo "-------------------------------------------------" >> "$log"
		  echo "startup loop" >> "$log"

	echo "-------------------------------------------------" >> "$log"

	if systemctl is-active --quiet isc-dhcp-server.service; then
		date >> "$log"/dhcp.status
		echo "dhcp is running" >> "$log"/dhcp.status
	else
		echo "restarting dhcp" >> "$log"/dhcp.status
		sudo systemctl restart isc-dhcp-server  | tee -a "$log"/dhcp.status
	fi
	echo "-------------------------------------------------" >> "$log"

	if [ $c -eq 10]; then
		echo "10 loops"
	fi
done
