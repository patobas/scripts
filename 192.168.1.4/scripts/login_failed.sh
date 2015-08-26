#!/bin/bash
fecha=`date +"%Y-%m-%d"`
dia=`date +"%a"`
hora=`date +"%R"`
host=`hostname`
log=/opt/zimbra/log/mailbox.log
mailto=root@renatea.gob.ar

cant1=`cat /opt/zimbra/log/mailbox.log | grep 'account not found' | awk {'print $13'} | sort | uniq | wc -l`
cat /opt/zimbra/log/mailbox.log | grep 'account not found' | awk {'print $13'} | sort | uniq | mutt -s "Zimbra - Intentos de cuentas desconocidas: $cant1" $mailto

cant2=`cat /opt/zimbra/log/mailbox.log | grep 'invalid password' | awk {'print $13'} | sort | uniq | wc -l`
cat /opt/zimbra/log/mailbox.log | grep 'invalid password' | awk {'print $13'} | sort | uniq | mutt -s "Zimbra - Intentos fallidos: $cant2" $mailto

cant3=`cat /var/log/mail.log | grep 'Relay access denied' | wc -l`
cat /var/log/mail.log | grep 'Relay access denied' | mutt -s "Zimbra - Intentos de Relay: $cant3" $mailto
