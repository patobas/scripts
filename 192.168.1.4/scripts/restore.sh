echo "*******************************************************"
echo "*    Zimbra - Restore all email accounts              *"
echo "*******************************************************"
echo ""
#
echo Start Time Restore = $(date +%T)         
before="$(date +%s)"
#
echo ""
echo "Starting the process restore the backup files ..."
su - zimbra -c "/opt/zimbra/scripts/restore_all_accounts.sh"
before2="$(date +%s)"
echo The process lasted = $(date +%T)
# Calculating time
after="$(date +%s)"
elapsed="$(expr $after - $before)"
hours=$(($elapsed / 3600))
elapsed=$(($elapsed - $hours * 3600))
minutes=$(($elapsed / 60))
seconds=$(($elapsed - $minutes * 60))
echo "The complete restore lasted : "$hours hours $minutes minutes $seconds seconds"

