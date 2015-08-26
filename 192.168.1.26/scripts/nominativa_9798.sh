#!/bin/bash
echo "Dump tabla nominativa_9798"
pg_dump -Z 7 -h 192.168.1.2 -U postgres -p 5432 dbafip -t nominativa_9798 > /home/pato/nominativa_9798.sql.gz -i
echo "Termino dump"
echo "Copiamos nominativa_9798"
scp /home/pato/nominativa_9798.sql.gz pato@192.168.1.19:/media/storage/
echo "Termino de copiar nominativa_9798"
