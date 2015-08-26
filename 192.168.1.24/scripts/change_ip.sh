#!/bin/bash
ifconfig eth0 192.168.1.24
/etc/init.d/networking stop
/etc/init.d/networking start
/root/scripts/net.sh
