#!/bin/bash
cat /dev/null > /var/log/apache2/error.log
rm -rf /var/log/apache2/error.log.1?.gz
