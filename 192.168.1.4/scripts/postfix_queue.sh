mailq | tail +2 | grep -v '^ *(' | awk  'BEGIN { RS = "" } # $7=sender, $8=recipient1, $9=recipient2 { if ($8 == "ofu1991@gmail.com" && $9 == "") print $1 } ' | tr -d '*!' | postsuper -d -

