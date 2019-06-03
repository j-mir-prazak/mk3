#!/bin/bash

sudo chmod 0777 -R /home/*
sudo chmod +x -R /etc/network/*

while true; do
	sleep 30
	  echo "-------------------------------------------------" >> "$log"
		  echo "startup loop" >> "$log"

	echo "-------------------------------------------------" >> "$log"
	sudo systemctl restart isc-dhcp-server  | tee -a "$log"/dhcp.status
  echo "" >> "$log"/dhcp.status
  echo "-------------------------------------------------" >> "$log"

done
