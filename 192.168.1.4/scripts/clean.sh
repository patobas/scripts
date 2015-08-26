#!/bin/bash
mailq|grep -i $1 |awk '{print $1}'|sed -e s/\*//g > clean
for i in 'cat clean'; do postsuper -d $i; done


