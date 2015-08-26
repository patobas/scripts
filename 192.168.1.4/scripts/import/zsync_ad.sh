#!/bin/bash
# zsync_ad.sh is a script thant syncs AD users and Zimbra users
lock=/tmp/zsy.lock
mailto1=root@renatea.gob.ar
mailto2=mesadeayuda@renatea.gob.ar
RUTA="/opt/zimbra/bin"


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
############################### todos@ ##################################
$ZMPROV adlm todos@renatea.gob.ar $i
$ZMPROV sp $i R3n4t34#2000
$ZMPROV ma $i zimbraPasswordMustChange TRUE

mutt -s "Zimbra - Mail account [$i] creada" $mailto1 -c $mailto2 < $DIF_TMP
RES=$?
if [ "$RES" == "0" ]; then echo "[Ok]"; else echo "[Err]"; fi
done
############################### SIGNATURE ##################################
# Obtain signature from LDAP user atributes
signature=`$RUTA/zmprov ga $i | egrep "(^cn|^ou|^company|^street|^telephoneNumber)" | cut -d : -f 2 | sed 's/^\ //g'`
signn=`$RUTA/zmprov ga $i | egrep "(^cn)" | cut -d : -f 2 | sed 's/^\ //g'`
$RUTA/zmprov csig $i Renatea zimbraPrefMailSignatureHTML "<html><head></head><body>$signn<p><img src='http://www.renatea.gob.ar/resources/img/firman.png' /></body></html>"
echo "done!"



####$ZCS_TMP
/opt/zimbra/bin/zmprov -l gaa renatea.gob.ar | grep -v ^antivirus@ | grep -v ^llukaszyk@ | grep -v ^dcipolat@ | grep -v ^dsegovia@ | grep -v ^fail2ban@ | grep -v ^ham@ | grep -v ^root@ | grep -v ^spam@ | grep -v ^aperezlindo@ | grep -v ^dcipolat@ | sort > /tmp/1
/opt/zimbra/bin/zmprov gdl todos@renatea.gob.ar | grep zimbraMailForwardingAddress: | awk {'print $2'} |  sort > /tmp/2
diff /tmp/1 /tmp/2 | grep @ | awk {'print $2'} > /tmp/3
diff=`cat /tmp/3 | wc -l`

if test $diff -gt "0" ; then
        printf '%b\n''\033[31mHay '$diff' accounts que no están en todos@renatea.gob.ar!\033[39m' 
	mutt -s "$diff accounts no están en todos@" $mailto1 < /tmp/3
	echo ""
else
        printf '%b\n' '\033[32mTodos los usuarios estan en todos@renatea.gob.ar\033[39m'
	echo ""
fi

for i in $(cat /tmp/3);
do
echo -n " - $i ";
$ZMPROV adlm todos@renatea.gob.ar $i
mutt -s "Zimbra Account en todos@ [$i]" $mailto1 < /tmp/3
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




