#!/bin/bash
#################################################################

# Let's set some variables first:
fecha=`date +"%Y%m%d"`
STARTDATE="$(head -1 /var/log/mail.log | awk -F" " '{print $1 " " $2 " " $3}')"
ENDDATE="$(tail -1 /var/log/mail.log | awk -F" " '{print $1 " " $2 " " $3}')"
MESSAGE=/opt/$fecha.lastmailstatsmessage

# Now we generate the text of our email and define the subject
# and recipient:

echo "Subject: Postfix Daily Stats Report $(date "+%H:%M %d.%m.%y")" > $MESSAGE
echo "To: root@renatea.gob.ar" >> $MESSAGE
echo "$STARTDATE and $ENDDATE." >> $MESSAGE
/usr/sbin/pflogsumm /var/log/mail.log >> $MESSAGE

# It's time to send this stuff:

cat /opt/$fecha.lastmailstatsmessage | /usr/sbin/sendmail -F "root@renatea.gob.ar" root@renatea.gob.ar

# We leave /opt/lastmailstatsmessage where it is.
# In case someone needs to read it later, this
# might be helpful.
