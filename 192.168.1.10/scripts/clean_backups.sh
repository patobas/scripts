#!/bin/bash
mailto=root@renatea.gob.ar
backup_dir=/var/backup
log=/var/log/backup.logs

# Movemos los viernes mayores a 10 dias
find $backup_dir/*vie*.gz  -mtime +10 -exec mv {} /var/backup/historicos/ \; >> $log

# Borramos los backups mas viejos que 10 dias
find $backup_dir/*gz* $backup_dir/*sql* -mtime +10 -exec rm {} \; >> $log

