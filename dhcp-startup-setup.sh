#!/bin/bash

path="/home/linaro/"

if [[ ! -z $1 ]]; then echo $1; fi

echo "" >> "$path"dhcp.status
echo "-------------------------------------------------" >> "$path"dhcp.status
echo "" >> "$path"dhcp.status

echo "dhcp startup setup" | tee -a "$path"dhcp.status
date | tee -a "$path"dhcp.status

if [ -f "/boot/dhcp-server" ]; then

        echo "running dhcp server" | tee -a "$path"dhcp.status

        if [[ -f "/var/run/dhcpd.pid" ]]; then
          pid=$(cat /var/run/dhcpd.pid)
          sudo kill -s SIGTERM "$pid"
          sudo rm /var/run/dhcpd.pid
        fi

        sudo rm /etc/network/interfaces.d/eth0
        sudo cp -f "$path"eth0.setup /etc/network/interfaces.d/eth0
	      sudo /etc/init.d/networking restart
        sudo /etc/init.d/network-manager restart
	      sudo ip addr flush eth0
        #sudo systemctl restart networking
	      #sudo /etc/init.d/networking restart

        echo "" >> "$path"dhcp.status
        echo "-------------------------------------------------" >> "$path"dhcp.status
        echo "" >> "$path"dhcp.status
	#journalctl -xe >> "$path"dhcp.status

elif [ -f "/boot/dhcp-client" ]; then

  if [[ -f "/var/run/dhcpd.pid" ]]; then
    pid=$(cat /var/run/dhcpd.pid)
    sudo kill -s SIGTERM "$pid"
    sudo rm /var/run/dhcpd.pid
  fi

	echo "running dhcp client" | tee -a "$path"dhcp.status
  sudo rm /etc/network/interfaces.d/eth0
  sudo cp -f "$path"eth0.blank /etc/network/interfaces.d/eth0
  sudo /etc/init.d/networking restart
  sudo /etc/init.d/network-manager restart
	sudo ip addr flush eth0
      	#sudo ip addr flush eth0
      	#sudo /etc/init.d/networking restart
        #sudo systemctl restart networking

else
        echo "no dhcp setup specified"
fi

echo "" >> "$path"dhcp.status
echo "-------------------------------------------------" >> "$path"dhcp.status
echo "" >> "$path"dhcp.status
ip a | tee -a "$path"dhcp.status
