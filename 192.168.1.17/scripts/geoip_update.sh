#!/bin/bash
wget -q http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz -O - |gunzip > /usr/share/GeoIP/GeoCity.dat.new && mv /usr/share/GeoIP/GeoCity.dat.new /usr/share/GeoIP/GeoCity.dat
wget -q http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz -O - |gunzip > /usr/share/GeoIP/GeoIP.dat.new && mv /usr/share/GeoIP/GeoIP.dat.new /usr/share/GeoIP/GeoIP.dat
