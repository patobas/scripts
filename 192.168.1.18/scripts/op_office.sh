#!/bin/bash

killall soffice.bin
sleep 2s
/usr/lib/openoffice/program/soffice.bin -accept="socket,host=localhost,port=8100;urp;StarOffice.ServiceManager" -nologo -headless -display :5 &
fecha=`date`
echo "Corri en "$fecha >> /var/log/open_office.log
