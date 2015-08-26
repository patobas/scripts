#!/bin/bash
 
############################################################################
# Simple backup script. It uses complete and incremental backups, with #
# hard links to simulate snapshots. $FULL_BACKUP_LIMIT controls the #
# frecuency of full backups.It accepts at least one source directory and a #
# single destination directory as arguments. Usage: #
# #
# incremental_backup.sh SOURCE_DIRECTORY_1 [SOURCE_DIRECTORY_2..N] #
# DESTINATION_DIRECTORY #
# #
# #
# Author: Álvaro Reig González #
# Licence: GNU GLPv3 # #
# www.alvaroreig.com #
# https://github.com/alvaroreig #
############################################################################
 
DATE=`date +%Y%m%d`
TIMESTAMP=$(date +%m%d%y%H%M%S)
FULL_BACKUP_STRING=backup-full-$DATE-$TIMESTAMP
INC_BACKUP_STRING=backup-inc-$DATE-$TIMESTAMP
FULL_BACKUP_LIMIT=10
BACKUPS_TO_KEEP=40
EXCLUSSIONS="--exclude .cache/ --exclude proc/ --exclude .thumbnails/ --exclude .gvfs --exclude var/data/ --exclude var/data/repo/ --exclude var/data/squid3/ --exclude var/pgdata/pg_afip --exclude var/pgdata/pg_bck --exclude mnt/nas_23/ --exclude var/rnbackups --exclude var/mksbackup --exclude var/backup --exclude var/db/ --exclude newsletter/ --exclude nfs-server/ --exclude home/pato/Procesos --exclude opt/samba_shares/cis/sgg/dr/ --exclude opt/images/ --exclude opt/images/cupones/ --exclude var/images/ --exclude var/lib/postgresql/ --exclude media/storage/"
#gate= --exclude var/data/ --exclude var/data/repo/ --exclude var/data/squid3/
#dbaf= --exclude var/pgdata/pg_afip --exclude var/pgdata/pg_bck
#back= --exclude mnt/nas_23/ --exclude var/log/ --exclude var/rnbackups --exclude var/mksbackup --exclude var/backup --exclude var/db/
#webs= --exclude newsletter/ --exclude nfs-server/
#intr= --exclude home/pato/Procesos --exclude opt/samba_shares/cis/sgg/dr/ --exclude opt/images/ --exclude opt/images/cupones/
#cldm= --exclude var/images/ --exclude var/lib/postgresql/ --exclude media/storage/
#clds= --exclude var/lib/postgresql/

OPTIONS="-h -ab --stats"
#To test the script, include "-n" to perform a 'dry' rsync
LOG=/var/log/backup.log
 
############################################################################
# Arguments processing. The last argument is the destination directory, the#
# previous arguments are the source[s] directory[ies] #
############################################################################
 
ARGS=("$@")
 
if [ ${#ARGS[*]} -lt 2 ]; then
echo "At least two arguments are needed" >> $LOG
  echo "Usage: bash incremental_backup [SOURCE_DIR_1]...[SOURCE_DIR_N] [DESTINATION_DIR]" >> $LOG
  exit;
else
 
  #Store the destination directory
  DEST_DIR=${ARGS[${#ARGS[*]}-1]}
 
  #Store the first source directory
  SOURCE_DIRS=${ARGS[0]}
  let LAST_SOURCE_POSITION=${#ARGS[*]}-2
  SOURCE_COUNTER=1
   
  #Store the next source directories
  while [ $SOURCE_COUNTER -le $LAST_SOURCE_POSITION ]; do
CURRENT_SOURCE_DIR=${ARGS[$SOURCE_COUNTER]-1]}
    let SOURCE_COUNTER=SOURCE_COUNTER+1
    SOURCE_DIRS=$SOURCE_DIRS" "$CURRENT_SOURCE_DIR
  done
 
echo "" >> $LOG
  echo "" >> $LOG
  echo "[" `date +%Y-%m-%d_%R` "]" "###### Starting backup #######" >> $LOG
  echo "[" `date +%Y-%m-%d_%R` "]" "Directories to backup" $SOURCE_DIRS >> $LOG
  echo "[" `date +%Y-%m-%d_%R` "]" "Destination directory" $DEST_DIR >> $LOG
  echo "[" `date +%Y-%m-%d_%R` "]" "Limit to full backup:" $FULL_BACKUP_LIMIT >> $LOG
  echo "[" `date +%Y-%m-%d_%R` "]" "Backups to keep:" $BACKUPS_TO_KEEP >> $LOG
  echo "[" `date +%Y-%m-%d_%R` "]" "Exclussions:" $EXCLUSSIONS >> $LOG
  echo "[" `date +%Y-%m-%d_%R` "]" "###### Browsing previous backups ######" >> $LOG
fi
 
############################################################################
# Browse previous backups #
############################################################################
BACKUPS=`ls -t $DEST_DIR |grep backup-`
BACKUP_COUNTER=0
BACKUPS_LIST=()
 
for x in $BACKUPS
do
BACKUPS_LIST[$BACKUP_COUNTER]="$x"
    echo "[" `date +%Y-%m-%d_%R` "]" "backup detected:" ${BACKUPS_LIST[$BACKUP_COUNTER]} >> $LOG
    let BACKUP_COUNTER=BACKUP_COUNTER+1
     
done
 
############################################################################
# Delete old backups, if necessary #
############################################################################
 
echo "[" `date +%Y-%m-%d_%R` "]" "###### Deleting old backups ######" >> $LOG
echo "[" `date +%Y-%m-%d_%R` "]" "Number of previous backups: " ${#BACKUPS_LIST[*]} >> $LOG
echo "[" `date +%Y-%m-%d_%R` "]" "Backups to keep:" $BACKUPS_TO_KEEP >> $LOG
 
###
if [ $BACKUPS_TO_KEEP -lt ${#BACKUPS_LIST[*]} ]; then
let BACKUPS_TO_DELETE=${#BACKUPS_LIST[*]}-$BACKUPS_TO_KEEP
  echo "[" `date +%Y-%m-%d_%R` "]" "Need to delete" $BACKUPS_TO_DELETE" backups" $BACKUPS_TO_DELETE >> $LOG
 
  while [ $BACKUPS_TO_DELETE -gt 0 ]; do
BACKUP=${BACKUPS_LIST[${#BACKUPS_LIST[*]}-1]}
    unset BACKUPS_LIST[${#BACKUPS_LIST[*]}-1]
    echo "[" `date +%Y-%m-%d_%R` "]" "Backup to delete:" $BACKUP >> $LOG
    rm -rf $DEST_DIR"/"$BACKUP >> $LOG
    if [ $? -ne 0 ]; then
echo "[" `date +%Y-%m-%d_%R` "]" "####### Error while deleting backup #######" >> $LOG
    else
echo "[" `date +%Y-%m-%d_%R` "]" "Backup correctly deleted" >> $LOG
    fi
let BACKUPS_TO_DELETE=BACKUPS_TO_DELETE-1
  done
else
echo "[" `date +%Y-%m-%d_%R` "]" "No need to delete backups" >> $LOG
fi
 
 
############################################################################
# The next backup will be complete if there is no full backup in the last #
# FULL_BACKUP_LIMIT backups. If it is incremental, the last full backup #
# will be used as a reference for the "--link-dest" option #
############################################################################
 
NEXT_BACKUP_FULL=true
COUNTER=0
LAST_FULL_BACKUP=
 
echo "[" `date +%Y-%m-%d_%R` "]" "###### Performing the backup ######" >> $LOG
 
while [[ $COUNTER -lt $FULL_BACKUP_LIMIT && $COUNTER -lt ${#BACKUPS_LIST[*]} ]]; do
if [[ ${BACKUPS_LIST[$COUNTER]} == *full* ]]; then
NEXT_BACKUP_FULL=false;
   LAST_FULL_BACKUP=${BACKUPS_LIST[$COUNTER]}
    echo "[" `date +%Y-%m-%d_%R` "]" "A full backup was performed" $COUNTER "backups ago which is less that the specified limit of" $FULL_BACKUP_LIMIT>> $LOG
   break;
  fi
let COUNTER=COUNTER+1
done
 
############################################################################
# Finally, the backup is performed #
############################################################################
 
if [ $NEXT_BACKUP_FULL == true ]; then
echo "[" `date +%Y-%m-%d_%R` "]" "The backup will be full" >> $LOG
rsync $OPTIONS $EXCLUSSIONS $SOURCE_DIRS $DEST_DIR/$FULL_BACKUP_STRING >> $LOG
else
echo "[" `date +%Y-%m-%d_%R` "]" "The backup will be incremental" >> $LOG
rsync $OPTIONS $EXCLUSSIONS --link-dest=$DEST_DIR/$LAST_FULL_BACKUP $SOURCE_DIRS $DEST_DIR/$INC_BACKUP_STRING >> $LOG
  $COM >> $LOG
fi
 
############################################################################
# Log the backup status #
############################################################################
 
if [ $? -ne 0 ]; then
echo "[" `date +%Y-%m-%d_%R` "]" "####### Error during the backup. Please execute the script with the -v flag #######" >> $LOG
  echo "" >> $LOG
  echo "" >> $LOG
else
echo "[" `date +%Y-%m-%d_%R` "]" "####### Backup correct #######" >> $LOG
  echo "" >> $LOG
  echo "" >> $LOG
fi
