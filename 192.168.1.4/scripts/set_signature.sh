#!/bin/bash
  
  RUTA="/opt/zimbra/bin"
  
  # Check for run as zimbra user
  ID=`id -u -n`
  if [ x$ID != "xzimbra" ]; then
     echo "Please run as ZIMBRA user"
     echo "Exiting..."
     exit 1
  fi
  
  
  # Obtain all accounts
  accounts=`$RUTA/zmprov -l gaa`
  
  for ac in $accounts; do
     echo -ne "Checking account: $ac \t"
  
     # Verify for set signature
     #sign=`$RUTA/zmprov -l ga $ac | grep zimbraPrefMailSignatureEnabled | cut -d : -f 2`
     sign=`$RUTA/zmprov -l ga $ac | grep SignatureName | cut -d : -f 2`
	 #zmprov -l ga pbasalo | grep SignatureName
  
     if [ `echo $sign | grep Renatea` ]; then
        echo "This account have a Signature. Nothing to do."
     else
        echo -ne "Setting signature... "
  
        # Obtain signature from LDAP user atributes
        signature=`$RUTA/zmprov ga $ac | egrep "(^cn|^ou|^company|^street|^telephoneNumber)" | cut -d : -f 2 | sed 's/^\ //g'`
		signn=`$RUTA/zmprov ga $ac | egrep "(^cn)" | cut -d : -f 2 | sed 's/^\ //g'`
  
        # Set signature for account $ca
#        $RUTA/zmprov ma $ac zimbraPrefMailSignatureEnabled TRUE  zimbraPrefMailSignatureStyle internet zimbraPrefMailSignature "$signature"
  
		$RUTA/zmprov csig $ac Renatea zimbraPrefMailSignatureHTML "<html><head></head><body>$signn<p><img src='http://www.renatea.gob.ar/resources/img/firman.png' /></body></html>"
        echo "done!"
     fi
  
  done
