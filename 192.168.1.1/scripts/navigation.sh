#!/bin/bash
mailto1=pbasalo@renatea.gob.ar
mailto2=mmendiguren@renatea.gob.ar
mailto3=jrossotti@renatea.gob.ar
log1=/tmp/navigation.log
log2=/tmp/navigation_mail.log

cat /var/data/squid3/log/access.log | grep 192.168.1.65 | awk {'print $7'} | sort | uniq > $log1
sed -i 's/.com.ar/.com.ar /' $log1
sed -i 's/.com/.com /' $log1
sed -i 's/.net/.net /' $log1
sed -i 's/yuq.me/yuq.me /' $log1
sed -i 's/la-nacion.fyre.co/la-nacion.fyre.co /' $log1
sed -i 's/avatars.fyre.co/avatars.fyre.co /' $log1
sed -i 's/.org/.org /' $log1
sed -i 's/.gob.ar/.gob.ar /' $log1
sed -i 's/.gov.ar/.gov.ar /' $log1

cat $log1 | awk {'print $1'} | grep -v doubleclick | grep -v tumblr.com | grep -v analytics | grep -v adsystem | grep -v mgid | grep -v groovinads.com | grep -v e-planning.net | grep -v exoclick.com | grep -v ookla.com | grep -v pubmatic.com | grep -v rubiconproject.com | grep -v servebom.com | grep -v turn.com | grep -v chango.com | grep -v yieldmanager.com | grep -v mxptint.net | grep -v nspmotion.com | grep -v ads.yahoo.com | grep -v ajax.googleapis.com | grep -v ar.archive.ubuntu.com | grep -v beacon-1.newrelic.com | grep -v b.scorecardresearch.com | grep -v bs.serving-sys.com | grep -v c1.tentaculos.net | grep -v c.bing.com | grep -v cdn.cxense.com | grep -v cdn.thinglink.me/jse/embed.js | grep -v clients1.google.com | grep -v cm.adgrx.com | grep -v connect.facebook.net | grep -v downloads.source.org | grep -v dps.bing.com | grep -v ds.serving-sys.com | grep -v extras.ubuntu.com | grep -v fonts.googleapis.com | grep -v gmtdmp.mookie1.com | grep -v goog.applovin.com | grep -v graph.facebook.com | grep -v ib.adnxs.com | grep -v nym1.ib.adnxs.com | grep -v ocsp.digicert.com | grep -v odb.outbrain.com | grep -v o.tentaculos.net | grep -v pagead2.googlesyndication.com | grep -v ping.chartbeat.net | grep -v pix04.revsci.net | grep -v pixel.ad.mlnadvertising.com | grep -v pixel.mathtag.com | grep -v platform.twitter.com | grep -v ppa.launchpad.net | grep -v rs.gwallet.com | grep -v s0.2mdn.net | grep -v s1.2mdn.net | grep -v security.ubuntu.com | grep -v static.chartbeat.com | grep -v t1.tentaculos.net | grep -v t2.gstatic.com | grep -v tags.mathtag.com | grep -v tn-ar.cdncmd.com | grep -v tn.com | grep -v ufpr.dl.source.org | grep -v vassg141.ocsp.omniroot.com | grep -v widgets.outbrain.com | grep -v www.gstatic.com | sort | uniq > $log2
mutt -s "Reporte `date -R | awk {'print $2"-"$3"-"$4'}`" $mailto1 -c $mailto2 -c $mailto3 < $log2
