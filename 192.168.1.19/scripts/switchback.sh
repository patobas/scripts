#!/bin/bash
BACKUP_LABEL="base-backup"

psql -U postgres -c "select pg_start_backup('$BACKUP_LABEL');"
rsync -cva --inplace --exclude=*pg_xlog* --exclude=recovery* --exclude=postgresql.conf --exclude=pg_hba.conf /var/lib/postgresql/9.1/main/base/* 192.168.1.20:/var/lib/postgresql/9.1/main/base/
psql -U postgres -c "select pg_stop_backup();"
