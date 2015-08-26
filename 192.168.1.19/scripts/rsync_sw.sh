#!/bin/bash
echo "rsync 19 a 18..."
rsync -avz --exclude=ts_libs/sql.inc -e ssh /var/www/hosts/intranet2/* 192.168.1.18:/var/www/hosts/intranet2/
echo "rsync 19 a 18 OK"

echo "rsync 19 a 62..."
rsync -avz --exclude=ts_libs/sql.inc -e ssh /var/www/hosts/intranet2/* 192.168.1.62:/var/www/hosts/intranet2/
echo "rsync 19 a 62 OK"

echo "rsync 19 a 63..."
rsync -avz --exclude=ts_libs/sql.inc -e ssh /var/www/hosts/intranet2/* 192.168.1.63:/var/www/hosts/intranet2/
echo "rsync 19 a 63 OK"

