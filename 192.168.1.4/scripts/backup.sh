echo "*******************************************************"
echo "*     Zimbra - Backup all email accounts              *"
echo "*******************************************************"
echo""
#
echo Start time of the backup = $(date +%T)  
before="$(date +%s)"
#
echo ""
ZHOME=/opt/zimbra
ZBACKUP=$ZHOME/backup/mailbox
echo "Generating backup files ..."
su - zimbra -c "/opt/zimbra/scripts/backup_all_accounts.sh"
echo "Sending files to backup all email accounts \o/ ) ..."
rsync -avH $ZBACKUP root@192.168.1.10:/var/backup/zimbra_backup_accounts
before2="$(date +%s)"
#
echo The process lasted = $(date +%T)
# Calculating time
after="$(date +%s)"
elapsed="$(expr $after - $before)"
hours=$(($elapsed / 3600))
elapsed=$(($elapsed - $hours * 3600))
minutes=$(($elapsed / 60))
seconds=$(($elapsed - $minutes * 60))
echo The complete backup lasted : "$hours hours $minutes minutes $seconds seconds"

