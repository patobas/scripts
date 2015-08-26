#!/bin/bash
# Backup of Zimbra mailboxes using zmmailbox
# Restore of mailbox should be performed using:
# /opt/zimbra/bin/zmmailbox -z -m user@host postRestURL -u https://HOST "//?fmt=tgz&resolve=skip" mailbox-name-date.tgz
BackupFolder="backup/"
MailBox="pbasalo"
DateToday=`date -I`
for name in $MailBox
do
/opt/zimbra/bin/zmmailbox -z -m $name@renatea.gob.ar getRestURL "//?fmt=tgz" > /opt/zimbra/backup/$name-$DateToday.tgz
/opt/zimbra/bin/zmprov getAccount $name@renatea.gob.ar > $name-$DateToday-settings.txt
done
