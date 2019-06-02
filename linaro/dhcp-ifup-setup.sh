#!/bin/bash

path=$(pwd)

if [[ ! -z $1 ]]; then echo $1; fi

echo "" >> "$path"dhcp.status
echo "-------------------------------------------------" >> "$path"dhcp.status
echo "" >> "$path"dhcp.status

echo "dhcp ifup startup" | tee -a "$path"dhcp.status
date | tee -a "$path"dhcp.status

if [ -f "/boot/dhcp-server" ]; then

  sudo systemctl restart isc-dhcp-server | tee -a "$path"dhcp.status
  echo "" >> "$path"dhcp.status
  echo "-------------------------------------------------" >> "$path"dhcp.status
  echo "" >> "$path"dhcp.status
  #journalctl -xe >> "$path"dhcp.status

elif [ -f "/boot/dhcp-client" ]; then

  echo "" >> "$path"dhcp.status
  echo "--------------------------------------------  -----" >> "$path"dhcp.status
  echo "" >> "$path"dhcp.status

else
        echo "no dhcp setup specified"
fi

echo "" >> "$path"dhcp.status
echo "-------------------------------------------------" >> "$path"dhcp.status
echo "" >> "$path"dhcp.status

ip a | tee -a "$path"dhcp.status
