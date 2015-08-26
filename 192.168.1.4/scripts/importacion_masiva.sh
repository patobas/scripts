#!/bin/bash
# zsync_ad.sh is a script thant syncs AD users and Zimbra users
mails=/root/scripts/new_mails
name=/root/scripts/new_name
surname=/root/scripts/new_surname
accounts=/root/scripts/accounts
lock=/tmp/imp_mas.lock
lock_log=/tmp/zsy.lock.log

if test -f $lock
then
	printf '%b\n' '\033[31mimportacion_masiva is running!!!\033[39m'
	exit
else
        echo "1" > $lock

ZMPROV=/opt/zimbra/bin/zmprov
DOMAIN_NAME="renatea.gob.ar"
TIMESTAMP=`date +%N`

echo -n "Quering ZCS... "
echo "Found `cat $mails | wc -l` users "

#echo -n "New users: "
for i in $(cat $mails | awk {'print $1'});

do
echo -n " - Adding $i ";
searchValues=`cat $accounts | awk {'print $1'}`
Username=`cat $accounts | awk '{print $2" "$3}'`
nombre=`cat $accounts | awk '{print $2}'`
apellido=`cat $accounts | awk '{print $3}'`

#Username=`echo $searchValues | grep -w cn: | awk '{split ($0, a, "cn:"); print a[2]}' | awk '{print $1" "$2}'` # get the username
#nombre=`echo $searchValues | grep -w cn: | awk '{split ($0, a, "cn:"); print a[2]}' | awk '{print $1}'`
#apellido=`echo $searchValues | grep -w cn: | awk '{split ($0, a, "cn:"); print a[2]}' | awk '{print $2}'`

#exec 3< /root/scripts/new_mails
#exec 4< /root/scripts/new_name
#exec 5< /root/scripts/new_surname

# Read user and password
#while read mail <&3 && read name <&4 && read surname <&5 ; do
    # Just print this for debugging
#    printf "\tCreating user: %s \n" $mail
    # Create the user with adduser (you can add whichever option you like)
#$ZMPROV createAccount $mail passwd displayName "$name $surname" givenName $name sn $surname > /dev/null; done
    # Assign the password to the user, passwd must read it from stdin
#    echo $ipasswd | passwd --stdin $iuser

#createAccount andy@renatea.gob.ar test321 displayName 'Andy Anderson' givenName Andy sn Anderson
for i in $(cat $accounts); do $ZMPROV createAccount $searchValues passwd displayName "$Username" givenName $nombre sn $apellido > /dev/null; done
RES=$?
if [ "$RES" == "0" ]; then echo "[Ok]"; else echo "[Err]"; fi
done

fi

rm -f $lock
