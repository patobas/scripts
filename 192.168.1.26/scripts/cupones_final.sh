#!/bin/sh
psql -h 192.168.1.19 -U postgres -c "update cupones_modif set procesado=1 where procesado=0;" cupones
psql -h 192.168.1.2 -U postgres -f /root/scripts/cupones_allnew.sql dbafip
psql -h 192.168.1.2 -U postgres -f /root/scripts/cupones_act.sql dbafip
psql -h 192.168.1.19 -U postgres -c "update cupones_modif set procesado=2 where procesado=1;" cupones


