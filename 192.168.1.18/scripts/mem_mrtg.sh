#!/bin/sh

#Gets system memory usage

#Active memory, free memory

stats=`vmstat | tail -1`

 

set $stats ; echo $6 ; echo $4

 

echo `uptime`

echo `hostname`
