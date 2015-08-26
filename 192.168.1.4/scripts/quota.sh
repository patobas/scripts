#!/bin/bash
#zmprov=`/opt/zimbra/bin/zmprov`
echo "Username         Total Quota         Usage"
zmprov -l gaa | while read ACCOUNT
do
QUOTA_TOTAL=`zmprov ga ${ACCOUNT} | grep "zimbraMailQuota" | cut -d ":" -f2`
QUOTA_USAGE=`zmmailbox -z -m ${ACCOUNT} gms`
echo "${ACCOUNT}    ${QUOTA_TOTAL}    ${QUOTA_USAGE}"
done
