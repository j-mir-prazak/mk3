#!/bin/bash

path=$(dirname "$0")

if [[ ! -z $1 ]]; then echo $1; fi

echo "" >> "$path"/dhcp.status
echo "-------------------------------------------------" >> "$path"/dhcp.status
echo "" >> "$path"/dhcp.status

echo "dhcp startup setup" | tee -a "$path"/dhcp.status
date | tee -a "$path"/dhcp.status

if [ -f "/boot/dhcp-server" ]; then

        echo "running dhcp server" | tee -a "$path"/dhcp.status

        if [[ -f "/var/run/dhcpd.pid" ]]; then
          pid=$(cat /var/run/dhcpd.pid)
          sudo kill -s SIGTERM "$pid"
          sudo rm /var/run/dhcpd.pid
        fi
        echo "removing eth0 profile" | tee -a "$path"/dhcp.status
        sudo bash -c 'rm /etc/network/interfaces.d/eth0'
        cat "$path"/eth0setup | tee -a "$path"/dhcp.status
        echo "cp eth0 profile" | tee -a "$path"/dhcp.status
        sudo cp "$path"/eth0setup >/etc/network/interfaces.d/eth0
	      #sudo /etc/init.d/networking restart
        #sudo /etc/init.d/network-manager restart
	      #sudo ip addr flush eth0


        echo "eth0 down" | tee -a "$path"/dhcp.status
        sudo ifconfig eth0 down | tee -a "$path"/dhcp.status
        sleep 5
        echo "eth0 up" | tee -a "$path"/dhcp.status
        sudo ifconfig eth0 up | tee -a "$path"/dhcp.status
        #sudo systemctl restart networking
	      #sudo /etc/init.d/networking restart

        echo "" >> "$path"/dhcp.status
        echo "-------------------------------------------------" >> "$path"/dhcp.status
        echo "" >> "$path"/dhcp.status
	#journalctl -xe >> "$path"/dhcp.status

elif [ -f "/boot/dhcp-client" ]; then

  echo "running dhcp client" | tee -a "$path"/dhcp.status

  if [[ -f "/var/run/dhcpd.pid" ]]; then
    pid=$(cat /var/run/dhcpd.pid)
    sudo kill -s SIGTERM "$pid"
    sudo rm /var/run/dhcpd.pid
  fi

	echo "removing eth0 profile" | tee -a "$path"/dhcp.status
  sudo bash -c 'rm /etc/network/interfaces.d/eth0'
  cat "$path"/eth0blank | tee -a "$path"/dhcp.status
  echo "cp eth0 profile" | tee -a "$path"/dhcp.status
  sudo cp "$path"/eth0blank /etc/network/interfaces.d/eth0
  #sudo ip addr flush eth0
  #sudo /etc/init.d/networking restart
  #sudo /etc/init.d/network-manager restart


  echo "eth0 down" | tee -a "$path"/dhcp.status
  sudo ifconfig eth0 down | tee -a "$path"/dhcp.status
  sleep 5
  echo "eth0 up" | tee -a "$path"/dhcp.status
  sudo ifconfig eth0 up | tee -a "$path"/dhcp.status
      	#sudo ip addr flush eth0
      	#sudo /etc/init.d/networking restart
        #sudo systemctl restart networking

else
        echo "no dhcp setup specified"
fi

echo "" >> "$path"/dhcp.status
echo "-------------------------------------------------" >> "$path"/dhcp.status
echo "" >> "$path"/dhcp.status
ip a | tee -a "$path"/dhcp.status
