#!/bin/bash
rsync -e ssh -azvv --delete /opt/images/* --exclude=/opt/images/cupones /qnap/
rsync -e ssh -azvv --delete /opt/images/disco_2/* --exclude=/opt/images/cupones /qnap/disco_2/
/opt/images/disco_2
