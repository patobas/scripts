#!/bin/bash
lockfile="/tmp/webalizer.lock"
# bail out if lock file still exists
if [ -f $lockfile ]; then
        echo "Lock file exists! Webalizer may still be crunching numbers!"
        exit 1
else
        # write the lock file
        date +"%d.%m.%Y - %H:%M" > $lockfile
        echo -e "-------------------------------------"
        echo "[`date +"%d.%m.%Y - %H:%M"`] Generating stats..."
        echo -e "-------------------------------------\n"
        # go trough config files and generate stats
        for i in /etc/webalizer/*.conf; do webalizer -c $i; done
        echo -e "\n-------------------------------------"
        echo "[`date +"%d.%m.%Y - %H:%M"`] Finished"
        echo -e "-------------------------------------\n"
        # delete the lock file
        rm -rf $lockfile
fi
exit 0
