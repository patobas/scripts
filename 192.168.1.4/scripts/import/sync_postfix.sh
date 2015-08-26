#!/bin/bash
# zsync_ad.sh is a script thant syncs AD users and Zimbra users
lock=/tmp/zsy.lock
mailto=root@renatea.gob.ar

if test -f $lock
then
	printf '%b\n' '\033[31mzsync is running!!!\033[39m'
else
        echo "1" > $lock

LDAPSEARCH=/opt/zimbra/bin/ldapsearch
ZMPROV=/opt/zimbra/bin/zmprov
DOMAIN_NAME="renatea.gob.ar"
TIMESTAMP=`date +%N`
TMP_DIR=/tmp
ADS_TMP=$TMP_DIR/users_ads_$TIMESTAMP.lst
ZCS_TMP=$TMP_DIR/users_zcs_$TIMESTAMP.lst
DIF_TMP=$TMP_DIR/users_dif_$TIMESTAMP.lst

# Server values
LDAP_SERVER="192.168.1.11"
#PORT="389"
#DOMAIN="renatea.gob.ar"
BASEDN="dc=renatea,dc=gob,dc=ar"
BINDDN="zimbra"
BINDPW="R3n4T34_588"
#FILTER="(&(sAMAccountName=*)(objectClass=user)(givenName=*))"
FILTER="(&(sAMAccountName=*)(objectClass=user)(givenName=*))"
FIELDS="mail CN"

#/opt/zimbra/bin/ldapsearch -x -h 192.168.1.11 -b dc=renatea,dc=gob,dc=ar -D zimbra -w R3n4T34_588 "(GivenName=*)" "CN"  "mail"

# Extract users from ADS
echo -n "AD... "
$LDAPSEARCH -x -h $LDAP_SERVER -b $BASEDN -D "$BINDDN" -w $BINDPW "$FILTER" $FIELDS | \
grep "@$DOMAIN_NAME" | \
awk '{print $2}' | \
sort > $ADS_TMP
echo "`cat $ADS_TMP | wc -l` users ($ADS_TMP)"

# Extract users from ZCS
echo -n "ZCS... "
$ZMPROV -l gaa $DOMAIN_NAME > $ZCS_TMP
echo "`cat $ZCS_TMP | wc -l` users ($ZCS_TMP)"

# Generate diff
echo "Creando archivo diferencial ($DIF_TMP)"
#diff -u $ZCS_TMP $ADS_TMP | grep "$DOMAIN_NAME" > $DIF_TMP
comm -23 <(sort $ADS_TMP) <(sort $ZCS_TMP) | grep "$DOMAIN_NAME" > $DIF_TMP

# Clean up users list
# rm -f $ADS_TMP $ZCS_TMP

# Import new users
#| grep ^+ | sed s/^+//g);
echo -n "Nuevos usuarios: "
echo ""
#cat $DIF_TMP | grep ^+ | wc -l
cat $DIF_TMP
for i in $(cat $DIF_TMP);
do
echo -n " - Creando $i ";
searchValues=`$LDAPSEARCH -x -h $LDAP_SERVER -b $BASEDN -D $BINDDN -w $BINDPW -LLL "(mail=$i)" cn`
Username=`echo $searchValues | grep -w cn: | awk '{split ($0, a, "cn:"); print a[2]}' | awk '{print $1" "$2}'` # get the username
nombre=`echo $searchValues | grep -w cn: | awk '{split ($0, a, "cn:"); print a[2]}' | awk '{print $1}'`
apellido=`echo $searchValues | grep -w cn: | awk '{split ($0, a, "cn:"); print a[2]}' | awk '{print $2}'`

#createAccount andy@renatea.gob.ar test321 displayName 'Andy Anderson' givenName Andy sn Anderson

$ZMPROV createAccount $i passwd displayName "$Username" givenName $nombre sn $apellido > /dev/null;
$ZMPROV adlm todos@renatea.gob.ar $i
mutt -s "Zimbra - Mail account [$i] creada" $mailto < $DIF_TMP
RES=$?
if [ "$RES" == "0" ]; then echo "[Ok]"; else echo "[Err]"; fi
done

# Delete old users
# echo -n "Old users: "
# cat $DIF_TMP | grep ^- | wc -l
# for i in $(cat $DIF_TMP | grep ^- | sed s/^-//g);
# do
# echo -n " - Deleting $i ";
# $ZMPROV deleteAccount $i > /dev/null;
# RES=$?
# if [ "$RES" == "0" ]; then echo "[Ok]"; else echo "[Err]"; fi
# done


# Clean up diff list
# rm -f $DIF_TMP

rm -f $lock
fi

