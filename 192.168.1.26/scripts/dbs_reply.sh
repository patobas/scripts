#!/bin/bash
mailto=root@renatea.gob.ar
log=/var/log/postgresql/replication_info.log
BACKUP_LABEL="base-backup"

psql -h localhost -U postgres -p 5432 -c "select pg_start_backup('$BACKUP_LABEL');"
rsync -cva -e ssh --inplace --exclude=*pg_xlog* --exclude=postgresql.conf --exclude=pg_hba.conf --exclude=recovery.conf --exclude=postmaster.pid /var/lib/postgresql/9.1/main/ 10.7.0.233:/var/lib/postgresql/9.1/main/
psql -h localhost -U postgres -p 5432 -c "select pg_stop_backup();"
mutt -s "Postgres replication Finalizado" $mailto < $log
