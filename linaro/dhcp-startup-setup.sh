#!/bin/bash

path=$(dirname $0)
log="/home/pi"

if [[ ! -z $1 ]]; then echo $1; fi

echo "" >> "$log"/dhcp.status
echo "-------------------------------------------------" >> "$log"/dhcp.status
echo "" >> "$log"/dhcp.status

echo "dhcp startup setup" | tee -a "$log"/dhcp.status
date | tee -a "$log"/dhcp.status

if [ -f "/boot/dhcp-server" ]; then

        echo "running dhcp server" | tee -a "$log"/dhcp.status

        if [[ -f "/var/run/dhcpd.pid" ]]; then
          pid=$(cat /var/run/dhcpd.pid)
          sudo kill -s SIGTERM "$pid"
          sudo rm /var/run/dhcpd.pid
        fi
        echo "removing eth0 profile" | tee -a "$log"/dhcp.status
        sudo rm /etc/dhcpcd.conf
        echo "cp eth0 profile" | tee -a "$log"/dhcp.status
        sudo cp "$path"/dhcpcdsetup /etc/dhcpcd.conf
	      #sudo /etc/init.d/networking restart
        #sudo /etc/init.d/network-manager restart
	      #sudo ip addr flush eth0


        echo "eth0 down" | tee -a "$log"/dhcp.status
        sudo ifconfig eth0 down | tee -a "$log"/dhcp.status
        sleep 5
        echo "eth0 up" | tee -a "$log"/dhcp.status
        sudo ifconfig eth0 up | tee -a "$log"/dhcp.status
        #sudo systemctl restart networking
	      #sudo /etc/init.d/networking restart

        echo "" >> "$log"/dhcp.status
        echo "-------------------------------------------------" >> "$log"/dhcp.status
        echo "" >> "$log"/dhcp.status
	#journalctl -xe >> "$log"/dhcp.status

elif [ -f "/boot/dhcp-client" ]; then

  echo "running dhcp client" | tee -a "$log"/dhcp.status

  if [[ -f "/var/run/dhcpd.pid" ]]; then
    pid=$(cat /var/run/dhcpd.pid)
    sudo kill -s SIGTERM "$pid"
    sudo rm /var/run/dhcpd.pid
  fi

	echo "removing eth0 profile" | tee -a "$log"/dhcp.status
  sudo rm /etc/dhcpcd.conf
  echo "cp eth0 profile" | tee -a "$log"/dhcp.status
  sudo cp "$path"/dhcpcddefault /etc/dhcpcd.conf
  # sudo bash -c 'rm /etc/network/interfaces.d/eth0'
  # cat "$path"/eth0blank | tee -a "$log"/dhcp.status
  # sudo cp "$path"/eth0blank /etc/network/interfaces.d/eth0

  #sudo ip addr flush eth0
  #sudo /etc/init.d/networking restart
  #sudo /etc/init.d/network-manager restart


  echo "eth0 down" | tee -a "$log"/dhcp.status
  sudo ifconfig eth0 down | tee -a "$log"/dhcp.status
  sleep 5
  echo "eth0 up" | tee -a "$log"/dhcp.status
  sudo ifconfig eth0 up | tee -a "$log"/dhcp.status
      	#sudo ip addr flush eth0
      	#sudo /etc/init.d/networking restart
        #sudo systemctl restart networking

else
        echo "no dhcp setup specified"
fi

echo "" >> "$log"/dhcp.status
echo "-------------------------------------------------" >> "$log"/dhcp.status
echo "" >> "$log"/dhcp.status
ip a | tee -a "$log"/dhcp.status
