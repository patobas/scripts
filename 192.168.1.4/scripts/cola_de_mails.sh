#!/bin/bash
cd /var/spool/postfix/

mailq | grep libreta
mailq | grep libreta | awk {'print $1'}



vim 386CC11B213
 2015  mailq | grep 386CC11B213
 2016  find -name 386CC11B213
 2017  rm -rf maildrop/386CC11B213 
 2018  mailq



