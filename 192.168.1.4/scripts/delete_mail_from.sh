postqueue -p | tail -n +2 | awk 'BEGIN { RS = "" } /zimbra@mailserver\.renatea\.gob\.ar/ { print $1 }' | tr -d '*!' | postsuper -d -
