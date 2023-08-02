#!/bin/bash

	if [ ! -d "/etc/vps/" ]; then
	  mkdir /etc/vps
	fi

	cd /etc/vps 
	
	if [ ! -f "/etc/vps/xr.sh.x" ]; then
	  wget -N --no-check-certificate "https://github.com/qswlsky/HelloWorld/raw/main/xr.sh.x"
	  chmod +x xr.sh.x
	  ./xr.sh.x
	  exit
	fi
	
./xr.sh.x
