#!/bin/bash

function zeropadd { if [ "$1" -lt 10 ]; then { echo "0$1"; } else { echo "$1"; } fi; }

for raw_month in `seq 1 12`; do
month=`zeropadd $raw_month`
echo "Month $month"

for raw_day in `seq 1 31`; do
day=`zeropadd $raw_day`

for raw_idx in `seq 1 10`; do
idx=`zeropadd $raw_idx`
echo "2004-$month-$day $idx"

# rm /var/lib/amavis/virusmails/spam-*-2004$month$day-*-$idx.gz
rm /var/lib/amavis/virusmails/virus-2004$month$day-*-$idx
done
done
done
