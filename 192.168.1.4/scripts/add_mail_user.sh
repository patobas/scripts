#!/bin/bash
# Script to add a user to postfix mail server system
        read -p "Enter mailaccount : " username
SELECT=`mysql -u root -pmfatggs mail -e'select * from users where email="'$username'@renatea.gob.ar"'`
        if test $SELECT="0" ; then
		mysql -u root -pmfatggs mail -e'insert into users values ("'$username'@renatea.gob.ar","$1$3612e318$72z9wXq3RAozsEkT4Rnvf1","1500000000","NULL",1,1,2013)'
		mail -s "" $username@renatea.gob.ar 
		sleep 1
                [ $? -eq 0 ] || echo "Failed to add account!"
        exit 2
fi

