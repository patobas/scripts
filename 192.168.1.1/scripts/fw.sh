#!/bin/bash
BLOCKDB="block.txt"
WORKDIR="/tmp"
pwd=$(pwd)
cd $WORKDIR
#List of ips to block
ipset --create blackips iphash
## Obtain List of badguys from openbl.org
wget -q -c --output-document=$BLOCKDB http://www.openbl.org/lists/base.txt
if [ -f $BLOCKDB ]; then
    IPList=$(grep -Ev "^#" $BLOCKDB | sort -u)
    for i in $IPList
    do
        ipset --add blackips $i
    done
fi
rm $BLOCKDB
## Obtain List of badguys from ciarmy.com
wget -q -c --output-document=$BLOCKDB http://www.ciarmy.com/list/ci-badguys.txt
if [ -f $BLOCKDB ]; then
    IPList=$(grep -Ev "^#" $BLOCKDB | sort -u)
    for i in $IPList
    do
        ipset --add blackips $i
    done
fi
rm $BLOCKDB
## Obtain List of badguys from dshield.org
wget -q -c --output-document=$BLOCKDB http://feeds.dshield.org/top10-2.txt
if [ -f $BLOCKDB ]; then
    IPList=$(grep -E "^[1-9]" $BLOCKDB | cut -f1 | sort -u)
    for i in $IPList
    do
        ipset --add blackips $i
    done
fi
rm $BLOCKDB
#List of networks to block
ipset --create blacknets nethash
## Obtain List of badguys from dshield.org
wget -q -c --output-document=$BLOCKDB http://feeds.dshield.org/block.txt
if [ -f $BLOCKDB ]; then
    IPList=$(grep -E "^[1-9]" $BLOCKDB | cut -f1,3 | sed "s/\t/\//g" | sort -u)
    for i in $IPList
    do
        ipset --add blacknets $i
    done
fi
rm $BLOCKDB
## Obtain List of badguys from spamhaus.org
    wget -q -c --output-document=$BLOCKDB http://www.spamhaus.org/drop/drop.lasso
    if [ -f $BLOCKDB ]; then
      IPList=$(grep -E "^[1-9]" $BLOCKDB | cut -d" " -f1 | sort -u)
      for i in $IPList
      do
        ipset --add blacknets $i
      done
    fi
    rm $BLOCKDB
#Drop blacklisted ips
iptables -A FORWARD -m set --match-set blackips src -j DROP
iptables -A FORWARD -m set --match-set blacknets src -j DROP
cd $pwd
