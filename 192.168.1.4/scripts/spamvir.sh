#!/bin/bash

/etc/init.d/amavis stop
sleep 1s
/etc/init.d/amavis start

####################################

/etc/init.d/clamav-daemon stop
sleep 1s
/etc/init.d/clamav-daemon start

####################################

/etc/init.d/clamav-freshclam stop
sleep 1s
/etc/init.d/clamav-freshclam start

####################################

/etc/init.d/spamassassin stop
sleep 1s
/etc/init.d/spamassassin start

####################################


echo "El servidor está securizado..."

