#!/bin/bash

#. /etc/ids.cfg

if [ -d /var/log/suricata ]; then

	/usr/bin/find  /var/log/suricata/ -name "unified2.*"  -mtime +3 -exec rm {} \;

else 

	echo "Suricata directory doesn't exist!!!"

fi

