#!/bin/bash
# por Patricio Basalo
mailto1=root@renatea.gob.ar
mailto2=desarrollo@renatea.gob.ar
mailto3=mesadeayuda@renatea.gob.ar
mailto4=soporte@renatea.gob.ar
log_rn=/var/log/www.renatea.gob.ar.log
log_emp=/var/log/www.empleadores.renatea.gob.ar.log
log_cup=/var/log/cupones.renatea.gob.ar.log
log_webm=/var/log/webmail.renatea.gob.ar.log
log_nag=/var/log/nagios.renatea.gob.ar.log
attach=/tmp/site.log

#####################################################################################################################
#####################################################################################################################

        wget -q http://isup.me/www.renatea.gob.ar -O check_site --timeout=50
check=`cat check_site | grep 'just you' | grep not | wc -l`
recov_www=`cat $log_rn | grep www.renatea.gob.ar | tail -1 | grep DOWN | awk {'print $1'} | wc -l`

	#Si check=1 quiere decir que está caído
        if [ "$check" = "1" ] ;  then
                printf '%b\n' '\033[31mwww.renatea.gob.ar FAILED!!!\033[39m'
				if [ "$recov_www" = "1" ] ; then
				exit
				else
				sleep 1
				fi
                echo "DOWN www.renatea.gob.ar `date +"%R"`" >> $log_rn
		echo `cat $log_rn | grep www.renatea.gob.ar | grep DOWN | tail -1` > $attach
		mutt -s "www.renatea.gob.ar is DOWN! [Gate]" -c $mailto1 -c $mailto2 -c $mailto3 -c $mailto4 < $attach
        else
                echo "UP www.renatea.gob.ar `date +"%R"`" >> $log_rn
                printf '%b\n' '\033[32mwww.renatea.gob.ar			OK!\033[39m'
				#Si recov=1 estaba caído y manda mail con UP
				if [ "$recov_www" = "1" ] ; then
				printf '%b\n' '\033[32mwww.renatea.gob.ar               RECOVERED!\033[39m'
				echo `cat $log_rn | grep www.renatea.gob.ar | grep DOWN | tail -1` > $attach
				echo `cat $log_rn | grep www.renatea.gob.ar | grep UP | tail -1` >> $attach
				mutt -s "www.renatea.gob.ar is UP! [Gate]" -c $mailto1 -c $mailto2 -c $mailto3 -c $mailto4  < $attach
				cat /dev/null > $attach
				else
				sleep 1
				fi
        fi
rm -rf check_site

#####################################################################################################################
#####################################################################################################################

        wget -q http://isup.me/www.empleadores.renatea.gob.ar -O check_site --timeout=50
check=`cat check_site | grep 'just you' | grep not | wc -l`
recov_emp=`cat $log_emp | grep www.empleadores.renatea.gob.ar | tail -1 | grep DOWN | awk {'print $1'} | wc -l`

        #Si check=1 quiere decir que está caído
        if [ "$check" = "1" ] ;  then
                printf '%b\n' '\033[31mwww.empleadores.renatea.gob.ar FAILED!!!\033[39m'
                                if [ "$recov_emp" = "1" ] ; then
                                exit
                                else
                                sleep 1
                                fi
                echo "DOWN www.empleadores.renatea.gob.ar `date +"%R"`" >> $log_emp
                echo `cat $log_emp | grep www.empleadores.renatea.gob.ar | grep DOWN | tail -1` > $attach
                mutt -s "www.empleadores.renatea.gob.ar is DOWN! [Gate]" -c $mailto1 -c $mailto2 -c $mailto3 -c $mailto4  < $attach
        else
                echo "UP www.empleadores.renatea.gob.ar `date +"%R"`" >> $log_emp
                printf '%b\n' '\033[32mwww.empleadores.renatea.gob.ar		OK!\033[39m'
                                #Si recov=1 estaba caído y manda mail con UP
                                if [ "$recov_emp" = "1" ] ; then
                                printf '%b\n' '\033[32mwww.empleadores.renatea.gob.ar               RECOVERED!\033[39m'
                                echo `cat $log_emp | grep www.empleadores.renatea.gob.ar | grep DOWN | tail -1` > $attach
                                echo `cat $log_emp | grep www.empleadores.renatea.gob.ar | grep UP | tail -1` >> $attach
                                mutt -s "www.empleadores.renatea.gob.ar is UP! [Gate]" -c $mailto1 -c $mailto2 -c $mailto3 -c $mailto4  < $attach
                                cat /dev/null > $attach
                                else
                                sleep 1
                                fi
        fi
rm -rf check_site

#####################################################################################################################
#####################################################################################################################

        wget -q http://isup.me/cupones.renatea.gob.ar -O check_site --timeout=50
check=`cat check_site | grep 'just you' | grep not | wc -l`
recov_cup=`cat $log_cup | grep cupones.renatea.gob.ar | tail -1 | grep DOWN | awk {'print $1'} | wc -l`

        #Si check=1 quiere decir que está caído
        if [ "$check" = "1" ] ;  then
                printf '%b\n' '\033[31mcupones.renatea.gob.ar FAILED!!!\033[39m'
                                if [ "$recov_cup" = "1" ] ; then
                                exit
                                else
                                sleep 1
                                fi
                echo "DOWN cupones.renatea.gob.ar `date +"%R"`" >> $log_cup
                echo `cat $log_cup | grep cupones.renatea.gob.ar | grep DOWN | tail -1` > $attach
                mutt -s "cupones.renatea.gob.ar is DOWN! [Gate]" -c $mailto1 -c $mailto2 -c $mailto3 -c $mailto4  < $attach
        else
                echo "UP cupones.renatea.gob.ar `date +"%R"`" >> $log_cup
                printf '%b\n' '\033[32mcupones.renatea.gob.ar			OK!\033[39m'
                                #Si recov=1 estaba caído y manda mail con UP
                                if [ "$recov_cup" = "1" ] ; then
                                printf '%b\n' '\033[32mcupones.renatea.gob.ar               RECOVERED!\033[39m'
                                echo `cat $log_cup | grep cupones.renatea.gob.ar | grep DOWN | tail -1` > $attach
                                echo `cat $log_cup | grep cupones.renatea.gob.ar | grep UP | tail -1` >> $attach
                                mutt -s "cupones.renatea.gob.ar is UP! [Gate]" -c $mailto1 -c $mailto2 -c $mailto3 -c $mailto4  < $attach
                                cat /dev/null > $attach
                                else
                                sleep 1
                                fi
        fi
rm -rf check_site

#####################################################################################################################
#####################################################################################################################

        wget -q http://isup.me/webmail.renatea.gob.ar -O check_site --timeout=50
check=`cat check_site | grep 'just you' | grep not | wc -l`
recov_webm=`cat $log_webm | grep webmail.renatea.gob.ar | tail -1 | grep DOWN | awk {'print $1'} | wc -l`

        #Si check=1 quiere decir que está caído
        if [ "$check" = "1" ] ;  then
                printf '%b\n' '\033[31mwebmail.renatea.gob.ar FAILED!!!\033[39m'
                                if [ "$recov_webm" = "1" ] ; then
                                exit
                                else
                                sleep 1
                                fi
                echo "DOWN webmail.renatea.gob.ar `date +"%R"`" >> $log_webm
                echo `cat $log_webm | grep webmail.renatea.gob.ar | grep DOWN | tail -1` > $attach
                mutt -s "webmail.renatea.gob.ar is DOWN! [Gate]" -c $mailto1 -c $mailto2 -c $mailto3 -c $mailto4  < $attach
        else
                echo "UP webmail.renatea.gob.ar `date +"%R"`" >> $log_webm
                printf '%b\n' '\033[32mwebmail.renatea.gob.ar			OK!\033[39m'
                                #Si recov=1 estaba caído y manda mail con UP
                                if [ "$recov_webm" = "1" ] ; then
                                printf '%b\n' '\033[32mwebmail.renatea.gob.ar               RECOVERED!\033[39m'
                                echo `cat $log_webm | grep webmail.renatea.gob.ar | grep DOWN | tail -1` > $attach
                                echo `cat $log_webm | grep webmail.renatea.gob.ar | grep UP | tail -1` >> $attach
                                mutt -s "webmail.renatea.gob.ar is UP! [Gate]" -c $mailto1 -c $mailto2 -c $mailto3 -c $mailto4  < $attach
                                cat /dev/null > $attach
                                else
                                sleep 1
                                fi
        fi
rm -rf check_site

#####################################################################################################################
#####################################################################################################################

#        wget -q http://isup.me/nagios.renatea.gob.ar/nagios -O check_site --timeout=50
#check=`cat check_site | grep 'just you' | grep not | wc -l`
#recov_nag=`cat $log_nag | grep nagios.renatea.gob.ar | tail -1 | grep DOWN | awk {'print $1'} | wc -l`

#        #Si check=1 quiere decir que está caído
#        if [ "$check" = "1" ] ;  then
#                printf '%b\n' '\033[31mnagios.renatea.gob.ar FAILED!!!\033[39m'
#                                if [ "$recov_nag" = "1" ] ; then
#                                exit
#                                else
#                                sleep 1
#                                fi
#                echo "DOWN nagios.renatea.gob.ar `date +"%R"`" >> $log_nag
#                echo `cat $log_nag | grep nagios.renatea.gob.ar | grep DOWN | tail -1` > $attach
#                mutt -s "nagios.renatea.gob.ar is DOWN! [Gate]" -c $mailto1 -c $mailto2 -c $mailto3 -c $mailto4  < $attach
#        else
#                echo "UP nagios.renatea.gob.ar `date +"%R"`" >> $log_nag
#                printf '%b\n' '\033[32mnagios.renatea.gob.ar			OK!\033[39m'
#                                #Si recov=1 estaba caído y manda mail con UP
#                                if [ "$recov_nag" = "1" ] ; then
#                                printf '%b\n' '\033[32mnagios.renatea.gob.ar               RECOVERED!\033[39m'
#                                echo `cat $log_nag | grep nagios.renatea.gob.ar | grep DOWN | tail -1` > $attach
#                                echo `cat $log_nag | grep nagios.renatea.gob.ar | grep UP | tail -1` >> $attach
#                                mutt -s "nagios.renatea.gob.ar is UP! [Gate]" -c $mailto1 -c $mailto2 -c $mailto3 -c $mailto4  < $attach
#                                cat /dev/null > $attach
#                                else
#                                sleep 1
#                                fi
#        fi
rm -rf check_site

#####################################################################################################################
#####################################################################################################################

