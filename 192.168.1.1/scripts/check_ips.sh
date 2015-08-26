#!/bin/sh
#script to monitor Suricata activity for the past hour to alert on inactivity
#Inactivity could be due to a connection having been removed or some process failing
MAILTO=root@renatea.gob.ar
DATE=`date`
SUBJECT="`hostname` Suricata inactivity alert `date`"
LIMIT=5
REPORT=/tmp/so-lasthour.txt

echo $SUBJECT > /tmp/edgerouter.log

if test ` mysql -N -B --user root --database snorby -e
"SELECT COUNT(signature)as cnt, signature FROM event WHERE status<>1
and timestamp>=date_sub(now(), interval 3 hour) GROUP BY signature
ORDER BY cnt DESC LIMIT 20;" | grep -c .` -le $LIMIT
  then
     echo "Too few events"

     echo "non-URL signatures" > $REPORT
     mysql -N -B --user root --database securityonion_db -e "SELECT
COUNT(signature)as cnt, signature FROM event WHERE status<>1 and
timestamp>=date_sub(now(), interval 3 hour) GROUP BY signature ORDER
BY cnt DESC LIMIT 20;" >> $REPORT
     echo "" >> $REPORT
     echo "URL signatures" >> $REPORT
     mysql -N -B --user root --database securityonion_db -e "SELECT
COUNT(signature)as cnt, signature FROM event WHERE status=1 and
timestamp>=date_sub(now(), interval 3 hour) GROUP BY signature ORDER
BY cnt DESC LIMIT 20;" >> $REPORT
     cat $REPORT | mail -s "$SUBJECT" $MAILTO

  else
     echo "Acceptible number of events"
  fi
