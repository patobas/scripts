#!/bin/bash
uptime=`uptime | awk '{print $3}'`" dias, "`uptime | awk '{print $5}'`" horas"
label='fail2ban'
#fail2ban-client status apache | awk '/Total failed:/{print $5}'
#fail2ban-client status ssh | awk '/Total failed:/{print $5}'
fail2ban-client status postfix | grep " Currently banned:" | sed 's/   |- Currently banned:\t//g'
fail2ban-client status ssh | grep " Currently banned:" | sed 's/   |- Currently banned:\t//g'
echo `uptime`
echo `hostname`

