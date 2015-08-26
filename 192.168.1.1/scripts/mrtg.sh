#!/bin/bash
indexmaker /etc/mrtg.cfg > /var/data/mrtg/index.html 
if [ ! -d /var/lock/mrtg ]; then mkdir /var/lock/mrtg; fi; if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
