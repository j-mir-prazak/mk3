#!/bin/bash

path=$(dirname $0)
log="/home/pi"

if [[ ! -z $1 ]]; then echo $1; fi

echo "" >> "$log"/dhcp.status
echo "-------------------------------------------------" >> "$log"/dhcp.status
echo "" >> "$log"/dhcp.status

echo "dhcp ifup startup" | tee -a "$log"/dhcp.status
date | tee -a "$log"/dhcp.status

if [ -f "/boot/dhcp-server" ]; then   

  sudo systemctl restart isc-dhcp-server | tee -a "$log"/dhcp.status
  echo "" >> "$log"/dhcp.status
  echo "-------------------------------------------------" >> "$log"/dhcp.status
  echo "" >> "$log"/dhcp.status
  #journalctl -xe >> "$log"/dhcp.status

elif [ -f "/boot/dhcp-client" ]; then

  echo "" >> "$log"/dhcp.status
  echo "--------------------------------------------  -----" >> "$log"/dhcp.status
  echo "" >> "$log"/dhcp.status

else
        echo "no dhcp setup specified"
fi

echo "" >> "$log"/dhcp.status
echo "-------------------------------------------------" >> "$log"/dhcp.status
echo "" >> "$log"/dhcp.status

ip a | tee -a "$log"/dhcp.status
